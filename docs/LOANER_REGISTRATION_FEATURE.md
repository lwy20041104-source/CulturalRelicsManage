# 借展人注册功能文档

## 功能概述

完善的借展人前台注册功能，允许用户自主注册成为文物借展人，注册时需要填写完整的个人信息和选择所属博物馆。

## 功能特性

### 1. 注册信息要求

**必填项**：
- ✅ 用户名（4-20位字母、数字或下划线）
- ✅ 密码（6-20位字符）
- ✅ 确认密码（必须与密码一致）
- ✅ 真实姓名
- ✅ 邮箱（需符合邮箱格式）
- ✅ 电话号码（11位手机号）
- ✅ 所属博物馆（从下拉列表选择）

**自动设置**：
- 角色：固定为"文物借展人"（LOANER）
- 状态：启用（status = 1）
- 创建时间：当前时间
- 更新时间：当前时间

### 2. 数据存储

#### sys_user 表
存储用户基本信息：
- `username` - 用户名
- `password` - 加密后的密码（BCrypt）
- `real_name` - 真实姓名
- `email` - 邮箱
- `phone` - 电话号码
- `role_id` - 角色ID（借展人角色）
- `status` - 状态（1=启用）
- `create_time` - 创建时间
- `update_time` - 更新时间

#### user_museum 表
存储用户与博物馆的关联关系：
- `user_id` - 用户ID
- `museum_id` - 博物馆ID
- `is_primary` - 是否为主博物馆（1=是）
- `create_time` - 创建时间
- `update_time` - 更新时间

### 3. 数据验证

#### 后端验证（RegisterRequest DTO）
```java
@NotBlank(message = "用户名不能为空")
@Pattern(regexp = "^[a-zA-Z0-9_]{4,20}$", message = "用户名必须是4-20位字母、数字或下划线")
private String username;

@NotBlank(message = "密码不能为空")
@Pattern(regexp = "^.{6,20}$", message = "密码长度必须在6-20位之间")
private String password;

@NotBlank(message = "真实姓名不能为空")
private String realName;

@NotBlank(message = "邮箱不能为空")
@Email(message = "邮箱格式不正确")
private String email;

@NotBlank(message = "电话号码不能为空")
@Pattern(regexp = "^1[3-9]\\d{9}$", message = "电话号码格式不正确")
private String phone;

@NotNull(message = "所属博物馆不能为空")
private Long museumId;
```

#### 前端验证
- 用户名：4-20位字母、数字或下划线
- 密码：6-20位字符
- 确认密码：必须与密码一致
- 真实姓名：必填
- 邮箱：必填且符合邮箱格式
- 电话号码：11位手机号（1开头）
- 所属博物馆：必选
- 用户协议：必须勾选同意

### 4. 业务逻辑

#### 注册流程
1. **验证用户名唯一性**
   - 检查用户名是否已存在
   - 如果存在，返回错误"用户名已存在"

2. **验证博物馆有效性**
   - 检查所选博物馆是否存在
   - 如果不存在，返回错误"所选博物馆不存在"

3. **获取借展人角色**
   - 查询角色代码为"LOANER"的角色
   - 如果不存在，返回错误"借展人角色不存在，请联系管理员"

4. **创建用户记录**
   - 密码使用 BCrypt 加密
   - 设置角色ID为借展人角色
   - 设置状态为启用（1）
   - 插入 sys_user 表

5. **创建用户-博物馆关联**
   - 设置为主博物馆（is_primary = 1）
   - 插入 user_museum 表

6. **事务保护**
   - 使用 `@Transactional` 确保数据一致性
   - 任何步骤失败都会回滚

7. **记录操作日志**
   - 记录注册成功/失败的日志
   - 包含IP地址、操作人等信息

## 技术实现

### 后端实现

#### 1. RegisterRequest DTO
```java
@Data
public class RegisterRequest {
    @NotBlank(message = "用户名不能为空")
    @Pattern(regexp = "^[a-zA-Z0-9_]{4,20}$")
    private String username;
    
    @NotBlank(message = "密码不能为空")
    @Pattern(regexp = "^.{6,20}$")
    private String password;
    
    @NotBlank(message = "真实姓名不能为空")
    private String realName;
    
    @NotBlank(message = "邮箱不能为空")
    @Email(message = "邮箱格式不正确")
    private String email;
    
    @NotBlank(message = "电话号码不能为空")
    @Pattern(regexp = "^1[3-9]\\d{9}$")
    private String phone;
    
    @NotNull(message = "所属博物馆不能为空")
    private Long museumId;
}
```

#### 2. AuthController 注册接口
```java
@PostMapping("/register")
public Result<Long> register(@Valid @RequestBody RegisterRequest request) {
    try {
        Long userId = sysUserService.register(request);
        // 记录日志
        logService.log(request.getRealName(), "注册", "系统认证", 
                "借展人注册：" + request.getUsername(), "成功", ipAddress);
        return Result.success("注册成功，请登录", userId);
    } catch (IllegalArgumentException e) {
        return Result.error(e.getMessage());
    }
}
```

#### 3. SysUserService 注册方法
```java
@Override
@Transactional(rollbackFor = Exception.class)
public Long register(RegisterRequest request) {
    // 1. 验证用户名唯一性
    // 2. 验证博物馆有效性
    // 3. 获取借展人角色
    // 4. 创建用户
    // 5. 创建用户-博物馆关联
    return userId;
}
```

### 前端实现

#### 1. 注册页面（PortalRegisterView.vue）
- 美观的双栏布局
- 左侧展示注册优势
- 右侧注册表单
- 实时表单验证
- 密码强度提示
- 博物馆下拉选择（支持搜索）

#### 2. 表单验证
```javascript
const validateUsername = (rule, value, callback) => {
  if (!/^[a-zA-Z0-9_]{4,20}$/.test(value)) {
    callback(new Error('用户名必须是4-20位字母、数字或下划线'))
  } else {
    callback()
  }
}

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}
```

#### 3. 注册API调用
```javascript
const handleRegister = async () => {
  await registerFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    const requestData = {
      username: registerForm.username,
      password: registerForm.password,
      realName: registerForm.realName,
      email: registerForm.email,
      phone: registerForm.phone,
      museumId: registerForm.museumId
    }
    
    const res = await registerApi(requestData)
    
    if (res.code === 200) {
      ElMessage.success('注册成功！请登录')
      router.push('/portal-login')
    }
  })
}
```

## API 接口

### 注册接口

**请求**：
```http
POST /api/auth/register
Content-Type: application/json

{
  "username": "zhangsan",
  "password": "123456",
  "realName": "张三",
  "email": "zhangsan@example.com",
  "phone": "13800138000",
  "museumId": 1
}
```

**成功响应**：
```json
{
  "code": 200,
  "message": "注册成功，请登录",
  "data": 10
}
```

**失败响应**：
```json
{
  "code": 500,
  "message": "用户名已存在",
  "data": null
}
```

## 页面路由

### 注册页面
- **路径**：`/portal-register`
- **组件**：`PortalRegisterView.vue`
- **访问权限**：无需登录

### 登录页面
- **路径**：`/portal-login`
- **组件**：`PortalLoginView.vue`
- **访问权限**：无需登录

## 用户体验

### 1. 注册流程
1. 访问前台登录页面
2. 点击"立即注册"按钮
3. 填写注册信息
4. 选择所属博物馆
5. 勾选用户协议
6. 点击"立即注册"
7. 注册成功后自动跳转到登录页面

### 2. 表单提示
- 实时验证输入格式
- 清晰的错误提示
- 密码强度提示
- 博物馆搜索功能

### 3. 错误处理
- 用户名已存在
- 邮箱格式错误
- 手机号格式错误
- 密码不一致
- 未选择博物馆
- 未同意用户协议

## 安全性

### 1. 密码加密
- 使用 BCrypt 加密算法
- 密码不可逆加密
- 每次加密结果不同（加盐）

### 2. 输入验证
- 前端验证（用户体验）
- 后端验证（安全保障）
- 防止SQL注入
- 防止XSS攻击

### 3. 事务保护
- 使用数据库事务
- 确保数据一致性
- 失败自动回滚

### 4. 日志记录
- 记录注册操作
- 记录IP地址
- 便于审计追踪

## 测试用例

### 1. 正常注册
- 输入：所有必填项正确
- 预期：注册成功，跳转到登录页面

### 2. 用户名已存在
- 输入：已存在的用户名
- 预期：提示"用户名已存在"

### 3. 密码不一致
- 输入：两次密码不同
- 预期：提示"两次输入的密码不一致"

### 4. 邮箱格式错误
- 输入：错误的邮箱格式
- 预期：提示"邮箱格式不正确"

### 5. 手机号格式错误
- 输入：非11位或格式错误的手机号
- 预期：提示"请输入正确的手机号码"

### 6. 未选择博物馆
- 输入：不选择博物馆
- 预期：提示"请选择所属博物馆"

### 7. 未同意协议
- 输入：不勾选用户协议
- 预期：提示"请阅读并同意用户协议和隐私政策"

## 相关文件

### 后端文件
- `backend/src/main/java/com/example/dto/RegisterRequest.java` - 注册请求DTO
- `backend/src/main/java/com/example/controller/AuthController.java` - 认证控制器
- `backend/src/main/java/com/example/service/SysUserService.java` - 用户服务接口
- `backend/src/main/java/com/example/service/impl/SysUserServiceImpl.java` - 用户服务实现
- `backend/src/main/java/com/example/mapper/UserMuseumMapper.java` - 用户博物馆关联Mapper

### 前端文件
- `frontend/src/views/PortalRegisterView.vue` - 注册页面
- `frontend/src/views/PortalLoginView.vue` - 登录页面（更新）
- `frontend/src/api/auth.js` - 认证API
- `frontend/src/router/index.js` - 路由配置

### 数据库表
- `sys_user` - 用户表
- `user_museum` - 用户博物馆关联表
- `sys_role` - 角色表
- `museum` - 博物馆表

## 后续优化建议

### 1. 邮箱验证
- 发送验证邮件
- 验证邮箱有效性
- 防止恶意注册

### 2. 手机验证码
- 发送短信验证码
- 验证手机号真实性
- 增强安全性

### 3. 图形验证码
- 防止机器人注册
- 防止暴力破解

### 4. 密码强度检测
- 实时显示密码强度
- 建议使用强密码
- 提升账号安全性

### 5. 注册审核
- 管理员审核注册
- 验证用户身份
- 防止虚假注册

## 修改日期
2026-04-23

## 修改人员
Kiro AI Assistant
