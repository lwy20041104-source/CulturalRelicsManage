# 修复管理权限系统完善说明

## 执行时间
2026-04-28

## 问题背景

1. **权限检查错误**：后端代码检查 `repairs:manage` 权限，但系统使用的是角色权限（`ROLE_ADMIN`、`ROLE_CURATOR`）
2. **权限数据不完整**：sys_permission 表缺少修复管理相关的完整权限定义
3. **角色权限分配不清晰**：各角色的权限分配需要明确

## 解决方案

### 1. 修复后端权限检查逻辑

**文件**: `backend/src/main/java/com/example/controller/RepairRecordController.java`

**修改内容**：
- 将权限检查从 `repairs:manage` 改为 `ROLE_ADMIN`
- 管理员（ADMIN）可以查看和操作所有修复记录
- 保管员（CURATOR）只能查看和操作自己申请的记录

**修改的方法**：
1. `page()` - 分页查询修复记录
2. `getById()` - 查询单条记录详情
3. `deleteById()` - 删除修复记录

### 2. 完善权限表数据

**文件**: `backend/sql/complete_repair_permissions.sql`

#### 新增权限（sys_permission）

| ID | 权限名称 | 权限代码 | 类型 | 路径 | 说明 |
|----|---------|---------|------|------|------|
| 14 | 修复管理 | repairs:manage | MENU | /repairs | 管理员修复管理菜单 |
| 15 | 修复审批 | repairs:approve | API | /repairs/approve | 审批修复申请 |
| 16 | 修复进度 | repairs:progress | API | /repairs/progress | 更新修复进度 |
| 17 | 修复完成 | repairs:complete | API | /repairs/complete | 完成修复 |
| 18 | 修复删除 | repairs:delete | API | /repairs/delete | 删除修复记录 |
| 19 | 修复统计 | repairs:statistics | API | /repairs/statistics | 修复统计数据 |
| 20 | 博物馆管理 | museums:manage | MENU | /museums | 博物馆管理 |
| 21 | 备份管理 | backups:manage | MENU | /backups | 数据备份管理 |
| 22 | AI对话管理 | ai-chat:manage | MENU | /ai-chat | AI对话管理 |
| 23 | 通知查看 | notifications:view | API | /notifications | 查看通知 |

#### 角色权限分配（sys_role_permission）

**ADMIN（系统管理员，role_id=1）**
- 拥有所有权限（permission_id: 1-23）
- 新增权限关联 id: 22-31

**CURATOR（文物保管员，role_id=2）**
- 原有权限：1,2,3,5,12,13
- 新增权限：18（修复删除-仅自己的），23（通知查看）
- 新增权限关联 id: 32-33

**APPROVER（借展审批员，role_id=3）**
- 原有权限：1,4,10
- 新增权限：23（通知查看）
- 新增权限关联 id: 34

**LOANER（文物借展人，role_id=4）**
- 新增权限：1（看板），2（文物查看），4（借展申请），23（通知查看）
- 新增权限关联 id: 35-38

## 权限设计说明

### 系统权限模型

系统采用**混合权限模型**：
1. **角色权限（Role-Based）**：Spring Security 使用 `ROLE_*` 格式
2. **功能权限（Permission-Based）**：数据库存储细粒度权限

### 权限检查策略

**后端代码层面**：
- 使用角色检查（`ROLE_ADMIN`、`ROLE_CURATOR` 等）
- 简单、高效、易维护

**数据库层面**：
- 存储细粒度权限（`repairs:manage`、`repairs:apply` 等）
- 便于权限管理和审计
- 为未来扩展预留空间

### 修复管理权限矩阵

| 操作 | ADMIN | CURATOR | 说明 |
|------|-------|---------|------|
| 查看所有记录 | ✅ | ❌ | CURATOR只能看自己的 |
| 查看自己的记录 | ✅ | ✅ | |
| 申请修复 | ✅ | ✅ | |
| 审批修复 | ✅ | ❌ | |
| 开始修复 | ✅ | ❌ | |
| 更新进度 | ✅ | ❌ | |
| 完成修复 | ✅ | ❌ | |
| 删除记录 | ✅ | ✅ | CURATOR只能删除自己的 |
| 撤回申请 | ✅ | ✅ | 待审批状态 |

## 执行步骤

### 1. 执行SQL脚本

```bash
mysql -u root -p cultural_relics_management < backend/sql/complete_repair_permissions.sql
```

### 2. 重启后端服务

```bash
cd backend
mvn spring-boot:run
```

### 3. 验证权限

**测试场景**：
1. 使用 admin 账号登录，应该能看到所有修复记录
2. 使用 curator 账号登录，只能看到自己申请的记录
3. curator 只能删除自己的已拒绝记录
4. curator 只能撤回自己的待审批记录

## 验证查询

```sql
-- 查看所有权限
SELECT id, permission_name, permission_code, permission_type 
FROM sys_permission 
ORDER BY id;

-- 查看ADMIN角色权限
SELECT p.permission_code, p.permission_name
FROM sys_role_permission rp
JOIN sys_permission p ON rp.permission_id = p.id
WHERE rp.role_id = 1
ORDER BY p.id;

-- 查看CURATOR角色权限
SELECT p.permission_code, p.permission_name
FROM sys_role_permission rp
JOIN sys_permission p ON rp.permission_id = p.id
WHERE rp.role_id = 2
ORDER BY p.id;
```

## 注意事项

1. **权限表ID连续性**：新增权限从 id=14 开始，角色权限关联从 id=22 开始
2. **ON DUPLICATE KEY UPDATE**：使用此语法避免重复插入
3. **后端代码已修改**：权限检查已从 `repairs:manage` 改为 `ROLE_ADMIN`
4. **编译状态**：后端已成功编译（BUILD SUCCESS）

## 相关文件

- `backend/sql/complete_repair_permissions.sql` - 权限数据完善脚本
- `backend/src/main/java/com/example/controller/RepairRecordController.java` - 修复后的控制器
- `backend/src/main/java/com/example/security/CustomUserDetailsService.java` - 用户权限加载服务

## 下一步

执行SQL脚本后，重启后端服务，然后进行以下测试：
1. 管理员登录测试
2. 保管员登录测试
3. 验证权限过滤是否正确
4. 验证操作权限是否正确
