-- ========================================
-- 文物图片关系迁移：从一对一改为一对多
-- ========================================
-- 执行时间：2026-04-28
-- 说明：
-- 1. 移除 relic_id 的 UNIQUE 约束，允许一个文物关联多张图片
-- 2. 保留 image_id 的 UNIQUE 约束，确保一张图片只属于一个文物
-- 3. 添加 is_main 字段，标识主图
-- 4. 迁移现有数据，将所有现有图片标记为主图
-- ========================================

USE cultural_relics_management;

-- ========================================
-- 第一步：备份现有数据
-- ========================================
CREATE TABLE IF NOT EXISTS relic_image_relation_backup_20260428 AS
SELECT * FROM relic_image_relation;

SELECT '备份完成，备份表：relic_image_relation_backup_20260428' AS info;

-- ========================================
-- 第二步：删除旧表并重建
-- ========================================

-- 先删除外键约束和触发器
DROP TRIGGER IF EXISTS tr_delete_relic_image_relation;
DROP TRIGGER IF EXISTS tr_delete_image_relic_relation;

-- 删除旧表
DROP TABLE IF EXISTS relic_image_relation;

-- 创建新表（支持一对多）
CREATE TABLE relic_image_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    relic_id BIGINT NOT NULL COMMENT '文物ID',
    image_id BIGINT NOT NULL COMMENT '图片ID（唯一，确保一张图片只关联一个文物）',
    relation_type VARCHAR(20) DEFAULT 'detail' COMMENT '关联类型（main:主图, detail:详情图）',
    is_main TINYINT DEFAULT 0 COMMENT '是否为主图（1:是, 0:否）',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 索引
    UNIQUE KEY uk_image_id (image_id),  -- 保留：一张图片只能属于一个文物
    KEY idx_relic_id (relic_id),        -- 移除UNIQUE：一个文物可以有多张图片
    KEY idx_relation_type (relation_type),
    KEY idx_is_main (is_main),
    
    -- 外键约束
    CONSTRAINT fk_relic_image_relic FOREIGN KEY (relic_id) 
        REFERENCES cultural_relic(id) ON DELETE CASCADE,
    CONSTRAINT fk_relic_image_image FOREIGN KEY (image_id) 
        REFERENCES image_library(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci 
COMMENT='文物图片关联表（一对多：一个文物可以有多张图片）';

SELECT '新表创建完成：relic_image_relation（支持一对多）' AS info;

-- ========================================
-- 第三步：迁移数据
-- ========================================

-- 将备份数据迁移到新表，所有现有图片标记为主图
INSERT INTO relic_image_relation 
    (id, relic_id, image_id, relation_type, is_main, sort_order, create_time, update_time)
SELECT 
    id,
    relic_id,
    image_id,
    'main' AS relation_type,
    1 AS is_main,  -- 现有图片都标记为主图
    sort_order,
    create_time,
    update_time
FROM relic_image_relation_backup_20260428;

SELECT CONCAT('数据迁移完成，共迁移 ', COUNT(*), ' 条记录') AS info
FROM relic_image_relation;

-- ========================================
-- 第四步：重建触发器
-- ========================================

-- 触发器：删除文物时自动删除关联
DELIMITER //

CREATE TRIGGER tr_delete_relic_image_relation
AFTER DELETE ON cultural_relic
FOR EACH ROW
BEGIN
    DELETE FROM relic_image_relation WHERE relic_id = OLD.id;
END//

-- 触发器：删除图片时自动删除关联
CREATE TRIGGER tr_delete_image_relic_relation
AFTER DELETE ON image_library
FOR EACH ROW
BEGIN
    DELETE FROM relic_image_relation WHERE image_id = OLD.id;
END//

DELIMITER ;

SELECT '触发器重建完成' AS info;

-- ========================================
-- 第五步：创建辅助存储过程
-- ========================================

-- 存储过程：设置文物主图
DROP PROCEDURE IF EXISTS sp_set_relic_main_image;

DELIMITER //

CREATE PROCEDURE sp_set_relic_main_image(
    IN p_relic_id BIGINT,
    IN p_image_id BIGINT
)
BEGIN
    -- 将该文物的所有图片设置为非主图
    UPDATE relic_image_relation 
    SET is_main = 0, relation_type = 'detail'
    WHERE relic_id = p_relic_id;
    
    -- 将指定图片设置为主图
    UPDATE relic_image_relation 
    SET is_main = 1, relation_type = 'main'
    WHERE relic_id = p_relic_id AND image_id = p_image_id;
    
    SELECT '主图设置成功' AS message;
END//

DELIMITER ;

SELECT '存储过程创建完成：sp_set_relic_main_image' AS info;

-- ========================================
-- 第六步：验证数据
-- ========================================

SELECT '========== 表结构验证 ==========' AS '';
SHOW CREATE TABLE relic_image_relation;

SELECT '========== 数据统计 ==========' AS '';
SELECT 
    COUNT(*) AS total_relations,
    COUNT(DISTINCT relic_id) AS unique_relics,
    COUNT(DISTINCT image_id) AS unique_images,
    SUM(is_main) AS main_images_count
FROM relic_image_relation;

SELECT '========== 主图统计（每个文物应该只有一张主图）==========' AS '';
SELECT 
    relic_id,
    COUNT(*) AS main_image_count
FROM relic_image_relation
WHERE is_main = 1
GROUP BY relic_id
HAVING COUNT(*) > 1;

SELECT '========== 前10条记录示例 ==========' AS '';
SELECT 
    r.id,
    r.relic_id,
    cr.name AS relic_name,
    r.image_id,
    i.file_name AS image_name,
    r.relation_type,
    r.is_main,
    r.sort_order
FROM relic_image_relation r
LEFT JOIN cultural_relic cr ON r.relic_id = cr.id
LEFT JOIN image_library i ON r.image_id = i.id
ORDER BY r.relic_id, r.is_main DESC, r.sort_order
LIMIT 10;

SELECT '========== 迁移完成 ==========' AS '';
SELECT '
迁移说明：
1. ✅ 已移除 relic_id 的 UNIQUE 约束
2. ✅ 已保留 image_id 的 UNIQUE 约束
3. ✅ 已添加 is_main 字段标识主图
4. ✅ 已迁移所有现有数据
5. ✅ 已重建触发器
6. ✅ 已创建辅助存储过程

下一步：
- 修改后端代码，支持多图片上传和查询
- 修改前端界面，支持多图片上传和显示
' AS summary;
