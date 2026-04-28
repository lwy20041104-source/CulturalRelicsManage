-- 修改loan_record表，添加borrower_id字段并移除borrower_name字段
-- 执行日期：2026-04-24

-- 1. 添加borrower_id字段
ALTER TABLE loan_record ADD COLUMN borrower_id BIGINT COMMENT '借展人ID（关联sys_user表）';

-- 2. 如果有现有数据，尝试根据borrower_name匹配sys_user表的real_name来填充borrower_id
-- 注意：这一步可能无法完全匹配所有数据，建议在执行前备份数据
UPDATE loan_record lr
LEFT JOIN sys_user su ON lr.borrower_name = su.real_name
SET lr.borrower_id = su.id
WHERE lr.borrower_name IS NOT NULL;

-- 3. 删除borrower_name字段（如果不需要保留的话）
-- 注意：如果需要保留历史数据，可以先不删除此字段，等确认borrower_id数据正确后再删除
-- ALTER TABLE loan_record DROP COLUMN borrower_name;

-- 4. 添加外键约束（可选，建议添加以保证数据完整性）
ALTER TABLE loan_record ADD CONSTRAINT fk_loan_record_borrower 
    FOREIGN KEY (borrower_id) REFERENCES sys_user(id);

-- 5. 添加索引以提高查询性能
ALTER TABLE loan_record ADD INDEX idx_borrower_id (borrower_id);

-- 6. 查看修改后的表结构
DESC loan_record;

-- 7. 验证数据
SELECT 
    lr.id,
    lr.borrower_id,
    su.username,
    su.real_name,
    lr.borrower_name as old_borrower_name,
    lr.relic_id,
    lr.status
FROM loan_record lr
LEFT JOIN sys_user su ON lr.borrower_id = su.id
LIMIT 10;
