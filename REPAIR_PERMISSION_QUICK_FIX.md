# 修复管理权限问题 - 快速修复指南

## 🎯 问题

**现象**: 系统管理员和文物保管员都只能看见和操作未审批的修复申请

**期望**: 
- 系统管理员应该看到**所有状态**的**所有记录**
- 文物保管员应该看到**所有状态**的**自己的记录**

---

## 🔍 快速诊断（3步）

### 步骤1: 执行诊断脚本

```bash
mysql -u root -p cultural_relics < backend/sql/diagnose_repair_permissions.sql
```

这个脚本会检查：
- ✅ 修复记录的状态分布
- ✅ 用户权限配置
- ✅ 测试数据完整性

### 步骤2: 查看诊断结果

重点关注以下输出：

#### 2.1 修复记录状态分布
```
状态      | 数量 | 记录ID列表
---------|------|------------
待审批    | 5    | 1,2,3,4,5
```

**如果只有"待审批"状态** → 问题确认：需要创建测试数据

#### 2.2 ADMIN权限诊断
```
权限代码         | 权限名称
----------------|----------
repairs:manage  | 修复管理
```

**如果没有 repairs:manage** → 问题确认：需要配置权限

#### 2.3 CURATOR权限诊断
```
权限代码       | 权限名称
--------------|----------
repairs:apply | 申请修复
```

**如果有 repairs:manage** → 问题确认：权限配置错误

### 步骤3: 根据诊断结果选择修复方案

---

## ✅ 修复方案

### 方案A: 数据问题 - 创建测试数据

**适用场景**: 诊断显示只有"待审批"状态的记录

```bash
# 执行测试数据创建脚本
mysql -u root -p cultural_relics < backend/sql/create_repair_test_data.sql
```

**这个脚本会创建**:
- ✅ curator01的5条记录（待审批、待修复、修复中、修复完成、已拒绝）
- ✅ curator02的1条记录（用于测试数据隔离）

### 方案B: 权限问题 - 配置权限

**适用场景**: 诊断显示权限配置不正确

```bash
# 执行权限配置脚本
mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql
```

**这个脚本会**:
- ✅ 确保ADMIN有 repairs:manage 权限
- ✅ 确保CURATOR只有 repairs:apply 权限
- ✅ 移除CURATOR的 repairs:manage 权限

### 方案C: 两者都有问题

```bash
# 先修复权限
mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql

# 再创建测试数据
mysql -u root -p cultural_relics < backend/sql/create_repair_test_data.sql
```

---

## 🧪 验证修复结果

### 测试1: 系统管理员（admin）

1. 使用 `admin` 账号登录
2. 进入 **修复管理** 页面
3. 不选择任何筛选条件，点击"搜索"

**预期结果**:
```
✅ 看到所有状态的记录：
   - 待审批 (多条)
   - 待修复 (至少1条)
   - 修复中 (至少1条)
   - 修复完成 (至少1条)
   - 已拒绝 (至少1条)

✅ 看到所有保管员的记录：
   - curator01的记录
   - curator02的记录
```

### 测试2: 保管员1（curator01）

1. 使用 `curator01` 账号登录
2. 进入 **申请修复** 页面
3. 不选择任何筛选条件，点击"搜索"

**预期结果**:
```
✅ 只看到自己的记录（所有状态）：
   - 待审批 (至少1条)
   - 待修复 (至少1条)
   - 修复中 (至少1条)
   - 修复完成 (至少1条)
   - 已拒绝 (至少1条)

❌ 看不到curator02的记录
```

### 测试3: 保管员2（curator02）

1. 使用 `curator02` 账号登录
2. 进入 **申请修复** 页面
3. 不选择任何筛选条件，点击"搜索"

**预期结果**:
```
✅ 只看到自己的记录：
   - 待审批 (至少1条)

❌ 看不到curator01的记录
```

### 测试4: 操作权限

**curator01测试**:
- ✅ 待审批记录：可以"撤回"（删除）
- ✅ 已拒绝记录：可以"删除"
- ✅ 其他状态：只能"详情"查看

**admin测试**:
- ✅ 待审批记录：可以"审批"
- ✅ 待修复记录：可以"开始修复"
- ✅ 修复中记录：可以"更新进度"、"完成修复"
- ✅ 所有记录：可以查看详情

---

## 📊 验证SQL（可选）

如果想手动验证，可以执行以下SQL：

### 验证记录状态分布
```sql
SELECT status, COUNT(*) as count
FROM repair_record
GROUP BY status;
```

### 验证curator01的记录
```sql
SELECT rr.id, rr.repair_code, rr.status, u.username
FROM repair_record rr
JOIN sys_user u ON rr.applicant_id = u.id
WHERE u.username = 'curator01'
ORDER BY rr.id;
```

### 验证admin的权限
```sql
SELECT p.permission_code
FROM sys_user u
JOIN sys_user_role ur ON u.id = ur.user_id
JOIN sys_role r ON ur.role_id = r.id
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE u.username = 'admin'
AND p.permission_code LIKE 'repairs:%';
```

---

## 🎯 预期的最终状态

### 数据库状态
```
repair_record表:
- 至少6条记录
- 包含所有5种状态（待审批、待修复、修复中、修复完成、已拒绝）
- 至少2个不同的申请人（curator01, curator02）
```

### 权限配置
```
ADMIN角色:
- ✅ repairs:manage

CURATOR角色:
- ✅ repairs:apply
- ❌ repairs:manage (不应该有)
```

### 用户体验
```
admin登录:
- 看到"修复管理"菜单
- 看到所有记录（所有状态、所有申请人）
- 可以审批、修复、完成

curator01登录:
- 看到"申请修复"菜单
- 只看到自己的记录（所有状态）
- 可以申请、撤回（待审批）、删除（已拒绝）

curator02登录:
- 看到"申请修复"菜单
- 只看到自己的记录
- 看不到curator01的记录
```

---

## 🆘 如果还是有问题

### 检查后端日志

启动后端服务，查看控制台输出：

```
保管员权限过滤：只显示申请人ID=3的记录
查询修复记录：pageNum=1, pageSize=10, applicantIdFilter=3, total=5
```

如果看到 `applicantIdFilter=null` 但用户是curator → 权限配置有问题

### 检查前端网络请求

打开浏览器开发者工具 → Network → 查看API请求：

```
GET /api/repairs?pageNum=1&pageSize=10&status=&priority=&relicName=&repairExpert=
```

查看响应数据中的记录数量和状态分布。

### 清除浏览器缓存

有时候前端缓存会导致问题：
1. 按 Ctrl+Shift+Delete
2. 清除缓存和Cookie
3. 重新登录

---

## 📝 总结

**问题根源**: 很可能是数据库中只有"待审批"状态的记录

**解决方法**: 
1. 执行诊断脚本确认问题
2. 执行测试数据创建脚本
3. 验证修复结果

**预计时间**: 5分钟

---

**创建时间**: 2026-04-28  
**状态**: 可立即执行
