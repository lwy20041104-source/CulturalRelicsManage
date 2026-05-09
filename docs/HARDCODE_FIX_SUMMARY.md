# 硬编码用户信息修复总结

## 问题概述

在项目中发现多处硬编码用户信息的问题，主要表现为：
1. 使用硬编码的字符串 `"admin"` 作为操作人
2. 使用硬编码的 `Long userId = 1L` 作为用户ID
3. 使用 `authentication.getName()` 获取用户名而不是真实姓名

这些硬编码导致审计日志和操作记录无法正确显示实际操作人的真实姓名。

## 修复方案

使用 `UserContextUtil` 工具类统一获取当前登录用户信息：
- `userContextUtil.getCurrentUserRealName()` - 获取真实姓名
- `userContextUtil.getCurrentUserId()` - 获取用户ID
- `userContextUtil.getCurrentUsername()` - 获取用户名

## 修复详情

### 1. BackupController.java ✅

#### 问题代码
```java
@PostMapping
public Result<SysBackup> createBackup(@RequestBody SysBackup backup) {
    String username = "admin"; // ❌ 硬编码
    SysBackup result = backupService.createManualBackup(..., username);
    return Result.success(result);
}

@PostMapping("/{id}/restore")
public Result<SysRestore> restoreDatabase(@PathVariable Long id) {
    String username = "admin"; // ❌ 硬编码
    SysRestore result = backupService.restoreDatabase(id, username);
    return Result.success(result);
}
```

#### 修复后
```java
@PostMapping
public Result<SysBackup> createBackup(@RequestBody SysBackup backup) {
    String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
    SysBackup result = backupService.createManualBackup(..., realName);
    return Result.success(result);
}

@PostMapping("/{id}/restore")
public Result<SysRestore> restoreDatabase(@PathVariable Long id) {
    String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
    SysRestore result = backupService.restoreDatabase(id, realName);
    return Result.success(result);
}
```

### 2. CulturalRelicController.java ✅

#### 问题代码
```java
// 问题1：saveWithImage() 方法
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
String uploaderName = authentication != null ? authentication.getName() : "系统"; // ❌ 获取用户名
Long uploaderId = 1L; // ❌ 硬编码ID

// 问题2：uploadImage() 方法
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
String uploaderName = authentication != null ? authentication.getName() : "系统"; // ❌ 获取用户名
Long uploaderId = 1L; // ❌ 硬编码ID

// 问题3：delete() 方法
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
String username = authentication != null ? authentication.getName() : "系统"; // ❌ 获取用户名
Long userId = 1L; // ❌ 硬编码ID
```

#### 修复后
```java
// 修复1：saveWithImage() 方法
String uploaderName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
Long uploaderId = userContextUtil.getCurrentUserId(); // ✅ 获取真实ID

// 修复2：uploadImage() 方法
String uploaderName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
Long uploaderId = userContextUtil.getCurrentUserId(); // ✅ 获取真实ID

// 修复3：delete() 方法
String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
Long userId = userContextUtil.getCurrentUserId(); // ✅ 获取真实ID
```

### 3. SysUserController.java ✅

#### 问题代码
```java
// 问题1：update() 方法
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
String username = authentication != null ? authentication.getName() : "系统"; // ❌ 获取用户名
Long operatorId = 1L; // ❌ 硬编码ID

// 问题2：delete() 方法
Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
String username = authentication != null ? authentication.getName() : "系统"; // ❌ 获取用户名
Long userId = 1L; // ❌ 硬编码ID
```

#### 修复后
```java
// 修复1：update() 方法
String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
Long operatorId = userContextUtil.getCurrentUserId(); // ✅ 获取真实ID

// 修复2：delete() 方法
String realName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
Long userId = userContextUtil.getCurrentUserId(); // ✅ 获取真实ID
```

### 4. RelicImageRelationController.java ✅

#### 问题代码
```java
@PostMapping("/upload/{relicId}")
public Result<String> uploadRelicImage(@PathVariable Long relicId, @RequestParam("file") MultipartFile file) {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    String uploaderName = authentication != null ? authentication.getName() : "系统"; // ❌ 获取用户名
    Long uploaderId = 1L; // ❌ 硬编码ID
    
    String imagePath = relicImageRelationService.uploadAndSetRelicMainImage(
            relicId, file, uploaderId, uploaderName);
    return Result.success("上传成功", imagePath);
}
```

#### 修复后
```java
@PostMapping("/upload/{relicId}")
public Result<String> uploadRelicImage(@PathVariable Long relicId, @RequestParam("file") MultipartFile file) {
    String uploaderName = userContextUtil.getCurrentUserRealName(); // ✅ 获取真实姓名
    Long uploaderId = userContextUtil.getCurrentUserId(); // ✅ 获取真实ID
    
    String imagePath = relicImageRelationService.uploadAndSetRelicMainImage(
            relicId, file, uploaderId, uploaderName);
    return Result.success("上传成功", imagePath);
}
```

## 未修复的情况（合理使用）

以下情况使用 `authentication.getName()` 是合理的，因为业务逻辑需要用户名而不是真实姓名：

### 1. LoanRecordController.java ✅ 合理
```java
// 查询当前用户的借展记录 - 需要用户名作为查询条件
@GetMapping("/my")
public Result<PageResult<LoanRecord>> myLoans(...) {
    String username = SecurityContextHolder.getContext().getAuthentication().getName();
    return Result.success(loanRecordService.pageMyLoans(pageNum, pageSize, status, username));
}

// 用户归还文物 - 需要用户名验证权限
@PutMapping("/{id}/user-return")
public Result<Boolean> userReturnLoan(@PathVariable Long id, ...) {
    String username = SecurityContextHolder.getContext().getAuthentication().getName();
    boolean success = loanRecordService.userReturnLoan(id, username);
    return Result.success("归还申请已提交", success);
}
```

### 2. ImageLibraryController.java ✅ 合理
```java
// 上传图片 - 需要用户名作为上传者标识
@PostMapping("/upload")
public Result<ImageLibrary> uploadImage(...) {
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    String username = auth.getName();
    ImageLibrary image = imageLibraryService.uploadImage(file, ..., username);
    return Result.success("上传成功", image);
}
```

**说明**：这些方法中使用用户名是因为：
1. Service 层的方法参数需要用户名（username）而不是真实姓名
2. 用户名用于数据库查询和权限验证
3. 这些操作不涉及审计日志记录

## 修复统计

| 文件 | 修复数量 | 问题类型 |
|------|----------|----------|
| BackupController.java | 2处 | 硬编码 "admin" |
| CulturalRelicController.java | 3处 | 硬编码 ID 和用户名 |
| SysUserController.java | 2处 | 硬编码 ID 和用户名 |
| RelicImageRelationController.java | 1处 | 硬编码 ID 和用户名 |
| **总计** | **8处** | - |

## UserContextUtil 工具类

### 核心方法

```java
@Component
public class UserContextUtil {
    
    private final SysUserMapper userMapper;
    
    /**
     * 获取当前登录用户的真实姓名
     * 如果获取失败，返回用户名
     * 如果用户未登录，返回"系统"
     */
    public String getCurrentUserRealName() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() 
                || "anonymousUser".equals(authentication.getPrincipal())) {
                return "系统";
            }
            
            String username = authentication.getName();
            SysUser user = userMapper.selectByUsername(username);
            
            if (user != null && user.getRealName() != null && !user.getRealName().isEmpty()) {
                return user.getRealName();
            }
            
            return username;
        } catch (Exception e) {
            return "系统";
        }
    }
    
    /**
     * 获取当前登录用户的用户名
     */
    public String getCurrentUsername() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() 
                || "anonymousUser".equals(authentication.getPrincipal())) {
                return "系统";
            }
            return authentication.getName();
        } catch (Exception e) {
            return "系统";
        }
    }
    
    /**
     * 获取当前登录用户的ID
     */
    public Long getCurrentUserId() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() 
                || "anonymousUser".equals(authentication.getPrincipal())) {
                return null;
            }
            
            String username = authentication.getName();
            SysUser user = userMapper.selectByUsername(username);
            
            return user != null ? user.getId() : null;
        } catch (Exception e) {
            return null;
        }
    }
    
    /**
     * 获取当前登录用户的完整信息
     */
    public SysUser getCurrentUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() 
                || "anonymousUser".equals(authentication.getPrincipal())) {
                return null;
            }
            
            String username = authentication.getName();
            return userMapper.selectByUsername(username);
        } catch (Exception e) {
            return null;
        }
    }
}
```

### 使用场景

| 方法 | 使用场景 | 返回值 |
|------|----------|--------|
| getCurrentUserRealName() | 审计日志、操作记录、显示操作人 | 真实姓名（如"张三"） |
| getCurrentUsername() | 数据查询、权限验证 | 用户名（如"zhangsan"） |
| getCurrentUserId() | 数据关联、外键引用 | 用户ID（如123L） |
| getCurrentUser() | 需要完整用户信息 | SysUser对象 |

## 测试建议

### 1. 功能测试
```
测试步骤：
1. 使用不同用户登录系统
2. 执行各种操作（创建、修改、删除）
3. 检查操作记录和审计日志
4. 验证显示的是真实姓名而不是用户名或"admin"

测试用例：
- 用户A（真实姓名：张三）创建备份 → 创建人应显示"张三"
- 用户B（真实姓名：李四）上传图片 → 上传者应显示"李四"
- 用户C（真实姓名：王五）删除文物 → 操作人应显示"王五"
```

### 2. 边界测试
```
测试场景：
1. 用户没有设置真实姓名 → 应显示用户名
2. 用户未登录 → 应显示"系统"
3. 认证信息异常 → 应显示"系统"
```

### 3. 审计日志验证
```sql
-- 查询最近的审计日志
SELECT 
    operator_name,  -- 应该是真实姓名
    operation_type,
    operation_module,
    operation_time
FROM sys_operation_log
ORDER BY operation_time DESC
LIMIT 20;

-- 查询备份记录
SELECT 
    backup_name,
    created_by,  -- 应该是真实姓名
    created_time
FROM sys_backup
ORDER BY created_time DESC;
```

## 影响范围

### 直接影响
1. **审计日志**：所有操作日志现在显示真实姓名
2. **备份记录**：创建人和恢复人显示真实姓名
3. **文物管理**：上传者和操作人显示真实姓名
4. **用户管理**：操作人显示真实姓名
5. **图片管理**：上传者显示真实姓名

### 间接影响
1. **可追溯性提升**：更容易追踪谁执行了什么操作
2. **用户体验改善**：界面显示更友好的真实姓名
3. **合规性增强**：审计日志更符合规范要求

## 注意事项

### 1. 依赖注入
所有需要使用 `UserContextUtil` 的 Controller 都必须注入该工具类：

```java
@RestController
public class SomeController {
    
    @Autowired
    private com.example.util.UserContextUtil userContextUtil;
    
    // 或者使用构造函数注入
    public SomeController(com.example.util.UserContextUtil userContextUtil) {
        this.userContextUtil = userContextUtil;
    }
}
```

### 2. 异常处理
`UserContextUtil` 的所有方法都已内置异常处理，不会抛出异常：
- 如果获取失败，返回默认值（"系统" 或 null）
- 调用方无需额外的 try-catch

### 3. 性能考虑
- 每次调用都会查询数据库获取用户信息
- 如果性能敏感，可以考虑添加缓存
- 对于高频操作，可以在方法开始时获取一次，然后重复使用

### 4. 数据一致性
- 确保所有用户都设置了真实姓名（real_name）
- 如果没有设置，会回退到用户名（username）

## 总结

通过本次修复，项目中所有硬编码用户信息的问题都已解决：

✅ **修复完成**：8处硬编码问题
✅ **统一使用**：UserContextUtil 工具类
✅ **提升质量**：审计日志和操作记录更准确
✅ **改善体验**：显示真实姓名更友好
✅ **增强合规**：符合审计规范要求

所有修改已通过编译检查，无语法错误。建议进行完整的功能测试以验证修复效果。

## 相关文档

- `docs/BACKUP_CREATOR_FIX.md` - 备份创建人修复详情
- `docs/BACKUP_SYSTEM_GUIDE.md` - 备份系统使用指南
- `backend/src/main/java/com/example/util/UserContextUtil.java` - 工具类源码

---

**修复日期**：2026-05-09  
**修复人员**：Kiro AI Assistant  
**审核状态**：待测试验证
