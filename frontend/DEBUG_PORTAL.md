# 前台页面空白问题调试指南

## 问题描述
前台界面（/portal）显示为空白，但后台界面正常。

## 已修复的问题
✅ 修复了API导入错误：
- 将AI聊天相关API从 `relics.js` 移到 `aiChat.js`
- 将报表相关API从 `relics.js` 移到 `reports.js`

## 调试步骤

### 1. 检查浏览器控制台
打开浏览器开发者工具（F12），查看Console标签页：
- 是否有JavaScript错误？
- 是否有API请求失败（404、500等）？
- 是否有网络请求超时？

### 2. 检查网络请求
在开发者工具的Network标签页中：
- 检查 `/statistics/overview` 请求是否成功
- 检查 `/categories` 请求是否成功
- 检查 `/relics` 请求是否成功
- 检查 `/ai-chat/sessions` 请求是否成功

### 3. 检查后端服务
确认后端服务是否正常运行：
```bash
# 检查后端是否启动
# 访问 http://localhost:8080/actuator/health（如果配置了actuator）
```

### 4. 检查登录状态
在浏览器控制台执行：
```javascript
console.log('Token:', sessionStorage.getItem('token'))
console.log('Role:', sessionStorage.getItem('role'))
console.log('Username:', sessionStorage.getItem('username'))
console.log('RealName:', sessionStorage.getItem('realName'))
```

### 5. 检查页面挂载
在浏览器控制台查看是否有以下日志：
- "前台页面已挂载，开始加载数据..."
- "开始加载统计数据..."
- "开始加载分类数据..."

### 6. 临时调试代码
如果页面完全空白，可以在 `PublicPortalView.vue` 的 `onMounted` 钩子开头添加：
```javascript
onMounted(async () => {
  console.log('=== 前台页面调试信息 ===')
  console.log('Token:', sessionStorage.getItem('token'))
  console.log('Role:', sessionStorage.getItem('role'))
  console.log('ActiveSection:', activeSection.value)
  
  // 测试是否能渲染基本内容
  ElMessage.success('页面已加载')
  
  // ... 原有代码
})
```

## 可能的原因

### 原因1：API请求失败
**症状**：控制台显示API请求404或500错误
**解决方案**：
1. 确认后端服务已启动
2. 检查后端Controller是否有对应的接口
3. 检查API路径是否正确

### 原因2：未登录或Token过期
**症状**：页面重定向到登录页或API返回401
**解决方案**：
1. 重新登录前台系统（/portal-login）
2. 确认使用LOANER角色登录

### 原因3：某个组件渲染失败
**症状**：控制台显示组件相关错误
**解决方案**：
1. 检查 NotificationBell、LanguageSwitcher、ThemeSwitcher、DarkModeToggle 组件是否存在
2. 检查这些组件的导入路径是否正确

### 原因4：数据加载超时
**症状**：页面长时间显示加载状态
**解决方案**：
1. 检查网络连接
2. 检查后端数据库连接
3. 检查是否有慢查询

## 快速测试

### 测试1：简化页面
临时注释掉 `onMounted` 中的所有API调用，只保留：
```javascript
onMounted(async () => {
  console.log('页面已挂载')
  ElMessage.success('前台页面加载成功')
})
```

如果页面能显示，说明问题在API调用中。

### 测试2：逐个启用功能
逐个取消注释API调用，找出导致问题的具体API：
```javascript
onMounted(async () => {
  try {
    await loadStatistics()  // 先测试这个
    console.log('统计数据加载成功')
    
    // await loadCategories()  // 然后测试这个
    // await searchRelics()
    // await loadAvailableRelics()
    // await loadSessions()
  } catch (error) {
    console.error('加载失败:', error)
    ElMessage.error('数据加载失败: ' + error.message)
  }
})
```

## 联系信息
如果以上步骤都无法解决问题，请提供：
1. 浏览器控制台的完整错误信息
2. Network标签页中失败的API请求详情
3. 后端日志中的相关错误信息
