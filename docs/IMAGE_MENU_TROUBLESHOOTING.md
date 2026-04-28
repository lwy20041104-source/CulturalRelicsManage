# 图片管理菜单不显示问题排查指南

## 问题描述
系统管理员端的侧边栏没有显示"图片管理"菜单项。

## 原因分析
权限信息在用户登录时获取并存储在 `sessionStorage` 中。如果在添加图片管理功能之前已经登录，`sessionStorage` 中存储的是旧的权限列表，不包含 `images:manage` 权限。

## 解决方案

### 方案1：重新登录（推荐）✅

1. **退出登录**
   - 点击右上角的"退出登录"按钮
   - 或者直接访问：http://localhost:5173/login

2. **清除浏览器缓存**（可选但推荐）
   - 按 `Ctrl + Shift + Delete`
   - 选择"缓存的图片和文件"
   - 点击"清除数据"

3. **重新登录**
   - 使用 admin 账号登录
   - 用户名：`admin`
   - 密码：`admin123`

4. **验证菜单显示**
   - 登录后查看左侧菜单
   - 应该能看到"图片管理"菜单项
   - 位置在"分类管理"和"借展管理"之间

### 方案2：手动清除 SessionStorage

如果不想退出登录，可以在浏览器控制台手动清除权限缓存：

1. **打开浏览器开发者工具**
   - 按 `F12` 或 `Ctrl + Shift + I`

2. **打开控制台（Console）**
   - 点击顶部的 "Console" 标签

3. **执行以下命令**
   ```javascript
   // 清除权限缓存
   sessionStorage.removeItem('permissions');
   
   // 刷新页面
   location.reload();
   ```

4. **重新登录**
   - 页面会跳转到登录页
   - 重新登录即可获取新权限

### 方案3：检查后端服务

如果重新登录后仍然看不到菜单，检查后端服务：

1. **确认后端服务已重启**
   ```bash
   cd backend
   mvn clean package
   java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
   ```

2. **检查权限接口**
   - 打开浏览器开发者工具（F12）
   - 切换到 Network 标签
   - 登录后查找 `/auth/permissions` 请求
   - 查看响应数据中是否包含 `images:manage`

3. **预期响应示例**
   ```json
   {
     "code": 200,
     "message": "success",
     "data": [
       "dashboard:view",
       "relics:manage",
       "categories:manage",
       "images:manage",  // ← 应该包含这个
       "loans:manage",
       "maintenance:manage",
       "repairs:manage",
       "users:manage",
       "ai:query"
     ]
   }
   ```

## 验证步骤

### 1. 检查权限是否正确获取

在浏览器控制台执行：
```javascript
// 查看当前权限列表
console.log(JSON.parse(sessionStorage.getItem('permissions')));
```

**预期输出：**
```javascript
[
  "dashboard:view",
  "relics:manage",
  "categories:manage",
  "images:manage",  // ← 应该包含这个
  "loans:manage",
  "maintenance:manage",
  "repairs:manage",
  "users:manage",
  "ai:query"
]
```

### 2. 检查菜单项是否存在

在浏览器控制台执行：
```javascript
// 检查菜单项是否被渲染
document.querySelector('[index="/images"]');
```

**如果返回 `null`：** 说明权限检查失败，菜单项未渲染
**如果返回 DOM 元素：** 说明菜单项已渲染，可能是样式问题

### 3. 检查路由是否配置

访问：http://localhost:5173/images

**如果显示 404：** 路由配置有问题
**如果显示页面：** 说明路由正常，只是菜单不显示

## 常见问题

### Q1：重新登录后还是看不到菜单？

**A：** 检查以下几点：
1. 确认使用的是 `admin` 或 `curator` 账号（不是 `approver` 或 `loaner`）
2. 检查后端 `AuthController.java` 中的权限配置
3. 查看浏览器控制台是否有 JavaScript 错误
4. 确认前端代码已保存并重新编译

### Q2：其他角色能看到图片管理菜单吗？

**A：** 权限分配如下：
- ✅ **ADMIN（系统管理员）**：有权限
- ✅ **CURATOR（文物管理员）**：有权限
- ❌ **APPROVER（借展审批员）**：无权限
- ❌ **LOANER（借展人）**：无权限

### Q3：菜单显示了但点击没反应？

**A：** 检查：
1. 路由配置是否正确（`frontend/src/router/index.js`）
2. 页面组件是否存在（`frontend/src/views/ImageLibraryView.vue`）
3. 浏览器控制台是否有错误信息

### Q4：菜单位置不对？

**A：** 图片管理菜单应该在：
- 分类管理（Categories）之后
- 借展管理（Loans）之前

如果位置不对，检查 `frontend/src/views/LayoutView.vue` 中的菜单顺序。

## 技术细节

### 权限检查机制

前端使用 `v-if="hasPerm('images:manage')"` 来控制菜单显示：

```vue
<el-menu-item v-if="hasPerm('images:manage')" index="/images">
  {{ $t('nav.images') }}
</el-menu-item>
```

`hasPerm` 函数定义：
```javascript
const permissions = computed(() => 
  JSON.parse(sessionStorage.getItem('permissions') || '[]')
)

const hasPerm = (perm) => permissions.value.includes(perm)
```

### 权限获取流程

1. **用户登录** → 调用 `/auth/login` 接口
2. **获取权限** → 调用 `/auth/permissions?username=xxx` 接口
3. **存储权限** → 保存到 `sessionStorage.permissions`
4. **渲染菜单** → 根据权限显示/隐藏菜单项

### 后端权限配置

在 `AuthController.java` 的 `permissions` 方法中：

```java
if ("ADMIN".equals(code)) {
    perms.add("dashboard:view");
    perms.add("relics:manage");
    perms.add("categories:manage");
    perms.add("images:manage");  // ← 图片管理权限
    perms.add("loans:manage");
    perms.add("maintenance:manage");
    perms.add("repairs:manage");
    perms.add("users:manage");
    perms.add("ai:query");
}
```

## 快速诊断命令

在浏览器控制台依次执行以下命令进行诊断：

```javascript
// 1. 检查当前用户
console.log('用户名:', sessionStorage.getItem('username'));
console.log('角色:', sessionStorage.getItem('roleCode'));

// 2. 检查权限列表
console.log('权限列表:', JSON.parse(sessionStorage.getItem('permissions') || '[]'));

// 3. 检查是否有图片管理权限
const perms = JSON.parse(sessionStorage.getItem('permissions') || '[]');
console.log('有图片管理权限:', perms.includes('images:manage'));

// 4. 检查菜单项是否渲染
console.log('菜单项存在:', !!document.querySelector('[index="/images"]'));

// 5. 检查国际化配置
console.log('菜单文本:', document.querySelector('[index="/images"]')?.textContent);
```

## 联系支持

如果以上方法都无法解决问题，请提供以下信息：

1. 浏览器控制台的完整输出
2. Network 标签中 `/auth/permissions` 请求的响应
3. 使用的账号和角色
4. 前端和后端的版本信息

---

**最后更新：** 2024-01-XX
**文档版本：** 1.0
