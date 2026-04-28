-- 验证登录锁定字段是否存在
-- 查看sys_user表结构
DESC sys_user;

-- 查看是否有新增的字段
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    IS_NULLABLE, 
    COLUMN_DEFAULT, 
    COLUMN_COMMENT
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'cultural_relics' 
    AND TABLE_NAME = 'sys_user'
    AND COLUMN_NAME IN ('login_failed_count', 'account_locked', 'locked_time', 'last_login_time', 'last_login_ip');

-- 查看现有用户的锁定状态
SELECT 
    id,
    username,
    real_name,
    login_failed_count,
    account_locked,
    locked_time,
    last_login_time,
    last_login_ip
FROM 
    sys_user
WHERE 
    status = 1;
