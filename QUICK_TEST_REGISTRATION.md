# 快速测试：借展人注册功能

## 测试前准备

### 1. 确保后端服务运行
```bash
# 启动后端服务
cd backend
mvn spring-boot:run
```

### 2. 确保前端服务运行
```bash
# 启动前端服务
cd frontend
npm run dev
```

### 3. 确保数据库中有博物馆数据
```sql
-- 查看博物馆列表
SELECT * FROM museum WHERE status = 1;

-- 如果没有，插入测试数据
INSERT INTO museum (museum_code, museum_name, city, status) 
VALUES ('M001', '故宫博物院', '北京', 1);
```

## 测试步骤

### 测试 1: 正常注册流程

1. **访问注册页面**
   - 打开浏览器访问：`http://localhost:5173/portal-login`
   - 点击"立即注册"按钮

2. **填写注册信息**
   - 用户名：`testuser01`
   - 密码：`123456`
   - 确认密码：`123456`
   - 真实姓名：`测试用户`
   - 邮箱：`testuser01@example.com`
   - 电话号码：`13800138000`
   - 所属博物馆：选择任意博物馆
   - 勾选"我已阅读并同意用户协议"

3. **提交注册**
   - 点击"立即注册"按钮
   - 等待响应

4. **验证结果**
   - ✅ 显示"注册成功！请登录"
   - ✅ 自动跳转到登录页面
   - ✅ 数据库中有新用户记录

### 测试 2: 用户名已存在

1. 使用相同的用户名再次注册
2. **预期结果**：
   - ❌ 显示"用户名已存在"
   - ❌ 不跳转页面

### 测试 3: 密码不一致

1. 填写注册信息
2. 密码：`123456`
3. 确认密码：`654321`（不同）
4. **预期结果**：
   - ❌ 显示"两次输入的密码不一致"
   - ❌ 无法提交

### 测试 4: 邮箱格式错误

1. 填写注册信息
2. 邮箱：`invalid-email`（错误格式）
3. **预期结果**：
   - ❌ 显示"请输入正确的邮箱格式"
   - ❌ 无法提交

### 测试 5: 手机号格式错误

1. 填写注册信息
2. 电话号码：`12345678901`（不是1开头）
3. **预期结果**：
   - ❌ 显示"请输入正确的手机号码"
   - ❌ 无法提交

### 测试 6: 未选择博物馆

1. 填写注册信息
2. 不选择博物馆
3. **预期结果**：
   - ❌ 显示"请选择所属博物馆"
   - ❌ 无法提交

### 测试 7: 未同意协议

1. 填写注册信息
2. 不勾选用户协议
3. **预期结果**：
   - ❌ 显示"请阅读并同意用户协议和隐私政策"
   - ❌ 无法提交

## 数据库验证

### 查看用户表
```sql
-- 查看新注册的用户
SELECT id, username, real_name, email, phone, role_id, status 
FROM sys_user 
WHERE username = 'testuser01';
```

**预期结果**：
- ✅ 有一条记录
- ✅ `role_id` 对应借展人角色
- ✅ `status` = 1（启用）
- ✅ 密码已加密（BCrypt格式）

### 查看用户-博物馆关联表
```sql
-- 查看用户与博物馆的关联
SELECT um.*, m.museum_name 
FROM user_museum um
JOIN museum m ON um.museum_id = m.id
WHERE um.user_id = (SELECT id FROM sys_user WHERE username = 'testuser01');
```

**预期结果**：
- ✅ 有一条记录
- ✅ `is_primary` = 1（主博物馆）
- ✅ `museum_id` 正确

### 查看操作日志
```sql
-- 查看注册日志
SELECT * FROM sys_operation_log 
WHERE operation_content LIKE '%注册%' 
ORDER BY create_time DESC 
LIMIT 5;
```

**预期结果**：
- ✅ 有注册成功的日志记录
- ✅ 包含用户名和IP地址

## 登录测试

### 使用新注册的账号登录

1. **访问登录页面**
   - `http://localhost:5173/portal-login`

2. **填写登录信息**
   - 用户名：`testuser01`
   - 密码：`123456`
   - 选择博物馆：选择注册时的博物馆

3. **提交登录**
   - 点击"登录"按钮

4. **验证结果**
   - ✅ 登录成功
   - ✅ 跳转到前台门户页面
   - ✅ 显示用户信息

## 常见问题

### Q1: 注册按钮无响应
**检查**：
- 是否勾选了用户协议
- 是否所有必填项都已填写
- 打开浏览器控制台查看错误信息

### Q2: 提示"用户名已存在"
**解决**：
- 更换一个新的用户名
- 或删除数据库中的测试用户

### Q3: 提示"所选博物馆不存在"
**解决**：
- 检查数据库中是否有启用的博物馆
- 确保 `museum` 表中有 `status = 1` 的记录

### Q4: 提示"借展人角色不存在"
**解决**：
```sql
-- 检查角色表
SELECT * FROM sys_role WHERE role_code = 'LOANER';

-- 如果不存在，插入角色
INSERT INTO sys_role (role_name, role_code, status) 
VALUES ('文物借展人', 'LOANER', 1);
```

### Q5: 注册成功但无法登录
**检查**：
- 用户状态是否为启用（status = 1）
- 角色是否正确设置
- 密码是否正确

## 清理测试数据

```sql
-- 删除测试用户
DELETE FROM user_museum WHERE user_id = (SELECT id FROM sys_user WHERE username = 'testuser01');
DELETE FROM sys_user WHERE username = 'testuser01';

-- 删除测试日志
DELETE FROM sys_operation_log WHERE operation_content LIKE '%testuser01%';
```

## 性能测试

### 并发注册测试
使用工具（如 JMeter）测试并发注册：
- 100个并发用户
- 每个用户注册不同的账号
- 验证数据一致性

### 预期结果
- ✅ 所有注册请求都能正确处理
- ✅ 没有重复的用户名
- ✅ 事务正确回滚

## 相关文档
- 详细功能文档：`docs/LOANER_REGISTRATION_FEATURE.md`
- 更新日志：`CHANGELOG.md`
