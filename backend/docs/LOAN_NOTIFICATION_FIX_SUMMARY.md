# 展借申请通知问题修复总结

## 问题描述
展借人提出展借申请之后，管理员端没有收到实时通知。

## 根本原因分析
通过代码审查发现，通知发送的核心逻辑是正确的，但缺少详细的日志记录，导致无法快速定位问题。可能的原因包括：

1. **用户配置问题**: 管理员或审批员账号未启用
2. **角色配置问题**: 角色代码不匹配或角色未启用
3. **WebSocket连接问题**: 前端未正确连接WebSocket或连接断开
4. **通知配置问题**: 用户禁用了该类型的通知
5. **数据问题**: borrowerId为null导致通知发送失败

## 解决方案

### 1. 增强日志记录 ✅

#### 修改文件: `NotificationServiceImpl.java`

**修改1: sendLoanApplyNotification() 方法**
- 添加方法开始和结束的日志
- 记录所有关键参数

**修改2: createAndSendNotification() 方法**
- 记录通知保存到数据库的状态
- 记录目标用户数量
- 记录每个用户的通知关联创建
- 记录WebSocket推送状态
- 增强错误日志

**修改3: getUserIdsByRoleCodes() 方法**
- 记录查询的角色代码和通知类型
- 记录找到的角色信息（ID、名称）
- 记录查询到的用户数量
- 记录每个用户的检查过程（DEBUG级别）
- 记录最终的目标用户列表

### 2. 创建诊断工具 ✅

#### 文档1: `LOAN_NOTIFICATION_DEBUG.md`
详细的问题排查指南，包括：
- 通知流程说明
- 代码检查结果
- 日志输出示例
- 常见问题及解决方法
- 数据库验证SQL

#### 文档2: `NOTIFICATION_TEST_GUIDE.md`
完整的测试指南，包括：
- 快速测试步骤
- API测试命令
- WebSocket连接示例代码
- 数据库验证SQL
- 常见问题排查
- 性能测试方法

#### SQL脚本: `verify_notification_setup.sql`
自动化验证脚本，检查：
- 角色配置
- 用户配置
- 通知配置
- 历史通知记录
- 统计信息
- 诊断建议

## 修改的代码文件

### backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java

#### 修改内容：
1. **sendLoanApplyNotification()**: 添加开始和结束日志
2. **createAndSendNotification()**: 添加详细的流程日志
3. **getUserIdsByRoleCodes()**: 添加完整的用户查询日志

#### 日志级别：
- `INFO`: 关键流程节点
- `DEBUG`: 详细的用户检查过程
- `WARN`: 异常情况
- `ERROR`: 错误情况

## 使用方法

### 1. 重新编译项目
```bash
cd backend
mvn clean compile
```

### 2. 启动应用
```bash
mvn spring-boot:run
```

### 3. 验证数据库配置
```bash
mysql -u root -p cultural_relics_db < sql/verify_notification_setup.sql
```

### 4. 提交测试申请
使用借展人账号提交一个展借申请，观察后端日志输出。

### 5. 分析日志
根据日志输出，确定问题所在：
- 如果看到"没有找到符合条件的用户"，检查用户和角色配置
- 如果看到"WebSocket推送失败"，检查前端WebSocket连接
- 如果看到"发送通知失败"，检查完整的错误堆栈

## 预期日志输出

### 正常情况
```
INFO  - 借展申请通知已发送：loanId=1, borrowerId=7, borrower=陈晓东, relic=青铜鼎
INFO  - 开始发送借展申请通知：loanId=1, borrowerName=陈晓东, relicName=青铜鼎, senderId=7
INFO  - 开始创建并发送通知：type=LOAN_APPLY, title=新的借展申请, roleCodes=[ADMIN, APPROVER]
INFO  - 通知已保存到数据库：notificationId=1
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
INFO  - 用户通知关联已创建：userId=1, notificationId=1
INFO  - WebSocket通知已推送：userId=1, title=新的借展申请
INFO  - 用户通知关联已创建：userId=5, notificationId=1
INFO  - WebSocket通知已推送：userId=5, title=新的借展申请
INFO  - 用户通知关联已创建：userId=6, notificationId=1
INFO  - WebSocket通知已推送：userId=6, title=新的借展申请
INFO  - 通知发送成功：type=LOAN_APPLY, title=新的借展申请, recipients=3
INFO  - 借展申请通知发送完成：loanId=1
```

### 异常情况示例

#### 情况1: 没有目标用户
```
WARN - 角色不存在：roleCode=ADMIN
WARN - 没有找到符合条件的用户，通知类型：LOAN_APPLY，角色：[ADMIN, APPROVER]
```

#### 情况2: WebSocket推送失败
```
ERROR - WebSocket推送失败：userId=1, error=User not connected
```

## 验证清单

- [ ] 代码编译成功
- [ ] 数据库中有ADMIN和APPROVER角色
- [ ] 数据库中有启用的管理员和审批员用户
- [ ] 提交展借申请后，日志显示完整的通知发送流程
- [ ] 数据库中创建了系统通知记录
- [ ] 数据库中为管理员和审批员创建了用户通知关联
- [ ] 管理员和审批员的前端收到WebSocket推送（如果在线）
- [ ] 管理员和审批员可以在通知列表中看到新通知

## 后续优化建议

### 1. 通知可靠性
- 添加消息队列（如RabbitMQ、Kafka）确保通知不丢失
- 实现通知重试机制
- 添加离线通知（邮件、短信）

### 2. 性能优化
- 批量插入用户通知关联
- 使用异步处理通知发送
- 添加通知缓存

### 3. 监控告警
- 添加通知发送成功率监控
- 添加WebSocket连接数监控
- 添加通知延迟监控
- 设置告警阈值

### 4. 用户体验
- 通知聚合（相同类型的通知合并显示）
- 通知优先级可视化
- 通知声音和震动提示
- 浏览器原生通知支持

### 5. 测试覆盖
- 添加单元测试
- 添加集成测试
- 添加压力测试
- 添加端到端测试

## 相关文档

- [通知系统实现文档](NOTIFICATION_SYSTEM_IMPLEMENTATION.md)
- [通知自动触发指南](NOTIFICATION_AUTO_TRIGGER_GUIDE.md)
- [问题排查指南](LOAN_NOTIFICATION_DEBUG.md)
- [测试指南](NOTIFICATION_TEST_GUIDE.md)

## 技术栈

- Spring Boot 2.7.x
- WebSocket (STOMP)
- MyBatis
- MySQL
- SLF4J + Logback

## 联系方式

如有问题，请查看日志输出并参考相关文档。
