# 修复申请撤回通知功能

## 功能概述
当文物保管员撤回待审批的修复申请时，系统自动向管理员发送通知，告知申请已被撤回。

## 实现内容

### 1. 通知服务接口

**文件**：`backend/src/main/java/com/example/service/NotificationService.java`

添加新的接口方法：
```java
/**
 * 发送修复申请撤回通知
 * 
 * @param repairId 修复记录ID
 * @param relicName 文物名称
 * @param repairReason 修复原因
 * @param senderId 发送人ID
 */
void sendRepairWithdrawNotification(Long repairId, String relicName, String repairReason, Long senderId);
```

### 2. 通知服务实现

**文件**：`backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

实现撤回通知发送逻辑：
```java
@Override
public void sendRepairWithdrawNotification(Long repairId, String relicName, String repairReason, Long senderId) {
    SystemNotification notification = new SystemNotification();
    notification.setTitle("修复申请已撤回");
    notification.setContent(String.format("文物\"%s\"的修复申请已被撤回，原修复原因：%s。", relicName, repairReason));
    notification.setType("REPAIR_WITHDRAW");
    notification.setPriority("NORMAL");
    notification.setRelatedType("REPAIR");
    notification.setRelatedId(repairId);
    notification.setSenderId(senderId);
    
    // 发送给系统管理员
    createAndSendNotification(notification, Arrays.asList("ADMIN"));
}
```

**通知特性**：
- **标题**：修复申请已撤回
- **内容**：包含文物名称和原修复原因
- **类型**：REPAIR_WITHDRAW
- **优先级**：NORMAL
- **接收者**：系统管理员（ADMIN角色）

### 3. 控制器调用

**文件**：`backend/src/main/java/com/example/controller/RepairRecordController.java`

在 `deleteById` 方法中添加通知发送：
```java
// 2. 执行删除操作
boolean success = repairRecordService.deleteById(id);

// 3. 发送撤回通知（仅当状态为待审批时）
if (success && "待审批".equals(oldRecord.getStatus())) {
    try {
        Long currentUserId = userContextUtil.getCurrentUserId();
        
        notificationService.sendRepairWithdrawNotification(
            id,
            oldRecord.getRelicName() != null ? oldRecord.getRelicName() : "未知文物",
            oldRecord.getRepairReason(),
            currentUserId
        );
        System.out.println("修复申请撤回通知已发送：repairId=" + id + ", relic=" + oldRecord.getRelicName());
    } catch (Exception e) {
        System.err.println("发送修复申请撤回通知失败: " + e.getMessage());
        e.printStackTrace();
    }
}

// 4. 记录审计日志
...
```

**执行流程**：
1. 验证修复记录存在
2. 权限检查（只能撤回自己的申请）
3. 执行删除操作
4. **如果删除成功且状态为"待审批"，发送撤回通知**
5. 记录审计日志
6. 返回成功响应

**条件判断**：
- ✅ 只有状态为"待审批"的申请才发送撤回通知
- ✅ 已拒绝的申请删除时不发送通知（因为已经被拒绝了）
- ✅ 通知发送失败不影响删除操作

## 通知类型完整列表

### 修复相关通知

| 通知类型 | 标题 | 接收者 | 触发时机 | 实现状态 |
|---------|------|--------|---------|---------|
| REPAIR_APPLY | 新的修复申请 | 管理员、保管员 | 提交新申请 | ✅ |
| REPAIR_UPDATE | 修复申请已更新 | 管理员 | 修改待审批申请 | ✅ |
| REPAIR_WITHDRAW | 修复申请已撤回 | 管理员 | 撤回待审批申请 | ✅ |
| REPAIR_APPROVED | 修复申请已通过 | 申请人 | 审批通过 | ✅ |
| REPAIR_REJECTED | 修复申请已驳回 | 申请人 | 审批拒绝 | ✅ |
| REPAIR_COMPLETED | 修复已完成 | 申请人 | 完成修复 | ✅ |

## 业务逻辑

### 撤回场景
1. **保管员提交修复申请** → 管理员收到"新的修复申请"通知
2. **保管员修改申请** → 管理员收到"修复申请已更新"通知
3. **保管员撤回申请** → 管理员收到"修复申请已撤回"通知

### 审批场景
1. **管理员审批通过** → 申请人收到"修复申请已通过"通知
2. **管理员审批拒绝** → 申请人收到"修复申请已驳回"通知

### 完成场景
1. **修复完成** → 申请人收到"修复已完成"通知

## 权限控制

### 撤回权限
- ✅ 保管员只能撤回自己提交的申请
- ✅ 只能撤回待审批状态的申请
- ✅ 管理员可以删除任何状态的记录（但不会触发撤回通知）

### 通知接收权限
- ✅ 管理员接收所有修复相关的操作通知
- ✅ 申请人接收自己申请的审批结果和完成通知

## 异常处理

### 通知发送失败
```java
try {
    notificationService.sendRepairWithdrawNotification(...);
} catch (Exception e) {
    System.err.println("发送修复申请撤回通知失败: " + e.getMessage());
    e.printStackTrace();
}
```

**处理策略**：
- 通知发送失败不影响撤回操作
- 记录详细的错误日志
- 使用 try-catch 保护主流程

## 前端展示

### 通知列表
管理员在通知中心会看到：
```
标题：修复申请已撤回
内容：文物"青铜鼎"的修复申请已被撤回，原修复原因：表面氧化严重，需要清洗和防护处理。
时间：2026-04-28 23:30:00
```

### 通知操作
- 点击通知可以查看修复记录详情（如果记录还存在）
- 标记为已读
- 删除通知

## 测试建议

### 功能测试
1. 以保管员身份登录
2. 创建一个修复申请
3. 点击"撤回"按钮
4. 确认撤回
5. 以管理员身份登录
6. 检查是否收到撤回通知
7. 验证通知内容是否正确

### 权限测试
1. 测试撤回自己的申请（应该成功）
2. 测试撤回他人的申请（应该失败）
3. 测试撤回已审批的申请（应该失败）

### 异常测试
1. 测试通知服务异常时撤回操作是否正常
2. 测试网络异常时的处理
3. 测试并发撤回的情况

## 数据库影响

### 通知记录
撤回操作会在以下表中创建记录：
- `system_notification` - 系统通知表
- `user_notification` - 用户通知关联表

### 修复记录
撤回操作会删除以下表中的记录：
- `repair_record` - 修复记录表
- `repair_record_material` - 修复材料使用记录表（级联删除）

## 日志记录

### 操作日志
```
用户：张三（保管员）
操作：删除
模块：文物修复
内容：撤回修复申请
时间：2026-04-28 23:30:00
IP：192.168.1.100
```

### 通知日志
```
修复申请撤回通知已发送：repairId=123, relic=青铜鼎
```

## 总结

成功为修复申请撤回功能添加了通知机制，确保管理员能及时了解申请的撤回情况。这完善了修复管理的通知体系，提升了系统的可追溯性和用户体验。

### 关键特性
- ✅ 只在撤回待审批申请时发送通知
- ✅ 通知内容包含文物名称和原修复原因
- ✅ 通知发送失败不影响撤回操作
- ✅ 完整的权限控制和异常处理
- ✅ 详细的日志记录

### 用户价值
- 管理员能及时了解申请撤回情况
- 避免审批已撤回的申请
- 提高沟通效率
- 完善的操作追溯
