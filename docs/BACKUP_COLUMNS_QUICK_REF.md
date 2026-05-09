# 数据备份列表新增列 - 快速参考

## 新增列概览

| 列名 | 数据库字段 | 显示位置 | 特殊样式 |
|------|-----------|---------|---------|
| 描述 | description | 创建时间之后 | 无 |
| 错误信息 | error_message | 描述之后 | 有错误时显示红色 |

## 代码位置

### 前端
```
frontend/src/views/BackupView.vue
- 第 70-85 行：新增的两个表格列
```

### 国际化
```
frontend/src/i18n/locales/zh-CN.js
- backup.description: '备份描述'
- backup.errorMessage: '错误信息'

frontend/src/i18n/locales/en-US.js
- backup.description: 'Description'
- backup.errorMessage: 'Error Message'
```

## 显示逻辑

### 描述列
```vue
<el-table-column 
  prop="description" 
  :label="$t('backup.description')" 
  min-width="200" 
  show-overflow-tooltip 
/>
```
- 直接显示 `description` 字段
- 长文本自动省略，悬停显示完整内容

### 错误信息列
```vue
<el-table-column :label="$t('backup.errorMessage')" min-width="200" show-overflow-tooltip>
  <template #default="scope">
    <span v-if="scope.row.errorMessage" style="color: #F56C6C;">
      {{ scope.row.errorMessage }}
    </span>
    <span v-else style="color: #909399;">—</span>
  </template>
</el-table-column>
```
- 有错误：红色文本（#F56C6C）
- 无错误：灰色占位符"—"（#909399）

## 测试清单

- [ ] 创建带描述的备份 → 描述正确显示
- [ ] 创建不带描述的备份 → 显示为空
- [ ] 查看失败的备份 → 错误信息显示为红色
- [ ] 查看成功的备份 → 显示灰色"—"
- [ ] 测试长文本 → 省略号和悬停提示正常
- [ ] 切换中英文 → 列标题正确翻译

## 快速验证

### SQL 查询
```sql
-- 查看备份记录的描述和错误信息
SELECT 
    backup_name,
    backup_status,
    description,
    error_message
FROM sys_backup
ORDER BY created_time DESC
LIMIT 5;
```

### 测试数据
```sql
-- 添加测试描述
UPDATE sys_backup 
SET description = '测试备份 - 系统升级前' 
WHERE id = 1;

-- 添加测试错误信息（仅用于测试）
UPDATE sys_backup 
SET error_message = '测试错误：备份文件创建失败' 
WHERE id = 2;
```

## 常见问题

**Q: 为什么有些备份没有描述？**  
A: 历史备份可能没有填写描述，这是正常的。

**Q: 成功的备份为什么显示"—"？**  
A: 成功的备份没有错误信息，所以显示占位符。

**Q: 错误信息太长怎么办？**  
A: 鼠标悬停在错误信息上可以看到完整内容。

**Q: 可以编辑描述吗？**  
A: 当前版本不支持在列表中直接编辑，需要在创建备份时填写。

## 相关文档

- 详细文档：`docs/BACKUP_VIEW_COLUMNS_UPDATE.md`
- 使用指南：`docs/BACKUP_SYSTEM_GUIDE.md`

---

**更新日期**：2026-05-09  
**版本**：v1.0
