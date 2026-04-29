# 🚀 3D文物展示 - 快速开始

## ⚡ 5分钟快速部署

### 1. 安装依赖

```bash
cd frontend
npm install
```

这将自动安装 Three.js 依赖。

### 2. 数据库迁移

```bash
cd backend
mysql -u root -p cultural_relics < sql/add_3d_model_support.sql
```

### 3. 创建上传目录

```bash
mkdir -p backend/uploads/3d-models
```

### 4. 启动服务

**后端**:
```bash
cd backend
mvn spring-boot:run
```

**前端**:
```bash
cd frontend
npm run dev
```

### 5. 访问页面

打开浏览器访问：
```
http://localhost:5173/relics/1/3d
```

## 🎯 快速测试

### 测试默认模型

1. 访问任意文物的3D页面
2. 如果没有上传模型，会自动显示默认立方体
3. 尝试以下操作：
   - 🖱️ 拖拽旋转
   - 🖱️ 滚轮缩放
   - 🔄 点击"自动旋转"
   - 💡 调节光照强度
   - 🎨 更改背景颜色

### 上传测试模型

**方式1：使用在线模型**

访问以下网站下载免费3D模型：
- [Sketchfab](https://sketchfab.com/) - 搜索 "artifact" 或 "pottery"
- [Free3D](https://free3d.com/) - 搜索 "vase" 或 "statue"
- [TurboSquid](https://www.turbosquid.com/Search/3D-Models/free/gltf)

**方式2：使用Blender创建**

1. 下载安装 [Blender](https://www.blender.org/)
2. 创建简单模型
3. 导出为 GLTF 格式：File → Export → glTF 2.0

**方式3：使用在线工具**

- [Tinkercad](https://www.tinkercad.com/) - 在线3D建模
- [Clara.io](https://clara.io/) - 在线3D编辑器

## 📱 功能演示

### 基本操作

```
1. 旋转视角
   - 鼠标左键拖拽

2. 平移视角
   - 鼠标右键拖拽

3. 缩放视角
   - 鼠标滚轮

4. 重置视角
   - 点击"重置视角"按钮
```

### 控制面板

```
1. 自动旋转
   ✅ 开启：模型自动旋转
   ❌ 关闭：停止旋转

2. 光照强度
   📊 范围：0 - 3
   💡 推荐：1.5

3. 背景颜色
   🎨 默认：#1a1a1a（深灰）
   🎨 推荐：#000000（黑色）或 #ffffff（白色）

4. 显示网格
   ✅ 开启：显示地面网格
   ❌ 关闭：隐藏网格
```

## 🎨 推荐的3D模型

### 文物类型推荐

| 文物类型 | 推荐格式 | 建议顶点数 | 参考网站 |
|---------|---------|-----------|---------|
| 青铜器 | GLTF | < 50K | Sketchfab |
| 陶瓷器 | GLTF | < 30K | Free3D |
| 玉器 | GLTF | < 20K | TurboSquid |
| 雕塑 | GLTF | < 100K | Sketchfab |

### 模型质量标准

**优秀**:
- ✅ 顶点数 < 50K
- ✅ 包含纹理
- ✅ 包含法线贴图
- ✅ 文件大小 < 10MB

**良好**:
- ✅ 顶点数 < 100K
- ✅ 基本纹理
- ✅ 文件大小 < 20MB

**可接受**:
- ⚠️ 顶点数 < 200K
- ⚠️ 无纹理
- ⚠️ 文件大小 < 50MB

## 🔧 常见问题快速解决

### 问题1：模型不显示

**解决方案**:
```javascript
// 检查浏览器控制台是否有错误
// 按 F12 打开开发者工具

// 常见错误：
1. CORS 错误 → 检查后端 CORS 配置
2. 404 错误 → 检查文件路径
3. 格式错误 → 确认文件格式正确
```

### 问题2：模型太大或太小

**解决方案**:
- 系统会自动缩放模型
- 如果仍然不合适，可以手动调整：
  - 滚轮缩放
  - 或修改代码中的 scale 参数

### 问题3：模型显示为黑色

**解决方案**:
```javascript
// 增加光照强度
1. 拖动"光照强度"滑块到 2.0 或更高
2. 或更改背景颜色为白色
```

### 问题4：上传失败

**检查清单**:
- ✅ 文件格式：.gltf, .glb, .obj
- ✅ 文件大小：< 50MB
- ✅ 登录状态：已登录
- ✅ 权限：ADMIN 或 CURATOR
- ✅ 网络：正常连接

## 📊 性能测试

### 测试场景

| 顶点数 | 加载时间 | FPS | 评级 |
|--------|---------|-----|------|
| < 10K | < 1s | 60 | 优秀 |
| 10K-50K | 1-3s | 60 | 良好 |
| 50K-100K | 3-5s | 45-60 | 可接受 |
| > 100K | > 5s | < 45 | 需优化 |

### 性能优化建议

**如果 FPS < 30**:
1. 关闭阴影：修改代码中的 `renderer.shadowMap.enabled = false`
2. 降低抗锯齿：修改 `antialias: false`
3. 减少光源数量
4. 使用更简单的材质

## 🎓 学习资源

### 入门教程

1. **Three.js 基础**
   - [Three.js Journey](https://threejs-journey.com/) - 付费课程
   - [Three.js Fundamentals](https://threejsfundamentals.org/) - 免费教程

2. **3D建模**
   - [Blender Guru](https://www.youtube.com/user/AndrewPPrice) - YouTube教程
   - [Blender 官方教程](https://www.blender.org/support/tutorials/)

3. **GLTF格式**
   - [GLTF 教程](https://www.khronos.org/gltf/)
   - [GLTF Viewer](https://gltf-viewer.donmccurdy.com/) - 在线查看器

### 示例代码

**创建简单场景**:
```javascript
import * as THREE from 'three'

// 场景
const scene = new THREE.Scene()

// 相机
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000)
camera.position.z = 5

// 渲染器
const renderer = new THREE.WebGLRenderer()
renderer.setSize(window.innerWidth, window.innerHeight)
document.body.appendChild(renderer.domElement)

// 立方体
const geometry = new THREE.BoxGeometry()
const material = new THREE.MeshBasicMaterial({ color: 0x00ff00 })
const cube = new THREE.Mesh(geometry, material)
scene.add(cube)

// 动画
function animate() {
  requestAnimationFrame(animate)
  cube.rotation.x += 0.01
  cube.rotation.y += 0.01
  renderer.render(scene, camera)
}
animate()
```

## 🎉 下一步

### 功能扩展

1. **添加动画**
   - 模型动画播放
   - 相机路径动画
   - 过渡效果

2. **添加交互**
   - 点击选择
   - 标注系统
   - 测量工具

3. **添加特效**
   - 后期处理
   - 粒子效果
   - 环境贴图

4. **VR/AR 支持**
   - WebXR 集成
   - AR.js 集成
   - 移动端优化

### 集成建议

1. **与文物管理集成**
   - 在文物列表添加"3D查看"按钮
   - 在文物详情页嵌入3D查看器
   - 支持批量上传3D模型

2. **与展览系统集成**
   - 虚拟展厅
   - 3D导览
   - 互动展示

3. **与教育系统集成**
   - 3D教学
   - 虚拟修复
   - 历史重现

## 📞 获取帮助

### 问题反馈

如果遇到问题，请提供：
1. 浏览器版本
2. 错误信息（控制台截图）
3. 操作步骤
4. 模型文件信息

### 技术支持

- 📧 Email: support@example.com
- 💬 GitHub Issues
- 📚 查看完整文档：`3D_RELIC_VIEWER_IMPLEMENTATION.md`

---

**祝您使用愉快！** 🎉
