-- ============================================
-- 修复图片路径中的双斜杠和错误格式
-- ============================================
-- 功能：清理 image_library 表中的错误路径
-- 日期：2026-04-23
-- ============================================

USE cultural_relics;

-- 1. 查看当前有问题的路径
SELECT 
    id,
    image_name,
    file_path,
    CASE 
        WHEN file_path LIKE '%//%' THEN '包含双斜杠'
        WHEN file_path LIKE './%' THEN '以 ./ 开头'
        WHEN file_path LIKE '%\\%' THEN '包含反斜杠'
        ELSE '正常'
    END as path_status
FROM image_library
WHERE file_path LIKE '%//%' 
   OR file_path LIKE './%'
   OR file_path LIKE '%\\%';

-- 2. 备份原始数据（可选但推荐）
CREATE TABLE IF NOT EXISTS image_library_backup_20260423 AS
SELECT * FROM image_library;

-- 3. 修复双斜杠 (//)
UPDATE image_library 
SET file_path = REPLACE(file_path, '//', '/')
WHERE file_path LIKE '%//%';

-- 4. 修复以 ./ 开头的路径
UPDATE image_library 
SET file_path = CONCAT('/', REPLACE(file_path, './', ''))
WHERE file_path LIKE './%';

-- 5. 修复反斜杠（Windows 路径）
UPDATE image_library 
SET file_path = REPLACE(file_path, '\\', '/')
WHERE file_path LIKE '%\\%';

-- 6. 确保所有路径以 / 开头
UPDATE image_library 
SET file_path = CONCAT('/', file_path)
WHERE file_path NOT LIKE '/%' 
  AND file_path NOT LIKE 'http%';

-- 7. 移除多余的前导斜杠（如果有 ///）
UPDATE image_library 
SET file_path = REPLACE(file_path, '///', '/')
WHERE file_path LIKE '%///%';

UPDATE image_library 
SET file_path = REPLACE(file_path, '//', '/')
WHERE file_path LIKE '%//%';

-- 8. 验证修复结果
SELECT 
    COUNT(*) as total_images,
    SUM(CASE WHEN file_path LIKE '%//%' THEN 1 ELSE 0 END) as double_slash_count,
    SUM(CASE WHEN file_path LIKE './%' THEN 1 ELSE 0 END) as dot_slash_count,
    SUM(CASE WHEN file_path LIKE '%\\%' THEN 1 ELSE 0 END) as backslash_count,
    SUM(CASE WHEN file_path LIKE '/%' AND file_path NOT LIKE '%//%' THEN 1 ELSE 0 END) as correct_path_count
FROM image_library;

-- 9. 显示修复后的路径示例
SELECT 
    id,
    image_name,
    file_path,
    '正常' as status
FROM image_library
ORDER BY id DESC
LIMIT 10;

-- 10. 检查是否还有问题路径
SELECT 
    id,
    image_name,
    file_path,
    '仍有问题' as status
FROM image_library
WHERE file_path LIKE '%//%' 
   OR file_path LIKE './%'
   OR file_path LIKE '%\\%'
   OR (file_path NOT LIKE '/%' AND file_path NOT LIKE 'http%');

-- ============================================
-- 说明
-- ============================================
-- 执行此脚本后，所有图片路径应该符合以下格式：
-- 正确格式: /uploads/abc123.jpg
-- 错误格式: /./uploads//abc123.jpg
-- 错误格式: ./uploads/abc123.jpg
-- 错误格式: uploads\abc123.jpg
-- ============================================

-- 如果需要回滚，可以使用备份表：
-- DELETE FROM image_library;
-- INSERT INTO image_library SELECT * FROM image_library_backup_20260423;
