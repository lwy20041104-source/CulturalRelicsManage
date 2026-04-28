# 登录锁定功能测试指南

## 前置条件

### 1. 执行数据库脚本

```bash
# 进入MySQL
mysql -u root -p

# 选择数据库
use cultural_relics;

# 执行快速修复脚本
source backend/sql/quick_fix_login_lock.sql;
```

或者直接执行：

```sql
ALTER TABLE sys_user 
ADD COLUMN login_failed_count INT DEFAULT 0 COMMENT '登录失败次数',
ADD COLUMN account_locked TINYINT(1) DEFAULT 0 COMMENT '账户是否锁定：0-未锁定，1-已锁定',
ADD COLUMN locked_time DATETIME NULL COMMENT '账户锁定时间',
ADD COLUMN last_login_time DATETIME NULL COMMENT '最后登录时间',
ADD COLUMN last_login_ip VARCHAR(50) NULL COMMENT '最后登录IP';

UPDATE sys_user 
SET login_failed_count = 0, account_locked = 0 
WHERE login_failed_count IS NULL OR account_locked IS NULL;
```

### 2. 重启后端服务

**重要**：添加字段后必须重启Spring Boot应用！

```bash
# 停止应用
# 重新启动应用
```

### 3. 验证字段

```sql
-- 查看表结构
DESC sys_user;

-- 应该看到以下字段：
-- login_failed_count
-- account_locked
-- locked_time
-- last_login_time
-- last_login_ip
```

## 测试步骤

### 测试1：第一次密码错误

**操作**：
1. 打开前端登录页面
2. 用户名：`admin`
3. 密码：`wrong_password`（故意输错）
4. 点击登录

**预期结果**：
- 显示错误提示：`密码错误，还剩 2 次尝试机会`
- 无法登录

**验证数据库**：
```sql
SELECT username, login_failed_count, account_locked 
FROM sys_user 
WHERE username = 'admin';
```
应该显示：`login_failed_count = 1, account_locked = 0`

---

### 测试2：第二次密码错误

**操作**：
1. 再次输入错误密码
2. 点击登录

**预期结果**：
- 显示错误提示：`密码错误，还剩 1 次尝试机会`

**验证数据库**：
```sql
SELECT username, login_failed_count, account_locked 
FROM sys_user 
WHERE username = 'admin';
```
应该显示：`login_failed_count = 2, account_locked = 0`

---

### 测试3：第三次密码错误（触发锁定）

**操作**：
1. 第三次输入错误密码
2. 点击登录

**预期结果**：
- 显示错误提示：`密码错误次数过多，账户已被锁定 30 分钟`

**验证数据库**：
```sql
SELECT 
    username, 
    login_failed_count, 
    account_locked, 
    locked_time 
FROM sys_user 
WHERE username = 'admin';
```
应该显示：
- `login_failed_count = 3`
- `account_locked = 1`
- `locked_time = 当前时间`

---

### 测试4：锁定期间尝试登录

**操作**：
1. 输入正确密码：`123456`
2. 点击登录

**预期结果**：
- 显示错误提示：`账户已被锁定，请在 30 分钟后重试或联系管理员`
- 仍然无法登录

---

### 测试5：手动解锁

**操作**：
执行SQL解锁账户：
```sql
UPDATE sys_user 
SET 
    account_locked = 0,
    login_failed_count = 0,
    locked_time = NULL
WHERE username = 'admin';
```

**验证**：
1. 输入正确密码登录
2. 应该能成功登录

**验证数据库**：
```sql
SELECT 
    username, 
    login_failed_count, 
    account_locked, 
    last_login_time,
    last_login_ip
FROM sys_user 
WHERE username = 'admin';
```
应该显示：
- `login_failed_count = 0`
- `account_locked = 0`
- `last_login_time = 刚才登录的时间`
- `last_login_ip = 你的IP地址`

---

### 测试6：登录成功后重置

**操作**：
1. 先输入2次错误密码
2. 然后输入正确密码登录

**预期结果**：
- 登录成功
- 失败次数自动重置为0

**验证数据库**：
```sql
SELECT username, login_failed_count, account_locked 
FROM sys_user 
WHERE username = 'admin';
```
应该显示：`login_failed_count = 0, account_locked = 0`

---

## 故障排查

### 问题：提示信息不显示

**检查1：浏览器控制台**
1. 按F12打开开发者工具
2. 切换到Network标签
3. 尝试登录
4. 查看login请求的响应

**正确的响应格式**：
```json
{
  "code": 500,
  "message": "密码错误，还剩 2 次尝试机会",
  "data": null
}
```

**检查2：后端日志**
查看应用日志，应该有类似输出：
```
WARN - 用户 admin 登录失败，失败次数：1，IP：127.0.0.1
WARN - 用户 admin 登录失败，失败次数：2，IP：127.0.0.1
ERROR - 用户 admin 登录失败次数达到 3 次，账户已锁定
```

### 问题：字段值没有更新

**检查1：字段是否存在**
```sql
SHOW COLUMNS FROM sys_user LIKE '%login%';
SHOW COLUMNS FROM sys_user LIKE '%lock%';
```

**检查2：MyBatis Mapper是否更新**
确认 `SysUserMapper.xml` 中：
- `BaseResultMap` 包含新字段
- `BaseColumns` 包含新字段
- `updateById` 支持更新新字段

**检查3：应用是否重启**
添加字段后必须重启应用！

### 问题：锁定后仍能登录

**可能原因**：
1. 数据库字段未添加
2. 应用未重启
3. 缓存问题

**解决方案**：
```bash
# 1. 停止应用
# 2. 清理编译文件
mvn clean

# 3. 重新编译
mvn compile

# 4. 重启应用
```

## 清理测试数据

测试完成后，重置admin账户：

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

## 成功标准

✅ 密码错误时显示剩余尝试次数  
✅ 3次错误后账户被锁定  
✅ 锁定后无法登录（即使密码正确）  
✅ 数据库字段正确更新  
✅ 登录成功后失败次数重置  
✅ 后端日志正确记录  

## 注意事项

1. **测试前备份数据**：避免误操作影响生产数据
2. **使用测试账户**：不要用重要账户测试
3. **记录测试结果**：便于问题追踪
4. **及时解锁**：测试完成后解锁账户

## 联系支持

如果按照以上步骤仍无法解决问题，请提供：
1. 数据库表结构截图
2. 后端日志
3. 前端Network请求响应
4. 具体的错误信息
