# 🎨 3D文物展示功能实现完成

## 📋 功能概述

基于 Three.js 实现的交互式 3D 文物展示系统，支持多种 3D 模型格式，提供丰富的交互控制和视觉效果。

## ✨ 核心功能

### 1. 3D模型查看器

**组件**: `frontend/src/components/Relic3DViewer.vue`

**功能特性**:
- ✅ 支持 GLTF/GLB 格式（推荐）
- ✅ 支持 OBJ 格式
- ✅ 默认立方体模型（无模型时显示）
- ✅ 自动居中和缩放
- ✅ 实时渲染和动画

### 2. 交互控制

**鼠标操作**:
- 🖱️ 左键拖拽：旋转视角
- 🖱️ 右键拖拽：平移视角
- 🖱️ 滚轮：缩放视角

**控制面板**:
- 🔄 自动旋转开关
- 🔄 重置视角
- 🖥️ 全屏显示
- 💡 光照强度调节（0-3）
- 🎨 背景颜色选择
- 📐 网格显示开关

### 3. 视觉效果

**光照系统**:
- 环境光（Ambient Light）
- 主光源（Directional Light）+ 阴影
- 补光（Fill Light）
- 顶光（Top Light）

**材质效果**:
- PBR 材质（物理渲染）
- 金属度和粗糙度控制
- 阴影投射和接收

### 4. 模型管理

**上传功能**:
- 📤 支持拖拽上传
- 📤 文件格式验证
- 📤 文件大小限制（50MB）
- 📤 上传进度显示

**模型信息**:
- 📊 顶点数统计
- 📊 面数统计
- 📊 材质数量

## 🗂️ 文件结构

```
frontend/
├── src/
│   ├── components/
│   │   └── Relic3DViewer.vue          # 3D查看器组件
│   ├── views/
│   │   └── Relic3DView.vue            # 3D展示页面
│   ├── utils/
│   │   └── generate3DModel.js         # 模型生成工具
│   └── router/
│       └── index.js                    # 路由配置（已更新）

backend/
├── src/main/java/com/example/controller/
│   └── Relic3DController.java         # 3D模型API
└── sql/
    └── add_3d_model_support.sql       # 数据库迁移
```

## 🚀 安装和配置

### 1. 安装依赖

```bash
cd frontend
npm install
```

新增依赖：
- `three@^0.160.0` - Three.js 核心库

### 2. 数据库迁移

```bash
cd backend
mysql -u root -p cultural_relics < sql/add_3d_model_support.sql
```

添加的字段：
- `model_3d_url` - 3D模型URL
- `model_3d_type` - 模型类型（gltf/obj）
- `model_3d_size` - 文件大小
- `model_3d_upload_time` - 上传时间

### 3. 配置文件上传路径

**application.yml** 或 **application.properties**:

```yaml
# application.yml
file:
  upload:
    path: uploads/3d-models
    url-prefix: http://localhost:8080/uploads/3d-models
```

或

```properties
# application.properties
file.upload.path=uploads/3d-models
file.upload.url-prefix=http://localhost:8080/uploads/3d-models
```

### 4. 创建上传目录

```bash
mkdir -p backend/uploads/3d-models
```

## 📱 使用方法

### 访问3D展示页面

**方式1：从文物列表进入**
1. 进入文物管理页面
2. 点击文物的"3D展示"按钮
3. 跳转到 `/relics/{id}/3d` 页面

**方式2：直接访问**
```
http://localhost:5173/relics/1/3d
```

### 上传3D模型

1. 在3D展示页面右侧信息面板
2. 找到"3D模型管理"区域
3. 点击"上传3D模型"按钮
4. 选择 GLTF 或 OBJ 文件
5. 等待上传完成
6. 模型自动加载到查看器

### 交互操作

**基本操作**:
```
旋转：鼠标左键拖拽
平移：鼠标右键拖拽
缩放：鼠标滚轮
```

**控制面板**:
- 点击"自动旋转"：开启/关闭自动旋转
- 点击"重置视角"：恢复初始视角
- 点击"全屏"：进入/退出全屏模式
- 调节"光照强度"：改变场景亮度
- 选择"背景颜色"：更改背景色
- 切换"显示网格"：显示/隐藏地面网格

## 🎯 API 接口

### 1. 上传3D模型

```http
POST /api/relics/{id}/3d-model
Content-Type: multipart/form-data
Authorization: Bearer {token}

参数:
- file: 3D模型文件（.gltf, .glb, .obj）

响应:
{
  "code": 200,
  "message": "success",
  "data": {
    "relicId": 1,
    "modelUrl": "http://localhost:8080/uploads/3d-models/xxx.gltf",
    "filename": "xxx.gltf",
    "fileSize": 1024000,
    "modelType": "gltf"
  }
}
```

### 2. 删除3D模型

```http
DELETE /api/relics/{id}/3d-model?filename=xxx.gltf
Authorization: Bearer {token}

响应:
{
  "code": 200,
  "message": "success"
}
```

### 3. 获取3D模型信息

```http
GET /api/relics/{id}/3d-model

响应:
{
  "code": 200,
  "message": "success",
  "data": {
    "relicId": 1,
    "modelUrl": "http://localhost:8080/uploads/3d-models/xxx.gltf",
    "hasModel": true
  }
}
```

## 🎨 支持的3D格式

### GLTF/GLB（推荐）

**优点**:
- ✅ 标准格式，广泛支持
- ✅ 包含材质、纹理、动画
- ✅ 文件体积小
- ✅ 加载速度快

**使用场景**:
- 高质量文物展示
- 需要材质和纹理
- 需要动画效果

### OBJ

**优点**:
- ✅ 简单易用
- ✅ 广泛支持
- ✅ 纯几何数据

**缺点**:
- ❌ 不包含材质信息
- ❌ 需要单独的 MTL 文件

**使用场景**:
- 简单几何模型
- 不需要复杂材质

## 🔧 高级配置

### 自定义材质

在 `Relic3DViewer.vue` 中修改默认材质：

```javascript
const material = new THREE.MeshStandardMaterial({
  color: 0x8B4513,      // 颜色
  metalness: 0.3,       // 金属度 (0-1)
  roughness: 0.7,       // 粗糙度 (0-1)
  emissive: 0x000000,   // 自发光颜色
  emissiveIntensity: 0  // 自发光强度
})
```

### 自定义光照

```javascript
// 主光源
const mainLight = new THREE.DirectionalLight(0xffffff, 1.5)
mainLight.position.set(5, 10, 5)

// 环境光
const ambientLight = new THREE.AmbientLight(0xffffff, 0.5)

// 点光源
const pointLight = new THREE.PointLight(0xffffff, 1, 100)
pointLight.position.set(0, 5, 0)
```

### 自定义相机

```javascript
camera = new THREE.PerspectiveCamera(
  45,                    // 视野角度
  width / height,        // 宽高比
  0.1,                   // 近裁剪面
  1000                   // 远裁剪面
)
camera.position.set(5, 5, 5)
```

## 📊 性能优化

### 1. 模型优化

**建议**:
- 控制顶点数量（< 100K）
- 使用纹理压缩
- 合并材质
- 使用 LOD（细节层次）

### 2. 渲染优化

```javascript
// 启用抗锯齿
renderer = new THREE.WebGLRenderer({ antialias: true })

// 设置像素比
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

// 启用阴影优化
renderer.shadowMap.type = THREE.PCFSoftShadowMap
```

### 3. 内存管理

```javascript
// 组件卸载时清理资源
onUnmounted(() => {
  if (renderer) {
    renderer.dispose()
  }
  if (controls) {
    controls.dispose()
  }
  // 清理几何体和材质
  scene.traverse((object) => {
    if (object.geometry) {
      object.geometry.dispose()
    }
    if (object.material) {
      if (Array.isArray(object.material)) {
        object.material.forEach(material => material.dispose())
      } else {
        object.material.dispose()
      }
    }
  })
})
```

## 🎓 Three.js 基础知识

### 核心概念

1. **Scene（场景）**: 容器，包含所有3D对象
2. **Camera（相机）**: 观察视角
3. **Renderer（渲染器）**: 将场景渲染到画布
4. **Mesh（网格）**: 3D对象 = 几何体 + 材质
5. **Light（光源）**: 照亮场景

### 坐标系统

```
Y轴（上）
 |
 |
 |_____ X轴（右）
/
/
Z轴（前）
```

### 常用几何体

```javascript
// 立方体
new THREE.BoxGeometry(width, height, depth)

// 球体
new THREE.SphereGeometry(radius, widthSegments, heightSegments)

// 圆柱体
new THREE.CylinderGeometry(radiusTop, radiusBottom, height)

// 平面
new THREE.PlaneGeometry(width, height)
```

## 🐛 常见问题

### Q1: 模型加载失败？

**A**: 检查：
1. 文件格式是否正确（.gltf, .glb, .obj）
2. 文件路径是否可访问
3. CORS 配置是否正确
4. 文件大小是否超过限制

### Q2: 模型显示为黑色？

**A**: 可能原因：
1. 缺少光照
2. 材质问题
3. 法线方向错误

解决方法：
```javascript
// 添加更多光源
const ambientLight = new THREE.AmbientLight(0xffffff, 1)
scene.add(ambientLight)
```

### Q3: 性能问题？

**A**: 优化建议：
1. 减少模型顶点数
2. 降低阴影质量
3. 使用简化的材质
4. 禁用不必要的效果

### Q4: 模型太大或太小？

**A**: 自动缩放代码：
```javascript
const box = new THREE.Box3().setFromObject(model)
const size = box.getSize(new THREE.Vector3())
const maxDim = Math.max(size.x, size.y, size.z)
const scale = 3 / maxDim
model.scale.multiplyScalar(scale)
```

## 📚 扩展功能建议

### 1. 动画支持

```javascript
// 添加动画混合器
const mixer = new THREE.AnimationMixer(model)
const action = mixer.clipAction(gltf.animations[0])
action.play()

// 在动画循环中更新
const clock = new THREE.Clock()
function animate() {
  const delta = clock.getDelta()
  mixer.update(delta)
  renderer.render(scene, camera)
}
```

### 2. 测量工具

```javascript
// 添加距离测量
const raycaster = new THREE.Raycaster()
const mouse = new THREE.Vector2()

function onMouseClick(event) {
  mouse.x = (event.clientX / window.innerWidth) * 2 - 1
  mouse.y = -(event.clientY / window.innerHeight) * 2 + 1
  
  raycaster.setFromCamera(mouse, camera)
  const intersects = raycaster.intersectObjects(scene.children)
  
  if (intersects.length > 0) {
    const point = intersects[0].point
    // 添加测量点
  }
}
```

### 3. 截图功能

```javascript
function takeScreenshot() {
  renderer.render(scene, camera)
  const dataURL = renderer.domElement.toDataURL('image/png')
  const link = document.createElement('a')
  link.download = 'screenshot.png'
  link.href = dataURL
  link.click()
}
```

### 4. VR/AR 支持

```javascript
import { VRButton } from 'three/examples/jsm/webxr/VRButton'

// 启用 VR
renderer.xr.enabled = true
document.body.appendChild(VRButton.createButton(renderer))
```

## 🎉 完成状态

- ✅ 3D查看器组件
- ✅ 3D展示页面
- ✅ 交互控制
- ✅ 光照系统
- ✅ 模型上传API
- ✅ 数据库支持
- ✅ 路由配置
- ✅ 文档编写

## 📖 参考资源

- [Three.js 官方文档](https://threejs.org/docs/)
- [Three.js 示例](https://threejs.org/examples/)
- [GLTF 格式规范](https://www.khronos.org/gltf/)
- [WebGL 基础](https://webglfundamentals.org/)

---

**开发者**: Kiro AI Assistant
**版本**: 1.0.0
**更新时间**: 2026-04-29
