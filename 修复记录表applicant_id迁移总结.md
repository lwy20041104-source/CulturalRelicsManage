# 修复记录表applicant_id字段迁移总结

## 📋 问题描述

消息通知功能存在问题：
- `repair_record`表缺少`applicant_id`字段
- 无法确定修复申请通知的接收人
- 当前使用`applicant`字段（VARCHAR）存储申请人姓名，无法关联用户ID

---

## ✅ 已完成的修改

### 1. SQL迁移脚本 ✅

**文件：** `backend/sql/repair_record_add_applicant_id.sql`

**内容：**
- 添加`applicant_id`字段（BIGINT）
- 添加索引`idx_applicant_id`
- 数据迁移（从`applicant`匹配到`sys_user.username`）
- 删除`applicant`字段
- 验证查询

---

### 2. 实体类修改 ✅

**文件：** `backend/src/main/java/com/example/entity/RepairRecord.java`

**修改：**
```java
// 删除
private String applicant;  // 申请人

// 添加
private Long applicantId;      // 申请人ID
private String applicantName;  // 申请人姓名（用于显示）
```

---

### 3. Mapper XML修改 ✅

**文件：** `backend/src/main/resources/mapper/RepairRecordMapper.xml`

**修改：**
1. **ResultMap更新：**
   - 删除`applicant`映射
   - 添加`applicant_id`和`applicant_name`映射

2. **查询语句更新（添加JOIN）：**
   ```sql
   SELECT rr.*, cr.relic_name, cr.relic_code, su.real_name as applicant_name
   FROM repair_record rr
   LEFT JOIN cultural_relic cr ON rr.relic_id = cr.id
   LEFT JOIN sys_user su ON rr.applicant_id = su.id
   ```

3. **插入语句更新：**
   - 将`applicant`改为`applicant_id`
   - 将`#{applicant}`改为`#{applicantId}`

---

### 4. Service层修改 ✅

**文件：** `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java`

**修改：**

1. **添加依赖：**
   ```java
   private final SysUserMapper sysUserMapper;
   ```

2. **applyRepair方法更新：**
   ```java
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

3. **通知发送更新：**
   ```java
   notificationService.sendRepairApplyNotification(
       record.getId(),
       relic.getRelicName(),
       request.getRepairReason(),
       applicantId  // 传入申请人ID
   );
   ```

---

### 5. 文档创建 ✅

**文件：** `backend/docs/REPAIR_RECORD_APPLICANT_ID_MIGRATION.md`

**内容：**
- 问题描述
- 解决方案
- SQL迁移脚本说明
- 代码修改详情
- 数据库表结构对比
- 数据迁移注意事项
- 测试清单
- 执行步骤

---

## 📝 执行步骤

### 1. 备份数据（重要！）

```sql
-- 备份repair_record表
CREATE TABLE repair_record_backup_20260424 AS 
SELECT * FROM repair_record;
```

---

### 2. 执行SQL迁移脚本

```bash
# 方式1：命令行执行
mysql -u root -p cultural_relics < backend/sql/repair_record_add_applicant_id.sql

# 方式2：MySQL客户端执行
mysql -u root -p cultural_relics
source backend/sql/repair_record_add_applicant_id.sql
```

---

### 3. 验证数据库修改

```sql
-- 检查字段是否正确
SHOW COLUMNS FROM repair_record LIKE 'applicant%';

-- 应该只显示applicant_id，不应该有applicant

-- 检查索引
SHOW INDEX FROM repair_record WHERE Key_name = 'idx_applicant_id';

-- 检查数据迁移结果
SELECT 
    id,
    repair_code,
    applicant_id,
    apply_date
FROM repair_record
ORDER BY id DESC
LIMIT 10;

-- 检查NULL值数量
SELECT 
    COUNT(*) as total,
    COUNT(applicant_id) as with_applicant_id,
    COUNT(*) - COUNT(applicant_id) as null_count
FROM repair_record;
```

---

### 4. 编译后端代码

```bash
cd backend
mvn clean compile
```

**检查编译是否成功，确保没有错误。**

---

### 5. 重启后端服务

```bash
# 停止当前服务
# 然后启动新服务
cd backend
mvn spring-boot:run

# 或者打包后运行
mvn clean package
java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
```

---

### 6. 测试功能

**测试项目：**

1. **提交修复申请：**
   - 登录系统
   - 选择一个在库文物
   - 提交修复申请
   - 检查是否成功

2. **检查数据库：**
   ```sql
   SELECT * FROM repair_record ORDER BY id DESC LIMIT 1;
   ```
   - 验证`applicant_id`字段有值
   - 验证值是当前登录用户的ID

3. **检查通知：**
   - 查看管理员是否收到修复申请通知
   - 检查通知内容是否正确

4. **查看修复记录列表：**
   - 打开修复记录页面
   - 验证申请人姓名正确显示
   - 验证所有字段正常显示

---

## ⚠️ 注意事项

### 1. 数据备份

**重要：** 执行SQL脚本前务必备份数据！

```sql
CREATE TABLE repair_record_backup_20260424 AS 
SELECT * FROM repair_record;
```

---

### 2. 数据迁移

**问题：** 如果旧数据中`applicant`字段的值不是有效的用户名，迁移后`applicant_id`将为NULL。

**解决：**
- 在迁移前检查数据质量
- 或在迁移后手动修正NULL值

**检查无效数据：**
```sql
-- 查找无法匹配的记录
SELECT rr.id, rr.repair_code, rr.applicant
FROM repair_record_backup_20260424 rr
LEFT JOIN sys_user su ON rr.applicant = su.username
WHERE rr.applicant IS NOT NULL AND su.id IS NULL;
```

---

### 3. 不可逆操作

**警告：** 删除`applicant`字段是不可逆操作！

**建议：**
- 先在测试环境验证
- 确认无误后再在生产环境执行
- 保留备份表一段时间

---

### 4. 前端兼容性

**影响：** 前端显示申请人姓名时，需要使用`applicantName`字段。

**检查：** 前端代码中是否有使用`applicant`字段的地方，需要改为`applicantName`。

---

## 🧪 测试清单

### 数据库测试

- [ ] 备份数据完成
- [ ] SQL脚本执行成功
- [ ] `applicant_id`字段已添加
- [ ] `applicant`字段已删除
- [ ] 索引`idx_applicant_id`已创建
- [ ] 数据迁移成功（检查NULL值数量）

---

### 功能测试

- [ ] 后端编译成功
- [ ] 后端服务启动成功
- [ ] 提交修复申请成功
- [ ] `applicant_id`正确保存
- [ ] 修复记录列表正常显示
- [ ] 申请人姓名正确显示
- [ ] 修复记录详情正常显示

---

### 通知测试

- [ ] 提交修复申请后，管理员收到通知
- [ ] 通知内容正确
- [ ] 通知接收人正确
- [ ] 审批后，申请人收到通知

---

## 📊 数据库表结构变化

### 修改前

```
repair_record
├── id (BIGINT)
├── repair_code (VARCHAR)
├── relic_id (BIGINT)
├── status (VARCHAR)
├── priority (VARCHAR)
├── applicant (VARCHAR) ← 申请人姓名
├── apply_date (DATETIME)
└── ...
```

---

### 修改后

```
repair_record
├── id (BIGINT)
├── repair_code (VARCHAR)
├── relic_id (BIGINT)
├── status (VARCHAR)
├── priority (VARCHAR)
├── applicant_id (BIGINT) ← 申请人ID（新增）
├── apply_date (DATETIME)
└── ...

索引：
└── idx_applicant_id (applicant_id)
```

---

## 🎯 预期效果

修改完成后：

1. **数据完整性：**
   - 修复记录通过`applicant_id`关联到用户
   - 可以获取申请人的完整信息

2. **通知功能：**
   - 修复申请通知可以正确发送给申请人
   - 审批结果通知可以正确发送给申请人

3. **数据查询：**
   - 可以通过JOIN查询获取申请人姓名
   - 可以统计每个用户的修复申请数量

---

## 📚 相关文件

### 已修改的文件

1. `backend/sql/repair_record_add_applicant_id.sql` - SQL迁移脚本
2. `backend/src/main/java/com/example/entity/RepairRecord.java` - 实体类
3. `backend/src/main/resources/mapper/RepairRecordMapper.xml` - Mapper XML
4. `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java` - Service实现

### 新增的文档

1. `backend/docs/REPAIR_RECORD_APPLICANT_ID_MIGRATION.md` - 详细迁移文档
2. `修复记录表applicant_id迁移总结.md` - 本文档

---

## 🚀 下一步

1. **执行SQL迁移脚本**
2. **重启后端服务**
3. **测试功能**
4. **验证通知是否正常工作**

---

**所有代码修改已完成，请执行SQL迁移脚本并重启后端服务！** 🎊
