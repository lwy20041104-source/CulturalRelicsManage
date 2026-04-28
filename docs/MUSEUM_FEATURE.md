# 博物馆管理功能实现文档

## 功能概述

为前台借展人用户添加博物馆关联功能，实现以下需求：
1. 创建博物馆信息表和用户-博物馆关联表
2. 前台登录时要求选择所属博物馆
3. 系统管理员新增借展人用户时必须选择博物馆

## 数据库设计

### 1. 博物馆表 (museum)

```sql
CREATE TABLE museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    museum_code VARCHAR(50) NOT NULL UNIQUE,
    museum_name VARCHAR(100) NOT NULL,
    museum_type VARCHAR(50),
    province VARCHAR(50),
    city VARCHAR(50),
    address VARCHAR(200),
    contact_person VARCHAR(50),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    description TEXT,
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**字段说明：**
- `museum_code`: 博物馆编码（唯一）
- `museum_name`: 博物馆名称
- `museum_type`: 博物馆类型（综合类、历史类、艺术类等）
- `province/city`: 省份/城市
- `address`: 详细地址
- `contact_*`: 联系人信息
- `status`: 状态（1启用 0禁用）

### 2. 用户博物馆关联表 (user_museum)

```sql
CREATE TABLE user_museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    museum_id BIGINT NOT NULL,
    is_primary TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_museum (user_id, museum_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    FOREIGN KEY (museum_id) REFERENCES museum(id) ON DELETE CASCADE
);
```

**字段说明：**
- `user_id`: 用户ID（外键关联sys_user表）
- `museum_id`: 博物馆ID（外键关联museum表）
- `is_primary`: 是否主要博物馆（1是 0否）

### 3. 初始数据

系统预置了10个示例博物馆：
- 国家博物馆（北京）
- 故宫博物院（北京）
- 上海博物馆（上海）
- 陕西历史博物馆（西安）
- 湖南省博物馆（长沙）
- 南京博物院（南京）
- 浙江省博物馆（杭州）
- 河南博物院（郑州）
- 湖北省博物馆（武汉）
- 广东省博物馆（广州）

## 后端实现

### 1. 实体类

**Museum.java** - 博物馆实体
```java
@Data
public class Museum {
    private Long id;
    private String museumCode;
    private String museumName;
    private String museumType;
    private String province;
    private String city;
    // ... 其他字段
}
```

**UserMuseum.java** - 用户博物馆关联实体
```java
@Data
public class UserMuseum {
    private Long id;
    private Long userId;
    private Long museumId;
    private Integer isPrimary;
    // ... 其他字段
}
```

### 2. Mapper接口

**MuseumMapper.java** - 博物馆数据访问
- `selectAllActive()`: 获取所有启用的博物馆
- `selectById(Long id)`: 根据ID查询
- `selectByCode(String code)`: 根据编码查询
- `insert/update/delete`: 增删改操作

**UserMuseumMapper.java** - 用户博物馆关联数据访问
- `selectByUserId(Long userId)`: 查询用户的博物馆
- `selectPrimaryByUserId(Long userId)`: 查询用户的主要博物馆
- `insert/update/delete`: 增删改操作

### 3. Service层

**MuseumService** - 博物馆业务逻辑
- 提供博物馆的CRUD操作
- 获取启用的博物馆列表

### 4. Controller层

**MuseumController** - 博物馆接口
- `GET /museums/active`: 获取所有启用的博物馆（用于下拉选择）
- `GET /museums/{id}`: 获取博物馆详情
- `POST /museums`: 新增博物馆
- `PUT /museums/{id}`: 更新博物馆
- `DELETE /museums/{id}`: 删除博物馆

**SysUserController** - 用户管理接口（修改）
- `POST /users`: 新增用户时支持博物馆关联
- `PUT /users`: 更新用户时支持博物馆关联
- `GET /users/{userId}/museum`: 获取用户关联的博物馆

**AuthController** - 认证接口（修改）
- `POST /auth/login`: 登录时验证借展人必须提供博物馆ID

### 5. DTO修改

**LoginRequest.java** - 登录请求
```java
@Data
public class LoginRequest {
    private String username;
    private String password;
    private String roleCode;
    private Long museumId; // 新增：博物馆ID
}
```

## 前端实现

### 1. 前台登录页面 (PortalLoginView.vue)

**新增功能：**
- 博物馆下拉选择框（必填）
- 显示博物馆名称和城市
- 支持搜索过滤
- 登录时将博物馆ID传递给后端

**表单字段：**
```javascript
const loginForm = reactive({
  username: '',
  password: '',
  museumId: null,  // 新增
  remember: false,
  roleCode: 'LOANER'
})
```

**验证规则：**
```javascript
museumId: [
  { required: true, message: t('portalLogin.museumRequired'), trigger: 'change' }
]
```

### 2. 用户管理页面 (UsersView.vue)

**新增功能：**
- 角色选择为"借展人"时，显示博物馆选择框
- 博物馆选择框为必填项
- 编辑用户时自动加载关联的博物馆
- 保存时将博物馆关联信息一起提交

**动态显示逻辑：**
```javascript
const isLoanerRole = computed(() => {
  if (!form.roleId || !roleOptions.value.length) return false
  const selectedRole = roleOptions.value.find(r => r.id === form.roleId)
  return selectedRole && selectedRole.roleCode === 'LOANER'
})
```

**表单字段：**
```vue
<el-form-item v-if="isLoanerRole" :label="$t('user.museum')" prop="museumId">
  <el-select v-model="form.museumId" filterable>
    <el-option
      v-for="museum in museumList"
      :key="museum.id"
      :label="museum.museumName"
      :value="museum.id"
    />
  </el-select>
</el-form-item>
```

### 3. API接口 (museums.js)

新增博物馆相关API：
```javascript
export const getActiveMuseumsApi = () => request.get('/museums/active')
export const getMuseumByIdApi = (id) => request.get(`/museums/${id}`)
export const getUserMuseumApi = (userId) => request.get(`/users/${userId}/museum`)
// ... 其他API
```

### 4. 国际化支持

**中文翻译：**
```javascript
portalLogin: {
  selectMuseum: '请选择所属博物馆',
  museumRequired: '请选择所属博物馆',
  loadMuseumsFailed: '加载博物馆列表失败'
}

user: {
  museum: '所属博物馆',
  selectMuseum: '请选择博物馆',
  museumRequired: '借展人必须选择所属博物馆'
}
```

**英文翻译：**
```javascript
portalLogin: {
  selectMuseum: 'Please select your museum',
  museumRequired: 'Please select your museum',
  loadMuseumsFailed: 'Failed to load museum list'
}

user: {
  museum: 'Museum',
  selectMuseum: 'Please select museum',
  museumRequired: 'Visitor must select a museum'
}
```

## 使用流程

### 1. 管理员新增借展人用户

1. 登录后台管理系统
2. 进入"用户管理"页面
3. 点击"新增用户"
4. 填写用户信息
5. 选择角色为"文物借展人"
6. **系统自动显示"所属博物馆"下拉框（必填）**
7. 选择博物馆
8. 保存用户

### 2. 借展人登录

1. 访问前台登录页面 `/portal-login`
2. 输入用户名
3. 输入密码
4. **选择所属博物馆（必填）**
5. 点击"立即登录"
6. 系统验证博物馆信息
7. 登录成功，跳转到前台门户

### 3. 编辑借展人用户

1. 在用户管理页面点击"编辑"
2. 系统自动加载用户关联的博物馆
3. 可以修改博物馆关联
4. 保存更新

## 数据库初始化

执行以下SQL文件创建表和初始数据：

```bash
mysql -u root -p cultural_relics < backend/sql/museum_tables.sql
```

该脚本会：
1. 创建museum表
2. 创建user_museum表
3. 插入10个示例博物馆
4. 为现有的loaner和visitor01用户分配博物馆

## 安全性考虑

1. **外键约束**：user_museum表使用外键约束，确保数据一致性
2. **级联删除**：删除用户或博物馆时，自动删除关联记录
3. **唯一约束**：user_id和museum_id组合唯一，防止重复关联
4. **登录验证**：借展人登录时必须提供博物馆ID，后端进行验证
5. **权限控制**：只有管理员可以管理博物馆信息

## 扩展功能建议

1. **多博物馆支持**：一个用户可以关联多个博物馆
2. **博物馆管理界面**：添加专门的博物馆管理页面
3. **博物馆统计**：统计每个博物馆的用户数量、借展数量等
4. **博物馆权限**：不同博物馆的用户只能看到本馆的文物
5. **博物馆审核**：新增博物馆需要审核才能启用

## 测试建议

1. **单元测试**：测试Mapper和Service层的方法
2. **集成测试**：测试完整的登录和用户管理流程
3. **前端测试**：测试表单验证和动态显示逻辑
4. **边界测试**：测试必填项验证、数据库约束等

## 注意事项

1. 确保数据库已执行museum_tables.sql脚本
2. 现有的借展人用户需要手动分配博物馆
3. 博物馆编码必须唯一
4. 删除博物馆前需要先解除用户关联或转移用户
5. 前台登录时博物馆选择为必填项，不能为空
