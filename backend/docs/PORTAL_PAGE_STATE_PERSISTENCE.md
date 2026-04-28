# 前台用户端页面状态持久化

## 问题描述
前台用户端刷新之后会回到首页，用户体验不佳。需要实现在哪个页面点击刷新，刷新之后就在哪个界面。

## 解决方案

### 实现原理
使用 `localStorage` 保存用户当前访问的页面状态，在页面刷新后从 `localStorage` 恢复状态。

### 实现步骤

#### 1. 修改 activeSection 初始化
```javascript
// 修复前
const activeSection = ref('home')

// 修复后
// 从localStorage恢复上次访问的页面，如果没有则默认为首页
const activeSection = ref(localStorage.getItem('portalActiveSection') || 'home')
```

#### 2. 在页面切换时保存状态
在 `watch(activeSection)` 中添加保存逻辑：

```javascript
watch(activeSection, async (newSection) => {
  console.log('切换到section:', newSection)
  
  // 保存当前页面到localStorage，以便刷新后恢复
  localStorage.setItem('portalActiveSection', newSection)
  
  // ... 其他逻辑
})
```

## 技术细节

### localStorage 键名
- **键名**: `portalActiveSection`
- **值**: 当前页面的标识符（如 'home', 'data-screen', 'relics', 'loan', 'my-loans' 等）

### 页面标识符列表
| 标识符 | 页面名称 |
|--------|---------|
| home | 首页 |
| data-screen | 数据大屏 |
| reports | 数据报表 |
| relics | 文物查询 |
| categories | 分类查询 |
| loan | 申请借展 |
| my-loans | 我的借展 |
| ai | AI搜索 |

### 工作流程
1. **页面加载时**：
   - 从 `localStorage.getItem('portalActiveSection')` 读取上次访问的页面
   - 如果没有保存的状态，默认显示首页（'home'）
   - 将 `activeSection` 设置为读取的值

2. **页面切换时**：
   - 用户点击导航菜单切换页面
   - `activeSection` 的值发生变化
   - `watch(activeSection)` 监听到变化
   - 将新的页面标识符保存到 `localStorage.setItem('portalActiveSection', newSection)`

3. **页面刷新时**：
   - 浏览器刷新页面
   - Vue 组件重新初始化
   - `activeSection` 从 `localStorage` 读取上次保存的值
   - 页面自动显示上次访问的内容

## 修改的文件
- `frontend/src/views/PublicPortalView.vue`
  - 第1279行：修改 `activeSection` 初始化逻辑
  - 第1363行：在 `watch(activeSection)` 中添加保存逻辑

## 用户体验改进
1. **刷新保持状态**：用户在任何页面刷新后，都会停留在当前页面，不会跳转到首页
2. **跨会话保持**：即使关闭浏览器后重新打开，也会记住上次访问的页面
3. **自然的导航体验**：用户可以自由刷新页面而不用担心丢失当前位置

## 注意事项
1. **localStorage 的作用域**：
   - localStorage 是按域名存储的
   - 同一域名下的所有页面共享 localStorage
   - 不同浏览器的 localStorage 是独立的

2. **清除状态**：
   - 用户清除浏览器缓存时，localStorage 会被清除
   - 可以通过 `localStorage.removeItem('portalActiveSection')` 手动清除
   - 退出登录时可以考虑清除状态（当前未实现）

3. **默认值**：
   - 如果 localStorage 中没有保存的状态，默认显示首页
   - 这确保了首次访问的用户有良好的体验

## 扩展性
如果需要保存更多的页面状态（如筛选条件、滚动位置等），可以：

1. 使用 JSON 格式保存更复杂的状态：
```javascript
const state = {
  activeSection: 'relics',
  filters: { category: 1, era: '唐代' },
  scrollPosition: 500
}
localStorage.setItem('portalState', JSON.stringify(state))
```

2. 在页面加载时恢复完整状态：
```javascript
const savedState = JSON.parse(localStorage.getItem('portalState') || '{}')
const activeSection = ref(savedState.activeSection || 'home')
```

## 测试验证
1. ✅ 在首页刷新，停留在首页
2. ✅ 在数据大屏刷新，停留在数据大屏
3. ✅ 在文物查询刷新，停留在文物查询
4. ✅ 在我的借展刷新，停留在我的借展
5. ✅ 关闭浏览器后重新打开，仍然记住上次访问的页面
6. ✅ 清除浏览器缓存后，恢复到默认首页

## 相关文档
- [分类和年代国际化修复](./CATEGORY_ERA_I18N_FIX.md)
- [数据大屏图表国际化修复](./DASHBOARD_CHARTS_I18N_FIX.md)
