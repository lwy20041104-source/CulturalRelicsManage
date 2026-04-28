# CRUD按钮国际化指南

## 概述
为系统中所有界面的增删改查和批量操作按钮实现国际化，使其在英文语言下显示为英文。

## 已添加的通用翻译键

### common 命名空间新增键

| 中文键 | 英文翻译 | 用途 |
|--------|---------|------|
| batchDelete | Batch Delete | 批量删除按钮 |
| batchUpdate | Batch Update | 批量修改按钮 |
| batchUpdateStatus | Batch Update Status | 批量修改状态按钮 |
| batchOperation | Batch Operation | 批量操作 |
| selected | Selected | 已选择 |
| deleteConfirm | Are you sure to delete? | 删除确认 |
| batchDeleteConfirm | Are you sure to delete {count} selected items? | 批量删除确认 |
| deleteSuccess | Deleted successfully | 删除成功 |
| deleteFailed | Delete failed | 删除失败 |
| updateSuccess | Updated successfully | 更新成功 |
| updateFailed | Update failed | 更新失败 |
| saveSuccess | Saved successfully | 保存成功 |
| saveFailed | Save failed | 保存失败 |
| addSuccess | Added successfully | 添加成功 |
| addFailed | Add failed | 添加失败 |
| enable | Enable | 启用 |
| disable | Disable | 禁用 |
| enabled | Enabled | 已启用 |
| disabled | Disabled | 已禁用 |
| selectAll | Select All | 全选 |
| deselectAll | Deselect All | 取消全选 |
| changeTo | Change To | 修改为 |

## 需要修改的界面列表

### 主要管理界面
1. ✅ UsersView.vue - 用户管理
2. ⏳ MuseumsView.vue - 博物馆管理
3. ⏳ EmployeesView.vue - 员工管理
4. ⏳ LoanersView.vue - 借展人管理
5. ⏳ RelicsView.vue - 文物管理
6. ⏳ CategoriesView.vue - 分类管理
7. ⏳ LoansView.vue - 借展管理
8. ⏳ RepairsView.vue - 修复管理
9. ⏳ MaintenanceView.vue - 维护记录
10. ⏳ ExpertsView.vue - 修复专家
11. ⏳ ImageLibraryView.vue - 图片管理
12. ⏳ ArchivesView.vue - 档案管理
13. ⏳ OperationLogsView.vue - 操作日志
14. ⏳ NotificationsView.vue - 通知管理

## 修改模式

### 1. 按钮文本修改

#### 修改前
```vue
<el-button type="primary" @click="handleQuery">搜索</el-button>
<el-button @click="handleReset">重置</el-button>
<el-button type="success" @click="handleAdd">新增博物馆</el-button>
<el-button type="danger" @click="batchDelete">批量删除</el-button>
<el-button type="warning" @click="batchUpdateStatus">批量修改状态</el-button>
<el-button link type="primary" @click="handleEdit(scope.row)">编辑</el-button>
<el-button link type="danger" @click="handleDelete(scope.row)">删除</el-button>
```

#### 修改后
```vue
<el-button type="primary" @click="handleQuery">{{ $t('common.search') }}</el-button>
<el-button @click="handleReset">{{ $t('common.reset') }}</el-button>
<el-button type="success" @click="handleAdd">{{ $t('museum.add') }}</el-button>
<el-button type="danger" @click="batchDelete">{{ $t('common.batchDelete') }}</el-button>
<el-button type="warning" @click="batchUpdateStatus">{{ $t('common.batchUpdateStatus') }}</el-button>
<el-button link type="primary" @click="handleEdit(scope.row)">{{ $t('common.edit') }}</el-button>
<el-button link type="danger" @click="handleDelete(scope.row)">{{ $t('common.delete') }}</el-button>
```

### 2. 对话框标题修改

#### 修改前
```javascript
const handleAdd = () => {
  dialogTitle.value = '新增博物馆'
  // ...
}

const handleEdit = (row) => {
  dialogTitle.value = '编辑博物馆'
  // ...
}
```

#### 修改后
```javascript
const handleAdd = () => {
  dialogTitle.value = t('museum.add')
  // ...
}

const handleEdit = (row) => {
  dialogTitle.value = t('museum.edit')
  // ...
}
```

### 3. 确认消息修改

#### 修改前
```javascript
await ElMessageBox.confirm(
  `确定要删除博物馆"${row.museumName}"吗？`,
  '提示',
  { type: 'warning' }
)
```

#### 修改后
```javascript
await ElMessageBox.confirm(
  t('museum.deleteConfirm', { name: row.museumName }),
  t('common.warning'),
  { type: 'warning' }
)
```

### 4. 成功/失败消息修改

#### 修改前
```javascript
ElMessage.success('删除成功')
ElMessage.error('删除失败')
```

#### 修改后
```javascript
ElMessage.success(t('common.deleteSuccess'))
ElMessage.error(t('common.deleteFailed'))
```

### 5. 表格列标题修改

#### 修改前
```vue
<el-table-column prop="museumCode" label="博物馆编码" width="120" />
<el-table-column prop="museumName" label="博物馆名称" min-width="150" />
<el-table-column label="操作" width="180" fixed="right">
```

#### 修改后
```vue
<el-table-column prop="museumCode" :label="$t('museum.code')" width="120" />
<el-table-column prop="museumName" :label="$t('museum.name')" min-width="150" />
<el-table-column :label="$t('common.operation')" width="180" fixed="right">
```

### 6. 表单标签修改

#### 修改前
```vue
<el-form-item label="博物馆编码" prop="museumCode">
<el-form-item label="博物馆名称" prop="museumName">
```

#### 修改后
```vue
<el-form-item :label="$t('museum.code')" prop="museumCode">
<el-form-item :label="$t('museum.name')" prop="museumName">
```

### 7. 占位符修改

#### 修改前
```vue
<el-input v-model="queryParams.museumName" placeholder="博物馆名称" />
<el-select v-model="queryParams.status" placeholder="合作状态">
```

#### 修改后
```vue
<el-input v-model="queryParams.museumName" :placeholder="$t('museum.name')" />
<el-select v-model="queryParams.status" :placeholder="$t('museum.status')">
```

## 特定界面的翻译键

### 博物馆管理（museum）
```javascript
museum: {
  title: '博物馆管理',
  code: '博物馆编码',
  name: '博物馆名称',
  type: '博物馆类型',
  add: '新增博物馆',
  edit: '编辑博物馆',
  deleteConfirm: '确定要删除博物馆"{name}"吗？',
  // ...
}
```

### 员工管理（employee）
```javascript
employee: {
  title: '员工管理',
  add: '新增员工',
  edit: '编辑员工',
  // ...
}
```

### 文物管理（relic）
```javascript
relic: {
  title: '文物管理',
  add: '新增文物',
  edit: '编辑文物',
  batchUpdateStatus: '批量修改状态',
  // ...
}
```

## 实现步骤

### 步骤1：导入 useI18n
```javascript
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
```

### 步骤2：修改模板中的硬编码文本
- 按钮文本：使用 `{{ $t('key') }}`
- 属性绑定：使用 `:label="$t('key')"` 或 `:placeholder="$t('key')"`

### 步骤3：修改脚本中的硬编码文本
- 对话框标题：使用 `t('key')`
- 消息提示：使用 `t('key')`
- 确认对话框：使用 `t('key', { param: value })`

### 步骤4：添加特定界面的翻译键
在 `zh-CN.js` 和 `en-US.js` 中添加对应的翻译。

## 注意事项

1. **保持一致性**：相同功能的按钮使用相同的翻译键
2. **参数化消息**：删除确认等消息使用参数化，如 `{name}`、`{count}`
3. **避免重复**：优先使用 `common` 命名空间的通用键
4. **测试验证**：修改后切换语言验证所有文本是否正确显示

## 批量修改建议

由于文件较多，建议按以下优先级修改：

### 高优先级（核心管理界面）
1. UsersView.vue
2. RelicsView.vue
3. LoansView.vue
4. RepairsView.vue
5. MuseumsView.vue

### 中优先级（辅助管理界面）
6. EmployeesView.vue
7. LoanersView.vue
8. CategoriesView.vue
9. ExpertsView.vue
10. MaintenanceView.vue

### 低优先级（其他界面）
11. ImageLibraryView.vue
12. ArchivesView.vue
13. OperationLogsView.vue
14. NotificationsView.vue

## 示例：完整的 MuseumsView.vue 修改

见下一个文档：`MUSEUMS_VIEW_I18N_EXAMPLE.md`
