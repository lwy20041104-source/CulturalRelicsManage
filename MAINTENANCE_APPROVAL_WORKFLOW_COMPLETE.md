# 维护记录审批流程实现完成

## 概述
成功将维护记录功能改造为审批流程，包括数据库迁移、后端权限控制、审批接口和前端界面更新。

## 实现内容

### 1. 数据库改造
**文件**: `backend/sql/alter_maintenance_record_add_approval.sql`

- 将 `maintainer` 字段改为 `maintainer_id`（关联用户表）
- 添加审批相关字段：
  - `status` VARCHAR(20) - 状态（待审批、已通过、已拒绝）
  - `approver` VARCHAR(50) - 审批人
  - `approve_date` DATETIME - 审批时间
  - `approve_remark` TEXT - 审批备注

### 2. 后端实现

#### 2.1 实体类更新
**文件**: `backend/src/main/java/com/example/entity/MaintenanceRecord.java`

添加字段：
- `maintainerId` - 维护人ID
- `maintainerName` - 维护人姓名（关联查询）
- `status` - 状态
- `approver` - 审批人
- `approveDate` - 审批时间
- `approveRemark` - 审批备注

#### 2.2 Mapper 层更新
**文件**: 
- `backend/src/main/resources/mapper/MaintenanceRecordMapper.xml`
- `backend/src/main/java/com/example/mapper/MaintenanceRecordMapper.java`

功能：
- 支持按状态筛选
- 支持按维护人ID过滤（权限控制）
- 关联用户表查询维护人姓名

#### 2.3 Service 层更新
**文件**:
- `backend/src/main/java/com/example/service/MaintenanceRecordService.java`
- `backend/src/main/java/com/example/service/impl/MaintenanceRecordServiceImpl.java`

功能：
- `pageRecords` 方法支持状态和维护人ID过滤

#### 2.4 Controller 层更新
**文件**: `backend/src/main/java/com/example/controller/MaintenanceRecordController.java`

**权限控制**：
- 管理员（ADMIN）：可以查看所有维护记录
- 保管员（CURATOR）：只能查看自己的维护记录

**接口功能**：

1. **GET /maintenance** - 分页查询
   - 支持状态筛选
   - 自动根据角色过滤数据

2. **POST /maintenance** - 提交维护申请
   - 自动设置维护人ID为当前用户
   - 初始状态为"待审批"
   - 发送通知给管理员

3. **PUT /maintenance** - 更新维护申请
   - 只能修改自己的申请
   - 只能修改待审批状态的申请
   - 验证维护日期

4. **DELETE /maintenance/{id}** - 撤回维护申请
   - 只能删除自己的记录
   - 如果是待审批状态，发送撤回通知给管理员

5. **PUT /maintenance/approve** - 审批维护申请（新增）
   - 只能审批待审批状态的申请
   - 设置审批人、审批时间
   - 发送审批结果通知给申请人

#### 2.5 通知服务更新
**文件**:
- `backend/src/main/java/com/example/service/NotificationService.java`
- `backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

**新增通知方法**：

1. **sendMaintenanceApplyNotification** - 维护申请通知
   - 发送给：系统管理员
   - 触发时机：提交维护申请时

2. **sendMaintenanceApprovalNotification** - 审批结果通知
   - 发送给：申请人
   - 触发时机：管理员审批后
   - 内容：通过/拒绝

3. **sendMaintenanceWithdrawNotification** - 撤回申请通知
   - 发送给：系统管理员
   - 触发时机：保管员撤回待审批的申请

### 3. 前端实现

#### 3.1 API 更新
**文件**: `frontend/src/api/maintenance.js`

新增接口：
```javascript
export const approveMaintenanceApi = (data) => request.put('/maintenance/approve', data)
```

#### 3.2 界面更新
**文件**: `frontend/src/views/MaintenanceView.vue`

**功能改造**：

1. **工具栏**：
   - 保管员：显示"新增维护"按钮
   - 管理员：不显示新增按钮
   - 添加状态筛选下拉框（待审批、已通过、已拒绝）

2. **表格列**：
   - 添加"状态"列，显示彩色标签
   - 维护人列显示真实姓名
   - 操作列根据角色和状态动态显示按钮

3. **操作按钮**：
   - **保管员**：
     - 详情（所有状态）
     - 编辑（仅待审批）
     - 撤回（仅待审批）
   - **管理员**：
     - 详情（所有状态）
     - 审批（仅待审批）

4. **新增/编辑对话框**：
   - 移除"维护人"输入框（自动使用当前用户）
   - 保留其他字段

5. **审批对话框**（新增）：
   - 显示文物名称、维护类型、维护内容（只读）
   - 审批结果：通过/拒绝（单选）
   - 审批备注：文本框（拒绝时必填）

6. **详情对话框**：
   - 添加状态、审批人、审批时间、审批备注字段

## 权限控制总结

| 角色 | 查看权限 | 新增 | 编辑 | 撤回 | 审批 |
|------|---------|------|------|------|------|
| 系统管理员 | 所有记录 | ❌ | ❌ | ❌ | ✅ |
| 文物保管员 | 自己的记录 | ✅ | ✅（待审批） | ✅（待审批） | ❌ |

## 状态流转

```
待审批 → 已通过（管理员审批通过）
待审批 → 已拒绝（管理员审批拒绝）
待审批 → 删除（保管员撤回）
```

## 消息通知

| 操作 | 通知对象 | 通知类型 |
|------|---------|---------|
| 提交维护申请 | 系统管理员 | MAINTENANCE_APPLY |
| 审批通过 | 申请人 | MAINTENANCE_APPROVED |
| 审批拒绝 | 申请人 | MAINTENANCE_REJECTED |
| 撤回申请 | 系统管理员 | MAINTENANCE_WITHDRAW |

## 测试建议

### 1. 数据库测试
```sql
-- 执行迁移脚本
source backend/sql/migrate_maintenance_record_maintainer.sql;
source backend/sql/alter_maintenance_record_add_approval.sql;

-- 验证表结构
DESC maintenance_record;

-- 检查数据迁移
SELECT id, maintainer_id, status FROM maintenance_record;
```

### 2. 后端测试

**保管员测试**：
1. 登录保管员账号
2. 提交维护申请 → 检查状态为"待审批"
3. 查看维护列表 → 只能看到自己的记录
4. 编辑待审批的申请 → 成功
5. 尝试编辑已通过的申请 → 失败
6. 撤回待审批的申请 → 成功

**管理员测试**：
1. 登录管理员账号
2. 查看维护列表 → 可以看到所有记录
3. 审批待审批的申请（通过） → 成功
4. 审批待审批的申请（拒绝） → 成功
5. 尝试审批已通过的申请 → 失败

### 3. 前端测试

**保管员界面**：
1. 检查工具栏显示"新增维护"按钮和状态筛选
2. 检查表格只显示自己的记录
3. 检查待审批记录显示"编辑"和"撤回"按钮
4. 检查已通过/已拒绝记录只显示"详情"按钮
5. 测试新增维护申请
6. 测试编辑待审批申请
7. 测试撤回待审批申请

**管理员界面**：
1. 检查工具栏不显示"新增维护"按钮
2. 检查表格显示所有记录
3. 检查待审批记录显示"审批"按钮
4. 测试审批通过
5. 测试审批拒绝（检查备注必填）
6. 检查详情对话框显示审批信息

### 4. 通知测试
1. 保管员提交申请 → 管理员收到通知
2. 管理员审批通过 → 保管员收到通知
3. 管理员审批拒绝 → 保管员收到通知
4. 保管员撤回申请 → 管理员收到通知

## 注意事项

1. **数据迁移**：执行迁移脚本前请备份数据库
2. **权限验证**：确保 Spring Security 配置正确
3. **前端角色判断**：依赖 `userStore.roles` 包含 'ADMIN'
4. **通知服务**：确保 NotificationService 已正确注入
5. **审计日志**：所有操作都会记录审计日志

## 文件清单

### 数据库
- `backend/sql/migrate_maintenance_record_maintainer.sql`
- `backend/sql/alter_maintenance_record_add_approval.sql`

### 后端
- `backend/src/main/java/com/example/entity/MaintenanceRecord.java`
- `backend/src/main/resources/mapper/MaintenanceRecordMapper.xml`
- `backend/src/main/java/com/example/mapper/MaintenanceRecordMapper.java`
- `backend/src/main/java/com/example/service/MaintenanceRecordService.java`
- `backend/src/main/java/com/example/service/impl/MaintenanceRecordServiceImpl.java`
- `backend/src/main/java/com/example/controller/MaintenanceRecordController.java`
- `backend/src/main/java/com/example/service/NotificationService.java`
- `backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

### 前端
- `frontend/src/api/maintenance.js`
- `frontend/src/views/MaintenanceView.vue`

## 完成状态

✅ 数据库迁移脚本
✅ 后端实体类更新
✅ 后端 Mapper 层更新
✅ 后端 Service 层更新
✅ 后端 Controller 层更新（权限控制 + 审批接口）
✅ 通知服务更新（3个新通知方法）
✅ 前端 API 更新
✅ 前端界面更新（审批流程 + 权限控制）

## 下一步

建议按照测试建议进行完整的功能测试，确保：
1. 数据库迁移成功
2. 权限控制正确
3. 审批流程完整
4. 通知功能正常
5. 前端界面显示正确
