-- =====================================================
-- 修复记录表添加applicant_id字段并删除applicant字段
-- 用于消息通知功能正确识别通知接收人
-- =====================================================

-- 1. 添加applicant_id字段
ALTER TABLE repair_record 
ADD COLUMN applicant_id BIGINT COMMENT '申请人ID' AFTER priority;

-- 2. 添加索引
ALTER TABLE repair_record 
ADD INDEX idx_applicant_id (applicant_id);

-- 3. 尝试从sys_user表中匹配现有数据（如果applicant字段有值）
-- 注意：这一步可能无法完全匹配所有数据，因为applicant字段存储的是用户名而非ID
UPDATE repair_record rr
LEFT JOIN sys_user su ON rr.applicant = su.username
SET rr.applicant_id = su.id
WHERE rr.applicant IS NOT NULL AND su.id IS NOT NULL;

-- 4. 删除旧的applicant字段
ALTER TABLE repair_record 
DROP COLUMN applicant;

-- 5. 验证修改
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME IN ('applicant_id', 'applicant')
ORDER BY ORDINAL_POSITION;

-- 6. 查看修改后的数据
SELECT 
    id,
    repair_code,
    relic_id,
    status,
    applicant_id,
    apply_date,
    repair_reason
FROM repair_record
ORDER BY id DESC
LIMIT 10;
