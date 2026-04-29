-- 维护记录表字段迁移：maintainer 改为 maintainer_id
-- 执行日期：2026-04-29

-- 1. 添加新字段 maintainer_id
ALTER TABLE maintenance_record 
ADD COLUMN maintainer_id BIGINT COMMENT '维护人员ID（关联sys_user表）' AFTER maintainer;

-- 2. 添加外键约束（可选，根据需要）
-- ALTER TABLE maintenance_record 
-- ADD CONSTRAINT fk_maintenance_maintainer 
-- FOREIGN KEY (maintainer_id) REFERENCES sys_user(id);

-- 3. 迁移数据：根据 maintainer 姓名查找对应的用户ID
UPDATE maintenance_record mr
LEFT JOIN sys_user su ON mr.maintainer = su.real_name
SET mr.maintainer_id = su.id
WHERE mr.maintainer IS NOT NULL AND su.id IS NOT NULL;

-- 4. 检查迁移结果
SELECT 
    COUNT(*) as total_records,
    COUNT(maintainer_id) as migrated_records,
    COUNT(*) - COUNT(maintainer_id) as unmigrated_records
FROM maintenance_record;

-- 5. 查看未迁移的记录（如果有）
SELECT id, maintainer, maintainer_id
FROM maintenance_record
WHERE maintainer IS NOT NULL AND maintainer_id IS NULL;

-- 6. 删除旧字段（确认数据迁移无误后再执行）
-- ALTER TABLE maintenance_record DROP COLUMN maintainer;

-- 注意：
-- 1. 执行前请先备份数据库
-- 2. 先执行步骤1-5，检查数据迁移是否正确
-- 3. 确认无误后再执行步骤6删除旧字段
-- 4. 如果有未迁移的记录，需要手动处理
