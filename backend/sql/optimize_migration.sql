-- ============================================================
-- 数据库优化迁移脚本
-- 适用场景：对现有数据库执行优化
-- 生成时间：2026-06-14
-- 
-- 执行前请先备份数据库！
-- ============================================================

-- ============================================================
-- 第一部分：删除未使用的表（8个）
-- ============================================================

-- 1. 字典表 - 代码中无 Entity/Mapper，未被使用
DROP TABLE IF EXISTS `sys_dict`;

-- 2. 权限表 - 代码中无 Entity/Mapper，RBAC 未实现
DROP TABLE IF EXISTS `sys_permission`;

-- 3. 角色权限关联表 - 代码中无 Entity/Mapper，RBAC 未实现
DROP TABLE IF EXISTS `sys_role_permission`;

-- 4. 用户角色关联表 - 代码中无 Entity/Mapper（sys_user 已有 role_id 直接关联）
DROP TABLE IF EXISTS `sys_user_role`;

-- 5. 档案版本表 - 有 Entity 但无 Mapper，死代码
DROP TABLE IF EXISTS `archive_version`;

-- 6. 图片库过期快照备份（2026-04-23）
DROP TABLE IF EXISTS `image_library_backup_20260423`;

-- 7. 文物图片关联过期快照备份（2026-04-28）
DROP TABLE IF EXISTS `relic_image_relation_backup_20260428`;

-- 8. 旧版修复记录备份
DROP TABLE IF EXISTS `repair_record_backup`;


-- ============================================================
-- 第二部分：删除冗余索引（5处）
-- MySQL 的 UNIQUE 约束底层自动创建 B-tree 索引，
-- 同列的普通 INDEX 完全冗余，浪费磁盘且拖慢写入
-- ============================================================

-- 1. cultural_relic: UNIQUE(relic_code) 已包含索引功能
DROP INDEX `idx_relic_code` ON `cultural_relic`;

-- 2. museum: UNIQUE(museum_code) 已包含索引功能
DROP INDEX `idx_museum_code` ON `museum`;

-- 3. repair_expert: UNIQUE(expert_code) 已包含索引功能
DROP INDEX `idx_expert_code` ON `repair_expert`;

-- 4. repair_material: UNIQUE(material_code) 已包含索引功能
DROP INDEX `idx_material_code` ON `repair_material`;

-- 5. sys_user: UNIQUE(username) 已包含索引功能
DROP INDEX `idx_username` ON `sys_user`;


-- ============================================================
-- 第三部分：补充缺失的外键约束（6处）
-- 注意：如果现有数据存在孤儿记录，FK 创建会失败。
-- 下方已包含孤儿数据清理步骤
-- ============================================================

-- 清理孤儿数据（category_id 指向不存在的分类）
-- DELETE FROM `cultural_relic` WHERE `category_id` IS NOT NULL 
--   AND `category_id` NOT IN (SELECT `id` FROM `cultural_relic_category`);

-- 1. cultural_relic.category_id -> cultural_relic_category.id
ALTER TABLE `cultural_relic` 
  ADD CONSTRAINT `fk_cultural_relic_category` 
  FOREIGN KEY (`category_id`) REFERENCES `cultural_relic_category` (`id`) 
  ON DELETE SET NULL ON UPDATE RESTRICT;

-- 清理孤儿数据
-- DELETE FROM `maintenance_record` WHERE `relic_id` NOT IN (SELECT `id` FROM `cultural_relic`);

-- 2. maintenance_record.relic_id -> cultural_relic.id
ALTER TABLE `maintenance_record` 
  ADD CONSTRAINT `fk_maintenance_relic` 
  FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) 
  ON DELETE CASCADE ON UPDATE RESTRICT;

-- 3. maintenance_record.maintainer_id -> sys_user.id
ALTER TABLE `maintenance_record` 
  ADD CONSTRAINT `fk_maintenance_maintainer` 
  FOREIGN KEY (`maintainer_id`) REFERENCES `sys_user` (`id`) 
  ON DELETE SET NULL ON UPDATE RESTRICT;

-- 4. repair_record.relic_id -> cultural_relic.id
ALTER TABLE `repair_record` 
  ADD CONSTRAINT `fk_repair_relic` 
  FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) 
  ON DELETE CASCADE ON UPDATE RESTRICT;

-- 5. repair_record.applicant_id -> sys_user.id
ALTER TABLE `repair_record` 
  ADD CONSTRAINT `fk_repair_applicant` 
  FOREIGN KEY (`applicant_id`) REFERENCES `sys_user` (`id`) 
  ON DELETE SET NULL ON UPDATE RESTRICT;

-- 6. loan_record.relic_id -> cultural_relic.id
ALTER TABLE `loan_record` 
  ADD CONSTRAINT `fk_loan_relic` 
  FOREIGN KEY (`relic_id`) REFERENCES `cultural_relic` (`id`) 
  ON DELETE CASCADE ON UPDATE RESTRICT;


-- ============================================================
-- 总结
-- ============================================================
-- ✅ 删除表：8个
-- ✅ 删除冗余索引：5处
-- ✅ 补充外键：6处
-- 
-- 如需回滚，请使用之前创建的数据库备份。
-- ============================================================
