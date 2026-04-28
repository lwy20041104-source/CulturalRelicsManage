# 博物馆管理功能实现文档

## 概述
为系统管理员添加了博物馆管理界面，支持博物馆的增删改查、分页查询、状态管理等功能。

## 功能特性

### 1. 博物馆列表管理
- 分页展示博物馆列表
- 支持按博物馆名称、城市、合作状态筛选
- 显示博物馆编码、名称、类型、地址、联系方式等信息
- 合作状态标签显示（有合作/无合作）

### 2. 新增博物馆
- 博物馆编码（唯一，不可重复）
- 博物馆名称（唯一，不可重复）
- 博物馆类型（综合类、历史类、艺术类、科技类、自然类、专题类）
- 省份、城市、详细地址
- 联系人、联系电话、联系邮箱
- 描述信息
- 合作状态（有合作/无合作）

### 3. 编辑博物馆
- 支持修改除编码外的所有信息
- 博物馆编码不可修改（保证数据一致性）

### 4. 删除博物馆
- 支持删除博物馆
- 采用逻辑删除方式
- 删除时将合作状态改为"无合作"（status=0）
- 不会真正删除数据库记录
- 删除前需要确认

### 5. 权限控制
- 仅系统管理员（ADMIN角色）可以访问博物馆管理功能
- 其他角色无权访问

## 后端实现

### 1. 实体类（Museum.java）
```java
@Data
public class Museum {
    private Long id;
    private String museumCode;        // 博物馆编码
    private String museumName;        // 博物馆名称
    private String museumType;        // 博物馆类型
    private String province;          // 省份
    private String city;              // 城市
    private String address;           // 详细地址
    private String contactPerson;     // 联系人
    private String contactPhone;      // 联系电话
    private String contactEmail;      // 联系邮箱
    private String description;       // 描述
    private Integer status;           // 合作状态：1-有合作，0-无合作
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
```

### 2. 控制器（MuseumController.java）

**分页查询**
```java
@GetMapping
public Result<PageResult<Museum>> page(
    @RequestParam(defaultValue = "1") Integer pageNum,
    @RequestParam(defaultValue = "10") Integer pageSize,
    @RequestParam(required = false) String museumName,
    @RequestParam(required = false) String city,
    @RequestParam(required = false) Integer status
)
```

**新增博物馆**
```java
@PostMapping
@OperationLog(operationType = "新增", operationModule = "博物馆管理", operationContent = "新增博物馆")
public Result<String> add(@RequestBody Museum museum)
```
- 检查编码是否已存在
- 检查名称是否已存在
- 默认合作状态为有合作

**更新博物馆**
```java
@PutMapping("/{id}")
@OperationLog(operationType = "修改", operationModule = "博物馆管理", operationContent = "修改博物馆信息")
public Result<String> update(@PathVariable Long id, @RequestBody Museum museum)
```

**删除博物馆**
```java
@DeleteMapping("/{id}")
@OperationLog(operationType = "删除", operationModule = "博物馆管理", operationContent = "删除博物馆")
public Result<String> delete(@PathVariable Long id)
```
- 采用逻辑删除方式
- 将博物馆状态改为0（无合作）
- 不会真正删除数据库记录
- 保留历史数据，便于追溯

### 3. 数据访问层（MuseumMapper.java）

**分页查询**
```java
@Select("<script>" +
        "SELECT * FROM museum WHERE 1=1 " +
        "<if test='museumName != null and museumName != \"\"'> AND museum_name LIKE CONCAT('%', #{museumName}, '%') </if>" +
        "<if test='city != null and city != \"\"'> AND city = #{city} </if>" +
        "<if test='status != null'> AND status = #{status} </if>" +
        "ORDER BY id ASC " +
        "</script>")
List<Museum> selectByPage(@Param("museumName") String museumName, 
                           @Param("city") String city, 
                           @Param("status") Integer status);
```

**说明**：查询结果按ID递增排序，确保博物馆按添加顺序显示。

### 4. 服务层（MuseumService.java）

**分页查询实现**
```java
@Override
public PageResult<Museum> pageMuseums(Integer pageNum, Integer pageSize, 
                                       String museumName, String city, Integer status) {
    int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
    int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
    
    List<Museum> list = museumMapper.selectByPage(museumName, city, status);
    long total = list.size();
    
    // 手动分页
    int fromIndex = (current - 1) * size;
    int toIndex = Math.min(fromIndex + size, list.size());
    
    List<Museum> records = fromIndex < list.size() ? 
        list.subList(fromIndex, toIndex) : new ArrayList<>();
    
    return new PageResult<>(records, total, current, size);
}
```

### 5. 安全配置（SecurityConfig.java）

```java
// 博物馆管理 - 仅管理员可以管理
.antMatchers("/museums/**").hasRole("ADMIN")
```

**注意**：`/museums/active` 接口需要公开访问（用于下拉选择），已在前面配置：
```java
.antMatchers(HttpMethod.GET, "/museums/active").permitAll()
```

### 6. 缓存配置

使用Redis缓存提高查询性能：
- 启用的博物馆列表缓存
- 博物馆详情缓存
- 按编码查询缓存
- 按名称查询缓存
- 增删改操作自动清除缓存

## 前端实现

### 1. API接口（museums.js）

```javascript
// 分页查询博物馆列表
export const getMuseumsPageApi = (params) => request.get('/museums', { params })

// 获取所有启用的博物馆（用于下拉选择）
export const getActiveMuseumsApi = () => request.get('/museums/active')

// 根据ID获取博物馆详情
export const getMuseumByIdApi = (id) => request.get(`/museums/${id}`)

// 新增博物馆
export const addMuseumApi = (data) => request.post('/museums', data)

// 更新博物馆
export const updateMuseumApi = (id, data) => request.put(`/museums/${id}`, data)

// 删除博物馆
export const deleteMuseumApi = (id) => request.delete(`/museums/${id}`)
```

### 2. 管理页面（MuseumsView.vue）

**功能组件**：
1. **搜索栏**
   - 博物馆名称搜索
   - 城市筛选
   - 合作状态筛选
   - 查询和重置按钮

2. **数据表格**
   - 显示博物馆编码、名称、类型、省份、城市、地址
   - 显示联系人、联系电话
   - 合作状态标签（有合作/无合作）
   - 操作按钮（编辑、删除）

3. **新增/编辑对话框**
   - 表单验证
   - 博物馆编码（新增时可编辑，编辑时禁用）
   - 博物馆名称
   - 博物馆类型（下拉选择）
   - 省份、城市
   - 详细地址
   - 联系人、联系电话、联系邮箱
   - 描述信息
   - 合作状态（单选按钮）

4. **分页组件**
   - 支持每页10/20/50/100条
   - 页码跳转

### 3. 表单验证规则

```javascript
const rules = {
  museumCode: [
    { required: true, message: '请输入博物馆编码', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  museumName: [
    { required: true, message: '请输入博物馆名称', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  museumType: [
    { required: true, message: '请选择博物馆类型', trigger: 'change' }
  ],
  province: [
    { required: true, message: '请输入省份', trigger: 'blur' }
  ],
  city: [
    { required: true, message: '请输入城市', trigger: 'blur' }
  ],
  contactPhone: [
    { pattern: /^1\d{10}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  contactEmail: [
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ]
}
```

### 4. 路由配置

```javascript
{ 
  path: '/museums', 
  component: () => import('../views/MuseumsView.vue'), 
  meta: { perm: 'users:manage' } 
}
```

### 5. 导航菜单

在 `LayoutView.vue` 中添加：
```vue
<el-menu-item v-if="hasPerm('users:manage')" index="/museums">
  博物馆管理
</el-menu-item>
```

## 博物馆类型

系统支持以下博物馆类型：
- 综合类：综合性博物馆，收藏多种类型文物
- 历史类：专注于历史文物和历史事件
- 艺术类：专注于艺术品收藏和展示
- 科技类：专注于科技文物和科技发展
- 自然类：专注于自然标本和自然科学
- 专题类：专注于特定主题的博物馆

## 操作日志

所有博物馆管理操作都会自动记录到操作日志：
- 新增博物馆
- 修改博物馆信息
- 删除博物馆

## 数据库表结构

```sql
CREATE TABLE museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    museum_code VARCHAR(20) NOT NULL UNIQUE COMMENT '博物馆编码',
    museum_name VARCHAR(50) NOT NULL UNIQUE COMMENT '博物馆名称',
    museum_type VARCHAR(20) COMMENT '博物馆类型',
    province VARCHAR(20) COMMENT '省份',
    city VARCHAR(20) COMMENT '城市',
    address VARCHAR(200) COMMENT '详细地址',
    contact_person VARCHAR(50) COMMENT '联系人',
    contact_phone VARCHAR(20) COMMENT '联系电话',
    contact_email VARCHAR(50) COMMENT '联系邮箱',
    description TEXT COMMENT '描述',
    status INT DEFAULT 1 COMMENT '合作状态：1-有合作，0-无合作',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## 使用场景

### 1. 新增博物馆
1. 管理员登录系统
2. 点击左侧菜单"博物馆管理"
3. 点击"新增博物馆"按钮
4. 填写博物馆信息
5. 点击"确定"保存

### 2. 编辑博物馆
1. 在博物馆列表中找到要编辑的博物馆
2. 点击"编辑"按钮
3. 修改博物馆信息
4. 点击"确定"保存

### 3. 删除博物馆
1. 在博物馆列表中找到要删除的博物馆
2. 点击"删除"按钮
3. 确认删除操作
4. 系统将博物馆状态改为"无合作"（逻辑删除）

**注意**：删除操作不会真正删除数据，只是将状态改为"无合作"。如需恢复，可通过编辑功能将状态改回"有合作"。

### 4. 查询博物馆
1. 在搜索栏输入博物馆名称或城市
2. 选择合作状态筛选
3. 点击"查询"按钮

## 注意事项

1. **博物馆编码唯一性**
   - 博物馆编码必须唯一
   - 编码一旦创建不可修改
   - 建议使用有意义的编码规则

2. **博物馆名称唯一性**
   - 博物馆名称必须唯一
   - 避免重复添加相同博物馆

3. **逻辑删除**
   - 删除操作不会真正删除数据
   - 只是将合作状态改为"无合作"
   - 保留历史数据，便于数据追溯和恢复
   - 如需恢复，可通过编辑将状态改回"有合作"

4. **权限控制**
   - 只有管理员可以管理博物馆
   - 其他角色只能查看有合作的博物馆列表

5. **缓存更新**
   - 增删改操作会自动清除缓存
   - 确保数据一致性

## 测试建议

### 1. 功能测试
- 测试新增博物馆
- 测试编辑博物馆
- 测试删除博物馆
- 测试分页查询
- 测试搜索筛选

### 2. 验证测试
- 测试博物馆编码唯一性验证
- 测试博物馆名称唯一性验证
- 测试必填字段验证
- 测试手机号格式验证
- 测试邮箱格式验证
- 测试逻辑删除（状态改为无合作）
- 测试删除后的数据恢复（编辑状态改回有合作）

### 3. 权限测试
- 测试管理员访问
- 测试非管理员访问（应被拒绝）
- 测试未登录访问（应跳转登录）

### 4. 边界测试
- 测试空数据列表
- 测试大量数据分页
- 测试特殊字符输入
- 测试超长文本输入

## 文件清单

### 后端文件
- `backend/src/main/java/com/example/entity/Museum.java` - 博物馆实体
- `backend/src/main/java/com/example/controller/MuseumController.java` - 博物馆控制器
- `backend/src/main/java/com/example/service/MuseumService.java` - 博物馆服务接口
- `backend/src/main/java/com/example/service/impl/MuseumServiceImpl.java` - 博物馆服务实现
- `backend/src/main/java/com/example/mapper/MuseumMapper.java` - 博物馆数据访问
- `backend/src/main/java/com/example/config/SecurityConfig.java` - 安全配置（权限）

### 前端文件
- `frontend/src/views/MuseumsView.vue` - 博物馆管理页面
- `frontend/src/api/museums.js` - 博物馆API接口
- `frontend/src/router/index.js` - 路由配置
- `frontend/src/views/LayoutView.vue` - 布局（导航菜单）

### 文档文件
- `backend/docs/MUSEUM_MANAGEMENT.md` - 本文档

## 更新日期
2026-04-24
