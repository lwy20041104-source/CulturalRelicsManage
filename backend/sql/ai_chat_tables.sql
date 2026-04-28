-- AI对话记录表创建脚本
-- 执行此脚本前请确保已连接到 cultural_relics 数据库

USE cultural_relics;

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

-- AI查询结果详情表
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

-- 查看创建的表
SHOW TABLES LIKE 'ai_%';

-- 查看表结构
DESC ai_chat_session;
DESC ai_chat_message;
DESC ai_query_result;
