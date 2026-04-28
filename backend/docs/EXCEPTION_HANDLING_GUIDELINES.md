# 异常处理规范指南

## 自定义异常类体系

### 1. BusinessException - 业务异常
**用途**：处理可预期的业务逻辑错误

**使用场景**：
- 业务规则验证失败
- 业务流程不满足条件
- 数据状态不符合要求

**示例**：
```java
// 文物状态检查
if (!"在库".equals(relic.getStatus())) {
    throw new BusinessException("只有在库状态的文物才能申请借展");
}

// 角色权限检查
if (!hasPermission(user, "APPROVE")) {
    throw new BusinessException("PERMISSION_DENIED", "您没有审批权限");
}

// 业务规则验证
if (loanDays > MAX_LOAN_DAYS) {
    throw new BusinessException("借展天数不能超过" + MAX_LOAN_DAYS + "天");
}
```

---

### 2. ValidationException - 参数验证异常
**用途**：处理参数校验失败的情况

**使用场景**：
- 必填参数缺失
- 参数格式不正确
- 参数值不在有效范围内
- 数据唯一性冲突

**示例**：
```java
// 参数为空
if (username == null || username.trim().isEmpty()) {
    throw new ValidationException("username", "用户名不能为空");
}

// 格式验证
if (!email.matches(EMAIL_PATTERN)) {
    throw new ValidationException("email", "邮箱格式不正确");
}

// 数据唯一性
if (existingUser != null) {
    throw new ValidationException("用户名已存在");
}

// 范围验证
if (age < 0 || age > 150) {
    throw new ValidationException("age", "年龄必须在0-150之间");
}
```

---

### 3. ResourceNotFoundException - 资源未找到异常
**用途**：处理数据不存在的情况

**使用场景**：
- 根据ID查询数据不存在
- 关联数据不存在
- 文件或资源不存在

**示例**：
```java
// 查询单个资源
CulturalRelic relic = relicMapper.selectById(id);
if (relic == null) {
    throw new ResourceNotFoundException("文物", "id", id);
}

// 查询关联资源
Museum museum = museumMapper.selectById(museumId);
if (museum == null) {
    throw new ResourceNotFoundException("博物馆", "id", museumId);
}

// 简化形式
if (user == null) {
    throw new ResourceNotFoundException("用户不存在");
}
```

---

### 4. ServiceException - 服务异常
**用途**：处理外部服务调用失败的情况

**使用场景**：
- 邮件服务调用失败
- 短信服务调用失败
- 第三方API调用失败
- 文件存储服务失败

**示例**：
```java
// 邮件发送失败
try {
    mailSender.send(message);
} catch (Exception e) {
    throw new ServiceException("邮件", "邮件发送失败", e);
}

// 短信发送失败
if (!smsResult.isSuccess()) {
    throw new ServiceException("短信", "短信发送失败：" + smsResult.getMessage());
}

// 第三方API调用
try {
    apiClient.call(request);
} catch (Exception e) {
    throw new ServiceException("AI服务", "AI服务调用失败", e);
}
```

---

## 异常处理最佳实践

### 1. Service层抛出异常
```java
@Service
public class UserServiceImpl implements UserService {
    
    @Override
    public void updateUser(Long id, UserDTO dto) {
        // 1. 验证资源是否存在
        User user = userMapper.selectById(id);
        if (user == null) {
            throw new ResourceNotFoundException("用户", "id", id);
        }
        
        // 2. 验证参数
        if (dto.getEmail() != null && !isValidEmail(dto.getEmail())) {
            throw new ValidationException("email", "邮箱格式不正确");
        }
        
        // 3. 验证业务规则
        if (user.getStatus() == 0) {
            throw new BusinessException("已禁用的用户不能修改");
        }
        
        // 4. 执行更新
        userMapper.updateById(user);
    }
}
```

### 2. Controller层不需要try-catch
```java
@RestController
@RequestMapping("/api/users")
public class UserController {
    
    @PutMapping("/{id}")
    public Result<Void> updateUser(@PathVariable Long id, @RequestBody UserDTO dto) {
        // 直接调用Service，异常由全局异常处理器捕获
        userService.updateUser(id, dto);
        return Result.success();
    }
}
```

### 3. 全局异常处理器统一处理
```java
@RestControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(BusinessException.class)
    public Result<String> handleBusinessException(BusinessException e) {
        log.warn("业务异常 [{}]: {}", e.getCode(), e.getMessage());
        return Result.error(e.getMessage());
    }
    
    @ExceptionHandler(ValidationException.class)
    public Result<String> handleValidationException(ValidationException e) {
        log.warn("参数校验失败: {}", e.getMessage());
        return Result.error(e.getMessage());
    }
}
```

---

## 异常处理反模式

### ❌ 不要捕获异常后不处理
```java
// 错误示例
try {
    userService.save(user);
} catch (Exception e) {
    // 什么都不做
}
```

### ❌ 不要捕获异常后只打印日志
```java
// 错误示例
try {
    userService.save(user);
} catch (Exception e) {
    log.error("保存失败", e);
    // 没有抛出异常，调用者无法感知错误
}
```

### ❌ 不要使用Exception.printStackTrace()
```java
// 错误示例
try {
    userService.save(user);
} catch (Exception e) {
    e.printStackTrace(); // 应该使用日志框架
}
```

### ❌ 不要抛出过于宽泛的异常
```java
// 错误示例
throw new Exception("操作失败");
throw new RuntimeException("保存失败");

// 正确示例
throw new BusinessException("操作失败");
throw new ValidationException("参数不正确");
```

### ❌ 不要在循环中捕获异常
```java
// 错误示例
for (User user : users) {
    try {
        userService.save(user);
    } catch (Exception e) {
        log.error("保存失败", e);
    }
}

// 正确示例
List<String> errors = new ArrayList<>();
for (User user : users) {
    try {
        userService.save(user);
    } catch (Exception e) {
        errors.add(user.getUsername() + ": " + e.getMessage());
    }
}
if (!errors.isEmpty()) {
    throw new BusinessException("批量保存失败：" + String.join(", ", errors));
}
```

---

## 事务处理

### 1. 使用@Transactional注解
```java
@Service
public class OrderServiceImpl implements OrderService {
    
    @Transactional(rollbackFor = Exception.class)
    public void createOrder(OrderDTO dto) {
        // 1. 创建订单
        Order order = new Order();
        orderMapper.insert(order);
        
        // 2. 创建订单明细
        for (OrderItem item : dto.getItems()) {
            orderItemMapper.insert(item);
        }
        
        // 3. 扣减库存
        for (OrderItem item : dto.getItems()) {
            inventoryService.deduct(item.getProductId(), item.getQuantity());
        }
        
        // 任何异常都会导致事务回滚
    }
}
```

### 2. 异常与事务回滚
```java
// RuntimeException及其子类会自动回滚
@Transactional
public void method1() {
    // ...
    throw new BusinessException("错误"); // 会回滚
}

// 检查异常需要显式配置
@Transactional(rollbackFor = Exception.class)
public void method2() throws Exception {
    // ...
    throw new Exception("错误"); // 会回滚
}

// 不回滚特定异常
@Transactional(noRollbackFor = ValidationException.class)
public void method3() {
    // ...
    throw new ValidationException("错误"); // 不会回滚
}
```

---

## 异常信息国际化

### 1. 使用错误码
```java
public class BusinessException extends RuntimeException {
    private String code;
    
    public BusinessException(String code, String message) {
        super(message);
        this.code = code;
    }
}

// 使用示例
throw new BusinessException("USER_NOT_FOUND", "用户不存在");
throw new BusinessException("PERMISSION_DENIED", "权限不足");
```

### 2. 错误码常量
```java
public class ErrorCode {
    public static final String USER_NOT_FOUND = "USER_NOT_FOUND";
    public static final String PERMISSION_DENIED = "PERMISSION_DENIED";
    public static final String INVALID_PARAMETER = "INVALID_PARAMETER";
    public static final String RESOURCE_NOT_FOUND = "RESOURCE_NOT_FOUND";
    public static final String SERVICE_UNAVAILABLE = "SERVICE_UNAVAILABLE";
}
```

---

## 异常处理检查清单

在编写代码时，请检查：
- [ ] 是否使用了合适的自定义异常类
- [ ] 异常信息是否清晰明确
- [ ] 是否记录了必要的上下文信息
- [ ] 是否在Service层抛出异常
- [ ] Controller层是否避免了不必要的try-catch
- [ ] 是否正确配置了@Transactional
- [ ] 是否避免了异常处理反模式
- [ ] 异常日志级别是否正确（WARN/ERROR）
- [ ] 是否对敏感信息进行了脱敏

---

## 迁移指南

### 将现有代码迁移到新的异常体系

#### 1. 替换IllegalArgumentException
```java
// 旧代码
throw new IllegalArgumentException("用户名不能为空");

// 新代码
throw new ValidationException("username", "用户名不能为空");
```

#### 2. 替换RuntimeException
```java
// 旧代码
throw new RuntimeException("用户创建失败");

// 新代码
throw new BusinessException("用户创建失败");
```

#### 3. 替换Exception
```java
// 旧代码
throw new Exception("邮件发送失败");

// 新代码
throw new ServiceException("邮件", "邮件发送失败");
```

#### 4. 添加资源检查
```java
// 旧代码
User user = userMapper.selectById(id);
if (user == null) {
    throw new IllegalArgumentException("用户不存在");
}

// 新代码
User user = userMapper.selectById(id);
if (user == null) {
    throw new ResourceNotFoundException("用户", "id", id);
}
```
