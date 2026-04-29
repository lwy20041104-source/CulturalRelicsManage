# 🔧 修复申请审批员菜单问题

## 🐛 问题描述

审批员登录后，菜单显示：
- ✅ 首页
- ✅ 数据大屏
- ✅ 数据报表
- ❌ **档案管理**（不应该显示）
- ✅ 借展管理
- ❌ **缺少：维护记录**
- ❌ **缺少：修复管理**
- ✅ AI搜索

## 🎯 期望结果

审批员应该看到：
- ✅ 首页
- ✅ 数据大屏
- ✅ 数据报表
- ✅ 借展管理
- ✅ **维护记录**（维护审批管理）
- ✅ **修复管理**（文物修复审批管理）
- ✅ AI搜索

## 🔍 问题原因

APPROVER角色缺少以下权限：
- `maintenance:manage` (权限ID: 5) - 维护管理
- `repairs:manage` (权限ID: 14) - 修复管理

## ⚡ 快速修复

### 执行SQL脚本

```bash
cd backend
mysql -u root -p cultural_relics < sql/fix_approver_permissions.sql
```

### 脚本功能

1. ✅ 更新角色名称：从"借展审批员"改为"申请审批员"
2. ✅ 添加维护管理权限 (permission_id: 5)
3. ✅ 添加修复管理权限 (permission_id: 14)
4. ✅ 添加通知查看权限 (permission_id: 23)
5. ✅ 删除档案管理权限（如果存在）
6. ✅ 显示最终权限列表

## 🧪 验证步骤

### 1. 执行SQL脚本

```bash
cd backend
mysql -u root -p cultural_relics < sql/fix_approver_permissions.sql
```

**预期输出**：
```
=== APPROVER角色权限列表 ===

角色名称    | 角色代码  | 权限ID | 权限名称    | 权限代码            | 权限类型 | 路径
----------|----------|--------|------------|-------------------|---------|-------------
申请审批员  | APPROVER | 1      | 看板查看    | dashboard:view     | MENU    | /dashboard
申请审批员  | APPROVER | 4      | 借展管理    | loans:manage       | MENU    | /loans
申请审批员  | APPROVER | 5      | 维护管理    | maintenance:manage | MENU    | /maintenance
申请审批员  | APPROVER | 14     | 修复管理    | repairs:manage     | MENU    | /repairs
申请审批员  | APPROVER | 23     | 通知查看    | notifications:view | API     | /notifications
```

### 2. 重启后端服务（如果正在运行）

```bash
# 如果后端正在运行，需要重启以刷新权限缓存
# Ctrl+C 停止后端
cd backend
mvn spring-boot:run
```

### 3. 清除浏览器缓存并重新登录

**重要！** 必须清除浏览器缓存或使用无痕模式：

1. 打开浏览器开发者工具 (F12)
2. 右键点击刷新按钮
3. 选择"清空缓存并硬性重新加载"

或者：

1. 打开无痕窗口 (Ctrl+Shift+N)
2. 访问系统登录页面

### 4. 登录审批员账号

- 用户名: `approver01`
- 密码: `123456`

### 5. 检查菜单

**应该看到**：
- ✅ 首页
- ✅ 数据大屏
- ✅ 数据报表
- ✅ 借展管理
- ✅ **维护记录**
- ✅ **修复管理**
- ✅ AI搜索

**不应该看到**：
- ❌ 档案管理
- ❌ 员工管理
- ❌ 文物管理
- ❌ 分类管理

### 6. 测试审批功能

#### 测试维护审批
1. 用保管员账号(`curator01`)登录，提交维护申请
2. 退出，用审批员账号登录
3. 进入"维护记录"
4. 应该看到待审批的申请
5. 点击"审批"按钮，可以通过/拒绝

#### 测试修复审批
1. 用保管员账号登录，提交修复申请
2. 退出，用审批员账号登录
3. 进入"修复管理"
4. 应该看到待审批的申请
5. 点击"审批"按钮，可以通过/拒绝

## 🔧 手动修复（如果脚本失败）

如果自动脚本失败，可以手动执行以下SQL：

```sql
USE cultural_relics;

-- 1. 更新角色名称
UPDATE sys_role 
SET role_name = '申请审批员', 
    description = '负责借展、修复、维护申请的审批'
WHERE role_code = 'APPROVER';

-- 2. 获取角色ID
SET @approver_role_id = (SELECT id FROM sys_role WHERE role_code = 'APPROVER');

-- 3. 添加权限
INSERT IGNORE INTO sys_role_permission (role_id, permission_id, create_time)
VALUES 
    (@approver_role_id, 1, NOW()),   -- 看板查看
    (@approver_role_id, 4, NOW()),   -- 借展管理
    (@approver_role_id, 5, NOW()),   -- 维护管理
    (@approver_role_id, 14, NOW()),  -- 修复管理
    (@approver_role_id, 23, NOW());  -- 通知查看

-- 4. 删除档案权限
DELETE FROM sys_role_permission 
WHERE role_id = @approver_role_id 
  AND permission_id IN (
    SELECT id FROM sys_permission 
    WHERE permission_code IN ('archives:manage', 'archives:view')
  );

-- 5. 验证结果
SELECT 
    r.role_name AS '角色名称',
    p.permission_name AS '权限名称',
    p.permission_code AS '权限代码'
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'APPROVER'
ORDER BY p.id;
```

## ❓ 常见问题

### Q1: 执行脚本后菜单还是不对？

**A**: 需要清除浏览器缓存或使用无痕模式重新登录。权限信息可能被缓存在浏览器中。

### Q2: 提示"权限不足"？

**A**: 确保：
1. SQL脚本执行成功
2. 后端服务已重启
3. 浏览器缓存已清除
4. 使用正确的审批员账号登录

### Q3: 菜单显示了但点击报错？

**A**: 检查后端Controller中的权限注解：
- `MaintenanceRecordController` 应该有 `@PreAuthorize("hasAnyRole('ADMIN', 'APPROVER')")`
- `RepairRecordController` 应该有 `@PreAuthorize("hasAnyRole('ADMIN', 'APPROVER')")`

### Q4: 如何确认权限已正确配置？

**A**: 执行以下SQL查询：

```sql
SELECT 
    r.role_name,
    p.permission_name,
    p.permission_code
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'APPROVER'
ORDER BY p.id;
```

应该看到5条记录：
1. dashboard:view
2. loans:manage
3. maintenance:manage
4. repairs:manage
5. notifications:view

## 📊 权限配置对比

### 修复前

| 权限ID | 权限代码 | 权限名称 | 状态 |
|--------|---------|---------|------|
| 1 | dashboard:view | 看板查看 | ✅ 有 |
| 4 | loans:manage | 借展管理 | ✅ 有 |
| 5 | maintenance:manage | 维护管理 | ❌ **缺少** |
| 14 | repairs:manage | 修复管理 | ❌ **缺少** |
| 23 | notifications:view | 通知查看 | ✅ 有 |

### 修复后

| 权限ID | 权限代码 | 权限名称 | 状态 |
|--------|---------|---------|------|
| 1 | dashboard:view | 看板查看 | ✅ 有 |
| 4 | loans:manage | 借展管理 | ✅ 有 |
| 5 | maintenance:manage | 维护管理 | ✅ **已添加** |
| 14 | repairs:manage | 修复管理 | ✅ **已添加** |
| 23 | notifications:view | 通知查看 | ✅ 有 |

## 🎉 完成

执行脚本后，审批员菜单应该显示正确！

---

**需要帮助？** 查看详细文档：
- `APPROVER_MENU_CONFIGURATION_COMPLETE.md` - 完整配置文档
- `backend/sql/fix_approver_permissions.sql` - SQL修复脚本
