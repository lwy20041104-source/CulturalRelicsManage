# 登录锁定功能问题诊断清单

## 问题现象
- ❌ 密码错误时显示"登录失败，请检查用户名和密码"
- ❌ 没有显示"密码错误，还剩 X 次尝试机会"
- ❌ 3次错误后没有显示"账户已被锁定"

## 诊断步骤

### ✅ 步骤1：检查数据库字段

```sql
-- 执行此SQL
SHOW COLUMNS FROM sys_user LIKE '%login%';
SHOW COLUMNS FROM sys_user LIKE '%lock%';
```

**必须看到以下字段**：
- `login_failed_count`
- `account_locked`
- `locked_time`
- `last_login_time`
- `last_login_ip`

**如果没有这些字段**：
```sql
-- 执行完整设置脚本
source backend/sql/complete_login_lock_setup.sql;
```

---

### ✅ 步骤2：验证字段数据

```sql
SELECT 
    username,
    login_failed_count,
    account_locked,
    locked_time
FROM sys_user 
WHERE username = 'admin';
```

**预期结果**：
- `login_failed_count` 应该是数字（0或其他）
- `account_locked` 应该是 0 或 1
- 不应该是 NULL

**如果是NULL**：
```sql
UPDATE sys_user 
SET login_failed_count = 0, account_locked = 0 
WHERE username = 'admin';
```

---

### ✅ 步骤3：检查后端代码

#### 3.1 检查 SysUserMapper.xml

打开 `backend/src/main/resources/mapper/SysUserMapper.xml`

**必须包含**：
```xml
<resultMap id="BaseResultMap" type="com.example.entity.SysUser">
    <!-- ... 其他字段 ... -->
    <result property="loginFailedCount" column="login_failed_count"/>
    <result property="accountLocked" column="account_locked"/>
    <result property="lockedTime" column="locked_time"/>
    <result property="lastLoginTime" column="last_login_time"/>
    <result property="lastLoginIp" column="last_login_ip"/>
</resultMap>

<sql id="BaseColumns">
    su.id, su.username, ..., 
    su.login_failed_count, su.account_locked, su.locked_time, 
    su.last_login_time, su.last_login_ip
</sql>
```

#### 3.2 检查 GlobalExceptionHandler.java

打开 `backend/src/main/java/com/example/common/GlobalExceptionHandler.java`

**必须是**：
```java
@ExceptionHandler(IllegalArgumentException.class)
@ResponseStatus(HttpStatus.OK)  // 注意：必须是 OK，不是 BAD_REQUEST
public Result<String> handleIllegalArgumentException(IllegalArgumentException e) {
    log.warn("业务异常: {}", e.getMessage());
    return Result.error(e.getMessage());
}
```

---

### ✅ 步骤4：重启后端服务

**非常重要**：修改代码或添加字段后必须重启！

```bash
# 1. 停止后端服务
# 2. 清理编译文件（可选但推荐）
mvn clean

# 3. 重新编译
mvn compile

# 4. 启动服务
```

---

### ✅ 步骤5：测试后端API

使用curl或Postman测试：

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "wrong_password",
    "roleCode": "ADMIN"
  }'
```

**预期响应**：
```json
{
  "code": 500,
  "message": "密码错误，还剩 2 次尝试机会",
  "data": null
}
```

**如果响应是**：
```json
{
  "code": 500,
  "message": "登录失败，请检查用户名和密码",
  "data": null
}
```

说明：
1. 后端没有正确抛出详细错误信息
2. 或者 LoginSecurityService 没有被调用

---

### ✅ 步骤6：检查后端日志

启动后端，尝试登录，查看日志：

**应该看到**：
```
WARN - 用户 admin 登录失败，失败次数：1，IP：127.0.0.1
```

**如果没有这条日志**：
- LoginSecurityService 没有被调用
- 检查 SysUserServiceImpl 是否注入了 LoginSecurityService
- 检查 login 方法是否调用了 loginSecurityService.recordLoginFailure()

---

### ✅ 步骤7：检查前端代码

#### 7.1 检查 request.js

打开 `frontend/src/api/request.js`

**响应拦截器应该是**：
```javascript
request.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response && error.response.data) {
      const customError = new Error(error.response.data.message)
      customError.response = { data: error.response.data }
      return Promise.reject(customError)
    }
    return Promise.reject(error)
  }
)
```

#### 7.2 检查 LoginView.vue

打开 `frontend/src/views/LoginView.vue`

**错误处理应该是**：
```javascript
} catch (e) {
  const msg = e?.response?.data?.message || t('login.loginFailed')
  ElMessage.error(msg)
}
```

---

### ✅ 步骤8：浏览器测试

1. 打开浏览器开发者工具（F12）
2. 切换到 Network 标签
3. 尝试登录（输入错误密码）
4. 查看 login 请求

**检查点**：
- Status: 200 OK
- Response:
  ```json
  {
    "code": 500,
    "message": "密码错误，还剩 2 次尝试机会",
    "data": null
  }
  ```

**如果 message 不对**：
- 后端问题，返回步骤5
- 检查后端日志

**如果前端没有显示**：
- 前端问题，检查步骤7
- 检查浏览器控制台是否有JavaScript错误

---

## 完整测试流程

### 测试1：第一次密码错误

1. 输入用户名：`admin`
2. 输入密码：`wrong`
3. 点击登录

**预期**：
- 前端显示：`密码错误，还剩 2 次尝试机会`
- 数据库：`login_failed_count = 1`

### 测试2：第二次密码错误

1. 再次输入错误密码
2. 点击登录

**预期**：
- 前端显示：`密码错误，还剩 1 次尝试机会`
- 数据库：`login_failed_count = 2`

### 测试3：第三次密码错误

1. 第三次输入错误密码
2. 点击登录

**预期**：
- 前端显示：`密码错误次数过多，账户已被锁定 30 分钟`
- 数据库：`login_failed_count = 3, account_locked = 1`

### 测试4：锁定后尝试登录

1. 输入正确密码：`123456`
2. 点击登录

**预期**：
- 前端显示：`账户已被锁定，请在 30 分钟后重试或联系管理员`
- 无法登录

---

## 快速修复命令

### 重置数据库
```sql
UPDATE sys_user 
SET login_failed_count = 0, account_locked = 0, locked_time = NULL 
WHERE username = 'admin';
```

### 重启后端
```bash
# 停止服务
# mvn clean
# 启动服务
```

### 清除浏览器缓存
```
Ctrl + Shift + Delete
或
Ctrl + F5 强制刷新
```

---

## 常见问题

### Q1: 字段添加了但还是不工作
**A**: 必须重启后端服务！

### Q2: 后端日志没有 WARN 信息
**A**: LoginSecurityService 没有被调用，检查依赖注入

### Q3: 前端显示"登录失败，请检查用户名和密码"
**A**: 
1. 检查后端响应格式（步骤5）
2. 检查 GlobalExceptionHandler（步骤3.2）
3. 检查前端拦截器（步骤7.1）

### Q4: 数据库字段是 NULL
**A**: 执行初始化SQL：
```sql
UPDATE sys_user SET login_failed_count = 0, account_locked = 0;
```

---

## 成功标准

✅ 数据库字段存在且不为NULL  
✅ 后端日志显示登录失败信息  
✅ 后端API返回详细错误信息  
✅ 前端显示剩余尝试次数  
✅ 3次后账户被锁定  
✅ 锁定后显示锁定提示  

---

## 如果还是不工作

请提供以下信息：

1. **数据库查询结果**：
```sql
SELECT * FROM sys_user WHERE username = 'admin';
```

2. **后端日志**（最近50行）

3. **浏览器Network截图**（login请求的Response）

4. **后端代码确认**：
   - SysUserMapper.xml 是否包含新字段
   - GlobalExceptionHandler 的 @ResponseStatus
   - SysUserServiceImpl 是否注入 LoginSecurityService
