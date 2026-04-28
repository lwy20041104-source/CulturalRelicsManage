# 🔴 紧急修复说明

## 问题
修复管理界面无法加载数据，后端报错：
```
Could not set property 'materialsUsed' of 'class com.example.entity.RepairRecord'
```

## 原因
数据库表中有 `materials_used` 字段，但Java代码中已删除。

## 解决方法（选择一种）

### 方法1：命令行执行（推荐）⭐
```bash
mysql -u root -p cultural_relics < EXECUTE_THIS_FIX.sql
```

### 方法2：MySQL Workbench
1. 打开MySQL Workbench
2. 连接数据库
3. 打开文件 `EXECUTE_THIS_FIX.sql`
4. 点击执行（⚡图标）

### 方法3：直接执行SQL
```sql
USE cultural_relics;
ALTER TABLE repair_record DROP COLUMN materials_used;
```

## 执行后
1. 重启后端服务
2. 刷新浏览器（Ctrl+F5）
3. 测试修复管理页面

## 需要帮助？
查看详细文档：`backend/docs/URGENT_FIX_MATERIALS_USED.md`
