# 如何使用多个邮箱账号

## 概述

Spring Boot的邮件配置一次只能使用一个邮箱账号作为发件人。本文档提供了几种方案来管理和切换多个邮箱账号。

## 方案1：使用Profile配置（推荐）

通过Spring Boot的Profile功能，创建不同的配置文件，根据需要切换使用哪个邮箱。

### 配置文件结构

```
backend/src/main/resources/
├── application.yml              # 主配置文件
├── application-mail-qq.yml      # QQ邮箱配置
└── application-mail-163.yml     # 163邮箱配置
```

### 1. QQ邮箱配置

文件：`application-mail-qq.yml`

```yaml
# QQ邮箱配置
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 465
    username: 你的QQ邮箱@qq.com
    password: 你的QQ邮箱授权码
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

### 2. 163邮箱配置

文件：`application-mail-163.yml`

```yaml
# 163邮箱配置
spring:
  mail:
    enabled: true
    host: smtp.163.com
    port: 465
    username: 你的163邮箱@163.com
    password: 你的163邮箱授权码
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

### 3. 主配置文件

文件：`application.yml`

```yaml
spring:
  profiles:
    active: dev
    include: mail-qq  # 使用QQ邮箱，如果要用163邮箱改为 mail-163
```

### 4. 切换邮箱

#### 方法1：修改配置文件（推荐）

修改 `application.yml` 中的 `include` 配置：

```yaml
# 使用QQ邮箱
spring:
  profiles:
    include: mail-qq

# 使用163邮箱
spring:
  profiles:
    include: mail-163
```

修改后重启服务即可。

#### 方法2：启动参数

不修改配置文件，通过启动参数指定：

```bash
# 使用QQ邮箱
java -jar app.jar --spring.profiles.include=mail-qq

# 使用163邮箱
java -jar app.jar --spring.profiles.include=mail-163
```

#### 方法3：环境变量

```bash
# 使用QQ邮箱
export SPRING_PROFILES_INCLUDE=mail-qq
java -jar app.jar

# 使用163邮箱
export SPRING_PROFILES_INCLUDE=mail-163
java -jar app.jar
```

### 5. 优势

- ✅ 配置清晰，易于管理
- ✅ 切换方便，只需修改一行配置
- ✅ 支持多个邮箱配置
- ✅ 不需要修改代码

## 方案2：环境变量配置

使用环境变量来配置邮箱信息，根据不同环境使用不同的邮箱。

### 1. 修改配置文件

```yaml
spring:
  mail:
    enabled: true
    host: ${MAIL_HOST:smtp.qq.com}
    port: ${MAIL_PORT:465}
    username: ${MAIL_USERNAME}
    password: ${MAIL_PASSWORD}
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true
            trust: ${MAIL_HOST:smtp.qq.com}
          socketFactory:
            class: javax.net.ssl.SSLSocketFactory
            port: ${MAIL_PORT:465}
    default-encoding: UTF-8
```

### 2. 设置环境变量

#### 使用QQ邮箱

```bash
export MAIL_HOST=smtp.qq.com
export MAIL_PORT=465
export MAIL_USERNAME=你的QQ邮箱@qq.com
export MAIL_PASSWORD=你的QQ邮箱授权码
```

#### 使用163邮箱

```bash
export MAIL_HOST=smtp.163.com
export MAIL_PORT=465
export MAIL_USERNAME=你的163邮箱@163.com
export MAIL_PASSWORD=你的163邮箱授权码
```

### 3. 优势

- ✅ 配置灵活
- ✅ 适合容器化部署
- ✅ 敏感信息不在配置文件中

## 方案3：自定义邮件服务（高级）

如果需要在运行时动态切换邮箱，可以自定义邮件服务。

### 1. 创建多邮箱配置类

```java
@Configuration
public class MultipleMailConfig {
    
    @Bean("qqMailSender")
    public JavaMailSender qqMailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.qq.com");
        mailSender.setPort(465);
        mailSender.setUsername("你的QQ邮箱@qq.com");
        mailSender.setPassword("你的QQ邮箱授权码");
        
        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.qq.com");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.port", "465");
        
        return mailSender;
    }
    
    @Bean("mail163Sender")
    public JavaMailSender mail163Sender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost("smtp.163.com");
        mailSender.setPort(465);
        mailSender.setUsername("你的163邮箱@163.com");
        mailSender.setPassword("你的163邮箱授权码");
        
        Properties props = mailSender.getJavaMailProperties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.ssl.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.163.com");
        props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.put("mail.smtp.socketFactory.port", "465");
        
        return mailSender;
    }
}
```

### 2. 修改邮件服务

```java
@Service
public class EmailServiceImpl implements EmailService {
    
    @Autowired
    @Qualifier("qqMailSender")
    private JavaMailSender qqMailSender;
    
    @Autowired
    @Qualifier("mail163Sender")
    private JavaMailSender mail163Sender;
    
    @Value("${mail.sender.type:qq}")
    private String senderType;
    
    private JavaMailSender getMailSender() {
        if ("163".equals(senderType)) {
            return mail163Sender;
        }
        return qqMailSender;
    }
    
    @Override
    public boolean sendVerificationCode(String to, String code, int expireMinutes) {
        JavaMailSender mailSender = getMailSender();
        // 使用选择的mailSender发送邮件
        // ...
    }
}
```

### 3. 配置文件

```yaml
mail:
  sender:
    type: qq  # 或 163
```

### 4. 优势

- ✅ 可以在运行时动态切换
- ✅ 支持多个邮箱同时存在
- ✅ 灵活性最高

### 5. 劣势

- ❌ 需要修改代码
- ❌ 配置较复杂

## 推荐方案对比

| 方案 | 适用场景 | 复杂度 | 灵活性 |
|------|---------|--------|--------|
| Profile配置 | 开发/测试/生产环境使用不同邮箱 | ⭐ 简单 | ⭐⭐ 中等 |
| 环境变量 | 容器化部署，敏感信息保护 | ⭐⭐ 中等 | ⭐⭐ 中等 |
| 自定义服务 | 需要运行时动态切换 | ⭐⭐⭐ 复杂 | ⭐⭐⭐ 高 |

## 当前项目配置（方案1）

### 文件结构

```
backend/src/main/resources/
├── application.yml              # 主配置（已配置使用mail-qq）
├── application-mail-qq.yml      # QQ邮箱配置（已创建）
└── application-mail-163.yml     # 163邮箱配置（已创建）
```

### 使用QQ邮箱

1. 编辑 `application-mail-qq.yml`，填入你的QQ邮箱和授权码
2. 确保 `application.yml` 中配置为：
   ```yaml
   spring:
     profiles:
       include: mail-qq
   ```
3. 重启服务

### 使用163邮箱

1. 编辑 `application-mail-163.yml`，填入你的163邮箱和授权码
2. 修改 `application.yml` 中配置为：
   ```yaml
   spring:
     profiles:
       include: mail-163
   ```
3. 重启服务

### 切换邮箱

只需修改 `application.yml` 中的一行配置：

```yaml
# 从QQ邮箱切换到163邮箱
spring:
  profiles:
    include: mail-163  # 改这里即可
```

然后重启服务。

## 安全建议

### 1. 不要提交敏感信息到Git

在 `.gitignore` 中添加：

```
# 邮箱配置文件
application-mail-*.yml
```

### 2. 使用示例文件

创建示例文件供团队参考：

```
application-mail-qq.yml.example
application-mail-163.yml.example
```

示例文件中不包含真实的邮箱和密码：

```yaml
# QQ邮箱配置示例
spring:
  mail:
    enabled: true
    host: smtp.qq.com
    port: 465
    username: your-email@qq.com  # 替换为你的QQ邮箱
    password: your-authorization-code  # 替换为你的授权码
    # ...
```

### 3. 使用密钥管理服务

生产环境建议使用：
- 阿里云KMS
- AWS Secrets Manager
- HashiCorp Vault

## 常见问题

### Q1: 可以同时使用两个邮箱发送吗？

**A:** 不可以。Spring Boot的默认邮件配置一次只能使用一个邮箱。如果需要同时使用，需要使用方案3（自定义邮件服务）。

### Q2: 切换邮箱需要重启服务吗？

**A:** 
- 方案1（Profile配置）：需要重启
- 方案2（环境变量）：需要重启
- 方案3（自定义服务）：可以不重启（如果实现了动态切换）

### Q3: 如何知道当前使用的是哪个邮箱？

**A:** 查看 `application.yml` 中的 `spring.profiles.include` 配置，或者查看启动日志。

### Q4: 可以根据收件人自动选择发件邮箱吗？

**A:** 需要使用方案3（自定义邮件服务），在代码中实现逻辑判断。

## 总结

对于大多数场景，**推荐使用方案1（Profile配置）**：

✅ **优点**：
- 配置简单清晰
- 易于管理和维护
- 切换方便
- 不需要修改代码

📝 **使用步骤**：
1. 创建 `application-mail-qq.yml` 和 `application-mail-163.yml`
2. 填入对应的邮箱配置
3. 在 `application.yml` 中通过 `include` 选择使用哪个
4. 重启服务

现在你可以轻松地在QQ邮箱和163邮箱之间切换了！
