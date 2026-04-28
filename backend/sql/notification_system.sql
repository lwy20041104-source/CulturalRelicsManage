-- 消息通知系统数据库表

-- 1. 系统通知表
CREATE TABLE IF NOT EXISTS `system_notification` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '通知ID',
    `title` VARCHAR(200) NOT NULL COMMENT '通知标题',
    `content` TEXT NOT NULL COMMENT '通知内容',
    `type` VARCHAR(50) NOT NULL COMMENT '通知类型：LOAN_APPLY(借展申请)、LOAN_OVERDUE(借展逾期)、REPAIR_APPLY(修复申请)、LOAN_APPROVED(借展审批通过)、LOAN_REJECTED(借展审批拒绝)、REPAIR_APPROVED(修复审批通过)、REPAIR_REJECTED(修复审批拒绝)',
    `priority` VARCHAR(20) NOT NULL DEFAULT 'NORMAL' COMMENT '优先级：LOW(低)、NORMAL(普通)、HIGH(高)、URGENT(紧急)',
    `related_type` VARCHAR(50) COMMENT '关联类型：LOAN(借展)、REPAIR(修复)',
    `related_id` BIGINT COMMENT '关联ID（借展记录ID或修复记录ID）',
    `sender_id` BIGINT COMMENT '发送人ID',
    `sender_name` VARCHAR(100) COMMENT '发送人姓名',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    INDEX `idx_type` (`type`),
    INDEX `idx_related` (`related_type`, `related_id`),
    INDEX `idx_create_time` (`create_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统通知表';

-- 2. 用户通知关联表（多对多）
CREATE TABLE IF NOT EXISTS `user_notification` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `notification_id` BIGINT NOT NULL COMMENT '通知ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `is_read` TINYINT NOT NULL DEFAULT 0 COMMENT '是否已读：0-未读，1-已读',
    `read_time` DATETIME COMMENT '阅读时间',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_notification_user` (`notification_id`, `user_id`),
    INDEX `idx_user_id` (`user_id`),
    INDEX `idx_is_read` (`is_read`),
    FOREIGN KEY (`notification_id`) REFERENCES `system_notification`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`user_id`) REFERENCES `sys_user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户通知关联表';

-- 3. 通知配置表（用户可以配置接收哪些类型的通知）
CREATE TABLE IF NOT EXISTS `notification_config` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'ID',
    `user_id` BIGINT NOT NULL COMMENT '用户ID',
    `notification_type` VARCHAR(50) NOT NULL COMMENT '通知类型',
    `enabled` TINYINT NOT NULL DEFAULT 1 COMMENT '是否启用：0-禁用，1-启用',
    `create_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `update_time` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_user_type` (`user_id`, `notification_type`),
    FOREIGN KEY (`user_id`) REFERENCES `sys_user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知配置表';

-- 插入示例数据（可选）
-- 为系统管理员创建默认通知配置
INSERT INTO `notification_config` (`user_id`, `notification_type`, `enabled`)
SELECT u.id, 'LOAN_APPLY', 1
FROM `sys_user` u
INNER JOIN `sys_role` r ON u.role_id = r.id
WHERE r.role_code = 'ADMIN'
ON DUPLICATE KEY UPDATE enabled = enabled;

INSERT INTO `notification_config` (`user_id`, `notification_type`, `enabled`)
SELECT u.id, 'LOAN_OVERDUE', 1
FROM `sys_user` u
INNER JOIN `sys_role` r ON u.role_id = r.id
WHERE r.role_code = 'ADMIN'
ON DUPLICATE KEY UPDATE enabled = enabled;

INSERT INTO `notification_config` (`user_id`, `notification_type`, `enabled`)
SELECT u.id, 'REPAIR_APPLY', 1
FROM `sys_user` u
INNER JOIN `sys_role` r ON u.role_id = r.id
WHERE r.role_code = 'ADMIN'
ON DUPLICATE KEY UPDATE enabled = enabled;

-- 为借展审批员创建默认通知配置
INSERT INTO `notification_config` (`user_id`, `notification_type`, `enabled`)
SELECT u.id, 'LOAN_APPLY', 1
FROM `sys_user` u
INNER JOIN `sys_role` r ON u.role_id = r.id
WHERE r.role_code = 'APPROVER'
ON DUPLICATE KEY UPDATE enabled = enabled;

-- 为文物保管员创建默认通知配置
INSERT INTO `notification_config` (`user_id`, `notification_type`, `enabled`)
SELECT u.id, 'LOAN_OVERDUE', 1
FROM `sys_user` u
INNER JOIN `sys_role` r ON u.role_id = r.id
WHERE r.role_code = 'CURATOR'
ON DUPLICATE KEY UPDATE enabled = enabled;

INSERT INTO `notification_config` (`user_id`, `notification_type`, `enabled`)
SELECT u.id, 'REPAIR_APPLY', 1
FROM `sys_user` u
INNER JOIN `sys_role` r ON u.role_id = r.id
WHERE r.role_code = 'CURATOR'
ON DUPLICATE KEY UPDATE enabled = enabled;
