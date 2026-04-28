-- ========================================
-- 根据文物类型添加修复专家
-- ID从7开始，涵盖各类文物修复领域
-- ========================================

USE cultural_relics;

-- 根据文物表中的材质和分类，添加对应的修复专家
-- 现有专家（ID 1-6）：
-- 1. 叶知秋 - 纸质文物修复
-- 2. 白露晞 - 金属文物修复
-- 3. 陆星河 - 石质文物修复
-- 4. 江晚晴 - 陶瓷文物修复
-- 5. 宋归远 - 金银器文物修复
-- 6. 纪南风 - 青铜器文物修复

INSERT INTO repair_expert (id, expert_name, expert_code, specialty, title, phone, email, work_years, certification, status, remark) VALUES

-- 青铜器修复专家（ID: 7-9）
(7, '司马铸', 'EXP007', '青铜器文物修复', '研究员级高级修复师', '13800001007', 'simzhu@museum.com', 25, '国家文物局颁发研究员级高级修复师证书', 1, '擅长商周青铜器修复，主持过多项国宝级青铜器修复项目'),
(8, '欧阳锦', 'EXP008', '青铜器鎏金修复', '高级修复师', '13800001008', 'oyjin@museum.com', 16, '国家文物局颁发高级修复师证书', 1, '专注于青铜器表面鎏金工艺修复，技艺精湛'),
(9, '钟离铭', 'EXP009', '青铜器铭文修复', '高级修复师', '13800001009', 'zlming@museum.com', 14, '国家文物局颁发高级修复师证书', 1, '精通青铜器铭文识别与修复，古文字学功底深厚'),

-- 玉器修复专家（ID: 10-12）
(10, '慕容璧', 'EXP010', '玉器文物修复', '研究员级高级修复师', '13800001010', 'mrbi@museum.com', 22, '国家文物局颁发研究员级高级修复师证书', 1, '玉器修复领域权威专家，擅长各类玉器修复与鉴定'),
(11, '上官琢', 'EXP011', '玉器雕刻修复', '高级修复师', '13800001011', 'sgzhuo@museum.com', 18, '国家文物局颁发高级修复师证书', 1, '精通传统玉雕技艺，擅长玉器缺损部位的补雕'),
(12, '南宫润', 'EXP012', '玉器抛光修复', '中级修复师', '13800001012', 'ngrun@museum.com', 10, '国家文物局颁发中级修复师证书', 1, '专注于玉器表面抛光与保养，手法细腻'),

-- 丝织品修复专家（ID: 13-15）
(13, '锦绣华', 'EXP013', '丝织品文物修复', '研究员级高级修复师', '13800001013', 'jxhua@museum.com', 28, '国家文物局颁发研究员级高级修复师证书', 1, '丝织品修复领域泰斗，主持过多项重要丝织品文物修复'),
(14, '云锦绣', 'EXP014', '云锦织物修复', '高级修复师', '13800001014', 'yjxiu@museum.com', 15, '国家文物局颁发高级修复师证书', 1, '擅长云锦、织金等高级丝织品修复，技艺传承有序'),
(15, '绫罗纱', 'EXP015', '刺绣文物修复', '高级修复师', '13800001015', 'llsha@museum.com', 13, '国家文物局颁发高级修复师证书', 1, '精通各类刺绣技法，擅长刺绣文物的修复与复原'),

-- 木器修复专家（ID: 16-18）
(16, '檀木香', 'EXP016', '木质文物修复', '研究员级高级修复师', '13800001016', 'tmxiang@museum.com', 26, '国家文物局颁发研究员级高级修复师证书', 1, '木器修复领域专家，擅长各类珍贵木材文物修复'),
(17, '梓木匠', 'EXP017', '古典家具修复', '高级修复师', '13800001017', 'zmjiang@museum.com', 20, '国家文物局颁发高级修复师证书', 1, '精通明清家具修复，对黄花梨、紫檀等名贵木材有深入研究'),
(18, '楠木青', 'EXP018', '木雕文物修复', '高级修复师', '13800001018', 'nmqing@museum.com', 17, '国家文物局颁发高级修复师证书', 1, '擅长木雕造像修复，雕刻技艺精湛'),

-- 漆器修复专家（ID: 19-21）
(19, '漆园生', 'EXP019', '漆器文物修复', '研究员级高级修复师', '13800001019', 'qysheng@museum.com', 24, '国家文物局颁发研究员级高级修复师证书', 1, '漆器修复领域权威，精通传统大漆工艺'),
(20, '朱漆红', 'EXP020', '剔红漆器修复', '高级修复师', '13800001020', 'zqhong@museum.com', 16, '国家文物局颁发高级修复师证书', 1, '专注于剔红、剔黑等雕漆工艺修复'),
(21, '金漆彩', 'EXP021', '彩绘漆器修复', '中级修复师', '13800001021', 'jqcai@museum.com', 11, '国家文物局颁发中级修复师证书', 1, '擅长漆器彩绘修复，色彩还原准确'),

-- 书画修复专家（ID: 22-24）
(22, '墨香斋', 'EXP022', '书画文物修复', '研究员级高级修复师', '13800001022', 'mxzhai@museum.com', 30, '国家文物局颁发研究员级高级修复师证书', 1, '书画修复大师，主持过多幅国宝级书画修复'),
(23, '纸墨轩', 'EXP023', '古籍善本修复', '高级修复师', '13800001023', 'zmxuan@museum.com', 19, '国家文物局颁发高级修复师证书', 1, '精通古籍装裱与修复，对各朝代装裱形式有深入研究'),
(24, '丹青手', 'EXP024', '壁画文物修复', '高级修复师', '13800001024', 'dqshou@museum.com', 15, '国家文物局颁发高级修复师证书', 1, '擅长壁画修复与色彩还原，参与过多处石窟壁画修复'),

-- 石质文物修复专家（ID: 25-27）
(25, '石破天', 'EXP025', '石质文物修复', '研究员级高级修复师', '13800001025', 'sptian@museum.com', 23, '国家文物局颁发研究员级高级修复师证书', 1, '石质文物修复专家，擅长各类石材文物修复'),
(26, '岩石坚', 'EXP026', '石刻碑拓修复', '高级修复师', '13800001026', 'ysjian@museum.com', 17, '国家文物局颁发高级修复师证书', 1, '精通石刻拓片制作与修复，碑学功底深厚'),
(27, '玉石琢', 'EXP027', '石雕造像修复', '高级修复师', '13800001027', 'yszhuo@museum.com', 14, '国家文物局颁发高级修复师证书', 1, '擅长佛教石雕造像修复，对各朝代造像风格有深入研究'),

-- 陶瓷修复专家（ID: 28-30）
(28, '瓷都匠', 'EXP028', '陶瓷文物修复', '研究员级高级修复师', '13800001028', 'cdjiang@museum.com', 27, '国家文物局颁发研究员级高级修复师证书', 1, '陶瓷修复领域权威，擅长各类陶瓷器修复'),
(29, '青花瓷', 'EXP029', '青花瓷器修复', '高级修复师', '13800001029', 'qhci@museum.com', 18, '国家文物局颁发高级修复师证书', 1, '专注于青花瓷修复，对元明清青花有深入研究'),
(30, '釉彩师', 'EXP030', '彩瓷釉面修复', '高级修复师', '13800001030', 'ycshi@museum.com', 16, '国家文物局颁发高级修复师证书', 1, '擅长粉彩、珐琅彩等彩瓷修复，釉色还原精准'),

-- 金属文物修复专家（ID: 31-33）
(31, '铁匠铺', 'EXP031', '铁器文物修复', '高级修复师', '13800001031', 'tjpu@museum.com', 19, '国家文物局颁发高级修复师证书', 1, '擅长铁器文物除锈与修复，对古代冶铁工艺有深入研究'),
(32, '铜镜师', 'EXP032', '铜镜文物修复', '中级修复师', '13800001032', 'tjshi@museum.com', 12, '国家文物局颁发中级修复师证书', 1, '专注于古代铜镜修复，对铜镜纹饰有深入研究'),
(33, '金工巧', 'EXP033', '金属器物修复', '高级修复师', '13800001033', 'jgqiao@museum.com', 15, '国家文物局颁发高级修复师证书', 1, '精通各类金属器物修复，焊接技艺精湛'),

-- 综合修复专家（ID: 34-36）
(34, '百工师', 'EXP034', '综合文物修复', '研究员级高级修复师', '13800001034', 'bgshi@museum.com', 32, '国家文物局颁发研究员级高级修复师证书', 1, '全能型修复专家，精通多种文物修复技艺'),
(35, '古物医', 'EXP035', '文物保护修复', '研究员级高级修复师', '13800001035', 'gwyi@museum.com', 29, '国家文物局颁发研究员级高级修复师证书', 1, '文物保护与修复专家，擅长文物病害诊断与治理'),
(36, '修复堂', 'EXP036', '文物修复技术研究', '研究员', '13800001036', 'xftang@museum.com', 25, '国家文物局颁发研究员证书', 1, '文物修复技术研究专家，多项修复技术创新成果');

-- 验证插入结果
SELECT '========== 专家数据插入完成 ==========' AS '';
SELECT CONCAT('修复专家总数: ', COUNT(*), ' 位') AS result FROM repair_expert;

-- 按专业领域分类统计
SELECT '========== 专家专业领域分类 ==========' AS '';
SELECT 
    CASE 
        WHEN specialty LIKE '%青铜%' THEN '青铜器修复'
        WHEN specialty LIKE '%玉器%' THEN '玉器修复'
        WHEN specialty LIKE '%丝织%' OR specialty LIKE '%刺绣%' OR specialty LIKE '%云锦%' THEN '丝织品修复'
        WHEN specialty LIKE '%木%' OR specialty LIKE '%家具%' OR specialty LIKE '%木雕%' THEN '木器修复'
        WHEN specialty LIKE '%漆器%' THEN '漆器修复'
        WHEN specialty LIKE '%书画%' OR specialty LIKE '%古籍%' OR specialty LIKE '%壁画%' THEN '书画修复'
        WHEN specialty LIKE '%石%' OR specialty LIKE '%石刻%' OR specialty LIKE '%石雕%' THEN '石质文物修复'
        WHEN specialty LIKE '%陶瓷%' OR specialty LIKE '%瓷器%' OR specialty LIKE '%青花%' OR specialty LIKE '%釉%' THEN '陶瓷修复'
        WHEN specialty LIKE '%金属%' OR specialty LIKE '%铁器%' OR specialty LIKE '%铜镜%' OR specialty LIKE '%金工%' THEN '金属文物修复'
        WHEN specialty LIKE '%金银%' THEN '金银器修复'
        WHEN specialty LIKE '%综合%' OR specialty LIKE '%保护%' OR specialty LIKE '%研究%' THEN '综合/研究'
        ELSE '其他'
    END AS '专业类别',
    COUNT(*) AS '专家数量',
    GROUP_CONCAT(expert_name SEPARATOR '、') AS '专家名单'
FROM repair_expert
GROUP BY 
    CASE 
        WHEN specialty LIKE '%青铜%' THEN '青铜器修复'
        WHEN specialty LIKE '%玉器%' THEN '玉器修复'
        WHEN specialty LIKE '%丝织%' OR specialty LIKE '%刺绣%' OR specialty LIKE '%云锦%' THEN '丝织品修复'
        WHEN specialty LIKE '%木%' OR specialty LIKE '%家具%' OR specialty LIKE '%木雕%' THEN '木器修复'
        WHEN specialty LIKE '%漆器%' THEN '漆器修复'
        WHEN specialty LIKE '%书画%' OR specialty LIKE '%古籍%' OR specialty LIKE '%壁画%' THEN '书画修复'
        WHEN specialty LIKE '%石%' OR specialty LIKE '%石刻%' OR specialty LIKE '%石雕%' THEN '石质文物修复'
        WHEN specialty LIKE '%陶瓷%' OR specialty LIKE '%瓷器%' OR specialty LIKE '%青花%' OR specialty LIKE '%釉%' THEN '陶瓷修复'
        WHEN specialty LIKE '%金属%' OR specialty LIKE '%铁器%' OR specialty LIKE '%铜镜%' OR specialty LIKE '%金工%' THEN '金属文物修复'
        WHEN specialty LIKE '%金银%' THEN '金银器修复'
        WHEN specialty LIKE '%综合%' OR specialty LIKE '%保护%' OR specialty LIKE '%研究%' THEN '综合/研究'
        ELSE '其他'
    END
ORDER BY COUNT(*) DESC;

-- 按职称统计
SELECT '========== 专家职称分布 ==========' AS '';
SELECT 
    title AS '职称',
    COUNT(*) AS '人数',
    CONCAT(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM repair_expert), 1), '%') AS '占比'
FROM repair_expert
GROUP BY title
ORDER BY COUNT(*) DESC;

-- 按从业年限统计
SELECT '========== 专家从业年限分布 ==========' AS '';
SELECT 
    CASE 
        WHEN work_years >= 25 THEN '25年以上（资深专家）'
        WHEN work_years >= 20 THEN '20-24年（高级专家）'
        WHEN work_years >= 15 THEN '15-19年（经验丰富）'
        WHEN work_years >= 10 THEN '10-14年（成熟期）'
        ELSE '10年以下（成长期）'
    END AS '从业年限段',
    COUNT(*) AS '人数',
    GROUP_CONCAT(expert_name SEPARATOR '、') AS '专家名单'
FROM repair_expert
GROUP BY 
    CASE 
        WHEN work_years >= 25 THEN '25年以上（资深专家）'
        WHEN work_years >= 20 THEN '20-24年（高级专家）'
        WHEN work_years >= 15 THEN '15-19年（经验丰富）'
        WHEN work_years >= 10 THEN '10-14年（成熟期）'
        ELSE '10年以下（成长期）'
    END
ORDER BY MIN(work_years) DESC;

-- 查看所有专家列表
SELECT '========== 所有专家列表 ==========' AS '';
SELECT 
    id AS 'ID',
    expert_name AS '姓名',
    expert_code AS '编号',
    specialty AS '专业领域',
    title AS '职称',
    work_years AS '从业年限',
    phone AS '电话',
    CASE WHEN status = 1 THEN '启用' ELSE '禁用' END AS '状态'
FROM repair_expert
ORDER BY id;

-- 文物类型与专家对应关系
SELECT '========== 文物类型与专家对应关系 ==========' AS '';
SELECT '青铜器' AS '文物类型', '司马铸、欧阳锦、钟离铭、纪南风' AS '对应专家';
SELECT '玉器' AS '文物类型', '慕容璧、上官琢、南宫润' AS '对应专家';
SELECT '丝织品' AS '文物类型', '锦绣华、云锦绣、绫罗纱' AS '对应专家';
SELECT '木器/家具' AS '文物类型', '檀木香、梓木匠、楠木青' AS '对应专家';
SELECT '漆器' AS '文物类型', '漆园生、朱漆红、金漆彩' AS '对应专家';
SELECT '书画/古籍' AS '文物类型', '墨香斋、纸墨轩、丹青手、叶知秋' AS '对应专家';
SELECT '石质文物' AS '文物类型', '石破天、岩石坚、玉石琢、陆星河' AS '对应专家';
SELECT '陶瓷器' AS '文物类型', '瓷都匠、青花瓷、釉彩师、江晚晴' AS '对应专家';
SELECT '金属器' AS '文物类型', '铁匠铺、铜镜师、金工巧、白露晞' AS '对应专家';
SELECT '金银器' AS '文物类型', '宋归远' AS '对应专家';
SELECT '综合/研究' AS '文物类型', '百工师、古物医、修复堂' AS '对应专家';

SELECT '========== 验证完成 ==========' AS '';
