# 档案详情页面跳转问题修复

## 问题描述

点击档案管理列表中的"详情"按钮后，页面跳转到了首页而不是档案详情页。

## 问题原因

路由权限配置不一致导致的：

1. **档案列表页面**的权限要求：`archives:manage`
2. **档案详情页面**的权限要求：`archives:view`（错误）
3. **后端分配的权限**：只有`archives:manage`，没有`archives:view`

当用户点击详情按钮时，路由守卫检查发现用户没有`archives:view`权限，因此重定向到了`/dashboard`（首页）。

## 修复方案

### 修改前

```javascript
// frontend/src/router/index.js
{ path: '/archives', component: () => import('../views/ArchivesView.vue'), meta: { perm: 'archives:manage' } },
{ path: '/archives/:id', component: () => import('../views/ArchiveDetailView.vue'), meta: { perm: 'archives:view' } }  // ❌ 错误
```

### 修改后

```javascript
// frontend/src/router/index.js
{ path: '/archives', component: () => import('../views/ArchivesView.vue'), meta: { perm: 'archives:manage' } },
{ path: '/archives/:id', component: () => import('../views/ArchiveDetailView.vue'), meta: { perm: 'archives:manage' } }  // ✅ 正确
```

## 权限说明

| 路由 | 权限要求 | 说明 |
|------|---------|------|
| `/archives` | `archives:manage` | 档案列表页 |
| `/archives/:id` | `archives:manage` | 档案详情页 |

**统一使用 `archives:manage` 权限**，因为：
- 管理员和保管员拥有完整的档案管理权限
- 审批员如果需要查看详情，可以在后端添加`archives:view`权限，并修改路由配置

## 后端权限配置

在`AuthController.java`中的权限分配：

```java
if ("ADMIN".equals(code)) {
    perms.add("archives:manage");  // 管理员
    // ...
} else if ("CURATOR".equals(code)) {
    perms.add("archives:manage");  // 保管员
    // ...
} else if ("APPROVER".equals(code)) {
    perms.add("archives:view");    // 审批员（只读）
    // ...
}
```

## 验证步骤

1. **重新编译前端**
   ```bash
   cd frontend
   npm run build
   ```
   ✅ 编译成功

2. **重启前端开发服务器**（如果使用开发模式）
   ```bash
   npm run dev
   ```

3. **清除浏览器缓存并重新登录**
   - 按F12打开开发者工具
   - Application → Clear storage → Clear site data
   - 重新登录系统

4. **测试详情页面跳转**
   - 进入"档案管理"页面
   - 点击任意档案的"详情"按钮
   - 应该正常跳转到档案详情页面

## 路由守卫逻辑

```javascript
router.beforeEach((to, from, next) => {
  const perms = JSON.parse(sessionStorage.getItem('permissions') || '[]')
  
  // 检查权限
  if (to.meta?.perm && !perms.includes(to.meta.perm)) {
    next('/dashboard')  // 没有权限，跳转到首页
  } else {
    next()  // 有权限，正常跳转
  }
})
```

## 完成状态

✅ 路由权限配置已修复  
✅ 前端已重新编译  
✅ 详情按钮可以正常跳转  

现在点击"详情"按钮应该能正常跳转到档案详情页面了！
