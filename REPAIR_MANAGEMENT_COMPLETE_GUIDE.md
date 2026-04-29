# 修复管理完整功能指南

## 功能概述

文物保管员端的修复管理功能已完整实现，包括权限控制、审批流程和完善的消息通知系统。

## 一、权限控制

### 1.1 保管员权限
文物保管员在修复管理界面**只能看到自己申请的修复记录**。

**实现位置**：`backend/src/main/java/com/example/controller/RepairRecordController.java`

```java
// 获取当前用户权限，判断是否需要过滤申请人
Long applicantIdFilter = null;

if (authentication != null) {
    // 检查是否是管理员角色
    boolean isAdmin = authorities.stream()
        .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    
    // 如果不是管理员（即CURATOR等角色），只查询自己申请的
    if (!isAdmin) {
        applicantIdFilter = userContextUtil.getCurrentUserId();
        System.out.println("保管员权限过滤：只显示申请人ID=" + applicantIdFilter + "的记录");
    } else {
        System.out.println("管理员权限：显示所有记录");
    }
}

PageResult<RepairRecord> result = repairRecordService.pageRecords(
    pageNum, pageSize, status, priority, relicName, repairExpert, applicantIdFilter);
```

**权限说明**：
- ✅ **保管员（CURATOR）**：只能查看自己申请的修复记录
- ✅ **管理员（ADMIN）**：可以查看所有修复记录

### 1.2 操作权限

| 操作 | 保管员 | 管理员 | 说明 |
|------|--------|--------|------|
| 查看列表 | ✅ 仅自己的 | ✅ 全部 | 权限过滤 |
| 申请修复 | ✅ | ✅ | 提交新申请 |
| 编辑申请 | ✅ 仅自己的待审批 | ✅ | 修改待审批申请 |
| 撤回申请 | ✅ 仅自己的待审批 | ✅ | 删除待审批申请 |
| 查看详情 | ✅ 仅自己的 | ✅ 全部 | 查看详细信息 |
| 审批申请 | ❌ | ✅ | 审批通过/拒绝 |
| 开始修复 | ❌ | ✅ | 开始修复工作 |
| 更新进度 | ❌ | ✅ | 更新修复进度 |
| 完成修复 | ❌ | ✅ | 标记修复完成 |

## 二、修复流程

### 2.1 完整流程图

```
保管员提交申请 → 待审批 → 管理员审批 → 待修复 → 开始修复 → 修复中 → 完成修复 → 修复完成
                    ↓                ↓
                  撤回            拒绝 → 已拒绝
```

### 2.2 状态说明

| 状态 | 说明 | 可执行操作（保管员） | 可执行操作（管理员） |
|------|------|---------------------|---------------------|
| 待审批 | 申请已提交，等待审批 | 编辑、撤回、查看详情 | 审批（通过/拒绝） |
| 待修复 | 审批通过，等待开始修复 | 查看详情 | 开始修复 |
| 修复中 | 正在修复 | 查看详情 | 更新进度、完成修复 |
| 修复完成 | 修复已完成 | 查看详情 | 查看详情 |
| 已拒绝 | 审批被拒绝 | 查看详情 | 删除 |

### 2.3 流程详细说明

#### 步骤1：提交申请（保管员）
- 选择需要修复的文物
- 填写修复原因、损坏描述
- 选择优先级（紧急、高、普通、低）
- 添加修复材料（可选）
- 提交申请
- **状态**：待审批
- **通知**：系统管理员收到"新的修复申请"通知

#### 步骤2：审批申请（管理员）
- 查看申请详情
- 审批通过或拒绝
- 填写审批意见
- 指定修复专家（通过时）
- **状态**：待修复（通过）或 已拒绝（拒绝）
- **通知**：申请人收到"修复申请已通过/已驳回"通知

#### 步骤3：开始修复（管理员）
- 点击"开始修复"按钮
- **状态**：修复中
- **通知**：无

#### 步骤4：更新进度（管理员）
- 填写修复过程、修复方法
- 更新实际费用
- 上传修复后照片
- **状态**：修复中
- **通知**：无

#### 步骤5：完成修复（管理员）
- 填写质量评分、质量评估意见
- 确认完成
- **状态**：修复完成
- **通知**：申请人收到"修复已完成"通知

## 三、消息通知系统

### 3.1 通知类型完整列表

| 通知类型 | 触发时机 | 发送人 | 接收人 | 标题 | 实现状态 |
|---------|---------|--------|--------|------|---------|
| REPAIR_APPLY | 提交新申请 | 保管员 | 管理员 | 新的修复申请 | ✅ |
| REPAIR_UPDATE | 修改待审批申请 | 保管员 | 管理员 | 修复申请已更新 | ✅ |
| REPAIR_WITHDRAW | 撤回待审批申请 | 保管员 | 管理员 | 修复申请已撤回 | ✅ |
| REPAIR_APPROVED | 审批通过 | 管理员 | 申请人 | 修复申请已通过 | ✅ |
| REPAIR_REJECTED | 审批拒绝 | 管理员 | 申请人 | 修复申请已驳回 | ✅ |
| REPAIR_COMPLETED | 完成修复 | 管理员 | 申请人 | 修复已完成 | ✅ |

### 3.2 通知实现详情

#### 3.2.1 提交申请通知
**文件**：`RepairRecordController.java` - `applyRepair()` 方法

```java
// 发送修复申请通知
if (result > 0) {
    try {
        notificationService.sendRepairApplyNotification(
            record.getId(),
            relic.getRelicName(),
            request.getRepairReason(),
            applicantId
        );
    } catch (Exception e) {
        log.error("发送修复申请通知失败：{}", e.getMessage(), e);
    }
}
```

**通知内容**：
- 标题：新的修复申请
- 内容：文物"xxx"提交了修复申请，修复原因：xxx，请及时审批。
- 接收者：系统管理员

#### 3.2.2 修改申请通知
**文件**：`RepairRecordController.java` - `updateRepairApply()` 方法

```java
// 发送更新通知
if (success) {
    try {
        RepairRecord updatedRecord = repairRecordService.getById(id);
        Long currentUserId = userContextUtil.getCurrentUserId();
        
        notificationService.sendRepairUpdateNotification(
            id,
            updatedRecord.getRelicName(),
            updatedRecord.getRepairReason(),
            currentUserId
        );
    } catch (Exception e) {
        System.err.println("发送修复申请更新通知失败: " + e.getMessage());
    }
}
```

**通知内容**：
- 标题：修复申请已更新
- 内容：文物"xxx"的修复申请已更新，修复原因：xxx，请重新审核。
- 接收者：系统管理员

#### 3.2.3 撤回申请通知
**文件**：`RepairRecordController.java` - `deleteById()` 方法

```java
// 发送撤回通知（仅当状态为待审批时）
if (success && "待审批".equals(oldRecord.getStatus())) {
    try {
        Long currentUserId = userContextUtil.getCurrentUserId();
        
        notificationService.sendRepairWithdrawNotification(
            id,
            oldRecord.getRelicName(),
            oldRecord.getRepairReason(),
            currentUserId
        );
    } catch (Exception e) {
        System.err.println("发送修复申请撤回通知失败: " + e.getMessage());
    }
}
```

**通知内容**：
- 标题：修复申请已撤回
- 内容：文物"xxx"的修复申请已被撤回，原修复原因：xxx。
- 接收者：系统管理员

#### 3.2.4 审批结果通知
**文件**：`RepairRecordController.java` - `approveRepair()` 方法

```java
// 发送审批结果通知
if (success) {
    try {
        RepairRecord record = repairRecordService.getById(request.getId());
        notificationService.sendRepairApprovalNotification(
            record.getId(),
            record.getApplicantId(),
            record.getRelicName(),
            request.getApproved(),
            approver
        );
    } catch (Exception e) {
        System.err.println("发送审批结果通知失败: " + e.getMessage());
    }
}
```

**通知内容**：
- 标题：修复申请已通过 / 修复申请已驳回
- 内容：您申请修复的文物"xxx"已被 xxx 审批通过/驳回。
- 接收者：申请人

#### 3.2.5 完成修复通知
**文件**：`RepairRecordController.java` - `completeRepair()` 方法

```java
// 发送修复完成通知
if (success) {
    try {
        RepairRecord record = repairRecordService.getById(id);
        Integer qualityScore = request != null ? request.getQualityScore() : null;
        notificationService.sendRepairCompletionNotification(
            record.getId(),
            record.getApplicantId(),
            record.getRelicName(),
            qualityScore
        );
    } catch (Exception e) {
        System.err.println("发送修复完成通知失败: " + e.getMessage());
    }
}
```

**通知内容**：
- 标题：修复已完成
- 内容：您申请修复的文物"xxx"已完成修复，质量评分：xx分。
- 接收者：申请人

## 四、前端界面

### 4.1 保管员端（RepairsView.vue）

**功能列表**：
- ✅ 查看自己的修复记录列表
- ✅ 筛选（状态、优先级、文物名称、修复专家）
- ✅ 申请新的修复
- ✅ 编辑待审批的申请
- ✅ 撤回待审批的申请
- ✅ 查看修复详情
- ✅ 查看使用材料

**操作按钮**：
```vue
<el-button link type="primary" @click="viewDetail(scope.row)">详情</el-button>
<el-button v-if="scope.row.status === '待审批'" link type="primary" @click="openEdit(scope.row)">编辑</el-button>
<el-button v-if="scope.row.status === '待审批'" link type="warning" @click="remove(scope.row.id)">撤回</el-button>
```

### 4.2 管理员端

**额外功能**：
- ✅ 查看所有修复记录
- ✅ 审批修复申请
- ✅ 开始修复
- ✅ 更新修复进度
- ✅ 完成修复

## 五、数据库设计

### 5.1 主表：repair_record

| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 主键 |
| repair_code | VARCHAR | 修复编号 |
| relic_id | BIGINT | 文物ID |
| status | VARCHAR | 状态 |
| priority | VARCHAR | 优先级 |
| applicant_id | BIGINT | 申请人ID |
| apply_date | DATETIME | 申请日期 |
| repair_reason | TEXT | 修复原因 |
| damage_description | TEXT | 损坏描述 |
| estimated_cost | DECIMAL | 预算费用 |
| approver | VARCHAR | 审批人 |
| approve_date | DATETIME | 审批日期 |
| approve_remark | TEXT | 审批意见 |
| repair_expert | VARCHAR | 修复专家 |
| start_date | DATETIME | 开始日期 |
| complete_date | DATETIME | 完成日期 |
| repair_process | TEXT | 修复过程 |
| repair_method | TEXT | 修复方法 |
| actual_cost | DECIMAL | 实际费用 |
| before_images | TEXT | 修复前照片 |
| after_images | TEXT | 修复后照片 |
| quality_score | INT | 质量评分 |
| quality_remark | TEXT | 质量评估 |
| remark | TEXT | 备注 |

### 5.2 关联表：repair_record_material

| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGINT | 主键 |
| repair_record_id | BIGINT | 修复记录ID |
| material_id | BIGINT | 材料ID |
| quantity | DECIMAL | 使用数量 |
| unit_price | DECIMAL | 单价 |
| total_price | DECIMAL | 总价 |
| remark | TEXT | 备注 |

## 六、API 接口

### 6.1 查询接口

```
GET /repairs
参数：
  - pageNum: 页码
  - pageSize: 每页大小
  - status: 状态筛选
  - priority: 优先级筛选
  - relicName: 文物名称筛选
  - repairExpert: 修复专家筛选
  
权限：保管员只能查看自己的记录
```

### 6.2 申请接口

```
POST /repairs/apply
请求体：RepairApplyRequest
  - relicId: 文物ID
  - priority: 优先级
  - repairReason: 修复原因
  - damageDescription: 损坏描述
  - estimatedCost: 预算费用
  - repairExpert: 修复专家（可选）
  - beforeImages: 修复前照片
  - remark: 备注
  
通知：发送给管理员
```

### 6.3 编辑接口

```
PUT /repairs/apply/{id}
请求体：RepairApplyRequest
  
权限：只能编辑自己的待审批申请
通知：发送给管理员
```

### 6.4 撤回接口

```
DELETE /repairs/{id}

权限：只能撤回自己的待审批申请
通知：发送给管理员（仅待审批状态）
```

### 6.5 审批接口

```
PUT /repairs/approve
请求体：RepairApproveRequest
  - id: 修复记录ID
  - approved: 是否通过
  - repairExpert: 修复专家
  - approveRemark: 审批意见
  
权限：仅管理员
通知：发送给申请人
```

### 6.6 完成接口

```
PUT /repairs/{id}/complete
请求体：RepairProgressRequest
  - repairProcess: 修复过程
  - repairMethod: 修复方法
  - actualCost: 实际费用
  - afterImages: 修复后照片
  - qualityScore: 质量评分
  - qualityRemark: 质量评估
  
权限：仅管理员
通知：发送给申请人
```

## 七、测试场景

### 7.1 保管员操作测试

1. **提交申请**
   - 登录保管员账号
   - 进入修复管理
   - 点击"申请修复"
   - 填写申请信息
   - 提交
   - 验证：管理员收到通知

2. **编辑申请**
   - 找到待审批的申请
   - 点击"编辑"
   - 修改信息
   - 提交
   - 验证：管理员收到更新通知

3. **撤回申请**
   - 找到待审批的申请
   - 点击"撤回"
   - 确认
   - 验证：管理员收到撤回通知

4. **查看详情**
   - 点击"详情"按钮
   - 查看完整信息
   - 查看材料使用情况

### 7.2 管理员操作测试

1. **审批申请**
   - 登录管理员账号
   - 查看待审批申请
   - 点击"审批"
   - 选择通过/拒绝
   - 填写意见
   - 提交
   - 验证：申请人收到通知

2. **完成修复**
   - 找到修复中的记录
   - 点击"完成修复"
   - 填写质量评分
   - 提交
   - 验证：申请人收到通知

### 7.3 权限测试

1. **保管员权限**
   - 验证只能看到自己的申请
   - 验证不能编辑他人的申请
   - 验证不能审批申请

2. **管理员权限**
   - 验证可以看到所有申请
   - 验证可以审批任何申请
   - 验证可以完成任何修复

## 八、总结

### 8.1 已实现功能

✅ **权限控制**
- 保管员只能查看自己的修复记录
- 保管员只能编辑/撤回自己的待审批申请
- 管理员可以查看和操作所有记录

✅ **审批流程**
- 申请 → 审批 → 修复 → 完成
- 状态流转清晰
- 操作权限明确

✅ **消息通知**
- 提交申请通知管理员
- 修改申请通知管理员
- 撤回申请通知管理员
- 审批结果通知申请人
- 完成修复通知申请人

✅ **材料管理**
- 申请时添加材料
- 编辑时修改材料
- 详情页查看材料

✅ **审计日志**
- 所有操作都有日志记录
- 记录操作人、时间、IP
- 记录数据变更前后对比

### 8.2 系统特点

1. **完整的权限体系**：基于角色的访问控制
2. **规范的审批流程**：申请→审批→执行→完成
3. **完善的通知机制**：关键操作都有通知
4. **详细的审计追踪**：所有操作可追溯
5. **友好的用户界面**：操作简单直观

### 8.3 用户价值

- **保管员**：方便申请和跟踪修复进度
- **管理员**：高效审批和管理修复工作
- **系统**：规范流程、提高效率、降低风险
