-- 修复repair_record表结构
USE cultural_relics;

-- 删除旧表并重建（保留数据的安全方式）
DROP TABLE IF EXISTS repair_record_backup;
CREATE TABLE repair_record_backup AS SELECT * FROM repair_record;

-- 删除旧表
DROP TABLE IF EXISTS repair_record;

-- 创建新的repair_record表（完整结构）
CREATE TABLE repair_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    repair_code VARCHAR(50) COMMENT '修复编号',
    relic_id BIGINT NOT NULL COMMENT '文物ID',
    status VARCHAR(20) DEFAULT '待审批' COMMENT '状态：待审批、待修复、修复中、修复完成、已拒绝',
    priority VARCHAR(20) DEFAULT '普通' COMMENT '优先级：紧急、高、普通、低',
    applicant VARCHAR(50) COMMENT '申请人',
    apply_date DATETIME COMMENT '申请日期',
    repair_reason VARCHAR(255) COMMENT '修复原因',
    damage_description TEXT COMMENT '损坏描述',
    estimated_cost DECIMAL(10,2) DEFAULT 0 COMMENT '预算费用',
    approver VARCHAR(50) COMMENT '审批人',
    approve_date DATETIME COMMENT '审批日期',
    approve_remark VARCHAR(500) COMMENT '审批意见',
    repair_expert VARCHAR(50) COMMENT '修复专家',
    start_date DATETIME COMMENT '开始修复日期',
    complete_date DATETIME COMMENT '完成日期',
    repair_process TEXT COMMENT '修复过程',
    repair_method TEXT COMMENT '修复方法',
    materials_used VARCHAR(500) COMMENT '使用材料',
    actual_cost DECIMAL(10,2) DEFAULT 0 COMMENT '实际费用',
    before_images VARCHAR(1000) COMMENT '修复前照片（多张，逗号分隔）',
    after_images VARCHAR(1000) COMMENT '修复后照片（多张，逗号分隔）',
    quality_score INT DEFAULT 0 COMMENT '质量评分（0-100）',
    quality_remark VARCHAR(500) COMMENT '质量评估意见',
    remark VARCHAR(1000) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_repair_code (repair_code),
    INDEX idx_relic_id (relic_id),
    INDEX idx_status (status),
    INDEX idx_apply_date (apply_date),
    INDEX idx_repair_expert (repair_expert)
) COMMENT='修复记录表';

-- 插入测试数据
INSERT INTO repair_record (
    repair_code, relic_id, status, priority, applicant, apply_date,
    repair_reason, damage_description, estimated_cost, repair_expert,
    start_date, repair_process, repair_method, materials_used,
    actual_cost, complete_date, quality_score, quality_remark,
    before_images, after_images, remark
) VALUES
(
    'REP2026001', 8, '修复完成', '高', '保管员一号', '2026-02-25 09:00:00',
    '表面氧化严重', '银壶表面出现大面积氧化层，局部有腐蚀斑点，影响观赏价值',
    2500.00, '修复师乙', '2026-03-01 09:00:00',
    '1. 表面清洁 2. 化学稳定处理 3. 镀层保护 4. 抛光处理',
    '采用化学还原法去除氧化层，使用保护性镀层防止再次氧化',
    '化学试剂、保护镀层材料、抛光材料',
    2500.00, '2026-03-05 16:00:00', 95, '修复效果优秀，表面光洁度恢复良好，保护层均匀',
    '/uploads/repair/before_8_1.jpg,/uploads/repair/before_8_2.jpg',
    '/uploads/repair/after_8_1.jpg,/uploads/repair/after_8_2.jpg',
    '修复过程顺利，未发现其他隐藏损伤'
),
(
    'REP2026002', 5, '修复中', '紧急', '保管员一号', '2026-02-08 10:00:00',
    '纸本边缘磨损', '书法作品边缘出现磨损和撕裂，需要加固处理',
    1200.00, '修复师甲', '2026-02-12 10:00:00',
    '正在进行纤维修补和边缘加固',
    '使用传统装裱技术进行纸张加固和边缘修补',
    '宣纸、浆糊、丝绸',
    0, NULL, 0, NULL,
    '/uploads/repair/before_5_1.jpg,/uploads/repair/before_5_2.jpg',
    NULL,
    '需要特别注意墨迹保护，避免水分渗透'
),
(
    'REP2026003', 12, '待修复', '普通', '馆员一号', '2026-03-15 11:00:00',
    '石雕裂隙扩大', '观音像底座出现裂纹，有扩大趋势，需要及时处理',
    3000.00, '修复师丙', NULL,
    NULL,
    '计划采用环氧树脂填补裂缝，并进行结构加固',
    '环氧树脂、加固材料、石材修复剂',
    0, NULL, 0, NULL,
    '/uploads/repair/before_12_1.jpg',
    NULL,
    '已通过审批，等待修复师档期安排'
),
(
    'REP2026004', 2, '待审批', '普通', '保管员二号', '2026-04-10 14:00:00',
    '剑身锈蚀处理', '青铜剑剑身出现锈蚀点，需要进行除锈和防护处理',
    900.00, NULL, NULL,
    NULL,
    NULL,
    NULL,
    0, NULL, 0, NULL,
    '/uploads/repair/before_2_1.jpg',
    NULL,
    '等待审批'
),
(
    'REP2026005', 3, '已拒绝', '低', '馆员二号', '2026-04-05 09:30:00',
    '釉面细微裂纹', '唐三彩马釉面有细微裂纹',
    1500.00, NULL, NULL,
    NULL,
    NULL,
    NULL,
    0, NULL, 0, NULL,
    '/uploads/repair/before_3_1.jpg',
    NULL,
    '审批意见：裂纹属于自然老化现象，不影响文物价值，暂不需要修复'
);

-- 创建修复专家表
CREATE TABLE IF NOT EXISTS repair_expert (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    expert_name VARCHAR(50) NOT NULL COMMENT '专家姓名',
    expert_code VARCHAR(50) UNIQUE COMMENT '专家编号',
    specialty VARCHAR(100) COMMENT '专业领域',
    title VARCHAR(50) COMMENT '职称',
    phone VARCHAR(20) COMMENT '联系电话',
    email VARCHAR(100) COMMENT '邮箱',
    work_years INT COMMENT '从业年限',
    certification VARCHAR(200) COMMENT '资质证书',
    status TINYINT DEFAULT 1 COMMENT '状态：1启用 0禁用',
    remark VARCHAR(500) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_expert_code (expert_code),
    INDEX idx_specialty (specialty)
) COMMENT='修复专家表';

-- 插入专家数据
INSERT INTO repair_expert (expert_name, expert_code, specialty, title, phone, email, work_years, certification) VALUES
('修复师甲', 'EXP001', '纸质文物修复', '高级修复师', '13800001001', 'expert1@museum.com', 15, '国家文物局颁发高级修复师证书'),
('修复师乙', 'EXP002', '金属文物修复', '高级修复师', '13800001002', 'expert2@museum.com', 12, '国家文物局颁发高级修复师证书'),
('修复师丙', 'EXP003', '石质文物修复', '中级修复师', '13800001003', 'expert3@museum.com', 8, '国家文物局颁发中级修复师证书'),
('修复师丁', 'EXP004', '陶瓷文物修复', '高级修复师', '13800001004', 'expert4@museum.com', 18, '国家文物局颁发高级修复师证书');

-- 验证数据
SELECT '修复记录数量:' as info, COUNT(*) as count FROM repair_record
UNION ALL
SELECT '修复专家数量:' as info, COUNT(*) as count FROM repair_expert;

SELECT repair_code, relic_id, status, priority, applicant, apply_date FROM repair_record ORDER BY apply_date DESC;
