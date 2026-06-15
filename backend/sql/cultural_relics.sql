/*
 Navicat Premium Data Transfer

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : localhost:3306
 Source Schema         : cultural_relics

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 15/06/2026 07:59:49
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_chat_message
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_message`;
CREATE TABLE `ai_chat_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `message_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息类型：user-用户消息, ai-AI回复',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容（完整的JSON响应）',
  `query_keyword` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '查询关键词（用户消息时记录）',
  `result_count` int NULL DEFAULT 0 COMMENT '返回结果数量（AI回复时记录）',
  `has_external_result` tinyint NULL DEFAULT 0 COMMENT '是否包含外部搜索结果：0-否，1-是',
  `relic_ids` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '相关文物ID列表（逗号分隔）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_session_id`(`session_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_message_type`(`message_type`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 143 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI对话消息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_chat_message
-- ----------------------------
INSERT INTO `ai_chat_message` VALUES (1, 1, 1, 'user', '请介绍一下商代青铜器的特点', '商代,青铜器', 0, 0, NULL, '2024-03-01 10:00:00');
INSERT INTO `ai_chat_message` VALUES (2, 1, 1, 'ai', '商代青铜器是中国青铜时代的代表，主要特点包括：1.器型厚重，纹饰繁复；2.常见饕餮纹、夔龙纹等神秘图案；3.铸造工艺精湛，多采用分铸法。我馆收藏的商代青铜鼎就是典型代表。', '商代,青铜器', 1, 0, '1', '2024-03-01 10:02:00');
INSERT INTO `ai_chat_message` VALUES (3, 1, 1, 'user', '馆内有哪些商代青铜器？', '商代,青铜器,馆藏', 0, 0, NULL, '2024-03-01 10:10:00');
INSERT INTO `ai_chat_message` VALUES (4, 1, 1, 'ai', '我馆目前收藏有商代青铜鼎（编号WW2024001），该文物出土于河南安阳，为三足圆鼎，腹部饰饕餮纹，铭文清晰，重38.5公斤，保存状态良好，目前在库。', '商代,青铜器', 1, 0, '1', '2024-03-01 10:15:00');
INSERT INTO `ai_chat_message` VALUES (5, 2, 2, 'user', '唐代有什么著名文物？', '唐代,文物', 0, 0, NULL, '2024-03-05 11:00:00');
INSERT INTO `ai_chat_message` VALUES (6, 2, 2, 'ai', '唐代是中国文化的鼎盛时期，我馆收藏有多件唐代珍品：1.唐三彩马（WW2024007）；2.唐代青铜佛像（WW2024005）；3.唐代山水画卷（WW2024013）；4.唐代金杯（WW2024024）等。', '唐代', 4, 0, '5,7,13,24', '2024-03-05 11:05:00');
INSERT INTO `ai_chat_message` VALUES (7, 2, 2, 'user', '唐三彩的特点是什么？', '唐三彩,特点', 0, 0, NULL, '2024-03-05 11:15:00');
INSERT INTO `ai_chat_message` VALUES (8, 2, 2, 'ai', '唐三彩是唐代低温釉陶器，主要特点：1.以黄、绿、白三色为主；2.釉色鲜艳，流动自然；3.多为陪葬品，造型生动。我馆的唐三彩马出土于洛阳，色彩保存完好，是研究唐代陶瓷艺术的重要实物。', '唐三彩', 1, 1, '7', '2024-03-05 11:20:00');
INSERT INTO `ai_chat_message` VALUES (9, 3, 3, 'user', '如何鉴别宋代瓷器？', '宋代,瓷器,鉴别', 0, 0, NULL, '2024-03-10 14:00:00');
INSERT INTO `ai_chat_message` VALUES (10, 3, 3, 'ai', '宋代瓷器鉴别要点：1.釉色：汝窑天青、官窑粉青、哥窑开片；2.胎质：细腻坚致；3.器型：简洁优雅；4.工艺：施釉均匀。我馆收藏的宋代汝窑盘（WW2024008）就是典型的汝窑天青釉，开片自然，是鉴赏学习的好范本。', '宋代,瓷器', 1, 1, '8', '2024-03-10 14:10:00');
INSERT INTO `ai_chat_message` VALUES (11, 3, 3, 'user', '馆内有哪些宋代瓷器？', '宋代,瓷器,馆藏', 0, 0, NULL, '2024-03-10 14:20:00');
INSERT INTO `ai_chat_message` VALUES (12, 3, 3, 'ai', '我馆收藏的宋代瓷器包括：宋代汝窑盘（WW2024008）、宋徽宗瘦金体书法（WW2024014，虽是书法但记录了宋代文化）等。汝窑盘是宋代五大名窑之一的代表作品。', '宋代,瓷器', 1, 0, '8', '2024-03-10 14:25:00');
INSERT INTO `ai_chat_message` VALUES (13, 4, 4, 'user', '王羲之的书法有什么特点？', '王羲之,书法', 0, 0, NULL, '2024-03-15 09:00:00');
INSERT INTO `ai_chat_message` VALUES (14, 4, 4, 'ai', '王羲之被誉为\"书圣\"，其书法特点：1.笔法灵动，结构严谨；2.行书流畅自然，富有韵律；3.兰亭序是其代表作。我馆收藏有王羲之兰亭序摹本（WW2024012），为唐代摹本，是研究王羲之书法的珍贵资料。', '王羲之,书法', 1, 1, '12', '2024-03-15 09:15:00');
INSERT INTO `ai_chat_message` VALUES (15, 4, 4, 'user', '这个摹本可以借展吗？', '借展,兰亭序', 0, 0, NULL, '2024-03-15 09:25:00');
INSERT INTO `ai_chat_message` VALUES (16, 4, 4, 'ai', '王羲之兰亭序摹本（WW2024012）目前状态为在库，理论上可以申请借展。但由于是纸本文物，较为脆弱，借展需要严格的环境控制和保护措施。建议您通过正式渠道提交借展申请，由审批员评估后决定。', '借展', 1, 0, '12', '2024-03-15 09:30:00');
INSERT INTO `ai_chat_message` VALUES (17, 5, 5, 'user', '玉器如何保养？', '玉器,保养', 0, 0, NULL, '2024-03-20 10:00:00');
INSERT INTO `ai_chat_message` VALUES (18, 5, 5, 'ai', '玉器保养要点：1.避免碰撞，防止破损；2.定期清洁，用软布擦拭；3.避免接触化学物质；4.保持适当湿度，防止失水。我馆对玉器文物都有专业的保养流程，如新石器玉璧、汉代玉衣片等都定期进行维护。', '玉器,保养', 3, 1, '18,19,20', '2024-03-20 10:20:00');
INSERT INTO `ai_chat_message` VALUES (19, 5, 5, 'user', '良渚玉璧有什么文化意义？', '良渚,玉璧', 0, 0, NULL, '2024-03-20 10:30:00');
INSERT INTO `ai_chat_message` VALUES (20, 5, 5, 'ai', '良渚玉璧是良渚文化的代表性器物，文化意义重大：1.礼器功能，用于祭祀；2.神人兽面纹体现原始宗教信仰；3.反映了5000年前的高度文明。我馆收藏的新石器玉璧（WW2024018）就出土于浙江良渚，直径25厘米，纹饰精美。', '良渚,玉璧', 1, 1, '18', '2024-03-20 10:40:00');
INSERT INTO `ai_chat_message` VALUES (21, 6, 1, 'user', '唐代金银器工艺如何？', '唐代,金银器,工艺', 0, 0, NULL, '2024-04-01 11:00:00');
INSERT INTO `ai_chat_message` VALUES (22, 6, 1, 'ai', '唐代金银器工艺达到高峰：1.錾刻、鎏金技术精湛；2.造型华丽，纹饰繁复；3.受西域影响，风格多样。我馆收藏的唐代金杯（WW2024024）采用鎏金银杯工艺，錾刻花纹精美，是唐代金属工艺的代表作品。', '唐代,金银器', 1, 1, '24', '2024-04-01 11:10:00');
INSERT INTO `ai_chat_message` VALUES (23, 6, 1, 'user', '这件金杯现在状态如何？', '金杯,状态', 0, 0, NULL, '2024-04-01 11:15:00');
INSERT INTO `ai_chat_message` VALUES (24, 6, 1, 'ai', '唐代金杯（WW2024024）目前状态为在库，保存良好。该文物在2024年4月10日进行过深度维护，包括清洁与防护处理。重量0.25公斤，出土于陕西西安，是研究唐代金属工艺的重要实物。', '金杯', 1, 0, '24', '2024-04-01 11:18:00');
INSERT INTO `ai_chat_message` VALUES (25, 7, 2, 'user', '汉代碑刻有什么特点？', '汉代,碑刻', 0, 0, NULL, '2024-04-10 15:00:00');
INSERT INTO `ai_chat_message` VALUES (26, 7, 2, 'ai', '汉代碑刻特点：1.多用隶书，笔画方正；2.内容丰富，记录历史事件；3.石质坚硬，保存较好。我馆收藏的汉代石碑（WW2024029）出土于山东曲阜，碑文保存完整，是研究汉代书法和历史的重要资料。', '汉代,碑刻', 1, 1, '29', '2024-04-10 15:20:00');
INSERT INTO `ai_chat_message` VALUES (27, 7, 2, 'user', '碑刻如何保护？', '碑刻,保护', 0, 0, NULL, '2024-04-10 15:30:00');
INSERT INTO `ai_chat_message` VALUES (28, 7, 2, 'ai', '碑刻保护措施：1.控制温湿度，防止风化；2.定期除尘清洁；3.避免阳光直射；4.必要时进行化学加固。我馆对汉代石碑和北魏造像碑都建立了完善的保护档案，定期进行维护检查。', '碑刻,保护', 2, 1, '29,30', '2024-04-10 15:35:00');
INSERT INTO `ai_chat_message` VALUES (29, 8, 3, 'user', '古代钱币如何鉴别真伪？', '古代钱币,鉴别', 0, 0, NULL, '2024-04-20 13:00:00');
INSERT INTO `ai_chat_message` VALUES (30, 8, 3, 'ai', '古代钱币鉴别方法：1.看铜质和锈色；2.听声音，真品声音清脆；3.观察文字和纹饰；4.测量重量和尺寸。我馆收藏有战国刀币、秦半两、汉五铢、唐开元通宝等各朝代钱币，可供研究参考。', '古代钱币', 4, 1, '33,34,35,36', '2024-04-20 13:15:00');
INSERT INTO `ai_chat_message` VALUES (31, 8, 3, 'user', '宋代钱币套装包含哪些？', '宋代,钱币', 0, 0, NULL, '2024-04-20 13:20:00');
INSERT INTO `ai_chat_message` VALUES (32, 8, 3, 'ai', '我馆收藏的宋代铜钱套装（WW2024037）包含宋代各朝钱币100枚，涵盖了宋太祖至宋徽宗时期的主要货币，如宋元通宝、太平通宝、熙宁元宝等，是研究宋代货币制度的完整资料。', '宋代,钱币', 1, 0, '37', '2024-04-20 13:22:00');
INSERT INTO `ai_chat_message` VALUES (33, 11, 13, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-22 11:18:32');
INSERT INTO `ai_chat_message` VALUES (34, 11, 13, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-22 11:18:32');
INSERT INTO `ai_chat_message` VALUES (35, 12, 16, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-23 15:36:34');
INSERT INTO `ai_chat_message` VALUES (36, 12, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-23 15:36:34');
INSERT INTO `ai_chat_message` VALUES (37, 13, 16, 'user', '兵马俑', '兵马俑', NULL, NULL, NULL, '2026-04-23 15:45:30');
INSERT INTO `ai_chat_message` VALUES (38, 13, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-23 15:45:30');
INSERT INTO `ai_chat_message` VALUES (39, 14, 16, 'user', '兵马俑', '兵马俑', NULL, NULL, NULL, '2026-04-23 15:46:48');
INSERT INTO `ai_chat_message` VALUES (40, 14, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-23 15:46:48');
INSERT INTO `ai_chat_message` VALUES (41, 15, 16, 'user', '介绍一下司母戊鼎\n', '介绍一下司母戊鼎\n', NULL, NULL, NULL, '2026-04-24 12:13:04');
INSERT INTO `ai_chat_message` VALUES (42, 15, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-24 12:13:04');
INSERT INTO `ai_chat_message` VALUES (43, 16, 1, 'user', '介绍一下司母戊鼎', '介绍一下司母戊鼎', NULL, NULL, NULL, '2026-04-24 12:13:59');
INSERT INTO `ai_chat_message` VALUES (44, 16, 1, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-24 12:13:59');
INSERT INTO `ai_chat_message` VALUES (49, 19, 1, 'user', '唐代金银器工艺如何？', '唐代金银器工艺如何？', NULL, NULL, NULL, '2026-04-24 13:35:09');
INSERT INTO `ai_chat_message` VALUES (50, 19, 1, 'ai', '为您找到了 5 件唐代金银器相关文物，按相关度为您排序展示。', NULL, 5, 0, '3,18,37,41,102', '2026-04-24 13:35:09');
INSERT INTO `ai_chat_message` VALUES (51, 20, 16, 'user', '唐代金银器工艺如何？\n', '唐代金银器工艺如何？\n', NULL, NULL, NULL, '2026-04-24 13:35:44');
INSERT INTO `ai_chat_message` VALUES (52, 20, 16, 'ai', '为您找到了 5 件唐代金银器相关文物，按相关度为您排序展示。', NULL, 5, 0, '3,18,37,41,102', '2026-04-24 13:35:44');
INSERT INTO `ai_chat_message` VALUES (53, 20, 16, 'user', '青铜器如何修复？', '青铜器如何修复？', NULL, NULL, NULL, '2026-04-24 13:36:09');
INSERT INTO `ai_chat_message` VALUES (54, 20, 16, 'ai', '青铜器修复技术：1.除锈处理：机械除锈或化学除锈；2.矫形整形：恢复器物原有形状；3.焊接粘接：修复断裂部位；4.封护处理：涂刷保护层防止氧化。 我馆收藏的北魏石佛像（WW0000003）和宋代银壶（WW0000068）和春秋青铜编钟（WW0000006），北魏时期完整石佛造像，艺术价值极高，都经过专业修复处理，保存状况良好。', NULL, 5, 0, '3,68,6,8,12', '2026-04-24 13:36:09');
INSERT INTO `ai_chat_message` VALUES (55, 21, 16, 'user', '汉代碑刻有什么特点？\n', '汉代碑刻有什么特点？\n', NULL, NULL, NULL, '2026-04-24 13:37:07');
INSERT INTO `ai_chat_message` VALUES (56, 21, 16, 'ai', '汉代碑特点：1.多用隶书，笔画方正；2.内容丰富，记录历史事件；3.石质坚硬，保存较好；4.实用与艺术并重； 我馆收藏的隋朝石刻佛首（WW0000073）和北魏石佛头像（WW0000002）和明代木雕佛龛（WW0000029），隋代石刻佛首，雕刻精美，面容庄严，是研究汉代碑的重要资料。', NULL, 5, 0, '73,2,29,33,46', '2026-04-24 13:37:07');
INSERT INTO `ai_chat_message` VALUES (57, 21, 16, 'user', '汉代刻碑如何保养\n', '汉代刻碑如何保养\n', NULL, NULL, NULL, '2026-04-24 13:37:35');
INSERT INTO `ai_chat_message` VALUES (58, 21, 16, 'ai', '为您找到了 5 件汉代碑相关文物，按相关度为您排序展示。', NULL, 5, 0, '73,1,2,19,24', '2026-04-24 13:37:35');
INSERT INTO `ai_chat_message` VALUES (59, 21, 16, 'user', '汉代刻碑如何保养？\n', '汉代刻碑如何保养？\n', NULL, NULL, NULL, '2026-04-24 13:38:07');
INSERT INTO `ai_chat_message` VALUES (60, 21, 16, 'ai', '为您找到了 5 件汉代碑相关文物，按相关度为您排序展示。', NULL, 5, 0, '73,1,2,19,24', '2026-04-24 13:38:07');
INSERT INTO `ai_chat_message` VALUES (61, 22, 16, 'user', '汉代碑刻有什么特点？', '汉代碑刻有什么特点？', NULL, NULL, NULL, '2026-04-24 13:43:03');
INSERT INTO `ai_chat_message` VALUES (62, 22, 16, 'ai', '汉代碑特点：1.多用隶书，笔画方正；2.内容丰富，记录历史事件；3.石质坚硬，保存较好；4.实用与艺术并重；', NULL, 0, 0, NULL, '2026-04-24 13:43:03');
INSERT INTO `ai_chat_message` VALUES (63, 22, 16, 'user', '汉代刻碑如何保养？', '汉代刻碑如何保养？', NULL, NULL, NULL, '2026-04-24 13:43:12');
INSERT INTO `ai_chat_message` VALUES (64, 22, 16, 'ai', '为您找到了 5 件汉代碑相关文物，按相关度为您排序展示。', NULL, 5, 0, '73,1,2,19,24', '2026-04-24 13:43:12');
INSERT INTO `ai_chat_message` VALUES (65, 23, 16, 'user', '玉器要如何保养\n', '玉器要如何保养\n', NULL, NULL, NULL, '2026-04-24 13:46:46');
INSERT INTO `ai_chat_message` VALUES (66, 23, 16, 'ai', '玉器保护措施：1.控制温湿度，防止风化；2.定期除尘清洁；3.避免阳光直射；4.必要时进行化学加固。', NULL, 0, 0, NULL, '2026-04-24 13:46:46');
INSERT INTO `ai_chat_message` VALUES (67, 23, 16, 'user', '青铜器要如何保养\n', '青铜器要如何保养\n', NULL, NULL, NULL, '2026-04-24 13:46:56');
INSERT INTO `ai_chat_message` VALUES (68, 23, 16, 'ai', '青铜器保护措施：1.控制温湿度，防止风化；2.定期除尘清洁；3.避免阳光直射；4.必要时进行化学加固。5.防止青铜病；6.控制氯离子含量；', NULL, 0, 0, NULL, '2026-04-24 13:46:56');
INSERT INTO `ai_chat_message` VALUES (69, 23, 16, 'user', '陶瓷器要如何保养\n', '陶瓷器要如何保养\n', NULL, NULL, NULL, '2026-04-24 13:47:21');
INSERT INTO `ai_chat_message` VALUES (70, 23, 16, 'ai', '瓷器保护措施：1.控制温湿度，防止风化；2.定期除尘清洁；3.避免阳光直射；4.必要时进行化学加固。', NULL, 0, 0, NULL, '2026-04-24 13:47:21');
INSERT INTO `ai_chat_message` VALUES (71, 23, 16, 'user', '介绍一下明代服饰的特点\n', '介绍一下明代服饰的特点\n', NULL, NULL, NULL, '2026-04-24 13:47:48');
INSERT INTO `ai_chat_message` VALUES (72, 23, 16, 'ai', '关于\"明代服饰的特点\"，本博物馆共收藏了 5 件相关文物，为您展示部分代表性藏品。', NULL, 5, 0, '82,96,11,12,21', '2026-04-24 13:47:48');
INSERT INTO `ai_chat_message` VALUES (73, 24, 16, 'user', '介绍一下司母戊鼎\n', '介绍一下司母戊鼎\n', NULL, NULL, NULL, '2026-04-24 13:55:31');
INSERT INTO `ai_chat_message` VALUES (74, 24, 16, 'ai', '\"商代青铜鼎\"是商朝时期的文物，材质为青铜，属于青铜器类。 商代青铜鼎，铸造精良，纹饰精美', NULL, 0, 0, NULL, '2026-04-24 13:55:31');
INSERT INTO `ai_chat_message` VALUES (75, 24, 16, 'user', '汉代碑刻有什么特点？', '汉代碑刻有什么特点？', NULL, NULL, NULL, '2026-04-24 13:57:22');
INSERT INTO `ai_chat_message` VALUES (76, 24, 16, 'ai', '汉代碑特点：1.多用隶书，笔画方正；2.内容丰富，记录历史事件；3.石质坚硬，保存较好；4.实用与艺术并重；', NULL, 0, 0, NULL, '2026-04-24 13:57:22');
INSERT INTO `ai_chat_message` VALUES (77, 24, 16, 'user', '司母戊鼎\n', '司母戊鼎\n', NULL, NULL, NULL, '2026-04-24 13:57:48');
INSERT INTO `ai_chat_message` VALUES (78, 24, 16, 'ai', '为您找到了\"商代青铜鼎\"，它是商朝时期的文物，材质为青铜，属于青铜器类。商代青铜鼎，铸造精良，纹饰精美', NULL, 2, 0, '59,7', '2026-04-24 13:57:48');
INSERT INTO `ai_chat_message` VALUES (79, 25, 16, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-24 14:01:00');
INSERT INTO `ai_chat_message` VALUES (80, 25, 16, 'ai', '为您找到了\"商代青铜鼎\"，它是商朝时期的文物，材质为青铜，属于青铜器类。商代青铜鼎，铸造精良，纹饰精美', NULL, 2, 0, '59,7', '2026-04-24 14:01:00');
INSERT INTO `ai_chat_message` VALUES (81, 25, 16, 'user', '介绍一下司母戊鼎\n', '介绍一下司母戊鼎\n', NULL, NULL, NULL, '2026-04-24 14:01:12');
INSERT INTO `ai_chat_message` VALUES (82, 25, 16, 'ai', '为您找到了\"商代青铜鼎\"，它是商朝时期的文物，材质为青铜，属于青铜器类。商代青铜鼎，铸造精良，纹饰精美', NULL, 2, 0, '59,7', '2026-04-24 14:01:12');
INSERT INTO `ai_chat_message` VALUES (83, 26, 16, 'user', '介绍一下司母戊鼎', '介绍一下司母戊鼎', NULL, NULL, NULL, '2026-04-24 14:01:55');
INSERT INTO `ai_chat_message` VALUES (84, 26, 16, 'ai', '为您找到了\"商代青铜鼎\"，它是商朝时期的文物，材质为青铜，属于青铜器类。商代青铜鼎，铸造精良，纹饰精美', NULL, 2, 0, '59,7', '2026-04-24 14:01:55');
INSERT INTO `ai_chat_message` VALUES (85, 27, 17, 'user', '介绍一下清明上河图\n', '介绍一下清明上河图\n', NULL, NULL, NULL, '2026-04-24 14:10:25');
INSERT INTO `ai_chat_message` VALUES (86, 27, 17, 'ai', '关于\"该概念\"，本博物馆共收藏了 63 件相关文物。', NULL, 0, 0, NULL, '2026-04-24 14:10:25');
INSERT INTO `ai_chat_message` VALUES (87, 27, 17, 'user', '清明上河图', '清明上河图', NULL, NULL, NULL, '2026-04-24 14:10:33');
INSERT INTO `ai_chat_message` VALUES (88, 27, 17, 'ai', '本博物馆共有 63 件相关文物，包括元代墨竹图、北宋铜钱串、北魏石佛像等。', NULL, 0, 0, NULL, '2026-04-24 14:10:33');
INSERT INTO `ai_chat_message` VALUES (89, 28, 17, 'user', '清明上河图', '清明上河图', NULL, NULL, NULL, '2026-04-24 14:14:56');
INSERT INTO `ai_chat_message` VALUES (90, 28, 17, 'ai', '为您找到了\"明代补子\"，它是明朝时期的文物，材质为丝绸，属于服饰类。明代官服补子，刺绣精美', NULL, 5, 0, '25,26,27,28,29', '2026-04-24 14:14:56');
INSERT INTO `ai_chat_message` VALUES (91, 28, 17, 'user', '介绍一下清明上河图\n', '介绍一下清明上河图\n', NULL, NULL, NULL, '2026-04-24 14:15:25');
INSERT INTO `ai_chat_message` VALUES (92, 28, 17, 'ai', '为您找到了\"明代补子\"，它是明朝时期的文物，材质为丝绸，属于服饰类。明代官服补子，刺绣精美', NULL, 5, 0, '25,26,27,28,29', '2026-04-24 14:15:25');
INSERT INTO `ai_chat_message` VALUES (93, 28, 17, 'user', '商代青铜大鼎', '商代青铜大鼎', NULL, NULL, NULL, '2026-04-24 14:15:40');
INSERT INTO `ai_chat_message` VALUES (94, 28, 17, 'ai', '为您找到了\"商代玉戈\"，它是商朝时期的文物，材质为玉，属于玉器类。商代玉戈，玉质精良，制作精美', NULL, 5, 0, '61,6,8,12,40', '2026-04-24 14:15:40');
INSERT INTO `ai_chat_message` VALUES (95, 29, 17, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-24 14:30:20');
INSERT INTO `ai_chat_message` VALUES (96, 29, 17, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-24 14:30:20');
INSERT INTO `ai_chat_message` VALUES (97, 30, 1, 'user', '讲解', '讲解', NULL, NULL, NULL, '2026-04-24 19:45:29');
INSERT INTO `ai_chat_message` VALUES (98, 30, 1, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-24 19:45:29');
INSERT INTO `ai_chat_message` VALUES (99, 31, 1, 'user', '五铢钱', '五铢钱', NULL, NULL, NULL, '2026-04-24 19:45:56');
INSERT INTO `ai_chat_message` VALUES (100, 31, 1, 'ai', '已为你找到 2 件与“五铢钱”相关的馆藏文物，并补充展示了尺寸和重量信息。', NULL, 2, 0, '16,17', '2026-04-24 19:45:56');
INSERT INTO `ai_chat_message` VALUES (101, 32, 1, 'user', '汉朝', '汉朝', NULL, NULL, NULL, '2026-04-24 19:46:12');
INSERT INTO `ai_chat_message` VALUES (102, 32, 1, 'ai', '已为你找到 5 件与“汉朝”相关的馆藏文物，并补充展示了尺寸和重量信息。', NULL, 5, 0, '8,9,10,11,12', '2026-04-24 19:46:12');
INSERT INTO `ai_chat_message` VALUES (103, 33, 1, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-27 10:39:49');
INSERT INTO `ai_chat_message` VALUES (104, 33, 1, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-27 10:39:49');
INSERT INTO `ai_chat_message` VALUES (105, 34, 16, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-27 10:41:10');
INSERT INTO `ai_chat_message` VALUES (106, 34, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-27 10:41:10');
INSERT INTO `ai_chat_message` VALUES (107, 35, 16, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-27 17:25:19');
INSERT INTO `ai_chat_message` VALUES (108, 35, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-27 17:25:19');
INSERT INTO `ai_chat_message` VALUES (109, 35, 16, 'user', '兵马俑\n', '兵马俑\n', NULL, NULL, NULL, '2026-04-27 17:25:24');
INSERT INTO `ai_chat_message` VALUES (110, 35, 16, 'ai', '已为你找到 1 件与“兵马俑”相关的馆藏文物，并补充展示了尺寸和重量信息。', NULL, 1, 0, '270', '2026-04-27 17:25:24');
INSERT INTO `ai_chat_message` VALUES (111, 36, 16, 'user', '司母戊鼎', '司母戊鼎', NULL, NULL, NULL, '2026-04-30 10:10:01');
INSERT INTO `ai_chat_message` VALUES (112, 36, 16, 'ai', '本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。', NULL, 1, 1, '', '2026-04-30 10:10:01');
INSERT INTO `ai_chat_message` VALUES (113, 37, 1, 'user', '有哪些唐朝的文物\n', '有哪些唐朝的文物\n', NULL, NULL, NULL, '2026-05-09 16:43:48');
INSERT INTO `ai_chat_message` VALUES (114, 37, 1, 'ai', '抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。', NULL, 0, 0, NULL, '2026-05-09 16:43:48');
INSERT INTO `ai_chat_message` VALUES (115, 38, 1, 'user', '有哪些唐朝的文物\n', '有哪些唐朝的文物\n', NULL, NULL, NULL, '2026-05-09 16:45:58');
INSERT INTO `ai_chat_message` VALUES (116, 38, 1, 'ai', '抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。', NULL, 0, 0, NULL, '2026-05-09 16:45:58');
INSERT INTO `ai_chat_message` VALUES (117, 39, 1, 'user', '司母戊鼎\n', '司母戊鼎\n', NULL, NULL, NULL, '2026-05-09 16:47:05');
INSERT INTO `ai_chat_message` VALUES (118, 39, 1, 'ai', '抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。', NULL, 0, 0, NULL, '2026-05-09 16:47:05');
INSERT INTO `ai_chat_message` VALUES (119, 40, 1, 'user', '有哪些文物不能在潮湿环境下保存\n', '有哪些文物不能在潮湿环境下保存\n', NULL, NULL, NULL, '2026-05-09 16:54:00');
INSERT INTO `ai_chat_message` VALUES (120, 40, 1, 'ai', '抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。', NULL, 0, 0, NULL, '2026-05-09 16:54:00');
INSERT INTO `ai_chat_message` VALUES (121, 40, 1, 'user', '有哪些文物不能在潮湿环境下保存\n', '有哪些文物不能在潮湿环境下保存\n', NULL, NULL, NULL, '2026-05-09 16:54:17');
INSERT INTO `ai_chat_message` VALUES (122, 40, 1, 'ai', '抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。', NULL, 0, 0, NULL, '2026-05-09 16:54:17');
INSERT INTO `ai_chat_message` VALUES (123, 40, 1, 'user', '有哪些文物不能在潮湿环境下保存\n', '有哪些文物不能在潮湿环境下保存\n', NULL, NULL, NULL, '2026-05-09 16:54:30');
INSERT INTO `ai_chat_message` VALUES (124, 40, 1, 'ai', '抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。', NULL, 0, 0, NULL, '2026-05-09 16:54:30');
INSERT INTO `ai_chat_message` VALUES (125, 40, 1, 'user', '有哪些文物不能在潮湿环境下保存\n', '有哪些文物不能在潮湿环境下保存\n', NULL, NULL, NULL, '2026-05-09 16:57:28');
INSERT INTO `ai_chat_message` VALUES (126, 40, 1, 'ai', '根据文物材质特性，以下文物不宜在潮湿环境保存：纸本类（如汉碑残拓、明代唐寅山水画、清代花鸟立轴等），丝绸类（如汉代丝织残片、明代龙袍、清代织金袍等），漆木类（如汉代漆盘、明代黄花梨椅、清代红木柜等），以及陶器类（如汉代彩绘陶俑、唐三彩马等）。潮湿易导致纸张霉变、丝绸腐朽、漆木开裂、陶器彩绘剥落。', NULL, 31, 0, '9,14,11,23,26,28,32,33,38,45,46,47,49,52,53,54,58,64,69,70,71,72,74,79,84,85,86,87,90,97,99', '2026-05-09 16:57:28');
INSERT INTO `ai_chat_message` VALUES (127, 41, 1, 'user', '有哪些唐朝的文物？\n', '有哪些唐朝的文物？\n', NULL, NULL, NULL, '2026-05-09 17:09:15');
INSERT INTO `ai_chat_message` VALUES (128, 41, 1, 'ai', '{\"answer\":\"根据博物馆馆藏，唐朝文物共有10件，包括：开元通宝套币、鎏金银壶、唐碑拓本、唐代金杯、唐代龙凤玉佩、唐代墓志铭、唐代青铜佛像、唐代山水画卷、唐代铜佛像、唐代铜观音、唐代玉带饰、唐开元通宝、唐三彩马、王羲之兰亭序摹本、王羲之摹本。这些文物涵盖了金银器、玉器、碑帖、佛像、书画、钱币、陶瓷器等多个类别，展现了唐代文化的繁荣与艺术成就。\",\"total\":15,\"topReason\":\"用户询问唐朝文物，列表中共有15件年代为唐朝的文物，涵盖多种材质与类型，全面反映唐代艺术与历史。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 15 件相关文物\",\"relics\":[{\"id\":20,\"relicName\":\"开元通宝套币\",\"imagePath\":\"/uploads/b1a5dc0a56e649cb98dcd54893ce2cf9.jpg\",\"era\":\"唐朝\",\"material\":\"铜\",\"status\":\"在库\",\"categoryName\":\"钱币\",\"dimensions\":\"直径2.4cm\",\"weight\":0.2,\"description\":\"唐代开元通宝成套钱币，品相完好\",\"introduction\":\"开元通宝套币，年代为唐朝，材质为铜，分类属于钱币，尺寸为直径2.4cm，重量约 0.20kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代开元通宝成套钱币，品相完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":22,\"relicName\":\"鎏金银壶\",\"imagePath\":\"/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp\",\"era\":\"唐朝\",\"material\":\"鎏金银\",\"status\":\"在库\",\"categoryName\":\"金银器\",\"dimensions\":\"高25cm\",\"weight\":1.2,\"description\":\"唐代鎏金银壶，造型优美，工艺精湛\",\"introduction\":\"鎏金银壶，年代为唐朝，材质为鎏金银，分类属于金银器，尺寸为高25cm，重量约 1.20kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代鎏金银壶，造型优美，工艺精湛\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":74,\"relicName\":\"唐碑拓本\",\"imagePath\":\"/uploads/59454ff4a2c042fd925150657b318d51.webp\",\"era\":\"唐朝\",\"material\":\"纸\",\"status\":\"在库\",\"categoryName\":\"碑帖\",\"dimensions\":\"100x50cm\",\"weight\":0.2,\"description\":\"唐代碑刻拓本，书法遒劲，保存完好\",\"introduction\":\"唐碑拓本，年代为唐朝，材质为纸，分类属于碑帖，尺寸为100x50cm，重量约 0.20kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代碑刻拓本，书法遒劲，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":75,\"relicName\":\"唐代金杯\",\"imagePath\":\"/uploads/645b9ef90d134ef0b0139a4fa7918046.webp\",\"era\":\"唐朝\",\"material\":\"金\",\"status\":\"在库\",\"categoryName\":\"金银器\",\"dimensions\":\"高10cm\",\"weight\":0.2,\"description\":\"唐代金杯，工艺精湛，保存完好\",\"introduction\":\"唐代金杯，年代为唐朝，材质为金，分类属于金银器，尺寸为高10cm，重量约 0.20kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代金杯，工艺精湛，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":76,\"relicName\":\"唐代龙凤玉佩\",\"imagePath\":\"/uploads/63d15e510c7d4e3db421a419b350fe24.webp\",\"era\":\"唐朝\",\"material\":\"玉\",\"status\":\"在库\",\"categoryName\":\"玉器\",\"dimensions\":\"长10cm\",\"weight\":0.15,\"description\":\"唐代龙凤纹玉佩，雕工精细，寓意吉祥\",\"introduction\":\"唐代龙凤玉佩，年代为唐朝，材质为玉，分类属于玉器，尺寸为长10cm，重量约 0.15kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代龙凤纹玉佩，雕工精细，寓意吉祥\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":77,\"relicName\":\"唐代墓志铭\",\"imagePath\":\"/uploads/8a46b212628d48d5ab02a77e02697f1b.webp\",\"era\":\"唐朝\",\"material\":\"石\",\"status\":\"在库\",\"categoryName\":\"碑帖\",\"dimensions\":\"50x50cm\",\"weight\":30.0,\"description\":\"唐代墓志铭，文字清晰，书法精美\",\"introduction\":\"唐代墓志铭，年代为唐朝，材质为石，分类属于碑帖，尺寸为50x50cm，重量约 30.00kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代墓志铭，文字清晰，书法精美\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":78,\"relicName\":\"唐代青铜佛像\",\"imagePath\":\"/uploads/3c219d52e3814f8d8c6277827ec91d97.webp\",\"era\":\"唐朝\",\"material\":\"青铜\",\"status\":\"在库\",\"categoryName\":\"佛像\",\"dimensions\":\"高50cm\",\"weight\":12.0,\"description\":\"唐代青铜佛像，铸造精良，神态庄严\",\"introduction\":\"唐代青铜佛像，年代为唐朝，材质为青铜，分类属于佛像，尺寸为高50cm，重量约 12.00kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代青铜佛像，铸造精良，神态庄严\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":79,\"relicName\":\"唐代山水画卷\",\"imagePath\":\"/uploads/9784a41ce1a44bcbb3ce5f6428fe578b.webp\",\"era\":\"唐朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"300x50cm\",\"weight\":1.0,\"description\":\"唐代山水画卷，笔墨精妙，极为珍贵\",\"introduction\":\"唐代山水画卷，年代为唐朝，材质为纸本，分类属于书画，尺寸为300x50cm，重量约 1.00kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代山水画卷，笔墨精妙，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":80,\"relicName\":\"唐代铜佛像\",\"imagePath\":\"/uploads/e089b182f84640379e15b2400d714945.jpg\",\"era\":\"唐朝\",\"material\":\"青铜\",\"status\":\"在库\",\"categoryName\":\"佛像\",\"dimensions\":\"高35cm\",\"weight\":8.0,\"description\":\"唐代铜佛造像，铸造精良，保存完好\",\"introduction\":\"唐代铜佛像，年代为唐朝，材质为青铜，分类属于佛像，尺寸为高35cm，重量约 8.00kg，当前状态为在库，来源/出土地为山西五台山。相关介绍：唐代铜佛造像，铸造精良，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":81,\"relicName\":\"唐代铜观音\",\"imagePath\":\"/uploads/6da715a8159045bda0e896de63ace624.webp\",\"era\":\"唐朝\",\"material\":\"青铜\",\"status\":\"在库\",\"categoryName\":\"佛像\",\"dimensions\":\"高60cm\",\"weight\":15.0,\"description\":\"唐代铜观音像，造型优美，神态慈祥\",\"introduction\":\"唐代铜观音，年代为唐朝，材质为青铜，分类属于佛像，尺寸为高60cm，重量约 15.00kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代铜观音像，造型优美，神态慈祥\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":82,\"relicName\":\"唐代玉带饰\",\"imagePath\":\"/uploads/dde2f35afcff45f09b596453e10a4ef0.jpg\",\"era\":\"唐朝\",\"material\":\"玉\",\"status\":\"在库\",\"categoryName\":\"玉器\",\"dimensions\":\"长8cm\",\"weight\":0.1,\"description\":\"唐代玉带饰，雕工精细，保存完好\",\"introduction\":\"唐代玉带饰，年代为唐朝，材质为玉，分类属于玉器，尺寸为长8cm，重量约 0.10kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代玉带饰，雕工精细，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":83,\"relicName\":\"唐开元通宝\",\"imagePath\":\"/uploads/cdce86e7172a4afd980616b72139e389.webp\",\"era\":\"唐朝\",\"material\":\"铜\",\"status\":\"在库\",\"categoryName\":\"钱币\",\"dimensions\":\"直径2.4cm\",\"weight\":0.04,\"description\":\"唐代开元通宝，铸造规整，品相完好\",\"introduction\":\"唐开元通宝，年代为唐朝，材质为铜，分类属于钱币，尺寸为直径2.4cm，重量约 0.04kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代开元通宝，铸造规整，品相完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":84,\"relicName\":\"唐三彩马\",\"imagePath\":\"/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp\",\"era\":\"唐朝\",\"material\":\"陶\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高50cm\",\"weight\":5.0,\"description\":\"唐三彩马，造型生动，釉色艳丽\",\"introduction\":\"唐三彩马，年代为唐朝，材质为陶，分类属于陶瓷器，尺寸为高50cm，重量约 5.00kg，当前状态为在库，来源/出土地为河南洛阳。相关介绍：唐三彩马，造型生动，釉色艳丽\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":85,\"relicName\":\"王羲之兰亭序摹本\",\"imagePath\":\"/uploads/ab83d1743bd541d79414fe67c8a5e524.webp\",\"era\":\"唐朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"28x320cm\",\"weight\":0.5,\"description\":\"王羲之兰亭序唐代摹本，书法精妙，极为珍贵\",\"introduction\":\"王羲之兰亭序摹本，年代为唐朝，材质为纸本，分类属于书画，尺寸为28x320cm，重量约 0.50kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：王羲之兰亭序唐代摹本，书法精妙，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":86,\"relicName\":\"王羲之摹本\",\"imagePath\":\"/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg\",\"era\":\"唐朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"30x100cm\",\"weight\":0.3,\"description\":\"王羲之书法唐代摹本，笔法精妙，价值连城\",\"introduction\":\"王羲之摹本，年代为唐朝，材质为纸本，分类属于书画，尺寸为30x100cm，重量约 0.30kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：王羲之书法唐代摹本，笔法精妙，价值连城\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":41}', NULL, 15, 0, '20,22,74,75,76,77,78,79,80,81,82,83,84,85,86', '2026-05-09 17:09:15');
INSERT INTO `ai_chat_message` VALUES (129, 41, 1, 'user', '这些文物应该如何保养\n', '这些文物应该如何保养\n', NULL, NULL, NULL, '2026-05-09 17:09:54');
INSERT INTO `ai_chat_message` VALUES (130, 41, 1, 'ai', '{\"answer\":\"文物保养需根据材质分类处理：石质文物（如北魏石佛头像）需防潮、避光、避免酸碱接触；青铜器（如曾侯乙编钟）需控制温湿度、防锈；陶瓷器（如汝窑天青釉盏）需防碰撞、防尘；书画类（如唐寅山水画）需防潮、防虫、避免紫外线；丝绸服饰（如民国旗袍）需恒温恒湿、防虫蛀；漆木器（如明代黄花梨椅）需防干裂、防虫。建议定期检查环境，避免直接接触。\",\"total\":5,\"topReason\":\"推荐涵盖主要材质类别：石质、青铜、陶瓷、书画、丝绸，代表不同保养需求，便于用户了解各类文物保养要点。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 5 件相关文物\",\"relics\":[{\"id\":2,\"relicName\":\"北魏石佛头像\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"era\":\"南北朝\",\"material\":\"石\",\"status\":\"借展中\",\"categoryName\":\"佛像\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"introduction\":\"北魏石佛头像，年代为南北朝，材质为石，分类属于佛像，尺寸为高25cm，重量约 8.00kg，当前状态为借展中，来源/出土地为山西大同。相关介绍：北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"relevancePercent\":95,\"matchTags\":[\"保养\",\"文物\",\"材质\",\"环境\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":5,\"relicName\":\"曾侯乙编钟\",\"imagePath\":\"/uploads/32877c4cd94f4c7f98de18818a8c5104.webp\",\"era\":\"战国\",\"material\":\"青铜\",\"status\":\"修复中\",\"categoryName\":\"青铜器\",\"dimensions\":\"高265cm\",\"weight\":2500.0,\"description\":\"战国时期曾侯乙墓出土编钟，音律完整，国宝级文物\",\"introduction\":\"曾侯乙编钟，年代为战国，材质为青铜，分类属于青铜器，尺寸为高265cm，重量约 2500.00kg，当前状态为修复中，来源/出土地为湖北随州。相关介绍：战国时期曾侯乙墓出土编钟，音律完整，国宝级文物\",\"relevancePercent\":95,\"matchTags\":[\"保养\",\"文物\",\"材质\",\"环境\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":56,\"relicName\":\"汝窑天青釉盏\",\"imagePath\":\"/uploads/6bd0676aaba342a0a7da079eb82dec70.webp\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径12cm\",\"weight\":0.2,\"description\":\"宋代汝窑天青釉盏，釉色纯正，极为珍贵\",\"introduction\":\"汝窑天青釉盏，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为直径12cm，重量约 0.20kg，当前状态为在库，来源/出土地为河南汝州。相关介绍：宋代汝窑天青釉盏，釉色纯正，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"保养\",\"文物\",\"材质\",\"环境\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":32,\"relicName\":\"明代唐寅山水画\",\"imagePath\":\"/uploads/3f8291c4743e4e078f1f5b47e69bdcce.webp\",\"era\":\"明朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"120x60cm\",\"weight\":0.5,\"description\":\"明代唐寅山水画作，笔墨精妙，极为珍贵\",\"introduction\":\"明代唐寅山水画，年代为明朝，材质为纸本，分类属于书画，尺寸为120x60cm，重量约 0.50kg，当前状态为在库，来源/出土地为江苏苏州。相关介绍：明代唐寅山水画作，笔墨精妙，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"保养\",\"文物\",\"材质\",\"环境\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":24,\"relicName\":\"民国旗袍\",\"imagePath\":\"/uploads/3c3c740446124bc794e2339c33eb37ea.webp\",\"era\":\"民国\",\"material\":\"丝绸\",\"status\":\"在库\",\"categoryName\":\"服饰\",\"dimensions\":\"长120cm\",\"weight\":0.5,\"description\":\"民国时期旗袍，保存完好，具有时代特色\",\"introduction\":\"民国旗袍，年代为民国，材质为丝绸，分类属于服饰，尺寸为长120cm，重量约 0.50kg，当前状态为在库，来源/出土地为上海。相关介绍：民国时期旗袍，保存完好，具有时代特色\",\"relevancePercent\":95,\"matchTags\":[\"保养\",\"文物\",\"材质\",\"环境\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":null}', NULL, 5, 0, '2,5,56,32,24', '2026-05-09 17:09:54');
INSERT INTO `ai_chat_message` VALUES (131, 41, 1, 'user', '有什么值得参观的文物？\n', '有什么值得参观的文物？\n', NULL, NULL, NULL, '2026-05-09 17:10:51');
INSERT INTO `ai_chat_message` VALUES (132, 41, 1, 'ai', '{\"answer\":\"根据您的问题，我推荐参观曾侯乙编钟、宋徽宗瘦金体书法、元代青花瓷瓶、唐三彩马和新石器彩陶罐。这些文物分别代表了不同时代的顶尖工艺：战国青铜乐器的音律完整、宋代书法的独特笔法、元代青花的浓艳发色、唐代陶俑的生动造型以及新石器时代的彩绘技艺，均具有极高的历史与艺术价值。\",\"total\":5,\"topReason\":\"这些文物均为各时期代表性国宝，涵盖青铜、书画、陶瓷、陶器等多类别，展示中国文明发展脉络，且状态为在库或修复中，适合参观。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 5 件相关文物\",\"relics\":[{\"id\":5,\"relicName\":\"曾侯乙编钟\",\"imagePath\":\"/uploads/32877c4cd94f4c7f98de18818a8c5104.webp\",\"era\":\"战国\",\"material\":\"青铜\",\"status\":\"修复中\",\"categoryName\":\"青铜器\",\"dimensions\":\"高265cm\",\"weight\":2500.0,\"description\":\"战国时期曾侯乙墓出土编钟，音律完整，国宝级文物\",\"introduction\":\"曾侯乙编钟，年代为战国，材质为青铜，分类属于青铜器，尺寸为高265cm，重量约 2500.00kg，当前状态为修复中，来源/出土地为湖北随州。相关介绍：战国时期曾侯乙墓出土编钟，音律完整，国宝级文物\",\"relevancePercent\":95,\"matchTags\":[\"参观\",\"值得\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":70,\"relicName\":\"宋徽宗瘦金体书法\",\"imagePath\":\"/uploads/322f2cc978d249ba98113313ae837853.webp\",\"era\":\"宋朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"100x40cm\",\"weight\":0.3,\"description\":\"宋徽宗瘦金体书法真迹，笔法独特，国宝级文物\",\"introduction\":\"宋徽宗瘦金体书法，年代为宋朝，材质为纸本，分类属于书画，尺寸为100x40cm，重量约 0.30kg，当前状态为在库，来源/出土地为河南开封。相关介绍：宋徽宗瘦金体书法真迹，笔法独特，国宝级文物\",\"relevancePercent\":95,\"matchTags\":[\"参观\",\"值得\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":98,\"relicName\":\"元代青花瓷瓶\",\"imagePath\":\"/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp\",\"era\":\"元朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高40cm\",\"weight\":3.0,\"description\":\"元代青花瓷瓶，青花发色浓艳，极为珍贵\",\"introduction\":\"元代青花瓷瓶，年代为元朝，材质为瓷，分类属于陶瓷器，尺寸为高40cm，重量约 3.00kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：元代青花瓷瓶，青花发色浓艳，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"参观\",\"值得\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":84,\"relicName\":\"唐三彩马\",\"imagePath\":\"/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp\",\"era\":\"唐朝\",\"material\":\"陶\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高50cm\",\"weight\":5.0,\"description\":\"唐三彩马，造型生动，釉色艳丽\",\"introduction\":\"唐三彩马，年代为唐朝，材质为陶，分类属于陶瓷器，尺寸为高50cm，重量约 5.00kg，当前状态为在库，来源/出土地为河南洛阳。相关介绍：唐三彩马，造型生动，釉色艳丽\",\"relevancePercent\":95,\"matchTags\":[\"参观\",\"值得\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":93,\"relicName\":\"新石器彩陶罐\",\"imagePath\":\"/uploads/5daff7dd306e4104ba29ad26d2fd0fa7.webp\",\"era\":\"新石器时代\",\"material\":\"陶\",\"status\":\"封存\",\"categoryName\":\"青铜器\",\"dimensions\":\"高40cm\",\"weight\":3.0,\"description\":\"新石器时代彩陶罐，纹饰精美，保存完好\",\"introduction\":\"新石器彩陶罐，年代为新石器时代，材质为陶，分类属于青铜器，尺寸为高40cm，重量约 3.00kg，当前状态为封存，来源/出土地为甘肃马家窑。相关介绍：新石器时代彩陶罐，纹饰精美，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"参观\",\"值得\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":null}', NULL, 5, 0, '5,70,98,84,93', '2026-05-09 17:10:51');
INSERT INTO `ai_chat_message` VALUES (133, 42, 1, 'user', '有哪些陶瓷类文物？\n', '有哪些陶瓷类文物？\n', NULL, NULL, NULL, '2026-05-09 17:18:42');
INSERT INTO `ai_chat_message` VALUES (134, 42, 1, 'ai', '{\"answer\":\"根据馆藏文物列表，陶瓷类文物包括：汉代彩绘陶俑（ID:10）、明代青花盘（ID:30）、明代青花碗（ID:31）、清代粉彩瓶（ID:44）、汝窑天青釉盏（ID:56）、三国青瓷罐（ID:57）、宋代白瓷瓶（ID:63）、宋代汝窑盘（ID:66）、唐三彩马（ID:84）、元代青花瓷瓶（ID:98）、元青花梅瓶（ID:100）等。这些文物涵盖从汉代到清代的陶瓷精品，如汝窑、青花、粉彩等，具有重要历史与艺术价值。\",\"total\":11,\"topReason\":\"这些文物的分类均为\'陶瓷器\'，符合用户对陶瓷类文物的需求，且涵盖不同年代和工艺类型，具有代表性。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 11 件相关文物\",\"relics\":[{\"id\":10,\"relicName\":\"汉代彩绘陶俑\",\"imagePath\":\"/uploads/7a334f27bf404354b547edc28f274458.webp\",\"era\":\"汉朝\",\"material\":\"陶\",\"status\":\"借展中\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高35cm\",\"weight\":2.0,\"description\":\"\",\"introduction\":\"汉代彩绘陶俑，年代为汉朝，材质为陶，分类属于陶瓷器，尺寸为高35cm，重量约 2.00kg，当前状态为借展中，来源/出土地为陕西咸阳。系统中暂未录入更详细的文字介绍。\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":30,\"relicName\":\"明代青花盘\",\"imagePath\":\"/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp\",\"era\":\"明朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径35cm\",\"weight\":1.5,\"description\":\"明代青花瓷盘，纹饰精美，品相完好\",\"introduction\":\"明代青花盘，年代为明朝，材质为瓷，分类属于陶瓷器，尺寸为直径35cm，重量约 1.50kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：明代青花瓷盘，纹饰精美，品相完好\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":31,\"relicName\":\"明代青花碗\",\"imagePath\":\"/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp\",\"era\":\"明朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径15cm\",\"weight\":0.3,\"description\":\"明代青花碗，胎质细腻，青花发色纯正\",\"introduction\":\"明代青花碗，年代为明朝，材质为瓷，分类属于陶瓷器，尺寸为直径15cm，重量约 0.30kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：明代青花碗，胎质细腻，青花发色纯正\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":44,\"relicName\":\"清代粉彩瓶\",\"imagePath\":\"/uploads/c77e9d65149544b98c254da1592b9650.webp\",\"era\":\"清朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高45cm\",\"weight\":3.0,\"description\":\"清代粉彩瓷瓶，色彩艳丽，绘画精美\",\"introduction\":\"清代粉彩瓶，年代为清朝，材质为瓷，分类属于陶瓷器，尺寸为高45cm，重量约 3.00kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：清代粉彩瓷瓶，色彩艳丽，绘画精美\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":56,\"relicName\":\"汝窑天青釉盏\",\"imagePath\":\"/uploads/6bd0676aaba342a0a7da079eb82dec70.webp\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径12cm\",\"weight\":0.2,\"description\":\"宋代汝窑天青釉盏，釉色纯正，极为珍贵\",\"introduction\":\"汝窑天青釉盏，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为直径12cm，重量约 0.20kg，当前状态为在库，来源/出土地为河南汝州。相关介绍：宋代汝窑天青釉盏，釉色纯正，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":57,\"relicName\":\"三国青瓷罐\",\"imagePath\":\"/uploads/88da0fad01314386b5968c70ede17edb.webp\",\"era\":\"三国\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高30cm\",\"weight\":2.0,\"description\":\"三国时期青瓷罐，釉色青翠，保存完好\",\"introduction\":\"三国青瓷罐，年代为三国，材质为瓷，分类属于陶瓷器，尺寸为高30cm，重量约 2.00kg，当前状态为在库，来源/出土地为浙江越窑。相关介绍：三国时期青瓷罐，釉色青翠，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":63,\"relicName\":\"宋代白瓷瓶\",\"imagePath\":\"/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高30cm\",\"weight\":1.5,\"description\":\"宋代白瓷瓶，胎质细腻，釉色纯白\",\"introduction\":\"宋代白瓷瓶，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为高30cm，重量约 1.50kg，当前状态为在库，来源/出土地为河北定窑。相关介绍：宋代白瓷瓶，胎质细腻，釉色纯白\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":66,\"relicName\":\"宋代汝窑盘\",\"imagePath\":\"/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径20cm\",\"weight\":0.5,\"description\":\"宋代汝窑盘，釉色天青，极为珍贵\",\"introduction\":\"宋代汝窑盘，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为直径20cm，重量约 0.50kg，当前状态为在库，来源/出土地为河南汝州。相关介绍：宋代汝窑盘，釉色天青，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":84,\"relicName\":\"唐三彩马\",\"imagePath\":\"/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp\",\"era\":\"唐朝\",\"material\":\"陶\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高50cm\",\"weight\":5.0,\"description\":\"唐三彩马，造型生动，釉色艳丽\",\"introduction\":\"唐三彩马，年代为唐朝，材质为陶，分类属于陶瓷器，尺寸为高50cm，重量约 5.00kg，当前状态为在库，来源/出土地为河南洛阳。相关介绍：唐三彩马，造型生动，釉色艳丽\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":98,\"relicName\":\"元代青花瓷瓶\",\"imagePath\":\"/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp\",\"era\":\"元朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高40cm\",\"weight\":3.0,\"description\":\"元代青花瓷瓶，青花发色浓艳，极为珍贵\",\"introduction\":\"元代青花瓷瓶，年代为元朝，材质为瓷，分类属于陶瓷器，尺寸为高40cm，重量约 3.00kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：元代青花瓷瓶，青花发色浓艳，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":100,\"relicName\":\"元青花梅瓶\",\"imagePath\":\"/uploads/3284351accd947448894fb6607a88f7c.jpg\",\"era\":\"元朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高35cm\",\"weight\":2.5,\"description\":\"元青花梅瓶，造型优美，纹饰精美\",\"introduction\":\"元青花梅瓶，年代为元朝，材质为瓷，分类属于陶瓷器，尺寸为高35cm，重量约 2.50kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：元青花梅瓶，造型优美，纹饰精美\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"陶瓷类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":42}', NULL, 11, 0, '10,30,31,44,56,57,63,66,84,98,100', '2026-05-09 17:18:42');
INSERT INTO `ai_chat_message` VALUES (135, 43, 1, 'user', '有哪些陶瓷类文物？\n', '有哪些陶瓷类文物？\n', NULL, NULL, NULL, '2026-05-09 17:22:03');
INSERT INTO `ai_chat_message` VALUES (136, 43, 1, 'ai', '{\"answer\":\"根据文物列表，陶瓷类文物包括：汉代彩绘陶俑（ID 10）、明代青花盘（ID 30）、明代青花碗（ID 31）、清代粉彩瓶（ID 44）、汝窑天青釉盏（ID 56）、三国青瓷罐（ID 57）、宋代白瓷瓶（ID 63）、宋代汝窑盘（ID 66）、唐三彩马（ID 84）、元代青花瓷瓶（ID 98）和元青花梅瓶（ID 100）。这些文物涵盖陶器和瓷器，年代从汉代到清代，具有重要的历史与艺术价值。\",\"total\":11,\"topReason\":\"这些文物分类均为陶瓷器，符合用户查询的陶瓷类文物需求，涵盖多种年代和类型，代表性高。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 11 件相关文物\",\"relics\":[{\"id\":10,\"relicName\":\"汉代彩绘陶俑\",\"imagePath\":\"/uploads/7a334f27bf404354b547edc28f274458.webp\",\"era\":\"汉朝\",\"material\":\"陶\",\"status\":\"借展中\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高35cm\",\"weight\":2.0,\"description\":\"\",\"introduction\":\"汉代彩绘陶俑，年代为汉朝，材质为陶，分类属于陶瓷器，尺寸为高35cm，重量约 2.00kg，当前状态为借展中，来源/出土地为陕西咸阳。系统中暂未录入更详细的文字介绍。\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":30,\"relicName\":\"明代青花盘\",\"imagePath\":\"/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp\",\"era\":\"明朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径35cm\",\"weight\":1.5,\"description\":\"明代青花瓷盘，纹饰精美，品相完好\",\"introduction\":\"明代青花盘，年代为明朝，材质为瓷，分类属于陶瓷器，尺寸为直径35cm，重量约 1.50kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：明代青花瓷盘，纹饰精美，品相完好\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":31,\"relicName\":\"明代青花碗\",\"imagePath\":\"/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp\",\"era\":\"明朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径15cm\",\"weight\":0.3,\"description\":\"明代青花碗，胎质细腻，青花发色纯正\",\"introduction\":\"明代青花碗，年代为明朝，材质为瓷，分类属于陶瓷器，尺寸为直径15cm，重量约 0.30kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：明代青花碗，胎质细腻，青花发色纯正\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":44,\"relicName\":\"清代粉彩瓶\",\"imagePath\":\"/uploads/c77e9d65149544b98c254da1592b9650.webp\",\"era\":\"清朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高45cm\",\"weight\":3.0,\"description\":\"清代粉彩瓷瓶，色彩艳丽，绘画精美\",\"introduction\":\"清代粉彩瓶，年代为清朝，材质为瓷，分类属于陶瓷器，尺寸为高45cm，重量约 3.00kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：清代粉彩瓷瓶，色彩艳丽，绘画精美\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":56,\"relicName\":\"汝窑天青釉盏\",\"imagePath\":\"/uploads/6bd0676aaba342a0a7da079eb82dec70.webp\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径12cm\",\"weight\":0.2,\"description\":\"宋代汝窑天青釉盏，釉色纯正，极为珍贵\",\"introduction\":\"汝窑天青釉盏，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为直径12cm，重量约 0.20kg，当前状态为在库，来源/出土地为河南汝州。相关介绍：宋代汝窑天青釉盏，釉色纯正，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":57,\"relicName\":\"三国青瓷罐\",\"imagePath\":\"/uploads/88da0fad01314386b5968c70ede17edb.webp\",\"era\":\"三国\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高30cm\",\"weight\":2.0,\"description\":\"三国时期青瓷罐，釉色青翠，保存完好\",\"introduction\":\"三国青瓷罐，年代为三国，材质为瓷，分类属于陶瓷器，尺寸为高30cm，重量约 2.00kg，当前状态为在库，来源/出土地为浙江越窑。相关介绍：三国时期青瓷罐，釉色青翠，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":63,\"relicName\":\"宋代白瓷瓶\",\"imagePath\":\"/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高30cm\",\"weight\":1.5,\"description\":\"宋代白瓷瓶，胎质细腻，釉色纯白\",\"introduction\":\"宋代白瓷瓶，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为高30cm，重量约 1.50kg，当前状态为在库，来源/出土地为河北定窑。相关介绍：宋代白瓷瓶，胎质细腻，釉色纯白\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":66,\"relicName\":\"宋代汝窑盘\",\"imagePath\":\"/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp\",\"era\":\"宋朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"直径20cm\",\"weight\":0.5,\"description\":\"宋代汝窑盘，釉色天青，极为珍贵\",\"introduction\":\"宋代汝窑盘，年代为宋朝，材质为瓷，分类属于陶瓷器，尺寸为直径20cm，重量约 0.50kg，当前状态为在库，来源/出土地为河南汝州。相关介绍：宋代汝窑盘，釉色天青，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":84,\"relicName\":\"唐三彩马\",\"imagePath\":\"/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp\",\"era\":\"唐朝\",\"material\":\"陶\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高50cm\",\"weight\":5.0,\"description\":\"唐三彩马，造型生动，釉色艳丽\",\"introduction\":\"唐三彩马，年代为唐朝，材质为陶，分类属于陶瓷器，尺寸为高50cm，重量约 5.00kg，当前状态为在库，来源/出土地为河南洛阳。相关介绍：唐三彩马，造型生动，釉色艳丽\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":98,\"relicName\":\"元代青花瓷瓶\",\"imagePath\":\"/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp\",\"era\":\"元朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高40cm\",\"weight\":3.0,\"description\":\"元代青花瓷瓶，青花发色浓艳，极为珍贵\",\"introduction\":\"元代青花瓷瓶，年代为元朝，材质为瓷，分类属于陶瓷器，尺寸为高40cm，重量约 3.00kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：元代青花瓷瓶，青花发色浓艳，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":100,\"relicName\":\"元青花梅瓶\",\"imagePath\":\"/uploads/3284351accd947448894fb6607a88f7c.jpg\",\"era\":\"元朝\",\"material\":\"瓷\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高35cm\",\"weight\":2.5,\"description\":\"元青花梅瓶，造型优美，纹饰精美\",\"introduction\":\"元青花梅瓶，年代为元朝，材质为瓷，分类属于陶瓷器，尺寸为高35cm，重量约 2.50kg，当前状态为在库，来源/出土地为江西景德镇。相关介绍：元青花梅瓶，造型优美，纹饰精美\",\"relevancePercent\":95,\"matchTags\":[\"陶瓷\",\"文物\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":43}', NULL, 11, 0, '10,30,31,44,56,57,63,66,84,98,100', '2026-05-09 17:22:03');
INSERT INTO `ai_chat_message` VALUES (137, 44, 1, 'user', '讲解唐朝文物的特点\n', '讲解唐朝文物的特点\n', NULL, NULL, NULL, '2026-05-09 17:23:34');
INSERT INTO `ai_chat_message` VALUES (138, 44, 1, 'ai', '{\"answer\":\"唐代文物以造型饱满、色彩绚丽、工艺精湛著称。例如唐三彩马釉色艳丽，展现了唐代陶瓷的辉煌；唐代金银器如金杯、鎏金银壶造型优美，体现了高超的金属工艺；唐代玉器如龙凤玉佩雕工精细，寓意吉祥；唐代佛像如铜观音神态慈祥，反映了唐代佛教艺术的成熟；唐代书画如王羲之兰亭序摹本，更是书法艺术的巅峰。\",\"total\":5,\"topReason\":\"唐三彩马代表唐代陶瓷特色，金杯和鎏金银壶体现金银器工艺，龙凤玉佩展示玉器雕工，兰亭序摹本突出书法艺术，这些文物全面反映唐代文物特点。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 5 件相关文物\",\"relics\":[{\"id\":84,\"relicName\":\"唐三彩马\",\"imagePath\":\"/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp\",\"era\":\"唐朝\",\"material\":\"陶\",\"status\":\"在库\",\"categoryName\":\"陶瓷器\",\"dimensions\":\"高50cm\",\"weight\":5.0,\"description\":\"唐三彩马，造型生动，釉色艳丽\",\"introduction\":\"唐三彩马，年代为唐朝，材质为陶，分类属于陶瓷器，尺寸为高50cm，重量约 5.00kg，当前状态为在库，来源/出土地为河南洛阳。相关介绍：唐三彩马，造型生动，釉色艳丽\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\",\"文物\",\"特点\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":75,\"relicName\":\"唐代金杯\",\"imagePath\":\"/uploads/645b9ef90d134ef0b0139a4fa7918046.webp\",\"era\":\"唐朝\",\"material\":\"金\",\"status\":\"在库\",\"categoryName\":\"金银器\",\"dimensions\":\"高10cm\",\"weight\":0.2,\"description\":\"唐代金杯，工艺精湛，保存完好\",\"introduction\":\"唐代金杯，年代为唐朝，材质为金，分类属于金银器，尺寸为高10cm，重量约 0.20kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代金杯，工艺精湛，保存完好\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\",\"文物\",\"特点\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":22,\"relicName\":\"鎏金银壶\",\"imagePath\":\"/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp\",\"era\":\"唐朝\",\"material\":\"鎏金银\",\"status\":\"在库\",\"categoryName\":\"金银器\",\"dimensions\":\"高25cm\",\"weight\":1.2,\"description\":\"唐代鎏金银壶，造型优美，工艺精湛\",\"introduction\":\"鎏金银壶，年代为唐朝，材质为鎏金银，分类属于金银器，尺寸为高25cm，重量约 1.20kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代鎏金银壶，造型优美，工艺精湛\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\",\"文物\",\"特点\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":76,\"relicName\":\"唐代龙凤玉佩\",\"imagePath\":\"/uploads/63d15e510c7d4e3db421a419b350fe24.webp\",\"era\":\"唐朝\",\"material\":\"玉\",\"status\":\"在库\",\"categoryName\":\"玉器\",\"dimensions\":\"长10cm\",\"weight\":0.15,\"description\":\"唐代龙凤纹玉佩，雕工精细，寓意吉祥\",\"introduction\":\"唐代龙凤玉佩，年代为唐朝，材质为玉，分类属于玉器，尺寸为长10cm，重量约 0.15kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：唐代龙凤纹玉佩，雕工精细，寓意吉祥\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\",\"文物\",\"特点\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":85,\"relicName\":\"王羲之兰亭序摹本\",\"imagePath\":\"/uploads/ab83d1743bd541d79414fe67c8a5e524.webp\",\"era\":\"唐朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"28x320cm\",\"weight\":0.5,\"description\":\"王羲之兰亭序唐代摹本，书法精妙，极为珍贵\",\"introduction\":\"王羲之兰亭序摹本，年代为唐朝，材质为纸本，分类属于书画，尺寸为28x320cm，重量约 0.50kg，当前状态为在库，来源/出土地为陕西西安。相关介绍：王羲之兰亭序唐代摹本，书法精妙，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"唐朝\",\"文物\",\"特点\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":44}', NULL, 5, 0, '84,75,22,76,85', '2026-05-09 17:23:34');
INSERT INTO `ai_chat_message` VALUES (139, 45, 1, 'user', '简要介绍一下\n清代郑板桥竹石图', '简要介绍一下\n清代郑板桥竹石图', NULL, NULL, NULL, '2026-05-09 17:37:17');
INSERT INTO `ai_chat_message` VALUES (140, 45, 1, 'ai', '{\"answer\":\"清代郑板桥竹石图是郑板桥的代表作之一，以竹、石为主题，笔墨苍劲有力，构图巧妙，展现了郑板桥独特的艺术风格和高超的绘画技艺。该作品为纸本水墨，属于书画类文物，具有极高的艺术价值和历史价值，是研究清代书画艺术的重要实物资料。\",\"total\":1,\"topReason\":\"用户明确询问“清代郑板桥竹石图”，文物列表中ID为52的文物名称与之完全匹配，且描述相符，因此推荐此件。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 1 件相关文物\",\"relics\":[{\"id\":52,\"relicName\":\"清代郑板桥竹石图\",\"imagePath\":\"/uploads/fffcad1c276141588537230a45f1aee8.webp\",\"era\":\"清朝\",\"material\":\"纸本\",\"status\":\"在库\",\"categoryName\":\"书画\",\"dimensions\":\"130x60cm\",\"weight\":0.5,\"description\":\"清代郑板桥竹石图，笔墨苍劲，极为珍贵\",\"introduction\":\"清代郑板桥竹石图，年代为清朝，材质为纸本，分类属于书画，尺寸为130x60cm，重量约 0.50kg，当前状态为在库，来源/出土地为江苏扬州。相关介绍：清代郑板桥竹石图，笔墨苍劲，极为珍贵\",\"relevancePercent\":95,\"matchTags\":[\"清代\",\"郑板桥\",\"竹石图\",\"书画\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":45}', NULL, 1, 0, '52', '2026-05-09 17:37:17');
INSERT INTO `ai_chat_message` VALUES (141, 46, 1, 'user', '统计一下所有的文物的分类\n', '统计一下所有的文物的分类\n', NULL, NULL, NULL, '2026-05-09 17:54:41');
INSERT INTO `ai_chat_message` VALUES (142, 46, 1, 'ai', '{\"answer\":\"根据博物馆文物列表，文物分类包括：佛像、碑帖、青铜器、陶瓷器、杂项、服饰、玉器、钱币、金银器、书画。共有104件文物，涵盖多个历史时期和材质。\",\"total\":5,\"topReason\":\"这些文物分别代表不同分类（佛像、碑帖、青铜器），且具有代表性，可帮助用户直观理解分类多样性。\",\"museumHit\":true,\"museumMessage\":\"AI为您找到了 5 件相关文物\",\"relics\":[{\"id\":2,\"relicName\":\"北魏石佛头像\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"era\":\"南北朝\",\"material\":\"石\",\"status\":\"借展中\",\"categoryName\":\"佛像\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"introduction\":\"北魏石佛头像，年代为南北朝，材质为石，分类属于佛像，尺寸为高25cm，重量约 8.00kg，当前状态为借展中，来源/出土地为山西大同。相关介绍：北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"relevancePercent\":95,\"matchTags\":[\"统计\",\"分类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":3,\"relicName\":\"北魏石佛像\",\"imagePath\":\"/uploads/7d1c8d9746954228ad84bb360a48e958.webp\",\"era\":\"南北朝\",\"material\":\"石\",\"status\":\"修复中\",\"categoryName\":\"佛像\",\"dimensions\":\"高80cm\",\"weight\":50.0,\"description\":\"北魏时期完整石佛造像，艺术价值极高\",\"introduction\":\"北魏石佛像，年代为南北朝，材质为石，分类属于佛像，尺寸为高80cm，重量约 50.00kg，当前状态为修复中，来源/出土地为河南洛阳。相关介绍：北魏时期完整石佛造像，艺术价值极高\",\"relevancePercent\":95,\"matchTags\":[\"统计\",\"分类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":4,\"relicName\":\"北魏造像碑\",\"imagePath\":\"/uploads/3a61faebc0ef44638ca78150f3bc978d.webp\",\"era\":\"南北朝\",\"material\":\"石\",\"status\":\"借展中\",\"categoryName\":\"碑帖\",\"dimensions\":\"高120cm\",\"weight\":150.0,\"description\":\"北魏造像碑，碑文清晰，造像精美\",\"introduction\":\"北魏造像碑，年代为南北朝，材质为石，分类属于碑帖，尺寸为高120cm，重量约 150.00kg，当前状态为借展中，来源/出土地为河北邯郸。相关介绍：北魏造像碑，碑文清晰，造像精美\",\"relevancePercent\":95,\"matchTags\":[\"统计\",\"分类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":5,\"relicName\":\"曾侯乙编钟\",\"imagePath\":\"/uploads/32877c4cd94f4c7f98de18818a8c5104.webp\",\"era\":\"战国\",\"material\":\"青铜\",\"status\":\"修复中\",\"categoryName\":\"青铜器\",\"dimensions\":\"高265cm\",\"weight\":2500.0,\"description\":\"战国时期曾侯乙墓出土编钟，音律完整，国宝级文物\",\"introduction\":\"曾侯乙编钟，年代为战国，材质为青铜，分类属于青铜器，尺寸为高265cm，重量约 2500.00kg，当前状态为修复中，来源/出土地为湖北随州。相关介绍：战国时期曾侯乙墓出土编钟，音律完整，国宝级文物\",\"relevancePercent\":95,\"matchTags\":[\"统计\",\"分类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null},{\"id\":6,\"relicName\":\"春秋青铜编钟\",\"imagePath\":\"/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg\",\"era\":\"春秋\",\"material\":\"青铜\",\"status\":\"在库\",\"categoryName\":\"青铜器\",\"dimensions\":\"高45cm\",\"weight\":15.0,\"description\":\"春秋时期青铜编钟，铸造精良\",\"introduction\":\"春秋青铜编钟，年代为春秋，材质为青铜，分类属于青铜器，尺寸为高45cm，重量约 15.00kg，当前状态为在库，来源/出土地为河南新郑。相关介绍：春秋时期青铜编钟，铸造精良\",\"relevancePercent\":95,\"matchTags\":[\"统计\",\"分类\"],\"external\":null,\"sourceName\":null,\"sourceType\":null,\"sourceUrl\":null}],\"webResults\":[],\"sessionId\":46}', NULL, 5, 0, '2,3,4,5,6', '2026-05-09 17:54:41');

-- ----------------------------
-- Table structure for ai_chat_session
-- ----------------------------
DROP TABLE IF EXISTS `ai_chat_session`;
CREATE TABLE `ai_chat_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '新对话' COMMENT '会话标题',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 47 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI对话会话表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_chat_session
-- ----------------------------
INSERT INTO `ai_chat_session` VALUES (1, 1, '查询青铜器相关信息', '2024-03-01 10:00:00', '2024-03-01 10:15:00');
INSERT INTO `ai_chat_session` VALUES (2, 2, '了解唐代文物', '2024-03-05 11:00:00', '2024-03-05 11:20:00');
INSERT INTO `ai_chat_session` VALUES (3, 3, '瓷器鉴定咨询', '2024-03-10 14:00:00', '2024-03-10 14:25:00');
INSERT INTO `ai_chat_session` VALUES (4, 4, '书画作品研究', '2024-03-15 09:00:00', '2024-03-15 09:30:00');
INSERT INTO `ai_chat_session` VALUES (5, 5, '玉器文化探讨', '2024-03-20 10:00:00', '2024-03-20 10:40:00');
INSERT INTO `ai_chat_session` VALUES (6, 1, '金银器工艺咨询', '2024-04-01 11:00:00', '2024-04-01 11:18:00');
INSERT INTO `ai_chat_session` VALUES (7, 2, '碑刻文字解读', '2024-04-10 15:00:00', '2024-04-10 15:35:00');
INSERT INTO `ai_chat_session` VALUES (8, 3, '古代钱币鉴别', '2024-04-20 13:00:00', '2024-04-20 13:22:00');
INSERT INTO `ai_chat_session` VALUES (11, 13, 'AI查询：司母戊鼎', '2026-04-22 11:18:32', '2026-04-22 11:18:32');
INSERT INTO `ai_chat_session` VALUES (12, 16, 'AI查询：司母戊鼎', '2026-04-23 15:36:34', '2026-04-23 15:36:34');
INSERT INTO `ai_chat_session` VALUES (13, 16, 'AI查询：兵马俑', '2026-04-23 15:45:30', '2026-04-23 15:45:30');
INSERT INTO `ai_chat_session` VALUES (14, 16, 'AI查询：兵马俑', '2026-04-23 15:46:48', '2026-04-23 15:46:48');
INSERT INTO `ai_chat_session` VALUES (15, 16, 'AI查询：介绍一下司母戊鼎\n', '2026-04-24 12:13:04', '2026-04-24 12:13:04');
INSERT INTO `ai_chat_session` VALUES (16, 1, 'AI查询：介绍一下司母戊鼎', '2026-04-24 12:13:59', '2026-04-24 12:13:59');
INSERT INTO `ai_chat_session` VALUES (19, 1, 'AI查询：唐代金银器工艺如何？', '2026-04-24 13:35:09', '2026-04-24 13:35:09');
INSERT INTO `ai_chat_session` VALUES (20, 16, 'AI查询：唐代金银器工艺如何？\n', '2026-04-24 13:35:44', '2026-04-24 13:35:44');
INSERT INTO `ai_chat_session` VALUES (21, 16, 'AI查询：汉代碑刻有什么特点？\n', '2026-04-24 13:37:07', '2026-04-24 13:37:07');
INSERT INTO `ai_chat_session` VALUES (22, 16, 'AI查询：汉代碑刻有什么特点？', '2026-04-24 13:43:03', '2026-04-24 13:43:03');
INSERT INTO `ai_chat_session` VALUES (23, 16, 'AI查询：玉器要如何保养\n', '2026-04-24 13:46:46', '2026-04-24 13:46:46');
INSERT INTO `ai_chat_session` VALUES (24, 16, 'AI查询：介绍一下司母戊鼎\n', '2026-04-24 13:55:31', '2026-04-24 13:55:31');
INSERT INTO `ai_chat_session` VALUES (25, 16, 'AI查询：司母戊鼎', '2026-04-24 14:01:00', '2026-04-24 14:01:00');
INSERT INTO `ai_chat_session` VALUES (26, 16, 'AI查询：介绍一下司母戊鼎', '2026-04-24 14:01:55', '2026-04-24 14:01:55');
INSERT INTO `ai_chat_session` VALUES (27, 17, 'AI查询：介绍一下清明上河图\n', '2026-04-24 14:10:25', '2026-04-24 14:10:25');
INSERT INTO `ai_chat_session` VALUES (28, 17, 'AI查询：清明上河图', '2026-04-24 14:14:56', '2026-04-24 14:14:56');
INSERT INTO `ai_chat_session` VALUES (29, 17, 'AI查询：司母戊鼎', '2026-04-24 14:30:20', '2026-04-24 14:30:20');
INSERT INTO `ai_chat_session` VALUES (30, 1, 'AI查询：讲解', '2026-04-24 19:45:29', '2026-04-24 19:45:29');
INSERT INTO `ai_chat_session` VALUES (31, 1, 'AI查询：五铢钱', '2026-04-24 19:45:56', '2026-04-24 19:45:56');
INSERT INTO `ai_chat_session` VALUES (32, 1, 'AI查询：汉朝', '2026-04-24 19:46:12', '2026-04-24 19:46:12');
INSERT INTO `ai_chat_session` VALUES (33, 1, 'AI查询：司母戊鼎', '2026-04-27 10:39:49', '2026-04-27 10:39:49');
INSERT INTO `ai_chat_session` VALUES (34, 16, 'AI查询：司母戊鼎', '2026-04-27 10:41:10', '2026-04-27 10:41:10');
INSERT INTO `ai_chat_session` VALUES (35, 16, 'AI查询：司母戊鼎', '2026-04-27 17:25:19', '2026-04-27 17:25:19');
INSERT INTO `ai_chat_session` VALUES (36, 16, 'AI查询：司母戊鼎', '2026-04-30 10:10:01', '2026-04-30 10:10:01');
INSERT INTO `ai_chat_session` VALUES (37, 1, 'AI查询：有哪些唐朝的文物\n', '2026-05-09 16:43:48', '2026-05-09 16:43:48');
INSERT INTO `ai_chat_session` VALUES (38, 1, 'AI查询：有哪些唐朝的文物\n', '2026-05-09 16:45:58', '2026-05-09 16:45:58');
INSERT INTO `ai_chat_session` VALUES (39, 1, 'AI查询：司母戊鼎\n', '2026-05-09 16:47:05', '2026-05-09 16:47:05');
INSERT INTO `ai_chat_session` VALUES (40, 1, 'AI查询：有哪些文物不能在潮湿环境下保存\n', '2026-05-09 16:54:00', '2026-05-09 16:54:00');
INSERT INTO `ai_chat_session` VALUES (41, 1, 'AI查询：有哪些唐朝的文物？\n', '2026-05-09 17:09:15', '2026-05-09 17:09:15');
INSERT INTO `ai_chat_session` VALUES (42, 1, 'AI查询：有哪些陶瓷类文物？\n', '2026-05-09 17:18:42', '2026-05-09 17:18:42');
INSERT INTO `ai_chat_session` VALUES (43, 1, 'AI查询：有哪些陶瓷类文物？\n', '2026-05-09 17:22:03', '2026-05-09 17:22:03');
INSERT INTO `ai_chat_session` VALUES (44, 1, 'AI查询：讲解唐朝文物的特点\n', '2026-05-09 17:23:34', '2026-05-09 17:23:34');
INSERT INTO `ai_chat_session` VALUES (45, 1, 'AI查询：简要介绍一下\n清代郑板桥竹石图', '2026-05-09 17:37:17', '2026-05-09 17:37:17');
INSERT INTO `ai_chat_session` VALUES (46, 1, 'AI查询：统计一下所有的文物的分类\n', '2026-05-09 17:54:41', '2026-05-09 17:54:41');

-- ----------------------------
-- Table structure for ai_query_result
-- ----------------------------
DROP TABLE IF EXISTS `ai_query_result`;
CREATE TABLE `ai_query_result`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `message_id` bigint NOT NULL COMMENT '消息ID',
  `relic_id` bigint NULL DEFAULT NULL COMMENT '文物ID（馆藏文物）',
  `relic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '文物名称',
  `relevance_percent` int NULL DEFAULT 0 COMMENT '相关度百分比',
  `is_external` tinyint NULL DEFAULT 0 COMMENT '是否外部资料：0-馆藏，1-外部',
  `source_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源名称',
  `source_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源类型：百科、博物馆官网等',
  `source_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '来源链接',
  `match_tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '匹配标签（JSON数组）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_message_id`(`message_id`) USING BTREE,
  INDEX `idx_relic_id`(`relic_id`) USING BTREE,
  INDEX `idx_is_external`(`is_external`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 175 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'AI查询结果详情表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_query_result
-- ----------------------------
INSERT INTO `ai_query_result` VALUES (1, 34, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-22 11:18:32');
INSERT INTO `ai_query_result` VALUES (2, 36, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-23 15:36:34');
INSERT INTO `ai_query_result` VALUES (3, 38, NULL, '兵马俑', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%85%B5%E9%A9%AC%E4%BF%91', '[]', '2026-04-23 15:45:30');
INSERT INTO `ai_query_result` VALUES (4, 40, NULL, '兵马俑', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%85%B5%E9%A9%AC%E4%BF%91', '[]', '2026-04-23 15:46:48');
INSERT INTO `ai_query_result` VALUES (5, 42, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-24 12:13:04');
INSERT INTO `ai_query_result` VALUES (6, 44, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-24 12:13:59');
INSERT INTO `ai_query_result` VALUES (9, 50, 3, '北魏石佛像', 7, 0, NULL, NULL, NULL, '[\"描述命中：艺\"]', '2026-04-24 13:35:09');
INSERT INTO `ai_query_result` VALUES (10, 50, 18, '和田白玉佩', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:09');
INSERT INTO `ai_query_result` VALUES (11, 50, 37, '明代玉如意', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:09');
INSERT INTO `ai_query_result` VALUES (12, 50, 41, '清代白玉如意', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:09');
INSERT INTO `ai_query_result` VALUES (13, 50, 102, '战国龙纹玉璧', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:09');
INSERT INTO `ai_query_result` VALUES (14, 52, 3, '北魏石佛像', 7, 0, NULL, NULL, NULL, '[\"描述命中：艺\"]', '2026-04-24 13:35:44');
INSERT INTO `ai_query_result` VALUES (15, 52, 18, '和田白玉佩', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:44');
INSERT INTO `ai_query_result` VALUES (16, 52, 37, '明代玉如意', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:44');
INSERT INTO `ai_query_result` VALUES (17, 52, 41, '清代白玉如意', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:44');
INSERT INTO `ai_query_result` VALUES (18, 52, 102, '战国龙纹玉璧', 7, 0, NULL, NULL, NULL, '[\"描述命中：工\"]', '2026-04-24 13:35:44');
INSERT INTO `ai_query_result` VALUES (19, 54, 3, '北魏石佛像', 27, 0, NULL, NULL, NULL, '[\"状态命中：修\",\"状态命中：复\"]', '2026-04-24 13:36:09');
INSERT INTO `ai_query_result` VALUES (20, 54, 68, '宋代银壶', 27, 0, NULL, NULL, NULL, '[\"状态命中：修\",\"状态命中：复\"]', '2026-04-24 13:36:09');
INSERT INTO `ai_query_result` VALUES (21, 54, 6, '春秋青铜编钟', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜制品\",\"材质命中：青铜制品\",\"分类命中：青铜制品\",\"描述命中：青铜制品\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 13:36:09');
INSERT INTO `ai_query_result` VALUES (22, 54, 8, '东汉铜灯', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜制品\",\"材质命中：青铜制品\",\"分类命中：青铜制品\",\"描述命中：青铜制品\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 13:36:09');
INSERT INTO `ai_query_result` VALUES (23, 54, 12, '汉代青铜镜', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜制品\",\"材质命中：青铜制品\",\"分类命中：青铜制品\",\"描述命中：青铜制品\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 13:36:09');
INSERT INTO `ai_query_result` VALUES (24, 56, 73, '隋朝石刻佛首', 29, 0, NULL, NULL, NULL, '[\"名称命中：刻\",\"描述命中：刻\"]', '2026-04-24 13:37:07');
INSERT INTO `ai_query_result` VALUES (25, 56, 2, '北魏石佛头像', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:37:07');
INSERT INTO `ai_query_result` VALUES (26, 56, 29, '明代木雕佛龛', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:37:07');
INSERT INTO `ai_query_result` VALUES (27, 56, 33, '明代剔红盒', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:37:07');
INSERT INTO `ai_query_result` VALUES (28, 56, 46, '清代红木柜', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:37:07');
INSERT INTO `ai_query_result` VALUES (29, 58, 73, '隋朝石刻佛首', 29, 0, NULL, NULL, NULL, '[\"名称命中：刻\",\"描述命中：刻\"]', '2026-04-24 13:37:35');
INSERT INTO `ai_query_result` VALUES (30, 58, 1, '北宋铜钱串', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:37:35');
INSERT INTO `ai_query_result` VALUES (31, 58, 2, '北魏石佛头像', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:37:35');
INSERT INTO `ai_query_result` VALUES (32, 58, 19, '金代鎏金杯', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:37:35');
INSERT INTO `ai_query_result` VALUES (33, 58, 24, '民国旗袍', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:37:35');
INSERT INTO `ai_query_result` VALUES (34, 60, 73, '隋朝石刻佛首', 29, 0, NULL, NULL, NULL, '[\"名称命中：刻\",\"描述命中：刻\"]', '2026-04-24 13:38:07');
INSERT INTO `ai_query_result` VALUES (35, 60, 1, '北宋铜钱串', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:38:07');
INSERT INTO `ai_query_result` VALUES (36, 60, 2, '北魏石佛头像', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:38:07');
INSERT INTO `ai_query_result` VALUES (37, 60, 19, '金代鎏金杯', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:38:07');
INSERT INTO `ai_query_result` VALUES (38, 60, 24, '民国旗袍', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:38:07');
INSERT INTO `ai_query_result` VALUES (39, 64, 73, '隋朝石刻佛首', 29, 0, NULL, NULL, NULL, '[\"名称命中：刻\",\"描述命中：刻\"]', '2026-04-24 13:43:12');
INSERT INTO `ai_query_result` VALUES (40, 64, 1, '北宋铜钱串', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:43:12');
INSERT INTO `ai_query_result` VALUES (41, 64, 2, '北魏石佛头像', 7, 0, NULL, NULL, NULL, '[\"描述命中：刻\"]', '2026-04-24 13:43:12');
INSERT INTO `ai_query_result` VALUES (42, 64, 19, '金代鎏金杯', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:43:12');
INSERT INTO `ai_query_result` VALUES (43, 64, 24, '民国旗袍', 7, 0, NULL, NULL, NULL, '[\"描述命中：保\"]', '2026-04-24 13:43:12');
INSERT INTO `ai_query_result` VALUES (44, 72, 82, '唐代玉带饰', 29, 0, NULL, NULL, NULL, '[\"名称命中：饰\",\"描述命中：饰\"]', '2026-04-24 13:47:48');
INSERT INTO `ai_query_result` VALUES (45, 72, 96, '元代金饰片', 29, 0, NULL, NULL, NULL, '[\"名称命中：饰\",\"描述命中：饰\"]', '2026-04-24 13:47:48');
INSERT INTO `ai_query_result` VALUES (46, 72, 11, '汉代漆盘', 7, 0, NULL, NULL, NULL, '[\"描述命中：饰\"]', '2026-04-24 13:47:48');
INSERT INTO `ai_query_result` VALUES (47, 72, 12, '汉代青铜镜', 7, 0, NULL, NULL, NULL, '[\"描述命中：饰\"]', '2026-04-24 13:47:48');
INSERT INTO `ai_query_result` VALUES (48, 72, 21, '辽代玉鸟佩', 7, 0, NULL, NULL, NULL, '[\"描述命中：饰\"]', '2026-04-24 13:47:48');
INSERT INTO `ai_query_result` VALUES (49, 78, 59, '商代青铜鼎', 29, 0, NULL, NULL, NULL, '[\"名称命中：鼎\",\"描述命中：鼎\"]', '2026-04-24 13:57:48');
INSERT INTO `ai_query_result` VALUES (50, 78, 7, '大禹鼎', 22, 0, NULL, NULL, NULL, '[\"名称命中：鼎\"]', '2026-04-24 13:57:48');
INSERT INTO `ai_query_result` VALUES (51, 80, 59, '商代青铜鼎', 29, 0, NULL, NULL, NULL, '[\"名称命中：鼎\",\"描述命中：鼎\"]', '2026-04-24 14:01:00');
INSERT INTO `ai_query_result` VALUES (52, 80, 7, '大禹鼎', 22, 0, NULL, NULL, NULL, '[\"名称命中：鼎\"]', '2026-04-24 14:01:00');
INSERT INTO `ai_query_result` VALUES (53, 82, 59, '商代青铜鼎', 29, 0, NULL, NULL, NULL, '[\"名称命中：鼎\",\"描述命中：鼎\"]', '2026-04-24 14:01:12');
INSERT INTO `ai_query_result` VALUES (54, 82, 7, '大禹鼎', 22, 0, NULL, NULL, NULL, '[\"名称命中：鼎\"]', '2026-04-24 14:01:12');
INSERT INTO `ai_query_result` VALUES (55, 84, 59, '商代青铜鼎', 29, 0, NULL, NULL, NULL, '[\"名称命中：鼎\",\"描述命中：鼎\"]', '2026-04-24 14:01:55');
INSERT INTO `ai_query_result` VALUES (56, 84, 7, '大禹鼎', 22, 0, NULL, NULL, NULL, '[\"名称命中：鼎\"]', '2026-04-24 14:01:55');
INSERT INTO `ai_query_result` VALUES (57, 90, 25, '明代补子', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:14:56');
INSERT INTO `ai_query_result` VALUES (58, 90, 26, '明代黄花梨椅', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:14:56');
INSERT INTO `ai_query_result` VALUES (59, 90, 27, '明代金簪', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:14:56');
INSERT INTO `ai_query_result` VALUES (60, 90, 28, '明代龙袍', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:14:56');
INSERT INTO `ai_query_result` VALUES (61, 90, 29, '明代木雕佛龛', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:14:56');
INSERT INTO `ai_query_result` VALUES (62, 92, 25, '明代补子', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:15:25');
INSERT INTO `ai_query_result` VALUES (63, 92, 26, '明代黄花梨椅', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:15:25');
INSERT INTO `ai_query_result` VALUES (64, 92, 27, '明代金簪', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:15:25');
INSERT INTO `ai_query_result` VALUES (65, 92, 28, '明代龙袍', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:15:25');
INSERT INTO `ai_query_result` VALUES (66, 92, 29, '明代木雕佛龛', 100, 0, NULL, NULL, NULL, '[\"名称命中：明朝\",\"年代命中：明朝\",\"描述命中：明朝\",\"名称命中：明代\",\"年代命中：明代\",\"描述命中：明代\",\"名称命中：明\",\"年代命中：明\",\"描述命中：明\"]', '2026-04-24 14:15:25');
INSERT INTO `ai_query_result` VALUES (67, 94, 61, '商代玉戈', 100, 0, NULL, NULL, NULL, '[\"名称命中：商\",\"年代命中：商\",\"描述命中：商\",\"名称命中：商代\",\"年代命中：商代\",\"描述命中：商代\",\"名称命中：商朝\",\"年代命中：商朝\",\"描述命中：商朝\"]', '2026-04-24 14:15:40');
INSERT INTO `ai_query_result` VALUES (68, 94, 6, '春秋青铜编钟', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 14:15:40');
INSERT INTO `ai_query_result` VALUES (69, 94, 8, '东汉铜灯', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 14:15:40');
INSERT INTO `ai_query_result` VALUES (70, 94, 12, '汉代青铜镜', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 14:15:40');
INSERT INTO `ai_query_result` VALUES (71, 94, 40, '秦朝铜诏版', 100, 0, NULL, NULL, NULL, '[\"名称命中：青铜器\",\"材质命中：青铜器\",\"分类命中：青铜器\",\"描述命中：青铜器\",\"名称命中：青铜\",\"材质命中：青铜\",\"分类命中：青铜\",\"描述命中：青铜\",\"名称命中：铜制\",\"材质命中：铜制\",\"分类命中：铜制\",\"描述命中：铜制\",\"名称命中：铜\",\"材质命中：铜\",\"分类命中：铜\",\"描述命中：铜\",\"名称命中：铜器\",\"材质命中：铜器\",\"分类命中：铜器\",\"描述命中：铜器\",\"名称命中：铜质\",\"材质命中：铜质\",\"分类命中：铜质\",\"描述命中：铜质\"]', '2026-04-24 14:15:40');
INSERT INTO `ai_query_result` VALUES (72, 96, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-24 14:30:20');
INSERT INTO `ai_query_result` VALUES (73, 98, NULL, '讲解', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E8%AE%B2%E8%A7%A3', '[]', '2026-04-24 19:45:29');
INSERT INTO `ai_query_result` VALUES (74, 100, 16, '汉五铢钱', 90, 0, NULL, NULL, NULL, '[\"名称整句命中\",\"描述/来源整句命中\",\"名称命中：五铢钱\",\"描述命中：五铢钱\"]', '2026-04-24 19:45:56');
INSERT INTO `ai_query_result` VALUES (75, 100, 17, '汉五铢钱范', 67, 0, NULL, NULL, NULL, '[\"名称整句命中\",\"名称命中：五铢钱\"]', '2026-04-24 19:45:56');
INSERT INTO `ai_query_result` VALUES (76, 102, 8, '东汉铜灯', 13, 0, NULL, NULL, NULL, '[\"年代命中：汉朝\"]', '2026-04-24 19:46:12');
INSERT INTO `ai_query_result` VALUES (77, 102, 9, '汉碑残拓', 13, 0, NULL, NULL, NULL, '[\"年代命中：汉朝\"]', '2026-04-24 19:46:12');
INSERT INTO `ai_query_result` VALUES (78, 102, 10, '汉代彩绘陶俑', 13, 0, NULL, NULL, NULL, '[\"年代命中：汉朝\"]', '2026-04-24 19:46:12');
INSERT INTO `ai_query_result` VALUES (79, 102, 11, '汉代漆盘', 13, 0, NULL, NULL, NULL, '[\"年代命中：汉朝\"]', '2026-04-24 19:46:12');
INSERT INTO `ai_query_result` VALUES (80, 102, 12, '汉代青铜镜', 13, 0, NULL, NULL, NULL, '[\"年代命中：汉朝\"]', '2026-04-24 19:46:12');
INSERT INTO `ai_query_result` VALUES (81, 104, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-27 10:39:49');
INSERT INTO `ai_query_result` VALUES (82, 106, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-27 10:41:10');
INSERT INTO `ai_query_result` VALUES (83, 108, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-27 17:25:19');
INSERT INTO `ai_query_result` VALUES (84, 110, 270, '兵马俑', 67, 0, NULL, NULL, NULL, '[\"名称整句命中\",\"名称命中：兵马俑\"]', '2026-04-27 17:25:24');
INSERT INTO `ai_query_result` VALUES (85, 112, NULL, '后母戊鼎', 0, 1, '百度百科', '百科', 'https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E', '[]', '2026-04-30 10:10:01');
INSERT INTO `ai_query_result` VALUES (86, 126, 9, '汉碑残拓', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (87, 126, 14, '汉代丝织残片', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (88, 126, 11, '汉代漆盘', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (89, 126, 23, '民国漆盒', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (90, 126, 26, '明代黄花梨椅', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (91, 126, 28, '明代龙袍', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (92, 126, 32, '明代唐寅山水画', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (93, 126, 33, '明代剔红盒', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (94, 126, 38, '明代云锦服饰', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (95, 126, 45, '清代官服', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (96, 126, 46, '清代红木柜', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (97, 126, 47, '清代花鸟立轴', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (98, 126, 49, '清代行书扇面', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (99, 126, 52, '清代郑板桥竹石图', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (100, 126, 53, '清代织金袍', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (101, 126, 54, '清代紫檀桌', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (102, 126, 58, '山水卷轴', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (103, 126, 64, '宋代碑刻拓片', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (104, 126, 69, '宋代织锦残片', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (105, 126, 70, '宋徽宗瘦金体书法', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (106, 126, 71, '宋人山水册页', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (107, 126, 72, '宋帖影印本', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (108, 126, 74, '唐碑拓本', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (109, 126, 79, '唐代山水画卷', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (110, 126, 84, '唐三彩马', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (111, 126, 85, '王羲之兰亭序摹本', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (112, 126, 86, '王羲之摹本', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (113, 126, 87, '魏碑拓片', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (114, 126, 90, '西夏文残碑拓片', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (115, 126, 97, '元代墨竹图', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (116, 126, 99, '元代赵孟頫行书', 95, 0, NULL, NULL, NULL, '[\"潮湿环境\",\"保存\",\"材质\",\"纸本\",\"丝绸\",\"漆木\",\"陶器\"]', '2026-05-09 16:57:28');
INSERT INTO `ai_query_result` VALUES (117, 128, 20, '开元通宝套币', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (118, 128, 22, '鎏金银壶', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (119, 128, 74, '唐碑拓本', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (120, 128, 75, '唐代金杯', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (121, 128, 76, '唐代龙凤玉佩', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (122, 128, 77, '唐代墓志铭', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (123, 128, 78, '唐代青铜佛像', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (124, 128, 79, '唐代山水画卷', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (125, 128, 80, '唐代铜佛像', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (126, 128, 81, '唐代铜观音', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (127, 128, 82, '唐代玉带饰', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (128, 128, 83, '唐开元通宝', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (129, 128, 84, '唐三彩马', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (130, 128, 85, '王羲之兰亭序摹本', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (131, 128, 86, '王羲之摹本', 95, 0, NULL, NULL, NULL, '[\"唐朝\"]', '2026-05-09 17:09:15');
INSERT INTO `ai_query_result` VALUES (132, 130, 2, '北魏石佛头像', 95, 0, NULL, NULL, NULL, '[\"保养\",\"文物\",\"材质\",\"环境\"]', '2026-05-09 17:09:54');
INSERT INTO `ai_query_result` VALUES (133, 130, 5, '曾侯乙编钟', 95, 0, NULL, NULL, NULL, '[\"保养\",\"文物\",\"材质\",\"环境\"]', '2026-05-09 17:09:54');
INSERT INTO `ai_query_result` VALUES (134, 130, 56, '汝窑天青釉盏', 95, 0, NULL, NULL, NULL, '[\"保养\",\"文物\",\"材质\",\"环境\"]', '2026-05-09 17:09:54');
INSERT INTO `ai_query_result` VALUES (135, 130, 32, '明代唐寅山水画', 95, 0, NULL, NULL, NULL, '[\"保养\",\"文物\",\"材质\",\"环境\"]', '2026-05-09 17:09:54');
INSERT INTO `ai_query_result` VALUES (136, 130, 24, '民国旗袍', 95, 0, NULL, NULL, NULL, '[\"保养\",\"文物\",\"材质\",\"环境\"]', '2026-05-09 17:09:54');
INSERT INTO `ai_query_result` VALUES (137, 132, 5, '曾侯乙编钟', 95, 0, NULL, NULL, NULL, '[\"参观\",\"值得\",\"文物\"]', '2026-05-09 17:10:51');
INSERT INTO `ai_query_result` VALUES (138, 132, 70, '宋徽宗瘦金体书法', 95, 0, NULL, NULL, NULL, '[\"参观\",\"值得\",\"文物\"]', '2026-05-09 17:10:51');
INSERT INTO `ai_query_result` VALUES (139, 132, 98, '元代青花瓷瓶', 95, 0, NULL, NULL, NULL, '[\"参观\",\"值得\",\"文物\"]', '2026-05-09 17:10:51');
INSERT INTO `ai_query_result` VALUES (140, 132, 84, '唐三彩马', 95, 0, NULL, NULL, NULL, '[\"参观\",\"值得\",\"文物\"]', '2026-05-09 17:10:51');
INSERT INTO `ai_query_result` VALUES (141, 132, 93, '新石器彩陶罐', 95, 0, NULL, NULL, NULL, '[\"参观\",\"值得\",\"文物\"]', '2026-05-09 17:10:51');
INSERT INTO `ai_query_result` VALUES (142, 134, 10, '汉代彩绘陶俑', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (143, 134, 30, '明代青花盘', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (144, 134, 31, '明代青花碗', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (145, 134, 44, '清代粉彩瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (146, 134, 56, '汝窑天青釉盏', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (147, 134, 57, '三国青瓷罐', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (148, 134, 63, '宋代白瓷瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (149, 134, 66, '宋代汝窑盘', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (150, 134, 84, '唐三彩马', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (151, 134, 98, '元代青花瓷瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (152, 134, 100, '元青花梅瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"陶瓷类\"]', '2026-05-09 17:18:42');
INSERT INTO `ai_query_result` VALUES (153, 136, 10, '汉代彩绘陶俑', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (154, 136, 30, '明代青花盘', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (155, 136, 31, '明代青花碗', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (156, 136, 44, '清代粉彩瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (157, 136, 56, '汝窑天青釉盏', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (158, 136, 57, '三国青瓷罐', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (159, 136, 63, '宋代白瓷瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (160, 136, 66, '宋代汝窑盘', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (161, 136, 84, '唐三彩马', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (162, 136, 98, '元代青花瓷瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (163, 136, 100, '元青花梅瓶', 95, 0, NULL, NULL, NULL, '[\"陶瓷\",\"文物\"]', '2026-05-09 17:22:03');
INSERT INTO `ai_query_result` VALUES (164, 138, 84, '唐三彩马', 95, 0, NULL, NULL, NULL, '[\"唐朝\",\"文物\",\"特点\"]', '2026-05-09 17:23:34');
INSERT INTO `ai_query_result` VALUES (165, 138, 75, '唐代金杯', 95, 0, NULL, NULL, NULL, '[\"唐朝\",\"文物\",\"特点\"]', '2026-05-09 17:23:34');
INSERT INTO `ai_query_result` VALUES (166, 138, 22, '鎏金银壶', 95, 0, NULL, NULL, NULL, '[\"唐朝\",\"文物\",\"特点\"]', '2026-05-09 17:23:34');
INSERT INTO `ai_query_result` VALUES (167, 138, 76, '唐代龙凤玉佩', 95, 0, NULL, NULL, NULL, '[\"唐朝\",\"文物\",\"特点\"]', '2026-05-09 17:23:34');
INSERT INTO `ai_query_result` VALUES (168, 138, 85, '王羲之兰亭序摹本', 95, 0, NULL, NULL, NULL, '[\"唐朝\",\"文物\",\"特点\"]', '2026-05-09 17:23:34');
INSERT INTO `ai_query_result` VALUES (169, 140, 52, '清代郑板桥竹石图', 95, 0, NULL, NULL, NULL, '[\"清代\",\"郑板桥\",\"竹石图\",\"书画\"]', '2026-05-09 17:37:17');
INSERT INTO `ai_query_result` VALUES (170, 142, 2, '北魏石佛头像', 95, 0, NULL, NULL, NULL, '[\"统计\",\"分类\"]', '2026-05-09 17:54:41');
INSERT INTO `ai_query_result` VALUES (171, 142, 3, '北魏石佛像', 95, 0, NULL, NULL, NULL, '[\"统计\",\"分类\"]', '2026-05-09 17:54:41');
INSERT INTO `ai_query_result` VALUES (172, 142, 4, '北魏造像碑', 95, 0, NULL, NULL, NULL, '[\"统计\",\"分类\"]', '2026-05-09 17:54:41');
INSERT INTO `ai_query_result` VALUES (173, 142, 5, '曾侯乙编钟', 95, 0, NULL, NULL, NULL, '[\"统计\",\"分类\"]', '2026-05-09 17:54:41');
INSERT INTO `ai_query_result` VALUES (174, 142, 6, '春秋青铜编钟', 95, 0, NULL, NULL, NULL, '[\"统计\",\"分类\"]', '2026-05-09 17:54:41');

-- ----------------------------
-- Table structure for archive_document
-- ----------------------------
DROP TABLE IF EXISTS `archive_document`;
CREATE TABLE `archive_document`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `document_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文档类型：appraisal-鉴定报告/repair-修复记录/research-研究论文/certificate-证书/photo-照片/other-其他',
  `document_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文档名称',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小（字节）',
  `file_format` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件格式：pdf/doc/docx/jpg/png/xlsx等',
  `upload_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `uploader_id` bigint NULL DEFAULT NULL COMMENT '上传人ID',
  `uploader_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上传人姓名',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '文档说明',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序顺序',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_archive_id`(`archive_id`) USING BTREE,
  INDEX `idx_document_type`(`document_type`) USING BTREE,
  INDEX `idx_upload_time`(`upload_time`) USING BTREE,
  CONSTRAINT `archive_document_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '档案文档表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of archive_document
-- ----------------------------
INSERT INTO `archive_document` VALUES (1, 1, 'appraisal', '商代青铜鼎正面照.webp', '/uploads/e1f44f18efda4cbf918cc666a368091a.webp', 7740, 'webp', '2024-01-15 10:30:00', 1, '张明远', '商代青铜鼎正面高清照片', 1);
INSERT INTO `archive_document` VALUES (2, 1, 'research', '商代青铜觚参考图.jpg', '/uploads/38eee9a70cb34f24a48ede15088d9d15.jpg', 167105, 'jpg', '2024-01-15 11:00:00', 1, '张明远', '同时期青铜器参考图', 2);
INSERT INTO `archive_document` VALUES (3, 1, 'photo', '商代玉戈参考图.webp', '/uploads/fc921cae189342e493a59d5436ff04cc.webp', 6128, 'webp', '2024-01-15 14:00:00', 1, '张明远', '同时期文物参考', 3);
INSERT INTO `archive_document` VALUES (4, 1, 'certificate', '国家一级文物证书.pdf', '/uploads/archives/cert_001.pdf', 1234567, 'pdf', '2024-01-16 09:00:00', 1, '张明远', '国家文物局颁发的一级文物证书', 4);
INSERT INTO `archive_document` VALUES (7, 3, 'research', '兰亭序摹本高清照.webp', '/uploads/ab83d1743bd541d79414fe67c8a5e524.webp', 17550, 'webp', '2024-02-10 12:00:00', 1, '张明远', '兰亭序摹本高清照片', 1);
INSERT INTO `archive_document` VALUES (8, 3, 'research', '王羲之摹本细节.jpg', '/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg', 67022, 'jpg', '2024-02-12 14:00:00', 1, '张明远', '摹本细节照片', 2);
INSERT INTO `archive_document` VALUES (9, 3, 'photo', '兰亭序高清扫描.webp', '/uploads/ab83d1743bd541d79414fe67c8a5e524.webp', 17550, 'webp', '2024-02-13 10:00:00', 1, '张明远', '兰亭序高清扫描图', 3);
INSERT INTO `archive_document` VALUES (10, 4, 'photo', '明代龙袍正面照.webp', '/uploads/e4bed460f71d495d945fd6630cdcf323.webp', 18164, 'webp', '2024-03-01 11:00:00', 2, '李婉清', '龙袍正面高清照片', 1);
INSERT INTO `archive_document` VALUES (11, 4, 'photo', '明代云锦服饰参考.webp', '/uploads/7cb302c8ff474f1bbb00064077ff6447.webp', 20252, 'webp', '2024-03-01 11:30:00', 2, '李婉清', '同时期服饰参考', 2);
INSERT INTO `archive_document` VALUES (12, 4, 'appraisal', '明代补子细节.webp', '/uploads/3b5b872bc4574442be36bdfa7525f43d.webp', 28430, 'webp', '2024-03-02 09:00:00', 2, '李婉清', '刺绣工艺细节', 3);
INSERT INTO `archive_document` VALUES (13, 5, 'appraisal', '曾侯乙编钟全景.webp', '/uploads/32877c4cd94f4c7f98de18818a8c5104.webp', 18406, 'webp', '2024-03-10 10:00:00', 1, '张明远', '编钟全景照片', 1);
INSERT INTO `archive_document` VALUES (14, 5, 'repair', '春秋青铜编钟参考.jpeg', '/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg', 30293, 'jpeg', '2024-03-15 14:00:00', 1, '张明远', '同时期编钟参考', 2);
INSERT INTO `archive_document` VALUES (15, 5, 'repair', '编钟修复记录照片.webp', '/uploads/32877c4cd94f4c7f98de18818a8c5104.webp', 18406, 'webp', '2024-03-20 16:00:00', 1, '张明远', '编钟修复过程照片', 3);
INSERT INTO `archive_document` VALUES (16, 5, 'research', '编钟音律测试图.jpeg', '/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg', 30293, 'jpeg', '2024-03-22 11:00:00', 1, '张明远', '编钟音律测试照片', 4);
INSERT INTO `archive_document` VALUES (17, 7, 'photo', '汉代石碑照片.webp', '/uploads/e371e143cebe48abb5ef249fd426ccd1.webp', 43302, 'webp', '2024-04-05 12:00:00', 1, '张明远', '石碑高清照片', 1);
INSERT INTO `archive_document` VALUES (18, 7, 'research', '汉碑残拓参考.webp', '/uploads/e423867d6e4f4aac83af6cb469f4bbc7.webp', 66428, 'webp', '2024-04-06 10:00:00', 1, '张明远', '碑文拓片', 2);
INSERT INTO `archive_document` VALUES (19, 8, 'repair', '唐代青铜佛像正面.webp', '/uploads/3c219d52e3814f8d8c6277827ec91d97.webp', 11008, 'webp', '2024-04-12 10:00:00', 2, '李婉清', '佛像正面照片', 1);
INSERT INTO `archive_document` VALUES (20, 8, 'repair', '唐代铜佛像参考.jpg', '/uploads/e089b182f84640379e15b2400d714945.jpg', 837682, 'jpg', '2024-04-13 14:00:00', 2, '李婉清', '同时期佛像参考', 2);
INSERT INTO `archive_document` VALUES (21, 8, 'repair', '唐代铜观音参考.webp', '/uploads/6da715a8159045bda0e896de63ace624.webp', 6124, 'webp', '2024-04-18 16:00:00', 2, '李婉清', '同时期造像参考', 3);
INSERT INTO `archive_document` VALUES (22, 8, 'photo', '佛像修复对比照.jpg', '/uploads/e089b182f84640379e15b2400d714945.jpg', 837682, 'jpg', '2024-04-18 17:00:00', 2, '李婉清', '修复前后对比照片', 4);
INSERT INTO `archive_document` VALUES (24, 13, 'photo', '元代赵孟頫行书.webp', '/uploads/ceef9b347b9b424abf5c9bed5a9b879f.webp', 15846, 'webp', '2026-04-26 23:00:47', 1, '张明远', '', 0);

-- ----------------------------
-- Table structure for archive_history
-- ----------------------------
DROP TABLE IF EXISTS `archive_history`;
CREATE TABLE `archive_history`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '历史记录ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `version` int NULL DEFAULT NULL COMMENT '版本号',
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '操作类型：create-创建/update-更新/upload-上传文档/delete-删除文档/export-导出/print-打印/publish-发布/archive-归档',
  `operation_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '操作内容描述',
  `change_log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '变更日志',
  `operator_id` bigint NULL DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人姓名',
  `operation_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'IP地址',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_archive_id`(`archive_id`) USING BTREE,
  INDEX `idx_operation_time`(`operation_time`) USING BTREE,
  INDEX `idx_operation_type`(`operation_type`) USING BTREE,
  CONSTRAINT `archive_history_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 55 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '档案历史记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of archive_history
-- ----------------------------
INSERT INTO `archive_history` VALUES (1, 1, 1, 'create', '创建档案：商代青铜鼎完整档案', '初始版本', 1, '张明远', '2024-01-15 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (2, 1, 1, 'upload', '上传文档：商代青铜鼎鉴定报告.pdf', '文档类型：鉴定报告', 1, '张明远', '2024-01-15 10:30:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (3, 1, 1, 'upload', '上传文档：商代青铜器铸造工艺研究.pdf', '文档类型：研究论文', 1, '张明远', '2024-01-15 11:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (4, 1, 1, 'upload', '上传文档：商代青铜鼎高清照片集.zip', '文档类型：照片', 1, '张明远', '2024-01-15 14:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (5, 1, 1, 'upload', '上传文档：国家一级文物证书.pdf', '文档类型：证书', 1, '张明远', '2024-01-16 09:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (6, 1, 1, 'publish', '发布档案', '档案已正式发布', 1, '张明远', '2024-01-20 14:30:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (7, 1, 1, 'export', '导出档案（PDF格式）', NULL, 1, '张明远', '2024-01-25 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (12, 3, 1, 'create', '创建档案：王羲之兰亭序摹本研究档案', '初始版本', 1, '张明远', '2024-02-10 11:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (13, 3, 1, 'upload', '上传文档：兰亭序书法艺术研究.docx', '文档类型：研究论文', 1, '张明远', '2024-02-10 12:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (14, 3, 1, 'upload', '上传文档：唐代摹本技法分析.pdf', '文档类型：研究论文', 1, '张明远', '2024-02-12 14:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (15, 3, 1, 'upload', '上传文档：兰亭序摹本高清扫描.tif', '文档类型：照片', 1, '张明远', '2024-02-13 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (16, 3, 2, 'update', '更新档案：王羲之兰亭序摹本研究档案', '版本 v2', 1, '张明远', '2024-02-15 14:20:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (17, 3, 2, 'publish', '发布档案', '档案已正式发布', 1, '张明远', '2024-02-20 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (18, 4, 1, 'create', '创建档案：明代龙袍图片档案', '初始版本', 2, '李婉清', '2024-03-01 10:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (19, 4, 1, 'upload', '上传文档：明代龙袍正面照.jpg', '文档类型：照片', 2, '李婉清', '2024-03-01 11:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (20, 4, 1, 'upload', '上传文档：明代龙袍细节照.jpg', '文档类型：照片', 2, '李婉清', '2024-03-01 11:30:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (21, 4, 1, 'upload', '上传文档：明代龙袍织物分析报告.pdf', '文档类型：鉴定报告', 2, '李婉清', '2024-03-02 09:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (22, 4, 1, 'publish', '发布档案', '档案已正式发布', 2, '李婉清', '2024-03-05 15:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (23, 4, 1, 'archive', '归档', '档案已归档', 2, '李婉清', '2024-04-01 09:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (24, 5, 1, 'create', '创建档案：曾侯乙编钟完整档案', '初始版本', 1, '张明远', '2024-03-10 09:30:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (25, 5, 1, 'upload', '上传文档：曾侯乙编钟鉴定报告.pdf', '文档类型：鉴定报告', 1, '张明远', '2024-03-10 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (26, 5, 2, 'update', '更新档案：曾侯乙编钟完整档案', '版本 v2', 1, '张明远', '2024-03-15 14:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (27, 5, 2, 'upload', '上传文档：编钟修复方案.pdf', '文档类型：修复记录', 1, '张明远', '2024-03-15 14:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (28, 5, 3, 'update', '更新档案：曾侯乙编钟完整档案', '版本 v3', 1, '张明远', '2024-03-20 16:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (29, 5, 3, 'upload', '上传文档：编钟修复过程记录.docx', '文档类型：修复记录', 1, '张明远', '2024-03-20 16:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (30, 5, 3, 'upload', '上传文档：编钟音律研究.pdf', '文档类型：研究论文', 1, '张明远', '2024-03-22 11:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (31, 5, 3, 'publish', '发布档案', '档案已正式发布', 1, '张明远', '2024-03-28 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (32, 5, 3, 'export', '导出档案（Word格式）', NULL, 1, '张明远', '2024-04-02 14:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (33, 6, 1, 'create', '创建档案：宋代汝窑盘鉴定档案', '初始版本', 2, '李婉清', '2024-04-01 10:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (34, 7, 1, 'create', '创建档案：汉代石碑拓片档案', '初始版本', 1, '张明远', '2024-04-05 11:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (35, 7, 1, 'upload', '上传文档：汉代石碑拓片.jpg', '文档类型：照片', 1, '张明远', '2024-04-05 12:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (36, 7, 1, 'upload', '上传文档：汉代碑刻文字考证.pdf', '文档类型：研究论文', 1, '张明远', '2024-04-06 10:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (37, 7, 1, 'publish', '发布档案', '档案已正式发布', 1, '张明远', '2024-04-10 14:00:00', '192.168.1.100');
INSERT INTO `archive_history` VALUES (38, 8, 1, 'create', '创建档案：唐代青铜佛像修复档案', '初始版本', 2, '李婉清', '2024-04-12 09:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (39, 8, 1, 'upload', '上传文档：唐代佛像修复前评估.pdf', '文档类型：修复记录', 2, '李婉清', '2024-04-12 10:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (40, 8, 1, 'upload', '上传文档：唐代佛像修复方案.pdf', '文档类型：修复记录', 2, '李婉清', '2024-04-13 14:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (41, 8, 2, 'update', '更新档案：唐代青铜佛像修复档案', '版本 v2', 2, '李婉清', '2024-04-18 15:30:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (42, 8, 2, 'upload', '上传文档：唐代佛像修复完成报告.pdf', '文档类型：修复记录', 2, '李婉清', '2024-04-18 16:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (43, 8, 2, 'upload', '上传文档：修复前后对比照片.jpg', '文档类型：照片', 2, '李婉清', '2024-04-18 17:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (44, 8, 2, 'publish', '发布档案', '档案已正式发布', 2, '李婉清', '2024-04-20 10:00:00', '192.168.1.101');
INSERT INTO `archive_history` VALUES (50, 12, 1, 'create', '创建档案：编钟保养档案', '初始版本', 2, '李婉清', '2026-04-24 12:03:25', '0:0:0:0:0:0:0:1');
INSERT INTO `archive_history` VALUES (51, 13, 1, 'create', '创建档案：元代赵孟頫行书研究档案', '初始版本', 1, '张明远', '2026-04-24 12:05:09', '0:0:0:0:0:0:0:1');
INSERT INTO `archive_history` VALUES (52, 13, 1, 'upload', '上传文档：元代赵孟頫行书.webp', '文档类型：照片', 1, '张明远', '2026-04-26 23:00:47', '0:0:0:0:0:0:0:1');
INSERT INTO `archive_history` VALUES (53, 12, 1, 'print', '生成打印预览', NULL, 1, '张明远', '2026-05-09 13:25:04', '0:0:0:0:0:0:0:1');
INSERT INTO `archive_history` VALUES (54, 12, 1, 'print', '生成打印预览', NULL, 1, '张明远', '2026-05-09 13:25:09', '0:0:0:0:0:0:0:1');

-- ----------------------------
-- Table structure for archive_relation
-- ----------------------------
DROP TABLE IF EXISTS `archive_relation`;
CREATE TABLE `archive_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `relation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '关联类型：loan-借展/repair-修复/maintenance-维护/exhibition-展览',
  `relation_id` bigint NOT NULL COMMENT '关联记录ID',
  `relation_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '关联时间',
  `relation_desc` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联描述',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_archive_id`(`archive_id`) USING BTREE,
  INDEX `idx_relation_type`(`relation_type`) USING BTREE,
  INDEX `idx_relation_id`(`relation_id`) USING BTREE,
  CONSTRAINT `archive_relation_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '档案关联关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of archive_relation
-- ----------------------------
INSERT INTO `archive_relation` VALUES (1, 1, 'maintenance', 1, '2024-01-18 10:00:00', '关联维护记录：商代青铜鼎定期保养');
INSERT INTO `archive_relation` VALUES (2, 1, 'repair', 1, '2024-01-19 14:00:00', '关联修复记录：青铜鼎表面清洁处理');
INSERT INTO `archive_relation` VALUES (4, 4, 'exhibition', 1, '2024-03-10 10:00:00', '关联展览记录：明代服饰专题展');
INSERT INTO `archive_relation` VALUES (5, 4, 'maintenance', 2, '2024-03-15 14:00:00', '关联维护记录：龙袍防虫防霉处理');
INSERT INTO `archive_relation` VALUES (6, 5, 'repair', 2, '2024-03-12 09:00:00', '关联修复记录：编钟修复项目');
INSERT INTO `archive_relation` VALUES (7, 5, 'maintenance', 3, '2024-03-25 11:00:00', '关联维护记录：编钟音律校准');
INSERT INTO `archive_relation` VALUES (8, 5, 'exhibition', 2, '2024-04-01 10:00:00', '关联展览记录：青铜器专题展');
INSERT INTO `archive_relation` VALUES (9, 8, 'repair', 3, '2024-04-12 09:00:00', '关联修复记录：唐代佛像修复项目');
INSERT INTO `archive_relation` VALUES (10, 8, 'maintenance', 4, '2024-04-20 15:00:00', '关联维护记录：修复后的保养维护');

-- ----------------------------
-- Table structure for cultural_relic
-- ----------------------------
DROP TABLE IF EXISTS `cultural_relic`;
CREATE TABLE `cultural_relic`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `relic_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `relic_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `category_id` bigint NULL DEFAULT NULL,
  `era` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `material` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `origin` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `dimensions` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `weight` decimal(10, 2) NULL DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '在库',
  `image_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `model_3d_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '3D模型URL',
  `model_3d_upload_time` datetime NULL DEFAULT NULL COMMENT '3D模型上传时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `relic_code`(`relic_code`) USING BTREE,
  INDEX `idx_relic_name`(`relic_name`) USING BTREE,
  INDEX `idx_category_id`(`category_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_model_3d_url`(`model_3d_url`) USING BTREE,
  CONSTRAINT `fk_cultural_relic_category` FOREIGN KEY (`category_id`) REFERENCES `cultural_relic_category` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 285 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cultural_relic
-- ----------------------------
INSERT INTO `cultural_relic` VALUES (2, 'WW202501002', '北魏石佛头像', 9, '南北朝', '石', '山西大同', '高25cm', 8.00, '北魏时期石雕佛头像，雕刻精美，面容慈祥', '借展中', '/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp', 'https://sketchfab.com/3d-models/four-faced-buddhist-altar-stone-statue-a37ff58bc518482a8829b711adda6c35', NULL, '2025-01-02 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (3, 'WW202501003', '北魏石佛像', 9, '南北朝', '石', '河南洛阳', '高80cm', 50.00, '北魏时期完整石佛造像，艺术价值极高', '修复中', '/uploads/7d1c8d9746954228ad84bb360a48e958.webp', 'https://sketchfab.com/3d-models/buddha-dipankara-metropolitan-museum-of-art-2a4749b2c7ea4220888792c2d445a2c6', NULL, '2025-01-03 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (4, 'WW202501004', '北魏造像碑', 6, '南北朝', '石', '河北邯郸', '高120cm', 150.00, '北魏造像碑，碑文清晰，造像精美', '借展中', '/uploads/3a61faebc0ef44638ca78150f3bc978d.webp', 'https://sketchfab.com/3d-models/buddhist-stele-of-bing-fajing-e31f089bcc1448c6a971fd0216ca748d', NULL, '2025-01-04 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (5, 'WW202501005', '曾侯乙编钟', 1, '战国', '青铜', '湖北随州', '高265cm', 2500.00, '战国时期曾侯乙墓出土编钟，音律完整，国宝级文物', '修复中', '/uploads/32877c4cd94f4c7f98de18818a8c5104.webp', 'https://sketchfab.com/3d-models/part-of-a-bianzhong-bell-set-3e2cf957b79f4da5adab7f35b37290fa', NULL, '2025-01-05 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (6, 'WW202501006', '春秋青铜编钟', 1, '春秋', '青铜', '河南新郑', '高45cm', 15.00, '春秋时期青铜编钟，铸造精良', '在库', '/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg', 'https://sketchfab.com/3d-models/chinese-bronze-bell-0fd27661ebe142aa880e17963d68851c', '2026-05-06 20:17:07', '2025-01-06 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (7, 'WW202501007', '大禹鼎', 1, '商朝', '青铜', '河南安阳', '高87cm', 75.00, '商代青铜重器，铭文记载大禹治水功绩', '在库', '/uploads/3536f8a54033417db069185f5a53ed4e.webp', 'https://sketchfab.com/3d-models/animated-bronze-ding-food-vessel-5th-c-bce-39b0e727bc1c43a38615b8ca8ac70a78', NULL, '2025-01-07 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (8, 'WW202501008', '东汉铜灯', 1, '汉朝', '青铜', '河北满城', '高48cm', 5.00, '东汉时期青铜灯具，设计巧妙，实用性强', '在库', '/uploads/6cd196faa27044cabfd3257132e0a023.jpg', 'https://sketchfab.com/3d-models/mh-19914146-chinese-turtle-lamp-96087bb0fa274bc290bc49da067617ce', NULL, '2025-01-08 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (9, 'WW202501009', '汉碑残拓', 6, '汉朝', '纸', '陕西西安', '50x70cm', 0.10, '汉代石碑拓片，虽有残缺但文字清晰', '借展中', '/uploads/e423867d6e4f4aac83af6cb469f4bbc7.webp', 'https://sketchfab.com/3d-models/chinese-stone-stele-e15311fd1d0a4b85a08419db712a1b91', '2026-05-06 20:17:23', '2025-01-09 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (10, 'WW202501010', '汉代彩绘陶俑', 2, '汉朝', '陶', '陕西咸阳', '高35cm', 2.00, '', '借展中', '/uploads/7a334f27bf404354b547edc28f274458.webp', 'https://sketchfab.com/3d-models/terracotta-warrior-statue-be25eea03ed741f4b84b5aa1ffbeb659', '2026-05-06 20:18:25', '2025-01-10 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (11, 'WW202501011', '汉代漆盘', 10, '汉朝', '漆木', '湖南长沙', '直径30cm', 0.50, '汉代漆器，纹饰精美，保存完好', '在库', '/uploads/7a49cbe142044f7c9d0a77ae81f5407c.webp', 'https://sketchfab.com/3d-models/chinese-tableware-8008b8c234c048369d329483afacaf46', '2026-05-08 12:21:06', '2025-01-11 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (12, 'WW202501012', '汉代青铜镜', 1, '汉朝', '青铜', '河南洛阳', '直径18cm', 0.80, '汉代铜镜，纹饰精美，铭文清晰', '借展中', '/uploads/678d29b16b5b4f12975d11fc2234feb3.webp', 'https://sketchfab.com/3d-models/animated-bronze-ding-food-vessel-5th-c-bce-39b0e727bc1c43a38615b8ca8ac70a78', NULL, '2025-01-12 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (13, 'WW202501013', '汉代石碑', 6, '汉朝', '石', '山东曲阜', '高180cm', 500.00, '汉代石碑，碑文完整，书法价值高', '在库', '/uploads/e371e143cebe48abb5ef249fd426ccd1.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-01-13 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (14, 'WW202501014', '汉代丝织残片', 8, '汉朝', '丝绸', '新疆吐鲁番', '20x30cm', 0.05, '汉代丝织品残片，纹样精美，极为珍贵', '借展中', '/uploads/3d0187ad0349445fabf4e0b33c512579.jpg', 'https://sketchfab.com/3d-models/silk-fabric-29d9a321f688419b9ae46fd5aa70f124', NULL, '2025-01-14 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (15, 'WW202501015', '汉代玉衣片', 4, '汉朝', '玉', '河北定州', '10x8cm', 0.20, '汉代金缕玉衣残片，工艺精湛', '在库', '/uploads/a6175e984ff14c8389805dd4508cb84e.webp', 'https://sketchfab.com/3d-models/jade-bi-disc-1100-771-bce-d763ec3d9b9c487fa1c6770ed80829cf', NULL, '2025-01-15 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (17, 'WW202501017', '汉五铢钱范', 7, '汉朝', '陶', '河南洛阳', '15x10cm', 0.50, '汉代铸钱模具，研究古代铸币工艺的重要实物', '在库', '/uploads/afabd4e7a71d49ad8ac87373a7a3fb48.webp', 'https://sketchfab.com/3d-models/chinese-coin-384f557db51a407e807c59af188cc9cc', NULL, '2025-01-17 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (18, 'WW202501018', '和田白玉佩', 4, '清朝', '和田玉', '新疆和田', '长8cm', 0.15, '清代和田白玉佩，玉质温润，雕工精细', '在库', '/uploads/17a595c9464541eaa43c2a2b77afd543.jpg', 'https://sketchfab.com/3d-models/chinese-imperial-jade-freepolyorg-4a78e21ef3824418ad4115f5f1aee75d', NULL, '2025-01-18 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (19, 'WW202501019', '金代鎏金杯', 5, '金朝', '鎏金银', '黑龙江哈尔滨', '高12cm', 0.30, '金代鎏金银杯，工艺精湛，保存完好', '在库', '/uploads/48f50558423a4fa98876114cd7cc1914.webp', 'https://sketchfab.com/3d-models/chinese-ancient-artifact-cup-a67d6ad73b354bbfabc2341c319799d8', NULL, '2025-01-19 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (20, 'WW202501020', '开元通宝套币', 7, '唐朝', '铜', '陕西西安', '直径2.4cm', 0.20, '唐代开元通宝成套钱币，品相完好', '在库', '/uploads/b1a5dc0a56e649cb98dcd54893ce2cf9.jpg', 'https://sketchfab.com/3d-models/old-coins-variety-set-08ad1336691345508071cc34aa0ee85c', NULL, '2025-01-20 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (21, 'WW202501021', '辽代玉鸟佩', 4, '辽朝', '玉', '内蒙古赤峰', '长6cm', 0.08, '辽代玉雕鸟形佩饰，造型生动', '在库', '/uploads/433fa46930e04a3fbf0737ed392d4fd6.webp', 'https://sketchfab.com/3d-models/chinese-jade-seal-8404c53255044457a3d4d35ff4ea206a', NULL, '2025-01-21 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (22, 'WW202501022', '鎏金银壶', 5, '唐朝', '鎏金银', '陕西西安', '高25cm', 1.20, '唐代鎏金银壶，造型优美，工艺精湛', '在库', '/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp', 'https://sketchfab.com/3d-models/gold-and-silver-coins-c44b65cc0c6d44898aa40a42a82f82e1', NULL, '2025-01-22 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (23, 'WW202501023', '民国漆盒', 10, '民国', '漆木', '北京', '直径15cm', 0.30, '民国时期漆盒，工艺精美', '在库', '/uploads/d3200cbab3b049fc961bfade69089eac.jpg', 'https://sketchfab.com/3d-models/an-antique-lacquer-box-3e4d31c9a40049139532c172ecf34b73', NULL, '2025-01-23 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (24, 'WW202501024', '民国旗袍', 8, '民国', '丝绸', '上海', '长120cm', 0.50, '民国时期旗袍，保存完好，具有时代特色', '在库', '/uploads/3c3c740446124bc794e2339c33eb37ea.webp', 'https://sketchfab.com/3d-models/traditional-chinese-costumes-jinhuafu-0f09a05d8e7e41ae89ee98fd0a002d6d', NULL, '2025-01-24 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (25, 'WW202501025', '明代补子', 8, '明朝', '丝绸', '北京', '30x30cm', 0.20, '明代官服补子，刺绣精美', '借展中', '/uploads/3b5b872bc4574442be36bdfa7525f43d.webp', 'https://sketchfab.com/3d-models/traditional-chinese-costumes-jinhuafu-0f09a05d8e7e41ae89ee98fd0a002d6d', NULL, '2025-01-25 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (26, 'WW202501026', '明代黄花梨椅', 10, '明朝', '黄花梨木', '广东', '高95cm', 15.00, '明代黄花梨圈椅，造型优美，包浆自然', '在库', '/uploads/970e5599235e41aabb14c8275df4475e.webp', 'https://sketchfab.com/3d-models/chinese-classical-low-wooden-table-928d9159b0a1404285a5f4efb7dd1523', NULL, '2025-01-26 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (27, 'WW202501027', '明代金簪', 5, '明朝', '金', '北京', '长15cm', 0.10, '明代金簪，工艺精细，保存完好', '在库', '/uploads/971880acf0944e498e2c11a133011590.webp', 'https://sketchfab.com/3d-models/ancient-gold-coin-1409b233a341410a92c9a3e0e03ff10a', NULL, '2025-01-27 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (28, 'WW202501028', '明代龙袍', 10, '明朝', '丝绸', '北京', '长150cm', 2.00, '明代皇室龙袍，刺绣精美，极为珍贵', '在库', '/uploads/e4bed460f71d495d945fd6630cdcf323.webp', 'https://sketchfab.com/3d-models/traditional-chinese-costumes-jinhuafu-0f09a05d8e7e41ae89ee98fd0a002d6d', NULL, '2025-01-28 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (29, 'WW202501029', '明代木雕佛龛', 9, '明朝', '木', '福建', '高60cm', 10.00, '明代木雕佛龛，雕刻精美，保存完好', '在库', '/uploads/3f14bc2165a04e32a96846dd28c20158.webp', 'https://sketchfab.com/3d-models/the-buddha-statue-in-a-mountain-53d144d6c081439f9aa5dc1b753ce1ce', NULL, '2025-01-29 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (30, 'WW202501030', '明代青花盘', 2, '明朝', '瓷', '江西景德镇', '直径35cm', 1.50, '明代青花瓷盘，纹饰精美，品相完好', '在库', '/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp', 'https://sketchfab.com/3d-models/colored-blue-and-white-porcelain-vase-d0358634154a4a2b82e29db3da041b34', NULL, '2025-01-30 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (31, 'WW202501031', '明代青花碗', 2, '明朝', '瓷', '江西景德镇', '直径15cm', 0.30, '明代青花碗，胎质细腻，青花发色纯正', '在库', '/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp', 'https://sketchfab.com/3d-models/ancient-chinese-porcelain-vase-39eb515623694df3a0bf052cfde6690f', NULL, '2025-01-31 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (32, 'WW202501032', '明代唐寅山水画', 3, '明朝', '纸本', '江苏苏州', '120x60cm', 0.50, '明代唐寅山水画作，笔墨精妙，极为珍贵', '在库', '/uploads/3f8291c4743e4e078f1f5b47e69bdcce.webp', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-02-01 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (33, 'WW202501033', '明代剔红盒', 10, '明朝', '漆木', '北京', '直径20cm', 0.80, '明代剔红漆盒，雕刻精美，保存完好', '借展中', '/uploads/aab685aa93184206a68ad8a41bb8a604.webp', 'https://sketchfab.com/3d-models/an-antique-lacquer-box-3e4d31c9a40049139532c172ecf34b73', NULL, '2025-02-02 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (34, 'WW202501034', '明代铜佛', 9, '明朝', '青铜', '山西五台山', '高40cm', 8.00, '明代铜佛造像，铸造精良，神态庄严', '在库', '/uploads/e22c85430b234395a7e4911fb9f36541.webp', 'https://sketchfab.com/3d-models/the-buddha-statue-in-a-mountain-53d144d6c081439f9aa5dc1b753ce1ce', NULL, '2025-02-03 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (35, 'WW202501035', '明代银锭', 5, '明朝', '银', '云南', '重50两', 1.50, '明代银锭，铭文清晰，保存完好', '在库', '/uploads/e9f595acac3f40f18e29d3a921144290.jpg', 'https://sketchfab.com/3d-models/gold-and-silver-coins-c44b65cc0c6d44898aa40a42a82f82e1', NULL, '2025-02-04 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (36, 'WW202501036', '明代银香炉', 5, '明朝', '银', '江苏南京', '高18cm', 1.00, '明代银香炉，造型典雅，工艺精湛', '在库', '/uploads/019f1b7f43cd415ca0a9263fc8ea7053.webp', 'https://sketchfab.com/3d-models/chinese-ancient-artifact-cup-a67d6ad73b354bbfabc2341c319799d8', NULL, '2025-02-05 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (37, 'WW202501037', '明代玉如意', 4, '明朝', '玉', '北京', '长40cm', 0.80, '明代玉如意，玉质温润，雕工精细', '在库', '/uploads/47e94f29a81244c0ae8f71c8ede34dfb.webp', 'https://sketchfab.com/3d-models/chinese-imperial-jade-freepolyorg-4a78e21ef3824418ad4115f5f1aee75d', NULL, '2025-02-06 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (38, 'WW202501038', '明代云锦服饰', 8, '明朝', '云锦', '江苏南京', '长130cm', 1.50, '明代云锦服饰，织造精美，色彩艳丽', '借展中', '/uploads/7cb302c8ff474f1bbb00064077ff6447.webp', 'https://sketchfab.com/3d-models/traditional-chinese-costumes-jinhuafu-0f09a05d8e7e41ae89ee98fd0a002d6d', NULL, '2025-02-07 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (39, 'WW202501039', '秦半两钱', 7, '秦朝', '铜', '陕西咸阳', '直径3.2cm', 0.05, '秦代半两钱，中国最早的统一货币', '在库', '/uploads/e1411506fcf94f5a8bedd3eeda9b7378.webp', 'https://sketchfab.com/3d-models/chinese-coin-384f557db51a407e807c59af188cc9cc', NULL, '2025-02-08 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (40, 'WW202501040', '秦朝铜诏版', 1, '秦朝', '青铜', '陕西西安', '30x20cm', 5.00, '秦代诏书铜版，文字清晰，极为珍贵', '在库', '/uploads/88572677c666468e8c66144f43d24186.webp', 'https://sketchfab.com/3d-models/chinese-bronze-ding-vessel-300371f38b92494fbb2a5f1709db2104', NULL, '2025-02-09 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (41, 'WW202501041', '清代白玉如意', 4, '清朝', '白玉', '北京', '长35cm', 0.60, '清代白玉如意，玉质上乘，雕工精美', '在库', '/uploads/bd43d42531484560933d09ec7502f243.jpg', 'https://sketchfab.com/3d-models/chinese-imperial-jade-freepolyorg-4a78e21ef3824418ad4115f5f1aee75d', NULL, '2025-02-10 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (42, 'WW202501042', '清代鼻烟壶', 4, '清朝', '玉石', '北京', '高8cm', 0.10, '清代鼻烟壶，小巧精致，工艺精湛', '在库', '/uploads/3a92d4aea53e4857a9ce860f15c511c2.webp', 'https://sketchfab.com/3d-models/chinese-jade-seal-8404c53255044457a3d4d35ff4ea206a', NULL, '2025-02-11 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (43, 'WW202501043', '清代翡翠手镯', 4, '清朝', '翡翠', '云南', '直径6cm', 0.08, '清代翡翠手镯，色泽鲜艳，质地细腻', '在库', '/uploads/529731d36ef8408590babfb9f4cd584c.webp', 'https://sketchfab.com/3d-models/jade-bi-disc-1100-771-bce-d763ec3d9b9c487fa1c6770ed80829cf', NULL, '2025-02-12 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (44, 'WW202501044', '清代粉彩瓶', 2, '清朝', '瓷', '江西景德镇', '高45cm', 3.00, '清代粉彩瓷瓶，色彩艳丽，绘画精美', '在库', '/uploads/c77e9d65149544b98c254da1592b9650.webp', 'https://sketchfab.com/3d-models/porcelain-vase-d6554d72a1604329bec9756daded361d', NULL, '2025-02-13 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (45, 'WW202501045', '清代官服', 8, '清朝', '丝绸', '北京', '长140cm', 2.00, '清代官服，品级清晰，保存完好', '在库', '/uploads/0306afb2748e4cdb96e5292143173bf6.webp', 'https://sketchfab.com/3d-models/traditional-chinese-costumes-jinhuafu-0f09a05d8e7e41ae89ee98fd0a002d6d', NULL, '2025-02-14 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (46, 'WW202501046', '清代红木柜', 10, '清朝', '红木', '广东', '高180cm', 80.00, '清代红木柜，造型端庄，雕刻精美', '在库', '/uploads/ff357c7d674f40a5b8000c918182f7fe.webp', 'https://sketchfab.com/3d-models/antique-chinese-carved-red-lacquer-cabinet-6f7a085788bd450294c9f41207a35ae8', NULL, '2025-02-15 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (47, 'WW202501047', '清代花鸟立轴', 3, '清朝', '纸本', '北京', '150x60cm', 0.50, '清代花鸟画立轴，设色雅致，笔墨精妙', '在库', '/uploads/58a4b9b01b7740ddb7cb206dab672f08.webp', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-02-16 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (48, 'WW202501048', '清代铜香插', 1, '清朝', '青铜', '北京', '高15cm', 0.50, '清代铜香插，造型别致，包浆自然', '在库', '/uploads/d35eb1aa7fdc434f81c5ca1790c0aaa0.webp', 'https://sketchfab.com/3d-models/ting-food-vessel-12th-c-bce-3186ab05ebe04717af18181e5757205d', NULL, '2025-02-17 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (49, 'WW202501049', '清代行书扇面', 3, '清朝', '纸本', '江苏扬州', '50x20cm', 0.10, '清代行书扇面，书法流畅，保存完好', '在库', '/uploads/298dcbaa80b94d30aa24baa9c3c850af.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-02-18 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (50, 'WW202501050', '清代银锭', 5, '清朝', '银', '云南', '重10两', 0.30, '清代银锭，铭文清晰，品相完好', '在库', '/uploads/43b585c6af20412e98bf3a4191d99c36.webp', 'https://sketchfab.com/3d-models/gold-and-silver-coins-c44b65cc0c6d44898aa40a42a82f82e1', NULL, '2025-02-19 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (51, 'WW202501051', '清代银簪', 5, '清朝', '银', '北京', '长12cm', 0.05, '清代银簪，工艺精细，保存完好', '在库', '/uploads/adaff9788ded43359a696008bac31900.webp', 'https://sketchfab.com/3d-models/ancient-gold-coin-1409b233a341410a92c9a3e0e03ff10a', NULL, '2025-02-20 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (52, 'WW202501052', '清代郑板桥竹石图', 3, '清朝', '纸本', '江苏扬州', '130x60cm', 0.50, '清代郑板桥竹石图，笔墨苍劲，极为珍贵', '在库', '/uploads/fffcad1c276141588537230a45f1aee8.webp', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-02-21 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (53, 'WW202501053', '清代织金袍', 8, '清朝', '织金缎', '北京', '长145cm', 2.50, '清代织金袍，织造精美，金线灿烂', '在库', '/uploads/9554fd393ce240ea99a2788886bf09a8.webp', 'https://sketchfab.com/3d-models/traditional-chinese-costumes-jinhuafu-0f09a05d8e7e41ae89ee98fd0a002d6d', NULL, '2025-02-22 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (54, 'WW202501054', '清代紫檀桌', 10, '清朝', '紫檀木', '北京', '高85cm', 50.00, '清代紫檀桌，材质珍贵，造型典雅', '在库', '/uploads/3b0c4c59760041dfbbbe323ee122dde4.webp', 'https://sketchfab.com/3d-models/chinese-lacquer-shanxi-console-table-fb09d8719c9b4f81ba5ca2244fcc7588', NULL, '2025-02-23 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (55, 'WW202501055', '清帖拓页', 6, '清朝', '纸', '北京', '30x40cm', 0.05, '清代碑帖拓片，字迹清晰', '在库', '/uploads/d3b88237423f4b5fbfd69ab309942557.jpg', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-02-24 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (56, 'WW202501056', '汝窑天青釉盏', 2, '宋朝', '瓷', '河南汝州', '直径12cm', 0.20, '宋代汝窑天青釉盏，釉色纯正，极为珍贵', '在库', '/uploads/6bd0676aaba342a0a7da079eb82dec70.webp', 'https://sketchfab.com/3d-models/porcelain-vase-e8843ce29f304443a4a60a41d638cf74', NULL, '2025-02-25 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (57, 'WW202501057', '三国青瓷罐', 2, '三国', '瓷', '浙江越窑', '高30cm', 2.00, '三国时期青瓷罐，釉色青翠，保存完好', '在库', '/uploads/88da0fad01314386b5968c70ede17edb.webp', 'https://sketchfab.com/3d-models/ancient-chinese-porcelain-vase-39eb515623694df3a0bf052cfde6690f', NULL, '2025-02-26 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (58, 'WW202501058', '山水卷轴', 3, '明朝', '纸本', '浙江杭州', '200x50cm', 0.80, '明代山水画卷轴，笔墨精妙，构图优美', '在库', '/uploads/75d2df6fbd6b4bf2b669e6344533ad26.webp', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-02-27 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (59, 'WW202501059', '商代青铜鼎', 1, '商朝', '青铜', '河南安阳', '高60cm', 40.00, '商代青铜鼎，铸造精良，纹饰精美', '在库', '/uploads/e1f44f18efda4cbf918cc666a368091a.webp', 'https://sketchfab.com/3d-models/chinese-bronze-ding-vessel-300371f38b92494fbb2a5f1709db2104', '2026-05-08 12:59:40', '2025-02-28 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (60, 'WW202501060', '商代青铜觚', 1, '商朝', '青铜', '河南安阳', '高35cm', 5.00, '商代青铜觚，造型优美，纹饰精美', '在库', '/uploads/38eee9a70cb34f24a48ede15088d9d15.jpg', 'https://sketchfab.com/3d-models/chinese-bronze-ding-vessel-300371f38b92494fbb2a5f1709db2104', NULL, '2025-03-01 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (61, 'WW202501061', '商代玉戈', 4, '商朝', '玉', '河南安阳', '长25cm', 0.50, '商代玉戈，玉质精良，制作精美', '在库', '/uploads/fc921cae189342e493a59d5436ff04cc.webp', 'https://sketchfab.com/3d-models/jade-bi-disc-1100-771-bce-d763ec3d9b9c487fa1c6770ed80829cf', NULL, '2025-03-02 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (62, 'WW202501062', '石雕观音像', 9, '明朝', '石', '福建泉州', '高150cm', 300.00, '明代石雕观音像，雕刻精美，神态慈祥', '在库', '/uploads/43e6e949f77f4a91b0114e4693edad14.jpg', 'https://sketchfab.com/3d-models/the-buddha-statue-in-a-mountain-53d144d6c081439f9aa5dc1b753ce1ce', NULL, '2025-03-03 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (63, 'WW202501063', '宋代白瓷瓶', 2, '宋朝', '瓷', '河北定窑', '高30cm', 1.50, '宋代白瓷瓶，胎质细腻，釉色纯白', '在库', '/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg', 'https://sketchfab.com/3d-models/cut-down-porcelain-vase-2375cce82d2c481c86c79eb39bee93ee', NULL, '2025-03-04 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (64, 'WW202501064', '宋代碑刻拓片', 6, '宋朝', '纸', '山东曲阜', '80x40cm', 0.10, '宋代碑刻拓片，字迹清晰，书法价值高', '在库', '/uploads/7c80c4768d8e4d54a7dad114b4d47c42.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-05 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (65, 'WW202501065', '宋代木雕罗汉', 9, '宋朝', '木', '山西五台山', '高80cm', 20.00, '宋代木雕罗汉像，雕刻精美，神态生动', '在库', '/uploads/5efe908f0b594c0f8aaf1a90b63b0596.webp', 'https://sketchfab.com/3d-models/the-buddha-statue-in-a-mountain-53d144d6c081439f9aa5dc1b753ce1ce', NULL, '2025-03-06 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (66, 'WW202501066', '宋代汝窑盘', 2, '宋朝', '瓷', '河南汝州', '直径20cm', 0.50, '宋代汝窑盘，釉色天青，极为珍贵', '在库', '/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp', 'https://sketchfab.com/3d-models/colored-blue-and-white-porcelain-vase-d0358634154a4a2b82e29db3da041b34', NULL, '2025-03-07 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (67, 'WW202501067', '宋代铜钱套装', 7, '宋朝', '铜', '河南开封', '直径2.5cm', 0.30, '宋代铜钱成套，品相完好，品种齐全', '在库', '/uploads/57fb47604e1c4e4eb35cace934f6f0eb.webp', 'https://sketchfab.com/3d-models/old-coins-variety-set-08ad1336691345508071cc34aa0ee85c', NULL, '2025-03-08 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (68, 'WW202501068', '宋代银壶', 5, '宋朝', '银', '浙江杭州', '高20cm', 0.80, '宋代银壶，造型优美，工艺精湛', '修复中', '/uploads/08c6ab0e5b4643179743861502d297b5.webp', 'https://sketchfab.com/3d-models/chinese-ancient-artifact-cup-a67d6ad73b354bbfabc2341c319799d8', NULL, '2025-03-09 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (69, 'WW202501069', '宋代织锦残片', 8, '宋朝', '丝绸', '浙江杭州', '30x20cm', 0.10, '宋代织锦残片，纹样精美，极为珍贵', '在库', '/uploads/12ff4825507f43fd85ca71521284491c.jpg', 'https://sketchfab.com/3d-models/silk-fabric-29d9a321f688419b9ae46fd5aa70f124', NULL, '2025-03-10 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (70, 'WW202501070', '宋徽宗瘦金体书法', 3, '宋朝', '纸本', '河南开封', '100x40cm', 0.30, '宋徽宗瘦金体书法真迹，笔法独特，国宝级文物', '在库', '/uploads/322f2cc978d249ba98113313ae837853.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-11 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (71, 'WW202501071', '宋人山水册页', 3, '宋朝', '纸本', '浙江杭州', '30x25cm', 0.20, '宋代山水画册页，笔墨精妙，意境深远', '在库', '/uploads/f9c3ff6a9b11439894dcf068dc52138b.webp', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-03-12 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (72, 'WW202501072', '宋帖影印本', 3, '宋朝', '纸', '浙江杭州', '40x30cm', 0.15, '宋代碑帖影印本，字迹清晰，保存完好', '在库', '/uploads/b2c5eaf363914301870124970b2a61ec.jpeg', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-13 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (73, 'WW202501073', '隋朝石刻佛首', 9, '隋朝', '石', '河北邯郸', '高40cm', 25.00, '隋代石刻佛首，雕刻精美，面容庄严', '在库', '/uploads/90324eee34794322bf92eea2151d74ad.webp', 'https://sketchfab.com/3d-models/stone-statue-of-one-buddha-and-twobodhisattvas-8c744c4a67ad4923bbfcee4b33c91385', '2026-05-08 13:04:28', '2025-03-14 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (74, 'WW202501074', '唐碑拓本', 6, '唐朝', '纸', '陕西西安', '100x50cm', 0.20, '唐代碑刻拓本，书法遒劲，保存完好', '在库', '/uploads/59454ff4a2c042fd925150657b318d51.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-15 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (75, 'WW202501075', '唐代金杯', 5, '唐朝', '金', '陕西西安', '高10cm', 0.20, '唐代金杯，工艺精湛，保存完好', '在库', '/uploads/645b9ef90d134ef0b0139a4fa7918046.webp', 'https://sketchfab.com/3d-models/ancient-gold-coin-1409b233a341410a92c9a3e0e03ff10a', NULL, '2025-03-16 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (76, 'WW202501076', '唐代龙凤玉佩', 4, '唐朝', '玉', '陕西西安', '长10cm', 0.15, '唐代龙凤纹玉佩，雕工精细，寓意吉祥', '在库', '/uploads/63d15e510c7d4e3db421a419b350fe24.webp', 'https://sketchfab.com/3d-models/chinese-imperial-jade-freepolyorg-4a78e21ef3824418ad4115f5f1aee75d', NULL, '2025-03-17 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (77, 'WW202501077', '唐代墓志铭', 6, '唐朝', '石', '陕西西安', '50x50cm', 30.00, '唐代墓志铭，文字清晰，书法精美', '在库', '/uploads/8a46b212628d48d5ab02a77e02697f1b.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-18 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (78, 'WW202501078', '唐代青铜佛像', 9, '唐朝', '青铜', '陕西西安', '高50cm', 12.00, '唐代青铜佛像，铸造精良，神态庄严', '在库', '/uploads/3c219d52e3814f8d8c6277827ec91d97.webp', 'https://sketchfab.com/3d-models/leshan-giant-tallest-buddha-statue-china-fbdce41919314fe19d3a5de28357c58e', '2026-05-08 13:08:55', '2025-03-19 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (79, 'WW202501079', '唐代山水画卷', 3, '唐朝', '纸本', '陕西西安', '300x50cm', 1.00, '唐代山水画卷，笔墨精妙，极为珍贵', '在库', '/uploads/9784a41ce1a44bcbb3ce5f6428fe578b.webp', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-03-20 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (80, 'WW202501080', '唐代铜佛像', 9, '唐朝', '青铜', '山西五台山', '高35cm', 8.00, '唐代铜佛造像，铸造精良，保存完好', '在库', '/uploads/e089b182f84640379e15b2400d714945.jpg', 'https://sketchfab.com/3d-models/the-buddha-statue-in-a-mountain-53d144d6c081439f9aa5dc1b753ce1ce', NULL, '2025-03-21 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (81, 'WW202501081', '唐代铜观音', 9, '唐朝', '青铜', '陕西西安', '高60cm', 15.00, '唐代铜观音像，造型优美，神态慈祥', '在库', '/uploads/6da715a8159045bda0e896de63ace624.webp', 'https://sketchfab.com/3d-models/stone-statue-of-vipassi-buddha-ed07bb68ee44429abb6ec001ba3c8d4d', '2026-05-08 13:11:08', '2025-03-22 10:00:00', '2026-06-15 07:57:31');
INSERT INTO `cultural_relic` VALUES (82, 'WW202501082', '唐代玉带饰', 4, '唐朝', '玉', '陕西西安', '长8cm', 0.10, '唐代玉带饰，雕工精细，保存完好', '在库', '/uploads/dde2f35afcff45f09b596453e10a4ef0.jpg', 'https://sketchfab.com/3d-models/chinese-jade-handled-bowl-c4d84d08bc374f86be02a20340331a90', NULL, '2025-03-23 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (83, 'WW202501083', '唐开元通宝', 7, '唐朝', '铜', '陕西西安', '直径2.4cm', 0.04, '唐代开元通宝，铸造规整，品相完好', '在库', '/uploads/cdce86e7172a4afd980616b72139e389.webp', 'https://sketchfab.com/3d-models/chinese-coin-384f557db51a407e807c59af188cc9cc', NULL, '2025-03-24 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (84, 'WW202501084', '唐三彩马', 2, '唐朝', '陶', '河南洛阳', '高50cm', 5.00, '唐三彩马，造型生动，釉色艳丽', '在库', '/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp', 'https://sketchfab.com/3d-models/chinese-terracotta-horse-1ffd515f7c8145d0a60e413515262b04', NULL, '2025-03-25 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (85, 'WW202501085', '王羲之兰亭序摹本', 3, '唐朝', '纸本', '陕西西安', '28x320cm', 0.50, '王羲之兰亭序唐代摹本，书法精妙，极为珍贵', '在库', '/uploads/ab83d1743bd541d79414fe67c8a5e524.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-26 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (86, 'WW202501086', '王羲之摹本', 3, '唐朝', '纸本', '陕西西安', '30x100cm', 0.30, '王羲之书法唐代摹本，笔法精妙，价值连城', '在库', '/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-27 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (87, 'WW202501087', '魏碑拓片', 6, '南北朝', '纸', '河南洛阳', '60x40cm', 0.10, '北魏碑刻拓片，字体方正，书法价值高', '在库', '/uploads/ce705c2e63fc421bb86c03b9866e23de.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-28 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (88, 'WW202501088', '五代十国银执壶', 5, '五代十国', '银', '河南开封', '高25cm', 1.00, '五代银执壶，造型优美，工艺精湛', '在库', '/uploads/3ca543bae2a045379128befb7e377b26.jpg', 'https://sketchfab.com/3d-models/chinese-ancient-artifact-cup-a67d6ad73b354bbfabc2341c319799d8', NULL, '2025-03-29 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (89, 'WW202501089', '西汉青铜镜', 1, '汉朝', '青铜', '陕西西安', '直径20cm', 1.00, '西汉铜镜，纹饰精美，保存完好', '在库', '/uploads/295deac6800f40c4ae4983184256f1d2.jpg', 'https://sketchfab.com/3d-models/animated-bronze-ding-food-vessel-5th-c-bce-39b0e727bc1c43a38615b8ca8ac70a78', NULL, '2025-03-30 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (90, 'WW202501090', '西夏文残碑拓片', 6, '西夏', '纸', '宁夏银川', '50x30cm', 0.08, '西夏文残碑拓片，文字罕见，研究价值高', '在库', '/uploads/8a42bd4782a14cd8a1774817ed013e9c.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-03-31 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (91, 'WW202501091', '西周青铜簋', 1, '西周', '青铜', '陕西宝鸡', '高25cm', 8.00, '西周青铜簋，铸造精良，铭文清晰', '在库', '/uploads/230a77be5e6c4522aa33237f9e12dba0.webp', 'https://sketchfab.com/3d-models/ting-food-vessel-12th-c-bce-3186ab05ebe04717af18181e5757205d', NULL, '2025-04-01 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (92, 'WW202501092', '夏朝青铜铃', 1, '夏朝', '青铜', '河南偃师', '高15cm', 1.50, '夏代青铜铃，中国最早的青铜器之一，极为珍贵', '在库', '/uploads/4ca25ebf262344e4b063b6cdfbc37e69.webp', 'https://sketchfab.com/3d-models/chinese-bronze-ding-vessel-300371f38b92494fbb2a5f1709db2104', NULL, '2025-04-02 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (93, 'WW202501093', '新石器彩陶罐', 1, '新石器时代', '陶', '甘肃马家窑', '高40cm', 3.00, '新石器时代彩陶罐，纹饰精美，保存完好', '封存', '/uploads/5daff7dd306e4104ba29ad26d2fd0fa7.webp', 'https://sketchfab.com/3d-models/ceramic-horse-e4b39918931243acb91063047bb08809', NULL, '2025-04-03 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (94, 'WW202501094', '新石器玉璧', 4, '新石器时代', '玉', '浙江良渚', '直径20cm', 0.80, '新石器时代玉璧，制作精美，礼器珍品', '封存', '/uploads/409d3e97d9704f25b6464797f156a888.webp', 'https://sketchfab.com/3d-models/jade-bi-disc-1100-771-bce-d763ec3d9b9c487fa1c6770ed80829cf', NULL, '2025-04-04 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (95, 'WW202501095', '元代金冠', 5, '元朝', '金', '内蒙古', '高20cm', 0.50, '元代金冠，工艺精湛，保存完好', '在库', '/uploads/f8d4f30997cd4eceb41293d08bb8f511.webp', 'https://sketchfab.com/3d-models/ancient-gold-coin-1409b233a341410a92c9a3e0e03ff10a', NULL, '2025-04-05 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (96, 'WW202501096', '元代金饰片', 5, '元朝', '金', '内蒙古', '5x3cm', 0.05, '元代金饰片，工艺精细，保存完好', '在库', '/uploads/68fb242a5a634fceaee81b622bcab6a3.webp', 'https://sketchfab.com/3d-models/gold-and-silver-coins-c44b65cc0c6d44898aa40a42a82f82e1', NULL, '2025-04-06 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (97, 'WW202501097', '元代墨竹图', 3, '元朝', '纸本', '浙江杭州', '100x50cm', 0.40, '元代墨竹图，笔墨苍劲，意境高远', '在库', '/uploads/25588e9135eb47459a61873b01be1e5b.jpg', 'https://sketchfab.com/3d-models/chinese-painting-f0bdcca352b44d06a122a3dec17c68bb', NULL, '2025-04-07 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (98, 'WW202501098', '元代青花瓷瓶', 2, '元朝', '瓷', '江西景德镇', '高40cm', 3.00, '元代青花瓷瓶，青花发色浓艳，极为珍贵', '在库', '/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp', 'https://sketchfab.com/3d-models/porcelain-vase-d6554d72a1604329bec9756daded361d', NULL, '2025-04-08 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (99, 'WW202501099', '元代赵孟頫行书', 3, '元朝', '纸本', '浙江湖州', '80x40cm', 0.30, '元代赵孟頫行书真迹，书法精妙，价值连城', '在库', '/uploads/df772c02a59a42638c72c399180620b3.webp', 'https://sketchfab.com/3d-models/scroll-with-chinese-calligraphy-6c353b702ac84065aa0627fb4994c067', NULL, '2025-04-09 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (100, 'WW202501100', '元青花梅瓶', 2, '元朝', '瓷', '江西景德镇', '高35cm', 2.50, '元青花梅瓶，造型优美，纹饰精美', '在库', '/uploads/3284351accd947448894fb6607a88f7c.jpg', 'https://sketchfab.com/3d-models/ancient-chinese-porcelain-vase-39eb515623694df3a0bf052cfde6690f', NULL, '2025-04-10 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (101, 'WW202501101', '战国刀币', 7, '战国', '铜', '河北燕国', '长15cm', 0.20, '战国刀币，造型独特，保存完好', '在库', '/uploads/943a120f7a794fbaa6fb93d440447317.webp', 'https://sketchfab.com/3d-models/old-coins-variety-set-08ad1336691345508071cc34aa0ee85c', NULL, '2025-04-11 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (102, 'WW202501102', '战国龙纹玉璧', 4, '战国', '玉', '河南洛阳', '直径18cm', 0.50, '战国龙纹玉璧，雕工精美，纹饰精细', '在库', '/uploads/dd86229ede644f57a2efe72b44c61738.webp', 'https://sketchfab.com/3d-models/jade-bi-disc-1100-771-bce-d763ec3d9b9c487fa1c6770ed80829cf', NULL, '2025-04-12 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (103, 'WW202501103', '战国漆器盒', 10, '战国', '漆木', '湖北荆州', '直径20cm', 0.60, '战国漆器盒，纹饰精美，保存完好', '在库', '/uploads/1e461ed655484847bce9d967ae110e73.webp', 'https://sketchfab.com/3d-models/old-storage-wooden-box-6a6683d8533a412c822dd59627349985', NULL, '2025-04-13 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (104, 'WW202501104', '战国青铜剑', 1, '战国', '青铜', '湖北荆州', '长60cm', 1.50, '锋利依旧，铸造精良', '在库', '/uploads/2170bd1297d7486bba277c514d27e9f2.webp', 'https://sketchfab.com/3d-models/animated-bronze-ding-food-vessel-5th-c-bce-39b0e727bc1c43a38615b8ca8ac70a78', NULL, '2025-04-14 10:00:00', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (270, 'CR2026001', '兵马俑', 2, '秦朝', '陶俑', '陕西咸阳', '170x50cm', 180.00, '兵马俑群较为完整', '在库', '/uploads/e0c81692a3c34a8088300bc1ea3d6303.jpg', 'https://sketchfab.com/3d-models/terracotta-warrior-8fd9421a512745ddbe6abb31c1425017', NULL, '2026-04-23 16:16:55', '2026-06-15 07:52:44');
INSERT INTO `cultural_relic` VALUES (284, 'CR2026002', '北宋铜钱串', 7, '宋朝', '铜', '', '', NULL, '', '在库', '', 'https://sketchfab.com/3d-models/chinese-coin-384f557db51a407e807c59af188cc9cc', NULL, '2026-05-06 20:38:09', '2026-06-15 07:52:44');

-- ----------------------------
-- Table structure for cultural_relic_category
-- ----------------------------
DROP TABLE IF EXISTS `cultural_relic_category`;
CREATE TABLE `cultural_relic_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `parent_id` bigint NULL DEFAULT 0,
  `sort_order` int NULL DEFAULT 0,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of cultural_relic_category
-- ----------------------------
INSERT INTO `cultural_relic_category` VALUES (1, '青铜器', 0, 1, '青铜器文物', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (2, '陶瓷器', 0, 2, '陶瓷器文物', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (3, '书画', 0, 3, '书法绘画', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (4, '玉器', 0, 4, '玉石器物', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (5, '金银器', 0, 5, '金银制品', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (6, '碑帖', 0, 6, '碑刻拓片', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (7, '钱币', 0, 7, '古代钱币', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (8, '服饰', 0, 8, '传统服饰', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (9, '佛像', 0, 9, '佛教造像', '2026-04-02 18:00:33', '2026-04-02 18:00:33');
INSERT INTO `cultural_relic_category` VALUES (10, '杂项', 0, 10, '其他文物', '2026-04-02 18:00:33', '2026-04-02 18:00:33');

-- ----------------------------
-- Table structure for image_library
-- ----------------------------
DROP TABLE IF EXISTS `image_library`;
CREATE TABLE `image_library`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `image_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片名称',
  `original_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原始文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '文件类型(MIME)',
  `width` int NULL DEFAULT NULL COMMENT '图片宽度',
  `height` int NULL DEFAULT NULL COMMENT '图片高度',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'uncategorized' COMMENT '分类(relic/exhibition/document/other/uncategorized)',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '标签(逗号分隔)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '描述',
  `uploader_id` bigint NULL DEFAULT NULL COMMENT '上传者ID',
  `uploader_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '上传者姓名',
  `reference_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联类型(relic/loan/repair等)',
  `reference_id` bigint NULL DEFAULT NULL COMMENT '关联对象ID',
  `is_public` tinyint NULL DEFAULT 1 COMMENT '是否公开(1:是 0:否)',
  `view_count` int NULL DEFAULT 0 COMMENT '浏览次数',
  `download_count` int NULL DEFAULT 0 COMMENT '下载次数',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态(1:正常 0:已删除)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE,
  INDEX `idx_uploader`(`uploader_id`) USING BTREE,
  INDEX `idx_reference`(`reference_type`, `reference_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '图片库管理表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of image_library
-- ----------------------------
INSERT INTO `image_library` VALUES (1, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg', 49872, 'image/jpeg', 700, 494, 'relic', NULL, NULL, NULL, 'admin', 'relic', 1, 1, 0, 2, 1, '2026-04-23 15:19:02', '2026-04-27 11:01:21');
INSERT INTO `image_library` VALUES (2, '北魏石佛头像.webp', '北魏石佛头像.webp', '/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp', 59754, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 2, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:32:39');
INSERT INTO `image_library` VALUES (3, '北魏石佛像.webp', '北魏石佛像.webp', '/uploads/7d1c8d9746954228ad84bb360a48e958.webp', 18716, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 3, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (4, '北魏造像碑.webp', '北魏造像碑.webp', '/uploads/3a61faebc0ef44638ca78150f3bc978d.webp', 18918, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 4, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (5, '曾侯乙编钟.webp', '曾侯乙编钟.webp', '/uploads/32877c4cd94f4c7f98de18818a8c5104.webp', 18406, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 5, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (6, '春秋青铜编钟.jpeg', '春秋青铜编钟.jpeg', '/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg', 30293, 'image/jpeg', 640, 612, 'relic', NULL, NULL, NULL, 'admin', 'relic', 6, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (7, '大禹鼎.webp', '大禹鼎.webp', '/uploads/3536f8a54033417db069185f5a53ed4e.webp', 7730, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 7, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (8, '东汉铜灯.jpg', '东汉铜灯.jpg', '/uploads/6cd196faa27044cabfd3257132e0a023.jpg', 177576, 'image/jpeg', 810, 1023, 'relic', NULL, NULL, NULL, 'admin', 'relic', 8, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (9, '汉碑残拓.webp', '汉碑残拓.webp', '/uploads/e423867d6e4f4aac83af6cb469f4bbc7.webp', 66428, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 9, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (10, '汉代彩绘陶俑.webp', '汉代彩绘陶俑.webp', '/uploads/7a334f27bf404354b547edc28f274458.webp', 13832, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 10, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (11, '汉代漆盘.webp', '汉代漆盘.webp', '/uploads/7a49cbe142044f7c9d0a77ae81f5407c.webp', 5926, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 11, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (12, '汉代青铜镜.webp', '汉代青铜镜.webp', '/uploads/678d29b16b5b4f12975d11fc2234feb3.webp', 15174, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 12, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (13, '汉代石碑.webp', '汉代石碑.webp', '/uploads/e371e143cebe48abb5ef249fd426ccd1.webp', 43302, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 13, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (14, '汉代丝织残片.jpg', '汉代丝织残片.jpg', '/uploads/3d0187ad0349445fabf4e0b33c512579.jpg', 45189, 'image/jpeg', 500, 363, 'relic', NULL, NULL, NULL, 'admin', 'relic', 14, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (15, '汉代玉衣片.webp', '汉代玉衣片.webp', '/uploads/a6175e984ff14c8389805dd4508cb84e.webp', 11226, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 15, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (16, '汉五铢钱.webp', '汉五铢钱.webp', '/uploads/9032c02617784f07954a342206f8d298.webp', 17040, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 16, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (17, '汉五铢钱范.webp', '汉五铢钱范.webp', '/uploads/afabd4e7a71d49ad8ac87373a7a3fb48.webp', 8440, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 17, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (18, '和田白玉佩.jpg', '和田白玉佩.jpg', '/uploads/17a595c9464541eaa43c2a2b77afd543.jpg', 249824, 'image/jpeg', 1350, 1800, 'relic', NULL, NULL, NULL, 'admin', 'relic', 18, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (19, '金代鎏金杯.webp', '金代鎏金杯.webp', '/uploads/48f50558423a4fa98876114cd7cc1914.webp', 35634, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 19, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (20, '开元通宝套币.jpg', '开元通宝套币.jpg', '/uploads/b1a5dc0a56e649cb98dcd54893ce2cf9.jpg', 109824, 'image/jpeg', 700, 525, 'relic', NULL, NULL, NULL, 'admin', 'relic', 20, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (21, '辽代玉鸟佩.webp', '辽代玉鸟佩.webp', '/uploads/433fa46930e04a3fbf0737ed392d4fd6.webp', 7726, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 21, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (22, '鎏金银壶.webp', '鎏金银壶.webp', '/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp', 8352, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 22, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (23, '民国漆盒.jpg', '民国漆盒.jpg', '/uploads/d3200cbab3b049fc961bfade69089eac.jpg', 159197, 'image/jpeg', 1417, 1358, 'relic', NULL, NULL, NULL, 'admin', 'relic', 23, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (24, '民国旗袍.webp', '民国旗袍.webp', '/uploads/3c3c740446124bc794e2339c33eb37ea.webp', 9062, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 24, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (25, '明代补子.webp', '明代补子.webp', '/uploads/3b5b872bc4574442be36bdfa7525f43d.webp', 28430, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 25, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (26, '明代黄花梨椅.webp', '明代黄花梨椅.webp', '/uploads/970e5599235e41aabb14c8275df4475e.webp', 9774, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 26, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (27, '明代金簪.webp', '明代金簪.webp', '/uploads/971880acf0944e498e2c11a133011590.webp', 8608, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 27, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (28, '明代龙袍.webp', '明代龙袍.webp', '/uploads/e4bed460f71d495d945fd6630cdcf323.webp', 18164, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 28, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (29, '明代木雕佛龛.webp', '明代木雕佛龛.webp', '/uploads/3f14bc2165a04e32a96846dd28c20158.webp', 22258, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 29, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (30, '明代青花盘.webp', '明代青花盘.webp', '/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp', 30644, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 30, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (31, '明代青花碗.webp', '明代青花碗.webp', '/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp', 6846, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 31, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (32, '明代唐寅山水画.webp', '明代唐寅山水画.webp', '/uploads/3f8291c4743e4e078f1f5b47e69bdcce.webp', 22236, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 32, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (33, '明代剔红盒.webp', '明代剔红盒.webp', '/uploads/aab685aa93184206a68ad8a41bb8a604.webp', 5662, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 33, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (34, '明代铜佛.webp', '明代铜佛.webp', '/uploads/e22c85430b234395a7e4911fb9f36541.webp', 10478, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 34, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (35, '明代银锭.jpg', '明代银锭.jpg', '/uploads/e9f595acac3f40f18e29d3a921144290.jpg', 195719, 'image/jpeg', 1442, 1008, 'relic', NULL, NULL, NULL, 'admin', 'relic', 35, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (36, '明代银香炉.webp', '明代银香炉.webp', '/uploads/019f1b7f43cd415ca0a9263fc8ea7053.webp', 18106, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 36, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (37, '明代玉如意.webp', '明代玉如意.webp', '/uploads/47e94f29a81244c0ae8f71c8ede34dfb.webp', 3456, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 37, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (38, '明代云锦服饰.webp', '明代云锦服饰.webp', '/uploads/7cb302c8ff474f1bbb00064077ff6447.webp', 20252, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 38, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (39, '秦半两钱.webp', '秦半两钱.webp', '/uploads/e1411506fcf94f5a8bedd3eeda9b7378.webp', 12342, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 39, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (40, '秦朝铜诏版.webp', '秦朝铜诏版.webp', '/uploads/88572677c666468e8c66144f43d24186.webp', 36058, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 40, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (41, '清代白玉如意.jpg', '清代白玉如意.jpg', '/uploads/bd43d42531484560933d09ec7502f243.jpg', 604436, 'image/jpeg', 2000, 1238, 'relic', NULL, NULL, NULL, 'admin', 'relic', 41, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (42, '清代鼻烟壶.webp', '清代鼻烟壶.webp', '/uploads/3a92d4aea53e4857a9ce860f15c511c2.webp', 24196, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 42, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (43, '清代翡翠手镯.webp', '清代翡翠手镯.webp', '/uploads/529731d36ef8408590babfb9f4cd584c.webp', 4512, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 43, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (44, '清代粉彩瓶.webp', '清代粉彩瓶.webp', '/uploads/c77e9d65149544b98c254da1592b9650.webp', 15274, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 44, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (45, '清代官服.webp', '清代官服.webp', '/uploads/0306afb2748e4cdb96e5292143173bf6.webp', 6698, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 45, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (46, '清代红木柜.webp', '清代红木柜.webp', '/uploads/ff357c7d674f40a5b8000c918182f7fe.webp', 10462, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 46, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (47, '清代花鸟立轴.webp', '清代花鸟立轴.webp', '/uploads/58a4b9b01b7740ddb7cb206dab672f08.webp', 17552, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 47, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (48, '清代铜香插.webp', '清代铜香插.webp', '/uploads/d35eb1aa7fdc434f81c5ca1790c0aaa0.webp', 9694, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 48, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (49, '清代行书扇面.webp', '清代行书扇面.webp', '/uploads/298dcbaa80b94d30aa24baa9c3c850af.webp', 16470, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 49, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (50, '清代银锭.webp', '清代银锭.webp', '/uploads/43b585c6af20412e98bf3a4191d99c36.webp', 11816, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 50, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (51, '清代银簪.webp', '清代银簪.webp', '/uploads/adaff9788ded43359a696008bac31900.webp', 22580, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 51, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (52, '清代郑板桥竹石图.webp', '清代郑板桥竹石图.webp', '/uploads/fffcad1c276141588537230a45f1aee8.webp', 15082, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 52, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (53, '清代织金袍.webp', '清代织金袍.webp', '/uploads/9554fd393ce240ea99a2788886bf09a8.webp', 7378, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 53, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (54, '清代紫檀桌.webp', '清代紫檀桌.webp', '/uploads/3b0c4c59760041dfbbbe323ee122dde4.webp', 3356, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 54, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (55, '清帖拓页.jpg', '清帖拓页.jpg', '/uploads/d3b88237423f4b5fbfd69ab309942557.jpg', 235329, 'image/jpeg', 932, 1024, 'relic', NULL, NULL, NULL, 'admin', 'relic', 55, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (56, '汝窑天青釉盏.webp', '汝窑天青釉盏.webp', '/uploads/6bd0676aaba342a0a7da079eb82dec70.webp', 16186, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 56, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (57, '三国青瓷罐.webp', '三国青瓷罐.webp', '/uploads/88da0fad01314386b5968c70ede17edb.webp', 2694, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 57, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (58, '山水卷轴.webp', '山水卷轴.webp', '/uploads/75d2df6fbd6b4bf2b669e6344533ad26.webp', 76182, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 58, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (59, '商代青铜鼎.webp', '商代青铜鼎.webp', '/uploads/e1f44f18efda4cbf918cc666a368091a.webp', 7740, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 59, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (60, '商代青铜觚.jpg', '商代青铜觚.jpg', '/uploads/38eee9a70cb34f24a48ede15088d9d15.jpg', 167105, 'image/jpeg', 1600, 867, 'relic', NULL, NULL, NULL, 'admin', 'relic', 60, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (61, '商代玉戈.webp', '商代玉戈.webp', '/uploads/fc921cae189342e493a59d5436ff04cc.webp', 6128, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 61, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (62, '石雕观音像.jpg', '石雕观音像.jpg', '/uploads/43e6e949f77f4a91b0114e4693edad14.jpg', 100551, 'image/jpeg', 550, 666, 'relic', NULL, NULL, NULL, 'admin', 'relic', 62, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (63, '宋代白瓷瓶.jpg', '宋代白瓷瓶.jpg', '/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg', 113760, 'image/jpeg', 700, 1070, 'relic', NULL, NULL, NULL, 'admin', 'relic', 63, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (64, '宋代碑刻拓片.webp', '宋代碑刻拓片.webp', '/uploads/7c80c4768d8e4d54a7dad114b4d47c42.webp', 31052, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 64, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (65, '宋代木雕罗汉.webp', '宋代木雕罗汉.webp', '/uploads/5efe908f0b594c0f8aaf1a90b63b0596.webp', 10638, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 65, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (66, '宋代汝窑盘.webp', '宋代汝窑盘.webp', '/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp', 2004, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 66, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (67, '宋代铜钱套装.webp', '宋代铜钱套装.webp', '/uploads/57fb47604e1c4e4eb35cace934f6f0eb.webp', 9410, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 67, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (68, '宋代银壶.webp', '宋代银壶.webp', '/uploads/08c6ab0e5b4643179743861502d297b5.webp', 12184, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 68, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (69, '宋代织锦残片.jpg', '宋代织锦残片.jpg', '/uploads/12ff4825507f43fd85ca71521284491c.jpg', 53031, 'image/jpeg', 645, 433, 'relic', NULL, NULL, NULL, 'admin', 'relic', 69, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (70, '宋徽宗瘦金体书法.webp', '宋徽宗瘦金体书法.webp', '/uploads/322f2cc978d249ba98113313ae837853.webp', 16574, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 70, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (71, '宋人山水册页.webp', '宋人山水册页.webp', '/uploads/f9c3ff6a9b11439894dcf068dc52138b.webp', 21030, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 71, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (72, '宋帖影印本.jpeg', '宋帖影印本.jpeg', '/uploads/b2c5eaf363914301870124970b2a61ec.jpeg', 87355, 'image/jpeg', 850, 362, 'relic', NULL, NULL, NULL, 'admin', 'relic', 72, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (73, '隋朝石刻佛首.webp', '隋朝石刻佛首.webp', '/uploads/90324eee34794322bf92eea2151d74ad.webp', 15802, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 73, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (74, '唐碑拓本.webp', '唐碑拓本.webp', '/uploads/59454ff4a2c042fd925150657b318d51.webp', 26628, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 74, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (75, '唐代金杯.webp', '唐代金杯.webp', '/uploads/645b9ef90d134ef0b0139a4fa7918046.webp', 11324, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 75, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (76, '唐代龙凤玉佩.webp', '唐代龙凤玉佩.webp', '/uploads/63d15e510c7d4e3db421a419b350fe24.webp', 3902, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 76, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (77, '唐代墓志铭.webp', '唐代墓志铭.webp', '/uploads/8a46b212628d48d5ab02a77e02697f1b.webp', 12580, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 77, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (78, '唐代青铜佛像.webp', '唐代青铜佛像.webp', '/uploads/3c219d52e3814f8d8c6277827ec91d97.webp', 11008, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 78, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (79, '唐代山水画卷.webp', '唐代山水画卷.webp', '/uploads/9784a41ce1a44bcbb3ce5f6428fe578b.webp', 12246, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 79, 1, 0, 0, 1, '2026-04-23 15:19:02', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (80, '唐代铜佛像.jpg', '唐代铜佛像.jpg', '/uploads/e089b182f84640379e15b2400d714945.jpg', 837682, 'image/jpeg', 1488, 2000, 'relic', NULL, NULL, NULL, 'admin', 'relic', 80, 1, 1, 0, 1, '2026-04-23 15:19:03', '2026-04-23 16:57:49');
INSERT INTO `image_library` VALUES (81, '唐代铜观音.webp', '唐代铜观音.webp', '/uploads/6da715a8159045bda0e896de63ace624.webp', 6124, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 81, 1, 1, 0, 1, '2026-04-23 15:19:03', '2026-04-23 16:57:43');
INSERT INTO `image_library` VALUES (82, '唐代玉带饰.jpg', '唐代玉带饰.jpg', '/uploads/dde2f35afcff45f09b596453e10a4ef0.jpg', 15196, 'image/jpeg', 562, 433, 'relic', NULL, NULL, NULL, 'admin', 'relic', 82, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (83, '唐开元通宝.webp', '唐开元通宝.webp', '/uploads/cdce86e7172a4afd980616b72139e389.webp', 9274, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 83, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (84, '唐三彩马.webp', '唐三彩马.webp', '/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp', 6316, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 84, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (85, '王羲之兰亭序摹本.webp', '王羲之兰亭序摹本.webp', '/uploads/ab83d1743bd541d79414fe67c8a5e524.webp', 17550, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 85, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (86, '王羲之摹本.jpg', '王羲之摹本.jpg', '/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg', 67022, 'image/jpeg', 1234, 408, 'relic', NULL, NULL, NULL, 'admin', 'relic', 86, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (87, '魏碑拓片.webp', '魏碑拓片.webp', '/uploads/ce705c2e63fc421bb86c03b9866e23de.webp', 76218, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 87, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (88, '五代十国银执壶.jpg', '五代十国银执壶.jpg', '/uploads/3ca543bae2a045379128befb7e377b26.jpg', 79612, 'image/jpeg', 467, 700, 'relic', NULL, NULL, NULL, 'admin', 'relic', 88, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (89, '西汉青铜镜.jpg', '西汉青铜镜.jpg', '/uploads/295deac6800f40c4ae4983184256f1d2.jpg', 180575, 'image/jpeg', 564, 564, 'relic', NULL, NULL, NULL, 'admin', 'relic', 89, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (90, '西夏文残碑拓片.webp', '西夏文残碑拓片.webp', '/uploads/8a42bd4782a14cd8a1774817ed013e9c.webp', 54878, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 90, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (91, '西周青铜簋.webp', '西周青铜簋.webp', '/uploads/230a77be5e6c4522aa33237f9e12dba0.webp', 11022, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 91, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (92, '夏朝青铜铃.webp', '夏朝青铜铃.webp', '/uploads/4ca25ebf262344e4b063b6cdfbc37e69.webp', 5036, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 92, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (93, '新石器彩陶罐.webp', '新石器彩陶罐.webp', '/uploads/5daff7dd306e4104ba29ad26d2fd0fa7.webp', 3720, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 93, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (94, '新石器玉璧.webp', '新石器玉璧.webp', '/uploads/409d3e97d9704f25b6464797f156a888.webp', 3290, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 94, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (95, '元代金冠.webp', '元代金冠.webp', '/uploads/f8d4f30997cd4eceb41293d08bb8f511.webp', 15236, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 95, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (96, '元代金饰片.webp', '元代金饰片.webp', '/uploads/68fb242a5a634fceaee81b622bcab6a3.webp', 11926, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 96, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (97, '元代墨竹图.jpg', '元代墨竹图.jpg', '/uploads/25588e9135eb47459a61873b01be1e5b.jpg', 455586, 'image/jpeg', 2030, 1080, 'relic', NULL, NULL, NULL, 'admin', 'relic', 97, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (98, '元代青花瓷瓶.webp', '元代青花瓷瓶.webp', '/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp', 10102, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 98, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (99, '元代赵孟頫行书.webp', '元代赵孟頫行书.webp', '/uploads/df772c02a59a42638c72c399180620b3.webp', 15846, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 99, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (100, '元青花梅瓶.jpg', '元青花梅瓶.jpg', '/uploads/3284351accd947448894fb6607a88f7c.jpg', 147800, 'image/jpeg', 960, 1521, 'relic', NULL, NULL, NULL, 'admin', 'relic', 100, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (101, '战国刀币.webp', '战国刀币.webp', '/uploads/943a120f7a794fbaa6fb93d440447317.webp', 10532, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 101, 1, 1, 0, 1, '2026-04-23 15:19:03', '2026-04-24 11:25:19');
INSERT INTO `image_library` VALUES (102, '战国龙纹玉璧.webp', '战国龙纹玉璧.webp', '/uploads/dd86229ede644f57a2efe72b44c61738.webp', 13538, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 102, 1, 1, 0, 1, '2026-04-23 15:19:03', '2026-04-27 10:37:12');
INSERT INTO `image_library` VALUES (103, '战国漆器盒.webp', '战国漆器盒.webp', '/uploads/1e461ed655484847bce9d967ae110e73.webp', 7670, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 103, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (104, '战国青铜剑.webp', '战国青铜剑.webp', '/uploads/2170bd1297d7486bba277c514d27e9f2.webp', 2176, 'image/webp', NULL, NULL, 'relic', NULL, NULL, NULL, 'admin', 'relic', 104, 1, 0, 0, 1, '2026-04-23 15:19:03', '2026-04-23 15:33:06');
INSERT INTO `image_library` VALUES (105, '兵马俑.jpg', '兵马俑.jpg', '/uploads/e0c81692a3c34a8088300bc1ea3d6303.jpg', 41121, 'image/jpeg', NULL, NULL, 'relic', '完整的兵马俑群', NULL, 1, 'admin', 'relic', 270, 1, 6, 1, 1, '2026-04-23 16:16:55', '2026-04-28 16:58:05');
INSERT INTO `image_library` VALUES (106, '82c82adf6b914deb8eb45f3e1915dbee.webp', '82c82adf6b914deb8eb45f3e1915dbee.webp', '/uploads/2b5cc81fe8cb4ca7bf6adfe680c0bf6b.webp', 9274, 'image/webp', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 21:48:11', '2026-04-28 22:14:39');
INSERT INTO `image_library` VALUES (107, '2b5cc81fe8cb4ca7bf6adfe680c0bf6b.webp', '2b5cc81fe8cb4ca7bf6adfe680c0bf6b.webp', '/uploads/7230f3058d0e48f6961d6a8c0af2f50c.webp', 9274, 'image/webp', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:09:18', '2026-04-28 22:14:37');
INSERT INTO `image_library` VALUES (108, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/0fe20711a32b44c4a6e5f189df83cdb2.jpg', 49872, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:30:07', '2026-05-06 15:29:59');
INSERT INTO `image_library` VALUES (109, '北宋铜钱串1.jpg', '北宋铜钱串1.jpg', '/uploads/04469ab6b719401a82015bbf3d5b27c6.jpg', 119310, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:30:07', '2026-05-06 15:29:58');
INSERT INTO `image_library` VALUES (110, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/8840036c119444f884f046fbdbb36aad.jpg', 49872, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:37:51', '2026-05-06 15:29:56');
INSERT INTO `image_library` VALUES (111, '北宋铜钱串1.jpg', '北宋铜钱串1.jpg', '/uploads/d2affb9a5c1e4bcb88d277a58db5810a.jpg', 119310, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:38:41', '2026-05-06 15:29:47');
INSERT INTO `image_library` VALUES (112, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/589afd17c2794f6789ddbb863ca5552e.jpg', 49872, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:47:53', '2026-05-06 15:29:45');
INSERT INTO `image_library` VALUES (113, '北宋铜钱串1.jpg', '北宋铜钱串1.jpg', '/uploads/b6af9377191d45ceaed67bfd243d6d5c.jpg', 119310, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:47:53', '2026-05-06 15:29:43');
INSERT INTO `image_library` VALUES (114, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/6b3b1a06492a47ca8fffa628199f6a25.jpg', 49872, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:51:25', '2026-05-06 15:29:41');
INSERT INTO `image_library` VALUES (115, '北宋铜钱串1.jpg', '北宋铜钱串1.jpg', '/uploads/418aa51b4a67459a9571712f7e244a42.jpg', 119310, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:51:25', '2026-05-06 15:29:40');
INSERT INTO `image_library` VALUES (116, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/9ac84a6be9b24b77bfad28db88d4024a.jpg', 49872, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:55:27', '2026-05-06 15:29:38');
INSERT INTO `image_library` VALUES (117, '北宋铜钱串1.jpg', '北宋铜钱串1.jpg', '/uploads/c2f7f8c630a043db99ce81163fb354e3.jpg', 119310, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 0, '2026-04-28 22:55:27', '2026-05-06 15:29:36');
INSERT INTO `image_library` VALUES (120, '北宋铜钱串.jpg', '北宋铜钱串.jpg', '/uploads/dab90db0ff19468abe11dfee441094f5.jpg', 49872, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 1, 0, 1, '2026-05-06 20:38:10', '2026-05-09 13:10:03');
INSERT INTO `image_library` VALUES (121, '北宋铜钱串1.jpg', '北宋铜钱串1.jpg', '/uploads/33bcf080cdf84cd4bfb0199701388162.jpg', 119310, 'image/jpeg', NULL, NULL, 'relic', NULL, NULL, 1, '张明远', NULL, NULL, 1, 0, 0, 1, '2026-05-06 20:38:10', '2026-05-06 20:38:10');

-- ----------------------------
-- Table structure for loan_record
-- ----------------------------
DROP TABLE IF EXISTS `loan_record`;
CREATE TABLE `loan_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `relic_id` bigint NOT NULL,
  `borrower_unit` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `borrower_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `loan_date` datetime NOT NULL,
  `expected_return_date` datetime NOT NULL,
  `actual_return_date` datetime NULL DEFAULT NULL,
  `purpose` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '待审批',
  `approver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `approve_time` datetime NULL DEFAULT NULL,
  `approve_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `borrower_id` bigint NULL DEFAULT NULL COMMENT '借展人ID（关联sys_user表）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_relic_id`(`relic_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_expected_return_date`(`expected_return_date`) USING BTREE,
  INDEX `idx_borrower_id`(`borrower_id`) USING BTREE,
  CONSTRAINT `fk_loan_record_borrower` FOREIGN KEY (`borrower_id`) REFERENCES `sys_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_loan_relic` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 30 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of loan_record
-- ----------------------------
INSERT INTO `loan_record` VALUES (1, 5, '湖北省博物馆', '13910000001', '2026-01-10 10:00:00', '2026-02-10 10:00:00', '2026-02-08 15:00:00', '专题展出', '已归还', '张明远', '2026-01-09 14:00:00', '同意', '2026-04-02 18:00:33', '2026-04-25 17:40:30', 16);
INSERT INTO `loan_record` VALUES (2, 3, '湖北省博物馆', '13910000002', '2026-02-01 09:30:00', '2026-03-01 09:30:00', '2026-04-06 20:37:11', '交流展览', '已归还', '张明远', '2026-01-31 16:30:00', '同意', '2026-04-02 18:00:33', '2026-04-25 17:40:30', 16);
INSERT INTO `loan_record` VALUES (3, 2, '湖北省博物馆', '13910000003', '2026-02-15 11:00:00', '2026-03-15 11:00:00', NULL, '学术研究', '逾期', '张明远', '2026-02-14 10:20:00', '同意', '2026-04-02 18:00:33', '2026-04-25 17:40:30', 16);
INSERT INTO `loan_record` VALUES (4, 1, '湖北省博物馆', '13910000004', '2026-03-05 13:00:00', '2026-04-05 13:00:00', NULL, '联合展览', '已驳回', '张明远', '2026-04-06 20:37:13', '审批驳回', '2026-04-02 18:00:33', '2026-04-25 17:40:30', 16);
INSERT INTO `loan_record` VALUES (5, 7, '湖北省博物馆', '13910000005', '2026-03-10 09:00:00', '2026-04-10 09:00:00', NULL, '借展', '逾期', '张明远', '2026-04-06 20:37:15', '审批通过', '2026-04-02 18:00:33', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (6, 10, '湖北省博物馆', '13910000006', '2026-03-12 09:30:00', '2026-04-12 09:30:00', NULL, '文献研究', '逾期', '张明远', '2026-03-11 12:00:00', '同意', '2026-04-02 18:00:33', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (7, 11, '湖北省博物馆', '13910000007', '2026-03-14 10:00:00', '2026-04-14 10:00:00', '2026-04-13 14:32:32', '服饰文化展', '已归还', '张明远', '2026-03-13 18:00:00', '同意', '2026-04-02 18:00:33', '2026-04-25 17:40:30', 16);
INSERT INTO `loan_record` VALUES (8, 9, '湖北省博物馆', '13910000008', '2026-03-16 11:00:00', '2026-04-16 11:00:00', NULL, '拓片临展', '已驳回', '陈淑华', '2026-04-14 20:54:58', '审批驳回', '2026-04-02 18:00:33', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (9, 12, '湖北省博物馆', '13910000009', '2026-03-18 12:30:00', '2026-04-18 12:30:00', NULL, '专题展', '逾期', '陈淑华', '2026-04-14 20:55:02', '审批通过', '2026-04-02 18:00:33', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (10, 4, '湖北省博物馆', '13910000010', '2026-03-20 14:00:00', '2026-04-20 14:00:00', NULL, '文物联展', '逾期', '陈淑华', '2026-03-19 16:00:00', '同意', '2026-04-02 18:00:33', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (11, 4, '湖北省博物馆', '1234561213', '2026-04-16 16:00:00', '2026-05-01 09:05:00', NULL, '', '待审批', '陈淑华', NULL, NULL, '2026-04-15 23:26:01', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (12, 1, '湖北省博物馆', '13900001001', '2024-03-01 09:00:00', '2024-04-01 09:00:00', '2024-03-30 15:00:00', '青铜器专题展览', '已归还', '赵国强', '2024-02-28 14:00:00', '同意借展', '2024-02-25 10:00:00', '2026-04-24 15:07:22', 16);
INSERT INTO `loan_record` VALUES (13, 3, '湖北省博物馆', '13900001002', '2024-04-10 10:00:00', '2024-05-10 10:00:00', '2024-05-09 16:00:00', '战国文物展', '已归还', '刘建国', '2024-04-08 15:00:00', '同意', '2024-04-05 11:00:00', '2026-04-24 15:07:22', 16);
INSERT INTO `loan_record` VALUES (14, 7, '湖北省博物馆', '13900001003', '2024-05-15 09:00:00', '2024-06-15 09:00:00', '2026-04-23 20:30:45', '唐代文化展', '已归还', '赵国强', '2024-05-13 16:00:00', '批准借展', '2024-05-10 09:00:00', '2026-04-24 15:07:22', 16);
INSERT INTO `loan_record` VALUES (15, 14, '湖北省博物馆', '13900001004', '2024-06-01 10:00:00', '2024-07-01 10:00:00', NULL, '书画艺术研究', '逾期', '刘建国', '2024-05-30 14:00:00', '同意', '2024-05-28 10:00:00', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (16, 9, '湖北省博物馆', '13900001005', '2024-06-10 11:00:00', '2024-07-10 11:00:00', NULL, '瓷器文化展', '逾期', '赵国强', '2024-06-08 15:00:00', '批准', '2024-06-05 11:00:00', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (17, 12, '湖北省博物馆', '13900001006', '2024-07-01 09:00:00', '2024-08-01 09:00:00', NULL, '古代书法研究', '待审批', '陈淑华', NULL, NULL, '2024-06-28 10:00:00', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (18, 18, '湖北省博物馆', '13900001007', '2024-07-05 10:00:00', '2024-08-05 10:00:00', NULL, '玉器专题展', '待审批', '陈淑华', NULL, NULL, '2024-07-02 11:00:00', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (19, 24, '湖北省博物馆', '13900001008', '2024-07-10 11:00:00', '2024-08-10 11:00:00', NULL, '唐代金银器展', '待审批', '陈淑华', NULL, NULL, '2024-07-08 09:00:00', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (20, 29, '湖北省博物馆', '13900001009', '2024-07-15 09:00:00', '2024-08-15 09:00:00', NULL, '汉代碑刻研究', '已驳回', 'admin', '2026-04-29 22:00:35', '审批驳回', '2024-07-12 10:00:00', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (21, 38, '湖北省博物馆', '13900001010', '2024-07-20 10:00:00', '2024-08-20 10:00:00', NULL, '明清服饰展', '逾期', 'admin', '2026-04-29 22:00:33', '审批通过', '2024-07-18 11:00:00', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (22, 5, '湖北省博物馆', '13900001011', '2024-02-15 09:00:00', '2024-03-15 09:00:00', '2024-03-14 16:00:00', '佛教造像展', '已归还', '赵国强', '2024-02-13 14:00:00', '同意', '2024-02-10 10:00:00', '2026-04-24 15:07:22', 16);
INSERT INTO `loan_record` VALUES (23, 10, '湖北省博物馆', '13900001012', '2024-03-20 10:00:00', '2024-04-20 10:00:00', '2024-04-25 15:00:00', '明代瓷器研究', '已归还', '刘建国', '2024-03-18 15:00:00', '批准', '2024-03-15 11:00:00', '2026-04-24 15:07:22', 16);
INSERT INTO `loan_record` VALUES (24, 25, '湖北省博物馆', '13900001013', '2024-04-25 11:00:00', '2024-05-25 11:00:00', NULL, '古代金属工艺展', '逾期', '赵国强', '2024-04-23 16:00:00', '同意', '2024-04-20 09:00:00', '2026-04-24 15:07:22', 16);
INSERT INTO `loan_record` VALUES (25, 33, '湖北省博物馆', '13900001014', '2024-05-30 09:00:00', '2024-06-30 09:00:00', NULL, '战国货币研究', '逾期', '刘建国', '2024-05-28 14:00:00', '批准', '2024-05-25 10:00:00', '2026-05-13 08:34:49', 16);
INSERT INTO `loan_record` VALUES (26, 45, '湖北省博物馆', '13900001015', '2024-06-20 10:00:00', '2024-07-20 10:00:00', '2026-04-27 13:36:17', '明式家具展', '已归还', '赵国强', '2024-06-18 15:00:00', '同意', '2024-06-15 11:00:00', '2026-04-27 13:36:17', 16);
INSERT INTO `loan_record` VALUES (27, 3, '湖北省博物馆', '12345678910', '2026-04-19 22:12:23', '2026-04-30 12:08:00', NULL, '展览', '待审批', '陈淑华', NULL, NULL, '2026-04-19 22:12:47', '2026-04-25 17:40:54', 16);
INSERT INTO `loan_record` VALUES (28, 1, '湖北省博物馆', '19986310535', '2026-04-24 16:43:03', '2026-04-30 13:00:00', '2026-04-27 16:04:30', '展览', '已归还', '陈淑华', '2026-04-24 17:03:07', '审批通过', '2026-04-24 16:43:18', '2026-04-27 16:04:30', 16);
INSERT INTO `loan_record` VALUES (29, 6, '湖北省博物馆', '19986310535', '2026-04-24 17:03:14', '2026-04-30 00:00:00', NULL, '展览', '已驳回', 'admin', '2026-04-28 14:00:03', '审批驳回', '2026-04-24 17:03:38', '2026-04-25 17:40:54', 16);

-- ----------------------------
-- Table structure for maintenance_record
-- ----------------------------
DROP TABLE IF EXISTS `maintenance_record`;
CREATE TABLE `maintenance_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `relic_id` bigint NOT NULL,
  `maintenance_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `maintenance_date` datetime NOT NULL,
  `maintenance_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `maintainer` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `maintainer_id` bigint NULL DEFAULT NULL COMMENT '维护人员ID（关联sys_user表）',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '待审批' COMMENT '状态：待审批、已通过、已拒绝',
  `approver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_date` datetime NULL DEFAULT NULL COMMENT '审批日期',
  `approve_remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '审批意见',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_relic_id`(`relic_id`) USING BTREE,
  INDEX `idx_maintenance_date`(`maintenance_date`) USING BTREE,
  INDEX `idx_maintainer_id`(`maintainer_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  CONSTRAINT `fk_maintenance_maintainer` FOREIGN KEY (`maintainer_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_maintenance_relic` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 34 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of maintenance_record
-- ----------------------------
INSERT INTO `maintenance_record` VALUES (2, 2, '状态检查', '2026-01-15 10:00:00', '剑身锈蚀点检查', '', 2, '待审批', NULL, NULL, NULL, '轻微锈斑', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (3, 3, '环境检查', '2026-01-20 11:00:00', '温湿度记录与釉面观察', '', 2, '待审批', NULL, NULL, NULL, '正常', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (4, 4, '日常保养', '2026-02-02 09:30:00', '无酸擦拭处理', '', 2, '待审批', NULL, NULL, NULL, '正常', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (5, 5, '状态检查', '2026-02-10 14:00:00', '纸本边缘加固评估', '', 2, '待审批', NULL, NULL, NULL, '建议修复', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (6, 6, '日常保养', '2026-02-18 15:00:00', '防潮箱更新', '', 3, '待审批', NULL, NULL, NULL, '正常', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (7, 7, '状态检查', '2026-02-25 10:20:00', '玉质裂纹检查', '', 3, '待审批', NULL, NULL, NULL, '正常', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (8, 8, '深度维护', '2026-03-01 09:40:00', '金属腐蚀处置', '', 3, '待审批', NULL, NULL, NULL, '已转修复', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (9, 9, '日常保养', '2026-03-08 11:10:00', '拓片展卷整理', '', 3, '待审批', NULL, NULL, NULL, '正常', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (10, 12, '状态检查', '2026-03-15 13:30:00', '石雕裂隙监测', '', 3, '待审批', NULL, NULL, NULL, '持续观察', '2020-04-02 18:00:33', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (12, 10, '日常维护', '2026-04-14 00:00:00', '检查套币完整度', '', 9, '已拒绝', 'chen', '2026-04-29 22:29:06', '', '', '2026-04-14 20:51:30', '2026-04-29 22:29:05');
INSERT INTO `maintenance_record` VALUES (14, 2, '状态检查', '2024-01-25 10:00:00', '检查青铜簋表面锈蚀情况', '', 9, '待审批', NULL, NULL, NULL, '发现轻微锈斑', '2024-01-25 10:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (15, 3, '日常保养', '2024-02-05 11:00:00', '青铜剑除尘，刃部保护', '', 9, '待审批', NULL, NULL, NULL, '保存完好', '2024-02-05 11:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (16, 4, '深度维护', '2024-02-10 09:00:00', '铜镜表面清洁与防护', '', 9, '待审批', NULL, NULL, NULL, '已做防护处理', '2024-02-10 09:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (17, 5, '状态检查', '2024-02-15 10:00:00', '检查鎏金残存情况', '', 9, '待审批', NULL, NULL, NULL, '鎏金脱落严重', '2024-02-15 10:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (18, 6, '日常保养', '2024-02-20 11:00:00', '彩陶罐除尘，温湿度监测', '', 9, '待审批', NULL, NULL, NULL, '正常', '2024-02-20 11:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (19, 7, '环境检查', '2024-02-25 09:00:00', '三彩马釉面检查，环境调控', '', 14, '待审批', NULL, NULL, NULL, '釉面完好', '2024-02-25 09:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (20, 8, '日常保养', '2024-03-01 10:00:00', '汝窑盘清洁保养', '', 14, '待审批', NULL, NULL, NULL, '开片自然', '2024-03-01 10:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (21, 9, '状态检查', '2024-03-05 11:00:00', '青花瓷瓶釉面检查', '', 14, '待审批', NULL, NULL, NULL, '状态良好', '2024-03-05 11:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (22, 10, '日常保养', '2024-03-10 09:00:00', '青花碗除尘保养', '', 14, '待审批', NULL, NULL, NULL, '正常', '2024-03-10 09:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (23, 12, '环境检查', '2024-03-15 10:00:00', '书法作品防潮检查', '', 14, '待审批', NULL, NULL, NULL, '需要除湿', '2024-03-15 10:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (24, 13, '日常保养', '2024-03-20 11:00:00', '山水画卷展卷检查', '', 14, '待审批', NULL, NULL, NULL, '绢本完好', '2024-03-20 11:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (25, 15, '状态检查', '2024-03-25 09:00:00', '行书手卷纸张状态检查', '', 2, '待审批', NULL, NULL, NULL, '纸张老化', '2024-03-25 09:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (26, 18, '日常保养', '2024-04-01 10:00:00', '玉璧清洁保养', '', 2, '待审批', NULL, NULL, NULL, '玉质温润', '2024-04-01 10:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (27, 20, '状态检查', '2024-04-05 11:00:00', '玉衣片检查', '', 3, '待审批', NULL, NULL, NULL, '完好', '2024-04-05 11:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (28, 24, '深度维护', '2024-04-10 09:00:00', '金杯清洁与防护', '', 9, '待审批', NULL, NULL, NULL, '已做保护', '2024-04-10 09:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (29, 25, '状态检查', '2024-04-15 10:00:00', '银壶氧化检查', '', 14, '待审批', NULL, NULL, NULL, '需要修复', '2024-04-15 10:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (30, 29, '日常保养', '2024-04-20 11:00:00', '石碑除尘清洁', '', 14, '已拒绝', 'admin', '2026-04-30 10:13:39', '', '碑文清晰', '2024-04-20 11:30:00', '2026-04-30 10:13:38');
INSERT INTO `maintenance_record` VALUES (31, 38, '环境检查', '2024-04-25 09:00:00', '龙袍防虫防潮检查', '', 2, '待审批', NULL, NULL, NULL, '需要防虫处理', '2024-04-25 09:30:00', '2026-04-29 13:20:29');
INSERT INTO `maintenance_record` VALUES (32, 45, '日常保养', '2024-05-01 10:00:00', '黄花梨椅清洁保养', '', 2, '已通过', 'admin', '2026-04-30 10:13:36', '', '木质良好', '2024-05-01 10:30:00', '2026-04-30 10:13:35');
INSERT INTO `maintenance_record` VALUES (33, 2, '日常维护', '2026-04-30 12:22:47', '防止氧化', '', 2, '已通过', 'chen', '2026-04-29 22:29:02', '', '', '2026-04-29 12:23:12', '2026-04-29 22:29:02');

-- ----------------------------
-- Table structure for museum
-- ----------------------------
DROP TABLE IF EXISTS `museum`;
CREATE TABLE `museum`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '博物馆ID',
  `museum_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '博物馆编码',
  `museum_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '博物馆名称',
  `museum_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '博物馆类型（综合类、历史类、艺术类、自然类等）',
  `province` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '省份',
  `city` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '城市',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '详细地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系邮箱',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '博物馆简介',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `museum_code`(`museum_code`) USING BTREE,
  INDEX `idx_museum_name`(`museum_name`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '博物馆信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of museum
-- ----------------------------
INSERT INTO `museum` VALUES (1, 'MUS001', '国家博物馆', '综合类', '北京市', '北京市', '天安门广场东侧', '张望', '010-12345678', 'contact@nationalmuseum.cn', '中国国家博物馆是世界上单体建筑面积最大的博物馆', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (2, 'MUS002', '故宫博物院', '历史类', '北京市', '北京市', '景山前街4号', '李斯', '010-87654321', 'contact@dpm.org.cn', '明清两代的皇家宫殿，世界文化遗产', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (3, 'MUS003', '上海博物馆', '综合类', '上海市', '上海市', '人民大道201号', '王巍', '021-12345678', 'contact@shanghaimuseum.net', '中国古代艺术博物馆', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (4, 'MUS004', '陕西历史博物馆', '历史类', '陕西省', '西安市', '小寨东路91号', '赵任', '029-12345678', 'contact@sxhm.com', '中国第一座大型现代化国家级博物馆', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (5, 'MUS005', '湖南省博物馆', '综合类', '湖南省', '长沙市', '东风路50号', '刘珠', '0731-12345678', 'contact@hnmuseum.com', '马王堆汉墓文物收藏地', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (6, 'MUS006', '南京博物院', '综合类', '江苏省', '南京市', '中山东路321号', '陈城', '025-12345678', 'contact@njmuseum.com', '中国三大博物馆之一', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (7, 'MUS007', '浙江省博物馆', '综合类', '浙江省', '杭州市', '孤山路25号', '周柳', '0571-12345678', 'contact@zhejiangmuseum.com', '浙江省最大的综合性博物馆', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (8, 'MUS008', '河南博物院', '历史类', '河南省', '郑州市', '农业路8号', '吴问', '0371-12345678', 'contact@henanmuseum.net', '中国建立较早的博物馆之一', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (9, 'MUS009', '湖北省博物馆', '综合类', '湖北省', '武汉市', '东湖路160号', '郑楠', '027-12345678', 'contact@hubeimuseum.com', '曾侯乙编钟收藏地', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (10, 'MUS010', '广东省博物馆', '综合类', '广东省', '广州市', '珠江东路2号', '黄文', '020-12345678', 'contact@gdmuseum.com', '岭南文化展示中心', 1, '2026-04-23 11:24:46', '2026-04-24 20:17:16');
INSERT INTO `museum` VALUES (11, 'MUS011', '首都博物馆', '历史类', '北京市', '北京', '西城区复兴门外大街16号', '张伟', '13800000011', 'museum11@qq.com', '以北京历史文化为主题的大型综合性博物馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (12, 'MUS012', '天津博物馆', '综合类', '天津市', '天津', '河西区平江道62号', '李强', '13800000012', 'museum12@qq.com', '展示天津历史与艺术的综合博物馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (13, 'MUS013', '山西博物院', '历史类', '山西省', '太原', '滨河西路北段13号', '王磊', '13800000013', 'museum13@qq.com', '山西历史文化展示中心', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (14, 'MUS014', '辽宁省博物馆', '艺术类', '辽宁省', '沈阳', '浑南区智慧三街157号', '赵敏', '13800000014', 'museum14@qq.com', '以书画和文物收藏著称', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (15, 'MUS015', '吉林省博物院', '综合类', '吉林省', '长春', '人民大街3188号', '陈杰', '13800000015', 'museum15@qq.com', '地方历史与艺术展览', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (16, 'MUS016', '黑龙江省博物馆', '历史类', '黑龙江省', '哈尔滨', '红军街64号', '刘洋', '13800000016', 'museum16@qq.com', '展示东北历史文化', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (17, 'MUS017', '苏州博物馆', '艺术类', '江苏省', '苏州', '东北街204号', '周涛', '13800000017', 'museum17@qq.com', '融合古典与现代建筑艺术', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (18, 'MUS018', '扬州博物馆', '综合类', '江苏省', '扬州', '文昌西路468号', '吴强', '13800000018', 'museum18@qq.com', '扬州历史文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (19, 'MUS019', '宁波博物馆', '历史类', '浙江省', '宁波', '鄞州区首南中路1000号', '郑凯', '13800000019', 'museum19@qq.com', '地方文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (20, 'MUS020', '安徽博物院', '综合类', '安徽省', '合肥', '怀宁路268号', '何俊', '13800000020', 'museum20@qq.com', '安徽历史文化综合展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (21, 'MUS021', '福建博物院', '历史类', '福建省', '福州', '鼓楼区湖头街96号', '林涛', '13800000021', 'museum21@qq.com', '福建文化遗产展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (22, 'MUS022', '江西省博物馆', '综合类', '江西省', '南昌', '赣江北大道698号', '谢辉', '13800000022', 'museum22@qq.com', '江西历史文化展览', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (23, 'MUS023', '山东博物馆', '历史类', '山东省', '济南', '经十东路11899号', '高峰', '13800000023', 'museum23@qq.com', '齐鲁文化展示中心', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (24, 'MUS024', '青岛市博物馆', '艺术类', '山东省', '青岛', '崂山区梅岭东路51号', '孙伟', '13800000024', 'museum24@qq.com', '地方文化艺术展馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (25, 'MUS025', '大连博物馆', '综合类', '辽宁省', '大连', '沙河口区会展路10号', '马超', '13800000025', 'museum25@qq.com', '展示城市发展历史', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (26, 'MUS026', '重庆中国三峡博物馆', '历史类', '重庆市', '重庆', '渝中区人民路236号', '蒋欣', '13800000026', 'museum26@qq.com', '三峡文化主题博物馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (27, 'MUS027', '成都博物馆', '综合类', '四川省', '成都', '青羊区小河街1号', '唐宇', '13800000027', 'museum27@qq.com', '成都历史文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (28, 'MUS028', '四川博物院', '历史类', '四川省', '成都', '青羊区浣花南路251号', '冯亮', '13800000028', 'museum28@qq.com', '四川历史文物收藏', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (29, 'MUS029', '云南省博物馆', '综合类', '云南省', '昆明', '广福路6393号', '段飞', '13800000029', 'museum29@qq.com', '多民族文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (30, 'MUS030', '贵州省博物馆', '历史类', '贵州省', '贵阳', '观山湖区林城东路107号', '罗军', '13800000030', 'museum30@qq.com', '民族文化特色鲜明', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (31, 'MUS031', '广西民族博物馆', '民族类', '广西壮族自治区', '南宁', '青环路11号', '覃伟', '13800000031', 'museum31@qq.com', '民族文化主题博物馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (32, 'MUS032', '海南省博物馆', '综合类', '海南省', '海口', '国兴大道68号', '符强', '13800000032', 'museum32@qq.com', '海南历史文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (33, 'MUS033', '西藏博物馆', '历史类', '西藏自治区', '拉萨', '罗布林卡路19号', '扎西', '13800000033', 'museum33@qq.com', '藏族文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (34, 'MUS034', '青海省博物馆', '综合类', '青海省', '西宁', '城西区西关大街58号', '马龙', '13800000034', 'museum34@qq.com', '高原文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (35, 'MUS035', '宁夏博物馆', '历史类', '宁夏回族自治区', '银川', '人民广场东街6号', '杨帆', '13800000035', 'museum35@qq.com', '西夏文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (36, 'MUS036', '新疆博物馆', '综合类', '新疆维吾尔自治区', '乌鲁木齐', '西北路132号', '阿力', '13800000036', 'museum36@qq.com', '丝绸之路文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (37, 'MUS037', '洛阳博物馆', '历史类', '河南省', '洛阳', '聂泰路', '赵磊', '13800000037', 'museum37@qq.com', '古都文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (38, 'MUS038', '开封博物馆', '历史类', '河南省', '开封', '郑开大道', '孙涛', '13800000038', 'museum38@qq.com', '宋代文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (39, 'MUS039', '徐州博物馆', '综合类', '江苏省', '徐州', '和平路118号', '钱峰', '13800000039', 'museum39@qq.com', '汉文化特色明显', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (40, 'MUS040', '无锡博物院', '艺术类', '江苏省', '无锡', '钟书路100号', '周凯', '13800000040', 'museum40@qq.com', '地方艺术文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (41, 'MUS041', '温州博物馆', '综合类', '浙江省', '温州', '市府路', '林峰', '13800000041', 'museum41@qq.com', '地方文化展馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (42, 'MUS042', '台州博物馆', '历史类', '浙江省', '台州', '中心大道', '郑辉', '13800000042', 'museum42@qq.com', '区域文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (43, 'MUS043', '泉州博物馆', '历史类', '福建省', '泉州', '东湖街', '陈涛', '13800000043', 'museum43@qq.com', '海上丝绸之路文化', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (44, 'MUS044', '厦门博物馆', '综合类', '福建省', '厦门', '体育路', '黄强', '13800000044', 'museum44@qq.com', '闽南文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (45, 'MUS045', '烟台博物馆', '历史类', '山东省', '烟台', '南大街', '孙建', '13800000045', 'museum45@qq.com', '地方文化展览', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (46, 'MUS046', '济宁博物馆', '综合类', '山东省', '济宁', '太白楼路', '李涛', '13800000046', 'museum46@qq.com', '孔孟文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (47, 'MUS047', '保定博物馆', '历史类', '河北省', '保定', '朝阳北大街', '王强', '13800000047', 'museum47@qq.com', '地方历史展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (48, 'MUS048', '唐山博物馆', '综合类', '河北省', '唐山', '新华道', '刘伟', '13800000048', 'museum48@qq.com', '工业文化特色', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (49, 'MUS049', '呼和浩特博物馆', '历史类', '内蒙古自治区', '呼和浩特', '新华大街', '巴特尔', '13800000049', 'museum49@qq.com', '草原文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (50, 'MUS050', '包头博物馆', '综合类', '内蒙古自治区', '包头', '钢铁大街', '乌兰', '13800000050', 'museum50@qq.com', '工业与草原文化结合', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (51, 'MUS051', '延安革命纪念馆', '历史类', '陕西省', '延安', '王家坪路', '张军', '13800000051', 'museum51@qq.com', '革命历史纪念馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (52, 'MUS052', '遵义会议纪念馆', '历史类', '贵州省', '遵义', '红花岗区', '李军', '13800000052', 'museum52@qq.com', '红色文化教育基地', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (53, 'MUS053', '井冈山革命博物馆', '历史类', '江西省', '吉安', '茨坪镇', '刘军', '13800000053', 'museum53@qq.com', '革命历史主题馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (54, 'MUS054', '南昌八一起义纪念馆', '历史类', '江西省', '南昌', '中山路', '陈军', '13800000054', 'museum54@qq.com', '红色文化展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (55, 'MUS055', '广州鲁迅纪念馆', '人物类', '广东省', '广州', '文明路', '周军', '13800000055', 'museum55@qq.com', '纪念鲁迅文化贡献', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (56, 'MUS056', '杭州工艺美术博物馆', '艺术类', '浙江省', '杭州', '桥弄街', '吴军', '13800000056', 'museum56@qq.com', '传统工艺展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (57, 'MUS057', '北京汽车博物馆', '科技类', '北京市', '北京', '丰台区', '赵军', '13800000057', 'museum57@qq.com', '汽车工业发展展示', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (58, 'MUS058', '上海航海博物馆', '科技类', '上海市', '上海', '临港新区', '孙军', '13800000058', 'museum58@qq.com', '航海文化展示', 0, '2026-04-24 20:15:42', '2026-04-24 20:44:23');
INSERT INTO `museum` VALUES (59, 'MUS059', '中国丝绸博物馆', '艺术类', '浙江省', '杭州', '玉皇山路', '钱军', '13800000059', 'museum59@qq.com', '丝绸文化专题馆', 1, '2026-04-24 20:15:42', '2026-04-24 20:15:42');
INSERT INTO `museum` VALUES (60, 'MUS060', '中国茶叶博物馆', '文化类', '浙江省', '杭州', '龙井路', '龙旺', '13800000060', 'museum60@qq.com', '茶文化展示', 1, '2026-04-24 20:41:19', '2026-04-24 20:41:21');
INSERT INTO `museum` VALUES (61, 'MUS061', '合肥市博物馆', '综合类', '安徽省', '合肥', '蜀山区怀宁路', '张强', '13900000061', 'museum61@qq.com', '地方综合性博物馆', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (62, 'MUS062', '芜湖市博物馆', '历史类', '安徽省', '芜湖', '镜湖区文化路', '李伟', '13900000062', 'museum62@qq.com', '地方历史文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (63, 'MUS063', '蚌埠博物馆', '综合类', '安徽省', '蚌埠', '龙子湖区东海大道', '王磊', '13900000063', 'museum63@qq.com', '区域文化展馆', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (64, 'MUS064', '泉州海外交通史博物馆', '历史类', '福建省', '泉州', '丰泽区东湖街', '陈杰', '13900000064', 'museum64@qq.com', '海上丝绸之路专题馆', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (65, 'MUS065', '福州三坊七巷博物馆', '历史类', '福建省', '福州', '鼓楼区南后街', '林涛', '13900000065', 'museum65@qq.com', '传统街区文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (66, 'MUS066', '漳州博物馆', '综合类', '福建省', '漳州', '芗城区胜利路', '郑凯', '13900000066', 'museum66@qq.com', '闽南文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (67, 'MUS067', '佛山祖庙博物馆', '历史类', '广东省', '佛山', '禅城区祖庙路', '何俊', '13900000067', 'museum67@qq.com', '岭南文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (68, 'MUS068', '深圳博物馆', '综合类', '广东省', '深圳', '福田区同心路', '刘洋', '13900000068', 'museum68@qq.com', '城市发展与历史展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (69, 'MUS069', '东莞博物馆', '综合类', '广东省', '东莞', '莞城区新芬路', '周涛', '13900000069', 'museum69@qq.com', '地方历史文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (70, 'MUS070', '桂林博物馆', '历史类', '广西壮族自治区', '桂林', '秀峰区解放西路', '吴强', '13900000070', 'museum70@qq.com', '桂林山水文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (71, 'MUS071', '柳州博物馆', '综合类', '广西壮族自治区', '柳州', '城中区文昌路', '郑辉', '13900000071', 'museum71@qq.com', '工业与民族文化结合', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (72, 'MUS072', '三亚市博物馆', '综合类', '海南省', '三亚', '吉阳区迎宾路', '谢辉', '13900000072', 'museum72@qq.com', '热带海洋文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (73, 'MUS073', '海口骑楼老街博物馆', '历史类', '海南省', '海口', '龙华区中山路', '高峰', '13900000073', 'museum73@qq.com', '骑楼文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (74, 'MUS074', '邯郸博物馆', '历史类', '河北省', '邯郸', '丛台区人民路', '孙伟', '13900000074', 'museum74@qq.com', '赵文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (75, 'MUS075', '邢台博物馆', '综合类', '河北省', '邢台', '桥东区泉北大街', '马超', '13900000075', 'museum75@qq.com', '地方文化展览', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (76, 'MUS076', '秦皇岛博物馆', '综合类', '河北省', '秦皇岛', '海港区文化路', '蒋欣', '13900000076', 'museum76@qq.com', '海港文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (77, 'MUS077', '哈尔滨工业博物馆', '工业类', '黑龙江省', '哈尔滨', '南岗区', '唐宇', '13900000077', 'museum77@qq.com', '工业发展展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (78, 'MUS078', '齐齐哈尔博物馆', '综合类', '黑龙江省', '齐齐哈尔', '龙沙区', '冯亮', '13900000078', 'museum78@qq.com', '地方文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (79, 'MUS079', '宜昌博物馆', '综合类', '湖北省', '宜昌', '西陵区发展大道', '段飞', '13900000079', 'museum79@qq.com', '三峡区域文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (80, 'MUS080', '襄阳博物馆', '历史类', '湖北省', '襄阳', '樊城区', '罗军', '13900000080', 'museum80@qq.com', '古城文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (81, 'MUS081', '株洲博物馆', '综合类', '湖南省', '株洲', '天元区', '覃伟', '13900000081', 'museum81@qq.com', '地方文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (82, 'MUS082', '岳阳博物馆', '历史类', '湖南省', '岳阳', '岳阳楼区', '符强', '13900000082', 'museum82@qq.com', '洞庭湖文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (83, 'MUS083', '常州博物馆', '综合类', '江苏省', '常州', '新北区龙城大道', '扎西', '13900000083', 'museum83@qq.com', '地方历史文化', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (84, 'MUS084', '南通博物苑', '历史类', '江苏省', '南通', '崇川区濠南路', '马龙', '13900000084', 'museum84@qq.com', '中国早期博物馆之一', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (85, 'MUS085', '镇江博物馆', '综合类', '江苏省', '镇江', '润州区伯先路', '杨帆', '13900000085', 'museum85@qq.com', '地方文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (86, 'MUS086', '九江博物馆', '历史类', '江西省', '九江', '浔阳区滨江路', '阿力', '13900000086', 'museum86@qq.com', '长江文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (87, 'MUS087', '赣州博物馆', '综合类', '江西省', '赣州', '章贡区', '赵磊', '13900000087', 'museum87@qq.com', '客家文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (88, 'MUS088', '延边博物馆', '民族类', '吉林省', '延吉', '公园路', '孙涛', '13900000088', 'museum88@qq.com', '朝鲜族文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (89, 'MUS089', '四平博物馆', '综合类', '吉林省', '四平', '铁西区', '钱峰', '13900000089', 'museum89@qq.com', '地方文化展览', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (90, 'MUS090', '锦州博物馆', '历史类', '辽宁省', '锦州', '古塔区', '周凯', '13900000090', 'museum90@qq.com', '辽西文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (91, 'MUS091', '鞍山博物馆', '综合类', '辽宁省', '鞍山', '铁东区', '林峰', '13900000091', 'museum91@qq.com', '工业与历史文化', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (92, 'MUS092', '银川当代美术馆', '艺术类', '宁夏回族自治区', '银川', '西夏区', '郑辉', '13900000092', 'museum92@qq.com', '现代艺术展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (93, 'MUS093', '固原博物馆', '历史类', '宁夏回族自治区', '固原', '原州区', '陈涛', '13900000093', 'museum93@qq.com', '西北历史文化', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (94, 'MUS094', '大同博物馆', '历史类', '山西省', '大同', '平城区', '黄强', '13900000094', 'museum94@qq.com', '北魏文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (95, 'MUS095', '临汾博物馆', '综合类', '山西省', '临汾', '尧都区', '孙建', '13900000095', 'museum95@qq.com', '晋文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (96, 'MUS096', '榆林博物馆', '历史类', '陕西省', '榆林', '榆阳区', '李涛', '13900000096', 'museum96@qq.com', '边塞文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (97, 'MUS097', '汉中博物馆', '历史类', '陕西省', '汉中', '汉台区', '王强', '13900000097', 'museum97@qq.com', '三国文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (98, 'MUS098', '日喀则博物馆', '历史类', '西藏自治区', '日喀则', '桑珠孜区', '刘伟', '13900000098', 'museum98@qq.com', '藏文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (99, 'MUS099', '昌吉博物馆', '综合类', '新疆维吾尔自治区', '昌吉', '昌吉市', '巴特尔', '13900000099', 'museum99@qq.com', '多民族文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (100, 'MUS100', '喀什博物馆', '历史类', '新疆维吾尔自治区', '喀什', '喀什市', '乌兰', '13900000100', 'museum100@qq.com', '丝路文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (101, 'MUS101', '曲靖博物馆', '综合类', '云南省', '曲靖', '麒麟区', '张军', '13900000101', 'museum101@qq.com', '地方文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (102, 'MUS102', '大理博物馆', '历史类', '云南省', '大理', '大理市', '李军', '13900000102', 'museum102@qq.com', '白族文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (103, 'MUS103', '嘉兴博物馆', '综合类', '浙江省', '嘉兴', '南湖区', '刘军', '13900000103', 'museum103@qq.com', '江南文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (104, 'MUS104', '绍兴博物馆', '历史类', '浙江省', '绍兴', '越城区', '陈军', '13900000104', 'museum104@qq.com', '越文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (105, 'MUS105', '湖州博物馆', '综合类', '浙江省', '湖州', '吴兴区', '周军', '13900000105', 'museum105@qq.com', '江南丝绸文化', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (106, 'MUS106', '衢州博物馆', '历史类', '浙江省', '衢州', '柯城区', '吴军', '13900000106', 'museum106@qq.com', '地方文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (107, 'MUS107', '丽水博物馆', '综合类', '浙江省', '丽水', '莲都区', '赵军', '13900000107', 'museum107@qq.com', '生态文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (108, 'MUS108', '舟山博物馆', '海洋类', '浙江省', '舟山', '定海区', '孙军', '13900000108', 'museum108@qq.com', '海洋文化展示', 1, '2026-04-24 20:47:58', '2026-04-24 20:47:58');
INSERT INTO `museum` VALUES (109, 'MUS109', '金华博物馆', '综合类', '浙江省', '金华', '婺城区', '钱军', '13900000109', 'museum109@qq.com', '地方文化展馆', 1, '2026-04-24 20:47:58', '2026-04-27 11:50:52');
INSERT INTO `museum` VALUES (110, 'MUS110', '台州海洋世界博物馆', '海洋类', '浙江省', '台州', '椒江区', '郑军', '13900000110', 'museum110@qq.com', '海洋生态展示', NULL, '2026-04-24 20:47:58', '2026-04-27 11:50:46');

-- ----------------------------
-- Table structure for notification_config
-- ----------------------------
DROP TABLE IF EXISTS `notification_config`;
CREATE TABLE `notification_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `notification_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知类型',
  `enabled` tinyint NOT NULL DEFAULT 1 COMMENT '是否启用：0-禁用，1-启用',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_type`(`user_id`, `notification_type`) USING BTREE,
  CONSTRAINT `notification_config_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 23 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of notification_config
-- ----------------------------
INSERT INTO `notification_config` VALUES (1, 1, 'LOAN_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (2, 1, 'LOAN_OVERDUE', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (3, 1, 'REPAIR_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (4, 4, 'LOAN_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (5, 5, 'LOAN_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (6, 10, 'LOAN_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (7, 12, 'LOAN_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (11, 2, 'LOAN_OVERDUE', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (12, 3, 'LOAN_OVERDUE', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (13, 9, 'LOAN_OVERDUE', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (14, 11, 'LOAN_OVERDUE', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (15, 14, 'LOAN_OVERDUE', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (18, 2, 'REPAIR_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (19, 3, 'REPAIR_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (20, 9, 'REPAIR_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (21, 11, 'REPAIR_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');
INSERT INTO `notification_config` VALUES (22, 14, 'REPAIR_APPLY', 1, '2026-04-24 14:42:53', '2026-04-24 14:42:53');

-- ----------------------------
-- Table structure for relic_archive
-- ----------------------------
DROP TABLE IF EXISTS `relic_archive`;
CREATE TABLE `relic_archive`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '档案ID',
  `relic_id` bigint NOT NULL COMMENT '文物ID',
  `archive_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '档案编号，如：AR-2024-001',
  `archive_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '档案标题',
  `archive_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'complete' COMMENT '档案类型：complete-完整档案/basic-基础档案/image-图片档案/document-文档档案',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '档案描述',
  `version` int NULL DEFAULT 1 COMMENT '版本号',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'draft' COMMENT '状态：draft-草稿/published-已发布/archived-已归档',
  `created_by` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `created_by_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人姓名',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `published_time` datetime NULL DEFAULT NULL COMMENT '发布时间',
  `archived_time` datetime NULL DEFAULT NULL COMMENT '归档时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `archive_code`(`archive_code`) USING BTREE,
  INDEX `idx_relic_id`(`relic_id`) USING BTREE,
  INDEX `idx_archive_code`(`archive_code`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_created_time`(`created_time`) USING BTREE,
  CONSTRAINT `relic_archive_ibfk_1` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文物档案主表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of relic_archive
-- ----------------------------
INSERT INTO `relic_archive` VALUES (1, 59, 'AR-2024-001', '商代青铜鼎完整档案', 'complete', '商代青铜鼎的完整档案，包含鉴定报告、修复记录、研究论文等全部资料', 1, 'published', 1, '张明远', '2024-01-15 10:00:00', '2026-04-24 11:30:10', '2024-01-20 14:30:00', NULL);
INSERT INTO `relic_archive` VALUES (3, 85, 'AR-2024-003', '王羲之兰亭序摹本研究档案', 'document', '王羲之兰亭序摹本的研究文档档案', 2, 'published', 1, '张明远', '2024-02-10 11:00:00', '2026-04-24 11:30:10', '2024-02-20 10:00:00', NULL);
INSERT INTO `relic_archive` VALUES (4, 28, 'AR-2024-004', '明代龙袍图片档案', 'image', '明代龙袍的高清图片档案', 1, 'archived', 2, '李婉清', '2024-03-01 10:00:00', '2026-04-24 11:30:33', '2024-03-05 15:00:00', '2024-04-01 09:00:00');
INSERT INTO `relic_archive` VALUES (5, 5, 'AR-2024-005', '曾侯乙编钟完整档案', 'complete', '曾侯乙编钟的完整档案，包含出土记录、鉴定报告、修复全过程', 3, 'published', 1, '张明远', '2024-03-10 09:30:00', '2026-04-24 11:30:10', '2024-03-28 10:00:00', NULL);
INSERT INTO `relic_archive` VALUES (6, 66, 'AR-2024-006', '宋代汝窑盘鉴定档案', 'document', '宋代汝窑盘的专业鉴定档案', 1, 'draft', 2, '李婉清', '2024-04-01 10:00:00', '2026-04-24 11:30:33', NULL, NULL);
INSERT INTO `relic_archive` VALUES (7, 13, 'AR-2024-007', '汉代石碑拓片档案', 'document', '汉代石碑的拓片及研究资料档案', 1, 'published', 1, '张明远', '2024-04-05 11:00:00', '2026-04-24 11:30:10', '2024-04-10 14:00:00', NULL);
INSERT INTO `relic_archive` VALUES (8, 78, 'AR-2024-008', '唐代青铜佛像修复档案', 'complete', '唐代青铜佛像的修复全过程档案', 2, 'published', 2, '李婉清', '2024-04-12 09:00:00', '2026-04-24 11:30:33', '2024-04-20 10:00:00', NULL);
INSERT INTO `relic_archive` VALUES (12, 5, 'AR-2026-002', '编钟保养档案', 'image', '', 1, 'draft', 2, '李婉清', '2026-04-24 12:03:25', '2026-04-24 12:03:25', NULL, NULL);
INSERT INTO `relic_archive` VALUES (13, 99, 'AR-2026-003', '元代赵孟頫行书研究档案', 'complete', '研究学习赵孟頫行书的风格与笔法', 1, 'draft', 1, '张明远', '2026-04-24 12:05:09', '2026-04-24 12:05:09', NULL, NULL);

-- ----------------------------
-- Table structure for relic_image_relation
-- ----------------------------
DROP TABLE IF EXISTS `relic_image_relation`;
CREATE TABLE `relic_image_relation`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `relic_id` bigint NOT NULL COMMENT '文物ID',
  `image_id` bigint NOT NULL COMMENT '图片ID（唯一，确保一张图片只关联一个文物）',
  `relation_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'detail' COMMENT '关联类型（main:主图, detail:详情图）',
  `is_main` tinyint NULL DEFAULT 0 COMMENT '是否为主图（1:是, 0:否）',
  `sort_order` int NULL DEFAULT 0 COMMENT '排序顺序',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_image_id`(`image_id`) USING BTREE,
  INDEX `idx_relic_id`(`relic_id`) USING BTREE,
  INDEX `idx_relation_type`(`relation_type`) USING BTREE,
  INDEX `idx_is_main`(`is_main`) USING BTREE,
  CONSTRAINT `fk_relic_image_image` FOREIGN KEY (`image_id`) REFERENCES `image_library` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_relic_image_relic` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 228 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '文物图片关联表（一对多：一个文物可以有多张图片）' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of relic_image_relation
-- ----------------------------
INSERT INTO `relic_image_relation` VALUES (2, 2, 2, 'main', 1, 1, '2026-04-23 15:33:30', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (3, 3, 3, 'main', 1, 1, '2025-01-03 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (4, 4, 4, 'main', 1, 1, '2025-01-04 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (5, 5, 5, 'main', 1, 1, '2025-01-05 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (6, 6, 6, 'main', 1, 1, '2025-01-06 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (7, 7, 7, 'main', 1, 1, '2025-01-07 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (8, 8, 8, 'main', 1, 1, '2025-01-08 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (9, 9, 9, 'main', 1, 1, '2025-01-09 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (10, 10, 10, 'main', 1, 1, '2025-01-10 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (11, 11, 11, 'main', 1, 1, '2025-01-11 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (12, 12, 12, 'main', 1, 1, '2025-01-12 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (13, 13, 13, 'main', 1, 1, '2025-01-13 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (14, 14, 14, 'main', 1, 1, '2025-01-14 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (15, 15, 15, 'main', 1, 1, '2025-01-15 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (17, 17, 17, 'main', 1, 1, '2025-01-17 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (18, 18, 18, 'main', 1, 1, '2025-01-18 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (19, 19, 19, 'main', 1, 1, '2025-01-19 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (20, 20, 20, 'main', 1, 1, '2025-01-20 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (21, 21, 21, 'main', 1, 1, '2025-01-21 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (22, 22, 22, 'main', 1, 1, '2025-01-22 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (23, 23, 23, 'main', 1, 1, '2025-01-23 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (24, 24, 24, 'main', 1, 1, '2025-01-24 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (25, 25, 25, 'main', 1, 1, '2025-01-25 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (26, 26, 26, 'main', 1, 1, '2025-01-26 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (27, 27, 27, 'main', 1, 1, '2025-01-27 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (28, 28, 28, 'main', 1, 1, '2025-01-28 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (29, 29, 29, 'main', 1, 1, '2025-01-29 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (30, 30, 30, 'main', 1, 1, '2025-01-30 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (31, 31, 31, 'main', 1, 1, '2025-01-31 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (32, 32, 32, 'main', 1, 1, '2025-02-01 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (33, 33, 33, 'main', 1, 1, '2025-02-02 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (34, 34, 34, 'main', 1, 1, '2025-02-03 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (35, 35, 35, 'main', 1, 1, '2025-02-04 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (36, 36, 36, 'main', 1, 1, '2025-02-05 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (37, 37, 37, 'main', 1, 1, '2025-02-06 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (38, 38, 38, 'main', 1, 1, '2025-02-07 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (39, 39, 39, 'main', 1, 1, '2025-02-08 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (40, 40, 40, 'main', 1, 1, '2025-02-09 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (41, 41, 41, 'main', 1, 1, '2025-02-10 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (42, 42, 42, 'main', 1, 1, '2025-02-11 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (43, 43, 43, 'main', 1, 1, '2025-02-12 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (44, 44, 44, 'main', 1, 1, '2025-02-13 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (45, 45, 45, 'main', 1, 1, '2025-02-14 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (46, 46, 46, 'main', 1, 1, '2025-02-15 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (47, 47, 47, 'main', 1, 1, '2025-02-16 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (48, 48, 48, 'main', 1, 1, '2025-02-17 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (49, 49, 49, 'main', 1, 1, '2025-02-18 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (50, 50, 50, 'main', 1, 1, '2025-02-19 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (51, 51, 51, 'main', 1, 1, '2025-02-20 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (52, 52, 52, 'main', 1, 1, '2025-02-21 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (53, 53, 53, 'main', 1, 1, '2025-02-22 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (54, 54, 54, 'main', 1, 1, '2025-02-23 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (55, 55, 55, 'main', 1, 1, '2025-02-24 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (56, 56, 56, 'main', 1, 1, '2025-02-25 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (57, 57, 57, 'main', 1, 1, '2025-02-26 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (58, 58, 58, 'main', 1, 1, '2025-02-27 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (59, 59, 59, 'main', 1, 1, '2025-02-28 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (60, 60, 60, 'main', 1, 1, '2025-03-01 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (61, 61, 61, 'main', 1, 1, '2025-03-02 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (62, 62, 62, 'main', 1, 1, '2025-03-03 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (63, 63, 63, 'main', 1, 1, '2025-03-04 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (64, 64, 64, 'main', 1, 1, '2025-03-05 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (65, 65, 65, 'main', 1, 1, '2025-03-06 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (66, 66, 66, 'main', 1, 1, '2025-03-07 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (67, 67, 67, 'main', 1, 1, '2025-03-08 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (68, 68, 68, 'main', 1, 1, '2025-03-09 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (69, 69, 69, 'main', 1, 1, '2025-03-10 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (70, 70, 70, 'main', 1, 1, '2025-03-11 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (71, 71, 71, 'main', 1, 1, '2025-03-12 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (72, 72, 72, 'main', 1, 1, '2025-03-13 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (73, 73, 73, 'main', 1, 1, '2025-03-14 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (74, 74, 74, 'main', 1, 1, '2025-03-15 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (75, 75, 75, 'main', 1, 1, '2025-03-16 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (76, 76, 76, 'main', 1, 1, '2025-03-17 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (77, 77, 77, 'main', 1, 1, '2025-03-18 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (78, 78, 78, 'main', 1, 1, '2025-03-19 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (79, 79, 79, 'main', 1, 1, '2025-03-20 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (80, 80, 80, 'main', 1, 1, '2025-03-21 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (81, 81, 81, 'main', 1, 1, '2025-03-22 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (82, 82, 82, 'main', 1, 1, '2025-03-23 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (83, 83, 83, 'main', 1, 1, '2025-03-24 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (84, 84, 84, 'main', 1, 1, '2025-03-25 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (85, 85, 85, 'main', 1, 1, '2025-03-26 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (86, 86, 86, 'main', 1, 1, '2025-03-27 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (87, 87, 87, 'main', 1, 1, '2025-03-28 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (88, 88, 88, 'main', 1, 1, '2025-03-29 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (89, 89, 89, 'main', 1, 1, '2025-03-30 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (90, 90, 90, 'main', 1, 1, '2025-03-31 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (91, 91, 91, 'main', 1, 1, '2025-04-01 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (92, 92, 92, 'main', 1, 1, '2025-04-02 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (93, 93, 93, 'main', 1, 1, '2025-04-03 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (94, 94, 94, 'main', 1, 1, '2025-04-04 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (95, 95, 95, 'main', 1, 1, '2025-04-05 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (96, 96, 96, 'main', 1, 1, '2025-04-06 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (97, 97, 97, 'main', 1, 1, '2025-04-07 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (98, 98, 98, 'main', 1, 1, '2025-04-08 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (99, 99, 99, 'main', 1, 1, '2025-04-09 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (100, 100, 100, 'main', 1, 1, '2025-04-10 10:00:00', '2026-04-23 15:54:21');
INSERT INTO `relic_image_relation` VALUES (101, 101, 101, 'main', 1, 1, '2025-04-11 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (102, 102, 102, 'main', 1, 1, '2025-04-12 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (103, 103, 103, 'main', 1, 1, '2025-04-13 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (104, 104, 104, 'main', 1, 1, '2025-04-14 10:00:00', '2026-04-23 15:54:20');
INSERT INTO `relic_image_relation` VALUES (211, 270, 105, 'main', 1, 1, '2026-04-23 16:16:55', '2026-04-23 16:16:55');
INSERT INTO `relic_image_relation` VALUES (226, 284, 120, 'main', 1, 0, '2026-05-06 20:38:10', '2026-05-06 20:38:10');
INSERT INTO `relic_image_relation` VALUES (227, 284, 121, 'detail', 0, 1, '2026-05-06 20:38:10', '2026-05-06 20:38:10');

-- ----------------------------
-- Table structure for repair_expert
-- ----------------------------
DROP TABLE IF EXISTS `repair_expert`;
CREATE TABLE `repair_expert`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expert_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '专家姓名',
  `expert_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专家编号',
  `specialty` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '专业领域',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '职称',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `work_years` int NULL DEFAULT NULL COMMENT '从业年限',
  `certification` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资质证书',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态：1启用 0禁用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `expert_code`(`expert_code`) USING BTREE,
  INDEX `idx_specialty`(`specialty`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 37 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '修复专家表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of repair_expert
-- ----------------------------
INSERT INTO `repair_expert` VALUES (1, '叶知秋', 'EXP001', '纸质文物修复', '高级修复师', '13800001001', 'expert1@museum.com', 15, '国家文物局颁发高级修复师证书', 1, NULL, '2026-04-15 16:50:20', '2026-04-18 15:23:09');
INSERT INTO `repair_expert` VALUES (2, '白露晞', 'EXP002', '金属文物修复', '高级修复师', '13800001002', 'expert2@museum.com', 12, '国家文物局颁发高级修复师证书', 1, NULL, '2026-04-15 16:50:20', '2026-04-18 15:23:09');
INSERT INTO `repair_expert` VALUES (3, '陆星河', 'EXP003', '石质文物修复', '中级修复师', '13800001003', 'expert3@museum.com', 8, '国家文物局颁发中级修复师证书', 1, NULL, '2026-04-15 16:50:20', '2026-04-18 15:23:09');
INSERT INTO `repair_expert` VALUES (4, '江晚晴', 'EXP004', '陶瓷文物修复', '高级修复师', '13800001004', 'expert4@museum.com', 18, '国家文物局颁发高级修复师证书', 1, NULL, '2026-04-15 16:50:20', '2026-04-18 15:23:09');
INSERT INTO `repair_expert` VALUES (5, '宋归远', 'EXP005', '金银器文物修复', '中级修复师', '13800001005', 'exerpt5@museum.com', 20, '国家文物局颁发中级修复师证书', 1, NULL, '2026-04-23 20:49:54', '2026-04-23 20:49:56');
INSERT INTO `repair_expert` VALUES (6, '纪南风', 'EXP00006', '青铜器文物修复', '中级修复师', '15079510236', '45132@qq.com', 10, '', 1, '', '2026-04-28 16:41:56', '2026-04-28 16:41:56');
INSERT INTO `repair_expert` VALUES (7, '司马铸', 'EXP007', '青铜器文物修复', '研究员级高级修复师', '13800001007', 'simzhu@museum.com', 25, '国家文物局颁发研究员级高级修复师证书', 1, '擅长商周青铜器修复，主持过多项国宝级青铜器修复项目', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (8, '欧阳锦', 'EXP008', '青铜器鎏金修复', '高级修复师', '13800001008', 'oyjin@museum.com', 16, '国家文物局颁发高级修复师证书', 1, '专注于青铜器表面鎏金工艺修复，技艺精湛', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (9, '钟离铭', 'EXP009', '青铜器铭文修复', '高级修复师', '13800001009', 'zlming@museum.com', 14, '国家文物局颁发高级修复师证书', 1, '精通青铜器铭文识别与修复，古文字学功底深厚', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (10, '慕容璧', 'EXP010', '玉器文物修复', '研究员级高级修复师', '13800001010', 'mrbi@museum.com', 22, '国家文物局颁发研究员级高级修复师证书', 1, '玉器修复领域权威专家，擅长各类玉器修复与鉴定', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (11, '上官琢', 'EXP011', '玉器雕刻修复', '高级修复师', '13800001011', 'sgzhuo@museum.com', 18, '国家文物局颁发高级修复师证书', 1, '精通传统玉雕技艺，擅长玉器缺损部位的补雕', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (12, '南宫润', 'EXP012', '玉器抛光修复', '中级修复师', '13800001012', 'ngrun@museum.com', 10, '国家文物局颁发中级修复师证书', 1, '专注于玉器表面抛光与保养，手法细腻', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (13, '锦绣华', 'EXP013', '丝织品文物修复', '研究员级高级修复师', '13800001013', 'jxhua@museum.com', 28, '国家文物局颁发研究员级高级修复师证书', 1, '丝织品修复领域泰斗，主持过多项重要丝织品文物修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (14, '云锦绣', 'EXP014', '云锦织物修复', '高级修复师', '13800001014', 'yjxiu@museum.com', 15, '国家文物局颁发高级修复师证书', 1, '擅长云锦、织金等高级丝织品修复，技艺传承有序', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (15, '绫罗纱', 'EXP015', '刺绣文物修复', '高级修复师', '13800001015', 'llsha@museum.com', 13, '国家文物局颁发高级修复师证书', 1, '精通各类刺绣技法，擅长刺绣文物的修复与复原', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (16, '檀木香', 'EXP016', '木质文物修复', '研究员级高级修复师', '13800001016', 'tmxiang@museum.com', 26, '国家文物局颁发研究员级高级修复师证书', 1, '木器修复领域专家，擅长各类珍贵木材文物修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (17, '梓木匠', 'EXP017', '古典家具修复', '高级修复师', '13800001017', 'zmjiang@museum.com', 20, '国家文物局颁发高级修复师证书', 1, '精通明清家具修复，对黄花梨、紫檀等名贵木材有深入研究', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (18, '楠木青', 'EXP018', '木雕文物修复', '高级修复师', '13800001018', 'nmqing@museum.com', 17, '国家文物局颁发高级修复师证书', 1, '擅长木雕造像修复，雕刻技艺精湛', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (19, '漆园生', 'EXP019', '漆器文物修复', '研究员级高级修复师', '13800001019', 'qysheng@museum.com', 24, '国家文物局颁发研究员级高级修复师证书', 1, '漆器修复领域权威，精通传统大漆工艺', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (20, '朱漆红', 'EXP020', '剔红漆器修复', '高级修复师', '13800001020', 'zqhong@museum.com', 16, '国家文物局颁发高级修复师证书', 1, '专注于剔红、剔黑等雕漆工艺修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (21, '金漆彩', 'EXP021', '彩绘漆器修复', '中级修复师', '13800001021', 'jqcai@museum.com', 11, '国家文物局颁发中级修复师证书', 1, '擅长漆器彩绘修复，色彩还原准确', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (22, '墨香斋', 'EXP022', '书画文物修复', '研究员级高级修复师', '13800001022', 'mxzhai@museum.com', 30, '国家文物局颁发研究员级高级修复师证书', 1, '书画修复大师，主持过多幅国宝级书画修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (23, '纸墨轩', 'EXP023', '古籍善本修复', '高级修复师', '13800001023', 'zmxuan@museum.com', 19, '国家文物局颁发高级修复师证书', 1, '精通古籍装裱与修复，对各朝代装裱形式有深入研究', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (24, '丹青手', 'EXP024', '壁画文物修复', '高级修复师', '13800001024', 'dqshou@museum.com', 15, '国家文物局颁发高级修复师证书', 1, '擅长壁画修复与色彩还原，参与过多处石窟壁画修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (25, '石破天', 'EXP025', '石质文物修复', '研究员级高级修复师', '13800001025', 'sptian@museum.com', 23, '国家文物局颁发研究员级高级修复师证书', 1, '石质文物修复专家，擅长各类石材文物修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (26, '岩石坚', 'EXP026', '石刻碑拓修复', '高级修复师', '13800001026', 'ysjian@museum.com', 17, '国家文物局颁发高级修复师证书', 1, '精通石刻拓片制作与修复，碑学功底深厚', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (27, '玉石琢', 'EXP027', '石雕造像修复', '高级修复师', '13800001027', 'yszhuo@museum.com', 14, '国家文物局颁发高级修复师证书', 1, '擅长佛教石雕造像修复，对各朝代造像风格有深入研究', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (28, '瓷都匠', 'EXP028', '陶瓷文物修复', '研究员级高级修复师', '13800001028', 'cdjiang@museum.com', 27, '国家文物局颁发研究员级高级修复师证书', 1, '陶瓷修复领域权威，擅长各类陶瓷器修复', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (29, '青花瓷', 'EXP029', '青花瓷器修复', '高级修复师', '13800001029', 'qhci@museum.com', 18, '国家文物局颁发高级修复师证书', 1, '专注于青花瓷修复，对元明清青花有深入研究', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (30, '釉彩师', 'EXP030', '彩瓷釉面修复', '高级修复师', '13800001030', 'ycshi@museum.com', 16, '国家文物局颁发高级修复师证书', 1, '擅长粉彩、珐琅彩等彩瓷修复，釉色还原精准', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (31, '铁匠铺', 'EXP031', '铁器文物修复', '高级修复师', '13800001031', 'tjpu@museum.com', 19, '国家文物局颁发高级修复师证书', 1, '擅长铁器文物除锈与修复，对古代冶铁工艺有深入研究', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (32, '铜镜师', 'EXP032', '铜镜文物修复', '中级修复师', '13800001032', 'tjshi@museum.com', 12, '国家文物局颁发中级修复师证书', 1, '专注于古代铜镜修复，对铜镜纹饰有深入研究', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (33, '金工巧', 'EXP033', '金属器物修复', '高级修复师', '13800001033', 'jgqiao@museum.com', 15, '国家文物局颁发高级修复师证书', 1, '精通各类金属器物修复，焊接技艺精湛', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (34, '百工师', 'EXP034', '综合文物修复', '研究员级高级修复师', '13800001034', 'bgshi@museum.com', 32, '国家文物局颁发研究员级高级修复师证书', 1, '全能型修复专家，精通多种文物修复技艺', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (35, '古物医', 'EXP035', '文物保护修复', '研究员级高级修复师', '13800001035', 'gwyi@museum.com', 29, '国家文物局颁发研究员级高级修复师证书', 1, '文物保护与修复专家，擅长文物病害诊断与治理', '2026-04-28 17:50:20', '2026-04-28 17:50:20');
INSERT INTO `repair_expert` VALUES (36, '修复堂', 'EXP036', '文物修复技术研究', '研究员', '13800001036', 'xftang@museum.com', 25, '国家文物局颁发研究员证书', 1, '文物修复技术研究专家，多项修复技术创新成果', '2026-04-28 17:50:20', '2026-04-28 17:50:20');

-- ----------------------------
-- Table structure for repair_material
-- ----------------------------
DROP TABLE IF EXISTS `repair_material`;
CREATE TABLE `repair_material`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '材料名称',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '材料编号',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '材料类别',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '单位',
  `unit_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '单价',
  `stock_quantity` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '库存数量',
  `supplier` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '供应商',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `material_code`(`material_code`) USING BTREE,
  INDEX `idx_category`(`category`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 71 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '修复材料表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of repair_material
-- ----------------------------
INSERT INTO `repair_material` VALUES (1, '环氧树脂', 'MAT001', '粘合剂', 'kg', 150.00, 50.00, '文保材料公司', '用于陶瓷、石器等文物的粘接修复', '2026-04-15 16:50:20', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (2, '化学试剂A', 'MAT002', '清洁剂', 'L', 200.00, 30.00, '化工材料公司', '用于金属文物表面清洁', '2026-04-15 16:50:20', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (3, '保护镀层材料', 'MAT003', '保护剂', 'kg', 300.00, 20.00, '文保材料公司', '用于金属文物表面保护', '2026-04-15 16:50:20', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (4, '宣纸', 'MAT004', '纸质材料', '张', 50.00, 100.00, '传统工艺公司', '用于书画类文物修复', '2026-04-15 16:50:20', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (5, '丝绸', 'MAT005', '纺织材料', 'm', 80.00, 50.00, '传统工艺公司', '用于纺织品文物修复', '2026-04-15 16:50:20', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (6, '石材修复剂', 'MAT006', '修复剂', 'kg', 180.00, 40.00, '文保材料公司', '用于石质文物的裂缝修复', '2026-04-15 16:50:20', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (7, '丙烯酸树脂', 'MAT007', '粘合剂', 'kg', 220.00, 35.00, '文保材料公司', '透明度高，适用于玻璃、陶瓷修复', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (8, '无酸纸', 'MAT008', '纸质材料', '张', 30.00, 200.00, '传统工艺公司', '用于书画装裱和修复', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (9, '天然蜂蜡', 'MAT009', '保护剂', 'kg', 120.00, 25.00, '天然材料供应商', '用于木质文物表面保护', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (10, '青铜修复膏', 'MAT010', '修复剂', 'kg', 350.00, 15.00, '文保材料公司', '专用于青铜器修复', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (11, '棉布', 'MAT011', '纺织材料', 'm', 45.00, 80.00, '传统工艺公司', '用于纺织品文物加固', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (12, '去离子水', 'MAT012', '清洁剂', 'L', 15.00, 100.00, '化工材料公司', '用于文物清洗，不含杂质', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (13, '硅胶干燥剂', 'MAT013', '保护剂', 'kg', 60.00, 50.00, '化工材料公司', '用于文物储存环境湿度控制', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (14, '金箔', 'MAT014', '装饰材料', '张', 500.00, 10.00, '传统工艺公司', '用于金属器物表面修复', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (15, '木材填充剂', 'MAT015', '修复剂', 'kg', 95.00, 45.00, '文保材料公司', '用于木质文物缺损部位填补', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (16, '中性清洁剂', 'MAT016', '清洁剂', 'L', 80.00, 60.00, '化工材料公司', 'pH值中性，适用于各类文物清洁', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (17, '聚乙烯醇', 'MAT017', '粘合剂', 'kg', 110.00, 40.00, '化工材料公司', '水溶性粘合剂，易于去除', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (18, '羊毛毡', 'MAT018', '纺织材料', 'm', 65.00, 30.00, '传统工艺公司', '用于文物包装和保护', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (19, '石膏粉', 'MAT019', '修复剂', 'kg', 25.00, 100.00, '建材供应商', '用于石质、陶瓷文物的填补', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (20, '防霉剂', 'MAT020', '保护剂', 'L', 150.00, 35.00, '化工材料公司', '用于预防文物霉变', '2026-04-28 17:21:32', '2026-04-28 17:21:32');
INSERT INTO `repair_material` VALUES (21, '青铜器清洗剂', 'MAT021', '清洁剂', 'L', 280.00, 25.00, '文保材料公司', '专用于青铜器表面锈蚀清洗，不损伤器物本体', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (22, '青铜器缓蚀剂', 'MAT022', '保护剂', 'kg', 320.00, 18.00, '文保材料公司', '用于青铜器表面防锈保护，延缓氧化进程', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (23, '青铜焊接材料', 'MAT023', '修复剂', 'kg', 450.00, 12.00, '文保材料公司', '用于青铜器裂缝和断裂部位的焊接修复', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (24, '青铜器封护剂', 'MAT024', '保护剂', 'L', 380.00, 20.00, '文保材料公司', '青铜器修复后的表面封护，防止二次氧化', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (25, '青铜器做旧材料', 'MAT025', '装饰材料', 'kg', 200.00, 15.00, '文保材料公司', '用于修复部位的色泽调整，使其与原器物协调', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (26, '石质文物清洗液', 'MAT026', '清洁剂', 'L', 180.00, 34.00, '文保材料公司', '温和清洗石质文物表面污渍，不损伤石材', '2026-04-28 17:29:51', '2026-04-28 23:12:47');
INSERT INTO `repair_material` VALUES (27, '石材加固剂', 'MAT027', '保护剂', 'L', 350.00, 22.00, '文保材料公司', '用于风化石材的加固处理，提高强度', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (28, '石材裂缝修补剂', 'MAT028', '修复剂', 'kg', 280.00, 28.00, '文保材料公司', '专用于石质文物裂缝填补，粘接力强', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (29, '石材防水剂', 'MAT029', '保护剂', 'L', 220.00, 30.00, '文保材料公司', '石质文物表面防水处理，防止水分侵蚀', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (30, '石材色差调整剂', 'MAT030', '装饰材料', 'kg', 260.00, 18.00, '文保材料公司', '用于修复部位与原石材的色泽协调', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (31, '陶瓷器清洗剂', 'MAT031', '清洁剂', 'L', 150.00, 40.00, '文保材料公司', '温和清洗陶瓷器表面污渍，保护釉面', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (32, '陶瓷粘接剂', 'MAT032', '粘合剂', 'kg', 280.00, 29.00, '文保材料公司', '专用于陶瓷器碎片粘接，粘接力强且可逆', '2026-04-28 17:29:51', '2026-04-29 22:58:12');
INSERT INTO `repair_material` VALUES (33, '陶瓷补缺材料', 'MAT033', '修复剂', 'kg', 320.00, 25.00, '文保材料公司', '用于陶瓷器缺损部位的填补，可塑性好', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (34, '陶瓷釉面修复剂', 'MAT034', '装饰材料', 'kg', 380.00, 15.00, '文保材料公司', '用于陶瓷器釉面修复，恢复原有光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (35, '陶瓷器封护蜡', 'MAT035', '保护剂', 'kg', 180.00, 28.00, '文保材料公司', '陶瓷器修复后的表面保护，增加光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (36, '纸质文物清洗液', 'MAT036', '清洁剂', 'L', 120.00, 45.00, '文保材料公司', '温和清洗纸质文物污渍，不损伤纸张纤维', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (37, '纸张加固剂', 'MAT037', '保护剂', 'L', 200.00, 35.00, '文保材料公司', '用于脆弱纸张的加固处理，提高强度', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (38, '纸张修补浆料', 'MAT038', '修复剂', 'kg', 150.00, 40.00, '传统工艺公司', '用于纸质文物破损部位的修补，纤维匹配', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (39, '纸张脱酸剂', 'MAT039', '保护剂', 'L', 180.00, 30.00, '文保材料公司', '中和纸张酸性，延缓老化进程', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (40, '装裱用浆糊', 'MAT040', '粘合剂', 'kg', 80.00, 50.00, '传统工艺公司', '传统装裱用浆糊，粘性适中且可逆', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (41, '玉器清洗液', 'MAT041', '清洁剂', 'L', 200.00, 30.00, '文保材料公司', '温和清洗玉器表面污渍，不损伤玉质', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (42, '玉器粘接剂', 'MAT042', '粘合剂', 'kg', 350.00, 20.00, '文保材料公司', '专用于玉器碎片粘接，透明度高', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (43, '玉器抛光膏', 'MAT043', '装饰材料', 'kg', 280.00, 22.00, '文保材料公司', '用于玉器表面抛光，恢复原有光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (44, '玉器补缺材料', 'MAT044', '修复剂', 'kg', 420.00, 15.00, '文保材料公司', '用于玉器缺损部位填补，硬度匹配', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (45, '玉器保养油', 'MAT045', '保护剂', 'L', 150.00, 25.00, '天然材料供应商', '玉器日常保养用油，保持润泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (46, '贵金属清洗液', 'MAT046', '清洁剂', 'L', 250.00, 28.00, '文保材料公司', '专用于金银器清洗，温和不损伤', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (47, '金银器抛光剂', 'MAT047', '装饰材料', 'kg', 300.00, 20.00, '文保材料公司', '用于金银器表面抛光，恢复光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (48, '银器防氧化剂', 'MAT048', '保护剂', 'L', 220.00, 25.00, '文保材料公司', '防止银器氧化变黑，长期保护', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (49, '金属焊接材料', 'MAT049', '修复剂', 'kg', 500.00, 10.00, '文保材料公司', '用于金银器裂缝和断裂修复', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (50, '鎏金修复材料', 'MAT050', '装饰材料', 'g', 800.00, 5.00, '文保材料公司', '用于鎏金器物表面修复，恢复金色', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (51, '丝织品清洗剂', 'MAT051', '清洁剂', 'L', 180.00, 35.00, '文保材料公司', '温和清洗丝织品，不损伤纤维', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (52, '丝织品加固剂', 'MAT052', '保护剂', 'L', 250.00, 28.00, '文保材料公司', '用于脆弱丝织品的加固处理', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (53, '丝线（多色）', 'MAT053', '纺织材料', 'g', 120.00, 100.00, '传统工艺公司', '用于丝织品修补，多种颜色可选', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (54, '织物修补网', 'MAT054', '纺织材料', 'm', 90.00, 40.00, '传统工艺公司', '用于丝织品背面加固，透气性好', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (55, '丝织品防虫剂', 'MAT055', '保护剂', 'L', 160.00, 30.00, '化工材料公司', '防止丝织品虫蛀，安全无毒', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (56, '木材清洁剂', 'MAT056', '清洁剂', 'L', 100.00, 50.00, '文保材料公司', '温和清洁木质文物表面污渍', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (57, '木材防腐剂', 'MAT057', '保护剂', 'L', 180.00, 40.00, '文保材料公司', '防止木材腐朽和虫蛀，延长寿命', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (58, '木材加固剂', 'MAT058', '保护剂', 'L', 220.00, 35.00, '文保材料公司', '用于糟朽木材的加固处理', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (59, '木材修补腻子', 'MAT059', '修复剂', 'kg', 150.00, 45.00, '文保材料公司', '用于木质文物缺损填补，可调色', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (60, '木材保养蜡', 'MAT060', '保护剂', 'kg', 130.00, 38.00, '天然材料供应商', '木质文物日常保养，保持光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (61, '漆器清洗液', 'MAT061', '清洁剂', 'L', 160.00, 32.00, '文保材料公司', '温和清洗漆器表面，不损伤漆层', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (62, '天然大漆', 'MAT062', '修复剂', 'kg', 500.00, 15.00, '传统工艺公司', '用于漆器修复，传统天然材料', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (63, '漆器补缺材料', 'MAT063', '修复剂', 'kg', 280.00, 20.00, '文保材料公司', '用于漆器缺损部位填补', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (64, '漆器抛光材料', 'MAT064', '装饰材料', 'kg', 180.00, 25.00, '传统工艺公司', '用于漆器表面抛光，恢复光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (65, '漆器保护蜡', 'MAT065', '保护剂', 'kg', 150.00, 28.00, '天然材料供应商', '漆器表面保护，防止干裂', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (66, '铜器除锈剂', 'MAT066', '清洁剂', 'L', 180.00, 35.00, '化工材料公司', '去除铜器表面锈蚀，温和有效', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (67, '铜器抛光膏', 'MAT067', '装饰材料', 'kg', 150.00, 30.00, '化工材料公司', '用于铜器表面抛光，恢复光泽', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (68, '铜器防锈油', 'MAT068', '保护剂', 'L', 120.00, 40.00, '化工材料公司', '铜器表面防锈保护，长期有效', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (69, '铜器焊接材料', 'MAT069', '修复剂', 'kg', 280.00, 20.00, '文保材料公司', '用于铜器裂缝和断裂修复', '2026-04-28 17:29:51', '2026-04-28 17:29:51');
INSERT INTO `repair_material` VALUES (70, '铜器做旧液', 'MAT070', '装饰材料', 'L', 200.00, 22.00, '文保材料公司', '用于修复部位的色泽调整', '2026-04-28 17:29:51', '2026-04-28 17:29:51');

-- ----------------------------
-- Table structure for repair_record
-- ----------------------------
DROP TABLE IF EXISTS `repair_record`;
CREATE TABLE `repair_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `repair_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修复编号',
  `relic_id` bigint NOT NULL COMMENT '文物ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '待审批' COMMENT '状态：待审批、待修复、修复中、修复完成、已拒绝',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '普通' COMMENT '优先级：紧急、高、普通、低',
  `applicant_id` bigint NULL DEFAULT NULL COMMENT '申请人ID',
  `apply_date` datetime NULL DEFAULT NULL COMMENT '申请日期',
  `repair_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修复原因',
  `damage_description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '损坏描述',
  `estimated_cost` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '预算费用',
  `approver` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批人',
  `approve_date` datetime NULL DEFAULT NULL COMMENT '审批日期',
  `approve_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '审批意见',
  `repair_expert` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修复专家',
  `start_date` datetime NULL DEFAULT NULL COMMENT '开始修复日期',
  `complete_date` datetime NULL DEFAULT NULL COMMENT '完成日期',
  `repair_process` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '修复过程',
  `repair_method` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '修复方法',
  `actual_cost` decimal(10, 2) NULL DEFAULT 0.00 COMMENT '实际费用',
  `before_images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修复前照片（多张，逗号分隔）',
  `after_images` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '修复后照片（多张，逗号分隔）',
  `quality_score` int NULL DEFAULT 0 COMMENT '质量评分（0-100）',
  `quality_remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '质量评估意见',
  `remark` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_repair_code`(`repair_code`) USING BTREE,
  INDEX `idx_relic_id`(`relic_id`) USING BTREE,
  INDEX `idx_status`(`status`) USING BTREE,
  INDEX `idx_apply_date`(`apply_date`) USING BTREE,
  INDEX `idx_repair_expert`(`repair_expert`) USING BTREE,
  INDEX `idx_applicant_id`(`applicant_id`) USING BTREE,
  CONSTRAINT `fk_repair_applicant` FOREIGN KEY (`applicant_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `fk_repair_relic` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '修复记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of repair_record
-- ----------------------------
INSERT INTO `repair_record` VALUES (1, 'REP2026001', 8, '修复完成', '高', 2, '2026-02-25 09:00:00', '表面氧化严重', '银壶表面出现大面积氧化层，局部有腐蚀斑点，影响观赏价值', 2500.00, NULL, NULL, NULL, '修复师乙', '2026-03-01 09:00:00', '2026-03-05 16:00:00', '1. 表面清洁 2. 化学稳定处理 3. 镀层保护 4. 抛光处理', '采用化学还原法去除氧化层，使用保护性镀层防止再次氧化', 2500.00, '/uploads/repair/before_8_1.jpg,/uploads/repair/before_8_2.jpg', '/uploads/repair/after_8_1.jpg,/uploads/repair/after_8_2.jpg', 95, '修复效果优秀，表面光洁度恢复良好，保护层均匀', '修复过程顺利，未发现其他隐藏损伤', '2026-04-15 16:50:26', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (2, 'REP2026002', 5, '修复中', '紧急', 2, '2026-02-08 10:00:00', '纸本边缘磨损', '书法作品边缘出现磨损和撕裂，需要加固处理', 1200.00, NULL, NULL, NULL, '修复师甲', '2026-02-12 10:00:00', NULL, '正在进行纤维修补和边缘加固', '使用传统装裱技术进行纸张加固和边缘修补', 0.00, '/uploads/repair/before_5_1.jpg,/uploads/repair/before_5_2.jpg', NULL, 0, NULL, '需要特别注意墨迹保护，避免水分渗透', '2026-04-15 16:50:26', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (3, 'REP2026003', 12, '待修复', '普通', 2, '2026-03-15 11:00:00', '石雕裂隙扩大', '观音像底座出现裂纹，有扩大趋势，需要及时处理', 3000.00, NULL, NULL, NULL, '修复师丙', NULL, NULL, NULL, '计划采用环氧树脂填补裂缝，并进行结构加固', 0.00, '/uploads/repair/before_12_1.jpg', NULL, 0, NULL, '已通过审批，等待修复师档期安排', '2026-04-15 16:50:26', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (4, 'REP2026004', 2, '待审批', '普通', 2, '2026-04-10 14:00:00', '剑身锈蚀处理', '青铜剑剑身出现锈蚀点，需要进行除锈和防护处理', 900.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, '/uploads/repair/before_2_1.jpg', NULL, 0, NULL, '等待审批', '2026-04-15 16:50:26', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (5, 'REP2026005', 3, '已拒绝', '低', 2, '2026-04-05 09:30:00', '釉面细微裂纹', '唐三彩马釉面有细微裂纹', 1500.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, '/uploads/repair/before_3_1.jpg', NULL, 0, NULL, '审批意见：裂纹属于自然老化现象，不影响文物价值，暂不需要修复', '2026-04-15 16:50:26', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (7, 'REP2026007', 5, '已拒绝', '普通', 2, NULL, '鎏金脱落', NULL, 3500.00, 'chen', '2026-04-29 22:06:01', '', '修复专家王工', '2024-02-20 10:00:00', NULL, '鎏金修复，表面加固处理', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-02-20 17:00:00', '2026-04-29 22:06:00');
INSERT INTO `repair_record` VALUES (8, 'REP2026008', 15, '待审批', '普通', 2, NULL, '纸张老化', NULL, 2800.00, NULL, NULL, NULL, '修复专家张工', '2024-04-01 11:00:00', NULL, '脱酸处理，边缘加固', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-04-01 18:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (9, 'REP2026009', 25, '待审批', '普通', 2, NULL, '银器氧化', NULL, 2200.00, NULL, NULL, NULL, '修复专家赵工', '2024-04-20 09:00:00', NULL, '化学清洗，防氧化处理', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-04-20 16:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (10, 'REP2026010', 38, '待审批', '普通', 2, NULL, '织物破损', NULL, 4500.00, NULL, NULL, NULL, '修复专家刘工', '2024-05-05 10:00:00', NULL, '织物修补，防虫处理', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-05-05 17:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (11, 'REP2026011', 11, '待审批', '普通', 2, NULL, '釉面细裂', NULL, 1800.00, NULL, NULL, NULL, '修复专家陈工', '2024-03-15 11:00:00', NULL, '显微加固处理', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-03-15 18:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (12, 'REP2026012', 30, '待审批', '普通', 2, NULL, '碑文模糊', NULL, 3200.00, NULL, NULL, NULL, '修复专家周工', '2024-04-25 09:00:00', NULL, '表面清洁，文字加固', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-04-25 16:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (13, 'REP2026013', 43, '待审批', '普通', 2, NULL, '彩绘脱落', NULL, 2600.00, NULL, NULL, NULL, '修复专家吴工', '2024-05-10 10:00:00', NULL, '彩绘修复，表面保护', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-05-10 17:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (14, 'REP2026014', 48, '待审批', '普通', 2, NULL, '漆层剥落', NULL, 2100.00, NULL, NULL, NULL, '修复专家郑工', '2024-05-20 11:00:00', NULL, '漆层修补，表面加固', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-05-20 18:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (15, 'REP2026015', 46, '待审批', '普通', 2, NULL, '木材开裂', NULL, 5500.00, NULL, NULL, NULL, '修复专家孙工', '2024-05-15 09:00:00', NULL, '裂缝填补，结构加固', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2024-05-15 16:00:00', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (16, 'REP2026016', 68, '修复中', '高', 2, '2026-04-23 20:52:40', '银壶氧化', '银壶氧化变黑', 250.00, 'admin', '2026-04-23 20:53:11', '', '宋归远', '2026-04-23 20:54:56', NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-23 20:52:40', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (17, 'REP2026017', 3, '修复中', '紧急', 2, '2026-04-23 20:56:03', '佛身破损', '佛身破损', 1000.00, 'admin', '2026-04-23 20:56:11', '', '陆星河', '2026-04-23 20:58:00', NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-23 20:56:03', '2026-04-24 16:30:28');
INSERT INTO `repair_record` VALUES (18, 'REP2026018', 7, '待审批', '普通', 1, '2026-04-28 17:40:50', '鼎身破损', '大禹鼎鼎身出现裂痕', 0.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-28 17:40:49', '2026-04-28 17:40:49');
INSERT INTO `repair_record` VALUES (19, 'REP2026019', 56, '待审批', '普通', 1, '2026-04-28 17:53:42', '瓶身氧化', '瓶身表面氧化变色', 810.00, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-28 17:53:42', '2026-04-28 17:53:42');
INSERT INTO `repair_record` VALUES (21, 'REP202604280625', 6, '待修复', '普通', 2, '2026-04-23 20:55:32', '表面污渍需要清理', '长期展出导致表面有污渍，需要专业清理', 3000.00, 'admin', '2026-04-24 20:55:32', '同意修复，安排专家处理', '张三', NULL, NULL, NULL, NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2026-04-28 20:55:32', '2026-04-28 21:17:16');
INSERT INTO `repair_record` VALUES (22, 'REP202604282896', 7, '修复中', '紧急', 2, '2026-04-18 20:55:32', '严重损坏需要紧急修复', '多处破损，包括边缘碎裂和表面剥落，需要全面修复', 8000.00, 'admin', '2026-04-19 20:55:32', '同意紧急修复', '李四', '2026-04-20 20:55:32', NULL, '已完成初步清理和评估，正在进行裂纹修复，预计还需3天完成', NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2026-04-28 20:55:32', '2026-04-28 21:17:16');
INSERT INTO `repair_record` VALUES (23, 'REP202604282605', 8, '修复完成', '普通', 2, '2026-04-08 20:55:32', '轻微损坏需要修复', '表面有轻微磨损和划痕', 3000.00, 'admin', '2026-04-09 20:55:32', '同意修复', '王五', '2026-04-10 20:55:32', '2026-04-26 20:55:32', '清理、修复、加固、封护', '采用传统工艺进行修复，使用天然材料', 2800.00, NULL, NULL, 95, '修复效果良好，文物状态恢复到理想水平', NULL, '2026-04-28 20:55:32', '2026-04-28 21:17:16');
INSERT INTO `repair_record` VALUES (24, 'REP202604284336', 11, '已拒绝', '低', 2, '2026-04-25 20:55:32', '需要修复', '有轻微损坏', 2000.00, 'admin', '2026-04-26 20:55:32', '经评估，损坏程度不足以进行修复，建议继续观察。如果损坏加重，可重新申请。', NULL, NULL, NULL, NULL, NULL, 0.00, NULL, NULL, 0, NULL, NULL, '2026-04-28 20:55:32', '2026-04-28 21:17:16');
INSERT INTO `repair_record` VALUES (25, 'REP202604283867', 13, '已拒绝', '普通', 2, '2026-04-28 20:55:32', '需要进行保养性修复', '文物保存时间较长，需要进行预防性保护', 180.00, 'chen', '2026-04-29 23:23:32', '', '', NULL, NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-28 20:55:32', '2026-04-29 23:23:32');
INSERT INTO `repair_record` VALUES (26, 'REP2026428', 270, '已拒绝', '普通', 2, '2026-04-29 22:26:39', '兵马俑破损', '兵马俑群有部分破损', 280.00, 'chen', '2026-04-29 23:22:51', '', NULL, NULL, NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-29 22:26:39', '2026-04-29 23:22:51');
INSERT INTO `repair_record` VALUES (27, 'REP2026428', 102, '待修复', '普通', 2, '2026-04-29 22:27:37', '保养', '保养玉璧防氧化', 150.00, 'chen', '2026-04-29 22:35:41', '', '南宫润', NULL, NULL, NULL, NULL, 0.00, '', NULL, 0, NULL, '', '2026-04-29 22:27:36', '2026-04-29 22:35:41');

-- ----------------------------
-- Table structure for repair_record_material
-- ----------------------------
DROP TABLE IF EXISTS `repair_record_material`;
CREATE TABLE `repair_record_material`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `repair_record_id` bigint NOT NULL COMMENT '修复记录ID',
  `material_id` bigint NOT NULL COMMENT '材料ID',
  `quantity` decimal(10, 2) NOT NULL COMMENT '使用数量',
  `unit_price` decimal(10, 2) NOT NULL COMMENT '单价',
  `total_price` decimal(10, 2) NOT NULL COMMENT '总价',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_repair_record_id`(`repair_record_id`) USING BTREE,
  INDEX `idx_material_id`(`material_id`) USING BTREE,
  CONSTRAINT `fk_rrm_material` FOREIGN KEY (`material_id`) REFERENCES `repair_material` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_rrm_repair_record` FOREIGN KEY (`repair_record_id`) REFERENCES `repair_record` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '修复记录材料关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of repair_record_material
-- ----------------------------
INSERT INTO `repair_record_material` VALUES (1, 1, 22, 2.50, 320.00, 800.00, '用于陶瓷粘合', '2026-04-15 10:30:00');
INSERT INTO `repair_record_material` VALUES (2, 2, 21, 5.00, 280.00, 1400.00, '用于表面修复', '2026-04-15 10:30:00');
INSERT INTO `repair_record_material` VALUES (3, 3, 10, 1.00, 350.00, 350.00, '清洁处理', '2026-04-16 14:20:00');
INSERT INTO `repair_record_material` VALUES (4, 4, 27, 0.50, 350.00, 175.00, '表面保护', '2026-04-16 14:20:00');
INSERT INTO `repair_record_material` VALUES (5, 5, 30, 3.00, 260.00, 780.00, '纺织品修复', '2026-04-18 09:15:00');
INSERT INTO `repair_record_material` VALUES (7, 7, 24, 2.50, 380.00, 950.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (8, 8, 42, 5.00, 350.00, 1750.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (9, 9, 53, 1.00, 120.00, 120.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (10, 10, 5, 0.50, 80.00, 40.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (11, 11, 63, 3.00, 280.00, 840.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (12, 12, 34, 1.50, 380.00, 570.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (13, 13, 45, 2.50, 150.00, 375.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (14, 14, 68, 5.00, 120.00, 600.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (15, 15, 57, 1.00, 180.00, 180.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (16, 16, 48, 0.50, 220.00, 110.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (17, 17, 6, 3.00, 180.00, 540.00, NULL, '2026-04-27 22:47:21');
INSERT INTO `repair_record_material` VALUES (18, 25, 26, 1.00, 180.00, 180.00, '', '2026-04-28 23:12:47');
INSERT INTO `repair_record_material` VALUES (19, 26, 32, 1.00, 280.00, 280.00, '', '2026-04-29 22:58:12');

-- ----------------------------
-- Table structure for sys_backup
-- ----------------------------
DROP TABLE IF EXISTS `sys_backup`;
CREATE TABLE `sys_backup`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '备份ID',
  `backup_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备份名称',
  `backup_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备份类型：manual-手动, auto-自动',
  `backup_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'processing' COMMENT '备份状态：processing-处理中, success-成功, failed-失败',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备份文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备份文件路径',
  `file_size` bigint NULL DEFAULT 0 COMMENT '文件大小（字节）',
  `is_encrypted` tinyint(1) NULL DEFAULT 0 COMMENT '是否加密：0-否, 1-是',
  `backup_tables` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备份的表列表（JSON数组）',
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备份描述',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` tinyint(1) NULL DEFAULT 0 COMMENT '是否删除：0-否, 1-是',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_backup_type`(`backup_type`) USING BTREE,
  INDEX `idx_backup_status`(`backup_status`) USING BTREE,
  INDEX `idx_created_time`(`created_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统备份记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_backup
-- ----------------------------
INSERT INTO `sys_backup` VALUES (1, '系统上线前备份', 'manual', 'success', 'backup_20260420_100000.sql', 'backups/backup_20260420_100000.sql', 15728640, 0, NULL, '系统正式上线前的完整备份', NULL, '张明远', '2026-04-20 10:00:00', 1);
INSERT INTO `sys_backup` VALUES (2, '每日自动备份-20260421', 'auto', 'success', 'backup_20260421_020000.sql', 'backups/backup_20260421_020000.sql', 16777216, 0, NULL, '系统自动执行的每日备份', NULL, '张明远', '2026-04-21 02:00:00', 1);
INSERT INTO `sys_backup` VALUES (3, '重要数据加密备份', 'manual', 'success', 'backup_20260422_150000.sql', 'backups/backup_20260422_150000.sql', 18874368, 1, NULL, '包含敏感数据的加密备份', NULL, '张明远', '2026-04-22 15:00:00', 0);
INSERT INTO `sys_backup` VALUES (4, '失败的备份任务', 'auto', 'failed', 'backup_20260423_020000.sql', 'backups/backup_20260423_020000.sql', 0, 0, NULL, '由于磁盘空间不足导致备份失败', 'mysqldump: Error: No space left on device when writing to file', '张明远', '2026-04-23 02:00:00', 1);
INSERT INTO `sys_backup` VALUES (5, '权限错误的备份', 'manual', 'failed', 'backup_20260424_100000.sql', 'backups/backup_20260424_100000.sql', 0, 0, NULL, '测试备份权限', 'mysqldump: Got error: 1044: Access denied for user', '张明远', '2026-04-24 10:00:00', 0);
INSERT INTO `sys_backup` VALUES (6, '每日自动备份-20260426', 'auto', 'success', 'backup_20260426_020000.sql', 'backups/backup_20260426_020000.sql', 20971520, 0, NULL, '系统自动执行的每日备份', NULL, '张明远', '2026-04-26 02:00:00', 1);
INSERT INTO `sys_backup` VALUES (7, '数据迁移前备份', 'manual', 'success', 'backup_20260427_080000.sql', 'backups/backup_20260427_080000.sql', 22020096, 0, NULL, '执行数据迁移操作前的安全备份', NULL, '张明远', '2026-04-27 08:00:00', 0);
INSERT INTO `sys_backup` VALUES (8, '正在执行的备份', 'manual', 'processing', 'backup_20260427_210000.sql', 'backups/backup_20260427_210000.sql', 0, 0, NULL, '当前正在执行的备份任务', NULL, '张明远', '2026-04-27 21:00:00', 1);
INSERT INTO `sys_backup` VALUES (9, '重要数据备份', 'manual', 'success', 'backup_20260509_143608.sql', 'backups\\backup_20260509_143608.sql', 517492, 0, NULL, '', NULL, '张明远', '2026-05-09 14:36:09', 1);
INSERT INTO `sys_backup` VALUES (10, '数据备份', 'manual', 'success', 'backup_20260509_145118.sql', 'backups\\backup_20260509_145118.sql', 537759, 0, NULL, '', NULL, '张明远', '2026-05-09 14:51:19', 0);
INSERT INTO `sys_backup` VALUES (11, '备份', 'manual', 'success', 'backup_20260509_150136.sql', 'backups\\backup_20260509_150136.sql', 539969, 0, NULL, '', NULL, '张明远', '2026-05-09 15:01:36', 0);
INSERT INTO `sys_backup` VALUES (12, '测试备份', 'manual', 'success', 'backup_20260509_150233.sql', 'backups\\backup_20260509_150233.sql', 540366, 0, NULL, '', NULL, '张明远', '2026-05-09 15:02:33', 0);
INSERT INTO `sys_backup` VALUES (13, '每日自动备份 - 2026-05-11 12:00', 'auto', 'success', 'backup_20260511_120000.sql', 'backups\\backup_20260511_120000.sql', 611294, 0, NULL, '自动备份 - daily', NULL, '系统', '2026-05-11 12:00:00', 1);
INSERT INTO `sys_backup` VALUES (14, '备份测试', 'manual', 'failed', 'backup_20260513_122541.sql', 'backups\\backup_20260513_122541.sql', 617583, 1, NULL, '', 'Java原生备份失败: Invalid AES key length: 27 bytes', '张明远', '2026-05-13 12:25:41', 0);
INSERT INTO `sys_backup` VALUES (15, '1', 'manual', 'failed', 'backup_20260513_122807.sql', 'backups\\backup_20260513_122807.sql', 618431, 1, NULL, '', 'Java原生备份失败: Invalid AES key length: 27 bytes', '张明远', '2026-05-13 12:28:08', 0);
INSERT INTO `sys_backup` VALUES (16, '1', 'manual', 'failed', 'backup_20260513_123055.sql', 'backups\\backup_20260513_123055.sql', 618869, 1, NULL, '', 'Java原生备份失败: Invalid AES key length: 27 bytes', '张明远', '2026-05-13 12:30:55', 0);
INSERT INTO `sys_backup` VALUES (17, '1', 'manual', 'failed', 'backup_20260513_123129.sql', 'backups\\backup_20260513_123129.sql', 619301, 1, NULL, '', 'Java原生备份失败: Invalid AES key length: 31 bytes', '张明远', '2026-05-13 12:31:29', 0);
INSERT INTO `sys_backup` VALUES (18, '2', 'manual', 'failed', 'backup_20260513_123256.sql', 'backups\\backup_20260513_123256.sql', 619739, 1, NULL, '', 'Java原生备份失败: Invalid AES key length: 31 bytes', '张明远', '2026-05-13 12:32:56', 0);
INSERT INTO `sys_backup` VALUES (19, '12', 'manual', 'success', 'backup_20260513_124851.sql', 'backups\\backup_20260513_124851.sql', 620179, 0, NULL, '', NULL, '张明远', '2026-05-13 12:48:52', 0);
INSERT INTO `sys_backup` VALUES (20, '3', 'manual', 'failed', 'backup_20260513_124925.sql', 'backups\\backup_20260513_124925.sql', 620564, 1, NULL, '', 'Java原生备份失败: Invalid AES key length: 31 bytes', '张明远', '2026-05-13 12:49:25', 0);
INSERT INTO `sys_backup` VALUES (21, '1', 'manual', 'failed', 'backup_20260513_125120.sql', 'backups\\backup_20260513_125120.sql', 621002, 1, NULL, '', 'Java原生备份失败: Illegal key size or default parameters', '张明远', '2026-05-13 12:51:21', 0);
INSERT INTO `sys_backup` VALUES (22, '1', 'manual', 'success', 'backup_20260513_125315.sql', 'backups\\backup_20260513_125315.sql', 621456, 1, NULL, '', NULL, '张明远', '2026-05-13 12:53:15', 0);
INSERT INTO `sys_backup` VALUES (23, '每日自动备份 - 2026-05-15 20:00', 'auto', 'success', 'backup_20260515_200000.sql', 'backups\\backup_20260515_200000.sql', 658758, 0, NULL, '自动备份 - daily', NULL, '系统', '2026-05-15 20:00:00', 0);
INSERT INTO `sys_backup` VALUES (24, '每日自动备份 - 2026-05-17 20:00', 'auto', 'success', 'backup_20260517_200000.sql', 'backups\\backup_20260517_200000.sql', 660420, 0, NULL, '自动备份 - daily', NULL, '系统', '2026-05-17 20:00:00', 0);
INSERT INTO `sys_backup` VALUES (25, '每日自动备份 - 2026-06-14 20:00', 'auto', 'success', 'backup_20260614_200000.sql', 'backups\\backup_20260614_200000.sql', 623207, 0, NULL, '自动备份 - daily', NULL, '系统', '2026-06-14 20:00:00', 0);

-- ----------------------------
-- Table structure for sys_backup_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_backup_config`;
CREATE TABLE `sys_backup_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置名称',
  `is_enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用：0-否, 1-是',
  `backup_frequency` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备份频率：daily-每天, weekly-每周, monthly-每月',
  `backup_time` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备份时间（HH:mm）',
  `retention_days` int NULL DEFAULT 30 COMMENT '保留天数',
  `max_backup_count` int NULL DEFAULT 10 COMMENT '最大备份数量',
  `is_encrypted` tinyint(1) NULL DEFAULT 0 COMMENT '是否加密：0-否, 1-是',
  `backup_tables` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备份的表列表（JSON数组，为空则备份全部）',
  `notification_enabled` tinyint(1) NULL DEFAULT 1 COMMENT '是否启用通知：0-否, 1-是',
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '创建人',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '更新人',
  `updated_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '备份配置表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_backup_config
-- ----------------------------
INSERT INTO `sys_backup_config` VALUES (1, '默认自动备份配置', 1, 'daily', '20:00', 30, 10, 0, NULL, 1, 'system', '2026-04-27 21:08:59', NULL, '2026-05-11 14:49:22');
INSERT INTO `sys_backup_config` VALUES (2, '默认自动备份配置', 1, 'daily', '02:00', 30, 10, 0, NULL, 1, 'admin', '2026-04-20 10:00:00', NULL, '2026-04-27 21:34:31');
INSERT INTO `sys_backup_config` VALUES (3, '每周备份配置', 0, 'weekly', '03:00', 90, 20, 1, NULL, 1, 'admin', '2026-04-21 14:30:00', NULL, '2026-04-27 21:34:31');

-- ----------------------------
-- Table structure for sys_data_change_detail
-- ----------------------------
DROP TABLE IF EXISTS `sys_data_change_detail`;
CREATE TABLE `sys_data_change_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `log_id` bigint NOT NULL COMMENT '操作日志ID',
  `field_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字段名称',
  `field_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字段标签（中文名）',
  `old_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '旧值',
  `new_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '新值',
  `value_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '值类型：STRING, NUMBER, DATE, BOOLEAN, JSON',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_log_id`(`log_id`) USING BTREE,
  CONSTRAINT `sys_data_change_detail_ibfk_1` FOREIGN KEY (`log_id`) REFERENCES `sys_operation_log` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据变更详情表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_data_change_detail
-- ----------------------------
INSERT INTO `sys_data_change_detail` VALUES (1, 771, 'status', '状态', '正常', '维护中', 'STRING', '2026-04-28 13:51:32');
INSERT INTO `sys_data_change_detail` VALUES (2, 771, 'location', '位置', '展厅A-001', '修复室-101', 'STRING', '2026-04-28 13:51:32');
INSERT INTO `sys_data_change_detail` VALUES (3, 777, 'status', '状态', '正常', '维护中', 'STRING', '2026-04-28 14:31:50');
INSERT INTO `sys_data_change_detail` VALUES (4, 777, 'location', '位置', '展厅A-001', '修复室-101', 'STRING', '2026-04-28 14:31:50');
INSERT INTO `sys_data_change_detail` VALUES (5, 778, 'status', '状态', '正常', '维护中', 'STRING', '2026-04-28 14:35:05');
INSERT INTO `sys_data_change_detail` VALUES (6, 778, 'location', '位置', '展厅A-001', '修复室-101', 'STRING', '2026-04-28 14:35:05');
INSERT INTO `sys_data_change_detail` VALUES (7, 782, 'status', '状态', '正常', '维护中', 'STRING', '2026-04-28 16:18:00');
INSERT INTO `sys_data_change_detail` VALUES (8, 782, 'location', '位置', '展厅A-001', '修复室-101', 'STRING', '2026-04-28 16:18:00');

-- ----------------------------
-- Table structure for sys_operation_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_operation_log`;
CREATE TABLE `sys_operation_log`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `operator` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `operation_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `operation_module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `operation_content` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `operation_result` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `operation_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` bigint NULL DEFAULT NULL COMMENT '操作用户ID',
  `resource_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资源类型：RELIC-文物，LOAN-借展，REPAIR-修复等',
  `resource_id` bigint NULL DEFAULT NULL COMMENT '资源ID',
  `before_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作前数据（JSON格式）',
  `after_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '操作后数据（JSON格式）',
  `changed_fields` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '变更字段列表（JSON格式）',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求方法：GET, POST, PUT, DELETE',
  `request_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求URL',
  `request_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '请求参数（JSON格式）',
  `response_data` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '响应数据（JSON格式）',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '错误信息',
  `execution_time` bigint NULL DEFAULT NULL COMMENT '执行时长（毫秒）',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户代理',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '操作系统',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_operator`(`operator`) USING BTREE,
  INDEX `idx_operation_time`(`operation_time`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_resource`(`resource_type`, `resource_id`) USING BTREE,
  INDEX `idx_operation_type`(`operation_type`) USING BTREE,
  INDEX `idx_operation_result`(`operation_result`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1091 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_operation_log
-- ----------------------------
INSERT INTO `sys_operation_log` VALUES (1, '张明远', '登录', '认证模块', '用户登录', '成功', '127.0.0.1', '2026-03-20 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (2, '李婉清', '新增', '文物管理', '新增文物', '成功', '127.0.0.1', '2026-03-20 09:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (3, '王建国', '修改', '文物管理', '修改文物信息', '成功', '127.0.0.1', '2026-03-20 09:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (4, '陈淑华', '审批', '借展管理', '审批借展记录', '成功', '127.0.0.1', '2026-03-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (5, '刘志强', '审批', '借展管理', '审批借展记录', '成功', '127.0.0.1', '2026-03-20 09:40:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (6, '林小夏', '新增', '维护管理', '新增维护记录', '成功', '127.0.0.1', '2026-03-20 09:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (7, '周子轩', '新增', '修复管理', '新增修复记录', '成功', '127.0.0.1', '2026-03-20 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (8, '赵雨桐', '导出', '统计模块', '导出借展统计报表', '成功', '127.0.0.1', '2026-03-20 10:10:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (9, '张明远', '查询', '日志模块', '查询系统日志', '成功', '127.0.0.1', '2026-03-20 10:20:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (10, '张明远', '登出', '认证模块', '管理员退出系统', '成功', '127.0.0.1', '2026-03-20 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (11, '张明远', '登录', '认证模块', '管理员登录系统', '成功', '192.168.1.100', '2024-01-15 08:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (12, '沈听澜', '新增', '文物管理', '新增文物', '成功', '192.168.1.101', '2024-01-15 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (13, '张明远', '操作', '文物管理', '新增文物', '成功', '192.168.1.102', '2024-01-16 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (14, '李婉清', '修改', '文物管理', '修改文物信息', '成功', '192.168.1.103', '2024-02-20 11:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (15, '王建国', '审批', '借展管理', '审批借展申请', '成功', '192.168.1.104', '2024-02-28 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (16, '陈淑华', '审批', '借展管理', '审批借展申请', '成功', '192.168.1.105', '2024-04-08 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (17, '刘志强', '新增', '维护管理', '新增维护记录', '成功', '192.168.1.101', '2024-01-20 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (18, '林小夏', '新增', '维护管理', '新增维护记录', '成功', '192.168.1.102', '2024-01-25 10:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (19, '周子轩', '新增', '修复管理', '新增修复记录', '成功', '192.168.1.106', '2024-02-01 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (20, '赵雨桐', '新增', '修复管理', '新增修复记录', '成功', '192.168.1.107', '2024-02-20 17:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (21, '徐天宇', '审批', '借展管理', '审批借展申请', '成功', '192.168.1.104', '2024-05-13 16:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (22, '叶知秋', '审批', '借展管理', '审批借展申请', '成功', '192.168.1.105', '2024-05-30 14:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (23, '顾云舟', '修改', '文物管理', '更新文物信息', '成功', '192.168.1.103', '2024-03-10 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (24, '沈听澜', '导出', '统计模块', '导出文物统计报表', '成功', '192.168.1.100', '2024-04-15 14:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (25, '张明远', '查询', '日志模块', '查询系统操作日志', '成功', '192.168.1.108', '2024-05-01 09:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (26, '李婉清', '删除', '文物管理', '删除重复文物记录', '成功', '192.168.1.101', '2024-03-20 11:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (27, '王建国', '修改', '用户管理', '修改用户权限', '成功', '192.168.1.100', '2024-02-10 10:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (28, '陈淑华', '驳回', '借展管理', '驳回借展申请', '成功', '192.168.1.104', '2024-04-05 15:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (29, '刘志强', '新增', '维护管理', '新增维护记录', '成功', '192.168.1.109', '2024-03-25 09:30:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (30, '林小夏', '登出', '认证模块', '管理员退出系统', '成功', '192.168.1.100', '2024-05-20 18:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (31, '张明远', '登录', '系统认证', '用户登录', '成功', '127.0.0.1', '2026-04-15 15:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (32, '张明远', '新增', '用户管理', '新增用户', '成功', '127.0.0.1', '2026-04-15 15:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (33, '张明远', '修改', '文物管理', '修改文物信息', '成功', '127.0.0.1', '2026-04-16 15:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (34, '张明远', '删除', '用户管理', '删除用户', '成功', '127.0.0.1', '2026-04-16 15:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (35, '张明远', '查询', '文物管理', '导出文物数据', '成功', '127.0.0.1', '2026-04-17 10:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (36, '张明远', '登出', '系统认证', '退出登录', '成功', '127.0.0.1', '2026-04-17 12:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (37, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:40:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (38, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:40:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (39, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:40:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (40, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:41:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (41, '张明远', '删除', '分类管理', '删除文物分类', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:41:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (42, '张明远', '删除', '分类管理', '删除文物分类', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:41:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (43, '张明远', '删除', '分类管理', '删除文物分类', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:42:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (44, '张明远', '删除', '分类管理', '删除文物分类', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 12:42:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (45, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 13:01:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (46, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 13:01:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (47, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:23:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (48, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:24:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (49, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:24:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (50, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:25:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (51, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:26:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (52, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:26:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (53, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:27:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (54, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:27:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (55, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:27:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (56, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:28:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (57, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:28:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (58, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:28:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (59, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:29:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (60, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:29:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (61, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:30:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (62, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:30:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (63, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:30:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (64, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:30:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (65, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:31:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (66, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:31:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (67, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:31:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (68, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:32:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (69, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:32:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (70, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:32:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (71, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:33:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (72, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:33:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (73, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:33:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (74, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:33:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (75, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:34:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (76, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:34:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (77, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:35:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (78, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:35:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (79, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:35:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (80, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:36:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (81, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:36:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (82, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:36:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (83, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:37:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (84, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:38:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (85, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:38:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (86, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:38:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (87, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:39:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (88, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:39:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (89, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:39:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (90, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:40:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (91, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:40:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (92, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:40:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (93, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:40:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (94, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:41:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (95, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:41:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (96, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:42:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (97, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:42:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (98, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:42:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (99, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:43:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (100, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:43:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (101, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:43:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (102, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:44:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (103, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:44:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (104, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:44:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (105, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:44:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (106, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:45:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (107, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:46:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (108, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (109, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (110, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (111, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (112, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (113, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (114, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (115, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (116, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (117, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (118, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (119, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:47:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (120, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:48:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (121, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:48:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (122, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:48:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (123, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (124, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (125, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (126, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (127, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (128, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (129, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (130, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (131, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (132, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (133, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:49:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (134, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (135, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (136, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (137, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (138, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (139, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (140, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (141, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (142, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (143, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (144, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (145, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (146, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (147, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:50:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (148, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:51:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (149, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:51:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (150, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:51:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (151, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:52:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (152, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:52:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (153, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 15:52:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (154, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 16:18:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (155, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 16:18:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (156, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-18 16:19:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (157, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-19 21:54:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (158, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-19 21:54:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (159, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-19 21:54:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (160, 'admin', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-19 22:02:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (161, 'admin', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-19 22:02:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (162, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-19 22:02:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (163, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-19 22:03:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (164, '顾云舟', '新增', '借展管理', '提交借展申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-19 22:10:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (165, '顾云舟', '新增', '借展管理', '提交借展申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-19 22:12:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (166, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-22 11:16:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (167, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-22 11:17:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (168, '顾云舟', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-22 11:18:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (169, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 10:40:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (170, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 10:41:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (171, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 10:41:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (172, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 10:41:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (173, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 10:41:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (174, '顾云舟', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 11:12:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (175, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 11:18:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (176, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 11:18:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (177, '张明远', '新增', '用户管理', '新增用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 11:32:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (178, '张明远', '新增', '用户管理', '新增用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 11:56:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (179, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 11:57:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (180, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 12:13:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (181, '张明远', '查询', '文物管理', '导出文物数据(Excel)', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 12:42:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (182, '张明远', '查询', '文物管理', '导出文物数据(Excel)', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 12:51:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (183, '张明远', '查询', '文物管理', '导出文物数据(PDF)', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 12:51:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (184, '张明远', '查询', '文物管理', '导出文物数据(Word)', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 12:51:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (185, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:33:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (186, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:33:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (187, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:35:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (188, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:35:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (189, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:35:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (190, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:35:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (191, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:35:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (192, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:36:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (193, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:40:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (194, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:42:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (195, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:43:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (196, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:44:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (197, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:44:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (198, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:47:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (199, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:47:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (200, '张明远', '新增', '图片管理', '上传图片', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 13:48:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (201, '张明远', '新增', '图片管理', '上传图片', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 13:49:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (202, '张明远', '新增', '图片管理', '上传图片', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 13:49:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (203, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:52:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (204, '张明远', '新增', '图片管理', '批量上传图片', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 13:54:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (205, '张明远', '新增', '图片管理', '批量上传图片', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 13:54:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (206, '张明远', '新增', '图片管理', '批量上传图片', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 13:54:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (207, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:57:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (208, '张明远', '新增', '图片管理', '上传图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:58:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (209, '张明远', '新增', '图片管理', '上传图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:59:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (210, '张明远', '查询', '图片管理', '下载图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:59:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (211, '张明远', '查询', '图片管理', '下载图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 13:59:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (212, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:07:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (213, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:15:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (214, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:15:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (215, '张明远', '删除', '图片管理', '删除图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:21:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (216, '张明远', '删除', '图片管理', '删除图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:21:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (217, '张明远', '新增', '图片管理', '批量上传图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:22:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (218, '张明远', '删除', '文物管理', '删除文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:24:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (219, '张明远', '删除', '文物管理', '删除文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:25:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (220, '张明远', '删除', '文物管理', '删除文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:25:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (221, '张明远', '删除', '图片管理', '删除图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:25:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (222, '张明远', '删除', '图片管理', '删除图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:25:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (223, '张明远', '删除', '图片管理', '删除图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:25:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (224, '张明远', '删除', '图片管理', '删除图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:25:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (225, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:39:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (226, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:39:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (227, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:39:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (228, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:39:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (229, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:40:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (230, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:40:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (231, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:40:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (232, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:40:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (233, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:41:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (234, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:41:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (235, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:41:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (236, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:41:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (237, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:42:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (238, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:42:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (239, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:42:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (240, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:42:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (241, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:43:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (242, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:43:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (243, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:57:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (244, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:57:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (245, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:57:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (246, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:57:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (247, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 14:58:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (248, '张明远', '新增', '图片管理', '批量上传图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:15:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (249, '张明远', '新增', '图片管理', '批量上传图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:19:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (250, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:36:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (251, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:45:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (252, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:46:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (253, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:50:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (254, '张明远', '新增', '文物管理', '新增文物（含图片）', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:58:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (255, '张明远', '新增', '文物管理', '新增文物（含图片）', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 15:59:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (256, '张明远', '新增', '文物管理', '新增文物（含图片）', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:04:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (257, '张明远', '新增', '文物管理', '新增文物（含图片）', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:05:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (258, '张明远', '新增', '文物管理', '新增文物（含图片）', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:16:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (259, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:25:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (260, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:25:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (261, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:25:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (262, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:25:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (263, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:25:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (264, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:26:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (265, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:26:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (266, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:26:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (267, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (268, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (269, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (270, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (271, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (272, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (273, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (274, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (275, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:27:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (276, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (277, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (278, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (279, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (280, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (281, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (282, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (283, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (284, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (285, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:28:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (286, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (287, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (288, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (289, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (290, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (291, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (292, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (293, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (294, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (295, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (296, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:29:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (297, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (298, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (299, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (300, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (301, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (302, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (303, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (304, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (305, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (306, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (307, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (308, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:30:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (309, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (310, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (311, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (312, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (313, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (314, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (315, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (316, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:31:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (317, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (318, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (319, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (320, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (321, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (322, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (323, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (324, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (325, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (326, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (327, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:32:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (328, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (329, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (330, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (331, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (332, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (333, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (334, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (335, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (336, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (337, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:33:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (338, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (339, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (340, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (341, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (342, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (343, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (344, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (345, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (346, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:34:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (347, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:35:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (348, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:35:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (349, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:35:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (350, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:35:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (351, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:35:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (352, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:35:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (353, '田昊鑫', '注册', '系统认证', '借展人注册：tian', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:49:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (354, '田昊鑫', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 16:49:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (355, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:01:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (356, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:01:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (357, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:02:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (358, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:03:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (359, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:03:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (360, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:03:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (361, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:03:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (362, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:03:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (363, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:03:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (364, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:04:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (365, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:04:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (366, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:04:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (367, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:04:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (368, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:04:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (369, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:04:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (370, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (371, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (372, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (373, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (374, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (375, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (376, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (377, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:05:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (378, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (379, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (380, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (381, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (382, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (383, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (384, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:06:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (385, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (386, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (387, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (388, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (389, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (390, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (391, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:07:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (392, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (393, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (394, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (395, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (396, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (397, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (398, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (399, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (400, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:08:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (401, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (402, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (403, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (404, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (405, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (406, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (407, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (408, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:09:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (409, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (410, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (411, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (412, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (413, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (414, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (415, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (416, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (417, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:10:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (418, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (419, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (420, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (421, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (422, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (423, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (424, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (425, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (426, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (427, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:11:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (428, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (429, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (430, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (431, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (432, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (433, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (434, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (435, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (436, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (437, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:12:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (438, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (439, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (440, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (441, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (442, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (443, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (444, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (445, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (446, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (447, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (448, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:13:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (449, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (450, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (451, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (452, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (453, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (454, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (455, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (456, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (457, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:14:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (458, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:15:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (459, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:35:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (460, 'wang', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:35:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (461, 'wang', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:37:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (462, 'wang', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:37:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (463, 'wang', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:37:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (464, 'wang', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:37:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (465, '王建国', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:37:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (466, '王建国', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:46:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (467, '王', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:46:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (468, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:50:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (469, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:50:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (470, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:50:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (471, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:50:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (472, '田昊鑫', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 17:50:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (473, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:55:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (474, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:55:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (475, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:55:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (476, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:55:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (477, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:55:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (478, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:56:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (479, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 17:56:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (480, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:01:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (481, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:01:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (482, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:01:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (483, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:01:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (484, '田昊鑫', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 18:05:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (485, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:21:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (486, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:21:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (487, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:21:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (488, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:21:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (489, 'tian', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:21:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (490, 'shen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:22:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (491, 'shen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:22:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (492, 'shen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:22:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (493, 'shen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:22:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (494, 'shen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:22:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (495, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 18:24:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (496, 'zhao', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:27:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (497, 'zhao', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:28:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (498, 'zhao', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 18:28:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (499, 'admin', '忘记密码', '系统认证', '发送验证码：EMAIL', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:02:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (500, 'admin', '忘记密码', '系统认证', '发送验证码：EMAIL', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:25:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (501, 'admin', '重置密码', '系统认证', '密码重置成功', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:25:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (502, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:26:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (503, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:28:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (504, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:28:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (505, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:29:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (506, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:30:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (507, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:30:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (508, '张明远', '修改', '借展管理', '归还文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:30:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (509, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:30:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (510, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:31:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (511, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:31:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (512, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:32:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (513, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:32:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (514, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:33:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (515, '张明远', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 20:50:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (516, '张明远', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 20:50:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (517, '张明远', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 20:50:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (518, '张明远', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 20:50:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (519, '张明远', '新增', '文物修复', '提交修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:52:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (520, '张明远', '修改', '文物修复', '审批修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:53:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (521, '张明远', '修改', '文物修复', '开始修复', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:54:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (522, '张明远', '新增', '文物修复', '提交修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:56:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (523, '张明远', '修改', '文物修复', '审批修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:56:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (524, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:57:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (525, '田昊鑫', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:57:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (526, 'admin', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-23 20:57:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (527, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:57:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (528, '张明远', '修改', '文物修复', '开始修复', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 20:58:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (529, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:08:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (530, 'lll', '忘记密码', '系统认证', '发送验证码：EMAIL', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:09:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (531, 'lll', '重置密码', '系统认证', '密码重置成功', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:09:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (532, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:09:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (533, 'lll', '忘记密码', '系统认证', '发送验证码：EMAIL', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:14:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (534, 'lll', '重置密码', '系统认证', '密码重置成功', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:15:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (535, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:15:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (536, 'admin', '忘记密码', '系统认证', '发送验证码：EMAIL', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:15:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (537, 'admin', '重置密码', '系统认证', '密码重置成功', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:16:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (538, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:16:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (539, '张明远', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:51:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (540, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:54:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (541, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:54:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (542, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 21:57:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (543, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 22:25:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (544, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 22:31:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (545, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 22:31:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (546, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 23:11:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (547, '张明远', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-23 23:34:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (548, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 10:00:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (549, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 10:19:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (550, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 10:19:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (551, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 10:20:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (552, '张明远', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 11:20:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (553, '张明远', '新增', '档案管理', '创建文物档案', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 11:34:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (554, '张明远', '上传', '档案管理', '上传档案文档', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 11:36:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (555, '张明远', '修改', '档案管理', '更新文物档案', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 11:37:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (556, '张明远', '新增', '档案管理', '创建文物档案', '失败', '0:0:0:0:0:0:0:1', '2026-04-24 11:44:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (557, '张明远', '新增', '档案管理', '创建文物档案', '成功', '127.0.0.1', '2026-04-24 11:52:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (558, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 11:52:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (559, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 11:52:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (560, '李婉清', '新增', '档案管理', '创建文物档案', '成功', '127.0.0.1', '2026-04-24 11:53:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (561, '李婉清', '新增', '档案管理', '创建文物档案', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:03:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (562, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:03:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (563, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:03:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (564, '张明远', '新增', '档案管理', '创建文物档案', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:05:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (565, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:12:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (566, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:12:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (567, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:13:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (568, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:13:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (569, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:13:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (570, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 12:22:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (571, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:25:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (572, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:35:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (573, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:35:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (574, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:35:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (575, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:35:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (576, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:36:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (577, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:36:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (578, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:36:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (579, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:37:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (580, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:37:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (581, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:37:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (582, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:38:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (583, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:43:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (584, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:43:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (585, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:46:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (586, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:46:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (587, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:47:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (588, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:47:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (589, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:55:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (590, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:57:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (591, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 13:57:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (592, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:01:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (593, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:01:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (594, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:01:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (595, '田昊鑫', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:10:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (596, '田昊鑫', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:10:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (597, '田昊鑫', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:10:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (598, '田昊鑫', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:14:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (599, '田昊鑫', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:15:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (600, '田昊鑫', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:15:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (601, '田昊鑫', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:30:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (602, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:38:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (603, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:40:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (604, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:40:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (605, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:53:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (606, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 14:54:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (607, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 15:29:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (608, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 15:41:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (609, 'lwy', '新增', '借展管理', '提交借展申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 16:43:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (610, '张明远', '修改', '借展管理', '审批借展申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 17:03:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (611, 'lwy', '新增', '借展管理', '提交借展申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 17:03:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (612, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 17:03:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (613, 'lwy', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 18:08:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (614, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 18:13:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (615, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 19:45:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (616, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 19:45:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (617, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 19:46:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (618, '张明远', '删除', '博物馆管理', '删除博物馆', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 20:39:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (619, '张明远', '删除', '博物馆管理', '删除博物馆', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 20:44:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (620, '张明远', '新增', '用户管理', '新增用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 20:57:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (621, '陈宇航', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 20:57:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (622, '张明远', '新增', '用户管理', '新增用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 20:58:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (623, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 21:43:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (624, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 21:43:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (625, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 21:43:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (626, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 22:02:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (627, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-24 22:37:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (628, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 16:49:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (629, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:07:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (630, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:07:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (631, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:20:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (632, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:22:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (633, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:22:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (634, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:29:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (635, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:31:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (636, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:32:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (637, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 17:59:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (638, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 18:00:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (639, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 18:00:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (640, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 19:44:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (641, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 19:44:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (642, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 19:44:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (643, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 20:00:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (644, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 20:05:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (645, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 20:15:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (646, '陈淑华', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-25 20:15:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (647, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 16:11:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (648, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 16:18:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (649, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 18:28:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (650, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 18:30:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (651, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 18:32:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (652, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 18:47:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (653, '张明远', '上传', '档案管理', '上传档案文档', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 23:00:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (654, '张明远', '新增', '用户管理', '新增用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-26 23:01:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (655, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 08:57:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (656, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 09:02:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (657, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 10:34:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (658, '张明远', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 10:35:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (659, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 10:39:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (660, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 10:41:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (661, '张明远', '查询', '图片管理', '下载图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:01:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (662, '张明远', '查询', '图片管理', '下载图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:01:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (663, '张明远', '查询', '图片管理', '下载图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:01:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (664, '张明远', '删除', '用户管理', '删除用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:47:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (665, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:48:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (666, '张明远', '新增', '用户管理', '新增用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:49:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (667, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:49:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (668, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:49:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (669, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:49:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (670, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:50:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (671, '张明远', '修改', '用户管理', '修改用户信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:50:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (672, '张明远', '修改', '博物馆管理', '修改博物馆信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:50:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (673, '张明远', '修改', '博物馆管理', '修改博物馆信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:50:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (674, '张明远', '修改', '博物馆管理', '修改博物馆信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 11:50:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (675, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:28:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (676, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:28:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (677, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:28:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (678, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:28:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (679, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:29:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (680, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:29:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (681, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:29:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (682, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:31:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (683, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:31:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (684, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:31:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (685, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:33:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (686, 'lwy', '修改', '借展管理', '用户主动归还文物', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 13:33:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (687, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:36:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (688, 'lwy', '修改', '借展管理', '用户主动归还文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:36:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (689, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:36:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (690, 'lwy', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:42:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (691, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:42:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (692, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:42:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (693, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 13:43:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (694, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:15:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (695, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:16:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (696, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:16:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (697, '张明远', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:35:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (698, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:55:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (699, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:55:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (700, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 15:55:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (701, 'lwy', '修改', '借展管理', '用户主动归还文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 16:04:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (702, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 16:04:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (703, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 16:05:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (704, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 16:50:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (705, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 16:50:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (706, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 16:54:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (707, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:01:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (708, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:05:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (709, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:17:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (710, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:17:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (711, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:17:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (712, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:23:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (713, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:25:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (714, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:25:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (715, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:25:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (716, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:29:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (717, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:29:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (718, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:30:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (719, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:31:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (720, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:34:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (721, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:34:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (722, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:35:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (723, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:39:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (724, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:39:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (725, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:40:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (726, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:45:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (727, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:49:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (728, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:52:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (729, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:52:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (730, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:54:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (731, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:54:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (732, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:54:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (733, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:55:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (734, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:55:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (735, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:55:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (736, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 17:57:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (737, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:00:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (738, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:01:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (739, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:01:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (740, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:03:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (741, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:04:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (742, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:06:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (743, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:15:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (744, 'admin', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-27 18:15:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (745, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:15:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (746, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:15:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (747, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:15:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (748, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:20:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (749, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:20:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (750, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:27:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (751, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:27:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (752, '未知用户', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:29:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (753, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 18:35:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (754, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 20:00:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (755, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 20:06:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (756, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 20:07:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (757, '张明远', '查询', '文物管理', '导出文物数据(Excel)', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 20:34:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (758, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 21:05:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (759, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 21:05:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (760, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 21:47:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (761, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 21:47:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (762, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 22:28:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (763, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 22:28:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (764, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 22:38:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (765, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-27 22:38:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (766, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 13:13:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (767, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 13:13:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (768, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 13:13:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (769, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 13:27:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (770, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 13:27:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (771, 'admin', '修改', '文物管理', '修改文物信息', 'SUCCESS', '127.0.0.1', '2026-04-28 12:51:25', 1, 'RELIC', 1, '{\"relicName\":\"商代青铜鼎\",\"status\":\"正常\",\"location\":\"展厅A-001\"}', '{\"relicName\":\"商代青铜鼎\",\"status\":\"维护中\",\"location\":\"修复室-101\"}', '[{\"field\":\"status\",\"label\":\"状态\",\"oldValue\":\"正常\",\"newValue\":\"维护中\"},{\"field\":\"location\",\"label\":\"位置\",\"oldValue\":\"展厅A-001\",\"newValue\":\"修复室-101\"}]', 'PUT', '/api/relics/1', NULL, NULL, NULL, 125, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (772, '张明远', '修改', '借展管理', '审批借展申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 14:00:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (773, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 14:00:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (774, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 14:00:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (775, 'admin', '修改', '文物管理', '修改文物管理（ID:1）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 14:30:40', 1, 'RELIC', 1, NULL, NULL, '[{\"field\":\"weight\",\"label\":\"重量\",\"oldValue\":0.5,\"newValue\":1.0,\"valueType\":\"NUMBER\",\"changed\":true}]', 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (776, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 14:30:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (777, 'admin', '修改', '文物管理', '修改文物信息', 'SUCCESS', '127.0.0.1', '2026-04-28 13:31:50', 1, 'RELIC', 1, '{\"relicName\":\"商代青铜鼎\",\"status\":\"正常\",\"location\":\"展厅A-001\"}', '{\"relicName\":\"商代青铜鼎\",\"status\":\"维护中\",\"location\":\"修复室-101\"}', '[{\"field\":\"status\",\"label\":\"状态\",\"oldValue\":\"正常\",\"newValue\":\"维护中\"},{\"field\":\"location\",\"label\":\"位置\",\"oldValue\":\"展厅A-001\",\"newValue\":\"修复室-101\"}]', 'PUT', '/api/relics/1', NULL, NULL, NULL, 125, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (778, 'admin', '修改', '文物管理', '修改文物信息', 'SUCCESS', '127.0.0.1', '2026-04-28 13:35:05', 1, 'RELIC', 1, '{\"relicName\":\"商代青铜鼎\",\"status\":\"正常\",\"location\":\"展厅A-001\"}', '{\"relicName\":\"商代青铜鼎\",\"status\":\"维护中\",\"location\":\"修复室-101\"}', '[{\"field\":\"status\",\"label\":\"状态\",\"oldValue\":\"正常\",\"newValue\":\"维护中\"},{\"field\":\"location\",\"label\":\"位置\",\"oldValue\":\"展厅A-001\",\"newValue\":\"修复室-101\"}]', 'PUT', '/api/relics/1', NULL, NULL, NULL, 125, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (779, 'lwy', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 15:48:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (780, 'admin', '删除', '用户管理', '删除用户管理（ID:119）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 16:09:46', 1, 'USER', 119, NULL, NULL, NULL, 'DELETE', '/users/119', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (781, '张明远', '删除', '用户管理', '删除用户', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:09:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (782, 'admin', '修改', '文物管理', '修改文物信息', 'SUCCESS', '127.0.0.1', '2026-04-28 15:18:00', 1, 'RELIC', 1, '{\"relicName\":\"商代青铜鼎\",\"status\":\"正常\",\"location\":\"展厅A-001\"}', '{\"relicName\":\"商代青铜鼎\",\"status\":\"维护中\",\"location\":\"修复室-101\"}', '[{\"field\":\"status\",\"label\":\"状态\",\"oldValue\":\"正常\",\"newValue\":\"维护中\"},{\"field\":\"location\",\"label\":\"位置\",\"oldValue\":\"展厅A-001\",\"newValue\":\"修复室-101\"}]', 'PUT', '/api/relics/1', NULL, NULL, NULL, 125, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (783, 'admin', '修改', '文物管理', '修改文物管理（ID:1）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 16:28:38', 1, 'RELIC', 1, NULL, NULL, '[{\"field\":\"weight\",\"label\":\"重量\",\"oldValue\":1.0,\"newValue\":20.0,\"valueType\":\"NUMBER\",\"changed\":true}]', 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (784, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:28:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (785, 'admin', '修改', '文物管理', '修改文物管理（ID:270）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 16:31:44', 1, 'RELIC', 270, NULL, NULL, '[{\"field\":\"description\",\"label\":\"描述\",\"oldValue\":null,\"newValue\":\"兵马俑群较为完整\",\"valueType\":\"STRING\",\"changed\":true}]', 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (786, '张明远', '修改', '文物管理', '修改文物信息', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:31:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (787, 'admin', '删除', '用户管理', '删除用户管理（ID:118）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 16:38:23', 1, 'USER', 118, NULL, NULL, NULL, 'DELETE', '/users/118', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (788, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:40:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (789, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:40:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (790, '张明远', '新增', '专家管理', '新增修复专家', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:41:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (791, 'admin', '删除', '用户管理', '删除用户管理（ID:117）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 16:42:51', 1, 'USER', 117, NULL, NULL, NULL, 'DELETE', '/users/117', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (792, 'admin', '修改', '用户管理', '修改用户管理（ID:20）', 'SUCCESS', '0:0:0:0:0:0:0:1', '2026-04-28 16:43:09', 1, 'USER', 20, NULL, NULL, '[{\"field\":\"status\",\"label\":\"status\",\"oldValue\":1,\"newValue\":2,\"valueType\":\"NUMBER\",\"changed\":true}]', 'PUT', '/users', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (793, '张明远', '修改', '文物管理', '修改文物管理（ID:10）', 'SUCCESS', '127.0.0.1', '2026-04-28 16:54:11', 1, 'RELIC', 10, NULL, NULL, '[{\"field\":\"description\",\"label\":\"描述\",\"oldValue\":\"汉代彩绘陶俑，色彩保存较好\",\"newValue\":\"\",\"valueType\":\"STRING\",\"changed\":true}]', 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (794, '张明远', '修改', '图片管理', '修改图片管理（ID:105）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 16:58:03', 1, 'IMAGE', 105, NULL, NULL, '[{\"field\":\"tags\",\"label\":\"tags\",\"oldValue\":null,\"newValue\":\"完整的兵马俑群\",\"valueType\":\"STRING\",\"changed\":true}]', 'PUT', '/images/105', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (796, '张明远', '修改', '文物管理', '修改文物管理（ID:104）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 17:14:39', 1, 'RELIC', 104, NULL, NULL, '[{\"field\":\"description\",\"label\":\"描述\",\"oldValue\":\"战国青铜剑，锋利依旧，铸造精良\",\"newValue\":\"锋利依旧，铸造精良\",\"valueType\":\"STRING\",\"changed\":true}]', 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (797, '张明远', '新增', '文物修复', '提交修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 17:40:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (798, '张明远', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 17:41:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (799, '张明远', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-28 17:52:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (800, '张明远', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-28 17:52:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (801, '张明远', '新增', '文物修复', '提交修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 17:53:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (802, '李婉清', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 17:55:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (803, '李婉清', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 17:55:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (804, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 19:15:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (805, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 19:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (806, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 20:47:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (807, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 20:47:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (808, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 20:47:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (809, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 20:47:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (810, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 20:57:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (811, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 20:57:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (812, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 21:20:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (813, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 21:48:11', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (814, '张明远', '修改', '文物管理', '修改文物管理（ID:16）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 21:48:14', 1, 'RELIC', 16, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (815, 'admin', '删除', '文物管理', '删除文物管理（ID:16）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 21:53:37', 1, 'RELIC', 16, NULL, NULL, NULL, 'DELETE', '/relics/16', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (816, '张明远', '修改', '文物管理', '修改文物管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:09:18', 1, 'RELIC', 1, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (817, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:09:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (818, 'admin', '删除', '文物管理', '删除文物管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:09:32', 1, 'RELIC', 1, NULL, NULL, NULL, 'DELETE', '/relics/1', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (819, '张明远', '查询', '文物管理', '生成文物二维码', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:12:47', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (820, '张明远', '删除', '图片管理', '删除图片管理（ID:107）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:14:37', 1, 'IMAGE', 107, NULL, NULL, NULL, 'DELETE', '/images/107', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (821, '张明远', '删除', '图片管理', '删除图片管理（ID:106）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:14:39', 1, 'IMAGE', 106, NULL, NULL, NULL, 'DELETE', '/images/106', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (822, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:15:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (823, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:16:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (824, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:18:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (825, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:19:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (826, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:24:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (827, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:24:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (828, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:24:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (829, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:26:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (830, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:30:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (831, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:30:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (832, '张明远', '修改', '文物管理', '修改文物管理（ID:278）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:37:51', 1, 'RELIC', 278, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (833, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:37:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (834, '张明远', '修改', '文物管理', '修改文物管理（ID:278）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:38:41', 1, 'RELIC', 278, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (835, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:38:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (836, 'admin', '删除', '文物管理', '删除文物管理（ID:278）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:01', 1, 'RELIC', 278, NULL, NULL, NULL, 'DELETE', '/relics/278', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (837, 'admin', '删除', '文物管理', '删除文物管理（ID:279）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:04', 1, 'RELIC', 279, NULL, NULL, NULL, 'DELETE', '/relics/279', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (838, 'admin', '删除', '文物管理', '删除文物管理（ID:271）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:19', 1, 'RELIC', 271, NULL, NULL, NULL, 'DELETE', '/relics/271', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (839, 'admin', '删除', '文物管理', '删除文物管理（ID:272）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:21', 1, 'RELIC', 272, NULL, NULL, NULL, 'DELETE', '/relics/272', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (840, 'admin', '删除', '文物管理', '删除文物管理（ID:273）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:27', 1, 'RELIC', 273, NULL, NULL, NULL, 'DELETE', '/relics/273', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (841, '张明远', '删除', '文物管理', '批量删除文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (842, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (843, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:47:53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (844, 'admin', '删除', '文物管理', '删除文物管理（ID:280）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:51:02', 1, 'RELIC', 280, NULL, NULL, NULL, 'DELETE', '/relics/280', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (845, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:51:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (846, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 22:51:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (847, 'admin', '删除', '文物管理', '删除文物管理（ID:281）', '成功', '127.0.0.1', '2026-04-28 22:55:06', 1, 'RELIC', 281, NULL, NULL, NULL, 'DELETE', '/relics/281', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (848, '张明远', '新增', '文物管理', '新增文物', '成功', '127.0.0.1', '2026-04-28 22:55:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (849, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '127.0.0.1', '2026-04-28 22:55:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (850, '李婉清', '修改', '文物修复', '更新修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-28 23:07:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (851, '李婉清', '修改', '文物修复', '更新修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-28 23:07:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (852, '李婉清', '修改', '文物修复', '更新修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-28 23:10:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (853, '李婉清', '删除', '文物修复', '删除文物修复（ID:20）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:11:31', 2, 'REPAIR', 20, NULL, NULL, NULL, 'DELETE', '/repairs/20', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (854, '李婉清', '修改', '文物修复', '修改文物修复（ID:25）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:12:48', 2, 'REPAIR', 25, NULL, NULL, '[{\"field\":\"estimatedCost\",\"label\":\"预估费用\",\"oldValue\":3500.00,\"newValue\":180.00,\"valueType\":\"OBJECT\",\"changed\":true},{\"field\":\"repairExpert\",\"label\":\"修复专家\",\"oldValue\":null,\"newValue\":\"\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"beforeImages\",\"label\":\"beforeImages\",\"oldValue\":null,\"newValue\":\"\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"remark\",\"label\":\"remark\",\"oldValue\":null,\"newValue\":\"\",\"valueType\":\"STRING\",\"changed\":true}]', 'PUT', '/repairs/apply/25', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (855, '李婉清', '修改', '文物修复', '更新修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:12:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (856, '李婉清', '新增', '材料管理', '添加材料使用记录', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:12:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (857, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:15:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (858, '李婉清', '删除', '文物修复', '删除文物修复（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:15:51', 2, 'REPAIR', 6, NULL, NULL, NULL, 'DELETE', '/repairs/6', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (859, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-28 23:15:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (860, 'adnin', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 12:01:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (861, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:01:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (862, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:01:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (863, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:02:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (864, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:02:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (865, '陈淑华', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:02:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (866, '李婉清', '删除', '保养管理', '删除保养管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:03:47', 2, 'MAINTENANCE', 1, NULL, NULL, NULL, 'DELETE', '/maintenance/1', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (867, '李婉清', '删除', '保养管理', '删除保养管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:03:50', 2, 'MAINTENANCE', 11, NULL, NULL, NULL, 'DELETE', '/maintenance/11', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (868, '李婉清', '删除', '保养管理', '删除保养管理（ID:13）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:03:54', 2, 'MAINTENANCE', 13, NULL, NULL, NULL, 'DELETE', '/maintenance/13', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (869, '李婉清', '新增', '保养管理', '新增保养记录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 12:23:12', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (870, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 13:31:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (871, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 13:31:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (872, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 13:33:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (873, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 13:33:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (874, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 14:16:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (875, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 14:16:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (876, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 14:26:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (877, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 14:26:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (878, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 14:30:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (879, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 14:30:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (880, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 18:07:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (881, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 18:07:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (882, '陈淑华', '登出', '系统认证', '退出登录', '成功', '127.0.0.1', '2026-04-29 18:09:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (883, '陈淑华', '登录', '系统认证', '用户登录', '成功', '127.0.0.1', '2026-04-29 18:09:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (884, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 19:06:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (885, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 19:07:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (886, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 19:50:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (887, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 21:58:24', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (888, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 21:58:32', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (889, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 21:58:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (890, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 21:59:22', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (891, '陈淑华', '审批', '借展管理', '审批借展管理（ID:21）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:00:33', 4, 'LOAN', 21, NULL, NULL, NULL, 'PUT', '/loans/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (892, '陈淑华', '审批', '借展管理', '审批借展管理（ID:20）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:00:35', 4, 'LOAN', 20, NULL, NULL, NULL, 'PUT', '/loans/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (893, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:00:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (894, 'lwy', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:00:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (895, '陈淑华', '审批', '文物修复', '审批文物修复（ID:7）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:06:01', 4, 'REPAIR', 7, NULL, NULL, NULL, 'PUT', '/repairs/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (896, '李婉清', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:06:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (897, '李婉清', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 22:24:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (898, '李婉清', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 22:24:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (899, '李婉清', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 22:24:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (900, '李婉清', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 22:24:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (901, '李婉清', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 22:24:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (902, '李婉清', '新增', '文物修复', '提交修复申请', '失败', '0:0:0:0:0:0:0:1', '2026-04-29 22:25:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (903, '李婉清', '新增', '文物修复', '提交修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:26:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (904, '李婉清', '新增', '材料管理', '添加材料使用记录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:26:39', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (905, '李婉清', '新增', '文物修复', '提交修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:27:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (906, '李婉清', '新增', '材料管理', '添加材料使用记录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:27:37', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (907, '陈淑华', '审批', '保养管理', '审批保养管理（ID:33）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:29:02', 4, 'MAINTENANCE', 33, NULL, NULL, NULL, 'PUT', '/maintenance/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (908, '陈淑华', '审批', '保养管理', '审批保养管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:29:06', 4, 'MAINTENANCE', 12, NULL, NULL, NULL, 'PUT', '/maintenance/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (909, '李婉清', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:29:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (910, '陈淑华', '审批', '文物修复', '审批文物修复（ID:27）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:35:41', 4, 'REPAIR', 27, NULL, NULL, NULL, 'PUT', '/repairs/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (911, '李婉清', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:43:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (912, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:50:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (913, '张明远', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:50:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (914, '李婉清', '修改', '文物修复', '修改文物修复（ID:26）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:58:13', 2, 'REPAIR', 26, NULL, NULL, '[{\"field\":\"estimatedCost\",\"label\":\"预估费用\",\"oldValue\":25.00,\"newValue\":280.00,\"valueType\":\"OBJECT\",\"changed\":true}]', 'PUT', '/repairs/apply/26', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (915, '李婉清', '修改', '文物修复', '更新修复申请', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:58:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (916, '李婉清', '新增', '材料管理', '添加材料使用记录', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 22:58:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (917, '陈淑华', '审批', '文物修复', '审批文物修复（ID:26）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 23:22:51', 4, 'REPAIR', 26, NULL, NULL, NULL, 'PUT', '/repairs/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (918, '陈淑华', '审批', '文物修复', '审批文物修复（ID:25）', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 23:23:32', 4, 'REPAIR', 25, NULL, NULL, NULL, 'PUT', '/repairs/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (919, '李婉清', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 23:23:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (920, '李婉清', '修改', '消息通知', '标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-29 23:23:40', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (921, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 09:34:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (922, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 09:34:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (923, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 09:34:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (924, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 09:35:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (925, 'lwy', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 10:09:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (926, 'lwy', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 10:10:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (927, '张明远', '审批', '保养管理', '审批保养管理（ID:32）', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 10:13:36', 1, 'MAINTENANCE', 32, NULL, NULL, NULL, 'PUT', '/maintenance/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (928, '张明远', '审批', '保养管理', '审批保养管理（ID:30）', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 10:13:39', 1, 'MAINTENANCE', 30, NULL, NULL, NULL, 'PUT', '/maintenance/approve', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (929, '张明远', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-04-30 10:37:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (930, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:02:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (931, '张明远', '删除', '图片管理', '删除图片管理（ID:117）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:36', 1, 'IMAGE', 117, NULL, NULL, NULL, 'DELETE', '/images/117', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (932, '张明远', '删除', '图片管理', '删除图片管理（ID:116）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:38', 1, 'IMAGE', 116, NULL, NULL, NULL, 'DELETE', '/images/116', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (933, '张明远', '删除', '图片管理', '删除图片管理（ID:115）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:40', 1, 'IMAGE', 115, NULL, NULL, NULL, 'DELETE', '/images/115', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (934, '张明远', '删除', '图片管理', '删除图片管理（ID:114）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:41', 1, 'IMAGE', 114, NULL, NULL, NULL, 'DELETE', '/images/114', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (935, '张明远', '删除', '图片管理', '删除图片管理（ID:113）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:43', 1, 'IMAGE', 113, NULL, NULL, NULL, 'DELETE', '/images/113', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (936, '张明远', '删除', '图片管理', '删除图片管理（ID:112）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:45', 1, 'IMAGE', 112, NULL, NULL, NULL, 'DELETE', '/images/112', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (937, '张明远', '删除', '图片管理', '删除图片管理（ID:111）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:47', 1, 'IMAGE', 111, NULL, NULL, NULL, 'DELETE', '/images/111', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (938, 'admin', '删除', '文物管理', '删除文物管理（ID:282）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:53', 1, 'RELIC', 282, NULL, NULL, NULL, 'DELETE', '/relics/282', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (939, '张明远', '删除', '图片管理', '删除图片管理（ID:110）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:56', 1, 'IMAGE', 110, NULL, NULL, NULL, 'DELETE', '/images/110', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (940, '张明远', '删除', '图片管理', '删除图片管理（ID:109）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:58', 1, 'IMAGE', 109, NULL, NULL, NULL, 'DELETE', '/images/109', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (941, '张明远', '删除', '图片管理', '删除图片管理（ID:108）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:29:59', 1, 'IMAGE', 108, NULL, NULL, NULL, 'DELETE', '/images/108', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (942, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:52:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (943, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:52:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (944, 'admin', '删除', '文物管理', '删除文物管理（ID:283）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 15:52:59', 1, 'RELIC', 283, NULL, NULL, NULL, 'DELETE', '/relics/283', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (945, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 17:25:49', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (946, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 17:28:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (947, '张明远', '修改', '文物管理', '修改文物管理（ID:7）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 18:09:39', 1, 'RELIC', 7, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (948, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 18:20:01', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (949, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 19:53:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (950, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:02:56', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (951, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:03:18', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (952, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:04:53', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (953, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:05:51', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (954, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:07:29', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (955, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:14:32', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (956, '张明远', '修改', '文物管理', '修改文物管理（ID:6）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:17:07', 1, 'RELIC', 6, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (957, '张明远', '修改', '文物管理', '修改文物管理（ID:9）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:17:23', 1, 'RELIC', 9, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (958, '张明远', '修改', '文物管理', '修改文物管理（ID:10）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:18:25', 1, 'RELIC', 10, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (959, '张明远', '修改', '文物管理', '修改文物管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:18:37', 1, 'RELIC', 11, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (960, '张明远', '新增', '文物管理', '新增文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:38:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (961, '张明远', '新增', '文物图片管理', '批量上传文物图片', '成功', '0:0:0:0:0:0:0:1', '2026-05-06 20:38:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (962, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 11:26:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (963, '张明远', '修改', '文物管理', '修改文物管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:21:06', 1, 'RELIC', 11, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (964, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:57:52', 1, 'RELIC', 11, NULL, NULL, NULL, 'DELETE', '/relics/11/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (965, '张明远', '修改', '文物管理', '修改文物管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:57:54', 1, 'RELIC', 11, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (966, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:58:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (967, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:58:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (968, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:58:37', 1, 'RELIC', 11, NULL, NULL, NULL, 'DELETE', '/relics/11/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (969, '张明远', '修改', '文物管理', '修改文物管理（ID:11）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:58:39', 1, 'RELIC', 11, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (970, '张明远', '修改', '文物管理', '修改文物管理（ID:59）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:59:40', 1, 'RELIC', 59, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (971, '张明远', '保存3D模型链接', '3D模型管理', '保存3D模型链接3D模型管理（ID:59）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 12:59:40', 1, 'RELIC', 59, NULL, NULL, NULL, 'POST', '/relics/59/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (972, '张明远', '修改', '文物管理', '修改文物管理（ID:73）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 13:04:28', 1, 'RELIC', 73, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (973, '张明远', '保存3D模型链接', '3D模型管理', '保存3D模型链接3D模型管理（ID:73）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 13:04:28', 1, 'RELIC', 73, NULL, NULL, NULL, 'POST', '/relics/73/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (974, '张明远', '修改', '文物管理', '修改文物管理（ID:78）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 13:08:55', 1, 'RELIC', 78, NULL, NULL, NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (975, '张明远', '保存3D模型链接', '3D模型管理', '保存3D模型链接3D模型管理（ID:78）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 13:08:55', 1, 'RELIC', 78, NULL, NULL, NULL, 'POST', '/relics/78/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (976, '张明远', '修改', '文物管理', '修改文物管理（ID:81）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 13:11:08', 1, 'RELIC', 81, '{\"id\":81,\"relicCode\":\"WW202501081\",\"relicName\":\"唐代铜观音\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"唐朝\",\"material\":\"青铜\",\"origin\":\"陕西西安\",\"dimensions\":\"高60cm\",\"weight\":15.0,\"description\":\"唐代铜观音像，造型优美，神态慈祥\",\"status\":\"在库\",\"imagePath\":\"/uploads/6da715a8159045bda0e896de63ace624.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-03-22T10:00:00\",\"updateTime\":\"2026-04-23T17:08:47\"}', '{\"id\":81,\"relicCode\":\"WW202501081\",\"relicName\":\"唐代铜观音\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"唐朝\",\"material\":\"青铜\",\"origin\":\"陕西西安\",\"dimensions\":\"高60cm\",\"weight\":15.0,\"description\":\"唐代铜观音像，造型优美，神态慈祥\",\"status\":\"在库\",\"imagePath\":\"/uploads/6da715a8159045bda0e896de63ace624.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-03-22T10:00:00\",\"updateTime\":\"2026-05-08T13:11:08\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (977, '张明远', '保存3D模型链接', '3D模型管理', '保存3D模型链接3D模型管理（ID:81）', '成功', '0:0:0:0:0:0:0:1', '2026-05-08 13:11:08', 1, 'RELIC', 81, '{\"id\":81,\"relicCode\":\"WW202501081\",\"relicName\":\"唐代铜观音\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"唐朝\",\"material\":\"青铜\",\"origin\":\"陕西西安\",\"dimensions\":\"高60cm\",\"weight\":15.0,\"description\":\"唐代铜观音像，造型优美，神态慈祥\",\"status\":\"在库\",\"imagePath\":\"/uploads/6da715a8159045bda0e896de63ace624.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-03-22T10:00:00\",\"updateTime\":\"2026-05-08T13:11:08\"}', '{\"id\":81,\"relicCode\":\"WW202501081\",\"relicName\":\"唐代铜观音\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"唐朝\",\"material\":\"青铜\",\"origin\":\"陕西西安\",\"dimensions\":\"高60cm\",\"weight\":15.0,\"description\":\"唐代铜观音像，造型优美，神态慈祥\",\"status\":\"在库\",\"imagePath\":\"/uploads/6da715a8159045bda0e896de63ace624.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/objstone-buddha-head-sculpture-9616e574c3b04c388bf0351400f7f0c9\",\"model3dUploadTime\":\"2026-05-08T13:11:08\",\"createTime\":\"2025-03-22T10:00:00\",\"updateTime\":\"2026-05-08T13:11:08\"}', '[{\"field\":\"model3dUrl\",\"label\":\"3D模型链接\",\"oldValue\":null,\"newValue\":\"https://sketchfab.com/3d-models/objstone-buddha-head-sculpture-9616e574c3b04c388bf0351400f7f0c9\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"model3dUploadTime\",\"label\":\"3D模型上传时间\",\"oldValue\":null,\"newValue\":\"2026-05-08T13:11:08\",\"valueType\":\"DATE\",\"changed\":true}]', 'POST', '/relics/81/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (978, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 11:06:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (979, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 11:59:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (980, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 12:00:06', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (981, '陈淑华', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 12:32:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (982, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 12:33:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (983, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:15:50', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (984, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:16:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (985, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:17:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (986, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:17:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (987, '张明远', '打印', '档案管理', '打印档案', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:25:04', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (988, '张明远', '打印', '档案管理', '打印档案', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:25:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (989, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:38:35', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (990, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:38:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (991, '李婉清', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:45:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (992, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 13:45:26', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (993, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:29:07', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (994, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:29:27', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (995, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:30:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (996, '张明远', '删除', '备份管理', '删除备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:30:22', 1, 'BACKUP', 1, '{\"id\":1,\"backupName\":\"系统上线前备份\",\"backupType\":\"manual\",\"backupStatus\":\"success\",\"fileName\":\"backup_20260420_100000.sql\",\"filePath\":\"backups/backup_20260420_100000.sql\",\"fileSize\":15728640,\"isEncrypted\":false,\"backupTables\":null,\"description\":\"系统正式上线前的完整备份\",\"errorMessage\":null,\"createdBy\":\"admin\",\"createdTime\":\"2026-04-20T10:00:00\",\"deleted\":false}', NULL, NULL, 'DELETE', '/backup/1', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (997, '张明远', '删除', '备份管理', '清理过期备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:31:38', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (998, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:36:09', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (999, '张明远', '删除', '备份管理', '删除备份管理（ID:9）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:51:12', 1, 'BACKUP', 9, '{\"id\":9,\"backupName\":\"重要数据备份\",\"backupType\":\"manual\",\"backupStatus\":\"success\",\"fileName\":\"backup_20260509_143608.sql\",\"filePath\":\"backups\\\\backup_20260509_143608.sql\",\"fileSize\":517492,\"isEncrypted\":false,\"backupTables\":null,\"description\":\"\",\"errorMessage\":null,\"createdBy\":\"admin\",\"createdTime\":\"2026-05-09T14:36:09\",\"deleted\":false}', NULL, NULL, 'DELETE', '/backup/9', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1000, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:51:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1001, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 14:51:34', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"02:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-04-27T21:08:59\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"02:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T14:51:34\"}', '[{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-04-27T21:08:59\",\"newValue\":\"2026-05-09T14:51:34\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1002, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 15:01:36', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1003, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 15:02:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1004, '张明远', '删除', '备份管理', '删除备份管理（ID:8）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 15:02:42', 1, 'BACKUP', 8, '{\"id\":8,\"backupName\":\"正在执行的备份\",\"backupType\":\"manual\",\"backupStatus\":\"processing\",\"fileName\":\"backup_20260427_210000.sql\",\"filePath\":\"backups/backup_20260427_210000.sql\",\"fileSize\":0,\"isEncrypted\":false,\"backupTables\":null,\"description\":\"当前正在执行的备份任务\",\"errorMessage\":null,\"createdBy\":\"admin\",\"createdTime\":\"2026-04-27T21:00:00\",\"deleted\":false}', NULL, NULL, 'DELETE', '/backup/8', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1005, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 15:16:59', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"02:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T14:51:34\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"16:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T15:16:58\"}', '[{\"field\":\"backupTime\",\"label\":\"backupTime\",\"oldValue\":\"02:00\",\"newValue\":\"16:00\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-05-09T14:51:34\",\"newValue\":\"2026-05-09T15:16:58\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1006, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:41:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1007, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:43:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1008, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:45:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1009, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:47:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1010, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:54:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1011, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:54:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1012, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:54:31', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1013, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 16:57:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1014, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:09:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1015, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:09:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1016, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:10:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1017, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:18:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1018, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:22:03', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1019, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:23:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1020, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:37:18', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1021, '张明远', '查询', 'AI查询', 'AI智能查询文物', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:54:42', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1022, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 17:59:48', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"16:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T15:16:58\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"16:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T17:59:47\"}', '[{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-05-09T15:16:58\",\"newValue\":\"2026-05-09T17:59:47\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1023, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 18:01:50', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"16:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T17:59:47\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"19:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T18:01:49\"}', '[{\"field\":\"backupTime\",\"label\":\"backupTime\",\"oldValue\":\"16:00\",\"newValue\":\"19:00\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-05-09T17:59:47\",\"newValue\":\"2026-05-09T18:01:49\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1024, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 22:03:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1025, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-09 22:04:22', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"19:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T18:01:49\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"19:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T22:04:21\"}', '[{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-05-09T18:01:49\",\"newValue\":\"2026-05-09T22:04:21\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1026, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-11 11:38:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1027, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-11 11:39:40', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"19:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-09T22:04:21\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"12:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-11T11:39:39\"}', '[{\"field\":\"backupTime\",\"label\":\"backupTime\",\"oldValue\":\"19:00\",\"newValue\":\"12:00\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-05-09T22:04:21\",\"newValue\":\"2026-05-11T11:39:39\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1028, '张明远', '修改', '备份管理', '修改备份管理（ID:1）', '成功', '0:0:0:0:0:0:0:1', '2026-05-11 14:49:22', 1, 'BACKUP_CONFIG', 1, '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"12:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-11T11:39:39\"}', '{\"id\":1,\"configName\":\"默认自动备份配置\",\"isEnabled\":true,\"backupFrequency\":\"daily\",\"backupTime\":\"20:00\",\"retentionDays\":30,\"maxBackupCount\":10,\"isEncrypted\":false,\"backupTables\":null,\"notificationEnabled\":true,\"createdBy\":\"system\",\"createdTime\":\"2026-04-27T21:08:59\",\"updatedBy\":null,\"updatedTime\":\"2026-05-11T14:49:22\"}', '[{\"field\":\"backupTime\",\"label\":\"backupTime\",\"oldValue\":\"12:00\",\"newValue\":\"20:00\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"updatedTime\",\"label\":\"updatedTime\",\"oldValue\":\"2026-05-11T11:39:39\",\"newValue\":\"2026-05-11T14:49:22\",\"valueType\":\"DATE\",\"changed\":true}]', 'PUT', '/backup/config', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1029, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-12 14:22:46', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1030, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-12 14:22:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1031, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-12 14:23:02', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1032, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:23:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1033, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:25:20', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1034, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:25:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1035, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:27:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1036, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:27:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1037, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:28:08', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1038, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:30:55', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1039, '张明远', '新增', '备份管理', '创建手动备份', '成功', '127.0.0.1', '2026-05-13 12:31:29', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1040, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:32:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1041, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:48:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1042, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:49:25', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1043, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:51:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1044, '张明远', '新增', '备份管理', '创建手动备份', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 12:53:15', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1045, '张明远', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 14:57:14', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1046, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 14:57:51', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1047, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 14:57:58', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1048, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 16:34:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1049, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 16:34:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1050, '李婉清', '修改', '消息通知', '批量标记通知为已读', '成功', '0:0:0:0:0:0:0:1', '2026-05-13 16:35:01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1051, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:25:10', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1052, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:25:17', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1053, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:25:21', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1054, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:25:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1055, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:25:33', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1056, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:25:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1057, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:27:55', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-04-23T20:30:18\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:27:55\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1058, '张明远', '保存3D模型链接', '3D模型管理', '保存3D模型链接3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:27:55', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:27:55\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:27:55\"}', '[{\"field\":\"model3dUrl\",\"label\":\"3D模型链接\",\"oldValue\":null,\"newValue\":\"ewsfzxd\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"model3dUploadTime\",\"label\":\"3D模型上传时间\",\"oldValue\":null,\"newValue\":\"2026-05-15T08:27:55\",\"valueType\":\"DATE\",\"changed\":true}]', 'POST', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1059, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:28:00', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:27:55\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:27:55\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1060, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:28:01', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:27:55\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:28:01\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1061, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:2）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:28:13', 1, 'RELIC', 2, '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-06T16:20:26\"}', '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-06T16:20:26\"}', NULL, 'DELETE', '/relics/2/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1062, '张明远', '修改', '文物管理', '修改文物管理（ID:2）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:28:17', 1, 'RELIC', 2, '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-06T16:20:26\"}', '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-15T08:28:17\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1063, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:2）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:28:39', 1, 'RELIC', 2, '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-15T08:28:17\"}', '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-15T08:28:17\"}', NULL, 'DELETE', '/relics/2/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1064, '张明远', '修改', '文物管理', '修改文物管理（ID:2）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:28:41', 1, 'RELIC', 2, '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-15T08:28:17\"}', '{\"id\":2,\"relicCode\":\"WW202501002\",\"relicName\":\"北魏石佛头像\",\"categoryId\":9,\"categoryName\":\"佛像\",\"era\":\"南北朝\",\"material\":\"石\",\"origin\":\"山西大同\",\"dimensions\":\"高25cm\",\"weight\":8.0,\"description\":\"北魏时期石雕佛头像，雕刻精美，面容慈祥\",\"status\":\"借展中\",\"imagePath\":\"/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/stone-bodhisattva-head-9366562c76ba4615962ac291bd18206f\",\"model3dUploadTime\":null,\"createTime\":\"2025-01-02T10:00:00\",\"updateTime\":\"2026-05-15T08:28:41\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1065, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:29:27', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:28:01\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:28:01\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1066, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:29:30', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:28:01\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:30\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1067, '张明远', '保存3D模型链接', '3D模型管理', '保存3D模型链接3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:29:30', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"ewsfzxd\",\"model3dUploadTime\":\"2026-05-15T08:27:55\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:30\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:30\"}', '[{\"field\":\"model3dUrl\",\"label\":\"3D模型链接\",\"oldValue\":\"ewsfzxd\",\"newValue\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"model3dUploadTime\",\"label\":\"3D模型上传时间\",\"oldValue\":\"2026-05-15T08:27:55\",\"newValue\":\"2026-05-15T08:29:30\",\"valueType\":\"DATE\",\"changed\":true}]', 'POST', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1068, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:29:45', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:30\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:30\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1069, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:29:46', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:30\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:46\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1070, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:32:22', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:46\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:46\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1071, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:32:24', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:29:46\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:32:24\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1072, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:32:56', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:32:24\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:32:24\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1073, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:34:45', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:32:24\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:34:45\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1074, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:35:11', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:34:45\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:34:45\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1075, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:35:12', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:34:45\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:35:12\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1076, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:40:11', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:35:12\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:35:12\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1077, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:40:12', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:35:12\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:40:12\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1078, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:42:20', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:40:12\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:40:12\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1079, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 08:43:05', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:40:12\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:40:12\"}', NULL, 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1080, '张明远', '删除3D模型', '3D模型管理', '删除3D模型3D模型管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 09:03:31', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"model3dUploadTime\":\"2026-05-15T08:29:30\",\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T08:40:12\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T09:03:31\"}', '[{\"field\":\"model3dUrl\",\"label\":\"3D模型链接\",\"oldValue\":\"https://sketchfab.com/3d-models/chinese-tomb-figures-618-906-ce-611a95a8551348bdb9230faa4fcc0820\",\"newValue\":null,\"valueType\":\"STRING\",\"changed\":true},{\"field\":\"model3dUploadTime\",\"label\":\"3D模型上传时间\",\"oldValue\":\"2026-05-15T08:29:30\",\"newValue\":null,\"valueType\":\"DATE\",\"changed\":true}]', 'DELETE', '/relics/12/3d-model-url', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1081, '张明远', '修改', '文物管理', '修改文物管理（ID:12）', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 09:03:36', 1, 'RELIC', 12, '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T09:03:31\"}', '{\"id\":12,\"relicCode\":\"WW202501012\",\"relicName\":\"汉代青铜镜\",\"categoryId\":1,\"categoryName\":\"青铜器\",\"era\":\"汉朝\",\"material\":\"青铜\",\"origin\":\"河南洛阳\",\"dimensions\":\"直径18cm\",\"weight\":0.8,\"description\":\"汉代铜镜，纹饰精美，铭文清晰\",\"status\":\"借展中\",\"imagePath\":\"/uploads/678d29b16b5b4f12975d11fc2234feb3.webp\",\"model3dUrl\":null,\"model3dUploadTime\":null,\"createTime\":\"2025-01-12T10:00:00\",\"updateTime\":\"2026-05-15T09:03:36\"}', NULL, 'PUT', '/relics', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1082, '张明远', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 11:58:23', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1083, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-15 13:23:16', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1084, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-17 11:53:28', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1085, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-17 11:53:41', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1086, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-17 11:53:45', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1087, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-05-17 11:53:52', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1088, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-17 11:53:57', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1089, '未知用户', '登出', '系统认证', '退出登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-17 11:53:59', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1090, '陈淑华', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-05-17 11:54:05', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1091, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:12:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1092, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:12:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1093, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:12:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1094, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:12:44', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1095, '李婉清', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-06-14 16:12:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1096, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:13:19', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1097, '张明远', '修改', '用户管理', '修改用户管理（ID:4）', '成功', '0:0:0:0:0:0:0:1', '2026-06-14 16:13:31', 1, 'USER', 4, '{\"id\":4,\"username\":\"chen\",\"password\":\"$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC\",\"realName\":\"陈淑华\",\"email\":\"3071624946@qq.com\",\"phone\":\"13800000004\",\"status\":1,\"roleId\":3,\"roleName\":\"申请审批员\",\"roleCode\":\"APPROVER\",\"createTime\":\"2026-04-02T18:00:33\",\"updateTime\":\"2026-06-14T16:12:44\",\"loginFailedCount\":3,\"accountLocked\":1,\"lockedTime\":\"2026-06-14T16:12:44\",\"lastLoginTime\":\"2026-05-17T11:54:05\",\"lastLoginIp\":\"0:0:0:0:0:0:0:1\"}', '{\"id\":4,\"username\":\"chen\",\"password\":\"$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC\",\"realName\":\"陈淑华\",\"email\":\"3071624946@qq.com\",\"phone\":\"13800000004\",\"status\":1,\"roleId\":3,\"roleName\":\"申请审批员\",\"roleCode\":\"APPROVER\",\"createTime\":\"2026-04-02T18:00:33\",\"updateTime\":\"2026-06-14T16:13:31\",\"loginFailedCount\":3,\"accountLocked\":1,\"lockedTime\":\"2026-06-14T16:12:44\",\"lastLoginTime\":\"2026-05-17T11:54:05\",\"lastLoginIp\":\"0:0:0:0:0:0:0:1\"}', NULL, 'PUT', '/users', NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1098, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:13:34', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1099, 'chen', '登录', '系统认证', '用户登录', '失败', '0:0:0:0:0:0:0:1', '2026-06-14 16:13:43', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `sys_operation_log` VALUES (1100, '张明远', '登录', '系统认证', '用户登录', '成功', '0:0:0:0:0:0:0:1', '2026-06-15 07:48:30', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for sys_restore
-- ----------------------------
DROP TABLE IF EXISTS `sys_restore`;
CREATE TABLE `sys_restore`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '恢复ID',
  `backup_id` bigint NOT NULL COMMENT '备份ID',
  `restore_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'processing' COMMENT '恢复状态：processing-处理中, success-成功, failed-失败',
  `restore_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '恢复类型：full-完全恢复, partial-部分恢复',
  `restore_tables` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '恢复的表列表（JSON数组）',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '错误信息',
  `created_by` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '操作人',
  `created_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `completed_time` datetime NULL DEFAULT NULL COMMENT '完成时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_backup_id`(`backup_id`) USING BTREE,
  INDEX `idx_restore_status`(`restore_status`) USING BTREE,
  CONSTRAINT `sys_restore_ibfk_1` FOREIGN KEY (`backup_id`) REFERENCES `sys_backup` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统恢复记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_restore
-- ----------------------------
INSERT INTO `sys_restore` VALUES (1, 1, 'success', 'full', NULL, NULL, 'admin', '2026-04-20 18:00:00', '2026-04-20 18:05:30');
INSERT INTO `sys_restore` VALUES (2, 3, 'success', 'full', NULL, NULL, 'admin', '2026-04-22 16:00:00', '2026-04-22 16:06:15');
INSERT INTO `sys_restore` VALUES (3, 2, 'failed', 'full', NULL, 'mysql: Error: Cannot connect to database server', 'admin', '2026-04-21 10:00:00', NULL);
INSERT INTO `sys_restore` VALUES (4, 5, 'processing', 'full', NULL, NULL, 'admin', '2026-04-27 21:05:00', NULL);

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` tinyint NULL DEFAULT 1,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `role_code`(`role_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '系统管理员', 'ADMIN', '系统最高权限管理员', 1, '2026-04-01 22:58:33', '2026-04-01 22:58:33');
INSERT INTO `sys_role` VALUES (2, '文物保管员', 'CURATOR', '负责文物信息和维护记录管理', 1, '2026-04-01 22:58:33', '2026-04-01 22:58:33');
INSERT INTO `sys_role` VALUES (3, '申请审批员', 'APPROVER', '负责借展、修复、维护申请的审批', 1, '2026-04-01 22:58:33', '2026-04-29 14:24:00');
INSERT INTO `sys_role` VALUES (4, '文物借展人', 'LOANER', '负责申请借展文物', 1, '2026-04-16 16:00:08', '2026-04-16 16:00:09');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `status` tinyint NULL DEFAULT 1,
  `role_id` bigint NULL DEFAULT NULL,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `login_failed_count` int NULL DEFAULT 0 COMMENT '登录失败次数',
  `account_locked` tinyint(1) NULL DEFAULT 0 COMMENT '账户是否锁定：0-未锁定，1-已锁定',
  `locked_time` datetime NULL DEFAULT NULL COMMENT '账户锁定时间',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最后登录IP',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username`) USING BTREE,
  INDEX `idx_role_id`(`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 122 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '$2a$10$cnGSWFJQCF6b/alG2mf1mung9vS1o9jEXNqy0MwQk3PYTfBYt9C6C', '张明远', '3071624946@qq.com', '15874225616', 1, 1, '2026-04-01 22:58:33', '2026-06-15 07:48:30', 0, 0, NULL, '2026-06-15 07:48:30', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (2, 'li', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '李婉清', '3071624946@qq.com', '13800000002', 1, 2, '2026-04-02 18:00:33', '2026-06-14 16:12:56', 0, 0, NULL, '2026-06-14 16:12:56', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (3, 'wang', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '王建国', 'c02@test.com', '13800000003', 1, 2, '2026-04-02 18:00:33', '2026-04-23 17:37:14', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (4, 'chen', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '陈淑华', '3071624946@qq.com', '13800000004', 1, 3, '2026-04-02 18:00:33', '2026-06-14 16:13:31', 3, 1, '2026-06-14 16:12:44', '2026-05-17 11:54:05', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (5, 'liu', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '刘志强', 'a02@test.com', '13800000005', 1, 3, '2026-04-02 18:00:33', '2026-04-17 13:59:20', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (6, '赵曌', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '赵曌', 'vdcd@test.com', '14785412309', 1, 4, '2026-04-24 21:14:45', '2026-04-27 09:02:32', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (7, '沈卓', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '沈卓', 'egbf@test.com', '18540259630', 1, 4, '2026-04-24 21:15:25', '2026-04-24 21:43:23', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (8, 'lin', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '林小夏', 's01@test.com', '13800000008', 1, 4, '2026-04-02 18:00:33', '2026-04-19 21:57:10', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (9, 'zhou', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '周子轩', 's02@test.com', '13800000009', 1, 2, '2026-04-02 18:00:33', '2026-04-17 13:59:20', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (10, 'zhao', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '赵雨桐', 's03@test.com', '13800000010', 1, 3, '2026-04-02 18:00:33', '2026-04-27 11:48:20', 3, 1, '2026-04-23 18:28:07', NULL, '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (11, 'xu', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '徐天宇', 's04@test.com', '13800000011', 1, 2, '2026-04-02 18:00:33', '2026-04-24 18:13:44', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (12, 'ye', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '叶知秋', 's05@test.com', '13800000012', 0, 3, '2026-04-02 18:00:33', '2026-04-17 13:59:20', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (13, 'gu', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '顾云舟', '96451@qq.com', '12345678910', 1, 4, '2026-04-07 22:08:17', '2026-04-17 13:59:20', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (14, 'shen', '$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC', '沈听澜', 'ydtfg@qq.com', '12345678910', 1, 2, '2026-04-14 20:39:57', '2026-04-23 18:22:02', 3, 1, '2026-04-23 18:22:02', NULL, 'unknown');
INSERT INTO `sys_user` VALUES (15, '沈渊', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '沈渊', 'egbf@test.com', '14785412304', 1, 4, '2026-04-24 21:16:15', '2026-04-24 21:43:27', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (16, 'lll', '$2a$10$bcyoNgD.5l5Vf9GCy1odO.bTK1GJWg0YtFgl/SzGUpdCQnLt.TybK', 'lwy', '3071624946@qq.com', '19986310535', 1, 4, '2026-04-23 11:56:58', '2026-04-30 10:09:30', 0, 0, NULL, '2026-04-30 10:09:30', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (17, 'tian', '$2a$10$qCWMKbAXDglIbuLZhrHoROvOzT2OL.IB2S0NcvfyxChAU4Jfgg9lW', '田昊鑫', '8452@qq.com', '18423047950', 1, 4, '2026-04-23 16:49:32', '2026-04-24 14:10:13', 0, 0, '2026-04-23 18:21:31', '2026-04-24 14:10:14', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (18, '陈宇航', '$2a$10$gOr3AFdjQE9lIWV0PWNk1e7/jhT2GPnYQ808O1jS6MXlX19UFyLi.', '陈宇航', '845@qq.com', '15987456201', 1, 4, '2026-04-24 20:57:03', '2026-04-24 20:57:22', 0, 0, NULL, '2026-04-24 20:57:23', '0:0:0:0:0:0:0:1');
INSERT INTO `sys_user` VALUES (19, '林若曦', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '林若曦', 'dhvvb415@qq.com', '13800000013', 1, 4, '2026-04-24 20:58:18', '2026-04-24 21:22:12', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (20, '林思远', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '林思远', 'fav@test.com', '13800000014', 2, 4, '2025-01-01 10:00:00', '2026-04-28 16:43:09', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (21, '王俊凯', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '王俊凯', 'gbdf@test.com', '13800000015', 1, 4, '2025-01-02 10:00:00', '2026-04-24 21:22:11', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (22, '刘子墨', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '刘子墨', 'egvc@test.com', '13800000016', 1, 4, '2025-01-03 10:00:00', '2026-04-24 21:22:12', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (23, '赵嘉诚', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '赵嘉诚', 'sgbc@test.com', '13800000017', 1, 4, '2025-01-04 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (24, '周浩然', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '周浩然', 'egve@test.com', '13800000018', 1, 4, '2025-01-05 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (25, '黄梓轩', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '黄梓轩', 'wedsv@test.com', '13800000019', 1, 4, '2025-01-06 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (26, '吴景行', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '吴景行', 'rgf@test.com', '13800000020', 1, 4, '2025-01-07 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (27, '徐晨曦', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '徐晨曦', 'wrg@test.com', '13800000021', 1, 4, '2025-01-08 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (28, '孙逸凡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '孙逸凡', 'uk@test.com', '13800000022', 1, 4, '2025-01-09 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (29, '何承泽', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '何承泽', 'ikj@test.com', '13800000023', 1, 4, '2025-01-10 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (30, '郭沐辰', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '郭沐辰', 'olikj@test.com', '13800000024', 1, 4, '2025-01-11 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (31, '马睿哲', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '马睿哲', 'ehnh@test.com', '13800000025', 1, 4, '2025-01-12 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (32, '高煜城', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '高煜城', 'umhn@test.com', '13800000026', 1, 4, '2025-01-13 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (33, '胡泽洋', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '胡泽洋', 'er@test.com', '13800000027', 1, 4, '2025-01-14 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (34, '朱奕辰', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '朱奕辰', 'pokj@test.com', '13800000028', 1, 4, '2025-01-15 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (35, '曹铭轩', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '曹铭轩', 'efygh@test.com', '13800000029', 1, 4, '2025-01-16 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (36, '袁皓轩', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '袁皓轩', 'lkj@test.com', '13800000030', 1, 4, '2025-01-17 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (37, '邓嘉树', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '邓嘉树', 'wredfg@test.com', '13800000031', 1, 4, '2025-01-18 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (38, '彭子昂', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '彭子昂', 'dfgh@test.com', '13800000032', 1, 4, '2025-01-19 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (39, '韩亦凡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '韩亦凡', 'ewgdf@test.com', '13800000033', 1, 4, '2025-01-20 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (40, '梁启明', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '梁启明', 'gdsv@test.com', '13800000034', 1, 4, '2025-01-21 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (41, '谢雨辰', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '谢雨辰', 'sdvcx@test.com', '13800000035', 1, 4, '2025-01-22 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (42, '唐一鸣', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '唐一鸣', 'srgfv@test.com', '13800000036', 1, 4, '2025-01-23 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (43, '罗景程', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '罗景程', 'dvc@test.com', '13800000037', 1, 4, '2025-01-24 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (44, '郑昊然', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '郑昊然', 'kjhn@test.com', '13800000038', 1, 4, '2025-01-25 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (45, '许泽楷', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '许泽楷', 'zx@test.com', '13800000039', 1, 4, '2025-01-26 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (46, '冯宇辰', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '冯宇辰', 'efd@test.com', '13800000040', 1, 4, '2025-01-27 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (47, '宋浩宇', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '宋浩宇', 'rgfv@test.com', '13800000041', 1, 4, '2025-01-28 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (48, '蒋承宇', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '蒋承宇', 'kjhg@test.com', '13800000042', 1, 4, '2025-01-29 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (49, '沈逸晨', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '沈逸晨', 'w4terfsd@test.com', '13800000043', 1, 4, '2025-01-30 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (50, '魏泽阳', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '魏泽阳', 'ewsdf@test.com', '13800000044', 1, 4, '2025-01-31 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (51, '吕俊豪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '吕俊豪', '4tre@test.com', '13800000045', 1, 4, '2025-02-01 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (52, '丁一航', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '丁一航', '9oiuj@test.com', '13800000046', 1, 4, '2025-02-02 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (53, '杜明轩', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '杜明轩', '5yet@test.com', '13800000047', 1, 4, '2025-02-03 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (54, '任泽宇', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '任泽宇', '3245rt@test.com', '13800000048', 1, 4, '2025-02-04 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (55, '姚书恒', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '姚书恒', '5rtg@test.com', '13800000049', 1, 4, '2025-02-05 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (56, '卢景泽', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '卢景泽', 'tgf6@test.com', '13800000050', 1, 4, '2025-02-06 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (57, '潘宇航', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '潘宇航', 'jyhg5@test.com', '13800000051', 1, 4, '2025-02-07 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (58, '戴浩然', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '戴浩然', 'etdg@test.com', '13800000052', 1, 4, '2025-02-08 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (59, '苏子昂', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '苏子昂', 'kjh@test.com', '13800000053', 1, 4, '2025-02-09 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (60, '叶承泽', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '叶承泽', 'poikjh@test.com', '13800000054', 1, 4, '2025-02-10 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (61, '范宇辰', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '范宇辰', 'erfd@test.com', '13800000055', 1, 4, '2025-02-11 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (62, '江昊宇', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '江昊宇', 'rffffb@test.com', '13800000056', 1, 4, '2025-02-12 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (63, '钟嘉懿', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '钟嘉懿', 'rgfb@test.com', '13800000057', 1, 4, '2025-02-13 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (64, '石景天', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '石景天', '53dgf@test.com', '13800000058', 1, 4, '2025-02-14 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (65, '陆泽轩', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '陆泽轩', 'dfgsg@test.com', '13800000059', 1, 4, '2025-02-15 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (66, '程一鸣', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '程一鸣', 'uytfv@test.com', '13800000060', 1, 4, '2025-02-16 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (67, '顾宇辰', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '顾宇辰', 'jhgnfb@test.com', '13800000061', 1, 4, '2025-02-17 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (68, '夏明远', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '夏明远', 'esdfgg@test.com', '13800000062', 1, 4, '2025-02-18 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (69, '陈雨桐', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '陈雨桐', 'rgfdv@test.com', '13800000063', 1, 4, '2025-02-19 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (70, '王语嫣', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '王语嫣', 'yhgf@test.com', '13800000064', 1, 4, '2025-02-20 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (71, '刘诗涵', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '刘诗涵', 'wrgd@test.com', '13800000065', 1, 4, '2025-02-21 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (72, '赵梦琪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '赵梦琪', 'jhg@test.com', '13800000066', 1, 4, '2025-02-22 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (73, '周依然', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '周依然', 'wgdf@test.com', '13800000067', 1, 4, '2025-02-23 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (74, '黄思雨', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '黄思雨', 'iukjhg@test.com', '13800000068', 1, 4, '2025-02-24 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (75, '吴婉清', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '吴婉清', 'werdfg@test.com', '13800000069', 1, 4, '2025-02-25 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (76, '徐静怡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '徐静怡', 'wergdhfg@test.com', '13800000070', 1, 4, '2025-02-26 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (77, '孙雅琪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '孙雅琪', 'jhgbf@test.com', '13800000071', 1, 4, '2025-02-27 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (78, '何欣妍', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '何欣妍', 'qewf@test.com', '13800000072', 1, 4, '2025-02-28 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (79, '郭雨菲', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '郭雨菲', 'wegsf@test.com', '13800000073', 1, 4, '2025-03-01 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (80, '马可馨', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '马可馨', '3rfrefd@test.com', '13800000074', 1, 4, '2025-03-02 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (81, '高子萱', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '高子萱', 'htgfdv@test.com', '13800000075', 1, 4, '2025-03-03 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (82, '胡雨欣', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '胡雨欣', 'qwefgdfbg@test.com', '13800000076', 1, 4, '2025-03-04 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (83, '朱梓涵', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '朱梓涵', 'okujhgf@test.com', '13800000077', 1, 4, '2025-03-05 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (84, '曹若彤', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '曹若彤', 'tregfd@test.com', '13800000078', 1, 4, '2025-03-06 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (85, '袁欣然', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '袁欣然', '6uyht@test.com', '13800000079', 1, 4, '2025-03-07 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (86, '邓雨薇', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '邓雨薇', 'regfd@test.com', '13800000080', 1, 4, '2025-03-08 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (87, '彭依婷', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '彭依婷', '5yreg@test.com', '13800000081', 1, 4, '2025-03-09 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (88, '韩梦瑶', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '韩梦瑶', '7uhytr@test.com', '13800000082', 1, 4, '2025-03-10 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (89, '梁思琪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '梁思琪', '34ergt@test.com', '13800000083', 1, 4, '2025-03-11 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (90, '谢语彤', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '谢语彤', '43terg@test.com', '13800000084', 1, 4, '2025-03-12 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (91, '唐诗雨', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '唐诗雨', '45yerthg@test.com', '13800000085', 1, 4, '2025-03-13 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (92, '罗婉莹', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '罗婉莹', '43ertg@test.com', '13800000086', 1, 4, '2025-03-14 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (93, '郑依娜', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '郑依娜', '234regfd@test.com', '13800000087', 1, 4, '2025-03-15 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (94, '许梦洁', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '许梦洁', 'htrf@test.com', '13800000088', 1, 4, '2025-03-16 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (95, '冯子怡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '冯子怡', 'ythgfsd@test.com', '13800000089', 1, 4, '2025-03-17 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (96, '宋雨涵', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '宋雨涵', 'werghdf@test.com', '13800000090', 1, 4, '2025-03-18 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (97, '蒋欣怡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '蒋欣怡', '34rf@test.com', '13800000091', 1, 4, '2025-03-19 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (98, '沈梦妍', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '沈梦妍', '24rt@test.com', '13800000092', 1, 4, '2025-03-20 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (99, '魏可欣', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '魏可欣', 'trf4red@test.com', '13800000093', 1, 4, '2025-03-21 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (100, '吕诗琪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '吕诗琪', '324rge@test.com', '13800000094', 1, 4, '2025-03-22 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (101, '丁语涵', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '丁语涵', '87uyg@test.com', '13800000095', 1, 4, '2025-03-23 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (102, '杜欣悦', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '杜欣悦', '34rf@test.com', '13800000096', 1, 4, '2025-03-24 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (103, '任佳怡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '任佳怡', '2435tfd@test.com', '13800000097', 1, 4, '2025-03-25 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (104, '姚诗涵', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '姚诗涵', '76trf@test.com', '13800000098', 1, 4, '2025-03-26 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (105, '卢梦婷', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '卢梦婷', '345rf@test.com', '13800000099', 1, 4, '2025-03-27 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (106, '潘依琳', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '潘依琳', '6tf@test.com', '13800000100', 1, 4, '2025-03-28 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (107, '戴雨萱', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '戴雨萱', '34rf@test.com', '13800000101', 1, 4, '2025-03-29 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (108, '苏可欣', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '苏可欣', '34rfdsssssfg@test.com', '13800000102', 1, 4, '2025-03-30 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (109, '叶雨彤', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '叶雨彤', '7ytgf@test.com', '13800000103', 1, 4, '2025-03-31 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (110, '范诗琪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '范诗琪', '1qas@test.com', '13800000104', 1, 4, '2025-04-01 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (111, '江梦瑶', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '江梦瑶', '2ws@test.com', '13800000105', 1, 4, '2025-04-02 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (112, '钟婉婷', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '钟婉婷', '3eddc@test.com', '13800000106', 1, 4, '2025-04-03 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (113, '石雨桐', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '石雨桐', '4rffv@test.com', '13800000107', 1, 4, '2025-04-04 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (114, '陆欣怡', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '陆欣怡', '5tgb@test.com', '13800000108', 1, 4, '2025-04-05 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (115, '程梦涵', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '程梦涵', '6yhn@test.com', '13800000109', 1, 4, '2025-04-06 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (116, '顾依婷', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '顾依婷', '7ujm@test.com', '13800000110', 1, 4, '2025-04-07 10:00:00', '2026-04-24 21:23:53', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (117, '夏雨菲', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '夏雨菲', '8ikkkk@test.com', '13800000111', 0, 4, '2025-04-08 10:00:00', '2026-04-28 16:42:51', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (118, '安若溪', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '安若溪', '9ol@test.com', '13800000112', 0, 4, '2025-04-09 10:00:00', '2026-04-28 16:38:23', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (119, '顾清妍', '$2a$10$CEd0/yJiR0WLLaOUXaE/yeWqL6Pzm8tdT1qQEsEPdn/nAlO/OyqG.', '顾清妍', '0poij@test.com', '13800000113', 0, 4, '2025-04-10 10:00:00', '2026-04-28 16:09:45', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (120, 'zzz', '$2a$10$tQx/OPW4UXlwk8wrjDxkfOHKrrutHWCV9F7eljB41amfiaaKAGN7W', '曾珍', '451@qq.com', '12340587021', 0, 3, '2026-04-26 23:01:58', '2026-04-27 11:47:31', 0, 0, NULL, NULL, NULL);
INSERT INTO `sys_user` VALUES (121, 'llll', '$2a$10$CS5y/kWnnM4l8Mt7yXihkuaS1Z7hy8ERkYmp9N4suDIr.Pn0raWeu', '零零零零', 'hjgddd@qq.com', '14785013654', 1, 4, '2026-04-27 11:49:17', '2026-04-27 11:50:07', 0, 0, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for system_notification
-- ----------------------------
DROP TABLE IF EXISTS `system_notification`;
CREATE TABLE `system_notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '通知ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知内容',
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '通知类型：LOAN_APPLY(借展申请)、LOAN_OVERDUE(借展逾期)、REPAIR_APPLY(修复申请)、LOAN_APPROVED(借展审批通过)、LOAN_REJECTED(借展审批拒绝)、REPAIR_APPROVED(修复审批通过)、REPAIR_REJECTED(修复审批拒绝)',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'NORMAL' COMMENT '优先级：LOW(低)、NORMAL(普通)、HIGH(高)、URGENT(紧急)',
  `related_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联类型：LOAN(借展)、REPAIR(修复)',
  `related_id` bigint NULL DEFAULT NULL COMMENT '关联ID（借展记录ID或修复记录ID）',
  `sender_id` bigint NULL DEFAULT NULL COMMENT '发送人ID',
  `sender_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发送人姓名',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_type`(`type`) USING BTREE,
  INDEX `idx_related`(`related_type`, `related_id`) USING BTREE,
  INDEX `idx_create_time`(`create_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 31 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统通知表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of system_notification
-- ----------------------------
INSERT INTO `system_notification` VALUES (1, '借展申请已通过', '您申请借展的文物\"北宋铜钱串\"已被 admin 审批通过。', 'LOAN_APPROVED', 'NORMAL', 'LOAN', 28, NULL, 'admin', '2026-04-24 17:03:07');
INSERT INTO `system_notification` VALUES (2, '新的借展申请', '用户 lwy 提交了文物\"春秋青铜编钟\"的借展申请，请及时审批。', 'LOAN_APPLY', 'NORMAL', 'LOAN', 29, 16, 'lwy', '2026-04-24 17:03:38');
INSERT INTO `system_notification` VALUES (3, '用户主动归还文物', '用户 lll 已主动归还文物\"清代官服\"，请及时确认。', 'USER_RETURN', 'HIGH', 'LOAN', 26, NULL, 'lll', '2026-04-27 13:36:17');
INSERT INTO `system_notification` VALUES (4, '用户主动归还文物', '用户 lll 已主动归还文物\"北宋铜钱串\"，请及时确认。', 'USER_RETURN', 'HIGH', 'LOAN', 28, NULL, 'lll', '2026-04-27 16:04:30');
INSERT INTO `system_notification` VALUES (5, '借展申请已驳回', '您申请借展的文物\"春秋青铜编钟\"已被 admin 驳回。', 'LOAN_REJECTED', 'NORMAL', 'LOAN', 29, NULL, 'admin', '2026-04-28 14:00:03');
INSERT INTO `system_notification` VALUES (6, '新的修复申请', '文物\"大禹鼎\"提交了修复申请，修复原因：鼎身破损，请及时审批。', 'REPAIR_APPLY', 'NORMAL', 'REPAIR', 18, 1, NULL, '2026-04-28 17:40:50');
INSERT INTO `system_notification` VALUES (7, '新的修复申请', '文物\"汝窑天青釉盏\"提交了修复申请，修复原因：瓶身氧化，请及时审批。', 'REPAIR_APPLY', 'NORMAL', 'REPAIR', 19, 1, NULL, '2026-04-28 17:53:42');
INSERT INTO `system_notification` VALUES (8, '修复申请已更新', '文物\"汉代石碑\"的修复申请已更新，修复原因：需要进行保养性修复，请重新审核。', 'REPAIR_UPDATE', 'NORMAL', 'REPAIR', 25, 2, NULL, '2026-04-28 23:12:48');
INSERT INTO `system_notification` VALUES (9, '修复申请已撤回', '文物\"北魏石佛头像\"的修复申请已被撤回，原修复原因：表面锈蚀。', 'REPAIR_WITHDRAW', 'NORMAL', 'REPAIR', 6, 2, NULL, '2026-04-28 23:15:51');
INSERT INTO `system_notification` VALUES (10, '借展申请已通过', '您申请借展的文物\"明代云锦服饰\"已被 admin 审批通过。', 'LOAN_APPROVED', 'NORMAL', 'LOAN', 21, NULL, 'admin', '2026-04-29 22:00:33');
INSERT INTO `system_notification` VALUES (11, '借展申请已驳回', '您申请借展的文物\"明代木雕佛龛\"已被 admin 驳回。', 'LOAN_REJECTED', 'NORMAL', 'LOAN', 20, NULL, 'admin', '2026-04-29 22:00:35');
INSERT INTO `system_notification` VALUES (12, '修复申请已拒绝', '文物\"曾侯乙编钟\"的修复申请已被 chen 拒绝。', 'REPAIR_REJECTED', 'NORMAL', 'REPAIR', 7, NULL, 'chen', '2026-04-29 22:06:01');
INSERT INTO `system_notification` VALUES (13, '新的修复申请', '文物\"兵马俑\"提交了修复申请，修复原因：兵马俑破损，请及时审批。', 'REPAIR_APPLY', 'NORMAL', 'REPAIR', 26, 2, NULL, '2026-04-29 22:26:39');
INSERT INTO `system_notification` VALUES (14, '新的修复申请', '文物\"战国龙纹玉璧\"提交了修复申请，修复原因：保养，请及时审批。', 'REPAIR_APPLY', 'NORMAL', 'REPAIR', 27, 2, NULL, '2026-04-29 22:27:37');
INSERT INTO `system_notification` VALUES (15, '维护申请已通过', '文物\"北魏石佛头像\"的维护申请已被 chen 审批通过。', 'MAINTENANCE_APPROVED', 'NORMAL', 'MAINTENANCE', 33, NULL, 'chen', '2026-04-29 22:29:02');
INSERT INTO `system_notification` VALUES (16, '维护申请已拒绝', '文物\"汉代彩绘陶俑\"的维护申请已被 chen 拒绝。', 'MAINTENANCE_REJECTED', 'NORMAL', 'MAINTENANCE', 12, NULL, 'chen', '2026-04-29 22:29:06');
INSERT INTO `system_notification` VALUES (17, '修复申请已通过', '文物\"战国龙纹玉璧\"的修复申请已被 chen 审批通过。', 'REPAIR_APPROVED', 'NORMAL', 'REPAIR', 27, NULL, 'chen', '2026-04-29 22:35:41');
INSERT INTO `system_notification` VALUES (18, '修复申请已更新', '文物\"兵马俑\"的修复申请已更新，修复原因：兵马俑破损，请重新审核。', 'REPAIR_UPDATE', 'NORMAL', 'REPAIR', 26, 2, NULL, '2026-04-29 22:58:13');
INSERT INTO `system_notification` VALUES (19, '修复申请已拒绝', '文物\"兵马俑\"的修复申请已被 陈淑华 拒绝。', 'REPAIR_REJECTED', 'NORMAL', 'REPAIR', 26, NULL, '陈淑华', '2026-04-29 23:22:51');
INSERT INTO `system_notification` VALUES (20, '修复申请已拒绝', '文物\"汉代石碑\"的修复申请已被 陈淑华 拒绝。', 'REPAIR_REJECTED', 'NORMAL', 'REPAIR', 25, NULL, '陈淑华', '2026-04-29 23:23:32');
INSERT INTO `system_notification` VALUES (21, '维护申请已通过', '文物\"清代官服\"的维护申请已被 张明远 审批通过。', 'MAINTENANCE_APPROVED', 'NORMAL', 'MAINTENANCE', 32, NULL, '张明远', '2026-04-30 10:13:36');
INSERT INTO `system_notification` VALUES (22, '维护申请已拒绝', '文物\"明代木雕佛龛\"的维护申请已被 张明远 拒绝。', 'MAINTENANCE_REJECTED', 'NORMAL', 'MAINTENANCE', 30, NULL, '张明远', '2026-04-30 10:13:39');
INSERT INTO `system_notification` VALUES (23, '文物逾期未归还', '用户 lwy 借展的文物\"明代剔红盒\"已逾期 682 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 25, NULL, NULL, '2026-05-13 08:34:49');
INSERT INTO `system_notification` VALUES (24, '文物逾期未归还', '用户 lwy 借展的文物\"明代云锦服饰\"已逾期 631 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 21, NULL, NULL, '2026-05-13 08:34:49');
INSERT INTO `system_notification` VALUES (25, '文物逾期未归还', '用户 lwy 借展的文物\"汉碑残拓\"已逾期 672 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 16, NULL, NULL, '2026-05-13 08:34:49');
INSERT INTO `system_notification` VALUES (26, '文物逾期未归还', '用户 lwy 借展的文物\"汉代丝织残片\"已逾期 681 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 15, NULL, NULL, '2026-05-13 08:34:49');
INSERT INTO `system_notification` VALUES (27, '文物逾期未归还', '用户 lwy 借展的文物\"北魏造像碑\"已逾期 23 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 10, NULL, NULL, '2026-05-13 08:34:49');
INSERT INTO `system_notification` VALUES (28, '文物逾期未归还', '用户 lwy 借展的文物\"汉代青铜镜\"已逾期 25 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 9, NULL, NULL, '2026-05-13 08:34:50');
INSERT INTO `system_notification` VALUES (29, '文物逾期未归还', '用户 lwy 借展的文物\"汉代彩绘陶俑\"已逾期 31 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 6, NULL, NULL, '2026-05-13 08:34:50');
INSERT INTO `system_notification` VALUES (30, '文物逾期未归还', '用户 lwy 借展的文物\"大禹鼎\"已逾期 33 天未归还，请及时处理。', 'LOAN_OVERDUE', 'HIGH', 'LOAN', 5, NULL, NULL, '2026-05-13 08:34:50');

-- ----------------------------
-- Table structure for user_museum
-- ----------------------------
DROP TABLE IF EXISTS `user_museum`;
CREATE TABLE `user_museum`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `museum_id` bigint NOT NULL COMMENT '博物馆ID',
  `is_primary` tinyint NULL DEFAULT 1 COMMENT '是否主要博物馆：1是 0否',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_user_museum`(`user_id`, `museum_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_museum_id`(`museum_id`) USING BTREE,
  CONSTRAINT `user_museum_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_museum_ibfk_2` FOREIGN KEY (`museum_id`) REFERENCES `museum` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 119 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户博物馆关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_museum
-- ----------------------------
INSERT INTO `user_museum` VALUES (1, 8, 1, 1, '2026-04-23 11:26:24', '2026-04-23 11:26:25');
INSERT INTO `user_museum` VALUES (2, 13, 2, 1, '2026-04-23 11:26:37', '2026-04-23 11:26:39');
INSERT INTO `user_museum` VALUES (3, 16, 9, 1, '2026-04-23 11:56:57', '2026-04-23 11:56:57');
INSERT INTO `user_museum` VALUES (4, 17, 7, 1, '2026-04-23 16:49:31', '2026-04-23 16:49:31');
INSERT INTO `user_museum` VALUES (5, 18, 1, 1, '2026-04-24 20:57:03', '2026-04-24 20:57:03');
INSERT INTO `user_museum` VALUES (6, 19, 2, 1, '2026-04-24 20:58:18', '2026-04-24 20:58:18');
INSERT INTO `user_museum` VALUES (8, 21, 2, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (9, 22, 3, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (10, 23, 4, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (11, 24, 5, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (12, 25, 6, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (13, 26, 7, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (14, 27, 8, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (15, 28, 9, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (16, 29, 10, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (17, 30, 11, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (18, 31, 12, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (19, 32, 13, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (20, 33, 14, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (21, 34, 15, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (22, 35, 16, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (23, 36, 17, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (24, 37, 18, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (25, 38, 19, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (26, 39, 20, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (27, 40, 21, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (28, 41, 22, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (29, 42, 23, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (30, 43, 24, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (31, 44, 25, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (32, 45, 26, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (33, 46, 27, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (34, 47, 28, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (35, 48, 29, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (36, 49, 30, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (37, 50, 31, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (38, 51, 32, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (39, 52, 33, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (40, 53, 34, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (41, 54, 35, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (42, 55, 36, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (43, 56, 37, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (44, 57, 38, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (45, 58, 39, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (46, 59, 40, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (47, 60, 41, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (48, 61, 42, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (49, 62, 43, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (50, 63, 44, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (51, 64, 45, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (52, 65, 46, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (53, 66, 47, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (54, 67, 48, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (55, 68, 49, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (56, 69, 50, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (57, 70, 51, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (58, 71, 52, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (59, 72, 53, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (60, 73, 54, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (61, 74, 55, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (62, 75, 56, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (63, 76, 57, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (64, 77, 58, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (65, 78, 59, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (66, 79, 60, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (67, 80, 61, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (68, 81, 62, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (69, 82, 63, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (70, 83, 64, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (71, 84, 65, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (72, 85, 66, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (73, 86, 67, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (74, 87, 68, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (75, 88, 69, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (76, 89, 70, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (77, 90, 71, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (78, 91, 72, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (79, 92, 73, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (80, 93, 74, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (81, 94, 75, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (82, 95, 76, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (83, 96, 77, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (84, 97, 78, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (85, 98, 79, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (86, 99, 80, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (87, 100, 81, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (88, 101, 82, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (89, 102, 83, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (90, 103, 84, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (91, 104, 85, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (92, 105, 86, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (93, 106, 87, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (94, 107, 88, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (95, 108, 89, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (96, 109, 90, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (97, 110, 91, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (98, 111, 92, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (99, 112, 93, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (100, 113, 94, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (101, 114, 95, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (102, 115, 96, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (103, 116, 97, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (104, 117, 98, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (105, 118, 99, 1, '2025-01-01 10:00:00', '2025-01-01 10:00:00');
INSERT INTO `user_museum` VALUES (108, 7, 1, 1, '2026-04-24 21:43:23', '2026-04-24 21:43:23');
INSERT INTO `user_museum` VALUES (109, 15, 1, 1, '2026-04-24 21:43:27', '2026-04-24 21:43:27');
INSERT INTO `user_museum` VALUES (111, 6, 1, 1, '2026-04-27 09:02:32', '2026-04-27 09:02:32');
INSERT INTO `user_museum` VALUES (116, 119, 100, 1, '2026-04-27 11:50:07', '2026-04-27 11:50:07');
INSERT INTO `user_museum` VALUES (117, 121, 1, 1, '2026-04-27 11:50:07', '2026-04-27 11:50:07');
INSERT INTO `user_museum` VALUES (118, 20, 1, 1, '2026-04-28 16:43:09', '2026-04-28 16:43:09');

-- ----------------------------
-- Table structure for user_notification
-- ----------------------------
DROP TABLE IF EXISTS `user_notification`;
CREATE TABLE `user_notification`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `notification_id` bigint NOT NULL COMMENT '通知ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `is_read` tinyint NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
  `read_time` datetime NULL DEFAULT NULL COMMENT '阅读时间',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_notification_user`(`notification_id`, `user_id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_is_read`(`is_read`) USING BTREE,
  CONSTRAINT `user_notification_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `system_notification` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_notification_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户通知关联表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_notification
-- ----------------------------
INSERT INTO `user_notification` VALUES (1, 1, 16, 1, '2026-04-24 18:08:50', '2026-04-24 17:03:07');
INSERT INTO `user_notification` VALUES (2, 2, 1, 1, '2026-04-24 17:03:42', '2026-04-24 17:03:38');
INSERT INTO `user_notification` VALUES (3, 2, 4, 1, '2026-04-25 20:15:55', '2026-04-24 17:03:38');
INSERT INTO `user_notification` VALUES (4, 2, 5, 0, NULL, '2026-04-24 17:03:38');
INSERT INTO `user_notification` VALUES (5, 2, 10, 0, NULL, '2026-04-24 17:03:38');
INSERT INTO `user_notification` VALUES (6, 3, 1, 1, '2026-04-27 13:36:31', '2026-04-27 13:36:17');
INSERT INTO `user_notification` VALUES (7, 3, 4, 1, '2026-04-29 12:02:50', '2026-04-27 13:36:17');
INSERT INTO `user_notification` VALUES (8, 3, 5, 0, NULL, '2026-04-27 13:36:17');
INSERT INTO `user_notification` VALUES (9, 3, 10, 0, NULL, '2026-04-27 13:36:17');
INSERT INTO `user_notification` VALUES (10, 4, 1, 1, '2026-04-27 16:04:37', '2026-04-27 16:04:30');
INSERT INTO `user_notification` VALUES (11, 4, 4, 1, '2026-04-29 12:02:50', '2026-04-27 16:04:30');
INSERT INTO `user_notification` VALUES (12, 4, 5, 0, NULL, '2026-04-27 16:04:30');
INSERT INTO `user_notification` VALUES (13, 4, 10, 0, NULL, '2026-04-27 16:04:30');
INSERT INTO `user_notification` VALUES (14, 5, 16, 1, '2026-04-28 15:48:41', '2026-04-28 14:00:03');
INSERT INTO `user_notification` VALUES (15, 6, 1, 1, '2026-04-28 17:41:01', '2026-04-28 17:40:50');
INSERT INTO `user_notification` VALUES (16, 6, 2, 1, '2026-04-28 17:55:03', '2026-04-28 17:40:50');
INSERT INTO `user_notification` VALUES (17, 6, 3, 0, NULL, '2026-04-28 17:40:50');
INSERT INTO `user_notification` VALUES (18, 6, 9, 0, NULL, '2026-04-28 17:40:50');
INSERT INTO `user_notification` VALUES (19, 6, 11, 0, NULL, '2026-04-28 17:40:50');
INSERT INTO `user_notification` VALUES (20, 6, 14, 0, NULL, '2026-04-28 17:40:50');
INSERT INTO `user_notification` VALUES (21, 7, 1, 1, '2026-04-28 21:20:39', '2026-04-28 17:53:42');
INSERT INTO `user_notification` VALUES (22, 7, 2, 1, '2026-04-28 17:55:02', '2026-04-28 17:53:42');
INSERT INTO `user_notification` VALUES (23, 7, 3, 0, NULL, '2026-04-28 17:53:42');
INSERT INTO `user_notification` VALUES (24, 7, 9, 0, NULL, '2026-04-28 17:53:42');
INSERT INTO `user_notification` VALUES (25, 7, 11, 0, NULL, '2026-04-28 17:53:42');
INSERT INTO `user_notification` VALUES (26, 7, 14, 0, NULL, '2026-04-28 17:53:42');
INSERT INTO `user_notification` VALUES (27, 8, 1, 1, '2026-04-28 23:15:44', '2026-04-28 23:12:48');
INSERT INTO `user_notification` VALUES (28, 9, 1, 1, '2026-04-28 23:15:57', '2026-04-28 23:15:51');
INSERT INTO `user_notification` VALUES (29, 10, 16, 1, '2026-04-29 22:00:51', '2026-04-29 22:00:33');
INSERT INTO `user_notification` VALUES (30, 11, 16, 1, '2026-04-29 22:00:51', '2026-04-29 22:00:35');
INSERT INTO `user_notification` VALUES (31, 12, 2, 1, '2026-04-29 22:06:25', '2026-04-29 22:06:01');
INSERT INTO `user_notification` VALUES (32, 13, 1, 1, '2026-04-29 22:50:04', '2026-04-29 22:26:39');
INSERT INTO `user_notification` VALUES (33, 13, 2, 1, '2026-04-29 22:29:15', '2026-04-29 22:26:39');
INSERT INTO `user_notification` VALUES (34, 13, 3, 0, NULL, '2026-04-29 22:26:39');
INSERT INTO `user_notification` VALUES (35, 13, 9, 0, NULL, '2026-04-29 22:26:39');
INSERT INTO `user_notification` VALUES (36, 13, 11, 0, NULL, '2026-04-29 22:26:39');
INSERT INTO `user_notification` VALUES (37, 13, 14, 0, NULL, '2026-04-29 22:26:39');
INSERT INTO `user_notification` VALUES (38, 14, 1, 1, '2026-04-29 22:50:03', '2026-04-29 22:27:37');
INSERT INTO `user_notification` VALUES (39, 14, 2, 1, '2026-04-29 22:29:15', '2026-04-29 22:27:37');
INSERT INTO `user_notification` VALUES (40, 14, 3, 0, NULL, '2026-04-29 22:27:37');
INSERT INTO `user_notification` VALUES (41, 14, 9, 0, NULL, '2026-04-29 22:27:37');
INSERT INTO `user_notification` VALUES (42, 14, 11, 0, NULL, '2026-04-29 22:27:37');
INSERT INTO `user_notification` VALUES (43, 14, 14, 0, NULL, '2026-04-29 22:27:37');
INSERT INTO `user_notification` VALUES (44, 15, 2, 1, '2026-04-29 22:29:15', '2026-04-29 22:29:02');
INSERT INTO `user_notification` VALUES (45, 16, 9, 0, NULL, '2026-04-29 22:29:06');
INSERT INTO `user_notification` VALUES (46, 17, 2, 1, '2026-04-29 22:43:45', '2026-04-29 22:35:41');
INSERT INTO `user_notification` VALUES (47, 18, 1, 1, '2026-04-30 10:37:58', '2026-04-29 22:58:13');
INSERT INTO `user_notification` VALUES (48, 19, 2, 1, '2026-04-29 23:23:38', '2026-04-29 23:22:51');
INSERT INTO `user_notification` VALUES (49, 20, 2, 1, '2026-04-29 23:23:40', '2026-04-29 23:23:32');
INSERT INTO `user_notification` VALUES (50, 21, 2, 1, '2026-05-13 16:35:01', '2026-04-30 10:13:36');
INSERT INTO `user_notification` VALUES (51, 22, 14, 0, NULL, '2026-04-30 10:13:39');
INSERT INTO `user_notification` VALUES (52, 23, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (53, 23, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (54, 23, 3, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (55, 23, 9, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (56, 23, 11, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (57, 23, 14, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (58, 24, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (59, 24, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (60, 24, 3, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (61, 24, 9, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (62, 24, 11, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (63, 24, 14, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (64, 25, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (65, 25, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (66, 25, 3, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (67, 25, 9, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (68, 25, 11, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (69, 25, 14, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (70, 26, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (71, 26, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (72, 26, 3, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (73, 26, 9, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (74, 26, 11, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (75, 26, 14, 0, NULL, '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (76, 27, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (77, 27, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:49');
INSERT INTO `user_notification` VALUES (78, 27, 3, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (79, 27, 9, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (80, 27, 11, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (81, 27, 14, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (82, 28, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (83, 28, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (84, 28, 3, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (85, 28, 9, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (86, 28, 11, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (87, 28, 14, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (88, 29, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (89, 29, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (90, 29, 3, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (91, 29, 9, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (92, 29, 11, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (93, 29, 14, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (94, 30, 1, 1, '2026-05-13 14:57:14', '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (95, 30, 2, 1, '2026-05-13 16:35:01', '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (96, 30, 3, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (97, 30, 9, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (98, 30, 11, 0, NULL, '2026-05-13 08:34:50');
INSERT INTO `user_notification` VALUES (99, 30, 14, 0, NULL, '2026-05-13 08:34:50');

-- ----------------------------
-- Table structure for verification_code
-- ----------------------------
DROP TABLE IF EXISTS `verification_code`;
CREATE TABLE `verification_code`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `code` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '验证码',
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '验证码类型：EMAIL-邮箱，PHONE-手机',
  `contact` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '联系方式（邮箱或手机号）',
  `purpose` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用途：RESET_PASSWORD-重置密码',
  `used` tinyint(1) NULL DEFAULT 0 COMMENT '是否已使用：0-未使用，1-已使用',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_username`(`username`) USING BTREE,
  INDEX `idx_code`(`code`) USING BTREE,
  INDEX `idx_expire_time`(`expire_time`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '验证码表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of verification_code
-- ----------------------------
INSERT INTO `verification_code` VALUES (5, 16, 'lll', '668473', 'EMAIL', 'lwy1472583692024@163.com', 'RESET_PASSWORD', 1, '2026-04-23 21:29:48', '2026-04-23 21:14:48');
INSERT INTO `verification_code` VALUES (6, 1, 'admin', '529543', 'EMAIL', '3071624946@qq.com', 'RESET_PASSWORD', 1, '2026-04-23 21:30:48', '2026-04-23 21:15:48');

-- ----------------------------
-- View structure for v_image_category_stats
-- ----------------------------
DROP VIEW IF EXISTS `v_image_category_stats`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_image_category_stats` AS select `image_library`.`category` AS `category`,count(0) AS `image_count`,sum(`image_library`.`file_size`) AS `total_size`,avg(`image_library`.`view_count`) AS `avg_views`,sum(`image_library`.`download_count`) AS `total_downloads` from `image_library` where (`image_library`.`status` = 1) group by `image_library`.`category`;

-- ----------------------------
-- View structure for v_operation_log_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_operation_log_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_operation_log_statistics` AS select cast(`sys_operation_log`.`operation_time` as date) AS `log_date`,`sys_operation_log`.`operation_type` AS `operation_type`,`sys_operation_log`.`operation_module` AS `operation_module`,`sys_operation_log`.`operation_result` AS `operation_result`,count(0) AS `operation_count`,count(distinct `sys_operation_log`.`user_id`) AS `user_count`,avg(`sys_operation_log`.`execution_time`) AS `avg_execution_time`,max(`sys_operation_log`.`execution_time`) AS `max_execution_time` from `sys_operation_log` where (`sys_operation_log`.`operation_time` >= (now() - interval 30 day)) group by cast(`sys_operation_log`.`operation_time` as date),`sys_operation_log`.`operation_type`,`sys_operation_log`.`operation_module`,`sys_operation_log`.`operation_result`;

-- ----------------------------
-- View structure for v_recent_images
-- ----------------------------
DROP VIEW IF EXISTS `v_recent_images`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_recent_images` AS select `image_library`.`id` AS `id`,`image_library`.`image_name` AS `image_name`,`image_library`.`file_path` AS `file_path`,`image_library`.`file_size` AS `file_size`,`image_library`.`category` AS `category`,`image_library`.`uploader_name` AS `uploader_name`,`image_library`.`view_count` AS `view_count`,`image_library`.`create_time` AS `create_time` from `image_library` where (`image_library`.`status` = 1) order by `image_library`.`create_time` desc limit 20;

-- ----------------------------
-- View structure for v_resource_operation_history
-- ----------------------------
DROP VIEW IF EXISTS `v_resource_operation_history`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_resource_operation_history` AS select `ol`.`id` AS `id`,`ol`.`resource_type` AS `resource_type`,`ol`.`resource_id` AS `resource_id`,`ol`.`operation_type` AS `operation_type`,`ol`.`operation_content` AS `operation_content`,`ol`.`operator` AS `operator`,`ol`.`user_id` AS `user_id`,`ol`.`operation_time` AS `operation_time`,`ol`.`before_data` AS `before_data`,`ol`.`after_data` AS `after_data`,`ol`.`changed_fields` AS `changed_fields` from `sys_operation_log` `ol` where ((`ol`.`resource_type` is not null) and (`ol`.`resource_id` is not null)) order by `ol`.`operation_time` desc;

-- ----------------------------
-- View structure for v_user_operation_statistics
-- ----------------------------
DROP VIEW IF EXISTS `v_user_operation_statistics`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `v_user_operation_statistics` AS select `u`.`id` AS `user_id`,`u`.`username` AS `username`,`u`.`real_name` AS `real_name`,count(`ol`.`id`) AS `total_operations`,count((case when (`ol`.`operation_result` = 'SUCCESS') then 1 end)) AS `success_count`,count((case when (`ol`.`operation_result` = 'FAIL') then 1 end)) AS `fail_count`,max(`ol`.`operation_time`) AS `last_operation_time` from (`sys_user` `u` left join `sys_operation_log` `ol` on((`u`.`id` = `ol`.`user_id`))) where (`ol`.`operation_time` >= (now() - interval 30 day)) group by `u`.`id`,`u`.`username`,`u`.`real_name`;

-- ----------------------------
-- Function structure for fn_count_changes
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_count_changes`;
delimiter ;;
CREATE FUNCTION `fn_count_changes`(changed_fields_json TEXT)
 RETURNS int
  DETERMINISTIC
BEGIN
    DECLARE change_count INT DEFAULT 0;

IF changed_fields_json IS NOT NULL AND changed_fields_json != '' THEN
        -- 简单计算：统计逗号数量+1
SET change_count = (LENGTH(changed_fields_json) - LENGTH(REPLACE(changed_fields_json, ',', ''))) + 1;
END IF;

RETURN change_count;
END
;;
delimiter ;

-- ----------------------------
-- Function structure for fn_get_relic_image_path
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_get_relic_image_path`;
delimiter ;;
CREATE FUNCTION `fn_get_relic_image_path`(p_relic_id BIGINT)
 RETURNS varchar(500) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
  READS SQL DATA 
  DETERMINISTIC
BEGIN
    DECLARE v_image_path VARCHAR(500);
    
    SELECT i.file_path INTO v_image_path
    FROM relic_image_relation ri
    JOIN image_library i ON ri.image_id = i.id
    WHERE ri.relic_id = p_relic_id 
      AND i.status = 1
    LIMIT 1;
    
    RETURN v_image_path;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_clean_old_logs
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_clean_old_logs`;
delimiter ;;
CREATE PROCEDURE `sp_clean_old_logs`(IN days INT)
BEGIN
    DECLARE deleted_count INT;

-- 删除指定天数之前的日志
DELETE FROM sys_operation_log
WHERE operation_time < DATE_SUB(NOW(), INTERVAL days DAY);

SET deleted_count = ROW_COUNT();

SELECT CONCAT('已删除 ', deleted_count, ' 条日志记录') AS result;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_get_resource_history
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_resource_history`;
delimiter ;;
CREATE PROCEDURE `sp_get_resource_history`(IN p_resource_type VARCHAR(50),
    IN p_resource_id BIGINT)
BEGIN
SELECT
    id,
    operation_type,
    operation_content,
    operator,
    operation_time,
    before_data,
    after_data,
    changed_fields,
    ip_address,
    execution_time
FROM sys_operation_log
WHERE resource_type = p_resource_type
  AND resource_id = p_resource_id
ORDER BY operation_time DESC;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_remove_relic_main_image
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_remove_relic_main_image`;
delimiter ;;
CREATE PROCEDURE `sp_remove_relic_main_image`(IN p_relic_id BIGINT)
BEGIN
    DECLARE v_image_id BIGINT;
    
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error: 移除文物主图失败' as message;
    END;
    
    START TRANSACTION;
    
    -- 获取关联的图片ID
    SELECT image_id INTO v_image_id 
    FROM relic_image_relation 
    WHERE relic_id = p_relic_id 
    LIMIT 1;
    
    -- 删除关联
    DELETE FROM relic_image_relation WHERE relic_id = p_relic_id;
    
    -- 清除图片的 reference 字段
    IF v_image_id IS NOT NULL THEN
        UPDATE image_library 
        SET reference_type = NULL, 
            reference_id = NULL,
            update_time = CURRENT_TIMESTAMP
        WHERE id = v_image_id;
    END IF;
    
    COMMIT;
    
    SELECT CONCAT('成功移除文物 ', p_relic_id, ' 的主图') as message;
END
;;
delimiter ;

-- ----------------------------
-- Procedure structure for sp_set_relic_main_image
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_set_relic_main_image`;
delimiter ;;
CREATE PROCEDURE `sp_set_relic_main_image`(IN p_relic_id BIGINT,
    IN p_image_id BIGINT)
BEGIN
    -- 将该文物的所有图片设置为非主图
    UPDATE relic_image_relation
    SET is_main = 0, relation_type = 'detail'
    WHERE relic_id = p_relic_id;

    -- 将指定图片设置为主图
    UPDATE relic_image_relation
    SET is_main = 1, relation_type = 'main'
    WHERE relic_id = p_relic_id AND image_id = p_image_id;

    SELECT '主图设置成功' AS message;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table cultural_relic
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_delete_relic_image_relation`;
delimiter ;;
CREATE TRIGGER `tr_delete_relic_image_relation` AFTER DELETE ON `cultural_relic` FOR EACH ROW BEGIN
    DELETE FROM relic_image_relation WHERE relic_id = OLD.id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table image_library
-- ----------------------------
DROP TRIGGER IF EXISTS `tr_delete_image_relic_relation`;
delimiter ;;
CREATE TRIGGER `tr_delete_image_relic_relation` AFTER DELETE ON `image_library` FOR EACH ROW BEGIN
    DELETE FROM relic_image_relation WHERE image_id = OLD.id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
