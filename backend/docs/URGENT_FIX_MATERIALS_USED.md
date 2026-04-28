# 紧急修复：删除repair_record表的materials_used字段

## 问题描述

**错误信息**：
```
Could not set property 'materialsUsed' of 'class com.example.entity.RepairRecord'
There is no setter for property named 'materialsUsed'
```

**原因**：
- 数据库表 `repair_record` 中仍然有 `materials_used` 字段
- Java实体类 `RepairRecord` 中已经删除了 `materialsUsed` 字段
- MyBatis查询时无法映射该字段，导致异常

## 解决方案

### 方案1：执行SQL脚本（推荐）

**步骤1：打开MySQL客户端**
```bash
mysql -u root -p
```

**步骤2：执行删除脚本**
```bash
source E:/java/Graduate/CulturalRelicsManage/CulturalRelicsManage/backend/sql/repair_record_remove_materials_used.sql
```

或者直接执行：
```bash
mysql -u root -p cultural_relics < backend/sql/repair_record_remove_materials_used.sql
```

### 方案2：手动执行SQL（快速）

**直接在MySQL中执行**：
```sql
USE cultural_relics;

-- 删除materials_used字段
ALTER TABLE repair_record DROP COLUMN materials_used;

-- 验证
SHOW COLUMNS FROM repair_record;
```

### 方案3：使用MySQL Workbench

1. 打开MySQL Workbench
2. 连接到数据库
3. 选择 `cultural_relics` 数据库
4. 执行以下SQL：
```sql
ALTER TABLE repair_record DROP COLUMN materials_used;
```

## 验证修复

### 1. 检查字段是否删除
```sql
USE cultural_relics;

SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'cultural_relics'
  AND TABLE_NAME = 'repair_record'
  AND COLUMN_NAME = 'materials_used';
```

**预期结果**：返回空结果（0行）

### 2. 查看表结构
```sql
SHOW COLUMNS FROM repair_record;
```

**预期结果**：列表中没有 `materials_used` 字段

### 3. 重启后端服务
```bash
# 停止当前服务（Ctrl+C）
# 重新启动
cd backend
mvn spring-boot:run
```

### 4. 测试前端
1. 刷新浏览器（Ctrl+F5）
2. 访问修复管理页面
3. 应该能正常加载数据

## 完整修复流程

```bash
# 1. 执行SQL脚本
mysql -u root -p cultural_relics < backend/sql/repair_record_remove_materials_used.sql

# 2. 重启后端
cd backend
mvn spring-boot:run

# 3. 刷新前端
# 在浏览器中按 Ctrl+F5
```

## 如果问题仍然存在

### 检查1：确认字段已删除
```sql
DESCRIBE repair_record;
```

### 检查2：清理MyBatis缓存
```bash
# 重新编译
cd backend
mvn clean compile
mvn spring-boot:run
```

### 检查3：检查Mapper XML
如果使用了XML配置的Mapper，需要检查是否有引用materials_used字段：
```bash
# 搜索所有Mapper XML文件
grep -r "materials_used" backend/src/main/resources/mapper/
```

### 检查4：检查ResultMap
如果有自定义的ResultMap，需要移除materials_used的映射。

## 数据备份（可选）

如果担心数据丢失，可以先备份：
```sql
-- 备份materials_used字段的数据
CREATE TABLE repair_record_materials_backup AS
SELECT id, repair_code, materials_used
FROM repair_record
WHERE materials_used IS NOT NULL;

-- 查看备份
SELECT * FROM repair_record_materials_backup;
```

## 回滚方案（如果需要）

如果需要恢复materials_used字段：
```sql
-- 恢复字段
ALTER TABLE repair_record 
ADD COLUMN materials_used VARCHAR(500) COMMENT '使用材料' 
AFTER repair_method;

-- 从备份恢复数据（如果有备份）
UPDATE repair_record rr
JOIN repair_record_materials_backup b ON rr.id = b.id
SET rr.materials_used = b.materials_used;
```

## 注意事项

1. **数据丢失**：删除字段后，materials_used中的数据将永久丢失
2. **备份建议**：如果数据重要，请先备份
3. **新架构**：现在材料信息通过 `repair_record_material` 关联表管理
4. **前端适配**：前端需要使用新的材料管理接口

## 相关文档

- [数据库结构变更文档](REPAIR_MATERIAL_RELATION_DESIGN.md)
- [材料管理实现文档](REPAIR_MATERIAL_IMPLEMENTATION.md)
- [迁移脚本](../sql/repair_record_remove_materials_used.sql)

## 常见问题

### Q1: 删除字段后数据会丢失吗？
A: 是的，materials_used字段中的数据会丢失。如果需要保留，请先备份。

### Q2: 如何查看之前使用的材料？
A: 现在通过 `repair_record_material` 关联表管理材料使用记录。

### Q3: 前端如何显示材料信息？
A: 使用新的API接口：
```javascript
GET /api/repair-materials/repair-record/{repairRecordId}
```

### Q4: 如何添加材料使用记录？
A: 使用新的API接口：
```javascript
POST /api/repair-materials/usage
{
  "repairRecordId": 1,
  "materialId": 3,
  "quantity": 2.5,
  "unitPrice": 150.00
}
```

---

**紧急程度**：🔴 高  
**影响范围**：修复管理模块  
**修复时间**：< 5分钟  
**需要重启**：是
