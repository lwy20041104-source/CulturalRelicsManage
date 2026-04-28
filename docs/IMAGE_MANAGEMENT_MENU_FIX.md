# 图片管理菜单显示问题修复

## 问题描述

后台管理系统中没有显示"图片管理"菜单项。

## 问题原因

1. 前端导航菜单中没有添加图片管理菜单项
2. 后端权限配置中没有添加`images:manage`权限
3. SecurityConfig中没有配置图片管理接口的访问权限

## 解决方案

### 1. 前端菜单配置

**文件：** `frontend/src/views/LayoutView.vue`

**修改内容：**
```vue
<el-menu router :default-active="$route.path" class="menu">
  <el-menu-item index="/dashboard">首页</el-menu-item>
  <el-menu-item index="/data-screen">{{ $t('nav.dataScreen') }}</el-menu-item>
  <el-menu-item index="/reports">{{ $t('nav.reports') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('users:manage')" index="/users">{{ $t('nav.users') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('relics:manage')" index="/relics">{{ $t('nav.relics') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('categories:manage')" index="/categories">{{ $t('nav.categories') }}</el-menu-item>
  <!-- 新增：图片管理菜单 -->
  <el-menu-item v-if="hasPerm('images:manage')" index="/images">{{ $t('nav.images') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('loans:manage')" index="/loans">{{ $t('nav.loans') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('maintenance:manage')" index="/maintenance">{{ $t('nav.maintenance') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('repairs:manage')" index="/repairs">{{ $t('nav.repairs') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('repairs:manage')" index="/experts">{{ $t('nav.experts') }}</el-menu-item>
  <el-menu-item v-if="hasPerm('users:manage')" index="/operation-logs">操作日志</el-menu-item>
  <el-menu-item v-if="hasPerm('users:manage')" index="/ai-chat-history">AI对话历史</el-menu-item>
  <el-menu-item index="/ai-query">{{ $t('nav.aiQuery') }}</el-menu-item>
</el-menu>
```

**说明：**
- 添加了图片管理菜单项
- 路由路径：`/images`
- 权限控制：`images:manage`
- 显示文本：使用国际化`$t('nav.images')`

### 2. 后端权限配置

**文件：** `backend/src/main/java/com/example/controller/AuthController.java`

**修改内容：**
```java
SysRole role = sysRoleMapper.selectById(user.getRoleId());
if (role != null) {
    String code = role.getRoleCode();
    if ("ADMIN".equals(code)) {
        perms.add("dashboard:view");
        perms.add("relics:manage");
        perms.add("categories:manage");
        perms.add("images:manage");  // 新增
        perms.add("loans:manage");
        perms.add("maintenance:manage");
        perms.add("repairs:manage");
        perms.add("users:manage");
        perms.add("ai:query");
    } else if ("CURATOR".equals(code)) {
        perms.add("dashboard:view");
        perms.add("relics:manage");
        perms.add("categories:manage");
        perms.add("images:manage");  // 新增
        perms.add("maintenance:manage");
        perms.add("repairs:manage");
        perms.add("ai:query");
    } else if ("APPROVER".equals(code)) {
        perms.add("dashboard:view");
        perms.add("loans:manage");
        perms.add("ai:query");
    }
}
```

**说明：**
- 为ADMIN（系统管理员）角色添加`images:manage`权限
- 为CURATOR（文物管理员）角色添加`images:manage`权限
- APPROVER（借展审批员）和LOANER（借展人）不需要图片管理权限

### 3. SecurityConfig配置

**文件：** `backend/src/main/java/com/example/config/SecurityConfig.java`

**修改内容：**
```java
// 管理员和保管员的写权限
.antMatchers("/users/**").hasRole("ADMIN")
.antMatchers("/relics/**", "/categories/**").hasAnyRole("ADMIN", "CURATOR")
.antMatchers("/images/**").hasAnyRole("ADMIN", "CURATOR")  // 新增
.antMatchers("/loans/**").hasAnyRole("ADMIN", "APPROVER")
.antMatchers("/maintenance/**").hasAnyRole("ADMIN", "CURATOR")
```

**说明：**
- 配置`/images/**`接口的访问权限
- 只有ADMIN和CURATOR角色可以访问
- 包括所有图片管理相关的API接口

## 权限说明

### 角色权限对照表

| 角色 | 角色代码 | 图片管理权限 | 说明 |
|------|---------|-------------|------|
| 系统管理员 | ADMIN | ✅ 有权限 | 可以管理所有图片 |
| 文物管理员 | CURATOR | ✅ 有权限 | 可以管理文物相关图片 |
| 借展审批员 | APPROVER | ❌ 无权限 | 不需要管理图片 |
| 借展人 | LOANER | ❌ 无权限 | 只能查看，不能管理 |

### 权限控制流程

1. **前端权限控制**
   - 用户登录后，从后端获取权限列表
   - 权限列表存储在`sessionStorage`中
   - 菜单项根据权限动态显示/隐藏
   - 使用`v-if="hasPerm('images:manage')"`控制

2. **后端权限控制**
   - Spring Security配置接口访问权限
   - 使用`hasAnyRole("ADMIN", "CURATOR")`控制
   - 无权限访问会返回403 Forbidden

## 验证步骤

### 1. 重启后端服务
```bash
cd backend
mvn clean package
java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
```

### 2. 刷新前端页面
```bash
# 如果是开发模式，前端会自动热更新
# 如果是生产模式，需要重新构建
cd frontend
npm run build
```

### 3. 测试菜单显示

#### 测试ADMIN角色
1. 使用admin账号登录
2. 查看左侧菜单
3. 应该能看到"图片管理"菜单项
4. 点击菜单，应该能正常访问图片管理页面

#### 测试CURATOR角色
1. 使用curator账号登录
2. 查看左侧菜单
3. 应该能看到"图片管理"菜单项
4. 点击菜单，应该能正常访问图片管理页面

#### 测试APPROVER角色
1. 使用approver账号登录
2. 查看左侧菜单
3. 不应该看到"图片管理"菜单项

#### 测试LOANER角色
1. 使用loaner账号登录（前台登录）
2. 前台页面不显示图片管理功能

### 4. 测试API权限

#### 有权限的角色（ADMIN/CURATOR）
```bash
# 获取图片列表
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/images

# 应该返回200 OK
```

#### 无权限的角色（APPROVER/LOANER）
```bash
# 获取图片列表
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/images

# 应该返回403 Forbidden
```

## 菜单位置

图片管理菜单位于：
- 首页
- 数据大屏
- 数据报表
- 用户管理
- 文物管理
- 分类管理
- **图片管理** ← 新增位置
- 借展管理
- 维护记录
- 修复管理
- 修复专家
- 操作日志
- AI对话历史
- AI查询

## 国际化支持

菜单文本已支持中英文：
- 中文：图片管理
- 英文：Images

翻译配置在：
- `frontend/src/i18n/locales/zh-CN.js`
- `frontend/src/i18n/locales/en-US.js`

## 故障排查

### 问题1：菜单不显示

**可能原因：**
1. 用户角色没有`images:manage`权限
2. 前端权限列表未更新
3. 浏览器缓存问题

**解决方案：**
1. 检查用户角色是否为ADMIN或CURATOR
2. 重新登录刷新权限
3. 清除浏览器缓存（Ctrl+Shift+Delete）

### 问题2：点击菜单报404

**可能原因：**
1. 路由配置错误
2. 组件未正确导入

**解决方案：**
1. 检查`router/index.js`中是否有`/images`路由
2. 检查`ImageLibraryView.vue`组件是否存在
3. 检查组件导入路径是否正确

### 问题3：访问接口返回403

**可能原因：**
1. SecurityConfig配置错误
2. 用户角色权限不足
3. Token过期

**解决方案：**
1. 检查SecurityConfig中`/images/**`的配置
2. 确认用户角色为ADMIN或CURATOR
3. 重新登录获取新Token

## 总结

通过以下三个步骤完成了图片管理菜单的配置：

1. ✅ 前端添加菜单项（LayoutView.vue）
2. ✅ 后端添加权限配置（AuthController.java）
3. ✅ 配置接口访问权限（SecurityConfig.java）

现在ADMIN和CURATOR角色的用户可以在后台管理系统中看到并访问"图片管理"菜单了！
