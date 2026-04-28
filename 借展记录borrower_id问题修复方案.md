# 借展记录borrower_id问题修复方案

## 📅 创建日期
2026年4月24日

---

## 🐛 问题描述

### 问题1：借展人字段显示为空
管理员端的借展管理页面中，借展人字段显示为空。

### 问题2：管理员收不到实时通知
展借人提交借展申请后，管理员端没有收到实时通知。

---

## 🔍 问题原因

### 根本原因
`loan_record`表缺少`borrower_id`字段，只有`borrower_name`（VARCHAR类型存储姓名字符串）。

### 具体影响

1. **借展人显示为空**：
   - 前端显示的是`borrowerName`字段
   - Mapper查询时通过`LEFT JOIN sys_user`获取`real_name`
   - 但是JOIN条件是`lr.borrower_id = su.id`
   - 由于数据库表没有`borrower_id`字段，JOIN失败
   - 导致`borrowerName`为NULL

2. **管理员收不到通知**：
   - 通知服务需要`borrowerId`来确定通知接收人
   - `LoanRecordServiceImpl.save()`方法检查`borrowerId != null`
   - 由于`borrowerId`为NULL，通知不会发送

---

## 🔧 解决方案

### 步骤1：执行数据库迁移

**文件**: `backend/sql/loan_record_add_borrower_id.sql`

**操作**:
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

### 步骤2：修改LoanRecordController

**问题**: Controller直接接收前端传来的LoanRecord，但前端只发送borrowerName，没有borrowerId。

**解决**: 在Controller中从borrowerName查询borrowerId。

**修改文件**: `backend/src/main/java/com/example/controller/LoanRecordController.java`

**添加依赖**:
```java
private final SysUserMapper sysUserMapper;

public LoanRecordController(LoanRecordService loanRecordService, 
                           SysUserMapper sysUserMapper) {
    this.loanRecordService = loanRecordService;
    this.sysUserMapper = sysUserMapper;
}
```

**修改save方法**:
```java
@PostMapping
@OperationLog(operationType = "新增", operationModule = "借展管理", operationContent = "提交借展申请")
public Result<Boolean> save(@RequestBody LoanRecord loanRecord) {
    // ... 现有的验证代码 ...
    
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
    
    loanRecord.setStatus("待审批");
    loanRecord.setCreateTime(LocalDateTime.now());
    loanRecord.setUpdateTime(LocalDateTime.now());
    return Result.success("申请成功", loanRecordService.save(loanRecord));
}
```

---

### 步骤3：添加SysUserMapper方法

**问题**: SysUserMapper可能没有selectByRealName方法。

**解决**: 在SysUserMapper中添加该方法。

**修改文件**: `backend/src/main/java/com/example/mapper/SysUserMapper.java`

**添加方法**:
```java
SysUser selectByRealName(String realName);
```

**修改文件**: `backend/src/main/resources/mapper/SysUserMapper.xml`

**添加查询**:
```xml
<select id="selectByRealName" resultType="com.example.entity.SysUser">
    SELECT * FROM sys_user WHERE real_name = #{realName} LIMIT 1
</select>
```

---

## 📋 完整修改清单

### 1. 数据库修改 ✅
- [ ] 执行SQL脚本：`backend/sql/loan_record_add_borrower_id.sql`
- [ ] 验证borrower_id字段已添加
- [ ] 验证索引已创建
- [ ] 验证历史数据已迁移

### 2. 后端代码修改
- [ ] 修改LoanRecordController（添加SysUserMapper依赖）
- [ ] 修改save方法（从borrowerName获取borrowerId）
- [ ] 添加SysUserMapper.selectByRealName方法
- [ ] 添加SysUserMapper.xml查询语句

### 3. 验证测试
- [ ] 重启后端服务
- [ ] 提交新的借展申请
- [ ] 验证borrower_id正确保存
- [ ] 验证借展人姓名正确显示
- [ ] 验证管理员收到实时通知

---

## 🧪 测试步骤

### 1. 数据库测试

```sql
-- 检查字段
SHOW COLUMNS FROM loan_record LIKE 'borrower%';

-- 检查数据
SELECT id, relic_id, borrower_id, borrower_name, status 
FROM loan_record 
ORDER BY id DESC 
LIMIT 5;

-- 检查NULL值
SELECT COUNT(*) as total,
       COUNT(borrower_id) as with_id,
       COUNT(*) - COUNT(borrower_id) as null_count
FROM loan_record;
```

---

### 2. 功能测试

**测试1：提交借展申请**
1. 登录为借展人
2. 提交借展申请
3. 检查数据库：`SELECT * FROM loan_record ORDER BY id DESC LIMIT 1;`
4. 验证borrower_id字段有值

**测试2：查看借展列表**
1. 登录为管理员
2. 打开借展管理页面
3. 验证借展人列显示正确的姓名

**测试3：实时通知**
1. 登录为借展人
2. 提交借展申请
3. 登录为管理员
4. 查看是否立即收到通知（无需刷新）

---

## 📊 数据流程

### 修改前（有问题）

```
前端发送：
{
  relicId: 1,
  borrowerName: "张三",  // 只有姓名
  borrowerUnit: "省博物馆",
  ...
}
    ↓
Controller接收：
loanRecord.borrowerId = null  // 没有ID
    ↓
Service保存：
INSERT INTO loan_record (borrower_name, ...) VALUES ('张三', ...)
// borrower_id字段不存在，无法保存
    ↓
通知检查：
if (borrowerId != null) { ... }  // 条件不满足，不发送通知
    ↓
查询显示：
LEFT JOIN sys_user ON lr.borrower_id = su.id  // JOIN失败
borrowerName = NULL  // 显示为空
```

---

### 修改后（正确）

```
前端发送：
{
  relicId: 1,
  borrowerName: "张三",
  borrowerUnit: "省博物馆",
  ...
}
    ↓
Controller处理：
user = sysUserMapper.selectByRealName("张三")
loanRecord.borrowerId = user.getId()  // 设置ID
    ↓
Service保存：
INSERT INTO loan_record (borrower_id, borrower_name, ...) 
VALUES (1, '张三', ...)
    ↓
通知发送：
if (borrowerId != null) {  // 条件满足
  sendLoanApplyNotification(..., borrowerId)  // 发送通知
}
    ↓
查询显示：
LEFT JOIN sys_user ON lr.borrower_id = su.id  // JOIN成功
borrowerName = su.real_name  // 显示正确的姓名
```

---

## ⚠️ 注意事项

### 1. 数据迁移
- 历史数据中的borrower_name可能无法完全匹配到用户
- 建议在迁移后检查NULL值数量
- 对于无法匹配的记录，可能需要手动修正

### 2. 前端兼容性
- 前端代码不需要修改
- 前端继续发送borrowerName
- Controller负责转换为borrowerId

### 3. 备份数据
- 执行SQL脚本前务必备份数据
- 建议先在测试环境验证

---

## 🎯 预期效果

修改完成后：

1. **借展人显示正常**：
   - 管理员端借展列表显示借展人姓名
   - 详情页面显示完整的借展人信息

2. **实时通知正常**：
   - 借展人提交申请后，管理员立即收到通知
   - 通知内容包含借展人姓名和文物名称
   - 桌面通知正常弹出（如果已安装WebSocket依赖）

3. **数据完整性**：
   - 新提交的借展申请自动保存borrower_id
   - 可以通过borrower_id关联到用户表
   - 可以统计每个用户的借展记录

---

## 📚 相关文档

- **修复记录表迁移**: `backend/docs/REPAIR_RECORD_APPLICANT_ID_MIGRATION.md`
- **通知系统状态**: `NOTIFICATION_STATUS.md`
- **WebSocket实现**: `WEBSOCKET_IMPLEMENTATION_SUMMARY.md`

---

**执行SQL脚本并修改代码后，问题将得到解决！** 🎊
