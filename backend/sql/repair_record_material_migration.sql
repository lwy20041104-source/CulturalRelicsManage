-- 修复记录与材料关联迁移脚本
-- 创建日期: 2026-04-27
-- 说明: 将repair_record表的materials_used字段改为通过中间表关联

USE cultural_relics;

-- ========================================
-- 1. 备份现有数据（可选）
-- ========================================
-- 如果需要保留materials_used的数据，可以先备份
-- CREATE TABLE repair_record_backup AS SELECT * FROM repair_record;

-- ========================================
-- 2. 检查repair_record_material表是否存在
-- ========================================
-- 如果不存在，先创建中间表
CREATE TABLE IF NOT EXISTS `repair_record_material` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `repair_record_id` BIGINT NOT NULL COMMENT '修复记录ID',
  `material_id` BIGINT NOT NULL COMMENT '材料ID',
  `quantity` DECIMAL(10,2) NOT NULL COMMENT '使用数量',
  `unit_price` DECIMAL(10,2) NOT NULL COMMENT '单价',
  `total_price` DECIMAL(10,2) NOT NULL COMMENT '总价',
  `remark` VARCHAR(500) COMMENT '备注',
  `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  INDEX `idx_repair_record_id` (`repair_record_id`),
  INDEX `idx_material_id` (`material_id`),
  CONSTRAINT `fk_rrm_repair_record` FOREIGN KEY (`repair_record_id`) 
    REFERENCES `repair_record` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rrm_material` FOREIGN KEY (`material_id`) 
    REFERENCES `repair_material` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='修复记录材料关联表';

-- ========================================
-- 3. 数据迁移（如果materials_used有数据）
-- ========================================
-- 注意：这个脚本假设materials_used字段存储的是材料名称（文本）
-- 如果需要迁移数据，需要根据实际情况调整

-- 示例：如果materials_used存储的是"环氧树脂,宣纸"这样的文本
-- 需要手动处理或编写复杂的迁移逻辑

-- ========================================
-- 4. 删除repair_record表的materials_used字段
-- ========================================
-- 检查字段是否存在
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
  'SELECT "Column materials_used does not exist" AS message'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- ========================================
-- 5. 验证修改
-- ========================================
-- 查看repair_record表结构
SHOW COLUMNS FROM repair_record LIKE 'materials%';

-- 查看repair_record_material表结构
SHOW COLUMNS FROM repair_record_material;

-- 查看外键约束
SELECT 
  CONSTRAINT_NAME,
  TABLE_NAME,
  COLUMN_NAME,
  REFERENCED_TABLE_NAME,
  REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'repair_record_material';

-- ========================================
-- 6. 说明
-- ========================================
/*
数据库结构变更说明：

变更前：
- repair_record表有materials_used字段（VARCHAR类型，存储材料名称文本）
- 一个修复记录只能记录材料名称，无法记录数量、价格等详细信息

变更后：
- repair_record表移除materials_used字段
- 通过repair_record_material中间表关联
- 一个修复记录可以关联多个材料（多对多关系）
- 每个材料关联记录包含：数量、单价、总价、备注等详细信息

关系说明：
1. repair_record (1) <---> (N) repair_record_material
2. repair_material (1) <---> (N) repair_record_material
3. 多对多关系：一个修复记录可以使用多个材料，一个材料可以被多个修复记录使用

优势：
1. 结构化存储材料使用信息
2. 可以记录每次使用的数量和价格
3. 支持材料库存管理
4. 支持成本统计和分析
5. 数据完整性约束（外键）

注意事项：
1. 删除修复记录时，会级联删除相关的材料使用记录（ON DELETE CASCADE）
2. 删除材料时，如果有使用记录，会被限制删除（ON DELETE RESTRICT）
3. 需要更新应用程序代码，使用新的关联方式
*/

-- ========================================
-- 7. 回滚脚本（如果需要）
-- ========================================
/*
-- 如果需要回滚，可以执行以下脚本：

-- 恢复materials_used字段
ALTER TABLE repair_record 
ADD COLUMN materials_used VARCHAR(500) COMMENT '使用材料' 
AFTER repair_method;

-- 从中间表恢复数据（示例）
UPDATE repair_record rr
SET materials_used = (
  SELECT GROUP_CONCAT(rm.material_name SEPARATOR ',')
  FROM repair_record_material rrm
  JOIN repair_material rm ON rrm.material_id = rm.id
  WHERE rrm.repair_record_id = rr.id
);

-- 删除中间表（如果需要）
-- DROP TABLE repair_record_material;
*/

COMMIT;

SELECT '修复记录与材料关联迁移完成！' AS message;
