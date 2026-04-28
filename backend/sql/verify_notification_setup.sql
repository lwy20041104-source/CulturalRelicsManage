-- ========================================
-- 通知系统配置验证脚本
-- ========================================

-- 1. 检查角色配置
-- ========================================
SELECT '=== 1. 角色配置检查 ===' AS '';

SELECT 
    id,
    role_name,
    role_code,
    description,
    status,
    CASE 
        WHEN status = 1 THEN '✓ 已启用'
        ELSE '✗ 已禁用'
    END AS status_text
FROM sys_role
WHERE role_code IN ('ADMIN', 'APPROVER', 'CURATOR')
ORDER BY id;

-- 预期结果：
-- ADMIN (系统管理员) - 已启用
-- APPROVER (借展审批员) - 已启用
-- CURATOR (文物保管员) - 已启用


-- 2. 检查管理员和审批员用户
-- ========================================
SELECT '=== 2. 管理员和审批员用户检查 ===' AS '';

SELECT 
    u.id,
    u.username,
    u.real_name,
    r.role_name,
    r.role_code,
    u.status,
    CASE 
        WHEN u.status = 1 THEN '✓ 已启用'
        WHEN u.status = 0 THEN '✗ 已禁用'
        ELSE '? 未知状态'
    END AS status_text,
    u.email,
    u.phone
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE r.role_code IN ('ADMIN', 'APPROVER')
ORDER BY r.role_code, u.id;

-- 预期结果：
-- 至少有1个ADMIN用户（status=1）
-- 至少有1个APPROVER用户（status=1）


-- 3. 检查借展人用户
-- ========================================
SELECT '=== 3. 借展人用户检查 ===' AS '';

SELECT 
    u.id,
    u.username,
    u.real_name,
    r.role_name,
    r.role_code,
    u.status,
    CASE 
        WHEN u.status = 1 THEN '✓ 已启用'
        ELSE '✗ 已禁用'
    END AS status_text
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE r.role_code = 'LOANER'
ORDER BY u.id;


-- 4. 检查通知配置表
-- ========================================
SELECT '=== 4. 通知配置检查 ===' AS '';

-- 检查是否有禁用LOAN_APPLY通知的用户
SELECT 
    nc.id,
    nc.user_id,
    u.username,
    u.real_name,
    nc.notification_type,
    nc.enabled,
    CASE 
        WHEN nc.enabled = 1 THEN '✓ 已启用'
        ELSE '✗ 已禁用'
    END AS enabled_text
FROM notification_config nc
LEFT JOIN sys_user u ON nc.user_id = u.id
WHERE nc.notification_type = 'LOAN_APPLY'
ORDER BY nc.user_id;

-- 如果没有记录，说明所有用户使用默认配置（启用）


-- 5. 检查最近的展借申请通知
-- ========================================
SELECT '=== 5. 最近的展借申请通知 ===' AS '';

SELECT 
    sn.id,
    sn.title,
    sn.content,
    sn.type,
    sn.priority,
    sn.sender_name,
    sn.create_time,
    COUNT(un.id) AS recipient_count
FROM system_notification sn
LEFT JOIN user_notification un ON sn.id = un.notification_id
WHERE sn.type = 'LOAN_APPLY'
GROUP BY sn.id
ORDER BY sn.create_time DESC
LIMIT 10;


-- 6. 检查用户通知关联
-- ========================================
SELECT '=== 6. 最近的用户通知关联 ===' AS '';

SELECT 
    un.id,
    un.user_id,
    u.username,
    u.real_name,
    r.role_code,
    sn.title,
    sn.type,
    un.is_read,
    CASE 
        WHEN un.is_read = 1 THEN '✓ 已读'
        ELSE '✗ 未读'
    END AS read_status,
    un.create_time,
    un.read_time
FROM user_notification un
LEFT JOIN system_notification sn ON un.notification_id = sn.id
LEFT JOIN sys_user u ON un.user_id = u.id
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE sn.type = 'LOAN_APPLY'
ORDER BY un.create_time DESC
LIMIT 20;


-- 7. 统计各角色收到的通知数量
-- ========================================
SELECT '=== 7. 各角色通知统计 ===' AS '';

SELECT 
    r.role_code,
    r.role_name,
    COUNT(DISTINCT u.id) AS user_count,
    COUNT(un.id) AS notification_count,
    SUM(CASE WHEN un.is_read = 0 THEN 1 ELSE 0 END) AS unread_count,
    SUM(CASE WHEN un.is_read = 1 THEN 1 ELSE 0 END) AS read_count
FROM sys_role r
LEFT JOIN sys_user u ON r.id = u.role_id AND u.status = 1
LEFT JOIN user_notification un ON u.id = un.user_id
LEFT JOIN system_notification sn ON un.notification_id = sn.id AND sn.type = 'LOAN_APPLY'
WHERE r.role_code IN ('ADMIN', 'APPROVER')
GROUP BY r.id, r.role_code, r.role_name
ORDER BY r.role_code;


-- 8. 检查可借展的文物
-- ========================================
SELECT '=== 8. 可借展文物检查 ===' AS '';

SELECT 
    id,
    relic_name,
    relic_code,
    status,
    CASE 
        WHEN status = '在库' THEN '✓ 可借展'
        ELSE '✗ 不可借展'
    END AS loan_status
FROM cultural_relic
WHERE status = '在库'
ORDER BY id
LIMIT 10;


-- 9. 检查最近的展借记录
-- ========================================
SELECT '=== 9. 最近的展借记录 ===' AS '';

SELECT 
    lr.id,
    lr.relic_id,
    cr.relic_name,
    lr.borrower_id,
    lr.borrower_name,
    lr.status,
    lr.loan_date,
    lr.expected_return_date,
    lr.create_time
FROM loan_record lr
LEFT JOIN cultural_relic cr ON lr.relic_id = cr.id
ORDER BY lr.create_time DESC
LIMIT 10;


-- 10. 诊断建议
-- ========================================
SELECT '=== 10. 诊断建议 ===' AS '';

-- 检查是否有管理员
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ 有管理员用户'
        ELSE '✗ 警告：没有管理员用户！'
    END AS admin_check
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE r.role_code = 'ADMIN' AND u.status = 1;

-- 检查是否有审批员
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ 有审批员用户'
        ELSE '✗ 警告：没有审批员用户！'
    END AS approver_check
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE r.role_code = 'APPROVER' AND u.status = 1;

-- 检查是否有借展人
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN '✓ 有借展人用户'
        ELSE '✗ 警告：没有借展人用户！'
    END AS loaner_check
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE r.role_code = 'LOANER' AND u.status = 1;

-- 检查是否有可借展文物
SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN CONCAT('✓ 有 ', COUNT(*), ' 件可借展文物')
        ELSE '✗ 警告：没有可借展文物！'
    END AS relic_check
FROM cultural_relic
WHERE status = '在库';


-- ========================================
-- 修复脚本（如果需要）
-- ========================================

-- 如果没有管理员，创建一个
-- INSERT INTO sys_user (username, password, real_name, email, phone, status, role_id, create_time)
-- SELECT 'admin', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '系统管理员', 'admin@museum.com', '13800138000', 1, id, NOW()
-- FROM sys_role WHERE role_code = 'ADMIN'
-- WHERE NOT EXISTS (SELECT 1 FROM sys_user u LEFT JOIN sys_role r ON u.role_id = r.id WHERE r.role_code = 'ADMIN');

-- 如果没有审批员，创建一个
-- INSERT INTO sys_user (username, password, real_name, email, phone, status, role_id, create_time)
-- SELECT 'approver01', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '审批员', 'approver@museum.com', '13800138001', 1, id, NOW()
-- FROM sys_role WHERE role_code = 'APPROVER'
-- WHERE NOT EXISTS (SELECT 1 FROM sys_user u LEFT JOIN sys_role r ON u.role_id = r.id WHERE r.role_code = 'APPROVER');

-- 启用所有管理员和审批员的账号
-- UPDATE sys_user u
-- LEFT JOIN sys_role r ON u.role_id = r.id
-- SET u.status = 1
-- WHERE r.role_code IN ('ADMIN', 'APPROVER');
