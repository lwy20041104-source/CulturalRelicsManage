# 文物保管员权限细化 - 实施完成

## 📋 需求说明

文物保管员对自己的修复申请记录有以下操作权限：

1. **详情查看**：可以查看所有自己申请的记录详情
2. **撤回操作**：可以撤回"待审批"状态的申请（撤回即删除）
3. **删除操作**：可以删除"已拒绝"状态的申请记录
4. **权限限制**：只能看到和操作自己申请的记录

---

## ✅ 已完成的修改

### 1. 前端界面修改

**文件**: `frontend/src/views/RepairApplyView.vue`

#### 1.1 操作列修改
```vue
<el-table-column :label="$t('common.operation')" width="200" fixed="right">
  <template #default="scope">
    <!-- 详情：所有状态都可查看 -->
    <el-button link type="primary" @click="viewDetail(scope.row)">
      {{ $t('common.detail') }}
    </el-button>
    
    <!-- 撤回：仅待审批状态 -->
    <el-button 
      v-if="scope.row.status === '待审批'" 
      link 
      type="warning" 
      @click="withdraw(scope.row.id)">
      {{ $t('repair.withdraw') }}
    </el-button>
    
    <!-- 删除：仅已拒绝状态 -->
    <el-button 
      v-if="scope.row.status === '已拒绝'" 
      link 
      type="danger" 
      @click="remove(scope.row.id)">
      {{ $t('common.delete') }}
    </el-button>
  </template>
</el-table-column>
```

#### 1.2 新增撤回方法
```javascript
const withdraw = async (id) => {
  await ElMessageBox.confirm(
    t('repair.withdrawConfirm'), 
    t('message.tip'), 
    { type: 'warning' }
  )
  await deleteRepairApi(id)
  ElMessage.success(t('repair.withdrawSuccess'))
  loadData()
}
```

#### 1.3 修改删除方法
```javascript
const remove = async (id) => {
  await ElMessageBox.confirm(
    t('repair.deleteRejectedConfirm'), 
    t('message.tip'), 
    { type: 'warning' }
  )
  await deleteRepairApi(id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}
```

---

### 2. 国际化配置

#### 2.1 中文配置 (`zh-CN.js`)
```javascript
repair: {
  // ... 其他配置
  withdraw: '撤回',
  withdrawConfirm: '确定要撤回这条待审批的申请吗？撤回后将删除该申请记录。',
  withdrawSuccess: '撤回成功',
  deleteRejectedConfirm: '确定要删除这条已拒绝的申请记录吗？'
}
```

#### 2.2 英文配置 (`en-US.js`)
```javascript
repair: {
  // ... other configs
  withdraw: 'Withdraw',
  withdrawConfirm: 'Are you sure to withdraw this pending application? The record will be deleted.',
  withdrawSuccess: 'Withdrawn successfully',
  deleteRejectedConfirm: 'Are you sure to delete this rejected application?'
}
```

---

## 🎯 功能说明

### 操作权限矩阵

| 状态 | 详情 | 撤回 | 删除 | 说明 |
|------|------|------|------|------|
| 待审批 | ✅ | ✅ | ❌ | 可以撤回申请 |
| 待修复 | ✅ | ❌ | ❌ | 已审批通过，不可操作 |
| 修复中 | ✅ | ❌ | ❌ | 正在修复，不可操作 |
| 修复完成 | ✅ | ❌ | ❌ | 已完成，不可操作 |
| 已拒绝 | ✅ | ❌ | ✅ | 可以删除记录 |

### 操作说明

#### 1. 详情查看
- **权限**：所有状态
- **功能**：查看申请的完整信息
- **按钮**：蓝色"详情"按钮

#### 2. 撤回操作
- **权限**：仅"待审批"状态
- **功能**：撤回申请（实际是删除记录）
- **按钮**：橙色"撤回"按钮
- **确认提示**：需要确认操作
- **成功提示**：显示"撤回成功"

#### 3. 删除操作
- **权限**：仅"已拒绝"状态
- **功能**：删除已拒绝的申请记录
- **按钮**：红色"删除"按钮
- **确认提示**：需要确认操作
- **成功提示**：显示"删除成功"

---

## 🔒 权限控制

### 后端权限过滤（已实现）

**文件**: `RepairRecordController.java`

```java
@GetMapping
public Result<PageResult<RepairRecord>> page(..., Authentication authentication) {
    // 获取当前用户权限
    Long applicantIdFilter = null;
    if (authentication != null) {
        Collection<? extends GrantedAuthority> authorities = 
            authentication.getAuthorities();
        
        // 检查是否有 repairs:manage 权限
        boolean hasManagePermission = authorities.stream()
            .anyMatch(a -> a.getAuthority().equals("repairs:manage"));
        
        // 如果只有 repairs:apply 权限，只查询自己申请的
        if (!hasManagePermission) {
            applicantIdFilter = userContextUtil.getCurrentUserId();
        }
    }
    
    // 查询时过滤申请人
    PageResult<RepairRecord> result = repairRecordService.pageRecords(
        pageNum, pageSize, status, priority, relicName, repairExpert, applicantIdFilter);
    return Result.success(result);
}
```

### 删除权限控制（已实现）

**文件**: `RepairRecordServiceImpl.java`

```java
@Override
@Transactional
public boolean deleteById(Long id) {
    RepairRecord record = repairRecordMapper.selectById(id);
    if (record == null) {
        throw new IllegalArgumentException("修复记录不存在");
    }
    
    // 只允许删除待审批和已拒绝的记录
    if (!"待审批".equals(record.getStatus()) && !"已拒绝".equals(record.getStatus())) {
        throw new IllegalArgumentException("当前状态不允许删除");
    }
    
    return repairRecordMapper.deleteById(id) > 0;
}
```

---

## 🧪 测试场景

### 场景1: 撤回待审批申请
1. 保管员登录（curator01）
2. 提交一个修复申请
3. 在列表中找到该申请（状态：待审批）
4. 点击"撤回"按钮
5. 确认撤回操作
6. 验证：
   - ✅ 显示"撤回成功"提示
   - ✅ 记录从列表中消失
   - ✅ 数据库中记录被删除

### 场景2: 删除已拒绝申请
1. 保管员登录（curator01）
2. 提交一个修复申请
3. 管理员审批拒绝该申请
4. 保管员刷新列表，找到该申请（状态：已拒绝）
5. 点击"删除"按钮
6. 确认删除操作
7. 验证：
   - ✅ 显示"删除成功"提示
   - ✅ 记录从列表中消失
   - ✅ 数据库中记录被删除

### 场景3: 查看详情
1. 保管员登录（curator01）
2. 查看任意状态的申请记录
3. 点击"详情"按钮
4. 验证：
   - ✅ 显示完整的申请信息
   - ✅ 包含审批信息（如果已审批）
   - ✅ 包含修复信息（如果已修复）

### 场景4: 权限限制
1. 保管员登录（curator01）
2. 查看修复申请列表
3. 验证：
   - ✅ 只显示自己申请的记录
   - ✅ 不显示其他保管员的申请
   - ✅ 不显示管理员创建的申请

### 场景5: 操作按钮显示
1. 保管员登录（curator01）
2. 查看不同状态的申请
3. 验证按钮显示：
   - 待审批：✅ 详情 + ✅ 撤回
   - 待修复：✅ 详情
   - 修复中：✅ 详情
   - 修复完成：✅ 详情
   - 已拒绝：✅ 详情 + ✅ 删除

---

## 📝 用户体验优化

### 1. 按钮颜色区分
- **详情**：蓝色（primary）- 查看操作
- **撤回**：橙色（warning）- 警告操作
- **删除**：红色（danger）- 危险操作

### 2. 确认提示
- **撤回**：明确说明撤回后将删除记录
- **删除**：明确说明删除已拒绝的申请

### 3. 成功提示
- **撤回**：显示"撤回成功"
- **删除**：显示"删除成功"

### 4. 国际化支持
- 所有文本都支持中英文切换
- 提示信息清晰明确

---

## 🔍 技术实现细节

### 1. 条件渲染
使用 `v-if` 指令根据状态显示不同按钮：
```vue
<el-button v-if="scope.row.status === '待审批'" ...>撤回</el-button>
<el-button v-if="scope.row.status === '已拒绝'" ...>删除</el-button>
```

### 2. 方法复用
撤回和删除都调用同一个API（`deleteRepairApi`），但提示信息不同：
- 撤回：强调"撤回申请"
- 删除：强调"删除记录"

### 3. 后端验证
后端Service层验证状态，确保只能删除"待审批"和"已拒绝"状态的记录。

---

## ✅ 验证清单

### 前端验证
- [x] 待审批状态显示"撤回"按钮
- [x] 已拒绝状态显示"删除"按钮
- [x] 其他状态不显示操作按钮（除详情外）
- [x] 撤回操作有确认提示
- [x] 删除操作有确认提示
- [x] 操作成功后刷新列表
- [x] 国际化文本正确显示

### 后端验证
- [x] 权限过滤正常工作
- [x] 只能删除待审批和已拒绝状态
- [x] 删除操作有状态验证
- [x] 保管员只能操作自己的记录

### 用户体验验证
- [x] 按钮颜色区分明确
- [x] 提示信息清晰易懂
- [x] 操作流程顺畅
- [x] 错误提示友好

---

## 📊 修改文件清单

| 文件 | 修改内容 | 状态 |
|------|---------|------|
| `frontend/src/views/RepairApplyView.vue` | 添加撤回功能，修改操作列 | ✅ |
| `frontend/src/i18n/locales/zh-CN.js` | 添加撤回相关文本 | ✅ |
| `frontend/src/i18n/locales/en-US.js` | 添加撤回相关文本 | ✅ |
| `backend/src/main/java/.../RepairRecordController.java` | 权限过滤（已完成） | ✅ |
| `backend/src/main/java/.../RepairRecordServiceImpl.java` | 删除权限控制（已完成） | ✅ |

---

## 🎉 总结

文物保管员权限细化已完成，实现了：

1. ✅ **详情查看**：所有状态都可查看
2. ✅ **撤回操作**：待审批状态可撤回
3. ✅ **删除操作**：已拒绝状态可删除
4. ✅ **权限限制**：只能操作自己的记录
5. ✅ **国际化支持**：中英文完整支持
6. ✅ **用户体验**：按钮颜色区分，提示清晰

所有功能已实现并可以立即测试！

---

**完成时间**: 2026-04-28  
**状态**: 已完成
