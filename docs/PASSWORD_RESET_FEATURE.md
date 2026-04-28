# 密码重置功能文档

## 功能概述

本系统实现了完整的密码重置功能，用户可以通过绑定的邮箱或手机号来重置忘记的密码。

## 功能特性

### 1. 验证方式
- **邮箱验证**：通过用户绑定的邮箱接收验证码
- **手机验证**：通过用户绑定的手机号接收验证码

### 2. 安全机制
- **联系方式验证**：必须输入与账户绑定的邮箱或手机号，不匹配则无法发送验证码
- **验证码有效期**：验证码有效期为15分钟
- **一次性使用**：验证码使用后自动标记为已使用，不可重复使用
- **账户解锁**：密码重置成功后，自动解除账户锁定状态

### 3. 用户体验
- **掩码显示**：
  - 邮箱：显示前2位和@后面的域名（如：ab***@example.com）
  - 手机号：显示前3位和后4位（如：138****5678）
- **友好提示**：每个步骤都有清晰的提示信息
- **自动跳转**：密码重置成功后自动跳转到登录页面

## 数据库设计

### verification_code 表

```sql
CREATE TABLE verification_code (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    code VARCHAR(10) NOT NULL COMMENT '验证码',
    type VARCHAR(20) NOT NULL COMMENT '验证类型：EMAIL-邮箱，PHONE-手机',
    contact VARCHAR(100) NOT NULL COMMENT '联系方式（邮箱或手机号）',
    purpose VARCHAR(50) NOT NULL COMMENT '用途：RESET_PASSWORD-重置密码',
    used TINYINT DEFAULT 0 COMMENT '是否已使用：0-未使用，1-已使用',
    expire_time DATETIME NOT NULL COMMENT '过期时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_username (username),
    INDEX idx_code (code),
    INDEX idx_expire_time (expire_time)
);
```

## 后端实现

### 1. 核心类

#### PasswordResetService
- `sendVerificationCode(ForgotPasswordRequest)` - 发送验证码
- `verifyCode(String username, String code)` - 验证验证码
- `resetPassword(ResetPasswordRequest)` - 重置密码

#### AuthController
- `POST /auth/forgot-password` - 发送验证码
- `POST /auth/verify-code` - 验证验证码
- `POST /auth/reset-password` - 重置密码

### 2. DTO类

#### ForgotPasswordRequest
```java
{
    "username": "用户名",
    "verificationType": "EMAIL 或 PHONE",
    "email": "邮箱地址（EMAIL验证时必填）",
    "phone": "手机号（PHONE验证时必填）"
}
```

#### ResetPasswordRequest
```java
{
    "username": "用户名",
    "code": "验证码",
    "newPassword": "新密码",
    "confirmPassword": "确认密码"
}
```

### 3. 业务流程

#### 发送验证码流程
1. 验证用户是否存在
2. 验证联系方式是否与账户绑定的信息匹配
3. 生成6位数字验证码
4. 删除该用户之前的验证码（防止重复）
5. 保存验证码到数据库（设置15分钟有效期）
6. 发送验证码到邮箱或手机
7. 返回掩码后的联系方式

#### 重置密码流程
1. 验证两次密码是否一致
2. 验证验证码是否有效（未过期、未使用）
3. 更新用户密码（BCrypt加密）
4. 重置登录安全字段（失败次数、锁定状态）
5. 标记验证码为已使用
6. 记录操作日志

## 前端实现

### 1. 页面路由

- `/forgot-password` - 忘记密码页面（输入用户名和选择验证方式）
- `/reset-password` - 重置密码页面（输入验证码和新密码）

### 2. 用户流程

1. **忘记密码页面**
   - 输入用户名
   - 选择验证方式（邮箱或手机）
   - 输入对应的联系方式
   - 点击"发送验证码"
   - 系统验证后发送验证码并跳转到重置密码页面

2. **重置密码页面**
   - 显示用户名（禁用状态）
   - 输入收到的6位验证码
   - 输入新密码
   - 再次输入新密码确认
   - 点击"重置密码"
   - 成功后自动跳转到登录页面

### 3. 表单验证

- 用户名：必填
- 验证方式：必选
- 邮箱：必填，格式验证
- 手机号：必填，11位数字，1开头
- 验证码：必填，6位数字
- 新密码：必填，最少6位
- 确认密码：必填，必须与新密码一致

## API接口

### 1. 发送验证码

**请求**
```http
POST /auth/forgot-password
Content-Type: application/json

{
    "username": "testuser",
    "verificationType": "EMAIL",
    "email": "test@example.com"
}
```

**响应**
```json
{
    "code": 200,
    "message": "验证码已发送到您的邮箱：te***@example.com",
    "data": "验证码已发送到您的邮箱：te***@example.com"
}
```

### 2. 验证验证码

**请求**
```http
POST /auth/verify-code?username=testuser&code=123456
```

**响应**
```json
{
    "code": 200,
    "message": "验证码正确",
    "data": true
}
```

### 3. 重置密码

**请求**
```http
POST /auth/reset-password
Content-Type: application/json

{
    "username": "testuser",
    "code": "123456",
    "newPassword": "newpass123",
    "confirmPassword": "newpass123"
}
```

**响应**
```json
{
    "code": 200,
    "message": "密码重置成功，请使用新密码登录",
    "data": true
}
```

## 注意事项

### 1. 邮件和短信服务

当前实现中，邮件和短信发送功能为**模拟实现**，仅在日志中输出验证码。

**生产环境需要集成实际服务：**

#### 邮件服务集成示例（JavaMail）
```java
// 添加依赖
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>

// 配置
spring.mail.host=smtp.example.com
spring.mail.port=587
spring.mail.username=your-email@example.com
spring.mail.password=your-password

// 代码
@Autowired
private JavaMailSender mailSender;

SimpleMailMessage message = new SimpleMailMessage();
message.setTo(email);
message.setSubject("密码重置验证码");
message.setText("您的验证码是：" + code + "，有效期15分钟。");
mailSender.send(message);
```

#### 短信服务集成示例（阿里云短信）
```java
// 添加依赖
<dependency>
    <groupId>com.aliyun</groupId>
    <artifactId>dysmsapi20170525</artifactId>
    <version>2.0.24</version>
</dependency>

// 配置
aliyun.sms.access-key-id=your-access-key-id
aliyun.sms.access-key-secret=your-access-key-secret
aliyun.sms.sign-name=your-sign-name
aliyun.sms.template-code=your-template-code

// 代码实现略
```

### 2. 安全建议

1. **频率限制**：建议添加验证码发送频率限制（如：同一用户1分钟内只能发送1次）
2. **IP限制**：建议添加IP级别的频率限制，防止恶意攻击
3. **验证码复杂度**：当前为6位数字，可根据安全需求调整
4. **有效期**：当前为15分钟，可根据实际需求调整
5. **日志记录**：所有密码重置操作都会记录到操作日志表

### 3. 测试建议

1. **正常流程测试**
   - 邮箱验证流程
   - 手机验证流程
   - 密码重置成功

2. **异常情况测试**
   - 用户不存在
   - 联系方式不匹配
   - 验证码错误
   - 验证码过期
   - 验证码已使用
   - 两次密码不一致

3. **安全测试**
   - 验证码暴力破解
   - 重复发送验证码
   - 账户锁定后重置密码

## 操作日志

系统会自动记录以下操作：

1. **发送验证码**
   - 操作人：用户名
   - 操作类型：忘记密码
   - 操作模块：系统认证
   - 操作内容：发送验证码：EMAIL/PHONE
   - 操作结果：成功/失败
   - IP地址：自动记录

2. **重置密码**
   - 操作人：用户名
   - 操作类型：重置密码
   - 操作模块：系统认证
   - 操作内容：密码重置成功
   - 操作结果：成功/失败
   - IP地址：自动记录

## 更新日志

### 2026-04-23
- ✅ 创建 verification_code 表
- ✅ 实现 PasswordResetService 服务
- ✅ 添加 AuthController 密码重置接口
- ✅ 创建前端忘记密码页面
- ✅ 创建前端重置密码页面
- ✅ 更新路由配置
- ✅ 在登录页面添加"忘记密码"链接
- ✅ 添加操作日志记录
- ✅ 实现账户自动解锁功能

## 待完成事项

- [ ] 集成实际的邮件服务
- [ ] 集成实际的短信服务
- [ ] 添加验证码发送频率限制
- [ ] 添加IP级别的频率限制
- [ ] 添加验证码发送记录统计
- [ ] 完善错误处理和用户提示
