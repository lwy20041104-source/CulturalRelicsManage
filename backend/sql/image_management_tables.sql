-- 图片管理表
CREATE TABLE IF NOT EXISTS image_library (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '图片ID',
    image_name VARCHAR(200) NOT NULL COMMENT '图片名称',
    original_name VARCHAR(200) COMMENT '原始文件名',
    file_path VARCHAR(500) NOT NULL COMMENT '文件路径',
    file_size BIGINT COMMENT '文件大小(字节)',
    file_type VARCHAR(50) COMMENT '文件类型(MIME)',
    width INT COMMENT '图片宽度',
    height INT COMMENT '图片高度',
    category VARCHAR(50) DEFAULT 'uncategorized' COMMENT '分类(relic/exhibition/document/other/uncategorized)',
    tags VARCHAR(500) COMMENT '标签(逗号分隔)',
    description TEXT COMMENT '描述',
    uploader_id BIGINT COMMENT '上传者ID',
    uploader_name VARCHAR(100) COMMENT '上传者姓名',
    reference_type VARCHAR(50) COMMENT '关联类型(relic/loan/repair等)',
    reference_id BIGINT COMMENT '关联对象ID',
    is_public TINYINT DEFAULT 1 COMMENT '是否公开(1:是 0:否)',
    view_count INT DEFAULT 0 COMMENT '浏览次数',
    download_count INT DEFAULT 0 COMMENT '下载次数',
    status TINYINT DEFAULT 1 COMMENT '状态(1:正常 0:已删除)',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_category (category),
    INDEX idx_uploader (uploader_id),
    INDEX idx_reference (reference_type, reference_id),
    INDEX idx_create_time (create_time),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图片库管理表';

-- 插入示例数据
INSERT INTO image_library (image_name, original_name, file_path, file_size, file_type, width, height, category, tags, description, uploader_id, uploader_name, reference_type, reference_id, is_public) VALUES
('青铜鼎图片', 'bronze_ding.jpg', '/uploads/images/bronze_ding_001.jpg', 245678, 'image/jpeg', 1920, 1080, 'relic', '青铜器,商朝,文物', '商代青铜鼎高清图片', 1, 'admin', 'relic', 1, 1),
('玉璧展示图', 'jade_bi.jpg', '/uploads/images/jade_bi_001.jpg', 189234, 'image/jpeg', 1600, 1200, 'relic', '玉器,战国,文物', '战国玉璧展示图', 1, 'admin', 'relic', 2, 1),
('陶罐侧面图', 'pottery_jar.jpg', '/uploads/images/pottery_jar_001.jpg', 156789, 'image/jpeg', 1280, 960, 'relic', '陶器,新石器,文物', '新石器时代陶罐侧面图', 1, 'admin', 'relic', 3, 1),
('展览海报', 'exhibition_poster.jpg', '/uploads/images/exhibition_poster_001.jpg', 512345, 'image/jpeg', 2048, 2732, 'exhibition', '展览,宣传,海报', '文物展览宣传海报', 1, 'admin', NULL, NULL, 1),
('修复前照片', 'repair_before.jpg', '/uploads/images/repair_before_001.jpg', 234567, 'image/jpeg', 1920, 1080, 'relic', '修复,损坏,记录', '文物修复前状态照片', 1, 'admin', 'repair', 1, 0);

-- 创建图片分类统计视图
CREATE OR REPLACE VIEW v_image_category_stats AS
SELECT 
    category,
    COUNT(*) as image_count,
    SUM(file_size) as total_size,
    AVG(view_count) as avg_views,
    SUM(download_count) as total_downloads
FROM image_library
WHERE status = 1
GROUP BY category;

-- 创建最近上传图片视图
CREATE OR REPLACE VIEW v_recent_images AS
SELECT 
    id,
    image_name,
    file_path,
    file_size,
    category,
    uploader_name,
    view_count,
    create_time
FROM image_library
WHERE status = 1
ORDER BY create_time DESC
LIMIT 20;
