-- 快速迁移脚本：移除repair_record表的materials_used字段
-- 创建日期: 2026-04-27

USE cultural_relics;

-- 方法1：直接删除（MySQL 5.7+支持IF EXISTS）
-- ALTER TABLE repair_record DROP COLUMN IF EXISTS materials_used;

-- 方法2：兼容所有MySQL版本
-- 检查字段是否存在，如果存在则删除
SET @column_exists = (
  SELECT COUNT(*) 
  FROM INFORMATION_SCHEMA.COLUMNS 
  WHERE TABLE_SCHEMA = 'cultural_relics' 
    AND TABLE_NAME = 'repair_record' 
    AND COLUMN_NAME = 'materials_used'
);

-- 如果字段存在，则删除
SET @sql = IF(@column_exists > 0,
  'ALTER TABLE repair_record DROP COLUMN materials_used',
  'SELECT "Column materials_used does not exist, no action needed" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 验证结果
SELECT 
  CASE 
    WHEN COUNT(*) = 0 THEN 'SUCCESS: materials_used字段已删除'
    ELSE 'WARNING: materials_used字段仍然存在'
  END AS result
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME = 'materials_used';

-- 显示当前表结构
SHOW COLUMNS FROM repair_record;
