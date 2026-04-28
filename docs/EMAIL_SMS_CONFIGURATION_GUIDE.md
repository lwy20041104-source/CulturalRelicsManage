# 邮件和短信服务配置指南

## 概述

本系统支持通过邮件和短信发送验证码。默认情况下，邮件和短信服务是禁用的（会在日志中模拟发送）。要启用真实的邮件和短信发送功能，需要进行以下配置。

## 一、邮件服务配置

### 1. QQ邮箱配置（推荐用于测试）

#### 步骤1：获取QQ邮箱授权码

1. 登录QQ邮箱：https://mail.qq.com
2. 点击"设置" → "账户"
3. 找到"POP3/IMAP/SMTP/Exchange/CardDAV/CalDAV服务"
4. 开启"POP3/SMTP服务"或"IMAP/SMTP服务"
5. 按照提示发送短信，获取授权码（16位字符）
6. **重要**：授权码不是QQ密码，是一个16位的随机字符串

#### 步骤2：配置application.yml

在 `backend/src/main/resources/application.yml` 中添加：

```yaml
spring:
  mail:
    enabled: true  # 启用邮件服务
    host: smtp.qq.com
    port: 587
    username: your-qq-email@qq.com  # 替换为你的QQ邮箱
    password: your-authorization-code  # 替换为授权码
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
    default-encoding: UTF-8
```

#### 步骤3：测试邮件发送

重启后端服务，尝试发送验证码，检查邮箱是否收到。

### 2. 163邮箱配置

#### 步骤1：获取163邮箱授权码

1. 登录163邮箱：https://mail.163.com
2. 点击"设置" → "POP3/SMTP/IMAP"
3. 开启"SMTP服务"
4. 按照提示获取授权码

#### 步骤2：配置application.yml

```yaml
spring:
  mail:
    enabled: true
    host: smtp.163.com
    port: 465
    username: your-email@163.com
    password: your-authorization-code
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true
          socketFactory:
            class: javax.net.ssl.SSLSocketFactory
    default-encoding: UTF-8
```

### 3. Gmail配置

#### 步骤1：创建应用专用密码

1. 登录Google账户：https://myaccount.google.com
2. 选择"安全性"
3. 启用"两步验证"
4. 在"两步验证"下找到"应用专用密码"
5. 生成新的应用专用密码

#### 步骤2：配置application.yml

```yaml
spring:
  mail:
    enabled: true
    host: smtp.gmail.com
    port: 587
    username: your-email@gmail.com
    password: your-app-password
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
    default-encoding: UTF-8
```

### 4. 企业邮箱配置

如果使用企业邮箱（如阿里云企业邮箱、腾讯企业邮箱），请联系邮箱管理员获取SMTP配置信息。

## 二、短信服务配置（阿里云短信）

### 1. 注册阿里云账号

访问：https://www.aliyun.com

### 2. 开通短信服务

1. 登录阿里云控制台
2. 搜索"短信服务"
3. 开通短信服务（可能需要实名认证）

### 3. 创建AccessKey

1. 访问：https://ram.console.aliyun.com/manage/ak
2. 点击"创建AccessKey"
3. 记录AccessKey ID和AccessKey Secret（只显示一次，请妥善保管）

### 4. 申请短信签名

1. 进入短信服务控制台：https://dysms.console.aliyun.com/
2. 点击"国内消息" → "签名管理" → "添加签名"
3. 填写签名信息（如：文物管理系统）
4. 提交审核（通常1-2个工作日）

### 5. 申请短信模板

1. 点击"模板管理" → "添加模板"
2. 选择模板类型：验证码
3. 填写模板内容，例如：
   ```
   您的验证码是${code}，有效期${expire}分钟，请勿泄露给他人。
   ```
4. 提交审核（通常1-2个工作日）
5. 审核通过后，记录模板CODE（如：SMS_123456789）

### 6. 配置application.yml

```yaml
aliyun:
  sms:
    enabled: true  # 启用短信服务
    access-key-id: your-access-key-id  # 替换为你的AccessKey ID
    access-key-secret: your-access-key-secret  # 替换为你的AccessKey Secret
    sign-name: 文物管理系统  # 替换为你的短信签名
    template-code: SMS_123456789  # 替换为你的模板CODE
```

### 7. 测试短信发送

重启后端服务，尝试发送验证码，检查手机是否收到。

## 三、配置文件管理

### 推荐方式：使用独立配置文件

为了安全起见，建议将邮件和短信配置放在独立的配置文件中，不提交到Git仓库。

#### 步骤1：创建配置文件

复制示例文件：
```bash
cd backend/src/main/resources
cp application-mail-sms.yml.example application-mail-sms.yml
```

#### 步骤2：编辑配置文件

编辑 `application-mail-sms.yml`，填入真实的配置信息。

#### 步骤3：激活配置

在 `application.yml` 中添加：
```yaml
spring:
  profiles:
    include: mail-sms
```

#### 步骤4：添加到.gitignore

确保 `application-mail-sms.yml` 不被提交到Git：
```
# .gitignore
backend/src/main/resources/application-mail-sms.yml
```

## 四、测试验证

### 1. 测试邮件发送

```bash
curl -X POST http://localhost:8080/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "verificationType": "EMAIL",
    "email": "test@example.com"
  }'
```

检查：
- 后端日志是否显示"验证码邮件发送成功"
- 邮箱是否收到验证码邮件

### 2. 测试短信发送

```bash
curl -X POST http://localhost:8080/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "verificationType": "PHONE",
    "phone": "13800138000"
  }'
```

检查：
- 后端日志是否显示"验证码短信发送成功"
- 手机是否收到验证码短信

## 五、常见问题

### Q1: 邮件发送失败，提示"535 Authentication failed"

**A:** 
1. 检查邮箱用户名和密码是否正确
2. 确认使用的是授权码，不是登录密码
3. 检查是否开启了SMTP服务

### Q2: 邮件发送失败，提示"Connection timed out"

**A:**
1. 检查网络连接
2. 检查SMTP端口是否正确
3. 尝试更换端口（587或465）
4. 检查防火墙设置

### Q3: 短信发送失败，提示"InvalidAccessKeyId"

**A:**
1. 检查AccessKey ID是否正确
2. 检查AccessKey是否已启用
3. 确认AccessKey有短信发送权限

### Q4: 短信发送失败，提示"isv.BUSINESS_LIMIT_CONTROL"

**A:**
1. 检查短信余额是否充足
2. 检查是否超过发送频率限制
3. 检查手机号是否在黑名单中

### Q5: 收不到邮件

**A:**
1. 检查垃圾邮件箱
2. 检查邮箱地址是否正确
3. 检查邮件服务器日志

### Q6: 收不到短信

**A:**
1. 检查手机号是否正确
2. 检查手机信号是否正常
3. 检查是否被运营商拦截
4. 查看阿里云短信发送记录

## 六、安全建议

### 1. 保护配置信息

- ❌ 不要将邮箱密码、AccessKey等敏感信息提交到Git
- ✅ 使用环境变量或独立配置文件
- ✅ 在生产环境使用密钥管理服务

### 2. 限制发送频率

建议添加以下限制：
- 同一用户：1分钟内只能发送1次
- 同一IP：1分钟内最多发送5次
- 同一手机号/邮箱：1小时内最多发送10次

### 3. 监控发送情况

- 记录所有发送日志
- 监控发送成功率
- 设置异常告警

### 4. 成本控制

- 短信服务按条收费，注意成本控制
- 设置每日发送上限
- 定期检查账户余额

## 七、开发环境配置示例

### 完整的application.yml配置

```yaml
spring:
  # 邮件配置
  mail:
    enabled: true
    host: smtp.qq.com
    port: 587
    username: your-email@qq.com
    password: your-authorization-code
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
    default-encoding: UTF-8

# 阿里云短信配置
aliyun:
  sms:
    enabled: true
    access-key-id: LTAI5tXXXXXXXXXXXXXX
    access-key-secret: your-secret-key
    sign-name: 文物管理系统
    template-code: SMS_123456789
```

## 八、生产环境配置建议

### 1. 使用环境变量

```yaml
spring:
  mail:
    enabled: true
    host: ${MAIL_HOST:smtp.qq.com}
    port: ${MAIL_PORT:587}
    username: ${MAIL_USERNAME}
    password: ${MAIL_PASSWORD}

aliyun:
  sms:
    enabled: true
    access-key-id: ${ALIYUN_ACCESS_KEY_ID}
    access-key-secret: ${ALIYUN_ACCESS_KEY_SECRET}
    sign-name: ${ALIYUN_SMS_SIGN_NAME}
    template-code: ${ALIYUN_SMS_TEMPLATE_CODE}
```

### 2. 使用配置中心

如果使用Spring Cloud Config或Nacos等配置中心，将敏感配置存储在配置中心。

### 3. 使用密钥管理服务

如阿里云KMS、AWS Secrets Manager等。

## 九、费用说明

### 邮件服务

- QQ邮箱、163邮箱：免费（有发送频率限制）
- 企业邮箱：根据套餐不同
- 第三方邮件服务（如SendGrid、阿里云邮件推送）：按量收费

### 短信服务（阿里云）

- 验证码短信：约0.045元/条
- 需要预充值
- 建议充值100元起步

## 十、总结

1. **开发测试阶段**：使用QQ邮箱或163邮箱即可，免费且配置简单
2. **生产环境**：建议使用企业邮箱和阿里云短信服务
3. **安全第一**：保护好配置信息，不要泄露到公开仓库
4. **成本控制**：添加发送频率限制，避免被恶意利用

配置完成后，重启后端服务，密码重置功能就能真实发送邮件和短信了！
