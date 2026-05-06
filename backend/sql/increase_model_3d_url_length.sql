-- 增加 model_3d_url 字段长度
-- 从 VARCHAR(500) 增加到 VARCHAR(2000)，以支持更长的3D模型链接（如Sketchfab嵌入链接）

USE cultural_relics;

ALTER TABLE cultural_relic 
MODIFY COLUMN model_3d_url VARCHAR(2000) NULL DEFAULT NULL COMMENT '3D模型URL';

-- 验证修改
SHOW COLUMNS FROM cultural_relic LIKE 'model_3d_url';
