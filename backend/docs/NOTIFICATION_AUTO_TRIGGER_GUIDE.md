# 通知自动触发功能说明

## 实现日期
2026年4月24日

## 功能概述
系统已实现完整的自动通知触发机制，在关键业务节点自动发送通知给相关人员。

## 已实现的自动通知功能

### 1. 借展申请通知 ✅

**触发时机**: 借展人提交借展申请时

**触发位置**: `LoanRecordServiceImpl.save()`

**触发条件**: 
- 借展申请成功保存到数据库
- borrowerId不为空

**通知内容**: "用户 {借展人姓名} 提交了文物"{文物名称}"的借展申请，请及时审批。"

**接收人**: 
- 系统管理员（ADMIN）
- 借展审批员（APPROVER）

**代码实现**:
```java
// 发送借展申请通知
if (success && loanRecord.getBorrowerId() != null) {
    try {
        notificationService.sendLoanApplyNotification(
            loanRecord.getId(),
            loanRecord.getBorrowerName(),
            relic.getRelicName(),
            loanRecord.getBorrowerId()
        );
        log.info("借展申请通知已发送：loanId={}, borrowerId={}, borrower={}, relic={}", 
                loanRecord.getId(), loanRecord.getBorrowerId(), 
                loanRecord.getBorrowerName(), relic.getRelicName());
    } catch (Exception e) {
        log.error("发送借展申请通知失败：{}", e.getMessage(), e);
    }
}
```

**测试方法**:
1. 登录为借展人（LOANER角色）
2. 提交借展申请
3. 查看管理员和审批员是否收到通知

---

### 2. 借展审批结果通知 ✅

**触发时机**: 审批员审批借展申请时（通过或拒绝）

**触发位置**: `LoanRecordServiceImpl.approveLoan()`

**触发条件**: 
- 审批操作成功
- borrowerId不为空

**通知内容**: 
- 通过："您申请借展的文物"{文物名称}"已被 {审批人} 审批通过。"
- 拒绝："您申请借展的文物"{文物名称}"已被 {审批人} 驳回。"

**接收人**: 借展申请人

**代码实现**:
```java
// 发送借展审批结果通知
if (updated && loanRecord.getBorrowerId() != null) {
    try {
        CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
        if (relic != null) {
            notificationService.sendLoanApprovalNotification(
                loanRecord.getId(),
                loanRecord.getBorrowerId(),
                relic.getRelicName(),
                approved,
                approverName
            );
            log.info("借展审批结果通知已发送：loanId={}, borrowerId={}, approved={}, approver={}", 
                    loanRecord.getId(), loanRecord.getBorrowerId(), approved, approverName);
        }
    } catch (Exception e) {
        log.error("发送借展审批结果通知失败：{}", e.getMessage(), e);
    }
}
```

**测试方法**:
1. 登录为审批员（APPROVER角色）
2. 审批借展申请（通过或拒绝）
3. 查看借展人是否收到通知

---

### 3. 借展逾期通知 ✅

**触发时机**: 每天凌晨1点自动检查

**触发位置**: `LoanOverdueCheckTask.checkOverdueLoans()`

**触发条件**: 
- 借展记录状态为"借出中"
- 预计归还日期早于当前日期

**通知内容**: "用户 {借展人姓名} 借展的文物"{文物名称}"已逾期 {天数} 天未归还，请及时处理。"

**接收人**: 
- 系统管理员（ADMIN）
- 文物保管员（CURATOR）

**定时任务配置**:
```java
@Scheduled(cron = "0 0 1 * * ?")  // 每天凌晨1点执行
public void checkOverdueLoans() {
    // 检查逾期借展记录
    List<LoanRecord> loanRecords = loanRecordService.listByStatus("借出中");
    LocalDate today = LocalDate.now();
    
    for (LoanRecord record : loanRecords) {
        LocalDate returnDate = record.getExpectedReturnDate().toLocalDate();
        
        if (returnDate.isBefore(today)) {
            int overdueDays = (int) ChronoUnit.DAYS.between(returnDate, today);
            
            // 发送逾期通知
            notificationService.sendLoanOverdueNotification(
                record.getId(),
                record.getBorrowerName(),
                relic.getRelicName(),
                overdueDays
            );
        }
    }
}
```

**测试方法**:
1. 创建一个预计归还日期为昨天的借展记录
2. 等待定时任务执行（或手动触发）
3. 查看管理员和保管员是否收到逾期通知

**手动触发测试**:
```java
// 在测试类中调用
@Autowired
private LoanOverdueCheckTask loanOverdueCheckTask;

@Test
public void testOverdueCheck() {
    loanOverdueCheckTask.checkOverdueLoans();
}
```

---

### 4. 修复申请通知 ✅

**触发时机**: 提交修复申请时

**触发位置**: `RepairRecordServiceImpl.applyRepair()`

**触发条件**: 
- 修复申请成功保存到数据库

**通知内容**: "文物"{文物名称}"提交了修复申请，修复原因：{修复原因}，请及时审批。"

**接收人**: 
- 系统管理员（ADMIN）
- 文物保管员（CURATOR）

**代码实现**:
```java
// 发送修复申请通知
if (result > 0) {
    try {
        notificationService.sendRepairApplyNotification(
            record.getId(),
            relic.getRelicName(),
            request.getRepairReason(),
            null  // 申请人ID
        );
        log.info("修复申请通知已发送：repairId={}, relic={}", 
                record.getId(), relic.getRelicName());
    } catch (Exception e) {
        log.error("发送修复申请通知失败：{}", e.getMessage(), e);
    }
}
```

**测试方法**:
1. 登录系统
2. 提交修复申请
3. 查看管理员和保管员是否收到通知

---

### 5. 修复审批结果通知 ⚠️

**状态**: 代码已实现但被注释

**原因**: RepairRecord表缺少applicant_id字段，无法确定通知接收人

**建议**: 
1. 在repair_record表添加applicant_id字段
2. 修改申请流程，记录申请人的user_id
3. 取消注释通知代码

**代码位置**: `RepairRecordServiceImpl.approveRepair()`

**需要的修改**:
```sql
-- 添加applicant_id字段
ALTER TABLE repair_record ADD COLUMN applicant_id BIGINT COMMENT '申请人ID';
ALTER TABLE repair_record ADD INDEX idx_applicant_id (applicant_id);
```

---

## 通知类型汇总

| 通知类型 | 触发方式 | 接收人 | 状态 |
|---------|---------|--------|------|
| LOAN_APPLY | 提交借展申请 | 管理员、审批员 | ✅ 已实现 |
| LOAN_APPROVED | 审批通过 | 借展人 | ✅ 已实现 |
| LOAN_REJECTED | 审批拒绝 | 借展人 | ✅ 已实现 |
| LOAN_OVERDUE | 定时检查（每天1点） | 管理员、保管员 | ✅ 已实现 |
| REPAIR_APPLY | 提交修复申请 | 管理员、保管员 | ✅ 已实现 |
| REPAIR_APPROVED | 审批通过 | 申请人 | ⚠️ 待完善 |
| REPAIR_REJECTED | 审批拒绝 | 申请人 | ⚠️ 待完善 |

## 定时任务配置

### 逾期检查任务

**Cron表达式**: `0 0 1 * * ?`

**执行时间**: 每天凌晨1点

**执行内容**:
1. 查询所有"借出中"状态的借展记录
2. 检查预计归还日期是否早于当前日期
3. 计算逾期天数
4. 发送逾期通知给管理员和保管员

**修改执行时间**:
```java
// 修改为每小时执行一次
@Scheduled(cron = "0 0 * * * ?")

// 修改为每30分钟执行一次
@Scheduled(cron = "0 */30 * * * ?")

// 修改为每天上午9点执行
@Scheduled(cron = "0 0 9 * * ?")
```

## 通知发送流程

### 1. 创建通知
```java
SystemNotification notification = new SystemNotification();
notification.setTitle("通知标题");
notification.setContent("通知内容");
notification.setType("LOAN_APPLY");
notification.setPriority("NORMAL");
notification.setRelatedType("LOAN");
notification.setRelatedId(loanId);
notification.setSenderId(senderId);
notification.setSenderName(senderName);
```

### 2. 发送给指定角色
```java
notificationService.createAndSendNotification(
    notification, 
    Arrays.asList("ADMIN", "APPROVER")
);
```

### 3. 系统自动处理
- 保存通知到数据库
- 查询目标角色的所有用户
- 为每个用户创建通知关联
- 通过WebSocket实时推送（如果已启用）
- 记录日志

## 测试指南

### 1. 测试借展申请通知

**步骤**:
1. 登录为借展人（username: loaner, password: 123456）
2. 进入借展管理页面
3. 提交借展申请
4. 登录为管理员查看通知

**预期结果**:
- 管理员收到"新的借展申请"通知
- 审批员收到"新的借展申请"通知
- 通知内容包含借展人姓名和文物名称

### 2. 测试借展审批通知

**步骤**:
1. 登录为审批员
2. 审批借展申请（通过或拒绝）
3. 登录为借展人查看通知

**预期结果**:
- 借展人收到审批结果通知
- 通知内容包含审批人姓名和审批结果

### 3. 测试逾期通知

**步骤**:
1. 创建一个预计归还日期为昨天的借展记录
2. 手动触发定时任务或等待凌晨1点
3. 登录为管理员查看通知

**预期结果**:
- 管理员收到逾期通知
- 保管员收到逾期通知
- 通知内容包含逾期天数

### 4. 测试修复申请通知

**步骤**:
1. 登录系统
2. 提交修复申请
3. 登录为管理员查看通知

**预期结果**:
- 管理员收到修复申请通知
- 保管员收到修复申请通知
- 通知内容包含文物名称和修复原因

## 故障排查

### 1. 通知没有发送

**可能原因**:
- 通知服务未正常启动
- 数据库连接失败
- 角色配置错误
- 用户状态为禁用

**排查方法**:
1. 查看后端日志是否有错误
2. 检查数据库表是否正常
3. 验证角色代码是否正确
4. 确认用户状态为启用

### 2. 定时任务未执行

**可能原因**:
- Spring定时任务未启用
- Cron表达式错误
- 服务器时间不正确

**排查方法**:
1. 检查Application类是否有@EnableScheduling注解
2. 验证Cron表达式是否正确
3. 查看服务器时间是否准确
4. 查看日志是否有定时任务执行记录

### 3. 通知重复发送

**可能原因**:
- 定时任务重复执行
- 没有记录已发送的通知

**解决方案**:
- 添加通知发送记录表
- 检查是否已发送过相同通知
- 避免重复发送

## 性能优化建议

### 1. 批量发送通知
```java
// 批量插入用户通知关联
List<UserNotification> userNotifications = new ArrayList<>();
for (Long userId : targetUserIds) {
    UserNotification un = new UserNotification();
    un.setNotificationId(notificationId);
    un.setUserId(userId);
    userNotifications.add(un);
}
// 批量插入
userNotificationMapper.batchInsert(userNotifications);
```

### 2. 异步发送通知
```java
@Async
public void sendNotificationAsync(SystemNotification notification, List<String> roleCodes) {
    createAndSendNotification(notification, roleCodes);
}
```

### 3. 缓存角色用户列表
```java
@Cacheable(value = "roleUsers", key = "#roleCode")
public List<Long> getUserIdsByRoleCode(String roleCode) {
    // 查询角色用户
}
```

## 相关文档

- 通知系统实现：`backend/docs/NOTIFICATION_SYSTEM_IMPLEMENTATION.md`
- 前端通知实现：`frontend/docs/NOTIFICATION_FRONTEND_IMPLEMENTATION.md`
- 数据库迁移：`backend/docs/LOAN_RECORD_BORROWER_ID_MIGRATION.md`
- WebSocket配置：`frontend/WEBSOCKET_SETUP.md`
