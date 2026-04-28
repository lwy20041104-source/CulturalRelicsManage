# 通知系统测试指南

## 快速测试步骤

### 1. 启动应用
```bash
cd backend
mvn spring-boot:run
```

### 2. 测试展借申请通知

#### 步骤1: 准备测试数据
确保数据库中有以下数据：
- 管理员用户（admin, role_id=1）
- 审批员用户（approver01, approver02, role_id=3）
- 借展人用户（loaner01, role_id=4）
- 可借展的文物（status='在库'）

#### 步骤2: 使用借展人账号提交申请
```bash
# 登录借展人账号
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "loaner01",
    "password": "123456"
  }'

# 保存返回的token
TOKEN="<返回的token>"

# 提交展借申请
curl -X POST http://localhost:8080/loans \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "relicId": 1,
    "borrowerName": "陈晓东",
    "loanDate": "2026-04-25T10:00:00",
    "expectedReturnDate": "2026-05-25T10:00:00",
    "loanPurpose": "展览展示",
    "loanRemark": "测试展借申请"
  }'
```

#### 步骤3: 检查后端日志
查看控制台输出，应该看到以下日志：

```
INFO  - 借展申请通知已发送：loanId=X, borrowerId=7, borrower=陈晓东, relic=XXX
INFO  - 开始发送借展申请通知：loanId=X, borrowerName=陈晓东, relicName=XXX, senderId=7
INFO  - 开始创建并发送通知：type=LOAN_APPLY, title=新的借展申请, roleCodes=[ADMIN, APPROVER]
INFO  - 通知已保存到数据库：notificationId=X
INFO  - 开始获取目标用户列表：roleCodes=[ADMIN, APPROVER], notificationType=LOAN_APPLY
INFO  - 找到角色：roleCode=ADMIN, roleId=1, roleName=系统管理员
INFO  - 查询到角色用户数：roleCode=ADMIN, userCount=1
INFO  - 添加目标用户：userId=1, username=admin, realName=系统管理员
INFO  - 找到角色：roleCode=APPROVER, roleId=3, roleName=借展审批员
INFO  - 查询到角色用户数：roleCode=APPROVER, userCount=2
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

#### 步骤4: 使用管理员账号查看通知
```bash
# 登录管理员账号
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "123456"
  }'

# 保存返回的token
ADMIN_TOKEN="<返回的token>"

# 查看通知列表
curl -X GET "http://localhost:8080/notifications?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer $ADMIN_TOKEN"

# 查看未读通知数量
curl -X GET "http://localhost:8080/notifications/unread-count" \
  -H "Authorization: Bearer $ADMIN_TOKEN"
```

### 3. 测试WebSocket实时推送

#### 前端WebSocket连接代码示例
```javascript
import SockJS from 'sockjs-client';
import { Stomp } from '@stomp/stompjs';

// 建立WebSocket连接
const socket = new SockJS('http://localhost:8080/ws-notification');
const stompClient = Stomp.over(socket);

// 连接到WebSocket服务器
stompClient.connect(
  { Authorization: `Bearer ${token}` },
  (frame) => {
    console.log('WebSocket连接成功:', frame);
    
    // 订阅用户私有队列
    stompClient.subscribe('/user/queue/notifications', (message) => {
      const notification = JSON.parse(message.body);
      console.log('收到新通知:', notification);
      
      // 显示通知
      showNotification(notification);
      
      // 更新未读数量
      updateUnreadCount();
    });
  },
  (error) => {
    console.error('WebSocket连接失败:', error);
  }
);

// 显示通知的函数
function showNotification(notification) {
  // 使用浏览器通知API
  if (Notification.permission === 'granted') {
    new Notification(notification.title, {
      body: notification.content,
      icon: '/logo.png'
    });
  }
  
  // 或者使用UI组件显示通知
  // 例如：Element Plus的ElNotification
  ElNotification({
    title: notification.title,
    message: notification.content,
    type: 'info',
    duration: 5000
  });
}
```

### 4. 数据库验证

#### 检查系统通知表
```sql
SELECT * FROM system_notification 
WHERE type = 'LOAN_APPLY' 
ORDER BY create_time DESC 
LIMIT 5;
```

#### 检查用户通知关联表
```sql
SELECT 
    un.id,
    un.user_id,
    u.username,
    u.real_name,
    sn.title,
    sn.content,
    un.is_read,
    un.create_time
FROM user_notification un
LEFT JOIN system_notification sn ON un.notification_id = sn.id
LEFT JOIN sys_user u ON un.user_id = u.id
WHERE sn.type = 'LOAN_APPLY'
ORDER BY un.create_time DESC
LIMIT 10;
```

#### 检查通知配置
```sql
-- 查看用户的通知配置
SELECT * FROM notification_config 
WHERE user_id IN (1, 5, 6) 
AND notification_type = 'LOAN_APPLY';

-- 如果没有配置，说明使用默认配置（启用）
```

### 5. 常见问题排查

#### 问题1: 日志显示"没有找到符合条件的用户"
**检查步骤**:
```sql
-- 1. 检查角色是否存在且启用
SELECT * FROM sys_role WHERE role_code IN ('ADMIN', 'APPROVER');

-- 2. 检查是否有该角色的用户
SELECT u.*, r.role_name, r.role_code 
FROM sys_user u 
LEFT JOIN sys_role r ON u.role_id = r.id 
WHERE r.role_code IN ('ADMIN', 'APPROVER');

-- 3. 检查用户状态
SELECT u.*, r.role_name, r.role_code 
FROM sys_user u 
LEFT JOIN sys_role r ON u.role_id = r.id 
WHERE r.role_code IN ('ADMIN', 'APPROVER') 
AND u.status = 1;
```

#### 问题2: 通知保存到数据库但WebSocket没有推送
**可能原因**:
1. 用户未连接WebSocket
2. WebSocket连接已断开
3. Token过期

**解决方法**:
- 检查前端WebSocket连接状态
- 重新登录获取新token
- 检查浏览器控制台的WebSocket错误

#### 问题3: borrowerId为null
**原因**: 在LoanRecordController中，borrowerId是通过borrowerName查询得到的

**检查**:
```sql
-- 检查用户是否存在
SELECT * FROM sys_user WHERE real_name = '陈晓东' OR username = '陈晓东';
```

**解决**: 确保borrowerName与数据库中的real_name或username匹配

### 6. 性能测试

#### 测试并发通知发送
```bash
# 使用Apache Bench进行压力测试
ab -n 100 -c 10 -H "Authorization: Bearer $TOKEN" \
   -p loan_request.json -T application/json \
   http://localhost:8080/loans
```

#### 监控指标
- 通知创建时间
- WebSocket推送延迟
- 数据库插入性能
- 内存使用情况

### 7. 日志级别调整

如果需要更详细的日志，可以在 `application.yml` 中调整日志级别：

```yaml
logging:
  level:
    com.example.service.impl.NotificationServiceImpl: DEBUG
    com.example.service.impl.LoanRecordServiceImpl: DEBUG
    com.example.service.impl.WebSocketNotificationServiceImpl: DEBUG
```

## 预期结果

测试成功的标志：
1. ✅ 后端日志显示完整的通知发送流程
2. ✅ 数据库中创建了系统通知记录
3. ✅ 数据库中为管理员和审批员创建了用户通知关联
4. ✅ 管理员和审批员的前端收到WebSocket推送
5. ✅ 通知列表中显示新通知
6. ✅ 未读数量正确更新

## 下一步优化建议

1. **添加通知重试机制**: 如果WebSocket推送失败，可以考虑重试或使用其他通知方式
2. **通知聚合**: 如果短时间内有多个相同类型的通知，可以聚合显示
3. **通知优先级**: 根据优先级使用不同的提示方式
4. **离线通知**: 用户离线时的通知可以通过邮件或短信发送
5. **通知统计**: 添加通知的打开率、响应时间等统计指标
