# 表格增强功能使用说明

## 功能概述

本系统为主要管理页面添加了以下增强功能：
1. **快捷键支持** - 提高操作效率
2. **拖拽排序** - 直观的数据排序
3. **批量操作** - 批量删除、批量导出

## 已启用页面

- ✅ 博物馆管理 (`MuseumsView.vue`) - 完整功能
- ✅ 员工管理 (`EmployeesView.vue`) - 快捷键 + 批量操作
- ✅ 借展人管理 (`LoanersView.vue`) - 快捷键 + 批量操作

## 快捷键列表

| 快捷键 | 功能 | 说明 |
|--------|------|------|
| `Ctrl + N` | 新增 | 打开新增对话框 |
| `Ctrl + F` | 搜索 | 聚焦到搜索框 |
| `F5` | 刷新 | 重新加载数据 |
| `Delete` | 删除选中项 | 删除已选中的行 |
| `Ctrl + A` | 全选 | 选中表格所有行 |
| `Ctrl + E` | 导出选中项 | 导出已选中的数据为CSV |
| `Esc` | 取消选择 | 清除所有选中项 |

## 拖拽排序

### 启用条件
- 博物馆管理页面已启用
- 其他页面可根据需要启用

### 使用方法
1. 找到表格第一列的 **排序图标** (☰)
2. 按住图标拖动行到目标位置
3. 释放鼠标完成排序
4. 系统会显示排序结果提示

### 视觉反馈
- **拖动中**: 行变为半透明，显示拖动效果
- **目标位置**: 高亮显示可放置位置
- **完成后**: 显示成功提示消息

## 批量操作

### 批量删除
1. 勾选表格左侧的复选框选择多行
2. 点击 **批量删除** 按钮（显示已选数量）
3. 确认删除操作
4. 系统执行批量删除并刷新数据

### 批量导出
1. 勾选要导出的数据行
2. 点击 **批量导出** 按钮
3. 系统自动下载CSV文件
4. 文件包含所有选中行的数据

### 导出格式
- 文件格式: CSV (UTF-8 with BOM)
- 文件名: `{页面名称}数据.csv`
- 包含列: 所有主要字段

## 快捷键帮助按钮

### 位置
- 固定在页面右下角
- 紫色渐变圆形按钮
- 悬停时有动画效果

### 使用方法
1. 点击右下角的 **?** 按钮
2. 查看完整快捷键列表
3. 点击页面其他位置关闭

## 开发指南

### 在新页面中启用功能

#### 1. 导入组合式函数
```javascript
import { useTableEnhancements } from '../composables/useTableEnhancements'
import ShortcutHelp from '../components/ShortcutHelp.vue'
```

#### 2. 使用组合式函数
```javascript
const tableRef = ref(null)

const {
  selectedIds,
  handleSelectionChange,
  confirmBatchOperation,
  initDragSort
} = useTableEnhancements({
  onAdd: handleAdd,           // 新增回调
  onRefresh: loadData,        // 刷新回调
  onBatchDelete: (ids) => {   // 批量删除回调
    confirmBatchOperation('确定要删除吗？', async (ids) => {
      // 删除逻辑
    })
  },
  onBatchExport: (ids) => {   // 批量导出回调
    // 导出逻辑
  },
  tableRef,                   // 表格ref
  enableDragSort: true,       // 是否启用拖拽
  onDragEnd: (oldIndex, newIndex) => {
    // 拖拽结束回调
  }
})
```

#### 3. 修改模板
```vue
<template>
  <!-- 添加ref和selection-change -->
  <el-table 
    ref="tableRef"
    :data="tableData"
    @selection-change="handleSelectionChange"
    row-key="id"
  >
    <!-- 添加选择列 -->
    <el-table-column type="selection" width="55" />
    
    <!-- 如果启用拖拽，添加拖拽列 -->
    <el-table-column label="排序" width="60" align="center">
      <template #default>
        <el-icon class="drag-handle">
          <Rank />
        </el-icon>
      </template>
    </el-table-column>
    
    <!-- 其他列... -->
  </el-table>
  
  <!-- 添加快捷键帮助按钮 -->
  <ShortcutHelp />
</template>
```

#### 4. 添加批量操作按钮
```vue
<el-button 
  type="danger" 
  :disabled="selectedIds.length === 0"
  @click="handleBatchDelete"
>
  批量删除 ({{ selectedIds.length }})
</el-button>
```

#### 5. 添加拖拽样式
```css
.drag-handle {
  cursor: move;
  color: #909399;
  transition: color 0.3s;
}

.drag-handle:hover {
  color: #409eff;
}

:deep(.sortable-ghost) {
  opacity: 0.4;
  background: #f0f9ff;
}

:deep(.sortable-chosen) {
  background: #e0f2fe;
}

:deep(.sortable-drag) {
  opacity: 0.8;
  background: #fff;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}
```

## 注意事项

1. **快捷键冲突**: 
   - 避免在输入框聚焦时触发快捷键
   - 系统会自动处理输入框内的快捷键

2. **拖拽排序**:
   - 仅在当前页面内排序
   - 不会自动保存到后端
   - 需要手动实现持久化逻辑

3. **批量操作**:
   - 操作前会显示确认对话框
   - 失败时会显示错误提示
   - 成功后自动刷新数据

4. **性能优化**:
   - 大数据量时建议禁用拖拽排序
   - 批量操作建议限制最大数量
   - 导出大量数据时考虑后端处理

## 依赖库

- `sortablejs`: ^1.15.2 - 拖拽排序功能
- `element-plus`: ^2.7.8 - UI组件库

## 安装依赖

```bash
cd frontend
npm install sortablejs
```

## 浏览器兼容性

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 更新日志

### v1.0.0 (2026-04-24)
- ✨ 新增快捷键支持
- ✨ 新增拖拽排序功能
- ✨ 新增批量操作功能
- ✨ 新增快捷键帮助组件
- 📝 完善使用文档

## 反馈与建议

如有问题或建议，请联系开发团队。
