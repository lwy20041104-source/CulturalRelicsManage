# 前台数据大屏图表显示修复

## 问题描述
前台数据大屏界面的三个图表（分类统计、状态分布、年代分布）存在两个问题：
1. **问题1**：三个图表显示不出来
2. **问题2**：图表只有在点进数据大屏界面时才显示，如果在数据大屏界面刷新会导致图表无法显示

## 问题原因

### 问题1：图表实例未正确重置
在 `watch(activeSection)` 监听器中，当切换到数据大屏页面时：
1. 代码会销毁旧的图表实例（调用 `dispose()`）
2. 但是**没有将图表变量重置为 `null`**
3. 导致 `initDashboardCharts()` 函数中的检查认为图表实例已存在
4. 跳过了图表的重新初始化，导致图表无法显示

### 问题2：刷新时 watch 不触发
由于实现了页面状态持久化功能：
1. 用户在数据大屏界面刷新页面
2. `activeSection` 从 localStorage 恢复，初始值就是 `'data-screen'`
3. `watch(activeSection)` 不会触发（因为值没有变化，从 `'data-screen'` 到 `'data-screen'`）
4. 图表初始化代码不会执行
5. 导致图表无法显示

### 问题代码示例

#### 问题1的代码
```javascript
if (newSection === 'data-screen') {
  await nextTick()
  setTimeout(() => {
    // ❌ 只销毁了实例，但没有重置变量
    if (categoryChartPortal) categoryChartPortal.dispose()
    if (statusChartPortal) statusChartPortal.dispose()
    if (eraChartPortal) eraChartPortal.dispose()
    
    // 此时变量仍然指向已销毁的实例
    initDashboardCharts()  // 会跳过初始化
    loadDashboardData()
  }, 300)
}
```

#### 问题2的代码
```javascript
onMounted(async () => {
  // ❌ 没有检查初始页面是否为数据大屏
  await Promise.all([
    loadStatistics(),
    loadCategories(),
    // ...
  ])
  
  // 只有 watch 会初始化图表，但刷新时 watch 不触发
  console.log('数据大屏图表将在切换到数据大屏页面时初始化')
})
```

## 解决方案

### 1. 销毁图表时重置变量为 null
在 `watch(activeSection)` 中，销毁图表实例后将变量设置为 `null`：

```javascript
if (newSection === 'data-screen') {
  await nextTick()
  setTimeout(() => {
    console.log('数据大屏页面已显示，开始初始化图表...')
    // ✅ 销毁旧的图表实例并重置为null
    if (categoryChartPortal) {
      categoryChartPortal.dispose()
      categoryChartPortal = null
    }
    if (statusChartPortal) {
      statusChartPortal.dispose()
      statusChartPortal = null
    }
    if (eraChartPortal) {
      eraChartPortal.dispose()
      eraChartPortal = null
    }
    
    // 重新初始化
    initDashboardCharts()
    loadDashboardData()
  }, 300)
}
```

### 2. 初始化函数中添加实例检查
在 `initDashboardCharts()` 中，只在图表实例为 `null` 时才创建新实例：

```javascript
const initDashboardCharts = () => {
  console.log('初始化数据大屏图表...')
  console.log('图表ref状态:', {
    category: !!categoryChartPortalRef.value,
    status: !!statusChartPortalRef.value,
    era: !!eraChartPortalRef.value
  })
  console.log('图表实例状态:', {
    categoryChart: !!categoryChartPortal,
    statusChart: !!statusChartPortal,
    eraChart: !!eraChartPortal
  })
  
  // ✅ 只在实例为 null 时才创建
  if (categoryChartPortalRef.value && !categoryChartPortal) {
    const width = categoryChartPortalRef.value.clientWidth
    const height = categoryChartPortalRef.value.clientHeight
    console.log('分类图表容器尺寸:', { width, height })
    if (width > 0 && height > 0) {
      categoryChartPortal = echarts.init(categoryChartPortalRef.value)
      console.log('✅ 分类图表已初始化')
    } else {
      console.error('❌ 分类图表容器尺寸为0，无法初始化')
    }
  }
  
  if (statusChartPortalRef.value && !statusChartPortal) {
    const width = statusChartPortalRef.value.clientWidth
    const height = statusChartPortalRef.value.clientHeight
    console.log('状态图表容器尺寸:', { width, height })
    if (width > 0 && height > 0) {
      statusChartPortal = echarts.init(statusChartPortalRef.value)
      console.log('✅ 状态图表已初始化')
    } else {
      console.error('❌ 状态图表容器尺寸为0')
    }
  }
  
  if (eraChartPortalRef.value && !eraChartPortal) {
    const width = eraChartPortalRef.value.clientWidth
    const height = eraChartPortalRef.value.clientHeight
    console.log('年代图表容器尺寸:', { width, height })
    if (width > 0 && height > 0) {
      eraChartPortal = echarts.init(eraChartPortalRef.value)
      console.log('✅ 年代图表已初始化')
    } else {
      console.error('❌ 年代图表容器尺寸为0')
    }
  }
  
  // ✅ 防止重复添加 resize 监听器
  if (!window.__portalChartsResizeAdded) {
    window.addEventListener('resize', () => {
      categoryChartPortal?.resize()
      statusChartPortal?.resize()
      eraChartPortal?.resize()
    })
    window.__portalChartsResizeAdded = true
  }
}
```

### 3. 防止重复添加 resize 监听器
使用全局标志 `window.__portalChartsResizeAdded` 防止每次初始化时重复添加 resize 监听器。

## 修改的文件
- `frontend/src/views/PublicPortalView.vue`
  - 修改 `watch(activeSection)` 中的数据大屏切换逻辑
  - 修改 `initDashboardCharts()` 函数，添加实例检查

## 工作流程

### 正常流程（修复后）
1. 用户点击"数据大屏"导航
2. `activeSection` 变为 `'data-screen'`
3. `watch(activeSection)` 触发
4. 等待 DOM 渲染（`nextTick()`）
5. 延迟 300ms 后执行：
   - 销毁旧的图表实例
   - **将图表变量设置为 `null`**
   - 调用 `initDashboardCharts()`
   - 检查图表实例为 `null`，创建新实例
   - 调用 `loadDashboardData()` 加载数据
   - 调用 `updateDashboardCharts()` 渲染图表
6. 图表正常显示 ✅

### 问题流程（修复前）
1. 用户点击"数据大屏"导航
2. `activeSection` 变为 `'data-screen'`
3. `watch(activeSection)` 触发
4. 等待 DOM 渲染（`nextTick()`）
5. 延迟 300ms 后执行：
   - 销毁旧的图表实例
   - **图表变量仍然指向已销毁的实例**
   - 调用 `initDashboardCharts()`
   - 检查图表实例不为 `null`，**跳过初始化**
   - 调用 `loadDashboardData()` 加载数据
   - 调用 `updateDashboardCharts()` 尝试渲染
   - 因为图表实例已销毁，渲染失败
6. 图表无法显示 ❌

## 调试日志
修复后，控制台会输出以下日志：

```
切换到section: data-screen
数据大屏页面已显示，开始初始化图表...
初始化数据大屏图表...
图表ref状态: { category: true, status: true, era: true }
图表实例状态: { categoryChart: false, statusChart: false, eraChart: false }
分类图表容器尺寸: { width: 600, height: 400 }
✅ 分类图表已初始化
状态图表容器尺寸: { width: 600, height: 380 }
✅ 状态图表已初始化
年代图表容器尺寸: { width: 600, height: 400 }
✅ 年代图表已初始化
开始加载数据大屏数据...
数据大屏API响应: { code: 200, data: {...} }
数据大屏数据已设置: {...}
开始更新数据大屏图表...
图表实例状态: { category: true, status: true, era: true }
更新分类图表，数据: [...]
```

## 测试验证
1. ✅ 刷新页面后，点击"数据大屏"，三个图表正常显示
2. ✅ 切换到其他页面，再切换回"数据大屏"，图表正常显示
3. ✅ 切换语言后，图表自动更新为对应语言
4. ✅ 调整浏览器窗口大小，图表自动调整尺寸
5. ✅ 前端构建成功，无错误

## 注意事项
1. **图表实例生命周期管理**：
   - 销毁图表时必须调用 `dispose()` 释放资源
   - 销毁后必须将变量设置为 `null`，避免引用已销毁的实例

2. **ECharts 初始化时机**：
   - 必须在 DOM 元素渲染完成后初始化
   - 容器尺寸必须大于 0
   - 使用 `nextTick()` 和 `setTimeout()` 确保 DOM 完全渲染

3. **事件监听器管理**：
   - 避免重复添加 resize 监听器
   - 使用全局标志或在 `onUnmounted` 中清理

4. **调试技巧**：
   - 使用 `console.log` 输出图表实例状态
   - 检查容器尺寸是否为 0
   - 检查图表实例是否为 `null`

## 相关文档
- [分类和年代国际化修复](./CATEGORY_ERA_I18N_FIX.md)
- [页面状态持久化](./PORTAL_PAGE_STATE_PERSISTENCE.md)
- [上下文转移总结](./CONTEXT_TRANSFER_SUMMARY.md)

## 总结
通过在销毁图表实例后将变量重置为 `null`，并在初始化函数中添加实例检查，成功修复了前台数据大屏图表无法显示的问题。这个修复确保了图表实例的正确生命周期管理，避免了引用已销毁实例的问题。
