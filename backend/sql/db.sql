CREATE DATABASE IF NOT EXISTS cultural_relics DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE cultural_relics;

-- 用户表
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    real_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    status TINYINT DEFAULT 1,
    role_id BIGINT,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_role_id (role_id)
);

-- 角色表
CREATE TABLE IF NOT EXISTS sys_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL,
    role_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 文物分类表
CREATE TABLE IF NOT EXISTS cultural_relic_category (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    parent_id BIGINT DEFAULT 0,
    sort_order INT DEFAULT 0,
    description VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_parent_id (parent_id)
);

-- 文物信息表
CREATE TABLE IF NOT EXISTS cultural_relic (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_code VARCHAR(50) NOT NULL UNIQUE,
    relic_name VARCHAR(100) NOT NULL,
    category_id BIGINT,
    era VARCHAR(50),
    material VARCHAR(50),
    origin VARCHAR(100),
    dimensions VARCHAR(100),
    weight DECIMAL(10,2),
    description TEXT,
    status VARCHAR(20) DEFAULT '在库',
    image_path VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_relic_code (relic_code),
    INDEX idx_relic_name (relic_name),
    INDEX idx_category_id (category_id),
    INDEX idx_status (status)
);

-- 借展记录表
CREATE TABLE IF NOT EXISTS loan_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_id BIGINT NOT NULL,
    borrower_name VARCHAR(50) NOT NULL,
    borrower_unit VARCHAR(100) NOT NULL,
    borrower_phone VARCHAR(20),
    loan_date DATETIME NOT NULL,
    expected_return_date DATETIME NOT NULL,
    actual_return_date DATETIME,
    purpose VARCHAR(500),
    status VARCHAR(20) DEFAULT '待审批',
    approver_name VARCHAR(50),
    approve_time DATETIME,
    approve_remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_relic_id (relic_id),
    INDEX idx_status (status),
    INDEX idx_expected_return_date (expected_return_date)
);

-- 维护记录表
CREATE TABLE IF NOT EXISTS maintenance_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_id BIGINT NOT NULL,
    maintenance_type VARCHAR(20) NOT NULL,
    maintenance_date DATETIME NOT NULL,
    maintenance_content TEXT NOT NULL,
    maintainer VARCHAR(50) NOT NULL,
    remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_relic_id (relic_id),
    INDEX idx_maintenance_date (maintenance_date)
);

-- 修复记录表
CREATE TABLE IF NOT EXISTS repair_record (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_id BIGINT NOT NULL,
    repair_reason VARCHAR(255),
    repair_process TEXT,
    repair_person VARCHAR(50),
    repair_cost DECIMAL(10,2) DEFAULT 0,
    repair_date DATETIME,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_relic_id (relic_id),
    INDEX idx_repair_date (repair_date)
);

-- 权限表
CREATE TABLE IF NOT EXISTS sys_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    permission_name VARCHAR(100) NOT NULL,
    permission_code VARCHAR(100) NOT NULL UNIQUE,
    permission_type VARCHAR(20) DEFAULT 'MENU',
    path VARCHAR(255),
    component VARCHAR(255),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 用户角色关联表
CREATE TABLE IF NOT EXISTS sys_user_role (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    role_id BIGINT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_role (user_id, role_id)
);

-- 角色权限关联表
CREATE TABLE IF NOT EXISTS sys_role_permission (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    role_id BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_role_permission (role_id, permission_id)
);

-- 数据字典表
CREATE TABLE IF NOT EXISTS sys_dict (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    dict_type VARCHAR(50) NOT NULL,
    dict_label VARCHAR(100) NOT NULL,
    dict_value VARCHAR(100) NOT NULL,
    sort_order INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_dict_type (dict_type)
);

-- 操作日志表
CREATE TABLE IF NOT EXISTS sys_operation_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    operator VARCHAR(50) NOT NULL,
    operation_type VARCHAR(50) NOT NULL,
    operation_module VARCHAR(50) NOT NULL,
    operation_content VARCHAR(1000),
    operation_result VARCHAR(20),
    ip_address VARCHAR(50),
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_operator (operator),
    INDEX idx_operation_time (operation_time)
);

-- 初始化角色数据
INSERT INTO sys_role (role_name, role_code, description) VALUES
('系统管理员', 'ADMIN', '系统最高权限管理员'),
('文物保管员', 'CURATOR', '负责文物信息和维护记录管理'),
('借展审批员', 'APPROVER', '负责借展申请审批'),
('文物借展人', 'LOANER', '负责申请借展文物')
ON DUPLICATE KEY UPDATE role_name=VALUES(role_name);

-- 初始化账号（密码：123456）
-- BCrypt加密后的密码哈希值
INSERT INTO sys_user (username, password, real_name, role_id) VALUES
('admin', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '系统管理员', 1),
('zhangsan', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '文物保管员', 1),
('lisi', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '展借审批员', 1),
('loaner', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '文物借展人', 4)
ON DUPLICATE KEY UPDATE password=VALUES(password), real_name=VALUES(real_name);

-- =========================
-- 2) 用户表（10条以上，密码明文均为 123456）
-- BCrypt: $2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u
-- =========================
INSERT INTO sys_user (id, username, password, real_name, email, phone, status, role_id) VALUES
(2, 'curator01',  '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '保管员一号', 'c01@test.com',    '13800000002', 1, 2),
(3, 'curator02',  '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '保管员二号', 'c02@test.com',    '13800000003', 1, 2),
(4, 'approver01', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '审批员一号', 'a01@test.com',    '13800000004', 1, 3),
(5, 'approver02', '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '审批员二号', 'a02@test.com',    '13800000005', 1, 3),
(6, 'visitor01',  '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '访客一号',   'v01@test.com',    '13800000006', 1, 4),
(7, 'auditor01',  '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '审计员一号', 'u01@test.com',    '13800000007', 1, 5),
(8, 'staff01',    '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '馆员一号',   's01@test.com',    '13800000008', 1, 2),
(9, 'staff02',    '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '馆员二号',   's02@test.com',    '13800000009', 1, 2),
(10,'staff03',    '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '馆员三号',   's03@test.com',    '13800000010', 1, 3),
(11,'staff04',    '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '馆员四号',   's04@test.com',    '13800000011', 1, 2),
(12,'staff05',    '$2a$10$4F.XROvXwA3iPdgP3aHQq.aU1qQY4SDENEvVk9sdxEx74XbcwkP9u', '馆员五号',   's05@test.com',    '13800000012', 1, 3)
ON DUPLICATE KEY UPDATE
password=VALUES(password), real_name=VALUES(real_name), email=VALUES(email), phone=VALUES(phone), status=VALUES(status), role_id=VALUES(role_id);

-- =========================
-- 3) 文物分类（10条）
-- =========================
INSERT INTO cultural_relic_category (id, category_name, parent_id, sort_order, description) VALUES
(1, '青铜器', 0, 1, '青铜器文物'),
(2, '陶瓷器', 0, 2, '陶瓷器文物'),
(3, '书画',   0, 3, '书法绘画'),
(4, '玉器',   0, 4, '玉石器物'),
(5, '金银器', 0, 5, '金银制品'),
(6, '碑帖',   0, 6, '碑刻拓片'),
(7, '钱币',   0, 7, '古代钱币'),
(8, '服饰',   0, 8, '传统服饰'),
(9, '佛像',   0, 9, '佛教造像'),
(10,'杂项',   0,10, '其他文物');

-- =========================
-- 4) 文物信息（12条）
-- =========================
INSERT INTO cultural_relic (id, relic_code, relic_name, category_id, era, material, origin, dimensions, weight, description, status, image_path) VALUES
(1,  'CR2026001', '西周青铜鼎',     1, '西周', '青铜', '陕西', '60x60x75cm', 45.50, '铭文清晰', '在库', NULL),
(2,  'CR2026002', '战国青铜剑',     1, '战国', '青铜', '湖北', '90x4x1cm',   3.20,  '保存完好', '在库', NULL),
(3,  'CR2026003', '唐三彩马',       2, '唐代', '陶',   '洛阳', '40x15x35cm', 8.60,  '釉色鲜明', '在库', NULL),
(4,  'CR2026004', '汝窑天青釉盏',   2, '宋代', '瓷',   '汝州', '12x12x6cm',  0.60,  '器型端正', '在库', NULL),
(5,  'CR2026005', '王羲之摹本',     3, '晋代', '纸本', '浙江', '120x35cm',   0.20,  '书法珍品', '借出', NULL),
(6,  'CR2026006', '山水卷轴',       3, '明代', '绢本', '苏州', '300x45cm',   0.80,  '设色山水', '在库', NULL),
(7,  'CR2026007', '和田白玉佩',     4, '汉代', '玉',   '新疆', '8x5x1cm',    0.10,  '温润细腻', '在库', NULL),
(8,  'CR2026008', '鎏金银壶',       5, '唐代', '银',   '西安', '22x15x20cm', 1.50,  '工艺精湛', '维修中', NULL),
(9,  'CR2026009', '魏碑拓片',       6, '北魏', '纸',   '河南', '180x60cm',   0.40,  '碑文字迹清晰', '在库', NULL),
(10, 'CR2026010', '开元通宝套币',   7, '唐代', '铜',   '长安', '25x25x3cm',  2.20,  '钱币成套', '在库', NULL),
(11, 'CR2026011', '明代云锦服饰',   8, '明代', '丝织', '南京', '160x55cm',   1.00,  '纹样华丽', '在库', NULL),
(12, 'CR2026012', '石雕观音像',     9, '宋代', '石',   '四川', '45x35x95cm', 65.00, '局部风化', '在库', NULL)
ON DUPLICATE KEY UPDATE
relic_name=VALUES(relic_name), category_id=VALUES(category_id), era=VALUES(era), material=VALUES(material), origin=VALUES(origin), status=VALUES(status);

-- =========================
-- 5) 借展记录（10条）
-- =========================
INSERT INTO loan_record (id, relic_id, borrower_name, borrower_unit, borrower_phone, loan_date, expected_return_date, actual_return_date, purpose, status, approver_name, approve_time, approve_remark) VALUES
(1, 5,  '张博', '省博物馆',   '13910000001', '2026-01-10 10:00:00', '2026-02-10 10:00:00', '2026-02-08 15:00:00', '专题展出', '已归还', '审批员一号', '2026-01-09 14:00:00', '同意'),
(2, 3,  '李文', '市历史馆',   '13910000002', '2026-02-01 09:30:00', '2026-03-01 09:30:00', NULL,                  '交流展览', '借展中', '审批员一号', '2026-01-31 16:30:00', '同意'),
(3, 2,  '王晓', '文旅局',     '13910000003', '2026-02-15 11:00:00', '2026-03-15 11:00:00', NULL,                  '学术研究', '逾期',   '审批员二号', '2026-02-14 10:20:00', '同意'),
(4, 1,  '周宁', '大学博物馆', '13910000004', '2026-03-05 13:00:00', '2026-04-05 13:00:00', NULL,                  '联合展览', '待审批', NULL,       NULL,                  NULL),
(5, 7,  '吴言', '民俗馆',     '13910000005', '2026-03-10 09:00:00', '2026-04-10 09:00:00', NULL,                  '借展',     '待审批', NULL,       NULL,                  NULL),
(6, 10, '郑文', '收藏研究院', '13910000006', '2026-03-12 09:30:00', '2026-04-12 09:30:00', NULL,                  '文献研究', '借展中', '审批员二号', '2026-03-11 12:00:00', '同意'),
(7, 11, '冯哲', '地方馆',     '13910000007', '2026-03-14 10:00:00', '2026-04-14 10:00:00', NULL,                  '服饰文化展', '借展中', '审批员一号', '2026-03-13 18:00:00', '同意'),
(8, 9,  '陈默', '碑刻馆',     '13910000008', '2026-03-16 11:00:00', '2026-04-16 11:00:00', NULL,                  '拓片临展', '待审批', NULL,       NULL,                  NULL),
(9, 12, '高远', '佛教文化馆', '13910000009', '2026-03-18 12:30:00', '2026-04-18 12:30:00', NULL,                  '专题展',   '待审批', NULL,       NULL,                  NULL),
(10,4,  '赵川', '瓷器馆',     '13910000010', '2026-03-20 14:00:00', '2026-04-20 14:00:00', NULL,                  '文物联展', '借展中', '审批员二号', '2026-03-19 16:00:00', '同意');

-- =========================
-- 6) 维护记录（10条）
-- =========================
INSERT INTO maintenance_record (id, relic_id, maintenance_type, maintenance_date, maintenance_content, maintainer, remark) VALUES
(1, 1,  '日常保养', '2026-01-05 09:00:00', '表面除尘、防氧化处理', '保管员一号', '正常'),
(2, 2,  '状态检查', '2026-01-15 10:00:00', '剑身锈蚀点检查',       '保管员二号', '轻微锈斑'),
(3, 3,  '环境检查', '2026-01-20 11:00:00', '温湿度记录与釉面观察', '馆员一号',   '正常'),
(4, 4,  '日常保养', '2026-02-02 09:30:00', '无酸擦拭处理',         '馆员二号',   '正常'),
(5, 5,  '状态检查', '2026-02-10 14:00:00', '纸本边缘加固评估',     '保管员一号', '建议修复'),
(6, 6,  '日常保养', '2026-02-18 15:00:00', '防潮箱更新',           '馆员三号',   '正常'),
(7, 7,  '状态检查', '2026-02-25 10:20:00', '玉质裂纹检查',         '馆员四号',   '正常'),
(8, 8,  '深度维护', '2026-03-01 09:40:00', '金属腐蚀处置',         '保管员二号', '已转修复'),
(9, 9,  '日常保养', '2026-03-08 11:10:00', '拓片展卷整理',         '馆员五号',   '正常'),
(10,12, '状态检查', '2026-03-15 13:30:00', '石雕裂隙监测',         '馆员一号',   '持续观察');

-- =========================
-- 7) 修复记录（10条）
-- =========================
INSERT INTO repair_record (id, relic_id, repair_reason, repair_process, repair_person, repair_cost, repair_date) VALUES
(1, 5,  '边缘磨损',   '纤维修补与边缘加固',   '修复师甲', 1200.00, '2026-02-12 10:00:00'),
(2, 8,  '表面氧化',   '化学稳定与镀层保护',   '修复师乙', 2500.00, '2026-03-03 14:00:00'),
(3, 12, '细小裂纹',   '裂缝填补与结构加固',   '修复师丙', 3000.00, '2026-03-18 16:00:00'),
(4, 2,  '锈蚀处理',   '局部除锈与防护涂层',   '修复师甲',  900.00, '2026-01-30 09:00:00'),
(5, 3,  '釉面细裂',   '显微加固处理',         '修复师丁', 1500.00, '2026-02-06 11:00:00'),
(6, 4,  '口沿磨损',   '口沿修补',             '修复师丙',  800.00, '2026-02-20 15:00:00'),
(7, 7,  '挂件松动',   '重新固定连接结构',     '修复师乙',  650.00, '2026-02-28 10:30:00'),
(8, 9,  '纸张老化',   '脱酸与装裱修护',       '修复师丁', 2100.00, '2026-03-10 13:00:00'),
(9, 10, '表面污渍',   '清洗与保护蜡处理',     '修复师甲',  500.00, '2026-03-12 09:30:00'),
(10,11, '织物松散',   '织物加固与局部补线',   '修复师丙', 1700.00, '2026-03-16 14:20:00');

-- =========================
-- 8) 权限表（12条）
-- =========================
INSERT INTO sys_permission (id, permission_name, permission_code, permission_type, path, component) VALUES
(1,  '看板查看',     'dashboard:view',        'MENU', '/dashboard',   'DashboardView'),
(2,  '文物管理',     'relics:manage',         'MENU', '/relics',      'RelicsView'),
(3,  '分类管理',     'categories:manage',     'MENU', '/categories',  'CategoriesView'),
(4,  '借展管理',     'loans:manage',          'MENU', '/loans',       'LoansView'),
(5,  '维护管理',     'maintenance:manage',    'MENU', '/maintenance', 'MaintenanceView'),
(6,  '统计概览',     'statistics:overview',   'API',  '/statistics/overview', NULL),
(7,  '文物统计',     'statistics:relics',     'API',  '/statistics/relics', NULL),
(8,  '借展统计',     'statistics:loans',      'API',  '/statistics/loans', NULL),
(9,  '维护统计',     'statistics:maintenance','API',  '/statistics/maintenance', NULL),
(10, '借展审批',     'loans:approve',         'API',  '/loans/approve', NULL),
(11, '用户管理',     'users:manage',          'MENU', '/users',       'UsersView'),
(12, '日志查看',     'logs:view',             'MENU', '/logs',        'LogsView')
ON DUPLICATE KEY UPDATE
permission_name=VALUES(permission_name), permission_type=VALUES(permission_type), path=VALUES(path), component=VALUES(component);

-- =========================
-- 9) 用户角色关联（10条）
-- =========================
INSERT INTO sys_user_role (id, user_id, role_id) VALUES
(1,1,1),(2,2,2),(3,3,2),(4,4,3),(5,5,3),
(6,6,4),(7,7,5),(8,8,2),(9,9,2),(10,10,3)
ON DUPLICATE KEY UPDATE role_id=VALUES(role_id);

-- =========================
-- 10) 角色权限关联（15条）
-- =========================
INSERT INTO sys_role_permission (id, role_id, permission_id) VALUES
(1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),
(13,2,1),(14,2,2),(15,2,3),(16,2,5),
(17,3,1),(18,3,4),(19,3,10),
(20,5,12)
ON DUPLICATE KEY UPDATE role_id=VALUES(role_id), permission_id=VALUES(permission_id);

-- =========================
-- 11) 数据字典（10条）
-- =========================
INSERT INTO sys_dict (id, dict_type, dict_label, dict_value, sort_order) VALUES
(1,  'relic_status', '在库',    '在库',    1),
(2,  'relic_status', '借出',    '借出',    2),
(3,  'relic_status', '维修中',  '维修中',  3),
(4,  'loan_status',  '待审批',  '待审批',  1),
(5,  'loan_status',  '借展中',  '借展中',  2),
(6,  'loan_status',  '已归还',  '已归还',  3),
(7,  'loan_status',  '逾期',    '逾期',    4),
(8,  'maint_type',   '日常保养','日常保养',1),
(9,  'maint_type',   '状态检查','状态检查',2),
(10, 'maint_type',   '深度维护','深度维护',3);

-- =========================
-- 12) 操作日志（10条）
-- =========================
INSERT INTO sys_operation_log (id, operator, operation_type, operation_module, operation_content, operation_result, ip_address, operation_time) VALUES
(1,  'admin',     'LOGIN',  '认证模块', '管理员登录系统',              'SUCCESS', '127.0.0.1', '2026-03-20 09:00:00'),
(2,  'curator01', 'INSERT', '文物管理', '新增文物 CR2026001',          'SUCCESS', '127.0.0.1', '2026-03-20 09:10:00'),
(3,  'curator02', 'UPDATE', '文物管理', '更新文物 CR2026003 状态',     'SUCCESS', '127.0.0.1', '2026-03-20 09:20:00'),
(4,  'approver01','APPROVE','借展管理', '审批借展记录 #2',             'SUCCESS', '127.0.0.1', '2026-03-20 09:30:00'),
(5,  'approver02','APPROVE','借展管理', '审批借展记录 #6',             'SUCCESS', '127.0.0.1', '2026-03-20 09:40:00'),
(6,  'staff01',   'INSERT', '维护管理', '新增维护记录 #8',             'SUCCESS', '127.0.0.1', '2026-03-20 09:50:00'),
(7,  'staff02',   'INSERT', '修复管理', '新增修复记录 #3',             'SUCCESS', '127.0.0.1', '2026-03-20 10:00:00'),
(8,  'admin',     'EXPORT', '统计模块', '导出借展统计报表',            'SUCCESS', '127.0.0.1', '2026-03-20 10:10:00'),
(9,  'auditor01', 'QUERY',  '日志模块', '查询系统日志',                'SUCCESS', '127.0.0.1', '2026-03-20 10:20:00'),
(10, 'admin',     'LOGOUT', '认证模块', '管理员退出系统',              'SUCCESS', '127.0.0.1', '2026-03-20 10:30:00');


-- =========================
-- AI对话记录表
-- =========================
-- AI对话会话表
CREATE TABLE IF NOT EXISTS ai_chat_session (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    session_title VARCHAR(200) DEFAULT '新对话' COMMENT '会话标题',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_user_id (user_id),
    INDEX idx_create_time (create_time)
) COMMENT='AI对话会话表';

-- AI对话消息表
CREATE TABLE IF NOT EXISTS ai_chat_message (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    session_id BIGINT NOT NULL COMMENT '会话ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    message_type VARCHAR(20) NOT NULL COMMENT '消息类型：user-用户消息, ai-AI回复',
    content TEXT NOT NULL COMMENT '消息内容',
    query_keyword VARCHAR(500) COMMENT '查询关键词（用户消息时记录）',
    result_count INT DEFAULT 0 COMMENT '返回结果数量（AI回复时记录）',
    has_external_result TINYINT DEFAULT 0 COMMENT '是否包含外部搜索结果：0-否，1-是',
    relic_ids VARCHAR(500) COMMENT '相关文物ID列表（逗号分隔）',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_session_id (session_id),
    INDEX idx_user_id (user_id),
    INDEX idx_message_type (message_type),
    INDEX idx_create_time (create_time)
) COMMENT='AI对话消息表';

-- AI查询结果详情表（可选，用于存储详细的查询结果）
CREATE TABLE IF NOT EXISTS ai_query_result (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    message_id BIGINT NOT NULL COMMENT '消息ID',
    relic_id BIGINT COMMENT '文物ID（馆藏文物）',
    relic_name VARCHAR(100) NOT NULL COMMENT '文物名称',
    relevance_percent INT DEFAULT 0 COMMENT '相关度百分比',
    is_external TINYINT DEFAULT 0 COMMENT '是否外部资料：0-馆藏，1-外部',
    source_name VARCHAR(100) COMMENT '来源名称',
    source_type VARCHAR(50) COMMENT '来源类型：百科、博物馆官网等',
    source_url VARCHAR(500) COMMENT '来源链接',
    match_tags VARCHAR(500) COMMENT '匹配标签（JSON数组）',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_message_id (message_id),
    INDEX idx_relic_id (relic_id),
    INDEX idx_is_external (is_external)
) COMMENT='AI查询结果详情表';
