-- 删除文物表中的 model_3d_type 和 model_3d_size 字段
-- Migration: Remove model_3d_type and model_3d_size fields from cultural_relic table
-- Date: 2026-05-08

USE cultural_relics;

-- 删除 model_3d_type 字段
ALTER TABLE cultural_relic DROP COLUMN IF EXISTS model_3d_type;

-- 删除 model_3d_size 字段
ALTER TABLE cultural_relic DROP COLUMN IF EXISTS model_3d_size;

-- 验证字段已删除
SHOW COLUMNS FROM cultural_relic;
