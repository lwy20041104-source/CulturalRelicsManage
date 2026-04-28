# 消息通知系统实现文档

## 实现日期
2026年4月24日

## 功能概述
为博物馆文物数字化管理平台添加了完整的消息通知系统，支持在借展申请、文物逾期、修复申请等关键业务场景下向相关角色发送通知。

## 数据库设计

### 1. system_notification（系统通知表）
存储所有系统通知的基本信息。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | BIGINT | 主键，自增 |
| title | VARCHAR(100) | 通知标题 |
| content | TEXT | 通知内容 |
| type | VARCHAR(50) | 通知类型（LOAN_APPLY、LOAN_OVERDUE、REPAIR_APPLY等） |
| priority | VARCHAR(20) | 优先级（LOW、NORMAL、HIGH、URGENT） |
| related_type | VARCHAR(20) | 关联类型（LOAN、REPAIR） |
| related_id | BIGINT | 关联ID（借展记录ID或修复记录ID） |
| sender_id | BIGINT | 发送人ID |
| sender_name | VARCHAR(50) | 发送人姓名 |
| create_time | DATETIME | 创建时间 |

### 2. user_notification（用户通知关联表）
记录通知与用户的关联关系，支持一条通知发送给多个用户。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | BIGINT | 主键，自增 |
| notification_id | BIGINT | 通知ID |
| user_id | BIGINT | 用户ID |
| is_read | TINYINT | 是否已读（0-未读，1-已读） |
| read_time | DATETIME | 阅读时间 |
| create_time | DATETIME | 创建时间 |

### 3. notification_config（通知配置表）
用户可以配置是否接收特定类型的通知。

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | BIGINT | 主键，自增 |
| user_id | BIGINT | 用户ID |
| notification_type | VARCHAR(50) | 通知类型 |
| enabled | TINYINT | 是否启用（0-禁用，1-启用） |
| create_time | DATETIME | 创建时间 |
| update_time | DATETIME | 更新时间 |

## 通知类型

### 申请类通知
- **LOAN_APPLY**: 借展申请
- **REPAIR_APPLY**: 修复申请

### 审批结果通知
- **LOAN_APPROVED**: 借展审批通过
- **LOAN_REJECTED**: 借展审批拒绝
- **REPAIR_APPROVED**: 修复审批通过
- **REPAIR_REJECTED**: 修复审批拒绝

### 预警类通知
- **LOAN_OVERDUE**: 借展逾期

## 通知接收规则

### 系统管理员（ADMIN）
接收以下通知：
- 借展申请（LOAN_APPLY）
- 文物逾期（LOAN_OVERDUE）
- 修复申请（REPAIR_APPLY）

### 借展审批员（APPROVER）
接收以下通知：
- 借展申请（LOAN_APPLY）

### 文物保管员（CURATOR）
接收以下通知：
- 文物逾期（LOAN_OVERDUE）
- 修复申请（REPAIR_APPLY）

### 申请人
接收以下通知：
- 借展审批结果（LOAN_APPROVED、LOAN_REJECTED）
- 修复审批结果（REPAIR_APPROVED、REPAIR_REJECTED）

## 核心功能

### 1. 通知发送
- 支持按角色批量发送通知
- 自动过滤已禁用通知的用户
- 支持通知优先级设置
- 关联业务记录（借展、修复）

### 2. 通知查询
- 分页查询用户通知列表
- 支持按已读/未读状态筛选
- 按创建时间倒序排列
- 返回完整的通知详情

### 3. 通知管理
- 标记单条通知为已读
- 批量标记通知为已读
- 删除通知
- 统计未读通知数量

### 4. 定时任务
- 每天凌晨1点自动检查逾期借展记录
- 自动发送逾期通知给管理员和保管员
- 记录逾期天数

## API接口

### 1. 获取用户通知列表
```
GET /api/notifications
参数：
- pageNum: 页码（默认1）
- pageSize: 每页数量（默认10）
- isRead: 是否已读（可选）
```

### 2. 标记通知为已读
```
PUT /api/notifications/{id}/read
```

### 3. 批量标记为已读
```
PUT /api/notifications/read-all
参数：
- notificationIds: 通知ID列表
```

### 4. 获取未读通知数量
```
GET /api/notifications/unread-count
```

### 5. 删除通知
```
DELETE /api/notifications/{id}
```

## 业务集成

### 1. 借展申请通知
**触发时机**: 借展人提交借展申请时

**集成位置**: `LoanRecordServiceImpl.save()`

**通知内容**: "用户 {借展人姓名} 提交了文物"{文物名称}"的借展申请，请及时审批。"

**接收人**: 系统管理员、借展审批员

### 2. 借展逾期通知
**触发时机**: 每天凌晨1点定时检查

**集成位置**: `LoanOverdueCheckTask.checkOverdueLoans()`

**通知内容**: "用户 {借展人姓名} 借展的文物"{文物名称}"已逾期 {天数} 天未归还，请及时处理。"

**接收人**: 系统管理员、文物保管员

### 3. 修复申请通知
**触发时机**: 提交修复申请时

**集成位置**: `RepairRecordServiceImpl.applyRepair()`

**通知内容**: "文物"{文物名称}"提交了修复申请，修复原因：{修复原因}，请及时审批。"

**接收人**: 系统管理员、文物保管员

### 4. 借展审批结果通知
**触发时机**: 审批员审批借展申请时

**集成位置**: `LoanRecordServiceImpl.approve()`

**通知内容**: "您申请借展的文物"{文物名称}"已被 {审批人} {审批通过/驳回}。"

**接收人**: 借展人（通过borrower_id确定）

**状态**: ✅ 已实现

### 5. 修复审批结果通知
**触发时机**: 审批员审批修复申请时

**集成位置**: `RepairRecordServiceImpl.approveRepair()`

**通知内容**: "文物"{文物名称}"的修复申请已被 {审批人} {审批通过/拒绝}。"

**接收人**: 申请人

## 技术实现

### 后端技术栈
- Spring Boot 2.7.14
- MyBatis（纯MyBatis，非MyBatis-Plus）
- Spring AOP（操作日志）
- Spring Scheduling（定时任务）

### 核心类说明

#### 实体类
- `SystemNotification`: 系统通知实体
- `UserNotification`: 用户通知关联实体
- `NotificationConfig`: 通知配置实体

#### Mapper接口
- `SystemNotificationMapper`: 系统通知数据访问
- `UserNotificationMapper`: 用户通知关联数据访问
- `NotificationConfigMapper`: 通知配置数据访问

#### Service层
- `NotificationService`: 通知服务接口
- `NotificationServiceImpl`: 通知服务实现

#### Controller层
- `NotificationController`: 通知API控制器

#### 定时任务
- `LoanOverdueCheckTask`: 借展逾期检查任务（每天凌晨1点执行）

## 已知限制

### 1. 通知配置功能未完全实现
**当前状态**: 数据库表已创建，但前端配置界面未实现

**影响**: 用户无法自定义通知接收偏好

**解决方案**: 开发前端通知配置页面

## 最新更新

### 2026年4月24日 - 添加borrower_id字段
- ✅ 修改loan_record表结构，添加borrower_id字段
- ✅ 更新LoanRecord实体类和Mapper
- ✅ 实现借展审批结果通知功能
- ✅ 通过JOIN查询sys_user表获取借展人姓名

详见：`backend/docs/LOAN_RECORD_BORROWER_ID_MIGRATION.md`

## 部署说明

### 1. 执行数据库脚本
```sql
-- 执行以下SQL文件创建通知相关表
source backend/sql/notification_system.sql;
```

### 2. 重启后端服务
```bash
cd backend
mvn clean package -DskipTests
java -jar target/cultural-relics-manage-1.0.0.jar
```

### 3. 验证功能
- 提交借展申请，检查管理员是否收到通知
- 提交修复申请，检查保管员是否收到通知
- 等待定时任务执行（或手动触发），检查逾期通知

## 测试建议

### 1. 单元测试
- 测试通知创建和发送
- 测试通知查询和分页
- 测试通知标记已读
- 测试未读数量统计

### 2. 集成测试
- 测试借展申请流程中的通知发送
- 测试修复申请流程中的通知发送
- 测试定时任务的逾期检查

### 3. 性能测试
- 测试大量通知的查询性能
- 测试批量发送通知的性能

## 未来优化方向

1. **实时推送**: 集成WebSocket实现实时通知推送
2. **邮件通知**: 支持通过邮件发送重要通知
3. **短信通知**: 支持通过短信发送紧急通知
4. **通知模板**: 支持自定义通知模板
5. **通知统计**: 添加通知发送统计和分析功能
6. **通知分类**: 支持更细粒度的通知分类和筛选
7. **通知搜索**: 支持按关键词搜索通知内容

## 相关文档
- 数据库脚本: `backend/sql/notification_system.sql`
- API文档: 访问 http://localhost:8080/doc.html 查看Swagger文档
- 代码质量指南: `backend/docs/CODE_QUALITY_IMPROVEMENTS.md`
- 异常处理指南: `backend/docs/EXCEPTION_HANDLING_GUIDELINES.md`
- 日志规范: `backend/docs/LOGGING_GUIDELINES.md`
