-- ========================================
-- 审计日志修复脚本 - 添加缺失字段
-- ========================================

USE cultural_relics;

-- 检查并添加缺失的字段

-- 1. 添加 user_id 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'user_id';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN user_id BIGINT COMMENT ''操作用户ID'' AFTER id',
    'SELECT ''user_id字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. 添加 resource_type 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'resource_type';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN resource_type VARCHAR(50) COMMENT ''资源类型'' AFTER operation_result',
    'SELECT ''resource_type字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. 添加 resource_id 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'resource_id';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN resource_id BIGINT COMMENT ''资源ID'' AFTER resource_type',
    'SELECT ''resource_id字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4. 添加 before_data 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'before_data';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN before_data TEXT COMMENT ''操作前数据（JSON格式）'' AFTER resource_id',
    'SELECT ''before_data字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 5. 添加 after_data 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'after_data';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN after_data TEXT COMMENT ''操作后数据（JSON格式）'' AFTER before_data',
    'SELECT ''after_data字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 6. 添加 changed_fields 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'changed_fields';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN changed_fields TEXT COMMENT ''变更字段列表（JSON格式）'' AFTER after_data',
    'SELECT ''changed_fields字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 7. 添加 request_method 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'request_method';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN request_method VARCHAR(10) COMMENT ''请求方法'' AFTER changed_fields',
    'SELECT ''request_method字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 8. 添加 request_url 字段
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'request_url';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN request_url VARCHAR(500) COMMENT ''请求URL'' AFTER request_method',
    'SELECT ''request_url字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 9. 添加 ip_address 字段（如果不存在）
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'ip_address';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN ip_address VARCHAR(50) COMMENT ''IP地址'' AFTER request_url',
    'SELECT ''ip_address字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 10. 添加 operation_result 字段（如果不存在）
SET @col_exists = 0;
SELECT COUNT(*) INTO @col_exists 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND COLUMN_NAME = 'operation_result';

SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_operation_log ADD COLUMN operation_result VARCHAR(20) DEFAULT ''SUCCESS'' COMMENT ''操作结果'' AFTER operation_content',
    'SELECT ''operation_result字段已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 添加索引
SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND INDEX_NAME = 'idx_user_id';

SET @sql = IF(@index_exists = 0,
    'ALTER TABLE sys_operation_log ADD INDEX idx_user_id (user_id)',
    'SELECT ''idx_user_id索引已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @index_exists = 0;
SELECT COUNT(*) INTO @index_exists 
FROM INFORMATION_SCHEMA.STATISTICS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log' 
  AND INDEX_NAME = 'idx_resource';

SET @sql = IF(@index_exists = 0,
    'ALTER TABLE sys_operation_log ADD INDEX idx_resource (resource_type, resource_id)',
    'SELECT ''idx_resource索引已存在'' AS info');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 显示最终的表结构
SELECT '========== 修复完成 ==========' AS '';
SELECT '当前sys_operation_log表结构:' AS '';
DESC sys_operation_log;

SELECT CONCAT('操作日志表字段数: ', COUNT(*), '个') AS result 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log';

SELECT '请重启后端服务以应用更改' AS next_step;
