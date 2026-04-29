# 申请审批员角色功能增强完成

## 概述
成功将"借展审批员"角色升级为"申请审批员"角色，现在可以对文物借展申请、文物修复申请、文物维护申请进行查看详情和审批操作。

## 角色定义

### 申请审批员（APPROVER）
**新功能范围**:
- ✅ 文物借展申请审批
- ✅ 文物修复申请审批
- ✅ 文物维护申请审批

**权限**:
- ✅ 查看所有申请记录
- ✅ 查看申请详情
- ✅ 审批申请（通过/拒绝）
- ❌ 不能编辑他人的申请
- ❌ 不能撤回他人的申请

---

## 实现内容

### 1. 后端权限控制

#### 1.1 维护管理 Controller
**文件**: `backend/src/main/java/com/example/controller/MaintenanceRecordController.java`

**修改内容**:

##### 查询权限
```java
// 检查是否是管理员或审批员角色（ADMIN和APPROVER可以查看所有记录）
boolean isAdminOrApprover = authorities.stream()
    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || 
                   a.getAuthority().equals("ROLE_APPROVER"));

// 如果不是管理员或审批员（即CURATOR等角色），只查询自己的维护记录
if (!isAdminOrApprover) {
    applicantIdFilter = userContextUtil.getCurrentUserId();
}
```

##### 编辑权限
```java
// 管理员和审批员也不能修改他人的申请，只能审批
// 所有人都只能修改自己的记录
Long currentUserId = userContextUtil.getCurrentUserId();
if (oldRecord.getMaintainerId() == null || 
    !oldRecord.getMaintainerId().equals(currentUserId)) {
    return Result.error("无权修改此申请");
}
```

##### 删除权限
```java
// 所有人都只能删除自己的记录
Long currentUserId = userContextUtil.getCurrentUserId();
if (oldRecord.getMaintainerId() == null || 
    !oldRecord.getMaintainerId().equals(currentUserId)) {
    return Result.error("无权删除此记录");
}
```

---

#### 1.2 修复管理 Controller
**文件**: `backend/src/main/java/com/example/controller/RepairRecordController.java`

**修改内容**:

##### 查询权限
```java
// 检查是否是管理员或审批员角色（ADMIN和APPROVER可以查看所有记录）
boolean isAdminOrApprover = authorities.stream()
    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || 
                   a.getAuthority().equals("ROLE_APPROVER"));

// 如果不是管理员或审批员（即CURATOR等角色），只查询自己申请的
if (!isAdminOrApprover) {
    applicantIdFilter = userContextUtil.getCurrentUserId();
}
```

##### 详情查看权限
```java
// 权限检查：保管员只能查看自己的记录，管理员和审批员可以查看所有记录
boolean isAdminOrApprover = authorities.stream()
    .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || 
                   a.getAuthority().equals("ROLE_APPROVER"));

// 如果不是管理员或审批员，检查是否是自己的记录
if (!isAdminOrApprover) {
    Long currentUserId = userContextUtil.getCurrentUserId();
    if (record.getApplicantId() == null || 
        !record.getApplicantId().equals(currentUserId)) {
        return Result.error("无权查看此记录");
    }
}
```

##### 删除权限
```java
// 所有人都只能删除自己的记录（管理员和审批员也不能删除他人记录）
Long currentUserId = userContextUtil.getCurrentUserId();
if (oldRecord.getApplicantId() == null || 
    !oldRecord.getApplicantId().equals(currentUserId)) {
    return Result.error("无权删除此记录");
}
```

---

#### 1.3 借展管理 Controller
**文件**: `backend/src/main/java/com/example/controller/LoanRecordController.java`

**状态**: 无需修改，已经支持APPROVER角色审批

---

### 2. 前端界面修改

#### 2.1 维护管理界面
**文件**: `frontend/src/views/MaintenanceView.vue`

**修改内容**:

##### 角色判断
```javascript
// 判断当前用户是否是管理员或审批员
const isAdminOrApprover = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN' || role === 'APPROVER'
})
```

##### 操作列按钮
```vue
<el-table-column :label="$t('common.operation')" 
                 :width="isAdminOrApprover ? 180 : 220">
  <template #default="scope">
    <el-button link type="primary" @click="viewDetail(scope.row)">
      详情
    </el-button>
    
    <!-- 管理员和审批员：只显示审批按钮 -->
    <el-button v-if="isAdminOrApprover && scope.row.status === '待审批'" 
               link type="warning" @click="openApprove(scope.row)">
      审批
    </el-button>
    
    <!-- 保管员：只显示编辑和撤回按钮 -->
    <template v-if="!isAdminOrApprover && scope.row.status === '待审批'">
      <el-button link type="primary" @click="openEdit(scope.row)">
        编辑
      </el-button>
      <el-button link type="danger" @click="remove(scope.row.id)">
        撤回
      </el-button>
    </template>
  </template>
</el-table-column>
```

---

#### 2.2 修复管理界面
**文件**: `frontend/src/views/RepairsView.vue`

**修改内容**:

##### 角色判断
```javascript
// 判断当前用户是否是管理员或审批员
const isAdminOrApprover = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN' || role === 'APPROVER'
})
```

##### 操作列按钮
```vue
<el-table-column :label="$t('common.operation')" 
                 :width="isAdminOrApprover ? 210 : 250" 
                 fixed="right">
  <template #default="scope">
    <el-button link type="primary" @click="viewDetail(scope.row)">
      详情
    </el-button>
    
    <!-- 管理员和审批员：只显示审批按钮 -->
    <el-button v-if="isAdminOrApprover && scope.row.status === '待审批'" 
               link type="warning" @click="openApprove(scope.row)">
      审批
    </el-button>
    
    <!-- 保管员：只显示编辑和撤回按钮 -->
    <template v-if="!isAdminOrApprover && scope.row.status === '待审批'">
      <el-button link type="primary" @click="openEdit(scope.row)">
        编辑
      </el-button>
      <el-button link type="danger" @click="remove(scope.row.id)">
        撤回
      </el-button>
    </template>
  </template>
</el-table-column>
```

---

#### 2.3 借展管理界面
**文件**: `frontend/src/views/LoansView.vue`

**状态**: 无需修改，已经支持APPROVER角色审批

---

## 权限矩阵

### 维护管理

| 操作 | 系统管理员 | 申请审批员 | 文物保管员（自己的） | 文物保管员（他人的） |
|------|-----------|-----------|-------------------|-------------------|
| 查看列表 | 所有记录 | 所有记录 | 自己的记录 | 看不到 |
| 查看详情 | ✅ | ✅ | ✅ | ❌ |
| 新增申请 | ✅ | ✅ | ✅ | N/A |
| 编辑申请 | ✅（自己的） | ✅（自己的） | ✅（待审批） | ❌ |
| 撤回申请 | ✅（自己的） | ✅（自己的） | ✅（待审批） | ❌ |
| 审批申请 | ✅ | ✅ | ❌ | ❌ |

### 修复管理

| 操作 | 系统管理员 | 申请审批员 | 文物保管员（自己的） | 文物保管员（他人的） |
|------|-----------|-----------|-------------------|-------------------|
| 查看列表 | 所有记录 | 所有记录 | 自己的记录 | 看不到 |
| 查看详情 | ✅ | ✅ | ✅ | ❌ |
| 新增申请 | ✅ | ✅ | ✅ | N/A |
| 编辑申请 | ✅（自己的） | ✅（自己的） | ✅（待审批） | ❌ |
| 撤回申请 | ✅（自己的） | ✅（自己的） | ✅（待审批） | ❌ |
| 审批申请 | ✅ | ✅ | ❌ | ❌ |

### 借展管理

| 操作 | 系统管理员 | 申请审批员 | 借展人（自己的） | 借展人（他人的） |
|------|-----------|-----------|----------------|----------------|
| 查看列表 | 所有记录 | 所有记录 | 自己的记录 | 看不到 |
| 查看详情 | ✅ | ✅ | ✅ | ❌ |
| 新增申请 | ✅ | ✅ | ✅ | N/A |
| 审批申请 | ✅ | ✅ | ❌ | ❌ |

---

## 消息通知

### 通知接收者更新

所有申请相关的通知现在会发送给：
- 系统管理员（ADMIN）
- 申请审批员（APPROVER）

**涉及的通知类型**:
1. 借展申请通知（LOAN_APPLY）
2. 修复申请通知（REPAIR_APPLY）
3. 维护申请通知（MAINTENANCE_APPLY）
4. 用户归还通知（USER_RETURN）
5. 申请撤回通知（WITHDRAW）

**代码示例**:
```java
// 发送给系统管理员和申请审批员
createAndSendNotification(notification, Arrays.asList("ADMIN", "APPROVER"));
```

---

## 界面效果

### 申请审批员视图（待审批状态）

#### 维护管理
```
┌────────┬────────┐
│  详情  │  审批  │
└────────┴────────┘
```

#### 修复管理
```
┌────────┬────────┐
│  详情  │  审批  │
└────────┴────────┘
```

#### 借展管理
```
┌────────┬────────┐
│  详情  │  审批  │
└────────┴────────┘
```

### 文物保管员视图（待审批状态）

#### 维护管理
```
┌────────┬────────┬────────┐
│  详情  │  编辑  │  撤回  │
└────────┴────────┴────────┘
```

#### 修复管理
```
┌────────┬────────┬────────┐
│  详情  │  编辑  │  撤回  │
└────────┴────────┴────────┘
```

---

## 测试场景

### 1. 申请审批员测试

#### 维护管理
- [ ] 登录申请审批员账号
- [ ] 访问维护管理页面
- [ ] 查看列表 → 显示所有用户的维护申请 ✓
- [ ] 查看待审批记录 → 只显示"详情"和"审批"按钮 ✓
- [ ] 点击"审批"按钮 → 打开审批对话框 ✓
- [ ] 提交审批 → 成功 ✓
- [ ] 申请人收到审批结果通知 ✓

#### 修复管理
- [ ] 访问修复管理页面
- [ ] 查看列表 → 显示所有用户的修复申请 ✓
- [ ] 查看待审批记录 → 只显示"详情"和"审批"按钮 ✓
- [ ] 点击"审批"按钮 → 打开审批对话框 ✓
- [ ] 提交审批 → 成功 ✓
- [ ] 申请人收到审批结果通知 ✓

#### 借展管理
- [ ] 访问借展管理页面
- [ ] 查看列表 → 显示所有用户的借展申请 ✓
- [ ] 查看待审批记录 → 显示"审批"按钮 ✓
- [ ] 点击"审批"按钮 → 打开审批对话框 ✓
- [ ] 提交审批 → 成功 ✓
- [ ] 申请人收到审批结果通知 ✓

### 2. 通知测试

#### 申请提交通知
- [ ] 保管员提交维护申请 → 管理员和审批员都收到通知 ✓
- [ ] 保管员提交修复申请 → 管理员和审批员都收到通知 ✓
- [ ] 用户提交借展申请 → 管理员和审批员都收到通知 ✓

#### 审批结果通知
- [ ] 审批员审批维护申请 → 申请人收到通知 ✓
- [ ] 审批员审批修复申请 → 申请人收到通知 ✓
- [ ] 审批员审批借展申请 → 申请人收到通知 ✓

---

## 修改文件清单

### 后端
1. `backend/src/main/java/com/example/controller/MaintenanceRecordController.java`
   - 查询方法：添加APPROVER角色检查
   - 编辑方法：明确所有人只能编辑自己的记录
   - 删除方法：明确所有人只能删除自己的记录

2. `backend/src/main/java/com/example/controller/RepairRecordController.java`
   - 查询方法：添加APPROVER角色检查
   - 详情方法：添加APPROVER角色检查
   - 删除方法：明确所有人只能删除自己的记录

### 前端
1. `frontend/src/views/MaintenanceView.vue`
   - 添加`isAdminOrApprover`计算属性
   - 修改操作列，APPROVER角色显示审批按钮

2. `frontend/src/views/RepairsView.vue`
   - 添加`isAdminOrApprover`计算属性
   - 修改操作列，APPROVER角色显示审批按钮

---

## 完成状态

✅ 后端维护管理Controller添加APPROVER角色支持
✅ 后端修复管理Controller添加APPROVER角色支持
✅ 前端维护管理界面添加APPROVER角色支持
✅ 前端修复管理界面添加APPROVER角色支持
✅ 借展管理已支持APPROVER角色（无需修改）
✅ 权限控制完善（查看、审批、编辑、删除）
✅ 消息通知发送给ADMIN和APPROVER

---

## 总结

现在"申请审批员"角色功能已经完全增强：

1. **功能范围扩大**：
   - 从只能审批借展申请
   - 扩展到可以审批借展、修复、维护三种申请

2. **权限清晰**：
   - 可以查看所有申请记录
   - 可以审批所有待审批的申请
   - 不能编辑或删除他人的申请

3. **通知完整**：
   - 所有新申请都会通知审批员
   - 审批结果会通知申请人

4. **界面统一**：
   - 三个管理界面（借展、修复、维护）都支持审批员角色
   - 按钮显示逻辑一致

这种设计符合实际业务需求，让审批员可以专注于审批工作，提高工作效率！
