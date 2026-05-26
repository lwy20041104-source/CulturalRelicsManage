# 博物馆文物数字化管理系统 - 数据库ER图

## 完整ER图

```mermaid
erDiagram
    %% 用户相关表
    sys_user ||--o{ sys_user_role : "has"
    sys_user ||--o{ sys_operation_log : "creates"
    sys_user ||--o{ user_notification : "receives"
    sys_user ||--o{ ai_chat_session : "owns"
    sys_user ||--o{ relic_archive : "creates"
    sys_user ||--o{ archive_document : "uploads"
    sys_user ||--o{ archive_history : "operates"
    sys_user ||--o{ maintenance_record : "applies"
    sys_user ||--o{ repair_record : "applies"
    sys_user ||--o{ sys_backup : "creates"
    sys_user ||--o{ image_library : "uploads"
    
    %% 文物相关表
    cultural_relic ||--o{ relic_image_relation : "has"
    cultural_relic ||--o{ relic_archive : "has"
    cultural_relic ||--o{ maintenance_record : "has"
    cultural_relic ||--o{ repair_record : "needs"
    cultural_relic }o--|| cultural_relic_category : "belongs to"
    cultural_relic ||--o{ ai_query_result : "matches"
    
    %% 分类表
    cultural_relic_category ||--o{ cultural_relic_category : "parent-child"
    
    %% 图片相关表
    image_library ||--o{ relic_image_relation : "used in"
    
    %% 档案相关表
    relic_archive ||--o{ archive_document : "contains"
    relic_archive ||--o{ archive_history : "has"
    relic_archive ||--o{ archive_version : "has"
    relic_archive ||--o{ archive_relation : "relates to"
    relic_archive ||--o{ archive_relation : "related by"
    
    %% 修复相关表
    repair_record }o--|| repair_expert : "assigned to"
    repair_record ||--o{ repair_record_material : "uses"
    repair_material ||--o{ repair_record_material : "used in"
    
    %% 日志相关表
    sys_operation_log ||--o{ sys_data_change_detail : "has details"
    
    %% 通知相关表
    system_notification ||--o{ user_notification : "sent to"
    notification_config ||--o{ system_notification : "configures"
    
    %% AI对话相关表
    ai_chat_session ||--o{ ai_chat_message : "contains"
    ai_chat_message ||--o{ ai_query_result : "has results"
    
    %% 备份相关表
    sys_backup_config ||--o{ sys_backup : "configures"

    %% 表定义
    sys_user {
        BIGINT id PK
        VARCHAR user_name UK
        VARCHAR password
        VARCHAR real_name
        VARCHAR email
        VARCHAR phone
        VARCHAR role
        INT status
        INT login_failed_count
        INT account_locked
        DATETIME locked_time
        VARCHAR last_login_ip
        DATETIME create_time
        DATETIME update_time
    }
    
    sys_user_role {
        BIGINT id PK
        BIGINT user_id FK
        VARCHAR role_code
        VARCHAR role_name
        DATETIME create_time
    }
    
    cultural_relic {
        BIGINT id PK
        VARCHAR relic_code UK
        VARCHAR relic_name
        BIGINT category_id FK
        VARCHAR era
        VARCHAR material
        VARCHAR unearthed_location
        VARCHAR dimensions
        DOUBLE weight
        VARCHAR status
        VARCHAR image_path
        VARCHAR model_3d_url
        VARCHAR origin
        TEXT description
        DATETIME create_time
        DATETIME update_time
    }
    
    cultural_relic_category {
        BIGINT id PK
        VARCHAR category_name
        BIGINT parent_id FK
        TEXT description
        DATETIME create_time
        DATETIME update_time
    }
    
    image_library {
        BIGINT id PK
        VARCHAR image_name
        VARCHAR image_path
        BIGINT image_size
        VARCHAR image_type
        BIGINT uploader_id FK
        DATETIME create_time
    }
    
    relic_image_relation {
        BIGINT id PK
        BIGINT relic_id FK
        BIGINT image_id FK
        INT is_main
        INT sort_order
        DATETIME create_time
    }
    
    relic_archive {
        BIGINT id PK
        VARCHAR archive_code UK
        BIGINT relic_id FK
        VARCHAR archive_type
        VARCHAR title
        VARCHAR status
        INT version
        BIGINT creator_id FK
        DATETIME create_time
        DATETIME update_time
    }
    
    archive_document {
        BIGINT id PK
        BIGINT archive_id FK
        VARCHAR document_type
        VARCHAR file_name
        VARCHAR file_path
        BIGINT file_size
        BIGINT uploader_id FK
        DATETIME create_time
    }
    
    archive_history {
        BIGINT id PK
        BIGINT archive_id FK
        VARCHAR operation_type
        TEXT operation_content
        BIGINT operator_id FK
        DATETIME create_time
    }
    
    archive_version {
        BIGINT id PK
        BIGINT archive_id FK
        INT version_number
        TEXT version_content
        TEXT change_description
        BIGINT creator_id FK
        DATETIME create_time
    }
    
    archive_relation {
        BIGINT id PK
        BIGINT archive_id FK
        BIGINT relation_archive_id FK
        VARCHAR relation_type
        DATETIME create_time
    }
    
    maintenance_record {
        BIGINT id PK
        BIGINT relic_id FK
        VARCHAR maintenance_type
        DATETIME maintenance_date
        TEXT maintenance_content
        VARCHAR status
        BIGINT applicant_id FK
        VARCHAR maintainer_name
        TEXT remark
        DATETIME create_time
        DATETIME update_time
    }
    
    repair_record {
        BIGINT id PK
        BIGINT relic_id FK
        BIGINT expert_id FK
        VARCHAR priority
        VARCHAR status
        TEXT repair_reason
        TEXT damage_description
        TEXT repair_process
        DECIMAL repair_cost
        BIGINT applicant_id FK
        DATETIME start_date
        DATETIME end_date
        DATETIME create_time
        DATETIME update_time
    }
    
    repair_expert {
        BIGINT id PK
        VARCHAR expert_code UK
        VARCHAR expert_name
        VARCHAR specialty
        VARCHAR phone
        VARCHAR email
        VARCHAR status
        DATETIME create_time
        DATETIME update_time
    }
    
    repair_material {
        BIGINT id PK
        VARCHAR material_name
        VARCHAR material_type
        VARCHAR unit
        DECIMAL unit_price
        INT stock_quantity
        VARCHAR supplier
        DATETIME create_time
        DATETIME update_time
    }
    
    repair_record_material {
        BIGINT id PK
        BIGINT repair_record_id FK
        BIGINT material_id FK
        INT quantity
        DECIMAL cost
        DATETIME create_time
    }
    
    sys_operation_log {
        BIGINT id PK
        BIGINT user_id FK
        VARCHAR module
        VARCHAR operation_type
        TEXT operation_content
        VARCHAR operation_result
        VARCHAR ip_address
        DATETIME create_time
    }
    
    sys_data_change_detail {
        BIGINT id PK
        BIGINT log_id FK
        VARCHAR table_name
        BIGINT record_id
        VARCHAR field_name
        TEXT old_value
        TEXT new_value
        DATETIME create_time
    }
    
    system_notification {
        BIGINT id PK
        VARCHAR title
        TEXT content
        VARCHAR type
        BIGINT related_id
        BIGINT sender_id FK
        DATETIME create_time
    }
    
    notification_config {
        BIGINT id PK
        VARCHAR notification_type UK
        INT enabled
        VARCHAR target_roles
        TEXT template_content
        DATETIME create_time
        DATETIME update_time
    }
    
    user_notification {
        BIGINT id PK
        BIGINT user_id FK
        BIGINT notification_id FK
        INT is_read
        DATETIME read_time
        DATETIME create_time
    }
    
    ai_chat_session {
        BIGINT id PK
        BIGINT user_id FK
        VARCHAR title
        DATETIME create_time
        DATETIME update_time
    }
    
    ai_chat_message {
        BIGINT id PK
        BIGINT session_id FK
        VARCHAR role
        TEXT content
        DATETIME create_time
    }
    
    ai_query_result {
        BIGINT id PK
        BIGINT message_id FK
        BIGINT relic_id FK
        INT relevance
        VARCHAR source_type
        VARCHAR source_name
        VARCHAR source_url
        VARCHAR image_url
        VARCHAR match_tags
        DATETIME create_time
    }
    
    sys_backup {
        BIGINT id PK
        VARCHAR backup_name
        VARCHAR backup_path
        BIGINT backup_size
        VARCHAR backup_type
        INT is_encrypted
        VARCHAR status
        BIGINT creator_id FK
        DATETIME create_time
    }
    
    sys_backup_config {
        BIGINT id PK
        VARCHAR config_key UK
        VARCHAR config_value
        TEXT description
        DATETIME create_time
        DATETIME update_time
    }
```

## 分模块ER图

### 1. 用户管理模块

```mermaid
erDiagram
    sys_user ||--o{ sys_user_role : "has"
    
    sys_user {
        BIGINT id PK "用户ID"
        VARCHAR user_name UK "用户名"
        VARCHAR password "密码"
        VARCHAR real_name "真实姓名"
        VARCHAR email "邮箱"
        VARCHAR phone "手机号"
        VARCHAR role "角色"
        INT status "状态"
        INT login_failed_count "登录失败次数"
        INT account_locked "账户锁定状态"
        DATETIME locked_time "锁定时间"
        VARCHAR last_login_ip "最后登录IP"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    sys_user_role {
        BIGINT id PK "角色ID"
        BIGINT user_id FK "用户ID"
        VARCHAR role_code "角色编码"
        VARCHAR role_name "角色名称"
        DATETIME create_time "创建时间"
    }
```

### 2. 文物管理模块

```mermaid
erDiagram
    cultural_relic }o--|| cultural_relic_category : "belongs to"
    cultural_relic ||--o{ relic_image_relation : "has"
    image_library ||--o{ relic_image_relation : "used in"
    cultural_relic_category ||--o{ cultural_relic_category : "parent-child"
    
    cultural_relic {
        BIGINT id PK "文物ID"
        VARCHAR relic_code UK "文物编号"
        VARCHAR relic_name "文物名称"
        BIGINT category_id FK "分类ID"
        VARCHAR era "年代"
        VARCHAR material "材质"
        VARCHAR unearthed_location "出土地点"
        VARCHAR dimensions "尺寸"
        DOUBLE weight "重量"
        VARCHAR status "状态"
        VARCHAR image_path "图片路径"
        VARCHAR model_3d_url "3D模型URL"
        VARCHAR origin "来源"
        TEXT description "描述"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    cultural_relic_category {
        BIGINT id PK "分类ID"
        VARCHAR category_name "分类名称"
        BIGINT parent_id FK "父分类ID"
        TEXT description "描述"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    image_library {
        BIGINT id PK "图片ID"
        VARCHAR image_name "图片名称"
        VARCHAR image_path "图片路径"
        BIGINT image_size "图片大小"
        VARCHAR image_type "图片类型"
        BIGINT uploader_id FK "上传人ID"
        DATETIME create_time "创建时间"
    }
    
    relic_image_relation {
        BIGINT id PK "关联ID"
        BIGINT relic_id FK "文物ID"
        BIGINT image_id FK "图片ID"
        INT is_main "是否主图"
        INT sort_order "排序"
        DATETIME create_time "创建时间"
    }
```

### 3. 档案管理模块

```mermaid
erDiagram
    cultural_relic ||--o{ relic_archive : "has"
    relic_archive ||--o{ archive_document : "contains"
    relic_archive ||--o{ archive_history : "has"
    relic_archive ||--o{ archive_version : "has"
    relic_archive ||--o{ archive_relation : "relates to"
    
    relic_archive {
        BIGINT id PK "档案ID"
        VARCHAR archive_code UK "档案编号"
        BIGINT relic_id FK "文物ID"
        VARCHAR archive_type "档案类型"
        VARCHAR title "档案标题"
        VARCHAR status "状态"
        INT version "版本号"
        BIGINT creator_id FK "创建人ID"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    archive_document {
        BIGINT id PK "文档ID"
        BIGINT archive_id FK "档案ID"
        VARCHAR document_type "文档类型"
        VARCHAR file_name "文件名"
        VARCHAR file_path "文件路径"
        BIGINT file_size "文件大小"
        BIGINT uploader_id FK "上传人ID"
        DATETIME create_time "创建时间"
    }
    
    archive_history {
        BIGINT id PK "历史ID"
        BIGINT archive_id FK "档案ID"
        VARCHAR operation_type "操作类型"
        TEXT operation_content "操作内容"
        BIGINT operator_id FK "操作人ID"
        DATETIME create_time "创建时间"
    }
    
    archive_version {
        BIGINT id PK "版本ID"
        BIGINT archive_id FK "档案ID"
        INT version_number "版本号"
        TEXT version_content "版本内容"
        TEXT change_description "变更说明"
        BIGINT creator_id FK "创建人ID"
        DATETIME create_time "创建时间"
    }
    
    archive_relation {
        BIGINT id PK "关联ID"
        BIGINT archive_id FK "档案ID"
        BIGINT relation_archive_id FK "关联档案ID"
        VARCHAR relation_type "关联类型"
        DATETIME create_time "创建时间"
    }
```

### 4. 维护与修复模块

```mermaid
erDiagram
    cultural_relic ||--o{ maintenance_record : "has"
    cultural_relic ||--o{ repair_record : "needs"
    repair_record }o--|| repair_expert : "assigned to"
    repair_record ||--o{ repair_record_material : "uses"
    repair_material ||--o{ repair_record_material : "used in"
    
    maintenance_record {
        BIGINT id PK "维护ID"
        BIGINT relic_id FK "文物ID"
        VARCHAR maintenance_type "维护类型"
        DATETIME maintenance_date "维护时间"
        TEXT maintenance_content "维护内容"
        VARCHAR status "状态"
        BIGINT applicant_id FK "申请人ID"
        VARCHAR maintainer_name "维护人姓名"
        TEXT remark "备注"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    repair_record {
        BIGINT id PK "修复ID"
        BIGINT relic_id FK "文物ID"
        BIGINT expert_id FK "专家ID"
        VARCHAR priority "优先级"
        VARCHAR status "状态"
        TEXT repair_reason "修复原因"
        TEXT damage_description "损坏描述"
        TEXT repair_process "修复过程"
        DECIMAL repair_cost "修复费用"
        BIGINT applicant_id FK "申请人ID"
        DATETIME start_date "开始时间"
        DATETIME end_date "结束时间"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    repair_expert {
        BIGINT id PK "专家ID"
        VARCHAR expert_code UK "专家编号"
        VARCHAR expert_name "专家姓名"
        VARCHAR specialty "专业领域"
        VARCHAR phone "联系电话"
        VARCHAR email "邮箱"
        VARCHAR status "状态"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    repair_material {
        BIGINT id PK "材料ID"
        VARCHAR material_name "材料名称"
        VARCHAR material_type "材料类型"
        VARCHAR unit "单位"
        DECIMAL unit_price "单价"
        INT stock_quantity "库存数量"
        VARCHAR supplier "供应商"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    repair_record_material {
        BIGINT id PK "关联ID"
        BIGINT repair_record_id FK "修复记录ID"
        BIGINT material_id FK "材料ID"
        INT quantity "使用数量"
        DECIMAL cost "费用"
        DATETIME create_time "创建时间"
    }
```

### 5. 日志与审计模块

```mermaid
erDiagram
    sys_user ||--o{ sys_operation_log : "creates"
    sys_operation_log ||--o{ sys_data_change_detail : "has details"
    
    sys_operation_log {
        BIGINT id PK "日志ID"
        BIGINT user_id FK "用户ID"
        VARCHAR module "操作模块"
        VARCHAR operation_type "操作类型"
        TEXT operation_content "操作内容"
        VARCHAR operation_result "操作结果"
        VARCHAR ip_address "IP地址"
        DATETIME create_time "创建时间"
    }
    
    sys_data_change_detail {
        BIGINT id PK "明细ID"
        BIGINT log_id FK "日志ID"
        VARCHAR table_name "表名"
        BIGINT record_id "记录ID"
        VARCHAR field_name "字段名"
        TEXT old_value "修改前值"
        TEXT new_value "修改后值"
        DATETIME create_time "创建时间"
    }
```

### 6. 通知模块

```mermaid
erDiagram
    sys_user ||--o{ user_notification : "receives"
    system_notification ||--o{ user_notification : "sent to"
    notification_config ||--o{ system_notification : "configures"
    
    system_notification {
        BIGINT id PK "通知ID"
        VARCHAR title "通知标题"
        TEXT content "通知内容"
        VARCHAR type "通知类型"
        BIGINT related_id "关联ID"
        BIGINT sender_id FK "发送人ID"
        DATETIME create_time "创建时间"
    }
    
    notification_config {
        BIGINT id PK "配置ID"
        VARCHAR notification_type UK "通知类型"
        INT enabled "是否启用"
        VARCHAR target_roles "目标角色"
        TEXT template_content "模板内容"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    user_notification {
        BIGINT id PK "关联ID"
        BIGINT user_id FK "用户ID"
        BIGINT notification_id FK "通知ID"
        INT is_read "是否已读"
        DATETIME read_time "阅读时间"
        DATETIME create_time "创建时间"
    }
```

### 7. AI对话模块

```mermaid
erDiagram
    sys_user ||--o{ ai_chat_session : "owns"
    ai_chat_session ||--o{ ai_chat_message : "contains"
    ai_chat_message ||--o{ ai_query_result : "has results"
    cultural_relic ||--o{ ai_query_result : "matches"
    
    ai_chat_session {
        BIGINT id PK "会话ID"
        BIGINT user_id FK "用户ID"
        VARCHAR title "会话标题"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
    
    ai_chat_message {
        BIGINT id PK "消息ID"
        BIGINT session_id FK "会话ID"
        VARCHAR role "角色"
        TEXT content "消息内容"
        DATETIME create_time "创建时间"
    }
    
    ai_query_result {
        BIGINT id PK "结果ID"
        BIGINT message_id FK "消息ID"
        BIGINT relic_id FK "文物ID"
        INT relevance "相关度评分"
        VARCHAR source_type "来源类型"
        VARCHAR source_name "来源名称"
        VARCHAR source_url "来源URL"
        VARCHAR image_url "图片URL"
        VARCHAR match_tags "匹配标签"
        DATETIME create_time "创建时间"
    }
```

### 8. 数据备份模块

```mermaid
erDiagram
    sys_user ||--o{ sys_backup : "creates"
    sys_backup_config ||--o{ sys_backup : "configures"
    
    sys_backup {
        BIGINT id PK "备份ID"
        VARCHAR backup_name "备份名称"
        VARCHAR backup_path "备份路径"
        BIGINT backup_size "备份大小"
        VARCHAR backup_type "备份类型"
        INT is_encrypted "是否加密"
        VARCHAR status "状态"
        BIGINT creator_id FK "创建人ID"
        DATETIME create_time "创建时间"
    }
    
    sys_backup_config {
        BIGINT id PK "配置ID"
        VARCHAR config_key UK "配置键"
        VARCHAR config_value "配置值"
        TEXT description "描述"
        DATETIME create_time "创建时间"
        DATETIME update_time "更新时间"
    }
```

## 数据库关系说明

### 核心关系

1. **用户中心关系**
   - 一个用户可以有多个角色(sys_user → sys_user_role)
   - 一个用户可以创建多条操作日志(sys_user → sys_operation_log)
   - 一个用户可以接收多条通知(sys_user → user_notification)
   - 一个用户可以拥有多个AI会话(sys_user → ai_chat_session)

2. **文物中心关系**
   - 一个文物属于一个分类(cultural_relic → cultural_relic_category)
   - 一个文物可以有多张图片(cultural_relic → relic_image_relation → image_library)
   - 一个文物可以有多个档案(cultural_relic → relic_archive)
   - 一个文物可以有多条维护记录(cultural_relic → maintenance_record)
   - 一个文物可以有多条修复记录(cultural_relic → repair_record)

3. **档案管理关系**
   - 一个档案可以包含多个文档(relic_archive → archive_document)
   - 一个档案可以有多条操作历史(relic_archive → archive_history)
   - 一个档案可以有多个版本(relic_archive → archive_version)
   - 档案之间可以建立关联关系(relic_archive → archive_relation)

4. **修复管理关系**
   - 一条修复记录分配给一个专家(repair_record → repair_expert)
   - 一条修复记录可以使用多种材料(repair_record → repair_record_material → repair_material)

5. **AI对话关系**
   - 一个会话包含多条消息(ai_chat_session → ai_chat_message)
   - 一条消息可以有多个查询结果(ai_chat_message → ai_query_result)
   - 查询结果可以关联文物(ai_query_result → cultural_relic)

### 关系基数

- **一对一(1:1)**: 无
- **一对多(1:N)**: 大部分关系,如用户-日志、文物-图片、档案-文档等
- **多对多(M:N)**: 通过中间表实现
  - 文物-图片(通过relic_image_relation)
  - 修复记录-材料(通过repair_record_material)
  - 用户-通知(通过user_notification)

### 外键约束

所有标注FK的字段都建立了外键约束,保证数据的参照完整性。主要外键包括:
- user_id → sys_user(id)
- relic_id → cultural_relic(id)
- category_id → cultural_relic_category(id)
- archive_id → relic_archive(id)
- expert_id → repair_expert(id)
- session_id → ai_chat_session(id)

### 唯一性约束

以下字段具有唯一性约束(UK):
- sys_user.user_name
- cultural_relic.relic_code
- relic_archive.archive_code
- repair_expert.expert_code
- notification_config.notification_type
- sys_backup_config.config_key
