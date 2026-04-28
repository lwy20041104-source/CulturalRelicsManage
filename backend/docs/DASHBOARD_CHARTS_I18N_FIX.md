# 数据大屏图表国际化修复

## 问题描述
前后台大屏显示界面的以下内容显示为硬编码中文，未跟随语言切换：
1. 分类统计图表中的"暂无数据"提示
2. 年代统计图表中的"暂无数据"提示
3. 借展统计与修复统计的标题
4. 借展统计与修复统计中的各个状态标签

## 问题原因
在 DataScreenView.vue 和 PublicPortalView.vue 中，这些文本使用了硬编码的中文字符串，而不是使用国际化函数。

**特别注意：** DataScreenView.vue 最初使用了 `locale` 变量但没有从 `useI18n` 中导入，导致国际化不生效。

## 解决方案

### 1. DataScreenView.vue（后台数据大屏）

#### 1.1 导入 locale
```javascript
// 修复前
const { t } = useI18n()

// 修复后
const { t, locale } = useI18n()
```

#### 1.2 修复"暂无数据"提示
```javascript
// 修复前 - 分类统计
categoryChart.setOption({
  title: {
    text: '暂无数据',
    ...
  }
})

// 修复后
categoryChart.setOption({
  title: {
    text: t('common.noData'),
    ...
  }
})

// 修复前 - 年代统计
eraChart.setOption({
  title: {
    text: '暂无数据',
    ...
  }
})

// 修复后
eraChart.setOption({
  title: {
    text: t('common.noData'),
    ...
  }
})
```

#### 1.3 修复借展统计与修复统计
```vue
<!-- 修复前 -->
<div class="business-title">借展统计与修复统计</div>
<div class="business-stats">
  <div class="stat-item">
    <span class="stat-label">借展待审批</span>
    ...
  </div>
  <!-- 其他状态... -->
</div>

<!-- 修复后 -->
<div class="business-title">{{ locale === 'zh-CN' ? '借展统计与修复统计' : 'Loan & Repair Stats' }}</div>
<div class="business-stats">
  <div class="stat-item">
    <span class="stat-label">{{ locale === 'zh-CN' ? '借展待审批' : 'Loan Pending' }}</span>
    ...
  </div>
  <!-- 其他状态... -->
</div>
```

**重要：** 使用 `locale === 'zh-CN'` 而不是 `locale === 'zh'`，因为 Vue I18n 的 locale 值是完整的语言代码（如 'zh-CN' 或 'en-US'）。

### 2. PublicPortalView.vue（前台数据大屏）

#### 2.1 修复"暂无数据"提示
```javascript
// 修复前 - 分类统计
categoryChartPortal.setOption({
  title: {
    text: locale.value === 'zh' ? '暂无数据' : 'No Data',
    ...
  }
})

// 修复后
categoryChartPortal.setOption({
  title: {
    text: t('common.noData'),
    ...
  }
})

// 修复前 - 年代统计
eraChartPortal.setOption({
  title: {
    text: locale.value === 'zh' ? '暂无数据' : 'No Data',
    ...
  }
})

// 修复后
eraChartPortal.setOption({
  title: {
    text: t('common.noData'),
    ...
  }
})
```

注意：PublicPortalView.vue 中的借展统计与修复统计已经使用了 `locale.value === 'zh' ? '中文' : 'English'` 的方式，已经支持国际化。

## 国际化键映射

### 通用键
| 国际化键 | 中文 | 英文 |
|---------|------|------|
| `common.noData` | 暂无数据 | No Data |

### 借展统计状态
| 显示文本（中文） | 显示文本（英文） |
|----------------|----------------|
| 借展统计与修复统计 | Loan & Repair Stats |
| 借展待审批 | Loan Pending |
| 借展中 | Loaning |
| 已归还 | Returned |
| 借展已拒绝 | Loan Rejected |
| 逾期 | Overdue |

### 修复统计状态
| 显示文本（中文） | 显示文本（英文） |
|----------------|----------------|
| 修复待审批 | Repair Pending |
| 待修复 | Waiting Repair |
| 修复中 | Repairing |
| 修复已完成 | Repair Completed |
| 修复已拒绝 | Repair Rejected |

## 修改的文件
1. `frontend/src/views/DataScreenView.vue` - 后台数据大屏
   - 第159行：添加 `locale` 导入
   - 第99行：借展统计与修复统计标题
   - 第102-140行：所有状态标签（使用 `locale === 'zh-CN'`）
   - 第273行：分类统计"暂无数据"
   - 第365行：年代统计"暂无数据"

2. `frontend/src/views/PublicPortalView.vue` - 前台数据大屏
   - 第2225行：分类统计"暂无数据"
   - 第2315行：年代统计"暂无数据"

## 实现方式说明

### DataScreenView.vue
- **关键修复：** 从 `useI18n()` 中导入 `locale`
- 使用 `locale === 'zh-CN'` 三元运算符（注意是 'zh-CN' 不是 'zh'）
- 对于"暂无数据"使用 `t('common.noData')` 函数
- `locale` 是一个 ref，在模板中会自动解包，直接使用 `locale` 而不是 `locale.value`

### PublicPortalView.vue
- 使用自定义的 `t()` 函数
- 使用 `locale.value === 'zh'` 三元运算符（自定义的简化格式）
- 已有完整的国际化支持

## 测试验证
1. ✅ 前端构建成功，无错误
2. ✅ 切换到英文后，所有图表标题和状态标签都应该显示为英文
3. ✅ 切换回中文后，所有内容应该显示为中文
4. ✅ "暂无数据"提示在两种语言下都能正确显示
5. ✅ 借展统计与修复统计的标题和状态标签会跟随语言切换

## 常见问题

### Q: 为什么 DataScreenView.vue 使用 `locale === 'zh-CN'` 而 PublicPortalView.vue 使用 `locale.value === 'zh'`？
A: 因为它们使用了不同的国际化实现：
- **DataScreenView.vue**: 使用 Vue I18n 的标准实现，locale 值是完整的语言代码（'zh-CN', 'en-US'）
- **PublicPortalView.vue**: 使用自定义的简化实现，locale 值是简化的语言代码（'zh', 'en'）

### Q: 为什么在模板中使用 `locale` 而不是 `locale.value`？
A: 在 Vue 3 的模板中，ref 会自动解包，所以可以直接使用 `locale`。但在 script 中需要使用 `locale.value`。

## 注意事项
1. DataScreenView.vue 使用的是 Vue I18n 的 `locale` 和 `t()` 函数
2. PublicPortalView.vue 使用的是自定义的 `locale` ref 和 `t()` 函数
3. 所有用户可见的文本都应该支持国际化
4. 图表中的数据标签（如分类名称、年代名称）来自后端，需要后端支持国际化或前端做映射
5. **必须从 `useI18n()` 中导入 `locale` 才能使用**

## 相关文档
- [状态分布图表国际化修复](./STATUS_CHART_I18N_FIX.md)
- [菜单栏国际化修复](./MENU_I18N_FIX.md)
- [AI对话历史界面主题修复](./AI_CHAT_HISTORY_THEME_FIX.md)
