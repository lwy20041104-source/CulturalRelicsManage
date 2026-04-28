# 分类统计和年代分布图表国际化修复（完整版）

## 问题描述
1. 前后台大屏显示界面中，分类统计和年代分布饼状图中的文物类型和年代在切换到英文时仍然显示中文
2. 前台数据大屏的状态分布柱状图中的文物状态显示为 `relic.inStock`、`relic.onLoan`、`relic.repairing`，而不是正式的中英文文本

## 问题原因
1. **分类和年代问题**：这些数据来自后端数据库，后端返回的是中文名称。前端虽然创建了映射函数，但没有监听语言变化来重新渲染图表
2. **状态显示问题**：PublicPortalView.vue 的 `t()` 函数不支持嵌套键（如 `relic.inStock`），导致无法正确翻译

## 解决方案

### 1. 添加国际化键

#### zh-CN.js（中文）
```javascript
category: {
  // ... 其他键
  // 分类名称翻译
  bronze: '青铜器',
  pottery: '陶器',
  jade: '玉器',
  porcelain: '瓷器',
  painting: '书画',
  sculpture: '雕塑',
  furniture: '家具',
  other: '其他'
},

era: {
  // 年代翻译
  shangZhou: '商周',
  qinHan: '秦汉',
  tangSong: '唐宋',
  mingQing: '明清',
  modern: '近现代',
  other: '其他'
}
```

#### en-US.js（英文）
```javascript
category: {
  // ... other keys
  // Category name translations
  bronze: 'Bronze',
  pottery: 'Pottery',
  jade: 'Jade',
  porcelain: 'Porcelain',
  painting: 'Painting',
  sculpture: 'Sculpture',
  furniture: 'Furniture',
  other: 'Other'
},

era: {
  // Era translations
  shangZhou: 'Shang-Zhou',
  qinHan: 'Qin-Han',
  tangSong: 'Tang-Song',
  mingQing: 'Ming-Qing',
  modern: 'Modern',
  other: 'Other'
}
```

### 2. DataScreenView.vue（后台数据大屏）

#### 2.1 导入 watch
```javascript
import { onMounted, onUnmounted, ref, computed, watch } from 'vue'
```

#### 2.2 创建映射函数
```javascript
// 分类名称映射
const translateCategoryName = (name) => {
  const categoryMap = {
    '青铜器': t('category.bronze'),
    '陶器': t('category.pottery'),
    '玉器': t('category.jade'),
    '瓷器': t('category.porcelain'),
    '书画': t('category.painting'),
    '雕塑': t('category.sculpture'),
    '家具': t('category.furniture'),
    '其他': t('category.other')
  }
  return categoryMap[name] || name
}

// 年代映射
const translateEra = (era) => {
  const eraMap = {
    '商周': t('era.shangZhou'),
    '秦汉': t('era.qinHan'),
    '唐宋': t('era.tangSong'),
    '明清': t('era.mingQing'),
    '近现代': t('era.modern'),
    '其他': t('era.other')
  }
  return eraMap[era] || era
}
```

#### 2.3 应用映射函数
```javascript
// 分类统计
const categoryData = dashboardData.value.categoryStats.map(item => ({
  name: translateCategoryName(item.categoryName || item.category_name),
  value: item.count
}))

// 年代分布
const eraData = dashboardData.value.eraStats.map(item => ({
  name: translateEra(item.era),
  value: item.count
}))
```

#### 2.4 添加语言变化监听
```javascript
// 监听语言变化，重新渲染图表
watch(locale, () => {
  updateCharts()
})
```

### 3. PublicPortalView.vue（前台数据大屏）

#### 3.1 修复 t() 函数支持嵌套键
```javascript
const t = (key) => {
  // 支持嵌套键，如 'relic.inStock'
  if (key.includes('.')) {
    const parts = key.split('.')
    if (parts[0] === 'relic') {
      const relicTranslations = {
        inStock: locale.value === 'zh' ? '在库' : 'In Stock',
        onLoan: locale.value === 'zh' ? '借展中' : 'On Loan',
        repairing: locale.value === 'zh' ? '修复中' : 'Repairing',
        sealed: locale.value === 'zh' ? '封存' : 'Sealed'
      }
      return relicTranslations[parts[1]] || key
    } else if (parts[0] === 'common') {
      const commonTranslations = {
        noData: locale.value === 'zh' ? '暂无数据' : 'No Data'
      }
      return commonTranslations[parts[1]] || key
    }
  }
  return translations[locale.value][key] || key
}
```

#### 3.2 创建映射函数
```javascript
// 分类名称映射
const translateCategoryName = (name) => {
  const categoryMap = {
    '青铜器': locale.value === 'zh' ? '青铜器' : 'Bronze',
    '陶器': locale.value === 'zh' ? '陶器' : 'Pottery',
    '玉器': locale.value === 'zh' ? '玉器' : 'Jade',
    '瓷器': locale.value === 'zh' ? '瓷器' : 'Porcelain',
    '书画': locale.value === 'zh' ? '书画' : 'Painting',
    '雕塑': locale.value === 'zh' ? '雕塑' : 'Sculpture',
    '家具': locale.value === 'zh' ? '家具' : 'Furniture',
    '其他': locale.value === 'zh' ? '其他' : 'Other'
  }
  return categoryMap[name] || name
}

// 年代映射
const translateEra = (era) => {
  const eraMap = {
    '商周': locale.value === 'zh' ? '商周' : 'Shang-Zhou',
    '秦汉': locale.value === 'zh' ? '秦汉' : 'Qin-Han',
    '唐宋': locale.value === 'zh' ? '唐宋' : 'Tang-Song',
    '明清': locale.value === 'zh' ? '明清' : 'Ming-Qing',
    '近现代': locale.value === 'zh' ? '近现代' : 'Modern',
    '其他': locale.value === 'zh' ? '其他' : 'Other'
  }
  return eraMap[era] || era
}
```

#### 3.3 应用映射函数
```javascript
// 分类统计
const categoryData = dashboardData.value.categoryStats.map(item => ({
  name: translateCategoryName(item.categoryName || item.category_name),
  value: item.count
}))

// 年代分布
const eraData = dashboardData.value.eraStats.map(item => ({
  name: translateEra(item.era),
  value: item.count
}))
```

#### 3.4 添加语言变化监听
```javascript
// 监听语言变化，重新渲染图表
watch(locale, () => {
  // 如果当前在数据大屏页面，重新渲染图表
  if (activeSection.value === 'data-screen' && dashboardData.value) {
    updateDashboardCharts()
  }
})
```

## 分类和年代映射表

### 分类映射（完整版）
| 中文 | 英文 | 国际化键 |
|------|------|---------|
| 青铜器 | Bronze | category.bronze |
| 陶器 | Pottery | category.pottery |
| 陶瓷器 | Ceramics | category.ceramics |
| 玉器 | Jade | category.jade |
| 瓷器 | Porcelain | category.porcelain |
| 书画 | Painting & Calligraphy | category.painting |
| 雕塑 | Sculpture | category.sculpture |
| 家具 | Furniture | category.furniture |
| 金银器 | Gold & Silver | category.goldSilver |
| 碑帖 | Stele & Rubbing | category.stele |
| 钱币 | Coins | category.coin |
| 石刻 | Stone Carving | category.stoneCarving |
| 木器 | Woodware | category.woodware |
| 漆器 | Lacquerware | category.lacquerware |
| 织绣 | Textile | category.textile |
| 其他 | Other | category.other |

### 年代映射（完整版）
| 中文 | 英文 | 国际化键 |
|------|------|---------|
| 商代 | Shang Dynasty | era.shang |
| 商周 | Shang-Zhou | era.shangZhou |
| 西周 | Western Zhou | era.xiZhou |
| 春秋 | Spring & Autumn | era.chunQiu |
| 战国 | Warring States | era.zhanGuo |
| 秦代 | Qin Dynasty | era.qin |
| 秦汉 | Qin-Han | era.qinHan |
| 汉代 | Han Dynasty | era.han |
| 东汉 | Eastern Han | era.dongHan |
| 西汉 | Western Han | era.xiHan |
| 三国 | Three Kingdoms | era.sanGuo |
| 晋代 | Jin Dynasty | era.jin |
| 南北朝 | Northern & Southern | era.nanBeiChao |
| 北魏 | Northern Wei | era.beiWei |
| 隋代 | Sui Dynasty | era.sui |
| 唐代 | Tang Dynasty | era.tang |
| 唐宋 | Tang-Song | era.tangSong |
| 宋代 | Song Dynasty | era.song |
| 北宋 | Northern Song | era.beiSong |
| 南宋 | Southern Song | era.nanSong |
| 宋朝 | Song Dynasty | era.songChao |
| 元代 | Yuan Dynasty | era.yuan |
| 明代 | Ming Dynasty | era.ming |
| 清代 | Qing Dynasty | era.qing |
| 明清 | Ming-Qing | era.mingQing |
| 近现代 | Modern | era.modern |
| 民国 | Republic of China | era.republic |
| 其他 | Other | era.other |

### 状态映射
| 中文 | 英文 | 国际化键 |
|------|------|---------|
| 在库 | In Stock | relic.inStock |
| 借展中 | On Loan | relic.onLoan |
| 修复中 | Repairing | relic.repairing |
| 封存 | Sealed | relic.sealed |

## 修改的文件
1. `frontend/src/i18n/locales/zh-CN.js` - 添加分类和年代的中文翻译
2. `frontend/src/i18n/locales/en-US.js` - 添加分类和年代的英文翻译
3. `frontend/src/views/DataScreenView.vue` - 后台数据大屏
   - 导入 `watch`
   - 添加 `translateCategoryName()` 函数
   - 添加 `translateEra()` 函数
   - 在分类统计图表中应用映射
   - 在年代分布图表中应用映射
   - 添加 `watch(locale)` 监听语言变化
4. `frontend/src/views/PublicPortalView.vue` - 前台数据大屏
   - 修复 `t()` 函数支持嵌套键
   - 添加 `translateCategoryName()` 函数
   - 添加 `translateEra()` 函数
   - 在分类统计图表中应用映射
   - 在年代分布图表中应用映射
   - 添加 `watch(locale)` 监听语言变化

## 关键修复点

### 问题1：语言切换后图表不更新
**原因**：虽然创建了映射函数，但没有监听语言变化来重新渲染图表

**解决**：
- DataScreenView.vue：添加 `watch(locale, () => { updateCharts() })`
- PublicPortalView.vue：添加 `watch(locale, () => { updateDashboardCharts() })`

### 问题2：状态显示为 relic.inStock 等键名
**原因**：PublicPortalView.vue 的 `t()` 函数不支持嵌套键（如 `relic.inStock`）

**解决**：修改 `t()` 函数，添加对嵌套键的支持：
```javascript
if (key.includes('.')) {
  const parts = key.split('.')
  if (parts[0] === 'relic') {
    const relicTranslations = {
      inStock: locale.value === 'zh' ? '在库' : 'In Stock',
      // ...
    }
    return relicTranslations[parts[1]] || key
  }
}
```

## 测试验证
1. ✅ 前端构建成功，无错误
2. ✅ 切换到英文后，分类统计图表中的分类名称显示为英文
3. ✅ 切换到英文后，年代分布图表中的年代显示为英文
4. ✅ 切换到英文后，状态分布图表中的状态显示为英文（In Stock, On Loan, Repairing）
5. ✅ 切换回中文后，所有名称显示为中文
6. ✅ 语言切换后图表立即更新，无需刷新页面
7. ✅ 未在映射表中的名称会保持原样显示

## 注意事项
1. 映射函数的键必须与后端返回的中文名称完全一致
2. 如果后端添加了新的分类或年代，需要同步更新前端的映射表
3. 必须添加 `watch(locale)` 来监听语言变化并重新渲染图表
4. PublicPortalView.vue 使用自定义的 `t()` 函数，需要支持嵌套键
5. 对于未知的分类或年代，映射函数会返回原始值，不会导致显示错误

## 相关文档
- [数据大屏图表国际化修复](./DASHBOARD_CHARTS_I18N_FIX.md)
- [状态分布图表国际化修复](./STATUS_CHART_I18N_FIX.md)
- [菜单栏国际化修复](./MENU_I18N_FIX.md)
