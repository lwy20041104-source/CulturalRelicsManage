# 邮箱切换快速指南

## 当前配置

- 📧 **当前使用**：QQ邮箱
- 📁 **配置文件**：`backend/src/main/resources/application.yml`

## 如何切换邮箱

### 方法：修改配置文件

打开文件：`backend/src/main/resources/application.yml`

找到以下配置：

```yaml
spring:
  profiles:
    active: dev
    # 邮箱配置切换：
    # - 使用QQ邮箱：include: mail-qq
    # - 使用163邮箱：include: mail-163
    # 修改后需要重启服务
    include: mail-qq  # 当前使用QQ邮箱
```

### 切换到163邮箱

将 `include: mail-qq` 改为 `include: mail-163`：

```yaml
spring:
  profiles:
    active: dev
    include: mail-163  # 切换到163邮箱
```

### 切换到QQ邮箱

将 `include: mail-163` 改为 `include: mail-qq`：

```yaml
spring:
  profiles:
    active: dev
    include: mail-qq  # 切换到QQ邮箱
```

## 完整步骤

### 步骤1：修改配置文件

```yaml
# 修改这一行
include: mail-163  # 或 mail-qq
```

### 步骤2：保存文件

保存 `application.yml` 文件。

### 步骤3：重启后端服务

**方法1：使用IDE**
- 停止当前运行的服务
- 重新启动服务

**方法2：使用命令行**
```bash
# 停止服务（Ctrl+C）
# 重新启动
cd backend
mvn spring-boot:run
```

### 步骤4：验证

查看启动日志，确认邮箱配置已生效：

```
使用QQ邮箱时，日志中会显示：
mail.host=smtp.qq.com

使用163邮箱时，日志中会显示：
mail.host=smtp.163.com
```

## 配置文件位置

```
backend/src/main/resources/
├── application.yml              # 主配置文件（在这里切换）
├── application-mail-qq.yml      # QQ邮箱配置
└── application-mail-163.yml     # 163邮箱配置
```

## 注意事项

### 1. 确保邮箱配置正确

**QQ邮箱配置** (`application-mail-qq.yml`)：
```yaml
spring:
  mail:
    username: 你的QQ邮箱@qq.com
    password: 你的QQ邮箱授权码
```

**163邮箱配置** (`application-mail-163.yml`)：
```yaml
spring:
  mail:
    username: 你的163邮箱@163.com
    password: 你的163邮箱授权码
```

### 2. 必须重启服务

修改配置后，必须重启后端服务才能生效。

### 3. 测试发送

重启后，测试发送验证码：
1. 访问忘记密码页面
2. 输入用户名和邮箱
3. 点击发送验证码
4. 检查邮箱是否收到

## 快速参考

| 操作 | 配置值 |
|------|--------|
| 使用QQ邮箱 | `include: mail-qq` |
| 使用163邮箱 | `include: mail-163` |

## 示例

### 示例1：从QQ邮箱切换到163邮箱

**修改前：**
```yaml
spring:
  profiles:
    include: mail-qq  # 当前使用QQ邮箱
```

**修改后：**
```yaml
spring:
  profiles:
    include: mail-163  # 切换到163邮箱
```

**操作：**
1. 修改配置
2. 保存文件
3. 重启服务
4. 测试发送

### 示例2：从163邮箱切换回QQ邮箱

**修改前：**
```yaml
spring:
  profiles:
    include: mail-163  # 当前使用163邮箱
```

**修改后：**
```yaml
spring:
  profiles:
    include: mail-qq  # 切换回QQ邮箱
```

**操作：**
1. 修改配置
2. 保存文件
3. 重启服务
4. 测试发送

## 常见问题

### Q1: 修改后没有生效？

**A:** 确认是否重启了服务。配置修改后必须重启才能生效。

### Q2: 如何确认当前使用的是哪个邮箱？

**A:** 查看 `application.yml` 中的 `include` 配置，或查看启动日志中的 `mail.host`。

### Q3: 可以不重启服务切换吗？

**A:** 不可以。使用Profile配置方式必须重启服务。如果需要不重启切换，需要使用更复杂的自定义邮件服务方案。

### Q4: 两个邮箱可以同时使用吗？

**A:** 不可以。一次只能使用一个邮箱。如果需要同时使用，需要自定义邮件服务。

## 总结

✅ **简单**：只需修改一行配置
✅ **快速**：重启服务即可生效
✅ **清晰**：配置文件有详细注释

现在你可以轻松地在QQ邮箱和163邮箱之间切换了！
