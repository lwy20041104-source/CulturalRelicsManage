# 备份创建人显示问题修复

## 问题描述

在数据备份管理界面，创建备份后，"创建人"字段显示的是用户名（username），而不是真实姓名（realName）。

## 问题原因

在 `BackupController.java` 中，`createBackup()` 和 `restoreDatabase()` 方法使用了硬编码的字符串 `"admin"` 作为创建人，而不是从当前登录用户获取真实姓名。

### 问题代码

```java
@PostMapping
public Result<SysBackup> createBackup(@RequestBody SysBackup backup) {
    try {
        String username = "admin"; // 从SecurityContext获取当前用户 ❌ 硬编码
        SysBackup result = backupService.createManualBackup(
            backup.getBackupName(),
            backup.getDescription(),
            backup.getIsEncrypted(),
            username  // ❌ 传递硬编码的 "admin"
        );
        return Result.success(result);
    } catch (Exception e) {
        log.error("创建备份失败", e);
        return Result.error("创建备份失败: " + e.getMessage());
    }
}
```

## 解决方案

使用 `UserContextUtil.getCurrentUserRealName()` 方法获取当前登录用户的真实姓名。

### 修复后的代码

```java
@PostMapping
public Result<SysBackup> createBackup(@RequestBody SysBackup backup) {
    try {
        String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
        SysBackup result = backupService.createManualBackup(
            backup.getBackupName(),
            backup.getDescription(),
            backup.getIsEncrypted(),
            realName  // ✅ 传递真实姓名
        );
        return Result.success(result);
    } catch (Exception e) {
        log.error("创建备份失败", e);
        return Result.error("创建备份失败: " + e.getMessage());
    }
}
```

同样修复了 `restoreDatabase()` 方法：

```java
@PostMapping("/{id}/restore")
public Result<SysRestore> restoreDatabase(@PathVariable Long id) {
    try {
        String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
        SysRestore result = backupService.restoreDatabase(id, realName);
        return Result.success(result);
    } catch (Exception e) {
        log.error("恢复数据库失败", e);
        return Result.error("恢复数据库失败: " + e.getMessage());
    }
}
```

## UserContextUtil 工作原理

`UserContextUtil` 是一个工具类，用于从 Spring Security 上下文中获取当前登录用户的信息。

### 核心方法

```java
public String getCurrentUserRealName() {
    try {
        // 1. 从 SecurityContext 获取认证信息
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        // 2. 检查是否已认证
        if (authentication == null || !authentication.isAuthenticated() 
            || "anonymousUser".equals(authentication.getPrincipal())) {
            return "系统";
        }
        
        // 3. 获取用户名
        String username = authentication.getName();
        
        // 4. 从数据库查询用户信息
        SysUser user = userMapper.selectByUsername(username);
        
        // 5. 返回真实姓名，如果没有则返回用户名
        if (user != null && user.getRealName() != null && !user.getRealName().isEmpty()) {
            return user.getRealName();
        }
        
        return username;
    } catch (Exception e) {
        return "系统";
    }
}
```

### 其他可用方法

- `getCurrentUsername()`：获取当前用户的用户名
- `getCurrentUserId()`：获取当前用户的ID
- `getCurrentUser()`：获取当前用户的完整信息

## 修改的文件

- `backend/src/main/java/com/example/controller/BackupController.java`
  - 修改 `createBackup()` 方法
  - 修改 `restoreDatabase()` 方法

## 测试步骤

1. 启动后端服务
2. 使用不同用户登录系统（确保用户有真实姓名）
3. 进入"系统管理" → "数据备份"
4. 创建新备份
5. 检查备份列表中的"创建人"字段
6. 验证显示的是真实姓名而不是用户名

### 测试用例

| 用户名 | 真实姓名 | 期望显示 |
|--------|----------|----------|
| admin | 系统管理员 | 系统管理员 |
| curator1 | 张三 | 张三 |
| curator2 | 李四 | 李四 |

## 相关功能

在项目中，其他地方也使用了 `UserContextUtil` 来获取当前用户信息：

1. **审计日志记录**
   - `BackupController.deleteBackup()` - 删除备份时记录操作人
   - `BackupController.updateBackupConfig()` - 修改配置时记录操作人

2. **其他控制器**
   - 所有需要记录操作人的地方都应该使用 `UserContextUtil`

## 注意事项

1. **依赖注入**
   - `BackupController` 已经注入了 `UserContextUtil`
   - 其他控制器如需使用，也需要注入

2. **异常处理**
   - `getCurrentUserRealName()` 内部已处理异常
   - 如果获取失败，会返回 "系统" 作为默认值

3. **未登录用户**
   - 如果用户未登录或认证失败，返回 "系统"
   - 备份功能需要 ADMIN 权限，正常情况下不会出现未登录

4. **数据库查询**
   - 每次调用都会查询数据库
   - 如果性能敏感，可以考虑缓存用户信息

## 总结

通过使用 `UserContextUtil.getCurrentUserRealName()` 方法，成功修复了备份创建人显示问题。现在系统会正确显示当前登录用户的真实姓名，而不是硬编码的 "admin" 或用户名。

这个修复提高了系统的可追溯性和审计能力，使管理员能够清楚地知道是谁创建或恢复了备份。
