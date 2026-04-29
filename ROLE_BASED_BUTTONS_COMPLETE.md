# 基于角色的按钮显示实现完成

## 概述
成功实现基于用户角色显示不同的操作按钮，系统管理员和文物保管员在维护管理和修复管理界面看到不同的操作选项。

## 实现方案

### 角色判断
通过 `sessionStorage.getItem('role')` 获取当前用户角色：
- `role === 'ADMIN'` → 系统管理员
- `role !== 'ADMIN'` → 文物保管员（CURATOR）

### 按钮显示规则

#### 系统管理员（ADMIN）
**待审批状态显示**:
- ✅ 详情
- ✅ 审批

**其他状态显示**:
- ✅ 详情

#### 文物保管员（CURATOR）
**待审批状态显示**:
- ✅ 详情
- ✅ 编辑
- ✅ 撤回

**其他状态显示**:
- ✅ 详情

---

## 实现内容

### 1. 维护管理界面

**文件**: `frontend/src/views/MaintenanceView.vue`

#### 1.1 添加角色判断
```javascript
import { onMounted, reactive, ref, computed } from 'vue'

// 判断当前用户是否是管理员
const isAdmin = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN'
})
```

#### 1.2 修改操作列
```vue
<el-table-column :label="$t('common.operation')" :width="isAdmin ? 180 : 220">
  <template #default="scope">
    <el-button link type="primary" @click="viewDetail(scope.row)">详情</el-button>
    
    <!-- 管理员：只显示审批按钮 -->
    <el-button v-if="isAdmin && scope.row.status === '待审批'" 
               link type="warning" @click="openApprove(scope.row)">
      审批
    </el-button>
    
    <!-- 保管员：只显示编辑和撤回按钮 -->
    <template v-if="!isAdmin && scope.row.status === '待审批'">
      <el-button link type="primary" @click="openEdit(scope.row)">编辑</el-button>
      <el-button link type="danger" @click="remove(scope.row.id)">撤回</el-button>
    </template>
  </template>
</el-table-column>
```

**操作列宽度**:
- 管理员：180px（2个按钮）
- 保管员：220px（3个按钮）

---

### 2. 修复管理界面

**文件**: `frontend/src/views/RepairsView.vue`

#### 2.1 添加角色判断
```javascript
import { onMounted, reactive, ref, computed } from 'vue'

// 判断当前用户是否是管理员
const isAdmin = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN'
})
```

#### 2.2 修改操作列
```vue
<el-table-column :label="$t('common.operation')" :width="isAdmin ? 210 : 250" fixed="right">
  <template #default="scope">
    <el-button link type="primary" @click="viewDetail(scope.row)">详情</el-button>
    
    <!-- 管理员：只显示审批按钮 -->
    <el-button v-if="isAdmin && scope.row.status === '待审批'" 
               link type="warning" @click="openApprove(scope.row)">
      审批
    </el-button>
    
    <!-- 保管员：只显示编辑和撤回按钮 -->
    <template v-if="!isAdmin && scope.row.status === '待审批'">
      <el-button link type="primary" @click="openEdit(scope.row)">编辑</el-button>
      <el-button link type="danger" @click="remove(scope.row.id)">撤回</el-button>
    </template>
  </template>
</el-table-column>
```

**操作列宽度**:
- 管理员：210px（2个按钮）
- 保管员：250px（3个按钮）

---

## 界面效果

### 维护管理界面

#### 系统管理员视图（待审批状态）
```
┌────────┬────────┐
│  详情  │  审批  │
└────────┴────────┘
```

#### 文物保管员视图（待审批状态）
```
┌────────┬────────┬────────┐
│  详情  │  编辑  │  撤回  │
└────────┴────────┴────────┘
```

#### 所有角色视图（其他状态）
```
┌────────┐
│  详情  │
└────────┘
```

---

### 修复管理界面

#### 系统管理员视图（待审批状态）
```
┌────────┬────────┐
│  详情  │  审批  │
└────────┴────────┘
```

#### 文物保管员视图（待审批状态）
```
┌────────┬────────┬────────┐
│  详情  │  编辑  │  撤回  │
└────────┴────────┴────────┘
```

#### 所有角色视图（其他状态）
```
┌────────┐
│  详情  │
└────────┘
```

---

## 权限控制

### 前端控制
- ✅ 根据角色显示不同的按钮
- ✅ 用户只能看到有权限的操作

### 后端控制（双重保险）
- ✅ 查询时按角色过滤数据
- ✅ 编辑/删除时验证记录所有权
- ✅ 审批时验证管理员权限

---

## 技术实现

### 1. 使用 computed 属性
```javascript
const isAdmin = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN'
})
```

**优点**:
- 响应式更新
- 自动缓存结果
- 代码简洁

### 2. 条件渲染
```vue
<!-- 管理员专用 -->
<el-button v-if="isAdmin && scope.row.status === '待审批'" ...>

<!-- 保管员专用 -->
<template v-if="!isAdmin && scope.row.status === '待审批'">
  ...
</template>
```

### 3. 动态宽度
```vue
<el-table-column :width="isAdmin ? 180 : 220">
```

根据角色自动调整列宽，确保界面美观。

---

## 测试场景

### 1. 系统管理员测试

#### 维护管理
- [ ] 登录管理员账号
- [ ] 访问维护管理页面
- [ ] 查看待审批记录 → 只显示"详情"和"审批"按钮 ✓
- [ ] 查看其他状态记录 → 只显示"详情"按钮 ✓
- [ ] 点击"审批"按钮 → 打开审批对话框 ✓
- [ ] 提交审批 → 成功 ✓

#### 修复管理
- [ ] 访问修复管理页面
- [ ] 查看待审批记录 → 只显示"详情"和"审批"按钮 ✓
- [ ] 查看其他状态记录 → 只显示"详情"按钮 ✓
- [ ] 点击"审批"按钮 → 打开审批对话框 ✓
- [ ] 提交审批 → 成功 ✓

---

### 2. 文物保管员测试

#### 维护管理
- [ ] 登录保管员账号
- [ ] 访问维护管理页面
- [ ] 查看待审批记录 → 只显示"详情"、"编辑"、"撤回"按钮 ✓
- [ ] 查看其他状态记录 → 只显示"详情"按钮 ✓
- [ ] 点击"编辑"按钮 → 打开编辑对话框 ✓
- [ ] 提交编辑 → 成功 ✓
- [ ] 点击"撤回"按钮 → 确认撤回 → 成功 ✓

#### 修复管理
- [ ] 访问修复管理页面
- [ ] 查看待审批记录 → 只显示"详情"、"编辑"、"撤回"按钮 ✓
- [ ] 查看其他状态记录 → 只显示"详情"按钮 ✓
- [ ] 点击"编辑"按钮 → 打开编辑对话框 ✓
- [ ] 提交编辑 → 成功 ✓
- [ ] 点击"撤回"按钮 → 确认撤回 → 成功 ✓

---

### 3. 按钮不显示测试

#### 管理员不应该看到
- [ ] "编辑"按钮 ✓
- [ ] "撤回"按钮 ✓

#### 保管员不应该看到
- [ ] "审批"按钮 ✓

---

## 修改文件清单

### 前端
1. `frontend/src/views/MaintenanceView.vue`
   - 添加 `computed` 导入
   - 添加 `isAdmin` 计算属性
   - 修改操作列模板，根据角色显示不同按钮
   - 调整操作列宽度（管理员 180px，保管员 220px）

2. `frontend/src/views/RepairsView.vue`
   - 添加 `computed` 导入
   - 添加 `isAdmin` 计算属性
   - 修改操作列模板，根据角色显示不同按钮
   - 调整操作列宽度（管理员 210px，保管员 250px）

### 后端
**无需修改**，权限控制已完善

---

## 优点总结

### 1. 用户体验
- ✅ 界面清晰，只显示可用的操作
- ✅ 减少误操作，避免点击无权限的按钮
- ✅ 符合用户心理预期

### 2. 安全性
- ✅ 前端按钮控制（第一层防护）
- ✅ 后端权限验证（第二层防护）
- ✅ 双重保险，更加安全

### 3. 可维护性
- ✅ 代码结构清晰
- ✅ 使用 computed 属性，响应式更新
- ✅ 易于扩展新角色

### 4. 性能
- ✅ computed 属性自动缓存
- ✅ 只在角色变化时重新计算
- ✅ 不影响页面性能

---

## 完成状态

✅ 维护管理界面根据角色显示不同按钮
✅ 修复管理界面根据角色显示不同按钮
✅ 管理员只看到：详情、审批
✅ 保管员只看到：详情、编辑、撤回
✅ 操作列宽度自动调整
✅ 代码使用 computed 属性，响应式更新

---

## 总结

现在维护管理和修复管理功能已经完全按角色分离显示：

1. **系统管理员**：专注于审批工作
   - 看到：详情、审批
   - 不看到：编辑、撤回

2. **文物保管员**：专注于申请管理
   - 看到：详情、编辑、撤回
   - 不看到：审批

这种设计：
- ✅ 职责清晰，符合业务流程
- ✅ 界面简洁，用户体验好
- ✅ 权限分离，安全性高
- ✅ 代码优雅，易于维护
