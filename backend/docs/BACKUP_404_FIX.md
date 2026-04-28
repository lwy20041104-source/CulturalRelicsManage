# 备份接口404错误修复

## 问题描述

前端访问备份接口时返回404错误：
```
GET http://localhost:8080/api/backup?pageNum=1&pageSize=10 404 (Not Found)
```

## 问题原因

### 1. Context Path配置
在 `application.yml` 中配置了：
```yaml
server:
  port: 8080
  servlet:
    context-path: /api
```

这意味着所有接口都会自动添加 `/api` 前缀。

### 2. Controller路径配置错误

**错误配置**：
```java
@RestController
@RequestMapping("/api/backup")  // ❌ 错误：重复了/api前缀
public class BackupController {
```

实际访问路径变成了：`/api/api/backup`（context-path + RequestMapping）

### 3. 其他Controller的正确配置

查看项目中其他Controller的配置：
```java
@RestController
@RequestMapping("/users")  // ✅ 正确：不带/api前缀
public class SysUserController {

@RestController
@RequestMapping("/relics")  // ✅ 正确：不带/api前缀
public class CulturalRelicController {

@RestController
@RequestMapping("/loans")  // ✅ 正确：不带/api前缀
public class LoanRecordController {
```

实际访问路径：`/api/users`, `/api/relics`, `/api/loans`

## 修复方案

### 修改BackupController

**修改前**：
```java
@Slf4j
@RestController
@RequestMapping("/api/backup")  // ❌ 错误
public class BackupController {
```

**修改后**：
```java
@Slf4j
@RestController
@RequestMapping("/backup")  // ✅ 正确
public class BackupController {
```

## 验证步骤

### 1. 重新编译
```bash
cd backend
mvn clean compile
```

结果：
```
[INFO] BUILD SUCCESS
[INFO] Total time: 13.308 s
[INFO] Finished at: 2026-04-27T21:29:36+08:00
```

### 2. 重启后端服务
```bash
# 停止当前运行的后端服务（Ctrl+C）
# 重新启动
mvn spring-boot:run
```

### 3. 测试接口
```bash
# 测试备份列表接口
curl http://localhost:8080/api/backup?pageNum=1&pageSize=10
```

预期返回：
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [],
    "total": 0,
    "current": 1,
    "size": 10
  }
}
```

### 4. 前端测试
1. 刷新前端页面
2. 访问"数据备份"菜单
3. 应该能正常加载备份列表

## 接口路径对照表

| Controller | RequestMapping | 实际访问路径 |
|-----------|---------------|------------|
| AuthController | `/auth` | `/api/auth` |
| SysUserController | `/users` | `/api/users` |
| CulturalRelicController | `/relics` | `/api/relics` |
| LoanRecordController | `/loans` | `/api/loans` |
| BackupController | `/backup` | `/api/backup` ✅ |

## 相关问题

### SysOperationLogController也有同样的问题

检查发现 `SysOperationLogController` 也使用了错误的路径：
```java
@RestController
@RequestMapping("/api/operation-logs")  // ❌ 错误
```

如果该接口也出现404错误，需要同样修复：
```java
@RestController
@RequestMapping("/operation-logs")  // ✅ 正确
```

## 经验总结

### 规则
当项目配置了 `context-path` 时：
- ✅ Controller的 `@RequestMapping` 不要包含context-path
- ✅ 前端API调用时要包含context-path
- ✅ 保持项目中所有Controller的配置风格一致

### 检查清单
- [ ] 检查 `application.yml` 中的 `context-path` 配置
- [ ] 确保所有Controller的 `@RequestMapping` 不包含context-path
- [ ] 确保前端API调用包含context-path
- [ ] 测试所有接口是否正常访问

## 后续注意事项

1. 新增Controller时，`@RequestMapping` 不要添加 `/api` 前缀
2. 前端调用时，URL要包含 `/api` 前缀
3. 保持代码风格一致，参考现有Controller

## 相关文档
- [备份系统实现文档](BACKUP_SYSTEM_IMPLEMENTATION.md)
- [快速开始指南](BACKUP_QUICK_START.md)

---

修复时间：2026-04-27 21:29:36
修复状态：✅ 完成
编译状态：✅ SUCCESS
下一步：重启后端服务
