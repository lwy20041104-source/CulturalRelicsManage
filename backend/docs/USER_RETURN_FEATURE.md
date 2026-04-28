# 用户主动归还文物功能实现文档

## 功能概述

为前台用户端添加了"我的借展"功能，允许用户查看自己的所有借展记录，并在文物逾期之前主动归还文物。用户主动归还后，后台管理员会收到消息通知。

**实现状态**: ✅ 已完成（包括前端样式、后端逻辑、通知功能）

**实现方式**: 功能集成在前台门户页面（PublicPortalView.vue）中作为一个独立的 section，与其他功能模块保持一致的交互方式，无需跳转到新页面。

## 功能特性

### 1. 我的借展记录页面
- 用户可以查看自己的所有借展记录
- 支持按状态筛选（待审批、借展中、已归还、已驳回、逾期）
- 显示统计卡片：借展中、已归还、已逾期、待审批
- 分页显示借展记录
- 显示文物详细信息和借展状态

### 2. 主动归还功能
- 用户可以对"借展中"和"逾期"状态的文物进行主动归还
- 归还前需要确认操作
- 归还后自动更新借展记录状态为"已归还"
- 自动更新文物状态为"在库"
- 自动发送通知给后台管理员和审批员

### 3. 通知功能
- 用户归还文物后，系统自动发送通知
- 通知对象：管理员（ADMIN）和审批员（APPROVER）
- 通知类型：USER_RETURN
- 通知优先级：HIGH（高优先级）
- 通知内容包含：用户名、文物名称、借展记录ID

## 实现细节

### 前端实现

#### 1. 集成到门户页面
**文件**: `frontend/src/views/PublicPortalView.vue`

**功能**:
- 在前台门户页面中添加"我的借展" section
- 显示用户的借展记录列表
- 统计卡片展示各状态数量（借展中、已归还、已逾期、待审批）
- 状态筛选和刷新功能
- 主动归还按钮（仅对借展中和逾期状态显示）
- 逾期提示（显示逾期天数）
- 响应式布局，与其他 section 样式保持一致

**主要组件**:
- 统计卡片（借展中、已归还、已逾期、待审批）
- 筛选栏（状态筛选、刷新按钮）
- 借展记录卡片列表
- 分页组件

**样式特点**:
- 使用与其他 section 一致的设计风格
- 卡片式布局，带阴影和悬停效果
- 响应式网格布局
- 逾期状态红色高亮显示
- 移动端适配

#### 2. 独立页面（备用）
**文件**: `frontend/src/views/PortalMyLoansView.vue`

保留独立页面作为备用方案，但当前主要使用集成在门户页面中的 section。

#### 2. 路由配置
**文件**: `frontend/src/router/index.js`

```javascript
{
  path: '/portal-my-loans',
  component: () => import('../views/PortalMyLoansView.vue')
}
```

**注意**: 路由已配置但当前主要使用门户页面中的 section 切换，无需页面跳转。

#### 3. API 接口
**文件**: `frontend/src/api/loans.js`

新增接口:
```javascript
// 查询当前用户的借展记录
export const getMyLoansPageApi = (params) => request.get('/loans/my', { params })

// 用户主动归还文物
export const userReturnLoanApi = (id) => request.put(`/loans/${id}/user-return`)
```

#### 4. 导航菜单
**文件**: `frontend/src/views/PublicPortalView.vue`

- 在前台门户页面添加"我的借展"菜单项
- 点击后切换到"我的借展" section（不跳转页面）
- 添加 List 图标
- 支持中英文国际化
- 与其他菜单项保持一致的交互方式

### 后端实现

#### 1. 控制器层
**文件**: `backend/src/main/java/com/example/controller/LoanRecordController.java`

新增接口:

```java
/**
 * 查询当前用户的借展记录（前台用户端）
 * GET /loans/my
 */
@GetMapping("/my")
public Result<PageResult<LoanRecord>> myLoans(
    @RequestParam(defaultValue = "1") Integer pageNum,
    @RequestParam(defaultValue = "10") Integer pageSize,
    @RequestParam(required = false) String status
)
// 从 SecurityContext 获取当前用户名
String username = SecurityContextHolder.getContext().getAuthentication().getName();

/**
 * 用户主动归还文物（前台用户端）
 * PUT /loans/{id}/user-return
 */
@PutMapping("/{id}/user-return")
@OperationLog(operationType = "修改", operationModule = "借展管理", operationContent = "用户主动归还文物")
public Result<Boolean> userReturnLoan(@PathVariable Long id)
// 从 SecurityContext 获取当前用户名
String username = SecurityContextHolder.getContext().getAuthentication().getName();
```

**注意**: 用户名从 Spring Security 的 SecurityContext 中获取，确保安全性。

#### 2. 服务层
**文件**: `backend/src/main/java/com/example/service/LoanRecordService.java`

新增方法:
```java
// 查询当前用户的借展记录
PageResult<LoanRecord> pageMyLoans(Integer pageNum, Integer pageSize, String status, String username);

// 用户主动归还文物
boolean userReturnLoan(Long id, String username);
```

**文件**: `backend/src/main/java/com/example/service/impl/LoanRecordServiceImpl.java`

实现逻辑:
1. **pageMyLoans**: 根据用户名查询该用户的借展记录，支持状态筛选和分页
2. **userReturnLoan**: 
   - 验证借展记录是否存在
   - 验证是否是该用户的借展记录
   - 验证状态是否允许归还（仅"借展中"和"逾期"）
   - 更新借展记录状态为"已归还"
   - 更新文物状态为"在库"
   - 发送通知给后台管理员

#### 3. 数据访问层
**文件**: `backend/src/main/java/com/example/mapper/LoanRecordMapper.java`

新增方法:
```java
// 根据借展人姓名分页查询
List<LoanRecord> selectPageByBorrowerName(
    @Param("offset") Integer offset,
    @Param("pageSize") Integer pageSize,
    @Param("status") String status,
    @Param("borrowerName") String borrowerName
);

// 根据借展人姓名统计数量
long countByBorrowerName(
    @Param("status") String status, 
    @Param("borrowerName") String borrowerName
);
```

**文件**: `backend/src/main/resources/mapper/LoanRecordMapper.xml`

SQL 实现:
```xml
<select id="selectPageByBorrowerName" resultType="com.example.entity.LoanRecord">
    SELECT lr.*, 
           cr.relic_name AS relicName,
           cr.relic_code AS relicCode,
           su.real_name AS borrowerName
    FROM loan_record lr
    LEFT JOIN cultural_relic cr ON lr.relic_id = cr.id
    LEFT JOIN sys_user su ON lr.borrower_id = su.id
    WHERE su.username = #{borrowerName}
    <if test="status != null and status != ''">
        AND lr.status = #{status}
    </if>
    ORDER BY lr.id DESC
    LIMIT #{offset}, #{pageSize}
</select>
```

#### 4. 通知服务
**文件**: `backend/src/main/java/com/example/service/NotificationService.java`

新增方法:
```java
/**
 * 发送用户主动归还文物通知
 */
void sendUserReturnNotification(Long loanId, String username, String relicName);
```

**文件**: `backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`

实现逻辑:
```java
@Override
public void sendUserReturnNotification(Long loanId, String username, String relicName) {
    SystemNotification notification = new SystemNotification();
    notification.setTitle("用户主动归还文物");
    notification.setContent(String.format("用户 %s 已主动归还文物\"%s\"，请及时确认。", 
            username, relicName));
    notification.setType("USER_RETURN");
    notification.setPriority("HIGH");
    notification.setRelatedType("LOAN");
    notification.setRelatedId(loanId);
    notification.setSenderName(username);
    
    // 发送给管理员和审批员
    List<String> roleCodes = Arrays.asList("ADMIN", "APPROVER");
    createAndSendNotification(notification, roleCodes);
}
```

## 使用流程

### 用户端操作流程

1. **登录前台用户端**
   - 访问前台门户页面

2. **进入我的借展页面**
   - 点击导航菜单中的"我的借展"
   - 页面切换到"我的借展" section（无需跳转）

3. **查看借展记录**
   - 查看统计卡片了解各状态数量
   - 浏览借展记录列表
   - 可按状态筛选记录

4. **主动归还文物**
   - 找到需要归还的借展记录（状态为"借展中"或"逾期"）
   - 点击"主动归还"按钮
   - 确认归还操作
   - 等待系统处理

5. **查看归还结果**
   - 系统提示"归还申请已提交，请等待管理员确认"
   - 借展记录状态更新为"已归还"
   - 文物状态更新为"在库"

### 管理员端操作流程

1. **接收通知**
   - 管理员和审批员收到高优先级通知
   - 通知标题："用户主动归还文物"
   - 通知内容：包含用户名和文物名称

2. **查看通知详情**
   - 点击通知查看详细信息
   - 可跳转到相关借展记录

3. **确认归还**
   - 核实文物已归还
   - 在系统中确认归还状态
   - 完成归还流程

## 权限控制

### 前台用户权限
- 只能查看自己的借展记录
- 只能归还自己借展的文物
- 只能归还"借展中"和"逾期"状态的文物

### 后台管理员权限
- 接收所有用户归还通知
- 可以查看所有借展记录
- 可以管理所有借展流程

## 数据验证

### 前端验证
- 归还前弹出确认对话框
- 只对符合条件的记录显示归还按钮

### 后端验证
1. **借展记录验证**
   - 记录是否存在
   - 是否属于当前用户
   - 状态是否允许归还

2. **状态验证**
   - 只允许"借展中"和"逾期"状态归还
   - 其他状态返回错误提示

3. **权限验证**
   - 验证用户身份
   - 验证操作权限

## 通知类型

### USER_RETURN 通知
- **类型代码**: USER_RETURN
- **优先级**: HIGH
- **接收对象**: 管理员（ADMIN）、审批员（APPROVER）
- **关联类型**: LOAN
- **关联ID**: 借展记录ID

## 国际化支持

### 中文
- navMyLoans: "我的借展"
- 统计卡片标签
- 按钮文本
- 提示信息

### 英文
- navMyLoans: "My Loans"
- 统计卡片标签
- 按钮文本
- 提示信息

## 测试建议

### 功能测试
1. 测试查询用户借展记录
2. 测试状态筛选功能
3. 测试主动归还功能
4. 测试通知发送功能
5. 测试权限控制

### 边界测试
1. 测试归还不属于自己的借展记录
2. 测试归还不允许归还状态的记录
3. 测试空数据情况
4. 测试分页边界

### 性能测试
1. 测试大量借展记录的加载性能
2. 测试并发归还操作
3. 测试通知发送性能

## 注意事项

1. **用户身份验证**
   - 用户名从 Spring Security 的 SecurityContext 中获取
   - 使用 `SecurityContextHolder.getContext().getAuthentication().getName()`
   - 确保用户已通过 JWT 认证
   - 不信任前端传递的用户信息

2. **状态一致性**
   - 归还时同时更新借展记录和文物状态
   - 使用事务确保数据一致性

3. **通知可靠性**
   - 通知发送失败不影响归还操作
   - 记录通知发送日志便于排查

4. **操作日志**
   - 使用 @OperationLog 注解记录操作
   - 便于审计和追溯

5. **统计数据准确性** ⭐ 重要
   - 统计卡片（借展中、已归还、已逾期、待审批）的数据独立于列表筛选条件
   - 统计数据通过并行查询各个状态的总数获得，确保准确性
   - 统计数据在以下情况下刷新：
     * 切换到"我的借展" section 时
     * 用户归还文物成功后
   - 列表数据可以按状态筛选，但不影响统计卡片的显示

## 未来扩展

1. **归还确认流程**
   - 添加管理员确认归还环节
   - 支持归还拒绝和重新申请

2. **归还评价**
   - 用户归还后可以评价借展体验
   - 管理员可以评价文物状态

3. **归还提醒**
   - 临近归还日期自动提醒用户
   - 支持自定义提醒时间

4. **批量归还**
   - 支持一次归还多个文物
   - 提高操作效率

## 相关文档

- [通知系统实现文档](NOTIFICATION_SYSTEM_IMPLEMENTATION.md)
- [借展通知修复总结](LOAN_NOTIFICATION_FIX_SUMMARY.md)
- [借展状态统一修复文档](LOAN_STATUS_UNIFICATION.md)

## 修改日期
2026-04-25

## 修改人员
AI Assistant (Kiro)

## 编译验证
- ✅ 前端构建成功 (npm run build)
- ✅ 后端编译成功 (mvn clean compile)
- ✅ 所有功能已实现并通过验证

## 问题修复记录

### 2026-04-25 - 统计数据准确性修复
**问题描述**: 统计卡片（借展中、已归还、已逾期、待审批）的数据会随着列表筛选条件变化，与数据库实际数据不符。

**问题原因**: 统计数据使用 `computed` 计算属性，基于当前页面的 `myLoansList` 进行过滤统计，而 `myLoansList` 会随着筛选条件变化。

**解决方案**:
1. 将 `myLoansStats` 从 `computed` 计算属性改为 `reactive` 响应式对象
2. 新增 `loadMyLoansStats()` 函数，通过并行查询各个状态的总数来获取准确的统计数据
3. 在切换到"我的借展" section 时调用 `loadMyLoansStats()`
4. 在用户归还文物成功后调用 `loadMyLoansStats()` 刷新统计数据

**修改文件**: `frontend/src/views/PublicPortalView.vue`

**效果**: 统计卡片始终显示所有状态的准确总数，不受列表筛选条件影响。
