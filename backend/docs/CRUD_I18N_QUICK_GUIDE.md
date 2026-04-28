# CRUD按钮国际化快速指南

## 已完成的工作

### 1. 添加了通用翻译键
在 `zh-CN.js` 和 `en-US.js` 中的 `common` 命名空间添加了以下键：

```javascript
// 批量操作
batchDelete: '批量删除' / 'Batch Delete'
batchUpdate: '批量修改' / 'Batch Update'
batchUpdateStatus: '批量修改状态' / 'Batch Update Status'
batchOperation: '批量操作' / 'Batch Operation'

// 操作反馈
deleteSuccess: '删除成功' / 'Deleted successfully'
deleteFailed: '删除失败' / 'Delete failed'
updateSuccess: '更新成功' / 'Updated successfully'
updateFailed: '更新失败' / 'Update failed'
saveSuccess: '保存成功' / 'Saved successfully'
saveFailed: '保存失败' / 'Save failed'
addSuccess: '添加成功' / 'Added successfully'
addFailed: '添加失败' / 'Add failed'

// 确认消息
deleteConfirm: '确定要删除吗？' / 'Are you sure to delete?'
batchDeleteConfirm: '确定要删除选中的 {count} 条数据吗？' / 'Are you sure to delete {count} selected items?'

// 状态
enable: '启用' / 'Enable'
disable: '禁用' / 'Disable'
enabled: '已启用' / 'Enabled'
disabled: '已禁用' / 'Disabled'

// 其他
selected: '已选择' / 'Selected'
changeTo: '修改为' / 'Change To'
selectAll: '全选' / 'Select All'
deselectAll: '取消全选' / 'Deselect All'
```

## 快速修改模式

### 模式1：按钮文本
```vue
<!-- 修改前 -->
<el-button type="primary">搜索</el-button>
<el-button>重置</el-button>
<el-button type="success">新增</el-button>
<el-button type="danger">批量删除</el-button>
<el-button link type="primary">编辑</el-button>
<el-button link type="danger">删除</el-button>

<!-- 修改后 -->
<el-button type="primary">{{ $t('common.search') }}</el-button>
<el-button>{{ $t('common.reset') }}</el-button>
<el-button type="success">{{ $t('模块.add') }}</el-button>
<el-button type="danger">{{ $t('common.batchDelete') }}</el-button>
<el-button link type="primary">{{ $t('common.edit') }}</el-button>
<el-button link type="danger">{{ $t('common.delete') }}</el-button>
```

### 模式2：消息提示
```javascript
// 修改前
ElMessage.success('删除成功')
ElMessage.error('删除失败')
ElMessage.success('保存成功')

// 修改后
ElMessage.success(t('common.deleteSuccess'))
ElMessage.error(t('common.deleteFailed'))
ElMessage.success(t('common.saveSuccess'))
```

### 模式3：确认对话框
```javascript
// 修改前
await ElMessageBox.confirm('确定要删除吗？', '提示', { type: 'warning' })
await ElMessageBox.confirm(`确定要删除选中的 ${count} 条数据吗？`, '警告')

// 修改后
await ElMessageBox.confirm(t('common.deleteConfirm'), t('common.tip'), { type: 'warning' })
await ElMessageBox.confirm(
  t('common.batchDeleteConfirm', { count }), 
  t('common.warning')
)
```

## 需要修改的主要文件

### 已完成 ✅
- ProfileView.vue
- PortalProfileView.vue
- PublicPortalView.vue（部分）

### 待修改 ⏳
1. **UsersView.vue** - 用户管理（已有部分国际化）
2. **MuseumsView.vue** - 博物馆管理
3. **EmployeesView.vue** - 员工管理
4. **LoanersView.vue** - 借展人管理
5. **RelicsView.vue** - 文物管理
6. **CategoriesView.vue** - 分类管理
7. **LoansView.vue** - 借展管理
8. **RepairsView.vue** - 修复管理
9. **MaintenanceView.vue** - 维护记录
10. **ExpertsView.vue** - 修复专家
11. **ImageLibraryView.vue** - 图片管理
12. **ArchivesView.vue** - 档案管理
13. **OperationLogsView.vue** - 操作日志

## 修改建议

由于文件数量较多，建议：

1. **优先修改核心界面**：用户管理、文物管理、借展管理、修复管理
2. **使用通用键**：优先使用 `common` 命名空间的键，减少重复翻译
3. **批量替换**：使用编辑器的查找替换功能批量修改常见模式
4. **分批测试**：每修改几个文件就测试一次，确保功能正常

## 常见替换模式

### 搜索和替换规则

1. `>搜索</el-button>` → `>{{ $t('common.search') }}</el-button>`
2. `>重置</el-button>` → `>{{ $t('common.reset') }}</el-button>`
3. `>编辑</el-button>` → `>{{ $t('common.edit') }}</el-button>`
4. `>删除</el-button>` → `>{{ $t('common.delete') }}</el-button>`
5. `>批量删除</el-button>` → `>{{ $t('common.batchDelete') }}</el-button>`
6. `ElMessage.success('删除成功')` → `ElMessage.success(t('common.deleteSuccess'))`
7. `ElMessage.error('删除失败')` → `ElMessage.error(t('common.deleteFailed'))`

## 注意事项

1. **导入 useI18n**：确保在 script setup 中导入
   ```javascript
   import { useI18n } from 'vue-i18n'
   const { t } = useI18n()
   ```

2. **模板 vs 脚本**：
   - 模板中使用 `$t('key')`
   - 脚本中使用 `t('key')`

3. **参数化消息**：使用 `{count}`、`{name}` 等参数
   ```javascript
   t('common.batchDeleteConfirm', { count: 5 })
   ```

4. **测试验证**：修改后切换语言测试所有按钮和消息

## 构建和测试

修改完成后：
```bash
cd frontend
npm run build
```

确保构建成功，然后在浏览器中测试语言切换功能。
