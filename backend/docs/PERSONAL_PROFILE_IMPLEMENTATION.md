# 个人信息界面实现文档

## 概述
为后台用户和前台用户分别实现了个人信息查看和编辑功能。用户可以修改自己的个人信息（除角色和真实姓名外），前台用户还可以修改所属博物馆。

## 功能需求

### 后台用户个人信息
- **显示字段**：username、real_name、密码、email、phone、status、角色
- **可修改字段**：username、email、phone、password
- **不可修改字段**：real_name、角色
- **特殊限制**：username不允许重复

### 前台用户个人信息
- **显示字段**：username、real_name、密码、email、phone、status、角色、所属博物馆
- **可修改字段**：username、email、phone、password、所属博物馆
- **不可修改字段**：real_name、角色
- **特殊限制**：username不允许重复

## 实现细节

### 1. 后端实现

#### 1.0 安全配置（SecurityConfig.java）

**重要**：个人信息接口需要在SecurityConfig中配置为允许所有已登录用户访问：

```java
// 个人信息接口 - 所有已登录用户都可以访问
.antMatchers(HttpMethod.GET, "/users/profile").authenticated()
.antMatchers(HttpMethod.PUT, "/users/profile").authenticated()
// 管理员和保管员的写权限
.antMatchers("/users/**").hasRole("ADMIN")
```

**注意顺序**：必须在 `.antMatchers("/users/**").hasRole("ADMIN")` 之前配置，因为Spring Security按顺序匹配规则，更具体的规则要放在前面。

#### 1.1 API接口（SysUserController.java）

**获取个人信息**
```java
@GetMapping("/profile")
public Result<Map<String, Object>> getProfile(Authentication authentication)
```
- 路径：`GET /users/profile`
- 功能：获取当前登录用户的个人信息
- 返回：包含用户基本信息和角色信息，借展人还包含博物馆信息

**更新个人信息**
```java
@PutMapping("/profile")
@OperationLog(operationType = "修改", operationModule = "个人信息", operationContent = "修改个人信息")
@Transactional
public Result<Boolean> updateProfile(@RequestBody Map<String, Object> requestData, Authentication authentication)
```
- 路径：`PUT /users/profile`
- 功能：更新当前登录用户的个人信息
- 验证：
  - 检查新用户名是否已存在
  - 密码强度验证（6-20位，必须包含数字和字母）
  - 借展人可以更新所属博物馆
- 特殊处理：
  - 如果修改了用户名，前端需要更新localStorage
  - 密码字段可选（不修改请留空）

#### 1.2 数据库映射（UserMuseumMapper.java）

新增方法获取博物馆名称：
```java
@Select("SELECT um.*, m.museum_name as museumName FROM user_museum um " +
        "LEFT JOIN museum m ON um.museum_id = m.id " +
        "WHERE um.user_id = #{userId} AND um.is_primary = 1 LIMIT 1")
UserMuseum selectPrimaryWithMuseumNameByUserId(Long userId)
```

#### 1.3 实体类更新（UserMuseum.java）

添加博物馆名称字段：
```java
private String museumName; // 博物馆名称（用于关联查询）
```

### 2. 前端实现

#### 2.1 后台个人信息页面（ProfileView.vue）

**路由**：`/profile`

**功能特性**：
- 展示模式和编辑模式切换
- 表单验证：
  - 用户名：不能包含空格
  - 邮箱：正确的邮箱格式
  - 电话：11位手机号码
  - 密码：6-20位，必须包含数字和字母（可选）
  - 确认密码：与密码一致
- 禁用字段显示：真实姓名、角色
- 修改用户名后自动更新localStorage

**UI设计**：
- 使用el-descriptions展示信息
- 使用el-form进行编辑
- 动画过渡效果
- 响应式布局

#### 2.2 前台个人信息页面（PortalProfileView.vue）

**路由**：`/portal-profile`

**功能特性**：
- 与后台页面类似，额外包含：
  - 所属博物馆选择器（el-select）
  - 博物馆列表加载
  - 博物馆信息展示
- 表单验证包含博物馆必选验证
- 渐变背景设计，符合前台门户风格

**UI设计**：
- 渐变背景色
- 卡片阴影效果
- 博物馆选择器带搜索功能
- 显示博物馆所在城市

#### 2.3 API接口（users.js）

```javascript
// 获取个人信息
export const getProfileApi = () => request.get('/users/profile')

// 更新个人信息
export const updateProfileApi = (data) => request.put('/users/profile', data)
```

#### 2.4 路由配置（router/index.js）

**后台路由**：
```javascript
{ path: '/profile', component: () => import('../views/ProfileView.vue') }
```

**前台路由**：
```javascript
{
  path: '/portal-profile',
  component: () => import('../views/PortalProfileView.vue')
}
```

**路由守卫**：
- `/profile`：需要登录，非LOANER角色可访问
- `/portal-profile`：需要登录，仅LOANER角色可访问

#### 2.5 导航菜单

**后台导航（LayoutView.vue）**：
```vue
<el-menu-item index="/profile">
  <el-icon><User /></el-icon>
  个人信息
</el-menu-item>
```

**前台导航（PublicPortalView.vue）**：
```vue
<el-button type="primary" size="small" @click="goToProfile">
  <el-icon><User /></el-icon>
  {{ locale === 'zh' ? '个人信息' : 'Profile' }}
</el-button>
```

## 密码验证规则

### 正则表达式
```javascript
/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/
```

### 验证逻辑
1. 长度：6-20位字符
2. 必须包含至少一个数字
3. 必须包含至少一个字母（大小写均可）
4. 密码字段可选（不修改时留空）

### 前端验证
```javascript
const validatePassword = (rule, value, callback) => {
  if (value) {
    if (value.length < 6 || value.length > 20) {
      callback(new Error('密码长度必须在6-20位之间'))
      return
    }
    if (!/[0-9]/.test(value)) {
      callback(new Error('密码必须包含数字'))
      return
    }
    if (!/[a-zA-Z]/.test(value)) {
      callback(new Error('密码必须包含字母'))
      return
    }
    if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
      callback(new Error('密码必须是6-20位字符，且包含数字和字母'))
      return
    }
  }
  callback()
}
```

### 后端验证
使用 `PasswordValidator.java` 工具类进行验证（参见 PASSWORD_STRENGTH_VALIDATION.md）

## 用户名重复检查

### 后端逻辑
```java
// 检查用户名是否修改
String newUsername = (String) requestData.get("username");
if (newUsername != null && !newUsername.equals(currentUsername)) {
    // 检查新用户名是否已存在
    SysUser existingUser = sysUserService.getUserByUsername(newUsername);
    if (existingUser != null && !existingUser.getId().equals(currentUser.getId())) {
        return Result.error("用户名已存在");
    }
    user.setUsername(newUsername);
}
```

### 前端处理
- 显示错误提示
- 修改成功后更新localStorage中的username

## 博物馆管理（仅前台用户）

### 数据加载
```javascript
const loadMuseums = async () => {
  try {
    const res = await getActiveMuseumsApi()
    museumList.value = res.data || []
  } catch (e) {
    ElMessage.error('加载博物馆列表失败')
  }
}
```

### 博物馆选择器
```vue
<el-select 
  v-model="editForm.museumId" 
  placeholder="请选择所属博物馆"
  filterable
  style="width: 100%"
>
  <el-option
    v-for="museum in museumList"
    :key="museum.id"
    :label="museum.museumName"
    :value="museum.id"
  >
    <span style="float: left">{{ museum.museumName }}</span>
    <span style="float: right; color: var(--el-text-color-secondary); font-size: 13px">
      {{ museum.city }}
    </span>
  </el-option>
</el-select>
```

### 后端更新逻辑
```java
// 如果是借展人且提供了博物馆ID，更新关联
if (success && "LOANER".equals(currentUser.getRoleCode()) && requestData.get("museumId") != null) {
    Long museumId = Long.valueOf(requestData.get("museumId").toString());
    // 先删除旧关联
    userMuseumMapper.deleteByUserId(user.getId());
    // 创建新关联
    UserMuseum userMuseum = new UserMuseum();
    userMuseum.setUserId(user.getId());
    userMuseum.setMuseumId(museumId);
    userMuseum.setIsPrimary(1);
    userMuseum.setCreateTime(LocalDateTime.now());
    userMuseum.setUpdateTime(LocalDateTime.now());
    userMuseumMapper.insert(userMuseum);
}
```

## 操作日志

个人信息修改操作会自动记录到操作日志中：
```java
@OperationLog(operationType = "修改", operationModule = "个人信息", operationContent = "修改个人信息")
```

## 测试建议

### 1. 后台用户测试
1. 登录后台系统
2. 点击左侧菜单"个人信息"
3. 验证信息显示正确
4. 点击"编辑个人信息"
5. 测试各字段验证：
   - 用户名重复检查
   - 邮箱格式验证
   - 电话号码验证
   - 密码强度验证
   - 确认密码一致性
6. 测试密码可选（留空不修改）
7. 验证真实姓名和角色不可修改
8. 提交修改，验证成功提示
9. 刷新页面，验证修改已保存

### 2. 前台用户测试
1. 登录前台门户
2. 点击顶部"个人信息"按钮
3. 验证信息显示正确（包括博物馆）
4. 点击"编辑个人信息"
5. 测试所有后台用户的验证项
6. 额外测试博物馆选择：
   - 博物馆列表加载
   - 搜索功能
   - 修改博物馆
7. 提交修改，验证成功提示
8. 返回门户，验证修改已保存

### 3. 边界情况测试
- 用户名修改为已存在的用户名
- 密码长度边界（5位、6位、20位、21位）
- 密码只包含数字或只包含字母
- 两次密码输入不一致
- 邮箱格式错误
- 电话号码格式错误
- 网络错误处理

## 文件清单

### 后端文件
- `backend/src/main/java/com/example/controller/SysUserController.java` - 个人信息API
- `backend/src/main/java/com/example/entity/UserMuseum.java` - 用户博物馆实体
- `backend/src/main/java/com/example/mapper/UserMuseumMapper.java` - 用户博物馆映射
- `backend/src/main/java/com/example/util/PasswordValidator.java` - 密码验证工具

### 前端文件
- `frontend/src/views/ProfileView.vue` - 后台个人信息页面
- `frontend/src/views/PortalProfileView.vue` - 前台个人信息页面
- `frontend/src/views/LayoutView.vue` - 后台布局（添加导航）
- `frontend/src/views/PublicPortalView.vue` - 前台门户（添加导航）
- `frontend/src/router/index.js` - 路由配置
- `frontend/src/api/users.js` - 用户API接口

### 文档文件
- `backend/docs/PERSONAL_PROFILE_IMPLEMENTATION.md` - 本文档
- `backend/docs/PASSWORD_STRENGTH_VALIDATION.md` - 密码强度验证文档

## 注意事项

1. **安全性**
   - 用户只能修改自己的个人信息
   - 通过Spring Security的Authentication获取当前用户
   - 密码在后端使用BCrypt加密存储
   - 用户名重复检查防止冲突

2. **用户体验**
   - 密码字段可选，不修改时留空
   - 修改用户名后自动更新localStorage
   - 表单验证提供即时反馈
   - 禁用字段明确标注不可修改
   - 前台页面风格与门户一致

3. **数据一致性**
   - 使用@Transactional确保事务一致性
   - 博物馆关联更新采用先删除后插入策略
   - 操作日志自动记录

4. **国际化支持**
   - 前台页面支持中英文切换
   - 使用locale判断显示语言
   - 后台页面使用中文

## 后续优化建议

1. **功能增强**
   - 添加头像上传功能
   - 添加密码修改历史记录
   - 添加邮箱/手机号验证
   - 添加账号安全设置

2. **用户体验**
   - 添加修改确认对话框
   - 添加修改前后对比
   - 添加撤销修改功能
   - 优化移动端显示

3. **安全性**
   - 添加敏感操作二次验证
   - 添加修改频率限制
   - 添加异常登录提醒
   - 添加操作审计日志

## 常见问题

### 1. 前台用户访问个人信息显示"加载个人信息失败"

**原因**：SecurityConfig中 `/users/**` 路径被配置为只有ADMIN角色才能访问，导致LOANER角色无法访问 `/users/profile`。

**解决方案**：在SecurityConfig中，在 `.antMatchers("/users/**").hasRole("ADMIN")` 之前添加：
```java
.antMatchers(HttpMethod.GET, "/users/profile").authenticated()
.antMatchers(HttpMethod.PUT, "/users/profile").authenticated()
```

### 2. IDE显示找不到类或包

**原因**：IDE缓存问题，Maven编译是成功的。

**解决方案**：
- 刷新Maven项目
- 清理IDE缓存（File → Invalidate Caches → Invalidate and Restart）
- 重新导入Maven项目

### 3. 修改用户名后其他地方显示的还是旧用户名

**原因**：前端localStorage没有更新。

**解决方案**：代码中已经处理，修改用户名成功后会自动更新localStorage：
```javascript
if (editForm.username !== profile.value.username) {
  localStorage.setItem('username', editForm.username)
}
```

## 更新日期
2026-04-24
