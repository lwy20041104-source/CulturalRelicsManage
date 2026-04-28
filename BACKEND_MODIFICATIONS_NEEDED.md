# 后端修改清单 - 保管员修复申请功能

## 🎯 快速参考

本文档列出了完成保管员修复申请功能所需的所有后端代码修改。

---

## 1️⃣ 执行数据库脚本

```bash
mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql
```

验证结果：
```sql
-- 查看CURATOR角色权限
SELECT p.permission_code, p.permission_name
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR';
```

预期结果应包含 `repairs:apply`，不应包含 `repairs:manage`。

---

## 2️⃣ 修改 RepairRecordController.java

### 位置
`backend/src/main/java/com/example/controller/RepairRecordController.java`

### 修改1: 在审批方法中添加通知

在 `approveRepair` 方法的最后，添加通知发送逻辑：

```java
@PutMapping("/approve")
public Result<Boolean> approveRepair(@RequestBody RepairApproveRequest request,
                                     Authentication authentication,
                                     javax.servlet.http.HttpServletRequest httpRequest) {
    // 1. 获取审批前的数据
    RepairRecord oldRecord = repairRecordService.getById(request.getId());
    
    // 2. 执行审批操作
    String approver = authentication != null ? authentication.getName() : "system";
    boolean success = repairRecordService.approveRepair(request, approver);
    
    // 3. 记录审计日志
    if (success && oldRecord != null) {
        try {
            RepairRecord newRecord = repairRecordService.getById(request.getId());
            String realName = userContextUtil.getCurrentUserRealName();
            Long userId = userContextUtil.getCurrentUserId();
            String ipAddress = getClientIp(httpRequest);
            
            operationLogService.logDataChange(
                userId,
                realName,
                "审批",
                "文物修复",
                "REPAIR",
                request.getId(),
                oldRecord,
                newRecord,
                ipAddress,
                "PUT",
                "/repairs/approve"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    // 🆕 4. 发送通知给申请人
    if (success && oldRecord != null) {
        try {
            RepairRecord record = repairRecordService.getById(request.getId());
            notificationService.sendRepairApprovalNotification(
                record.getId(),
                record.getApplicantId(),
                record.getRelicName(),
                request.getApproved(),
                approver
            );
        } catch (Exception e) {
            System.err.println("发送通知失败: " + e.getMessage());
        }
    }
    
    String message = Boolean.TRUE.equals(request.getApproved()) ? "审批通过" : "审批拒绝";
    return Result.success(message, success);
}
```

### 修改2: 在完成修复方法中添加通知

首先需要在类中注入 `NotificationService`（如果还没有）：

```java
private final NotificationService notificationService;

public RepairRecordController(RepairRecordService repairRecordService,
                             com.example.service.SysOperationLogService operationLogService,
                             com.example.util.UserContextUtil userContextUtil,
                             NotificationService notificationService) {
    this.repairRecordService = repairRecordService;
    this.operationLogService = operationLogService;
    this.userContextUtil = userContextUtil;
    this.notificationService = notificationService;
}
```

然后在 `completeRepair` 方法中添加通知：

```java
@PutMapping("/{id}/complete")
public Result<Boolean> completeRepair(@PathVariable Long id,
                                      @RequestBody(required = false) RepairProgressRequest request,
                                      javax.servlet.http.HttpServletRequest httpRequest) {
    // 1. 获取完成前的数据
    RepairRecord oldRecord = repairRecordService.getById(id);
    
    // 2. 执行完成修复操作
    boolean success = repairRecordService.completeRepair(id, request);
    
    // 3. 记录审计日志
    if (success && oldRecord != null) {
        try {
            RepairRecord newRecord = repairRecordService.getById(id);
            String realName = userContextUtil.getCurrentUserRealName();
            Long userId = userContextUtil.getCurrentUserId();
            String ipAddress = getClientIp(httpRequest);
            
            operationLogService.logDataChange(
                userId,
                realName,
                "完成修复",
                "文物修复",
                "REPAIR",
                id,
                oldRecord,
                newRecord,
                ipAddress,
                "PUT",
                "/repairs/" + id + "/complete"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    // 🆕 4. 发送通知给申请人
    if (success && oldRecord != null) {
        try {
            RepairRecord record = repairRecordService.getById(id);
            Integer qualityScore = request != null ? request.getQualityScore() : null;
            notificationService.sendRepairCompletionNotification(
                record.getId(),
                record.getApplicantId(),
                record.getRelicName(),
                qualityScore
            );
        } catch (Exception e) {
            System.err.println("发送通知失败: " + e.getMessage());
        }
    }
    
    return Result.success("修复已完成", success);
}
```

### 修改3: 在查询方法中添加权限过滤

修改 `page` 方法，添加申请人过滤：

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
    
    // 🆕 获取当前用户权限
    Long applicantIdFilter = null;
    if (authentication != null) {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        
        // 检查是否有 repairs:manage 权限
        boolean hasManagePermission = authorities.stream()
            .anyMatch(a -> a.getAuthority().equals("repairs:manage"));
        
        // 如果只有 repairs:apply 权限，只查询自己申请的
        if (!hasManagePermission) {
            applicantIdFilter = userContextUtil.getCurrentUserId();
        }
    }
    
    PageResult<RepairRecord> result = repairRecordService.pageRecords(
            pageNum, pageSize, status, priority, relicName, repairExpert, applicantIdFilter);
    return Result.success(result);
}
```

---

## 3️⃣ 修改 RepairRecordService.java

### 位置
`backend/src/main/java/com/example/service/RepairRecordService.java`

### 修改: 添加 applicantIdFilter 参数

```java
/**
 * 分页查询修复记录
 * 
 * @param pageNum 页码
 * @param pageSize 每页大小
 * @param status 状态
 * @param priority 优先级
 * @param relicName 文物名称
 * @param repairExpert 修复专家
 * @param applicantIdFilter 申请人ID过滤（null表示不过滤）
 * @return 分页结果
 */
PageResult<RepairRecord> pageRecords(Integer pageNum, Integer pageSize, 
                                     String status, String priority, 
                                     String relicName, String repairExpert,
                                     Long applicantIdFilter);
```

---

## 4️⃣ 修改 RepairRecordServiceImpl.java

### 位置
`backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java`

### 修改: 实现申请人过滤逻辑

```java
@Override
public PageResult<RepairRecord> pageRecords(Integer pageNum, Integer pageSize, 
                                           String status, String priority, 
                                           String relicName, String repairExpert,
                                           Long applicantIdFilter) {
    PageHelper.startPage(pageNum, pageSize);
    
    // 构建查询条件
    Map<String, Object> params = new HashMap<>();
    if (status != null && !status.isEmpty()) {
        params.put("status", status);
    }
    if (priority != null && !priority.isEmpty()) {
        params.put("priority", priority);
    }
    if (relicName != null && !relicName.isEmpty()) {
        params.put("relicName", relicName);
    }
    if (repairExpert != null && !repairExpert.isEmpty()) {
        params.put("repairExpert", repairExpert);
    }
    // 🆕 添加申请人过滤
    if (applicantIdFilter != null) {
        params.put("applicantId", applicantIdFilter);
    }
    
    List<RepairRecord> list = repairRecordMapper.selectByConditions(params);
    PageInfo<RepairRecord> pageInfo = new PageInfo<>(list);
    
    return new PageResult<>(pageInfo.getTotal(), pageInfo.getList());
}
```

### 同时需要修改 Mapper XML

在 `RepairRecordMapper.xml` 中添加申请人过滤条件：

```xml
<select id="selectByConditions" resultType="com.example.entity.RepairRecord">
    SELECT * FROM repair_record
    <where>
        <if test="status != null and status != ''">
            AND status = #{status}
        </if>
        <if test="priority != null and priority != ''">
            AND priority = #{priority}
        </if>
        <if test="relicName != null and relicName != ''">
            AND relic_name LIKE CONCAT('%', #{relicName}, '%')
        </if>
        <if test="repairExpert != null and repairExpert != ''">
            AND repair_expert LIKE CONCAT('%', #{repairExpert}, '%')
        </if>
        <!-- 🆕 添加申请人过滤 -->
        <if test="applicantId != null">
            AND applicant_id = #{applicantId}
        </if>
    </where>
    ORDER BY apply_date DESC
</select>
```

---

## 5️⃣ 修改 NotificationService.java

### 位置
`backend/src/main/java/com/example/service/NotificationService.java`

### 修改: 添加修复完成通知方法

在接口中添加新方法：

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

---

## 6️⃣ 修改 NotificationServiceImpl.java

### 位置
`backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

### 修改: 实现修复完成通知方法

```java
@Override
public void sendRepairCompletionNotification(Long repairId, Long applicantId, String relicName, Integer qualityScore) {
    try {
        SystemNotification notification = new SystemNotification();
        notification.setTitle("修复已完成");
        
        String content;
        if (qualityScore != null) {
            content = String.format("您申请的文物"%s"修复已完成，质量评分：%d分", relicName, qualityScore);
        } else {
            content = String.format("您申请的文物"%s"修复已完成", relicName);
        }
        
        notification.setContent(content);
        notification.setType("REPAIR");
        notification.setRelatedId(repairId);
        notification.setPriority("NORMAL");
        notification.setSenderId(null); // 系统通知
        notification.setCreateTime(LocalDateTime.now());
        
        // 发送给申请人
        createAndSendToUser(notification, applicantId);
        
        log.info("修复完成通知已发送: repairId={}, applicantId={}, relicName={}", 
                 repairId, applicantId, relicName);
    } catch (Exception e) {
        log.error("发送修复完成通知失败: repairId={}, applicantId={}", repairId, applicantId, e);
    }
}

/**
 * 创建通知并发送给指定用户
 */
private void createAndSendToUser(SystemNotification notification, Long userId) {
    // 保存通知到数据库
    systemNotificationMapper.insert(notification);
    
    // 创建用户通知关联
    UserNotification userNotification = new UserNotification();
    userNotification.setNotificationId(notification.getId());
    userNotification.setUserId(userId);
    userNotification.setIsRead(false);
    userNotification.setCreateTime(LocalDateTime.now());
    
    userNotificationMapper.insert(userNotification);
    
    // 通过WebSocket实时推送（如果用户在线）
    try {
        webSocketNotificationService.sendToUser(userId, notification);
    } catch (Exception e) {
        log.warn("WebSocket推送失败，用户可能不在线: userId={}", userId);
    }
}
```

---

## 7️⃣ 编译和重启

### 编译
```bash
cd backend
mvn clean compile
```

### 重启服务
重启Spring Boot应用以加载新的代码。

---

## ✅ 验证清单

### 数据库验证
- [ ] CURATOR角色有 `repairs:apply` 权限
- [ ] CURATOR角色没有 `repairs:manage` 权限
- [ ] 通知类型表中有 `REPAIR_APPROVED`, `REPAIR_REJECTED`, `REPAIR_COMPLETED`

### 功能验证
- [ ] 保管员可以申请修复
- [ ] 保管员只能看到自己的申请记录
- [ ] 管理员可以看到所有申请记录
- [ ] 审批通过后，申请人收到通知
- [ ] 审批拒绝后，申请人收到通知
- [ ] 修复完成后，申请人收到通知

### 权限验证
- [ ] 保管员不能访问 `/repairs` 路由
- [ ] 保管员不能访问 `/experts` 路由
- [ ] 保管员不能访问 `/repair-materials` 路由
- [ ] 保管员可以访问 `/repair-apply` 路由

---

## 📝 注意事项

1. **NotificationService注入**: 确保在 `RepairRecordController` 中正确注入 `NotificationService`

2. **权限检查**: 使用 Spring Security 的 `Authentication` 对象获取用户权限

3. **异常处理**: 所有通知发送都应该用 try-catch 包裹，避免影响主业务流程

4. **日志记录**: 添加适当的日志记录，便于调试和追踪

5. **数据库字段**: 确保 `repair_record` 表有 `applicant_id` 字段

---

**创建时间**: 2026-04-28  
**用途**: 后端开发人员快速参考
