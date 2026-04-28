-- ============================================
-- 文物数字化档案管理系统 - 数据库表结构
-- 创建时间：2024年
-- ============================================

-- 1. 文物档案主表
CREATE TABLE IF NOT EXISTS relic_archive (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '档案ID',
    relic_id BIGINT NOT NULL COMMENT '文物ID',
    archive_code VARCHAR(50) UNIQUE NOT NULL COMMENT '档案编号，如：AR-2024-001',
    archive_title VARCHAR(200) NOT NULL COMMENT '档案标题',
    archive_type VARCHAR(20) DEFAULT 'complete' COMMENT '档案类型：complete-完整档案/basic-基础档案/image-图片档案/document-文档档案',
    description TEXT COMMENT '档案描述',
    version INT DEFAULT 1 COMMENT '版本号',
    status VARCHAR(20) DEFAULT 'draft' COMMENT '状态：draft-草稿/published-已发布/archived-已归档',
    created_by BIGINT COMMENT '创建人ID',
    created_by_name VARCHAR(100) COMMENT '创建人姓名',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    published_time DATETIME COMMENT '发布时间',
    archived_time DATETIME COMMENT '归档时间',
    INDEX idx_relic_id (relic_id),
    INDEX idx_archive_code (archive_code),
    INDEX idx_status (status),
    INDEX idx_created_time (created_time),
    FOREIGN KEY (relic_id) REFERENCES cultural_relic(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='文物档案主表';

-- 2. 档案文档表
CREATE TABLE IF NOT EXISTS archive_document (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '文档ID',
    archive_id BIGINT NOT NULL COMMENT '档案ID',
    document_type VARCHAR(50) NOT NULL COMMENT '文档类型：appraisal-鉴定报告/repair-修复记录/research-研究论文/certificate-证书/photo-照片/other-其他',
    document_name VARCHAR(200) NOT NULL COMMENT '文档名称',
    file_path VARCHAR(500) NOT NULL COMMENT '文件路径',
    file_size BIGINT COMMENT '文件大小（字节）',
    file_format VARCHAR(20) COMMENT '文件格式：pdf/doc/docx/jpg/png/xlsx等',
    upload_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
    uploader_id BIGINT COMMENT '上传人ID',
    uploader_name VARCHAR(100) COMMENT '上传人姓名',
    description TEXT COMMENT '文档说明',
    sort_order INT DEFAULT 0 COMMENT '排序顺序',
    INDEX idx_archive_id (archive_id),
    INDEX idx_document_type (document_type),
    INDEX idx_upload_time (upload_time),
    FOREIGN KEY (archive_id) REFERENCES relic_archive(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案文档表';

-- 3. 档案历史记录表
CREATE TABLE IF NOT EXISTS archive_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '历史记录ID',
    archive_id BIGINT NOT NULL COMMENT '档案ID',
    version INT COMMENT '版本号',
    operation_type VARCHAR(50) NOT NULL COMMENT '操作类型：create-创建/update-更新/upload-上传文档/delete-删除文档/export-导出/print-打印/publish-发布/archive-归档',
    operation_content TEXT COMMENT '操作内容描述',
    change_log TEXT COMMENT '变更日志',
    operator_id BIGINT COMMENT '操作人ID',
    operator_name VARCHAR(100) COMMENT '操作人姓名',
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    INDEX idx_archive_id (archive_id),
    INDEX idx_operation_time (operation_time),
    INDEX idx_operation_type (operation_type),
    FOREIGN KEY (archive_id) REFERENCES relic_archive(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案历史记录表';

-- 4. 档案关联关系表
CREATE TABLE IF NOT EXISTS archive_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    archive_id BIGINT NOT NULL COMMENT '档案ID',
    relation_type VARCHAR(50) NOT NULL COMMENT '关联类型：loan-借展/repair-修复/maintenance-维护/exhibition-展览',
    relation_id BIGINT NOT NULL COMMENT '关联记录ID',
    relation_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '关联时间',
    relation_desc VARCHAR(500) COMMENT '关联描述',
    INDEX idx_archive_id (archive_id),
    INDEX idx_relation_type (relation_type),
    INDEX idx_relation_id (relation_id),
    FOREIGN KEY (archive_id) REFERENCES relic_archive(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案关联关系表';

-- 5. 档案版本表
CREATE TABLE IF NOT EXISTS archive_version (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '版本ID',
    archive_id BIGINT NOT NULL COMMENT '档案ID',
    version INT NOT NULL COMMENT '版本号',
    version_title VARCHAR(200) COMMENT '版本标题',
    change_log TEXT COMMENT '变更日志',
    content_snapshot LONGTEXT COMMENT '内容快照（JSON格式）',
    created_by BIGINT COMMENT '创建人ID',
    created_by_name VARCHAR(100) COMMENT '创建人姓名',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_archive_id (archive_id),
    INDEX idx_version (version),
    INDEX idx_created_time (created_time),
    FOREIGN KEY (archive_id) REFERENCES relic_archive(id) ON DELETE CASCADE,
    UNIQUE KEY uk_archive_version (archive_id, version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='档案版本表';

-- 插入初始数据（示例）
-- 注意：需要先有文物数据才能创建档案

-- 查询示例
-- 1. 查询某个文物的档案
-- SELECT * FROM relic_archive WHERE relic_id = 1;

-- 2. 查询档案的所有文档
-- SELECT * FROM archive_document WHERE archive_id = 1 ORDER BY sort_order, upload_time DESC;

-- 3. 查询档案的历史记录
-- SELECT * FROM archive_history WHERE archive_id = 1 ORDER BY operation_time DESC;

-- 4. 查询档案的关联记录
-- SELECT * FROM archive_relation WHERE archive_id = 1;

-- 5. 查询档案的版本历史
-- SELECT * FROM archive_version WHERE archive_id = 1 ORDER BY version DESC;

-- 6. 统计档案数量
-- SELECT status, COUNT(*) as count FROM relic_archive GROUP BY status;

-- 7. 查询最近创建的档案
-- SELECT * FROM relic_archive ORDER BY created_time DESC LIMIT 10;

-- 8. 查询包含特定文档类型的档案
-- SELECT DISTINCT ra.* FROM relic_archive ra
-- INNER JOIN archive_document ad ON ra.id = ad.archive_id
-- WHERE ad.document_type = 'appraisal';
