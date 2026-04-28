# 修复审计日志缺失字段

## 问题说明

执行 `audit_log_enhancement.sql` 后，发现以下关键字段缺失：
- `user_id`
- `resource_type`
- `resource_id`
- `before_data`
- `after_data`
- `changed_fields`
- `request_method`
- `request_url`
- `ip_address`
- `operation_result`

## 解决方案

我已经创建了一个修复脚本：`backend/sql/audit_log_fix_missing_fields.sql`

这个脚本会：
1. 检查每个字段是否存在
2. 只添加缺失的字段
3. 不会重复添加已存在的字段
4. 添加必要的索引

## 执行步骤

### 方法1：直接执行修复脚本

```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_fix_missing_fields.sql
```

### 方法2：手动执行SQL（如果方法1失败）

登录MySQL：
```bash
mysql -u root -p cultural_relics
```

然后逐个执行以下SQL：

```sql
-- 1. 添加 user_id
ALTER TABLE sys_operation_log ADD COLUMN user_id BIGINT COMMENT '操作用户ID' AFTER id;

-- 2. 添加 resource_type
ALTER TABLE sys_operation_log ADD COLUMN resource_type VARCHAR(50) COMMENT '资源类型' AFTER operation_result;

-- 3. 添加 resource_id
ALTER TABLE sys_operation_log ADD COLUMN resource_id BIGINT COMMENT '资源ID' AFTER resource_type;

-- 4. 添加 before_data
ALTER TABLE sys_operation_log ADD COLUMN before_data TEXT COMMENT '操作前数据（JSON格式）' AFTER resource_id;

-- 5. 添加 after_data
ALTER TABLE sys_operation_log ADD COLUMN after_data TEXT COMMENT '操作后数据（JSON格式）' AFTER before_data;

-- 6. 添加 changed_fields
ALTER TABLE sys_operation_log ADD COLUMN changed_fields TEXT COMMENT '变更字段列表（JSON格式）' AFTER after_data;

-- 7. 添加 request_method
ALTER TABLE sys_operation_log ADD COLUMN request_method VARCHAR(10) COMMENT '请求方法' AFTER changed_fields;

-- 8. 添加 request_url
ALTER TABLE sys_operation_log ADD COLUMN request_url VARCHAR(500) COMMENT '请求URL' AFTER request_method;

-- 9. 添加 ip_address（如果不存在）
ALTER TABLE sys_operation_log ADD COLUMN ip_address VARCHAR(50) COMMENT 'IP地址' AFTER request_url;

-- 10. 添加 operation_result（如果不存在）
ALTER TABLE sys_operation_log ADD COLUMN operation_result VARCHAR(20) DEFAULT 'SUCCESS' COMMENT '操作结果' AFTER operation_content;

-- 11. 添加索引
ALTER TABLE sys_operation_log ADD INDEX idx_user_id (user_id);
ALTER TABLE sys_operation_log ADD INDEX idx_resource (resource_type, resource_id);
```

## 验证

执行完成后，验证表结构：

```bash
mysql -u root -p cultural_relics -e "DESC sys_operation_log;"
```

应该看到以下字段：

```
+-------------------+---------------+------+-----+---------+----------------+
| Field             | Type          | Null | Key | Default | Extra          |
+-------------------+---------------+------+-----+---------+----------------+
| id                | bigint        | NO   | PRI | NULL    | auto_increment |
| user_id           | bigint        | YES  | MUL | NULL    |                | ← 新增
| operator          | varchar(50)   | NO   |     | NULL    |                |
| operation_type    | varchar(50)   | NO   | MUL | NULL    |                |
| operation_module  | varchar(50)   | NO   |     | NULL    |                |
| operation_content | varchar(1000) | YES  |     | NULL    |                |
| operation_result  | varchar(20)   | YES  |     | SUCCESS |                | ← 新增
| resource_type     | varchar(50)   | YES  | MUL | NULL    |                | ← 新增
| resource_id       | bigint        | YES  |     | NULL    |                | ← 新增
| before_data       | text          | YES  |     | NULL    |                | ← 新增
| after_data        | text          | YES  |     | NULL    |                | ← 新增
| changed_fields    | text          | YES  |     | NULL    |                | ← 新增
| request_method    | varchar(10)   | YES  |     | NULL    |                | ← 新增
| request_url       | varchar(500)  | YES  |     | NULL    |                | ← 新增
| ip_address        | varchar(50)   | YES  |     | NULL    |                | ← 新增
| request_params    | text          | YES  |     | NULL    |                |
| response_data     | text          | YES  |     | NULL    |                |
| error_message     | text          | YES  |     | NULL    |                |
| execution_time    | bigint        | YES  |     | NULL    |                |
| user_agent        | varchar(500)  | YES  |     | NULL    |                |
| browser           | varchar(50)   | YES  |     | NULL    |                |
| os                | varchar(50)   | YES  |     | NULL    |                |
| operation_time    | datetime      | YES  |     | NULL    |                |
+-------------------+---------------+------+-----+---------+----------------+
```

## 完成后的步骤

1. **重启后端服务**
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **执行一些操作**
   - 登录系统
   - 修改一个文物信息
   - 修改一个用户信息

3. **查看审计日志**
   - 进入"审计日志"页面
   - 点击最新记录的"详情"按钮
   - 现在应该能看到：
     - ✅ 数据对比区域
     - ✅ 变更字段列表
     - ✅ 完整数据对比（JSON格式）

## 测试SQL

执行操作后，可以用这个SQL验证数据：

```sql
-- 查看最新的日志记录
SELECT 
    id,
    operator,
    operation_type,
    operation_module,
    resource_type,
    resource_id,
    LENGTH(before_data) as before_data_length,
    LENGTH(after_data) as after_data_length,
    LENGTH(changed_fields) as changed_fields_length,
    operation_time
FROM sys_operation_log 
ORDER BY operation_time DESC 
LIMIT 5;
```

如果看到 `before_data_length`、`after_data_length`、`changed_fields_length` 有值（不是NULL），说明数据对比功能正常工作！

## 故障排查

### 问题1：字段已存在错误

如果看到类似 `Duplicate column name 'xxx'` 的错误，说明该字段已经存在，可以忽略这个错误。

### 问题2：权限不足

如果看到 `Access denied` 错误，确保使用的MySQL用户有 ALTER TABLE 权限。

### 问题3：表不存在

如果看到 `Table 'sys_operation_log' doesn't exist`，需要先执行基础的数据库脚本创建表。

---

**文档版本**: 1.0  
**创建时间**: 2026-04-28  
**适用场景**: 修复audit_log_enhancement.sql执行后缺失字段的问题
