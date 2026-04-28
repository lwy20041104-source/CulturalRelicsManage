-- ========================================
-- 完善修复管理权限系统
-- ========================================
-- 说明：
-- 1. 添加修复管理相关的权限到 sys_permission 表
-- 2. 为各角色分配相应的权限到 sys_role_permission 表
-- 3. ID从现有数据继续递增
-- ========================================

USE cultural_relics_management;

-- ========================================
-- 1. 添加修复管理相关权限
-- ========================================

-- 检查并添加"修复管理"权限（管理员使用）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (14, '修复管理', 'repairs:manage', 'MENU', '/repairs', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"修复审批"权限（API操作）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (15, '修复审批', 'repairs:approve', 'API', '/repairs/approve', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"修复进度更新"权限（API操作）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (16, '修复进度', 'repairs:progress', 'API', '/repairs/progress', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"修复完成"权限（API操作）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (17, '修复完成', 'repairs:complete', 'API', '/repairs/complete', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"修复删除"权限（API操作）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (18, '修复删除', 'repairs:delete', 'API', '/repairs/delete', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"修复统计"权限（API操作）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (19, '修复统计', 'repairs:statistics', 'API', '/repairs/statistics', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"博物馆管理"权限（管理员专用）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (20, '博物馆管理', 'museums:manage', 'MENU', '/museums', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"备份管理"权限（管理员专用）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (21, '备份管理', 'backups:manage', 'MENU', '/backups', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"AI对话管理"权限（管理员专用）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (22, 'AI对话管理', 'ai-chat:manage', 'MENU', '/ai-chat', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- 检查并添加"通知管理"权限（所有角色）
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, create_time)
VALUES (23, '通知查看', 'notifications:view', 'API', '/notifications', NOW())
ON DUPLICATE KEY UPDATE 
    permission_name = VALUES(permission_name),
    permission_code = VALUES(permission_code);

-- ========================================
-- 2. 为ADMIN角色（role_id=1）分配所有权限
-- ========================================

-- ADMIN拥有所有权限（id 14-23）
INSERT INTO sys_role_permission (id, role_id, permission_id, create_time)
VALUES 
    (22, 1, 14, NOW()),  -- 修复管理
    (23, 1, 15, NOW()),  -- 修复审批
    (24, 1, 16, NOW()),  -- 修复进度
    (25, 1, 17, NOW()),  -- 修复完成
    (26, 1, 18, NOW()),  -- 修复删除
    (27, 1, 19, NOW()),  -- 修复统计
    (28, 1, 20, NOW()),  -- 博物馆管理
    (29, 1, 21, NOW()),  -- 备份管理
    (30, 1, 22, NOW()),  -- AI对话管理
    (31, 1, 23, NOW())   -- 通知查看
ON DUPLICATE KEY UPDATE 
    role_id = VALUES(role_id),
    permission_id = VALUES(permission_id);

-- ========================================
-- 3. 为CURATOR角色（role_id=2）分配权限
-- ========================================

-- CURATOR拥有：申请修复、查看通知
-- 注意：CURATOR已有 repairs:apply (permission_id=13)
INSERT INTO sys_role_permission (id, role_id, permission_id, create_time)
VALUES 
    (32, 2, 18, NOW()),  -- 修复删除（只能删除自己的）
    (33, 2, 23, NOW())   -- 通知查看
ON DUPLICATE KEY UPDATE 
    role_id = VALUES(role_id),
    permission_id = VALUES(permission_id);

-- ========================================
-- 4. 为APPROVER角色（role_id=3）分配权限
-- ========================================

-- APPROVER拥有：借展审批、查看通知
INSERT INTO sys_role_permission (id, role_id, permission_id, create_time)
VALUES 
    (34, 3, 23, NOW())   -- 通知查看
ON DUPLICATE KEY UPDATE 
    role_id = VALUES(role_id),
    permission_id = VALUES(permission_id);

-- ========================================
-- 5. 为LOANER角色（role_id=4）分配权限
-- ========================================

-- LOANER拥有：查看文物、申请借展、查看通知
INSERT INTO sys_role_permission (id, role_id, permission_id, create_time)
VALUES 
    (35, 4, 1, NOW()),   -- 看板查看
    (36, 4, 2, NOW()),   -- 文物管理（只读）
    (37, 4, 4, NOW()),   -- 借展管理（申请）
    (38, 4, 23, NOW())   -- 通知查看
ON DUPLICATE KEY UPDATE 
    role_id = VALUES(role_id),
    permission_id = VALUES(permission_id);

-- ========================================
-- 验证结果
-- ========================================

SELECT '========== 权限表数据 ==========' AS '';
SELECT id, permission_name, permission_code, permission_type, path
FROM sys_permission
ORDER BY id;

SELECT '========== ADMIN角色权限 ==========' AS '';
SELECT 
    rp.id,
    r.role_name,
    p.permission_name,
    p.permission_code,
    p.permission_type
FROM sys_role_permission rp
JOIN sys_role r ON rp.role_id = r.id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'ADMIN'
ORDER BY rp.id;

SELECT '========== CURATOR角色权限 ==========' AS '';
SELECT 
    rp.id,
    r.role_name,
    p.permission_name,
    p.permission_code,
    p.permission_type
FROM sys_role_permission rp
JOIN sys_role r ON rp.role_id = r.id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR'
ORDER BY rp.id;

SELECT '========== APPROVER角色权限 ==========' AS '';
SELECT 
    rp.id,
    r.role_name,
    p.permission_name,
    p.permission_code,
    p.permission_type
FROM sys_role_permission rp
JOIN sys_role r ON rp.role_id = r.id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'APPROVER'
ORDER BY rp.id;

SELECT '========== LOANER角色权限 ==========' AS '';
SELECT 
    rp.id,
    r.role_name,
    p.permission_name,
    p.permission_code,
    p.permission_type
FROM sys_role_permission rp
JOIN sys_role r ON rp.role_id = r.id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'LOANER'
ORDER BY rp.id;

SELECT '========== 权限统计 ==========' AS '';
SELECT 
    r.role_name AS '角色',
    r.role_code AS '角色代码',
    COUNT(rp.permission_id) AS '权限数量'
FROM sys_role r
LEFT JOIN sys_role_permission rp ON r.id = rp.role_id
GROUP BY r.id, r.role_name, r.role_code
ORDER BY r.id;
