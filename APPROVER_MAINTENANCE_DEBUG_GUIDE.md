# 🔍 申请审批员查询维护记录问题 - 调试指南

## 📋 问题描述

**问题**：申请审批员（APPROVER）在维护记录管理页面无法查询到全部的维护记录  
**预期行为**：APPROVER应该能看到所有用户创建的维护记录  
**实际行为**：可能只看到自己创建的维护记录或看不到记录  

---

## 🔧 已添加的调试日志

我已经在 `MaintenanceRecordController.java` 的查询方法中添加了详细的调试日志。

### 修改的代码

**文件**：`backend/src/main/java/com/example/controller/MaintenanceRecordController.java`

**添加的日志**：
```java
// 打印所有权限信息用于调试
System.out.println("=== 维护记录查询权限检查 ===");
System.out.println("用户名: " + authentication.getName());
System.out.println("权限列表: " + authorities);
authorities.forEach(a -> System.out.println("  - " + a.getAuthority()));

// 检查每个权限
boolean isAdminOrApprover = authorities.stream()
    .anyMatch(a -> {
        String authority = a.getAuthority();
        boolean match = authority.equals("ROLE_ADMIN") || authority.equals("ROLE_APPROVER");
        System.out.println("检查权限: " + authority + " -> " + match);
        return match;
    });

System.out.println("是否是管理员或审批员: " + isAdminOrApprover);

if (!isAdminOrApprover) {
    maintainerIdFilter = userContextUtil.getCurrentUserId();
    System.out.println("保管员权限过滤：只显示维护人ID=" + maintainerIdFilter + "的记录");
} else {
    System.out.println("管理员/审批员权限：显示所有维护记录");
}
System.out.println("=== 权限检查完成 ===");
```

---

## 🧪 调试步骤

### 步骤 1：启动后端（查看日志）

```bash
cd backend
mvn spring-boot:run
```

**重要**：保持终端窗口打开，以便查看日志输出。

### 步骤 2：启动前端

```bash
cd frontend
npm run dev
```

### 步骤 3：使用APPROVER账号登录

- 访问：`http://localhost:5173/login`
- 用户名：`approver01`
- 密码：`123456`

### 步骤 4：进入维护管理页面

- 点击左侧菜单的"维护管理"
- 观察后端终端的日志输出

### 步骤 5：分析日志输出

**正常情况下的日志**（APPROVER应该看到）：
```
=== 维护记录查询权限检查 ===
用户名: approver01
权限列表: [ROLE_APPROVER]
  - ROLE_APPROVER
检查权限: ROLE_APPROVER -> true
是否是管理员或审批员: true
管理员/审批员权限：显示所有维护记录
=== 权限检查完成 ===
```

**异常情况1**（权限名称错误）：
```
=== 维护记录查询权限检查 ===
用户名: approver01
权限列表: [APPROVER]  ← 缺少 ROLE_ 前缀
  - APPROVER
检查权限: APPROVER -> false  ← 匹配失败
是否是管理员或审批员: false
保管员权限过滤：只显示维护人ID=X的记录
=== 权限检查完成 ===
```

**异常情况2**（authentication为null）：
```
警告: authentication 为 null
```

---

## 🔍 可能的问题原因

### 1. 权限名称不匹配 ⚠️

**问题**：数据库中的角色代码与代码中的判断不一致

**检查方法**：
```sql
-- 查询APPROVER角色的信息
SELECT * FROM sys_role WHERE role_code = 'APPROVER';

-- 查询approver01用户的角色
SELECT u.*, r.role_code 
FROM sys_user u 
LEFT JOIN sys_role r ON u.role_id = r.id 
WHERE u.username = 'approver01';
```

**预期结果**：
- role_code 应该是 `APPROVER`（不是 `approver` 或其他）
- role_id 应该是 3

### 2. JWT Token中的角色信息错误 ⚠️

**问题**：Token生成时没有正确包含角色信息

**检查方法**：查看 `CustomUserDetailsService.loadUserByUsername()` 方法的日志

### 3. 数据库中没有维护记录 ⚠️

**问题**：数据库中确实没有维护记录数据

**检查方法**：
```sql
-- 查询所有维护记录
SELECT * FROM maintenance_record;

-- 查询维护记录数量
SELECT COUNT(*) FROM maintenance_record;
```

### 4. 前端请求未携带Token ⚠️

**问题**：前端请求时没有在Header中携带JWT Token

**检查方法**：
- 打开浏览器开发者工具（F12）
- 切换到 Network 标签
- 刷新维护管理页面
- 查看请求的 Headers
- 确认有 `Authorization: Bearer <token>` 头

---

## 🛠️ 解决方案

### 解决方案 1：修复数据库角色代码

如果数据库中的角色代码不正确：

```sql
-- 更新APPROVER角色代码（如果需要）
UPDATE sys_role SET role_code = 'APPROVER' WHERE id = 3;

-- 确认approver01用户的角色ID
UPDATE sys_user SET role_id = 3 WHERE username = 'approver01';
```

### 解决方案 2：重新登录

如果Token中的角色信息过期：

1. 退出登录
2. 清除浏览器缓存（或使用无痕模式）
3. 重新登录

### 解决方案 3：添加测试数据

如果数据库中没有维护记录：

```sql
-- 插入测试维护记录
INSERT INTO maintenance_record 
(relic_id, relic_name, maintenance_type, maintenance_date, operator, description, status, maintainer_id, create_time, update_time)
VALUES
(1, '青铜鼎', '清洁', NOW(), 'curator01', '定期清洁保养', '待审批', 2, NOW(), NOW()),
(2, '玉璧', '检查', NOW(), 'curator01', '定期检查', '已通过', 2, NOW(), NOW()),
(3, '陶罐', '保养', NOW(), 'admin', '全面保养', '待审批', 1, NOW(), NOW());
```

### 解决方案 4：检查前端API调用

**文件**：`frontend/src/api/maintenance.js`

确认API调用正确：
```javascript
export const getMaintenancePageApi = (params) => {
  return request({
    url: '/maintenance',
    method: 'get',
    params
  })
}
```

**文件**：`frontend/src/utils/request.js`

确认请求拦截器正确添加Token：
```javascript
request.interceptors.request.use(config => {
  const token = sessionStorage.getItem('token')
  if (token) {
    config.headers['Authorization'] = `Bearer ${token}`
  }
  return config
})
```

---

## 📊 验证清单

使用以下清单逐项验证：

### 数据库验证
- [ ] sys_role 表中存在 role_code='APPROVER' 的记录（id=3）
- [ ] sys_user 表中 approver01 的 role_id=3
- [ ] maintenance_record 表中有测试数据

### 后端验证
- [ ] 后端编译成功
- [ ] 后端启动成功
- [ ] 日志中显示"管理员/审批员权限：显示所有维护记录"

### 前端验证
- [ ] 前端构建成功
- [ ] 前端启动成功
- [ ] 登录后 sessionStorage 中有 token
- [ ] 网络请求中有 Authorization 头

### 功能验证
- [ ] APPROVER可以看到左侧"维护管理"菜单
- [ ] 点击菜单可以进入维护管理页面
- [ ] 页面显示所有维护记录（不仅仅是自己的）
- [ ] 可以看到其他用户创建的记录

---

## 🎯 快速测试脚本

### 测试数据库

```sql
-- 1. 检查角色配置
SELECT id, role_name, role_code FROM sys_role WHERE role_code = 'APPROVER';
-- 预期: id=3, role_code='APPROVER'

-- 2. 检查用户配置
SELECT id, username, role_id FROM sys_user WHERE username = 'approver01';
-- 预期: role_id=3

-- 3. 检查维护记录
SELECT id, relic_name, maintainer_id, status FROM maintenance_record;
-- 预期: 有多条记录，maintainer_id不同

-- 4. 如果没有数据，插入测试数据
INSERT INTO maintenance_record 
(relic_id, relic_name, maintenance_type, maintenance_date, operator, description, status, maintainer_id, create_time, update_time)
VALUES
(1, '测试文物1', '清洁', NOW(), 'curator01', '测试记录1', '待审批', 2, NOW(), NOW()),
(1, '测试文物2', '检查', NOW(), 'admin', '测试记录2', '已通过', 1, NOW(), NOW());
```

### 测试后端日志

启动后端后，使用curl测试：

```bash
# 1. 登录获取token
curl -X POST http://localhost:8080/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"approver01","password":"123456","roleCode":"APPROVER"}'

# 2. 使用token查询维护记录（替换<TOKEN>为实际token）
curl -X GET "http://localhost:8080/maintenance?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer <TOKEN>"
```

---

## 📝 预期结果

### APPROVER角色应该看到：

1. **所有维护记录**：
   - 自己创建的记录
   - 其他用户（ADMIN、CURATOR）创建的记录
   - 所有状态的记录（待审批、已通过、已拒绝）

2. **操作权限**：
   - ✅ 查看所有记录
   - ✅ 创建自己的维护申请
   - ✅ 编辑自己的待审批申请
   - ✅ 删除自己的申请
   - ✅ 审批所有待审批的申请

3. **后端日志**：
   ```
   是否是管理员或审批员: true
   管理员/审批员权限：显示所有维护记录
   ```

---

## 🆘 如果问题仍然存在

### 收集以下信息：

1. **后端日志输出**（完整的权限检查日志）
2. **数据库查询结果**：
   ```sql
   SELECT * FROM sys_role WHERE id = 3;
   SELECT * FROM sys_user WHERE username = 'approver01';
   SELECT COUNT(*) FROM maintenance_record;
   ```
3. **浏览器控制台**：
   - Network标签中的请求详情
   - Console标签中的错误信息
4. **前端sessionStorage**：
   - token的值
   - role的值
   - permissions的值

### 联系支持

将以上信息提供给技术支持，以便进一步诊断问题。

---

## ✅ 总结

1. ✅ 已添加详细的调试日志
2. ✅ 后端编译成功
3. 📋 按照调试步骤操作
4. 🔍 查看后端日志输出
5. 🛠️ 根据日志选择对应的解决方案

**下一步**：
1. 启动后端并查看日志
2. 使用APPROVER账号登录
3. 进入维护管理页面
4. 观察后端日志输出
5. 根据日志信息确定问题原因

---

**文档作者**：Kiro AI Assistant  
**创建时间**：2026年4月29日  
**版本**：1.0.0  
**状态**：调试中
