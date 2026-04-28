# 图片管理菜单不显示 - 快速修复指南

## 🚨 问题现象
系统管理员登录后，左侧菜单栏看不到"图片管理"菜单项。

## ✅ 快速解决方案

### 方法1：重新登录（推荐）⭐

1. **点击右上角"退出登录"按钮**
2. **重新登录**
   - 用户名：`admin`
   - 密码：`admin123`
3. **查看左侧菜单**
   - 应该能看到"图片管理"菜单项
   - 位置在"分类管理"和"借展管理"之间

### 方法2：清除权限缓存

如果不想退出登录，可以在浏览器控制台执行：

1. **按 F12 打开开发者工具**
2. **切换到 Console 标签**
3. **复制粘贴以下代码并回车：**
   ```javascript
   sessionStorage.removeItem('permissions');
   location.reload();
   ```
4. **页面会自动刷新并跳转到登录页**
5. **重新登录即可**

### 方法3：使用诊断工具

访问诊断页面自动检测问题：

```
http://localhost:5173/check-image-menu.html
```

该工具会自动检测：
- ✓ 用户登录状态
- ✓ 权限列表
- ✓ 图片管理权限
- ✓ 用户角色
- ✓ 菜单项渲染
- ✓ 路由配置

并提供详细的解决方案。

## 🔍 问题原因

**核心原因：** 权限信息在用户登录时获取并缓存在 `sessionStorage` 中。

- 如果在添加图片管理功能**之前**已经登录
- `sessionStorage` 中存储的是**旧的权限列表**
- 不包含新增的 `images:manage` 权限
- 因此菜单项不会显示

**解决方法：** 重新登录以获取最新的权限列表。

## 📋 验证步骤

### 1. 检查权限是否包含图片管理

在浏览器控制台（F12 → Console）执行：

```javascript
console.log(JSON.parse(sessionStorage.getItem('permissions')));
```

**应该看到：**
```javascript
[
  "dashboard:view",
  "relics:manage",
  "categories:manage",
  "images:manage",  // ← 必须包含这个
  "loans:manage",
  "maintenance:manage",
  "repairs:manage",
  "users:manage",
  "ai:query"
]
```

如果没有 `images:manage`，说明需要重新登录。

### 2. 检查菜单项是否渲染

在浏览器控制台执行：

```javascript
console.log(document.querySelector('[index="/images"]'));
```

- 如果返回 `null`：菜单项未渲染（权限问题）
- 如果返回 DOM 元素：菜单项已渲染（可能是样式问题）

### 3. 直接访问图片管理页面

在浏览器地址栏输入：

```
http://localhost:5173/images
```

- 如果能正常显示页面：说明路由和权限都正常，只是菜单不显示
- 如果显示 404：说明路由配置有问题
- 如果显示无权限：说明权限配置有问题

## 🎯 权限说明

图片管理功能的权限分配：

| 角色 | 角色代码 | 是否有权限 | 说明 |
|------|---------|-----------|------|
| 系统管理员 | ADMIN | ✅ 有 | 完全访问权限 |
| 文物管理员 | CURATOR | ✅ 有 | 完全访问权限 |
| 借展审批员 | APPROVER | ❌ 无 | 无法访问 |
| 借展人 | LOANER | ❌ 无 | 无法访问 |

## ❓ 常见问题

### Q1：重新登录后还是看不到菜单？

**A：** 请检查：
1. 确认使用的是 `admin` 或 `curator` 账号
2. 清除浏览器缓存（Ctrl+Shift+Delete）
3. 确认后端服务已重启
4. 查看浏览器控制台是否有错误

### Q2：我是 APPROVER 角色，为什么看不到？

**A：** 图片管理功能只对 ADMIN 和 CURATOR 角色开放，APPROVER 和 LOANER 角色无权访问。

### Q3：菜单显示了但点击没反应？

**A：** 检查：
1. 浏览器控制台是否有错误
2. 路由配置是否正确
3. 页面组件是否存在

### Q4：后端报错怎么办？

**A：** 确认：
1. 数据库表 `image_library` 已创建
2. 后端服务已重启
3. 查看后端日志获取详细错误信息

## 🛠️ 技术细节

### 权限检查机制

前端使用 `v-if` 指令控制菜单显示：

```vue
<el-menu-item v-if="hasPerm('images:manage')" index="/images">
  {{ $t('nav.images') }}
</el-menu-item>
```

`hasPerm` 函数实现：

```javascript
const permissions = computed(() => 
  JSON.parse(sessionStorage.getItem('permissions') || '[]')
)

const hasPerm = (perm) => permissions.value.includes(perm)
```

### 权限获取流程

```
用户登录
  ↓
调用 /auth/login 接口
  ↓
调用 /auth/permissions?username=xxx 接口
  ↓
返回权限列表（包含 images:manage）
  ↓
保存到 sessionStorage.permissions
  ↓
Vue 组件读取权限
  ↓
根据权限显示/隐藏菜单项
```

## 📞 需要帮助？

如果以上方法都无法解决问题，请：

1. **使用诊断工具：** 访问 `/check-image-menu.html`
2. **查看详细文档：** `docs/IMAGE_MENU_TROUBLESHOOTING.md`
3. **查看验证清单：** `docs/IMAGE_MANAGEMENT_VERIFICATION.md`

---

**最后更新：** 2024-01-XX  
**适用版本：** v1.1.0+
