-- 验证IP地址记录功能

-- 1. 查看所有用户的IP记录
SELECT 
    id,
    username,
    real_name,
    login_failed_count,
    account_locked,
    locked_time,
    last_login_time,
    last_login_ip,
    status
FROM 
    sys_user
ORDER BY 
    last_login_time DESC;

-- 2. 查看最近登录的用户
SELECT 
    username,
    real_name,
    last_login_time,
    last_login_ip,
    login_failed_count
FROM 
    sys_user
WHERE 
    last_login_time IS NOT NULL
ORDER BY 
    last_login_time DESC
LIMIT 10;

-- 3. 查看有登录失败记录的用户
SELECT 
    username,
    real_name,
    login_failed_count,
    last_login_ip,
    account_locked,
    locked_time
FROM 
    sys_user
WHERE 
    login_failed_count > 0 
    OR account_locked = 1
ORDER BY 
    login_failed_count DESC;

-- 4. 查看特定用户的详细信息
SELECT 
    username,
    real_name,
    login_failed_count,
    account_locked,
    locked_time,
    last_login_time,
    last_login_ip,
    CASE 
        WHEN account_locked = 1 AND locked_time IS NOT NULL THEN
            CONCAT('锁定中，已过 ', TIMESTAMPDIFF(MINUTE, locked_time, NOW()), ' 分钟')
        WHEN login_failed_count > 0 THEN
            CONCAT('失败 ', login_failed_count, ' 次')
        ELSE
            '正常'
    END as status_desc
FROM 
    sys_user
WHERE 
    username = 'admin';

-- 5. 统计各IP的登录情况
SELECT 
    last_login_ip,
    COUNT(*) as user_count,
    GROUP_CONCAT(username) as usernames
FROM 
    sys_user
WHERE 
    last_login_ip IS NOT NULL
GROUP BY 
    last_login_ip
ORDER BY 
    user_count DESC;
