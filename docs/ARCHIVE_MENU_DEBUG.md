# 档案管理菜单调试指南

## 问题排查步骤

### 第1步：检查后端是否已重启

确保后端服务已经重启，使用修改后的权限配置：

```bash
cd backend
mvn spring-boot:run
```

等待后端完全启动（看到"Started CulturalRelicsApplication"）。

### 第2步：检查前端是否已重新编译

前端已重新编译 ✅

如果你使用的是开发模式（`npm run dev`），需要重启开发服务器：

```bash
cd frontend
# 按 Ctrl+C 停止当前服务
npm run dev
```

### 第3步：完全清除浏览器缓存

**方法1：使用开发者工具**
1. 打开浏览器（Chrome/Edge）
2. 按 F12 打开开发者工具
3. 右键点击刷新按钮
4. 选择"清空缓存并硬性重新加载"

**方法2：清除应用数据**
1. 按 F12 打开开发者工具
2. 进入 Application（应用程序）标签
3. 左侧找到 Storage（存储）
4. 点击 "Clear site data"（清除网站数据）
5. 确认清除

**方法3：使用无痕模式**
1. 按 Ctrl+Shift+N（Chrome）或 Ctrl+Shift+P（Edge）
2. 在无痕窗口中访问系统

### 第4步：重新登录并检查权限

1. **登录系统**
   - 使用管理员账号登录

2. **打开浏览器控制台**
   - 按 F12 打开开发者工具
   - 切换到 Console（控制台）标签

3. **检查权限数据**
   
   在控制台输入以下命令：
   
   ```javascript
   // 查看当前用户权限
   console.log(JSON.parse(sessionStorage.getItem('permissions')))
   
   // 查看用户名
   console.log(sessionStorage.getItem('username'))
   
   // 查看角色
   console.log(sessionStorage.getItem('role'))
   ```

4. **预期结果**
   
   如果是管理员或保管员，应该看到权限列表中包含：
   ```javascript
   [
     "dashboard:view",
     "relics:manage",
     "categories:manage",
     "images:manage",
     "archives:manage",  // ← 应该有这个
     "loans:manage",
     "maintenance:manage",
     "repairs:manage",
     "users:manage",
     "ai:query"
   ]
   ```

### 第5步：检查菜单渲染

在浏览器控制台输入：

```javascript
// 检查hasPerm函数
const permissions = JSON.parse(sessionStorage.getItem('permissions') || '[]')
const hasPerm = (perm) => permissions.includes(perm)

// 测试档案管理权限
console.log('archives:manage =', hasPerm('archives:manage'))
console.log('archives:view =', hasPerm('archives:view'))
```

**预期结果：**
- 管理员/保管员：`archives:manage = true`
- 审批员：`archives:view = true`

### 第6步：手动访问档案管理页面

即使菜单不显示，也可以尝试直接访问：

在浏览器地址栏输入：
```
http://localhost:5173/archives
```

如果能正常访问，说明路由和页面都是正常的，只是菜单权限检查有问题。

## 临时解决方案

如果以上步骤都无法解决，可以临时移除权限检查：

### 方案1：移除权限检查（临时）

编辑 `frontend/src/views/LayoutView.vue`，找到档案管理菜单项：

```vue
<!-- 原来的（有权限检查） -->
<el-menu-item v-if="hasPerm('archives:manage') || hasPerm('archives:view')" index="/archives">📚 档案管理</el-menu-item>

<!-- 改为（无权限检查，所有人都能看到） -->
<el-menu-item index="/archives">📚 档案管理</el-menu-item>
```

然后重新编译：
```bash
cd frontend
npm run build
```

### 方案2：添加调试信息

在 `frontend/src/views/LayoutView.vue` 的 `<script setup>` 部分添加：

```javascript
import { onMounted } from 'vue'

onMounted(() => {
  console.log('=== 权限调试信息 ===')
  console.log('用户名:', username.value)
  console.log('真实姓名:', realName.value)
  console.log('权限列表:', permissions.value)
  console.log('archives:manage:', hasPerm('archives:manage'))
  console.log('archives:view:', hasPerm('archives:view'))
})
```

## 常见问题

### Q1: 权限列表中没有 archives:manage

**原因：** 后端没有重启，或者登录时使用的是旧的权限配置

**解决：**
1. 确认后端已重启
2. 完全退出登录
3. 清除浏览器缓存
4. 重新登录

### Q2: 控制台显示 hasPerm is not defined

**原因：** 前端代码有问题

**解决：** 检查 LayoutView.vue 中的 hasPerm 函数定义

### Q3: 菜单显示了但点击没反应

**原因：** 路由配置问题

**解决：** 检查 `frontend/src/router/index.js` 中是否有 `/archives` 路由

### Q4: 提示没有权限访问

**原因：** 后端 SecurityConfig 没有配置正确

**解决：** 检查 `backend/src/main/java/com/example/config/SecurityConfig.java`

## 验证清单

- [ ] 后端已重启
- [ ] 前端已重新编译（或重启开发服务器）
- [ ] 浏览器缓存已清除
- [ ] 已重新登录
- [ ] 控制台显示权限列表包含 `archives:manage` 或 `archives:view`
- [ ] 菜单中显示"📚 档案管理"
- [ ] 点击菜单能正常跳转

## 当前配置状态

✅ 后端权限配置已修改（AuthController.java）  
✅ 前端菜单项已添加（LayoutView.vue）  
✅ 前端已重新编译  
✅ 路由已配置（/archives 和 /archives/:id）  
✅ 权限检查已放宽（支持 archives:manage 或 archives:view）  

## 下一步

1. **重启后端服务**
2. **清除浏览器缓存**
3. **重新登录**
4. **在控制台检查权限**
5. **查看菜单是否显示**

如果还是不行，请提供：
- 控制台中的权限列表输出
- 当前登录的用户角色
- 浏览器控制台是否有错误信息
