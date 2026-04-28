# 邮件SSL证书问题解决方案

## 问题描述

发送邮件时出现以下错误：
```
Could not convert socket to TLS
SSLHandshakeException: unable to find valid certification path to requested target
```

这是Java邮件发送时的SSL/TLS证书验证问题。

## 解决方案

### 方案1：添加SSL信任配置（推荐）

修改 `application.yml`：

```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 587
    username: 你的QQ邮箱@qq.com
    password: 你的授权码
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          ssl:
            trust: smtp.qq.com  # 添加这行，信任QQ邮箱服务器
        debug: true  # 开启调试，查看详细日志
    default-encoding: UTF-8
```

### 方案2：使用SSL端口465（更推荐）

将端口从587改为465，并使用SSL连接：

```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 465  # 使用SSL端口
    username: 你的QQ邮箱@qq.com
    password: 你的授权码
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true  # 启用SSL
            trust: smtp.qq.com
          socketFactory:
            class: javax.net.ssl.SSLSocketFactory
            port: 465
        debug: false
    default-encoding: UTF-8
```

### 方案3：完全禁用SSL验证（仅用于开发环境）

⚠️ **警告**：此方案会降低安全性，仅用于开发测试！

```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 587
    username: 你的QQ邮箱@qq.com
    password: 你的授权码
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: false  # 改为false
          ssl:
            trust: "*"  # 信任所有证书
            checkserveridentity: false
        debug: false
    default-encoding: UTF-8
```

## 推荐配置（QQ邮箱）

### 配置1：使用端口465（最稳定）

```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 465
    username: 3071624946@qq.com
    password: rpybvffaulzqddbc
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

### 配置2：使用端口587（备选）

```yaml
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 587
    username: 3071624946@qq.com
    password: rpybvffaulzqddbc
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          ssl:
            trust: smtp.qq.com
            protocols: TLSv1.2
    default-encoding: UTF-8
```

## 其他邮箱配置

### 163邮箱（推荐使用465端口）

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
            trust: smtp.163.com
          socketFactory:
            class: javax.net.ssl.SSLSocketFactory
            port: 465
    default-encoding: UTF-8
```

### Gmail

```yaml
spring:
  mail:
    enabled: true
    host: smtp.gmail.com
    port: 587
    username: 你的Gmail@gmail.com
    password: 你的应用专用密码
    properties:
      mail:
        smtp:
          auth: true
          starttls:
            enable: true
            required: true
          ssl:
            trust: smtp.gmail.com
    default-encoding: UTF-8
```

## 测试步骤

1. **修改配置文件**
   - 选择上面的一个配置方案
   - 替换为你的邮箱和授权码

2. **重启后端服务**
   ```bash
   # 停止当前服务
   # 重新启动
   cd backend
   mvn spring-boot:run
   ```

3. **测试发送**
   - 访问忘记密码页面
   - 输入用户名和邮箱
   - 点击发送验证码
   - 检查邮箱

4. **查看日志**
   - 如果还有问题，查看后端控制台日志
   - 日志会显示详细的连接信息

## 常见问题

### Q1: 还是报SSL错误

**A:** 尝试以下步骤：
1. 使用端口465而不是587
2. 确认授权码正确
3. 检查网络连接
4. 尝试禁用防火墙

### Q2: 连接超时

**A:**
1. 检查网络是否能访问smtp.qq.com
2. 尝试ping smtp.qq.com
3. 检查防火墙是否阻止了465或587端口

### Q3: 535 Authentication failed

**A:**
1. 确认使用的是授权码，不是QQ密码
2. 重新获取授权码
3. 确认邮箱地址正确

### Q4: 发送成功但收不到邮件

**A:**
1. 检查垃圾邮件箱
2. 确认收件人邮箱地址正确
3. 查看后端日志确认真的发送成功

## 验证配置是否正确

### 方法1：使用telnet测试

```bash
# 测试端口465
telnet smtp.qq.com 465

# 测试端口587
telnet smtp.qq.com 587
```

如果能连接，说明网络正常。

### 方法2：使用curl测试

```bash
curl -v telnet://smtp.qq.com:465
```

### 方法3：查看Java版本

某些旧版本的Java可能不支持最新的TLS协议：

```bash
java -version
```

如果Java版本低于1.8，建议升级。

## 推荐方案总结

**开发环境（最简单）：**
- 使用QQ邮箱
- 端口：465
- SSL：启用
- 信任：smtp.qq.com

**生产环境：**
- 使用企业邮箱
- 端口：465或587
- SSL：启用
- 完整的证书验证

## 当前建议

根据你的错误信息，建议：

1. **立即尝试**：将端口从587改为465
2. **添加信任**：添加 `ssl.trust: smtp.qq.com`
3. **重启服务**：重启后端服务
4. **测试发送**：再次尝试发送验证码

如果还有问题，请提供完整的错误日志。
