# 前端错误信息显示修复说明

## 问题描述

前端登录时，无论后端返回什么错误信息，都显示：
- "登录失败，请检查用户名和密码"

而不是后端返回的详细信息：
- "密码错误，还剩 2 次尝试机会"
- "账户已被锁定，请在 30 分钟后重试或联系管理员"

## 问题原因

后端返回的响应格式：
```json
{
  "code": 500,
  "message": "密码错误，还剩 2 次尝试机会",
  "data": null
}
```

HTTP状态码是 **200 OK**，但业务状态码 `code` 是 **500**。

原来的前端响应拦截器只检查HTTP状态码，认为200就是成功，直接返回了data，没有检查业务状态码。

## 修复方案

### 修改 `frontend/src/api/request.js`

**修改前**：
```javascript
request.interceptors.response.use(
  response => response.data,  // 直接返回，不检查业务状态码
  error => Promise.reject(error)
)
```

**修改后**：
```javascript
request.interceptors.response.use(
  response => {
    const data = response.data
    
    // 检查业务状态码
    if (data.code && data.code !== 200) {
      // 业务失败，抛出错误
      const error = new Error(data.message || '请求失败')
      error.response = { data: data }
      return Promise.reject(error)
    }
    
    // 业务成功，返回data
    return data
  },
  error => {
    // HTTP错误处理
    if (error.response && error.response.data) {
      const customError = new Error(error.response.data.message)
      customError.response = { data: error.response.data }
      return Promise.reject(customError)
    }
    return Promise.reject(error)
  }
)
```

### 添加调试日志

在 `LoginView.vue` 和 `PortalLoginView.vue` 的 catch 块中添加：

```javascript
} catch (e) {
  console.log('登录错误对象:', e)
  console.log('错误响应:', e?.response)
  console.log('错误数据:', e?.response?.data)
  console.log('错误消息:', e?.response?.data?.message)
  
  let msg = e?.response?.data?.message 
         || e?.message 
         || e?.data?.message
         || t('login.loginFailed')
  
  console.log('最终显示的消息:', msg)
  ElMessage.error(msg)
}
```

## 测试步骤

### 1. 清除浏览器缓存
```
Ctrl + Shift + Delete
或
Ctrl + F5 强制刷新
```

### 2. 打开开发者工具
按 F12，切换到 Console 标签

### 3. 测试密码错误（第1次）

**操作**：
- 用户名：admin
- 密码：wrong
- 点击登录

**预期**：
- Console显示：
  ```
  登录错误对象: Error: 密码错误，还剩 2 次尝试机会
  错误响应: {data: {code: 500, message: "密码错误，还剩 2 次尝试机会", data: null}}
  错误数据: {code: 500, message: "密码错误，还剩 2 次尝试机会", data: null}
  错误消息: 密码错误，还剩 2 次尝试机会
  最终显示的消息: 密码错误，还剩 2 次尝试机会
  ```
- 页面显示红色提示：**密码错误，还剩 2 次尝试机会**

### 4. 测试密码错误（第2次）

**操作**：
- 再次输入错误密码
- 点击登录

**预期**：
- 页面显示：**密码错误，还剩 1 次尝试机会**

### 5. 测试密码错误（第3次）

**操作**：
- 第三次输入错误密码
- 点击登录

**预期**：
- 页面显示：**密码错误次数过多，账户已被锁定 30 分钟**

### 6. 测试账户锁定

**操作**：
- 输入正确密码：123456
- 点击登录

**预期**：
- 页面显示：**账户已被锁定，请在 30 分钟后重试或联系管理员**

## 故障排查

### 问题1：仍然显示"登录失败，请检查用户名和密码"

**检查1：Console日志**
查看Console中的日志输出：

如果显示：
```
错误消息: undefined
最终显示的消息: 登录失败，请检查用户名和密码
```

说明 `e?.response?.data?.message` 是 undefined。

**检查2：Network请求**
1. 切换到 Network 标签
2. 查看 login 请求
3. 点击查看 Response

应该看到：
```json
{
  "code": 500,
  "message": "密码错误，还剩 2 次尝试机会",
  "data": null
}
```

如果Response正确但前端仍然获取不到，说明响应拦截器有问题。

**检查3：确认代码已更新**
1. 确认 `request.js` 已修改
2. 清除浏览器缓存
3. 强制刷新页面（Ctrl + F5）
4. 重新测试

### 问题2：Console没有日志输出

说明代码没有更新或浏览器缓存了旧代码。

**解决方案**：
1. 停止前端开发服务器
2. 删除 `node_modules/.vite` 缓存目录
3. 重新启动：`npm run dev`
4. 清除浏览器缓存
5. 强制刷新页面

### 问题3：后端返回的message是空的

**检查后端日志**：
应该看到类似日志：
```
WARN - 用户 admin 登录失败，失败次数：1，IP：127.0.0.1
```

**检查数据库**：
```sql
SELECT username, login_failed_count, account_locked 
FROM sys_user 
WHERE username = 'admin';
```

如果 `login_failed_count` 没有增加，说明后端功能没有正常工作。

## 验证成功的标准

✅ Console显示完整的错误对象  
✅ Console显示正确的错误消息  
✅ 页面显示详细的错误提示  
✅ 第1次错误：显示"还剩 2 次"  
✅ 第2次错误：显示"还剩 1 次"  
✅ 第3次错误：显示"已被锁定 30 分钟"  
✅ 锁定后：显示"账户已被锁定"  

## 清理测试数据

测试完成后，重置admin账户：

```sql
UPDATE sys_user 
SET 
    login_failed_count = 0,
    account_locked = 0,
    locked_time = NULL
WHERE username = 'admin';
```

## 移除调试日志（生产环境）

测试通过后，可以移除Console日志：

```javascript
} catch (e) {
  // 移除所有 console.log
  const msg = e?.response?.data?.message 
           || e?.message 
           || t('login.loginFailed')
  ElMessage.error(msg)
}
```

## 总结

核心修复点：
1. **响应拦截器检查业务状态码** - 不仅检查HTTP状态码，还要检查 `data.code`
2. **错误对象结构保持一致** - 确保 `error.response.data` 包含完整的响应数据
3. **多层级错误信息获取** - 尝试多种方式获取错误信息

修复后，前端能正确显示后端返回的所有错误信息，包括登录锁定的详细提示。
