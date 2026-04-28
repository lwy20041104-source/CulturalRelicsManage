# 代码质量改进总结

## 改进概述

本次改进主要解决了项目中的两个核心问题：
1. **异常处理不统一**：部分代码直接抛出RuntimeException，未统一处理
2. **日志级别混乱**：debug和info日志使用不规范

## 改进内容

### 1. 创建自定义异常类体系

#### 新增异常类
- `BusinessException` - 业务异常类，用于处理可预期的业务逻辑错误
- `ValidationException` - 参数验证异常，用于处理参数校验失败的情况
- `ResourceNotFoundException` - 资源未找到异常，用于处理数据不存在的情况
- `ServiceException` - 服务异常，用于处理外部服务调用失败的情况

#### 文件位置
```
backend/src/main/java/com/example/exception/
├── BusinessException.java
├── ValidationException.java
├── ResourceNotFoundException.java
└── ServiceException.java
```

### 2. 增强全局异常处理器

#### 更新内容
- 添加对所有自定义异常的处理
- 添加Spring Validation异常处理
- 添加数据库唯一键冲突异常处理
- 添加空指针异常处理
- 统一异常日志记录格式
- 规范HTTP状态码返回

#### 文件位置
```
backend/src/main/java/com/example/common/GlobalExceptionHandler.java
```

#### 支持的异常类型
| 异常类型 | 日志级别 | HTTP状态码 | 说明 |
|---------|---------|-----------|------|
| BusinessException | WARN | 200 | 业务异常 |
| ValidationException | WARN | 200 | 参数验证异常 |
| ResourceNotFoundException | WARN | 200 | 资源未找到 |
| ServiceException | ERROR | 200 | 外部服务异常 |
| IllegalArgumentException | WARN | 200 | 非法参数（兼容） |
| DuplicateKeyException | WARN | 200 | 数据库唯一键冲突 |
| NullPointerException | ERROR | 500 | 空指针异常 |
| Exception | ERROR | 500 | 通用异常 |

### 3. 修复现有代码中的异常处理

#### 修改的文件
1. **SysUserServiceImpl.java**
   - 将 `RuntimeException` 替换为 `BusinessException`
   - 将 `IllegalArgumentException` 替换为 `ValidationException`
   - 添加异常类导入

2. **PasswordResetServiceImpl.java**
   - 将 `RuntimeException` 替换为 `ServiceException`
   - 将 `IllegalArgumentException` 替换为 `ValidationException`
   - 添加异常类导入

### 4. 创建规范文档

#### 日志规范指南
**文件**：`backend/docs/LOGGING_GUIDELINES.md`

**内容包括**：
- 日志级别使用规范（ERROR、WARN、INFO、DEBUG）
- 异常处理规范
- 敏感信息处理
- 日志格式规范
- 性能考虑
- 日志配置建议

#### 异常处理规范指南
**文件**：`backend/docs/EXCEPTION_HANDLING_GUIDELINES.md`

**内容包括**：
- 自定义异常类体系说明
- 异常处理最佳实践
- 异常处理反模式
- 事务处理
- 异常信息国际化
- 迁移指南

## 使用示例

### 业务异常
```java
// 检查文物状态
if (!"在库".equals(relic.getStatus())) {
    throw new BusinessException("只有在库状态的文物才能申请借展");
}
```

### 参数验证异常
```java
// 验证用户名
if (username == null || username.trim().isEmpty()) {
    throw new ValidationException("username", "用户名不能为空");
}

// 验证数据唯一性
if (existingUser != null) {
    throw new ValidationException("用户名已存在");
}
```

### 资源未找到异常
```java
// 查询文物
CulturalRelic relic = relicMapper.selectById(id);
if (relic == null) {
    throw new ResourceNotFoundException("文物", "id", id);
}
```

### 服务异常
```java
// 邮件发送失败
if (!emailService.send(email, code)) {
    throw new ServiceException("邮件", "邮件发送失败，请稍后重试");
}
```

### 日志记录
```java
// ERROR级别 - 系统异常
log.error("邮件发送失败：recipient={}, error={}", email, e.getMessage(), e);

// WARN级别 - 业务异常
log.warn("用户不存在：username={}", username);
log.warn("账户已被锁定：username={}, remainingMinutes={}", username, minutes);

// INFO级别 - 重要业务操作
log.info("用户注册成功：userId={}, username={}", userId, username);
log.info("文物状态变更：relicId={}, oldStatus={}, newStatus={}", id, old, newStatus);

// DEBUG级别 - 调试信息
log.debug("查询参数：pageNum={}, pageSize={}, keyword={}", pageNum, pageSize, keyword);
```

## 迁移建议

### 1. 逐步迁移
建议按照以下顺序逐步迁移现有代码：
1. 核心业务模块（用户、文物、借展、修复）
2. 辅助功能模块（统计、报表、日志）
3. 工具类和配置类

### 2. 迁移步骤
对于每个Service类：
1. 添加自定义异常类的导入
2. 将 `RuntimeException` 替换为 `BusinessException`
3. 将 `IllegalArgumentException` 替换为 `ValidationException`
4. 添加资源检查，使用 `ResourceNotFoundException`
5. 外部服务调用失败使用 `ServiceException`
6. 检查日志级别是否正确

### 3. 测试验证
- 单元测试：验证异常是否正确抛出
- 集成测试：验证全局异常处理器是否正确捕获
- 日志检查：验证日志级别和格式是否符合规范

## 收益

### 1. 代码质量提升
- 异常处理统一规范
- 代码可读性提高
- 维护成本降低

### 2. 问题排查效率提升
- 日志级别清晰，便于过滤
- 异常信息明确，便于定位问题
- 上下文信息完整，便于复现问题

### 3. 用户体验改善
- 错误提示更加友好
- 异常响应格式统一
- 前端错误处理更加简单

## 注意事项

### 1. 向后兼容
- 保留了对 `IllegalArgumentException` 的支持
- 全局异常处理器会捕获所有异常类型
- 不会影响现有功能

### 2. 性能影响
- 自定义异常类继承自 `RuntimeException`，性能开销可忽略
- 日志使用占位符，避免不必要的字符串拼接
- 建议在生产环境关闭DEBUG日志

### 3. 团队协作
- 新代码必须遵循新的异常处理规范
- 修改旧代码时，顺便进行迁移
- 代码审查时，检查异常处理和日志使用

## 后续优化建议

### 1. 错误码体系
建议引入错误码体系，支持国际化：
```java
throw new BusinessException("USER_NOT_FOUND", "用户不存在");
```

### 2. 日志收集
建议在生产环境配置日志收集系统（如ELK、Splunk）：
- 集中管理日志
- 实时监控告警
- 日志分析统计

### 3. 监控告警
建议配置异常监控告警：
- ERROR级别日志实时告警
- 异常频率监控
- 性能指标监控

### 4. 文档完善
建议持续完善文档：
- 添加更多使用示例
- 补充常见问题FAQ
- 更新最佳实践

## 参考资料

- [日志规范指南](./LOGGING_GUIDELINES.md)
- [异常处理规范指南](./EXCEPTION_HANDLING_GUIDELINES.md)
- [Spring Boot官方文档 - Exception Handling](https://docs.spring.io/spring-boot/docs/current/reference/html/features.html#features.developing-web-applications.spring-mvc.error-handling)
- [SLF4J官方文档](http://www.slf4j.org/manual.html)
