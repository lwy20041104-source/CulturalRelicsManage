# 修复材料管理界面优化

## 优化时间
2026-04-27

## 优化内容

### 1. 完善中英文翻译

#### 添加缺失的common翻译
**中文（zh-CN.js）**
```javascript
common: {
  // ... 其他翻译
  actions: '操作',
  pleaseEnter: '请输入',
  required: '此项为必填项',
  createSuccess: '创建成功'
}
```

**英文（en-US.js）**
```javascript
common: {
  // ... other translations
  actions: 'Actions',
  pleaseEnter: 'Please enter',
  required: 'This field is required',
  createSuccess: 'Created successfully'
}
```

#### 添加材料管理专用翻译
**中文**
```javascript
repairMaterials: {
  addMaterial: '新增材料',
  // ... 其他翻译
}
```

**英文**
```javascript
repairMaterials: {
  addMaterial: 'Add Material',
  // ... other translations
}
```

### 2. 界面布局优化

#### 移除卡片标题
- ❌ 删除：`<template #header>` 部分
- ❌ 删除：显示"修复材料管理"的标题
- ✅ 原因：与其他界面保持一致，标题信息已在菜单中体现

#### 重新布局按钮
**优化前**
```
标题栏：[修复材料管理]  [库存不足] [添加]

搜索栏：[材料名称] [类别] [搜索] [重置]
```

**优化后**
```
搜索栏：[材料名称] [类别] [搜索] [重置] [新增材料] [库存不足]
```

**改进点**
- ✅ 所有操作按钮集中在一行
- ✅ 按钮顺序：搜索 → 重置 → 新增 → 库存不足
- ✅ 新增按钮在左侧（主要操作）
- ✅ 库存不足在右侧（辅助功能）

#### 按钮文本和颜色
- ✅ "添加" → "新增材料"（更明确）
- ✅ 新增按钮：`type="success"`（绿色，与其他界面一致）
- ✅ 库存不足：`type="warning"`（橙色，表示警告）

#### 下拉框宽度优化
**优化前**
```vue
<el-select v-model="searchForm.category">
```

**优化后**
```vue
<el-select 
  v-model="searchForm.category"
  style="width: 180px"
>
```

**改进点**
- ✅ 类别下拉框宽度从默认120px增加到180px
- ✅ 更好地显示较长的类别名称
- ✅ 视觉上更协调

### 3. 输入框占位符优化

**优化前**
```vue
:placeholder="$t('repairMaterials.materialName')"
```

**优化后**
```vue
:placeholder="$t('common.pleaseEnter')"
```

**改进点**
- ✅ 使用统一的"请输入"提示
- ✅ 与其他界面保持一致
- ✅ 更符合用户习惯

### 4. 对话框标题优化

**优化前**
```javascript
const dialogTitle = computed(() => 
  form.id ? t('common.edit') : t('common.add')
)
```

**优化后**
```javascript
const dialogTitle = computed(() => 
  form.id ? t('common.edit') : t('repairMaterials.addMaterial')
)
```

**改进点**
- ✅ 新增时显示"新增材料"而不是"添加"
- ✅ 更明确的操作提示

### 5. 样式清理

**删除的样式**
```css
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 10px;
}
```

**保留的样式**
```css
.repair-materials-container {
  padding: 20px;
}

.search-form {
  margin-bottom: 20px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

.stock-hint {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}
```

## 优化效果对比

### 优化前
```
┌─────────────────────────────────────────────┐
│ 修复材料管理          [库存不足] [添加]     │
├─────────────────────────────────────────────┤
│ 材料名称: [____] 类别: [____] [搜索] [重置] │
│                                             │
│ [材料列表表格]                              │
└─────────────────────────────────────────────┘
```

### 优化后
```
┌─────────────────────────────────────────────┐
│ 材料名称: [____] 类别: [______]             │
│ [搜索] [重置] [新增材料] [库存不足]         │
│                                             │
│ [材料列表表格]                              │
└─────────────────────────────────────────────┘
```

## 与其他界面的一致性

### 文物管理界面
```
[搜索条件] [搜索(蓝)] [新增文物(绿)]
```

### 修复管理界面
```
[搜索条件] [搜索(蓝)] [新增修复(绿)]
```

### 借展管理界面
```
[搜索条件] [搜索(蓝)] [新增借展(绿)]
```

### 材料管理界面（优化后）
```
[搜索条件] [搜索(蓝)] [重置] [新增材料(绿)] [库存不足(橙)]
```

✅ **保持一致的按钮颜色规范**
- 搜索按钮：`type="primary"` - 蓝色
- 新增按钮：`type="success"` - 绿色
- 警告按钮：`type="warning"` - 橙色
- 删除按钮：`type="danger"` - 红色

## 测试清单

完成优化后，请验证以下功能：

- [ ] 页面正常加载
- [ ] 搜索功能正常
- [ ] 重置功能正常
- [ ] "新增材料"按钮显示正确
- [ ] "新增材料"按钮颜色为绿色（success）✅
- [ ] "库存不足"按钮显示正确
- [ ] "库存不足"按钮颜色为橙色（warning）
- [ ] 类别下拉框宽度合适（180px）
- [ ] 输入框占位符显示"请输入"
- [ ] 新增对话框标题显示"新增材料"
- [ ] 编辑对话框标题显示"编辑"
- [ ] 中英文切换正常
- [ ] 所有翻译显示正确

## 翻译键对照表

| 中文键 | 中文 | 英文键 | 英文 |
|--------|------|--------|------|
| common.actions | 操作 | common.actions | Actions |
| common.pleaseEnter | 请输入 | common.pleaseEnter | Please enter |
| common.required | 此项为必填项 | common.required | This field is required |
| common.createSuccess | 创建成功 | common.createSuccess | Created successfully |
| repairMaterials.addMaterial | 新增材料 | repairMaterials.addMaterial | Add Material |

## 相关文件

- `frontend/src/views/RepairMaterialsView.vue` - 材料管理视图
- `frontend/src/i18n/locales/zh-CN.js` - 中文翻译
- `frontend/src/i18n/locales/en-US.js` - 英文翻译

## 后续建议

1. **统一按钮样式**
   - 确保所有界面的"搜索"按钮都使用 `type="primary"`（蓝色）
   - 确保所有界面的"新增"按钮都使用 `type="success"`（绿色）
   - 确保所有界面的警告按钮都使用 `type="warning"`（橙色）
   - 确保所有界面的删除按钮都使用 `type="danger"`（红色）

2. **统一输入框占位符**
   - 所有输入框使用 `common.pleaseEnter`
   - 所有下拉框使用 `common.pleaseSelect`

3. **统一布局模式**
   - 搜索条件 + 操作按钮在同一行
   - 主要操作按钮在左，辅助按钮在右

4. **响应式设计**
   - 考虑在小屏幕上按钮换行的情况
   - 可以添加媒体查询优化移动端显示

---

优化状态：✅ 完成
测试状态：⏳ 待测试
部署状态：⏳ 待部署
