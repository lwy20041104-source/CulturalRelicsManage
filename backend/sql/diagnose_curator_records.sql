-- ========================================
-- 诊断保管员修复记录显示问题
-- ========================================

USE cultural_relics_management;

-- 1. 查看所有用户及其角色
SELECT '========== 所有用户信息 ==========' AS '';
SELECT 
    u.id AS user_id,
    u.username,
    u.real_name,
    r.id AS role_id,
    r.role_name,
    r.role_code,
    u.status
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
ORDER BY u.id;

-- 2. 查看所有修复记录及其申请人信息
SELECT '========== 所有修复记录 ==========' AS '';
SELECT 
    rr.id AS repair_id,
    rr.relic_name,
    rr.status,
    rr.applicant_id,
    rr.applicant,
    u.id AS user_id,
    u.username AS applicant_username,
    u.real_name AS applicant_real_name,
    r.role_code AS applicant_role
FROM repair_record rr
LEFT JOIN sys_user u ON rr.applicant_id = u.id
LEFT JOIN sys_role r ON u.role_id = r.id
ORDER BY rr.id;

-- 3. 查看保管员用户的修复记录
SELECT '========== 保管员的修复记录 ==========' AS '';
SELECT 
    u.id AS curator_id,
    u.username AS curator_username,
    u.real_name AS curator_name,
    COUNT(rr.id) AS repair_count,
    GROUP_CONCAT(rr.id ORDER BY rr.id) AS repair_ids
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
LEFT JOIN repair_record rr ON rr.applicant_id = u.id
WHERE r.role_code = 'CURATOR'
GROUP BY u.id, u.username, u.real_name;

-- 4. 检查 applicant_id 是否为 NULL
SELECT '========== applicant_id 为 NULL 的记录 ==========' AS '';
SELECT 
    id,
    relic_name,
    status,
    applicant_id,
    applicant,
    create_time
FROM repair_record
WHERE applicant_id IS NULL
ORDER BY id;

-- 5. 检查 applicant 字段与用户名的匹配情况
SELECT '========== applicant 字段匹配检查 ==========' AS '';
SELECT 
    rr.id AS repair_id,
    rr.applicant AS applicant_field,
    rr.applicant_id,
    u.username AS matched_username,
    u.real_name AS matched_real_name,
    CASE 
        WHEN rr.applicant_id IS NULL THEN '❌ applicant_id为空'
        WHEN u.id IS NULL THEN '❌ 找不到对应用户'
        WHEN rr.applicant = u.username THEN '✅ 匹配正确'
        ELSE '⚠️ applicant与username不匹配'
    END AS match_status
FROM repair_record rr
LEFT JOIN sys_user u ON rr.applicant_id = u.id
ORDER BY rr.id;

-- 6. 查看当前登录的保管员应该看到的记录（假设保管员username是curator01）
SELECT '========== curator01 应该看到的记录 ==========' AS '';
SELECT 
    rr.id,
    rr.relic_name,
    rr.status,
    rr.applicant,
    rr.applicant_id,
    u.username,
    u.real_name
FROM repair_record rr
JOIN sys_user u ON rr.applicant_id = u.id
WHERE u.username = 'curator01'
ORDER BY rr.id;

-- 7. 统计各状态的记录数
SELECT '========== 各状态记录统计 ==========' AS '';
SELECT 
    status,
    COUNT(*) AS count,
    GROUP_CONCAT(id ORDER BY id) AS record_ids
FROM repair_record
GROUP BY status
ORDER BY 
    FIELD(status, '待审批', '待修复', '修复中', '修复完成', '已拒绝');
