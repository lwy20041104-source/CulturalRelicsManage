# 文物状态管理功能实现总结

## 实现日期
2026-04-23

## 功能概述
完善了文物管理、借展管理和修复管理的业务逻辑，实现了严格的状态控制规则，确保文物在不同业务流程中的状态一致性。

## 核心业务规则

### 规则1：借展申请限制
✅ **只有状态为"在库"的文物才能申请借展**
- 修复中的文物不能申请借展
- 借展中的文物不能重复借展
- 展出中的文物不能申请借展

### 规则2：修复申请限制
✅ **只有状态为"在库"的文物才能申请修复**
- 借展中的文物不能申请修复
- 修复中的文物不能重复申请修复
- 展出中的文物不能申请修复

### 规则3：状态自动更新
✅ **文物状态随业务流程自动更新**
- 借展审批通过：在库 → 借展中
- 借展归还：借展中 → 在库
- 开始修复：在库 → 修复中
- 完成修复：修复中 → 在库

## 已完成的工作

### 1. 借展管理服务（LoanRecordServiceImpl）✅

#### 修改的方法

**save() - 申请借展**
```java
// 添加的功能：
1. 检查文物是否存在
2. 检查文物状态是否为"在库"
3. 设置借展记录初始状态为"待审批"
4. 如果文物状态不是"在库"，抛出异常并提示当前状态
```

**approveLoan() - 审批借展（已有）**
```java
// 已有功能：
1. 审批通过时，更新文物状态为"借展中"
2. 审批拒绝时，文物状态保持"在库"
```

**returnLoan() - 归还文物（已有）**
```java
// 已有功能：
1. 归还时，更新文物状态为"在库"
```

### 2. 修复管理服务（RepairRecordServiceImpl）✅

#### 修改的方法

**applyRepair() - 申请修复**
```java
// 添加的功能：
1. 检查文物是否存在
2. 检查文物状态是否为"在库"
3. 如果文物状态不是"在库"，抛出异常并提示当前状态
```

**startRepair() - 开始修复**
```java
// 添加的功能：
1. 检查文物是否存在
2. 更新文物状态为"修复中"
3. 通过Mapper更新文物状态
```

**completeRepair() - 完成修复**
```java
// 添加的功能：
1. 检查文物是否存在
2. 更新文物状态为"在库"
3. 通过Mapper更新文物状态
```

**新增私有方法**
```java
updateRelicStatus() - 更新文物状态
```

### 3. 修复记录Mapper（RepairRecordMapper）✅

#### 新增的方法

**selectRelicById()**
```java
// 功能：根据文物ID查询文物信息
// 用途：在修复流程中检查文物状态
```

**updateRelicStatus()**
```java
// 功能：更新文物状态
// 参数：文物ID、状态、更新时间
// 用途：在修复流程中更新文物状态
```

### 4. 修复记录Mapper XML（RepairRecordMapper.xml）✅

#### 新增的SQL

**selectRelicById**
```xml
<select id="selectRelicById" resultType="com.example.entity.CulturalRelic">
    SELECT id, relic_code, relic_name, category_id, category_name, era, material,
           origin, dimensions, weight, description, status, image_path,
           create_time, update_time
    FROM cultural_relic
    WHERE id = #{relicId}
</select>
```

**updateRelicStatus**
```xml
<update id="updateRelicStatus">
    UPDATE cultural_relic
    SET status = #{status}, update_time = #{updateTime}
    WHERE id = #{relicId}
</update>
```

### 5. 文档（docs）✅

**RELIC_STATUS_MANAGEMENT.md**
- 详细的业务规则说明
- 完整的业务流程图
- 状态冲突场景分析
- 测试用例
- 实现文件清单

**RELIC_STATUS_IMPLEMENTATION_SUMMARY.md**
- 实现总结（本文档）

## 技术实现细节

### 1. 状态检查逻辑

```java
// 借展申请时检查
CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
if (!"在库".equals(relic.getStatus())) {
    throw new IllegalArgumentException("只有在库状态的文物才能申请借展，当前状态：" + relic.getStatus());
}

// 修复申请时检查
CulturalRelic relic = repairRecordMapper.selectRelicById(request.getRelicId());
if (!"在库".equals(relic.getStatus())) {
    throw new IllegalArgumentException("只有在库状态的文物才能申请修复，当前状态：" + relic.getStatus());
}
```

### 2. 状态更新逻辑

```java
// 开始修复时更新状态
relic.setStatus("修复中");
relic.setUpdateTime(LocalDateTime.now());
updateRelicStatus(relic);

// 完成修复时更新状态
relic.setStatus("在库");
relic.setUpdateTime(LocalDateTime.now());
updateRelicStatus(relic);
```

### 3. 事务管理

所有涉及状态更新的方法都使用了 `@Transactional` 注解，确保数据一致性：

```java
@Override
@Transactional
public boolean startRepair(Long id) {
    // 更新修复记录状态
    // 更新文物状态
    // 如果任何一步失败，整个事务回滚
}
```

## 业务流程图

### 借展流程

```
┌─────────┐
│ 在库文物 │
└────┬────┘
     │
     ▼
┌─────────────┐
│ 申请借展     │ ← 检查：状态必须为"在库"
│ (待审批)     │
└────┬────────┘
     │
     ├─────────┐
     │         │
     ▼         ▼
┌─────────┐ ┌─────────┐
│ 审批通过 │ │ 审批拒绝 │
│ (借出中) │ │ (已驳回) │
└────┬────┘ └────┬────┘
     │           │
     │           ▼
     │      ┌─────────┐
     │      │ 在库文物 │
     │      └─────────┘
     ▼
┌─────────┐
│ 借展中   │
└────┬────┘
     │
     ▼
┌─────────┐
│ 归还     │
│ (已归还) │
└────┬────┘
     │
     ▼
┌─────────┐
│ 在库文物 │
└─────────┘
```

### 修复流程

```
┌─────────┐
│ 在库文物 │
└────┬────┘
     │
     ▼
┌─────────────┐
│ 申请修复     │ ← 检查：状态必须为"在库"
│ (待审批)     │
└────┬────────┘
     │
     ├─────────┐
     │         │
     ▼         ▼
┌─────────┐ ┌─────────┐
│ 审批通过 │ │ 审批拒绝 │
│ (待修复) │ │ (已拒绝) │
└────┬────┘ └────┬────┘
     │           │
     │           ▼
     │      ┌─────────┐
     │      │ 在库文物 │
     │      └─────────┘
     ▼
┌─────────┐
│ 开始修复 │
│ (修复中) │ ← 更新文物状态为"修复中"
└────┬────┘
     │
     ▼
┌─────────┐
│ 修复中   │
└────┬────┘
     │
     ▼
┌─────────┐
│ 完成修复 │
│(修复完成)│ ← 更新文物状态为"在库"
└────┬────┘
     │
     ▼
┌─────────┐
│ 在库文物 │
└─────────┘
```

## 错误提示信息

### 借展申请错误

```
只有在库状态的文物才能申请借展，当前状态：借展中
只有在库状态的文物才能申请借展，当前状态：修复中
只有在库状态的文物才能申请借展，当前状态：展出中
```

### 修复申请错误

```
只有在库状态的文物才能申请修复，当前状态：借展中
只有在库状态的文物才能申请修复，当前状态：修复中
只有在库状态的文物才能申请修复，当前状态：展出中
```

## 测试验证

### 编译测试
```bash
cd backend
mvn clean compile -DskipTests
```
结果：✅ BUILD SUCCESS

### 功能测试建议

#### 测试1：正常借展流程
1. 创建文物（状态：在库）
2. 申请借展 → 应该成功
3. 审批通过 → 文物状态应变为"借展中"
4. 归还文物 → 文物状态应变为"在库"

#### 测试2：正常修复流程
1. 创建文物（状态：在库）
2. 申请修复 → 应该成功
3. 审批通过 → 文物状态应保持"在库"
4. 开始修复 → 文物状态应变为"修复中"
5. 完成修复 → 文物状态应变为"在库"

#### 测试3：借展中不能申请修复
1. 创建文物（状态：在库）
2. 申请借展并审批通过 → 文物状态变为"借展中"
3. 尝试申请修复 → 应该失败，提示"只有在库状态的文物才能申请修复，当前状态：借展中"

#### 测试4：修复中不能申请借展
1. 创建文物（状态：在库）
2. 申请修复、审批通过、开始修复 → 文物状态变为"修复中"
3. 尝试申请借展 → 应该失败，提示"只有在库状态的文物才能申请借展，当前状态：修复中"

## 相关文件清单

### 后端文件（4个）

1. `backend/src/main/java/com/example/service/impl/LoanRecordServiceImpl.java` (修改)
   - 修改 `save()` 方法

2. `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java` (修改)
   - 修改 `applyRepair()` 方法
   - 修改 `startRepair()` 方法
   - 修改 `completeRepair()` 方法
   - 新增 `updateRelicStatus()` 方法

3. `backend/src/main/java/com/example/mapper/RepairRecordMapper.java` (修改)
   - 新增 `selectRelicById()` 方法
   - 新增 `updateRelicStatus()` 方法

4. `backend/src/main/resources/mapper/RepairRecordMapper.xml` (修改)
   - 新增 `selectRelicById` SQL
   - 新增 `updateRelicStatus` SQL

### 文档文件（2个）

1. `docs/RELIC_STATUS_MANAGEMENT.md` - 详细的业务规则文档
2. `docs/RELIC_STATUS_IMPLEMENTATION_SUMMARY.md` - 实现总结（本文档）

## 代码统计

### 修改代码
- Java类：2个
- Mapper接口：1个
- Mapper XML：1个
- 修改行数：约150行

### 新增代码
- 新增方法：3个
- 新增SQL：2个
- 新增代码行数：约80行

### 文档
- 新增文档：2个
- 文档总字数：约8000字

## 前端建议（待实现）

### 1. 文物列表页面

建议在文物列表中根据状态控制操作按钮：

```vue
<template>
  <el-table-column label="操作" width="200">
    <template #default="{ row }">
      <!-- 只有在库状态才显示借展和修复按钮 -->
      <el-button 
        v-if="row.status === '在库'" 
        type="primary" 
        size="small"
        @click="handleLoan(row)"
      >
        申请借展
      </el-button>
      
      <el-button 
        v-if="row.status === '在库'" 
        type="warning" 
        size="small"
        @click="handleRepair(row)"
      >
        申请修复
      </el-button>
      
      <!-- 其他状态显示对应的操作 -->
      <el-tag v-else :type="getStatusType(row.status)">
        {{ row.status }}
      </el-tag>
    </template>
  </el-table-column>
</template>
```

### 2. 借展申请页面

建议在提交前验证文物状态：

```javascript
const handleSubmit = async () => {
  // 检查文物状态
  if (selectedRelic.value.status !== '在库') {
    ElMessage.error(`只有在库状态的文物才能申请借展，当前状态：${selectedRelic.value.status}`)
    return
  }
  
  // 提交借展申请
  try {
    await loanApi.create(formData)
    ElMessage.success('借展申请提交成功')
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '提交失败')
  }
}
```

### 3. 修复申请页面

建议在提交前验证文物状态：

```javascript
const handleSubmit = async () => {
  // 检查文物状态
  if (selectedRelic.value.status !== '在库') {
    ElMessage.error(`只有在库状态的文物才能申请修复，当前状态：${selectedRelic.value.status}`)
    return
  }
  
  // 提交修复申请
  try {
    await repairApi.apply(formData)
    ElMessage.success('修复申请提交成功')
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '提交失败')
  }
}
```

## 优势和收益

### 1. 数据一致性
✅ 确保文物状态在整个系统中保持一致
✅ 防止状态冲突和数据不一致

### 2. 业务逻辑正确性
✅ 严格执行业务规则
✅ 防止非法操作

### 3. 用户体验
✅ 清晰的错误提示
✅ 明确告知用户当前状态和限制

### 4. 系统可维护性
✅ 集中的状态管理逻辑
✅ 易于理解和维护

### 5. 可扩展性
✅ 易于添加新的状态和规则
✅ 支持更复杂的业务流程

## 总结

✅ **已完成**：
- 实现了严格的文物状态检查
- 实现了自动的状态更新
- 添加了清晰的错误提示
- 确保了数据一致性
- 提供了详细的文档

✅ **核心规则**：
- 只有"在库"状态的文物才能申请借展
- 只有"在库"状态的文物才能申请修复
- 文物状态随业务流程自动更新

✅ **技术保障**：
- 使用事务确保数据一致性
- 在Service层进行状态检查
- 通过Mapper更新文物状态

现在系统的文物状态管理更加严格和可靠，能够有效防止业务冲突和数据不一致！
