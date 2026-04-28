-- 测试AI对话会话用户显示问题

-- 1. 查看所有会话及其关联的用户信息
SELECT 
    s.id as session_id,
    s.user_id,
    u.username,
    u.real_name,
    s.session_title,
    s.create_time,
    s.update_time
FROM ai_chat_session s 
LEFT JOIN sys_user u ON s.user_id = u.id 
ORDER BY s.update_time DESC;

-- 2. 检查是否有会话的user_id没有对应的用户
SELECT 
    s.id as session_id,
    s.user_id,
    s.session_title,
    CASE 
        WHEN u.id IS NULL THEN '用户不存在'
        ELSE '用户存在'
    END as user_status
FROM ai_chat_session s 
LEFT JOIN sys_user u ON s.user_id = u.id 
WHERE u.id IS NULL;

-- 3. 统计每个用户的会话数量
SELECT 
    u.id as user_id,
    u.username,
    u.real_name,
    COUNT(s.id) as session_count
FROM sys_user u
LEFT JOIN ai_chat_session s ON u.id = s.user_id
GROUP BY u.id, u.username, u.real_name
ORDER BY session_count DESC;

-- 4. 查看最近10条会话的详细信息（包括消息数量）
SELECT 
    s.id as session_id,
    s.user_id,
    u.username,
    u.real_name,
    s.session_title,
    COUNT(m.id) as message_count,
    s.create_time,
    s.update_time
FROM ai_chat_session s 
LEFT JOIN sys_user u ON s.user_id = u.id 
LEFT JOIN ai_chat_message m ON s.id = m.session_id
GROUP BY s.id, s.user_id, u.username, u.real_name, s.session_title, s.create_time, s.update_time
ORDER BY s.update_time DESC
LIMIT 10;

-- 5. 检查sys_user表中是否所有用户都有real_name
SELECT 
    id,
    username,
    real_name,
    CASE 
        WHEN real_name IS NULL OR real_name = '' THEN '缺少真实姓名'
        ELSE '有真实姓名'
    END as name_status
FROM sys_user
ORDER BY id;

-- 6. 修复数据：如果某些用户没有real_name，可以使用username作为默认值
-- UPDATE sys_user SET real_name = username WHERE real_name IS NULL OR real_name = '';

-- 7. 测试修复后的查询（与Mapper中的SQL一致）
SELECT 
    s.id, 
    s.user_id, 
    s.session_title, 
    s.create_time, 
    s.update_time, 
    u.real_name as user_name
FROM ai_chat_session s 
LEFT JOIN sys_user u ON s.user_id = u.id 
ORDER BY s.update_time DESC;
