# 档案管理菜单显示问题修复

## 问题描述

前端菜单栏没有显示"📚 档案管理"菜单项。

## 问题原因

虽然前端`LayoutView.vue`中已经添加了档案管理菜单项：

```vue
<el-menu-item v-if="hasPerm('archives:manage')" index="/archives">📚 档案管理</el-menu-item>
```

但是后端`AuthController.java`的`permissions`方法中没有为用户角色添加`archives:manage`权限，导致前端权限检查失败，菜单项被隐藏。

## 解决方案

在`backend/src/main/java/com/example/controller/AuthController.java`的`permissions`方法中，为不同角色添加档案管理权限：

### 修改前

```java
if ("ADMIN".equals(code)) {
    perms.add("dashboard:view");
    perms.add("relics:manage");
    perms.add("categories:manage");
    perms.add("images:manage");
    perms.add("loans:manage");
    perms.add("maintenance:manage");
    perms.add("repairs:manage");
    perms.add("users:manage");
    perms.add("ai:query");
} else if ("CURATOR".equals(code)) {
    perms.add("dashboard:view");
    perms.add("relics:manage");
    perms.add("categories:manage");
    perms.add("images:manage");
    perms.add("maintenance:manage");
    perms.add("repairs:manage");
    perms.add("ai:query");
} else if ("APPROVER".equals(code)) {
    perms.add("dashboard:view");
    perms.add("loans:manage");
    perms.add("ai:query");
}
```

### 修改后

```java
if ("ADMIN".equals(code)) {
    perms.add("dashboard:view");
    perms.add("relics:manage");
    perms.add("categories:manage");
    perms.add("images:manage");
    perms.add("archives:manage");  // ✅ 新增
    perms.add("loans:manage");
    perms.add("maintenance:manage");
    perms.add("repairs:manage");
    perms.add("users:manage");
    perms.add("ai:query");
} else if ("CURATOR".equals(code)) {
    perms.add("dashboard:view");
    perms.add("relics:manage");
    perms.add("categories:manage");
    perms.add("images:manage");
    perms.add("archives:manage");  // ✅ 新增
    perms.add("maintenance:manage");
    perms.add("repairs:manage");
    perms.add("ai:query");
} else if ("APPROVER".equals(code)) {
    perms.add("dashboard:view");
    perms.add("archives:view");    // ✅ 新增（只读权限）
    perms.add("loans:manage");
    perms.add("ai:query");
}
```

## 权限说明

| 角色 | 权限 | 说明 |
|------|------|------|
| ADMIN（管理员） | `archives:manage` | 完整权限：创建、编辑、删除、发布、归档、导出 |
| CURATOR（保管员） | `archives:manage` | 完整权限：创建、编辑、删除、发布、归档、导出 |
| APPROVER（审批员） | `archives:view` | 只读权限：查看档案、查看文档、导出 |

## 验证步骤

1. **重新编译后端**
   ```bash
   cd backend
   mvn clean compile -DskipTests
   ```
   ✅ 编译成功

2. **重启后端服务**
   ```bash
   mvn spring-boot:run
   ```

3. **清除浏览器缓存并重新登录**
   - 打开浏览器开发者工具（F12）
   - 清除应用程序存储（Application → Clear storage）
   - 或者使用无痕模式
   - 重新登录系统

4. **验证菜单显示**
   - 使用管理员或保管员账号登录
   - 检查左侧菜单是否显示"📚 档案管理"
   - 点击菜单项，应该能正常跳转到档案列表页

## 前端权限检查逻辑

前端通过以下方式检查权限：

```javascript
// LayoutView.vue
const permissions = computed(() => JSON.parse(sessionStorage.getItem('permissions') || '[]'))
const hasPerm = (perm) => permissions.value.includes(perm)
```

菜单项只有在用户拥有对应权限时才会显示：

```vue
<el-menu-item v-if="hasPerm('archives:manage')" index="/archives">📚 档案管理</el-menu-item>
```

## 后端权限控制

后端在`SecurityConfig.java`中配置了档案管理的访问权限：

```java
// 档案管理权限
.antMatchers(HttpMethod.GET, "/archives/**").hasAnyRole("ADMIN", "CURATOR", "APPROVER")
.antMatchers(HttpMethod.POST, "/archives/**").hasAnyRole("ADMIN", "CURATOR")
.antMatchers(HttpMethod.PUT, "/archives/**").hasAnyRole("ADMIN", "CURATOR")
.antMatchers(HttpMethod.DELETE, "/archives/**").hasAnyRole("ADMIN", "CURATOR")
```

## 注意事项

1. **必须重新登录** - 权限信息在登录时获取并存储在sessionStorage中，修改权限配置后需要重新登录才能生效

2. **清除缓存** - 如果重新登录后仍然看不到菜单，请清除浏览器缓存

3. **检查角色** - 确保当前登录用户的角色是ADMIN、CURATOR或APPROVER

4. **后端必须重启** - 修改Java代码后必须重启后端服务

## 测试账号

根据系统配置，可以使用以下角色的账号测试：

- **管理员（ADMIN）** - 应该能看到"📚 档案管理"菜单，拥有完整权限
- **保管员（CURATOR）** - 应该能看到"📚 档案管理"菜单，拥有完整权限
- **审批员（APPROVER）** - 应该能看到"📚 档案管理"菜单，但只有查看权限

## 完成状态

✅ 后端权限配置已修改  
✅ 后端编译成功  
✅ 前端菜单项已存在  
✅ 权限检查逻辑正确  

现在重启后端服务并重新登录，应该能看到"📚 档案管理"菜单了！
