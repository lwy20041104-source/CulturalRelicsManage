-- 修复记录与材料关联表
-- 创建日期: 2026-04-27

USE cultural_relics;

-- 创建修复记录材料关联表
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

-- 插入测试数据
INSERT INTO `repair_record_material` (`repair_record_id`, `material_id`, `quantity`, `unit_price`, `total_price`, `remark`, `create_time`) VALUES
(1, 1, 2.50, 150.00, 375.00, '用于陶瓷粘合', '2026-04-15 10:30:00'),
(1, 4, 5.00, 50.00, 250.00, '用于表面修复', '2026-04-15 10:30:00'),
(2, 2, 1.00, 200.00, 200.00, '清洁处理', '2026-04-16 14:20:00'),
(2, 3, 0.50, 300.00, 150.00, '表面保护', '2026-04-16 14:20:00'),
(3, 5, 3.00, 80.00, 240.00, '纺织品修复', '2026-04-18 09:15:00'),
(4, 6, 1.50, 180.00, 270.00, '石材修复', '2026-04-20 11:00:00');

-- 验证数据
SELECT 
  rrm.id,
  rr.repair_code AS '修复编号',
  rm.material_name AS '材料名称',
  rrm.quantity AS '数量',
  rm.unit AS '单位',
  rrm.unit_price AS '单价',
  rrm.total_price AS '总价',
  rrm.remark AS '备注'
FROM repair_record_material rrm
LEFT JOIN repair_record rr ON rrm.repair_record_id = rr.id
LEFT JOIN repair_material rm ON rrm.material_id = rm.id
ORDER BY rrm.create_time DESC;
