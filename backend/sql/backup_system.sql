-- 数据备份系统表
-- 创建日期: 2026-04-27

-- 备份记录表
CREATE TABLE IF NOT EXISTS `sys_backup` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '备份ID',
  `backup_name` VARCHAR(200) NOT NULL COMMENT '备份名称',
  `backup_type` VARCHAR(20) NOT NULL COMMENT '备份类型：manual-手动, auto-自动',
  `backup_status` VARCHAR(20) NOT NULL DEFAULT 'processing' COMMENT '备份状态：processing-处理中, success-成功, failed-失败',
  `file_name` VARCHAR(255) NOT NULL COMMENT '备份文件名',
  `file_path` VARCHAR(500) NOT NULL COMMENT '备份文件路径',
  `file_size` BIGINT DEFAULT 0 COMMENT '文件大小（字节）',
  `is_encrypted` TINYINT(1) DEFAULT 0 COMMENT '是否加密：0-否, 1-是',
  `backup_tables` TEXT COMMENT '备份的表列表（JSON数组）',
  `description` VARCHAR(500) COMMENT '备份描述',
  `error_message` TEXT COMMENT '错误信息',
  `created_by` VARCHAR(50) COMMENT '创建人',
  `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `deleted` TINYINT(1) DEFAULT 0 COMMENT '是否删除：0-否, 1-是',
  PRIMARY KEY (`id`),
  INDEX `idx_backup_type` (`backup_type`),
  INDEX `idx_backup_status` (`backup_status`),
  INDEX `idx_created_time` (`created_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统备份记录表';

-- 备份配置表
CREATE TABLE IF NOT EXISTS `sys_backup_config` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_name` VARCHAR(100) NOT NULL COMMENT '配置名称',
  `is_enabled` TINYINT(1) DEFAULT 1 COMMENT '是否启用：0-否, 1-是',
  `backup_frequency` VARCHAR(20) NOT NULL COMMENT '备份频率：daily-每天, weekly-每周, monthly-每月',
  `backup_time` VARCHAR(10) NOT NULL COMMENT '备份时间（HH:mm）',
  `retention_days` INT DEFAULT 30 COMMENT '保留天数',
  `max_backup_count` INT DEFAULT 10 COMMENT '最大备份数量',
  `is_encrypted` TINYINT(1) DEFAULT 0 COMMENT '是否加密：0-否, 1-是',
  `backup_tables` TEXT COMMENT '备份的表列表（JSON数组，为空则备份全部）',
  `notification_enabled` TINYINT(1) DEFAULT 1 COMMENT '是否启用通知：0-否, 1-是',
  `created_by` VARCHAR(50) COMMENT '创建人',
  `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_by` VARCHAR(50) COMMENT '更新人',
  `updated_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='备份配置表';

-- 恢复记录表
CREATE TABLE IF NOT EXISTS `sys_restore` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '恢复ID',
  `backup_id` BIGINT NOT NULL COMMENT '备份ID',
  `restore_status` VARCHAR(20) NOT NULL DEFAULT 'processing' COMMENT '恢复状态：processing-处理中, success-成功, failed-失败',
  `restore_type` VARCHAR(20) NOT NULL COMMENT '恢复类型：full-完全恢复, partial-部分恢复',
  `restore_tables` TEXT COMMENT '恢复的表列表（JSON数组）',
  `error_message` TEXT COMMENT '错误信息',
  `created_by` VARCHAR(50) COMMENT '操作人',
  `created_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `completed_time` DATETIME COMMENT '完成时间',
  PRIMARY KEY (`id`),
  INDEX `idx_backup_id` (`backup_id`),
  INDEX `idx_restore_status` (`restore_status`),
  FOREIGN KEY (`backup_id`) REFERENCES `sys_backup`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统恢复记录表';

-- 插入默认备份配置
INSERT INTO `sys_backup_config` (
  `config_name`, 
  `is_enabled`, 
  `backup_frequency`, 
  `backup_time`, 
  `retention_days`, 
  `max_backup_count`, 
  `is_encrypted`,
  `notification_enabled`,
  `created_by`
) VALUES (
  '默认自动备份配置',
  1,
  'daily',
  '02:00',
  30,
  10,
  0,
  1,
  'system'
);
