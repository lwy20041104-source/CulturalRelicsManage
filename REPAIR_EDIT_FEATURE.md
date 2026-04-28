# 修复管理编辑功能实现

## 功能概述
为文物保管员添加了修改修复申请的功能，只能对**未审批**状态的申请进行修改。

## 后端实现

### 1. Controller 层
**文件**: `backend/src/main/java/com/example/controller/RepairRecordController.java`

添加了新的接口：
```java
@PutMapping("/apply/{id}")
@OperationLog(operationType = "修改", operationModule = "文物修复", operationContent = "更新修复申请")
public Result<Boolean> updateRepairApply(@PathVariable Long id,
                                         @RequestBody RepairApplyRequest request,
                                         Authentication authentication,
                                         javax.servlet.http.HttpServletRequest httpRequest)
```

**功能特性**：
- ✅ 权限检查：只能修改自己的申请
- ✅ 状态检查：只能修改待审批状态的申请
- ✅ 文物验证：如果修改了文物，验证新文物是否可用
- ✅ 审计日志：记录修改前后的数据变化

### 2. Service 层
**文件**: 
- `backend/src/main/java/com/example/service/RepairRecordService.java`
- `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java`

添加了新的方法：
```java
boolean updateRepairApply(RepairApplyRequest request);
```

**实现逻辑**：
1. 验证记录存在性
2. 检查状态是否为"待审批"
3. 如果修改了文物ID，验证新文物状态
4. 更新所有可修改字段
5. 记录操作日志

### 3. DTO 层
**文件**: `backend/src/main/java/com/example/dto/RepairApplyRequest.java`

添加了 `id` 字段：
```java
private Long id;  // 修复记录ID（更新时使用）
```

## 前端实现

### 1. API 层
**文件**: `frontend/src/api/repairs.js`

添加了新的 API 方法：
```javascript
export const updateRepairApplyApi = (id, data) => {
  return request.put(`/repairs/apply/${id}`, data)
}
```

### 2. 视图层
**文件**: `frontend/src/views/RepairsView.vue`

#### 操作列修改
```vue
<el-button v-if="scope.row.status === '待审批'" link type="primary" @click="openEdit(scope.row)">
  {{ $t('common.edit') }}
</el-button>
```

#### 新增函数

**openEdit 函数**：
- 加载修复记录的详细信息
- 加载已关联的材料列表
- 填充表单数据
- 打开编辑对话框

**submitApply 函数修改**：
- 支持新增和编辑两种模式
- 编辑模式：先删除旧材料记录，再添加新的
- 新增模式：直接添加材料记录
- 自动计算预估费用

#### 对话框标题动态化
```vue
:title="applyForm.id ? $t('common.edit') + $t('repair.title') : $t('repair.addRepair')"
```

## 功能特性

### 权限控制
- ✅ 只能编辑自己提交的申请
- ✅ 只能编辑待审批状态的申请
- ✅ 管理员可以查看所有记录，但保管员只能编辑自己的

### 数据验证
- ✅ 验证修复记录是否存在
- ✅ 验证状态是否允许修改
- ✅ 验证文物是否可用（如果修改了文物）
- ✅ 验证文物是否有其他正在进行的修复

### 材料管理
- ✅ 编辑时加载已有材料列表
- ✅ 支持添加、删除材料
- ✅ 更新时先删除旧材料记录，再添加新的
- ✅ 自动计算预估费用

### 审计日志
- ✅ 记录修改操作
- ✅ 记录修改前后的数据对比
- ✅ 记录操作人、IP地址等信息

## 操作流程

### 编辑修复申请
1. 在修复管理列表中，找到待审批状态的记录
2. 点击"编辑"按钮
3. 修改申请信息（文物、优先级、原因、材料等）
4. 点击"提交"保存修改
5. 系统验证权限和状态
6. 更新数据库记录
7. 更新材料使用记录
8. 记录审计日志

### 限制条件
- ❌ 不能编辑已审批的申请
- ❌ 不能编辑其他人的申请
- ❌ 不能修改为已有正在进行修复的文物
- ❌ 不能修改为非"在库"状态的文物

## 测试建议

### 功能测试
1. 测试编辑待审批的申请
2. 测试修改文物、优先级、原因等字段
3. 测试添加、删除材料
4. 测试预估费用自动计算

### 权限测试
1. 测试编辑自己的申请（应该成功）
2. 测试编辑他人的申请（应该失败）
3. 测试编辑已审批的申请（应该失败）

### 数据验证测试
1. 测试修改为不存在的文物（应该失败）
2. 测试修改为非"在库"状态的文物（应该失败）
3. 测试修改为已有正在进行修复的文物（应该失败）

## 国际化支持
使用现有的国际化键：
- `common.edit` - 编辑
- `repair.title` - 修复管理
- `message.updateSuccess` - 更新成功
- `message.saveSuccess` - 保存成功

## 总结
成功为文物保管员添加了修改修复申请的功能，具有完善的权限控制、数据验证和审计日志功能。用户体验良好，操作流程清晰。
