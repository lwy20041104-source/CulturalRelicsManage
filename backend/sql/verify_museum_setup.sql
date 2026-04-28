-- ========================================
-- 博物馆管理功能数据库验证脚本
-- ========================================

USE cultural_relics;

-- 1. 检查表是否存在
SELECT 
    '1. 检查表是否存在' as '检查项',
    CASE 
        WHEN COUNT(*) = 2 THEN '✅ 通过'
        ELSE '❌ 失败'
    END as '结果',
    COUNT(*) as '表数量'
FROM information_schema.tables 
WHERE table_schema = 'cultural_relics' 
AND table_name IN ('museum', 'user_museum');

-- 2. 检查museum表结构
SELECT 
    '2. 检查museum表结构' as '检查项',
    CASE 
        WHEN COUNT(*) >= 13 THEN '✅ 通过'
        ELSE '❌ 失败'
    END as '结果',
    COUNT(*) as '字段数量'
FROM information_schema.columns 
WHERE table_schema = 'cultural_relics' 
AND table_name = 'museum';

-- 3. 检查user_museum表结构
SELECT 
    '3. 检查user_museum表结构' as '检查项',
    CASE 
        WHEN COUNT(*) >= 5 THEN '✅ 通过'
        ELSE '❌ 失败'
    END as '结果',
    COUNT(*) as '字段数量'
FROM information_schema.columns 
WHERE table_schema = 'cultural_relics' 
AND table_name = 'user_museum';

-- 4. 检查博物馆数据
SELECT 
    '4. 检查博物馆数据' as '检查项',
    CASE 
        WHEN COUNT(*) = 10 THEN '✅ 通过'
        ELSE '❌ 失败'
    END as '结果',
    COUNT(*) as '博物馆数量'
FROM museum;

-- 5. 检查启用的博物馆
SELECT 
    '5. 检查启用的博物馆' as '检查项',
    CASE 
        WHEN COUNT(*) = 10 THEN '✅ 通过'
        ELSE '⚠️ 警告'
    END as '结果',
    COUNT(*) as '启用数量'
FROM museum 
WHERE status = 1;

-- 6. 检查用户博物馆关联
SELECT 
    '6. 检查用户博物馆关联' as '检查项',
    CASE 
        WHEN COUNT(*) >= 2 THEN '✅ 通过'
        ELSE '⚠️ 警告'
    END as '结果',
    COUNT(*) as '关联数量'
FROM user_museum;

-- 7. 检查外键约束
SELECT 
    '7. 检查外键约束' as '检查项',
    CASE 
        WHEN COUNT(*) = 2 THEN '✅ 通过'
        ELSE '⚠️ 警告'
    END as '结果',
    COUNT(*) as '外键数量'
FROM information_schema.table_constraints 
WHERE table_schema = 'cultural_relics' 
AND table_name = 'user_museum' 
AND constraint_type = 'FOREIGN KEY';

-- ========================================
-- 详细数据展示
-- ========================================

-- 显示所有博物馆
SELECT 
    '========== 博物馆列表 ==========' as '';

SELECT 
    id as 'ID',
    museum_code as '编码',
    museum_name as '名称',
    museum_type as '类型',
    city as '城市',
    CASE status WHEN 1 THEN '启用' ELSE '禁用' END as '状态'
FROM museum 
ORDER BY id;

-- 显示用户博物馆关联
SELECT 
    '========== 用户博物馆关联 ==========' as '';

SELECT 
    um.id as 'ID',
    u.username as '用户名',
    u.real_name as '姓名',
    m.museum_name as '博物馆',
    CASE um.is_primary WHEN 1 THEN '是' ELSE '否' END as '主要博物馆'
FROM user_museum um
LEFT JOIN sys_user u ON um.user_id = u.id
LEFT JOIN museum m ON um.museum_id = m.id
ORDER BY um.id;

-- 显示表结构
SELECT 
    '========== museum表结构 ==========' as '';

SELECT 
    column_name as '字段名',
    column_type as '类型',
    is_nullable as '可空',
    column_key as '键',
    column_default as '默认值',
    column_comment as '注释'
FROM information_schema.columns 
WHERE table_schema = 'cultural_relics' 
AND table_name = 'museum'
ORDER BY ordinal_position;

-- ========================================
-- 测试查询（模拟后端接口）
-- ========================================

SELECT 
    '========== 测试查询：获取启用的博物馆 ==========' as '';

-- 这是后端 /museums/active 接口执行的SQL
SELECT * FROM museum WHERE status = 1 ORDER BY museum_code;

-- ========================================
-- 总结
-- ========================================

SELECT 
    '========================================' as '';

SELECT 
    '验证完成！' as '状态',
    CONCAT(
        '博物馆表: ', 
        (SELECT COUNT(*) FROM museum), 
        '条记录 | ',
        '用户关联: ',
        (SELECT COUNT(*) FROM user_museum),
        '条记录'
    ) as '摘要';

SELECT 
    '如果所有检查项都显示 ✅ 通过，说明数据库配置正确' as '提示';

SELECT 
    '如果有 ❌ 失败，请重新执行 museum_tables.sql 脚本' as '建议';

