-- 备份系统测试数据
-- 创建日期: 2026-04-27
-- 用途: 用于测试备份系统功能

USE cultural_relics;

-- 清空现有测试数据（可选）
-- DELETE FROM sys_restore WHERE id > 0;
-- DELETE FROM sys_backup WHERE id > 0;
-- DELETE FROM sys_backup_config WHERE id > 0;

-- ========================================
-- 1. 插入备份配置数据
-- ========================================

-- 默认备份配置
INSERT INTO `sys_backup_config` (
  `config_name`, 
  `is_enabled`, 
  `backup_frequency`, 
  `backup_time`, 
  `retention_days`, 
  `max_backup_count`, 
  `is_encrypted`, 
  `notification_enabled`, 
  `created_by`, 
  `created_time`
) VALUES (
  '默认自动备份配置',
  1,
  'daily',
  '02:00',
  30,
  10,
  0,
  1,
  'admin',
  '2026-04-20 10:00:00'
);

-- 每周备份配置（未启用）
INSERT INTO `sys_backup_config` (
  `config_name`, 
  `is_enabled`, 
  `backup_frequency`, 
  `backup_time`, 
  `retention_days`, 
  `max_backup_count`, 
  `is_encrypted`, 
  `notification_enabled`, 
  `created_by`, 
  `created_time`
) VALUES (
  '每周备份配置',
  0,
  'weekly',
  '03:00',
  90,
  20,
  1,
  1,
  'admin',
  '2026-04-21 14:30:00'
);

-- ========================================
-- 2. 插入备份记录数据
-- ========================================

-- 成功的手动备份
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `created_by`, 
  `created_time`
) VALUES (
  '系统上线前备份',
  'manual',
  'success',
  'backup_20260420_100000.sql',
  'backups/backup_20260420_100000.sql',
  15728640,  -- 15MB
  0,
  '系统正式上线前的完整备份',
  'admin',
  '2026-04-20 10:00:00'
);

-- 成功的自动备份
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `created_by`, 
  `created_time`
) VALUES (
  '每日自动备份-20260421',
  'auto',
  'success',
  'backup_20260421_020000.sql',
  'backups/backup_20260421_020000.sql',
  16777216,  -- 16MB
  0,
  '系统自动执行的每日备份',
  'system',
  '2026-04-21 02:00:00'
);

-- 成功的加密备份
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `created_by`, 
  `created_time`
) VALUES (
  '重要数据加密备份',
  'manual',
  'success',
  'backup_20260422_150000.sql',
  'backups/backup_20260422_150000.sql',
  18874368,  -- 18MB
  1,
  '包含敏感数据的加密备份',
  'admin',
  '2026-04-22 15:00:00'
);

-- 成功的自动备份（昨天）
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `created_by`, 
  `created_time`
) VALUES (
  '每日自动备份-20260426',
  'auto',
  'success',
  'backup_20260426_020000.sql',
  'backups/backup_20260426_020000.sql',
  20971520,  -- 20MB
  0,
  '系统自动执行的每日备份',
  'system',
  '2026-04-26 02:00:00'
);

-- 成功的手动备份（今天早上）
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `created_by`, 
  `created_time`
) VALUES (
  '数据迁移前备份',
  'manual',
  'success',
  'backup_20260427_080000.sql',
  'backups/backup_20260427_080000.sql',
  22020096,  -- 21MB
  0,
  '执行数据迁移操作前的安全备份',
  'admin',
  '2026-04-27 08:00:00'
);

-- 处理中的备份
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `created_by`, 
  `created_time`
) VALUES (
  '正在执行的备份',
  'manual',
  'processing',
  'backup_20260427_210000.sql',
  'backups/backup_20260427_210000.sql',
  0,
  0,
  '当前正在执行的备份任务',
  'admin',
  '2026-04-27 21:00:00'
);

-- 失败的备份
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `error_message`,
  `created_by`, 
  `created_time`
) VALUES (
  '失败的备份任务',
  'auto',
  'failed',
  'backup_20260423_020000.sql',
  'backups/backup_20260423_020000.sql',
  0,
  0,
  '由于磁盘空间不足导致备份失败',
  'mysqldump: Error: No space left on device when writing to file',
  'system',
  '2026-04-23 02:00:00'
);

-- 另一个失败的备份
INSERT INTO `sys_backup` (
  `backup_name`, 
  `backup_type`, 
  `backup_status`, 
  `file_name`, 
  `file_path`, 
  `file_size`, 
  `is_encrypted`, 
  `description`, 
  `error_message`,
  `created_by`, 
  `created_time`
) VALUES (
  '权限错误的备份',
  'manual',
  'failed',
  'backup_20260424_100000.sql',
  'backups/backup_20260424_100000.sql',
  0,
  0,
  '测试备份权限',
  'mysqldump: Got error: 1044: Access denied for user',
  'curator',
  '2026-04-24 10:00:00'
);

-- ========================================
-- 3. 插入恢复记录数据
-- ========================================

-- 成功的恢复记录
INSERT INTO `sys_restore` (
  `backup_id`, 
  `restore_status`, 
  `restore_type`, 
  `created_by`, 
  `created_time`, 
  `completed_time`
) VALUES (
  1,  -- 对应"系统上线前备份"
  'success',
  'full',
  'admin',
  '2026-04-20 18:00:00',
  '2026-04-20 18:05:30'
);

-- 成功的恢复记录（从加密备份恢复）
INSERT INTO `sys_restore` (
  `backup_id`, 
  `restore_status`, 
  `restore_type`, 
  `created_by`, 
  `created_time`, 
  `completed_time`
) VALUES (
  3,  -- 对应"重要数据加密备份"
  'success',
  'full',
  'admin',
  '2026-04-22 16:00:00',
  '2026-04-22 16:06:15'
);

-- 处理中的恢复
INSERT INTO `sys_restore` (
  `backup_id`, 
  `restore_status`, 
  `restore_type`, 
  `created_by`, 
  `created_time`
) VALUES (
  5,  -- 对应"数据迁移前备份"
  'processing',
  'full',
  'admin',
  '2026-04-27 21:05:00'
);

-- 失败的恢复记录
INSERT INTO `sys_restore` (
  `backup_id`, 
  `restore_status`, 
  `restore_type`, 
  `error_message`,
  `created_by`, 
  `created_time`
) VALUES (
  2,  -- 对应"每日自动备份-20260421"
  'failed',
  'full',
  'mysql: Error: Cannot connect to database server',
  'admin',
  '2026-04-21 10:00:00'
);

-- ========================================
-- 验证插入的数据
-- ========================================

-- 查看备份配置
SELECT '=== 备份配置 ===' AS '';
SELECT 
  id,
  config_name,
  is_enabled,
  backup_frequency,
  backup_time,
  retention_days,
  max_backup_count,
  is_encrypted
FROM sys_backup_config;

-- 查看备份记录
SELECT '=== 备份记录 ===' AS '';
SELECT 
  id,
  backup_name,
  backup_type,
  backup_status,
  file_name,
  ROUND(file_size / 1024 / 1024, 2) AS 'file_size_mb',
  is_encrypted,
  created_by,
  created_time
FROM sys_backup
ORDER BY created_time DESC;

-- 查看恢复记录
SELECT '=== 恢复记录 ===' AS '';
SELECT 
  r.id,
  b.backup_name,
  r.restore_status,
  r.restore_type,
  r.created_by,
  r.created_time,
  r.completed_time
FROM sys_restore r
LEFT JOIN sys_backup b ON r.backup_id = b.id
ORDER BY r.created_time DESC;

-- 统计信息
SELECT '=== 统计信息 ===' AS '';
SELECT 
  '备份总数' AS item,
  COUNT(*) AS count
FROM sys_backup
UNION ALL
SELECT 
  '成功备份',
  COUNT(*)
FROM sys_backup
WHERE backup_status = 'success'
UNION ALL
SELECT 
  '失败备份',
  COUNT(*)
FROM sys_backup
WHERE backup_status = 'failed'
UNION ALL
SELECT 
  '处理中备份',
  COUNT(*)
FROM sys_backup
WHERE backup_status = 'processing'
UNION ALL
SELECT 
  '恢复总数',
  COUNT(*)
FROM sys_restore
UNION ALL
SELECT 
  '成功恢复',
  COUNT(*)
FROM sys_restore
WHERE restore_status = 'success';

-- 备份文件总大小
SELECT 
  '备份文件总大小(MB)' AS item,
  ROUND(SUM(file_size) / 1024 / 1024, 2) AS value
FROM sys_backup
WHERE backup_status = 'success';
