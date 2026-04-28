-- ========================================
-- 修复材料表测试数据插入脚本
-- 为 repair_material 表插入20条测试数据
-- ========================================

USE cultural_relics;

-- 清空现有数据（可选，如果需要重新插入）
-- TRUNCATE TABLE repair_material;

-- 插入20条修复材料数据
INSERT INTO repair_material (material_name, material_code, category, unit, unit_price, stock_quantity, supplier, remark) VALUES
-- 已有的6条数据（编号 MAT001-MAT006）
('环氧树脂', 'MAT001', '粘合剂', 'kg', 150.00, 50.00, '文保材料公司', '用于陶瓷、石器等文物的粘接修复'),
('化学试剂A', 'MAT002', '清洁剂', 'L', 200.00, 30.00, '化工材料公司', '用于金属文物表面清洁'),
('保护镀层材料', 'MAT003', '保护剂', 'kg', 300.00, 20.00, '文保材料公司', '用于金属文物表面保护'),
('宣纸', 'MAT004', '纸质材料', '张', 50.00, 100.00, '传统工艺公司', '用于书画类文物修复'),
('丝绸', 'MAT005', '纺织材料', 'm', 80.00, 50.00, '传统工艺公司', '用于纺织品文物修复'),
('石材修复剂', 'MAT006', '修复剂', 'kg', 180.00, 40.00, '文保材料公司', '用于石质文物的裂缝修复'),

-- 新增的14条数据（编号 MAT007-MAT020）
('丙烯酸树脂', 'MAT007', '粘合剂', 'kg', 220.00, 35.00, '文保材料公司', '透明度高，适用于玻璃、陶瓷修复'),
('无酸纸', 'MAT008', '纸质材料', '张', 30.00, 200.00, '传统工艺公司', '用于书画装裱和修复'),
('天然蜂蜡', 'MAT009', '保护剂', 'kg', 120.00, 25.00, '天然材料供应商', '用于木质文物表面保护'),
('青铜修复膏', 'MAT010', '修复剂', 'kg', 350.00, 15.00, '文保材料公司', '专用于青铜器修复'),
('棉布', 'MAT011', '纺织材料', 'm', 45.00, 80.00, '传统工艺公司', '用于纺织品文物加固'),
('去离子水', 'MAT012', '清洁剂', 'L', 15.00, 100.00, '化工材料公司', '用于文物清洗，不含杂质'),
('硅胶干燥剂', 'MAT013', '保护剂', 'kg', 60.00, 50.00, '化工材料公司', '用于文物储存环境湿度控制'),
('金箔', 'MAT014', '装饰材料', '张', 500.00, 10.00, '传统工艺公司', '用于金属器物表面修复'),
('木材填充剂', 'MAT015', '修复剂', 'kg', 95.00, 45.00, '文保材料公司', '用于木质文物缺损部位填补'),
('中性清洁剂', 'MAT016', '清洁剂', 'L', 80.00, 60.00, '化工材料公司', 'pH值中性，适用于各类文物清洁'),
('聚乙烯醇', 'MAT017', '粘合剂', 'kg', 110.00, 40.00, '化工材料公司', '水溶性粘合剂，易于去除'),
('羊毛毡', 'MAT018', '纺织材料', 'm', 65.00, 30.00, '传统工艺公司', '用于文物包装和保护'),
('石膏粉', 'MAT019', '修复剂', 'kg', 25.00, 100.00, '建材供应商', '用于石质、陶瓷文物的填补'),
('防霉剂', 'MAT020', '保护剂', 'L', 150.00, 35.00, '化工材料公司', '用于预防文物霉变')

ON DUPLICATE KEY UPDATE
    material_name = VALUES(material_name),
    category = VALUES(category),
    unit = VALUES(unit),
    unit_price = VALUES(unit_price),
    stock_quantity = VALUES(stock_quantity),
    supplier = VALUES(supplier),
    remark = VALUES(remark),
    update_time = CURRENT_TIMESTAMP;

-- 验证插入结果
SELECT '========== 数据插入完成 ==========' AS '';
SELECT CONCAT('修复材料总数: ', COUNT(*), ' 条') AS result FROM repair_material;

-- 查看所有材料数据
SELECT 
    id,
    material_name AS '材料名称',
    material_code AS '材料编号',
    category AS '类别',
    unit AS '单位',
    unit_price AS '单价',
    stock_quantity AS '库存数量',
    supplier AS '供应商'
FROM repair_material
ORDER BY id;

-- 按类别统计
SELECT 
    category AS '材料类别',
    COUNT(*) AS '数量',
    SUM(stock_quantity) AS '总库存',
    AVG(unit_price) AS '平均单价'
FROM repair_material
GROUP BY category
ORDER BY COUNT(*) DESC;

-- 库存预警（库存少于20的材料）
SELECT 
    material_name AS '材料名称',
    material_code AS '材料编号',
    stock_quantity AS '库存数量',
    '库存不足' AS '状态'
FROM repair_material
WHERE stock_quantity < 20
ORDER BY stock_quantity ASC;

SELECT '========== 验证完成 ==========' AS '';
