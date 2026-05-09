# 需求文档：3D模型管理审计日志功能

## 介绍

本文档定义了文物管理系统中3D模型管理功能的审计日志需求。当前系统已经为文物、借展、修复、维护等模块实现了完整的审计日志功能，包括操作前后数据对比、变更字段展示等。但是3D模型管理功能（上传、保存链接、删除3D模型）尚未实现审计日志。

本需求旨在为3D模型管理的所有修改操作添加审计日志，确保系统能够追踪3D模型的完整变更历史，包括谁在什么时间、从什么IP地址进行了什么操作，以及操作前后的数据对比。

## 术语表

- **Audit_Log_System**: 审计日志系统，负责记录和存储所有操作日志
- **3D_Model_Controller**: 3D模型管理控制器（Relic3DController），处理3D模型的上传、保存链接、删除操作
- **Operation_Log_Service**: 操作日志服务（SysOperationLogService），提供日志记录的核心方法
- **Cultural_Relic**: 文物实体，包含3D模型相关字段（model3dUrl、model3dUploadTime）
- **Before_Data**: 操作前的完整数据快照（JSON格式）
- **After_Data**: 操作后的完整数据快照（JSON格式）
- **Changed_Fields**: 变更字段列表（JSON格式），包含字段名、中文标签、旧值、新值
- **Field_Label_Mapping**: 字段标签映射，将数据库字段名映射为中文显示名称
- **Client_IP**: 客户端IP地址，标识操作来源
- **User_Agent**: 用户代理字符串，包含浏览器和操作系统信息

## 需求

### 需求 1: 上传3D模型文件的审计日志

**用户故事:** 作为系统管理员，我想要记录3D模型文件上传操作的完整审计日志，以便追踪文物3D模型的添加历史。

#### 验收标准

1. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录操作前的文物数据（包含空的model3dUrl和model3dUploadTime）
2. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录操作后的文物数据（包含新的model3dUrl和model3dUploadTime）
3. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录变更字段列表（model3dUrl从null变为URL，model3dUploadTime从null变为时间戳）
4. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录操作人的用户ID和真实姓名
5. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录客户端IP地址
6. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录HTTP请求方法（POST）和请求URL（/relics/{id}/3d-model）
7. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录操作类型为"上传3D模型"
8. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录操作模块为"3D模型管理"
9. WHEN 用户成功上传3D模型文件，THE Audit_Log_System SHALL 记录资源类型为"RELIC"和资源ID为文物ID
10. IF 上传3D模型文件失败，THEN THE Audit_Log_System SHALL NOT 记录审计日志

### 需求 2: 保存3D模型链接的审计日志

**用户故事:** 作为系统管理员，我想要记录3D模型链接保存操作的完整审计日志，以便追踪文物3D模型URL的变更历史。

#### 验收标准

1. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录操作前的文物数据（包含旧的model3dUrl和model3dUploadTime，或为null）
2. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录操作后的文物数据（包含新的model3dUrl和model3dUploadTime）
3. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 识别并记录model3dUrl的变更（从旧URL变为新URL，或从null变为URL）
4. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 识别并记录model3dUploadTime的变更
5. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录操作人的用户ID和真实姓名
6. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录客户端IP地址
7. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录HTTP请求方法（POST）和请求URL（/relics/{id}/3d-model-url）
8. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录操作类型为"保存3D模型链接"
9. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录操作模块为"3D模型管理"
10. WHEN 用户成功保存3D模型链接，THE Audit_Log_System SHALL 记录资源类型为"RELIC"和资源ID为文物ID
11. IF 保存3D模型链接失败，THEN THE Audit_Log_System SHALL NOT 记录审计日志

### 需求 3: 删除3D模型的审计日志

**用户故事:** 作为系统管理员，我想要记录3D模型删除操作的完整审计日志，以便追踪文物3D模型的移除历史。

#### 验收标准

1. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录操作前的文物数据（包含被删除的model3dUrl和model3dUploadTime）
2. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录操作后的文物数据（model3dUrl和model3dUploadTime均为null）
3. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录变更字段列表（model3dUrl从URL变为null，model3dUploadTime从时间戳变为null）
4. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录操作人的用户ID和真实姓名
5. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录客户端IP地址
6. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录HTTP请求方法（DELETE）和请求URL（/relics/{id}/3d-model-url）
7. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录操作类型为"删除3D模型"
8. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录操作模块为"3D模型管理"
9. WHEN 用户成功删除3D模型，THE Audit_Log_System SHALL 记录资源类型为"RELIC"和资源ID为文物ID
10. IF 删除3D模型失败，THEN THE Audit_Log_System SHALL NOT 记录审计日志

### 需求 4: 3D模型字段的中文标签映射

**用户故事:** 作为系统用户，我想要在操作日志界面看到3D模型字段的中文名称，以便更容易理解变更内容。

#### 验收标准

1. THE Field_Label_Mapping SHALL 将"model3dUrl"映射为"3D模型链接"
2. THE Field_Label_Mapping SHALL 将"model3dUploadTime"映射为"3D模型上传时间"
3. WHEN 审计日志记录3D模型字段变更，THE Audit_Log_System SHALL 使用Field_Label_Mapping中的中文标签
4. WHEN 用户查看操作日志详情，THE Operation_Log_View SHALL 显示中文字段标签而非数据库字段名

### 需求 5: 审计日志的数据完整性

**用户故事:** 作为系统管理员，我想要确保审计日志包含完整的上下文信息，以便进行全面的审计和问题追溯。

#### 验收标准

1. THE Audit_Log_System SHALL 在每条3D模型操作日志中记录操作时间（自动生成）
2. THE Audit_Log_System SHALL 在每条3D模型操作日志中记录用户代理字符串（User-Agent）
3. THE Audit_Log_System SHALL 从用户代理字符串中解析并记录浏览器类型
4. THE Audit_Log_System SHALL 从用户代理字符串中解析并记录操作系统类型
5. THE Audit_Log_System SHALL 确保Before_Data和After_Data以JSON格式存储
6. THE Audit_Log_System SHALL 确保Changed_Fields以JSON数组格式存储
7. WHEN 操作前文物没有3D模型，THE Before_Data SHALL 包含model3dUrl为null和model3dUploadTime为null
8. WHEN 操作后文物没有3D模型，THE After_Data SHALL 包含model3dUrl为null和model3dUploadTime为null

### 需求 6: 审计日志的查询和展示

**用户故事:** 作为系统管理员，我想要能够查询和查看3D模型的操作历史，以便了解文物3D模型的完整变更轨迹。

#### 验收标准

1. WHEN 用户查询特定文物的操作历史，THE Audit_Log_System SHALL 返回该文物的所有3D模型相关操作日志
2. WHEN 用户查看3D模型操作日志详情，THE Operation_Log_View SHALL 显示操作前后的完整数据对比
3. WHEN 用户查看3D模型操作日志详情，THE Operation_Log_View SHALL 以表格形式显示变更字段列表
4. WHEN 用户查看变更字段表格，THE Operation_Log_View SHALL 显示字段的中文标签、旧值、新值
5. WHEN 用户查看3D模型操作日志，THE Operation_Log_View SHALL 显示操作人、操作时间、IP地址、浏览器、操作系统等信息
6. THE Operation_Log_View SHALL 支持按操作模块"3D模型管理"过滤日志
7. THE Operation_Log_View SHALL 支持按操作类型（上传3D模型、保存3D模型链接、删除3D模型）过滤日志

### 需求 7: 审计日志的错误处理

**用户故事:** 作为系统开发者，我想要确保审计日志记录失败不会影响业务操作的正常执行，以便提高系统的健壮性。

#### 验收标准

1. IF 审计日志记录过程中发生异常，THEN THE 3D_Model_Controller SHALL 捕获异常并记录错误日志
2. IF 审计日志记录过程中发生异常，THEN THE 3D_Model_Controller SHALL 继续返回业务操作的成功结果
3. IF 审计日志记录过程中发生异常，THEN THE 3D_Model_Controller SHALL NOT 回滚业务操作
4. WHEN 审计日志记录失败，THE 3D_Model_Controller SHALL 在控制台输出错误信息（包含异常堆栈）
5. WHEN 审计日志记录失败，THE 3D_Model_Controller SHALL 确保用户不会看到审计日志相关的错误信息

### 需求 8: 审计日志与现有基础设施的集成

**用户故事:** 作为系统开发者，我想要复用现有的审计日志基础设施，以便保持代码的一致性和可维护性。

#### 验收标准

1. THE 3D_Model_Controller SHALL 使用Operation_Log_Service的logDataChange方法记录审计日志
2. THE 3D_Model_Controller SHALL 在业务操作成功后调用logDataChange方法
3. THE 3D_Model_Controller SHALL 在调用logDataChange前获取操作前的文物数据
4. THE 3D_Model_Controller SHALL 在调用logDataChange前获取操作后的文物数据
5. THE 3D_Model_Controller SHALL 使用UserContextUtil获取当前用户的ID和真实姓名
6. THE 3D_Model_Controller SHALL 使用getClientIp方法获取客户端IP地址（支持代理场景）
7. THE 3D_Model_Controller SHALL 将文物实体对象（CulturalRelic）作为beforeData和afterData传递给logDataChange
8. THE Operation_Log_Service SHALL 使用AuditLogUtil比较操作前后的文物对象差异
9. THE Operation_Log_Service SHALL 使用AuditLogUtil将文物对象转换为JSON字符串
10. THE Operation_Log_Service SHALL 使用AuditLogUtil生成变更字段列表的JSON字符串

## 非功能性需求

### 性能要求

1. THE Audit_Log_System SHALL 在100毫秒内完成单条审计日志的记录
2. THE Audit_Log_System SHALL 不显著增加3D模型操作的响应时间（增加不超过200毫秒）

### 安全要求

1. THE Audit_Log_System SHALL 确保审计日志不可被普通用户修改或删除
2. THE Audit_Log_System SHALL 记录所有3D模型操作，无论操作权限级别

### 兼容性要求

1. THE Audit_Log_System SHALL 与现有的操作日志查询界面（OperationLogsView.vue）兼容
2. THE Audit_Log_System SHALL 与现有的审计日志数据库表结构（sys_operation_log）兼容

### 可维护性要求

1. THE 3D_Model_Controller SHALL 遵循与RepairRecordController和LoanRecordController相同的审计日志实现模式
2. THE Field_Label_Mapping SHALL 集中定义在AuditLogUtil工具类中，便于维护和扩展
