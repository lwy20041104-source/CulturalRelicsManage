-- ========================================
-- 创建修复记录测试数据
-- ========================================
-- 用途：创建不同状态的修复记录，用于测试权限控制
-- 执行：mysql -u root -p cultural_relics < create_repair_test_data.sql
-- ========================================

USE cultural_relics;

-- ========================================
-- 准备工作：获取必要的ID
-- ========================================

-- 获取curator01的user_id（假设username为curator01）
SET @curator01_id = (SELECT id FROM sys_user WHERE username = 'curator01' LIMIT 1);

-- 获取curator02的user_id（如果不存在，使用curator01）
SET @curator02_id = (SELECT id FROM sys_user WHERE username = 'curator02' LIMIT 1);
SET @curator02_id = IFNULL(@curator02_id, @curator01_id);

-- 获取可用的文物ID（状态为"在库"）
SET @relic_id_1 = (SELECT id FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 0);
SET @relic_id_2 = (SELECT id FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 1);
SET @relic_id_3 = (SELECT id FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 2);
SET @relic_id_4 = (SELECT id FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 3);
SET @relic_id_5 = (SELECT id FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 4);
SET @relic_id_6 = (SELECT id FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 5);

-- 显示将要使用的ID
SELECT '========== 准备创建测试数据 ==========' as '';
SELECT @curator01_id as 'curator01_id', @curator02_id as 'curator02_id';
SELECT @relic_id_1 as 'relic_1', @relic_id_2 as 'relic_2', @relic_id_3 as 'relic_3';

-- ========================================
-- 为curator01创建不同状态的修复记录
-- ========================================

-- 1. 待审批状态（curator01）
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost
) VALUES (
  CONCAT('REP', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
  @relic_id_1,
  '待审批',
  '高',
  @curator01_id,
  DATE_SUB(NOW(), INTERVAL 1 DAY),
  '文物表面有裂纹，需要专业修复',
  '底部发现明显裂痕，长度约5cm，需要及时处理以防扩大',
  5000.00
);

-- 2. 待修复状态（curator01，已审批通过）
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark, repair_expert
) VALUES (
  CONCAT('REP', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
  @relic_id_2,
  '待修复',
  '普通',
  @curator01_id,
  DATE_SUB(NOW(), INTERVAL 5 DAY),
  '表面污渍需要清理',
  '长期展出导致表面有污渍，需要专业清理',
  3000.00,
  'admin',
  DATE_SUB(NOW(), INTERVAL 4 DAY),
  '同意修复，安排专家处理',
  '张三'
);

-- 3. 修复中状态（curator01）
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark, repair_expert,
  start_date, repair_process
) VALUES (
  CONCAT('REP', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
  @relic_id_3,
  '修复中',
  '紧急',
  @curator01_id,
  DATE_SUB(NOW(), INTERVAL 10 DAY),
  '严重损坏需要紧急修复',
  '多处破损，包括边缘碎裂和表面剥落，需要全面修复',
  8000.00,
  'admin',
  DATE_SUB(NOW(), INTERVAL 9 DAY),
  '同意紧急修复',
  '李四',
  DATE_SUB(NOW(), INTERVAL 8 DAY),
  '已完成初步清理和评估，正在进行裂纹修复，预计还需3天完成'
);

-- 4. 修复完成状态（curator01）
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark, repair_expert,
  start_date, complete_date, repair_process, repair_method,
  actual_cost, quality_score, quality_remark
) VALUES (
  CONCAT('REP', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
  @relic_id_4,
  '修复完成',
  '普通',
  @curator01_id,
  DATE_SUB(NOW(), INTERVAL 20 DAY),
  '轻微损坏需要修复',
  '表面有轻微磨损和划痕',
  3000.00,
  'admin',
  DATE_SUB(NOW(), INTERVAL 19 DAY),
  '同意修复',
  '王五',
  DATE_SUB(NOW(), INTERVAL 18 DAY),
  DATE_SUB(NOW(), INTERVAL 2 DAY),
  '清理、修复、加固、封护',
  '采用传统工艺进行修复，使用天然材料',
  2800.00,
  95,
  '修复效果良好，文物状态恢复到理想水平'
);

-- 5. 已拒绝状态（curator01）
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark
) VALUES (
  CONCAT('REP', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
  @relic_id_5,
  '已拒绝',
  '低',
  @curator01_id,
  DATE_SUB(NOW(), INTERVAL 3 DAY),
  '需要修复',
  '有轻微损坏',
  2000.00,
  'admin',
  DATE_SUB(NOW(), INTERVAL 2 DAY),
  '经评估，损坏程度不足以进行修复，建议继续观察。如果损坏加重，可重新申请。'
);

-- ========================================
-- 为curator02创建记录（用于测试数据隔离）
-- ========================================

-- 6. curator02的待审批记录
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost
) VALUES (
  CONCAT('REP', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0')),
  @relic_id_6,
  '待审批',
  '普通',
  @curator02_id,
  NOW(),
  '需要进行保养性修复',
  '文物保存时间较长，需要进行预防性保护',
  3500.00
);

-- ========================================
-- 验证创建结果
-- ========================================

SELECT '' as '';
SELECT '========== 创建完成，验证结果 ==========' as '';

-- 显示各状态的记录数量
SELECT 
  status as '状态',
  COUNT(*) as '数量'
FROM repair_record
GROUP BY status
ORDER BY 
  CASE status
    WHEN '待审批' THEN 1
    WHEN '待修复' THEN 2
    WHEN '修复中' THEN 3
    WHEN '修复完成' THEN 4
    WHEN '已拒绝' THEN 5
    ELSE 6
  END;

SELECT '' as '';

-- 显示curator01的记录
SELECT 
  id as 'ID',
  repair_code as '修复编号',
  status as '状态',
  priority as '优先级',
  apply_date as '申请日期'
FROM repair_record
WHERE applicant_id = @curator01_id
ORDER BY id DESC;

SELECT '' as '';
SELECT CONCAT('curator01 (ID=', @curator01_id, ') 的记录已创建') as '说明';

-- 显示curator02的记录
SELECT 
  id as 'ID',
  repair_code as '修复编号',
  status as '状态',
  priority as '优先级',
  apply_date as '申请日期'
FROM repair_record
WHERE applicant_id = @curator02_id AND applicant_id != @curator01_id
ORDER BY id DESC;

SELECT '' as '';
SELECT CONCAT('curator02 (ID=', @curator02_id, ') 的记录已创建') as '说明';

SELECT '' as '';
SELECT '========== 测试数据创建完成 ==========' as '';
SELECT '现在可以测试以下场景：' as '';
SELECT '1. admin登录 -> 修复管理 -> 应该看到所有状态的所有记录' as '';
SELECT '2. curator01登录 -> 申请修复 -> 应该只看到自己的记录（所有状态）' as '';
SELECT '3. curator02登录 -> 申请修复 -> 应该只看到自己的记录' as '';
SELECT '4. curator01应该看不到curator02的记录' as '';
