-- ========================================
-- 审计日志增强脚本
-- 添加操作前后数据对比功能
-- ========================================

USE cultural_relics;

-- ========================================
-- 1. 增强操作日志表结构
-- ========================================

-- 添加新字段
ALTER TABLE sys_operation_log 
ADD COLUMN IF NOT EXISTS user_id BIGINT COMMENT '操作用户ID',
ADD COLUMN IF NOT EXISTS resource_type VARCHAR(50) COMMENT '资源类型：RELIC-文物，LOAN-借展，REPAIR-修复等',
ADD COLUMN IF NOT EXISTS resource_id BIGINT COMMENT '资源ID',
ADD COLUMN IF NOT EXISTS before_data TEXT COMMENT '操作前数据（JSON格式）',
ADD COLUMN IF NOT EXISTS after_data TEXT COMMENT '操作后数据（JSON格式）',
ADD COLUMN IF NOT EXISTS changed_fields TEXT COMMENT '变更字段列表（JSON格式）',
ADD COLUMN IF NOT EXISTS request_method VARCHAR(10) COMMENT '请求方法：GET, POST, PUT, DELETE',
ADD COLUMN IF NOT EXISTS request_url VARCHAR(500) COMMENT '请求URL',
ADD COLUMN IF NOT EXISTS request_params TEXT COMMENT '请求参数（JSON格式）',
ADD COLUMN IF NOT EXISTS response_data TEXT COMMENT '响应数据（JSON格式）',
ADD COLUMN IF NOT EXISTS error_message TEXT COMMENT '错误信息',
ADD COLUMN IF NOT EXISTS execution_time BIGINT COMMENT '执行时长（毫秒）',
ADD COLUMN IF NOT EXISTS user_agent VARCHAR(500) COMMENT '用户代理',
ADD COLUMN IF NOT EXISTS browser VARCHAR(50) COMMENT '浏览器',
ADD COLUMN IF NOT EXISTS os VARCHAR(50) COMMENT '操作系统';

-- 添加索引
ALTER TABLE sys_operation_log ADD INDEX IF NOT EXISTS idx_user_id (user_id);
ALTER TABLE sys_operation_log ADD INDEX IF NOT EXISTS idx_resource (resource_type, resource_id);
ALTER TABLE sys_operation_log ADD INDEX IF NOT EXISTS idx_operation_type (operation_type);
ALTER TABLE sys_operation_log ADD INDEX IF NOT EXISTS idx_operation_result (operation_result);

-- ========================================
-- 2. 创建数据变更详情表（可选，用于存储大量变更数据）
-- ========================================

CREATE TABLE IF NOT EXISTS sys_data_change_detail (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '主键ID',
    log_id BIGINT NOT NULL COMMENT '操作日志ID',
    field_name VARCHAR(100) NOT NULL COMMENT '字段名称',
    field_label VARCHAR(100) COMMENT '字段标签（中文名）',
    old_value TEXT COMMENT '旧值',
    new_value TEXT COMMENT '新值',
    value_type VARCHAR(50) COMMENT '值类型：STRING, NUMBER, DATE, BOOLEAN, JSON',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_log_id (log_id),
    FOREIGN KEY (log_id) REFERENCES sys_operation_log(id) ON DELETE CASCADE
) COMMENT='数据变更详情表';

-- ========================================
-- 3. 创建审计日志统计视图
-- ========================================

CREATE OR REPLACE VIEW v_operation_log_statistics AS
SELECT 
    DATE(operation_time) AS log_date,
    operation_type,
    operation_module,
    operation_result,
    COUNT(*) AS operation_count,
    COUNT(DISTINCT user_id) AS user_count,
    AVG(execution_time) AS avg_execution_time,
    MAX(execution_time) AS max_execution_time
FROM sys_operation_log
WHERE operation_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(operation_time), operation_type, operation_module, operation_result;

-- ========================================
-- 4. 创建用户操作统计视图
-- ========================================

CREATE OR REPLACE VIEW v_user_operation_statistics AS
SELECT 
    u.id AS user_id,
    u.username,
    u.real_name,
    COUNT(ol.id) AS total_operations,
    COUNT(CASE WHEN ol.operation_result = 'SUCCESS' THEN 1 END) AS success_count,
    COUNT(CASE WHEN ol.operation_result = 'FAIL' THEN 1 END) AS fail_count,
    MAX(ol.operation_time) AS last_operation_time
FROM sys_user u
LEFT JOIN sys_operation_log ol ON u.id = ol.user_id
WHERE ol.operation_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY u.id, u.username, u.real_name;

-- ========================================
-- 5. 创建资源操作历史视图
-- ========================================

CREATE OR REPLACE VIEW v_resource_operation_history AS
SELECT 
    ol.id,
    ol.resource_type,
    ol.resource_id,
    ol.operation_type,
    ol.operation_content,
    ol.operator,
    ol.user_id,
    ol.operation_time,
    ol.before_data,
    ol.after_data,
    ol.changed_fields
FROM sys_operation_log ol
WHERE ol.resource_type IS NOT NULL 
  AND ol.resource_id IS NOT NULL
ORDER BY ol.operation_time DESC;

-- ========================================
-- 6. 插入示例数据（用于测试）
-- ========================================

-- 插入带有数据对比的操作日志示例
INSERT INTO sys_operation_log (
    user_id, operator, operation_type, operation_module, operation_content,
    resource_type, resource_id,
    before_data, after_data, changed_fields,
    operation_result, ip_address, request_method, request_url,
    execution_time, operation_time
) VALUES (
    1, 'admin', '修改', '文物管理', '修改文物信息',
    'RELIC', 1,
    '{"relicName":"商代青铜鼎","status":"正常","location":"展厅A-001"}',
    '{"relicName":"商代青铜鼎","status":"维护中","location":"修复室-101"}',
    '[{"field":"status","label":"状态","oldValue":"正常","newValue":"维护中"},{"field":"location","label":"位置","oldValue":"展厅A-001","newValue":"修复室-101"}]',
    'SUCCESS', '127.0.0.1', 'PUT', '/api/relics/1',
    125, NOW() - INTERVAL 1 HOUR
);

-- 插入对应的变更详情
INSERT INTO sys_data_change_detail (log_id, field_name, field_label, old_value, new_value, value_type) VALUES
(LAST_INSERT_ID(), 'status', '状态', '正常', '维护中', 'STRING'),
(LAST_INSERT_ID(), 'location', '位置', '展厅A-001', '修复室-101', 'STRING');

-- ========================================
-- 7. 创建存储过程：清理旧日志
-- ========================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS sp_clean_old_logs(IN days INT)
BEGIN
    DECLARE deleted_count INT;
    
    -- 删除指定天数之前的日志
    DELETE FROM sys_operation_log 
    WHERE operation_time < DATE_SUB(NOW(), INTERVAL days DAY);
    
    SET deleted_count = ROW_COUNT();
    
    SELECT CONCAT('已删除 ', deleted_count, ' 条日志记录') AS result;
END //

DELIMITER ;

-- ========================================
-- 8. 创建存储过程：获取资源操作历史
-- ========================================

DELIMITER //

CREATE PROCEDURE IF NOT EXISTS sp_get_resource_history(
    IN p_resource_type VARCHAR(50),
    IN p_resource_id BIGINT
)
BEGIN
    SELECT 
        id,
        operation_type,
        operation_content,
        operator,
        operation_time,
        before_data,
        after_data,
        changed_fields,
        ip_address,
        execution_time
    FROM sys_operation_log
    WHERE resource_type = p_resource_type
      AND resource_id = p_resource_id
    ORDER BY operation_time DESC;
END //

DELIMITER ;

-- ========================================
-- 9. 创建触发器：自动记录数据变更详情（可选）
-- ========================================

-- 注意：此触发器仅作为示例，实际使用时需要根据业务需求调整

-- DELIMITER //
-- 
-- CREATE TRIGGER IF NOT EXISTS trg_after_log_insert
-- AFTER INSERT ON sys_operation_log
-- FOR EACH ROW
-- BEGIN
--     -- 如果有变更字段，自动解析并插入详情表
--     IF NEW.changed_fields IS NOT NULL AND NEW.changed_fields != '' THEN
--         -- 这里需要使用存储过程来解析JSON并插入详情
--         -- 由于MySQL的JSON处理限制，建议在应用层处理
--         NULL;
--     END IF;
-- END //
-- 
-- DELIMITER ;

-- ========================================
-- 10. 创建函数：计算数据变更数量
-- ========================================

DELIMITER //

CREATE FUNCTION IF NOT EXISTS fn_count_changes(changed_fields_json TEXT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE change_count INT DEFAULT 0;
    
    IF changed_fields_json IS NOT NULL AND changed_fields_json != '' THEN
        -- 简单计算：统计逗号数量+1
        SET change_count = (LENGTH(changed_fields_json) - LENGTH(REPLACE(changed_fields_json, ',', ''))) + 1;
    END IF;
    
    RETURN change_count;
END //

DELIMITER ;

-- ========================================
-- 完成
-- ========================================

SELECT '========== 审计日志增强完成 ==========' AS '';
SELECT CONCAT('操作日志表字段数: ', COUNT(*), '个') AS result 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME = 'sys_operation_log';

SELECT '已创建视图:' AS '';
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS 
WHERE TABLE_SCHEMA = 'cultural_relics' 
  AND TABLE_NAME LIKE 'v_%operation%';

SELECT '已创建存储过程:' AS '';
SELECT ROUTINE_NAME FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_SCHEMA = 'cultural_relics' 
  AND ROUTINE_TYPE = 'PROCEDURE'
  AND ROUTINE_NAME LIKE 'sp_%';

SELECT '请重启后端服务以应用更改' AS next_step;
