# 安装说明

## 重要提示

在使用表格增强功能之前，需要安装新的依赖包。

## 安装步骤

### Windows (PowerShell/CMD)

```bash
cd frontend
npm install
```

### Linux/Mac

```bash
cd frontend
npm install
```

## 验证安装

安装完成后，检查是否成功：

```bash
# 检查 sortablejs 是否安装
npm list sortablejs
```

应该看到类似输出：
```
sortablejs@1.15.2
```

## 启动开发服务器

```bash
npm run dev
```

## 访问页面

打开浏览器访问：
- http://localhost:5173/museums （博物馆管理）
- http://localhost:5173/employees （员工管理）
- http://localhost:5173/loaners （借展人管理）

## 测试功能

1. **测试快捷键**
   - 按 `Ctrl + N` 应该打开新增对话框
   - 按 `F5` 应该刷新数据
   - 点击右下角 `?` 按钮查看所有快捷键

2. **测试拖拽排序**（博物馆管理页面）
   - 找到表格第一列的排序图标
   - 拖动行到不同位置
   - 应该看到排序成功提示

3. **测试批量操作**
   - 勾选多行数据
   - 点击"批量删除"或"批量导出"按钮
   - 确认操作成功

## 常见问题

### Q: npm install 失败？

**A**: 尝试以下方法：

1. 清除缓存
```bash
npm cache clean --force
```

2. 删除 node_modules 和 package-lock.json
```bash
rm -rf node_modules package-lock.json  # Linux/Mac
# 或
rmdir /s /q node_modules               # Windows CMD
del package-lock.json                  # Windows CMD
```

3. 重新安装
```bash
npm install
```

### Q: 端口被占用？

**A**: 修改端口或关闭占用端口的程序

```bash
# 查看端口占用 (Windows)
netstat -ano | findstr :5173

# 查看端口占用 (Linux/Mac)
lsof -i :5173
```

### Q: 快捷键不工作？

**A**: 
1. 确保页面已完全加载
2. 确保焦点不在输入框内
3. 检查浏览器控制台是否有错误

### Q: 拖拽排序不工作？

**A**:
1. 确认 sortablejs 已正确安装
2. 检查浏览器控制台是否有错误
3. 尝试刷新页面

## 需要帮助？

查看详细文档：
- `QUICK_REFERENCE.md` - 快速参考
- `ENHANCEMENT_SETUP.md` - 详细设置指南
- `docs/TABLE_ENHANCEMENTS.md` - 完整功能文档

---

**提示**: 如果遇到问题，请先查看浏览器控制台的错误信息。
