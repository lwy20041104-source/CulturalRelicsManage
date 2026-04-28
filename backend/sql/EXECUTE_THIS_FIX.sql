-- ========================================
-- 一键修复脚本
-- 问题：repair_record表的materials_used字段导致查询失败
-- 解决：删除该字段
-- ========================================

USE cultural_relics;

-- 显示当前状态
SELECT '========== 修复前状态 ==========' AS '';
SELECT 
  CASE 
    WHEN COUNT(*) > 0 THEN CONCAT('发现materials_used字段，准备删除...')
    ELSE '未发现materials_used字段，无需操作'
  END AS status
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME = 'materials_used';

-- 执行删除
SET @column_exists = (
  SELECT COUNT(*) 
  FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE TABLE_SCHEMA = 'cultural_relics' 
    AND TABLE_NAME = 'repair_record' 
    AND COLUMN_NAME = 'materials_used'
);

SET @sql = IF(@column_exists > 0,
  'ALTER TABLE repair_record DROP COLUMN materials_used',
  'SELECT "无需操作" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 显示修复后状态
SELECT '========== 修复后状态 ==========' AS '';
SELECT 
  CASE 
    WHEN COUNT(*) = 0 THEN '✅ SUCCESS: materials_used字段已成功删除！'
    ELSE '❌ ERROR: materials_used字段仍然存在'
  END AS result
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME = 'materials_used';

-- 显示当前表结构
SELECT '========== 当前表结构 ==========' AS '';
SHOW COLUMNS FROM repair_record;

SELECT '========== 修复完成 ==========' AS '';
SELECT '请重启后端服务：cd backend && mvn spring-boot:run' AS next_step;
