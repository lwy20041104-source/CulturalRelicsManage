# 🔧 3D文物展示 - 故障排除指南

## ✅ 已解决的问题

### 1. 后端编译错误

**错误信息**:
```
java: 对于success(没有参数), 找不到合适的方法
```

**解决方案**: ✅ 已修复
- 修改 `Relic3DController.java` 中的 `delete3DModel` 方法
- 将 `Result.success()` 改为 `Result.success("删除成功")`

### 2. 前端依赖缺失

**错误信息**:
```
Failed to resolve import "three" from "src/components/Relic3DViewer.vue"
```

**解决方案**: ✅ 已修复
```bash
cd frontend
npm install three@^0.160.0
```

## 🚀 启动步骤

### 1. 确认依赖已安装

**后端**:
```bash
cd backend
mvn clean compile
# 应该看到 BUILD SUCCESS
```

**前端**:
```bash
cd frontend
npm install
# 确认 three 已在 package.json 中
```

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

```
http://localhost:5173/relics/1/3d
```

## 🐛 常见问题

### Q1: 前端启动失败

**检查清单**:
```bash
# 1. 检查 Node.js 版本
node --version
# 应该 >= 16.0.0

# 2. 检查依赖
cd frontend
npm list three
# 应该显示 three@0.160.1

# 3. 清除缓存重新安装
rm -rf node_modules package-lock.json
npm install
```

### Q2: 后端启动失败

**检查清单**:
```bash
# 1. 检查 Java 版本
java -version
# 应该 >= 11

# 2. 检查 Maven 版本
mvn -version
# 应该 >= 3.6

# 3. 清除编译缓存
cd backend
mvn clean
mvn compile
```

### Q3: 3D模型不显示

**可能原因**:
1. ❌ 模型文件格式不支持
2. ❌ 文件路径错误
3. ❌ CORS 配置问题
4. ❌ 文件大小超限

**解决方案**:
```javascript
// 1. 检查浏览器控制台（F12）
// 查看是否有错误信息

// 2. 检查文件格式
// 只支持: .gltf, .glb, .obj

// 3. 检查文件大小
// 限制: < 50MB

// 4. 测试默认模型
// 不上传文件，应该显示默认立方体
```

### Q4: 上传失败

**检查清单**:
```bash
# 1. 检查上传目录是否存在
ls -la backend/uploads/3d-models

# 2. 检查目录权限
chmod 755 backend/uploads/3d-models

# 3. 检查文件大小
# 限制: 50MB

# 4. 检查登录状态
# 需要 ADMIN 或 CURATOR 角色
```

### Q5: 性能问题（卡顿）

**优化建议**:
```javascript
// 1. 降低模型复杂度
// 顶点数 < 50K

// 2. 关闭阴影
renderer.shadowMap.enabled = false

// 3. 降低抗锯齿
renderer = new THREE.WebGLRenderer({ antialias: false })

// 4. 减少光源数量
// 只保留环境光和主光源
```

## 📋 验证清单

### 后端验证

- [ ] Maven 编译成功
- [ ] Spring Boot 启动成功
- [ ] 数据库迁移完成
- [ ] 上传目录已创建
- [ ] API 端点可访问

### 前端验证

- [ ] npm install 成功
- [ ] three 依赖已安装
- [ ] Vite 启动成功
- [ ] 页面可以访问
- [ ] 3D查看器显示

### 功能验证

- [ ] 默认模型显示
- [ ] 鼠标交互正常
- [ ] 控制面板工作
- [ ] 文件上传成功
- [ ] 模型加载正常

## 🔍 调试技巧

### 1. 查看浏览器控制台

```javascript
// 按 F12 打开开发者工具
// 查看 Console 标签页
// 查找红色错误信息
```

### 2. 查看网络请求

```javascript
// 开发者工具 → Network 标签页
// 查看 API 请求是否成功
// 检查响应状态码和内容
```

### 3. 查看 Three.js 场景

```javascript
// 在浏览器控制台执行
console.log(scene)
console.log(camera)
console.log(renderer)
```

### 4. 查看后端日志

```bash
# 查看 Spring Boot 控制台输出
# 查找异常堆栈信息
```

## 📞 获取帮助

### 提供以下信息

1. **环境信息**:
   - 操作系统
   - Node.js 版本
   - Java 版本
   - 浏览器版本

2. **错误信息**:
   - 完整的错误消息
   - 浏览器控制台截图
   - 后端日志

3. **操作步骤**:
   - 详细的复现步骤
   - 使用的文件信息

### 参考文档

- `3D_RELIC_VIEWER_IMPLEMENTATION.md` - 完整实现文档
- `3D_QUICK_START.md` - 快速开始指南

## ✅ 当前状态

- ✅ 后端编译成功
- ✅ Three.js 依赖已安装
- ✅ 所有代码文件已创建
- ✅ 数据库脚本已准备
- ✅ 文档已完成

**可以开始使用了！** 🎉

---

**最后更新**: 2026-04-29
