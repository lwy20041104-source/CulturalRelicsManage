# 表格增强功能安装指南

## 快速开始

### 1. 安装依赖

```bash
cd frontend
npm install
```

这将自动安装 `sortablejs` 库（已添加到 package.json）。

### 2. 启动开发服务器

```bash
npm run dev
```

### 3. 访问页面

打开浏览器访问以下页面查看增强功能：

- **博物馆管理**: http://localhost:5173/museums
  - ✅ 快捷键支持
  - ✅ 拖拽排序
  - ✅ 批量删除
  - ✅ 批量导出

- **员工管理**: http://localhost:5173/employees
  - ✅ 快捷键支持
  - ✅ 批量删除
  - ✅ 批量导出

- **借展人管理**: http://localhost:5173/loaners
  - ✅ 快捷键支持
  - ✅ 批量删除
  - ✅ 批量导出

## 功能演示

### 快捷键操作

1. 在任意管理页面，按 `Ctrl + N` 打开新增对话框
2. 按 `Ctrl + F` 聚焦到搜索框
3. 按 `F5` 刷新数据
4. 选中数据后按 `Delete` 删除
5. 按 `Ctrl + A` 全选数据
6. 选中数据后按 `Ctrl + E` 导出
7. 按 `Esc` 取消选择

### 拖拽排序（博物馆管理）

1. 找到表格第一列的排序图标 (☰)
2. 按住图标拖动行
3. 移动到目标位置后释放
4. 查看排序结果提示

### 批量操作

1. 勾选表格左侧的复选框
2. 点击 **批量删除** 或 **批量导出** 按钮
3. 确认操作
4. 查看结果

### 快捷键帮助

点击页面右下角的紫色 **?** 按钮查看完整快捷键列表。

## 文件结构

```
frontend/
├── src/
│   ├── composables/
│   │   └── useTableEnhancements.js    # 表格增强组合式函数
│   ├── components/
│   │   └── ShortcutHelp.vue           # 快捷键帮助组件
│   └── views/
│       ├── MuseumsView.vue            # 博物馆管理（完整功能）
│       ├── EmployeesView.vue          # 员工管理（快捷键+批量）
│       └── LoanersView.vue            # 借展人管理（快捷键+批量）
├── docs/
│   └── TABLE_ENHANCEMENTS.md          # 详细使用文档
├── package.json                        # 依赖配置
└── ENHANCEMENT_SETUP.md               # 本文件
```

## 核心文件说明

### useTableEnhancements.js
提供以下功能：
- 快捷键监听和处理
- 拖拽排序初始化
- 批量操作辅助函数
- 选择状态管理

### ShortcutHelp.vue
- 快捷键帮助浮动按钮
- 快捷键列表展示
- 美观的UI设计

## 自定义配置

### 修改快捷键

编辑 `src/composables/useTableEnhancements.js`:

```javascript
const handleKeydown = (e) => {
  // 修改或添加快捷键
  if (e.ctrlKey && e.key === 'n') {
    // 你的逻辑
  }
}
```

### 启用/禁用拖拽排序

在组件中设置 `enableDragSort`:

```javascript
const { ... } = useTableEnhancements({
  enableDragSort: true,  // true启用，false禁用
  // ...
})
```

### 自定义导出格式

修改 `convertToCSV` 函数：

```javascript
const convertToCSV = (data) => {
  const headers = ['列1', '列2', '列3']
  const rows = data.map(item => [
    item.field1,
    item.field2,
    item.field3
  ])
  return [headers, ...rows].map(row => row.join(',')).join('\n')
}
```

## 常见问题

### Q: 快捷键不生效？
A: 确保页面已加载完成，且焦点不在输入框内。

### Q: 拖拽排序后数据没有保存？
A: 拖拽排序仅在前端生效，需要实现后端保存逻辑。

### Q: 批量导出的CSV文件乱码？
A: 已添加UTF-8 BOM，确保使用Excel 2016+或其他支持UTF-8的软件打开。

### Q: 如何在其他页面启用这些功能？
A: 参考 `docs/TABLE_ENHANCEMENTS.md` 中的开发指南。

## 技术栈

- Vue 3.4+
- Element Plus 2.7+
- Sortable.js 1.15+
- Vite 5.3+

## 浏览器支持

- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 性能建议

1. **大数据量**:
   - 禁用拖拽排序
   - 使用虚拟滚动
   - 限制批量操作数量

2. **移动端**:
   - 快捷键在移动端不可用
   - 拖拽排序需要触摸优化
   - 建议使用响应式设计

## 下一步

1. 查看 `docs/TABLE_ENHANCEMENTS.md` 了解详细功能
2. 在其他管理页面启用这些功能
3. 根据需求自定义快捷键和操作

## 支持

如有问题，请查看文档或联系开发团队。
