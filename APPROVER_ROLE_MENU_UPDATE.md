# 申请审批员菜单配置完成

## 📋 任务概述

将"借展审批员"角色升级为"申请审批员"，调整菜单显示：
- ❌ 删除：档案管理
- ✅ 保留：借展管理
- ✅ 添加：维护审批管理
- ✅ 添加：文物修复审批管理

## 🎯 实施内容

### 1. 数据库更新

**文件**: `backend/sql/update_approver_role.sql`

```sql
-- 更新角色名称
UPDATE sys_role 
SET 
    role_name = '申请审批员',
    description = '负责借展、修复、维护申请的审批'
WHERE role_code = 'APPROVER';
```

**执行方式**:
```bash
mysql -u root -p cultural_relics < backend/sql/update_approver_role.sql
```

### 2. 菜单显示逻辑

**文件**: `frontend/src/views/LayoutView.vue`

菜单项通过权限控制显示，APPROVER角色的菜单配置：

| 菜单项 | 权限要求 | 路由 | 显示状态 |
|--------|---------|------|---------|
| 首页 | 无 | `/dashboard` | ✅ 显示 |
| 数据大屏 | 无 | `/data-screen` | ✅ 显示 |
| 统计报表 | 无 | `/reports` | ✅ 显示 |
| 借展管理 | `loans:manage` | `/loans` | ✅ 显示 |
| 维护审批管理 | `maintenance:manage` | `/maintenance` | ✅ 显示 |
| 文物修复审批管理 | `repairs:manage` | `/repairs` | ✅ 显示 |
| AI智能查询 | 无 | `/ai-query` | ✅ 显示 |
| 档案管理 | `archives:manage` 或 `archives:view` | `/archives` | ❌ 不显示 |

### 3. 权限配置

APPROVER角色的权限在后端Controller中通过注解控制：

#### 借展管理
```java
@PreAuthorize("hasAnyRole('ADMIN', 'APPROVER')")
public Result approve(@PathVariable Long id, ...)
```

#### 维护管理
```java
@PreAuthorize("hasAnyRole('ADMIN', 'APPROVER')")
public Result approve(@PathVariable Long id, ...)
```

#### 修复管理
```java
@PreAuthorize("hasAnyRole('ADMIN', 'APPROVER')")
public Result approve(@PathVariable Long id, ...)
```

## 🔐 权限矩阵

### 申请审批员(APPROVER)权限

| 功能模块 | 查看 | 审批 | 编辑 | 删除 | 说明 |
|---------|------|------|------|------|------|
| 借展申请 | ✅ | ✅ | ❌ | ❌ | 可查看和审批所有借展申请 |
| 维护申请 | ✅ | ✅ | ❌ | ❌ | 可查看和审批所有维护申请 |
| 修复申请 | ✅ | ✅ | ❌ | ❌ | 可查看和审批所有修复申请 |
| 档案管理 | ❌ | ❌ | ❌ | ❌ | 无权限访问 |
| 文物管理 | ❌ | ❌ | ❌ | ❌ | 无权限访问 |
| 用户管理 | ❌ | ❌ | ❌ | ❌ | 无权限访问 |

### 系统管理员(ADMIN)权限

| 功能模块 | 查看 | 审批 | 编辑 | 删除 | 说明 |
|---------|------|------|------|------|------|
| 所有模块 | ✅ | ✅ | ✅ | ✅ | 拥有所有权限 |

### 文物保管员(CURATOR)权限

| 功能模块 | 查看 | 审批 | 编辑 | 删除 | 说明 |
|---------|------|------|------|------|------|
| 借展申请 | ✅ | ❌ | ✅* | ❌ | 只能编辑自己的待审批申请 |
| 维护申请 | ✅ | ❌ | ✅* | ❌ | 只能编辑自己的待审批申请 |
| 修复申请 | ✅ | ❌ | ✅* | ❌ | 只能编辑自己的待审批申请 |
| 文物管理 | ✅ | ❌ | ✅ | ✅ | 可管理文物信息 |

*注：只能编辑和撤回自己提交的待审批申请

## 📱 前端按钮显示逻辑

### 维护管理页面 (`MaintenanceView.vue`)

```javascript
const isAdminOrApprover = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN' || role === 'APPROVER'
})

const isCurrentUserRecord = (record) => {
  const currentUserId = parseInt(sessionStorage.getItem('userId'))
  return record.maintainerId === currentUserId
}
```

**按钮显示规则**:
- **管理员/审批员**: 详情、审批（通过/拒绝）
- **保管员（自己的记录）**: 详情、编辑（待审批）、撤回（待审批）
- **保管员（他人的记录）**: 详情

### 修复管理页面 (`RepairsView.vue`)

同维护管理页面的逻辑。

### 借展管理页面 (`LoansView.vue`)

同维护管理页面的逻辑。

## 🔄 通知系统

所有申请提交后，系统会自动发送通知给：
- ✅ 系统管理员 (ADMIN)
- ✅ 申请审批员 (APPROVER)

通知类型：
1. **申请提交通知**: 保管员提交申请时
2. **审批结果通知**: 管理员/审批员审批后
3. **撤回通知**: 保管员撤回申请时

## 📝 测试步骤

### 1. 更新数据库
```bash
cd backend
mysql -u root -p cultural_relics < sql/update_approver_role.sql
```

### 2. 重启后端服务
```bash
cd backend
mvn clean package
java -jar target/cultural-relics-manage.jar
```

### 3. 测试审批员登录

**测试账号**:
- 用户名: `approver01`
- 密码: `123456`
- 角色: 申请审批员

**验证菜单**:
- ✅ 应该看到: 首页、数据大屏、统计报表、借展管理、维护审批管理、文物修复审批管理、AI智能查询
- ❌ 不应该看到: 档案管理、文物管理、用户管理、分类管理、图片管理

### 4. 测试审批功能

#### 测试维护申请审批
1. 用保管员账号(`curator01`)登录
2. 进入"维护管理"，提交一条维护申请
3. 退出，用审批员账号(`approver01`)登录
4. 进入"维护审批管理"
5. 应该看到待审批的申请
6. 点击"审批"按钮，选择"通过"或"拒绝"
7. 验证审批成功，状态更新

#### 测试修复申请审批
1. 用保管员账号登录
2. 进入"文物修复管理"，提交一条修复申请
3. 退出，用审批员账号登录
4. 进入"文物修复审批管理"
5. 应该看到待审批的申请
6. 点击"审批"按钮，选择"通过"或"拒绝"
7. 验证审批成功，状态更新

#### 测试借展申请审批
1. 用借展人账号(`loaner01`)登录前台
2. 提交借展申请
3. 退出，用审批员账号登录后台
4. 进入"借展管理"
5. 应该看到待审批的申请
6. 点击"审批"按钮，选择"通过"或"拒绝"
7. 验证审批成功，状态更新

### 5. 测试权限控制

#### 验证审批员不能编辑申请
1. 用审批员账号登录
2. 进入任意审批管理页面
3. 应该只看到"详情"和"审批"按钮
4. 不应该看到"编辑"和"撤回"按钮

#### 验证保管员不能审批
1. 用保管员账号登录
2. 进入维护管理或修复管理页面
3. 对于自己的待审批记录，应该看到"详情"、"编辑"、"撤回"按钮
4. 不应该看到"审批"按钮

## 🎉 完成状态

- ✅ 数据库角色名称更新
- ✅ 菜单权限配置正确
- ✅ 后端权限控制完善
- ✅ 前端按钮显示逻辑正确
- ✅ 通知系统集成完成
- ✅ 文档编写完成

## 📚 相关文件

### 后端文件
- `backend/sql/update_approver_role.sql` - 数据库更新脚本
- `backend/src/main/java/com/example/controller/MaintenanceRecordController.java` - 维护管理控制器
- `backend/src/main/java/com/example/controller/RepairRecordController.java` - 修复管理控制器
- `backend/src/main/java/com/example/controller/LoanRecordController.java` - 借展管理控制器

### 前端文件
- `frontend/src/views/LayoutView.vue` - 菜单布局组件
- `frontend/src/views/MaintenanceView.vue` - 维护管理页面
- `frontend/src/views/RepairsView.vue` - 修复管理页面
- `frontend/src/views/LoansView.vue` - 借展管理页面
- `frontend/src/router/index.js` - 路由配置

### 文档文件
- `APPROVER_ROLE_ENHANCEMENT_COMPLETE.md` - 审批员角色增强文档
- `APPROVER_ROLE_MENU_UPDATE.md` - 本文档

## 💡 注意事项

1. **权限控制**: 菜单显示由前端权限判断，实际访问权限由后端Controller注解控制
2. **角色判断**: 使用 `sessionStorage.getItem('role')` 获取当前用户角色
3. **按钮显示**: 使用 `computed` 属性实现响应式角色判断
4. **通知发送**: 所有申请通知会同时发送给ADMIN和APPROVER角色
5. **数据隔离**: 保管员只能编辑和撤回自己的待审批申请

## 🔗 相关文档

- [申请审批员角色增强完成](./APPROVER_ROLE_ENHANCEMENT_COMPLETE.md)
- [维护记录审批流程](./backend/docs/MAINTENANCE_APPROVAL_GUIDE.md)
- [修复记录审批流程](./backend/docs/REPAIR_APPROVAL_GUIDE.md)
- [通知系统实现](./backend/docs/NOTIFICATION_SYSTEM_IMPLEMENTATION.md)
