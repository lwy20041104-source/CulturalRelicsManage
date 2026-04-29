-- ========================================
-- 修复申请审批员权限配置
-- 添加维护管理和修复管理权限
-- ========================================

USE cultural_relics;

-- 1. 更新角色名称和描述
UPDATE sys_role 
SET 
    role_name = '申请审批员',
    description = '负责借展、修复、维护申请的审批'
WHERE role_code = 'APPROVER';

-- 2. 查找角色ID
SET @approver_role_id = (SELECT id FROM sys_role WHERE role_code = 'APPROVER');

-- 3. 显示当前APPROVER角色ID
SELECT @approver_role_id AS 'APPROVER角色ID';

-- 4. 为APPROVER角色添加必要的权限
-- 注意：使用 INSERT IGNORE 避免重复插入

-- 权限ID说明（基于db.sql）：
-- 1  - dashboard:view       看板查看
-- 4  - loans:manage         借展管理
-- 5  - maintenance:manage   维护管理
-- 14 - repairs:manage       修复管理（来自complete_repair_permissions.sql）
-- 23 - notifications:view   通知查看（来自complete_repair_permissions.sql）

-- 添加看板查看权限（如果不存在）
INSERT IGNORE INTO sys_role_permission (role_id, permission_id, create_time)
VALUES (@approver_role_id, 1, NOW());

-- 添加借展管理权限（如果不存在）
INSERT IGNORE INTO sys_role_permission (role_id, permission_id, create_time)
VALUES (@approver_role_id, 4, NOW());

-- 添加维护管理权限（如果不存在）
INSERT IGNORE INTO sys_role_permission (role_id, permission_id, create_time)
VALUES (@approver_role_id, 5, NOW());

-- 添加修复管理权限（如果不存在）
INSERT IGNORE INTO sys_role_permission (role_id, permission_id, create_time)
VALUES (@approver_role_id, 14, NOW());

-- 添加通知查看权限（如果不存在）
INSERT IGNORE INTO sys_role_permission (role_id, permission_id, create_time)
VALUES (@approver_role_id, 23, NOW());

-- 5. 删除档案管理权限（如果存在）
DELETE FROM sys_role_permission 
WHERE role_id = @approver_role_id 
  AND permission_id IN (
    SELECT id FROM sys_permission 
    WHERE permission_code IN ('archives:manage', 'archives:view')
  );

-- 6. 验证APPROVER角色的所有权限
SELECT 
    '=== APPROVER角色权限列表 ===' AS '';

SELECT 
    r.role_name AS '角色名称',
    r.role_code AS '角色代码',
    p.id AS '权限ID',
    p.permission_name AS '权限名称',
    p.permission_code AS '权限代码',
    p.permission_type AS '权限类型',
    p.path AS '路径'
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'APPROVER'
ORDER BY p.permission_type, p.id;

-- ========================================
-- 预期结果
-- ========================================
-- APPROVER角色应该有以下权限：
-- 1. dashboard:view      - 看板查看 (MENU)
-- 2. loans:manage        - 借展管理 (MENU)
-- 3. maintenance:manage  - 维护管理 (MENU)
-- 4. repairs:manage      - 修复管理 (MENU)
-- 5. notifications:view  - 通知查看 (API)
--
-- 不应该有：
-- - archives:manage      - 档案管理
-- - archives:view        - 档案查看
-- - users:manage         - 用户管理
-- - relics:manage        - 文物管理
-- - categories:manage    - 分类管理
-- ========================================
