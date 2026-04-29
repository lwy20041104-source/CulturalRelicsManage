<template>
  <div class="relic-3d-viewer">
    <div ref="containerRef" class="viewer-container"></div>
    
    <!-- 控制面板 -->
    <div class="control-panel">
      <div class="control-group">
        <el-button-group>
          <el-button :icon="VideoPlay" @click="toggleAutoRotate" :type="autoRotate ? 'primary' : ''">
            {{ autoRotate ? '停止旋转' : '自动旋转' }}
          </el-button>
          <el-button :icon="Refresh" @click="resetCamera">重置视角</el-button>
          <el-button :icon="FullScreen" @click="toggleFullscreen">全屏</el-button>
        </el-button-group>
      </div>
      
      <div class="control-group">
        <span class="control-label">光照强度</span>
        <el-slider v-model="lightIntensity" :min="0" :max="3" :step="0.1" @input="updateLighting" style="width: 150px" />
      </div>
      
      <div class="control-group">
        <span class="control-label">背景颜色</span>
        <el-color-picker v-model="backgroundColor" @change="updateBackground" />
      </div>
      
      <div class="control-group">
        <span class="control-label">显示网格</span>
        <el-switch v-model="showGrid" @change="toggleGrid" />
      </div>
    </div>
    
    <!-- 加载提示 -->
    <div v-if="loading" class="loading-overlay">
      <el-icon class="is-loading" :size="50"><Loading /></el-icon>
      <p>加载3D模型中...</p>
    </div>
    
    <!-- 错误提示 -->
    <div v-if="error" class="error-overlay">
      <el-icon :size="50"><WarningFilled /></el-icon>
      <p>{{ error }}</p>
      <el-button @click="loadDefaultModel">加载默认模型</el-button>
    </div>
    
    <!-- 信息面板 -->
    <div class="info-panel" v-if="modelInfo">
      <h4>模型信息</h4>
      <p><strong>顶点数:</strong> {{ modelInfo.vertices }}</p>
      <p><strong>面数:</strong> {{ modelInfo.faces }}</p>
      <p><strong>材质:</strong> {{ modelInfo.materials }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, watch } from 'vue'
import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import { OBJLoader } from 'three/examples/jsm/loaders/OBJLoader'
import { VideoPlay, Refresh, FullScreen, Loading, WarningFilled } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'

const props = defineProps({
  modelUrl: {
    type: String,
    default: ''
  },
  modelType: {
    type: String,
    default: 'gltf', // gltf, obj, default
    validator: (value) => ['gltf', 'obj', 'default'].includes(value)
  },
  width: {
    type: Number,
    default: 800
  },
  height: {
    type: Number,
    default: 600
  }
})

const containerRef = ref(null)
const loading = ref(false)
const error = ref('')
const autoRotate = ref(true)
const lightIntensity = ref(1.5)
const backgroundColor = ref('#1a1a1a')
const showGrid = ref(true)
const modelInfo = ref(null)

let scene, camera, renderer, controls, model, gridHelper
let animationId = null

// 初始化场景
const initScene = () => {
  // 创建场景
  scene = new THREE.Scene()
  scene.background = new THREE.Color(backgroundColor.value)
  
  // 创建相机
  camera = new THREE.PerspectiveCamera(
    45,
    props.width / props.height,
    0.1,
    1000
  )
  camera.position.set(5, 5, 5)
  camera.lookAt(0, 0, 0)
  
  // 创建渲染器
  renderer = new THREE.WebGLRenderer({ antialias: true })
  renderer.setSize(props.width, props.height)
  renderer.setPixelRatio(window.devicePixelRatio)
  renderer.shadowMap.enabled = true
  renderer.shadowMap.type = THREE.PCFSoftShadowMap
  
  containerRef.value.appendChild(renderer.domElement)
  
  // 添加控制器
  controls = new OrbitControls(camera, renderer.domElement)
  controls.enableDamping = true
  controls.dampingFactor = 0.05
  controls.autoRotate = autoRotate.value
  controls.autoRotateSpeed = 2.0
  
  // 添加光照
  setupLighting()
  
  // 添加网格
  if (showGrid.value) {
    addGrid()
  }
  
  // 添加坐标轴辅助
  const axesHelper = new THREE.AxesHelper(5)
  scene.add(axesHelper)
  
  // 开始动画循环
  animate()
}

// 设置光照
const setupLighting = () => {
  // 环境光
  const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)
  scene.add(ambientLight)
  
  // 主光源
  const mainLight = new THREE.DirectionalLight(0xffffff, lightIntensity.value)
  mainLight.position.set(5, 10, 5)
  mainLight.castShadow = true
  mainLight.shadow.mapSize.width = 2048
  mainLight.shadow.mapSize.height = 2048
  scene.add(mainLight)
  
  // 补光
  const fillLight = new THREE.DirectionalLight(0xffffff, lightIntensity.value * 0.3)
  fillLight.position.set(-5, 5, -5)
  scene.add(fillLight)
  
  // 顶光
  const topLight = new THREE.DirectionalLight(0xffffff, lightIntensity.value * 0.2)
  topLight.position.set(0, 10, 0)
  scene.add(topLight)
}

// 添加网格
const addGrid = () => {
  gridHelper = new THREE.GridHelper(10, 10, 0x444444, 0x222222)
  scene.add(gridHelper)
}

// 加载默认模型（立方体）
const loadDefaultModel = () => {
  loading.value = true
  error.value = ''
  
  try {
    // 移除旧模型
    if (model) {
      scene.remove(model)
    }
    
    // 创建一个简单的立方体作为默认模型
    const geometry = new THREE.BoxGeometry(2, 2, 2)
    const material = new THREE.MeshStandardMaterial({
      color: 0x8B4513,
      metalness: 0.3,
      roughness: 0.7
    })
    model = new THREE.Mesh(geometry, material)
    model.castShadow = true
    model.receiveShadow = true
    
    scene.add(model)
    
    // 更新模型信息
    modelInfo.value = {
      vertices: geometry.attributes.position.count,
      faces: geometry.index ? geometry.index.count / 3 : geometry.attributes.position.count / 3,
      materials: 1
    }
    
    loading.value = false
    ElMessage.success('默认模型加载成功')
  } catch (err) {
    error.value = '加载默认模型失败: ' + err.message
    loading.value = false
  }
}

// 加载GLTF模型
const loadGLTFModel = (url) => {
  loading.value = true
  error.value = ''
  
  const loader = new GLTFLoader()
  loader.load(
    url,
    (gltf) => {
      if (model) {
        scene.remove(model)
      }
      
      model = gltf.scene
      model.traverse((child) => {
        if (child.isMesh) {
          child.castShadow = true
          child.receiveShadow = true
        }
      })
      
      // 居中模型
      const box = new THREE.Box3().setFromObject(model)
      const center = box.getCenter(new THREE.Vector3())
      model.position.sub(center)
      
      // 缩放模型以适应视图
      const size = box.getSize(new THREE.Vector3())
      const maxDim = Math.max(size.x, size.y, size.z)
      const scale = 3 / maxDim
      model.scale.multiplyScalar(scale)
      
      scene.add(model)
      
      // 计算模型信息
      let vertices = 0, faces = 0, materials = 0
      model.traverse((child) => {
        if (child.isMesh) {
          vertices += child.geometry.attributes.position.count
          faces += child.geometry.index ? child.geometry.index.count / 3 : child.geometry.attributes.position.count / 3
          materials++
        }
      })
      
      modelInfo.value = { vertices, faces, materials }
      loading.value = false
      ElMessage.success('3D模型加载成功')
    },
    (progress) => {
      console.log('Loading progress:', (progress.loaded / progress.total * 100) + '%')
    },
    (err) => {
      error.value = '加载GLTF模型失败: ' + err.message
      loading.value = false
      ElMessage.error('模型加载失败')
    }
  )
}

// 加载OBJ模型
const loadOBJModel = (url) => {
  loading.value = true
  error.value = ''
  
  const loader = new OBJLoader()
  loader.load(
    url,
    (obj) => {
      if (model) {
        scene.remove(model)
      }
      
      model = obj
      model.traverse((child) => {
        if (child.isMesh) {
          child.material = new THREE.MeshStandardMaterial({
            color: 0x8B4513,
            metalness: 0.3,
            roughness: 0.7
          })
          child.castShadow = true
          child.receiveShadow = true
        }
      })
      
      // 居中和缩放
      const box = new THREE.Box3().setFromObject(model)
      const center = box.getCenter(new THREE.Vector3())
      model.position.sub(center)
      
      const size = box.getSize(new THREE.Vector3())
      const maxDim = Math.max(size.x, size.y, size.z)
      const scale = 3 / maxDim
      model.scale.multiplyScalar(scale)
      
      scene.add(model)
      
      loading.value = false
      ElMessage.success('3D模型加载成功')
    },
    (progress) => {
      console.log('Loading progress:', (progress.loaded / progress.total * 100) + '%')
    },
    (err) => {
      error.value = '加载OBJ模型失败: ' + err.message
      loading.value = false
      ElMessage.error('模型加载失败')
    }
  )
}

// 动画循环
const animate = () => {
  animationId = requestAnimationFrame(animate)
  
  controls.update()
  
  renderer.render(scene, camera)
}

// 切换自动旋转
const toggleAutoRotate = () => {
  autoRotate.value = !autoRotate.value
  controls.autoRotate = autoRotate.value
}

// 重置相机
const resetCamera = () => {
  camera.position.set(5, 5, 5)
  camera.lookAt(0, 0, 0)
  controls.reset()
}

// 切换全屏
const toggleFullscreen = () => {
  if (!document.fullscreenElement) {
    containerRef.value.requestFullscreen()
  } else {
    document.exitFullscreen()
  }
}

// 更新光照
const updateLighting = () => {
  scene.children.forEach((child) => {
    if (child instanceof THREE.DirectionalLight) {
      if (child.position.y === 10 && child.position.x === 5) {
        child.intensity = lightIntensity.value
      } else if (child.position.x === -5) {
        child.intensity = lightIntensity.value * 0.3
      } else if (child.position.y === 10 && child.position.x === 0) {
        child.intensity = lightIntensity.value * 0.2
      }
    }
  })
}

// 更新背景
const updateBackground = () => {
  scene.background = new THREE.Color(backgroundColor.value)
}

// 切换网格
const toggleGrid = () => {
  if (showGrid.value) {
    if (!gridHelper) {
      addGrid()
    } else {
      scene.add(gridHelper)
    }
  } else {
    if (gridHelper) {
      scene.remove(gridHelper)
    }
  }
}

// 监听窗口大小变化
const handleResize = () => {
  const width = containerRef.value.clientWidth
  const height = containerRef.value.clientHeight
  
  camera.aspect = width / height
  camera.updateProjectionMatrix()
  
  renderer.setSize(width, height)
}

// 监听模型URL变化
watch(() => props.modelUrl, (newUrl) => {
  if (newUrl) {
    if (props.modelType === 'gltf') {
      loadGLTFModel(newUrl)
    } else if (props.modelType === 'obj') {
      loadOBJModel(newUrl)
    }
  } else {
    loadDefaultModel()
  }
})

onMounted(() => {
  initScene()
  
  // 加载模型
  if (props.modelUrl) {
    if (props.modelType === 'gltf') {
      loadGLTFModel(props.modelUrl)
    } else if (props.modelType === 'obj') {
      loadOBJModel(props.modelUrl)
    }
  } else {
    loadDefaultModel()
  }
  
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  if (animationId) {
    cancelAnimationFrame(animationId)
  }
  
  if (renderer) {
    renderer.dispose()
  }
  
  if (controls) {
    controls.dispose()
  }
  
  window.removeEventListener('resize', handleResize)
})
</script>

<style scoped>
.relic-3d-viewer {
  position: relative;
  width: 100%;
  height: 100%;
  background: #000;
  border-radius: 8px;
  overflow: hidden;
}

.viewer-container {
  width: 100%;
  height: 100%;
}

.control-panel {
  position: absolute;
  top: 20px;
  right: 20px;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(10px);
  padding: 15px;
  border-radius: 8px;
  display: flex;
  flex-direction: column;
  gap: 15px;
  z-index: 10;
}

.control-group {
  display: flex;
  align-items: center;
  gap: 10px;
}

.control-label {
  color: #fff;
  font-size: 14px;
  min-width: 80px;
}

.loading-overlay,
.error-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: rgba(0, 0, 0, 0.8);
  color: #fff;
  z-index: 20;
}

.loading-overlay p,
.error-overlay p {
  margin-top: 20px;
  font-size: 16px;
}

.info-panel {
  position: absolute;
  bottom: 20px;
  left: 20px;
  background: rgba(0, 0, 0, 0.7);
  backdrop-filter: blur(10px);
  padding: 15px;
  border-radius: 8px;
  color: #fff;
  z-index: 10;
}

.info-panel h4 {
  margin: 0 0 10px 0;
  font-size: 16px;
  font-weight: 600;
}

.info-panel p {
  margin: 5px 0;
  font-size: 14px;
}

.info-panel strong {
  color: #409eff;
}
</style>
