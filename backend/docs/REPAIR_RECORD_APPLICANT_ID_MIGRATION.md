# 修复记录表applicant_id字段迁移说明

## 📅 修改日期
2026年4月24日

---

## 🎯 问题描述

消息通知功能存在以下问题：
- `repair_record`表缺少`applicant_id`字段，无法确定通知接收人
- 当前使用`applicant`字段存储申请人姓名（字符串），无法关联到用户ID
- 导致修复申请通知无法正确发送给申请人

---

## 🔧 解决方案

### 1. 数据库修改

**添加字段：**
- 添加`applicant_id`字段（BIGINT类型）
- 添加索引`idx_applicant_id`

**删除字段：**
- 删除`applicant`字段（VARCHAR类型）

**数据迁移：**
- 尝试从`sys_user`表中匹配现有数据
- 通过`applicant`字段（用户名）关联到`sys_user.username`
- 将匹配到的`user.id`填充到`applicant_id`

---

## 📝 SQL迁移脚本

**文件位置：** `backend/sql/repair_record_add_applicant_id.sql`

```sql
-- 1. 添加applicant_id字段
ALTER TABLE repair_record 
ADD COLUMN applicant_id BIGINT COMMENT '申请人ID' AFTER priority;

-- 2. 添加索引
ALTER TABLE repair_record 
ADD INDEX idx_applicant_id (applicant_id);

-- 3. 数据迁移（尝试匹配现有数据）
UPDATE repair_record rr
LEFT JOIN sys_user su ON rr.applicant = su.username
SET rr.applicant_id = su.id
WHERE rr.applicant IS NOT NULL AND su.id IS NOT NULL;

-- 4. 删除旧字段
ALTER TABLE repair_record 
DROP COLUMN applicant;
```

---

## 🔄 代码修改

### 1. RepairRecord实体类

**修改前：**
```java
private String applicant;  // 申请人
```

**修改后：**
```java
private Long applicantId;      // 申请人ID
private String applicantName;  // 申请人姓名（用于显示，非数据库字段）
```

---

### 2. RepairRecordMapper.xml

**ResultMap修改：**
```xml
<!-- 修改前 -->
<result column="applicant" property="applicant"/>

<!-- 修改后 -->
<result column="applicant_id" property="applicantId"/>
<result column="applicant_name" property="applicantName"/>
```

**查询语句修改（添加JOIN）：**
```xml
SELECT rr.*, cr.relic_name, cr.relic_code, su.real_name as applicant_name
FROM repair_record rr
LEFT JOIN cultural_relic cr ON rr.relic_id = cr.id
LEFT JOIN sys_user su ON rr.applicant_id = su.id
```

**插入语句修改：**
```xml
<!-- 修改前 -->
INSERT INTO repair_record (
    repair_code, relic_id, status, priority, applicant, apply_date, ...
) VALUES (
    #{repairCode}, #{relicId}, #{status}, #{priority}, #{applicant}, #{applyDate}, ...
)

<!-- 修改后 -->
INSERT INTO repair_record (
    repair_code, relic_id, status, priority, applicant_id, apply_date, ...
) VALUES (
    #{repairCode}, #{relicId}, #{status}, #{priority}, #{applicantId}, #{applyDate}, ...
)
```

---

### 3. RepairRecordServiceImpl

**添加依赖：**
```java
private final SysUserMapper sysUserMapper;

public RepairRecordServiceImpl(RepairRecordMapper repairRecordMapper,
                               NotificationService notificationService,
                               SysUserMapper sysUserMapper) {
    this.repairRecordMapper = repairRecordMapper;
    this.notificationService = notificationService;
    this.sysUserMapper = sysUserMapper;
}
```

**applyRepair方法修改：**
```java
// 修改前
record.setApplicant(applicant);

// 修改后
// 获取申请人ID
Long applicantId = null;
if (applicant != null && !applicant.isEmpty()) {
    com.example.entity.SysUser user = sysUserMapper.selectByUsername(applicant);
    if (user != null) {
        applicantId = user.getId();
    }
}
record.setApplicantId(applicantId);
```

**通知发送修改：**
```java
// 修改前
notificationService.sendRepairApplyNotification(
    record.getId(),
    relic.getRelicName(),
    request.getRepairReason(),
    null  // 申请人ID为null
);

// 修改后
notificationService.sendRepairApplyNotification(
    record.getId(),
    relic.getRelicName(),
    request.getRepairReason(),
    applicantId  // 传入申请人ID
);
```

---

## 📊 数据库表结构对比

### 修改前

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | BIGINT | 主键 |
| repair_code | VARCHAR(50) | 修复编号 |
| relic_id | BIGINT | 文物ID |
| status | VARCHAR(20) | 状态 |
| priority | VARCHAR(20) | 优先级 |
| **applicant** | **VARCHAR(50)** | **申请人姓名** |
| apply_date | DATETIME | 申请日期 |
| ... | ... | ... |

---

### 修改后

| 字段名 | 类型 | 说明 |
|--------|------|------|
| id | BIGINT | 主键 |
| repair_code | VARCHAR(50) | 修复编号 |
| relic_id | BIGINT | 文物ID |
| status | VARCHAR(20) | 状态 |
| priority | VARCHAR(20) | 优先级 |
| **applicant_id** | **BIGINT** | **申请人ID** |
| apply_date | DATETIME | 申请日期 |
| ... | ... | ... |

**索引：**
- `idx_applicant_id` (applicant_id)

---

## 🔍 数据迁移注意事项

### 1. 数据匹配问题

**问题：**
- 旧数据中`applicant`字段存储的是用户名（username）
- 需要通过`sys_user.username`匹配到`sys_user.id`

**解决：**
```sql
UPDATE repair_record rr
LEFT JOIN sys_user su ON rr.applicant = su.username
SET rr.applicant_id = su.id
WHERE rr.applicant IS NOT NULL AND su.id IS NOT NULL;
```

---

### 2. 无法匹配的数据

**情况：**
- 如果`applicant`字段的值不是有效的用户名
- 或者对应的用户已被删除
- 这些记录的`applicant_id`将为NULL

**影响：**
- 这些记录无法发送通知给申请人
- 但不影响其他功能

**建议：**
- 在迁移后检查`applicant_id`为NULL的记录
- 手动修正或删除无效数据

---

### 3. 验证迁移结果

**检查字段：**
```sql
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME IN ('applicant_id', 'applicant')
ORDER BY ORDINAL_POSITION;
```

**检查数据：**
```sql
-- 查看迁移后的数据
SELECT 
    id,
    repair_code,
    relic_id,
    status,
    applicant_id,
    apply_date,
    repair_reason
FROM repair_record
ORDER BY id DESC
LIMIT 10;

-- 检查NULL值
SELECT COUNT(*) as null_count
FROM repair_record
WHERE applicant_id IS NULL;
```

---

## 🧪 测试清单

### 1. 数据库测试

- [ ] 执行SQL迁移脚本
- [ ] 验证`applicant_id`字段已添加
- [ ] 验证`applicant`字段已删除
- [ ] 验证索引已创建
- [ ] 检查数据迁移结果
- [ ] 检查NULL值数量

---

### 2. 功能测试

- [ ] 提交新的修复申请
- [ ] 验证`applicant_id`正确保存
- [ ] 验证通知正确发送给申请人
- [ ] 查询修复记录列表
- [ ] 验证申请人姓名正确显示
- [ ] 查看修复记录详情
- [ ] 验证所有字段正确显示

---

### 3. 通知测试

- [ ] 提交修复申请后，管理员收到通知
- [ ] 审批通过后，申请人收到通知
- [ ] 审批拒绝后，申请人收到通知
- [ ] 修复完成后，申请人收到通知
- [ ] 验证通知内容正确
- [ ] 验证通知接收人正确

---

## 📋 执行步骤

### 1. 备份数据

```sql
-- 备份repair_record表
CREATE TABLE repair_record_backup_20260424 AS 
SELECT * FROM repair_record;
```

---

### 2. 执行迁移脚本

```bash
# 连接到数据库
mysql -u root -p cultural_relics

# 执行迁移脚本
source backend/sql/repair_record_add_applicant_id.sql
```

---

### 3. 验证迁移结果

```sql
-- 检查字段
SHOW COLUMNS FROM repair_record LIKE 'applicant%';

-- 检查数据
SELECT id, repair_code, applicant_id FROM repair_record LIMIT 10;

-- 检查NULL值
SELECT COUNT(*) FROM repair_record WHERE applicant_id IS NULL;
```

---

### 4. 重启后端服务

```bash
cd backend
mvn clean package
java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
```

---

### 5. 测试功能

- 登录系统
- 提交修复申请
- 检查通知是否正确发送
- 验证数据是否正确保存

---

## ⚠️ 注意事项

### 1. 不可逆操作

**警告：** 删除`applicant`字段是不可逆操作！

**建议：**
- 在执行前务必备份数据
- 在测试环境先验证
- 确认无误后再在生产环境执行

---

### 2. 数据一致性

**问题：** 如果`applicant`字段的值不是有效的用户名，迁移后`applicant_id`将为NULL

**解决：**
- 在迁移前检查数据质量
- 修正无效的`applicant`值
- 或者在迁移后手动修正

---

### 3. 前端兼容性

**影响：** 前端可能需要调整显示逻辑

**修改：**
- 使用`applicantName`字段显示申请人姓名
- 而不是`applicant`字段

---

## ✅ 完成状态

**数据库修改：** ✅ 已完成
- SQL迁移脚本已创建
- 字段定义已更新

**实体类修改：** ✅ 已完成
- `RepairRecord.java`已更新
- 添加`applicantId`和`applicantName`字段

**Mapper修改：** ✅ 已完成
- `RepairRecordMapper.xml`已更新
- ResultMap已更新
- 查询语句已添加JOIN
- 插入语句已更新

**Service修改：** ✅ 已完成
- `RepairRecordServiceImpl.java`已更新
- 添加`SysUserMapper`依赖
- `applyRepair`方法已更新
- 通知发送已更新

---

## 🎯 预期效果

修改完成后：

1. **数据库层面：**
   - `repair_record`表有`applicant_id`字段
   - 可以通过`applicant_id`关联到`sys_user`表
   - 可以获取申请人的完整信息

2. **业务层面：**
   - 提交修复申请时，自动保存申请人ID
   - 通知系统可以正确识别通知接收人
   - 修复申请通知可以正确发送给申请人

3. **显示层面：**
   - 修复记录列表显示申请人姓名
   - 修复记录详情显示申请人完整信息
   - 通知消息显示正确的接收人

---

## 📚 相关文档

- [消息通知系统实现](./NOTIFICATION_SYSTEM_IMPLEMENTATION.md)
- [消息通知自动触发指南](./NOTIFICATION_AUTO_TRIGGER_GUIDE.md)

---

**执行SQL迁移脚本后，请重启后端服务并测试功能！** 🎊
