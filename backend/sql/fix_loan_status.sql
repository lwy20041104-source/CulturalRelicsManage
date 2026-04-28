-- 修复借展状态：统一使用"借展中"
-- 执行日期：2026-04-25
-- 说明：统一借展状态命名为"借展中"，解决数据大屏统计不一致的问题

-- 更新借展记录表中的状态：将"借出中"改为"借展中"
UPDATE loan_record 
SET status = '借展中' 
WHERE status = '借出中';

-- 更新文物表中的状态：将"借出中"改为"借展中"
UPDATE cultural_relic 
SET status = '借展中' 
WHERE status = '借出中';

-- 验证更新结果
SELECT 
    '借展记录状态统计' as table_name,
    status,
    COUNT(*) as count
FROM loan_record
WHERE status IN ('待审批', '借展中', '已归还', '已驳回', '逾期')
GROUP BY status
UNION ALL
SELECT 
    '文物状态统计' as table_name,
    status,
    COUNT(*) as count
FROM cultural_relic
WHERE status IN ('在库', '借展中', '修复中')
GROUP BY status;

-- 显示所有借展中的文物
SELECT 
    cr.id,
    cr.relic_code,
    cr.relic_name,
    cr.status as relic_status,
    lr.id as loan_id,
    lr.status as loan_status,
    lr.borrower_name,
    lr.expected_return_date,
    cr.update_time
FROM cultural_relic cr
LEFT JOIN loan_record lr ON cr.id = lr.relic_id AND lr.status = '借展中'
WHERE cr.status = '借展中'
ORDER BY cr.update_time DESC;
