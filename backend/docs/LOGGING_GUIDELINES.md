# 日志规范指南

## 日志级别使用规范

### ERROR - 错误级别
**使用场景**：
- 系统异常、错误，需要立即关注和处理
- 外部服务调用失败（邮件、短信、第三方API）
- 数据库操作失败
- 关键业务流程失败

**示例**：
```java
log.error("邮件发送失败：recipient={}, error={}", email, e.getMessage(), e);
log.error("数据库操作失败：userId={}", userId, e);
log.error("外部API调用失败：url={}, error={}", url, e.getMessage(), e);
```

**注意事项**：
- 必须包含异常堆栈信息（传入Exception对象）
- 记录关键上下文信息（用户ID、订单号等）
- 避免在循环中大量打印ERROR日志

---

### WARN - 警告级别
**使用场景**：
- 业务异常、预期内的错误（如参数校验失败）
- 资源未找到（用户不存在、数据不存在）
- 账户锁定、权限不足等安全相关警告
- 配置缺失或使用默认值
- 降级处理、兜底逻辑

**示例**：
```java
log.warn("用户不存在：username={}", username);
log.warn("账户已被锁定：username={}, remainingMinutes={}", username, minutes);
log.warn("参数校验失败：field={}, value={}", field, value);
log.warn("短信服务未启用，使用模拟发送：phone={}", phone);
```

**注意事项**：
- 不需要包含异常堆栈（除非对排查问题有帮助）
- 记录关键业务信息
- 用于可恢复的异常情况

---

### INFO - 信息级别
**使用场景**：
- 重要业务操作的开始和完成（注册、登录、订单创建）
- 关键状态变更（订单状态、文物状态）
- 定时任务执行
- 系统启动、关闭
- 重要配置加载

**示例**：
```java
log.info("用户注册成功：userId={}, username={}", userId, username);
log.info("文物状态变更：relicId={}, oldStatus={}, newStatus={}", id, old, newStatus);
log.info("定时任务执行：taskName={}, processedCount={}", name, count);
log.info("验证码已发送：type={}, contact={}", type, maskedContact);
```

**注意事项**：
- 记录业务关键节点
- 避免记录敏感信息（密码、完整手机号、完整邮箱）
- 生产环境默认日志级别，需控制日志量

---

### DEBUG - 调试级别
**使用场景**：
- 开发调试信息
- 详细的方法调用参数和返回值
- 中间计算结果
- 条件分支判断
- 性能监控数据

**示例**：
```java
log.debug("查询参数：pageNum={}, pageSize={}, keyword={}", pageNum, pageSize, keyword);
log.debug("计算结果：input={}, output={}", input, output);
log.debug("缓存命中：key={}, value={}", key, value);
log.debug("方法执行耗时：method={}, duration={}ms", method, duration);
```

**注意事项**：
- 仅在开发和测试环境启用
- 生产环境默认关闭
- 可以包含详细的技术信息

---

## 异常处理规范

### 1. 使用自定义异常类
```java
// ✅ 推荐
throw new BusinessException("用户创建失败");
throw new ValidationException("email", "邮箱格式不正确");
throw new ResourceNotFoundException("用户", "id", userId);
throw new ServiceException("邮件", "发送失败");

// ❌ 不推荐
throw new RuntimeException("用户创建失败");
throw new Exception("邮箱格式不正确");
```

### 2. 异常日志记录
```java
// ✅ 推荐：在捕获异常时记录日志
try {
    // 业务逻辑
} catch (Exception e) {
    log.error("操作失败：userId={}, error={}", userId, e.getMessage(), e);
    throw new BusinessException("操作失败", e);
}

// ❌ 不推荐：抛出异常时记录日志（会导致重复记录）
log.error("操作失败");
throw new BusinessException("操作失败");
```

### 3. 全局异常处理器统一处理
- 业务异常在Service层抛出
- Controller层不需要try-catch
- 全局异常处理器统一捕获并记录日志

---

## 敏感信息处理

### 需要脱敏的信息
- 密码：永远不记录
- 手机号：显示前3位和后4位（138****5678）
- 邮箱：显示前2位和域名（ab***@example.com）
- 身份证号：显示前6位和后4位
- 银行卡号：显示后4位

### 脱敏示例
```java
// ✅ 推荐
log.info("用户登录：username={}, phone={}", username, maskPhone(phone));
log.info("发送邮件：email={}", maskEmail(email));

// ❌ 不推荐
log.info("用户登录：username={}, password={}", username, password);
log.info("发送邮件：email={}", email);
```

---

## 日志格式规范

### 1. 使用占位符
```java
// ✅ 推荐
log.info("用户登录：username={}, ip={}", username, ip);

// ❌ 不推荐
log.info("用户登录：username=" + username + ", ip=" + ip);
```

### 2. 关键信息前置
```java
// ✅ 推荐
log.error("订单创建失败：orderId={}, userId={}, error={}", orderId, userId, e.getMessage(), e);

// ❌ 不推荐
log.error("创建失败：{}, {}, {}", e.getMessage(), orderId, userId, e);
```

### 3. 统一格式
```java
// 操作类型：关键信息1=值1, 关键信息2=值2
log.info("用户注册：username={}, realName={}, museumId={}", username, realName, museumId);
log.warn("账户锁定：username={}, failedCount={}, lockMinutes={}", username, count, minutes);
```

---

## 性能考虑

### 1. 避免不必要的字符串拼接
```java
// ✅ 推荐
log.debug("详细信息：data={}", data);

// ❌ 不推荐
log.debug("详细信息：" + data.toString());
```

### 2. 条件判断
```java
// ✅ 推荐（大量数据或复杂计算时）
if (log.isDebugEnabled()) {
    log.debug("详细数据：{}", expensiveOperation());
}

// ✅ 推荐（简单场景）
log.debug("简单数据：{}", simpleValue);
```

### 3. 避免循环中打印大量日志
```java
// ✅ 推荐
log.info("批量处理开始：count={}", list.size());
for (Item item : list) {
    // 处理逻辑
}
log.info("批量处理完成：successCount={}, failCount={}", success, fail);

// ❌ 不推荐
for (Item item : list) {
    log.info("处理项目：{}", item);
}
```

---

## 日志配置建议

### application.yml
```yaml
logging:
  level:
    root: INFO
    com.example: INFO
    com.example.service: INFO
    com.example.mapper: DEBUG  # MyBatis SQL日志
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"
  file:
    name: logs/cultural-relics.log
    max-size: 100MB
    max-history: 30
```

### 不同环境配置
- **开发环境**：DEBUG级别，输出到控制台
- **测试环境**：INFO级别，输出到文件
- **生产环境**：INFO级别，输出到文件，配置日志收集

---

## 检查清单

在提交代码前，请检查：
- [ ] 是否使用了正确的日志级别
- [ ] 是否记录了关键业务信息
- [ ] 是否对敏感信息进行了脱敏
- [ ] 是否使用了占位符而非字符串拼接
- [ ] 异常是否包含了堆栈信息
- [ ] 是否避免了重复记录日志
- [ ] 是否使用了自定义异常类
- [ ] 日志格式是否统一规范
