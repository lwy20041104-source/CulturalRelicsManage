# 3D模型链接上传功能 - 修复说明

## 🔧 问题总结

### 问题1：404错误
**现象**：`POST http://localhost:8080/api/relics/6/3d-model-url 404 (Not Found)`  
**原因**：`SysOperationLogController` 路径配置错误  
**状态**：✅ 已修复

### 问题2：数据未保存到数据库
**现象**：显示"添加成功"，但界面不显示，数据库中也没有记录  
**原因**：MyBatis XML映射文件缺少 `model_3d_url` 和 `model_3d_upload_time` 字段  
**状态**：✅ 已修复

### 问题3：数据库字段长度不足
**现象**：`Data too long for column 'model_3d_url' at row 1`  
**原因**：数据库字段长度为 `VARCHAR(500)`，某些链接超过500字符  
**状态**：✅ 已创建迁移脚本，需要执行

---

## 问题描述（历史记录）
用户在使用链接方式上传文物3D模型时，遇到404错误：
```
POST http://localhost:8080/api/relics/6/3d-model-url 404 (Not Found)
```

## 根本原因
在 `application.yml` 中配置了 `server.servlet.context-path: /api` 后，所有Controller的路径都会自动添加 `/api` 前缀。但是有一个Controller（`SysOperationLogController`）仍然在 `@RequestMapping` 注解中使用了 `/api` 前缀，导致路径冲突。

## 已修复的问题

### 1. 修复了 `SysOperationLogController.java`
**文件**: `backend/src/main/java/com/example/controller/SysOperationLogController.java`

**修改前**:
```java
@RestController
@RequestMapping("/api/operation-logs")
public class SysOperationLogController {
```

**修改后**:
```java
@RestController
@RequestMapping("/operation-logs")
public class SysOperationLogController {
```

### 2. 确认了 `Relic3DController.java` 的配置正确
**文件**: `backend/src/main/java/com/example/controller/Relic3DController.java`

Controller配置：
```java
@RestController
@RequestMapping("/relics")
@CrossOrigin
public class Relic3DController {
```

端点配置：
- `POST /{id}/3d-model-url` - 保存3D模型链接
- `DELETE /{id}/3d-model-url` - 删除3D模型（智能删除，支持文件和链接）

实际访问路径（由于context-path）：
- `POST /api/relics/{id}/3d-model-url`
- `DELETE /api/relics/{id}/3d-model-url`

## 功能说明

### 3D模型上传支持两种方式

#### 方式1：上传文件
- 支持格式：GLTF (.gltf, .glb), OBJ (.obj)
- 最大文件大小：50MB
- 文件会保存到服务器的 `uploads/3d-models` 目录

#### 方式2：输入链接
- 支持任何在线3D模型链接
- 支持Sketchfab等平台的嵌入链接
- 无扩展名的链接默认作为GLTF格式处理

### 智能删除功能
删除3D模型时，系统会自动判断：
- 如果是本地上传的文件，会同时删除服务器上的文件
- 如果是外部链接，只删除数据库记录

## 后续步骤

### ⚠️ 重要：需要重启后端服务

1. **停止当前运行的后端服务**
   - 如果后端正在运行，请先停止它
   - 在IDEA中点击停止按钮，或者在终端按 Ctrl+C

2. **重新启动后端服务**
   - 在IDEA中运行 `CulturalRelicsApplication`
   - 或者在终端执行：
     ```bash
     cd backend
     mvn spring-boot:run
     ```

3. **验证功能**
   - 打开前端页面
   - 编辑一个文物
   - 在3D模型上传区域，切换到"输入链接"选项卡
   - 输入一个3D模型链接（例如Sketchfab链接）
   - 点击确认保存
   - 应该能成功保存，不再出现404错误

## 测试建议

### 测试用例1：上传文件
1. 编辑文物
2. 选择"上传文件"选项卡
3. 上传一个 .glb 或 .gltf 文件
4. 保存并查看3D模型

### 测试用例2：输入链接
1. 编辑文物
2. 选择"输入链接"选项卡
3. 输入一个Sketchfab链接，例如：
   ```
   https://sketchfab.com/models/xxx/embed
   ```
4. 保存并查看3D模型

### 测试用例3：删除模型
1. 对于有3D模型的文物
2. 点击"删除3D模型"按钮
3. 确认删除
4. 验证模型已被删除

## 技术细节

### 前端API调用
```javascript
// 保存链接
await request.post(`/relics/${relicId}/3d-model-url`, {
  modelUrl: model3dUrlInput.value
})

// 删除模型（智能删除）
await request.delete(`/relics/${relicId}/3d-model-url`)
```

### 后端端点
```java
// 保存链接
@PostMapping("/{id}/3d-model-url")
@PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
public Result<Map<String, Object>> save3DModelUrl(
    @PathVariable Long id,
    @RequestBody Map<String, String> request)

// 智能删除
@DeleteMapping("/{id}/3d-model-url")
@PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
public Result<String> delete3DModelUrl(@PathVariable Long id)
```

### Context Path配置
```yaml
server:
  port: 8080
  servlet:
    context-path: /api
```

这个配置使得所有Controller的路径都自动添加 `/api` 前缀，因此：
- Controller中的 `@RequestMapping("/relics")` 
- 实际访问路径变为 `/api/relics`

## 最新修复 (2026-05-06 20:14)

### 问题1：数据库字段长度不足
**错误信息**：`Data too long for column 'model_3d_url' at row 1`

**原因**：数据库中 `model_3d_url` 字段长度为 `VARCHAR(500)`，但某些3D模型链接（特别是Sketchfab嵌入链接）可能超过500个字符。

**解决方案**：
1. ✅ 修复了 MyBatis XML 映射文件，添加了 `model_3d_url` 和 `model_3d_upload_time` 字段的映射
2. ✅ 创建了数据库迁移脚本 `backend/sql/increase_model_3d_url_length.sql`
3. ✅ 后端重新编译成功

### 问题2：3D模型显示问题
**现象**：提示"默认模型加载成功"，但展示的不是默认模型

**原因**：
1. Sketchfab链接解析不完整，只支持部分URL格式
2. 当模型加载失败时，不会自动回退到默认模型
3. 默认模型加载时会显示不必要的成功提示

**解决方案**：
1. ✅ 改进了Sketchfab链接解析，支持多种URL格式：
   - `https://sketchfab.com/3d-models/name-{modelId}`
   - `https://sketchfab.com/models/{modelId}/embed`
   - 直接的embed链接
2. ✅ 添加了模型加载失败时的自动回退机制，1秒后自动加载默认立方体模型
3. ✅ 移除了默认模型自动加载时的成功提示（只在用户手动点击"加载默认模型"按钮时才显示）
4. ✅ 改进了错误提示信息
5. ✅ 前端重新编译成功

### 需要执行的数据库迁移

**重要**：在重启后端服务之前，请先执行以下SQL脚本：

```sql
-- 方法1：在MySQL客户端或Navicat中执行
USE cultural_relics;

ALTER TABLE cultural_relic 
MODIFY COLUMN model_3d_url VARCHAR(2000) NULL DEFAULT NULL COMMENT '3D模型URL';
```

或者直接执行脚本文件：
```bash
mysql -u root -p cultural_relics < backend/sql/increase_model_3d_url_length.sql
```

## 编译状态
✅ 后端编译成功 (2026-05-06 20:14:14)
✅ 前端编译成功 (2026-05-06 20:25:00)
✅ 所有Controller路径已修正
✅ MyBatis映射文件已修复
✅ 数据库迁移脚本已创建
✅ 3D模型查看器已优化

## 下一步操作顺序

### 1️⃣ 执行数据库迁移（必须先做）
在MySQL中执行：
```sql
USE cultural_relics;
ALTER TABLE cultural_relic 
MODIFY COLUMN model_3d_url VARCHAR(2000) NULL DEFAULT NULL COMMENT '3D模型URL';
```

### 2️⃣ 重启后端服务
- 停止当前运行的后端服务
- 重新启动后端服务

### 3️⃣ 测试功能
- 编辑一个文物
- 切换到"输入链接"选项卡
- 输入3D模型链接（支持长链接）
- 保存并验证
