-- ============================================
-- 清除无效的文物图片路径
-- ============================================
-- 说明：由于 uploads 目录中没有实际的图片文件，
--       需要将数据库中的图片路径设置为 NULL，
--       这样前端会显示占位图，不会出现 404 错误。
-- ============================================

USE cultural_relics;

-- 1. 查看当前状态
SELECT '=== 当前文物图片状态 ===' as info;
SELECT 
    COUNT(*) as total_relics,
    SUM(CASE WHEN image_path IS NULL THEN 1 ELSE 0 END) as no_image,
    SUM(CASE WHEN image_path IS NOT NULL THEN 1 ELSE 0 END) as has_image_path
FROM cultural_relic;

-- 2. 查看有图片路径的文物
SELECT '=== 有图片路径的文物 ===' as info;
SELECT id, relic_name, image_path 
FROM cultural_relic 
WHERE image_path IS NOT NULL
LIMIT 10;

-- 3. 清除所有图片路径（因为实际文件不存在）
SELECT '=== 开始清除图片路径 ===' as info;
UPDATE cultural_relic 
SET image_path = NULL 
WHERE image_path IS NOT NULL;

-- 4. 验证结果
SELECT '=== 清除后的状态 ===' as info;
SELECT 
    COUNT(*) as total_relics,
    SUM(CASE WHEN image_path IS NULL THEN 1 ELSE 0 END) as no_image,
    SUM(CASE WHEN image_path IS NOT NULL THEN 1 ELSE 0 END) as has_image_path
FROM cultural_relic;

-- 5. 显示完成信息
SELECT '=== 操作完成 ===' as info;
SELECT '所有无效的图片路径已清除，前端将显示占位图' as message;
SELECT '如需为文物添加图片，请使用后台管理系统的"图片管理"功能' as next_step;

-- ============================================
-- 可选：为特定文物设置测试图片路径
-- ============================================
-- 如果你已经上传了图片到 uploads 目录，可以使用以下命令设置：
-- 
-- UPDATE cultural_relic 
-- SET image_path = '/uploads/your-image.jpg' 
-- WHERE id = 1;
-- 
-- ============================================
