# 借展状态统一修复文档

## 问题描述

数据大屏界面的状态分布柱状图中显示的"借展中"文物数量与数据库中的实际数量不一致。

### 根本原因

系统中存在两种不同的借展状态命名：
- **借出中**：部分代码和数据库记录使用此状态
- **借展中**：部分代码和数据库记录使用此状态

这导致统计查询时无法正确匹配所有借展记录。

## 解决方案

统一使用 **"借展中"** 作为借展状态的标准命名。

## 修改内容

### 1. 后端 Java 代码

#### 1.1 LoanRecordServiceImpl.java
- **文件路径**: `backend/src/main/java/com/example/service/impl/LoanRecordServiceImpl.java`
- **修改内容**: 
  - `approveLoan` 方法中，审批通过后设置借展记录状态为 "借展中"
  - 同时更新文物状态为 "借展中"

#### 1.2 ReportServiceImpl.java
- **文件路径**: `backend/src/main/java/com/example/service/impl/ReportServiceImpl.java`
- **修改内容**:
  - `getDashboardData` 方法：查询借展中文物数量时使用 "借展中"
  - `getDashboardData` 方法：查询借展记录统计时使用 "借展中"
  - `getStatusStats` 方法：状态统计时使用 "借展中"

#### 1.3 StatisticsController.java
- **文件路径**: `backend/src/main/java/com/example/controller/StatisticsController.java`
- **修改内容**:
  - `overview` 方法：统计借展中文物数量时使用 "借展中"

#### 1.4 RelicAiServiceImpl.java
- **文件路径**: `backend/src/main/java/com/example/service/impl/RelicAiServiceImpl.java`
- **修改内容**:
  - `expandKeyword` 方法：添加同义词映射，将 "借出" 和 "借出中" 映射到 "借展中"
  - 这样用户搜索 "借出中" 时也能找到状态为 "借展中" 的文物

#### 1.5 LoanOverdueTask.java
- **文件路径**: `backend/src/main/java/com/example/task/LoanOverdueTask.java`
- **修改内容**:
  - `markOverdueLoans` 方法：查询借展记录时使用 "借展中"

#### 1.6 LoanOverdueCheckTask.java
- **文件路径**: `backend/src/main/java/com/example/task/LoanOverdueCheckTask.java`
- **修改内容**:
  - `checkOverdueLoans` 方法：查询借展记录时使用 "借展中"

### 2. 前端 Vue 代码

#### 2.1 DataScreenView.vue
- **文件路径**: `frontend/src/views/DataScreenView.vue`
- **修改内容**:
  - 业务统计卡片中的 "借出中" 标签改为 "借展中"
  - 路由跳转参数从 `status=借出中` 改为 `status=借展中`

#### 2.2 LoansView.vue
- **文件路径**: `frontend/src/views/LoansView.vue`
- **修改内容**:
  - 状态筛选下拉框的选项值从 "借出中" 改为 "借展中"
  - 归还按钮的显示条件从 `status === '借出中'` 改为 `status === '借展中'`

#### 2.3 PublicPortalView.vue
- **文件路径**: `frontend/src/views/PublicPortalView.vue`
- **修改内容**:
  - 统计卡片中的 "借出中" 标签改为 "借展中"

#### 2.4 zh-CN.js（国际化配置）
- **文件路径**: `frontend/src/i18n/locales/zh-CN.js`
- **修改内容**:
  - `loan.onLoan` 翻译从 "借出中" 改为 "借展中"
  - 这影响借展管理界面的状态下拉框显示

### 3. SQL 脚本

#### 3.1 fix_loan_status.sql（新建）
- **文件路径**: `backend/sql/fix_loan_status.sql`
- **功能**: 数据库修复脚本
- **内容**:
  ```sql
  -- 更新借展记录表中的状态
  UPDATE loan_record 
  SET status = '借展中' 
  WHERE status = '借出中';
  
  -- 更新文物表中的状态
  UPDATE cultural_relic 
  SET status = '借展中' 
  WHERE status = '借出中';
  ```

#### 3.2 database.sql
- **文件路径**: `backend/sql/database.sql`
- **修改内容**:
  - `loan_record` 表的 INSERT 语句：将所有 "借出中" 改为 "借展中"
  - `sys_dict` 表的 INSERT 语句：将 loan_status 字典项 "借出中" 改为 "借展中"

#### 3.3 db.sql
- **文件路径**: `backend/sql/db.sql`
- **修改内容**:
  - `loan_record` 表的 INSERT 语句：将所有 "借出中" 改为 "借展中"
  - `sys_dict` 表的 INSERT 语句：将 loan_status 字典项 "借出中" 改为 "借展中"

#### 3.4 insert.sql
- **文件路径**: `backend/sql/insert.sql`
- **修改内容**:
  - `loan_record` 表的 INSERT 语句：将所有 "借出中" 改为 "借展中"

## 执行步骤

### 1. 更新代码
所有代码文件已经更新完成。

### 2. 更新数据库
执行以下 SQL 脚本更新现有数据：

```bash
# 在 MySQL 中执行
mysql -u your_username -p your_database < backend/sql/fix_loan_status.sql
```

或者在 MySQL 客户端中直接执行：

```sql
-- 更新借展记录表
UPDATE loan_record 
SET status = '借展中' 
WHERE status = '借出中';

-- 更新文物表
UPDATE cultural_relic 
SET status = '借展中' 
WHERE status = '借出中';

-- 更新字典表
UPDATE sys_dict 
SET dict_label = '借展中', dict_value = '借展中'
WHERE dict_type = 'loan_status' AND dict_value = '借出中';
```

### 3. 重启服务
```bash
# 重启后端服务
cd backend
mvn clean package
java -jar target/cultural-relics-*.jar

# 重新构建前端
cd frontend
npm run build
```

## 验证方法

### 1. 数据库验证
```sql
-- 检查借展记录状态
SELECT status, COUNT(*) as count
FROM loan_record
WHERE status IN ('待审批', '借展中', '已归还', '已驳回', '逾期')
GROUP BY status;

-- 检查文物状态
SELECT status, COUNT(*) as count
FROM cultural_relic
WHERE status IN ('在库', '借展中', '修复中')
GROUP BY status;

-- 检查字典表
SELECT * FROM sys_dict WHERE dict_type = 'loan_status';
```

### 2. 前端验证
1. 访问数据大屏页面
2. 查看状态分布柱状图中 "借展中" 的数量
3. 查看业务统计卡片中 "借展中" 的数量
4. 两者应该一致

### 3. 功能验证
1. 在借展管理页面，筛选状态为 "借展中" 的记录
2. 审批一条借展申请，检查状态是否正确设置为 "借展中"
3. 检查文物详情页面，状态应显示为 "借展中"
4. 使用 AI 查询功能搜索 "借出中"，应该能找到状态为 "借展中" 的文物

## 影响范围

### 受影响的功能模块
1. **数据大屏** - 状态统计图表
2. **借展管理** - 状态筛选和显示
3. **文物管理** - 状态显示
4. **统计报表** - 借展统计
5. **AI 查询** - 状态搜索
6. **定时任务** - 逾期检查
7. **公共门户** - 统计展示

### 不受影响的功能
- 文物分类管理
- 修复记录管理
- 维护记录管理
- 用户权限管理
- 操作日志

## 注意事项

1. **数据一致性**: 必须先执行 SQL 更新脚本，确保数据库中的状态统一
2. **缓存清理**: 如果使用了 Redis 缓存，需要清理相关缓存
3. **前端刷新**: 用户需要刷新浏览器页面以加载新的前端代码
4. **向后兼容**: AI 查询功能保留了对 "借出中" 的支持，会自动映射到 "借展中"

## 测试建议

### 单元测试
- 测试 `LoanRecordServiceImpl.approveLoan` 方法
- 测试 `ReportServiceImpl.getDashboardData` 方法
- 测试 `RelicAiServiceImpl.expandKeyword` 方法

### 集成测试
- 测试借展审批流程
- 测试数据大屏数据加载
- 测试借展记录查询和筛选

### 回归测试
- 测试所有涉及借展状态的功能
- 确保状态显示和统计正确

## 修复日期
2026-04-25

## 修复人员
AI Assistant (Kiro)

## 相关文档
- [借展通知调试文档](LOAN_NOTIFICATION_DEBUG.md)
- [借展通知修复总结](LOAN_NOTIFICATION_FIX_SUMMARY.md)
- [通知系统实现文档](NOTIFICATION_SYSTEM_IMPLEMENTATION.md)
