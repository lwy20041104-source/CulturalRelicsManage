-- ========================================
-- 诊断并修复申请审批员查询维护记录问题
-- 执行日期：2026-04-29
-- ========================================

-- 步骤 1: 检查当前表结构
-- ========================================
SELECT '=== 步骤 1: 检查 maintenance_record 表结构 ===' AS step;
DESCRIBE maintenance_record;

-- 步骤 2: 检查是否缺少必要字段
-- ========================================
SELECT '=== 步骤 2: 检查是否缺少必要字段 ===' AS step;
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    IS_NULLABLE,
    COLUMN_DEFAULT,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'maintenance_record'
ORDER BY ORDINAL_POSITION;

-- 步骤 3: 检查角色配置
-- ========================================
SELECT '=== 步骤 3: 检查角色配置 ===' AS step;
SELECT id, role_name, role_code, description 
FROM sys_role 
WHERE role_code IN ('ADMIN', 'CURATOR', 'APPROVER');

-- 步骤 4: 检查审批员用户配置
-- ========================================
SELECT '=== 步骤 4: 检查审批员用户配置 ===' AS step;
SELECT u.id, u.username, u.real_name, u.role_id, r.role_code, r.role_name
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE u.username = 'approver01';

-- 步骤 5: 检查维护记录数据
-- ========================================
SELECT '=== 步骤 5: 检查维护记录数据 ===' AS step;
SELECT COUNT(*) AS total_records FROM maintenance_record;

-- 步骤 6: 如果缺少字段，添加必要字段
-- ========================================
SELECT '=== 步骤 6: 添加缺少的字段（如果需要）===' AS step;

-- 检查是否存在 maintainer_id 字段
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND COLUMN_NAME = 'maintainer_id'
);

-- 如果字段不存在，添加字段
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE maintenance_record 
     ADD COLUMN maintainer_id BIGINT COMMENT ''维护人ID'' AFTER maintainer',
    'SELECT ''maintainer_id 字段已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查是否存在 status 字段
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND COLUMN_NAME = 'status'
);

-- 如果字段不存在，添加字段
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE maintenance_record 
     ADD COLUMN status VARCHAR(20) DEFAULT ''待审批'' COMMENT ''状态：待审批、已通过、已拒绝'' AFTER maintainer_id',
    'SELECT ''status 字段已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查是否存在 approver 字段
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND COLUMN_NAME = 'approver'
);

-- 如果字段不存在，添加字段
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE maintenance_record 
     ADD COLUMN approver VARCHAR(50) COMMENT ''审批人'' AFTER status',
    'SELECT ''approver 字段已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查是否存在 approve_date 字段
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND COLUMN_NAME = 'approve_date'
);

-- 如果字段不存在，添加字段
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE maintenance_record 
     ADD COLUMN approve_date DATETIME COMMENT ''审批日期'' AFTER approver',
    'SELECT ''approve_date 字段已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查是否存在 approve_remark 字段
SET @column_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND COLUMN_NAME = 'approve_remark'
);

-- 如果字段不存在，添加字段
SET @sql = IF(@column_exists = 0,
    'ALTER TABLE maintenance_record 
     ADD COLUMN approve_remark TEXT COMMENT ''审批意见'' AFTER approve_date',
    'SELECT ''approve_remark 字段已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 步骤 7: 更新现有数据
-- ========================================
SELECT '=== 步骤 7: 更新现有数据 ===' AS step;

-- 为现有记录设置 maintainer_id（根据 maintainer 字段映射到用户）
UPDATE maintenance_record mr
LEFT JOIN sys_user u ON mr.maintainer = u.real_name OR mr.maintainer = u.username
SET mr.maintainer_id = COALESCE(u.id, 2)  -- 默认设置为 curator01 (id=2)
WHERE mr.maintainer_id IS NULL;

-- 为现有记录设置状态为"已通过"（假设现有记录都是已完成的）
UPDATE maintenance_record 
SET status = '已通过' 
WHERE status IS NULL OR status = '';

-- 步骤 8: 创建索引（如果不存在）
-- ========================================
SELECT '=== 步骤 8: 创建索引 ===' AS step;

-- 检查并创建 maintainer_id 索引
SET @index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND INDEX_NAME = 'idx_maintainer_id'
);

SET @sql = IF(@index_exists = 0,
    'CREATE INDEX idx_maintainer_id ON maintenance_record(maintainer_id)',
    'SELECT ''idx_maintainer_id 索引已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 检查并创建 status 索引
SET @index_exists = (
    SELECT COUNT(*) 
    FROM INFORMATION_SCHEMA.STATISTICS 
    WHERE TABLE_SCHEMA = DATABASE() 
      AND TABLE_NAME = 'maintenance_record' 
      AND INDEX_NAME = 'idx_status'
);

SET @sql = IF(@index_exists = 0,
    'CREATE INDEX idx_status ON maintenance_record(status)',
    'SELECT ''idx_status 索引已存在'' AS message'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 步骤 9: 插入测试数据（不同用户创建的维护记录）
-- ========================================
SELECT '=== 步骤 9: 插入测试数据 ===' AS step;

-- 删除旧的测试数据（如果存在）
DELETE FROM maintenance_record 
WHERE remark LIKE '%测试数据-APPROVER调试%';

-- 插入新的测试数据
INSERT INTO maintenance_record 
(relic_id, relic_name, maintenance_type, maintenance_date, maintenance_content, maintainer, maintainer_id, status, remark, create_time, update_time)
VALUES
-- admin 创建的记录（待审批）
(1, '青铜鼎', '清洁', DATE_ADD(NOW(), INTERVAL 1 DAY), '定期清洁保养', 'admin', 1, '待审批', '测试数据-APPROVER调试', NOW(), NOW()),

-- curator01 创建的记录（待审批）
(2, '青铜簋', '检查', DATE_ADD(NOW(), INTERVAL 2 DAY), '定期检查', 'curator01', 2, '待审批', '测试数据-APPROVER调试', NOW(), NOW()),

-- curator01 创建的记录（已通过）
(3, '青铜剑', '保养', DATE_ADD(NOW(), INTERVAL 3 DAY), '全面保养', 'curator01', 2, '已通过', '测试数据-APPROVER调试', NOW(), NOW()),

-- approver01 创建的记录（待审批）
(4, '铜镜', '清洁', DATE_ADD(NOW(), INTERVAL 4 DAY), '表面清洁', 'approver01', 3, '待审批', '测试数据-APPROVER调试', NOW(), NOW()),

-- admin 创建的记录（已拒绝）
(5, '鎏金铜马', '检查', DATE_ADD(NOW(), INTERVAL 5 DAY), '状态检查', 'admin', 1, '已拒绝', '测试数据-APPROVER调试', NOW(), NOW());

-- 步骤 10: 验证修复结果
-- ========================================
SELECT '=== 步骤 10: 验证修复结果 ===' AS step;

-- 查看更新后的表结构
SELECT '--- 表结构 ---' AS info;
DESCRIBE maintenance_record;

-- 查看测试数据
SELECT '--- 测试数据（应该有5条）---' AS info;
SELECT 
    id,
    relic_name,
    maintenance_type,
    maintainer,
    maintainer_id,
    status,
    DATE_FORMAT(maintenance_date, '%Y-%m-%d %H:%i') AS maintenance_date,
    remark
FROM maintenance_record
WHERE remark LIKE '%测试数据-APPROVER调试%'
ORDER BY id;

-- 统计各状态的记录数
SELECT '--- 各状态记录统计 ---' AS info;
SELECT 
    status,
    COUNT(*) AS count
FROM maintenance_record
WHERE remark LIKE '%测试数据-APPROVER调试%'
GROUP BY status;

-- 统计各维护人的记录数
SELECT '--- 各维护人记录统计 ---' AS info;
SELECT 
    maintainer,
    maintainer_id,
    COUNT(*) AS count
FROM maintenance_record
WHERE remark LIKE '%测试数据-APPROVER调试%'
GROUP BY maintainer, maintainer_id;

-- 步骤 11: 验证角色和权限
-- ========================================
SELECT '=== 步骤 11: 验证角色和权限 ===' AS step;

-- 确认 APPROVER 角色存在
SELECT '--- APPROVER 角色信息 ---' AS info;
SELECT * FROM sys_role WHERE role_code = 'APPROVER';

-- 确认 approver01 用户配置正确
SELECT '--- approver01 用户信息 ---' AS info;
SELECT 
    u.id,
    u.username,
    u.real_name,
    u.role_id,
    r.role_code,
    r.role_name,
    u.status
FROM sys_user u
LEFT JOIN sys_role r ON u.role_id = r.id
WHERE u.username = 'approver01';

-- 步骤 12: 完成提示
-- ========================================
SELECT '=== 修复完成 ===' AS step;
SELECT '
✅ 数据库修复完成！

下一步操作：
1. 重启后端服务（如果正在运行）
2. 使用 approver01 账号登录（密码：123456）
3. 进入"维护管理"页面
4. 应该能看到所有维护记录（包括其他用户创建的）
5. 查看后端日志，确认权限检查输出：
   - 用户名: approver01
   - 权限列表: [ROLE_APPROVER]
   - 是否是管理员或审批员: true
   - 管理员/审批员权限：显示所有维护记录

测试数据说明：
- 共插入5条测试记录
- admin 创建：2条（1条待审批，1条已拒绝）
- curator01 创建：2条（1条待审批，1条已通过）
- approver01 创建：1条（待审批）

APPROVER 应该能看到所有5条测试记录！
' AS message;
