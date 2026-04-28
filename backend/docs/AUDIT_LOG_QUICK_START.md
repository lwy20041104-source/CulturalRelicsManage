# 审计日志增强 - 快速入门指南

## 一、执行数据库脚本

```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_enhancement.sql
```

**脚本功能**：
- ✅ 为sys_operation_log表添加16个新字段
- ✅ 创建sys_data_change_detail表
- ✅ 创建3个统计视图
- ✅ 创建2个存储过程
- ✅ 添加索引优化
- ✅ 插入示例数据

## 二、重启后端服务

```bash
cd backend
mvn clean compile
mvn spring-boot:run
```

## 三、使用示例

### 3.1 在Controller中记录数据变更

**示例：文物修改**

```java
@PutMapping("/{id}")
@OperationLog(operationType = "修改", operationModule = "文物管理", operationContent = "修改文物信息")
public Result<CulturalRelic> update(@PathVariable Long id, @RequestBody CulturalRelic relic, HttpSession session) {
    // 1. 获取修改前的数据
    CulturalRelic oldRelic = relicService.getById(id);
    
    // 2. 执行更新操作
    relic.setId(id);
    relicService.update(relic);
    
    // 3. 记录审计日志（包含数据对比）
    Long userId = (Long) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    String ipAddress = getIpAddress(request);
    
    operationLogService.logDataChange(
        userId,                    // 用户ID
        username,                  // 用户名
        "修改",                    // 操作类型
        "文物管理",                // 操作模块
        "RELIC",                   // 资源类型
        id,                        // 资源ID
        oldRelic,                  // 修改前数据
        relic,                     // 修改后数据
        ipAddress,                 // IP地址
        "PUT",                     // 请求方法
        "/api/relics/" + id        // 请求URL
    );
    
    return Result.success(relic);
}
```

**示例：借展审批**

```java
@PostMapping("/approve")
@OperationLog(operationType = "审批", operationModule = "借展管理", operationContent = "审批借展申请")
public Result<Void> approve(@RequestBody LoanApproveRequest request, HttpSession session) {
    // 1. 获取审批前的数据
    LoanRecord oldLoan = loanService.getById(request.getId());
    
    // 2. 执行审批操作
    loanService.approve(request);
    
    // 3. 获取审批后的数据
    LoanRecord newLoan = loanService.getById(request.getId());
    
    // 4. 记录审计日志
    Long userId = (Long) session.getAttribute("userId");
    String username = (String) session.getAttribute("username");
    String ipAddress = getIpAddress(request);
    
    operationLogService.logDataChange(
        userId,
        username,
        "审批",
        "借展管理",
        "LOAN",
        request.getId(),
        oldLoan,
        newLoan,
        ipAddress,
        "POST",
        "/api/loans/approve"
    );
    
    return Result.success("审批成功", null);
}
```

### 3.2 查询资源操作历史

```java
@GetMapping("/history/{resourceType}/{resourceId}")
public Result<List<SysOperationLog>> getHistory(
    @PathVariable String resourceType,
    @PathVariable Long resourceId
) {
    List<SysOperationLog> history = operationLogService.getResourceHistory(
        resourceType, 
        resourceId
    );
    return Result.success(history);
}
```

### 3.3 查看变更详情

```java
@GetMapping("/changes/{logId}")
public Result<List<DataChangeDetail>> getChanges(@PathVariable Long logId) {
    List<DataChangeDetail> changes = operationLogService.getChangeDetails(logId);
    return Result.success(changes);
}
```

## 四、数据格式说明

### 4.1 before_data（操作前数据）

```json
{
  "id": 1,
  "relicName": "商代青铜鼎",
  "relicCode": "CR2026001",
  "status": "正常",
  "location": "展厅A-001",
  "description": "商代晚期青铜器"
}
```

### 4.2 after_data（操作后数据）

```json
{
  "id": 1,
  "relicName": "商代青铜鼎",
  "relicCode": "CR2026001",
  "status": "维护中",
  "location": "修复室-101",
  "description": "商代晚期青铜器，需要修复"
}
```

### 4.3 changed_fields（变更字段）

```json
[
  {
    "field": "status",
    "label": "状态",
    "oldValue": "正常",
    "newValue": "维护中",
    "valueType": "STRING",
    "changed": true
  },
  {
    "field": "location",
    "label": "位置",
    "oldValue": "展厅A-001",
    "newValue": "修复室-101",
    "valueType": "STRING",
    "changed": true
  },
  {
    "field": "description",
    "label": "描述",
    "oldValue": "商代晚期青铜器",
    "newValue": "商代晚期青铜器，需要修复",
    "valueType": "STRING",
    "changed": true
  }
]
```

## 五、工具类使用

### 5.1 手动比较对象差异

```java
import com.example.util.AuditLogUtil;
import com.example.dto.DataChangeDTO;

// 创建字段标签映射
Map<String, String> fieldLabels = AuditLogUtil.createRelicFieldLabels();

// 比较两个对象
List<DataChangeDTO> changes = AuditLogUtil.compareObjects(
    oldRelic,      // 旧对象
    newRelic,      // 新对象
    fieldLabels    // 字段标签映射
);

// 转换为JSON
String changesJson = AuditLogUtil.changesToJson(changes);
```

### 5.2 解析客户端信息

```java
String userAgent = request.getHeader("User-Agent");

// 解析浏览器
String browser = AuditLogUtil.parseBrowser(userAgent);
// 结果: "Chrome", "Firefox", "Edge", "Safari" 等

// 解析操作系统
String os = AuditLogUtil.parseOS(userAgent);
// 结果: "Windows 10", "Mac OS X", "Linux", "Android" 等
```

## 六、数据库查询示例

### 6.1 查询资源操作历史

```sql
-- 查询文物ID=1的所有操作历史
SELECT * FROM sys_operation_log
WHERE resource_type = 'RELIC' AND resource_id = 1
ORDER BY operation_time DESC;
```

### 6.2 查询用户操作统计

```sql
-- 查询最近30天的用户操作统计
SELECT * FROM v_user_operation_statistics;
```

### 6.3 查询操作类型统计

```sql
-- 查询最近30天的操作统计
SELECT * FROM v_operation_log_statistics
ORDER BY log_date DESC, operation_count DESC;
```

### 6.4 清理旧日志

```sql
-- 清理90天前的日志
CALL sp_clean_old_logs(90);
```

## 七、注意事项

### 7.1 性能考虑
- ✅ 数据对比在内存中进行，速度快
- ✅ JSON存储占用空间较大，建议定期清理旧日志
- ✅ 建议只对重要操作记录详细日志

### 7.2 字段标签映射
- ✅ 需要为每种资源类型创建字段标签映射
- ✅ 标签用于前端显示，提高可读性
- ✅ 可以在AuditLogUtil中添加更多映射方法

### 7.3 敏感数据
- ⚠️ 密码字段不应记录
- ⚠️ 身份证号等敏感信息应脱敏
- ⚠️ 可以在compareObjects方法中添加字段过滤

## 八、常见问题

### Q1: 如何跳过某些字段不记录？
**A**: 在AuditLogUtil.shouldSkipField()方法中添加字段名：
```java
Set<String> skipFields = new HashSet<>(Arrays.asList(
    "id", "createTime", "updateTime", "password", "token"
));
```

### Q2: 如何自定义字段标签？
**A**: 创建自己的字段标签映射：
```java
Map<String, String> labels = new HashMap<>();
labels.put("fieldName", "字段中文名");
```

### Q3: 如何查看某个文物的完整操作历史？
**A**: 使用资源操作历史视图：
```sql
SELECT * FROM v_resource_operation_history
WHERE resource_type = 'RELIC' AND resource_id = 1;
```

### Q4: 日志数据太多怎么办？
**A**: 定期清理旧日志：
```sql
-- 清理6个月前的日志
CALL sp_clean_old_logs(180);
```

## 九、下一步

### 9.1 前端集成
- [ ] 创建操作日志详情对话框
- [ ] 实现数据对比展示组件
- [ ] 添加操作历史时间线
- [ ] 实现日志搜索和筛选

### 9.2 功能增强
- [ ] 添加更多资源类型的字段映射
- [ ] 实现敏感数据自动脱敏
- [ ] 添加日志导出功能
- [ ] 实现异常操作告警

### 9.3 性能优化
- [ ] 实现异步日志记录
- [ ] 添加日志归档功能
- [ ] 优化大数据量查询

---

**状态**: ✅ 后端已完成  
**编译**: ✅ 成功  
**测试**: ⏳ 待测试  

**最后更新**: 2026-04-27
