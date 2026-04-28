# 修复申请编辑 MyBatis 错误修复

## 错误信息

```
org.apache.ibatis.reflection.ReflectionException: 
There is no getter for property named 'materialsUsed' in 'class com.example.entity.RepairRecord'
```

## 问题分析

### 错误原因
MyBatis 在执行 `updateById` 操作时，尝试访问 `RepairRecord` 实体类中的 `materialsUsed` 属性，但该属性不存在。

### 根本原因
1. **数据库设计变更**：使用材料信息已从 `repair_record` 表的 `materials_used` 字段迁移到独立的关联表 `repair_record_material`
2. **实体类已更新**：`RepairRecord` 实体类中已删除 `materialsUsed` 字段
3. **Mapper XML 未同步**：`RepairRecordMapper.xml` 中仍然引用了已删除的字段

### 代码证据

**实体类注释**（RepairRecord.java）：
```java
// 修复信息
private String repairExpert;            // 修复专家
private LocalDateTime startDate;        // 开始修复日期
private LocalDateTime completeDate;     // 完成日期
private String repairProcess;           // 修复过程
private String repairMethod;            // 修复方法
// 注意：使用材料信息已移至repair_record_material关联表
private BigDecimal actualCost;          // 实际费用
```

**Mapper XML 问题**（RepairRecordMapper.xml）：
```xml
<!-- ResultMap 中的错误映射 -->
<result column="materials_used" property="materialsUsed"/>

<!-- updateById 中的错误引用 -->
<if test="materialsUsed != null">materials_used = #{materialsUsed},</if>
```

## 解决方案

### 修改文件
`backend/src/main/resources/mapper/RepairRecordMapper.xml`

### 修改内容

#### 1. 删除 ResultMap 中的 materialsUsed 映射

**修改前**：
```xml
<resultMap id="BaseResultMap" type="com.example.entity.RepairRecord">
    ...
    <result column="repair_process" property="repairProcess"/>
    <result column="repair_method" property="repairMethod"/>
    <result column="materials_used" property="materialsUsed"/>  <!-- 删除此行 -->
    <result column="actual_cost" property="actualCost"/>
    ...
</resultMap>
```

**修改后**：
```xml
<resultMap id="BaseResultMap" type="com.example.entity.RepairRecord">
    ...
    <result column="repair_process" property="repairProcess"/>
    <result column="repair_method" property="repairMethod"/>
    <result column="actual_cost" property="actualCost"/>
    ...
</resultMap>
```

#### 2. 删除 updateById 中的 materialsUsed 更新

**修改前**：
```xml
<update id="updateById">
    UPDATE repair_record
    <set>
        ...
        <if test="repairProcess != null">repair_process = #{repairProcess},</if>
        <if test="repairMethod != null">repair_method = #{repairMethod},</if>
        <if test="materialsUsed != null">materials_used = #{materialsUsed},</if>  <!-- 删除此行 -->
        <if test="actualCost != null">actual_cost = #{actualCost},</if>
        ...
    </set>
    WHERE id = #{id}
</update>
```

**修改后**：
```xml
<update id="updateById">
    UPDATE repair_record
    <set>
        <if test="relicId != null">relic_id = #{relicId},</if>
        <if test="status != null">status = #{status},</if>
        <if test="priority != null">priority = #{priority},</if>
        <if test="repairReason != null">repair_reason = #{repairReason},</if>
        <if test="damageDescription != null">damage_description = #{damageDescription},</if>
        <if test="estimatedCost != null">estimated_cost = #{estimatedCost},</if>
        <if test="approver != null">approver = #{approver},</if>
        <if test="approveDate != null">approve_date = #{approveDate},</if>
        <if test="approveRemark != null">approve_remark = #{approveRemark},</if>
        <if test="repairExpert != null">repair_expert = #{repairExpert},</if>
        <if test="startDate != null">start_date = #{startDate},</if>
        <if test="completeDate != null">complete_date = #{completeDate},</if>
        <if test="repairProcess != null">repair_process = #{repairProcess},</if>
        <if test="repairMethod != null">repair_method = #{repairMethod},</if>
        <if test="actualCost != null">actual_cost = #{actualCost},</if>
        <if test="beforeImages != null">before_images = #{beforeImages},</if>
        <if test="afterImages != null">after_images = #{afterImages},</if>
        <if test="qualityScore != null">quality_score = #{qualityScore},</if>
        <if test="qualityRemark != null">quality_remark = #{qualityRemark},</if>
        <if test="remark != null">remark = #{remark},</if>
        update_time = NOW()
    </set>
    WHERE id = #{id}
</update>
```

#### 3. 额外改进

在 `updateById` 语句中：
- ✅ 添加了 `relicId` 的更新支持（支持修改文物）
- ✅ 添加了 `repairReason`、`damageDescription`、`estimatedCost` 的更新支持（支持修改申请信息）
- ✅ 添加了 `update_time = NOW()` 自动更新时间戳

## 材料管理的正确方式

### 数据库设计
使用材料信息现在存储在独立的关联表中：

**表结构**：`repair_record_material`
- `id` - 主键
- `repair_record_id` - 修复记录ID（外键）
- `material_id` - 材料ID（外键）
- `quantity` - 使用数量
- `unit_price` - 单价
- `total_price` - 总价
- `remark` - 备注

### API 接口
- `GET /api/repair-material/repair-record/{repairRecordId}` - 查询修复记录的材料列表
- `POST /api/repair-material/usage` - 添加材料使用记录
- `DELETE /api/repair-material/usage/{id}` - 删除材料使用记录

### 前端处理
在编辑修复申请时：
1. 加载修复记录的基本信息
2. 单独加载材料使用列表
3. 更新时先删除旧的材料记录，再添加新的

## 测试验证

### 测试步骤
1. 启动后端服务
2. 以保管员身份登录
3. 创建一个修复申请（包含材料）
4. 点击"编辑"按钮
5. 修改申请信息（文物、原因、材料等）
6. 提交修改
7. 验证更新成功

### 预期结果
- ✅ 不再出现 `materialsUsed` 相关的 MyBatis 错误
- ✅ 修复申请更新成功
- ✅ 材料列表正确更新
- ✅ 通知发送给管理员

## 相关文件

### 修改的文件
- `backend/src/main/resources/mapper/RepairRecordMapper.xml`

### 相关文件（未修改）
- `backend/src/main/java/com/example/entity/RepairRecord.java` - 实体类（已正确）
- `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java` - Service 实现
- `backend/src/main/java/com/example/controller/RepairRecordController.java` - Controller

## 总结

这是一个典型的数据库重构后 Mapper XML 未同步更新的问题。通过删除 Mapper XML 中对已废弃字段的引用，并添加对新字段的支持，成功解决了编辑修复申请时的 MyBatis 错误。

### 关键要点
1. 实体类、Mapper XML 和数据库表结构必须保持一致
2. 数据库重构后要同步更新所有相关的 Mapper XML
3. 使用独立的关联表管理多对多关系（如材料使用）比在主表中存储更灵活
4. 更新操作应该自动更新 `update_time` 字段

### 改进建议
- 在数据库重构时，建立检查清单确保所有相关文件都已更新
- 使用 MyBatis Generator 自动生成 Mapper XML 可以减少此类错误
- 添加单元测试覆盖所有 CRUD 操作
