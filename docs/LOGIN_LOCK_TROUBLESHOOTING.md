# 登录锁定功能故障排查指南

## 问题现象

1. 密码输错3次后用户没有被锁定
2. 密码错误时没有显示剩余尝试次数提示
3. 仍然可以继续登录

## 排查步骤

### 步骤1：检查数据库字段是否存在

执行以下SQL验证字段：

```sql
-- 查看sys_user表结构
DESC sys_user;

-- 或者使用
SHOW COLUMNS FROM sys_user;
```

**应该看到以下字段**：
- `login_failed_count` (INT)
- `account_locked` (TINYINT)
- `locked_time` (DATETIME)
- `last_login_time` (DATETIME)
- `last_login_ip` (VARCHAR)

**如果字段不存在**，执行以下SQL添加：

```sql
-- 添加登录锁定相关字段
ALTER TABLE sys_user 
ADD COLUMN login_failed_count INT DEFAULT 0 COMMENT '登录失败次数',
ADD COLUMN account_locked TINYINT(1) DEFAULT 0 COMMENT '账户是否锁定：0-未锁定，1-已锁定',
ADD COLUMN locked_time DATETIME NULL COMMENT '账户锁定时间',
ADD COLUMN last_login_time DATETIME NULL COMMENT '最后登录时间',
ADD COLUMN last_login_ip VARCHAR(50) NULL COMMENT '最后登录IP';

-- 为现有用户初始化字段
UPDATE sys_user 
SET login_failed_count = 0, 
    account_locked = 0 
WHERE login_failed_count IS NULL OR account_locked IS NULL;
```

### 步骤2：验证字段数据

```sql
-- 查看所有用户的锁定状态
SELECT 
    id,
    username,
    real_name,
    login_failed_count,
    account_locked,
    locked_time,
    last_login_time,
    last_login_ip,
    status
FROM 
    sys_user;
```

**预期结果**：
- `login_failed_count` 应该是 0
- `account_locked` 应该是 0
- 其他字段可以为 NULL

### 步骤3：重启后端服务

添加字段后，必须重启Spring Boot应用：

```bash
# 停止应用
# 然后重新启动
```

### 步骤4：测试登录锁定功能

#### 测试用例1：密码错误1次

**操作**：
1. 使用正确的用户名
2. 输入错误的密码
3. 点击登录

**预期结果**：
- 返回错误信息：`密码错误，还剩 2 次尝试机会`
- 数据库中 `login_failed_count` = 1

**验证SQL**：
```sql
SELECT username, login_failed_count, account_locked 
FROM sys_user 
WHERE username = 'testuser';
```

#### 测试用例2：密码错误2次

**操作**：
1. 再次输入错误密码

**预期结果**：
- 返回错误信息：`密码错误，还剩 1 次尝试机会`
- 数据库中 `login_failed_count` = 2

#### 测试用例3：密码错误3次（触发锁定）

**操作**：
1. 第三次输入错误密码

**预期结果**：
- 返回错误信息：`密码错误次数过多，账户已被锁定 30 分钟`
- 数据库中：
  - `login_failed_count` = 3
  - `account_locked` = 1
  - `locked_time` = 当前时间

**验证SQL**：
```sql
SELECT 
    username, 
    login_failed_count, 
    account_locked, 
    locked_time,
    TIMESTAMPDIFF(MINUTE, locked_time, NOW()) as minutes_locked
FROM sys_user 
WHERE username = 'testuser';
```

#### 测试用例4：锁定后尝试登录

**操作**：
1. 使用正确的密码尝试登录

**预期结果**：
- 返回错误信息：`账户已被锁定，请在 30 分钟后重试或联系管理员`
- 无法登录

#### 测试用例5：登录成功后重置

**操作**：
1. 输入正确密码登录成功

**预期结果**：
- 登录成功
- 数据库中：
  - `login_failed_count` = 0
  - `account_locked` = 0
  - `locked_time` = NULL
  - `last_login_time` = 当前时间
  - `last_login_ip` = 客户端IP

## 常见问题

### 问题1：字段添加后仍然不生效

**原因**：
- 应用未重启
- MyBatis缓存未刷新

**解决方案**：
1. 完全停止应用
2. 清理target目录：`mvn clean`
3. 重新编译：`mvn compile`
4. 重启应用

### 问题2：提示信息不显示

**原因**：
- 前端未正确处理错误信息
- 后端返回的错误格式不对

**检查方法**：
1. 打开浏览器开发者工具
2. 查看Network标签
3. 检查登录请求的响应

**预期响应**：
```json
{
  "code": 500,
  "message": "密码错误，还剩 2 次尝试机会",
  "data": null
}
```

### 问题3：锁定时间不准确

**原因**：
- 服务器时区设置不正确
- 数据库时区与应用时区不一致

**解决方案**：
1. 检查application.yml中的数据库连接URL
2. 确保包含时区参数：`serverTimezone=UTC` 或 `serverTimezone=Asia/Shanghai`

### 问题4：自动解锁不工作

**原因**：
- 锁定时间字段为NULL
- 时间计算逻辑错误

**验证SQL**：
```sql
SELECT 
    username,
    locked_time,
    TIMESTAMPDIFF(MINUTE, locked_time, NOW()) as minutes_passed,
    CASE 
        WHEN TIMESTAMPDIFF(MINUTE, locked_time, NOW()) >= 30 THEN '应该解锁'
        ELSE '仍在锁定期'
    END as lock_status
FROM sys_user 
WHERE account_locked = 1;
```

## 手动解锁账户

如果需要手动解锁账户：

### 方法1：通过SQL

```sql
-- 解锁指定用户
UPDATE sys_user 
SET 
    account_locked = 0,
    login_failed_count = 0,
    locked_time = NULL
WHERE username = 'testuser';
```

### 方法2：通过API（需要管理员权限）

```bash
curl -X POST "http://localhost:8080/api/users/unlock-by-username?username=testuser" \
  -H "Authorization: Bearer YOUR_ADMIN_TOKEN"
```

### 方法3：通过管理后台

1. 登录管理后台
2. 进入"用户管理"
3. 找到被锁定的用户
4. 点击"解锁"按钮

## 日志检查

查看应用日志，应该能看到类似信息：

```
2026-04-23 17:00:00 - 用户 testuser 登录失败，失败次数：1，IP：192.168.1.100
2026-04-23 17:00:10 - 用户 testuser 登录失败，失败次数：2，IP：192.168.1.100
2026-04-23 17:00:20 - 用户 testuser 登录失败次数达到 3 次，账户已锁定
```

## 完整测试脚本

```sql
-- 1. 准备测试用户
INSERT INTO sys_user (username, password, real_name, status, role_id, create_time, update_time, login_failed_count, account_locked)
VALUES ('testlock', '$2a$10$...', '测试锁定用户', 1, 1, NOW(), NOW(), 0, 0);

-- 2. 模拟登录失败
UPDATE sys_user SET login_failed_count = 1 WHERE username = 'testlock';
UPDATE sys_user SET login_failed_count = 2 WHERE username = 'testlock';
UPDATE sys_user SET login_failed_count = 3, account_locked = 1, locked_time = NOW() WHERE username = 'testlock';

-- 3. 验证锁定状态
SELECT * FROM sys_user WHERE username = 'testlock';

-- 4. 测试自动解锁（模拟30分钟后）
UPDATE sys_user SET locked_time = DATE_SUB(NOW(), INTERVAL 31 MINUTE) WHERE username = 'testlock';

-- 5. 清理测试数据
DELETE FROM sys_user WHERE username = 'testlock';
```

## 配置调整

如需修改锁定策略，编辑 `LoginSecurityService.java`：

```java
// 修改最大失败次数
int MAX_FAILED_ATTEMPTS = 5;  // 改为5次

// 修改锁定时长
int LOCK_DURATION_MINUTES = 60;  // 改为60分钟
```

## 总结

确保完成以下步骤：

1. ✅ 执行SQL添加字段
2. ✅ 验证字段已添加
3. ✅ 更新现有用户数据
4. ✅ 重启应用服务
5. ✅ 测试登录锁定功能
6. ✅ 检查日志输出

如果以上步骤都完成但仍有问题，请检查：
- 应用是否正确连接到数据库
- MyBatis配置是否正确
- 是否有其他异常日志
