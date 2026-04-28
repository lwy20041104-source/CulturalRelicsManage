-- 博物馆表
CREATE TABLE IF NOT EXISTS museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '博物馆ID',
    museum_code VARCHAR(50) NOT NULL UNIQUE COMMENT '博物馆编码',
    museum_name VARCHAR(100) NOT NULL COMMENT '博物馆名称',
    museum_type VARCHAR(50) COMMENT '博物馆类型（综合类、历史类、艺术类、自然类等）',
    province VARCHAR(50) COMMENT '省份',
    city VARCHAR(50) COMMENT '城市',
    address VARCHAR(200) COMMENT '详细地址',
    contact_person VARCHAR(50) COMMENT '联系人',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    contact_email VARCHAR(100) COMMENT '联系邮箱',
    description TEXT COMMENT '博物馆简介',
    status TINYINT DEFAULT 1 COMMENT '状态：1启用 0禁用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_museum_code (museum_code),
    INDEX idx_museum_name (museum_name),
    INDEX idx_status (status)
) COMMENT='博物馆信息表';

-- 用户博物馆关联表（借展人与博物馆的关联）
CREATE TABLE IF NOT EXISTS user_museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '关联ID',
    user_id BIGINT NOT NULL COMMENT '用户ID',
    museum_id BIGINT NOT NULL COMMENT '博物馆ID',
    is_primary TINYINT DEFAULT 1 COMMENT '是否主要博物馆：1是 0否',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE KEY uk_user_museum (user_id, museum_id),
    INDEX idx_user_id (user_id),
    INDEX idx_museum_id (museum_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    FOREIGN KEY (museum_id) REFERENCES museum(id) ON DELETE CASCADE
) COMMENT='用户博物馆关联表';

-- 插入示例博物馆数据
INSERT INTO museum (museum_code, museum_name, museum_type, province, city, address, contact_person, contact_phone, contact_email, description, status) VALUES
('MUS001', '国家博物馆', '综合类', '北京市', '北京市', '天安门广场东侧', '张馆长', '010-12345678', 'contact@nationalmuseum.cn', '中国国家博物馆是世界上单体建筑面积最大的博物馆', 1),
('MUS002', '故宫博物院', '历史类', '北京市', '北京市', '景山前街4号', '李馆长', '010-87654321', 'contact@dpm.org.cn', '明清两代的皇家宫殿，世界文化遗产', 1),
('MUS003', '上海博物馆', '综合类', '上海市', '上海市', '人民大道201号', '王馆长', '021-12345678', 'contact@shanghaimuseum.net', '中国古代艺术博物馆', 1),
('MUS004', '陕西历史博物馆', '历史类', '陕西省', '西安市', '小寨东路91号', '赵馆长', '029-12345678', 'contact@sxhm.com', '中国第一座大型现代化国家级博物馆', 1),
('MUS005', '湖南省博物馆', '综合类', '湖南省', '长沙市', '东风路50号', '刘馆长', '0731-12345678', 'contact@hnmuseum.com', '马王堆汉墓文物收藏地', 1),
('MUS006', '南京博物院', '综合类', '江苏省', '南京市', '中山东路321号', '陈馆长', '025-12345678', 'contact@njmuseum.com', '中国三大博物馆之一', 1),
('MUS007', '浙江省博物馆', '综合类', '浙江省', '杭州市', '孤山路25号', '周馆长', '0571-12345678', 'contact@zhejiangmuseum.com', '浙江省最大的综合性博物馆', 1),
('MUS008', '河南博物院', '历史类', '河南省', '郑州市', '农业路8号', '吴馆长', '0371-12345678', 'contact@henanmuseum.net', '中国建立较早的博物馆之一', 1),
('MUS009', '湖北省博物馆', '综合类', '湖北省', '武汉市', '东湖路160号', '郑馆长', '027-12345678', 'contact@hubeimuseum.com', '曾侯乙编钟收藏地', 1),
('MUS010', '广东省博物馆', '综合类', '广东省', '广州市', '珠江东路2号', '黄馆长', '020-12345678', 'contact@gdmuseum.com', '岭南文化展示中心', 1);

-- 为现有的借展人用户分配博物馆（示例）
-- 假设loaner用户（id=4）关联到国家博物馆
INSERT INTO user_museum (user_id, museum_id, is_primary) 
SELECT 4, 1, 1 
WHERE EXISTS (SELECT 1 FROM sys_user WHERE id = 4 AND username = 'loaner')
ON DUPLICATE KEY UPDATE is_primary = 1;

-- 为visitor01用户（id=6）关联到上海博物馆
INSERT INTO user_museum (user_id, museum_id, is_primary) 
SELECT 6, 3, 1 
WHERE EXISTS (SELECT 1 FROM sys_user WHERE id = 6 AND username = 'visitor01')
ON DUPLICATE KEY UPDATE is_primary = 1;

-- 验证数据
SELECT '博物馆数量:' as info, COUNT(*) as count FROM museum
UNION ALL
SELECT '用户博物馆关联数量:' as info, COUNT(*) as count FROM user_museum;

SELECT m.museum_code, m.museum_name, m.city, m.status 
FROM museum m 
ORDER BY m.id;

SELECT u.username, u.real_name, m.museum_name, um.is_primary
FROM user_museum um
JOIN sys_user u ON um.user_id = u.id
JOIN museum m ON um.museum_id = m.id
ORDER BY um.user_id;
