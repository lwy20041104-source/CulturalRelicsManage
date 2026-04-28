# 快速参考 - 表格增强功能

## 🚀 快速开始

```bash
cd frontend
npm install
npm run dev
```

## ⌨️ 快捷键

| 快捷键 | 功能 |
|--------|------|
| `Ctrl + N` | 新增 |
| `Ctrl + F` | 搜索 |
| `F5` | 刷新 |
| `Delete` | 删除选中 |
| `Ctrl + A` | 全选 |
| `Ctrl + E` | 导出选中 |
| `Esc` | 取消选择 |

## 🎯 功能页面

- **博物馆管理** - 完整功能（快捷键 + 拖拽 + 批量）
- **员工管理** - 快捷键 + 批量操作
- **借展人管理** - 快捷键 + 批量操作

## 📦 核心文件

```
src/
├── composables/useTableEnhancements.js  # 核心功能
├── components/ShortcutHelp.vue          # 帮助按钮
└── views/
    ├── MuseumsView.vue                  # 示例页面
    ├── EmployeesView.vue
    └── LoanersView.vue
```

## 💡 使用示例

### 导入
```javascript
import { useTableEnhancements } from '../composables/useTableEnhancements'
import ShortcutHelp from '../components/ShortcutHelp.vue'
```

### 使用
```javascript
const { selectedIds, handleSelectionChange } = useTableEnhancements({
  onAdd: handleAdd,
  onRefresh: loadData,
  tableRef,
  enableDragSort: true
})
```

### 模板
```vue
<el-table ref="tableRef" @selection-change="handleSelectionChange">
  <el-table-column type="selection" width="55" />
  <!-- 其他列 -->
</el-table>
<ShortcutHelp />
```

## 🎨 拖拽排序

1. 找到排序图标 (☰)
2. 拖动到目标位置
3. 释放完成排序

## 📊 批量操作

1. 勾选数据行
2. 点击批量按钮
3. 确认操作

## 📚 详细文档

- 完整文档: `docs/TABLE_ENHANCEMENTS.md`
- 安装指南: `ENHANCEMENT_SETUP.md`
- 实现总结: `docs/ENHANCEMENT_SUMMARY.md`

## ❓ 帮助

点击页面右下角的 **?** 按钮查看快捷键列表。

---

**版本**: v1.0.0 | **更新**: 2026-04-24
