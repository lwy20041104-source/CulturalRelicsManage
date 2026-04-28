-- ========================================
-- 完整的登录锁定功能设置脚本
-- 请按顺序执行
-- ========================================

-- 步骤1：检查当前表结构
SELECT '=== 步骤1：检查当前表结构 ===' as step;
SHOW COLUMNS FROM sys_user;

-- 步骤2：添加字段（如果不存在）
SELECT '=== 步骤2：添加登录安全字段 ===' as step;

-- 检查字段是否存在
SET @col_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
    AND TABLE_NAME = 'sys_user' 
    AND COLUMN_NAME = 'login_failed_count'
);

-- 如果字段不存在，添加它们
SET @sql = IF(@col_exists = 0,
    'ALTER TABLE sys_user 
     ADD COLUMN login_failed_count INT DEFAULT 0 COMMENT ''登录失败次数'',
     ADD COLUMN account_locked TINYINT(1) DEFAULT 0 COMMENT ''账户是否锁定：0-未锁定，1-已锁定'',
     ADD COLUMN locked_time DATETIME NULL COMMENT ''账户锁定时间'',
     ADD COLUMN last_login_time DATETIME NULL COMMENT ''最后登录时间'',
     ADD COLUMN last_login_ip VARCHAR(50) NULL COMMENT ''最后登录IP''',
    'SELECT ''字段已存在，跳过添加'' as message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 步骤3：初始化现有用户数据
SELECT '=== 步骤3：初始化现有用户数据 ===' as step;

UPDATE sys_user 
SET 
    login_failed_count = COALESCE(login_failed_count, 0),
    account_locked = COALESCE(account_locked, 0),
    locked_time = NULL,
    last_login_time = NULL,
    last_login_ip = NULL
WHERE 
    login_failed_count IS NULL 
    OR account_locked IS NULL
    OR account_locked = 1;

-- 步骤4：验证字段
SELECT '=== 步骤4：验证字段已添加 ===' as step;

SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'sys_user'
    AND COLUMN_NAME IN ('login_failed_count', 'account_locked', 'locked_time', 'last_login_time', 'last_login_ip')
ORDER BY ORDINAL_POSITION;

-- 步骤5：查看所有用户的当前状态
SELECT '=== 步骤5：查看所有用户状态 ===' as step;

SELECT 
    id,
    username,
    real_name,
    COALESCE(login_failed_count, -1) as login_failed_count,
    COALESCE(account_locked, -1) as account_locked,
    locked_time,
    last_login_time,
    last_login_ip,
    status
FROM 
    sys_user
ORDER BY id;

-- 步骤6：创建测试用户（可选）
SELECT '=== 步骤6：创建测试用户（可选） ===' as step;

-- 取消下面的注释来创建测试用户
/*
INSERT INTO sys_user (
    username, 
    password, 
    real_name, 
    email, 
    phone, 
    status, 
    role_id, 
    create_time, 
    update_time,
    login_failed_count,
    account_locked
)
SELECT 
    'testlock',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH',  -- 密码: test123
    '测试锁定用户',
    'testlock@example.com',
    '13900000000',
    1,
    (SELECT id FROM sys_role WHERE role_code = 'ADMIN' LIMIT 1),
    NOW(),
    NOW(),
    0,
    0
WHERE NOT EXISTS (
    SELECT 1 FROM sys_user WHERE username = 'testlock'
);
*/

-- 步骤7：完成提示
SELECT '=== 设置完成 ===' as step;
SELECT 
    '字段已添加并初始化完成！' as message,
    '请重启后端服务，然后测试登录锁定功能。' as next_step,
    '测试步骤：' as test_guide,
    '1. 输入错误密码3次' as step1,
    '2. 检查是否显示剩余尝试次数' as step2,
    '3. 第3次后检查是否锁定' as step3,
    '4. 锁定后尝试登录，检查是否提示已锁定' as step4;
