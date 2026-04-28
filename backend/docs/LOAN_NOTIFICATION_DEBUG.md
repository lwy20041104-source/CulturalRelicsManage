# 展借申请通知问题排查与解决方案

## 问题描述
展借人提出展借申请之后，管理员端没有收到实时通知。

## 问题分析

### 1. 通知流程
当用户提交展借申请时，系统应该：
1. 保存展借记录到数据库
2. 调用 `NotificationService.sendLoanApplyNotification()` 发送通知
3. 通知服务创建系统通知并关联到目标用户（ADMIN和APPROVER角色）
4. 通过WebSocket实时推送通知到在线用户

### 2. 代码检查结果

#### 2.1 LoanRecordServiceImpl.save()
✅ 已正确调用通知服务：
```java
if (success && loanRecord.getBorrowerId() != null) {
    notificationService.sendLoanApplyNotification(
        loanRecord.getId(),
        loanRecord.getBorrowerName(),
        relic.getRelicName(),
        loanRecord.getBorrowerId()
    );
}
```

#### 2.2 NotificationServiceImpl.sendLoanApplyNotification()
✅ 已正确配置目标角色：
```java
createAndSendNotification(notification, Arrays.asList("ADMIN", "APPROVER"));
```

#### 2.3 数据库配置
✅ 角色配置正确：
- 角色ID 1: ADMIN (系统管理员)
- 角色ID 3: APPROVER (借展审批员)

✅ 用户配置正确：
- 用户ID 1: admin (角色: ADMIN)
- 用户ID 5: approver01 (角色: APPROVER)
- 用户ID 6: approver02 (角色: APPROVER)

#### 2.4 WebSocket配置
✅ WebSocket配置正确：
- 端点: `/ws-notification`
- 用户队列: `/user/{userId}/queue/notifications`
- 广播主题: `/topic/notifications`

## 已实施的改进

### 1. 增强日志记录
在以下方法中添加了详细的日志输出：

#### NotificationServiceImpl.sendLoanApplyNotification()
- 记录开始发送通知的参数
- 记录发送完成状态

#### NotificationServiceImpl.createAndSendNotification()
- 记录通知保存到数据库
- 记录目标用户数量
- 记录每个用户的通知关联创建
- 记录WebSocket推送状态

#### NotificationServiceImpl.getUserIdsByRoleCodes()
- 记录查询的角色代码和通知类型
- 记录找到的角色信息
- 记录查询到的用户数量
- 记录每个用户的检查过程
- 记录最终的目标用户列表

### 2. 日志级别说明
- `INFO`: 关键流程节点（通知创建、发送、用户添加）
- `DEBUG`: 详细的用户检查过程
- `WARN`: 异常情况（角色不存在、没有目标用户）
- `ERROR`: 错误情况（WebSocket推送失败、通知发送失败）

## 排查步骤

### 步骤1: 检查日志输出
提交一个展借申请后，查看后端日志，应该看到以下日志序列：

```
INFO  - 开始发送借展申请通知：loanId=X, borrowerName=XXX, relicName=XXX, senderId=X
INFO  - 开始创建并发送通知：type=LOAN_APPLY, title=新的借展申请, roleCodes=[ADMIN, APPROVER]
INFO  - 通知已保存到数据库：notificationId=X
INFO  - 开始获取目标用户列表：roleCodes=[ADMIN, APPROVER], notificationType=LOAN_APPLY
INFO  - 找到角色：roleCode=ADMIN, roleId=1, roleName=系统管理员
INFO  - 查询到角色用户数：roleCode=ADMIN, userCount=X
INFO  - 添加目标用户：userId=1, username=admin, realName=系统管理员
INFO  - 找到角色：roleCode=APPROVER, roleId=3, roleName=借展审批员
INFO  - 查询到角色用户数：roleCode=APPROVER, userCount=X
INFO  - 添加目标用户：userId=5, username=approver01, realName=赵国强
INFO  - 添加目标用户：userId=6, username=approver02, realName=刘建国
INFO  - 最终目标用户列表：userIds=[1, 5, 6], count=3
INFO  - 准备为 3 个用户创建通知关联
INFO  - 用户通知关联已创建：userId=1, notificationId=X
INFO  - WebSocket通知已推送：userId=1, title=新的借展申请
INFO  - 用户通知关联已创建：userId=5, notificationId=X
INFO  - WebSocket通知已推送：userId=5, title=新的借展申请
INFO  - 用户通知关联已创建：userId=6, notificationId=X
INFO  - WebSocket通知已推送：userId=6, title=新的借展申请
INFO  - 通知发送成功：type=LOAN_APPLY, title=新的借展申请, recipients=3
INFO  - 借展申请通知发送完成：loanId=X
```

### 步骤2: 检查可能的问题

#### 问题A: 没有找到目标用户
如果看到日志：
```
WARN - 没有找到符合条件的用户，通知类型：LOAN_APPLY，角色：[ADMIN, APPROVER]
```

可能原因：
1. 数据库中没有ADMIN或APPROVER角色的用户
2. 用户状态不是启用状态（status != 1）
3. 用户禁用了该类型的通知

解决方法：
```sql
-- 检查角色是否存在
SELECT * FROM sys_role WHERE role_code IN ('ADMIN', 'APPROVER') AND status = 1;

-- 检查是否有该角色的启用用户
SELECT u.*, r.role_name, r.role_code 
FROM sys_user u 
LEFT JOIN sys_role r ON u.role_id = r.id 
WHERE r.role_code IN ('ADMIN', 'APPROVER') AND u.status = 1;

-- 检查通知配置
SELECT * FROM notification_config WHERE user_id IN (1, 5, 6) AND notification_type = 'LOAN_APPLY';
```

#### 问题B: WebSocket推送失败
如果看到日志：
```
ERROR - WebSocket推送失败：userId=X, error=XXX
```

可能原因：
1. 用户未连接WebSocket
2. WebSocket连接已断开
3. 消息格式错误

解决方法：
- 检查前端是否正确连接WebSocket
- 检查前端控制台是否有WebSocket错误
- 确认用户已登录并建立WebSocket连接

#### 问题C: 角色不存在
如果看到日志：
```
WARN - 角色不存在：roleCode=ADMIN
```

解决方法：
```sql
-- 插入缺失的角色
INSERT INTO sys_role (role_name, role_code, description, status, create_time) 
VALUES ('系统管理员', 'ADMIN', '系统最高权限管理员', 1, NOW());
```

### 步骤3: 验证数据库记录
检查通知是否正确保存到数据库：

```sql
-- 查看最新的系统通知
SELECT * FROM system_notification ORDER BY create_time DESC LIMIT 10;

-- 查看用户通知关联
SELECT un.*, sn.title, sn.content, u.username, u.real_name
FROM user_notification un
LEFT JOIN system_notification sn ON un.notification_id = sn.id
LEFT JOIN sys_user u ON un.user_id = u.id
WHERE sn.type = 'LOAN_APPLY'
ORDER BY un.create_time DESC
LIMIT 10;
```

### 步骤4: 前端检查
确认前端是否正确处理WebSocket消息：

1. 检查WebSocket连接状态
2. 检查是否订阅了正确的队列：`/user/queue/notifications`
3. 检查消息处理函数是否正确执行
4. 检查浏览器控制台是否有错误

## 常见问题解决

### Q1: 通知保存到数据库但没有推送
**原因**: WebSocket连接问题
**解决**: 
- 确认用户已登录
- 检查WebSocket连接状态
- 重新连接WebSocket

### Q2: 只有部分管理员收到通知
**原因**: 部分用户未连接WebSocket或通知配置被禁用
**解决**:
- 检查未收到通知的用户是否在线
- 检查通知配置表

### Q3: 完全没有通知
**原因**: 
1. 借展记录的borrowerId为null
2. 通知服务调用失败
3. 数据库事务回滚

**解决**:
- 检查LoanRecord的borrowerId字段
- 查看完整的错误日志
- 检查数据库事务配置

## 测试建议

### 1. 单元测试
创建测试用例验证通知发送逻辑：
```java
@Test
public void testSendLoanApplyNotification() {
    // 准备测试数据
    Long loanId = 1L;
    String borrowerName = "测试用户";
    String relicName = "测试文物";
    Long senderId = 7L;
    
    // 调用通知服务
    notificationService.sendLoanApplyNotification(loanId, borrowerName, relicName, senderId);
    
    // 验证通知是否创建
    // 验证用户关联是否创建
    // 验证WebSocket是否推送
}
```

### 2. 集成测试
1. 使用借展人账号登录
2. 提交一个展借申请
3. 使用管理员账号登录
4. 检查是否收到实时通知
5. 检查通知列表中是否有该通知

### 3. 压力测试
模拟多个用户同时提交展借申请，验证通知系统的稳定性。

## 总结
通过增强日志记录，现在可以清楚地追踪通知发送的整个流程。如果管理员仍然没有收到通知，请按照上述排查步骤检查日志输出，定位具体问题。
