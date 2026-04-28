# 密码强度验证功能实现文档

## 实现日期
2026年4月24日

## 功能概述
为用户注册和用户管理功能添加密码强度验证，要求密码必须是6-20位字符，且必须包含数字和字母。

## 密码强度要求

### 基本要求
- **最小长度**: 6位字符
- **最大长度**: 20位字符
- **必须包含**: 数字（0-9）
- **必须包含**: 字母（a-z或A-Z）

### 验证规则
```
正则表达式: ^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$

说明:
- ^                  : 字符串开始
- (?=.*[0-9])        : 至少包含一个数字
- (?=.*[a-zA-Z])     : 至少包含一个字母
- .{6,20}            : 总长度6-20位
- $                  : 字符串结束
```

### 密码示例

#### ✅ 符合要求的密码
- `abc123` - 6位，包含字母和数字
- `password1` - 9位，包含字母和数字
- `Test123456` - 10位，包含大小写字母和数字
- `myPass2024` - 10位，包含字母和数字
- `Admin@123` - 9位，包含字母、数字和特殊字符

#### ❌ 不符合要求的密码
- `12345` - 太短（少于6位）
- `abcdef` - 没有数字
- `123456` - 没有字母
- `abc` - 太短且没有数字
- `a1` - 太短
- `abcdefghijklmnopqrst1` - 太长（超过20位）

## 技术实现

### 1. 后端实现

#### 1.1 密码验证工具类
**文件**: `backend/src/main/java/com/example/util/PasswordValidator.java`

**核心方法**:
```java
public class PasswordValidator {
    // 密码正则表达式
    private static final Pattern PASSWORD_PATTERN = 
        Pattern.compile("^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$");
    
    /**
     * 验证密码强度（抛出异常）
     */
    public static void validate(String password) {
        // 检查长度
        // 检查是否包含数字
        // 检查是否包含字母
        // 使用正则表达式完整验证
    }
    
    /**
     * 检查密码是否符合要求（返回布尔值）
     */
    public static boolean isValid(String password) {
        // 返回 true/false
    }
    
    /**
     * 获取密码强度描述
     */
    public static String getStrengthDescription(String password) {
        // 返回 "强"/"中"/"弱" 或错误提示
    }
}
```

#### 1.2 DTO验证
**文件**: `backend/src/main/java/com/example/dto/RegisterRequest.java`

```java
@NotBlank(message = "密码不能为空")
@Pattern(
    regexp = "^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$", 
    message = "密码必须是6-20位字符，且包含数字和字母"
)
private String password;
```

#### 1.3 Service层验证
**文件**: `backend/src/main/java/com/example/service/impl/SysUserServiceImpl.java`

**新增用户**:
```java
@Override
public boolean save(SysUser user) {
    // 验证密码强度
    if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
        PasswordValidator.validate(user.getPassword());
    } else {
        throw new ValidationException("密码不能为空");
    }
    
    // 加密并保存
    user.setPassword(passwordEncoder.encode(user.getPassword()));
    return sysUserMapper.insert(user) > 0;
}
```

**更新用户**:
```java
@Override
public boolean updateById(SysUser user) {
    // 如果修改了密码，验证密码强度
    if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
        PasswordValidator.validate(user.getPassword());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
    } else {
        user.setPassword(null); // 不修改密码
    }
    
    return sysUserMapper.updateById(user) > 0;
}
```

**用户注册**:
```java
@Override
@Transactional(rollbackFor = Exception.class)
public Long register(RegisterRequest request) {
    // 验证密码强度
    PasswordValidator.validate(request.getPassword());
    
    // 创建用户
    user.setPassword(passwordEncoder.encode(request.getPassword()));
    sysUserMapper.insert(user);
    
    return user.getId();
}
```

### 2. 前端实现

#### 2.1 注册页面验证
**文件**: `frontend/src/views/PortalRegisterView.vue`

**验证函数**:
```javascript
const validatePassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入密码'))
  } else if (value.length < 6 || value.length > 20) {
    callback(new Error('密码长度必须在6-20位之间'))
  } else if (!/[0-9]/.test(value)) {
    callback(new Error('密码必须包含数字'))
  } else if (!/[a-zA-Z]/.test(value)) {
    callback(new Error('密码必须包含字母'))
  } else if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
    callback(new Error('密码必须是6-20位字符，且包含数字和字母'))
  } else {
    if (registerForm.confirmPassword) {
      registerFormRef.value.validateField('confirmPassword')
    }
    callback()
  }
}
```

**输入框提示**:
```vue
<el-input 
  v-model="registerForm.password" 
  type="password" 
  placeholder="6-20位字符，必须包含数字和字母"
  show-password
/>
```

#### 2.2 用户管理页面验证
**文件**: `frontend/src/views/UsersView.vue`

**验证函数**:
```javascript
function validatePassword(rule, value, callback) {
  // 新增用户时，密码为必填
  if (!form.id && !value) {
    callback(new Error('密码不能为空'))
    return
  }
  
  // 编辑用户时，如果填写了密码，需要验证
  if (value) {
    // 检查长度
    if (String(value).length < 6) {
      callback(new Error('密码长度不能少于6位'))
      return
    }
    if (String(value).length > 20) {
      callback(new Error('密码长度不能超过20位'))
      return
    }
    // 检查是否包含数字
    if (!/[0-9]/.test(value)) {
      callback(new Error('密码必须包含数字'))
      return
    }
    // 检查是否包含字母
    if (!/[a-zA-Z]/.test(value)) {
      callback(new Error('密码必须包含字母'))
      return
    }
    // 完整验证
    if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
      callback(new Error('密码必须是6-20位字符，且包含数字和字母'))
      return
    }
  }
  callback()
}
```

**输入框提示**:
```vue
<!-- 新增用户 -->
<el-input 
  v-model="form.password" 
  type="password" 
  show-password 
  placeholder="6-20位字符，必须包含数字和字母" 
/>

<!-- 编辑用户 -->
<el-input 
  v-model="form.password" 
  type="password" 
  show-password 
  placeholder="6-20位字符，必须包含数字和字母（不修改请留空）" 
/>
```

## 验证流程

### 注册流程
```
用户输入密码
    ↓
前端实时验证（输入时）
    ↓
前端表单验证（提交时）
    ↓
后端DTO验证（@Pattern注解）
    ↓
后端Service验证（PasswordValidator.validate()）
    ↓
密码加密（BCrypt）
    ↓
保存到数据库
```

### 修改密码流程
```
用户输入新密码
    ↓
前端实时验证（输入时）
    ↓
前端表单验证（提交时）
    ↓
后端Service验证（PasswordValidator.validate()）
    ↓
密码加密（BCrypt）
    ↓
更新到数据库
```

## 错误提示信息

### 前端错误提示
| 错误情况 | 提示信息 |
|---------|---------|
| 密码为空 | 请输入密码 |
| 密码太短 | 密码长度不能少于6位 |
| 密码太长 | 密码长度不能超过20位 |
| 没有数字 | 密码必须包含数字 |
| 没有字母 | 密码必须包含字母 |
| 格式不正确 | 密码必须是6-20位字符，且包含数字和字母 |
| 两次密码不一致 | 两次输入的密码不一致 |

### 后端错误提示
| 错误情况 | 提示信息 |
|---------|---------|
| 密码为空 | 密码不能为空 |
| 密码太短 | 密码长度不能少于6位 |
| 密码太长 | 密码长度不能超过20位 |
| 没有数字 | 密码必须包含数字 |
| 没有字母 | 密码必须包含字母 |
| 格式不正确 | 密码必须是6-20位字符，且包含数字和字母 |

## 测试用例

### 1. 注册功能测试

#### 测试用例1: 正常注册
- **输入**: username=testuser, password=test123
- **预期**: 注册成功

#### 测试用例2: 密码太短
- **输入**: username=testuser, password=abc12
- **预期**: 提示"密码长度不能少于6位"

#### 测试用例3: 密码没有数字
- **输入**: username=testuser, password=abcdefgh
- **预期**: 提示"密码必须包含数字"

#### 测试用例4: 密码没有字母
- **输入**: username=testuser, password=12345678
- **预期**: 提示"密码必须包含字母"

#### 测试用例5: 密码太长
- **输入**: username=testuser, password=abcdefghijklmnopqrst1
- **预期**: 提示"密码长度不能超过20位"

### 2. 用户管理功能测试

#### 测试用例1: 新增用户（正常）
- **输入**: username=newuser, password=pass123
- **预期**: 保存成功

#### 测试用例2: 新增用户（密码不符合要求）
- **输入**: username=newuser, password=123456
- **预期**: 提示"密码必须包含字母"

#### 测试用例3: 编辑用户（修改密码）
- **输入**: 修改密码为 newpass123
- **预期**: 更新成功

#### 测试用例4: 编辑用户（不修改密码）
- **输入**: 密码字段留空
- **预期**: 更新成功，密码不变

#### 测试用例5: 编辑用户（密码不符合要求）
- **输入**: 修改密码为 abc
- **预期**: 提示"密码长度不能少于6位"

## 安全性说明

### 1. 密码加密
- 使用 **BCrypt** 算法加密密码
- 每次加密生成不同的盐值
- 密码不可逆，无法解密

### 2. 密码传输
- 前端使用 HTTPS 传输（生产环境）
- 密码字段使用 `type="password"` 隐藏输入

### 3. 密码存储
- 数据库只存储加密后的密码
- 密码字段长度足够存储BCrypt哈希值（60字符）

### 4. 密码验证
- 前后端双重验证
- 防止绕过前端验证直接调用API

## 用户体验优化

### 1. 实时验证
- 用户输入时实时显示错误提示
- 密码强度指示器（可选）

### 2. 友好提示
- 清晰的错误提示信息
- 输入框占位符提示密码要求

### 3. 密码可见性
- 提供"显示/隐藏密码"按钮
- 方便用户确认输入

## 未来优化方向

### 1. 密码强度等级
- 弱: 只包含数字和字母
- 中: 包含大小写字母和数字
- 强: 包含大小写字母、数字和特殊字符

### 2. 密码强度指示器
- 实时显示密码强度
- 颜色标识（红/黄/绿）

### 3. 密码历史
- 记录用户最近使用的密码
- 防止重复使用旧密码

### 4. 密码过期策略
- 定期提醒用户修改密码
- 强制密码过期时间

### 5. 密码复杂度配置
- 管理员可配置密码复杂度要求
- 不同角色不同的密码要求

## 相关文档
- [异常处理规范](./EXCEPTION_HANDLING_GUIDELINES.md)
- [日志规范](./LOGGING_GUIDELINES.md)
- [代码质量改进](./CODE_QUALITY_IMPROVEMENTS.md)

## 总结
密码强度验证功能已成功实现，包括：
- ✅ 后端密码验证工具类
- ✅ DTO层注解验证
- ✅ Service层业务验证
- ✅ 前端注册页面验证
- ✅ 前端用户管理页面验证
- ✅ 友好的错误提示
- ✅ 前后端双重验证

该功能有效提升了系统的安全性，防止用户使用弱密码，降低账户被破解的风险。
