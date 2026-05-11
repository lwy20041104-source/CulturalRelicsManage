-- 升级 ai_chat_message 表的 content 字段为 LONGTEXT
-- 用于存储完整的 AI 响应 JSON（包含多个文物信息）

USE cultural_relics;

-- 修改 content 字段类型为 LONGTEXT
ALTER TABLE `ai_chat_message` 
MODIFY COLUMN `content` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息内容（完整的JSON响应）';

-- 验证修改
SHOW FULL COLUMNS FROM `ai_chat_message` WHERE Field = 'content';
