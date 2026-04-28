# 快速启用邮件发送（5分钟配置）

## 使用QQ邮箱快速配置

### 第一步：获取QQ邮箱授权码（2分钟）

1. 打开浏览器，访问 https://mail.qq.com
2. 登录你的QQ邮箱
3. 点击顶部的"设置" → "账户"
4. 向下滚动，找到"POP3/IMAP/SMTP/Exchange/CardDAV/CalDAV服务"
5. 点击"开启"按钮（如果已开启则跳过）
6. 按照提示用手机发送短信
7. 发送成功后，页面会显示一个**16位的授权码**（类似：abcdefghijklmnop）
8. **复制并保存这个授权码**（这不是你的QQ密码！）

### 第二步：配置后端（2分钟）

打开文件：`backend/src/main/resources/application.yml`

在文件末尾添加以下配置：

**推荐配置（使用SSL端口465，最稳定）：**

```yaml
spring:
  mail:
    enabled: true  # 启用邮件服务
    host: smtp.qq.com
    port: 465  # 使用SSL端口
    username: 你的QQ邮箱@qq.com  # 例如：123456789@qq.com
    password: 你的16位授权码  # 粘贴刚才复制的授权码
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true
            trust: smtp.qq.com
          socketFactory:
            class: javax.net.ssl.SSLSocketFactory
            port: 465
    default-encoding: UTF-8
```

**备选配置（使用STARTTLS端口587）：**

```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 587
    username: 你的QQ邮箱@qq.com
    password: 你的16位授权码
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          ssl:
            trust: smtp.qq.com
    default-encoding: UTF-8
```

**示例（使用465端口）：**
```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 465
    username: 123456789@qq.com
    password: abcdefghijklmnop
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true
            trust: smtp.qq.com
          socketFactory:
            class: javax.net.ssl.SSLSocketFactory
            port: 465
    default-encoding: UTF-8
```

### 第三步：重启后端服务（1分钟）

1. 停止当前运行的后端服务（Ctrl+C 或点击IDE的停止按钮）
2. 重新启动后端服务

### 第四步：测试（1分钟）

1. 打开前端页面：http://localhost:5173/forgot-password
2. 输入用户名
3. 选择"邮箱验证"
4. 输入你的邮箱地址（必须是数据库中该用户绑定的邮箱）
5. 点击"发送验证码"
6. 检查邮箱（包括垃圾邮件箱），应该会收到一封验证码邮件

## 完成！

现在你的系统可以真实发送邮件了！

## 如果收不到邮件

### 检查1：查看后端日志

看是否有以下日志：
- ✅ "验证码邮件发送成功：xxx@xxx.com"
- ❌ "验证码邮件发送失败"或其他错误信息

### 检查2：确认配置正确

- 邮箱地址是否正确？
- 授权码是否正确？（16位字符）
- 是否使用了授权码而不是QQ密码？

### 检查3：查看垃圾邮件箱

有些邮件服务器可能会将验证码邮件标记为垃圾邮件。

### 检查4：确认数据库中的邮箱

```sql
SELECT username, email FROM sys_user WHERE username = '你的用户名';
```

确保数据库中的邮箱地址与你输入的一致。

## 常见错误

### 错误1：535 Authentication failed

**原因**：授权码错误或未开启SMTP服务

**解决**：
1. 重新获取授权码
2. 确认已开启SMTP服务

### 错误2：Connection timed out

**原因**：网络问题或端口被封

**解决**：
1. 检查网络连接
2. 尝试更换端口为465：
```yaml
spring:
  mail:
    port: 465
    properties:
      mail:
        smtp:
          ssl:
            enable: true
```

## 使用163邮箱

如果你想使用163邮箱，配置如下：

```yaml
spring:
  mail:
    enabled: true
    host: smtp.163.com
    port: 465
    username: 你的163邮箱@163.com
    password: 你的授权码
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true
    default-encoding: UTF-8
```

获取163邮箱授权码：
1. 登录 https://mail.163.com
2. 设置 → POP3/SMTP/IMAP
3. 开启SMTP服务
4. 获取授权码

## 短信服务配置

如果你也想启用短信发送，请参考：`docs/EMAIL_SMS_CONFIGURATION_GUIDE.md`

短信服务需要：
1. 注册阿里云账号
2. 开通短信服务
3. 申请短信签名和模板（需要审核1-2天）
4. 充值（约0.045元/条）

## 安全提示

⚠️ **重要**：不要将包含真实邮箱密码/授权码的配置文件提交到Git！

建议：
1. 将邮件配置放在独立文件 `application-mail-sms.yml`
2. 在 `.gitignore` 中添加该文件
3. 或使用环境变量

## 需要帮助？

如果遇到问题，请查看：
- 详细配置指南：`docs/EMAIL_SMS_CONFIGURATION_GUIDE.md`
- 测试指南：`docs/PASSWORD_RESET_TEST_GUIDE.md`
