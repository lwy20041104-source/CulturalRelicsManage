# 审计日志调试指南

## 当前状态

### ✅ 已完成的工作
1. **数据库层**：所有字段已添加到 `sys_operation_log` 表
2. **后端代码**：
   - Mapper、Service、Controller 都已正确实现
   - 已添加详细的调试日志输出
   - 编译成功（2026-04-28 17:02:51）
3. **前端界面**：数据对比功能已实现

### ❌ 当前问题
**操作记录没有自动保存到数据库 `sys_operation_log` 表**

## 问题诊断步骤

### 第一步：检查后端控制台日志

**重启后端服务**，然后执行一个修改操作（例如修改文物信息），观察控制台输出。

#### 预期看到的日志输出：

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
changedFields: [{"field":"status","label":"状态","oldValue":"在库","newValue":"维护中"}]
operationContent: 修改文物管理（ID:1）
准备插入数据库...

==>  Preparing: INSERT INTO sys_operation_log (user_id, operator, operation_type, ...) VALUES (?, ?, ?, ...)
==> Parameters: 1(Long), 管理员(String), 修改(String), ...
<==    Updates: 1

插入结果: 1
生成的日志ID: 123
========== 审计日志记录完成 ==========
```

### 第二步：根据日志输出判断问题

#### 情况 A：看到 "开始记录审计日志" 但没有 SQL 语句
**原因**：`logMapper.insertEnhanced(log)` 方法没有被执行或抛出异常

**解决方案**：
1. 检查是否有异常信息输出
2. 检查 MyBatis 配置是否正确
3. 检查 Mapper 接口是否被正确扫描

#### 情况 B：看到 SQL 语句但显示错误
**原因**：SQL 语句有语法错误或字段不匹配

**可能的错误信息**：
- `Unknown column 'xxx' in 'field list'` - 数据库表缺少某个字段
- `Column count doesn't match value count` - 字段数量与值数量不匹配
- `Data too long for column 'xxx'` - 数据超过字段长度限制

**解决方案**：
1. 执行 `backend/sql/audit_log_fix_missing_fields.sql` 确保所有字段存在
2. 检查 `sys_operation_log` 表结构是否与代码一致

#### 情况 C：SQL 执行成功但 Updates: 0
**原因**：数据没有真正插入数据库

**解决方案**：
1. 检查数据库事务是否回滚
2. 检查是否有触发器阻止插入
3. 检查数据库用户权限

#### 情况 D：完全没有看到任何日志输出
**原因**：`logDataChange` 方法没有被调用

**解决方案**：
1. 检查 Controller 中的 try-catch 是否捕获了异常但没有输出
2. 检查 `operationLogService` 是否正确注入
3. 在 Controller 的 update 方法开始处添加日志确认方法被调用

### 第三步：验证数据库表结构

执行以下 SQL 查询，确认表结构正确：

```sql
-- 查看 sys_operation_log 表结构
DESC sys_operation_log;

-- 查看表的所有字段
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'sys_operation_log'
ORDER BY ORDINAL_POSITION;

-- 检查是否有数据
SELECT COUNT(*) FROM sys_operation_log;

-- 查看最近的记录
SELECT * FROM sys_operation_log ORDER BY operation_time DESC LIMIT 5;
```

### 第四步：手动测试 Mapper

如果以上步骤都没有发现问题，可以创建一个测试接口直接调用 Mapper：

在 `CulturalRelicController.java` 中添加测试方法：

```java
@GetMapping("/test-audit-log")
public Result<String> testAuditLog() {
    try {
        SysOperationLog log = new SysOperationLog();
        log.setUserId(1L);
        log.setOperator("测试用户");
        log.setOperationType("测试");
        log.setOperationModule("测试模块");
        log.setOperationContent("测试操作内容");
        log.setResourceType("TEST");
        log.setResourceId(999L);
        log.setOperationResult("成功");
        log.setIpAddress("127.0.0.1");
        log.setRequestMethod("GET");
        log.setRequestUrl("/test");
        log.setOperationTime(LocalDateTime.now());
        
        int result = operationLogService.logMapper.insertEnhanced(log);
        
        return Result.success("测试成功，插入结果: " + result + ", 生成ID: " + log.getId());
    } catch (Exception e) {
        return Result.error("测试失败: " + e.getMessage());
    }
}
```

访问 `http://localhost:8080/api/relics/test-audit-log` 测试。

## 常见问题及解决方案

### 问题 1：字段长度不足

**错误信息**：`Data too long for column 'before_data'`

**解决方案**：修改字段类型为 TEXT 或 LONGTEXT

```sql
ALTER TABLE sys_operation_log 
MODIFY COLUMN before_data LONGTEXT,
MODIFY COLUMN after_data LONGTEXT,
MODIFY COLUMN changed_fields TEXT,
MODIFY COLUMN request_params TEXT,
MODIFY COLUMN response_data TEXT;
```

### 问题 2：字段不存在

**错误信息**：`Unknown column 'user_id' in 'field list'`

**解决方案**：执行字段修复脚本

```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_fix_missing_fields.sql
```

### 问题 3：MyBatis 没有输出 SQL

**原因**：日志级别配置不正确

**解决方案**：确认 `application.yml` 中的配置：

```yaml
mybatis:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

logging:
  level:
    com.example: debug
```

### 问题 4：事务回滚

**原因**：业务操作失败导致整个事务回滚

**解决方案**：审计日志记录应该在独立的事务中，修改 Service 方法：

```java
@Transactional(propagation = Propagation.REQUIRES_NEW)
public void logDataChange(...) {
    // 记录日志
}
```

## 下一步操作

1. **重启后端服务**
2. **执行一个修改操作**（例如修改文物信息）
3. **查看控制台日志输出**
4. **根据日志输出判断问题所在**
5. **将控制台日志截图或复制给我**，我会帮你分析具体问题

## 文件位置

- **Service 实现**：`backend/src/main/java/com/example/service/impl/SysOperationLogServiceImpl.java`
- **Mapper 接口**：`backend/src/main/java/com/example/mapper/SysOperationLogMapper.java`
- **Controller 示例**：`backend/src/main/java/com/example/controller/CulturalRelicController.java`
- **数据库脚本**：`backend/sql/audit_log_enhancement.sql`
- **字段修复脚本**：`backend/sql/audit_log_fix_missing_fields.sql`

## 联系方式

如果遇到问题，请提供：
1. 后端控制台的完整日志输出
2. 数据库表结构（`DESC sys_operation_log` 的结果）
3. 执行的操作类型（新增/修改/删除）
4. 是否有任何错误信息

---

**最后更新**：2026-04-28 17:03
**状态**：等待用户测试并提供日志输出
