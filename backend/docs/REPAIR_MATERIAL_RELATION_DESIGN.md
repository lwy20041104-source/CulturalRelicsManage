# 修复记录与材料关联设计文档

## 变更概述
将修复记录与材料的关系从简单文本字段改为规范的多对多关联关系。

## 变更时间
2026-04-27

## 数据库结构变更

### 变更前

**repair_record表**
```sql
CREATE TABLE repair_record (
    -- ... 其他字段
    repair_method VARCHAR(500),
    materials_used VARCHAR(500),  -- ❌ 文本字段，存储材料名称
    actual_cost DECIMAL(10,2),
    -- ... 其他字段
);
```

**问题**：
- ❌ 只能存储材料名称文本
- ❌ 无法记录使用数量
- ❌ 无法记录单价和总价
- ❌ 无法进行库存管理
- ❌ 无法进行成本统计
- ❌ 数据不规范，难以查询和分析

### 变更后

**repair_record表**
```sql
CREATE TABLE repair_record (
    -- ... 其他字段
    repair_method VARCHAR(500),
    -- materials_used字段已删除 ✅
    actual_cost DECIMAL(10,2),
    -- ... 其他字段
);
```

**repair_material表**（材料主表）
```sql
CREATE TABLE repair_material (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    material_name VARCHAR(100) NOT NULL,
    material_code VARCHAR(50) UNIQUE,
    category VARCHAR(50),
    unit VARCHAR(20),
    unit_price DECIMAL(10,2),
    stock_quantity DECIMAL(10,2) DEFAULT 0,
    supplier VARCHAR(100),
    remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**repair_record_material表**（关联表）
```sql
CREATE TABLE repair_record_material (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    repair_record_id BIGINT NOT NULL,      -- 修复记录ID
    material_id BIGINT NOT NULL,           -- 材料ID
    quantity DECIMAL(10,2) NOT NULL,       -- 使用数量
    unit_price DECIMAL(10,2) NOT NULL,     -- 单价（记录使用时的价格）
    total_price DECIMAL(10,2) NOT NULL,    -- 总价
    remark VARCHAR(500),                   -- 备注
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (repair_record_id) REFERENCES repair_record(id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES repair_material(id) ON DELETE RESTRICT
);
```

## 关系设计

### 多对多关系
```
repair_record (1) <---> (N) repair_record_material <---> (N) repair_material (1)
```

**说明**：
- 一个修复记录可以使用多个材料
- 一个材料可以被多个修复记录使用
- 通过中间表记录详细的使用信息

### 外键约束

**ON DELETE CASCADE**（repair_record_id）
- 删除修复记录时，自动删除相关的材料使用记录
- 保证数据一致性

**ON DELETE RESTRICT**（material_id）
- 如果材料被使用过，禁止删除该材料
- 保护历史数据

## 代码变更

### 后端实体类

**RepairRecord.java**
```java
// 删除字段
// private String materialsUsed;  ❌

// 添加注释
// 注意：使用材料信息已移至repair_record_material关联表
```

**RepairProgressRequest.java**
```java
// 删除字段
// private String materialsUsed;  ❌

// 添加注释
// 注意：材料使用信息通过repair_record_material关联表管理
```

**RepairRecordServiceImpl.java**
```java
// 删除代码
// if (request.getMaterialsUsed() != null) {
//     record.setMaterialsUsed(request.getMaterialsUsed());
// }

// 添加注释
// 注意：材料使用信息通过repair_record_material关联表管理
```

### 新增实体类

**RepairMaterial.java**
- 材料主表实体

**RepairRecordMaterial.java**
- 关联表实体
- 包含使用数量、单价、总价等信息

### 新增Mapper

**RepairMaterialMapper.java**
- 材料CRUD操作
- 库存管理
- 统计查询

**RepairRecordMaterialMapper.java**
- 关联关系管理
- 使用记录查询
- 统计分析

### 新增Service

**RepairMaterialService.java**
- 材料管理业务逻辑
- 库存管理
- 使用记录管理
- 统计分析

### 新增Controller

**RepairMaterialController.java**
- 材料管理API
- 13个接口端点

## 数据迁移

### 迁移脚本

**repair_record_material_migration.sql**
- 完整的迁移脚本
- 包含数据备份、迁移、验证
- 包含回滚脚本

**repair_record_remove_materials_used.sql**
- 快速迁移脚本
- 直接删除materials_used字段

### 迁移步骤

1. **备份数据**（可选）
```sql
CREATE TABLE repair_record_backup AS SELECT * FROM repair_record;
```

2. **创建关联表**
```bash
mysql -u root -p cultural_relics < backend/sql/repair_material_relation.sql
```

3. **删除旧字段**
```bash
mysql -u root -p cultural_relics < backend/sql/repair_record_remove_materials_used.sql
```

4. **重启后端服务**
```bash
cd backend
mvn spring-boot:run
```

## 功能优势

### 1. 结构化数据
- ✅ 材料信息规范化存储
- ✅ 使用数量、单价、总价明确记录
- ✅ 支持复杂查询和统计

### 2. 库存管理
- ✅ 实时库存跟踪
- ✅ 自动扣减库存
- ✅ 库存不足提醒
- ✅ 库存历史记录

### 3. 成本管理
- ✅ 记录使用时的实际价格
- ✅ 自动计算总价
- ✅ 支持成本统计分析
- ✅ 支持预算对比

### 4. 数据完整性
- ✅ 外键约束保证数据一致性
- ✅ 级联删除避免孤儿数据
- ✅ 限制删除保护历史数据

### 5. 查询分析
- ✅ 查询某个修复记录使用的所有材料
- ✅ 查询某个材料被哪些修复记录使用
- ✅ 统计材料使用总量
- ✅ 统计材料使用总金额
- ✅ 分析材料使用趋势

## 使用示例

### 1. 添加材料使用记录

**API调用**
```javascript
POST /api/repair-materials/usage
{
  "repairRecordId": 1,
  "materialId": 3,
  "quantity": 2.5,
  "unitPrice": 150.00,
  "remark": "用于陶瓷粘合"
}
```

**后端处理**
1. 检查材料是否存在
2. 检查库存是否足够
3. 计算总价（2.5 × 150.00 = 375.00）
4. 插入使用记录
5. 自动扣减库存（-2.5）

### 2. 查询修复记录的材料

**API调用**
```javascript
GET /api/repair-materials/repair-record/1
```

**返回数据**
```json
[
  {
    "id": 1,
    "repairRecordId": 1,
    "materialId": 3,
    "materialName": "环氧树脂",
    "materialCode": "MAT001",
    "quantity": 2.5,
    "unit": "kg",
    "unitPrice": 150.00,
    "totalPrice": 375.00,
    "remark": "用于陶瓷粘合"
  }
]
```

### 3. 查询材料使用统计

**API调用**
```javascript
GET /api/repair-materials/3/statistics
```

**返回数据**
```json
{
  "material": {
    "id": 3,
    "materialName": "环氧树脂",
    "stockQuantity": 47.5
  },
  "totalQuantity": 12.5,
  "totalAmount": 1875.00,
  "usageCount": 5,
  "usageRecords": [...]
}
```

## 前端集成

### 修复记录详情页

**显示使用的材料**
```vue
<el-table :data="materials">
  <el-table-column prop="materialName" label="材料名称" />
  <el-table-column prop="quantity" label="数量" />
  <el-table-column prop="unit" label="单位" />
  <el-table-column prop="unitPrice" label="单价" />
  <el-table-column prop="totalPrice" label="总价" />
</el-table>
```

**添加材料使用**
```vue
<el-button @click="showAddMaterial">添加材料</el-button>
```

### 材料管理页面

**查看使用记录**
```vue
<el-button @click="showStatistics(row)">统计</el-button>
```

## 注意事项

### 1. 数据迁移
- ⚠️ 旧的materials_used字段数据会丢失
- ⚠️ 如需保留，请先备份
- ⚠️ 迁移前请在测试环境验证

### 2. 前端适配
- ⚠️ 修复记录表单需要移除材料输入框
- ⚠️ 添加材料选择和数量输入功能
- ⚠️ 修复记录详情页需要显示材料列表

### 3. 库存管理
- ⚠️ 添加材料使用时会自动扣减库存
- ⚠️ 删除使用记录时会恢复库存
- ⚠️ 库存不足时无法添加使用记录

### 4. 权限控制
- ⚠️ 只有管理员和馆长可以管理材料
- ⚠️ 修复专家可以查看和添加使用记录
- ⚠️ 删除材料需要管理员权限

## 测试清单

### 数据库测试
- [ ] 执行迁移脚本成功
- [ ] materials_used字段已删除
- [ ] repair_record_material表已创建
- [ ] 外键约束正常工作
- [ ] 测试数据插入成功

### 后端测试
- [ ] 编译成功（无错误）
- [ ] 材料CRUD接口正常
- [ ] 使用记录接口正常
- [ ] 库存管理正常
- [ ] 统计接口正常

### 前端测试
- [ ] 材料管理页面正常
- [ ] 添加材料使用正常
- [ ] 查看使用记录正常
- [ ] 统计信息显示正常
- [ ] 库存不足提醒正常

### 集成测试
- [ ] 创建修复记录
- [ ] 添加材料使用
- [ ] 库存自动扣减
- [ ] 删除使用记录
- [ ] 库存自动恢复
- [ ] 查看统计信息

## 相关文档

- [材料管理实现文档](REPAIR_MATERIAL_IMPLEMENTATION.md)
- [数据库迁移脚本](../sql/repair_record_material_migration.sql)
- [快速迁移脚本](../sql/repair_record_remove_materials_used.sql)
- [关联表创建脚本](../sql/repair_material_relation.sql)

## 更新日志

### 2026-04-27
- ✅ 设计多对多关联关系
- ✅ 创建repair_record_material中间表
- ✅ 删除repair_record.materials_used字段
- ✅ 更新RepairRecord实体类
- ✅ 更新RepairProgressRequest DTO
- ✅ 更新RepairRecordServiceImpl
- ✅ 创建迁移脚本
- ✅ 通过编译验证
- ✅ 编写完整文档

---

**状态**：✅ 完成  
**编译**：✅ SUCCESS  
**测试**：⏳ 待执行  
**部署**：⏳ 待执行
