-- ========================================
-- 添加修复申请权限配置
-- 文件: backend/sql/add_repair_apply_permission.sql
-- 创建时间: 2026-04-28
-- 说明: 为文物保管员（CURATOR）角色添加申请修复权限，移除修复管理权限
-- ========================================

USE cultural_relics;

-- 1. 添加新权限
INSERT INTO sys_permission (permission_name, permission_code, permission_type, path, component) VALUES
('申请修复', 'repairs:apply', 'MENU', '/repair-apply', 'RepairApplyView')
ON DUPLICATE KEY UPDATE permission_name = VALUES(permission_name);

-- 2. 获取权限ID和角色ID
SET @permission_id = (SELECT id FROM sys_permission WHERE permission_code = 'repairs:apply');
SET @curator_role_id = (SELECT id FROM sys_role WHERE role_code = 'CURATOR');
SET @repairs_manage_permission_id = (SELECT id FROM sys_permission WHERE permission_code = 'repairs:manage');

-- 3. 为CURATOR角色添加 repairs:apply 权限
INSERT INTO sys_role_permission (role_id, permission_id) 
VALUES (@curator_role_id, @permission_id)
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id);

-- 4. 移除CURATOR角色的 repairs:manage 权限（如果存在）
DELETE FROM sys_role_permission 
WHERE role_id = @curator_role_id 
  AND permission_id = @repairs_manage_permission_id;

-- 5. 添加通知类型（如果表存在）
-- 检查 notification_type 表是否存在
SET @table_exists = (SELECT COUNT(*) FROM information_schema.tables 
                     WHERE table_schema = 'cultural_relics' 
                     AND table_name = 'notification_type');

-- 如果表存在，则插入通知类型
SET @sql_insert_notification_types = IF(@table_exists > 0,
    "INSERT INTO notification_type (type_code, type_name, description, enabled) VALUES
    ('REPAIR_APPROVED', '修复申请已通过', '您申请的文物修复已通过审批', 1),
    ('REPAIR_REJECTED', '修复申请已拒绝', '您申请的文物修复已被拒绝', 1),
    ('REPAIR_COMPLETED', '修复已完成', '您申请的文物修复已完成', 1)
    ON DUPLICATE KEY UPDATE type_name = VALUES(type_name)",
    "SELECT '通知类型表不存在，跳过通知配置' AS message"
);

PREPARE stmt FROM @sql_insert_notification_types;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 6. 为所有CURATOR角色用户创建通知配置（如果表存在）
SET @config_table_exists = (SELECT COUNT(*) FROM information_schema.tables 
                            WHERE table_schema = 'cultural_relics' 
                            AND table_name = 'notification_config');

-- 如果配置表存在，则为CURATOR用户添加通知配置
SET @sql_insert_notification_config = IF(@config_table_exists > 0 AND @table_exists > 0,
    "INSERT INTO notification_config (user_id, notification_type, enabled)
    SELECT u.id, 'REPAIR_APPROVED', 1
    FROM sys_user u
    WHERE u.role_id = @curator_role_id
    ON DUPLICATE KEY UPDATE enabled = enabled;
    
    INSERT INTO notification_config (user_id, notification_type, enabled)
    SELECT u.id, 'REPAIR_REJECTED', 1
    FROM sys_user u
    WHERE u.role_id = @curator_role_id
    ON DUPLICATE KEY UPDATE enabled = enabled;
    
    INSERT INTO notification_config (user_id, notification_type, enabled)
    SELECT u.id, 'REPAIR_COMPLETED', 1
    FROM sys_user u
    WHERE u.role_id = @curator_role_id
    ON DUPLICATE KEY UPDATE enabled = enabled",
    "SELECT '通知配置表不存在，跳过通知配置' AS message"
);

-- 注意：由于动态SQL的限制，这部分可能需要手动执行
-- 如果上面的动态SQL执行失败，请手动执行以下语句：
/*
INSERT INTO notification_config (user_id, notification_type, enabled)
SELECT u.id, 'REPAIR_APPROVED', 1
FROM sys_user u
WHERE u.role_id = (SELECT id FROM sys_role WHERE role_code = 'CURATOR')
ON DUPLICATE KEY UPDATE enabled = enabled;

INSERT INTO notification_config (user_id, notification_type, enabled)
SELECT u.id, 'REPAIR_REJECTED', 1
FROM sys_user u
WHERE u.role_id = (SELECT id FROM sys_role WHERE role_code = 'CURATOR')
ON DUPLICATE KEY UPDATE enabled = enabled;

INSERT INTO notification_config (user_id, notification_type, enabled)
SELECT u.id, 'REPAIR_COMPLETED', 1
FROM sys_user u
WHERE u.role_id = (SELECT id FROM sys_role WHERE role_code = 'CURATOR')
ON DUPLICATE KEY UPDATE enabled = enabled;
*/

-- ========================================
-- 验证结果
-- ========================================

SELECT '========================================' AS '';
SELECT '权限配置完成' AS '状态';
SELECT '========================================' AS '';

-- 显示CURATOR角色的权限
SELECT 
    r.role_name AS '角色',
    p.permission_name AS '权限',
    p.permission_code AS '权限代码',
    p.path AS '路径'
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR'
ORDER BY p.permission_code;

-- 显示通知类型配置（如果表存在）
SELECT '========================================' AS '';
SELECT '通知类型配置' AS '状态';
SELECT '========================================' AS '';

SET @show_notification_types = IF(@table_exists > 0,
    "SELECT type_code AS '类型代码', type_name AS '类型名称', description AS '描述', enabled AS '启用'
    FROM notification_type
    WHERE type_code LIKE 'REPAIR_%'",
    "SELECT '通知类型表不存在' AS message"
);

PREPARE stmt FROM @show_notification_types;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 显示CURATOR用户数量
SELECT '========================================' AS '';
SELECT 'CURATOR用户统计' AS '状态';
SELECT '========================================' AS '';

SELECT 
    COUNT(*) AS 'CURATOR用户数量',
    GROUP_CONCAT(username SEPARATOR ', ') AS '用户名列表'
FROM sys_user
WHERE role_id = @curator_role_id;

SELECT '========================================' AS '';
SELECT '配置完成！' AS '状态';
SELECT '========================================' AS '';
