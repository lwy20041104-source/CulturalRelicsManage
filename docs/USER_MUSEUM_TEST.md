# 用户博物馆关联功能测试指南

## 测试目标
验证新增借展人用户时，博物馆关联是否正确保存到 `user_museum` 表

## 前置条件

### 1. 数据库准备
确保已执行以下SQL脚本：
```bash
mysql -u root -p1234 cultural_relics < backend/sql/museum_tables.sql
```

验证表和数据：
```sql
USE cultural_relics;

-- 检查博物馆数据
SELECT COUNT(*) FROM museum;  -- 应该返回10

-- 检查现有的用户博物馆关联
SELECT * FROM user_museum;
```

### 2. 服务启动
- ✅ 后端服务已启动（端口8080）
- ✅ 前端服务已启动（端口5173）
- ✅ MySQL服务已启动
- ✅ 已修改SecurityConfig，允许匿名访问 `/museums/active`

---

## 测试步骤

### 测试1：新增借展人用户（完整流程）

#### 步骤1：登录后台管理系统
1. 访问：`http://localhost:5173/login`
2. 使用管理员账号登录：
   - 用户名：`admin`
   - 密码：`123456`
   - 角色：系统管理员

#### 步骤2：进入用户管理页面
1. 点击左侧菜单"系统管理" → "用户管理"
2. 点击"新增用户"按钮

#### 步骤3：填写用户信息
填写以下信息：
- **用户名**：`testloaner01`（必填）
- **密码**：`123456`（必填，新增时必填）
- **确认密码**：`123456`（必填，新增时必填）
- **真实姓名**：`测试借展人`（必填）
- **角色**：选择"文物借展人"（必填）
- **所属博物馆**：选择"国家博物馆"（必填，选择借展人角色后自动显示）
- **电话**：`13800138001`（必填）
- **邮箱**：`testloaner01@example.com`（必填）
- **状态**：启用（必填）

#### 步骤4：验证必填项
尝试以下操作，验证表单验证是否正确：

**测试4.1：不填密码**
- 清空密码字段
- 点击"确定"
- ✅ 预期：提示"此项为必填项"

**测试4.2：不填确认密码**
- 填写密码，但不填确认密码
- 点击"确定"
- ✅ 预期：提示"此项为必填项"

**测试4.3：两次密码不一致**
- 密码：`123456`
- 确认密码：`654321`
- 点击"确定"
- ✅ 预期：提示"两次密码不一致"

**测试4.4：选择借展人角色但不选博物馆**
- 选择角色为"文物借展人"
- 不选择博物馆
- 点击"确定"
- ✅ 预期：提示"借展人必须选择所属博物馆"

**测试4.5：正常提交**
- 填写所有必填项
- 点击"确定"
- ✅ 预期：提示"新增成功"

#### 步骤5：验证数据库
打开MySQL客户端，执行以下查询：

```sql
USE cultural_relics;

-- 查询新增的用户
SELECT id, username, real_name, role_id 
FROM sys_user 
WHERE username = 'testloaner01';

-- 假设新用户的ID是10，查询博物馆关联
SELECT um.*, m.museum_name 
FROM user_museum um
JOIN museum m ON um.museum_id = m.id
WHERE um.user_id = 10;  -- 替换为实际的用户ID
```

**预期结果：**
```
user_museum表应该有一条新记录：
- user_id: 10（新用户的ID）
- museum_id: 1（国家博物馆的ID）
- is_primary: 1
```

#### 步骤6：查看后端日志
检查后端控制台输出，应该看到类似以下日志：

```
=== 新增用户请求数据 ===
requestData: {username=testloaner01, password=123456, confirmPassword=123456, realName=测试借展人, roleId=4, museumId=1, phone=13800138001, email=testloaner01@example.com, status=1}
museumId: 1
用户保存结果: true, 用户ID: 10
创建用户博物馆关联: userId=10, museumId=1
博物馆关联插入结果: 1
```

---

### 测试2：新增非借展人用户

#### 步骤1：新增管理员用户
1. 点击"新增用户"
2. 填写信息：
   - 用户名：`testadmin01`
   - 密码：`123456`
   - 确认密码：`123456`
   - 真实姓名：`测试管理员`
   - 角色：选择"系统管理员"
   - 电话：`13800138002`
   - 邮箱：`testadmin01@example.com`
3. 点击"确定"

#### 步骤2：验证博物馆字段不显示
- ✅ 预期：选择"系统管理员"角色后，博物馆字段不显示
- ✅ 预期：可以正常保存，不需要选择博物馆

#### 步骤3：验证数据库
```sql
-- 查询新增的管理员用户
SELECT id, username, real_name, role_id 
FROM sys_user 
WHERE username = 'testadmin01';

-- 查询博物馆关联（应该没有记录）
SELECT * FROM user_museum WHERE user_id = 11;  -- 替换为实际的用户ID
```

**预期结果：**
- user_museum表中没有该用户的记录

---

### 测试3：编辑借展人用户

#### 步骤1：编辑现有借展人
1. 在用户列表中找到刚创建的 `testloaner01`
2. 点击"编辑"按钮
3. 应该自动加载关联的博物馆（国家博物馆）

#### 步骤2：修改博物馆
1. 将博物馆改为"上海博物馆"
2. 点击"确定"

#### 步骤3：验证数据库
```sql
-- 查询博物馆关联
SELECT um.*, m.museum_name 
FROM user_museum um
JOIN museum m ON um.museum_id = m.id
WHERE um.user_id = 10;  -- 替换为实际的用户ID
```

**预期结果：**
- museum_id 应该变为 3（上海博物馆）

---

### 测试4：前台登录验证

#### 步骤1：使用新用户登录前台
1. 访问：`http://localhost:5173/portal-login`
2. 输入：
   - 用户名：`testloaner01`
   - 密码：`123456`
   - 博物馆：选择"国家博物馆"
3. 点击"立即登录"

#### 步骤2：验证登录
- ✅ 预期：登录成功，跳转到前台门户
- ✅ 预期：可以正常浏览文物、申请借展

---

## 故障排查

### 问题1：user_museum表没有新增记录

**可能原因：**
1. 前端没有发送 `museumId` 字段
2. 后端没有接收到 `museumId` 字段
3. 数据库插入失败

**排查步骤：**

**1. 检查前端请求**
- 打开浏览器开发者工具（F12）
- 切换到 Network 标签页
- 新增用户时，查看 `/api/users` 的POST请求
- 点击请求，查看 Payload 或 Request Payload
- 确认是否包含 `museumId` 字段

**2. 检查后端日志**
- 查看后端控制台输出
- 应该看到 `=== 新增用户请求数据 ===` 的日志
- 确认 `museumId` 是否有值
- 确认是否执行了 `创建用户博物馆关联` 的逻辑

**3. 检查数据库**
```sql
-- 检查用户是否创建成功
SELECT * FROM sys_user WHERE username = 'testloaner01';

-- 检查博物馆关联
SELECT * FROM user_museum WHERE user_id = (
    SELECT id FROM sys_user WHERE username = 'testloaner01'
);
```

**4. 手动插入测试**
```sql
-- 如果自动插入失败，手动插入测试
INSERT INTO user_museum (user_id, museum_id, is_primary)
VALUES (
    (SELECT id FROM sys_user WHERE username = 'testloaner01'),
    1,
    1
);
```

---

### 问题2：博物馆字段不显示

**可能原因：**
- 角色数据没有正确加载
- `isLoanerRole` 计算属性逻辑错误

**排查步骤：**
1. 打开浏览器控制台（F12）
2. 在 Console 中输入：
   ```javascript
   // 查看角色列表
   console.log(roleOptions.value)
   
   // 查看当前选择的角色
   console.log(form.roleId)
   
   // 查看是否为借展人角色
   console.log(isLoanerRole.value)
   ```

---

### 问题3：表单验证不生效

**可能原因：**
- 验证规则没有正确配置
- 表单ref没有正确绑定

**排查步骤：**
1. 检查 `formRef` 是否正确绑定
2. 检查 `rules` 对象是否正确定义
3. 检查 `validateMuseumId` 函数逻辑

---

## 测试清单

- [ ] 数据库表已创建（museum、user_museum）
- [ ] 博物馆数据已插入（10条记录）
- [ ] 后端服务已重启
- [ ] SecurityConfig已修改，允许匿名访问博物馆接口
- [ ] 前端服务已重启
- [ ] 新增借展人用户时，密码为必填
- [ ] 新增借展人用户时，确认密码为必填
- [ ] 新增借展人用户时，博物馆为必填
- [ ] 选择借展人角色后，博物馆字段自动显示
- [ ] 选择非借展人角色后，博物馆字段自动隐藏
- [ ] 新增借展人用户后，user_museum表有新记录
- [ ] 编辑借展人用户时，自动加载关联的博物馆
- [ ] 修改博物馆后，user_museum表正确更新
- [ ] 新增非借展人用户时，不需要选择博物馆
- [ ] 前台登录时，可以选择博物馆
- [ ] 后端日志正确输出调试信息

---

## 成功标志

当你看到以下情况时，说明功能正常：

1. ✅ 新增借展人用户时，必须填写密码、确认密码、博物馆
2. ✅ 提交后，user_museum表有新记录
3. ✅ 后端日志显示正确的调试信息
4. ✅ 编辑借展人用户时，自动加载博物馆
5. ✅ 前台登录时，可以正常选择博物馆

---

## 清理测试数据

测试完成后，可以删除测试用户：

```sql
-- 删除测试用户（会自动级联删除user_museum记录）
DELETE FROM sys_user WHERE username IN ('testloaner01', 'testadmin01');

-- 验证删除
SELECT * FROM user_museum WHERE user_id NOT IN (SELECT id FROM sys_user);
```

