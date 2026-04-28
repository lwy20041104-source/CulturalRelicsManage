-- 检查repair_record表结构
USE cultural_relics;

-- 查看表结构
SHOW COLUMNS FROM repair_record;

-- 检查materials_used字段是否存在
SELECT 
  COLUMN_NAME,
  DATA_TYPE,
  IS_NULLABLE,
  COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME = 'materials_used';
