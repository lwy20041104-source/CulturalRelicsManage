<template>
  <div class="relic-3d-view">
    <el-card class="header-card">
      <div class="header-content">
        <div class="title-section">
          <h2>{{ relic?.relicName || '3D文物展示' }}</h2>
          <el-tag v-if="relic" type="info">{{ relic.era }}</el-tag>
        </div>
        <el-button @click="goBack">返回</el-button>
      </div>
    </el-card>

    <div class="content-layout">
      <!-- 3D查看器 -->
      <el-card class="viewer-card">
        <Relic3DViewer
          :model-url="modelUrl"
          :model-type="modelType"
          :width="viewerWidth"
          :height="viewerHeight"
        />
      </el-card>

      <!-- 文物信息面板 -->
      <el-card class="info-card" v-if="relic">
        <template #header>
          <div class="card-header">
            <span>文物信息</span>
          </div>
        </template>

        <el-descriptions :column="1" border>
          <el-descriptions-item label="文物编号">
            {{ relic.relicCode }}
          </el-descriptions-item>
          <el-descriptions-item label="文物名称">
            {{ relic.relicName }}
          </el-descriptions-item>
          <el-descriptions-item label="年代">
            {{ relic.era }}
          </el-descriptions-item>
          <el-descriptions-item label="材质">
            {{ relic.material }}
          </el-descriptions-item>
          <el-descriptions-item label="出土地点">
            {{ relic.origin }}
          </el-descriptions-item>
          <el-descriptions-item label="尺寸">
            {{ relic.dimensions }}
          </el-descriptions-item>
          <el-descriptions-item label="重量">
            {{ relic.weight }} kg
          </el-descriptions-item>
          <el-descriptions-item label="状态">
            <el-tag :type="getStatusType(relic.status)">
              {{ relic.status }}
            </el-tag>
          </el-descriptions-item>
        </el-descriptions>

        <el-divider />

        <div class="description-section">
          <h4>文物描述</h4>
          <p>{{ relic.description || '暂无描述' }}</p>
        </div>

        <el-divider />

        <div class="model-upload-section">
          <h4>3D模型管理</h4>
          
          <!-- 当前模型信息（在选项卡外显示） -->
          <div v-if="relic?.model3dUrl" class="current-model-info-top">
            <el-alert type="info" :closable="false">
              <template #title>
                <div class="model-info-content">
                  <span>当前模型：</span>
                  <el-link :href="relic.model3dUrl" target="_blank" type="primary" style="max-width: 400px; overflow: hidden; text-overflow: ellipsis;">
                    {{ relic.model3dUrl }}
                  </el-link>
                  <el-button type="danger" size="small" @click="deleteModel">
                    删除模型
                  </el-button>
                </div>
              </template>
            </el-alert>
          </div>
          
          <!-- 上传3D模型 -->
          <el-upload
            class="upload-demo"
            :action="uploadUrl"
            :headers="uploadHeaders"
            :on-success="handleUploadSuccess"
            :on-error="handleUploadError"
            :before-upload="beforeUpload"
            accept=".gltf,.glb,.obj"
            :show-file-list="false"
          >
            <el-button type="primary" :icon="Upload">选择文件上传</el-button>
          </el-upload>
          <p class="upload-tip">支持 GLTF (.gltf, .glb) 和 OBJ (.obj) 格式，文件大小不超过 50MB</p>
        </div>
      </el-card>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Upload } from '@element-plus/icons-vue'
import Relic3DViewer from '../components/Relic3DViewer.vue'
import { getRelicByIdApi } from '../api/relics'

const route = useRoute()
const router = useRouter()

const relic = ref(null)
const modelUrl = ref('')
const modelType = ref('default')
const viewerWidth = ref(800)
const viewerHeight = ref(600)

const uploadUrl = computed(() => {
  return `${import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'}/api/relics/${route.params.id}/3d-model`
})

const uploadHeaders = computed(() => {
  return {
    'Authorization': `Bearer ${sessionStorage.getItem('token')}`
  }
})

// 获取文物信息
const fetchRelicInfo = async () => {
  try {
    const id = route.params.id
    if (!id) {
      ElMessage.error('文物ID不存在')
      return
    }

    const response = await getRelicByIdApi(id)
    if (response.code === 200) {
      relic.value = response.data
      
      // 如果有3D模型URL，加载它
      if (relic.value.model3dUrl) {
        modelUrl.value = relic.value.model3dUrl
        
        // 根据文件扩展名判断模型类型，如果没有扩展名则默认使用gltf
        const url = relic.value.model3dUrl.toLowerCase()
        if (url.endsWith('.gltf') || url.endsWith('.glb')) {
          modelType.value = 'gltf'
        } else if (url.endsWith('.obj')) {
          modelType.value = 'obj'
        } else {
          // 对于没有扩展名的链接，默认尝试作为GLTF/GLB格式加载
          modelType.value = 'gltf'
        }
      }
    }
  } catch (error) {
    console.error('获取文物信息失败:', error)
    ElMessage.error('获取文物信息失败')
  }
}

// 获取状态类型
const getStatusType = (status) => {
  const typeMap = {
    '在库': 'success',
    '借展中': 'warning',
    '修复中': 'info',
    '封存': 'danger'
  }
  return typeMap[status] || 'info'
}

// 上传前检查
const beforeUpload = (file) => {
  const isValidType = file.name.endsWith('.gltf') || 
                      file.name.endsWith('.glb') || 
                      file.name.endsWith('.obj')
  const isLt50M = file.size / 1024 / 1024 < 50

  if (!isValidType) {
    ElMessage.error('只支持 GLTF (.gltf, .glb) 和 OBJ (.obj) 格式!')
    return false
  }
  if (!isLt50M) {
    ElMessage.error('文件大小不能超过 50MB!')
    return false
  }
  return true
}

// 上传成功
const handleUploadSuccess = (response) => {
  if (response.code === 200) {
    ElMessage.success('3D模型上传成功')
    modelUrl.value = response.data.modelUrl
    
    // 更新模型类型，如果没有扩展名则默认使用gltf
    const url = response.data.modelUrl.toLowerCase()
    if (url.endsWith('.gltf') || url.endsWith('.glb')) {
      modelType.value = 'gltf'
    } else if (url.endsWith('.obj')) {
      modelType.value = 'obj'
    } else {
      modelType.value = 'gltf'
    }
    
    // 刷新文物信息
    fetchRelicInfo()
  } else {
    ElMessage.error(response.message || '上传失败')
  }
}

// 上传失败
const handleUploadError = () => {
  ElMessage.error('上传失败，请重试')
}

// 删除模型
const deleteModel = async () => {
  try {
    await ElMessageBox.confirm(
      '确定要删除当前3D模型吗？',
      '确认删除',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )

    // 检查是否有模型
    if (!modelUrl.value) {
      ElMessage.error('没有可删除的模型')
      return
    }
    
    // 使用新的智能删除端点（不需要filename参数）
    const url = `${import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'}/api/relics/${route.params.id}/3d-model-url`
    
    const response = await fetch(url, {
      method: 'DELETE',
      headers: {
        'Authorization': `Bearer ${sessionStorage.getItem('token')}`,
        'Content-Type': 'application/json'
      }
    })
    
    const result = await response.json()
    
    if (result.code === 200) {
      ElMessage.success('模型删除成功')
      modelUrl.value = ''
      modelType.value = 'default'
      
      // 刷新文物信息
      await fetchRelicInfo()
    } else {
      ElMessage.error(result.message || '删除失败')
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除模型失败:', error)
      ElMessage.error('删除失败，请重试')
    }
  }
}

// 返回
const goBack = () => {
  // 检查是否有返回页码参数
  const returnPage = route.query.returnPage
  const returnPageSize = route.query.returnPageSize
  const returnRelicName = route.query.returnRelicName
  const returnCategoryId = route.query.returnCategoryId
  const returnStatus = route.query.returnStatus
  const returnEra = route.query.returnEra
  
  if (returnPage) {
    // 如果有返回页码，跳转到文物列表并恢复查询条件
    router.push({
      path: '/relics',
      query: {
        pageNum: returnPage,
        pageSize: returnPageSize,
        relicName: returnRelicName,
        categoryId: returnCategoryId,
        status: returnStatus,
        era: returnEra
      }
    })
  } else {
    // 否则使用默认的返回
    router.back()
  }
}

// 更新查看器尺寸
const updateViewerSize = () => {
  const viewerCard = document.querySelector('.viewer-card')
  if (viewerCard) {
    viewerWidth.value = viewerCard.clientWidth - 40
    viewerHeight.value = Math.min(600, window.innerHeight - 200)
  }
}

onMounted(() => {
  fetchRelicInfo()
  updateViewerSize()
  window.addEventListener('resize', updateViewerSize)
})
</script>

<style scoped>
.relic-3d-view {
  padding: 20px;
  min-height: 100vh;
  background: var(--bg-main);
}

.header-card {
  margin-bottom: 20px;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.title-section {
  display: flex;
  align-items: center;
  gap: 15px;
}

.title-section h2 {
  margin: 0;
  font-size: 24px;
  color: var(--text-primary);
}

.content-layout {
  display: grid;
  grid-template-columns: 1fr 400px;
  gap: 20px;
}

@media (max-width: 1200px) {
  .content-layout {
    grid-template-columns: 1fr;
  }
}

.viewer-card {
  min-height: 600px;
}

.info-card {
  height: fit-content;
}

.card-header {
  font-weight: 600;
  font-size: 16px;
}

.description-section {
  margin-top: 15px;
}

.description-section h4 {
  margin: 0 0 10px 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.description-section p {
  margin: 0;
  line-height: 1.6;
  color: var(--text-secondary);
}

.model-upload-section {
  margin-top: 15px;
}

.model-upload-section h4 {
  margin: 0 0 15px 0;
  font-size: 16px;
  font-weight: 600;
  color: var(--text-primary);
}

.current-model-info-top {
  margin-bottom: 15px;
}

.upload-tabs {
  margin-top: 10px;
}

.url-input {
  margin-bottom: 15px;
}

.url-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.model-info-content {
  display: flex;
  align-items: center;
  gap: 10px;
  flex-wrap: wrap;
}

.upload-tip {
  margin-top: 10px;
  font-size: 12px;
  color: var(--text-light);
}
</style>
