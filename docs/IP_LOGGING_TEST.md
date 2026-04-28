# IP地址记录功能测试

## 功能说明

系统会自动记录用户的登录IP地址：
- **登录失败时**：记录到 `last_login_ip`
- **登录成功时**：更新 `last_login_ip` 和 `last_login_time`

## 测试步骤

### 步骤1：清空测试数据

```sql
UPDATE sys_user 
SET 
    login_failed_count = 0,
    account_locked = 0,
    locked_time = NULL,
    last_login_time = NULL,
    last_login_ip = NULL
WHERE username = 'admin';
```

### 步骤2：测试登录失败（记录IP）

**操作**：
1. 打开登录页面
2. 用户名：admin
3. 密码：wrong（错误密码）
4. 点击登录

**验证数据库**：
```sql
SELECT 
    username,
    login_failed_count,
    last_login_ip,
    last_login_time
FROM sys_user 
WHERE username = 'admin';
```

**预期结果**：
- `login_failed_count` = 1
- `last_login_ip` = 你的IP地址（如 127.0.0.1 或 192.168.x.x）
- `last_login_time` = NULL（失败时不更新登录时间）

### 步骤3：测试登录成功（更新IP和时间）

**操作**：
1. 用户名：admin
2. 密码：123456（正确密码）
3. 点击登录

**验证数据库**：
```sql
SELECT 
    username,
    login_failed_count,
    account_locked,
    last_login_ip,
    last_login_time
FROM sys_user 
WHERE username = 'admin';
```

**预期结果**：
- `login_failed_count` = 0（重置为0）
- `account_locked` = 0
- `last_login_ip` = 你的IP地址
- `last_login_time` = 当前时间

### 步骤4：测试多次失败后的IP记录

**操作**：
1. 连续输入3次错误密码

**验证数据库**：
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

**预期结果**：
- `login_failed_count` = 3
- `account_locked` = 1
- `locked_time` = 锁定时间
- `last_login_ip` = 你的IP地址（最后一次失败的IP）

## IP地址获取逻辑

系统按以下顺序获取客户端IP：

1. `X-Forwarded-For` 头（代理服务器）
2. `Proxy-Client-IP` 头
3. `WL-Proxy-Client-IP` 头
4. `HTTP_CLIENT_IP` 头
5. `HTTP_X_FORWARDED_FOR` 头
6. `request.getRemoteAddr()`（直接连接）

## 常见IP地址

| IP地址 | 说明 |
|--------|------|
| 127.0.0.1 | 本地访问（localhost） |
| 0:0:0:0:0:0:0:1 | IPv6本地地址 |
| 192.168.x.x | 局域网地址 |
| 10.x.x.x | 内网地址 |
| 公网IP | 外网访问 |

## 验证查询

### 查看所有用户的IP记录
```sql
SELECT 
    username,
    real_name,
    last_login_time,
    last_login_ip,
    login_failed_count
FROM sys_user
WHERE last_login_ip IS NOT NULL
ORDER BY last_login_time DESC;
```

### 查看特定IP的登录记录
```sql
SELECT 
    username,
    real_name,
    last_login_time,
    login_failed_count,
    account_locked
FROM sys_user
WHERE last_login_ip = '127.0.0.1'
ORDER BY last_login_time DESC;
```

### 统计各IP的登录次数
```sql
SELECT 
    last_login_ip,
    COUNT(*) as user_count,
    GROUP_CONCAT(username) as usernames
FROM sys_user
WHERE last_login_ip IS NOT NULL
GROUP BY last_login_ip
ORDER BY user_count DESC;
```

## 后端日志验证

查看应用日志，应该能看到：

```
WARN - 用户 admin 登录失败，失败次数：1，IP：127.0.0.1
INFO - 用户 admin 登录成功，重置失败次数，IP：127.0.0.1
```

## 故障排查

### 问题1：IP地址是NULL

**可能原因**：
1. 方法签名未更新
2. Controller未传递IP地址
3. 数据库字段不存在

**检查**：
```sql
-- 检查字段是否存在
SHOW COLUMNS FROM sys_user LIKE '%ip%';

-- 检查字段值
SELECT username, last_login_ip FROM sys_user WHERE username = 'admin';
```

### 问题2：IP地址显示为"unknown"

**原因**：旧代码中硬编码了"unknown"

**解决**：
1. 确认已更新 `SysUserService.java` 接口
2. 确认已更新 `SysUserServiceImpl.java` 实现
3. 确认已更新 `AuthController.java` 调用
4. 重启后端服务

### 问题3：IP地址显示为 0:0:0:0:0:0:0:1

**说明**：这是IPv6的本地地址，等同于127.0.0.1

**正常情况**，无需处理。如果需要显示IPv4格式，可以在application.yml中配置：
```yaml
server:
  address: 127.0.0.1
```

## 成功标准

✅ 登录失败时记录IP地址  
✅ 登录成功时更新IP地址和登录时间  
✅ 失败次数重置时保留最后的IP  
✅ 后端日志显示正确的IP  
✅ 数据库字段正确更新  

## 安全建议

### 1. IP白名单
对管理员账户设置IP白名单：
```sql
-- 添加允许的IP列表字段
ALTER TABLE sys_user ADD COLUMN allowed_ips TEXT COMMENT '允许的IP列表，逗号分隔';

-- 设置管理员只能从特定IP登录
UPDATE sys_user 
SET allowed_ips = '127.0.0.1,192.168.1.100' 
WHERE username = 'admin';
```

### 2. 异常IP告警
监控异常IP登录：
- 同一IP短时间内多次失败
- 从未见过的IP登录管理员账户
- 境外IP登录

### 3. IP黑名单
记录恶意IP并自动封禁：
```sql
CREATE TABLE ip_blacklist (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    ip_address VARCHAR(50) NOT NULL,
    reason VARCHAR(200),
    blocked_time DATETIME,
    expire_time DATETIME,
    UNIQUE KEY uk_ip (ip_address)
);
```

## 清理测试数据

```sql
UPDATE sys_user 
SET 
    login_failed_count = 0,
    account_locked = 0,
    locked_time = NULL,
    last_login_time = NULL,
    last_login_ip = NULL
WHERE username = 'admin';
```
