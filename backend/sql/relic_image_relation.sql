-- ============================================
-- 文物图片关联表
-- ============================================
-- 功能：建立 image_library 和 cultural_relic 的一对一关联
-- 说明：一个文物只能关联一张主图片，一张图片只能作为一个文物的主图
-- ============================================

USE cultural_relics;

-- 1. 创建文物图片关联表
DROP TABLE IF EXISTS relic_image_relation;

CREATE TABLE relic_image_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    relic_id BIGINT NOT NULL UNIQUE COMMENT '文物ID（唯一，确保一个文物只有一张主图）',
    image_id BIGINT NOT NULL UNIQUE COMMENT '图片ID（唯一，确保一张图片只关联一个文物）',
    relation_type VARCHAR(20) DEFAULT 'main' COMMENT '关联类型（main:主图, detail:详情图等）',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    
    -- 外键约束
    CONSTRAINT fk_relic_image_relic FOREIGN KEY (relic_id) REFERENCES cultural_relic(id) ON DELETE CASCADE,
    CONSTRAINT fk_relic_image_image FOREIGN KEY (image_id) REFERENCES image_library(id) ON DELETE CASCADE,
    
    -- 索引
    INDEX idx_relic_id (relic_id),
    INDEX idx_image_id (image_id),
    INDEX idx_relation_type (relation_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文物图片关联表（一对一）';

-- 2. 创建视图：文物及其主图信息
CREATE OR REPLACE VIEW v_relic_with_image AS
SELECT 
    r.id as relic_id,
    r.relic_code,
    r.relic_name,
    r.category_id,
    r.era,
    r.material,
    r.origin,
    r.dimensions,
    r.weight,
    r.description,
    r.status,
    r.image_path as old_image_path,  -- 保留旧的图片路径字段
    i.id as image_id,
    i.image_name,
    i.file_path as image_path,
    i.file_size,
    i.width,
    i.height,
    i.file_type,
    ri.relation_type,
    ri.create_time as relation_create_time
FROM cultural_relic r
LEFT JOIN relic_image_relation ri ON r.id = ri.relic_id
LEFT JOIN image_library i ON ri.image_id = i.image_id AND i.status = 1
ORDER BY r.id;

-- 3. 插入示例数据（假设已有文物和图片数据）
-- 注意：这里的 relic_id 和 image_id 需要根据实际数据调整

-- 示例：如果文物ID为1，图片ID为1，建立关联
-- INSERT INTO relic_image_relation (relic_id, image_id, relation_type) 
-- VALUES (1, 1, 'main');

-- 4. 创建存储过程：为文物设置主图
DELIMITER //

DROP PROCEDURE IF EXISTS sp_set_relic_main_image//

CREATE PROCEDURE sp_set_relic_main_image(
    IN p_relic_id BIGINT,
    IN p_image_id BIGINT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: 设置文物主图失败' as message;
    END;
    
    START TRANSACTION;
    
    -- 检查文物是否存在
    IF NOT EXISTS (SELECT 1 FROM cultural_relic WHERE id = p_relic_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '文物不存在';
    END IF;
    
    -- 检查图片是否存在
    IF NOT EXISTS (SELECT 1 FROM image_library WHERE id = p_image_id AND status = 1) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '图片不存在或已删除';
    END IF;
    
    -- 删除该文物的旧关联（如果存在）
    DELETE FROM relic_image_relation WHERE relic_id = p_relic_id;
    
    -- 删除该图片的旧关联（如果存在，确保一对一）
    DELETE FROM relic_image_relation WHERE image_id = p_image_id;
    
    -- 创建新关联
    INSERT INTO relic_image_relation (relic_id, image_id, relation_type)
    VALUES (p_relic_id, p_image_id, 'main');
    
    -- 更新 image_library 的 reference 字段
    UPDATE image_library 
    SET reference_type = 'relic', 
        reference_id = p_relic_id,
        update_time = CURRENT_TIMESTAMP
    WHERE id = p_image_id;
    
    COMMIT;
    
    SELECT CONCAT('成功为文物 ', p_relic_id, ' 设置主图 ', p_image_id) as message;
END//

DELIMITER ;

-- 5. 创建存储过程：移除文物主图
DELIMITER //

DROP PROCEDURE IF EXISTS sp_remove_relic_main_image//

CREATE PROCEDURE sp_remove_relic_main_image(
    IN p_relic_id BIGINT
)
BEGIN
    DECLARE v_image_id BIGINT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: 移除文物主图失败' as message;
    END;
    
    START TRANSACTION;
    
    -- 获取关联的图片ID
    SELECT image_id INTO v_image_id 
    FROM relic_image_relation 
    WHERE relic_id = p_relic_id 
    LIMIT 1;
    
    -- 删除关联
    DELETE FROM relic_image_relation WHERE relic_id = p_relic_id;
    
    -- 清除图片的 reference 字段
    IF v_image_id IS NOT NULL THEN
        UPDATE image_library 
        SET reference_type = NULL, 
            reference_id = NULL,
            update_time = CURRENT_TIMESTAMP
        WHERE id = v_image_id;
    END IF;
    
    COMMIT;
    
    SELECT CONCAT('成功移除文物 ', p_relic_id, ' 的主图') as message;
END//

DELIMITER ;

-- 6. 创建函数：获取文物的主图路径
DELIMITER //

DROP FUNCTION IF EXISTS fn_get_relic_image_path//

CREATE FUNCTION fn_get_relic_image_path(p_relic_id BIGINT)
RETURNS VARCHAR(500)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_image_path VARCHAR(500);
    
    SELECT i.file_path INTO v_image_path
    FROM relic_image_relation ri
    JOIN image_library i ON ri.image_id = i.id
    WHERE ri.relic_id = p_relic_id 
      AND i.status = 1
    LIMIT 1;
    
    RETURN v_image_path;
END//

DELIMITER ;

-- 7. 创建触发器：删除文物时自动删除关联
DROP TRIGGER IF EXISTS tr_delete_relic_image_relation;

DELIMITER //

CREATE TRIGGER tr_delete_relic_image_relation
AFTER DELETE ON cultural_relic
FOR EACH ROW
BEGIN
    -- 删除关联记录（外键级联会自动处理，这里是额外的清理）
    DELETE FROM relic_image_relation WHERE relic_id = OLD.id;
END//

DELIMITER ;

-- 8. 创建触发器：删除图片时自动删除关联
DROP TRIGGER IF EXISTS tr_delete_image_relic_relation;

DELIMITER //

CREATE TRIGGER tr_delete_image_relic_relation
AFTER DELETE ON image_library
FOR EACH ROW
BEGIN
    -- 删除关联记录（外键级联会自动处理，这里是额外的清理）
    DELETE FROM relic_image_relation WHERE image_id = OLD.id;
END//

DELIMITER ;

-- ============================================
-- 使用示例
-- ============================================

-- 示例1：为文物设置主图
-- CALL sp_set_relic_main_image(1, 1);  -- 文物ID=1, 图片ID=1

-- 示例2：移除文物主图
-- CALL sp_remove_relic_main_image(1);  -- 文物ID=1

-- 示例3：查询文物及其主图
-- SELECT * FROM v_relic_with_image WHERE relic_id = 1;

-- 示例4：使用函数获取文物主图路径
-- SELECT id, relic_name, fn_get_relic_image_path(id) as image_path 
-- FROM cultural_relic 
-- WHERE id = 1;

-- 示例5：查询所有有主图的文物
-- SELECT * FROM v_relic_with_image WHERE image_id IS NOT NULL;

-- 示例6：查询所有没有主图的文物
-- SELECT * FROM v_relic_with_image WHERE image_id IS NULL;

-- 示例7：统计有图和无图的文物数量
-- SELECT 
--     COUNT(*) as total,
--     SUM(CASE WHEN image_id IS NOT NULL THEN 1 ELSE 0 END) as with_image,
--     SUM(CASE WHEN image_id IS NULL THEN 1 ELSE 0 END) as without_image
-- FROM v_relic_with_image;

-- ============================================
-- 数据迁移（可选）
-- ============================================
-- 如果 cultural_relic 表的 image_path 字段中有数据，
-- 可以通过以下步骤迁移到新的关联表：
-- 
-- 1. 先将图片路径导入到 image_library 表
-- 2. 然后建立关联关系
-- 
-- 注意：这需要根据实际情况编写迁移脚本

-- ============================================
-- 验证
-- ============================================

SELECT '=== 表结构创建完成 ===' as info;
SHOW CREATE TABLE relic_image_relation;

SELECT '=== 视图创建完成 ===' as info;
SHOW CREATE VIEW v_relic_with_image;

SELECT '=== 存储过程创建完成 ===' as info;
SHOW PROCEDURE STATUS WHERE Db = 'cultural_relics' AND Name LIKE 'sp_%relic%';

SELECT '=== 函数创建完成 ===' as info;
SHOW FUNCTION STATUS WHERE Db = 'cultural_relics' AND Name LIKE 'fn_%relic%';

SELECT '=== 触发器创建完成 ===' as info;
SHOW TRIGGERS WHERE `Table` IN ('cultural_relic', 'image_library');

SELECT '=== 所有对象创建完成 ===' as info;
SELECT '可以开始使用文物图片关联功能了' as message;
