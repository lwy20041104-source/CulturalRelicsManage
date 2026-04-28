-- 快速修复登录锁定功能
-- 请按顺序执行以下SQL语句

-- ========================================
-- 步骤1：检查字段是否存在
-- ========================================
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    COLUMN_DEFAULT,
    IS_NULLABLE
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'sys_user'
    AND COLUMN_NAME IN ('login_failed_count', 'account_locked', 'locked_time', 'last_login_time', 'last_login_ip');

-- 如果上面的查询返回0行，说明字段不存在，执行下面的添加语句
-- 如果返回5行，说明字段已存在，跳过步骤2

-- ========================================
-- 步骤2：添加字段（如果不存在）
-- ========================================
ALTER TABLE sys_user 
ADD COLUMN IF NOT EXISTS login_failed_count INT DEFAULT 0 COMMENT '登录失败次数',
ADD COLUMN IF NOT EXISTS account_locked TINYINT(1) DEFAULT 0 COMMENT '账户是否锁定：0-未锁定，1-已锁定',
ADD COLUMN IF NOT EXISTS locked_time DATETIME NULL COMMENT '账户锁定时间',
ADD COLUMN IF NOT EXISTS last_login_time DATETIME NULL COMMENT '最后登录时间',
ADD COLUMN IF NOT EXISTS last_login_ip VARCHAR(50) NULL COMMENT '最后登录IP';

-- ========================================
-- 步骤3：初始化现有用户数据
-- ========================================
UPDATE sys_user 
SET 
    login_failed_count = COALESCE(login_failed_count, 0),
    account_locked = COALESCE(account_locked, 0)
WHERE 
    login_failed_count IS NULL 
    OR account_locked IS NULL;

-- ========================================
-- 步骤4：验证字段和数据
-- ========================================
SELECT 
    id,
    username,
    real_name,
    COALESCE(login_failed_count, -999) as login_failed_count,
    COALESCE(account_locked, -999) as account_locked,
    locked_time,
    last_login_time,
    last_login_ip,
    status
FROM 
    sys_user
ORDER BY id;

-- ========================================
-- 步骤5：清理所有锁定状态（可选）
-- ========================================
-- 如果需要重置所有用户的锁定状态，取消下面的注释
/*
UPDATE sys_user 
SET 
    login_failed_count = 0,
    account_locked = 0,
    locked_time = NULL
WHERE 
    account_locked = 1 
    OR login_failed_count > 0;
*/

-- ========================================
-- 步骤6：测试特定用户
-- ========================================
-- 查看admin用户的状态
SELECT 
    username,
    login_failed_count,
    account_locked,
    locked_time,
    last_login_time,
    last_login_ip
FROM 
    sys_user
WHERE 
    username = 'admin';

-- ========================================
-- 完成提示
-- ========================================
SELECT '字段添加和初始化完成！请重启后端服务后测试登录锁定功能。' as message;
