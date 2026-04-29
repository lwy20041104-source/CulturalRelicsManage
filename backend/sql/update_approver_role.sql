-- ========================================
-- 更新审批员角色配置
-- 将"借展审批员"升级为"申请审批员"
-- ========================================

USE cultural_relics;

-- 1. 更新角色名称和描述
UPDATE sys_role 
SET 
    role_name = '申请审批员',
    description = '负责借展、修复、维护申请的审批'
WHERE role_code = 'APPROVER';

-- 2. 验证更新结果
SELECT id, role_name, role_code, description 
FROM sys_role 
WHERE role_code = 'APPROVER';

-- ========================================
-- 权限说明
-- ========================================
-- 申请审批员(APPROVER)应该具有以下权限：
-- 1. loans:manage      - 借展管理（查看和审批借展申请）
-- 2. maintenance:manage - 维护管理（查看和审批维护申请）
-- 3. repairs:manage    - 修复管理（查看和审批修复申请）
--
-- 申请审批员不应该具有以下权限：
-- 1. archives:manage   - 档案管理（已移除）
-- 2. archives:view     - 档案查看（已移除）
-- 3. users:manage      - 用户管理
-- 4. relics:manage     - 文物管理
-- 5. categories:manage - 分类管理
-- 6. images:manage     - 图片管理
--
-- 注意：权限控制在后端代码中实现，不在数据库表中
-- ========================================
