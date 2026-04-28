# 保管员用户ID获取问题修复

## 问题描述

**现象**：文物保管员登录后，在"申请修复"界面看到的不是自己的修复记录，而是其他用户（admin）的记录。

**截图显示**：
- 文物名称：古代文物编、明清瓷瓶
- 申请人：黎明01（但实际登录的是保管员）

## 根本原因

在 `UserContextUtil.java` 中，`getCurrentUserId()` 方法返回的是**硬编码的值 `1L`**（admin 的用户ID），而不是当前登录用户的真实ID。

### 问题代码

```java
public Long getCurrentUserId() {
    // TODO: 从authentication中获取真实用户ID
    return 1L;  // ❌ 硬编码返回1，导致所有用户都被识别为admin
}
```

### 影响范围

这个问题影响了所有需要获取当前用户ID的功能：
1. **修复记录过滤**：保管员看到的是 admin 的记录
2. **权限检查**：保管员可能无法正确访问自己的记录
3. **审计日志**：所有操作都记录为 user_id=1
4. **通知发送**：可能发送给错误的用户

## 解决方案

### 修复代码

**文件**：`backend/src/main/java/com/example/util/UserContextUtil.java`

```java
/**
 * 获取当前登录用户的ID
 */
public Long getCurrentUserId() {
    try {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
            return null;
        }
        
        String username = authentication.getName();
        SysUser user = userMapper.selectByUsername(username);
        
        return user != null ? user.getId() : null;
    } catch (Exception e) {
        System.err.println("获取当前用户ID失败: " + e.getMessage());
        return null;
    }
}
```

### 修复逻辑

1. 从 Spring Security 的 `SecurityContextHolder` 获取当前认证信息
2. 提取用户名（username）
3. 通过 `userMapper.selectByUsername()` 查询用户信息
4. 返回用户的真实 ID

## 验证步骤

### 1. 重启后端服务

```bash
cd backend
mvn spring-boot:run
```

### 2. 测试保管员登录

**测试账号**：
- 用户名：curator01（或其他保管员账号）
- 密码：123456

**预期结果**：
- 保管员只能看到自己申请的修复记录
- 如果保管员没有申请过修复，列表应该为空

### 3. 测试管理员登录

**测试账号**：
- 用户名：admin
- 密码：123456

**预期结果**：
- 管理员可以看到所有用户的修复记录

### 4. 查看后端日志

后端会输出详细的调试信息：

```
========== 修复记录查询请求 ==========
当前用户: curator01
用户权限: ROLE_CURATOR
是否是管理员: false
保管员权限过滤：只显示申请人ID=2的记录
查询结果: total=X, records.size=X
```

## 数据库验证

执行诊断SQL脚本：

```bash
mysql -u root -p cultural_relics_management < backend/sql/diagnose_curator_records.sql
```

这个脚本会显示：
1. 所有用户及其角色
2. 所有修复记录及其申请人
3. 保管员的修复记录统计
4. applicant_id 为 NULL 的记录
5. applicant 字段匹配检查

## 相关修复

### 1. 权限检查修复（已完成）

**文件**：`RepairRecordController.java`

- 将权限检查从 `repairs:manage` 改为 `ROLE_ADMIN`
- 管理员可以查看所有记录
- 保管员只能查看自己的记录

### 2. 用户ID获取修复（本次修复）

**文件**：`UserContextUtil.java`

- 从硬编码 `1L` 改为动态获取当前用户ID
- 确保每个用户看到自己的数据

## 测试场景

### 场景1：保管员查看修复记录

1. 使用保管员账号登录（curator01）
2. 进入"申请修复"菜单
3. **预期**：只显示 curator01 申请的记录
4. **验证**：申请人列显示的应该是当前登录用户的姓名

### 场景2：保管员申请新修复

1. 点击"申请修复"按钮
2. 填写修复信息并提交
3. **预期**：新记录的 applicant_id 应该是当前保管员的 user_id
4. **验证**：刷新列表，新记录应该出现在列表中

### 场景3：保管员删除记录

1. 选择一条"已拒绝"状态的记录
2. 点击"删除"按钮
3. **预期**：只能删除自己的记录
4. **验证**：尝试通过API删除其他用户的记录应该返回"无权删除此记录"

### 场景4：管理员查看所有记录

1. 使用管理员账号登录（admin）
2. 进入"修复管理"菜单
3. **预期**：显示所有用户的修复记录
4. **验证**：申请人列应该显示不同用户的姓名

## 编译状态

✅ **BUILD SUCCESS**

```
[INFO] Building Cultural Relics Management System 1.0.0
[INFO] Compiling 177 source files
[INFO] BUILD SUCCESS
[INFO] Total time: 14.668 s
```

## 相关文件

- `backend/src/main/java/com/example/util/UserContextUtil.java` - 用户上下文工具类（已修复）
- `backend/src/main/java/com/example/controller/RepairRecordController.java` - 修复记录控制器（已修复）
- `backend/sql/diagnose_curator_records.sql` - 诊断SQL脚本（新增）
- `REPAIR_PERMISSIONS_COMPLETE.md` - 权限系统完善说明

## 注意事项

1. **必须重启后端服务**才能生效
2. 如果数据库中的 `applicant_id` 为 NULL，需要手动修复数据
3. 确保所有保管员用户的 `role_id = 2`（CURATOR角色）
4. 测试时使用不同的浏览器或无痕模式，避免 token 缓存问题

## 下一步

1. ✅ 修复 `UserContextUtil.getCurrentUserId()` 方法
2. ✅ 编译后端代码
3. ⏳ 重启后端服务
4. ⏳ 测试保管员登录和记录过滤
5. ⏳ 测试管理员登录和全部记录查看
6. ⏳ 验证权限检查是否正确
