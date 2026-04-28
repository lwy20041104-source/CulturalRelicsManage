# 文物保管员修复申请功能 - 实施总结

## 📋 项目概述

为文物保管员（CURATOR）角色添加专用的修复申请功能，简化界面，只保留申请修复的权限，移除完整的修复管理权限。

**创建时间**: 2026-04-28  
**状态**: 前端完成，后端待完善

---

## ✅ 已完成的工作

### 1. 前端实现

#### 1.1 新建视图文件
- ✅ **文件**: `frontend/src/views/RepairApplyView.vue`
- **功能**:
  - 保管员专用的修复申请界面
  - 支持选择文物、材料
  - 自动计算预估费用
  - 只能查看和删除自己的申请记录
  - 只能删除"待审批"和"已拒绝"状态的记录

#### 1.2 路由配置
- ✅ **文件**: `frontend/src/router/index.js`
- **修改**: 已添加 `/repair-apply` 路由，权限为 `repairs:apply`

#### 1.3 菜单配置
- ✅ **文件**: `frontend/src/views/LayoutView.vue`
- **修改**: 已在修复管理菜单后添加"申请修复"菜单项

#### 1.4 国际化配置
- ✅ **文件**: `frontend/src/i18n/locales/zh-CN.js`
  - 添加: `repairApply: '申请修复'`
- ✅ **文件**: `frontend/src/i18n/locales/en-US.js`
  - 添加: `repairApply: 'Apply Repair'`

### 2. 数据库脚本

#### 2.1 权限配置SQL
- ✅ **文件**: `backend/sql/add_repair_apply_permission.sql`
- **功能**:
  - 添加 `repairs:apply` 权限
  - 为CURATOR角色分配 `repairs:apply` 权限
  - 移除CURATOR角色的 `repairs:manage` 权限
  - 添加通知类型（如果表存在）:
    - `REPAIR_APPROVED` - 修复申请已通过
    - `REPAIR_REJECTED` - 修复申请已拒绝
    - `REPAIR_COMPLETED` - 修复已完成
  - 为CURATOR用户创建通知配置

---

## ⏳ 待完成的工作

### 1. 执行数据库脚本

**操作步骤**:
```bash
mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql
```

**验证**:
- 检查CURATOR角色是否有 `repairs:apply` 权限
- 检查CURATOR角色是否已移除 `repairs:manage` 权限
- 检查通知类型是否已添加

### 2. 后端Controller修改

**文件**: `backend/src/main/java/com/example/controller/RepairRecordController.java`

#### 2.1 需要添加的功能

##### A. 在审批方法中添加通知发送

在 `approveRepair` 方法中，审批完成后发送通知给申请人：

```java
@PutMapping("/approve")
public Result<Boolean> approveRepair(@RequestBody RepairApproveRequest request,
                                     Authentication authentication,
                                     javax.servlet.http.HttpServletRequest httpRequest) {
    // ... 原有审批逻辑
    
    // 发送通知给申请人
    if (success) {
        RepairRecord record = repairRecordService.getById(request.getId());
        notificationService.sendRepairApprovalNotification(
            record.getId(),
            record.getApplicantId(),
            record.getRelicName(),
            request.getApproved(),
            approver
        );
    }
    
    return Result.success(message, success);
}
```

**注意**: `NotificationService` 已有 `sendRepairApprovalNotification` 方法，可以直接使用。

##### B. 在完成修复方法中添加通知发送

需要在 `NotificationService` 接口中添加新方法：

```java
/**
 * 发送修复完成通知
 * 
 * @param repairId 修复记录ID
 * @param applicantId 申请人ID
 * @param relicName 文物名称
 * @param qualityScore 质量评分
 */
void sendRepairCompletionNotification(Long repairId, Long applicantId, String relicName, Integer qualityScore);
```

然后在 `completeRepair` 方法中调用：

```java
@PutMapping("/{id}/complete")
public Result<Boolean> completeRepair(@PathVariable Long id,
                                      @RequestBody(required = false) RepairProgressRequest request,
                                      javax.servlet.http.HttpServletRequest httpRequest) {
    // ... 原有完成逻辑
    
    // 发送通知给申请人
    if (success) {
        RepairRecord record = repairRecordService.getById(id);
        notificationService.sendRepairCompletionNotification(
            record.getId(),
            record.getApplicantId(),
            record.getRelicName(),
            request != null ? request.getQualityScore() : null
        );
    }
    
    return Result.success("修复已完成", success);
}
```

##### C. 在查询方法中添加权限过滤

在 `page` 方法中，根据用户权限过滤数据：

```java
@GetMapping
public Result<PageResult<RepairRecord>> page(
        @RequestParam(defaultValue = "1") Integer pageNum,
        @RequestParam(defaultValue = "10") Integer pageSize,
        @RequestParam(required = false) String status,
        @RequestParam(required = false) String priority,
        @RequestParam(required = false) String relicName,
        @RequestParam(required = false) String repairExpert,
        Authentication authentication) {
    
    // 获取当前用户权限
    Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
    
    // 检查是否有 repairs:manage 权限
    boolean hasManagePermission = authorities.stream()
        .anyMatch(a -> a.getAuthority().equals("repairs:manage"));
    
    // 如果只有 repairs:apply 权限，只查询自己申请的
    Long applicantIdFilter = null;
    if (!hasManagePermission) {
        applicantIdFilter = userContextUtil.getCurrentUserId();
    }
    
    PageResult<RepairRecord> result = repairRecordService.pageRecords(
            pageNum, pageSize, status, priority, relicName, repairExpert, applicantIdFilter);
    return Result.success(result);
}
```

**注意**: 需要修改 `RepairRecordService.pageRecords` 方法，添加 `applicantIdFilter` 参数。

### 3. Service层修改

**文件**: `backend/src/main/java/com/example/service/RepairRecordService.java`

修改 `pageRecords` 方法签名：

```java
PageResult<RepairRecord> pageRecords(Integer pageNum, Integer pageSize, 
                                     String status, String priority, 
                                     String relicName, String repairExpert,
                                     Long applicantIdFilter);
```

**文件**: `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java`

在实现中添加申请人过滤逻辑：

```java
@Override
public PageResult<RepairRecord> pageRecords(Integer pageNum, Integer pageSize, 
                                           String status, String priority, 
                                           String relicName, String repairExpert,
                                           Long applicantIdFilter) {
    // ... 原有逻辑
    
    // 添加申请人过滤
    if (applicantIdFilter != null) {
        // 在查询条件中添加 applicant_id = applicantIdFilter
    }
    
    // ... 原有逻辑
}
```

### 4. NotificationService实现

**文件**: `backend/src/main/java/com/example/service/NotificationService.java`

添加接口方法：

```java
/**
 * 发送修复完成通知
 * 
 * @param repairId 修复记录ID
 * @param applicantId 申请人ID
 * @param relicName 文物名称
 * @param qualityScore 质量评分
 */
void sendRepairCompletionNotification(Long repairId, Long applicantId, String relicName, Integer qualityScore);
```

**文件**: `backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

实现该方法：

```java
@Override
public void sendRepairCompletionNotification(Long repairId, Long applicantId, String relicName, Integer qualityScore) {
    SystemNotification notification = new SystemNotification();
    notification.setTitle("修复已完成");
    notification.setContent(String.format("您申请的文物"%s"修复已完成，质量评分：%d分", 
        relicName, 
        qualityScore != null ? qualityScore : 0));
    notification.setType("REPAIR");
    notification.setRelatedId(repairId);
    notification.setPriority("NORMAL");
    notification.setSenderId(null); // 系统通知
    notification.setCreateTime(LocalDateTime.now());
    
    // 发送给申请人
    createAndSendToUser(notification, applicantId);
}
```

---

## 🧪 测试计划

### 1. 数据库测试

**测试步骤**:
1. 执行SQL脚本
2. 验证权限配置
3. 验证通知类型配置

**验证SQL**:
```sql
-- 查看CURATOR角色权限
SELECT 
    r.role_name AS '角色',
    p.permission_name AS '权限',
    p.permission_code AS '权限代码'
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR'
ORDER BY p.permission_code;

-- 查看通知类型
SELECT * FROM notification_type WHERE type_code LIKE 'REPAIR_%';
```

### 2. 前端功能测试

**测试用户**:
- 用户名: curator01
- 密码: 123456
- 角色: 文物保管员（CURATOR）

**测试场景**:

#### 场景1: 菜单显示
- ✅ 登录保管员账号
- ✅ 验证菜单只显示"申请修复"
- ✅ 验证不显示"修复管理"、"修复专家"、"修复材料"

#### 场景2: 申请修复
- ✅ 点击"申请修复"菜单
- ✅ 点击"申请修复"按钮
- ✅ 选择文物
- ✅ 选择材料
- ✅ 验证预估费用自动计算
- ✅ 提交申请
- ✅ 验证提交成功

#### 场景3: 查看记录
- ✅ 查看申请列表
- ✅ 验证只显示自己申请的记录
- ✅ 验证可以查看详情

#### 场景4: 删除记录
- ✅ 验证可以删除"待审批"状态的记录
- ✅ 验证可以删除"已拒绝"状态的记录
- ✅ 验证不能删除其他状态的记录

### 3. 通知功能测试

**测试场景**:

#### 场景1: 审批通过通知
1. 保管员提交修复申请
2. 管理员登录，审批通过
3. 保管员登录，验证收到"修复申请已通过"通知
4. 验证通知内容包含文物名称和审批人

#### 场景2: 审批拒绝通知
1. 保管员提交修复申请
2. 管理员登录，审批拒绝
3. 保管员登录，验证收到"修复申请已拒绝"通知
4. 验证通知内容包含拒绝原因

#### 场景3: 修复完成通知
1. 管理员完成修复
2. 保管员登录，验证收到"修复已完成"通知
3. 验证通知内容包含质量评分

### 4. 权限测试

**测试场景**:

#### 场景1: 路由访问权限
- ✅ 保管员访问 `/repair-apply` - 应该正常显示
- ❌ 保管员访问 `/repairs` - 应该跳转到 dashboard
- ❌ 保管员访问 `/experts` - 应该跳转到 dashboard
- ❌ 保管员访问 `/repair-materials` - 应该跳转到 dashboard

#### 场景2: 操作权限
- ✅ 保管员可以申请修复
- ✅ 保管员可以查看自己的申请
- ✅ 保管员可以删除待审批/已拒绝的申请
- ❌ 保管员不能审批修复
- ❌ 保管员不能开始修复
- ❌ 保管员不能完成修复
- ❌ 保管员不能查看其他人的申请

#### 场景3: 数据过滤
- ✅ 保管员只能看到自己申请的记录
- ✅ 管理员可以看到所有记录

---

## 📁 文件清单

### 前端文件
- ✅ `frontend/src/views/RepairApplyView.vue` - 新建
- ✅ `frontend/src/router/index.js` - 已配置
- ✅ `frontend/src/views/LayoutView.vue` - 已配置
- ✅ `frontend/src/i18n/locales/zh-CN.js` - 已修改
- ✅ `frontend/src/i18n/locales/en-US.js` - 已修改

### 后端文件
- ✅ `backend/sql/add_repair_apply_permission.sql` - 已创建
- ⏳ `backend/src/main/java/com/example/controller/RepairRecordController.java` - 需要修改
- ⏳ `backend/src/main/java/com/example/service/RepairRecordService.java` - 需要修改
- ⏳ `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java` - 需要修改
- ⏳ `backend/src/main/java/com/example/service/NotificationService.java` - 需要添加方法
- ⏳ `backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java` - 需要实现方法

### 文档文件
- ✅ `CURATOR_REPAIR_APPLY_MODIFICATION.md` - 设计方案
- ✅ `CURATOR_REPAIR_MODIFICATION_STEPS.md` - 实施步骤
- ✅ `CURATOR_REPAIR_APPLY_IMPLEMENTATION_SUMMARY.md` - 实施总结（本文档）

---

## 🎯 预期效果

### 保管员视角
- 菜单简洁，只显示"申请修复"
- 可以申请修复，选择材料
- 预估费用自动计算
- 可以查看自己的申请记录
- 可以查看申请状态和详情
- 可以删除待审批/已拒绝的申请
- 收到审批和完成通知

### 管理员/审批员视角
- 菜单显示完整的修复管理功能
- 可以查看所有修复记录
- 可以审批、修复、完成
- 可以管理专家和材料

---

## 📝 下一步操作

1. **执行数据库脚本**
   ```bash
   mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql
   ```

2. **修改后端代码**
   - 修改 `RepairRecordController.java`
   - 修改 `RepairRecordService.java` 和实现类
   - 修改 `NotificationService.java` 和实现类

3. **编译后端**
   ```bash
   cd backend
   mvn clean compile
   ```

4. **重启后端服务**

5. **测试功能**
   - 使用curator01账号登录测试
   - 验证菜单、权限、通知功能

---

**创建时间**: 2026-04-28  
**最后更新**: 2026-04-28  
**状态**: 前端完成，后端待完善
