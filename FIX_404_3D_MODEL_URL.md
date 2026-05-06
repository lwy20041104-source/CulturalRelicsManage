# 修复3D模型链接上传404错误

## 问题原因

Relic3DController使用了 `@RequestMapping("/api/relics")`，但由于已经配置了 `context-path: /api`，导致实际端点变成了：
- 错误的端点：`/api/api/relics/{id}/3d-model-url`
- 前端请求：`/api/relics/{id}/3d-model-url`
- 结果：404 Not Found

## 解决方案

将Relic3DController的 `@RequestMapping` 从 `/api/relics` 改为 `/relics`，让context-path自动添加 `/api` 前缀。

## 已修复

**文件**: `backend/src/main/java/com/example/controller/Relic3DController.java`

**修改前**:
```java
@RestController
@RequestMapping("/api/relics")
@CrossOrigin
public class Relic3DController {
```

**修改后**:
```java
@RestController
@RequestMapping("/relics")
@CrossOrigin
public class Relic3DController {
```

## 路径映射

配置 `context-path: /api` 后：
- Controller路径：`/relics`
- 实际端点：`/api/relics` ✅
- 前端请求：`baseURL(/api) + /relics` = `/api/relics` ✅

## 重启后端服务

**必须重启后端才能生效！**

1. **停止当前运行的后端**
   - 在运行后端的命令行窗口按 `Ctrl+C`

2. **启动新编译的后端**
   ```bash
   cd backend
   java -jar target/cultural-relics-manage-1.0.0.jar
   ```

3. **验证启动成功**
   看到以下日志：
   ```
   Tomcat started on port(s): 8080 (http) with context path '/api'
   Started CulturalRelicsApplication
   ```

4. **刷新前端页面并测试**
   - 打开文物管理页面
   - 点击"新增"或"编辑"
   - 选择"输入链接"选项卡
   - 输入一个3D模型链接
   - 保存

## 验证

链接上传功能应该正常工作，不再返回404错误。

## 注意事项

所有Controller都应该使用不带 `/api` 前缀的路径，因为 `context-path` 会自动添加。

例如：
- ✅ `@RequestMapping("/relics")` → 实际端点：`/api/relics`
- ✅ `@RequestMapping("/users")` → 实际端点：`/api/users`
- ❌ `@RequestMapping("/api/relics")` → 实际端点：`/api/api/relics` (错误)
