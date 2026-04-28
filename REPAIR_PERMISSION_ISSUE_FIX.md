# 修复管理权限问题修复方案

## 🐛 问题描述

**当前问题**: 系统管理员和文物保管员都只能看见和操作未审批的修复申请

**期望行为**:
- ✅ **系统管理员** (repairs:manage): 可以看见和操作**所有状态**的修复申请
- ✅ **文物保管员** (repairs:apply): 只能看见和操作**自己的**修复申请（所有状态）

---

## 🔍 问题分析

经过代码审查，后端权限控制逻辑是**正确的**：

### 后端代码（RepairRecordController.java）
```java
// 检查是否有 repairs:manage 权限
boolean hasManagePermission = authorities.stream()
    .anyMatch(a -> a.getAuthority().equals("repairs:manage"));

// 如果只有 repairs:apply 权限，只查询自己申请的
if (!hasManagePermission) {
    applicantIdFilter = userContextUtil.getCurrentUserId();
}
```

**逻辑正确**:
- 有 `repairs:manage` → `applicantIdFilter = null` → 查询所有记录
- 只有 `repairs:apply` → `applicantIdFilter = 当前用户ID` → 只查询自己的记录

### 前端代码（RepairsView.vue）
```javascript
const query = reactive({ 
  pageNum: 1, 
  pageSize: 10, 
  status: '',  // 初始为空，应该查询所有状态
  priority: '', 
  relicName: '', 
  repairExpert: '' 
})
```

**前端也正确**: status初始为空字符串，应该查询所有状态。

---

## 🎯 可能的原因

### 原因1: 数据库中只有"待审批"状态的记录
如果数据库中所有修复记录都是"待审批"状态，那么看起来就像只能看到待审批的记录。

### 原因2: 前端从URL参数获取了status
虽然代码中没有看到 `useRoute`，但可能从其他地方（如DataScreenView）跳转时带了status参数。

### 原因3: 权限配置问题
系统管理员可能没有正确配置 `repairs:manage` 权限。

---

## ✅ 解决方案

### 方案1: 验证数据库中的记录状态

```sql
-- 查看所有修复记录的状态分布
SELECT status, COUNT(*) as count
FROM repair_record
GROUP BY status;

-- 查看所有修复记录
SELECT id, repair_code, relic_id, status, applicant_id, apply_date
FROM repair_record
ORDER BY apply_date DESC;
```

**如果只有"待审批"记录**: 需要创建不同状态的测试数据。

### 方案2: 验证用户权限配置

```sql
-- 查看系统管理员（ADMIN）的权限
SELECT p.permission_code, p.permission_name
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'ADMIN';

-- 应该包含 repairs:manage

-- 查看保管员（CURATOR）的权限
SELECT p.permission_code, p.permission_name
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR';

-- 应该只有 repairs:apply，不应该有 repairs:manage
```

### 方案3: 前端添加URL参数处理（可选）

如果需要支持从URL参数初始化查询条件，可以在RepairsView.vue中添加：

```vue
<script setup>
import { onMounted, reactive, ref, watch } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()

const query = reactive({ 
  pageNum: 1, 
  pageSize: 10, 
  status: '', 
  priority: '', 
  relicName: '', 
  repairExpert: '' 
})

// 从URL参数初始化查询条件
onMounted(async () => {
  if (route.query.status) {
    query.status = route.query.status
  }
  await Promise.all([loadData(), loadRelics(), loadExperts(), loadAllMaterials()])
})
</script>
```

### 方案4: 创建测试数据

如果数据库中只有"待审批"记录，创建不同状态的测试数据：

```sql
-- 创建测试数据脚本
-- 假设已有一条待审批记录，ID=1

-- 1. 创建一条"待修复"记录（已审批通过）
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark, repair_expert
) VALUES (
  'REP2024000002', 2, '待修复', '高', 3,
  '2024-04-20 10:00:00', '表面有裂纹需要修复', '底部有明显裂痕，需要专业修复', 5000.00,
  'admin', '2024-04-21 09:00:00', '同意修复', '张三'
);

-- 2. 创建一条"修复中"记录
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark, repair_expert,
  start_date, repair_process
) VALUES (
  'REP2024000003', 3, '修复中', '紧急', 3,
  '2024-04-18 10:00:00', '严重损坏需要紧急修复', '多处破损，需要全面修复', 8000.00,
  'admin', '2024-04-19 09:00:00', '同意修复', '李四',
  '2024-04-22 08:00:00', '已完成初步清理，正在进行修复'
);

-- 3. 创建一条"修复完成"记录
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark, repair_expert,
  start_date, complete_date, repair_process, repair_method,
  actual_cost, quality_score, quality_remark
) VALUES (
  'REP2024000004', 4, '修复完成', '普通', 3,
  '2024-04-10 10:00:00', '轻微损坏需要修复', '表面有轻微磨损', 3000.00,
  'admin', '2024-04-11 09:00:00', '同意修复', '王五',
  '2024-04-12 08:00:00', '2024-04-25 17:00:00', 
  '清理、修复、加固', '采用传统工艺进行修复',
  2800.00, 95, '修复效果良好'
);

-- 4. 创建一条"已拒绝"记录
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost,
  approver, approve_date, approve_remark
) VALUES (
  'REP2024000005', 5, '已拒绝', '低', 3,
  '2024-04-26 10:00:00', '需要修复', '有轻微损坏', 2000.00,
  'admin', '2024-04-27 09:00:00', '损坏程度不足以进行修复，建议继续观察'
);

-- 5. 为另一个保管员创建记录（用于测试数据隔离）
-- 假设curator02的user_id=4
INSERT INTO repair_record (
  repair_code, relic_id, status, priority, applicant_id, 
  apply_date, repair_reason, damage_description, estimated_cost
) VALUES (
  'REP2024000006', 6, '待审批', '普通', 4,
  '2024-04-28 10:00:00', '需要修复', '有损坏', 3500.00
);
```

---

## 🧪 测试步骤

### 测试1: 验证数据库记录
```sql
-- 查看所有修复记录
SELECT id, repair_code, status, applicant_id, apply_date
FROM repair_record
ORDER BY id;
```

**预期结果**: 应该看到不同状态的记录（待审批、待修复、修复中、修复完成、已拒绝）

### 测试2: 系统管理员登录测试
1. 使用admin账号登录
2. 进入"修复管理"页面
3. 不选择任何筛选条件，点击"搜索"

**预期结果**: 
- ✅ 看到所有状态的修复记录
- ✅ 看到所有保管员提交的记录

### 测试3: 保管员登录测试
1. 使用curator01账号登录（假设user_id=3）
2. 进入"申请修复"页面
3. 不选择任何筛选条件，点击"搜索"

**预期结果**:
- ✅ 只看到自己提交的记录（applicant_id=3）
- ✅ 看到自己记录的所有状态
- ❌ 看不到其他保管员的记录

### 测试4: 数据隔离测试
1. curator01登录，查看记录列表
2. curator02登录，查看记录列表

**预期结果**:
- curator01只看到自己的记录
- curator02只看到自己的记录
- 两者看到的记录不同

---

## 📊 诊断命令

### 1. 检查当前修复记录状态分布
```sql
SELECT 
  status,
  COUNT(*) as count,
  GROUP_CONCAT(id) as record_ids
FROM repair_record
GROUP BY status;
```

### 2. 检查用户权限
```sql
-- 检查admin用户的权限
SELECT u.username, r.role_name, p.permission_code
FROM sys_user u
JOIN sys_user_role ur ON u.id = ur.user_id
JOIN sys_role r ON ur.role_id = r.id
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE u.username = 'admin'
AND p.permission_code LIKE 'repairs:%';

-- 检查curator01用户的权限
SELECT u.username, r.role_name, p.permission_code
FROM sys_user u
JOIN sys_user_role ur ON u.id = ur.user_id
JOIN sys_role r ON ur.role_id = r.id
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE u.username = 'curator01'
AND p.permission_code LIKE 'repairs:%';
```

### 3. 检查修复记录的申请人
```sql
SELECT 
  rr.id,
  rr.repair_code,
  rr.status,
  rr.applicant_id,
  u.username as applicant_username,
  u.real_name as applicant_realname
FROM repair_record rr
LEFT JOIN sys_user u ON rr.applicant_id = u.id
ORDER BY rr.id;
```

---

## 🔧 快速修复脚本

如果确认是数据问题，执行以下脚本创建测试数据：

```bash
# 保存为 create_repair_test_data.sql
mysql -u root -p cultural_relics < create_repair_test_data.sql
```

```sql
-- create_repair_test_data.sql
USE cultural_relics;

-- 确保有足够的文物记录
-- 如果没有，先创建一些测试文物

-- 创建不同状态的修复记录
-- 注意：需要根据实际的relic_id和applicant_id调整

-- 待修复状态
INSERT INTO repair_record (repair_code, relic_id, status, priority, applicant_id, apply_date, repair_reason, damage_description, estimated_cost, approver, approve_date, repair_expert)
SELECT 'REP2024000010', id, '待修复', '高', 3, NOW(), '需要修复', '有损坏', 5000.00, 'admin', NOW(), '张三'
FROM cultural_relic WHERE status = '在库' LIMIT 1;

-- 修复中状态
INSERT INTO repair_record (repair_code, relic_id, status, priority, applicant_id, apply_date, repair_reason, damage_description, estimated_cost, approver, approve_date, repair_expert, start_date)
SELECT 'REP2024000011', id, '修复中', '紧急', 3, DATE_SUB(NOW(), INTERVAL 5 DAY), '紧急修复', '严重损坏', 8000.00, 'admin', DATE_SUB(NOW(), INTERVAL 4 DAY), '李四', DATE_SUB(NOW(), INTERVAL 3 DAY)
FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 1;

-- 修复完成状态
INSERT INTO repair_record (repair_code, relic_id, status, priority, applicant_id, apply_date, repair_reason, damage_description, estimated_cost, approver, approve_date, repair_expert, start_date, complete_date, actual_cost, quality_score)
SELECT 'REP2024000012', id, '修复完成', '普通', 3, DATE_SUB(NOW(), INTERVAL 10 DAY), '修复', '有损坏', 3000.00, 'admin', DATE_SUB(NOW(), INTERVAL 9 DAY), '王五', DATE_SUB(NOW(), INTERVAL 8 DAY), DATE_SUB(NOW(), INTERVAL 1 DAY), 2800.00, 95
FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 2;

-- 已拒绝状态
INSERT INTO repair_record (repair_code, relic_id, status, priority, applicant_id, apply_date, repair_reason, damage_description, estimated_cost, approver, approve_date, approve_remark)
SELECT 'REP2024000013', id, '已拒绝', '低', 3, DATE_SUB(NOW(), INTERVAL 2 DAY), '需要修复', '轻微损坏', 2000.00, 'admin', DATE_SUB(NOW(), INTERVAL 1 DAY), '损坏程度不足'
FROM cultural_relic WHERE status = '在库' LIMIT 1 OFFSET 3;

-- 验证创建结果
SELECT 
  id, repair_code, status, applicant_id, apply_date
FROM repair_record
ORDER BY id DESC
LIMIT 10;
```

---

## ✅ 验证清单

完成修复后，请验证以下内容：

### 数据验证
- [ ] 数据库中有不同状态的修复记录
- [ ] 有多个保管员的修复记录（用于测试数据隔离）

### 权限验证
- [ ] admin用户有 `repairs:manage` 权限
- [ ] curator用户只有 `repairs:apply` 权限

### 功能验证
- [ ] admin可以看到所有状态的所有记录
- [ ] curator只能看到自己的记录（所有状态）
- [ ] curator01看不到curator02的记录

---

## 📝 总结

**代码层面**: 后端和前端的权限控制逻辑都是正确的。

**问题根源**: 很可能是以下之一：
1. 数据库中只有"待审批"状态的记录
2. 权限配置不正确
3. 测试数据不足

**解决方法**:
1. 执行诊断SQL检查数据和权限
2. 如果需要，创建测试数据
3. 重新测试验证

---

**创建时间**: 2026-04-28  
**状态**: 待验证
