# 博物馆文物数字化管理系统 - 完整UML图文档

本文档包含系统的9种UML图，按照标准UML顺序排列。

## 目录

1. [用例图 (Use Case Diagram)](#1-用例图-use-case-diagram)
2. [类图 (Class Diagram)](#2-类图-class-diagram)
3. [对象图 (Object Diagram)](#3-对象图-object-diagram)
4. [序列图 (Sequence Diagram)](#4-序列图-sequence-diagram)
5. [协作图 (Collaboration Diagram)](#5-协作图-collaboration-diagram)
6. [活动图 (Activity Diagram)](#6-活动图-activity-diagram)
7. [状态图 (State Diagram)](#7-状态图-state-diagram)
8. [组件图 (Component Diagram)](#8-组件图-component-diagram)
9. [部署图 (Deployment Diagram)](#9-部署图-deployment-diagram)

---


## 1. 用例图 (Use Case Diagram)

用例图展示了系统的功能需求以及各个角色与系统的交互关系。

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    博物馆文物数字化管理系统 - 用例图                           │
└─────────────────────────────────────────────────────────────────────────────┘

     ┌──────────┐                                                  ┌──────────┐
     │          │                                                  │          │
     │ 系统管理员│                                                  │ 文物保管员│
     │ (ADMIN)  │                                                  │(CURATOR) │
     │          │                                                  │          │
     └────┬─────┘                                                  └────┬─────┘
          │                                                             │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          ├─►│ UC-01: 用户管理                                  │      │
          │  │  • 创建/编辑/删除用户                            │      │
          │  │  • 分配角色权限                                  │      │
          │  │  • 查看用户列表                                  │      │
          │  │  • 重置用户密码                                  │      │
          │  └──────────────────────────────────────────────────┘      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          ├─►│ UC-02: 博物馆管理                                │      │
          │  │  • 创建/编辑博物馆信息                           │      │
          │  │  • 分配用户到博物馆                              │      │
          │  │  • 查看博物馆列表                                │      │
          │  └──────────────────────────────────────────────────┘      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          ├─►│ UC-03: 系统配置                                  │      │
          │  │  • 系统参数配置                                  │      │
          │  │  • 数据备份管理                                  │      │
          │  │  • 操作日志查看                                  │      │
          │  │  • 审计日志查看                                  │      │
          │  └──────────────────────────────────────────────────┘      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          └─►│ UC-04: 统计报表                                  │◄─────┤
             │  • 文物统计分析                                  │      │
             │  • 借展统计报表                                  │      │
             │  • 修复统计报表                                  │      │
             │  • 数据导出(Excel/PDF/Word)                      │      │
             └──────────────────────────────────────────────────┘      │
                                                                        │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-05: 文物管理                                  │◄─────┤
             │  • 添加/编辑/删除文物                            │      │
             │  • 文物分类管理                                  │      │
             │  • 文物图片管理                                  │      │
             │  • 文物3D模型管理                                │      │
             │  • 生成二维码标签                                │      │
             │  • 批量操作                                      │      │
             │  • 数据导入导出                                  │      │
             └──────────────────────────────────────────────────┘      │
                          │                                             │
                          │ «extends»                                   │
                          ▼                                             │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-06: 图片识别                                  │      │
             │  • 使用百度AI识别文物图片                        │      │
             │  • 自动提取文物信息                              │      │
             └──────────────────────────────────────────────────┘      │
                                                                        │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-07: 档案管理                                  │◄─────┤
             │  • 创建文物档案                                  │      │
             │  • 上传档案文档                                  │      │
             │  • 查看档案历史                                  │      │
             │  • 档案版本管理                                  │      │
             └──────────────────────────────────────────────────┘      │
                                                                        │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-08: 维护管理                                  │◄─────┤
             │  • 记录文物维护                                  │      │
             │  • 查看维护历史                                  │      │
             │  • 维护计划管理                                  │      │
             └──────────────────────────────────────────────────┘      │
                                                                        │
                                                                        │
     ┌──────────┐                                                      │
     │          │                                                      │
     │ 借展审批员│                                                      │
     │(APPROVER)│                                                      │
     │          │                                                      │
     └────┬─────┘                                                      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          ├─►│ UC-09: 借展审批                                  │      │
          │  │  • 审批借展申请                                  │      │
          │  │  • 查看借展记录                                  │      │
          │  │  • 处理逾期借展                                  │      │
          │  │  • 借展统计分析                                  │      │
          │  └──────────────────────────────────────────────────┘      │
          │                │                                            │
          │                │ «extends»                                  │
          │                ▼                                            │
          │  ┌──────────────────────────────────────────────────┐      │
          │  │ UC-10: 消息通知                                  │      │
          │  │  • 发送审批通知                                  │      │
          │  │  • 发送逾期提醒                                  │      │
          │  └──────────────────────────────────────────────────┘      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          └─►│ UC-11: 修复审批                                  │◄─────┤
             │  • 审批修复申请                                  │      │
             │  • 分配修复专家                                  │      │
             │  • 跟踪修复进度                                  │      │
             │  • 修复质量评估                                  │      │
             └──────────────────────────────────────────────────┘      │
                          │                                             │
                          │ «extends»                                   │
                          ▼                                             │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-10: 消息通知                                  │      │
             └──────────────────────────────────────────────────┘      │
                                                                        │
                                                                        │
     ┌──────────┐                                                      │
     │          │                                                      │
     │  借展人  │                                                      │
     │ (LOANER) │                                                      │
     │          │                                                      │
     └────┬─────┘                                                      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          ├─►│ UC-12: 文物浏览                                  │      │
          │  │  • 浏览文物列表                                  │      │
          │  │  • 查看文物详情                                  │      │
          │  │  • 查看3D模型                                    │      │
          │  │  • 扫描二维码查看                                │      │
          │  │  • 文物搜索过滤                                  │      │
          │  └──────────────────────────────────────────────────┘      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          ├─►│ UC-13: 借展申请                                  │      │
          │  │  • 提交借展申请                                  │      │
          │  │  • 查看申请状态                                  │      │
          │  │  • 查看我的借展记录                              │      │
          │  │  • 取消借展申请                                  │      │
          │  └──────────────────────────────────────────────────┘      │
          │                                                             │
          │  ┌──────────────────────────────────────────────────┐      │
          └─►│ UC-14: AI智能查询                                │      │
             │  • 自然语言查询文物                              │      │
             │  • 查看AI推荐                                    │      │
             │  • 查看查询历史                                  │      │
             │  • 多轮对话                                      │      │
             └──────────────────────────────────────────────────┘      │
                          │                                             │
                          │ «extends»                                   │
                          ▼                                             │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-15: 网络搜索                                  │      │
             │  • 查询外部文物信息                              │      │
             │  • 图片抓取                                      │      │
             └──────────────────────────────────────────────────┘      │
                                                                        │
                                                                        │
             ┌──────────────────────────────────────────────────┐      │
             │ UC-16: 通用功能 (所有角色)                       │      │
             │  • 登录/登出                                     │      │
             │  • 修改个人信息                                  │      │
             │  • 修改密码                                      │      │
             │  • 查看通知消息                                  │      │
             │  • 切换主题/语言                                 │      │
             │  • 暗黑模式切换                                  │      │
             └──────────────────────────────────────────────────┘      │
                          ▲                                             │
                          │                                             │
                          └─────────────────────────────────────────────┘
                                    所有角色都可使用

                          │ «includes»
                          ▼
             ┌──────────────────────────────────────────────────┐
             │ UC-17: 权限验证                                  │
             │  • JWT令牌验证                                   │
             │  • 角色权限检查                                  │
             │  • 操作日志记录                                  │
             └──────────────────────────────────────────────────┘
```

### 用例说明

#### 主要参与者 (Actors)

1. **系统管理员 (ADMIN)**: 拥有系统最高权限，负责用户管理、系统配置、数据备份等
2. **文物保管员 (CURATOR)**: 负责文物的日常管理、档案管理、维护记录等
3. **借展审批员 (APPROVER)**: 负责审批借展和修复申请
4. **借展人 (LOANER)**: 可以浏览文物、提交借展申请、使用AI查询

#### 用例关系

- **«extends»**: 扩展关系，表示可选的功能扩展
  - 图片识别扩展文物管理
  - 消息通知扩展借展审批和修复审批
  - 网络搜索扩展AI智能查询

- **«includes»**: 包含关系，表示必须执行的功能
  - 所有管理功能都包含权限验证
  - 所有数据操作都包含操作日志记录

---

## 2. 类图 (Class Diagram)

类图展示了系统的静态结构，包括类、属性、方法以及类之间的关系。

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         核心实体类图                                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────┐
│      CulturalRelic           │
├──────────────────────────────┤
│ - id: Long                   │
│ - relicCode: String          │
│ - relicName: String          │
│ - categoryId: Long           │
│ - categoryName: String       │
│ - era: String                │
│ - material: String           │
│ - origin: String             │
│ - dimensions: String         │
│ - weight: Double             │
│ - description: String        │
│ - status: String             │
│ - imagePath: String          │
│ - model3dUrl: String         │
│ - model3dUploadTime: LocalDateTime │
│ - createTime: LocalDateTime  │
│ - updateTime: LocalDateTime  │
├──────────────────────────────┤
│ + getId(): Long              │
│ + setId(Long): void          │
│ + getRelicName(): String     │
│ + setRelicName(String): void │
│ + getStatus(): String        │
│ + setStatus(String): void    │
│ + ... (其他getter/setter)    │
└──────────────────────────────┘
         △                △
         │                │
         │                │ 1
         │                │
         │                │ *
         │         ┌──────────────────────────────┐
         │         │      LoanRecord              │
         │         ├──────────────────────────────┤
         │         │ - id: Long                   │
         │         │ - relicId: Long              │
         │         │ - relicName: String          │
         │         │ - borrowerId: Long           │
         │         │ - borrowerName: String       │
         │         │ - borrowerUnit: String       │
         │         │ - borrowerPhone: String      │
         │         │ - loanDate: LocalDateTime    │
         │         │ - expectedReturnDate: LocalDateTime │
         │         │ - actualReturnDate: LocalDateTime   │
         │         │ - purpose: String            │
         │         │ - status: String             │
         │         │ - approverName: String       │
         │         │ - approveTime: LocalDateTime │
         │         │ - approveRemark: String      │
         │         │ - createTime: LocalDateTime  │
         │         │ - updateTime: LocalDateTime  │
         │         ├──────────────────────────────┤
         │         │ + applyLoan(): void          │
         │         │ + approve(): void            │
         │         │ + reject(): void             │
         │         │ + returnRelic(): void        │
         │         │ + isOverdue(): boolean       │
         │         └──────────────────────────────┘
         │                      │
         │                      │ *
         │                      │
         │                      │ 1
         │         ┌──────────────────────────────┐
         │         │      RepairRecord            │
         │         ├──────────────────────────────┤
         │         │ - id: Long                   │
         │         │ - repairCode: String         │
         │         │ - relicId: Long              │
         │         │ - status: String             │
         │         │ - priority: String           │
         │         │ - applicantId: Long          │
         │         │ - applyDate: LocalDateTime   │
         │         │ - repairReason: String       │
         │         │ - damageDescription: String  │
         │         │ - estimatedCost: BigDecimal  │
         │         │ - approver: String           │
         │         │ - approveDate: LocalDateTime │
         │         │ - approveRemark: String      │
         │         │ - repairExpert: String       │
         │         │ - startDate: LocalDateTime   │
         │         │ - completeDate: LocalDateTime│
         │         │ - repairProcess: String      │
         │         │ - repairMethod: String       │
         │         │ - actualCost: BigDecimal     │
         │         │ - beforeImages: String       │
         │         │ - afterImages: String        │
         │         │ - qualityScore: Integer      │
         │         │ - qualityRemark: String      │
         │         │ - remark: String             │
         │         │ - createTime: LocalDateTime  │
         │         │ - updateTime: LocalDateTime  │
         │         ├──────────────────────────────┤
         │         │ + applyRepair(): void        │
         │         │ + approve(): void            │
         │         │ + reject(): void             │
         │         │ + startRepair(): void        │
         │         │ + updateProgress(): void     │
         │         │ + completeRepair(): void     │
         │         │ + evaluateQuality(): void    │
         │         └──────────────────────────────┘
         │
         │ 1
         │
         │ *
┌──────────────────────────────┐
│   CulturalRelicCategory      │
├──────────────────────────────┤
│ - id: Long                   │
│ - categoryName: String       │
│ - parentId: Long             │
│ - description: String        │
│ - createTime: LocalDateTime  │
│ - updateTime: LocalDateTime  │
├──────────────────────────────┤
│ + addCategory(): void        │
│ + updateCategory(): void     │
│ + deleteCategory(): void     │
│ + getChildren(): List        │
└──────────────────────────────┘


┌──────────────────────────────┐
│         SysUser              │
├──────────────────────────────┤
│ - id: Long                   │
│ - username: String           │
│ - password: String           │
│ - realName: String           │
│ - email: String              │
│ - phone: String              │
│ - status: Integer            │
│ - roleId: Long               │
│ - roleName: String           │
│ - roleCode: String           │
│ - loginFailedCount: Integer  │
│ - accountLocked: Integer     │
│ - lockedTime: LocalDateTime  │
│ - lastLoginTime: LocalDateTime│
│ - lastLoginIp: String        │
│ - createTime: LocalDateTime  │
│ - updateTime: LocalDateTime  │
├──────────────────────────────┤
│ + login(): String            │
│ + logout(): void             │
│ + changePassword(): void     │
│ + resetPassword(): void      │
│ + lockAccount(): void        │
│ + unlockAccount(): void      │
│ + incrementFailedCount(): void│
│ + resetFailedCount(): void   │
└──────────────────────────────┘
         △
         │
         │ 1
         │
         │ *
┌──────────────────────────────┐
│      SysOperationLog         │
├──────────────────────────────┤
│ - id: Long                   │
│ - userId: Long               │
│ - username: String           │
│ - operationType: String      │
│ - operationModule: String    │
│ - operationContent: String   │
│ - requestMethod: String      │
│ - requestUrl: String         │
│ - requestParams: String      │
│ - responseData: String       │
│ - ipAddress: String          │
│ - operationTime: LocalDateTime│
│ - executionTime: Long        │
│ - status: Integer            │
├──────────────────────────────┤
│ + log(): void                │
│ + query(): List              │
│ + export(): void             │
└──────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                         服务层类图                                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────┐
│   «interface»                        │
│   CulturalRelicService               │
├──────────────────────────────────────┤
│ + pageRelics(...): PageResult        │
│ + getById(Long): CulturalRelic       │
│ + save(CulturalRelic): boolean       │
│ + saveWithImage(...): Long           │
│ + updateById(CulturalRelic): boolean │
│ + removeById(Long): boolean          │
│ + list(): List                       │
│ + count(): long                      │
│ + countByStatus(String): long        │
│ + batchDelete(List): boolean         │
│ + batchUpdateStatus(...): boolean    │
│ + exportExcel(...): void             │
│ + exportPdf(...): void               │
│ + exportWord(...): void              │
│ + importExcel(MultipartFile): int    │
│ + downloadTemplate(...): void        │
│ + getAvailableForRepair(): List      │
└──────────────────────────────────────┘
                △
                │
                │ implements
                │
┌──────────────────────────────────────┐
│   CulturalRelicServiceImpl           │
├──────────────────────────────────────┤
│ - culturalRelicMapper: Mapper        │
│ - relicImageRelationService: Service │
│ - fileStorageUtil: Util              │
├──────────────────────────────────────┤
│ + pageRelics(...): PageResult        │
│ + getById(Long): CulturalRelic       │
│ + save(CulturalRelic): boolean       │
│ + saveWithImage(...): Long           │
│ + updateById(CulturalRelic): boolean │
│ + removeById(Long): boolean          │
│ + ... (实现所有接口方法)             │
└──────────────────────────────────────┘
                │
                │ uses
                ▼
┌──────────────────────────────────────┐
│   CulturalRelicMapper                │
├──────────────────────────────────────┤
│ + insert(CulturalRelic): int         │
│ + update(CulturalRelic): int         │
│ + delete(Long): int                  │
│ + selectById(Long): CulturalRelic    │
│ + selectList(QueryWrapper): List     │
│ + selectPage(Page, Wrapper): Page    │
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   «interface»                        │
│   LoanRecordService                  │
├──────────────────────────────────────┤
│ + applyLoan(LoanRecord): boolean     │
│ + approveLoan(...): boolean          │
│ + rejectLoan(...): boolean           │
│ + returnRelic(Long): boolean         │
│ + getOverdueLoans(): List            │
│ + pageLoanRecords(...): PageResult   │
│ + getMyLoans(Long): List             │
└──────────────────────────────────────┘
                △
                │
                │ implements
                │
┌──────────────────────────────────────┐
│   LoanRecordServiceImpl              │
├──────────────────────────────────────┤
│ - loanRecordMapper: Mapper           │
│ - culturalRelicService: Service      │
│ - notificationService: Service       │
├──────────────────────────────────────┤
│ + applyLoan(LoanRecord): boolean     │
│ + approveLoan(...): boolean          │
│ + rejectLoan(...): boolean           │
│ + returnRelic(Long): boolean         │
│ + ... (实现所有接口方法)             │
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   «interface»                        │
│   RepairRecordService                │
├──────────────────────────────────────┤
│ + applyRepair(RepairRecord): boolean │
│ + approveRepair(...): boolean        │
│ + rejectRepair(...): boolean         │
│ + startRepair(Long): boolean         │
│ + updateProgress(...): boolean       │
│ + completeRepair(...): boolean       │
│ + pageRepairRecords(...): PageResult │
└──────────────────────────────────────┘
                △
                │
                │ implements
                │
┌──────────────────────────────────────┐
│   RepairRecordServiceImpl            │
├──────────────────────────────────────┤
│ - repairRecordMapper: Mapper         │
│ - culturalRelicService: Service      │
│ - notificationService: Service       │
├──────────────────────────────────────┤
│ + applyRepair(RepairRecord): boolean │
│ + approveRepair(...): boolean        │
│ + rejectRepair(...): boolean         │
│ + ... (实现所有接口方法)             │
└──────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                         控制层类图                                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────┐
│   CulturalRelicController            │
├──────────────────────────────────────┤
│ - culturalRelicService: Service      │
│ - fileStorageUtil: Util              │
│ - relicImageRelationService: Service │
│ - operationLogService: Service       │
│ - userContextUtil: Util              │
├──────────────────────────────────────┤
│ + page(...): Result<PageResult>      │
│ + getById(Long): Result              │
│ + save(CulturalRelic): Result        │
│ + saveWithImage(...): Result         │
│ + update(CulturalRelic): Result      │
│ + delete(Long): Result               │
│ + uploadImage(...): Result           │
│ + batchDelete(List): Result          │
│ + batchUpdateStatus(...): Result     │
│ + exportExcel(...): void             │
│ + exportPdf(...): void               │
│ + exportWord(...): void              │
│ + importExcel(MultipartFile): Result │
│ + downloadTemplate(...): void        │
│ + generateQRCode(Long): Result       │
│ + batchGenerateQRCode(List): Result  │
└──────────────────────────────────────┘
                │
                │ uses
                ▼
┌──────────────────────────────────────┐
│   CulturalRelicService               │
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   LoanRecordController               │
├──────────────────────────────────────┤
│ - loanRecordService: Service         │
│ - userContextUtil: Util              │
├──────────────────────────────────────┤
│ + page(...): Result<PageResult>      │
│ + getById(Long): Result              │
│ + apply(LoanRecord): Result          │
│ + approve(ApproveRequest): Result    │
│ + reject(ApproveRequest): Result     │
│ + returnRelic(Long): Result          │
│ + getMyLoans(): Result               │
│ + getOverdueLoans(): Result          │
└──────────────────────────────────────┘
                │
                │ uses
                ▼
┌──────────────────────────────────────┐
│   LoanRecordService                  │
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   RepairRecordController             │
├──────────────────────────────────────┤
│ - repairRecordService: Service       │
│ - userContextUtil: Util              │
├──────────────────────────────────────┤
│ + page(...): Result<PageResult>      │
│ + getById(Long): Result              │
│ + apply(RepairApplyRequest): Result  │
│ + approve(ApproveRequest): Result    │
│ + reject(ApproveRequest): Result     │
│ + startRepair(Long): Result          │
│ + updateProgress(...): Result        │
│ + completeRepair(...): Result        │
└──────────────────────────────────────┘
                │
                │ uses
                ▼
┌──────────────────────────────────────┐
│   RepairRecordService                │
└──────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                         工具类图                                             │
└─────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────┐
│   JwtUtil                            │
├──────────────────────────────────────┤
│ - SECRET_KEY: String                 │
│ - EXPIRATION_TIME: long              │
├──────────────────────────────────────┤
│ + generateToken(String): String      │
│ + validateToken(String): boolean     │
│ + getUsernameFromToken(String): String│
│ + isTokenExpired(String): boolean    │
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   FileStorageUtil                    │
├──────────────────────────────────────┤
│ - uploadPath: String                 │
│ - allowedExtensions: List            │
├──────────────────────────────────────┤
│ + uploadFile(MultipartFile): String  │
│ + deleteFile(String): boolean        │
│ + getFileUrl(String): String         │
│ + validateFile(MultipartFile): boolean│
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   QRCodeUtil                         │
├──────────────────────────────────────┤
│ + generateQRCode(String, int): BufferedImage │
│ + generateQRCodeBase64(String, int): String  │
│ + generateRelicQRCodeUrl(Long, String): String │
│ + generateQRCodeLabelBase64(...): String     │
└──────────────────────────────────────┘


┌──────────────────────────────────────┐
│   UserContextUtil                    │
├──────────────────────────────────────┤
│ + getCurrentUserId(): Long           │
│ + getCurrentUsername(): String       │
│ + getCurrentUserRealName(): String   │
│ + getCurrentUserRole(): String       │
│ + hasRole(String): boolean           │
│ + hasPermission(String): boolean     │
└──────────────────────────────────────┘
```

### 类关系说明

1. **继承关系 (Inheritance)**: 
   - 所有实体类继承基础实体类（如果有）

2. **实现关系 (Realization)**:
   - ServiceImpl类实现对应的Service接口

3. **关联关系 (Association)**:
   - CulturalRelic与LoanRecord: 一对多关系
   - CulturalRelic与RepairRecord: 一对多关系
   - CulturalRelic与CulturalRelicCategory: 多对一关系
   - SysUser与LoanRecord: 一对多关系
   - SysUser与SysOperationLog: 一对多关系

4. **依赖关系 (Dependency)**:
   - Controller依赖Service
   - Service依赖Mapper
   - Service之间相互依赖

5. **聚合关系 (Aggregation)**:
   - Controller聚合多个Service和Util

---

## 3. 对象图 (Object Diagram)

对象图展示了系统在某一时刻的对象实例及其关系，是类图的实例化。

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    借展业务场景对象图                                         │
│                    (某一时刻的对象实例快照)                                   │
└─────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────┐
│ relic1: CulturalRelic              │
├────────────────────────────────────┤
│ id = 1001                          │
│ relicCode = "WW-2024-001"          │
│ relicName = "青铜鼎"               │
│ categoryId = 1                     │
│ categoryName = "青铜器"            │
│ era = "商代"                       │
│ material = "青铜"                  │
│ origin = "河南安阳"                │
│ status = "借展中"                  │
│ createTime = 2024-01-15 10:30:00   │
└────────────────────────────────────┘
            △
            │ relicId
            │
┌────────────────────────────────────┐
│ loan1: LoanRecord                  │
├────────────────────────────────────┤
│ id = 5001                          │
│ relicId = 1001                     │
│ relicName = "青铜鼎"               │
│ borrowerId = 2001                  │
│ borrowerName = "张三"              │
│ borrowerUnit = "国家博物馆"        │
│ borrowerPhone = "13800138000"      │
│ loanDate = 2024-05-01 09:00:00     │
│ expectedReturnDate = 2024-06-01    │
│ actualReturnDate = null            │
│ purpose = "文物展览"               │
│ status = "已批准"                  │
│ approverName = "李四"              │
│ approveTime = 2024-04-25 14:30:00  │
│ approveRemark = "同意借展"         │
└────────────────────────────────────┘
            △
            │ borrowerId
            │
┌────────────────────────────────────┐
│ user1: SysUser                     │
├────────────────────────────────────┤
│ id = 2001                          │
│ username = "zhangsan"              │
│ realName = "张三"                  │
│ email = "zhangsan@museum.com"      │
│ phone = "13800138000"              │
│ status = 1                         │
│ roleId = 3                         │
│ roleName = "借展人"                │
│ roleCode = "LOANER"                │
│ loginFailedCount = 0               │
│ accountLocked = 0                  │
│ lastLoginTime = 2024-05-11 08:30:00│
│ lastLoginIp = "192.168.1.100"      │
└────────────────────────────────────┘


┌────────────────────────────────────┐
│ category1: CulturalRelicCategory   │
├────────────────────────────────────┤
│ id = 1                             │
│ categoryName = "青铜器"            │
│ parentId = null                    │
│ description = "商周时期青铜器"     │
│ createTime = 2024-01-01 00:00:00   │
└────────────────────────────────────┘
            △
            │ categoryId
            │
            └─────────────────────────┐
                                      │
                                      │
┌────────────────────────────────────┐
│ relic1: CulturalRelic              │
│ (同上)                             │
└────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                    修复业务场景对象图                                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────┐
│ relic2: CulturalRelic              │
├────────────────────────────────────┤
│ id = 1002                          │
│ relicCode = "WW-2024-002"          │
│ relicName = "唐三彩马"             │
│ categoryId = 2                     │
│ categoryName = "陶瓷器"            │
│ era = "唐代"                       │
│ material = "陶瓷"                  │
│ origin = "陕西西安"                │
│ status = "修复中"                  │
│ createTime = 2024-02-10 11:20:00   │
└────────────────────────────────────┘
            △
            │ relicId
            │
┌────────────────────────────────────┐
│ repair1: RepairRecord              │
├────────────────────────────────────┤
│ id = 6001                          │
│ repairCode = "REP-2024-001"        │
│ relicId = 1002                     │
│ status = "修复中"                  │
│ priority = "高"                    │
│ applicantId = 3001                 │
│ applyDate = 2024-04-20 10:00:00    │
│ repairReason = "表面釉层脱落"      │
│ damageDescription = "马腿部位釉层脱落约5cm²" │
│ estimatedCost = 50000.00           │
│ approver = "王五"                  │
│ approveDate = 2024-04-22 15:00:00  │
│ approveRemark = "批准修复"         │
│ repairExpert = "赵六"              │
│ startDate = 2024-04-25 09:00:00    │
│ completeDate = null                │
│ repairProcess = "清洗、补釉、烧制" │
│ repairMethod = "传统修复工艺"      │
│ actualCost = null                  │
│ qualityScore = null                │
└────────────────────────────────────┘
            △
            │ applicantId
            │
┌────────────────────────────────────┐
│ user2: SysUser                     │
├────────────────────────────────────┤
│ id = 3001                          │
│ username = "curator01"             │
│ realName = "李明"                  │
│ email = "liming@museum.com"        │
│ phone = "13900139000"              │
│ status = 1                         │
│ roleId = 2                         │
│ roleName = "文物保管员"            │
│ roleCode = "CURATOR"               │
│ loginFailedCount = 0               │
│ accountLocked = 0                  │
│ lastLoginTime = 2024-05-11 09:15:00│
│ lastLoginIp = "192.168.1.101"      │
└────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                    操作日志场景对象图                                         │
└─────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────┐
│ user3: SysUser                     │
├────────────────────────────────────┤
│ id = 1001                          │
│ username = "admin"                 │
│ realName = "系统管理员"            │
│ roleCode = "ADMIN"                 │
└────────────────────────────────────┘
            △
            │ userId
            │
┌────────────────────────────────────┐
│ log1: SysOperationLog              │
├────────────────────────────────────┤
│ id = 10001                         │
│ userId = 1001                      │
│ username = "admin"                 │
│ operationType = "新增"             │
│ operationModule = "文物管理"       │
│ operationContent = "新增文物"      │
│ requestMethod = "POST"             │
│ requestUrl = "/relics"             │
│ requestParams = "{relicName:...}"  │
│ responseData = "{code:200,...}"    │
│ ipAddress = "192.168.1.1"          │
│ operationTime = 2024-05-11 10:30:00│
│ executionTime = 125                │
│ status = 1                         │
└────────────────────────────────────┘
            │
            │
            ▼
┌────────────────────────────────────┐
│ log2: SysOperationLog              │
├────────────────────────────────────┤
│ id = 10002                         │
│ userId = 1001                      │
│ username = "admin"                 │
│ operationType = "修改"             │
│ operationModule = "文物管理"       │
│ operationContent = "修改文物状态"  │
│ requestMethod = "PUT"              │
│ requestUrl = "/relics/batch/status"│
│ requestParams = "{ids:[1001],...}" │
│ responseData = "{code:200,...}"    │
│ ipAddress = "192.168.1.1"          │
│ operationTime = 2024-05-11 10:35:00│
│ executionTime = 89                 │
│ status = 1                         │
└────────────────────────────────────┘


┌─────────────────────────────────────────────────────────────────────────────┐
│                    AI查询场景对象图                                           │
└─────────────────────────────────────────────────────────────────────────────┘

┌────────────────────────────────────┐
│ session1: AiChatSession            │
├────────────────────────────────────┤
│ id = 7001                          │
│ userId = 2001                      │
│ sessionTitle = "查询青铜器"        │
│ createTime = 2024-05-11 14:00:00   │
│ updateTime = 2024-05-11 14:05:00   │
└────────────────────────────────────┘
            △
            │ sessionId
            │
┌────────────────────────────────────┐
│ message1: AiChatMessage            │
├────────────────────────────────────┤
│ id = 8001                          │
│ sessionId = 7001                   │
│ role = "user"                      │
│ content = "有哪些商代青铜器？"     │
│ createTime = 2024-05-11 14:00:00   │
└────────────────────────────────────┘
            │
            │
            ▼
┌────────────────────────────────────┐
│ message2: AiChatMessage            │
├────────────────────────────────────┤
│ id = 8002                          │
│ sessionId = 7001                   │
│ role = "assistant"                 │
│ content = "我们馆藏有以下商代青铜器：\n1. 青铜鼎(WW-2024-001)..." │
│ createTime = 2024-05-11 14:00:05   │
└────────────────────────────────────┘
            │
            │
            ▼
┌────────────────────────────────────┐
│ message3: AiChatMessage            │
├────────────────────────────────────┤
│ id = 8003                          │
│ sessionId = 7001                   │
│ role = "user"                      │
│ content = "青铜鼎的详细信息"       │
│ createTime = 2024-05-11 14:05:00   │
└────────────────────────────────────┘
```

### 对象图说明

1. **借展业务场景**: 展示了一个完整的借展流程中的对象实例
   - 文物对象 (relic1)
   - 借展记录对象 (loan1)
   - 借展人对象 (user1)
   - 文物分类对象 (category1)

2. **修复业务场景**: 展示了文物修复过程中的对象实例
   - 文物对象 (relic2)
   - 修复记录对象 (repair1)
   - 保管员对象 (user2)

3. **操作日志场景**: 展示了系统操作日志的记录
   - 管理员对象 (user3)
   - 多个操作日志对象 (log1, log2)

4. **AI查询场景**: 展示了AI对话会话的对象结构
   - 会话对象 (session1)
   - 多个消息对象 (message1, message2, message3)

---
## 4. 序列图 (Sequence Diagram)

序列图展示了对象之间的交互顺序和消息传递过程。

### 4.1 借展申请与审批时序图

```
借展人          前端           Controller        Service          Mapper         数据库        通知服务
                                                                                            
  提交借展申请>                                                                            
                POST /loan/apply>                                                           
                                applyLoan()>                                            
                                                检查文物状态>                            
                                                                SELECT>              
                                                                <文物信息              
                                                <文物可借展                            
                                                创建借展记录>                            
                                                                INSERT>              
                                                                <成功              
                                                发送通知>
                                                                                            
                                <申请成功                                            
                <200 OK                                                            
  <申请已提交                                                                            
                                                                                            
  
审批员          前端           Controller        Service          Mapper         数据库        通知服务
                                                                                            
  审批借展申请>                                                                            
                POST /loan/approve>                                                         
                                approveLoan()>                                            
                                                更新记录状态>                            
                                                                UPDATE>              
                                                                <成功              
                                                更新文物状态>                            
                                                                UPDATE>              
                                                                <成功              
                                                发送通知>
                                                                                            
                                <审批成功                                            
                <200 OK                                                            
  <审批完成                                                                            
```

### 4.2 修复申请与进度跟踪时序图

```
保管员          前端           Controller        Service          Mapper         数据库        通知服务
                                                                                            
  提交修复申请>                                                                            
                POST /repair/apply>                                                         
                                applyRepair()>                                            
                                                检查文物状态>                            
                                                                SELECT>              
                                                                <文物信息              
                                                检查专家状态>                            
                                                                SELECT>              
                                                                <专家信息              
                                                创建修复记录>                            
                                                                INSERT>              
                                                                <成功              
                                                发送通知>
                                <申请成功                                            
                <200 OK                                                            
  <申请已提交                                                                            
                                                                                            

审批员          前端           Controller        Service          Mapper         数据库        通知服务
                                                                                            
  审批修复申请>                                                                            
                POST /repair/approve>                                                       
                                approveRepair()>                                           
                                                更新记录状态>                            
                                                                UPDATE>              
                                                更新文物状态>                            
                                                                UPDATE>              
                                                发送通知>
                                <审批成功                                            
                <200 OK                                                            
  <审批完成                                                                            
                                                                                            

专家            前端           Controller        Service          Mapper         数据库
                                                                              
  更新修复进度>                                                              
                POST /repair/progress>                                        
                                updateProgress()>                            
                                                更新进度>              
                                                                UPDATE>
                                                                <成功
                                <更新成功                              
                <200 OK                                              
  <进度已更新                                                              
```

### 4.3 AI智能查询时序图

```
用户            前端           Controller        Service        DeepSeek API    Mapper         数据库
                                                                                            
  输入查询问题>                                                                            
                POST /ai/query>                                                            
                                queryRelics()>                                            
                                                提取关键词>                            
                                                                                            
                                                查询馆藏文物>              
                                                                              SELECT>
                                                                              <文物列表
                                                <馆藏结果              
                                                                                            
                                                调用DeepSeek API>                           
                                                                HTTP POST>              
                                                                <AI响应              
                                                <AI分析结果                            
                                                                                            
                                                保存会话记录>              
                                                                              INSERT>
                                                保存消息记录>              
                                                                              INSERT>
                                                                                            
                                <查询结果                                            
                <200 OK + JSON                                                            
  <显示结果                                                                            
```

### 4.4 用户登录认证时序图

```
用户            前端           Controller        Service          Mapper         数据库        Redis
                                                                                            
  输入用户名密码>                                                                           
                POST /auth/login>                                                           
                                login()>                                            
                                                查询用户信息>                            
                                                                SELECT>              
                                                                <用户信息              
                                                <用户对象                            
                                                                                            
                                                验证密码>                            
                                                <验证成功                            
                                                                                            
                                                生成JWT Token>                            
                                                <Token                            
                                                                                            
                                                缓存Token>
                                                                                            
                                                更新登录信息>                            
                                                                UPDATE>              
                                                                <成功              
                                                                                            
                                                记录操作日志>                            
                                                                INSERT>              
                                                                                            
                                <登录成功+Token                                            
                <200 OK + Token                                                          
  <登录成功                                                                            
                                                                                            
  后续请求>                                                                            
                GET /relics (Header: Token)>                                                
                                验证Token>
                                                                              <Token有效
                                pageRelics()>                                            
                                                查询文物列表>                            
                                                                SELECT>              
                                                                <文物列表              
                                <分页结果                                            
                <200 OK + Data                                                            
  <显示数据                                                                            
```

### 4.5 文物图片上传时序图

```
保管员          前端           Controller        Service          FileUtil       Mapper         数据库
                                                                                            
  选择图片上传>                                                                            
                POST /relics/{id}/images>                                                   
                                uploadImage()>                                            
                                                检查文物存在>                            
                                                                SELECT>              
                                                                <文物信息              
                                                <文物存在                            
                                                                                            
                                                验证文件类型>                            
                                                <验证通过                            
                                                                                            
                                                保存文件到磁盘>                            
                                                <文件路径                            
                                                                                            
                                                创建图片关联>              
                                                                              INSERT>
                                                                              <成功
                                                                                            
                                                更新文物图片路径>              
                                                                              UPDATE>
                                                                              <成功
                                                                                            
                                <上传成功+路径                                            
                <200 OK + Path                                                            
  <上传完成                                                                            
```

### 4.6 数据备份时序图

```
定时任务        BackupService    BackupUtil       数据库          文件系统
                                                                
  触发备份任务>                                            
                    executeBackup()>                            
                                    检查配置>              
                                    <配置信息              
                                                                
                                    导出数据库>              
                                                  mysqldump>
                                                  <SQL文件
                                    <SQL数据              
                                                                
                                    压缩文件>
                                                                创建ZIP>
                                                                <ZIP文件
                                    <压缩完成              
                                                                              
                                    保存备份记录>              
                                                  INSERT>              
                                                  <成功              
                                                                              
                                    清理过期备份>              
                                                                删除旧文件>
                                                                <删除成功
                                    <清理完成              
                                                                              
                    <备份成功                                          
  <任务完成                                                          
```

# 5.协作图 (Collaboration Diagram)

协作图（也称为通信图）展示了对象之间的交互关系和消息传递顺序，强调对象之间的组织结构。

### 5.1 文物管理协作图

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         文物管理协作图                                        │
│                    (添加文物并上传图片)                                       │
└─────────────────────────────────────────────────────────────────────────────┘

                    1: saveWithImage(relic, imageFile)
    ┌──────────────────────────────────────────────────────────────┐
    │                                                              │
    ▼                                                              │

┌─────────────────────┐                                           │
│  :CulturalRelic     │                                           │
│  Controller         │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 2: getCurrentUserId()                                        │
    │ 3: getCurrentUserRealName()                                  │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :UserContextUtil   │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 4: saveWithImage(relic, imageFile, uploaderId, uploaderName)│
    ▼                                                              │
┌─────────────────────┐                                           │
│  :CulturalRelic     │                                           │
│  Service            │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 5: generateRelicCode()                                       │
    │                                                              │
    │ 6: insert(relic)                                             │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :CulturalRelic     │                                           │
│  Mapper             │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 7: INSERT INTO cultural_relic                                │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :MySQL Database    │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 8: uploadFile(imageFile)                                     │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :FileStorageUtil   │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 9: saveImageRelation(relicId, imagePath, uploaderId)        │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :RelicImageRelation│                                           │
│  Service            │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 10: insert(relation)                                         │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :RelicImageRelation│                                           │
│  Mapper             │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 11: INSERT INTO relic_image_relation                         │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :MySQL Database    │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 12: logDataChange(...)                                       │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :SysOperationLog   │                                           │
│  Service            │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 13: insert(log)                                              │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :SysOperationLog   │                                           │
│  Mapper             │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 14: INSERT INTO sys_operation_log                            │
    ▼                                                              │
┌─────────────────────┐                                           │
│  :MySQL Database    │                                           │
└─────────────────────┘                                           │
    │                                                              │
    │ 15: Result.success(relicId)                                  │
    └──────────────────────────────────────────────────────────────┘
```
### 5.2 借展流程协作图

    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                         借展申请与审批协作图                                  │
    └─────────────────────────────────────────────────────────────────────────────┘
    
                        1: applyLoan(loanRecord)
        ┌──────────────────────────────────────────────────────────────┐
        │                                                              │
        ▼                                                              │
    
    ┌─────────────────────┐                                           │
    │  :LoanRecord        │                                           │
    │  Controller         │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 2: getCurrentUserId()                                        │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :UserContextUtil   │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 3: applyLoan(loanRecord)                                     │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :LoanRecord        │                                           │
    │  Service            │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 4: getById(relicId)                                          │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :CulturalRelic     │                                           │
    │  Service            │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 5: selectById(relicId)                                       │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :CulturalRelic     │                                           │
    │  Mapper             │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 6: SELECT * FROM cultural_relic WHERE id = ?                 │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :MySQL Database    │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 7: checkRelicStatus(relic)                                   │
        │    [status == "在库"]                                        │
        │                                                              │
        │ 8: insert(loanRecord)                                        │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :LoanRecord        │                                           │
    │  Mapper             │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 9: INSERT INTO loan_record                                   │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :MySQL Database    │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 10: sendNotification(approverRole, message)                  │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :Notification      │                                           │
    │  Service            │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 11: insert(notification)                                     │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :Notification      │                                           │
    │  Mapper             │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 12: INSERT INTO notification                                 │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :MySQL Database    │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 13: sendWebSocketMessage(userId, notification)               │
        ▼                                                              │
    ┌─────────────────────┐                                           │
    │  :WebSocket         │                                           │
    │  Handler            │                                           │
    └─────────────────────┘                                           │
        │                                                              │
        │ 14: Result.success()                                         │
        └──────────────────────────────────────────────────────────────┘
# 6.活动图 (Activity Diagram)

活动图展示了业务流程中的活动顺序、决策点和并发流程。

## 6.1 借展申请活动图

    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                         借展申请流程活动图                                    │
    └─────────────────────────────────────────────────────────────────────────────┘
    
        (开始)
          │
          ▼
    
    ┌─────────────────┐
    │  用户登录系统   │
    └─────────────────┘
          │
          ▼
    ┌─────────────────┐
    │  浏览文物列表   │
    └─────────────────┘
          │
          ▼
    ┌─────────────────┐
    │  选择要借展的   │
    │    文物         │
    └─────────────────┘
          │
          ▼
    ┌─────────────────┐
    │  填写借展申请   │
    │  • 借展日期     │
    │  • 归还日期     │
    │  • 借展目的     │
    │  • 联系方式     │
    └─────────────────┘
          │
          ▼
    ┌─────────────────┐
    │  提交申请       │
    └─────────────────┘
          │
          ▼
        ◇───────────────◇
        │ 文物是否可借？ │
        ◇───────────────◇
          │           │
          │ 否        │ 是
          │           │
          ▼           ▼
    ┌─────────────┐ ┌─────────────────┐
    │ 返回错误提示│ │ 创建借展记录    │
    │ "文物不可借"│ │ 状态: 待审批    │
    └─────────────┘ └─────────────────┘
          │           │
          │           ▼
          │     ┌─────────────────┐
          │     │ 发送通知给审批员│
          │     └─────────────────┘
          │           │
          │           ▼
          │     ┌─────────────────┐
          │     │ 显示申请成功    │
          │     │ 等待审批        │
          │     └─────────────────┘
          │           │
          └───────────┘
                      │
                      ▼
                ┌─────────────────┐
                │ 审批员收到通知  │
                └─────────────────┘
                      │
                      ▼
                ┌─────────────────┐
                │ 审批员查看申请  │
                │ 详情            │
                └─────────────────┘
                      │
                      ▼
                ◇───────────────◇
                │ 是否批准？     │
                ◇───────────────◇
                  │           │
                  │ 拒绝      │ 批准
                  │           │
                  ▼           ▼
            ┌─────────────┐ ┌─────────────────┐
            │ 更新记录状态│ │ 更新记录状态    │
            │ 状态: 已拒绝│ │ 状态: 已批准    │
            └─────────────┘ └─────────────────┘
                  │           │
                  │           ▼
                  │     ┌─────────────────┐
                  │     │ 更新文物状态    │
                  │     │ 状态: 借展中    │
                  │     └─────────────────┘
                  │           │
                  ▼           ▼
            ┌─────────────────────────┐
            │ 发送通知给借展人        │
            │ (审批结果)              │
            └─────────────────────────┘
                  │
                  ▼
            ┌─────────────────┐
            │ 借展人收到通知  │
            └─────────────────┘
                  │
                  ▼
                ◇───────────────◇
                │ 是否批准？     │
                ◇───────────────◇
                  │           │
                  │ 否        │ 是
                  │           │
                  ▼           ▼
            ┌─────────────┐ ┌─────────────────┐
            │ 流程结束    │ │ 按时归还文物    │
            └─────────────┘ └─────────────────┘
                  │           │
                  │           ▼
                  │     ┌─────────────────┐
                  │     │ 保管员确认归还  │
                  │     └─────────────────┘
                  │           │
                  │           ▼
                  │     ┌─────────────────┐
                  │     │ 更新借展记录    │
                  │     │ 记录归还日期    │
                  │     └─────────────────┘
                  │           │
                  │           ▼
                  │     ┌─────────────────┐
                  │     │ 更新文物状态    │
                  │     │ 状态: 在库      │
                  │     └─────────────────┘
                  │           │
                  └───────────┘
                              │
                              ▼
                          (结束)
## 6.2 AI智能查询活动图

```

┌─────────────────────────────────────────────────────────────────────────────┐
│                         AI智能查询流程活动图                                  │
└─────────────────────────────────────────────────────────────────────────────┘

    (开始)
      │
      ▼

┌─────────────────┐
│  用户登录系统   │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│  进入AI查询页面 │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│  输入查询问题   │
│  (自然语言)     │
└─────────────────┘
      │
      ▼
┌─────────────────┐
│  提交查询请求   │
└─────────────────┘
      │
      ▼
╔═══════════════════════════════════════════════════════════╗
║                    后台处理 (并行)                        ║
╚═══════════════════════════════════════════════════════════╝
      │
      ├─────────────────────┬─────────────────────┐
      │                     │                     │
      ▼                     ▼                     ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│ 提取关键词  │     │ 创建会话    │     │ 保存用户    │
│ • NLP分词   │     │ 记录        │     │ 消息        │
│ • 同义词扩展│     └─────────────┘     └─────────────┘
└─────────────┘           │                     │
      │                   │                     │
      ▼                   │                     │
┌─────────────┐           │                     │
│ 查询馆藏文物│           │                     │
│ • 名称匹配  │           │                     │
│ • 年代匹配  │           │                     │
│ • 材质匹配  │           │                     │
└─────────────┘           │                     │
      │                   │                     │
      ▼                   │                     │
    ◇───────────◇         │                     │
    │ 找到文物？ │         │                     │
    ◇───────────◇         │                     │
      │       │           │                     │
      │ 是    │ 否        │                     │
      │       │           │                     │
      ▼       ▼           │                     │
┌─────────┐ ┌─────────┐  │                     │
│ 返回馆藏│ │ 馆藏结果│  │                     │
│ 文物列表│ │ 为空    │  │                     │
└─────────┘ └─────────┘  │                     │
      │       │           │                     │
      └───┬───┘           │                     │
          │               │                     │
          ▼               │                     │
    ┌─────────────┐       │                     │
    │ 调用DeepSeek│       │                     │
    │ AI API      │       │                     │
    │ • 发送问题  │       │                     │
    │ • 发送馆藏  │       │                     │
    │   结果      │       │                     │
    └─────────────┘       │                     │
          │               │                     │
          ▼               │                     │
    ┌─────────────┐       │                     │
    │ 等待AI响应  │       │                     │
    └─────────────┘       │                     │
          │               │                     │
          ▼               │                     │
    ┌─────────────┐       │                     │
    │ 接收AI分析  │       │                     │
    │ 结果        │       │                     │
    └─────────────┘       │                     │
          │               │                     │
          ▼               │                     │
    ◇───────────────◇     │                     │
    │ 需要网络搜索？│     │                     │
    ◇───────────────◇     │                     │
      │           │       │                     │
      │ 是        │ 否    │                     │
      │           │       │                     │
      ▼           │       │                     │
┌─────────────┐   │       │                     │
│ 调用百度搜索│   │       │                     │
│ API         │   │       │                     │
└─────────────┘   │       │                     │
      │           │       │                     │
      ▼           │       │                     │
┌─────────────┐   │       │                     │
│ 解析搜索结果│   │       │                     │
│ • 提取标题  │   │       │                     │
│ • 提取摘要  │   │       │                     │
│ • 提取图片  │   │       │                     │
└─────────────┘   │       │                     │
      │           │       │                     │
      └───────────┘       │                     │
                  │       │                     │
                  ▼       │                     │
            ┌─────────────┐                     │
            │ 整合查询结果│                     │
            │ • 馆藏文物  │                     │
            │ • AI分析    │                     │
            │ • 网络资料  │                     │
            └─────────────┘                     │
                  │                             │
                  ├─────────────────────────────┘
                  │
                  ▼
            ┌─────────────┐
            │ 保存AI响应  │
            │ 消息        │
            └─────────────┘
                  │
                  ▼
            ┌─────────────┐
            │ 返回结果给  │
            │ 前端        │
            └─────────────┘
                  │
                  ▼
            ┌─────────────┐
            │ 前端展示结果│
            │ • 文物卡片  │
            │ • AI解答    │
            │ • 相关图片  │
            └─────────────┘
                  │
                  ▼
            ◇───────────────◇
            │ 用户是否继续？│
            ◇───────────────◇
              │           │
              │ 是        │ 否
              │           │
              ▼           ▼
        ┌─────────────┐ (结束)
        │ 输入新问题  │
        │ (多轮对话)  │
        └─────────────┘
              │
              └──────────┐
                         │
                         ▼
                   (返回输入问题)

```



# 7. 状态图 (State Diagram)


状态图展示了对象在其生命周期中的状态变化和状态转换条件。


## 7.1 文物状态图

    ┌─────────────────────────────────────────────────────────────────────────────┐
    │                         文物生命周期状态图                                    │
    └─────────────────────────────────────────────────────────────────────────────┘
    
        ●─────────────────────────────────────────────────────────────────────────●
        │                                                                         │
        ▼                                                                         │
    
    ┌─────────────┐                                                               │
    │   新建      │ 创建文物记录                                                   │
    │  (CREATED)  │ ─────────────────────────────────────────────────────────────┘
    └─────────────┘
        │
        │ 入库操作 / 设置基本信息
        ▼
    ┌─────────────┐
    │   在库      │ ◄─────────────────────────────────────────────────────────┐
    │ (IN_STOCK)  │                                                           │
    └─────────────┘                                                           │
        │     ▲                                                               │
        │     │                                                               │
        │     │ 归还 / 更新状态                                               │
        │     │                                                               │
        │     │                                                               │
        │ 借展申请通过 / 更新状态                                             │
        │     │                                                               │
        ▼     │                                                               │
    ┌─────────────┐                                                           │
    │   借展中    │                                                           │
    │ (ON_LOAN)   │                                                           │
    └─────────────┘                                                           │
        │                                                                     │
        │ 逾期 / 系统检查                                                      │
        ▼                                                                     │
    ┌─────────────┐                                                           │
    │   逾期      │                                                           │
    │ (OVERDUE)   │ ──────────────────────────────────────────────────────────┘
    └─────────────┘
        │
        │ 强制归还 / 管理员操作
        └─────────────────────────────────────────────────────────────────────┐
                                                                              │
    ┌─────────────┐                                                           │
    │   在库      │ ◄─────────────────────────────────────────────────────────┘
    │ (IN_STOCK)  │
    └─────────────┘
        │
        │ 发现损坏 / 申请修复
        ▼
    ┌─────────────┐
    │   修复中    │
    │(REPAIRING)  │
    └─────────────┘
        │
        │ 修复完成 / 质量验收
        ▼
    ┌─────────────┐
    │   在库      │
    │ (IN_STOCK)  │
    └─────────────┘
        │
        │ 报废申请 / 管理员审批
        ▼
    ┌─────────────┐
    │   已报废    │
    │ (SCRAPPED)  │
    └─────────────┘
        │
        │
        ▼
        ●
## 7.2 借展记录状态图

```

┌─────────────────────────────────────────────────────────────────────────────┐
│                         借展记录生命周期状态图                                │
└─────────────────────────────────────────────────────────────────────────────┘

    ●
    │
    │ 用户提交申请 / 创建记录
    ▼

┌─────────────┐
│   待审批    │
│ (PENDING)   │
└─────────────┘
    │     │
    │     │ 审批员拒绝 / 记录拒绝原因
    │     ▼
    │ ┌─────────────┐
    │ │   已拒绝    │
    │ │ (REJECTED)  │
    │ └─────────────┘
    │     │
    │     │
    │     ▼
    │     ●
    │
    │ 审批员批准 / 更新文物状态
    ▼
┌─────────────┐
│   已批准    │
│ (APPROVED)  │
└─────────────┘
    │
    │ 到达借展日期 / 系统自动更新
    ▼
┌─────────────┐
│   借展中    │
│ (ACTIVE)    │
└─────────────┘
    │     │
    │     │ 超过归还日期 / 系统检查
    │     ▼
    │ ┌─────────────┐
    │ │   逾期      │
    │ │ (OVERDUE)   │
    │ └─────────────┘
    │     │
    │     │ 归还文物 / 保管员确认
    │     │
    │ 按时归还 / 保管员确认
    │     │
    └─────┼─────────────────────────────────────────────────────────┐
          │                                                         │
          ▼                                                         │
    ┌─────────────┐                                                 │
    │   已归还    │ ◄───────────────────────────────────────────────┘
    │ (RETURNED)  │
    └─────────────┘
          │
          │
          ▼
          ●
```
## 7.3 修复记录状态图

```

┌─────────────────────────────────────────────────────────────────────────────┐
│                         修复记录生命周期状态图                                │
└─────────────────────────────────────────────────────────────────────────────┘

    ●
    │
    │ 保管员提交申请 / 创建记录
    ▼

┌─────────────┐
│   待审批    │
│ (PENDING)   │
└─────────────┘
    │     │
    │     │ 审批员拒绝 / 记录拒绝原因
    │     ▼
    │ ┌─────────────┐
    │ │   已拒绝    │
    │ │ (REJECTED)  │
    │ └─────────────┘
    │     │
    │     │
    │     ▼
    │     ●
    │
    │ 审批员批准 / 分配专家
    ▼
┌─────────────┐
│   待修复    │
│(APPROVED)   │
└─────────────┘
    │
    │ 专家开始修复 / 记录开始时间
    ▼
┌─────────────┐
│   修复中    │
│(IN_PROGRESS)│
└─────────────┘
    │     │
    │     │ 修复暂停 / 专家操作
    │     ▼
    │ ┌─────────────┐
    │ │   已暂停    │
    │ │ (PAUSED)    │
    │ └─────────────┘
    │     │
    │     │ 恢复修复 / 专家操作
    │     │
    │     └─────────────────────────────────────────────────────────┐
    │                                                               │
    │ 修复完成 / 专家提交                                           │
    │                                                               │
    └─────┼───────────────────────────────────────────────────────────┘
          │
          ▼
    ┌─────────────┐
    │   待验收    │
    │(COMPLETED)  │
    └─────────────┘
          │     │
          │     │ 质量不合格 / 保管员评估
          │     ▼
          │ ┌─────────────┐
          │ │   返工      │
          │ │ (REWORK)    │ ──────────────────────────────────────────┐
          │ └─────────────┘                                           │
          │                                                           │
          │ 质量合格 / 保管员评估                                     │
          │                                                           │
          ▼                                                           │
    ┌─────────────┐                                                   │
    │   已验收    │                                                   │
    │ (ACCEPTED)  │                                                   │
    └─────────────┘                                                   │
          │                                                           │
          │                                                           │
          ▼                                                           │
          ●                                                           │
                                                                      │
                                                                      │
          专家重新修复 / 更新进度                                     │
          ┌─────────────────────────────────────────────────────────────┘
          │
          ▼
    ┌─────────────┐
    │   修复中    │
    │(IN_PROGRESS)│
    └─────────────┘

```
## 7.4 用户账户状态图

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         用户账户生命周期状态图                                │
└─────────────────────────────────────────────────────────────────────────────┘

    ●
    │
    │ 管理员创建账户 / 设置初始信息
    ▼

┌─────────────┐
│   待激活    │
│ (INACTIVE)  │
└─────────────┘
    │
    │ 用户首次登录 / 激活账户
    ▼
┌─────────────┐
│   正常      │ ◄─────────────────────────────────────────────────────────┐
│ (ACTIVE)    │                                                           │
└─────────────┘                                                           │
    │     │                                                               │
    │     │ 连续登录失败 / 超过限制次数                                   │
    │     ▼                                                               │
    │ ┌─────────────┐                                                     │
    │ │   已锁定    │                                                     │
    │ │ (LOCKED)    │                                                     │
    │ └─────────────┘                                                     │
    │     │                                                               │
    │     │ 管理员解锁 / 重置失败次数                                     │
    │     │                                                               │
    │     └─────────────────────────────────────────────────────────────┘
    │
    │ 管理员禁用 / 违规操作
    ▼
┌─────────────┐
│   已禁用    │
│ (DISABLED)  │
└─────────────┘
    │
    │ 管理员启用 / 恢复权限
    └─────────────────────────────────────────────────────────────────────┐
                                                                          │
┌─────────────┐                                                           │
│   正常      │ ◄─────────────────────────────────────────────────────────┘
│ (ACTIVE)    │
└─────────────┘
    │
    │ 管理员删除 / 注销账户
    ▼
┌─────────────┐
│   已删除    │
│ (DELETED)   │
└─────────────┘
    │
    │
    ▼
    ●

```
# 8.组件图 (Component Diagram)

组件图展示了系统的组件结构和组件之间的依赖关系。

## 8.1 系统整体组件架构

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         博物馆文物管理系统组件图                              │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              前端层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │   Vue 3 Core    │  │   Router        │  │   Pinia Store   │             │
│  │   • 响应式系统  │  │   • 路由管理    │  │   • 状态管理    │             │
│  │   • 组件系统    │  │   • 导航守卫    │  │   • 数据缓存    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│           └─────────────────────┼─────────────────────┘                     │
│                                 │                                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │  Element Plus   │  │   Axios HTTP    │  │   WebSocket     │             │
│  │  • UI组件库     │  │   • HTTP请求    │  │   • 实时通信    │             │
│  │  • 表单验证     │  │   • 拦截器      │  │   • 消息推送    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│           └─────────────────────┼─────────────────────┘                     │
│                                 │                                           │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │   Three.js      │  │   QRCode.js     │  │   Chart.js      │             │
│  │   • 3D模型展示  │  │   • 二维码生成  │  │   • 数据可视化  │             │
│  │   • 模型交互    │  │   • 扫码识别    │  │   • 统计图表    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ HTTP/WebSocket
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              网关层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │   Nginx         │  │   SSL/TLS       │  │   Load Balancer │             │
│  │   • 反向代理    │  │   • HTTPS加密   │  │   • 负载均衡    │             │
│  │   • 静态资源    │  │   • 证书管理    │  │   • 健康检查    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ HTTP
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              控制层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Spring MVC      │  │ JWT Security    │  │ WebSocket       │             │
│  │ • RESTful API   │  │ • 身份认证      │  │ • 实时通信      │             │
│  │ • 请求映射      │  │ • 权限控制      │  │ • 消息广播      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Exception       │  │ Validation      │  │ CORS Config     │             │
│  │ Handler         │  │ • 参数验证      │  │ • 跨域配置      │             │
│  │ • 异常处理      │  │ • 数据校验      │  │ • 请求过滤      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ Service调用
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              业务层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Cultural Relic  │  │ Loan Record     │  │ Repair Record   │             │
│  │ Service         │  │ Service         │  │ Service         │             │
│  │ • 文物管理      │  │ • 借展管理      │  │ • 修复管理      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ User Service    │  │ AI Service      │  │ Notification    │             │
│  │ • 用户管理      │  │ • AI查询        │  │ Service         │             │
│  │ • 权限管理      │  │ • 智能分析      │  │ • 消息通知      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ File Storage    │  │ Statistics      │  │ Operation Log   │             │
│  │ Service         │  │ Service         │  │ Service         │             │
│  │ • 文件管理      │  │ • 统计分析      │  │ • 操作日志      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ Mapper调用
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              持久层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ MyBatis-Plus    │  │ Connection Pool │  │ Transaction     │             │
│  │ • ORM映射       │  │ • 连接池管理    │  │ Manager         │             │
│  │ • SQL生成       │  │ • 连接复用      │  │ • 事务管理      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Data Mapper     │  │ Cache Manager   │  │ SQL Interceptor │             │
│  │ • 数据映射      │  │ • 缓存管理      │  │ • SQL拦截       │             │
│  │ • CRUD操作      │  │ • 缓存策略      │  │ • 性能监控      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ JDBC
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              数据层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ MySQL 8.0       │  │ Redis 6.0+      │  │ File System     │             │
│  │ • 业务数据存储  │  │ • 缓存存储      │  │ • 文件存储      │             │
│  │ • 事务支持      │  │ • 会话存储      │  │ • 图片/文档     │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 网络连接
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              外部服务                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ DeepSeek API    │  │ Baidu AI API    │  │ Email Service   │             │
│  │ • AI对话        │  │ • 图像识别      │  │ • 邮件发送      │             │
│  │ • 智能分析      │  │ • 文字识别      │  │ • 通知推送      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘

```
##  8.2 前端组件架构

```

┌─────────────────────────────────────────────────────────────────────────────┐
│                         前端组件架构图                                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              应用层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ App.vue         │  │ Router Config   │  │ Store Config    │             │
│  │ • 根组件        │  │ • 路由配置      │  │ • 状态配置      │             │
│  │ • 全局布局      │  │ • 权限路由      │  │ • 全局状态      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 组件依赖
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              页面层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Login Page      │  │ Dashboard Page  │  │ Relic Page      │             │
│  │ • 登录页面      │  │ • 仪表盘页面    │  │ • 文物管理页面  │             │
│  │ • 用户认证      │  │ • 数据概览      │  │ • 文物列表      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Loan Page       │  │ Repair Page     │  │ AI Chat Page    │             │
│  │ • 借展管理页面  │  │ • 修复管理页面  │  │ • AI查询页面    │             │
│  │ • 借展流程      │  │ • 修复流程      │  │ • 智能对话      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 组件组合
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              组件层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Layout          │  │ Header          │  │ Sidebar         │             │
│  │ Components      │  │ Components      │  │ Components      │             │
│  │ • 布局组件      │  │ • 头部组件      │  │ • 侧边栏组件    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Form            │  │ Table           │  │ Dialog          │             │
│  │ Components      │  │ Components      │  │ Components      │             │
│  │ • 表单组件      │  │ • 表格组件      │  │ • 对话框组件    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Chart           │  │ 3D Viewer       │  │ QR Code         │             │
│  │ Components      │  │ Components      │  │ Components      │             │
│  │ • 图表组件      │  │ • 3D展示组件    │  │ • 二维码组件    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 工具依赖
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              工具层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ HTTP Utils      │  │ Storage Utils   │  │ Validation      │             │
│  │ • HTTP请求      │  │ • 本地存储      │  │ Utils           │             │
│  │ • 拦截器        │  │ • 缓存管理      │  │ • 表单验证      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Date Utils      │  │ File Utils      │  │ Permission      │             │
│  │ • 日期处理      │  │ • 文件处理      │  │ Utils           │             │
│  │ • 格式化        │  │ • 上传下载      │  │ • 权限检查      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘

```
## 8.3 后端组件架构

```

┌─────────────────────────────────────────────────────────────────────────────┐
│                         后端组件架构图                                       │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────┐
│                              应用启动层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Application     │  │ Configuration   │  │ Bean Factory    │             │
│  │ • 应用入口      │  │ • 配置管理      │  │ • 依赖注入      │             │
│  │ • 启动流程      │  │ • 属性绑定      │  │ • 生命周期      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 组件装配
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              控制器层                                       │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Relic           │  │ Loan            │  │ Repair          │             │
│  │ Controller      │  │ Controller      │  │ Controller      │             │
│  │ • 文物接口      │  │ • 借展接口      │  │ • 修复接口      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ User            │  │ AI              │  │ Statistics      │             │
│  │ Controller      │  │ Controller      │  │ Controller      │             │
│  │ • 用户接口      │  │ • AI接口        │  │ • 统计接口      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 服务调用
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              服务层                                         │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Relic Service   │  │ Loan Service    │  │ Repair Service  │             │
│  │ Impl            │  │ Impl            │  │ Impl            │             │
│  │ • 文物业务      │  │ • 借展业务      │  │ • 修复业务      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ User Service    │  │ AI Service      │  │ File Service    │             │
│  │ Impl            │  │ Impl            │  │ Impl            │             │
│  │ • 用户业务      │  │ • AI业务        │  │ • 文件业务      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 数据访问
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              数据访问层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Relic Mapper    │  │ Loan Mapper     │  │ Repair Mapper   │             │
│  │ • 文物数据访问  │  │ • 借展数据访问  │  │ • 修复数据访问  │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ User Mapper     │  │ Log Mapper      │  │ Category Mapper │             │
│  │ • 用户数据访问  │  │ • 日志数据访问  │  │ • 分类数据访问  │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                 │
                                 │ 工具组件
                                 ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              工具组件层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ JWT Util        │  │ File Util       │  │ QR Code Util    │             │
│  │ • JWT处理       │  │ • 文件处理      │  │ • 二维码生成    │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Date Util       │  │ Validation      │  │ Exception       │             │
│  │ • 日期处理      │  │ Util            │  │ Handler         │             │
│  │                 │  │ • 数据验证      │  │ • 异常处理      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
```
# 9.部署图 (Deployment Diagram)

部署图展示了系统的物理架构，包括硬件节点、软件组件的部署以及节点之间的通信关系。

##  9.1 生产环境部署架构

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         生产环境部署架构图                                    │
└─────────────────────────────────────────────────────────────────────────────┘

                                 Internet
                                    │
                                    │ HTTPS
                                    ▼

┌─────────────────────────────────────────────────────────────────────────────┐
│                              负载均衡层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                    Load Balancer (Nginx)                               │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Server: LB-01   │  │ Server: LB-02   │  │ SSL Certificate │        │ │
│  │  │ IP: 10.0.1.10   │  │ IP: 10.0.1.11   │  │ • HTTPS加密     │        │ │
│  │  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│  │ • 证书管理      │        │ │
│  │  │ CPU: 4 Core     │  │ CPU: 4 Core     │  └─────────────────┘        │ │
│  │  │ RAM: 8GB        │  │ RAM: 8GB        │                               │ │
│  │  │ • 反向代理      │  │ • 反向代理      │                               │ │
│  │  │ • 负载均衡      │  │ • 负载均衡      │                               │ │
│  │  │ • 静态资源      │  │ • 静态资源      │                               │ │
│  │  └─────────────────┘  └─────────────────┘                               │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ HTTP
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              应用服务层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ App Server 01   │  │ App Server 02   │  │ App Server 03   │             │
│  │ IP: 10.0.2.10   │  │ IP: 10.0.2.11   │  │ IP: 10.0.2.12   │             │
│  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│             │
│  │ CPU: 8 Core     │  │ CPU: 8 Core     │  │ CPU: 8 Core     │             │
│  │ RAM: 16GB       │  │ RAM: 16GB       │  │ RAM: 16GB       │             │
│  │ Storage: 200GB  │  │ Storage: 200GB  │  │ Storage: 200GB  │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Java 17         │  │ Java 17         │  │ Java 17         │             │
│  │ Spring Boot     │  │ Spring Boot     │  │ Spring Boot     │             │
│  │ • 文物管理模块  │  │ • 借展管理模块  │  │ • AI查询模块    │             │
│  │ • 用户管理模块  │  │ • 修复管理模块  │  │ • 统计分析模块  │             │
│  │ • 文件管理模块  │  │ • 通知管理模块  │  │ • 日志管理模块  │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ JDBC/Redis
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              数据存储层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                        MySQL Cluster                                   │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Master DB       │  │ Slave DB 01     │  │ Slave DB 02     │        │ │
│  │  │ IP: 10.0.3.10   │  │ IP: 10.0.3.11   │  │ IP: 10.0.3.12   │        │ │
│  │  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│        │ │
│  │  │ CPU: 16 Core    │  │ CPU: 16 Core    │  │ CPU: 16 Core    │        │ │
│  │  │ RAM: 32GB       │  │ RAM: 32GB       │  │ RAM: 32GB       │        │ │
│  │  │ Storage: 2TB SSD│  │ Storage: 2TB SSD│  │ Storage: 2TB SSD│        │ │
│  │  │ MySQL 8.0       │  │ MySQL 8.0       │  │ MySQL 8.0       │        │ │
│  │  │ • 主数据库      │  │ • 读从库        │  │ • 读从库        │        │ │
│  │  │ • 写操作        │  │ • 读操作        │  │ • 读操作        │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                        Redis Cluster                                   │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Redis Master    │  │ Redis Slave 01  │  │ Redis Slave 02  │        │ │
│  │  │ IP: 10.0.4.10   │  │ IP: 10.0.4.11   │  │ IP: 10.0.4.12   │        │ │
│  │  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│        │ │
│  │  │ CPU: 8 Core     │  │ CPU: 8 Core     │  │ CPU: 8 Core     │        │ │
│  │  │ RAM: 16GB       │  │ RAM: 16GB       │  │ RAM: 16GB       │        │ │
│  │  │ Storage: 500GB  │  │ Storage: 500GB  │  │ Storage: 500GB  │        │ │
│  │  │ Redis 6.0+      │  │ Redis 6.0+      │  │ Redis 6.0+      │        │ │
│  │  │ • 缓存主节点    │  │ • 缓存从节点    │  │ • 缓存从节点    │        │ │
│  │  │ • 会话存储      │  │ • 读取缓存      │  │ • 读取缓存      │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ NFS/CIFS
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              文件存储层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                        File Storage Cluster                            │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ File Server 01  │  │ File Server 02  │  │ Backup Server   │        │ │
│  │  │ IP: 10.0.5.10   │  │ IP: 10.0.5.11   │  │ IP: 10.0.5.20   │        │ │
│  │  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│        │ │
│  │  │ CPU: 8 Core     │  │ CPU: 8 Core     │  │ CPU: 4 Core     │        │ │
│  │  │ RAM: 16GB       │  │ RAM: 16GB       │  │ RAM: 8GB        │        │ │
│  │  │ Storage: 10TB   │  │ Storage: 10TB   │  │ Storage: 20TB   │        │ │
│  │  │ • 文物图片      │  │ • 3D模型文件    │  │ • 数据备份      │        │ │
│  │  │ • 档案文档      │  │ • 系统文件      │  │ • 文件备份      │        │ │
│  │  │ • 日志文件      │  │ • 临时文件      │  │ • 历史数据      │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                    │
                                    │ API调用
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                              外部服务层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ DeepSeek API    │  │ Baidu AI API    │  │ Email Service   │             │
│  │ • AI对话服务    │  │ • 图像识别      │  │ • 邮件发送      │             │
│  │ • 智能分析      │  │ • OCR识别       │  │ • 短信通知      │             │
│  │ • 外部接口      │  │ • 外部接口      │  │ • 外部接口      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘


                              网络连接说明

┌─────────────────────────────────────────────────────────────────────────────┐
│  • Internet ←→ Load Balancer: HTTPS (443)                                  │
│  • Load Balancer ←→ App Servers: HTTP (8080)                               │
│  • App Servers ←→ MySQL: JDBC (3306)                                       │
│  • App Servers ←→ Redis: Redis Protocol (6379)                             │
│  • App Servers ←→ File Storage: NFS/HTTP (2049/80)                         │
│  • App Servers ←→ External APIs: HTTPS (443)                               │
│  • MySQL Master ←→ MySQL Slaves: Replication (3306)                        │
│  • Redis Master ←→ Redis Slaves: Replication (6379)                        │
│  • File Servers ←→ Backup Server: Rsync/SCP (22)                           │
└─────────────────────────────────────────────────────────────────────────────┘

```
## 9.2 开发环境部署架构

```

┌─────────────────────────────────────────────────────────────────────────────┐
│                         开发环境部署架构图                                    │
└─────────────────────────────────────────────────────────────────────────────┘

                              Developer Machine
                                    │
                                    │ HTTP
                                    ▼

┌─────────────────────────────────────────────────────────────────────────────┐
│                              开发服务器                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                    Development Server                                   │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Frontend Dev    │  │ Backend Dev     │  │ Database Dev    │        │ │
│  │  │ Server          │  │ Server          │  │ Server          │        │ │
│  │  │ IP: localhost   │  │ IP: localhost   │  │ IP: localhost   │        │ │
│  │  │ Port: 5173      │  │ Port: 8080      │  │ Port: 3306      │        │ │
│  │  │ OS: Windows 11  │  │ OS: Windows 11  │  │ OS: Windows 11  │        │ │
│  │  │ CPU: 8 Core     │  │ CPU: 8 Core     │  │ CPU: 8 Core     │        │ │
│  │  │ RAM: 16GB       │  │ RAM: 16GB       │  │ RAM: 16GB       │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  │           │                     │                     │                │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Node.js 18+     │  │ Java 17         │  │ MySQL 8.0       │        │ │
│  │  │ Vue 3           │  │ Spring Boot     │  │ • 开发数据库    │        │ │
│  │  │ Vite            │  │ • 热重载        │  │ • 测试数据      │        │ │
│  │  │ • 热重载        │  │ • 调试模式      │  │ • 本地存储      │        │ │
│  │  │ • 开发模式      │  │ • 日志输出      │  │                 │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                        Development Tools                                │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Redis (Docker)  │  │ File Storage    │  │ External APIs   │        │ │
│  │  │ Port: 6379      │  │ Local Folder    │  │ Mock Services   │        │ │
│  │  │ • 缓存测试      │  │ • 本地文件      │  │ • API模拟       │        │ │
│  │  │ • 会话存储      │  │ • 图片存储      │  │ • 测试数据      │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘


                              开发工具链

┌─────────────────────────────────────────────────────────────────────────────┐
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ IDE Tools       │  │ Version Control │  │ Build Tools     │             │
│  │ • IntelliJ IDEA │  │ • Git           │  │ • Maven         │             │
│  │ • VS Code       │  │ • GitHub        │  │ • npm/yarn      │             │
│  │ • Database Tool │  │ • 版本管理      │  │ • 构建打包      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Debug Tools     │  │ Test Tools      │  │ Monitor Tools   │             │
│  │ • 断点调试      │  │ • JUnit         │  │ • 日志监控      │             │
│  │ • 热重载        │  │ • Jest          │  │ • 性能监控      │             │
│  │ • 实时预览      │  │ • 单元测试      │  │ • 错误追踪      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘

```
##  9.3 测试环境部署架构

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         测试环境部署架构图                                    │
└─────────────────────────────────────────────────────────────────────────────┘

                              Test Network
                                    │
                                    │ HTTP
                                    ▼

┌─────────────────────────────────────────────────────────────────────────────┐
│                              测试服务层                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                        Test Environment                                 │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Web Server      │  │ App Server      │  │ Database Server │        │ │
│  │  │ IP: 192.168.1.10│  │ IP: 192.168.1.11│  │ IP: 192.168.1.12│        │ │
│  │  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│  │ OS: Ubuntu 20.04│        │ │
│  │  │ CPU: 4 Core     │  │ CPU: 8 Core     │  │ CPU: 4 Core     │        │ │
│  │  │ RAM: 8GB        │  │ RAM: 16GB       │  │ RAM: 8GB        │        │ │
│  │  │ Storage: 100GB  │  │ Storage: 200GB  │  │ Storage: 500GB  │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  │           │                     │                     │                │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Nginx           │  │ Java 17         │  │ MySQL 8.0       │        │ │
│  │  │ • 反向代理      │  │ Spring Boot     │  │ • 测试数据库    │        │ │
│  │  │ • 静态资源      │  │ • 测试配置      │  │ • 测试数据      │        │ │
│  │  │ • 负载均衡      │  │ • 日志记录      │  │ • 数据重置      │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
│                                    │                                         │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                        Test Support Services                           │ │
│  │  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐        │ │
│  │  │ Redis Server    │  │ File Server     │  │ Mock Services   │        │ │
│  │  │ IP: 192.168.1.13│  │ IP: 192.168.1.14│  │ IP: 192.168.1.15│        │ │
│  │  │ • 缓存服务      │  │ • 文件存储      │  │ • API模拟       │        │ │
│  │  │ • 会话管理      │  │ • 测试文件      │  │ • 外部服务模拟  │        │ │
│  │  └─────────────────┘  └─────────────────┘  └─────────────────┘        │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘


                              测试工具链

┌─────────────────────────────────────────────────────────────────────────────┐
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ CI/CD Pipeline  │  │ Test Automation │  │ Performance     │             │
│  │ • Jenkins       │  │ • Selenium      │  │ Testing         │             │
│  │ • GitLab CI     │  │ • Postman       │  │ • JMeter        │             │
│  │ • 自动部署      │  │ • 自动化测试    │  │ • 压力测试      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
│           │                     │                     │                     │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐             │
│  │ Quality Gate    │  │ Test Report     │  │ Monitor Tools   │             │
│  │ • 代码质量检查  │  │ • 测试报告      │  │ • 日志收集      │             │
│  │ • 安全扫描      │  │ • 覆盖率报告    │  │ • 性能监控      │             │
│  │ • 依赖检查      │  │ • 缺陷跟踪      │  │ • 告警通知      │             │
│  └─────────────────┘  └─────────────────┘  └─────────────────┘             │
└─────────────────────────────────────────────────────────────────────────────┘

```

```

### 部署说明

#### 9.1 生产环境特点
- **高可用性**: 负载均衡器双机热备，应用服务器集群部署
- **数据安全**: MySQL主从复制，Redis集群，定期数据备份
- **性能优化**: 读写分离，缓存策略，CDN加速
- **监控告警**: 全链路监控，实时告警，日志分析

#### 9.2 开发环境特点
- **快速开发**: 热重载，实时预览，快速调试
- **本地化**: 所有服务本地部署，减少网络依赖
- **工具集成**: IDE集成，版本控制，构建工具
- **模拟服务**: 外部API模拟，测试数据生成

#### 9.3 测试环境特点
- **自动化**: CI/CD流水线，自动化测试，自动部署
- **质量保证**: 代码质量检查，安全扫描，性能测试
- **环境隔离**: 独立的测试环境，数据隔离
- **监控分析**: 测试报告，性能分析，缺陷跟踪

---

## 总结

本文档完整展示了博物馆文物数字化管理系统的9种UML图：

1. **用例图**: 展示了系统功能需求和角色交互关系
2. **类图**: 描述了系统的静态结构和类之间的关系
3. **对象图**: 展示了系统运行时的对象实例快照
4. **序列图**: 描述了对象间按时间顺序的交互过程
5. **协作图**: 强调了对象间的组织结构和消息传递
6. **活动图**: 展示了业务流程中的活动顺序和决策点
7. **状态图**: 描述了对象在生命周期中的状态变化
8. **组件图**: 展示了系统的组件结构和依赖关系
9. **部署图**: 描述了系统的物理架构和部署环境

这些UML图从不同角度全面描述了系统的架构设计，为系统开发、维护和扩展提供了重要的参考依据。通过这些图表，开发团队可以更好地理解系统需求、设计架构、规划开发和部署实施。

---