-- =====================================================
-- 借展记录表添加borrower_id字段
-- 用于消息通知功能正确识别通知接收人
-- =====================================================

-- 1. 添加borrower_id字段
ALTER TABLE loan_record 
ADD COLUMN borrower_id BIGINT COMMENT '借展人ID' AFTER relic_id;

-- 2. 添加索引
ALTER TABLE loan_record 
ADD INDEX idx_borrower_id (borrower_id);

-- 3. 尝试从sys_user表中匹配现有数据
-- 注意：borrower_name字段存储的是真实姓名，需要通过real_name匹配
UPDATE loan_record lr
LEFT JOIN sys_user su ON lr.borrower_name = su.real_name
SET lr.borrower_id = su.id
WHERE lr.borrower_name IS NOT NULL AND su.id IS NOT NULL;

-- 4. 如果通过real_name匹配不到，尝试通过username匹配
UPDATE loan_record lr
LEFT JOIN sys_user su ON lr.borrower_name = su.username
SET lr.borrower_id = su.id
WHERE lr.borrower_id IS NULL 
  AND lr.borrower_name IS NOT NULL 
  AND su.id IS NOT NULL;

-- 5. 验证修改
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    IS_NULLABLE,
    COLUMN_KEY,
    COLUMN_COMMENT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
  AND TABLE_NAME = 'loan_record'
  AND COLUMN_NAME IN ('borrower_id', 'borrower_name')
ORDER BY ORDINAL_POSITION;

-- 6. 查看修改后的数据
SELECT 
    id,
    relic_id,
    borrower_id,
    borrower_name,
    borrower_unit,
    status,
    create_time
FROM loan_record
ORDER BY id DESC
LIMIT 10;

-- 7. 检查NULL值数量
SELECT 
    COUNT(*) as total,
    COUNT(borrower_id) as with_borrower_id,
    COUNT(*) - COUNT(borrower_id) as null_count
FROM loan_record;

-- 8. 查看无法匹配的记录
SELECT 
    id,
    borrower_name,
    borrower_unit,
    status
FROM loan_record
WHERE borrower_id IS NULL
ORDER BY id;
