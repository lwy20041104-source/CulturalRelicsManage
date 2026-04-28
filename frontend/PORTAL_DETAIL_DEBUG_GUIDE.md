# 前台门户文物详情调试指南

## 问题描述
用户反馈：未登录跟已登录的用户显示的东西是一样的，未登录用户还多一个二维码

## 已修复的问题

### 1. ✅ 修复 AI 搜索结果中的图片字段
- 文件：`frontend/src/views/PublicPortalView.vue`
- 位置：`viewRelicDetailFromAi` 函数（约第1967行）
- 修改：`imageUrl: relic.imagePath` → `imagePath: relic.imagePath`

### 2. ✅ 添加调试信息（已注释）
- 在详情对话框中添加了调试信息（已注释掉）
- 可以取消注释来查看 `isLoggedIn` 的实际值

## 调试步骤

### 步骤1：启用调试信息

在 `frontend/src/views/PublicPortalView.vue` 文件的第906-909行，取消注释调试信息：

```vue
<!-- 修改前（注释状态） -->
<!-- <div style="background: #f0f0f0; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
  <p style="margin: 0; font-size: 12px;">调试信息: isLoggedIn = {{ isLoggedIn }}</p>
  <p style="margin: 0; font-size: 12px;">Token: {{ sessionStorage.getItem('token') ? '存在' : '不存在' }}</p>
</div> -->

<!-- 修改后（启用调试） -->
<div style="background: #f0f0f0; padding: 10px; margin-bottom: 10px; border-radius: 4px;">
  <p style="margin: 0; font-size: 12px;">调试信息: isLoggedIn = {{ isLoggedIn }}</p>
  <p style="margin: 0; font-size: 12px;">Token: {{ sessionStorage.getItem('token') ? '存在' : '不存在' }}</p>
</div>
```

### 步骤2：清除浏览器缓存和存储

#### 方法1：使用开发者工具
1. 按 `F12` 打开开发者工具
2. 切换到 "Application" 或 "应用程序" 标签
3. 左侧选择 "Session Storage"
4. 找到你的网站（如 `http://localhost:5173`）
5. 右键点击 → "Clear" 或 "清除"
6. 左侧选择 "Local Storage"
7. 同样清除
8. 按 `Ctrl + Shift + R` 强制刷新

#### 方法2：使用无痕模式
1. 按 `Ctrl + Shift + N`（Chrome/Edge）或 `Ctrl + Shift + P`（Firefox）
2. 打开无痕窗口
3. 访问 `http://localhost:5173/portal`

### 步骤3：测试未登录状态

1. 确保已清除所有存储（参考步骤2）
2. 访问 `http://localhost:5173/portal`
3. 滚动到"文物搜索"部分
4. 点击任意文物卡片
5. 查看详情对话框

**预期结果：**
- ✅ 调试信息显示：`isLoggedIn = false`
- ✅ 调试信息显示：`Token: 不存在`
- ✅ 只显示3个字段：文物名称、年代、分类
- ✅ 显示登录提示："想了解更多？登录后可查看更多详细信息"
- ✅ 图片正常显示

**如果结果不符合预期：**
- 检查 sessionStorage 中是否有 `token`
- 检查控制台是否有错误
- 截图调试信息并提供

### 步骤4：测试已登录状态

1. 访问 `http://localhost:5173/portal-login`
2. 使用有效账号登录
3. 登录成功后返回首页
4. 滚动到"文物搜索"部分
5. 点击任意文物卡片
6. 查看详情对话框

**预期结果：**
- ✅ 调试信息显示：`isLoggedIn = true`
- ✅ 调试信息显示：`Token: 存在`
- ✅ 显示10个字段：文物编号、文物名称、年代、材质、分类、状态、尺寸、重量、来源、描述
- ✅ 不显示登录提示
- ✅ 图片正常显示

**如果结果不符合预期：**
- 检查登录是否成功
- 检查 sessionStorage 中是否有 `token`
- 检查控制台是否有错误
- 截图调试信息并提供

## 可能的问题和解决方案

### 问题1：两种状态显示相同内容

**可能原因：**
1. 浏览器缓存了旧版本代码
2. sessionStorage 中有残留的 token
3. `isLoggedIn` 计算属性没有正确工作

**解决方案：**
```bash
# 1. 停止开发服务器
Ctrl + C

# 2. 清除 Vite 缓存
rm -rf node_modules/.vite
# Windows PowerShell:
Remove-Item -Recurse -Force node_modules/.vite

# 3. 重新启动
npm run dev

# 4. 在浏览器中：
# - 按 F12 打开开发者工具
# - 切换到 Application 标签
# - 清除所有 Storage
# - 按 Ctrl + Shift + R 强制刷新
```

### 问题2：未登录用户看到二维码

**检查点：**
1. 确认是在 `PublicPortalView.vue` 页面（`/portal`）
2. 不是在 `PublicRelicsView.vue` 页面（`/public-relics`）

**说明：**
- `PublicPortalView.vue`（`/portal`）：前台门户首页，已修改为根据登录状态显示不同内容
- `PublicRelicsView.vue`（`/public-relics`）：前台文物查询页面，可能有不同的实现

如果问题出现在 `/public-relics` 页面，需要单独修改该文件。

### 问题3：图片不显示

**检查点：**
1. 打开浏览器控制台（F12）
2. 切换到 "Network" 标签
3. 刷新页面
4. 查看图片请求是否成功
5. 检查图片 URL 是否正确

**常见问题：**
- 图片路径错误
- 后端服务未启动
- 图片文件不存在

## 代码验证

### 验证1：isLoggedIn 计算属性

在 `frontend/src/views/PublicPortalView.vue` 约第1539行：

```javascript
const isLoggedIn = computed(() => {
  return !!sessionStorage.getItem('token')
})
```

### 验证2：详情对话框条件渲染

在 `frontend/src/views/PublicPortalView.vue` 约第912-975行：

```vue
<!-- 已登录用户：显示完整信息 -->
<template v-if="isLoggedIn">
  <!-- 10个字段 -->
</template>

<!-- 未登录用户：显示简化信息 -->
<template v-else>
  <!-- 3个字段 + 登录提示 -->
</template>
```

### 验证3：图片字段名

在 `frontend/src/views/PublicPortalView.vue`：

```vue
<!-- 详情对话框中 -->
<el-image v-if="currentRelic.imagePath" :src="resolveImageUrl(currentRelic.imagePath)">

<!-- viewRelicDetailFromAi 函数中 -->
imagePath: relic.imagePath  // 不是 imageUrl
```

## 浏览器控制台检查

### 检查 sessionStorage

在浏览器控制台（F12 → Console）执行：

```javascript
// 检查 token
console.log('Token:', sessionStorage.getItem('token'))

// 检查所有 sessionStorage
console.log('All sessionStorage:', Object.keys(sessionStorage).map(key => ({
  key,
  value: sessionStorage.getItem(key)
})))
```

### 检查 isLoggedIn 值

在浏览器控制台执行：

```javascript
// 这个需要在 Vue DevTools 中查看
// 或者在模板中启用调试信息
```

## 测试用例

### 测试用例1：未登录用户查看详情

**前置条件：**
- 清除所有 sessionStorage
- 未登录状态

**操作步骤：**
1. 访问 `/portal`
2. 点击文物卡片

**预期结果：**
- 只显示：文物名称、年代、分类
- 显示登录提示
- 不显示：文物编号、材质、状态、尺寸、重量、来源、描述

### 测试用例2：已登录用户查看详情

**前置条件：**
- 已登录
- sessionStorage 中有 token

**操作步骤：**
1. 访问 `/portal`
2. 点击文物卡片

**预期结果：**
- 显示所有10个字段
- 不显示登录提示

### 测试用例3：从 AI 搜索查看详情

**前置条件：**
- 已登录

**操作步骤：**
1. 访问 `/portal`
2. 滚动到 "AI智能搜索" 部分
3. 输入问题并搜索
4. 点击搜索结果中的"查看详情"

**预期结果：**
- 图片正常显示（使用 imagePath 字段）
- 显示完整信息

## 如果问题仍然存在

请提供以下信息：

1. **浏览器信息**
   - 浏览器名称和版本
   - 操作系统

2. **调试信息截图**
   - 启用调试信息后的截图
   - 显示 `isLoggedIn` 和 `Token` 的值

3. **控制台信息**
   - F12 → Console 标签的截图
   - 是否有错误信息

4. **Network 信息**
   - F12 → Network 标签
   - 图片请求是否成功
   - API 请求是否成功

5. **sessionStorage 内容**
   - F12 → Application → Session Storage
   - 截图显示所有存储的键值对

6. **具体操作步骤**
   - 从哪个页面开始
   - 点击了什么
   - 看到了什么

---

**更新时间：** 2026年4月27日  
**状态：** 待用户测试验证
