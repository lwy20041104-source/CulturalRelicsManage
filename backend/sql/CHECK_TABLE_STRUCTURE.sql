-- 快速检查 maintenance_record 表结构
-- 执行此脚本查看当前表结构

SELECT '=== 检查 maintenance_record 表结构 ===' AS info;

-- 查看表结构
DESCRIBE maintenance_record;

SELECT '=== 检查是否有必要字段 ===' AS info;

-- 检查关键字段是否存在
SELECT 
    CASE WHEN COUNT(*) > 0 THEN '✅ 存在' ELSE '❌ 不存在' END AS maintainer_id_status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'maintenance_record'
  AND COLUMN_NAME = 'maintainer_id';

SELECT 
    CASE WHEN COUNT(*) > 0 THEN '✅ 存在' ELSE '❌ 不存在' END AS status_field_status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'maintenance_record'
  AND COLUMN_NAME = 'status';

SELECT 
    CASE WHEN COUNT(*) > 0 THEN '✅ 存在' ELSE '❌ 不存在' END AS approver_status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'maintenance_record'
  AND COLUMN_NAME = 'approver';

SELECT '=== 检查维护记录数据 ===' AS info;

-- 查看维护记录总数
SELECT COUNT(*) AS total_records FROM maintenance_record;

-- 查看前5条记录（检查字段）
SELECT 
    id,
    relic_id,
    maintenance_type,
    maintainer,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS 
            WHERE TABLE_SCHEMA = DATABASE() 
              AND TABLE_NAME = 'maintenance_record' 
              AND COLUMN_NAME = 'maintainer_id'
        ) THEN '字段存在'
        ELSE '字段不存在'
    END AS maintainer_id_check
FROM maintenance_record
LIMIT 5;

SELECT '=== 检查 APPROVER 角色和用户 ===' AS info;

-- 检查 APPROVER 角色
SELECT * FROM sys_role WHERE role_code = 'APPROVER';

-- 检查 chen 用户（APPROVER）
SELECT u.id, u.username, u.real_name, u.role_id, r.role_code, r.role_name
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE u.username = 'chen';
