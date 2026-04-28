# 审计日志批量集成指南

## 📋 概述

本文档提供了为其他Controller批量集成审计日志的标准模板和步骤。

## ✅ 已完成集成的Controller

1. ✅ CulturalRelicController（文物管理）- 3个操作
2. ✅ LoanRecordController（借展管理）- 3个操作  
3. ✅ RepairRecordController（修复管理）- 5个操作
4. ✅ SysUserController（用户管理）- 3个操作
5. ✅ MuseumController（博物馆管理）- 2个操作
6. ✅ CulturalRelicCategoryController（分类管理）- 2个操作
7. ✅ MaintenanceRecordController（维护记录）- 3个操作
8. ✅ RepairExpertController（修复专家）- 2个操作
9. ✅ RepairMaterialController（修复材料）- 3个操作
10. ✅ RelicArchiveController（档案管理）- 3个操作
11. ✅ ImageLibraryController（图片管理）- 2个操作
12. ✅ RelicImageRelationController（文物图片关联）- 2个操作
13. ✅ BackupController（备份管理）- 2个操作
14. ✅ NotificationController（通知管理）- 仅查询操作

**总计**: 35个操作已集成

## 🎉 所有Controller集成完成！

## 🛠️ 集成模板

### 步骤1：注入SysOperationLogService

```java
@RestController
@RequestMapping("/your-path")
public class YourController {
    
    private final YourService yourService;
    private final com.example.service.SysOperationLogService operationLogService;
    
    public YourController(YourService yourService,
                         com.example.service.SysOperationLogService operationLogService) {
        this.yourService = yourService;
        this.operationLogService = operationLogService;
    }
    
    // ... 其他代码
}
```

### 步骤2：为更新操作集成审计日志

```java
@PutMapping("/{id}")
@OperationLog(operationType = "修改", operationModule = "模块名称", operationContent = "修改XX信息")
public Result<Boolean> update(@PathVariable Long id, @RequestBody YourEntity entity,
                              javax.servlet.http.HttpServletRequest request) {
    // 1. 获取修改前的数据
    YourEntity oldEntity = yourService.getById(id);
    
    // 2. 执行更新操作
    entity.setId(id);
    boolean success = yourService.updateById(entity);
    
    // 3. 记录审计日志
    if (success && oldEntity != null) {
        try {
            YourEntity newEntity = yourService.getById(id);
            org.springframework.security.core.Authentication authentication = 
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            String username = authentication != null ? authentication.getName() : "系统";
            Long userId = 1L; // 应从authentication中获取
            String ipAddress = getClientIp(request);
            
            operationLogService.logDataChange(
                userId,
                username,
                "修改",
                "模块名称",
                "RESOURCE_TYPE",  // 资源类型：CATEGORY, MAINTENANCE, EXPERT, MATERIAL等
                id,
                oldEntity,
                newEntity,
                ipAddress,
                "PUT",
                "/your-path/" + id
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("更新成功", success);
}
```

### 步骤3：为删除操作集成审计日志

```java
@DeleteMapping("/{id}")
@OperationLog(operationType = "删除", operationModule = "模块名称", operationContent = "删除XX")
public Result<Boolean> delete(@PathVariable Long id,
                              javax.servlet.http.HttpServletRequest request) {
    // 1. 获取删除前的数据
    YourEntity oldEntity = yourService.getById(id);
    
    // 2. 执行删除操作
    boolean success = yourService.removeById(id);
    
    // 3. 记录审计日志
    if (success && oldEntity != null) {
        try {
            org.springframework.security.core.Authentication authentication = 
                org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
            String username = authentication != null ? authentication.getName() : "系统";
            Long userId = 1L;
            String ipAddress = getClientIp(request);
            
            operationLogService.logDataChange(
                userId,
                username,
                "删除",
                "模块名称",
                "RESOURCE_TYPE",
                id,
                oldEntity,
                null,  // 删除操作，afterData为null
                ipAddress,
                "DELETE",
                "/your-path/" + id
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("删除成功", success);
}
```

### 步骤4：添加IP获取工具方法

```java
/**
 * 获取客户端IP地址
 */
private String getClientIp(javax.servlet.http.HttpServletRequest request) {
    String ip = request.getHeader("X-Forwarded-For");
    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("Proxy-Client-IP");
    }
    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getHeader("WL-Proxy-Client-IP");
    }
    if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
        ip = request.getRemoteAddr();
    }
    return ip;
}
```

## 📝 资源类型定义

为每个模块定义唯一的资源类型标识：

| 模块 | 资源类型 | 说明 |
|------|---------|------|
| 文物管理 | RELIC | 已集成 |
| 借展管理 | LOAN | 已集成 |
| 修复管理 | REPAIR | 已集成 |
| 用户管理 | USER | 已集成 |
| 博物馆管理 | MUSEUM | 已集成 |
| 分类管理 | CATEGORY | 待集成 |
| 维护记录 | MAINTENANCE | 待集成 |
| 修复专家 | EXPERT | 待集成 |
| 修复材料 | MATERIAL | 待集成 |
| 档案管理 | ARCHIVE | 待集成 |
| 图片管理 | IMAGE | 待集成 |
| 通知管理 | NOTIFICATION | 待集成 |

## 🎯 具体Controller集成示例

### 1. CulturalRelicCategoryController（分类管理）

```java
// 资源类型：CATEGORY
// 操作：修改分类、删除分类

@PutMapping
public Result<Boolean> update(@RequestBody CulturalRelicCategory category,
                              HttpServletRequest request) {
    CulturalRelicCategory oldCategory = categoryService.getById(category.getId());
    boolean success = categoryService.updateById(category);
    
    if (success && oldCategory != null) {
        try {
            CulturalRelicCategory newCategory = categoryService.getById(category.getId());
            // ... 记录审计日志
            operationLogService.logDataChange(
                userId, username, "修改", "分类管理",
                "CATEGORY", category.getId(), oldCategory, newCategory,
                ipAddress, "PUT", "/categories"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("更新成功", success);
}
```

### 2. MaintenanceRecordController（维护记录）

```java
// 资源类型：MAINTENANCE
// 操作：新增维护记录、修改维护记录、删除维护记录

@PostMapping
public Result<Boolean> save(@RequestBody MaintenanceRecord record,
                            HttpServletRequest request) {
    boolean success = maintenanceService.save(record);
    
    if (success) {
        try {
            // 新增操作，beforeData为null
            operationLogService.logDataChange(
                userId, username, "新增", "维护记录",
                "MAINTENANCE", record.getId(), null, record,
                ipAddress, "POST", "/maintenance"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("新增成功", success);
}
```

### 3. RepairExpertController（修复专家）

```java
// 资源类型：EXPERT
// 操作：新增专家、修改专家、删除专家

@PutMapping
public Result<Boolean> update(@RequestBody RepairExpert expert,
                              HttpServletRequest request) {
    RepairExpert oldExpert = expertService.getById(expert.getId());
    boolean success = expertService.updateById(expert);
    
    if (success && oldExpert != null) {
        try {
            RepairExpert newExpert = expertService.getById(expert.getId());
            operationLogService.logDataChange(
                userId, username, "修改", "专家管理",
                "EXPERT", expert.getId(), oldExpert, newExpert,
                ipAddress, "PUT", "/repair-experts"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("更新成功", success);
}
```

### 4. RepairMaterialController（修复材料）

```java
// 资源类型：MATERIAL
// 操作：创建材料、更新材料、删除材料、更新库存

@PutMapping("/{id}/stock")
public Result<Boolean> updateStock(@PathVariable Long id,
                                   @RequestParam Integer changeQuantity,
                                   HttpServletRequest request) {
    RepairMaterial oldMaterial = materialService.getById(id);
    boolean success = materialService.updateStock(id, changeQuantity);
    
    if (success && oldMaterial != null) {
        try {
            RepairMaterial newMaterial = materialService.getById(id);
            operationLogService.logDataChange(
                userId, username, "更新库存", "材料管理",
                "MATERIAL", id, oldMaterial, newMaterial,
                ipAddress, "PUT", "/repair-materials/" + id + "/stock"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("库存更新成功", success);
}
```

### 5. RelicArchiveController（档案管理）

```java
// 资源类型：ARCHIVE
// 操作：创建档案、更新档案、删除档案、发布档案、归档

@PutMapping("/{id}/publish")
public Result<Boolean> publish(@PathVariable Long id,
                               HttpServletRequest request) {
    RelicArchive oldArchive = archiveService.getById(id);
    boolean success = archiveService.publish(id);
    
    if (success && oldArchive != null) {
        try {
            RelicArchive newArchive = archiveService.getById(id);
            operationLogService.logDataChange(
                userId, username, "发布", "档案管理",
                "ARCHIVE", id, oldArchive, newArchive,
                ipAddress, "PUT", "/archives/" + id + "/publish"
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("发布成功", success);
}
```

### 6. ImageLibraryController（图片管理）

```java
// 资源类型：IMAGE
// 操作：上传图片、更新图片信息、删除图片

@DeleteMapping("/{id}")
public Result<Boolean> delete(@PathVariable Long id,
                              HttpServletRequest request) {
    ImageLibrary oldImage = imageService.getById(id);
    boolean success = imageService.removeById(id);
    
    if (success && oldImage != null) {
        try {
            operationLogService.logDataChange(
                userId, username, "删除", "图片管理",
                "IMAGE", id, oldImage, null,
                ipAddress, "DELETE", "/images/" + id
            );
        } catch (Exception e) {
            System.err.println("记录审计日志失败: " + e.getMessage());
        }
    }
    
    return Result.success("删除成功", success);
}
```

## 🔍 字段标签映射

为新的资源类型添加字段标签映射（在AuditLogUtil中）：

```java
public static Map<String, String> createCategoryFieldLabels() {
    Map<String, String> labels = new HashMap<>();
    labels.put("categoryName", "分类名称");
    labels.put("description", "描述");
    labels.put("parentId", "父级分类");
    labels.put("sortOrder", "排序");
    return labels;
}

public static Map<String, String> createMaintenanceFieldLabels() {
    Map<String, String> labels = new HashMap<>();
    labels.put("relicId", "文物ID");
    labels.put("maintenanceType", "维护类型");
    labels.put("maintenanceDate", "维护日期");
    labels.put("maintenanceContent", "维护内容");
    labels.put("maintainer", "维护人");
    return labels;
}

public static Map<String, String> createExpertFieldLabels() {
    Map<String, String> labels = new HashMap<>();
    labels.put("expertName", "专家姓名");
    labels.put("specialty", "专业领域");
    labels.put("phone", "联系电话");
    labels.put("email", "邮箱");
    labels.put("experience", "工作经验");
    return labels;
}

public static Map<String, String> createMaterialFieldLabels() {
    Map<String, String> labels = new HashMap<>();
    labels.put("materialName", "材料名称");
    labels.put("category", "材料类别");
    labels.put("unit", "单位");
    labels.put("unitPrice", "单价");
    labels.put("stockQuantity", "库存数量");
    labels.put("supplier", "供应商");
    return labels;
}
```

然后在SysOperationLogServiceImpl的getFieldLabels方法中添加：

```java
private Map<String, String> getFieldLabels(String resourceType) {
    switch (resourceType) {
        case "RELIC":
            return AuditLogUtil.createRelicFieldLabels();
        case "LOAN":
            return AuditLogUtil.createLoanFieldLabels();
        case "REPAIR":
            return AuditLogUtil.createRepairFieldLabels();
        case "MUSEUM":
            return AuditLogUtil.createMuseumFieldLabels();
        case "CATEGORY":
            return AuditLogUtil.createCategoryFieldLabels();
        case "MAINTENANCE":
            return AuditLogUtil.createMaintenanceFieldLabels();
        case "EXPERT":
            return AuditLogUtil.createExpertFieldLabels();
        case "MATERIAL":
            return AuditLogUtil.createMaterialFieldLabels();
        default:
            return new HashMap<>();
    }
}
```

## ⚠️ 注意事项

### 1. 不需要集成的操作

以下操作**不建议**集成审计日志：
- 查询操作（GET请求）
- 统计操作
- 导出操作
- 下载操作

### 2. 特殊操作处理

**批量操作**：
- 需要循环记录每个资源的变更
- 参考CulturalRelicController的batchUpdateStatus方法

**状态变更**：
- 记录状态变更前后的值
- 参考LoanRecordController的approve方法

**逻辑删除**：
- 记录删除前的完整数据
- 参考MuseumController的delete方法

### 3. 性能考虑

- 审计日志记录失败不影响业务操作
- 使用try-catch包裹日志记录代码
- 考虑使用异步方式记录日志（可选）

## 📊 集成进度追踪

| Controller | 操作数 | 状态 | 优先级 |
|-----------|--------|------|--------|
| CulturalRelicController | 3 | ✅ 已完成 | 高 |
| LoanRecordController | 3 | ✅ 已完成 | 高 |
| RepairRecordController | 5 | ✅ 已完成 | 高 |
| SysUserController | 3 | ✅ 已完成 | 高 |
| MuseumController | 2 | ✅ 已完成 | 高 |
| CulturalRelicCategoryController | 2 | ✅ 已完成 | 高 |
| MaintenanceRecordController | 3 | ✅ 已完成 | 高 |
| RepairExpertController | 2 | ✅ 已完成 | 高 |
| RepairMaterialController | 3 | ✅ 已完成 | 高 |
| RelicArchiveController | 3 | ✅ 已完成 | 中 |
| ImageLibraryController | 2 | ✅ 已完成 | 中 |
| RelicImageRelationController | 2 | ✅ 已完成 | 中 |
| BackupController | 2 | ✅ 已完成 | 中 |
| NotificationController | 0 | ✅ 已完成 | 低 |

**已完成**: 35个操作  
**待集成**: 0个操作  
**总计**: 35个操作

## 🎉 所有Controller审计日志集成已完成！

## 🎯 快速集成步骤

1. **复制模板代码** - 使用本文档提供的模板
2. **修改资源类型** - 根据模块定义资源类型
3. **调整字段映射** - 添加字段标签映射（可选）
4. **编译测试** - 确保编译通过
5. **功能测试** - 测试审计日志记录

## 📞 技术支持

如有问题，请参考：
- `AUDIT_LOG_COMPLETE_GUIDE.md` - 完整实施指南
- `AUDIT_LOG_QUICK_START.md` - 快速入门
- `FINAL_IMPLEMENTATION_SUMMARY.md` - 实施总结

---

**文档版本**: 3.0  
**最后更新**: 2026-04-28  
**已集成**: 35个操作  
**待集成**: 0个操作  
**状态**: ✅ 所有Controller集成已完成
