# 修复材料管理功能实现文档

## 概述
本文档记录了文物管理系统的修复材料管理功能的完整实现过程。

## 实现状态
✅ **已完成** - 所有功能已实现并通过编译验证

编译时间：2026-04-27 21:38:57
编译状态：BUILD SUCCESS
编译文件：172个源文件

## 功能特性

### 1. 材料管理
- ✅ 材料列表查询（分页、搜索、筛选）
- ✅ 材料创建（编号、名称、类别、单价、库存等）
- ✅ 材料编辑
- ✅ 材料删除（检查是否被使用）
- ✅ 库存管理（增加/减少库存）
- ✅ 库存不足提醒
- ✅ 材料类别管理

### 2. 材料使用记录
- ✅ 关联修复记录与材料
- ✅ 记录使用数量和价格
- ✅ 自动扣减库存
- ✅ 删除使用记录时恢复库存

### 3. 统计分析
- ✅ 材料使用总量统计
- ✅ 材料使用总金额统计
- ✅ 材料使用次数统计
- ✅ 使用记录查询

## 技术架构

### 后端实现

#### 1. 数据库表结构

**repair_material（材料表）**
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
)
```

**repair_record_material（关联表）**
```sql
CREATE TABLE repair_record_material (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    repair_record_id BIGINT NOT NULL,
    material_id BIGINT NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    remark VARCHAR(500),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (repair_record_id) REFERENCES repair_record(id) ON DELETE CASCADE,
    FOREIGN KEY (material_id) REFERENCES repair_material(id) ON DELETE RESTRICT
)
```

#### 2. 核心类文件

**实体类（2个）**
- `RepairMaterial.java` - 材料实体
- `RepairRecordMaterial.java` - 材料使用记录实体

**Mapper接口（2个）**
- `RepairMaterialMapper.java` - 材料数据访问层
  - 分页查询、条件搜索
  - CRUD操作
  - 库存更新
  - 类别查询
  - 库存不足查询
  
- `RepairRecordMaterialMapper.java` - 使用记录数据访问层
  - 根据修复记录查询材料
  - 根据材料查询使用记录
  - 统计使用量和金额

**服务层（1个）**
- `RepairMaterialService.java` - 业务逻辑层
  - 材料管理（CRUD）
  - 库存管理（增减、检查）
  - 使用记录管理
  - 统计分析

**控制器（1个）**
- `RepairMaterialController.java` - RESTful API
  - 14个接口端点
  - 权限控制
  - 操作日志

#### 3. API接口列表

| 方法 | 路径 | 说明 | 权限 |
|------|------|------|------|
| GET | /repair-materials | 分页查询材料列表 | ADMIN, CURATOR, REPAIR_EXPERT |
| GET | /repair-materials/all | 获取所有材料 | ADMIN, CURATOR, REPAIR_EXPERT |
| GET | /repair-materials/{id} | 根据ID查询材料 | ADMIN, CURATOR, REPAIR_EXPERT |
| POST | /repair-materials | 创建材料 | ADMIN, CURATOR |
| PUT | /repair-materials/{id} | 更新材料 | ADMIN, CURATOR |
| DELETE | /repair-materials/{id} | 删除材料 | ADMIN |
| PUT | /repair-materials/{id}/stock | 更新库存 | ADMIN, CURATOR |
| GET | /repair-materials/categories | 获取类别列表 | ADMIN, CURATOR, REPAIR_EXPERT |
| GET | /repair-materials/low-stock | 获取库存不足材料 | ADMIN, CURATOR |
| GET | /repair-materials/{id}/statistics | 获取材料统计 | ADMIN, CURATOR |
| POST | /repair-materials/usage | 添加使用记录 | ADMIN, CURATOR, REPAIR_EXPERT |
| GET | /repair-materials/repair-record/{id} | 获取修复记录材料 | ADMIN, CURATOR, REPAIR_EXPERT |
| DELETE | /repair-materials/usage/{id} | 删除使用记录 | ADMIN, CURATOR |

### 前端实现

#### 1. 视图组件
- `RepairMaterialsView.vue` - 材料管理主界面
  - 材料列表展示（表格）
  - 搜索和筛选
  - 创建/编辑对话框
  - 库存更新对话框
  - 统计信息对话框
  - 库存不足提醒对话框
  - 分页控件

#### 2. API接口封装
- `repairMaterial.js` - 前端API封装
  - 13个API方法
  - 统一错误处理

#### 3. 路由配置
```javascript
{
  path: '/repair-materials',
  component: RepairMaterialsView,
  meta: { perm: 'repairs:manage' }
}
```

#### 4. 菜单配置
- 位置：修复管理模块下
- 权限：repairs:manage
- 中英文支持

#### 5. 国际化支持
- 中文翻译（zh-CN.js）
- 英文翻译（en-US.js）
- 21个翻译键

## 业务逻辑

### 1. 材料创建
1. 验证材料编号唯一性
2. 设置默认库存为0
3. 记录创建时间

### 2. 材料更新
1. 检查材料是否存在
2. 验证编号唯一性（排除自己）
3. 更新材料信息

### 3. 材料删除
1. 检查是否有使用记录
2. 如有使用记录则禁止删除
3. 删除材料数据

### 4. 库存更新
1. 检查材料是否存在
2. 如果是减少库存，检查库存是否足够
3. 更新库存数量

### 5. 添加使用记录
1. 检查材料是否存在
2. 检查库存是否足够
3. 计算总价（数量 × 单价）
4. 插入使用记录
5. 自动扣减库存

### 6. 删除使用记录
1. 查询使用记录
2. 恢复库存（增加使用的数量）
3. 删除记录

## 部署步骤

### 1. 执行数据库脚本
```bash
# 创建关联表
mysql -u root -p cultural_relics < backend/sql/repair_material_relation.sql
```

### 2. 重启后端服务
```bash
cd backend
mvn spring-boot:run
```

### 3. 访问前端
```
http://localhost:5173/repair-materials
```

## 测试数据

### 材料数据（6条）
1. 环氧树脂 - MAT001 - 粘合剂 - 50kg库存
2. 化学试剂A - MAT002 - 清洁剂 - 30L库存
3. 保护镀层材料 - MAT003 - 保护剂 - 20kg库存
4. 宣纸 - MAT004 - 纸质材料 - 100张库存
5. 丝绸 - MAT005 - 纺织材料 - 50m库存
6. 石材修复剂 - MAT006 - 修复剂 - 40kg库存

### 使用记录（6条）
- 修复记录1使用了环氧树脂和宣纸
- 修复记录2使用了化学试剂A和保护镀层材料
- 修复记录3使用了丝绸
- 修复记录4使用了石材修复剂

## 功能演示

### 1. 查看材料列表
1. 登录系统（管理员/馆长/修复专家）
2. 点击"修复材料"菜单
3. 查看材料列表

### 2. 创建材料
1. 点击"添加"按钮
2. 填写材料信息
3. 点击"确定"保存

### 3. 更新库存
1. 点击材料的"更新库存"按钮
2. 输入变更数量（正数增加，负数减少）
3. 点击"确定"

### 4. 查看统计
1. 点击材料的"统计"按钮
2. 查看使用总量、总金额、使用次数

### 5. 库存不足提醒
1. 点击"库存不足"按钮
2. 查看库存低于10的材料列表

### 6. 搜索和筛选
1. 输入材料名称搜索
2. 选择材料类别筛选
3. 点击"搜索"按钮

## 权限设计

### 管理员（ADMIN）
- 所有操作权限
- 包括删除材料

### 馆长（CURATOR）
- 创建、编辑材料
- 更新库存
- 查看统计
- 添加/删除使用记录

### 修复专家（REPAIR_EXPERT）
- 查看材料列表
- 添加使用记录
- 查看统计

## 安全特性

### 1. 数据完整性
- 外键约束保证数据一致性
- 删除修复记录时级联删除使用记录
- 删除材料时限制（如有使用记录）

### 2. 库存控制
- 使用材料时检查库存
- 库存不足时禁止使用
- 删除使用记录时恢复库存

### 3. 权限控制
- 基于角色的访问控制
- 操作日志记录
- 敏感操作需要高权限

## 后续优化建议

### 短期优化（P1）
- [ ] 材料批量导入
- [ ] 材料使用历史图表
- [ ] 库存预警通知
- [ ] 材料采购建议

### 中期优化（P2）
- [ ] 材料成本分析
- [ ] 供应商管理
- [ ] 采购订单管理
- [ ] 材料有效期管理

### 长期优化（P3）
- [ ] 材料使用预测
- [ ] 智能库存优化
- [ ] 供应链集成
- [ ] 移动端支持

## 相关文档
- [数据库脚本](../sql/repair_material_relation.sql)
- [API接口文档](../README.md)

## 更新日志

### 2026-04-27
- ✅ 完成数据库表设计
- ✅ 完成后端实体类、Mapper、Service、Controller
- ✅ 完成前端视图组件和API
- ✅ 完成路由和菜单配置
- ✅ 完成中英文国际化
- ✅ 通过编译验证
- ✅ 编写完整文档

## 文件清单

### 后端文件（6个）
- backend/src/main/java/com/example/entity/RepairMaterial.java
- backend/src/main/java/com/example/entity/RepairRecordMaterial.java
- backend/src/main/java/com/example/mapper/RepairMaterialMapper.java
- backend/src/main/java/com/example/mapper/RepairRecordMaterialMapper.java
- backend/src/main/java/com/example/service/RepairMaterialService.java
- backend/src/main/java/com/example/controller/RepairMaterialController.java

### 前端文件（2个）
- frontend/src/views/RepairMaterialsView.vue
- frontend/src/api/repairMaterial.js

### 数据库脚本（1个）
- backend/sql/repair_material_relation.sql

### 配置文件（3个）
- frontend/src/router/index.js（路由配置）
- frontend/src/views/LayoutView.vue（菜单配置）
- frontend/src/i18n/locales/zh-CN.js（中文翻译）
- frontend/src/i18n/locales/en-US.js（英文翻译）

### 文档文件（1个）
- backend/docs/REPAIR_MATERIAL_IMPLEMENTATION.md

## 总结

修复材料管理功能已完整实现，包括：
- ✅ 14个API接口
- ✅ 6个Java类文件
- ✅ 1个前端视图组件
- ✅ 1个API封装文件
- ✅ 完整的国际化支持
- ✅ 详细的文档说明
- ✅ 通过编译验证

系统已准备好进行功能测试和部署。

---

**状态**：✅ 完成  
**编译**：✅ SUCCESS  
**文档**：✅ 完整  
**测试**：⏳ 待执行  
**部署**：⏳ 待执行
