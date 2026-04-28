# 修复申请编辑功能改进

## 问题修复

### 1. 文物名称显示问题

**问题描述**：
编辑修复申请时，文物选择器显示的是文物ID而不是文物名称。

**原因分析**：
- `getAvailableForRepairApi()` 只返回可用于修复的文物（没有正在进行修复的文物）
- 当前正在编辑的文物已经有一个待审批的修复记录，因此不在可用列表中
- 导致 `el-select` 组件无法找到对应的选项，只能显示绑定的值（文物ID）

**解决方案**：
在 `openEdit` 函数中，检查当前文物是否在选项列表中，如果不在则将其添加到列表开头。

**修改文件**：`frontend/src/views/RepairsView.vue`

```javascript
const openEdit = async (row) => {
  // ... 加载材料列表 ...
  
  // 确保当前文物在选项列表中
  const currentRelicInOptions = relicOptions.value.some(r => r.id === row.relicId)
  if (!currentRelicInOptions && row.relicId && row.relicName) {
    // 将当前文物添加到选项列表的开头
    relicOptions.value.unshift({
      id: row.relicId,
      relicName: row.relicName,
      relicCode: row.relicCode || ''
    })
  }
  
  // ... 填充表单数据 ...
}
```

**效果**：
- ✅ 编辑时正确显示文物名称和编号
- ✅ 可以选择其他可用文物
- ✅ 当前文物始终在选项列表中

---

### 2. 修改申请通知功能

**需求描述**：
当保管员修改修复申请时，应该向系统管理员发送通知，提醒其重新审核。

**实现方案**：

#### 2.1 后端 - Service 层

**文件**：`backend/src/main/java/com/example/service/NotificationService.java`

添加新的接口方法：
```java
/**
 * 发送修复申请更新通知
 * 
 * @param repairId 修复记录ID
 * @param relicName 文物名称
 * @param repairReason 修复原因
 * @param senderId 发送人ID
 */
void sendRepairUpdateNotification(Long repairId, String relicName, String repairReason, Long senderId);
```

**文件**：`backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

实现通知发送逻辑：
```java
@Override
public void sendRepairUpdateNotification(Long repairId, String relicName, String repairReason, Long senderId) {
    SystemNotification notification = new SystemNotification();
    notification.setTitle("修复申请已更新");
    notification.setContent(String.format("文物\"%s\"的修复申请已更新，修复原因：%s，请重新审核。", relicName, repairReason));
    notification.setType("REPAIR_UPDATE");
    notification.setPriority("NORMAL");
    notification.setRelatedType("REPAIR");
    notification.setRelatedId(repairId);
    notification.setSenderId(senderId);
    
    // 发送给系统管理员
    createAndSendNotification(notification, Arrays.asList("ADMIN"));
}
```

**通知特性**：
- 标题：修复申请已更新
- 内容：包含文物名称、修复原因
- 类型：REPAIR_UPDATE
- 优先级：NORMAL
- 接收者：系统管理员（ADMIN角色）

#### 2.2 后端 - Controller 层

**文件**：`backend/src/main/java/com/example/controller/RepairRecordController.java`

在 `updateRepairApply` 方法中添加通知发送：
```java
// 6. 发送更新通知
if (success) {
    try {
        RepairRecord updatedRecord = repairRecordService.getById(id);
        Long currentUserId = userContextUtil.getCurrentUserId();
        
        notificationService.sendRepairUpdateNotification(
            id,
            updatedRecord.getRelicName() != null ? updatedRecord.getRelicName() : "未知文物",
            updatedRecord.getRepairReason(),
            currentUserId
        );
        System.out.println("修复申请更新通知已发送：repairId=" + id + ", relic=" + updatedRecord.getRelicName());
    } catch (Exception e) {
        System.err.println("发送修复申请更新通知失败: " + e.getMessage());
        e.printStackTrace();
    }
}
```

**执行流程**：
1. 更新修复申请成功后
2. 查询更新后的记录（包含文物名称）
3. 获取当前用户ID作为发送人
4. 调用通知服务发送通知
5. 记录日志（成功或失败）

**异常处理**：
- 通知发送失败不影响更新操作
- 记录错误日志便于排查问题
- 使用 try-catch 确保主流程不被中断

---

## 功能对比

### 修改前
| 功能 | 状态 | 说明 |
|------|------|------|
| 编辑时显示文物名称 | ❌ | 显示文物ID |
| 修改申请发送通知 | ❌ | 无通知 |

### 修改后
| 功能 | 状态 | 说明 |
|------|------|------|
| 编辑时显示文物名称 | ✅ | 正确显示文物名称和编号 |
| 修改申请发送通知 | ✅ | 向管理员发送更新通知 |

---

## 通知类型总结

### 修复相关通知

| 通知类型 | 标题 | 接收者 | 触发时机 |
|---------|------|--------|---------|
| REPAIR_APPLY | 新的修复申请 | 管理员、保管员 | 提交新申请 |
| REPAIR_UPDATE | 修复申请已更新 | 管理员 | 修改待审批申请 |
| REPAIR_APPROVED | 修复申请已通过 | 申请人 | 审批通过 |
| REPAIR_REJECTED | 修复申请已驳回 | 申请人 | 审批拒绝 |
| REPAIR_COMPLETED | 修复已完成 | 申请人 | 完成修复 |

---

## 测试建议

### 文物名称显示测试
1. 创建一个修复申请
2. 点击"编辑"按钮
3. 验证文物选择器显示正确的文物名称和编号
4. 尝试切换到其他文物
5. 保存修改

### 通知功能测试
1. 以保管员身份登录
2. 编辑一个待审批的修复申请
3. 修改修复原因或其他信息
4. 提交修改
5. 以管理员身份登录
6. 检查是否收到"修复申请已更新"通知
7. 验证通知内容是否包含文物名称和修复原因
8. 点击通知应该能跳转到修复详情页

### 权限测试
1. 验证只有申请人能编辑自己的申请
2. 验证只能编辑待审批状态的申请
3. 验证通知只发送给管理员

---

## 代码改动总结

### 后端文件
1. `NotificationService.java` - 添加接口方法
2. `NotificationServiceImpl.java` - 实现通知发送
3. `RepairRecordController.java` - 调用通知服务

### 前端文件
1. `RepairsView.vue` - 修复文物名称显示问题

### 改动统计
- 新增方法：2个（接口 + 实现）
- 修改方法：2个（openEdit + updateRepairApply）
- 代码行数：约50行

---

## 用户体验改进

### 编辑体验
- ✅ 文物名称清晰可读
- ✅ 表单数据完整加载
- ✅ 材料列表正确显示
- ✅ 操作流程顺畅

### 通知体验
- ✅ 管理员及时收到更新通知
- ✅ 通知内容详细明确
- ✅ 可以快速跳转到详情页
- ✅ 避免遗漏审核更新的申请

---

## 总结

本次改进解决了两个重要问题：
1. **文物名称显示问题**：通过在编辑时动态添加当前文物到选项列表，确保正确显示文物名称
2. **通知功能完善**：添加修改申请通知，确保管理员能及时了解申请变更

这些改进提升了系统的可用性和用户体验，使修复管理流程更加完善。
