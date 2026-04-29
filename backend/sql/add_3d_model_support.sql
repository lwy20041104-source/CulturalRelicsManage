-- ========================================
-- 添加3D模型支持
-- 为文物表添加3D模型相关字段
-- ========================================

USE cultural_relics;

-- 1. 为文物表添加3D模型字段
ALTER TABLE cultural_relic
ADD COLUMN IF NOT EXISTS model_3d_url VARCHAR(500) COMMENT '3D模型URL' AFTER image_path,
ADD COLUMN IF NOT EXISTS model_3d_type VARCHAR(20) COMMENT '3D模型类型(gltf/obj)' AFTER model_3d_url,
ADD COLUMN IF NOT EXISTS model_3d_size BIGINT COMMENT '3D模型文件大小(字节)' AFTER model_3d_type,
ADD COLUMN IF NOT EXISTS model_3d_upload_time DATETIME COMMENT '3D模型上传时间' AFTER model_3d_size;

-- 2. 添加索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_model_3d_url ON cultural_relic(model_3d_url);

-- 3. 查看表结构
DESCRIBE cultural_relic;

-- 4. 示例：为某些文物添加示例3D模型URL（可选）
-- UPDATE cultural_relic 
-- SET 
--     model_3d_url = 'http://localhost:8080/uploads/3d-models/sample-bronze.gltf',
--     model_3d_type = 'gltf',
--     model_3d_size = 1024000,
--     model_3d_upload_time = NOW()
-- WHERE id = 1;

-- ========================================
-- 说明
-- ========================================
-- model_3d_url: 存储3D模型文件的访问URL
-- model_3d_type: 模型格式类型（gltf, glb, obj等）
-- model_3d_size: 模型文件大小，用于显示和限制
-- model_3d_upload_time: 上传时间，用于追踪和管理
-- ========================================
