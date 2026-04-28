# 审计日志问题排查总结

## 📋 问题描述

**操作记录没有自动保存到数据库 `sys_operation_log` 表中**

## ✅ 已完成的工作

### 1. 代码层面
- ✅ 数据库表结构已创建（16个新字段）
- ✅ Mapper 接口已实现（使用 @Insert 注解）
- ✅ Service 层已实现（logDataChange 方法）
- ✅ Controller 已集成（14个Controller，33个方法）
- ✅ 已添加详细的调试日志
- ✅ 编译成功（2026-04-28 17:02:51）

### 2. 调试增强
在 `SysOperationLogServiceImpl.logDataChange()` 方法中添加了详细的日志输出：
- 记录所有输入参数
- 记录 JSON 转换结果
- 记录数据对比结果
- 记录插入操作结果
- 捕获并输出所有异常信息

## 🔍 问题诊断方法

### 方法一：查看后端控制台日志（推荐）

**步骤：**

1. **重启后端服务**
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **执行一个修改操作**
   - 登录系统
   - 修改一个文物的信息（例如修改状态或位置）
   - 点击保存

3. **观察控制台输出**
   
   **预期看到的日志：**
   ```
   ========== 开始记录审计日志 ==========
   userId: 1
   operator: 管理员
   operationType: 修改
   operationModule: 文物管理
   resourceType: RELIC
   resourceId: 1
   beforeData length: 256
   afterData length: 258
   changedFields: [...]
   operationContent: 修改文物管理（ID:1）
   准备插入数据库...
   
   ==>  Preparing: INSERT INTO sys_operation_log (...)
   ==> Parameters: 1(Long), 管理员(String), ...
   <==    Updates: 1
   
   插入结果: 1
   生成的日志ID: 123
   ========== 审计日志记录完成 ==========
   ```

4. **根据日志判断问题**

   | 日志情况 | 可能原因 | 解决方案 |
   |---------|---------|---------|
   | 完全没有日志 | logDataChange 方法未被调用 | 检查 Controller 中的 try-catch |
   | 有开始日志，无 SQL | Mapper 方法执行失败 | 查看异常信息 |
   | 有 SQL，显示错误 | 数据库字段不匹配 | 执行验证脚本 |
   | SQL 成功，Updates: 0 | 数据未真正插入 | 检查事务和权限 |

### 方法二：验证数据库表结构

**执行验证脚本：**

```bash
mysql -u root -p cultural_relics < backend/sql/verify_audit_log_table.sql
```

**这个脚本会检查：**
- ✓ 表是否存在
- ✓ 所有必需字段是否存在
- ✓ 字段类型和长度是否正确
- ✓ 索引是否创建
- ✓ 是否可以手动插入数据
- ✓ 当前表中的数据统计

**如果验证失败，执行修复脚本：**

```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_fix_missing_fields.sql
```

### 方法三：直接查询数据库

```sql
-- 1. 查看表结构
DESC sys_operation_log;

-- 2. 查看记录数
SELECT COUNT(*) FROM sys_operation_log;

-- 3. 查看最近的记录
SELECT * FROM sys_operation_log ORDER BY operation_time DESC LIMIT 5;

-- 4. 查看是否有新增的记录（最近1小时）
SELECT * FROM sys_operation_log 
WHERE operation_time >= DATE_SUB(NOW(), INTERVAL 1 HOUR)
ORDER BY operation_time DESC;
```

## 🐛 常见问题及解决方案

### 问题 1：字段不存在

**错误信息：**
```
Unknown column 'user_id' in 'field list'
```

**解决方案：**
```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_fix_missing_fields.sql
```

### 问题 2：数据太长

**错误信息：**
```
Data too long for column 'before_data'
```

**解决方案：**
```sql
ALTER TABLE sys_operation_log 
MODIFY COLUMN before_data LONGTEXT,
MODIFY COLUMN after_data LONGTEXT;
```

### 问题 3：MyBatis 不输出 SQL

**原因：** 日志配置不正确

**解决方案：** 确认 `application.yml` 配置：
```yaml
mybatis:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

logging:
  level:
    com.example: debug
```

### 问题 4：Service 方法未被调用

**原因：** Controller 的 try-catch 捕获了异常但没有输出

**解决方案：** 在 Controller 的 update 方法开始处添加日志：
```java
@PutMapping
public Result<Boolean> update(@RequestBody CulturalRelic relic, HttpServletRequest request) {
    System.out.println("========== 开始更新文物 ==========");
    System.out.println("文物ID: " + relic.getId());
    
    // ... 原有代码
}
```

### 问题 5：事务回滚

**原因：** 审计日志记录失败导致整个事务回滚

**解决方案：** 修改 Service 方法，使用独立事务：
```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void logDataChange(...) {
    // 记录日志
}
```

## 📝 下一步操作清单

请按照以下顺序执行：

### 1️⃣ 验证数据库表（必须）
```bash
mysql -u root -p cultural_relics < backend/sql/verify_audit_log_table.sql
```
- 如果验证失败，执行修复脚本
- 截图或复制验证结果

### 2️⃣ 重启后端服务（必须）
```bash
cd backend
mvn spring-boot:run
```
- 确保使用最新编译的代码
- 观察启动日志是否有错误

### 3️⃣ 执行测试操作（必须）
- 登录系统
- 修改一个文物的信息
- 观察控制台日志输出

### 4️⃣ 收集信息并反馈

**请提供以下信息：**

1. **后端控制台日志**（从 "开始记录审计日志" 到 "记录完成" 的完整输出）
2. **数据库验证结果**（verify_audit_log_table.sql 的输出）
3. **数据库查询结果**：
   ```sql
   SELECT COUNT(*) FROM sys_operation_log;
   SELECT * FROM sys_operation_log ORDER BY operation_time DESC LIMIT 3;
   ```
4. **是否有任何错误信息**

## 📂 相关文件

| 文件 | 说明 |
|------|------|
| `backend/src/main/java/com/example/service/impl/SysOperationLogServiceImpl.java` | Service 实现（已添加调试日志） |
| `backend/src/main/java/com/example/mapper/SysOperationLogMapper.java` | Mapper 接口 |
| `backend/src/main/java/com/example/controller/CulturalRelicController.java` | Controller 示例 |
| `backend/sql/verify_audit_log_table.sql` | 数据库验证脚本 |
| `backend/sql/audit_log_fix_missing_fields.sql` | 字段修复脚本 |
| `AUDIT_LOG_DEBUG_GUIDE.md` | 详细调试指南 |

## 🎯 预期结果

完成以上步骤后，应该能够：
1. ✅ 在控制台看到完整的审计日志记录过程
2. ✅ 在数据库中看到新增的操作记录
3. ✅ 在前端操作日志页面看到记录
4. ✅ 点击详情可以看到数据对比

## 💡 提示

- 调试日志会输出大量信息，这是正常的
- 如果看到 SQL 语句，说明 MyBatis 配置正确
- 如果看到 "Updates: 1"，说明数据已插入
- 如果完全没有日志，可能是 Controller 的问题

---

**最后更新**：2026-04-28 17:05  
**状态**：等待用户测试并提供反馈  
**下一步**：根据用户提供的日志输出进行针对性修复
