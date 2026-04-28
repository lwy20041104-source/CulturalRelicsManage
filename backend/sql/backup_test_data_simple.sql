-- 备份系统测试数据（简化版）
-- 快速插入测试数据

USE cultural_relics;

-- 1. 备份配置（2条）
INSERT INTO `sys_backup_config` (`config_name`, `is_enabled`, `backup_frequency`, `backup_time`, `retention_days`, `max_backup_count`, `is_encrypted`, `notification_enabled`, `created_by`, `created_time`) VALUES
('默认自动备份配置', 1, 'daily', '02:00', 30, 10, 0, 1, 'admin', '2026-04-20 10:00:00'),
('每周备份配置', 0, 'weekly', '03:00', 90, 20, 1, 1, 'admin', '2026-04-21 14:30:00');

-- 2. 备份记录（8条）
INSERT INTO `sys_backup` (`backup_name`, `backup_type`, `backup_status`, `file_name`, `file_path`, `file_size`, `is_encrypted`, `description`, `error_message`, `created_by`, `created_time`) VALUES
('系统上线前备份', 'manual', 'success', 'backup_20260420_100000.sql', 'backups/backup_20260420_100000.sql', 15728640, 0, '系统正式上线前的完整备份', NULL, 'admin', '2026-04-20 10:00:00'),
('每日自动备份-20260421', 'auto', 'success', 'backup_20260421_020000.sql', 'backups/backup_20260421_020000.sql', 16777216, 0, '系统自动执行的每日备份', NULL, 'system', '2026-04-21 02:00:00'),
('重要数据加密备份', 'manual', 'success', 'backup_20260422_150000.sql', 'backups/backup_20260422_150000.sql', 18874368, 1, '包含敏感数据的加密备份', NULL, 'admin', '2026-04-22 15:00:00'),
('失败的备份任务', 'auto', 'failed', 'backup_20260423_020000.sql', 'backups/backup_20260423_020000.sql', 0, 0, '由于磁盘空间不足导致备份失败', 'mysqldump: Error: No space left on device when writing to file', 'system', '2026-04-23 02:00:00'),
('权限错误的备份', 'manual', 'failed', 'backup_20260424_100000.sql', 'backups/backup_20260424_100000.sql', 0, 0, '测试备份权限', 'mysqldump: Got error: 1044: Access denied for user', 'curator', '2026-04-24 10:00:00'),
('每日自动备份-20260426', 'auto', 'success', 'backup_20260426_020000.sql', 'backups/backup_20260426_020000.sql', 20971520, 0, '系统自动执行的每日备份', NULL, 'system', '2026-04-26 02:00:00'),
('数据迁移前备份', 'manual', 'success', 'backup_20260427_080000.sql', 'backups/backup_20260427_080000.sql', 22020096, 0, '执行数据迁移操作前的安全备份', NULL, 'admin', '2026-04-27 08:00:00'),
('正在执行的备份', 'manual', 'processing', 'backup_20260427_210000.sql', 'backups/backup_20260427_210000.sql', 0, 0, '当前正在执行的备份任务', NULL, 'admin', '2026-04-27 21:00:00');

-- 3. 恢复记录（4条）
INSERT INTO `sys_restore` (`backup_id`, `restore_status`, `restore_type`, `error_message`, `created_by`, `created_time`, `completed_time`) VALUES
(1, 'success', 'full', NULL, 'admin', '2026-04-20 18:00:00', '2026-04-20 18:05:30'),
(3, 'success', 'full', NULL, 'admin', '2026-04-22 16:00:00', '2026-04-22 16:06:15'),
(2, 'failed', 'full', 'mysql: Error: Cannot connect to database server', 'admin', '2026-04-21 10:00:00', NULL),
(5, 'processing', 'full', NULL, 'admin', '2026-04-27 21:05:00', NULL);
