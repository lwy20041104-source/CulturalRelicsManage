# 审计日志增强实现文档

## 实施日期
2026-04-27

## 功能概述
增强审计日志系统，添加操作前后数据对比功能，记录详细的变更信息，便于审计和问题追溯。

---

## 一、功能特性

### 1.1 数据对比
- ✅ 记录操作前数据（before_data）
- ✅ 记录操作后数据（after_data）
- ✅ 自动识别变更字段
- ✅ JSON格式存储变更详情
- ✅ 支持字段级别对比

### 1.2 详细信息记录
- ✅ 用户ID和用户名
- ✅ 资源类型和资源ID
- ✅ 请求方法（GET/POST/PUT/DELETE）
- ✅ 请求URL和参数
- ✅ 响应数据
- ✅ 错误信息
- ✅ 执行时长
- ✅ 客户端信息（浏览器、操作系统）

### 1.3 数据展示
- ✅ 变更字段高亮显示
- ✅ 前后数据对比视图
- ✅ 操作历史时间线
- ✅ 资源操作历史查询

---

## 二、数据库设计

### 2.1 增强操作日志表

**新增字段**：
```sql
ALTER TABLE sys_operation_log ADD COLUMN
    user_id BIGINT,                    -- 操作用户ID
    resource_type VARCHAR(50),         -- 资源类型
    resource_id BIGINT,                -- 资源ID
    before_data TEXT,                  -- 操作前数据（JSON）
    after_data TEXT,                   -- 操作后数据（JSON）
    changed_fields TEXT,               -- 变更字段列表（JSON）
    request_method VARCHAR(10),        -- 请求方法
    request_url VARCHAR(500),          -- 请求URL
    request_params TEXT,               -- 请求参数（JSON）
    response_data TEXT,                -- 响应数据（JSON）
    error_message TEXT,                -- 错误信息
    execution_time BIGINT,             -- 执行时长（毫秒）
    user_agent VARCHAR(500),           -- 用户代理
    browser VARCHAR(50),               -- 浏览器
    os VARCHAR(50);                    -- 操作系统
```

**完整表结构**：
```sql
CREATE TABLE sys_operation_log (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    operator VARCHAR(50) NOT NULL,
    operation_type VARCHAR(50) NOT NULL,
    operation_module VARCHAR(50) NOT NULL,
    operation_content VARCHAR(1000),
    operation_result VARCHAR(20),
    ip_address VARCHAR(50),
    resource_type VARCHAR(50),
    resource_id BIGINT,
    before_data TEXT,
    after_data TEXT,
    changed_fields TEXT,
    request_method VARCHAR(10),
    request_url VARCHAR(500),
    request_params TEXT,
    response_data TEXT,
    error_message TEXT,
    execution_time BIGINT,
    user_agent VARCHAR(500),
    browser VARCHAR(50),
    os VARCHAR(50),
    operation_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_user_id (user_id),
    INDEX idx_operator (operator),
    INDEX idx_operation_time (operation_time),
    INDEX idx_resource (resource_type, resource_id),
    INDEX idx_operation_type (operation_type),
    INDEX idx_operation_result (operation_result)
);
```

### 2.2 数据变更详情表

**用途**：存储详细的字段级变更信息

```sql
CREATE TABLE sys_data_change_detail (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    log_id BIGINT NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    field_label VARCHAR(100),
    old_value TEXT,
    new_value TEXT,
    value_type VARCHAR(50),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_log_id (log_id),
    FOREIGN KEY (log_id) REFERENCES sys_operation_log(id) ON DELETE CASCADE
);
```

### 2.3 统计视图

**操作日志统计视图**：
```sql
CREATE VIEW v_operation_log_statistics AS
SELECT 
    DATE(operation_time) AS log_date,
    operation_type,
    operation_module,
    operation_result,
    COUNT(*) AS operation_count,
    COUNT(DISTINCT user_id) AS user_count,
    AVG(execution_time) AS avg_execution_time,
    MAX(execution_time) AS max_execution_time
FROM sys_operation_log
WHERE operation_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(operation_time), operation_type, operation_module, operation_result;
```

**用户操作统计视图**：
```sql
CREATE VIEW v_user_operation_statistics AS
SELECT 
    u.id AS user_id,
    u.username,
    u.real_name,
    COUNT(ol.id) AS total_operations,
    COUNT(CASE WHEN ol.operation_result = 'SUCCESS' THEN 1 END) AS success_count,
    COUNT(CASE WHEN ol.operation_result = 'FAIL' THEN 1 END) AS fail_count,
    MAX(ol.operation_time) AS last_operation_time
FROM sys_user u
LEFT JOIN sys_operation_log ol ON u.id = ol.user_id
WHERE ol.operation_time >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY u.id, u.username, u.real_name;
```

**资源操作历史视图**：
```sql
CREATE VIEW v_resource_operation_history AS
SELECT 
    ol.id,
    ol.resource_type,
    ol.resource_id,
    ol.operation_type,
    ol.operation_content,
    ol.operator,
    ol.user_id,
    ol.operation_time,
    ol.before_data,
    ol.after_data,
    ol.changed_fields
FROM sys_operation_log ol
WHERE ol.resource_type IS NOT NULL 
  AND ol.resource_id IS NOT NULL
ORDER BY ol.operation_time DESC;
```

---

## 三、后端实现

### 3.1 实体类

**SysOperationLog.java** - 已增强
```java
@Data
public class SysOperationLog {
    private Long id;
    private Long userId;
    private String operator;
    private String operationType;
    private String operationModule;
    private String operationContent;
    private String operationResult;
    private String ipAddress;
    
    // 资源信息
    private String resourceType;
    private Long resourceId;
    
    // 数据对比
    private String beforeData;
    private String afterData;
    private String changedFields;
    
    // 请求信息
    private String requestMethod;
    private String requestUrl;
    private String requestParams;
    private String responseData;
    private String errorMessage;
    private Long executionTime;
    
    // 客户端信息
    private String userAgent;
    private String browser;
    private String os;
    
    private LocalDateTime operationTime;
}
```

**DataChangeDetail.java** - 新增
```java
@Data
public class DataChangeDetail {
    private Long id;
    private Long logId;
    private String fieldName;
    private String fieldLabel;
    private String oldValue;
    private String newValue;
    private String valueType;
    private LocalDateTime createTime;
}
```

**DataChangeDTO.java** - 新增
```java
@Data
public class DataChangeDTO {
    private String field;
    private String label;
    private Object oldValue;
    private Object newValue;
    private String valueType;
    private Boolean changed;
}
```

### 3.2 工具类

**AuditLogUtil.java** - 新增

**核心方法**：
```java
// 比较两个对象的差异
public static List<DataChangeDTO> compareObjects(
    Object oldObj, 
    Object newObj, 
    Map<String, String> fieldLabels
)

// 将对象转换为JSON
public static String toJson(Object obj)

// 将变更列表转换为JSON
public static String changesToJson(List<DataChangeDTO> changes)

// 解析浏览器信息
public static String parseBrowser(String userAgent)

// 解析操作系统信息
public static String parseOS(String userAgent)
```

**字段标签映射**：
```java
// 文物字段标签
public static Map<String, String> createRelicFieldLabels()

// 借展字段标签
public static Map<String, String> createLoanFieldLabels()

// 修复字段标签
public static Map<String, String> createRepairFieldLabels()
```

### 3.3 Service层

**新增方法**：
```java
// 记录增强的操作日志
void logEnhanced(SysOperationLog log);

// 记录数据变更（自动对比）
void logDataChange(
    Long userId, String operator, String operationType, 
    String operationModule, String resourceType, Long resourceId,
    Object beforeData, Object afterData,
    String ipAddress, String requestMethod, String requestUrl
);

// 获取资源操作历史
List<SysOperationLog> getResourceHistory(String resourceType, Long resourceId);

// 获取变更详情
List<DataChangeDetail> getChangeDetails(Long logId);

// 获取用户操作统计
List<Object> getUserOperationStatistics(int days);

// 获取操作类型统计
List<Object> getOperationTypeStatistics(int days);

// 清理旧日志
int cleanOldLogs(int days);
```

---

## 四、使用示例

### 4.1 记录文物修改日志

```java
@PutMapping("/{id}")
public Result<Relic> update(@PathVariable Long id, @RequestBody Relic relic) {
    // 获取修改前的数据
    Relic oldRelic = relicService.getById(id);
    
    // 执行更新
    relic.setId(id);
    relicService.update(relic);
    
    // 记录审计日志
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

### 4.2 查询资源操作历史

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

### 4.3 查看变更详情

```java
@GetMapping("/changes/{logId}")
public Result<List<DataChangeDetail>> getChanges(@PathVariable Long logId) {
    List<DataChangeDetail> changes = operationLogService.getChangeDetails(logId);
    return Result.success(changes);
}
```

---

## 五、数据格式示例

### 5.1 before_data（操作前数据）

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

### 5.2 after_data（操作后数据）

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

### 5.3 changed_fields（变更字段）

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

---

## 六、前端展示

### 6.1 操作日志列表

**显示字段**：
- 操作时间
- 操作人
- 操作类型
- 操作模块
- 操作内容
- 操作结果
- IP地址
- 执行时长
- 操作（查看详情）

### 6.2 日志详情对话框

**基本信息**：
- 操作人、操作时间、IP地址
- 浏览器、操作系统
- 请求方法、请求URL
- 执行时长、操作结果

**数据对比**：
- 并排显示操作前后数据
- 高亮显示变更字段
- 支持JSON格式化显示

**变更列表**：
- 表格形式展示所有变更
- 字段名、旧值、新值
- 变更类型标识

### 6.3 资源操作历史

**时间线展示**：
- 按时间倒序显示所有操作
- 每个操作显示简要信息
- 点击展开查看详细变更
- 支持筛选操作类型

---

## 七、存储过程

### 7.1 清理旧日志

```sql
CALL sp_clean_old_logs(90);  -- 清理90天前的日志
```

### 7.2 获取资源历史

```sql
CALL sp_get_resource_history('RELIC', 1);  -- 获取文物ID=1的操作历史
```

---

## 八、性能优化

### 8.1 索引优化
- ✅ user_id索引（按用户查询）
- ✅ operation_time索引（按时间查询）
- ✅ resource_type + resource_id复合索引（按资源查询）
- ✅ operation_type索引（按类型统计）

### 8.2 数据归档
- 定期归档旧日志到历史表
- 保留最近3-6个月的热数据
- 历史数据压缩存储

### 8.3 异步记录
- 使用消息队列异步记录日志
- 避免影响主业务性能
- 批量写入提高效率

---

## 九、安全建议

### 9.1 敏感数据脱敏
- 密码字段不记录
- 身份证号部分隐藏
- 手机号部分隐藏
- 银行卡号部分隐藏

### 9.2 访问控制
- 只有管理员可以查看所有日志
- 普通用户只能查看自己的操作日志
- 审计员有只读权限

### 9.3 日志保护
- 日志不可修改
- 日志不可删除（除非超过保留期）
- 记录日志访问行为

---

## 十、使用步骤

### 10.1 执行数据库脚本

```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_enhancement.sql
```

### 10.2 重启后端服务

```bash
cd backend
mvn clean compile
mvn spring-boot:run
```

### 10.3 测试功能

**测试数据对比**：
1. 修改一个文物信息
2. 查看操作日志
3. 点击查看详情
4. 查看数据对比

**测试操作历史**：
1. 选择一个文物
2. 查看操作历史
3. 查看时间线展示

---

## 十一、后续优化

### 11.1 功能增强
- [ ] 支持批量操作的日志记录
- [ ] 支持关联操作的日志链路追踪
- [ ] 支持日志导出（Excel、PDF）
- [ ] 支持日志搜索和高级筛选
- [ ] 支持日志告警（异常操作）

### 11.2 可视化
- [ ] 操作趋势图表
- [ ] 用户活跃度分析
- [ ] 操作热力图
- [ ] 异常操作检测

### 11.3 审计报告
- [ ] 自动生成审计报告
- [ ] 合规性检查
- [ ] 风险评估
- [ ] 操作审计追溯

---

## 十二、相关文档

- [数据库脚本](../sql/audit_log_enhancement.sql)
- [实体类](../src/main/java/com/example/entity/SysOperationLog.java)
- [工具类](../src/main/java/com/example/util/AuditLogUtil.java)
- [Service接口](../src/main/java/com/example/service/SysOperationLogService.java)

---

**状态**: ✅ 数据库完成，后端部分完成，前端待实现  
**优先级**: P2（中）  
**预计工作量**: 数据库1小时，后端3小时，前端4小时  
**测试**: ⏳ 待测试

---

**最后更新**: 2026-04-27  
**文档版本**: 1.0  
**作者**: Kiro AI Assistant
