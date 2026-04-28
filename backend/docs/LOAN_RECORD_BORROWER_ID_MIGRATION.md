# 借展记录borrower_id字段迁移文档

## 📅 迁移日期
2026年4月24日

---

## 🎯 迁移目标

为`loan_record`表添加`borrower_id`字段，解决以下问题：
1. 管理员端借展管理页面借展人显示为空
2. 借展申请提交后管理员收不到实时通知

---

## 📋 迁移内容

### 1. 数据库结构变更

**表名**: `loan_record`

**新增字段**:
- `borrower_id` (BIGINT) - 借展人用户ID，关联sys_user表

**新增索引**:
- `idx_borrower_id` - 提升查询性能

---

## 🔧 迁移步骤

### 步骤1：执行SQL迁移脚本

**文件**: `backend/sql/loan_record_add_borrower_id.sql`

```bash
# 在MySQL客户端执行
mysql -u root -p cultural_relics < backend/sql/loan_record_add_borrower_id.sql
```

**脚本内容**:
```sql
-- 1. 添加borrower_id字段
ALTER TABLE loan_record 
ADD COLUMN borrower_id BIGINT COMMENT '借展人ID' AFTER relic_id;

-- 2. 添加索引
ALTER TABLE loan_record 
ADD INDEX idx_borrower_id (borrower_id);

-- 3. 数据迁移（通过real_name匹配）
UPDATE loan_record lr
LEFT JOIN sys_user su ON lr.borrower_name = su.real_name
SET lr.borrower_id = su.id
WHERE lr.borrower_name IS NOT NULL AND su.id IS NOT NULL;

-- 4. 数据迁移（通过username匹配，作为备选）
UPDATE loan_record lr
LEFT JOIN sys_user su ON lr.borrower_name = su.username
SET lr.borrower_id = su.id
WHERE lr.borrower_id IS NULL 
  AND lr.borrower_name IS NOT NULL 
  AND su.id IS NOT NULL;
```

---

### 步骤2：后端代码修改

#### 2.1 修改LoanRecordController

**文件**: `backend/src/main/java/com/example/controller/LoanRecordController.java`

**变更内容**:
1. 添加SysUserMapper依赖注入
2. 在save方法中从borrowerName查询borrowerId

**关键代码**:
```java
// 从borrowerName获取borrowerId
if (loanRecord.getBorrowerName() != null && !loanRecord.getBorrowerName().isEmpty()) {
    // 先尝试通过real_name查询
    SysUser user = sysUserMapper.selectByRealName(loanRecord.getBorrowerName());
    if (user == null) {
        // 如果找不到，尝试通过username查询
        user = sysUserMapper.selectByUsername(loanRecord.getBorrowerName());
    }
    if (user != null) {
        loanRecord.setBorrowerId(user.getId());
    }
}
```

#### 2.2 实体类已支持

**文件**: `backend/src/main/java/com/example/entity/LoanRecord.java`

已包含borrowerId字段：
```java
private Long borrowerId;
private String borrowerName; // 从sys_user表关联查询得到
```

#### 2.3 Mapper已支持

**文件**: `backend/src/main/resources/mapper/LoanRecordMapper.xml`

查询语句已包含JOIN：
```xml
SELECT lr.*, 
       cr.relic_name AS relicName,
       su.real_name AS borrowerName
FROM loan_record lr
LEFT JOIN cultural_relic cr ON lr.relic_id = cr.id
LEFT JOIN sys_user su ON lr.borrower_id = su.id
```

INSERT语句已包含borrower_id：
```xml
INSERT INTO loan_record
(relic_id, borrower_id, borrower_unit, ...)
VALUES
(#{relicId}, #{borrowerId}, #{borrowerUnit}, ...)
```

#### 2.4 Service已支持

**文件**: `backend/src/main/java/com/example/service/impl/LoanRecordServiceImpl.java`

通知发送逻辑已包含borrowerId检查：
```java
// 发送借展申请通知
if (success && loanRecord.getBorrowerId() != null) {
    notificationService.sendLoanApplyNotification(
        loanRecord.getId(),
        loanRecord.getBorrowerName(),
        relic.getRelicName(),
        loanRecord.getBorrowerId()
    );
}
```

---

### 步骤3：重启服务

```bash
# 停止后端服务
# 重新启动后端服务
```

---

## ✅ 验证测试

### 1. 数据库验证

```sql
-- 检查字段是否添加成功
SHOW COLUMNS FROM loan_record LIKE 'borrower%';

-- 检查索引是否创建成功
SHOW INDEX FROM loan_record WHERE Key_name = 'idx_borrower_id';

-- 检查历史数据迁移情况
SELECT 
    COUNT(*) as total_records,
    COUNT(borrower_id) as records_with_id,
    COUNT(*) - COUNT(borrower_id) as records_without_id
FROM loan_record;

-- 查看最近的记录
SELECT id, relic_id, borrower_id, borrower_name, status, create_time
FROM loan_record
ORDER BY id DESC
LIMIT 5;
```

---

### 2. 功能测试

#### 测试1：提交借展申请

**操作步骤**:
1. 登录为借展人（例如：zhangsan）
2. 进入"借展申请"页面
3. 填写借展信息并提交

**验证点**:
```sql
-- 查看最新的借展记录
SELECT id, relic_id, borrower_id, borrower_name, status
FROM loan_record
ORDER BY id DESC
LIMIT 1;
```

**预期结果**:
- borrower_id字段有值（不为NULL）
- borrower_name显示正确的姓名

---

#### 测试2：管理员查看借展列表

**操作步骤**:
1. 登录为管理员
2. 进入"借展管理"页面
3. 查看借展列表

**验证点**:
- 借展人列显示正确的姓名（不为空）
- 可以看到所有借展记录

---

#### 测试3：实时通知

**操作步骤**:
1. 管理员登录并保持在线
2. 借展人提交借展申请
3. 观察管理员端通知

**验证点**:
- 管理员立即收到通知（无需刷新页面）
- 通知内容包含借展人姓名和文物名称
- 桌面通知弹出（如果已授权）

**后端日志验证**:
```
借展申请通知已发送：loanId=1, borrowerId=2, borrower=张三, relic=青铜鼎
```

---

## 📊 数据流程对比

### 迁移前（有问题）

```
前端提交 → Controller接收
{
  borrowerName: "张三"
  borrowerId: undefined  ❌
}
    ↓
Service保存
borrowerId = null  ❌
    ↓
通知检查
if (borrowerId != null) { ... }  ❌ 不满足
    ↓
查询显示
LEFT JOIN sys_user ON lr.borrower_id = su.id  ❌ JOIN失败
borrowerName = NULL  ❌
```

---

### 迁移后（正确）

```
前端提交 → Controller处理
{
  borrowerName: "张三"
}
    ↓
Controller查询用户
user = sysUserMapper.selectByRealName("张三")
loanRecord.setBorrowerId(user.getId())  ✅
    ↓
Service保存
INSERT ... borrower_id = 2  ✅
    ↓
通知发送
if (borrowerId != null) {  ✅ 满足条件
  sendLoanApplyNotification(..., borrowerId)  ✅
}
    ↓
查询显示
LEFT JOIN sys_user ON lr.borrower_id = su.id  ✅ JOIN成功
borrowerName = su.real_name  ✅ 显示"张三"
```

---

## ⚠️ 注意事项

### 1. 数据备份
- 执行SQL脚本前务必备份loan_record表
- 建议先在测试环境验证

### 2. 历史数据
- 历史数据通过borrower_name匹配sys_user表
- 如果borrower_name无法匹配到用户，borrower_id将为NULL
- 建议检查并手动修正无法匹配的记录

### 3. 前端兼容性
- 前端代码无需修改
- 前端继续发送borrowerName
- Controller负责转换为borrowerId

### 4. 性能优化
- 已添加idx_borrower_id索引
- JOIN查询性能良好

---

## 🔗 相关文档

- **修复记录表迁移**: `REPAIR_RECORD_APPLICANT_ID_MIGRATION.md`
- **通知系统实现**: `NOTIFICATION_SYSTEM_IMPLEMENTATION.md`
- **通知系统状态**: `NOTIFICATION_STATUS.md`
- **WebSocket实现**: `WEBSOCKET_IMPLEMENTATION_SUMMARY.md`

---

## 📝 迁移检查清单

- [x] 创建SQL迁移脚本
- [x] 修改LoanRecordController
- [x] 验证实体类支持
- [x] 验证Mapper支持
- [x] 验证Service支持
- [ ] 执行SQL脚本
- [ ] 重启后端服务
- [ ] 验证数据库字段
- [ ] 测试提交借展申请
- [ ] 测试借展人显示
- [ ] 测试实时通知

---

**迁移完成后，借展管理功能将完全正常！** 🎉
