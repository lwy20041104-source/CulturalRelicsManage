-- ========================================
-- 审计日志表验证脚本
-- 用于检查 sys_operation_log 表是否正确配置
-- ========================================

USE cultural_relics;

-- ========================================
-- 1. 检查表是否存在
-- ========================================
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ sys_operation_log 表存在'
        ELSE '✗ sys_operation_log 表不存在'
    END AS table_check
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'sys_operation_log';

-- ========================================
-- 2. 查看表结构（所有字段）
-- ========================================
SELECT 
    COLUMN_NAME AS '字段名',
    DATA_TYPE AS '数据类型',
    CHARACTER_MAXIMUM_LENGTH AS '最大长度',
    IS_NULLABLE AS '允许NULL',
    COLUMN_DEFAULT AS '默认值',
    COLUMN_COMMENT AS '注释'
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'sys_operation_log'
ORDER BY ORDINAL_POSITION;

-- ========================================
-- 3. 检查必需字段是否存在
-- ========================================
SELECT 
    '必需字段检查' AS check_type,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'id' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS id_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'user_id' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS user_id_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'operator' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS operator_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'operation_type' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS operation_type_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'operation_module' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS operation_module_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'operation_content' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS operation_content_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'resource_type' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS resource_type_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'resource_id' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS resource_id_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'before_data' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS before_data_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'after_data' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS after_data_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'changed_fields' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS changed_fields_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'operation_result' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS operation_result_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'ip_address' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS ip_address_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'request_method' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS request_method_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'request_url' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS request_url_field,
    CASE 
        WHEN SUM(CASE WHEN COLUMN_NAME = 'operation_time' THEN 1 ELSE 0 END) > 0 THEN '✓' ELSE '✗'
    END AS operation_time_field
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'sys_operation_log';

-- ========================================
-- 4. 检查索引
-- ========================================
SELECT 
    INDEX_NAME AS '索引名',
    COLUMN_NAME AS '字段名',
    NON_UNIQUE AS '非唯一',
    SEQ_IN_INDEX AS '序号'
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'sys_operation_log'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- ========================================
-- 5. 检查表中的数据
-- ========================================
SELECT 
    COUNT(*) AS '总记录数',
    COUNT(CASE WHEN operation_result = '成功' THEN 1 END) AS '成功记录数',
    COUNT(CASE WHEN operation_result = 'SUCCESS' THEN 1 END) AS 'SUCCESS记录数',
    COUNT(CASE WHEN operation_result = '失败' THEN 1 END) AS '失败记录数',
    COUNT(CASE WHEN operation_result = 'FAIL' THEN 1 END) AS 'FAIL记录数',
    COUNT(CASE WHEN before_data IS NOT NULL THEN 1 END) AS '有before_data的记录',
    COUNT(CASE WHEN after_data IS NOT NULL THEN 1 END) AS '有after_data的记录',
    COUNT(CASE WHEN changed_fields IS NOT NULL THEN 1 END) AS '有changed_fields的记录'
FROM sys_operation_log;

-- ========================================
-- 6. 查看最近的5条记录
-- ========================================
SELECT 
    id,
    user_id,
    operator,
    operation_type,
    operation_module,
    operation_content,
    resource_type,
    resource_id,
    operation_result,
    CASE 
        WHEN before_data IS NOT NULL THEN CONCAT('有数据(', LENGTH(before_data), '字节)')
        ELSE 'NULL'
    END AS before_data_status,
    CASE 
        WHEN after_data IS NOT NULL THEN CONCAT('有数据(', LENGTH(after_data), '字节)')
        ELSE 'NULL'
    END AS after_data_status,
    CASE 
        WHEN changed_fields IS NOT NULL THEN CONCAT('有数据(', LENGTH(changed_fields), '字节)')
        ELSE 'NULL'
    END AS changed_fields_status,
    operation_time
FROM sys_operation_log
ORDER BY operation_time DESC
LIMIT 5;

-- ========================================
-- 7. 测试插入一条记录
-- ========================================
INSERT INTO sys_operation_log (
    user_id, operator, operation_type, operation_module, operation_content,
    resource_type, resource_id, before_data, after_data, changed_fields,
    operation_result, ip_address, request_method, request_url, request_params,
    response_data, error_message, execution_time, user_agent, browser, os, operation_time
) VALUES (
    999, '测试用户', '测试', '测试模块', '测试插入操作',
    'TEST', 999, '{"test":"before"}', '{"test":"after"}', '[{"field":"test","oldValue":"before","newValue":"after"}]',
    '成功', '127.0.0.1', 'POST', '/test', '{}',
    '{}', NULL, 100, 'Test Agent', 'Chrome', 'Windows', NOW()
);

-- 查看刚插入的记录
SELECT 
    id,
    operator,
    operation_type,
    operation_content,
    operation_result,
    operation_time
FROM sys_operation_log
WHERE operator = '测试用户'
ORDER BY id DESC
LIMIT 1;

-- 删除测试记录
DELETE FROM sys_operation_log WHERE operator = '测试用户';

SELECT '测试记录已删除' AS cleanup_status;

-- ========================================
-- 8. 检查表权限
-- ========================================
SHOW GRANTS FOR CURRENT_USER();

-- ========================================
-- 完成
-- ========================================
SELECT '========== 验证完成 ==========' AS '';
SELECT '如果所有检查都显示 ✓，说明表结构正确' AS result;
SELECT '如果测试插入成功，说明表可以正常写入数据' AS result;
SELECT '如果后端仍然无法插入数据，请检查后端日志' AS next_step;
