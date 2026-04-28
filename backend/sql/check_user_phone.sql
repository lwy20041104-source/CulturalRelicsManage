-- 检查用户表中的电话号码
SELECT id, username, real_name, phone, role_id 
FROM sys_user 
WHERE role_code = 'LOANER' OR username IN ('loaner', 'test_loaner');

-- 如果需要为测试用户添加电话号码，可以执行以下语句：
-- UPDATE sys_user SET phone = '13800138000' WHERE username = 'loaner';
-- UPDATE sys_user SET phone = '13900139000' WHERE username = 'test_loaner';

-- 为所有没有电话号码的借展人角色用户设置默认电话
-- UPDATE sys_user 
-- SET phone = CONCAT('138', LPAD(id, 8, '0'))
-- WHERE role_code = 'LOANER' AND (phone IS NULL OR phone = '');
