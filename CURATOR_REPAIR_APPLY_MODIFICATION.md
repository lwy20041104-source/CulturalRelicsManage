# 文物保管员修复功能修改方案

## 📋 需求说明

### 当前状态
- 文物保管员（CURATOR）拥有 `repairs:manage` 权限
- 可以访问完整的修复管理功能（申请、审批、修复、完成等）
- 菜单中显示：修复管理、修复专家、修复材料

### 目标状态
- 文物保管员只能"申请修复"
- 不能审批、不能管理修复进度
- 菜单中只显示：申请修复
- 修复申请被审批/拒绝时接收通知

## 🎯 修改方案

### 1. 权限调整

#### 新增权限
```sql
-- 新增"申请修复"权限
INSERT INTO sys_permission (permission_name, permission_code, permission_type, path) VALUES
('申请修复', 'repairs:apply', 'MENU', '/repair-apply');
```

#### 角色权限调整
```sql
-- 移除CURATOR角色的 repairs:manage 权限
-- 添加CURATOR角色的 repairs:apply 权限

-- 假设：
-- role_id = 2 (CURATOR 文物保管员)
-- permission_id = X (repairs:apply 新权限)
```

### 2. 前端修改

#### 2.1 创建新视图：RepairApplyView.vue
- 只包含申请修复功能
- 显示自己申请的修复记录
- 可以查看申请状态
- 不能审批、不能修复

#### 2.2 修改路由配置（router/index.js）
```javascript
// 修改前
{ path: '/repairs', component: RepairsView, meta: { perm: 'repairs:manage' } }

// 修改后
{ path: '/repairs', component: RepairsView, meta: { perm: 'repairs:manage' } },
{ path: '/repair-apply', component: RepairApplyView, meta: { perm: 'repairs:apply' } }
```

#### 2.3 修改菜单配置（LayoutView.vue）
```vue
<!-- 修改前 -->
<el-menu-item v-if="hasPerm('repairs:manage')" index="/repairs">修复管理</el-menu-item>
<el-menu-item v-if="hasPerm('repairs:manage')" index="/experts">修复专家</el-menu-item>
<el-menu-item v-if="hasPerm('repairs:manage')" index="/repair-materials">修复材料</el-menu-item>

<!-- 修改后 -->
<el-menu-item v-if="hasPerm('repairs:manage')" index="/repairs">修复管理</el-menu-item>
<el-menu-item v-if="hasPerm('repairs:apply')" index="/repair-apply">申请修复</el-menu-item>
<el-menu-item v-if="hasPerm('repairs:manage')" index="/experts">修复专家</el-menu-item>
<el-menu-item v-if="hasPerm('repairs:manage')" index="/repair-materials">修复材料</el-menu-item>
```

#### 2.4 国际化配置
```javascript
// zh-CN.js
nav: {
  repairApply: '申请修复',
  // ...
}

// en-US.js
nav: {
  repairApply: 'Apply Repair',
  // ...
}
```

### 3. 后端修改

#### 3.1 权限检查
在 RepairRecordController 中添加权限检查：
- 申请修复：需要 `repairs:apply` 或 `repairs:manage`
- 审批修复：需要 `repairs:manage`
- 开始修复：需要 `repairs:manage`
- 更新进度：需要 `repairs:manage`
- 完成修复：需要 `repairs:manage`

#### 3.2 查询限制
保管员只能查看自己申请的修复记录：
```java
// 如果是 repairs:apply 权限，只查询自己申请的
if (hasPermission("repairs:apply") && !hasPermission("repairs:manage")) {
    query.setApplicantId(currentUserId);
}
```

### 4. 通知功能修改

#### 4.1 新增通知类型
```sql
-- 修复申请审批通知
INSERT INTO notification_type (type_code, type_name, description) VALUES
('REPAIR_APPROVED', '修复申请已通过', '您申请的文物修复已通过审批'),
('REPAIR_REJECTED', '修复申请已拒绝', '您申请的文物修复已被拒绝'),
('REPAIR_COMPLETED', '修复已完成', '您申请的文物修复已完成');
```

#### 4.2 通知触发时机
1. **修复申请通过**：审批员通过申请时，通知申请人
2. **修复申请拒绝**：审批员拒绝申请时，通知申请人
3. **修复完成**：修复师完成修复时，通知申请人

#### 4.3 通知内容模板
```
标题：修复申请已通过
内容：您申请的文物"${relicName}"修复已通过审批，修复专家：${expertName}

标题：修复申请已拒绝
内容：您申请的文物"${relicName}"修复申请已被拒绝，原因：${rejectReason}

标题：修复已完成
内容：您申请的文物"${relicName}"修复已完成，质量评分：${qualityScore}分
```

## 📝 实施步骤

### 步骤 1：数据库修改
1. 执行权限添加SQL
2. 执行通知类型添加SQL
3. 更新角色权限关联

### 步骤 2：后端修改
1. 修改 RepairRecordController 权限检查
2. 修改查询方法，添加申请人过滤
3. 修改审批方法，添加通知发送
4. 修改完成方法，添加通知发送

### 步骤 3：前端修改
1. 创建 RepairApplyView.vue
2. 修改路由配置
3. 修改菜单配置
4. 添加国际化配置
5. 修改通知组件，支持新通知类型

### 步骤 4：测试验证
1. 保管员登录，验证只能看到"申请修复"菜单
2. 保管员申请修复，验证功能正常
3. 审批员审批，验证保管员收到通知
4. 修复完成，验证保管员收到通知

## 🎨 RepairApplyView 界面设计

### 功能区域

#### 1. 顶部工具栏
- 搜索：文物名称、状态
- 按钮：申请修复

#### 2. 列表区域
显示字段：
- 文物名称
- 状态（待审批、已通过、已拒绝、修复中、修复完成）
- 修复原因
- 优先级
- 申请日期
- 审批人
- 修复专家
- 预估费用
- 操作（查看详情、删除-仅待审批状态）

#### 3. 申请对话框
与 RepairsView 的申请对话框相同，包含：
- 文物选择
- 优先级
- 修复原因
- 损坏描述
- 修复专家（可选）
- 修复前图片
- 材料选择（自动计算预估费用）
- 备注

#### 4. 详情对话框
显示完整的修复记录信息：
- 基本信息
- 审批信息
- 修复信息
- 材料使用明细
- 修复前后图片

### 状态说明

| 状态 | 说明 | 可操作 |
|------|------|--------|
| 待审批 | 刚提交，等待审批 | 查看详情、删除 |
| 已通过 | 审批通过，等待修复 | 查看详情 |
| 已拒绝 | 审批拒绝 | 查看详情、删除 |
| 修复中 | 正在修复 | 查看详情 |
| 修复完成 | 修复完成 | 查看详情 |

## 🔔 通知功能详细设计

### 通知表结构
```sql
CREATE TABLE notification (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '接收用户ID',
    type VARCHAR(50) NOT NULL COMMENT '通知类型',
    title VARCHAR(200) NOT NULL COMMENT '通知标题',
    content TEXT COMMENT '通知内容',
    related_id BIGINT COMMENT '关联ID（如修复记录ID）',
    related_type VARCHAR(50) COMMENT '关联类型',
    is_read TINYINT DEFAULT 0 COMMENT '是否已读',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_is_read (is_read)
);
```

### 通知发送逻辑

#### 1. 审批通过时
```java
// 在 approveRepairApi 方法中
if (approved) {
    // 发送通知给申请人
    notificationService.sendNotification(
        repairRecord.getApplicantId(),
        "REPAIR_APPROVED",
        "修复申请已通过",
        String.format("您申请的文物"%s"修复已通过审批，修复专家：%s", 
            repairRecord.getRelicName(), 
            repairRecord.getRepairExpert()),
        repairRecord.getId(),
        "REPAIR"
    );
}
```

#### 2. 审批拒绝时
```java
else {
    // 发送通知给申请人
    notificationService.sendNotification(
        repairRecord.getApplicantId(),
        "REPAIR_REJECTED",
        "修复申请已拒绝",
        String.format("您申请的文物"%s"修复申请已被拒绝，原因：%s", 
            repairRecord.getRelicName(), 
            approveRemark),
        repairRecord.getId(),
        "REPAIR"
    );
}
```

#### 3. 修复完成时
```java
// 在 completeRepairApi 方法中
notificationService.sendNotification(
    repairRecord.getApplicantId(),
    "REPAIR_COMPLETED",
    "修复已完成",
    String.format("您申请的文物"%s"修复已完成，质量评分：%d分", 
        repairRecord.getRelicName(), 
        qualityScore),
    repairRecord.getId(),
    "REPAIR"
);
```

### 通知显示

#### 通知铃铛组件
- 显示未读通知数量
- 点击显示通知列表
- 点击通知跳转到详情页

#### 通知列表
- 按时间倒序显示
- 未读通知高亮显示
- 点击标记为已读
- 支持批量标记已读
- 支持删除通知

## 📊 权限对比表

| 功能 | 系统管理员 | 文物保管员（修改前） | 文物保管员（修改后） | 审批员 |
|------|-----------|-------------------|-------------------|--------|
| 申请修复 | ✅ | ✅ | ✅ | ✅ |
| 审批修复 | ✅ | ✅ | ❌ | ✅ |
| 开始修复 | ✅ | ✅ | ❌ | ✅ |
| 更新进度 | ✅ | ✅ | ❌ | ✅ |
| 完成修复 | ✅ | ✅ | ❌ | ✅ |
| 查看所有记录 | ✅ | ✅ | ❌（只看自己的） | ✅ |
| 管理专家 | ✅ | ✅ | ❌ | ✅ |
| 管理材料 | ✅ | ✅ | ❌ | ✅ |
| 接收通知 | ✅ | ❌ | ✅ | ✅ |

## 🚀 优势

### 1. 权限分离
- 保管员专注于申请修复
- 审批和修复由专业人员负责
- 职责清晰，流程规范

### 2. 信息透明
- 保管员可以实时查看申请状态
- 收到审批和完成通知
- 了解修复进度

### 3. 操作简化
- 保管员界面更简洁
- 只显示相关功能
- 减少误操作

### 4. 审计追踪
- 每个申请都有申请人
- 审批和修复有明确责任人
- 便于追溯和管理

## 📌 注意事项

### 1. 数据迁移
- 现有修复记录需要设置 applicant_id
- 可以根据 applicant_name 匹配用户ID

### 2. 兼容性
- 保持 repairs:manage 权限不变
- 系统管理员和审批员仍使用原功能
- 新增 repairs:apply 权限给保管员

### 3. 通知配置
- 用户可以配置是否接收通知
- 支持邮件、站内信等多种方式
- 可以设置通知频率

### 4. 测试重点
- 权限控制是否生效
- 通知是否正常发送
- 界面显示是否正确
- 数据查询是否准确

---

**创建时间**：2026-04-28  
**状态**：设计方案  
**下一步**：实施修改
