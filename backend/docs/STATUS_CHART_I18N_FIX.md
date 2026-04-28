# 状态分布图表国际化修复

## 问题描述
在切换到英文时，首页和数据大屏的状态分布饼状图/柱状图中的四种状态（在库、借展中、修复中、封存）显示依然是中文，没有跟随语言切换。

## 问题原因
在以下文件中，状态分布图表直接使用了硬编码的中文状态名称或简单的三元运算符，而不是使用国际化函数 `t()`：

1. **DashboardView.vue** - 管理后台首页的状态分布图表
2. **DataScreenView.vue** - 数据大屏的状态分布图表
3. **PublicPortalView.vue** - 前台门户的状态分布图表

## 解决方案

### 1. DashboardView.vue（已在之前修复）
将硬编码的状态名称改为使用国际化键：

```javascript
// 修复前
const statusData = [
  { name: '在库', value: dashboardData.value.inStockRelics || 0 },
  { name: '借展中', value: dashboardData.value.loaningRelics || 0 },
  { name: '修复中', value: dashboardData.value.repairingRelics || 0 },
  { name: '封存', value: dashboardData.value.sealedRelics || 0 }
]

// 修复后
const statusData = [
  { name: t('relic.inStock'), value: dashboardData.value.inStockRelics || 0 },
  { name: t('relic.onLoan'), value: dashboardData.value.loaningRelics || 0 },
  { name: t('relic.repairing'), value: dashboardData.value.repairingRelics || 0 },
  { name: t('relic.sealed'), value: dashboardData.value.sealedRelics || 0 }
]
```

### 2. DataScreenView.vue
将硬编码的状态名称改为使用国际化键：

```javascript
// 修复前（第286-288行）
const statusData = [
  { name: '在库', value: dashboardData.value.inStockRelics || 0 },
  { name: '借展中', value: dashboardData.value.loaningRelics || 0 },
  { name: '修复中', value: dashboardData.value.repairingRelics || 0 }
]

// 修复后
const statusData = [
  { name: t('relic.inStock'), value: dashboardData.value.inStockRelics || 0 },
  { name: t('relic.onLoan'), value: dashboardData.value.loaningRelics || 0 },
  { name: t('relic.repairing'), value: dashboardData.value.repairingRelics || 0 }
]
```

### 3. PublicPortalView.vue
将三元运算符改为使用国际化键：

```javascript
// 修复前（第2238-2240行）
const statusData = [
  { name: locale.value === 'zh' ? '在库' : 'In Stock', value: dashboardData.value.inStockRelics || 0 },
  { name: locale.value === 'zh' ? '借展中' : 'On Loan', value: dashboardData.value.loaningRelics || 0 },
  { name: locale.value === 'zh' ? '修复中' : 'Repairing', value: dashboardData.value.repairingRelics || 0 }
]

// 修复后
const statusData = [
  { name: t('relic.inStock'), value: dashboardData.value.inStockRelics || 0 },
  { name: t('relic.onLoan'), value: dashboardData.value.loaningRelics || 0 },
  { name: t('relic.repairing'), value: dashboardData.value.repairingRelics || 0 }
]
```

## 国际化键映射

使用的国际化键及其对应的翻译：

| 国际化键 | 中文 | 英文 |
|---------|------|------|
| `relic.inStock` | 在库 | In Stock |
| `relic.onLoan` | 借展中 | On Loan |
| `relic.repairing` | 修复中 | Repairing |
| `relic.sealed` | 封存 | Sealed |

这些键已在以下文件中定义：
- `frontend/src/i18n/locales/zh-CN.js`
- `frontend/src/i18n/locales/en-US.js`

## 修改的文件
1. `frontend/src/views/DashboardView.vue` - 管理后台首页
2. `frontend/src/views/DataScreenView.vue` - 数据大屏
3. `frontend/src/views/PublicPortalView.vue` - 前台门户

## 测试验证
1. 前端构建成功，无错误
2. 切换到英文后，所有状态分布图表中的状态名称都应该显示为英文
3. 切换回中文后，状态名称应该显示为中文

## 注意事项
- 所有图表中的用户可见文本都应该使用 `t()` 函数进行国际化
- 避免使用硬编码的文本或简单的三元运算符
- 确保国际化键在所有语言文件中都有定义

## 相关文档
- [菜单栏国际化修复](./MENU_I18N_FIX.md)
- [AI对话历史界面主题修复](./AI_CHAT_HISTORY_THEME_FIX.md)
