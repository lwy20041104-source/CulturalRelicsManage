-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: cultural_relics
-- ------------------------------------------------------
-- Server version	8.0.31

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ai_chat_message`
--

DROP TABLE IF EXISTS `ai_chat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `message_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息类型：user-用户消息, ai-AI回复',
  `content` text COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容',
  `query_keyword` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '查询关键词（用户消息时记录）',
  `result_count` int DEFAULT '0' COMMENT '返回结果数量（AI回复时记录）',
  `has_external_result` tinyint DEFAULT '0' COMMENT '是否包含外部搜索结果：0-否，1-是',
  `relic_ids` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '相关文物ID列表（逗号分隔）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_message_type` (`message_type`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='AI对话消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_chat_message`
--

LOCK TABLES `ai_chat_message` WRITE;
/*!40000 ALTER TABLE `ai_chat_message` DISABLE KEYS */;
INSERT INTO `ai_chat_message` VALUES (1,1,1,'user','请介绍一下商代青铜器的特点','商代,青铜器',0,0,NULL,'2024-03-01 10:00:00'),(2,1,1,'ai','商代青铜器是中国青铜时代的代表，主要特点包括：1.器型厚重，纹饰繁复；2.常见饕餮纹、夔龙纹等神秘图案；3.铸造工艺精湛，多采用分铸法。我馆收藏的商代青铜鼎就是典型代表。','商代,青铜器',1,0,'1','2024-03-01 10:02:00'),(3,1,1,'user','馆内有哪些商代青铜器？','商代,青铜器,馆藏',0,0,NULL,'2024-03-01 10:10:00'),(4,1,1,'ai','我馆目前收藏有商代青铜鼎（编号WW2024001），该文物出土于河南安阳，为三足圆鼎，腹部饰饕餮纹，铭文清晰，重38.5公斤，保存状态良好，目前在库。','商代,青铜器',1,0,'1','2024-03-01 10:15:00'),(5,2,2,'user','唐代有什么著名文物？','唐代,文物',0,0,NULL,'2024-03-05 11:00:00'),(6,2,2,'ai','唐代是中国文化的鼎盛时期，我馆收藏有多件唐代珍品：1.唐三彩马（WW2024007）；2.唐代青铜佛像（WW2024005）；3.唐代山水画卷（WW2024013）；4.唐代金杯（WW2024024）等。','唐代',4,0,'5,7,13,24','2024-03-05 11:05:00'),(7,2,2,'user','唐三彩的特点是什么？','唐三彩,特点',0,0,NULL,'2024-03-05 11:15:00'),(8,2,2,'ai','唐三彩是唐代低温釉陶器，主要特点：1.以黄、绿、白三色为主；2.釉色鲜艳，流动自然；3.多为陪葬品，造型生动。我馆的唐三彩马出土于洛阳，色彩保存完好，是研究唐代陶瓷艺术的重要实物。','唐三彩',1,1,'7','2024-03-05 11:20:00'),(9,3,3,'user','如何鉴别宋代瓷器？','宋代,瓷器,鉴别',0,0,NULL,'2024-03-10 14:00:00'),(10,3,3,'ai','宋代瓷器鉴别要点：1.釉色：汝窑天青、官窑粉青、哥窑开片；2.胎质：细腻坚致；3.器型：简洁优雅；4.工艺：施釉均匀。我馆收藏的宋代汝窑盘（WW2024008）就是典型的汝窑天青釉，开片自然，是鉴赏学习的好范本。','宋代,瓷器',1,1,'8','2024-03-10 14:10:00'),(11,3,3,'user','馆内有哪些宋代瓷器？','宋代,瓷器,馆藏',0,0,NULL,'2024-03-10 14:20:00'),(12,3,3,'ai','我馆收藏的宋代瓷器包括：宋代汝窑盘（WW2024008）、宋徽宗瘦金体书法（WW2024014，虽是书法但记录了宋代文化）等。汝窑盘是宋代五大名窑之一的代表作品。','宋代,瓷器',1,0,'8','2024-03-10 14:25:00'),(13,4,4,'user','王羲之的书法有什么特点？','王羲之,书法',0,0,NULL,'2024-03-15 09:00:00'),(14,4,4,'ai','王羲之被誉为\"书圣\"，其书法特点：1.笔法灵动，结构严谨；2.行书流畅自然，富有韵律；3.兰亭序是其代表作。我馆收藏有王羲之兰亭序摹本（WW2024012），为唐代摹本，是研究王羲之书法的珍贵资料。','王羲之,书法',1,1,'12','2024-03-15 09:15:00'),(15,4,4,'user','这个摹本可以借展吗？','借展,兰亭序',0,0,NULL,'2024-03-15 09:25:00'),(16,4,4,'ai','王羲之兰亭序摹本（WW2024012）目前状态为在库，理论上可以申请借展。但由于是纸本文物，较为脆弱，借展需要严格的环境控制和保护措施。建议您通过正式渠道提交借展申请，由审批员评估后决定。','借展',1,0,'12','2024-03-15 09:30:00'),(17,5,5,'user','玉器如何保养？','玉器,保养',0,0,NULL,'2024-03-20 10:00:00'),(18,5,5,'ai','玉器保养要点：1.避免碰撞，防止破损；2.定期清洁，用软布擦拭；3.避免接触化学物质；4.保持适当湿度，防止失水。我馆对玉器文物都有专业的保养流程，如新石器玉璧、汉代玉衣片等都定期进行维护。','玉器,保养',3,1,'18,19,20','2024-03-20 10:20:00'),(19,5,5,'user','良渚玉璧有什么文化意义？','良渚,玉璧',0,0,NULL,'2024-03-20 10:30:00'),(20,5,5,'ai','良渚玉璧是良渚文化的代表性器物，文化意义重大：1.礼器功能，用于祭祀；2.神人兽面纹体现原始宗教信仰；3.反映了5000年前的高度文明。我馆收藏的新石器玉璧（WW2024018）就出土于浙江良渚，直径25厘米，纹饰精美。','良渚,玉璧',1,1,'18','2024-03-20 10:40:00'),(21,6,1,'user','唐代金银器工艺如何？','唐代,金银器,工艺',0,0,NULL,'2024-04-01 11:00:00'),(22,6,1,'ai','唐代金银器工艺达到高峰：1.錾刻、鎏金技术精湛；2.造型华丽，纹饰繁复；3.受西域影响，风格多样。我馆收藏的唐代金杯（WW2024024）采用鎏金银杯工艺，錾刻花纹精美，是唐代金属工艺的代表作品。','唐代,金银器',1,1,'24','2024-04-01 11:10:00'),(23,6,1,'user','这件金杯现在状态如何？','金杯,状态',0,0,NULL,'2024-04-01 11:15:00'),(24,6,1,'ai','唐代金杯（WW2024024）目前状态为在库，保存良好。该文物在2024年4月10日进行过深度维护，包括清洁与防护处理。重量0.25公斤，出土于陕西西安，是研究唐代金属工艺的重要实物。','金杯',1,0,'24','2024-04-01 11:18:00'),(25,7,2,'user','汉代碑刻有什么特点？','汉代,碑刻',0,0,NULL,'2024-04-10 15:00:00'),(26,7,2,'ai','汉代碑刻特点：1.多用隶书，笔画方正；2.内容丰富，记录历史事件；3.石质坚硬，保存较好。我馆收藏的汉代石碑（WW2024029）出土于山东曲阜，碑文保存完整，是研究汉代书法和历史的重要资料。','汉代,碑刻',1,1,'29','2024-04-10 15:20:00'),(27,7,2,'user','碑刻如何保护？','碑刻,保护',0,0,NULL,'2024-04-10 15:30:00'),(28,7,2,'ai','碑刻保护措施：1.控制温湿度，防止风化；2.定期除尘清洁；3.避免阳光直射；4.必要时进行化学加固。我馆对汉代石碑和北魏造像碑都建立了完善的保护档案，定期进行维护检查。','碑刻,保护',2,1,'29,30','2024-04-10 15:35:00'),(29,8,3,'user','古代钱币如何鉴别真伪？','古代钱币,鉴别',0,0,NULL,'2024-04-20 13:00:00'),(30,8,3,'ai','古代钱币鉴别方法：1.看铜质和锈色；2.听声音，真品声音清脆；3.观察文字和纹饰；4.测量重量和尺寸。我馆收藏有战国刀币、秦半两、汉五铢、唐开元通宝等各朝代钱币，可供研究参考。','古代钱币',4,1,'33,34,35,36','2024-04-20 13:15:00'),(31,8,3,'user','宋代钱币套装包含哪些？','宋代,钱币',0,0,NULL,'2024-04-20 13:20:00'),(32,8,3,'ai','我馆收藏的宋代铜钱套装（WW2024037）包含宋代各朝钱币100枚，涵盖了宋太祖至宋徽宗时期的主要货币，如宋元通宝、太平通宝、熙宁元宝等，是研究宋代货币制度的完整资料。','宋代,钱币',1,0,'37','2024-04-20 13:22:00'),(33,11,13,'user','司母戊鼎','司母戊鼎',NULL,NULL,NULL,'2026-04-22 11:18:32'),(34,11,13,'ai','本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。',NULL,1,1,'','2026-04-22 11:18:32'),(35,12,16,'user','司母戊鼎','司母戊鼎',NULL,NULL,NULL,'2026-04-23 15:36:34'),(36,12,16,'ai','本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。',NULL,1,1,'','2026-04-23 15:36:34'),(37,13,16,'user','兵马俑','兵马俑',NULL,NULL,NULL,'2026-04-23 15:45:30'),(38,13,16,'ai','本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。',NULL,1,1,'','2026-04-23 15:45:30'),(39,14,16,'user','兵马俑','兵马俑',NULL,NULL,NULL,'2026-04-23 15:46:48'),(40,14,16,'ai','本博物馆里无此文物，已为你补充抓取百度百科词条的简介与图片。',NULL,1,1,'','2026-04-23 15:46:48');
/*!40000 ALTER TABLE `ai_chat_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_chat_session`
--

DROP TABLE IF EXISTS `ai_chat_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_chat_session` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_title` varchar(200) COLLATE utf8mb4_general_ci DEFAULT '新对话' COMMENT '会话标题',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='AI对话会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_chat_session`
--

LOCK TABLES `ai_chat_session` WRITE;
/*!40000 ALTER TABLE `ai_chat_session` DISABLE KEYS */;
INSERT INTO `ai_chat_session` VALUES (1,1,'查询青铜器相关信息','2024-03-01 10:00:00','2024-03-01 10:15:00'),(2,2,'了解唐代文物','2024-03-05 11:00:00','2024-03-05 11:20:00'),(3,3,'瓷器鉴定咨询','2024-03-10 14:00:00','2024-03-10 14:25:00'),(4,4,'书画作品研究','2024-03-15 09:00:00','2024-03-15 09:30:00'),(5,5,'玉器文化探讨','2024-03-20 10:00:00','2024-03-20 10:40:00'),(6,1,'金银器工艺咨询','2024-04-01 11:00:00','2024-04-01 11:18:00'),(7,2,'碑刻文字解读','2024-04-10 15:00:00','2024-04-10 15:35:00'),(8,3,'古代钱币鉴别','2024-04-20 13:00:00','2024-04-20 13:22:00'),(11,13,'AI查询：司母戊鼎','2026-04-22 11:18:32','2026-04-22 11:18:32'),(12,16,'AI查询：司母戊鼎','2026-04-23 15:36:34','2026-04-23 15:36:34'),(13,16,'AI查询：兵马俑','2026-04-23 15:45:30','2026-04-23 15:45:30'),(14,16,'AI查询：兵马俑','2026-04-23 15:46:48','2026-04-23 15:46:48');
/*!40000 ALTER TABLE `ai_chat_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ai_query_result`
--

DROP TABLE IF EXISTS `ai_query_result`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ai_query_result` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `message_id` bigint NOT NULL COMMENT '消息ID',
  `relic_id` bigint DEFAULT NULL COMMENT '文物ID（馆藏文物）',
  `relic_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '文物名称',
  `relevance_percent` int DEFAULT '0' COMMENT '相关度百分比',
  `is_external` tinyint DEFAULT '0' COMMENT '是否外部资料：0-馆藏，1-外部',
  `source_name` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源名称',
  `source_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源类型：百科、博物馆官网等',
  `source_url` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '来源链接',
  `match_tags` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '匹配标签（JSON数组）',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_message_id` (`message_id`),
  KEY `idx_relic_id` (`relic_id`),
  KEY `idx_is_external` (`is_external`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='AI查询结果详情表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ai_query_result`
--

LOCK TABLES `ai_query_result` WRITE;
/*!40000 ALTER TABLE `ai_query_result` DISABLE KEYS */;
INSERT INTO `ai_query_result` VALUES (1,34,NULL,'后母戊鼎',0,1,'百度百科','百科','https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E','[]','2026-04-22 11:18:32'),(2,36,NULL,'后母戊鼎',0,1,'百度百科','百科','https://baike.baidu.com/item/%E5%90%8E%E6%AF%8D%E6%88%8A%E9%BC%8E','[]','2026-04-23 15:36:34'),(3,38,NULL,'兵马俑',0,1,'百度百科','百科','https://baike.baidu.com/item/%E5%85%B5%E9%A9%AC%E4%BF%91','[]','2026-04-23 15:45:30'),(4,40,NULL,'兵马俑',0,1,'百度百科','百科','https://baike.baidu.com/item/%E5%85%B5%E9%A9%AC%E4%BF%91','[]','2026-04-23 15:46:48');
/*!40000 ALTER TABLE `ai_query_result` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `archive_document`
--

DROP TABLE IF EXISTS `archive_document`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive_document` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '文档ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `document_type` varchar(50) NOT NULL COMMENT '文档类型：appraisal-鉴定报告/repair-修复记录/research-研究论文/certificate-证书/photo-照片/other-其他',
  `document_name` varchar(200) NOT NULL COMMENT '文档名称',
  `file_path` varchar(500) NOT NULL COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小（字节）',
  `file_format` varchar(20) DEFAULT NULL COMMENT '文件格式：pdf/doc/docx/jpg/png/xlsx等',
  `upload_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
  `uploader_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `uploader_name` varchar(100) DEFAULT NULL COMMENT '上传人姓名',
  `description` text COMMENT '文档说明',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  PRIMARY KEY (`id`),
  KEY `idx_archive_id` (`archive_id`),
  KEY `idx_document_type` (`document_type`),
  KEY `idx_upload_time` (`upload_time`),
  CONSTRAINT `archive_document_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='档案文档表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive_document`
--

LOCK TABLES `archive_document` WRITE;
/*!40000 ALTER TABLE `archive_document` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive_document` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `archive_history`
--

DROP TABLE IF EXISTS `archive_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive_history` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '历史记录ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `version` int DEFAULT NULL COMMENT '版本号',
  `operation_type` varchar(50) NOT NULL COMMENT '操作类型：create-创建/update-更新/upload-上传文档/delete-删除文档/export-导出/print-打印/publish-发布/archive-归档',
  `operation_content` text COMMENT '操作内容描述',
  `change_log` text COMMENT '变更日志',
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(100) DEFAULT NULL COMMENT '操作人姓名',
  `operation_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
  `ip_address` varchar(50) DEFAULT NULL COMMENT 'IP地址',
  PRIMARY KEY (`id`),
  KEY `idx_archive_id` (`archive_id`),
  KEY `idx_operation_time` (`operation_time`),
  KEY `idx_operation_type` (`operation_type`),
  CONSTRAINT `archive_history_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='档案历史记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive_history`
--

LOCK TABLES `archive_history` WRITE;
/*!40000 ALTER TABLE `archive_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `archive_relation`
--

DROP TABLE IF EXISTS `archive_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `relation_type` varchar(50) NOT NULL COMMENT '关联类型：loan-借展/repair-修复/maintenance-维护/exhibition-展览',
  `relation_id` bigint NOT NULL COMMENT '关联记录ID',
  `relation_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '关联时间',
  `relation_desc` varchar(500) DEFAULT NULL COMMENT '关联描述',
  PRIMARY KEY (`id`),
  KEY `idx_archive_id` (`archive_id`),
  KEY `idx_relation_type` (`relation_type`),
  KEY `idx_relation_id` (`relation_id`),
  CONSTRAINT `archive_relation_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='档案关联关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive_relation`
--

LOCK TABLES `archive_relation` WRITE;
/*!40000 ALTER TABLE `archive_relation` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `archive_version`
--

DROP TABLE IF EXISTS `archive_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `archive_version` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '版本ID',
  `archive_id` bigint NOT NULL COMMENT '档案ID',
  `version` int NOT NULL COMMENT '版本号',
  `version_title` varchar(200) DEFAULT NULL COMMENT '版本标题',
  `change_log` text COMMENT '变更日志',
  `content_snapshot` longtext COMMENT '内容快照（JSON格式）',
  `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `created_by_name` varchar(100) DEFAULT NULL COMMENT '创建人姓名',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_archive_version` (`archive_id`,`version`),
  KEY `idx_archive_id` (`archive_id`),
  KEY `idx_version` (`version`),
  KEY `idx_created_time` (`created_time`),
  CONSTRAINT `archive_version_ibfk_1` FOREIGN KEY (`archive_id`) REFERENCES `relic_archive` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='档案版本表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `archive_version`
--

LOCK TABLES `archive_version` WRITE;
/*!40000 ALTER TABLE `archive_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `archive_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cultural_relic`
--

DROP TABLE IF EXISTS `cultural_relic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cultural_relic` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `relic_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `relic_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `category_id` bigint DEFAULT NULL,
  `era` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `material` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `origin` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `dimensions` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `description` text COLLATE utf8mb4_general_ci,
  `status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '在库',
  `image_path` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `relic_code` (`relic_code`),
  KEY `idx_relic_code` (`relic_code`),
  KEY `idx_relic_name` (`relic_name`),
  KEY `idx_category_id` (`category_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=271 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultural_relic`
--

LOCK TABLES `cultural_relic` WRITE;
/*!40000 ALTER TABLE `cultural_relic` DISABLE KEYS */;
INSERT INTO `cultural_relic` VALUES (1,'WW202501001','北宋铜钱串',7,'宋朝','铜','河南开封','长约30cm',0.50,'北宋时期铜钱串，保存完整，具有较高的历史和收藏价值','在库','/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg','2025-01-01 10:00:00','2026-04-23 17:09:40'),(2,'WW202501002','北魏石佛头像',9,'南北朝','石','山西大同','高25cm',8.00,'北魏时期石雕佛头像，雕刻精美，面容慈祥','借展中','/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp','2025-01-02 10:00:00','2026-04-23 20:28:39'),(3,'WW202501003','北魏石佛像',9,'南北朝','石','河南洛阳','高80cm',50.00,'北魏时期完整石佛造像，艺术价值极高','修复中','/uploads/7d1c8d9746954228ad84bb360a48e958.webp','2025-01-03 10:00:00','2026-04-23 20:58:00'),(4,'WW202501004','北魏造像碑',6,'南北朝','石','河北邯郸','高120cm',150.00,'北魏造像碑，碑文清晰，造像精美','借展中','/uploads/3a61faebc0ef44638ca78150f3bc978d.webp','2025-01-04 10:00:00','2026-04-23 20:30:33'),(5,'WW202501005','曾侯乙编钟',1,'战国','青铜','湖北随州','高265cm',2500.00,'战国时期曾侯乙墓出土编钟，音律完整，国宝级文物','修复中','/uploads/32877c4cd94f4c7f98de18818a8c5104.webp','2025-01-05 10:00:00','2026-04-23 20:33:27'),(6,'WW202501006','春秋青铜编钟',1,'春秋','青铜','河南新郑','高45cm',15.00,'春秋时期青铜编钟，铸造精良','在库','/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg','2025-01-06 10:00:00','2026-04-23 17:04:25'),(7,'WW202501007','大禹鼎',1,'商朝','青铜','河南安阳','高87cm',75.00,'商代青铜重器，铭文记载大禹治水功绩','在库','/uploads/3536f8a54033417db069185f5a53ed4e.webp','2025-01-07 10:00:00','2026-04-23 20:30:45'),(8,'WW202501008','东汉铜灯',1,'汉朝','青铜','河北满城','高48cm',5.00,'东汉时期青铜灯具，设计巧妙，实用性强','在库','/uploads/6cd196faa27044cabfd3257132e0a023.jpg','2025-01-08 10:00:00','2026-04-23 17:05:35'),(9,'WW202501009','汉碑残拓',6,'汉朝','纸','陕西西安','50x70cm',0.10,'汉代石碑拓片，虽有残缺但文字清晰','借展中','/uploads/e423867d6e4f4aac83af6cb469f4bbc7.webp','2025-01-09 10:00:00','2026-04-23 20:31:12'),(10,'WW202501010','汉代彩绘陶俑',2,'汉朝','陶','陕西咸阳','高35cm',2.00,'汉代彩绘陶俑，色彩保存较好','借展中','/uploads/7a334f27bf404354b547edc28f274458.webp','2025-01-10 10:00:00','2026-04-23 20:29:10'),(11,'WW202501011','汉代漆盘',10,'汉朝','漆木','湖南长沙','直径30cm',0.50,'汉代漆器，纹饰精美，保存完好','在库','/uploads/7a49cbe142044f7c9d0a77ae81f5407c.webp','2025-01-11 10:00:00','2026-04-23 17:05:56'),(12,'WW202501012','汉代青铜镜',1,'汉朝','青铜','河南洛阳','直径18cm',0.80,'汉代铜镜，纹饰精美，铭文清晰','借展中','/uploads/678d29b16b5b4f12975d11fc2234feb3.webp','2025-01-12 10:00:00','2026-04-23 20:30:18'),(13,'WW202501013','汉代石碑',6,'汉朝','石','山东曲阜','高180cm',500.00,'汉代石碑，碑文完整，书法价值高','在库','/uploads/e371e143cebe48abb5ef249fd426ccd1.webp','2025-01-13 10:00:00','2026-04-23 16:27:36'),(14,'WW202501014','汉代丝织残片',8,'汉朝','丝绸','新疆吐鲁番','20x30cm',0.05,'汉代丝织品残片，纹样精美，极为珍贵','借展中','/uploads/3d0187ad0349445fabf4e0b33c512579.jpg','2025-01-14 10:00:00','2026-04-23 20:30:56'),(15,'WW202501015','汉代玉衣片',4,'汉朝','玉','河北定州','10x8cm',0.20,'汉代金缕玉衣残片，工艺精湛','在库','/uploads/a6175e984ff14c8389805dd4508cb84e.webp','2025-01-15 10:00:00','2026-04-23 17:06:21'),(16,'WW202501016','汉五铢钱',7,'汉朝','铜','陕西西安','直径2.5cm',0.03,'汉代五铢钱，铸造规整','在库','/uploads/9032c02617784f07954a342206f8d298.webp','2025-01-16 10:00:00','2026-04-23 17:06:28'),(17,'WW202501017','汉五铢钱范',7,'汉朝','陶','河南洛阳','15x10cm',0.50,'汉代铸钱模具，研究古代铸币工艺的重要实物','在库','/uploads/afabd4e7a71d49ad8ac87373a7a3fb48.webp','2025-01-17 10:00:00','2026-04-23 17:06:35'),(18,'WW202501018','和田白玉佩',4,'清朝','和田玉','新疆和田','长8cm',0.15,'清代和田白玉佩，玉质温润，雕工精细','在库','/uploads/17a595c9464541eaa43c2a2b77afd543.jpg','2025-01-18 10:00:00','2026-04-23 17:13:25'),(19,'WW202501019','金代鎏金杯',5,'金朝','鎏金银','黑龙江哈尔滨','高12cm',0.30,'金代鎏金银杯，工艺精湛，保存完好','在库','/uploads/48f50558423a4fa98876114cd7cc1914.webp','2025-01-19 10:00:00','2026-04-23 17:11:10'),(20,'WW202501020','开元通宝套币',7,'唐朝','铜','陕西西安','直径2.4cm',0.20,'唐代开元通宝成套钱币，品相完好','在库','/uploads/b1a5dc0a56e649cb98dcd54893ce2cf9.jpg','2025-01-20 10:00:00','2026-04-23 17:07:48'),(21,'WW202501021','辽代玉鸟佩',4,'辽朝','玉','内蒙古赤峰','长6cm',0.08,'辽代玉雕鸟形佩饰，造型生动','在库','/uploads/433fa46930e04a3fbf0737ed392d4fd6.webp','2025-01-21 10:00:00','2026-04-23 17:10:55'),(22,'WW202501022','鎏金银壶',5,'唐朝','鎏金银','陕西西安','高25cm',1.20,'唐代鎏金银壶，造型优美，工艺精湛','在库','/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp','2025-01-22 10:00:00','2026-04-23 17:07:53'),(23,'WW202501023','民国漆盒',10,'民国','漆木','北京','直径15cm',0.30,'民国时期漆盒，工艺精美','在库','/uploads/d3200cbab3b049fc961bfade69089eac.jpg','2025-01-23 10:00:00','2026-04-23 17:14:59'),(24,'WW202501024','民国旗袍',8,'民国','丝绸','上海','长120cm',0.50,'民国时期旗袍，保存完好，具有时代特色','在库','/uploads/3c3c740446124bc794e2339c33eb37ea.webp','2025-01-24 10:00:00','2026-04-23 17:15:04'),(25,'WW202501025','明代补子',8,'明朝','丝绸','北京','30x30cm',0.20,'明代官服补子，刺绣精美','借展中','/uploads/3b5b872bc4574442be36bdfa7525f43d.webp','2025-01-25 10:00:00','2026-04-23 20:31:57'),(26,'WW202501026','明代黄花梨椅',10,'明朝','黄花梨木','广东','高95cm',15.00,'明代黄花梨圈椅，造型优美，包浆自然','在库','/uploads/970e5599235e41aabb14c8275df4475e.webp','2025-01-26 10:00:00','2026-04-23 17:11:57'),(27,'WW202501027','明代金簪',5,'明朝','金','北京','长15cm',0.10,'明代金簪，工艺精细，保存完好','在库','/uploads/971880acf0944e498e2c11a133011590.webp','2025-01-27 10:00:00','2026-04-23 17:12:01'),(28,'WW202501028','明代龙袍',10,'明朝','丝绸','北京','长150cm',2.00,'明代皇室龙袍，刺绣精美，极为珍贵','在库','/uploads/e4bed460f71d495d945fd6630cdcf323.webp','2025-01-28 10:00:00','2026-04-23 16:28:53'),(29,'WW202501029','明代木雕佛龛',9,'明朝','木','福建','高60cm',10.00,'明代木雕佛龛，雕刻精美，保存完好','在库','/uploads/3f14bc2165a04e32a96846dd28c20158.webp','2025-01-29 10:00:00','2026-04-23 17:12:06'),(30,'WW202501030','明代青花盘',2,'明朝','瓷','江西景德镇','直径35cm',1.50,'明代青花瓷盘，纹饰精美，品相完好','在库','/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp','2025-01-30 10:00:00','2026-04-23 17:12:14'),(31,'WW202501031','明代青花碗',2,'明朝','瓷','江西景德镇','直径15cm',0.30,'明代青花碗，胎质细腻，青花发色纯正','在库','/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp','2025-01-31 10:00:00','2026-04-23 17:12:19'),(32,'WW202501032','明代唐寅山水画',3,'明朝','纸本','江苏苏州','120x60cm',0.50,'明代唐寅山水画作，笔墨精妙，极为珍贵','在库','/uploads/3f8291c4743e4e078f1f5b47e69bdcce.webp','2025-02-01 10:00:00','2026-04-23 17:12:29'),(33,'WW202501033','明代剔红盒',10,'明朝','漆木','北京','直径20cm',0.80,'明代剔红漆盒，雕刻精美，保存完好','借展中','/uploads/aab685aa93184206a68ad8a41bb8a604.webp','2025-02-02 10:00:00','2026-04-23 20:32:10'),(34,'WW202501034','明代铜佛',9,'明朝','青铜','山西五台山','高40cm',8.00,'明代铜佛造像，铸造精良，神态庄严','在库','/uploads/e22c85430b234395a7e4911fb9f36541.webp','2025-02-03 10:00:00','2026-04-23 17:12:44'),(35,'WW202501035','明代银锭',5,'明朝','银','云南','重50两',1.50,'明代银锭，铭文清晰，保存完好','在库','/uploads/e9f595acac3f40f18e29d3a921144290.jpg','2025-02-04 10:00:00','2026-04-23 17:12:50'),(36,'WW202501036','明代银香炉',5,'明朝','银','江苏南京','高18cm',1.00,'明代银香炉，造型典雅，工艺精湛','在库','/uploads/019f1b7f43cd415ca0a9263fc8ea7053.webp','2025-02-05 10:00:00','2026-04-23 17:12:54'),(37,'WW202501037','明代玉如意',4,'明朝','玉','北京','长40cm',0.80,'明代玉如意，玉质温润，雕工精细','在库','/uploads/47e94f29a81244c0ae8f71c8ede34dfb.webp','2025-02-06 10:00:00','2026-04-23 17:12:59'),(38,'WW202501038','明代云锦服饰',8,'明朝','云锦','江苏南京','长130cm',1.50,'明代云锦服饰，织造精美，色彩艳丽','在库','/uploads/7cb302c8ff474f1bbb00064077ff6447.webp','2025-02-07 10:00:00','2026-04-23 17:13:03'),(39,'WW202501039','秦半两钱',7,'秦朝','铜','陕西咸阳','直径3.2cm',0.05,'秦代半两钱，中国最早的统一货币','在库','/uploads/e1411506fcf94f5a8bedd3eeda9b7378.webp','2025-02-08 10:00:00','2026-04-23 17:05:18'),(40,'WW202501040','秦朝铜诏版',1,'秦朝','青铜','陕西西安','30x20cm',5.00,'秦代诏书铜版，文字清晰，极为珍贵','在库','/uploads/88572677c666468e8c66144f43d24186.webp','2025-02-09 10:00:00','2026-04-23 17:05:24'),(41,'WW202501041','清代白玉如意',4,'清朝','白玉','北京','长35cm',0.60,'清代白玉如意，玉质上乘，雕工精美','在库','/uploads/bd43d42531484560933d09ec7502f243.jpg','2025-02-10 10:00:00','2026-04-23 17:13:29'),(42,'WW202501042','清代鼻烟壶',4,'清朝','玉石','北京','高8cm',0.10,'清代鼻烟壶，小巧精致，工艺精湛','在库','/uploads/3a92d4aea53e4857a9ce860f15c511c2.webp','2025-02-11 10:00:00','2026-04-23 17:13:34'),(43,'WW202501043','清代翡翠手镯',4,'清朝','翡翠','云南','直径6cm',0.08,'清代翡翠手镯，色泽鲜艳，质地细腻','在库','/uploads/529731d36ef8408590babfb9f4cd584c.webp','2025-02-12 10:00:00','2026-04-23 17:13:39'),(44,'WW202501044','清代粉彩瓶',2,'清朝','瓷','江西景德镇','高45cm',3.00,'清代粉彩瓷瓶，色彩艳丽，绘画精美','在库','/uploads/c77e9d65149544b98c254da1592b9650.webp','2025-02-13 10:00:00','2026-04-23 17:13:42'),(45,'WW202501045','清代官服',8,'清朝','丝绸','北京','长140cm',2.00,'清代官服，品级清晰，保存完好','借展中','/uploads/0306afb2748e4cdb96e5292143173bf6.webp','2025-02-14 10:00:00','2026-04-23 20:32:24'),(46,'WW202501046','清代红木柜',10,'清朝','红木','广东','高180cm',80.00,'清代红木柜，造型端庄，雕刻精美','在库','/uploads/ff357c7d674f40a5b8000c918182f7fe.webp','2025-02-15 10:00:00','2026-04-23 17:13:52'),(47,'WW202501047','清代花鸟立轴',3,'清朝','纸本','北京','150x60cm',0.50,'清代花鸟画立轴，设色雅致，笔墨精妙','在库','/uploads/58a4b9b01b7740ddb7cb206dab672f08.webp','2025-02-16 10:00:00','2026-04-23 17:13:58'),(48,'WW202501048','清代铜香插',1,'清朝','青铜','北京','高15cm',0.50,'清代铜香插，造型别致，包浆自然','在库','/uploads/d35eb1aa7fdc434f81c5ca1790c0aaa0.webp','2025-02-17 10:00:00','2026-04-23 17:14:03'),(49,'WW202501049','清代行书扇面',3,'清朝','纸本','江苏扬州','50x20cm',0.10,'清代行书扇面，书法流畅，保存完好','在库','/uploads/298dcbaa80b94d30aa24baa9c3c850af.webp','2025-02-18 10:00:00','2026-04-23 17:14:09'),(50,'WW202501050','清代银锭',5,'清朝','银','云南','重10两',0.30,'清代银锭，铭文清晰，品相完好','在库','/uploads/43b585c6af20412e98bf3a4191d99c36.webp','2025-02-19 10:00:00','2026-04-23 17:14:25'),(51,'WW202501051','清代银簪',5,'清朝','银','北京','长12cm',0.05,'清代银簪，工艺精细，保存完好','在库','/uploads/adaff9788ded43359a696008bac31900.webp','2025-02-20 10:00:00','2026-04-23 17:14:29'),(52,'WW202501052','清代郑板桥竹石图',3,'清朝','纸本','江苏扬州','130x60cm',0.50,'清代郑板桥竹石图，笔墨苍劲，极为珍贵','在库','/uploads/fffcad1c276141588537230a45f1aee8.webp','2025-02-21 10:00:00','2026-04-23 17:14:35'),(53,'WW202501053','清代织金袍',8,'清朝','织金缎','北京','长145cm',2.50,'清代织金袍，织造精美，金线灿烂','在库','/uploads/9554fd393ce240ea99a2788886bf09a8.webp','2025-02-22 10:00:00','2026-04-23 17:14:40'),(54,'WW202501054','清代紫檀桌',10,'清朝','紫檀木','北京','高85cm',50.00,'清代紫檀桌，材质珍贵，造型典雅','在库','/uploads/3b0c4c59760041dfbbbe323ee122dde4.webp','2025-02-23 10:00:00','2026-04-23 17:14:44'),(55,'WW202501055','清帖拓页',6,'清朝','纸','北京','30x40cm',0.05,'清代碑帖拓片，字迹清晰','在库','/uploads/d3b88237423f4b5fbfd69ab309942557.jpg','2025-02-24 10:00:00','2026-04-23 17:14:53'),(56,'WW202501056','汝窑天青釉盏',2,'宋朝','瓷','河南汝州','直径12cm',0.20,'宋代汝窑天青釉盏，釉色纯正，极为珍贵','在库','/uploads/6bd0676aaba342a0a7da079eb82dec70.webp','2025-02-25 10:00:00','2026-04-23 17:09:45'),(57,'WW202501057','三国青瓷罐',2,'三国','瓷','浙江越窑','高30cm',2.00,'三国时期青瓷罐，釉色青翠，保存完好','在库','/uploads/88da0fad01314386b5968c70ede17edb.webp','2025-02-26 10:00:00','2026-04-23 17:06:53'),(58,'WW202501058','山水卷轴',3,'明朝','纸本','浙江杭州','200x50cm',0.80,'明代山水画卷轴，笔墨精妙，构图优美','在库','/uploads/75d2df6fbd6b4bf2b669e6344533ad26.webp','2025-02-27 10:00:00','2026-04-23 17:13:06'),(59,'WW202501059','商代青铜鼎',1,'商朝','青铜','河南安阳','高60cm',40.00,'商代青铜鼎，铸造精良，纹饰精美','在库','/uploads/e1f44f18efda4cbf918cc666a368091a.webp','2025-02-28 10:00:00','2026-04-23 17:03:09'),(60,'WW202501060','商代青铜觚',1,'商朝','青铜','河南安阳','高35cm',5.00,'商代青铜觚，造型优美，纹饰精美','在库','/uploads/38eee9a70cb34f24a48ede15088d9d15.jpg','2025-03-01 10:00:00','2026-04-23 17:03:59'),(61,'WW202501061','商代玉戈',4,'商朝','玉','河南安阳','长25cm',0.50,'商代玉戈，玉质精良，制作精美','在库','/uploads/fc921cae189342e493a59d5436ff04cc.webp','2025-03-02 10:00:00','2026-04-23 17:04:04'),(62,'WW202501062','石雕观音像',9,'明朝','石','福建泉州','高150cm',300.00,'明代石雕观音像，雕刻精美，神态慈祥','在库','/uploads/43e6e949f77f4a91b0114e4693edad14.jpg','2025-03-03 10:00:00','2026-04-23 17:13:12'),(63,'WW202501063','宋代白瓷瓶',2,'宋朝','瓷','河北定窑','高30cm',1.50,'宋代白瓷瓶，胎质细腻，釉色纯白','在库','/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg','2025-03-04 10:00:00','2026-04-23 17:09:48'),(64,'WW202501064','宋代碑刻拓片',6,'宋朝','纸','山东曲阜','80x40cm',0.10,'宋代碑刻拓片，字迹清晰，书法价值高','在库','/uploads/7c80c4768d8e4d54a7dad114b4d47c42.webp','2025-03-05 10:00:00','2026-04-23 17:09:56'),(65,'WW202501065','宋代木雕罗汉',9,'宋朝','木','山西五台山','高80cm',20.00,'宋代木雕罗汉像，雕刻精美，神态生动','在库','/uploads/5efe908f0b594c0f8aaf1a90b63b0596.webp','2025-03-06 10:00:00','2026-04-23 17:10:04'),(66,'WW202501066','宋代汝窑盘',2,'宋朝','瓷','河南汝州','直径20cm',0.50,'宋代汝窑盘，釉色天青，极为珍贵','在库','/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp','2025-03-07 10:00:00','2026-04-23 17:10:09'),(67,'WW202501067','宋代铜钱套装',7,'宋朝','铜','河南开封','直径2.5cm',0.30,'宋代铜钱成套，品相完好，品种齐全','在库','/uploads/57fb47604e1c4e4eb35cace934f6f0eb.webp','2025-03-08 10:00:00','2026-04-23 17:10:15'),(68,'WW202501068','宋代银壶',5,'宋朝','银','浙江杭州','高20cm',0.80,'宋代银壶，造型优美，工艺精湛','修复中','/uploads/08c6ab0e5b4643179743861502d297b5.webp','2025-03-09 10:00:00','2026-04-23 20:54:56'),(69,'WW202501069','宋代织锦残片',8,'宋朝','丝绸','浙江杭州','30x20cm',0.10,'宋代织锦残片，纹样精美，极为珍贵','在库','/uploads/12ff4825507f43fd85ca71521284491c.jpg','2025-03-10 10:00:00','2026-04-23 17:10:27'),(70,'WW202501070','宋徽宗瘦金体书法',3,'宋朝','纸本','河南开封','100x40cm',0.30,'宋徽宗瘦金体书法真迹，笔法独特，国宝级文物','在库','/uploads/322f2cc978d249ba98113313ae837853.webp','2025-03-11 10:00:00','2026-04-23 17:10:34'),(71,'WW202501071','宋人山水册页',3,'宋朝','纸本','浙江杭州','30x25cm',0.20,'宋代山水画册页，笔墨精妙，意境深远','在库','/uploads/f9c3ff6a9b11439894dcf068dc52138b.webp','2025-03-12 10:00:00','2026-04-23 17:10:39'),(72,'WW202501072','宋帖影印本',3,'宋朝','纸','浙江杭州','40x30cm',0.15,'宋代碑帖影印本，字迹清晰，保存完好','在库','/uploads/b2c5eaf363914301870124970b2a61ec.jpeg','2025-03-13 10:00:00','2026-04-23 17:10:45'),(73,'WW202501073','隋朝石刻佛首',9,'隋朝','石','河北邯郸','高40cm',25.00,'隋代石刻佛首，雕刻精美，面容庄严','在库','/uploads/90324eee34794322bf92eea2151d74ad.webp','2025-03-14 10:00:00','2026-04-23 17:07:38'),(74,'WW202501074','唐碑拓本',6,'唐朝','纸','陕西西安','100x50cm',0.20,'唐代碑刻拓本，书法遒劲，保存完好','在库','/uploads/59454ff4a2c042fd925150657b318d51.webp','2025-03-15 10:00:00','2026-04-23 17:08:00'),(75,'WW202501075','唐代金杯',5,'唐朝','金','陕西西安','高10cm',0.20,'唐代金杯，工艺精湛，保存完好','在库','/uploads/645b9ef90d134ef0b0139a4fa7918046.webp','2025-03-16 10:00:00','2026-04-23 17:08:05'),(76,'WW202501076','唐代龙凤玉佩',4,'唐朝','玉','陕西西安','长10cm',0.15,'唐代龙凤纹玉佩，雕工精细，寓意吉祥','在库','/uploads/63d15e510c7d4e3db421a419b350fe24.webp','2025-03-17 10:00:00','2026-04-23 17:08:09'),(77,'WW202501077','唐代墓志铭',6,'唐朝','石','陕西西安','50x50cm',30.00,'唐代墓志铭，文字清晰，书法精美','在库','/uploads/8a46b212628d48d5ab02a77e02697f1b.webp','2025-03-18 10:00:00','2026-04-23 16:33:18'),(78,'WW202501078','唐代青铜佛像',9,'唐朝','青铜','陕西西安','高50cm',12.00,'唐代青铜佛像，铸造精良，神态庄严','在库','/uploads/3c219d52e3814f8d8c6277827ec91d97.webp','2025-03-19 10:00:00','2026-04-23 17:08:27'),(79,'WW202501079','唐代山水画卷',3,'唐朝','纸本','陕西西安','300x50cm',1.00,'唐代山水画卷，笔墨精妙，极为珍贵','在库','/uploads/9784a41ce1a44bcbb3ce5f6428fe578b.webp','2025-03-20 10:00:00','2026-04-23 17:08:34'),(80,'WW202501080','唐代铜佛像',9,'唐朝','青铜','山西五台山','高35cm',8.00,'唐代铜佛造像，铸造精良，保存完好','在库','/uploads/e089b182f84640379e15b2400d714945.jpg','2025-03-21 10:00:00','2026-04-23 17:08:42'),(81,'WW202501081','唐代铜观音',9,'唐朝','青铜','陕西西安','高60cm',15.00,'唐代铜观音像，造型优美，神态慈祥','在库','/uploads/6da715a8159045bda0e896de63ace624.webp','2025-03-22 10:00:00','2026-04-23 17:08:47'),(82,'WW202501082','唐代玉带饰',4,'唐朝','玉','陕西西安','长8cm',0.10,'唐代玉带饰，雕工精细，保存完好','在库','/uploads/dde2f35afcff45f09b596453e10a4ef0.jpg','2025-03-23 10:00:00','2026-04-23 17:08:52'),(83,'WW202501083','唐开元通宝',7,'唐朝','铜','陕西西安','直径2.4cm',0.04,'唐代开元通宝，铸造规整，品相完好','在库','/uploads/cdce86e7172a4afd980616b72139e389.webp','2025-03-24 10:00:00','2026-04-23 17:08:57'),(84,'WW202501084','唐三彩马',2,'唐朝','陶','河南洛阳','高50cm',5.00,'唐三彩马，造型生动，釉色艳丽','在库','/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp','2025-03-25 10:00:00','2026-04-23 17:09:04'),(85,'WW202501085','王羲之兰亭序摹本',3,'唐朝','纸本','陕西西安','28x320cm',0.50,'王羲之兰亭序唐代摹本，书法精妙，极为珍贵','在库','/uploads/ab83d1743bd541d79414fe67c8a5e524.webp','2025-03-26 10:00:00','2026-04-23 17:09:12'),(86,'WW202501086','王羲之摹本',3,'唐朝','纸本','陕西西安','30x100cm',0.30,'王羲之书法唐代摹本，笔法精妙，价值连城','在库','/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg','2025-03-27 10:00:00','2026-04-23 17:09:22'),(87,'WW202501087','魏碑拓片',6,'南北朝','纸','河南洛阳','60x40cm',0.10,'北魏碑刻拓片，字体方正，书法价值高','在库','/uploads/ce705c2e63fc421bb86c03b9866e23de.webp','2025-03-28 10:00:00','2026-04-23 17:07:29'),(88,'WW202501088','五代十国银执壶',5,'五代十国','银','河南开封','高25cm',1.00,'五代银执壶，造型优美，工艺精湛','在库','/uploads/3ca543bae2a045379128befb7e377b26.jpg','2025-03-29 10:00:00','2026-04-23 17:09:32'),(89,'WW202501089','西汉青铜镜',1,'汉朝','青铜','陕西西安','直径20cm',1.00,'西汉铜镜，纹饰精美，保存完好','在库','/uploads/295deac6800f40c4ae4983184256f1d2.jpg','2025-03-30 10:00:00','2026-04-23 17:06:43'),(90,'WW202501090','西夏文残碑拓片',6,'西夏','纸','宁夏银川','50x30cm',0.08,'西夏文残碑拓片，文字罕见，研究价值高','在库','/uploads/8a42bd4782a14cd8a1774817ed013e9c.webp','2025-03-31 10:00:00','2026-04-23 17:11:04'),(91,'WW202501091','西周青铜簋',1,'西周','青铜','陕西宝鸡','高25cm',8.00,'西周青铜簋，铸造精良，铭文清晰','在库','/uploads/230a77be5e6c4522aa33237f9e12dba0.webp','2025-04-01 10:00:00','2026-04-23 17:04:16'),(92,'WW202501092','夏朝青铜铃',1,'夏朝','青铜','河南偃师','高15cm',1.50,'夏代青铜铃，中国最早的青铜器之一，极为珍贵','在库','/uploads/4ca25ebf262344e4b063b6cdfbc37e69.webp','2025-04-02 10:00:00','2026-04-23 17:03:42'),(93,'WW202501093','新石器彩陶罐',1,'新石器时代','陶','甘肃马家窑','高40cm',3.00,'新石器时代彩陶罐，纹饰精美，保存完好','封存','/uploads/5daff7dd306e4104ba29ad26d2fd0fa7.webp','2025-04-03 10:00:00','2026-04-23 17:01:36'),(94,'WW202501094','新石器玉璧',4,'新石器时代','玉','浙江良渚','直径20cm',0.80,'新石器时代玉璧，制作精美，礼器珍品','封存','/uploads/409d3e97d9704f25b6464797f156a888.webp','2025-04-04 10:00:00','2026-04-23 17:01:45'),(95,'WW202501095','元代金冠',5,'元朝','金','内蒙古','高20cm',0.50,'元代金冠，工艺精湛，保存完好','在库','/uploads/f8d4f30997cd4eceb41293d08bb8f511.webp','2025-04-05 10:00:00','2026-04-23 17:11:16'),(96,'WW202501096','元代金饰片',5,'元朝','金','内蒙古','5x3cm',0.05,'元代金饰片，工艺精细，保存完好','在库','/uploads/68fb242a5a634fceaee81b622bcab6a3.webp','2025-04-06 10:00:00','2026-04-23 17:11:20'),(97,'WW202501097','元代墨竹图',3,'元朝','纸本','浙江杭州','100x50cm',0.40,'元代墨竹图，笔墨苍劲，意境高远','在库','/uploads/25588e9135eb47459a61873b01be1e5b.jpg','2025-04-07 10:00:00','2026-04-23 17:11:25'),(98,'WW202501098','元代青花瓷瓶',2,'元朝','瓷','江西景德镇','高40cm',3.00,'元代青花瓷瓶，青花发色浓艳，极为珍贵','在库','/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp','2025-04-08 10:00:00','2026-04-23 17:11:29'),(99,'WW202501099','元代赵孟頫行书',3,'元朝','纸本','浙江湖州','80x40cm',0.30,'元代赵孟頫行书真迹，书法精妙，价值连城','在库','/uploads/df772c02a59a42638c72c399180620b3.webp','2025-04-09 10:00:00','2026-04-23 17:11:34'),(100,'WW202501100','元青花梅瓶',2,'元朝','瓷','江西景德镇','高35cm',2.50,'元青花梅瓶，造型优美，纹饰精美','在库','/uploads/3284351accd947448894fb6607a88f7c.jpg','2025-04-10 10:00:00','2026-04-23 17:11:38'),(101,'WW202501101','战国刀币',7,'战国','铜','河北燕国','长15cm',0.20,'战国刀币，造型独特，保存完好','在库','/uploads/943a120f7a794fbaa6fb93d440447317.webp','2025-04-11 10:00:00','2026-04-23 17:04:44'),(102,'WW202501102','战国龙纹玉璧',4,'战国','玉','河南洛阳','直径18cm',0.50,'战国龙纹玉璧，雕工精美，纹饰精细','在库','/uploads/dd86229ede644f57a2efe72b44c61738.webp','2025-04-12 10:00:00','2026-04-23 17:04:49'),(103,'WW202501103','战国漆器盒',10,'战国','漆木','湖北荆州','直径20cm',0.60,'战国漆器盒，纹饰精美，保存完好','在库','/uploads/1e461ed655484847bce9d967ae110e73.webp','2025-04-13 10:00:00','2026-04-23 17:05:00'),(104,'WW202501104','战国青铜剑',1,'战国','青铜','湖北荆州','长60cm',1.50,'战国青铜剑，锋利依旧，铸造精良','在库','/uploads/2170bd1297d7486bba277c514d27e9f2.webp','2025-04-14 10:00:00','2026-04-23 17:05:07'),(270,'CR2026001','兵马俑',2,'秦朝','陶俑','陕西咸阳','170x50cm',180.00,NULL,'在库','/uploads/e0c81692a3c34a8088300bc1ea3d6303.jpg','2026-04-23 16:16:55','2026-04-23 16:35:34');
/*!40000 ALTER TABLE `cultural_relic` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_delete_relic_image_relation` AFTER DELETE ON `cultural_relic` FOR EACH ROW BEGIN
    -- 删除关联记录（外键级联会自动处理，这里是额外的清理）
    DELETE FROM relic_image_relation WHERE relic_id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `cultural_relic_category`
--

DROP TABLE IF EXISTS `cultural_relic_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cultural_relic_category` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `parent_id` bigint DEFAULT '0',
  `sort_order` int DEFAULT '0',
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cultural_relic_category`
--

LOCK TABLES `cultural_relic_category` WRITE;
/*!40000 ALTER TABLE `cultural_relic_category` DISABLE KEYS */;
INSERT INTO `cultural_relic_category` VALUES (1,'青铜器',0,1,'青铜器文物','2026-04-02 18:00:33','2026-04-02 18:00:33'),(2,'陶瓷器',0,2,'陶瓷器文物','2026-04-02 18:00:33','2026-04-02 18:00:33'),(3,'书画',0,3,'书法绘画','2026-04-02 18:00:33','2026-04-02 18:00:33'),(4,'玉器',0,4,'玉石器物','2026-04-02 18:00:33','2026-04-02 18:00:33'),(5,'金银器',0,5,'金银制品','2026-04-02 18:00:33','2026-04-02 18:00:33'),(6,'碑帖',0,6,'碑刻拓片','2026-04-02 18:00:33','2026-04-02 18:00:33'),(7,'钱币',0,7,'古代钱币','2026-04-02 18:00:33','2026-04-02 18:00:33'),(8,'服饰',0,8,'传统服饰','2026-04-02 18:00:33','2026-04-02 18:00:33'),(9,'佛像',0,9,'佛教造像','2026-04-02 18:00:33','2026-04-02 18:00:33'),(10,'杂项',0,10,'其他文物','2026-04-02 18:00:33','2026-04-02 18:00:33');
/*!40000 ALTER TABLE `cultural_relic_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image_library`
--

DROP TABLE IF EXISTS `image_library`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_library` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '图片ID',
  `image_name` varchar(200) NOT NULL COMMENT '图片名称',
  `original_name` varchar(200) DEFAULT NULL COMMENT '原始文件名',
  `file_path` varchar(500) NOT NULL COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) DEFAULT NULL COMMENT '文件类型(MIME)',
  `width` int DEFAULT NULL COMMENT '图片宽度',
  `height` int DEFAULT NULL COMMENT '图片高度',
  `category` varchar(50) DEFAULT 'uncategorized' COMMENT '分类(relic/exhibition/document/other/uncategorized)',
  `tags` varchar(500) DEFAULT NULL COMMENT '标签(逗号分隔)',
  `description` text COMMENT '描述',
  `uploader_id` bigint DEFAULT NULL COMMENT '上传者ID',
  `uploader_name` varchar(100) DEFAULT NULL COMMENT '上传者姓名',
  `reference_type` varchar(50) DEFAULT NULL COMMENT '关联类型(relic/loan/repair等)',
  `reference_id` bigint DEFAULT NULL COMMENT '关联对象ID',
  `is_public` tinyint DEFAULT '1' COMMENT '是否公开(1:是 0:否)',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `download_count` int DEFAULT '0' COMMENT '下载次数',
  `status` tinyint DEFAULT '1' COMMENT '状态(1:正常 0:已删除)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_uploader` (`uploader_id`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  KEY `idx_create_time` (`create_time`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='图片库管理表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_library`
--

LOCK TABLES `image_library` WRITE;
/*!40000 ALTER TABLE `image_library` DISABLE KEYS */;
INSERT INTO `image_library` VALUES (1,'北宋铜钱串.jpg','北宋铜钱串.jpg','/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg',49872,'image/jpeg',700,494,'relic',NULL,NULL,NULL,'admin','relic',1,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:32:39'),(2,'北魏石佛头像.webp','北魏石佛头像.webp','/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp',59754,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',2,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:32:39'),(3,'北魏石佛像.webp','北魏石佛像.webp','/uploads/7d1c8d9746954228ad84bb360a48e958.webp',18716,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',3,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(4,'北魏造像碑.webp','北魏造像碑.webp','/uploads/3a61faebc0ef44638ca78150f3bc978d.webp',18918,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',4,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(5,'曾侯乙编钟.webp','曾侯乙编钟.webp','/uploads/32877c4cd94f4c7f98de18818a8c5104.webp',18406,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',5,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(6,'春秋青铜编钟.jpeg','春秋青铜编钟.jpeg','/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg',30293,'image/jpeg',640,612,'relic',NULL,NULL,NULL,'admin','relic',6,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(7,'大禹鼎.webp','大禹鼎.webp','/uploads/3536f8a54033417db069185f5a53ed4e.webp',7730,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',7,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(8,'东汉铜灯.jpg','东汉铜灯.jpg','/uploads/6cd196faa27044cabfd3257132e0a023.jpg',177576,'image/jpeg',810,1023,'relic',NULL,NULL,NULL,'admin','relic',8,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(9,'汉碑残拓.webp','汉碑残拓.webp','/uploads/e423867d6e4f4aac83af6cb469f4bbc7.webp',66428,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',9,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(10,'汉代彩绘陶俑.webp','汉代彩绘陶俑.webp','/uploads/7a334f27bf404354b547edc28f274458.webp',13832,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',10,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(11,'汉代漆盘.webp','汉代漆盘.webp','/uploads/7a49cbe142044f7c9d0a77ae81f5407c.webp',5926,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',11,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(12,'汉代青铜镜.webp','汉代青铜镜.webp','/uploads/678d29b16b5b4f12975d11fc2234feb3.webp',15174,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',12,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(13,'汉代石碑.webp','汉代石碑.webp','/uploads/e371e143cebe48abb5ef249fd426ccd1.webp',43302,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',13,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(14,'汉代丝织残片.jpg','汉代丝织残片.jpg','/uploads/3d0187ad0349445fabf4e0b33c512579.jpg',45189,'image/jpeg',500,363,'relic',NULL,NULL,NULL,'admin','relic',14,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(15,'汉代玉衣片.webp','汉代玉衣片.webp','/uploads/a6175e984ff14c8389805dd4508cb84e.webp',11226,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',15,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(16,'汉五铢钱.webp','汉五铢钱.webp','/uploads/9032c02617784f07954a342206f8d298.webp',17040,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',16,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(17,'汉五铢钱范.webp','汉五铢钱范.webp','/uploads/afabd4e7a71d49ad8ac87373a7a3fb48.webp',8440,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',17,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(18,'和田白玉佩.jpg','和田白玉佩.jpg','/uploads/17a595c9464541eaa43c2a2b77afd543.jpg',249824,'image/jpeg',1350,1800,'relic',NULL,NULL,NULL,'admin','relic',18,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(19,'金代鎏金杯.webp','金代鎏金杯.webp','/uploads/48f50558423a4fa98876114cd7cc1914.webp',35634,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',19,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(20,'开元通宝套币.jpg','开元通宝套币.jpg','/uploads/b1a5dc0a56e649cb98dcd54893ce2cf9.jpg',109824,'image/jpeg',700,525,'relic',NULL,NULL,NULL,'admin','relic',20,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(21,'辽代玉鸟佩.webp','辽代玉鸟佩.webp','/uploads/433fa46930e04a3fbf0737ed392d4fd6.webp',7726,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',21,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(22,'鎏金银壶.webp','鎏金银壶.webp','/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp',8352,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',22,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(23,'民国漆盒.jpg','民国漆盒.jpg','/uploads/d3200cbab3b049fc961bfade69089eac.jpg',159197,'image/jpeg',1417,1358,'relic',NULL,NULL,NULL,'admin','relic',23,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(24,'民国旗袍.webp','民国旗袍.webp','/uploads/3c3c740446124bc794e2339c33eb37ea.webp',9062,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',24,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(25,'明代补子.webp','明代补子.webp','/uploads/3b5b872bc4574442be36bdfa7525f43d.webp',28430,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',25,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(26,'明代黄花梨椅.webp','明代黄花梨椅.webp','/uploads/970e5599235e41aabb14c8275df4475e.webp',9774,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',26,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(27,'明代金簪.webp','明代金簪.webp','/uploads/971880acf0944e498e2c11a133011590.webp',8608,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',27,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(28,'明代龙袍.webp','明代龙袍.webp','/uploads/e4bed460f71d495d945fd6630cdcf323.webp',18164,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',28,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(29,'明代木雕佛龛.webp','明代木雕佛龛.webp','/uploads/3f14bc2165a04e32a96846dd28c20158.webp',22258,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',29,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(30,'明代青花盘.webp','明代青花盘.webp','/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp',30644,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',30,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(31,'明代青花碗.webp','明代青花碗.webp','/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp',6846,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',31,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(32,'明代唐寅山水画.webp','明代唐寅山水画.webp','/uploads/3f8291c4743e4e078f1f5b47e69bdcce.webp',22236,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',32,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(33,'明代剔红盒.webp','明代剔红盒.webp','/uploads/aab685aa93184206a68ad8a41bb8a604.webp',5662,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',33,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(34,'明代铜佛.webp','明代铜佛.webp','/uploads/e22c85430b234395a7e4911fb9f36541.webp',10478,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',34,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(35,'明代银锭.jpg','明代银锭.jpg','/uploads/e9f595acac3f40f18e29d3a921144290.jpg',195719,'image/jpeg',1442,1008,'relic',NULL,NULL,NULL,'admin','relic',35,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(36,'明代银香炉.webp','明代银香炉.webp','/uploads/019f1b7f43cd415ca0a9263fc8ea7053.webp',18106,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',36,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(37,'明代玉如意.webp','明代玉如意.webp','/uploads/47e94f29a81244c0ae8f71c8ede34dfb.webp',3456,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',37,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(38,'明代云锦服饰.webp','明代云锦服饰.webp','/uploads/7cb302c8ff474f1bbb00064077ff6447.webp',20252,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',38,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(39,'秦半两钱.webp','秦半两钱.webp','/uploads/e1411506fcf94f5a8bedd3eeda9b7378.webp',12342,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',39,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(40,'秦朝铜诏版.webp','秦朝铜诏版.webp','/uploads/88572677c666468e8c66144f43d24186.webp',36058,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',40,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(41,'清代白玉如意.jpg','清代白玉如意.jpg','/uploads/bd43d42531484560933d09ec7502f243.jpg',604436,'image/jpeg',2000,1238,'relic',NULL,NULL,NULL,'admin','relic',41,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(42,'清代鼻烟壶.webp','清代鼻烟壶.webp','/uploads/3a92d4aea53e4857a9ce860f15c511c2.webp',24196,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',42,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(43,'清代翡翠手镯.webp','清代翡翠手镯.webp','/uploads/529731d36ef8408590babfb9f4cd584c.webp',4512,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',43,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(44,'清代粉彩瓶.webp','清代粉彩瓶.webp','/uploads/c77e9d65149544b98c254da1592b9650.webp',15274,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',44,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(45,'清代官服.webp','清代官服.webp','/uploads/0306afb2748e4cdb96e5292143173bf6.webp',6698,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',45,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(46,'清代红木柜.webp','清代红木柜.webp','/uploads/ff357c7d674f40a5b8000c918182f7fe.webp',10462,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',46,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(47,'清代花鸟立轴.webp','清代花鸟立轴.webp','/uploads/58a4b9b01b7740ddb7cb206dab672f08.webp',17552,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',47,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(48,'清代铜香插.webp','清代铜香插.webp','/uploads/d35eb1aa7fdc434f81c5ca1790c0aaa0.webp',9694,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',48,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(49,'清代行书扇面.webp','清代行书扇面.webp','/uploads/298dcbaa80b94d30aa24baa9c3c850af.webp',16470,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',49,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(50,'清代银锭.webp','清代银锭.webp','/uploads/43b585c6af20412e98bf3a4191d99c36.webp',11816,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',50,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(51,'清代银簪.webp','清代银簪.webp','/uploads/adaff9788ded43359a696008bac31900.webp',22580,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',51,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(52,'清代郑板桥竹石图.webp','清代郑板桥竹石图.webp','/uploads/fffcad1c276141588537230a45f1aee8.webp',15082,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',52,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(53,'清代织金袍.webp','清代织金袍.webp','/uploads/9554fd393ce240ea99a2788886bf09a8.webp',7378,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',53,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(54,'清代紫檀桌.webp','清代紫檀桌.webp','/uploads/3b0c4c59760041dfbbbe323ee122dde4.webp',3356,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',54,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(55,'清帖拓页.jpg','清帖拓页.jpg','/uploads/d3b88237423f4b5fbfd69ab309942557.jpg',235329,'image/jpeg',932,1024,'relic',NULL,NULL,NULL,'admin','relic',55,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(56,'汝窑天青釉盏.webp','汝窑天青釉盏.webp','/uploads/6bd0676aaba342a0a7da079eb82dec70.webp',16186,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',56,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(57,'三国青瓷罐.webp','三国青瓷罐.webp','/uploads/88da0fad01314386b5968c70ede17edb.webp',2694,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',57,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(58,'山水卷轴.webp','山水卷轴.webp','/uploads/75d2df6fbd6b4bf2b669e6344533ad26.webp',76182,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',58,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(59,'商代青铜鼎.webp','商代青铜鼎.webp','/uploads/e1f44f18efda4cbf918cc666a368091a.webp',7740,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',59,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(60,'商代青铜觚.jpg','商代青铜觚.jpg','/uploads/38eee9a70cb34f24a48ede15088d9d15.jpg',167105,'image/jpeg',1600,867,'relic',NULL,NULL,NULL,'admin','relic',60,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(61,'商代玉戈.webp','商代玉戈.webp','/uploads/fc921cae189342e493a59d5436ff04cc.webp',6128,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',61,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(62,'石雕观音像.jpg','石雕观音像.jpg','/uploads/43e6e949f77f4a91b0114e4693edad14.jpg',100551,'image/jpeg',550,666,'relic',NULL,NULL,NULL,'admin','relic',62,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(63,'宋代白瓷瓶.jpg','宋代白瓷瓶.jpg','/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg',113760,'image/jpeg',700,1070,'relic',NULL,NULL,NULL,'admin','relic',63,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(64,'宋代碑刻拓片.webp','宋代碑刻拓片.webp','/uploads/7c80c4768d8e4d54a7dad114b4d47c42.webp',31052,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',64,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(65,'宋代木雕罗汉.webp','宋代木雕罗汉.webp','/uploads/5efe908f0b594c0f8aaf1a90b63b0596.webp',10638,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',65,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(66,'宋代汝窑盘.webp','宋代汝窑盘.webp','/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp',2004,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',66,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(67,'宋代铜钱套装.webp','宋代铜钱套装.webp','/uploads/57fb47604e1c4e4eb35cace934f6f0eb.webp',9410,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',67,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(68,'宋代银壶.webp','宋代银壶.webp','/uploads/08c6ab0e5b4643179743861502d297b5.webp',12184,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',68,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(69,'宋代织锦残片.jpg','宋代织锦残片.jpg','/uploads/12ff4825507f43fd85ca71521284491c.jpg',53031,'image/jpeg',645,433,'relic',NULL,NULL,NULL,'admin','relic',69,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(70,'宋徽宗瘦金体书法.webp','宋徽宗瘦金体书法.webp','/uploads/322f2cc978d249ba98113313ae837853.webp',16574,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',70,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(71,'宋人山水册页.webp','宋人山水册页.webp','/uploads/f9c3ff6a9b11439894dcf068dc52138b.webp',21030,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',71,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(72,'宋帖影印本.jpeg','宋帖影印本.jpeg','/uploads/b2c5eaf363914301870124970b2a61ec.jpeg',87355,'image/jpeg',850,362,'relic',NULL,NULL,NULL,'admin','relic',72,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(73,'隋朝石刻佛首.webp','隋朝石刻佛首.webp','/uploads/90324eee34794322bf92eea2151d74ad.webp',15802,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',73,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(74,'唐碑拓本.webp','唐碑拓本.webp','/uploads/59454ff4a2c042fd925150657b318d51.webp',26628,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',74,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(75,'唐代金杯.webp','唐代金杯.webp','/uploads/645b9ef90d134ef0b0139a4fa7918046.webp',11324,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',75,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(76,'唐代龙凤玉佩.webp','唐代龙凤玉佩.webp','/uploads/63d15e510c7d4e3db421a419b350fe24.webp',3902,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',76,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(77,'唐代墓志铭.webp','唐代墓志铭.webp','/uploads/8a46b212628d48d5ab02a77e02697f1b.webp',12580,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',77,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(78,'唐代青铜佛像.webp','唐代青铜佛像.webp','/uploads/3c219d52e3814f8d8c6277827ec91d97.webp',11008,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',78,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(79,'唐代山水画卷.webp','唐代山水画卷.webp','/uploads/9784a41ce1a44bcbb3ce5f6428fe578b.webp',12246,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',79,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(80,'唐代铜佛像.jpg','唐代铜佛像.jpg','/uploads/e089b182f84640379e15b2400d714945.jpg',837682,'image/jpeg',1488,2000,'relic',NULL,NULL,NULL,'admin','relic',80,1,1,0,1,'2026-04-23 15:19:03','2026-04-23 16:57:49'),(81,'唐代铜观音.webp','唐代铜观音.webp','/uploads/6da715a8159045bda0e896de63ace624.webp',6124,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',81,1,1,0,1,'2026-04-23 15:19:03','2026-04-23 16:57:43'),(82,'唐代玉带饰.jpg','唐代玉带饰.jpg','/uploads/dde2f35afcff45f09b596453e10a4ef0.jpg',15196,'image/jpeg',562,433,'relic',NULL,NULL,NULL,'admin','relic',82,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(83,'唐开元通宝.webp','唐开元通宝.webp','/uploads/cdce86e7172a4afd980616b72139e389.webp',9274,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',83,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(84,'唐三彩马.webp','唐三彩马.webp','/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp',6316,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',84,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(85,'王羲之兰亭序摹本.webp','王羲之兰亭序摹本.webp','/uploads/ab83d1743bd541d79414fe67c8a5e524.webp',17550,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',85,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(86,'王羲之摹本.jpg','王羲之摹本.jpg','/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg',67022,'image/jpeg',1234,408,'relic',NULL,NULL,NULL,'admin','relic',86,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(87,'魏碑拓片.webp','魏碑拓片.webp','/uploads/ce705c2e63fc421bb86c03b9866e23de.webp',76218,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',87,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(88,'五代十国银执壶.jpg','五代十国银执壶.jpg','/uploads/3ca543bae2a045379128befb7e377b26.jpg',79612,'image/jpeg',467,700,'relic',NULL,NULL,NULL,'admin','relic',88,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(89,'西汉青铜镜.jpg','西汉青铜镜.jpg','/uploads/295deac6800f40c4ae4983184256f1d2.jpg',180575,'image/jpeg',564,564,'relic',NULL,NULL,NULL,'admin','relic',89,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(90,'西夏文残碑拓片.webp','西夏文残碑拓片.webp','/uploads/8a42bd4782a14cd8a1774817ed013e9c.webp',54878,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',90,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(91,'西周青铜簋.webp','西周青铜簋.webp','/uploads/230a77be5e6c4522aa33237f9e12dba0.webp',11022,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',91,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(92,'夏朝青铜铃.webp','夏朝青铜铃.webp','/uploads/4ca25ebf262344e4b063b6cdfbc37e69.webp',5036,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',92,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(93,'新石器彩陶罐.webp','新石器彩陶罐.webp','/uploads/5daff7dd306e4104ba29ad26d2fd0fa7.webp',3720,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',93,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(94,'新石器玉璧.webp','新石器玉璧.webp','/uploads/409d3e97d9704f25b6464797f156a888.webp',3290,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',94,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(95,'元代金冠.webp','元代金冠.webp','/uploads/f8d4f30997cd4eceb41293d08bb8f511.webp',15236,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',95,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(96,'元代金饰片.webp','元代金饰片.webp','/uploads/68fb242a5a634fceaee81b622bcab6a3.webp',11926,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',96,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(97,'元代墨竹图.jpg','元代墨竹图.jpg','/uploads/25588e9135eb47459a61873b01be1e5b.jpg',455586,'image/jpeg',2030,1080,'relic',NULL,NULL,NULL,'admin','relic',97,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(98,'元代青花瓷瓶.webp','元代青花瓷瓶.webp','/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp',10102,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',98,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(99,'元代赵孟頫行书.webp','元代赵孟頫行书.webp','/uploads/df772c02a59a42638c72c399180620b3.webp',15846,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',99,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(100,'元青花梅瓶.jpg','元青花梅瓶.jpg','/uploads/3284351accd947448894fb6607a88f7c.jpg',147800,'image/jpeg',960,1521,'relic',NULL,NULL,NULL,'admin','relic',100,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(101,'战国刀币.webp','战国刀币.webp','/uploads/943a120f7a794fbaa6fb93d440447317.webp',10532,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',101,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(102,'战国龙纹玉璧.webp','战国龙纹玉璧.webp','/uploads/dd86229ede644f57a2efe72b44c61738.webp',13538,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',102,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(103,'战国漆器盒.webp','战国漆器盒.webp','/uploads/1e461ed655484847bce9d967ae110e73.webp',7670,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',103,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(104,'战国青铜剑.webp','战国青铜剑.webp','/uploads/2170bd1297d7486bba277c514d27e9f2.webp',2176,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',104,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(105,'兵马俑.jpg','兵马俑.jpg','/uploads/e0c81692a3c34a8088300bc1ea3d6303.jpg',41121,'image/jpeg',NULL,NULL,'relic',NULL,NULL,1,'admin','relic',270,1,1,0,1,'2026-04-23 16:16:55','2026-04-23 16:42:57');
/*!40000 ALTER TABLE `image_library` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tr_delete_image_relic_relation` AFTER DELETE ON `image_library` FOR EACH ROW BEGIN
    -- 删除关联记录（外键级联会自动处理，这里是额外的清理）
    DELETE FROM relic_image_relation WHERE image_id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `image_library_backup_20260423`
--

DROP TABLE IF EXISTS `image_library_backup_20260423`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `image_library_backup_20260423` (
  `id` bigint NOT NULL DEFAULT '0' COMMENT '图片ID',
  `image_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '图片名称',
  `original_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '原始文件名',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件路径',
  `file_size` bigint DEFAULT NULL COMMENT '文件大小(字节)',
  `file_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '文件类型(MIME)',
  `width` int DEFAULT NULL COMMENT '图片宽度',
  `height` int DEFAULT NULL COMMENT '图片高度',
  `category` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'uncategorized' COMMENT '分类(relic/exhibition/document/other/uncategorized)',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '标签(逗号分隔)',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '描述',
  `uploader_id` bigint DEFAULT NULL COMMENT '上传者ID',
  `uploader_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '上传者姓名',
  `reference_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '关联类型(relic/loan/repair等)',
  `reference_id` bigint DEFAULT NULL COMMENT '关联对象ID',
  `is_public` tinyint DEFAULT '1' COMMENT '是否公开(1:是 0:否)',
  `view_count` int DEFAULT '0' COMMENT '浏览次数',
  `download_count` int DEFAULT '0' COMMENT '下载次数',
  `status` tinyint DEFAULT '1' COMMENT '状态(1:正常 0:已删除)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image_library_backup_20260423`
--

LOCK TABLES `image_library_backup_20260423` WRITE;
/*!40000 ALTER TABLE `image_library_backup_20260423` DISABLE KEYS */;
INSERT INTO `image_library_backup_20260423` VALUES (1,'北宋铜钱串.jpg','北宋铜钱串.jpg','/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg',49872,'image/jpeg',700,494,'relic',NULL,NULL,NULL,'admin','relic',1,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:32:39'),(2,'北魏石佛头像.webp','北魏石佛头像.webp','/uploads/c6c6d69e1b2c4f9b9249750249e0722c.webp',59754,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',2,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:32:39'),(3,'北魏石佛像.webp','北魏石佛像.webp','/uploads/7d1c8d9746954228ad84bb360a48e958.webp',18716,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',3,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(4,'北魏造像碑.webp','北魏造像碑.webp','/uploads/3a61faebc0ef44638ca78150f3bc978d.webp',18918,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',4,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(5,'曾侯乙编钟.webp','曾侯乙编钟.webp','/uploads/32877c4cd94f4c7f98de18818a8c5104.webp',18406,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',5,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(6,'春秋青铜编钟.jpeg','春秋青铜编钟.jpeg','/uploads/045f072278a640b0b5a1ab25a4bcc4d7.jpeg',30293,'image/jpeg',640,612,'relic',NULL,NULL,NULL,'admin','relic',6,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(7,'大禹鼎.webp','大禹鼎.webp','/uploads/3536f8a54033417db069185f5a53ed4e.webp',7730,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',7,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(8,'东汉铜灯.jpg','东汉铜灯.jpg','/uploads/6cd196faa27044cabfd3257132e0a023.jpg',177576,'image/jpeg',810,1023,'relic',NULL,NULL,NULL,'admin','relic',8,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(9,'汉碑残拓.webp','汉碑残拓.webp','/uploads/e423867d6e4f4aac83af6cb469f4bbc7.webp',66428,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',9,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(10,'汉代彩绘陶俑.webp','汉代彩绘陶俑.webp','/uploads/7a334f27bf404354b547edc28f274458.webp',13832,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',10,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(11,'汉代漆盘.webp','汉代漆盘.webp','/uploads/7a49cbe142044f7c9d0a77ae81f5407c.webp',5926,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',11,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(12,'汉代青铜镜.webp','汉代青铜镜.webp','/uploads/678d29b16b5b4f12975d11fc2234feb3.webp',15174,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',12,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(13,'汉代石碑.webp','汉代石碑.webp','/uploads/e371e143cebe48abb5ef249fd426ccd1.webp',43302,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',13,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(14,'汉代丝织残片.jpg','汉代丝织残片.jpg','/uploads/3d0187ad0349445fabf4e0b33c512579.jpg',45189,'image/jpeg',500,363,'relic',NULL,NULL,NULL,'admin','relic',14,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(15,'汉代玉衣片.webp','汉代玉衣片.webp','/uploads/a6175e984ff14c8389805dd4508cb84e.webp',11226,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',15,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(16,'汉五铢钱.webp','汉五铢钱.webp','/uploads/9032c02617784f07954a342206f8d298.webp',17040,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',16,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(17,'汉五铢钱范.webp','汉五铢钱范.webp','/uploads/afabd4e7a71d49ad8ac87373a7a3fb48.webp',8440,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',17,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(18,'和田白玉佩.jpg','和田白玉佩.jpg','/uploads/17a595c9464541eaa43c2a2b77afd543.jpg',249824,'image/jpeg',1350,1800,'relic',NULL,NULL,NULL,'admin','relic',18,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(19,'金代鎏金杯.webp','金代鎏金杯.webp','/uploads/48f50558423a4fa98876114cd7cc1914.webp',35634,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',19,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(20,'开元通宝套币.jpg','开元通宝套币.jpg','/uploads/b1a5dc0a56e649cb98dcd54893ce2cf9.jpg',109824,'image/jpeg',700,525,'relic',NULL,NULL,NULL,'admin','relic',20,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(21,'辽代玉鸟佩.webp','辽代玉鸟佩.webp','/uploads/433fa46930e04a3fbf0737ed392d4fd6.webp',7726,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',21,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(22,'鎏金银壶.webp','鎏金银壶.webp','/uploads/8e9d1bac019c4e6fa93bf0d8537b4245.webp',8352,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',22,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(23,'民国漆盒.jpg','民国漆盒.jpg','/uploads/d3200cbab3b049fc961bfade69089eac.jpg',159197,'image/jpeg',1417,1358,'relic',NULL,NULL,NULL,'admin','relic',23,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(24,'民国旗袍.webp','民国旗袍.webp','/uploads/3c3c740446124bc794e2339c33eb37ea.webp',9062,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',24,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(25,'明代补子.webp','明代补子.webp','/uploads/3b5b872bc4574442be36bdfa7525f43d.webp',28430,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',25,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(26,'明代黄花梨椅.webp','明代黄花梨椅.webp','/uploads/970e5599235e41aabb14c8275df4475e.webp',9774,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',26,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(27,'明代金簪.webp','明代金簪.webp','/uploads/971880acf0944e498e2c11a133011590.webp',8608,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',27,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(28,'明代龙袍.webp','明代龙袍.webp','/uploads/e4bed460f71d495d945fd6630cdcf323.webp',18164,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',28,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(29,'明代木雕佛龛.webp','明代木雕佛龛.webp','/uploads/3f14bc2165a04e32a96846dd28c20158.webp',22258,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',29,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(30,'明代青花盘.webp','明代青花盘.webp','/uploads/0fa0b165b82c4ca3bde7575dc4e79e39.webp',30644,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',30,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(31,'明代青花碗.webp','明代青花碗.webp','/uploads/4baa8e62f5d54bdea8c5afe846b3ddf9.webp',6846,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',31,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(32,'明代唐寅山水画.webp','明代唐寅山水画.webp','/uploads/3f8291c4743e4e078f1f5b47e69bdcce.webp',22236,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',32,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(33,'明代剔红盒.webp','明代剔红盒.webp','/uploads/aab685aa93184206a68ad8a41bb8a604.webp',5662,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',33,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(34,'明代铜佛.webp','明代铜佛.webp','/uploads/e22c85430b234395a7e4911fb9f36541.webp',10478,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',34,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(35,'明代银锭.jpg','明代银锭.jpg','/uploads/e9f595acac3f40f18e29d3a921144290.jpg',195719,'image/jpeg',1442,1008,'relic',NULL,NULL,NULL,'admin','relic',35,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(36,'明代银香炉.webp','明代银香炉.webp','/uploads/019f1b7f43cd415ca0a9263fc8ea7053.webp',18106,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',36,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(37,'明代玉如意.webp','明代玉如意.webp','/uploads/47e94f29a81244c0ae8f71c8ede34dfb.webp',3456,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',37,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(38,'明代云锦服饰.webp','明代云锦服饰.webp','/uploads/7cb302c8ff474f1bbb00064077ff6447.webp',20252,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',38,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(39,'秦半两钱.webp','秦半两钱.webp','/uploads/e1411506fcf94f5a8bedd3eeda9b7378.webp',12342,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',39,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(40,'秦朝铜诏版.webp','秦朝铜诏版.webp','/uploads/88572677c666468e8c66144f43d24186.webp',36058,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',40,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(41,'清代白玉如意.jpg','清代白玉如意.jpg','/uploads/bd43d42531484560933d09ec7502f243.jpg',604436,'image/jpeg',2000,1238,'relic',NULL,NULL,NULL,'admin','relic',41,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(42,'清代鼻烟壶.webp','清代鼻烟壶.webp','/uploads/3a92d4aea53e4857a9ce860f15c511c2.webp',24196,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',42,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(43,'清代翡翠手镯.webp','清代翡翠手镯.webp','/uploads/529731d36ef8408590babfb9f4cd584c.webp',4512,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',43,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(44,'清代粉彩瓶.webp','清代粉彩瓶.webp','/uploads/c77e9d65149544b98c254da1592b9650.webp',15274,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',44,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(45,'清代官服.webp','清代官服.webp','/uploads/0306afb2748e4cdb96e5292143173bf6.webp',6698,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',45,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(46,'清代红木柜.webp','清代红木柜.webp','/uploads/ff357c7d674f40a5b8000c918182f7fe.webp',10462,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',46,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(47,'清代花鸟立轴.webp','清代花鸟立轴.webp','/uploads/58a4b9b01b7740ddb7cb206dab672f08.webp',17552,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',47,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(48,'清代铜香插.webp','清代铜香插.webp','/uploads/d35eb1aa7fdc434f81c5ca1790c0aaa0.webp',9694,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',48,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(49,'清代行书扇面.webp','清代行书扇面.webp','/uploads/298dcbaa80b94d30aa24baa9c3c850af.webp',16470,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',49,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(50,'清代银锭.webp','清代银锭.webp','/uploads/43b585c6af20412e98bf3a4191d99c36.webp',11816,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',50,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(51,'清代银簪.webp','清代银簪.webp','/uploads/adaff9788ded43359a696008bac31900.webp',22580,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',51,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(52,'清代郑板桥竹石图.webp','清代郑板桥竹石图.webp','/uploads/fffcad1c276141588537230a45f1aee8.webp',15082,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',52,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(53,'清代织金袍.webp','清代织金袍.webp','/uploads/9554fd393ce240ea99a2788886bf09a8.webp',7378,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',53,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(54,'清代紫檀桌.webp','清代紫檀桌.webp','/uploads/3b0c4c59760041dfbbbe323ee122dde4.webp',3356,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',54,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(55,'清帖拓页.jpg','清帖拓页.jpg','/uploads/d3b88237423f4b5fbfd69ab309942557.jpg',235329,'image/jpeg',932,1024,'relic',NULL,NULL,NULL,'admin','relic',55,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(56,'汝窑天青釉盏.webp','汝窑天青釉盏.webp','/uploads/6bd0676aaba342a0a7da079eb82dec70.webp',16186,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',56,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(57,'三国青瓷罐.webp','三国青瓷罐.webp','/uploads/88da0fad01314386b5968c70ede17edb.webp',2694,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',57,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(58,'山水卷轴.webp','山水卷轴.webp','/uploads/75d2df6fbd6b4bf2b669e6344533ad26.webp',76182,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',58,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(59,'商代青铜鼎.webp','商代青铜鼎.webp','/uploads/e1f44f18efda4cbf918cc666a368091a.webp',7740,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',59,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(60,'商代青铜觚.jpg','商代青铜觚.jpg','/uploads/38eee9a70cb34f24a48ede15088d9d15.jpg',167105,'image/jpeg',1600,867,'relic',NULL,NULL,NULL,'admin','relic',60,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(61,'商代玉戈.webp','商代玉戈.webp','/uploads/fc921cae189342e493a59d5436ff04cc.webp',6128,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',61,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(62,'石雕观音像.jpg','石雕观音像.jpg','/uploads/43e6e949f77f4a91b0114e4693edad14.jpg',100551,'image/jpeg',550,666,'relic',NULL,NULL,NULL,'admin','relic',62,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(63,'宋代白瓷瓶.jpg','宋代白瓷瓶.jpg','/uploads/cbb82347ac9e4112a6aecb970a7acd74.jpg',113760,'image/jpeg',700,1070,'relic',NULL,NULL,NULL,'admin','relic',63,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(64,'宋代碑刻拓片.webp','宋代碑刻拓片.webp','/uploads/7c80c4768d8e4d54a7dad114b4d47c42.webp',31052,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',64,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(65,'宋代木雕罗汉.webp','宋代木雕罗汉.webp','/uploads/5efe908f0b594c0f8aaf1a90b63b0596.webp',10638,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',65,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(66,'宋代汝窑盘.webp','宋代汝窑盘.webp','/uploads/a8b3f94cbd194ae2b3904806ee0364c6.webp',2004,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',66,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(67,'宋代铜钱套装.webp','宋代铜钱套装.webp','/uploads/57fb47604e1c4e4eb35cace934f6f0eb.webp',9410,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',67,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(68,'宋代银壶.webp','宋代银壶.webp','/uploads/08c6ab0e5b4643179743861502d297b5.webp',12184,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',68,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(69,'宋代织锦残片.jpg','宋代织锦残片.jpg','/uploads/12ff4825507f43fd85ca71521284491c.jpg',53031,'image/jpeg',645,433,'relic',NULL,NULL,NULL,'admin','relic',69,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(70,'宋徽宗瘦金体书法.webp','宋徽宗瘦金体书法.webp','/uploads/322f2cc978d249ba98113313ae837853.webp',16574,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',70,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(71,'宋人山水册页.webp','宋人山水册页.webp','/uploads/f9c3ff6a9b11439894dcf068dc52138b.webp',21030,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',71,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(72,'宋帖影印本.jpeg','宋帖影印本.jpeg','/uploads/b2c5eaf363914301870124970b2a61ec.jpeg',87355,'image/jpeg',850,362,'relic',NULL,NULL,NULL,'admin','relic',72,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(73,'隋朝石刻佛首.webp','隋朝石刻佛首.webp','/uploads/90324eee34794322bf92eea2151d74ad.webp',15802,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',73,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(74,'唐碑拓本.webp','唐碑拓本.webp','/uploads/59454ff4a2c042fd925150657b318d51.webp',26628,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',74,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(75,'唐代金杯.webp','唐代金杯.webp','/uploads/645b9ef90d134ef0b0139a4fa7918046.webp',11324,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',75,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(76,'唐代龙凤玉佩.webp','唐代龙凤玉佩.webp','/uploads/63d15e510c7d4e3db421a419b350fe24.webp',3902,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',76,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(77,'唐代墓志铭.webp','唐代墓志铭.webp','/uploads/8a46b212628d48d5ab02a77e02697f1b.webp',12580,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',77,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(78,'唐代青铜佛像.webp','唐代青铜佛像.webp','/uploads/3c219d52e3814f8d8c6277827ec91d97.webp',11008,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',78,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(79,'唐代山水画卷.webp','唐代山水画卷.webp','/uploads/9784a41ce1a44bcbb3ce5f6428fe578b.webp',12246,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',79,1,0,0,1,'2026-04-23 15:19:02','2026-04-23 15:33:06'),(80,'唐代铜佛像.jpg','唐代铜佛像.jpg','/uploads/e089b182f84640379e15b2400d714945.jpg',837682,'image/jpeg',1488,2000,'relic',NULL,NULL,NULL,'admin','relic',80,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(81,'唐代铜观音.webp','唐代铜观音.webp','/uploads/6da715a8159045bda0e896de63ace624.webp',6124,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',81,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(82,'唐代玉带饰.jpg','唐代玉带饰.jpg','/uploads/dde2f35afcff45f09b596453e10a4ef0.jpg',15196,'image/jpeg',562,433,'relic',NULL,NULL,NULL,'admin','relic',82,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(83,'唐开元通宝.webp','唐开元通宝.webp','/uploads/cdce86e7172a4afd980616b72139e389.webp',9274,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',83,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(84,'唐三彩马.webp','唐三彩马.webp','/uploads/aa0e3faee7b64ccb84a19a928c55f566.webp',6316,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',84,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(85,'王羲之兰亭序摹本.webp','王羲之兰亭序摹本.webp','/uploads/ab83d1743bd541d79414fe67c8a5e524.webp',17550,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',85,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(86,'王羲之摹本.jpg','王羲之摹本.jpg','/uploads/01f1a5d031a349bcb69b2bbca13846af.jpg',67022,'image/jpeg',1234,408,'relic',NULL,NULL,NULL,'admin','relic',86,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(87,'魏碑拓片.webp','魏碑拓片.webp','/uploads/ce705c2e63fc421bb86c03b9866e23de.webp',76218,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',87,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(88,'五代十国银执壶.jpg','五代十国银执壶.jpg','/uploads/3ca543bae2a045379128befb7e377b26.jpg',79612,'image/jpeg',467,700,'relic',NULL,NULL,NULL,'admin','relic',88,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(89,'西汉青铜镜.jpg','西汉青铜镜.jpg','/uploads/295deac6800f40c4ae4983184256f1d2.jpg',180575,'image/jpeg',564,564,'relic',NULL,NULL,NULL,'admin','relic',89,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(90,'西夏文残碑拓片.webp','西夏文残碑拓片.webp','/uploads/8a42bd4782a14cd8a1774817ed013e9c.webp',54878,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',90,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(91,'西周青铜簋.webp','西周青铜簋.webp','/uploads/230a77be5e6c4522aa33237f9e12dba0.webp',11022,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',91,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(92,'夏朝青铜铃.webp','夏朝青铜铃.webp','/uploads/4ca25ebf262344e4b063b6cdfbc37e69.webp',5036,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',92,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(93,'新石器彩陶罐.webp','新石器彩陶罐.webp','/uploads/5daff7dd306e4104ba29ad26d2fd0fa7.webp',3720,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',93,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(94,'新石器玉璧.webp','新石器玉璧.webp','/uploads/409d3e97d9704f25b6464797f156a888.webp',3290,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',94,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(95,'元代金冠.webp','元代金冠.webp','/uploads/f8d4f30997cd4eceb41293d08bb8f511.webp',15236,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',95,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(96,'元代金饰片.webp','元代金饰片.webp','/uploads/68fb242a5a634fceaee81b622bcab6a3.webp',11926,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',96,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(97,'元代墨竹图.jpg','元代墨竹图.jpg','/uploads/25588e9135eb47459a61873b01be1e5b.jpg',455586,'image/jpeg',2030,1080,'relic',NULL,NULL,NULL,'admin','relic',97,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(98,'元代青花瓷瓶.webp','元代青花瓷瓶.webp','/uploads/615f1dcbe4f64d9cb256330910c5cdd5.webp',10102,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',98,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(99,'元代赵孟頫行书.webp','元代赵孟頫行书.webp','/uploads/df772c02a59a42638c72c399180620b3.webp',15846,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',99,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(100,'元青花梅瓶.jpg','元青花梅瓶.jpg','/uploads/3284351accd947448894fb6607a88f7c.jpg',147800,'image/jpeg',960,1521,'relic',NULL,NULL,NULL,'admin','relic',100,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(101,'战国刀币.webp','战国刀币.webp','/uploads/943a120f7a794fbaa6fb93d440447317.webp',10532,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',101,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(102,'战国龙纹玉璧.webp','战国龙纹玉璧.webp','/uploads/dd86229ede644f57a2efe72b44c61738.webp',13538,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',102,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(103,'战国漆器盒.webp','战国漆器盒.webp','/uploads/1e461ed655484847bce9d967ae110e73.webp',7670,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',103,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(104,'战国青铜剑.webp','战国青铜剑.webp','/uploads/2170bd1297d7486bba277c514d27e9f2.webp',2176,'image/webp',NULL,NULL,'relic',NULL,NULL,NULL,'admin','relic',104,1,0,0,1,'2026-04-23 15:19:03','2026-04-23 15:33:06'),(105,'兵马俑.jpg','兵马俑.jpg','/uploads/e0c81692a3c34a8088300bc1ea3d6303.jpg',41121,'image/jpeg',NULL,NULL,'relic',NULL,NULL,1,'admin','relic',270,1,0,0,1,'2026-04-23 16:16:55','2026-04-23 16:18:37');
/*!40000 ALTER TABLE `image_library_backup_20260423` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loan_record`
--

DROP TABLE IF EXISTS `loan_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loan_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `relic_id` bigint NOT NULL,
  `borrower_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `borrower_unit` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `borrower_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `loan_date` datetime NOT NULL,
  `expected_return_date` datetime NOT NULL,
  `actual_return_date` datetime DEFAULT NULL,
  `purpose` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '待审批',
  `approver_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `approve_time` datetime DEFAULT NULL,
  `approve_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_relic_id` (`relic_id`),
  KEY `idx_status` (`status`),
  KEY `idx_expected_return_date` (`expected_return_date`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loan_record`
--

LOCK TABLES `loan_record` WRITE;
/*!40000 ALTER TABLE `loan_record` DISABLE KEYS */;
INSERT INTO `loan_record` VALUES (1,5,'张博','省博物馆','13910000001','2026-01-10 10:00:00','2026-02-10 10:00:00','2026-02-08 15:00:00','专题展出','已归还','审批员一号','2026-01-09 14:00:00','同意','2026-04-02 18:00:33','2026-04-02 18:00:33'),(2,3,'李文','市历史馆','13910000002','2026-02-01 09:30:00','2026-03-01 09:30:00','2026-04-06 20:37:11','交流展览','已归还','审批员一号','2026-01-31 16:30:00','同意','2026-04-02 18:00:33','2026-04-06 20:37:11'),(3,2,'王晓','文旅局','13910000003','2026-02-15 11:00:00','2026-03-15 11:00:00',NULL,'学术研究','逾期','审批员二号','2026-02-14 10:20:00','同意','2026-04-02 18:00:33','2026-04-02 18:00:33'),(4,1,'周宁','大学博物馆','13910000004','2026-03-05 13:00:00','2026-04-05 13:00:00',NULL,'联合展览','已驳回','系统管理员','2026-04-06 20:37:13','审批驳回','2026-04-02 18:00:33','2026-04-02 18:00:33'),(5,7,'吴言','民俗馆','13910000005','2026-03-10 09:00:00','2026-04-10 09:00:00',NULL,'借展','借展中','系统管理员','2026-04-06 20:37:15','审批通过','2026-04-02 18:00:33','2026-04-02 18:00:33'),(6,10,'郑文','收藏研究院','13910000006','2026-03-12 09:30:00','2026-04-12 09:30:00',NULL,'文献研究','借展中','审批员二号','2026-03-11 12:00:00','同意','2026-04-02 18:00:33','2026-04-02 18:00:33'),(7,11,'冯哲','地方馆','13910000007','2026-03-14 10:00:00','2026-04-14 10:00:00','2026-04-13 14:32:32','服饰文化展','已归还','审批员一号','2026-03-13 18:00:00','同意','2026-04-02 18:00:33','2026-04-13 14:32:32'),(8,9,'陈默','碑刻馆','13910000008','2026-03-16 11:00:00','2026-04-16 11:00:00',NULL,'拓片临展','已驳回','admin','2026-04-14 20:54:58','审批驳回','2026-04-02 18:00:33','2026-04-02 18:00:33'),(9,12,'高远','佛教文化馆','13910000009','2026-03-18 12:30:00','2026-04-18 12:30:00',NULL,'专题展','借展中','admin','2026-04-14 20:55:02','审批通过','2026-04-02 18:00:33','2026-04-02 18:00:33'),(10,4,'赵川','瓷器馆','13910000010','2026-03-20 14:00:00','2026-04-20 14:00:00',NULL,'文物联展','借展中','审批员二号','2026-03-19 16:00:00','同意','2026-04-02 18:00:33','2026-04-02 18:00:33'),(11,4,'钱多多','湖北省博物馆','1234561213','2026-04-16 16:00:00','2026-05-01 09:05:00',NULL,'','待审批',NULL,NULL,NULL,'2026-04-15 23:26:01','2026-04-15 23:26:01'),(12,1,'张文博','省博物馆','13900001001','2024-03-01 09:00:00','2024-04-01 09:00:00','2024-03-30 15:00:00','青铜器专题展览','已归还','赵国强','2024-02-28 14:00:00','同意借展','2024-02-25 10:00:00','2026-04-17 13:41:05'),(13,3,'李明华','市历史博物馆','13900001002','2024-04-10 10:00:00','2024-05-10 10:00:00','2024-05-09 16:00:00','战国文物展','已归还','刘建国','2024-04-08 15:00:00','同意','2024-04-05 11:00:00','2026-04-17 13:41:05'),(14,7,'王静雅','文化艺术中心','13900001003','2024-05-15 09:00:00','2024-06-15 09:00:00','2026-04-23 20:30:45','唐代文化展','已归还','赵国强','2024-05-13 16:00:00','批准借展','2024-05-10 09:00:00','2026-04-23 20:30:45'),(15,14,'陈晓东','大学博物馆','13900001004','2024-06-01 10:00:00','2024-07-01 10:00:00',NULL,'书画艺术研究','借展中','刘建国','2024-05-30 14:00:00','同意','2024-05-28 10:00:00','2026-04-17 13:41:05'),(16,9,'周敏','艺术馆','13900001005','2024-06-10 11:00:00','2024-07-10 11:00:00',NULL,'瓷器文化展','借展中','赵国强','2024-06-08 15:00:00','批准','2024-06-05 11:00:00','2026-04-17 13:41:05'),(17,12,'吴建华','文物研究所','13900001006','2024-07-01 09:00:00','2024-08-01 09:00:00',NULL,'古代书法研究','待审批',NULL,NULL,NULL,'2024-06-28 10:00:00','2026-04-17 13:41:05'),(18,18,'郑云飞','玉器博物馆','13900001007','2024-07-05 10:00:00','2024-08-05 10:00:00',NULL,'玉器专题展','待审批',NULL,NULL,NULL,'2024-07-02 11:00:00','2026-04-17 13:41:05'),(19,24,'孙丽娟','金银器馆','13900001008','2024-07-10 11:00:00','2024-08-10 11:00:00',NULL,'唐代金银器展','待审批',NULL,NULL,NULL,'2024-07-08 09:00:00','2026-04-17 13:41:05'),(20,29,'马志强','碑刻博物馆','13900001009','2024-07-15 09:00:00','2024-08-15 09:00:00',NULL,'汉代碑刻研究','待审批',NULL,NULL,NULL,'2024-07-12 10:00:00','2026-04-17 13:41:05'),(21,38,'林芳','服饰博物馆','13900001010','2024-07-20 10:00:00','2024-08-20 10:00:00',NULL,'明清服饰展','待审批',NULL,NULL,NULL,'2024-07-18 11:00:00','2026-04-17 13:41:05'),(22,5,'黄伟','佛教艺术馆','13900001011','2024-02-15 09:00:00','2024-03-15 09:00:00','2024-03-14 16:00:00','佛教造像展','已归还','赵国强','2024-02-13 14:00:00','同意','2024-02-10 10:00:00','2026-04-17 13:41:05'),(23,10,'徐晓明','陶瓷研究院','13900001012','2024-03-20 10:00:00','2024-04-20 10:00:00','2024-04-25 15:00:00','明代瓷器研究','已归还','刘建国','2024-03-18 15:00:00','批准','2024-03-15 11:00:00','2026-04-17 13:41:05'),(24,25,'张文博','金属工艺馆','13900001013','2024-04-25 11:00:00','2024-05-25 11:00:00',NULL,'古代金属工艺展','逾期','赵国强','2024-04-23 16:00:00','同意','2024-04-20 09:00:00','2026-04-17 13:41:05'),(25,33,'李明华','钱币博物馆','13900001014','2024-05-30 09:00:00','2024-06-30 09:00:00',NULL,'战国货币研究','借展中','刘建国','2024-05-28 14:00:00','批准','2024-05-25 10:00:00','2026-04-17 13:41:05'),(26,45,'王静雅','家具博物馆','13900001015','2024-06-20 10:00:00','2024-07-20 10:00:00',NULL,'明式家具展','借展中','赵国强','2024-06-18 15:00:00','同意','2024-06-15 11:00:00','2026-04-17 13:41:05'),(27,3,'顾云舟','湖北省博物馆','12345678910','2026-04-19 22:12:23','2026-04-30 12:08:00',NULL,'展览','待审批',NULL,NULL,NULL,'2026-04-19 22:12:47','2026-04-19 22:12:47');
/*!40000 ALTER TABLE `loan_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenance_record`
--

DROP TABLE IF EXISTS `maintenance_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenance_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `relic_id` bigint NOT NULL,
  `maintenance_type` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `maintenance_date` datetime NOT NULL,
  `maintenance_content` text COLLATE utf8mb4_general_ci NOT NULL,
  `maintainer` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_relic_id` (`relic_id`),
  KEY `idx_maintenance_date` (`maintenance_date`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenance_record`
--

LOCK TABLES `maintenance_record` WRITE;
/*!40000 ALTER TABLE `maintenance_record` DISABLE KEYS */;
INSERT INTO `maintenance_record` VALUES (1,1,'日常保养','2026-01-05 09:00:00','表面除尘、防氧化处理','保管员一号','正常','2020-04-02 18:00:33','2026-01-05 09:00:00'),(2,2,'状态检查','2026-01-15 10:00:00','剑身锈蚀点检查','保管员二号','轻微锈斑','2020-04-02 18:00:33','2026-01-15 10:00:00'),(3,3,'环境检查','2026-01-20 11:00:00','温湿度记录与釉面观察','馆员一号','正常','2020-04-02 18:00:33','2026-01-20 11:00:00'),(4,4,'日常保养','2026-02-02 09:30:00','无酸擦拭处理','馆员二号','正常','2020-04-02 18:00:33','2026-02-02 09:30:00'),(5,5,'状态检查','2026-02-10 14:00:00','纸本边缘加固评估','保管员一号','建议修复','2020-04-02 18:00:33','2026-02-10 14:00:00'),(6,6,'日常保养','2026-02-18 15:00:00','防潮箱更新','馆员三号','正常','2020-04-02 18:00:33','2026-02-18 15:00:00'),(7,7,'状态检查','2026-02-25 10:20:00','玉质裂纹检查','馆员四号','正常','2020-04-02 18:00:33','2026-02-25 10:20:00'),(8,8,'深度维护','2026-03-01 09:40:00','金属腐蚀处置','保管员二号','已转修复','2020-04-02 18:00:33','2026-03-01 09:40:00'),(9,9,'日常保养','2026-03-08 11:10:00','拓片展卷整理','馆员五号','正常','2020-04-02 18:00:33','2026-03-08 11:10:00'),(10,12,'状态检查','2026-03-15 13:30:00','石雕裂隙监测','馆员一号','持续观察','2020-04-02 18:00:33','2026-03-15 13:30:00'),(11,1,'检测','2026-04-08 12:00:00','检测裂痕','保管员一号','无明显裂痕','2026-04-07 22:18:34','2026-04-07 22:18:34'),(12,10,'日常维护','2026-04-14 00:00:00','检查套币完整度','zzz','','2026-04-14 20:51:30','2026-04-14 20:51:30'),(13,1,'日常保养','2024-01-20 09:00:00','青铜器表面除尘，防氧化处理','张文博','状态良好','2024-01-20 09:30:00','2026-04-17 13:41:18'),(14,2,'状态检查','2024-01-25 10:00:00','检查青铜簋表面锈蚀情况','李明华','发现轻微锈斑','2024-01-25 10:30:00','2026-04-17 13:41:18'),(15,3,'日常保养','2024-02-05 11:00:00','青铜剑除尘，刃部保护','王静雅','保存完好','2024-02-05 11:30:00','2026-04-17 13:41:18'),(16,4,'深度维护','2024-02-10 09:00:00','铜镜表面清洁与防护','张文博','已做防护处理','2024-02-10 09:30:00','2026-04-17 13:41:18'),(17,5,'状态检查','2024-02-15 10:00:00','检查鎏金残存情况','李明华','鎏金脱落严重','2024-02-15 10:30:00','2026-04-17 13:41:18'),(18,6,'日常保养','2024-02-20 11:00:00','彩陶罐除尘，温湿度监测','王静雅','正常','2024-02-20 11:30:00','2026-04-17 13:41:18'),(19,7,'环境检查','2024-02-25 09:00:00','三彩马釉面检查，环境调控','郑云飞','釉面完好','2024-02-25 09:30:00','2026-04-17 13:41:18'),(20,8,'日常保养','2024-03-01 10:00:00','汝窑盘清洁保养','孙丽娟','开片自然','2024-03-01 10:30:00','2026-04-17 13:41:18'),(21,9,'状态检查','2024-03-05 11:00:00','青花瓷瓶釉面检查','马志强','状态良好','2024-03-05 11:30:00','2026-04-17 13:41:18'),(22,10,'日常保养','2024-03-10 09:00:00','青花碗除尘保养','林芳','正常','2024-03-10 09:30:00','2026-04-17 13:41:18'),(23,12,'环境检查','2024-03-15 10:00:00','书法作品防潮检查','张文博','需要除湿','2024-03-15 10:30:00','2026-04-17 13:41:18'),(24,13,'日常保养','2024-03-20 11:00:00','山水画卷展卷检查','李明华','绢本完好','2024-03-20 11:30:00','2026-04-17 13:41:18'),(25,15,'状态检查','2024-03-25 09:00:00','行书手卷纸张状态检查','王静雅','纸张老化','2024-03-25 09:30:00','2026-04-17 13:41:18'),(26,18,'日常保养','2024-04-01 10:00:00','玉璧清洁保养','郑云飞','玉质温润','2024-04-01 10:30:00','2026-04-17 13:41:18'),(27,20,'状态检查','2024-04-05 11:00:00','玉衣片检查','孙丽娟','完好','2024-04-05 11:30:00','2026-04-17 13:41:18'),(28,24,'深度维护','2024-04-10 09:00:00','金杯清洁与防护','马志强','已做保护','2024-04-10 09:30:00','2026-04-17 13:41:18'),(29,25,'状态检查','2024-04-15 10:00:00','银壶氧化检查','林芳','需要修复','2024-04-15 10:30:00','2026-04-17 13:41:18'),(30,29,'日常保养','2024-04-20 11:00:00','石碑除尘清洁','张文博','碑文清晰','2024-04-20 11:30:00','2026-04-17 13:41:18'),(31,38,'环境检查','2024-04-25 09:00:00','龙袍防虫防潮检查','李明华','需要防虫处理','2024-04-25 09:30:00','2026-04-17 13:41:18'),(32,45,'日常保养','2024-05-01 10:00:00','黄花梨椅清洁保养','王静雅','木质良好','2024-05-01 10:30:00','2026-04-17 13:41:18');
/*!40000 ALTER TABLE `maintenance_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `museum`
--

DROP TABLE IF EXISTS `museum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `museum` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '博物馆ID',
  `museum_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '博物馆编码',
  `museum_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '博物馆名称',
  `museum_type` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '博物馆类型（综合类、历史类、艺术类、自然类等）',
  `province` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '省份',
  `city` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '城市',
  `address` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '详细地址',
  `contact_person` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `contact_email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系邮箱',
  `description` text COLLATE utf8mb4_general_ci COMMENT '博物馆简介',
  `status` tinyint DEFAULT '1' COMMENT '状态：1启用 0禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `museum_code` (`museum_code`),
  KEY `idx_museum_code` (`museum_code`),
  KEY `idx_museum_name` (`museum_name`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='博物馆信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `museum`
--

LOCK TABLES `museum` WRITE;
/*!40000 ALTER TABLE `museum` DISABLE KEYS */;
INSERT INTO `museum` VALUES (1,'MUS001','国家博物馆','综合类','北京市','北京市','天安门广场东侧','张馆长','010-12345678','contact@nationalmuseum.cn','中国国家博物馆是世界上单体建筑面积最大的博物馆',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(2,'MUS002','故宫博物院','历史类','北京市','北京市','景山前街4号','李馆长','010-87654321','contact@dpm.org.cn','明清两代的皇家宫殿，世界文化遗产',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(3,'MUS003','上海博物馆','综合类','上海市','上海市','人民大道201号','王馆长','021-12345678','contact@shanghaimuseum.net','中国古代艺术博物馆',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(4,'MUS004','陕西历史博物馆','历史类','陕西省','西安市','小寨东路91号','赵馆长','029-12345678','contact@sxhm.com','中国第一座大型现代化国家级博物馆',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(5,'MUS005','湖南省博物馆','综合类','湖南省','长沙市','东风路50号','刘馆长','0731-12345678','contact@hnmuseum.com','马王堆汉墓文物收藏地',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(6,'MUS006','南京博物院','综合类','江苏省','南京市','中山东路321号','陈馆长','025-12345678','contact@njmuseum.com','中国三大博物馆之一',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(7,'MUS007','浙江省博物馆','综合类','浙江省','杭州市','孤山路25号','周馆长','0571-12345678','contact@zhejiangmuseum.com','浙江省最大的综合性博物馆',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(8,'MUS008','河南博物院','历史类','河南省','郑州市','农业路8号','吴馆长','0371-12345678','contact@henanmuseum.net','中国建立较早的博物馆之一',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(9,'MUS009','湖北省博物馆','综合类','湖北省','武汉市','东湖路160号','郑馆长','027-12345678','contact@hubeimuseum.com','曾侯乙编钟收藏地',1,'2026-04-23 11:24:46','2026-04-23 11:24:46'),(10,'MUS010','广东省博物馆','综合类','广东省','广州市','珠江东路2号','黄馆长','020-12345678','contact@gdmuseum.com','岭南文化展示中心',1,'2026-04-23 11:24:46','2026-04-23 11:24:46');
/*!40000 ALTER TABLE `museum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relic_archive`
--

DROP TABLE IF EXISTS `relic_archive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relic_archive` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '档案ID',
  `relic_id` bigint NOT NULL COMMENT '文物ID',
  `archive_code` varchar(50) NOT NULL COMMENT '档案编号，如：AR-2024-001',
  `archive_title` varchar(200) NOT NULL COMMENT '档案标题',
  `archive_type` varchar(20) DEFAULT 'complete' COMMENT '档案类型：complete-完整档案/basic-基础档案/image-图片档案/document-文档档案',
  `description` text COMMENT '档案描述',
  `version` int DEFAULT '1' COMMENT '版本号',
  `status` varchar(20) DEFAULT 'draft' COMMENT '状态：draft-草稿/published-已发布/archived-已归档',
  `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `created_by_name` varchar(100) DEFAULT NULL COMMENT '创建人姓名',
  `created_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `published_time` datetime DEFAULT NULL COMMENT '发布时间',
  `archived_time` datetime DEFAULT NULL COMMENT '归档时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `archive_code` (`archive_code`),
  KEY `idx_relic_id` (`relic_id`),
  KEY `idx_archive_code` (`archive_code`),
  KEY `idx_status` (`status`),
  KEY `idx_created_time` (`created_time`),
  CONSTRAINT `relic_archive_ibfk_1` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文物档案主表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relic_archive`
--

LOCK TABLES `relic_archive` WRITE;
/*!40000 ALTER TABLE `relic_archive` DISABLE KEYS */;
/*!40000 ALTER TABLE `relic_archive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `relic_image_relation`
--

DROP TABLE IF EXISTS `relic_image_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `relic_image_relation` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `relic_id` bigint NOT NULL COMMENT '文物ID（唯一，确保一个文物只有一张主图）',
  `image_id` bigint NOT NULL COMMENT '图片ID（唯一，确保一张图片只关联一个文物）',
  `relation_type` varchar(20) DEFAULT 'main' COMMENT '关联类型（main:主图, detail:详情图等）',
  `sort_order` int DEFAULT '0' COMMENT '排序顺序',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `relic_id` (`relic_id`),
  UNIQUE KEY `image_id` (`image_id`),
  KEY `idx_relic_id` (`relic_id`),
  KEY `idx_image_id` (`image_id`),
  KEY `idx_relation_type` (`relation_type`),
  CONSTRAINT `fk_relic_image_image` FOREIGN KEY (`image_id`) REFERENCES `image_library` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_relic_image_relic` FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=212 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='文物图片关联表（一对一）';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `relic_image_relation`
--

LOCK TABLES `relic_image_relation` WRITE;
/*!40000 ALTER TABLE `relic_image_relation` DISABLE KEYS */;
INSERT INTO `relic_image_relation` VALUES (1,1,1,'main',1,'2026-04-23 15:33:19','2026-04-23 15:54:21'),(2,2,2,'main',1,'2026-04-23 15:33:30','2026-04-23 15:54:20'),(3,3,3,'main',1,'2025-01-03 10:00:00','2026-04-23 15:54:20'),(4,4,4,'main',1,'2025-01-04 10:00:00','2026-04-23 15:54:20'),(5,5,5,'main',1,'2025-01-05 10:00:00','2026-04-23 15:54:20'),(6,6,6,'main',1,'2025-01-06 10:00:00','2026-04-23 15:54:20'),(7,7,7,'main',1,'2025-01-07 10:00:00','2026-04-23 15:54:21'),(8,8,8,'main',1,'2025-01-08 10:00:00','2026-04-23 15:54:20'),(9,9,9,'main',1,'2025-01-09 10:00:00','2026-04-23 15:54:20'),(10,10,10,'main',1,'2025-01-10 10:00:00','2026-04-23 15:54:20'),(11,11,11,'main',1,'2025-01-11 10:00:00','2026-04-23 15:54:20'),(12,12,12,'main',1,'2025-01-12 10:00:00','2026-04-23 15:54:20'),(13,13,13,'main',1,'2025-01-13 10:00:00','2026-04-23 15:54:21'),(14,14,14,'main',1,'2025-01-14 10:00:00','2026-04-23 15:54:20'),(15,15,15,'main',1,'2025-01-15 10:00:00','2026-04-23 15:54:21'),(16,16,16,'main',1,'2025-01-16 10:00:00','2026-04-23 15:54:20'),(17,17,17,'main',1,'2025-01-17 10:00:00','2026-04-23 15:54:20'),(18,18,18,'main',1,'2025-01-18 10:00:00','2026-04-23 15:54:20'),(19,19,19,'main',1,'2025-01-19 10:00:00','2026-04-23 15:54:21'),(20,20,20,'main',1,'2025-01-20 10:00:00','2026-04-23 15:54:20'),(21,21,21,'main',1,'2025-01-21 10:00:00','2026-04-23 15:54:20'),(22,22,22,'main',1,'2025-01-22 10:00:00','2026-04-23 15:54:21'),(23,23,23,'main',1,'2025-01-23 10:00:00','2026-04-23 15:54:20'),(24,24,24,'main',1,'2025-01-24 10:00:00','2026-04-23 15:54:21'),(25,25,25,'main',1,'2025-01-25 10:00:00','2026-04-23 15:54:20'),(26,26,26,'main',1,'2025-01-26 10:00:00','2026-04-23 15:54:20'),(27,27,27,'main',1,'2025-01-27 10:00:00','2026-04-23 15:54:20'),(28,28,28,'main',1,'2025-01-28 10:00:00','2026-04-23 15:54:20'),(29,29,29,'main',1,'2025-01-29 10:00:00','2026-04-23 15:54:20'),(30,30,30,'main',1,'2025-01-30 10:00:00','2026-04-23 15:54:20'),(31,31,31,'main',1,'2025-01-31 10:00:00','2026-04-23 15:54:21'),(32,32,32,'main',1,'2025-02-01 10:00:00','2026-04-23 15:54:20'),(33,33,33,'main',1,'2025-02-02 10:00:00','2026-04-23 15:54:20'),(34,34,34,'main',1,'2025-02-03 10:00:00','2026-04-23 15:54:20'),(35,35,35,'main',1,'2025-02-04 10:00:00','2026-04-23 15:54:20'),(36,36,36,'main',1,'2025-02-05 10:00:00','2026-04-23 15:54:20'),(37,37,37,'main',1,'2025-02-06 10:00:00','2026-04-23 15:54:20'),(38,38,38,'main',1,'2025-02-07 10:00:00','2026-04-23 15:54:21'),(39,39,39,'main',1,'2025-02-08 10:00:00','2026-04-23 15:54:20'),(40,40,40,'main',1,'2025-02-09 10:00:00','2026-04-23 15:54:20'),(41,41,41,'main',1,'2025-02-10 10:00:00','2026-04-23 15:54:20'),(42,42,42,'main',1,'2025-02-11 10:00:00','2026-04-23 15:54:21'),(43,43,43,'main',1,'2025-02-12 10:00:00','2026-04-23 15:54:20'),(44,44,44,'main',1,'2025-02-13 10:00:00','2026-04-23 15:54:20'),(45,45,45,'main',1,'2025-02-14 10:00:00','2026-04-23 15:54:20'),(46,46,46,'main',1,'2025-02-15 10:00:00','2026-04-23 15:54:20'),(47,47,47,'main',1,'2025-02-16 10:00:00','2026-04-23 15:54:20'),(48,48,48,'main',1,'2025-02-17 10:00:00','2026-04-23 15:54:20'),(49,49,49,'main',1,'2025-02-18 10:00:00','2026-04-23 15:54:20'),(50,50,50,'main',1,'2025-02-19 10:00:00','2026-04-23 15:54:20'),(51,51,51,'main',1,'2025-02-20 10:00:00','2026-04-23 15:54:20'),(52,52,52,'main',1,'2025-02-21 10:00:00','2026-04-23 15:54:20'),(53,53,53,'main',1,'2025-02-22 10:00:00','2026-04-23 15:54:20'),(54,54,54,'main',1,'2025-02-23 10:00:00','2026-04-23 15:54:20'),(55,55,55,'main',1,'2025-02-24 10:00:00','2026-04-23 15:54:20'),(56,56,56,'main',1,'2025-02-25 10:00:00','2026-04-23 15:54:20'),(57,57,57,'main',1,'2025-02-26 10:00:00','2026-04-23 15:54:20'),(58,58,58,'main',1,'2025-02-27 10:00:00','2026-04-23 15:54:20'),(59,59,59,'main',1,'2025-02-28 10:00:00','2026-04-23 15:54:20'),(60,60,60,'main',1,'2025-03-01 10:00:00','2026-04-23 15:54:20'),(61,61,61,'main',1,'2025-03-02 10:00:00','2026-04-23 15:54:20'),(62,62,62,'main',1,'2025-03-03 10:00:00','2026-04-23 15:54:20'),(63,63,63,'main',1,'2025-03-04 10:00:00','2026-04-23 15:54:20'),(64,64,64,'main',1,'2025-03-05 10:00:00','2026-04-23 15:54:20'),(65,65,65,'main',1,'2025-03-06 10:00:00','2026-04-23 15:54:20'),(66,66,66,'main',1,'2025-03-07 10:00:00','2026-04-23 15:54:20'),(67,67,67,'main',1,'2025-03-08 10:00:00','2026-04-23 15:54:20'),(68,68,68,'main',1,'2025-03-09 10:00:00','2026-04-23 15:54:20'),(69,69,69,'main',1,'2025-03-10 10:00:00','2026-04-23 15:54:21'),(70,70,70,'main',1,'2025-03-11 10:00:00','2026-04-23 15:54:21'),(71,71,71,'main',1,'2025-03-12 10:00:00','2026-04-23 15:54:20'),(72,72,72,'main',1,'2025-03-13 10:00:00','2026-04-23 15:54:20'),(73,73,73,'main',1,'2025-03-14 10:00:00','2026-04-23 15:54:20'),(74,74,74,'main',1,'2025-03-15 10:00:00','2026-04-23 15:54:20'),(75,75,75,'main',1,'2025-03-16 10:00:00','2026-04-23 15:54:21'),(76,76,76,'main',1,'2025-03-17 10:00:00','2026-04-23 15:54:20'),(77,77,77,'main',1,'2025-03-18 10:00:00','2026-04-23 15:54:20'),(78,78,78,'main',1,'2025-03-19 10:00:00','2026-04-23 15:54:21'),(79,79,79,'main',1,'2025-03-20 10:00:00','2026-04-23 15:54:20'),(80,80,80,'main',1,'2025-03-21 10:00:00','2026-04-23 15:54:20'),(81,81,81,'main',1,'2025-03-22 10:00:00','2026-04-23 15:54:20'),(82,82,82,'main',1,'2025-03-23 10:00:00','2026-04-23 15:54:21'),(83,83,83,'main',1,'2025-03-24 10:00:00','2026-04-23 15:54:20'),(84,84,84,'main',1,'2025-03-25 10:00:00','2026-04-23 15:54:21'),(85,85,85,'main',1,'2025-03-26 10:00:00','2026-04-23 15:54:20'),(86,86,86,'main',1,'2025-03-27 10:00:00','2026-04-23 15:54:20'),(87,87,87,'main',1,'2025-03-28 10:00:00','2026-04-23 15:54:20'),(88,88,88,'main',1,'2025-03-29 10:00:00','2026-04-23 15:54:20'),(89,89,89,'main',1,'2025-03-30 10:00:00','2026-04-23 15:54:20'),(90,90,90,'main',1,'2025-03-31 10:00:00','2026-04-23 15:54:20'),(91,91,91,'main',1,'2025-04-01 10:00:00','2026-04-23 15:54:20'),(92,92,92,'main',1,'2025-04-02 10:00:00','2026-04-23 15:54:20'),(93,93,93,'main',1,'2025-04-03 10:00:00','2026-04-23 15:54:20'),(94,94,94,'main',1,'2025-04-04 10:00:00','2026-04-23 15:54:20'),(95,95,95,'main',1,'2025-04-05 10:00:00','2026-04-23 15:54:20'),(96,96,96,'main',1,'2025-04-06 10:00:00','2026-04-23 15:54:20'),(97,97,97,'main',1,'2025-04-07 10:00:00','2026-04-23 15:54:20'),(98,98,98,'main',1,'2025-04-08 10:00:00','2026-04-23 15:54:20'),(99,99,99,'main',1,'2025-04-09 10:00:00','2026-04-23 15:54:20'),(100,100,100,'main',1,'2025-04-10 10:00:00','2026-04-23 15:54:21'),(101,101,101,'main',1,'2025-04-11 10:00:00','2026-04-23 15:54:20'),(102,102,102,'main',1,'2025-04-12 10:00:00','2026-04-23 15:54:20'),(103,103,103,'main',1,'2025-04-13 10:00:00','2026-04-23 15:54:20'),(104,104,104,'main',1,'2025-04-14 10:00:00','2026-04-23 15:54:20'),(211,270,105,'main',1,'2026-04-23 16:16:55','2026-04-23 16:16:55');
/*!40000 ALTER TABLE `relic_image_relation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_expert`
--

DROP TABLE IF EXISTS `repair_expert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_expert` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expert_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT '专家姓名',
  `expert_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '专家编号',
  `specialty` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '专业领域',
  `title` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '职称',
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '联系电话',
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '邮箱',
  `work_years` int DEFAULT NULL COMMENT '从业年限',
  `certification` varchar(200) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '资质证书',
  `status` tinyint DEFAULT '1' COMMENT '状态：1启用 0禁用',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `expert_code` (`expert_code`),
  KEY `idx_expert_code` (`expert_code`),
  KEY `idx_specialty` (`specialty`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='修复专家表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_expert`
--

LOCK TABLES `repair_expert` WRITE;
/*!40000 ALTER TABLE `repair_expert` DISABLE KEYS */;
INSERT INTO `repair_expert` VALUES (1,'叶知秋','EXP001','纸质文物修复','高级修复师','13800001001','expert1@museum.com',15,'国家文物局颁发高级修复师证书',1,NULL,'2026-04-15 16:50:20','2026-04-18 15:23:09'),(2,'白露晞','EXP002','金属文物修复','高级修复师','13800001002','expert2@museum.com',12,'国家文物局颁发高级修复师证书',1,NULL,'2026-04-15 16:50:20','2026-04-18 15:23:09'),(3,'陆星河','EXP003','石质文物修复','中级修复师','13800001003','expert3@museum.com',8,'国家文物局颁发中级修复师证书',1,NULL,'2026-04-15 16:50:20','2026-04-18 15:23:09'),(4,'江晚晴','EXP004','陶瓷文物修复','高级修复师','13800001004','expert4@museum.com',18,'国家文物局颁发高级修复师证书',1,NULL,'2026-04-15 16:50:20','2026-04-18 15:23:09'),(5,'宋归远','EXP005','金银器文物修复','中级修复师','13800001005','exerpt5@museum.com',20,'国家文物局颁发中级修复师证书',1,NULL,'2026-04-23 20:49:54','2026-04-23 20:49:56');
/*!40000 ALTER TABLE `repair_expert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_material`
--

DROP TABLE IF EXISTS `repair_material`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_material` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `material_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL COMMENT '材料名称',
  `material_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '材料编号',
  `category` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '材料类别',
  `unit` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '单位',
  `unit_price` decimal(10,2) DEFAULT NULL COMMENT '单价',
  `stock_quantity` decimal(10,2) DEFAULT '0.00' COMMENT '库存数量',
  `supplier` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '供应商',
  `remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `material_code` (`material_code`),
  KEY `idx_material_code` (`material_code`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='修复材料表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_material`
--

LOCK TABLES `repair_material` WRITE;
/*!40000 ALTER TABLE `repair_material` DISABLE KEYS */;
INSERT INTO `repair_material` VALUES (1,'环氧树脂','MAT001','粘合剂','kg',150.00,50.00,'文保材料公司',NULL,'2026-04-15 16:50:20','2026-04-15 16:50:20'),(2,'化学试剂A','MAT002','清洁剂','L',200.00,30.00,'化工材料公司',NULL,'2026-04-15 16:50:20','2026-04-15 16:50:20'),(3,'保护镀层材料','MAT003','保护剂','kg',300.00,20.00,'文保材料公司',NULL,'2026-04-15 16:50:20','2026-04-15 16:50:20'),(4,'宣纸','MAT004','纸质材料','张',50.00,100.00,'传统工艺公司',NULL,'2026-04-15 16:50:20','2026-04-15 16:50:20'),(5,'丝绸','MAT005','纺织材料','m',80.00,50.00,'传统工艺公司',NULL,'2026-04-15 16:50:20','2026-04-15 16:50:20'),(6,'石材修复剂','MAT006','修复剂','kg',180.00,40.00,'文保材料公司',NULL,'2026-04-15 16:50:20','2026-04-15 16:50:20');
/*!40000 ALTER TABLE `repair_material` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_record`
--

DROP TABLE IF EXISTS `repair_record`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_record` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `repair_code` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修复编号',
  `relic_id` bigint NOT NULL COMMENT '文物ID',
  `status` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '待审批' COMMENT '状态：待审批、待修复、修复中、修复完成、已拒绝',
  `priority` varchar(20) COLLATE utf8mb4_general_ci DEFAULT '普通' COMMENT '优先级：紧急、高、普通、低',
  `applicant` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '申请人',
  `apply_date` datetime DEFAULT NULL COMMENT '申请日期',
  `repair_reason` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修复原因',
  `damage_description` text COLLATE utf8mb4_general_ci COMMENT '损坏描述',
  `estimated_cost` decimal(10,2) DEFAULT '0.00' COMMENT '预算费用',
  `approver` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审批人',
  `approve_date` datetime DEFAULT NULL COMMENT '审批日期',
  `approve_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '审批意见',
  `repair_expert` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修复专家',
  `start_date` datetime DEFAULT NULL COMMENT '开始修复日期',
  `complete_date` datetime DEFAULT NULL COMMENT '完成日期',
  `repair_process` text COLLATE utf8mb4_general_ci COMMENT '修复过程',
  `repair_method` text COLLATE utf8mb4_general_ci COMMENT '修复方法',
  `materials_used` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '使用材料',
  `actual_cost` decimal(10,2) DEFAULT '0.00' COMMENT '实际费用',
  `before_images` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修复前照片（多张，逗号分隔）',
  `after_images` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '修复后照片（多张，逗号分隔）',
  `quality_score` int DEFAULT '0' COMMENT '质量评分（0-100）',
  `quality_remark` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '质量评估意见',
  `remark` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '备注',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_repair_code` (`repair_code`),
  KEY `idx_relic_id` (`relic_id`),
  KEY `idx_status` (`status`),
  KEY `idx_apply_date` (`apply_date`),
  KEY `idx_repair_expert` (`repair_expert`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='修复记录表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_record`
--

LOCK TABLES `repair_record` WRITE;
/*!40000 ALTER TABLE `repair_record` DISABLE KEYS */;
INSERT INTO `repair_record` VALUES (1,'REP2026001',8,'修复完成','高','保管员一号','2026-02-25 09:00:00','表面氧化严重','银壶表面出现大面积氧化层，局部有腐蚀斑点，影响观赏价值',2500.00,NULL,NULL,NULL,'修复师乙','2026-03-01 09:00:00','2026-03-05 16:00:00','1. 表面清洁 2. 化学稳定处理 3. 镀层保护 4. 抛光处理','采用化学还原法去除氧化层，使用保护性镀层防止再次氧化','化学试剂、保护镀层材料、抛光材料',2500.00,'/uploads/repair/before_8_1.jpg,/uploads/repair/before_8_2.jpg','/uploads/repair/after_8_1.jpg,/uploads/repair/after_8_2.jpg',95,'修复效果优秀，表面光洁度恢复良好，保护层均匀','修复过程顺利，未发现其他隐藏损伤','2026-04-15 16:50:26','2026-04-15 16:50:26'),(2,'REP2026002',5,'修复中','紧急','保管员一号','2026-02-08 10:00:00','纸本边缘磨损','书法作品边缘出现磨损和撕裂，需要加固处理',1200.00,NULL,NULL,NULL,'修复师甲','2026-02-12 10:00:00',NULL,'正在进行纤维修补和边缘加固','使用传统装裱技术进行纸张加固和边缘修补','宣纸、浆糊、丝绸',0.00,'/uploads/repair/before_5_1.jpg,/uploads/repair/before_5_2.jpg',NULL,0,NULL,'需要特别注意墨迹保护，避免水分渗透','2026-04-15 16:50:26','2026-04-15 16:50:26'),(3,'REP2026003',12,'待修复','普通','馆员一号','2026-03-15 11:00:00','石雕裂隙扩大','观音像底座出现裂纹，有扩大趋势，需要及时处理',3000.00,NULL,NULL,NULL,'修复师丙',NULL,NULL,NULL,'计划采用环氧树脂填补裂缝，并进行结构加固','环氧树脂、加固材料、石材修复剂',0.00,'/uploads/repair/before_12_1.jpg',NULL,0,NULL,'已通过审批，等待修复师档期安排','2026-04-15 16:50:26','2026-04-15 16:50:26'),(4,'REP2026004',2,'待审批','普通','保管员二号','2026-04-10 14:00:00','剑身锈蚀处理','青铜剑剑身出现锈蚀点，需要进行除锈和防护处理',900.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,'/uploads/repair/before_2_1.jpg',NULL,0,NULL,'等待审批','2026-04-15 16:50:26','2026-04-15 16:50:26'),(5,'REP2026005',3,'已拒绝','低','馆员二号','2026-04-05 09:30:00','釉面细微裂纹','唐三彩马釉面有细微裂纹',1500.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0.00,'/uploads/repair/before_3_1.jpg',NULL,0,NULL,'审批意见：裂纹属于自然老化现象，不影响文物价值，暂不需要修复','2026-04-15 16:50:26','2026-04-15 16:50:26'),(6,'REP2026006',2,'待审批','普通',NULL,NULL,'表面锈蚀',NULL,1500.00,NULL,NULL,NULL,'修复专家李工','2024-02-01 09:00:00',NULL,'化学除锈，表面防护涂层处理',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-02-01 16:00:00','2026-04-17 13:49:54'),(7,'REP2026007',5,'待审批','普通',NULL,NULL,'鎏金脱落',NULL,3500.00,NULL,NULL,NULL,'修复专家王工','2024-02-20 10:00:00',NULL,'鎏金修复，表面加固处理',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-02-20 17:00:00','2026-04-17 13:49:54'),(8,'REP2026008',15,'待审批','普通',NULL,NULL,'纸张老化',NULL,2800.00,NULL,NULL,NULL,'修复专家张工','2024-04-01 11:00:00',NULL,'脱酸处理，边缘加固',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-04-01 18:00:00','2026-04-17 13:49:54'),(9,'REP2026009',25,'待审批','普通',NULL,NULL,'银器氧化',NULL,2200.00,NULL,NULL,NULL,'修复专家赵工','2024-04-20 09:00:00',NULL,'化学清洗，防氧化处理',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-04-20 16:00:00','2026-04-17 13:49:54'),(10,'REP2026010',38,'待审批','普通',NULL,NULL,'织物破损',NULL,4500.00,NULL,NULL,NULL,'修复专家刘工','2024-05-05 10:00:00',NULL,'织物修补，防虫处理',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-05-05 17:00:00','2026-04-17 13:49:54'),(11,'REP2026011',11,'待审批','普通',NULL,NULL,'釉面细裂',NULL,1800.00,NULL,NULL,NULL,'修复专家陈工','2024-03-15 11:00:00',NULL,'显微加固处理',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-03-15 18:00:00','2026-04-17 13:49:54'),(12,'REP2026012',30,'待审批','普通',NULL,NULL,'碑文模糊',NULL,3200.00,NULL,NULL,NULL,'修复专家周工','2024-04-25 09:00:00',NULL,'表面清洁，文字加固',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-04-25 16:00:00','2026-04-17 13:49:54'),(13,'REP2026013',43,'待审批','普通',NULL,NULL,'彩绘脱落',NULL,2600.00,NULL,NULL,NULL,'修复专家吴工','2024-05-10 10:00:00',NULL,'彩绘修复，表面保护',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-05-10 17:00:00','2026-04-17 13:49:54'),(14,'REP2026014',48,'待审批','普通',NULL,NULL,'漆层剥落',NULL,2100.00,NULL,NULL,NULL,'修复专家郑工','2024-05-20 11:00:00',NULL,'漆层修补，表面加固',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-05-20 18:00:00','2026-04-17 13:49:54'),(15,'REP2026015',46,'待审批','普通',NULL,NULL,'木材开裂',NULL,5500.00,NULL,NULL,NULL,'修复专家孙工','2024-05-15 09:00:00',NULL,'裂缝填补，结构加固',NULL,NULL,0.00,NULL,NULL,0,NULL,NULL,'2024-05-15 16:00:00','2026-04-17 13:49:54'),(16,'REP2026016',68,'修复中','高','admin','2026-04-23 20:52:40','银壶氧化','银壶氧化变黑',250.00,'admin','2026-04-23 20:53:11','','宋归远','2026-04-23 20:54:56',NULL,NULL,NULL,NULL,0.00,'',NULL,0,NULL,'','2026-04-23 20:52:40','2026-04-23 20:54:56'),(17,'REP2026017',3,'修复中','紧急','admin','2026-04-23 20:56:03','佛身破损','佛身破损',1000.00,'admin','2026-04-23 20:56:11','','陆星河','2026-04-23 20:58:00',NULL,NULL,NULL,NULL,0.00,'',NULL,0,NULL,'','2026-04-23 20:56:03','2026-04-23 20:58:00');
/*!40000 ALTER TABLE `repair_record` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `repair_record_backup`
--

DROP TABLE IF EXISTS `repair_record_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `repair_record_backup` (
  `id` bigint NOT NULL DEFAULT '0',
  `relic_id` bigint NOT NULL,
  `repair_reason` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `repair_process` text COLLATE utf8mb4_general_ci,
  `repair_person` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `repair_cost` decimal(10,2) DEFAULT '0.00',
  `repair_date` datetime DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `repair_record_backup`
--

LOCK TABLES `repair_record_backup` WRITE;
/*!40000 ALTER TABLE `repair_record_backup` DISABLE KEYS */;
INSERT INTO `repair_record_backup` VALUES (1,5,'边缘磨损','纤维修补与边缘加固','修复师甲',1200.00,'2026-02-12 10:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(2,8,'表面氧化','化学稳定与镀层保护','修复师乙',2500.00,'2026-03-03 14:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(3,12,'细小裂纹','裂缝填补与结构加固','修复师丙',3000.00,'2026-03-18 16:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(4,2,'锈蚀处理','局部除锈与防护涂层','修复师甲',900.00,'2026-01-30 09:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(5,3,'釉面细裂','显微加固处理','修复师丁',1500.00,'2026-02-06 11:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(6,4,'口沿磨损','口沿修补','修复师丙',800.00,'2026-02-20 15:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(7,7,'挂件松动','重新固定连接结构','修复师乙',650.00,'2026-02-28 10:30:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(8,9,'纸张老化','脱酸与装裱修护','修复师丁',2100.00,'2026-03-10 13:00:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(9,10,'表面污渍','清洗与保护蜡处理','修复师甲',500.00,'2026-03-12 09:30:00','2026-04-02 18:00:33','2026-04-02 18:00:33'),(10,11,'织物松散','织物加固与局部补线','修复师丙',1700.00,'2026-03-16 14:20:00','2026-04-02 18:00:33','2026-04-02 18:00:33');
/*!40000 ALTER TABLE `repair_record_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_dict`
--

DROP TABLE IF EXISTS `sys_dict`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_dict` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `dict_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `dict_label` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `dict_value` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `sort_order` int DEFAULT '0',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_dict_type` (`dict_type`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_dict`
--

LOCK TABLES `sys_dict` WRITE;
/*!40000 ALTER TABLE `sys_dict` DISABLE KEYS */;
INSERT INTO `sys_dict` VALUES (1,'relic_status','在库','在库',1,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(2,'relic_status','借出','借出',2,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(3,'relic_status','维修中','维修中',3,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(4,'loan_status','待审批','待审批',1,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(5,'loan_status','借展中','借展中',2,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(6,'loan_status','已归还','已归还',3,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(7,'loan_status','逾期','逾期',4,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(8,'maint_type','日常保养','日常保养',1,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(9,'maint_type','状态检查','状态检查',2,'2026-04-02 18:00:34','2026-04-02 18:00:34'),(10,'maint_type','深度维护','深度维护',3,'2026-04-02 18:00:34','2026-04-02 18:00:34');
/*!40000 ALTER TABLE `sys_dict` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_operation_log`
--

DROP TABLE IF EXISTS `sys_operation_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_operation_log` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `operator` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `operation_type` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `operation_module` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `operation_content` varchar(1000) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `operation_result` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ip_address` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `operation_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_operator` (`operator`),
  KEY `idx_operation_time` (`operation_time`)
) ENGINE=InnoDB AUTO_INCREMENT=547 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_operation_log`
--

LOCK TABLES `sys_operation_log` WRITE;
/*!40000 ALTER TABLE `sys_operation_log` DISABLE KEYS */;
INSERT INTO `sys_operation_log` VALUES (1,'张明远','登录','认证模块','用户登录','成功','127.0.0.1','2026-03-20 09:00:00'),(2,'李婉清','新增','文物管理','新增文物','成功','127.0.0.1','2026-03-20 09:10:00'),(3,'王建国','修改','文物管理','修改文物信息','成功','127.0.0.1','2026-03-20 09:20:00'),(4,'陈淑华','审批','借展管理','审批借展记录','成功','127.0.0.1','2026-03-20 09:30:00'),(5,'刘志强','审批','借展管理','审批借展记录','成功','127.0.0.1','2026-03-20 09:40:00'),(6,'林小夏','新增','维护管理','新增维护记录','成功','127.0.0.1','2026-03-20 09:50:00'),(7,'周子轩','新增','修复管理','新增修复记录','成功','127.0.0.1','2026-03-20 10:00:00'),(8,'赵雨桐','导出','统计模块','导出借展统计报表','成功','127.0.0.1','2026-03-20 10:10:00'),(9,'张明远','查询','日志模块','查询系统日志','成功','127.0.0.1','2026-03-20 10:20:00'),(10,'张明远','登出','认证模块','管理员退出系统','成功','127.0.0.1','2026-03-20 10:30:00'),(11,'张明远','登录','认证模块','管理员登录系统','成功','192.168.1.100','2024-01-15 08:30:00'),(12,'沈听澜','新增','文物管理','新增文物','成功','192.168.1.101','2024-01-15 09:00:00'),(13,'张明远','操作','文物管理','新增文物','成功','192.168.1.102','2024-01-16 10:00:00'),(14,'李婉清','修改','文物管理','修改文物信息','成功','192.168.1.103','2024-02-20 11:30:00'),(15,'王建国','审批','借展管理','审批借展申请','成功','192.168.1.104','2024-02-28 14:00:00'),(16,'陈淑华','审批','借展管理','审批借展申请','成功','192.168.1.105','2024-04-08 15:00:00'),(17,'刘志强','新增','维护管理','新增维护记录','成功','192.168.1.101','2024-01-20 09:30:00'),(18,'林小夏','新增','维护管理','新增维护记录','成功','192.168.1.102','2024-01-25 10:30:00'),(19,'周子轩','新增','修复管理','新增修复记录','成功','192.168.1.106','2024-02-01 16:00:00'),(20,'赵雨桐','新增','修复管理','新增修复记录','成功','192.168.1.107','2024-02-20 17:00:00'),(21,'徐天宇','审批','借展管理','审批借展申请','成功','192.168.1.104','2024-05-13 16:00:00'),(22,'叶知秋','审批','借展管理','审批借展申请','成功','192.168.1.105','2024-05-30 14:00:00'),(23,'顾云舟','修改','文物管理','更新文物信息','成功','192.168.1.103','2024-03-10 10:00:00'),(24,'沈听澜','导出','统计模块','导出文物统计报表','成功','192.168.1.100','2024-04-15 14:30:00'),(25,'张明远','查询','日志模块','查询系统操作日志','成功','192.168.1.108','2024-05-01 09:00:00'),(26,'李婉清','删除','文物管理','删除重复文物记录','成功','192.168.1.101','2024-03-20 11:00:00'),(27,'王建国','修改','用户管理','修改用户权限','成功','192.168.1.100','2024-02-10 10:00:00'),(28,'陈淑华','驳回','借展管理','驳回借展申请','成功','192.168.1.104','2024-04-05 15:00:00'),(29,'刘志强','新增','维护管理','新增维护记录','成功','192.168.1.109','2024-03-25 09:30:00'),(30,'林小夏','登出','认证模块','管理员退出系统','成功','192.168.1.100','2024-05-20 18:00:00'),(31,'张明远','登录','系统认证','用户登录','成功','127.0.0.1','2026-04-15 15:50:33'),(32,'张明远','新增','用户管理','新增用户','成功','127.0.0.1','2026-04-15 15:50:33'),(33,'张明远','修改','文物管理','修改文物信息','成功','127.0.0.1','2026-04-16 15:50:33'),(34,'张明远','删除','用户管理','删除用户','成功','127.0.0.1','2026-04-16 15:50:33'),(35,'张明远','查询','文物管理','导出文物数据','成功','127.0.0.1','2026-04-17 10:50:33'),(36,'张明远','登出','系统认证','退出登录','成功','127.0.0.1','2026-04-17 12:50:33'),(37,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 12:40:10'),(38,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-18 12:40:24'),(39,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 12:40:40'),(40,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 12:41:27'),(41,'张明远','删除','分类管理','删除文物分类','成功','0:0:0:0:0:0:0:1','2026-04-18 12:41:55'),(42,'张明远','删除','分类管理','删除文物分类','成功','0:0:0:0:0:0:0:1','2026-04-18 12:41:57'),(43,'张明远','删除','分类管理','删除文物分类','成功','0:0:0:0:0:0:0:1','2026-04-18 12:42:02'),(44,'张明远','删除','分类管理','删除文物分类','成功','0:0:0:0:0:0:0:1','2026-04-18 12:42:06'),(45,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-18 13:01:33'),(46,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 13:01:41'),(47,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 15:23:34'),(48,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:24:33'),(49,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:24:57'),(50,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:25:26'),(51,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:26:31'),(52,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:26:46'),(53,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:27:17'),(54,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:27:37'),(55,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:27:52'),(56,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:28:16'),(57,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:28:34'),(58,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:28:51'),(59,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:29:16'),(60,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:29:29'),(61,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:30:05'),(62,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:30:21'),(63,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:30:39'),(64,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:30:59'),(65,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:31:19'),(66,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:31:34'),(67,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:31:56'),(68,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:32:12'),(69,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:32:32'),(70,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:32:50'),(71,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:33:04'),(72,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:33:20'),(73,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:33:37'),(74,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:33:54'),(75,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:34:15'),(76,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:34:41'),(77,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:35:03'),(78,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:35:26'),(79,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:35:45'),(80,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:36:10'),(81,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:36:30'),(82,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:36:52'),(83,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:37:07'),(84,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:38:01'),(85,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:38:19'),(86,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:38:46'),(87,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:39:07'),(88,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:39:32'),(89,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:39:47'),(90,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:40:02'),(91,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:40:19'),(92,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:40:43'),(93,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:40:58'),(94,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:41:13'),(95,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:41:33'),(96,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:42:04'),(97,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:42:24'),(98,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:42:45'),(99,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:43:08'),(100,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:43:27'),(101,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:43:48'),(102,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:44:06'),(103,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:44:24'),(104,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:44:38'),(105,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:44:56'),(106,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:45:37'),(107,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:46:13'),(108,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:02'),(109,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:07'),(110,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:13'),(111,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:17'),(112,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:20'),(113,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:25'),(114,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:29'),(115,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:36'),(116,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:40'),(117,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:44'),(118,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:48'),(119,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:47:56'),(120,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:48:00'),(121,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:48:05'),(122,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:48:17'),(123,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:01'),(124,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:08'),(125,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:16'),(126,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:21'),(127,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:26'),(128,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:31'),(129,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:36'),(130,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:41'),(131,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:46'),(132,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:53'),(133,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:49:56'),(134,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:00'),(135,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:04'),(136,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:08'),(137,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:13'),(138,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:16'),(139,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:20'),(140,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:24'),(141,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:29'),(142,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:33'),(143,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:36'),(144,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:40'),(145,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:46'),(146,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:51'),(147,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:50:55'),(148,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:51:05'),(149,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:51:10'),(150,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:51:24'),(151,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:52:07'),(152,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:52:15'),(153,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-18 15:52:21'),(154,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-18 16:18:36'),(155,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 16:18:54'),(156,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-18 16:19:07'),(157,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-19 21:54:07'),(158,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-19 21:54:12'),(159,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-19 21:54:30'),(160,'admin','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-19 22:02:45'),(161,'admin','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-19 22:02:50'),(162,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-19 22:02:53'),(163,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-19 22:03:04'),(164,'顾云舟','新增','借展管理','提交借展申请','失败','0:0:0:0:0:0:0:1','2026-04-19 22:10:25'),(165,'顾云舟','新增','借展管理','提交借展申请','成功','0:0:0:0:0:0:0:1','2026-04-19 22:12:47'),(166,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-22 11:16:59'),(167,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-22 11:17:27'),(168,'顾云舟','查询','AI查询','AI智能查询文物','成功','0:0:0:0:0:0:0:1','2026-04-22 11:18:33'),(169,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 10:40:37'),(170,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 10:41:06'),(171,'李婉清','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 10:41:29'),(172,'chen','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 10:41:38'),(173,'陈淑华','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 10:41:42'),(174,'顾云舟','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 11:12:54'),(175,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 11:18:13'),(176,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 11:18:28'),(177,'张明远','新增','用户管理','新增用户','成功','0:0:0:0:0:0:0:1','2026-04-23 11:32:42'),(178,'张明远','新增','用户管理','新增用户','成功','0:0:0:0:0:0:0:1','2026-04-23 11:56:58'),(179,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 11:57:20'),(180,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 12:13:11'),(181,'张明远','查询','文物管理','导出文物数据(Excel)','成功','0:0:0:0:0:0:0:1','2026-04-23 12:42:45'),(182,'张明远','查询','文物管理','导出文物数据(Excel)','成功','0:0:0:0:0:0:0:1','2026-04-23 12:51:14'),(183,'张明远','查询','文物管理','导出文物数据(PDF)','成功','0:0:0:0:0:0:0:1','2026-04-23 12:51:16'),(184,'张明远','查询','文物管理','导出文物数据(Word)','成功','0:0:0:0:0:0:0:1','2026-04-23 12:51:17'),(185,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:33:30'),(186,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:33:37'),(187,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:35:22'),(188,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:35:34'),(189,'李婉清','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:35:46'),(190,'李婉清','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:35:52'),(191,'陈淑华','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:35:56'),(192,'陈淑华','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:36:08'),(193,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:40:52'),(194,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:42:58'),(195,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:43:11'),(196,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:44:00'),(197,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:44:06'),(198,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:47:05'),(199,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 13:47:12'),(200,'张明远','新增','图片管理','上传图片','失败','0:0:0:0:0:0:0:1','2026-04-23 13:48:42'),(201,'张明远','新增','图片管理','上传图片','失败','0:0:0:0:0:0:0:1','2026-04-23 13:49:09'),(202,'张明远','新增','图片管理','上传图片','失败','0:0:0:0:0:0:0:1','2026-04-23 13:49:17'),(203,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 13:52:50'),(204,'张明远','新增','图片管理','批量上传图片','失败','0:0:0:0:0:0:0:1','2026-04-23 13:54:24'),(205,'张明远','新增','图片管理','批量上传图片','失败','0:0:0:0:0:0:0:1','2026-04-23 13:54:26'),(206,'张明远','新增','图片管理','批量上传图片','失败','0:0:0:0:0:0:0:1','2026-04-23 13:54:48'),(207,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 13:57:45'),(208,'张明远','新增','图片管理','上传图片','成功','0:0:0:0:0:0:0:1','2026-04-23 13:58:11'),(209,'张明远','新增','图片管理','上传图片','成功','0:0:0:0:0:0:0:1','2026-04-23 13:59:04'),(210,'张明远','查询','图片管理','下载图片','成功','0:0:0:0:0:0:0:1','2026-04-23 13:59:06'),(211,'张明远','查询','图片管理','下载图片','成功','0:0:0:0:0:0:0:1','2026-04-23 13:59:21'),(212,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:07:47'),(213,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 14:15:28'),(214,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 14:15:48'),(215,'张明远','删除','图片管理','删除图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:21:11'),(216,'张明远','删除','图片管理','删除图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:21:13'),(217,'张明远','新增','图片管理','批量上传图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:22:12'),(218,'张明远','删除','文物管理','删除文物','成功','0:0:0:0:0:0:0:1','2026-04-23 14:24:55'),(219,'张明远','删除','文物管理','删除文物','成功','0:0:0:0:0:0:0:1','2026-04-23 14:25:16'),(220,'张明远','删除','文物管理','删除文物','成功','0:0:0:0:0:0:0:1','2026-04-23 14:25:44'),(221,'张明远','删除','图片管理','删除图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:25:48'),(222,'张明远','删除','图片管理','删除图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:25:54'),(223,'张明远','删除','图片管理','删除图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:25:55'),(224,'张明远','删除','图片管理','删除图片','成功','0:0:0:0:0:0:0:1','2026-04-23 14:25:57'),(225,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:39:04'),(226,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:39:28'),(227,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:39:42'),(228,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:39:57'),(229,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:40:13'),(230,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:40:28'),(231,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:40:45'),(232,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:40:57'),(233,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:41:12'),(234,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:41:26'),(235,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:41:39'),(236,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:41:51'),(237,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:42:05'),(238,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:42:20'),(239,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:42:37'),(240,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:42:54'),(241,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:43:07'),(242,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:43:20'),(243,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:57:47'),(244,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:57:51'),(245,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:57:54'),(246,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:57:57'),(247,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 14:58:01'),(248,'张明远','新增','图片管理','批量上传图片','成功','0:0:0:0:0:0:0:1','2026-04-23 15:15:34'),(249,'张明远','新增','图片管理','批量上传图片','成功','0:0:0:0:0:0:0:1','2026-04-23 15:19:03'),(250,'lwy','查询','AI查询','AI智能查询文物','成功','0:0:0:0:0:0:0:1','2026-04-23 15:36:34'),(251,'lwy','查询','AI查询','AI智能查询文物','成功','0:0:0:0:0:0:0:1','2026-04-23 15:45:30'),(252,'lwy','查询','AI查询','AI智能查询文物','成功','0:0:0:0:0:0:0:1','2026-04-23 15:46:49'),(253,'张明远','新增','文物管理','新增文物','成功','0:0:0:0:0:0:0:1','2026-04-23 15:50:55'),(254,'张明远','新增','文物管理','新增文物（含图片）','成功','0:0:0:0:0:0:0:1','2026-04-23 15:58:31'),(255,'张明远','新增','文物管理','新增文物（含图片）','成功','0:0:0:0:0:0:0:1','2026-04-23 15:59:25'),(256,'张明远','新增','文物管理','新增文物（含图片）','成功','0:0:0:0:0:0:0:1','2026-04-23 16:04:36'),(257,'张明远','新增','文物管理','新增文物（含图片）','成功','0:0:0:0:0:0:0:1','2026-04-23 16:05:20'),(258,'张明远','新增','文物管理','新增文物（含图片）','成功','0:0:0:0:0:0:0:1','2026-04-23 16:16:55'),(259,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:25:03'),(260,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:25:34'),(261,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:25:42'),(262,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:25:48'),(263,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:25:53'),(264,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:26:06'),(265,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:26:14'),(266,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:26:51'),(267,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:05'),(268,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:13'),(269,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:22'),(270,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:31'),(271,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:36'),(272,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:40'),(273,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:46'),(274,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:52'),(275,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:27:59'),(276,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:05'),(277,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:11'),(278,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:17'),(279,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:24'),(280,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:28'),(281,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:36'),(282,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:42'),(283,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:48'),(284,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:53'),(285,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:28:58'),(286,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:03'),(287,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:12'),(288,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:17'),(289,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:21'),(290,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:26'),(291,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:31'),(292,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:36'),(293,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:41'),(294,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:45'),(295,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:51'),(296,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:29:56'),(297,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:05'),(298,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:09'),(299,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:13'),(300,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:16'),(301,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:22'),(302,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:27'),(303,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:31'),(304,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:36'),(305,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:40'),(306,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:44'),(307,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:51'),(308,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:30:57'),(309,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:03'),(310,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:15'),(311,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:19'),(312,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:31'),(313,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:40'),(314,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:43'),(315,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:46'),(316,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:31:56'),(317,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:03'),(318,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:09'),(319,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:18'),(320,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:23'),(321,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:28'),(322,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:34'),(323,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:38'),(324,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:42'),(325,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:46'),(326,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:53'),(327,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:32:56'),(328,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:01'),(329,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:05'),(330,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:10'),(331,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:14'),(332,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:18'),(333,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:25'),(334,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:29'),(335,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:33'),(336,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:51'),(337,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:33:56'),(338,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:00'),(339,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:05'),(340,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:09'),(341,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:13'),(342,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:20'),(343,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:24'),(344,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:31'),(345,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:48'),(346,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:34:58'),(347,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:35:04'),(348,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:35:09'),(349,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:35:15'),(350,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:35:21'),(351,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:35:26'),(352,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 16:35:34'),(353,'田昊鑫','注册','系统认证','借展人注册：tian','成功','0:0:0:0:0:0:0:1','2026-04-23 16:49:32'),(354,'田昊鑫','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 16:49:56'),(355,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:01:36'),(356,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:01:45'),(357,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:02:03'),(358,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:03:03'),(359,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:03:09'),(360,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:03:19'),(361,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:03:42'),(362,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:03:50'),(363,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:03:59'),(364,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:04:04'),(365,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:04:16'),(366,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:04:25'),(367,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:04:33'),(368,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:04:44'),(369,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:04:49'),(370,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:00'),(371,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:07'),(372,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:18'),(373,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:24'),(374,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:35'),(375,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:41'),(376,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:46'),(377,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:05:56'),(378,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:01'),(379,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:13'),(380,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:21'),(381,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:28'),(382,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:35'),(383,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:43'),(384,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:06:53'),(385,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:06'),(386,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:11'),(387,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:24'),(388,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:29'),(389,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:38'),(390,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:48'),(391,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:07:53'),(392,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:00'),(393,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:05'),(394,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:09'),(395,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:27'),(396,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:34'),(397,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:42'),(398,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:47'),(399,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:52'),(400,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:08:57'),(401,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:04'),(402,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:12'),(403,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:22'),(404,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:32'),(405,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:40'),(406,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:45'),(407,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:48'),(408,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:09:56'),(409,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:04'),(410,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:09'),(411,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:15'),(412,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:20'),(413,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:27'),(414,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:34'),(415,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:39'),(416,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:45'),(417,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:10:55'),(418,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:04'),(419,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:10'),(420,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:16'),(421,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:20'),(422,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:25'),(423,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:29'),(424,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:34'),(425,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:38'),(426,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:47'),(427,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:11:57'),(428,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:01'),(429,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:06'),(430,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:14'),(431,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:19'),(432,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:29'),(433,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:37'),(434,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:44'),(435,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:50'),(436,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:54'),(437,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:12:59'),(438,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:03'),(439,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:06'),(440,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:12'),(441,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:25'),(442,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:29'),(443,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:34'),(444,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:39'),(445,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:42'),(446,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:48'),(447,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:52'),(448,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:13:58'),(449,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:03'),(450,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:09'),(451,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:25'),(452,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:30'),(453,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:35'),(454,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:40'),(455,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:44'),(456,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:53'),(457,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:14:59'),(458,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 17:15:04'),(459,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 17:35:48'),(460,'wang','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:35:55'),(461,'wang','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:37:06'),(462,'wang','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:37:07'),(463,'wang','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:37:08'),(464,'wang','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:37:09'),(465,'王建国','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 17:37:14'),(466,'王建国','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 17:46:02'),(467,'王','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:46:14'),(468,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:50:43'),(469,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:50:47'),(470,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:50:50'),(471,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:50:54'),(472,'田昊鑫','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 17:50:58'),(473,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:55:28'),(474,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:55:34'),(475,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:55:37'),(476,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:55:41'),(477,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:55:45'),(478,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:56:29'),(479,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 17:56:35'),(480,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:01:19'),(481,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:01:24'),(482,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:01:29'),(483,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:01:32'),(484,'田昊鑫','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 18:05:06'),(485,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:21:29'),(486,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:21:30'),(487,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:21:31'),(488,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:21:33'),(489,'tian','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:21:34'),(490,'shen','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:22:00'),(491,'shen','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:22:01'),(492,'shen','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:22:02'),(493,'shen','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:22:03'),(494,'shen','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:22:04'),(495,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 18:24:48'),(496,'zhao','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:27:54'),(497,'zhao','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:28:07'),(498,'zhao','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 18:28:07'),(499,'admin','忘记密码','系统认证','发送验证码：EMAIL','成功','0:0:0:0:0:0:0:1','2026-04-23 20:02:10'),(500,'admin','忘记密码','系统认证','发送验证码：EMAIL','成功','0:0:0:0:0:0:0:1','2026-04-23 20:25:06'),(501,'admin','重置密码','系统认证','密码重置成功','成功','0:0:0:0:0:0:0:1','2026-04-23 20:25:44'),(502,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 20:26:13'),(503,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:28:39'),(504,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:28:53'),(505,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:29:10'),(506,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:30:18'),(507,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:30:33'),(508,'张明远','修改','借展管理','归还文物','成功','0:0:0:0:0:0:0:1','2026-04-23 20:30:45'),(509,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:30:56'),(510,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:31:12'),(511,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:31:57'),(512,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:32:10'),(513,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:32:24'),(514,'张明远','修改','文物管理','修改文物信息','成功','0:0:0:0:0:0:0:1','2026-04-23 20:33:27'),(515,'张明远','新增','文物修复','提交修复申请','失败','0:0:0:0:0:0:0:1','2026-04-23 20:50:45'),(516,'张明远','新增','文物修复','提交修复申请','失败','0:0:0:0:0:0:0:1','2026-04-23 20:50:46'),(517,'张明远','新增','文物修复','提交修复申请','失败','0:0:0:0:0:0:0:1','2026-04-23 20:50:48'),(518,'张明远','新增','文物修复','提交修复申请','失败','0:0:0:0:0:0:0:1','2026-04-23 20:50:58'),(519,'张明远','新增','文物修复','提交修复申请','成功','0:0:0:0:0:0:0:1','2026-04-23 20:52:40'),(520,'张明远','修改','文物修复','审批修复申请','成功','0:0:0:0:0:0:0:1','2026-04-23 20:53:11'),(521,'张明远','修改','文物修复','开始修复','成功','0:0:0:0:0:0:0:1','2026-04-23 20:54:56'),(522,'张明远','新增','文物修复','提交修复申请','成功','0:0:0:0:0:0:0:1','2026-04-23 20:56:03'),(523,'张明远','修改','文物修复','审批修复申请','成功','0:0:0:0:0:0:0:1','2026-04-23 20:56:11'),(524,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 20:57:18'),(525,'田昊鑫','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 20:57:29'),(526,'admin','登录','系统认证','用户登录','失败','0:0:0:0:0:0:0:1','2026-04-23 20:57:48'),(527,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 20:57:56'),(528,'张明远','修改','文物修复','开始修复','成功','0:0:0:0:0:0:0:1','2026-04-23 20:58:00'),(529,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:08:26'),(530,'lll','忘记密码','系统认证','发送验证码：EMAIL','成功','0:0:0:0:0:0:0:1','2026-04-23 21:09:10'),(531,'lll','重置密码','系统认证','密码重置成功','成功','0:0:0:0:0:0:0:1','2026-04-23 21:09:28'),(532,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:09:42'),(533,'lll','忘记密码','系统认证','发送验证码：EMAIL','成功','0:0:0:0:0:0:0:1','2026-04-23 21:14:48'),(534,'lll','重置密码','系统认证','密码重置成功','成功','0:0:0:0:0:0:0:1','2026-04-23 21:15:06'),(535,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:15:16'),(536,'admin','忘记密码','系统认证','发送验证码：EMAIL','成功','0:0:0:0:0:0:0:1','2026-04-23 21:15:49'),(537,'admin','重置密码','系统认证','密码重置成功','成功','0:0:0:0:0:0:0:1','2026-04-23 21:16:21'),(538,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:16:29'),(539,'张明远','查询','文物管理','生成文物二维码','成功','0:0:0:0:0:0:0:1','2026-04-23 21:51:53'),(540,'张明远','登出','系统认证','退出登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:54:04'),(541,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:54:51'),(542,'lwy','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 21:57:04'),(543,'未知用户','查询','文物管理','生成文物二维码','成功','0:0:0:0:0:0:0:1','2026-04-23 22:25:17'),(544,'未知用户','查询','文物管理','生成文物二维码','成功','0:0:0:0:0:0:0:1','2026-04-23 22:31:16'),(545,'未知用户','查询','文物管理','生成文物二维码','成功','0:0:0:0:0:0:0:1','2026-04-23 22:31:18'),(546,'张明远','登录','系统认证','用户登录','成功','0:0:0:0:0:0:0:1','2026-04-23 23:11:59');
/*!40000 ALTER TABLE `sys_operation_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_permission`
--

DROP TABLE IF EXISTS `sys_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `permission_name` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `permission_code` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `permission_type` varchar(20) COLLATE utf8mb4_general_ci DEFAULT 'MENU',
  `path` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `component` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `permission_code` (`permission_code`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_permission`
--

LOCK TABLES `sys_permission` WRITE;
/*!40000 ALTER TABLE `sys_permission` DISABLE KEYS */;
INSERT INTO `sys_permission` VALUES (1,'看板查看','dashboard:view','MENU','/dashboard','DashboardView','2026-04-02 18:00:33','2026-04-02 18:00:33'),(2,'文物管理','relics:manage','MENU','/relics','RelicsView','2026-04-02 18:00:33','2026-04-02 18:00:33'),(3,'分类管理','categories:manage','MENU','/categories','CategoriesView','2026-04-02 18:00:33','2026-04-02 18:00:33'),(4,'借展管理','loans:manage','MENU','/loans','LoansView','2026-04-02 18:00:33','2026-04-02 18:00:33'),(5,'维护管理','maintenance:manage','MENU','/maintenance','MaintenanceView','2026-04-02 18:00:33','2026-04-02 18:00:33'),(6,'统计概览','statistics:overview','API','/statistics/overview',NULL,'2026-04-02 18:00:33','2026-04-02 18:00:33'),(7,'文物统计','statistics:relics','API','/statistics/relics',NULL,'2026-04-02 18:00:33','2026-04-02 18:00:33'),(8,'借展统计','statistics:loans','API','/statistics/loans',NULL,'2026-04-02 18:00:33','2026-04-02 18:00:33'),(9,'维护统计','statistics:maintenance','API','/statistics/maintenance',NULL,'2026-04-02 18:00:33','2026-04-02 18:00:33'),(10,'借展审批','loans:approve','API','/loans/approve',NULL,'2026-04-02 18:00:33','2026-04-02 18:00:33'),(11,'用户管理','users:manage','MENU','/users','UsersView','2026-04-02 18:00:33','2026-04-02 18:00:33'),(12,'日志查看','logs:view','MENU','/logs','LogsView','2026-04-02 18:00:33','2026-04-02 18:00:33');
/*!40000 ALTER TABLE `sys_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role`
--

DROP TABLE IF EXISTS `sys_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_name` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `role_code` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `role_code` (`role_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role`
--

LOCK TABLES `sys_role` WRITE;
/*!40000 ALTER TABLE `sys_role` DISABLE KEYS */;
INSERT INTO `sys_role` VALUES (1,'系统管理员','ADMIN','系统最高权限管理员',1,'2026-04-01 22:58:33','2026-04-01 22:58:33'),(2,'文物保管员','CURATOR','负责文物信息和维护记录管理',1,'2026-04-01 22:58:33','2026-04-01 22:58:33'),(3,'借展审批员','APPROVER','负责借展申请审批',1,'2026-04-01 22:58:33','2026-04-01 22:58:33'),(4,'文物借展人','LOANER','负责申请借展文物',1,'2026-04-16 16:00:08','2026-04-16 16:00:09');
/*!40000 ALTER TABLE `sys_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_role_permission`
--

DROP TABLE IF EXISTS `sys_role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_role_permission` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_permission` (`role_id`,`permission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_role_permission`
--

LOCK TABLES `sys_role_permission` WRITE;
/*!40000 ALTER TABLE `sys_role_permission` DISABLE KEYS */;
INSERT INTO `sys_role_permission` VALUES (1,1,1,'2026-04-02 18:00:34'),(2,1,2,'2026-04-02 18:00:34'),(3,1,3,'2026-04-02 18:00:34'),(4,1,4,'2026-04-02 18:00:34'),(5,1,5,'2026-04-02 18:00:34'),(6,1,6,'2026-04-02 18:00:34'),(7,1,7,'2026-04-02 18:00:34'),(8,1,8,'2026-04-02 18:00:34'),(9,1,9,'2026-04-02 18:00:34'),(10,1,10,'2026-04-02 18:00:34'),(11,1,11,'2026-04-02 18:00:34'),(12,1,12,'2026-04-02 18:00:34'),(13,2,1,'2026-04-02 18:00:34'),(14,2,2,'2026-04-02 18:00:34'),(15,2,3,'2026-04-02 18:00:34'),(16,2,5,'2026-04-02 18:00:34'),(17,3,1,'2026-04-02 18:00:34'),(18,3,4,'2026-04-02 18:00:34'),(19,3,10,'2026-04-02 18:00:34'),(20,5,12,'2026-04-02 18:00:34');
/*!40000 ALTER TABLE `sys_role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user`
--

DROP TABLE IF EXISTS `sys_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `real_name` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` tinyint DEFAULT '1',
  `role_id` bigint DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `login_failed_count` int DEFAULT '0' COMMENT '登录失败次数',
  `account_locked` tinyint(1) DEFAULT '0' COMMENT '账户是否锁定：0-未锁定，1-已锁定',
  `locked_time` datetime DEFAULT NULL COMMENT '账户锁定时间',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  `last_login_ip` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT '最后登录IP',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_username` (`username`),
  KEY `idx_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user`
--

LOCK TABLES `sys_user` WRITE;
/*!40000 ALTER TABLE `sys_user` DISABLE KEYS */;
INSERT INTO `sys_user` VALUES (1,'admin','$2a$10$cnGSWFJQCF6b/alG2mf1mung9vS1o9jEXNqy0MwQk3PYTfBYt9C6C','张明远','3071624946@qq.com','15874225616',1,1,'2026-04-01 22:58:33','2026-04-23 23:11:58',0,0,NULL,'2026-04-23 23:11:59','0:0:0:0:0:0:0:1'),(2,'li','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','李婉清','c01@test.com','13800000002',1,2,'2026-04-02 18:00:33','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(3,'wang','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','王建国','c02@test.com','13800000003',1,2,'2026-04-02 18:00:33','2026-04-23 17:37:14',0,0,NULL,NULL,NULL),(4,'chen','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','陈淑华','a01@test.com','13800000004',1,3,'2026-04-02 18:00:33','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(5,'liu','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','刘志强','a02@test.com','13800000005',1,3,'2026-04-02 18:00:33','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(8,'lin','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','林小夏','s01@test.com','13800000008',1,4,'2026-04-02 18:00:33','2026-04-19 21:57:10',0,0,NULL,NULL,NULL),(9,'zhou','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','周子轩','s02@test.com','13800000009',1,2,'2026-04-02 18:00:33','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(10,'zhao','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','赵雨桐','s03@test.com','13800000010',1,3,'2026-04-02 18:00:33','2026-04-23 18:28:07',3,1,'2026-04-23 18:28:07',NULL,'0:0:0:0:0:0:0:1'),(11,'xu','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','徐天宇','s04@test.com','13800000011',2,2,'2026-04-02 18:00:33','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(12,'ye','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','叶知秋','s05@test.com','13800000012',0,3,'2026-04-02 18:00:33','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(13,'gu','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','顾云舟','96451@qq.com','12345678910',1,4,'2026-04-07 22:08:17','2026-04-17 13:59:20',0,0,NULL,NULL,NULL),(14,'shen','$2a$10$/RQLY9NI5iVpbJ2kN09ksuB8g2xkj5cfpwD6ycd41covJOYwegwMC','沈听澜','ydtfg@qq.com','12345678910',1,2,'2026-04-14 20:39:57','2026-04-23 18:22:02',3,1,'2026-04-23 18:22:02',NULL,'unknown'),(16,'lll','$2a$10$bcyoNgD.5l5Vf9GCy1odO.bTK1GJWg0YtFgl/SzGUpdCQnLt.TybK','lwy','lwy1472583692024@163.com','19986310535',1,4,'2026-04-23 11:56:58','2026-04-23 21:57:04',0,0,NULL,'2026-04-23 21:57:04','0:0:0:0:0:0:0:1'),(17,'tian','$2a$10$qCWMKbAXDglIbuLZhrHoROvOzT2OL.IB2S0NcvfyxChAU4Jfgg9lW','田昊鑫','8452@qq.com','18423047950',1,4,'2026-04-23 16:49:32','2026-04-23 20:57:29',0,0,'2026-04-23 18:21:31','2026-04-23 20:57:29','0:0:0:0:0:0:0:1');
/*!40000 ALTER TABLE `sys_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_user_role`
--

DROP TABLE IF EXISTS `sys_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sys_user_role` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `role_id` bigint NOT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_role` (`user_id`,`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_user_role`
--

LOCK TABLES `sys_user_role` WRITE;
/*!40000 ALTER TABLE `sys_user_role` DISABLE KEYS */;
INSERT INTO `sys_user_role` VALUES (1,1,1,'2026-04-02 18:00:33'),(2,2,2,'2026-04-02 18:00:33'),(3,3,2,'2026-04-02 18:00:33'),(4,4,3,'2026-04-02 18:00:33'),(5,5,3,'2026-04-02 18:00:33'),(8,8,2,'2026-04-02 18:00:33'),(9,9,2,'2026-04-02 18:00:33'),(10,10,3,'2026-04-02 18:00:33'),(11,13,4,'2026-04-16 16:00:51');
/*!40000 ALTER TABLE `sys_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_museum`
--

DROP TABLE IF EXISTS `user_museum`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_museum` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '关联ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `museum_id` bigint NOT NULL COMMENT '博物馆ID',
  `is_primary` tinyint DEFAULT '1' COMMENT '是否主要博物馆：1是 0否',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_museum` (`user_id`,`museum_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_museum_id` (`museum_id`),
  CONSTRAINT `user_museum_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_museum_ibfk_2` FOREIGN KEY (`museum_id`) REFERENCES `museum` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='用户博物馆关联表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_museum`
--

LOCK TABLES `user_museum` WRITE;
/*!40000 ALTER TABLE `user_museum` DISABLE KEYS */;
INSERT INTO `user_museum` VALUES (1,8,1,1,'2026-04-23 11:26:24','2026-04-23 11:26:25'),(2,13,2,1,'2026-04-23 11:26:37','2026-04-23 11:26:39'),(3,16,9,1,'2026-04-23 11:56:57','2026-04-23 11:56:57'),(4,17,7,1,'2026-04-23 16:49:31','2026-04-23 16:49:31');
/*!40000 ALTER TABLE `user_museum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_image_category_stats`
--

DROP TABLE IF EXISTS `v_image_category_stats`;
/*!50001 DROP VIEW IF EXISTS `v_image_category_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_image_category_stats` AS SELECT 
 1 AS `category`,
 1 AS `image_count`,
 1 AS `total_size`,
 1 AS `avg_views`,
 1 AS `total_downloads`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_recent_images`
--

DROP TABLE IF EXISTS `v_recent_images`;
/*!50001 DROP VIEW IF EXISTS `v_recent_images`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_recent_images` AS SELECT 
 1 AS `id`,
 1 AS `image_name`,
 1 AS `file_path`,
 1 AS `file_size`,
 1 AS `category`,
 1 AS `uploader_name`,
 1 AS `view_count`,
 1 AS `create_time`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `verification_code`
--

DROP TABLE IF EXISTS `verification_code`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `verification_code` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `username` varchar(50) NOT NULL COMMENT '用户名',
  `code` varchar(10) NOT NULL COMMENT '验证码',
  `type` varchar(20) NOT NULL COMMENT '验证码类型：EMAIL-邮箱，PHONE-手机',
  `contact` varchar(100) NOT NULL COMMENT '联系方式（邮箱或手机号）',
  `purpose` varchar(50) NOT NULL COMMENT '用途：RESET_PASSWORD-重置密码',
  `used` tinyint(1) DEFAULT '0' COMMENT '是否已使用：0-未使用，1-已使用',
  `expire_time` datetime NOT NULL COMMENT '过期时间',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_username` (`username`),
  KEY `idx_code` (`code`),
  KEY `idx_expire_time` (`expire_time`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='验证码表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verification_code`
--

LOCK TABLES `verification_code` WRITE;
/*!40000 ALTER TABLE `verification_code` DISABLE KEYS */;
INSERT INTO `verification_code` VALUES (5,16,'lll','668473','EMAIL','lwy1472583692024@163.com','RESET_PASSWORD',1,'2026-04-23 21:29:48','2026-04-23 21:14:48'),(6,1,'admin','529543','EMAIL','3071624946@qq.com','RESET_PASSWORD',1,'2026-04-23 21:30:48','2026-04-23 21:15:48');
/*!40000 ALTER TABLE `verification_code` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Final view structure for view `v_image_category_stats`
--

/*!50001 DROP VIEW IF EXISTS `v_image_category_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_image_category_stats` AS select `image_library`.`category` AS `category`,count(0) AS `image_count`,sum(`image_library`.`file_size`) AS `total_size`,avg(`image_library`.`view_count`) AS `avg_views`,sum(`image_library`.`download_count`) AS `total_downloads` from `image_library` where (`image_library`.`status` = 1) group by `image_library`.`category` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_recent_images`
--

/*!50001 DROP VIEW IF EXISTS `v_recent_images`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_recent_images` AS select `image_library`.`id` AS `id`,`image_library`.`image_name` AS `image_name`,`image_library`.`file_path` AS `file_path`,`image_library`.`file_size` AS `file_size`,`image_library`.`category` AS `category`,`image_library`.`uploader_name` AS `uploader_name`,`image_library`.`view_count` AS `view_count`,`image_library`.`create_time` AS `create_time` from `image_library` where (`image_library`.`status` = 1) order by `image_library`.`create_time` desc limit 20 */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-23 23:19:47
