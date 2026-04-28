# 测试登录响应格式

## 使用curl测试

### 测试1：密码错误（第1次）

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

### 测试2：密码错误（第2次）

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
  "message": "密码错误，还剩 1 次尝试机会",
  "data": null
}
```

### 测试3：密码错误（第3次，触发锁定）

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
  "message": "密码错误次数过多，账户已被锁定 30 分钟",
  "data": null
}
```

### 测试4：账户已锁定

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "123456",
    "roleCode": "ADMIN"
  }'
```

**预期响应**：
```json
{
  "code": 500,
  "message": "账户已被锁定，请在 30 分钟后重试或联系管理员",
  "data": null
}
```

## 使用Postman测试

1. 创建新的POST请求
2. URL: `http://localhost:8080/api/auth/login`
3. Headers: `Content-Type: application/json`
4. Body (raw JSON):
```json
{
  "username": "admin",
  "password": "wrong_password",
  "roleCode": "ADMIN"
}
```

## 检查数据库

每次测试后检查数据库：

```sql
SELECT 
    username,
    login_failed_count,
    account_locked,
    locked_time,
    last_login_ip
FROM sys_user 
WHERE username = 'admin';
```

## 重置测试环境

```sql
UPDATE sys_user 
SET 
    login_failed_count = 0,
    account_locked = 0,
    locked_time = NULL
WHERE username = 'admin';
```

## 查看后端日志

启动后端时，应该能看到类似日志：

```
WARN - 用户 admin 登录失败，失败次数：1，IP：127.0.0.1
WARN - 用户 admin 登录失败，失败次数：2，IP：127.0.0.1
ERROR - 用户 admin 登录失败次数达到 3 次，账户已锁定
```

## 前端浏览器测试

1. 打开浏览器开发者工具（F12）
2. 切换到 Network 标签
3. 尝试登录
4. 查看 login 请求的响应

**检查点**：
- Status Code: 应该是 200 OK（即使登录失败）
- Response Body: 应该包含 `{code: 500, message: "密码错误，还剩 X 次尝试机会"}`

## 如果响应格式不对

### 检查1：GlobalExceptionHandler

确认 `GlobalExceptionHandler.java` 中：
```java
@ExceptionHandler(IllegalArgumentException.class)
@ResponseStatus(HttpStatus.OK)  // 必须是 OK，不是 BAD_REQUEST
public Result<String> handleIllegalArgumentException(IllegalArgumentException e) {
    log.warn("业务异常: {}", e.getMessage());
    return Result.error(e.getMessage());
}
```

### 检查2：AuthController

确认 `AuthController.java` 的 login 方法正确捕获异常：
```java
} catch (IllegalArgumentException e) {
    operationResult = "失败";
    return Result.error(e.getMessage());  // 直接返回错误信息
}
```

### 检查3：前端拦截器

确认 `frontend/src/api/request.js` 正确处理错误：
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
