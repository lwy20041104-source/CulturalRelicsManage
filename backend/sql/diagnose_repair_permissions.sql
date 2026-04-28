-- ========================================
-- 修复管理权限诊断脚本
-- ========================================
-- 用途：诊断为什么管理员和保管员都只能看到待审批的记录
-- 执行：mysql -u root -p cultural_relics < diagnose_repair_permissions.sql
-- ========================================

USE cultural_relics;

-- ========================================
-- 1. 检查修复记录状态分布
-- ========================================
SELECT '========== 1. 修复记录状态分布 ==========' as '';

SELECT 
  status as '状态',
  COUNT(*) as '数量',
  GROUP_CONCAT(id ORDER BY id) as '记录ID列表'
FROM repair_record
GROUP BY status
ORDER BY 
  CASE status
    WHEN '待审批' THEN 1
    WHEN '待修复' THEN 2
    WHEN '修复中' THEN 3
    WHEN '修复完成' THEN 4
    WHEN '已拒绝' THEN 5
    ELSE 6
  END;

SELECT '' as '';
SELECT '如果只有"待审批"状态，说明需要创建其他状态的测试数据' as '诊断结果';
SELECT '' as '';

-- ========================================
-- 2. 检查所有修复记录详情
-- ========================================
SELECT '========== 2. 所有修复记录详情 ==========' as '';

SELECT 
  rr.id as 'ID',
  rr.repair_code as '修复编号',
  rr.status as '状态',
  rr.applicant_id as '申请人ID',
  u.username as '申请人账号',
  u.real_name as '申请人姓名',
  rr.apply_date as '申请日期'
FROM repair_record rr
LEFT JOIN sys_user u ON rr.applicant_id = u.id
ORDER BY rr.id DESC
LIMIT 20;

SELECT '' as '';

-- ========================================
-- 3. 检查ADMIN角色的权限
-- ========================================
SELECT '========== 3. ADMIN角色的修复相关权限 ==========' as '';

SELECT 
  r.role_code as '角色代码',
  r.role_name as '角色名称',
  p.permission_code as '权限代码',
  p.permission_name as '权限名称'
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'ADMIN'
AND p.permission_code LIKE 'repairs:%'
ORDER BY p.permission_code;

SELECT '' as '';
SELECT '预期结果：应该包含 repairs:manage 权限' as '诊断说明';
SELECT '' as '';

-- ========================================
-- 4. 检查CURATOR角色的权限
-- ========================================
SELECT '========== 4. CURATOR角色的修复相关权限 ==========' as '';

SELECT 
  r.role_code as '角色代码',
  r.role_name as '角色名称',
  p.permission_code as '权限代码',
  p.permission_name as '权限名称'
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR'
AND p.permission_code LIKE 'repairs:%'
ORDER BY p.permission_code;

SELECT '' as '';
SELECT '预期结果：应该只有 repairs:apply 权限，不应该有 repairs:manage' as '诊断说明';
SELECT '' as '';

-- ========================================
-- 5. 检查admin用户的权限
-- ========================================
SELECT '========== 5. admin用户的修复相关权限 ==========' as '';

SELECT 
  u.username as '用户名',
  u.real_name as '真实姓名',
  r.role_name as '角色',
  p.permission_code as '权限代码'
FROM sys_user u
JOIN sys_user_role ur ON u.id = ur.user_id
JOIN sys_role r ON ur.role_id = r.id
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE u.username = 'admin'
AND p.permission_code LIKE 'repairs:%'
ORDER BY p.permission_code;

SELECT '' as '';

-- ========================================
-- 6. 检查curator用户的权限
-- ========================================
SELECT '========== 6. curator用户的修复相关权限 ==========' as '';

SELECT 
  u.username as '用户名',
  u.real_name as '真实姓名',
  r.role_name as '角色',
  p.permission_code as '权限代码'
FROM sys_user u
JOIN sys_user_role ur ON u.id = ur.user_id
JOIN sys_role r ON ur.role_id = r.id
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE u.username LIKE 'curator%'
AND p.permission_code LIKE 'repairs:%'
ORDER BY u.username, p.permission_code;

SELECT '' as '';

-- ========================================
-- 7. 检查是否有多个保管员的记录
-- ========================================
SELECT '========== 7. 各保管员的修复记录数量 ==========' as '';

SELECT 
  u.id as '用户ID',
  u.username as '用户名',
  u.real_name as '真实姓名',
  COUNT(rr.id) as '修复记录数量',
  GROUP_CONCAT(DISTINCT rr.status ORDER BY rr.status) as '涉及的状态'
FROM sys_user u
LEFT JOIN repair_record rr ON u.id = rr.applicant_id
WHERE u.username LIKE 'curator%'
GROUP BY u.id, u.username, u.real_name
ORDER BY u.username;

SELECT '' as '';
SELECT '建议：至少应该有2个保管员，每个保管员有多条不同状态的记录' as '诊断说明';
SELECT '' as '';

-- ========================================
-- 8. 检查文物状态（用于创建测试数据）
-- ========================================
SELECT '========== 8. 可用于修复申请的文物 ==========' as '';

SELECT 
  id as '文物ID',
  relic_code as '文物编号',
  relic_name as '文物名称',
  status as '状态'
FROM cultural_relic
WHERE status = '在库'
LIMIT 10;

SELECT '' as '';
SELECT '这些文物可以用于创建测试修复记录' as '说明';
SELECT '' as '';

-- ========================================
-- 9. 总结诊断结果
-- ========================================
SELECT '========== 诊断总结 ==========' as '';

SELECT 
  CASE 
    WHEN (SELECT COUNT(DISTINCT status) FROM repair_record) = 1 
      AND (SELECT status FROM repair_record LIMIT 1) = '待审批'
    THEN '问题确认：数据库中只有"待审批"状态的记录'
    WHEN (SELECT COUNT(DISTINCT status) FROM repair_record) > 1
    THEN '数据正常：有多种状态的记录'
    ELSE '数据异常：请检查repair_record表'
  END as '数据状态诊断';

SELECT 
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM sys_role r
      JOIN sys_role_permission rp ON r.id = rp.role_id
      JOIN sys_permission p ON rp.permission_id = p.id
      WHERE r.role_code = 'ADMIN' AND p.permission_code = 'repairs:manage'
    )
    THEN '权限正常：ADMIN有repairs:manage权限'
    ELSE '权限异常：ADMIN缺少repairs:manage权限'
  END as 'ADMIN权限诊断';

SELECT 
  CASE 
    WHEN EXISTS (
      SELECT 1 FROM sys_role r
      JOIN sys_role_permission rp ON r.id = rp.role_id
      JOIN sys_permission p ON rp.permission_id = p.id
      WHERE r.role_code = 'CURATOR' AND p.permission_code = 'repairs:apply'
    )
    AND NOT EXISTS (
      SELECT 1 FROM sys_role r
      JOIN sys_role_permission rp ON r.id = rp.role_id
      JOIN sys_permission p ON rp.permission_id = p.id
      WHERE r.role_code = 'CURATOR' AND p.permission_code = 'repairs:manage'
    )
    THEN '权限正常：CURATOR只有repairs:apply权限'
    ELSE '权限异常：CURATOR权限配置不正确'
  END as 'CURATOR权限诊断';

SELECT '' as '';
SELECT '========== 诊断完成 ==========' as '';
SELECT '请根据上述诊断结果，执行相应的修复脚本' as '';
