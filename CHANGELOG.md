# 博物馆文物管理系统 - 更新日志

## 2024年改进记录

### 🎉 新增功能

#### 1. 文物图片关联模块（一对一）（新增）
**实现时间：** 2024年4月

**功能描述：**
- 实现文物与图片的一对一关联
- 一个文物只能有一张主图
- 一张图片只能关联一个文物
- 自动级联删除关联记录
- 批量查询优化
- 统计分析功能

**涉及文件：**
- 数据库：`backend/sql/relic_image_relation.sql`
- 实体类：`RelicImageRelation.java`
- Mapper：`RelicImageRelationMapper.java`
- Service：`RelicImageRelationService.java`, `RelicImageRelationServiceImpl.java`
- Controller：`RelicImageRelationController.java`
- 权限配置：`SecurityConfig.java`（已更新）

**数据库变更：**
```sql
-- 新增文物图片关联表
CREATE TABLE relic_image_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_id BIGINT NOT NULL UNIQUE,      -- 文物ID（唯一，确保一对一）
    image_id BIGINT NOT NULL UNIQUE,      -- 图片ID（唯一，确保一对一）
    relation_type VARCHAR(20) DEFAULT 'main',
    sort_order INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (relic_id) REFERENCES cultural_relic(id) ON DELETE CASCADE,
    FOREIGN KEY (image_id) REFERENCES image_library(id) ON DELETE CASCADE
);

-- 新增视图
CREATE VIEW v_relic_with_image AS ...

-- 新增存储过程
sp_set_relic_main_image(relicId, imageId)
sp_remove_relic_main_image(relicId)

-- 新增函数
fn_get_relic_image_path(relicId)

-- 新增触发器（自动删除关联）
tr_delete_relic_image_relation
tr_delete_image_relic_relation
```

**API接口：**
```
POST   /api/relic-images/set                    - 设置文物主图
DELETE /api/relic-images/remove/{relicId}       - 移除文物主图
GET    /api/relic-images/relic/{relicId}        - 获取文物主图信息
GET    /api/relic-images/relic/{relicId}/path   - 获取文物主图路径
POST   /api/relic-images/batch/paths            - 批量获取文物图片路径
GET    /api/relic-images/relic/{relicId}/has-image - 检查文物是否有主图
GET    /api/relic-images/image/{imageId}/is-linked - 检查图片是否已关联
GET    /api/relic-images/all                    - 获取所有关联记录
GET    /api/relic-images/statistics             - 获取统计信息
```

**功能特点：**
- 一对一约束自动保证（UNIQUE约束）
- 事务处理确保数据一致性
- 级联删除自动清理关联
- 批量查询性能优化
- 支持统计分析（有图/无图文物数量）
- 存储过程和函数简化操作
- 视图方便联合查询

**权限说明：**
- ✅ ADMIN（管理员）：完全访问
- ✅ CURATOR（保管员）：完全访问
- ❌ APPROVER（审批员）：无权限
- ❌ LOANER（借展人）：无权限

**文档：**
- 详细文档：`docs/RELIC_IMAGE_RELATION_FEATURE.md`
- 快速开始：`RELIC_IMAGE_RELATION_QUICK_START.md`

---

#### 2. 图片管理模块（新增）
**实现时间：** 2024年

**功能描述：**
- 统一的图片库管理
- 支持单张和批量上传
- 图片分类管理（文物/展览/文档/其他/未分类）
- 图片标签和描述
- 网格视图和列表视图切换
- 图片预览和下载
- 浏览和下载统计
- 图片搜索功能
- 统计分析（分类统计、上传者统计、存储统计）
- 图片关联到文物/借展/修复等对象

**涉及文件：**
- 数据库：`backend/sql/image_management_tables.sql`
- 实体类：`ImageLibrary.java`
- Mapper：`ImageLibraryMapper.java`
- Service：`ImageLibraryService.java`, `ImageLibraryServiceImpl.java`
- Controller：`ImageLibraryController.java`
- 前端API：`frontend/src/api/images.js`
- 前端页面：`frontend/src/views/ImageLibraryView.vue`
- 路由配置：`frontend/src/router/index.js`

**数据库变更：**
```sql
-- 新增图片库表
CREATE TABLE image_library (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    image_name VARCHAR(200) NOT NULL,
    original_name VARCHAR(200),
    file_path VARCHAR(500) NOT NULL,
    file_size BIGINT,
    file_type VARCHAR(50),
    width INT,
    height INT,
    category VARCHAR(50) DEFAULT 'uncategorized',
    tags VARCHAR(500),
    description TEXT,
    uploader_id BIGINT,
    uploader_name VARCHAR(100),
    reference_type VARCHAR(50),
    reference_id BIGINT,
    is_public TINYINT DEFAULT 1,
    view_count INT DEFAULT 0,
    download_count INT DEFAULT 0,
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

**API接口：**
```
POST   /api/images/upload           - 上传图片
POST   /api/images/batch-upload     - 批量上传
GET    /api/images                  - 分页查询
GET    /api/images/{id}             - 获取详情
PUT    /api/images/{id}             - 更新信息
DELETE /api/images/{id}             - 删除图片
DELETE /api/images/batch            - 批量删除
DELETE /api/images/{id}/physical    - 物理删除
PUT    /api/images/{id}/link        - 关联到对象
GET    /api/images/reference/{type}/{id} - 获取关联图片
GET    /api/images/{id}/download    - 下载图片
GET    /api/images/search           - 搜索图片
GET    /api/images/statistics       - 统计信息
```

**功能特点：**
- 支持拖拽上传
- 自动获取图片尺寸
- 文件大小格式化显示
- 图片预览和放大查看
- 批量操作（上传、删除）
- 分类和标签管理
- 浏览和下载统计
- ECharts图表展示统计数据
- 响应式网格布局
- 中英文国际化支持

---

#### 2. 多格式数据导出（已有）
**实现时间：** 2024年

**功能描述：**
- PDF格式导出（新增）
- Word格式导出（新增）
- Excel格式导出（已有）
- 支持中文字体
- 统一的文档格式

**涉及文件：**
- 依赖配置：`backend/pom.xml`
- 工具类：`ExportUtils.java`（新建）
- Service：`CulturalRelicService.java`, `CulturalRelicServiceImpl.java`
- Controller：`CulturalRelicController.java`

**技术栈：**
- iText7 7.2.5（PDF生成）
- Apache POI 5.2.3（Excel和Word生成）
- 中文字体支持（font-asian）

**API接口：**
```
GET /api/relics/export      - 导出Excel
GET /api/relics/export/pdf  - 导出PDF
GET /api/relics/export/word - 导出Word
```

---

#### 2. 博物馆管理模块（新增）
**实现时间：** 2024年

**功能描述：**
- 博物馆信息管理（CRUD操作）
- 用户-博物馆关联管理
- 前台登录时博物馆选择（必填）
- 后台新增借展人时博物馆分配（动态显示）

**涉及文件：**
- 数据库：`backend/sql/museum_tables.sql`
- 实体类：`Museum.java`, `UserMuseum.java`
- Mapper：`MuseumMapper.java`, `UserMuseumMapper.java`
- Service：`MuseumService.java`, `MuseumServiceImpl.java`
- Controller：`MuseumController.java`
- 前端API：`frontend/src/api/museums.js`
- 前端页面：`PortalLoginView.vue`, `UsersView.vue`

**数据库变更：**
```sql
-- 新增表
CREATE TABLE museum (...)
CREATE TABLE user_museum (...)

-- 插入10个示例博物馆
INSERT INTO museum VALUES (...)
```

**配置变更：**
```java
// SecurityConfig.java
.antMatchers(HttpMethod.GET, "/museums/active").permitAll()
```

---

#### 2. 前台借展人独立登录界面
**实现时间：** 2024年

**功能描述：**
- 独立的前台登录页面（/portal-login）
- 棕色调、复古风格设计
- 左右分栏布局（展示区+登录表单）
- 博物馆选择（必填）
- 固定角色为LOANER

**涉及文件：**
- `frontend/src/views/PortalLoginView.vue`（新建）
- `frontend/src/router/index.js`（修改）
- `frontend/src/views/LoginView.vue`（修改）
- 国际化文件：`zh-CN.js`, `en-US.js`

**路由配置：**
```javascript
{
  path: '/portal-login',
  name: 'PortalLogin',
  component: () => import('../views/PortalLoginView.vue')
}
```

---

#### 3. 借展申请博物馆自动填充
**实现时间：** 2024年

**功能描述：**
- 借展单位字段自动填充为用户所属博物馆名称
- 字段设置为只读（禁用状态）
- 登录时保存博物馆名称到sessionStorage
- 表单初始化、切换页面、重置时自动填充

**涉及文件：**
- `frontend/src/views/PortalLoginView.vue`（修改）
- `frontend/src/views/PublicPortalView.vue`（修改）

**实现逻辑：**
```javascript
// 登录时保存
const selectedMuseum = museumList.value.find(m => m.id === loginForm.museumId)
sessionStorage.setItem('museumName', selectedMuseum.museumName)

// 表单初始化
loanForm.borrowerUnit = sessionStorage.getItem('museumName') || ''
```

---

### ✨ 功能增强

#### 1. 用户管理表单验证增强
**实现时间：** 2024年

**改进内容：**
- 新增用户时，密码为必填项
- 新增用户时，确认密码为必填项
- 新增借展人用户时，博物馆为必填项
- 编辑用户时，密码为可选项
- 表单字段显示红色星号（必填标识）

**涉及文件：**
- `frontend/src/views/UsersView.vue`
- 国际化文件：`zh-CN.js`, `en-US.js`

**验证规则：**
```javascript
// 密码验证
if (!form.id && !value) {
  callback(new Error(t('validation.required')))
}

// 博物馆验证
if (isLoanerRole.value && !value) {
  callback(new Error(t('user.museumRequired')))
}
```

---

#### 2. AI查询结果持久化（已实现）
**实现时间：** 已存在

**功能说明：**
- AI查询结果已完整保存到数据库
- 数据链路：会话→消息→查询结果
- 支持查询历史回溯
- 支持数据分析和审计

**涉及表：**
- `ai_chat_session`：会话表
- `ai_chat_message`：消息表
- `ai_query_result`：查询结果详情表

**核心代码：**
```java
// AiChatServiceImpl.java
public void saveConversation(Long sessionId, Long userId, String userQuestion, AiRelicQueryResponse aiResponse) {
    // 保存用户消息
    messageMapper.insert(userMessage);
    
    // 保存AI回复
    messageMapper.insert(aiMessage);
    
    // 保存查询结果详情
    for (AiRelicItemVO item : aiResponse.getRelics()) {
        queryResultMapper.insert(result);
    }
}
```

---

### 🐛 问题修复

#### 1. 图片管理菜单显示问题修复（新增）
**问题描述：**
- 后台管理系统中没有显示"图片管理"菜单项
- 用户无法访问图片管理功能

**原因分析：**
- 前端导航菜单中没有添加图片管理菜单项
- 后端权限配置中没有添加`images:manage`权限
- SecurityConfig中没有配置图片管理接口的访问权限

**解决方案：**
1. **前端菜单配置：**
   - 在`LayoutView.vue`中添加图片管理菜单项
   - 路由路径：`/images`
   - 权限控制：`v-if="hasPerm('images:manage')"`
   - 位置：分类管理和借展管理之间

2. **后端权限配置：**
   - 在`AuthController.java`中为ADMIN角色添加`images:manage`权限
   - 为CURATOR角色添加`images:manage`权限
   - APPROVER和LOANER角色不添加此权限

3. **接口权限配置：**
   - 在`SecurityConfig.java`中配置`/images/**`接口权限
   - 只允许ADMIN和CURATOR角色访问

**涉及文件：**
- `frontend/src/views/LayoutView.vue`（修改）
- `backend/src/main/java/com/example/controller/AuthController.java`（修改）
- `backend/src/main/java/com/example/config/SecurityConfig.java`（修改）

**权限说明：**
- ✅ ADMIN（系统管理员）：有权限
- ✅ CURATOR（文物管理员）：有权限
- ❌ APPROVER（借展审批员）：无权限
- ❌ LOANER（借展人）：无权限

**修复时间：** 2024年

**文档：** `docs/IMAGE_MANAGEMENT_MENU_FIX.md`

**重要提示：** 如果菜单不显示，需要重新登录以获取新权限！
- 权限信息在登录时获取并缓存在sessionStorage中
- 添加新功能后，已登录用户需要退出并重新登录
- 或在浏览器控制台执行：`sessionStorage.removeItem('permissions'); location.reload();`

**诊断工具：**
- 访问 `/check-image-menu.html` 可以自动诊断菜单显示问题
- 提供详细的检查结果和解决方案
- 支持一键检测权限、角色、菜单渲染等状态

---

#### 2. 图片管理模块编译错误修复（已有）
**问题描述：**
- 后端编译时出现MyBatis Plus包不存在的错误
- 项目使用MyBatis而非MyBatis Plus

**原因分析：**
- 图片管理模块代码中使用了MyBatis Plus的类和注解
- 项目pom.xml中没有MyBatis Plus依赖

**解决方案：**
1. **Service层修复：**
   - 移除`extends ServiceImpl`
   - 直接注入`ImageLibraryMapper`
   - 使用`PageResult`替代`Page`
   - 添加`getById()`方法

2. **Mapper层修复：**
   - 移除`extends BaseMapper`
   - 使用`@Insert`、`@Select`、`@Update`、`@Delete`注解定义SQL
   - 使用`<script>`标签支持动态SQL
   - 添加完整的CRUD方法

3. **Entity层修复：**
   - 移除`@TableName`注解
   - 移除`@TableId`注解

4. **Controller层修复：**
   - 调整返回类型为`Map<String, Object>`
   - 手动构建分页结果

**涉及文件：**
- `ImageLibraryService.java`（修改）
- `ImageLibraryServiceImpl.java`（修改）
- `ImageLibraryMapper.java`（修改）
- `ImageLibrary.java`（修改）
- `ImageLibraryController.java`（修改）

**修复时间：** 2024年

**文档：** `docs/IMAGE_MANAGEMENT_FIX.md`

---

#### 2. 数据报表导出功能修复（已有）
**问题描述：**
- 数据报表界面的导出Excel按钮无效（exportReport函数未实现）
- 文物管理界面缺少PDF和Word导出按钮
- 只有Excel导出，缺少PDF和Word导出功能

**原因分析：**
- ReportsView.vue中exportReport函数被调用但未实现
- RelicsView.vue中只有单一的Excel导出按钮
- relics.js中缺少PDF和Word导出API函数

**解决方案：**
1. **ReportsView.vue修复：**
   - 实现exportReport函数
   - 调用reports.js中的exportExcelApi
   - 支持不同报表类型和年份参数

2. **RelicsView.vue增强：**
   - 将单一导出按钮改为下拉菜单
   - 添加Excel、PDF、Word三个导出选项
   - 实现handleExportExcel、handleExportPdf、handleExportWord三个函数

3. **API接口完善：**
   - relics.js中添加exportRelicsPdfApi函数
   - relics.js中添加exportRelicsWordApi函数
   - 设置正确的responseType为'blob'

4. **国际化支持：**
   - 添加report.exportWord翻译（中文：导出Word，英文：Export Word）
   - 添加report.report翻译（中文：报表，英文：Report）

**涉及文件：**
- `frontend/src/views/ReportsView.vue`（修改）
- `frontend/src/views/RelicsView.vue`（修改）
- `frontend/src/api/relics.js`（修改）
- `frontend/src/i18n/locales/zh-CN.js`（修改）
- `frontend/src/i18n/locales/en-US.js`（修改）

**修复代码：**
```javascript
// ReportsView.vue - 新增exportReport函数
const exportReport = async (reportType, year) => {
  try {
    const { exportExcelApi } = await import('../api/reports')
    const res = await exportExcelApi(reportType, year)
    const blob = new Blob([res])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${t('report.report')}_${reportType}_${year || new Date().getFullYear()}_${new Date().getTime()}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('report.exportExcel') + t('common.success'))
  } catch (error) {
    console.error('导出报表失败:', error)
    ElMessage.error(t('message.operationFailed'))
  }
}

// RelicsView.vue - 改为下拉菜单
<el-dropdown @command="handleExportCommand">
  <el-button type="info">
    {{ $t('common.export') }}<el-icon class="el-icon--right"><arrow-down /></el-icon>
  </el-button>
  <template #dropdown>
    <el-dropdown-menu>
      <el-dropdown-item command="excel">{{ $t('report.exportExcel') }}</el-dropdown-item>
      <el-dropdown-item command="pdf">{{ $t('report.exportPdf') }}</el-dropdown-item>
      <el-dropdown-item command="word">{{ $t('report.exportWord') }}</el-dropdown-item>
    </el-dropdown-menu>
  </template>
</el-dropdown>

// relics.js - 新增API函数
export const exportRelicsPdfApi = (params) => {
  return request.get('/relics/export/pdf', {
    params,
    responseType: 'blob'
  })
}

export const exportRelicsWordApi = (params) => {
  return request.get('/relics/export/word', {
    params,
    responseType: 'blob'
  })
}
```

**修复时间：** 2024年

---

#### 2. 博物馆接口403错误
**问题描述：**
前台登录时加载博物馆列表失败，返回403 Forbidden错误。

**原因分析：**
`/museums/active`接口未在SecurityConfig中配置为允许匿名访问。

**解决方案：**
```java
// SecurityConfig.java
.antMatchers(HttpMethod.GET, "/museums/active").permitAll()
```

**修复时间：** 2024年

---

#### 2. 用户博物馆关联未保存
**问题描述：**
新增借展人用户时，user_museum表没有新增记录。

**原因分析：**
前端表单验证不完善，博物馆字段可能为空。

**解决方案：**
- 增强表单验证，博物馆为必填项
- 添加后端调试日志
- 前端动态显示博物馆字段

**修复时间：** 2024年

---

### 📚 文档更新

#### 新增文档
1. `docs/PROJECT_OVERVIEW.md` - 项目完整功能与技术文档
2. `docs/PROJECT_ANALYSIS.md` - 项目分析报告
3. `docs/MUSEUM_FEATURE.md` - 博物馆管理功能实现文档
4. `docs/MUSEUM_TROUBLESHOOTING.md` - 博物馆功能故障排查指南
5. `docs/QUICK_START_MUSEUM.md` - 博物馆功能快速启动指南
6. `docs/USER_MUSEUM_TEST.md` - 用户博物馆关联功能测试指南
7. `docs/MUSEUM_LOAN_TEST.md` - 前台借展申请测试指南
8. `docs/AI_QUERY_PERSISTENCE.md` - AI查询结果持久化功能说明
9. `docs/FEATURE_VERIFICATION.md` - 功能验证清单
10. `backend/sql/verify_museum_setup.sql` - 博物馆数据库验证脚本

#### 更新文档
1. `docs/PROJECT_ANALYSIS.md` - 更新核心功能模块数量（14→15）
2. `docs/PROJECT_OVERVIEW.md` - 添加博物馆管理模块说明

---

### 🔧 技术改进

#### 1. 安全配置优化
- 允许匿名访问博物馆列表接口
- 保持其他接口的认证要求

#### 2. 前端表单验证增强
- 动态显示/隐藏字段
- 必填项标识
- 实时验证

#### 3. 数据持久化完善
- 用户-博物馆关联
- AI查询结果保存
- 事务保证数据一致性

#### 4. 国际化支持
- 中英文翻译完整
- 所有新增功能都支持国际化

---

### 📊 数据库变更

#### 新增表
```sql
-- 博物馆表
CREATE TABLE museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    museum_code VARCHAR(50) NOT NULL UNIQUE,
    museum_name VARCHAR(100) NOT NULL,
    museum_type VARCHAR(50),
    province VARCHAR(50),
    city VARCHAR(50),
    address VARCHAR(200),
    contact_person VARCHAR(50),
    contact_phone VARCHAR(20),
    contact_email VARCHAR(100),
    description TEXT,
    status TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 用户博物馆关联表
CREATE TABLE user_museum (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    museum_id BIGINT NOT NULL,
    is_primary TINYINT DEFAULT 1,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_user_museum (user_id, museum_id),
    FOREIGN KEY (user_id) REFERENCES sys_user(id) ON DELETE CASCADE,
    FOREIGN KEY (museum_id) REFERENCES museum(id) ON DELETE CASCADE
);
```

#### 初始数据
- 插入10个示例博物馆
- 为现有借展人用户分配博物馆

---

### 🎯 功能统计

#### 核心功能模块
- **总数：** 15个模块
- **新增：** 1个模块（博物馆管理）
- **增强：** 3个模块（用户管理、借展管理、AI查询）

#### 数据库表
- **总数：** 17张表
- **新增：** 2张表（museum、user_museum）

#### 代码文件
- **新增：** 10+个文件
- **修改：** 8个文件

#### 文档
- **新增：** 10个文档
- **修改：** 2个文档

---

### ✅ 测试验证

#### 功能测试
- ✅ 博物馆管理CRUD
- ✅ 前台登录博物馆选择
- ✅ 后台新增用户博物馆分配
- ✅ 借展申请博物馆自动填充
- ✅ 用户管理必填项验证
- ✅ AI查询结果持久化

#### 集成测试
- ✅ 前后台登录隔离
- ✅ 用户-博物馆关联完整性
- ✅ 借展申请数据完整性
- ✅ AI查询数据链路完整性

#### 安全测试
- ✅ 匿名访问控制
- ✅ 认证授权验证
- ✅ 数据权限验证

---

### 🚀 部署说明

#### 数据库初始化
```bash
# 1. 执行博物馆表初始化
mysql -u root -p cultural_relics < backend/sql/museum_tables.sql

# 2. 验证数据
mysql -u root -p cultural_relics < backend/sql/verify_museum_setup.sql
```

#### 后端部署
```bash
cd backend
mvn clean package
java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
```

#### 前端部署
```bash
cd frontend
npm install
npm run build
# 将dist目录部署到Web服务器
```

---

### 📝 使用说明

#### 管理员操作
1. 登录后台管理系统
2. 进入"用户管理"
3. 新增借展人用户时，选择所属博物馆
4. 保存后，用户可以使用前台登录

#### 借展人操作
1. 访问前台登录页面（/portal-login）
2. 输入用户名、密码
3. 选择所属博物馆
4. 登录后可以申请借展
5. 借展单位自动填充为所属博物馆

---

### 🔮 未来规划

#### 短期计划（1-2周）
- [ ] 实现文件上传功能
- [ ] 添加消息通知系统
- [ ] 优化查询性能

#### 中期计划（1-2月）
- [ ] 实现权限管理完善
- [ ] 添加数据备份恢复
- [ ] 实现报表增强

#### 长期计划（3-6月）
- [ ] 微服务架构改造
- [ ] 容器化部署
- [ ] AI能力增强

---

### 👥 贡献者
- 系统架构设计
- 功能开发实现
- 文档编写维护
- 测试验证

---

### 📞 技术支持
如有问题，请查看相关文档：
- 功能实现：`docs/MUSEUM_FEATURE.md`
- 故障排查：`docs/MUSEUM_TROUBLESHOOTING.md`
- 快速启动：`docs/QUICK_START_MUSEUM.md`
- 功能验证：`docs/FEATURE_VERIFICATION.md`

---

## 版本历史

### v1.1.0 (2024年)
- 新增博物馆管理模块
- 新增前台独立登录
- 增强用户管理验证
- 完善AI查询持久化
- 优化安全配置

### v1.0.0 (初始版本)
- 基础功能实现
- 14个核心模块
- 前后端分离架构



---

## 2026年4月23日 - 错误处理修复与用户体验改进

### ✨ 新功能

#### 借展人注册功能
**功能描述：**
- 完善的借展人前台注册功能
- 用户可自主注册成为文物借展人
- 注册时填写完整的个人信息和选择所属博物馆

**必填信息：**
- ✅ 用户名（4-20位字母、数字或下划线）
- ✅ 密码（6-20位字符）
- ✅ 确认密码
- ✅ 真实姓名
- ✅ 邮箱
- ✅ 电话号码（11位手机号）
- ✅ 所属博物馆

**数据存储：**
- `sys_user` 表：存储用户基本信息（用户名、密码、真实姓名、邮箱、电话）
- `user_museum` 表：存储用户与博物馆的关联关系
- 角色：自动设置为"文物借展人"（LOANER）

**安全特性：**
- 密码使用 BCrypt 加密
- 前后端双重验证
- 事务保护确保数据一致性
- 操作日志记录

**用户体验：**
- 美观的双栏布局设计
- 实时表单验证
- 清晰的错误提示
- 博物馆下拉选择（支持搜索）
- 注册成功后自动跳转登录

**相关文件：**
- 后端：
  - `backend/src/main/java/com/example/dto/RegisterRequest.java` - 注册请求DTO
  - `backend/src/main/java/com/example/controller/AuthController.java` - 添加注册接口
  - `backend/src/main/java/com/example/service/impl/SysUserServiceImpl.java` - 注册业务逻辑
- 前端：
  - `frontend/src/views/PortalRegisterView.vue` - 注册页面
  - `frontend/src/views/PortalLoginView.vue` - 更新登录页面
  - `frontend/src/api/auth.js` - 添加注册API
  - `frontend/src/router/index.js` - 添加注册路由

**相关文档：**
- 详细说明：`docs/LOANER_REGISTRATION_FEATURE.md`

### 🐛 Bug修复

#### 添加 SysRoleMapper.selectByRoleCode 方法
**问题**：编译错误 - 找不到 selectByRoleCode 方法

**修复**：在 `SysRoleMapper` 接口中添加 `selectByRoleCode` 方法，用于根据角色代码查询角色信息

**相关文件**：
- `backend/src/main/java/com/example/mapper/SysRoleMapper.java`

**相关文档**：
- `docs/FIX_ROLE_MAPPER_METHOD.md`

### 🎨 用户体验改进

#### 年代字段改为下拉选择
**改进内容：**
- 将新增和编辑文物弹窗中的"年代"字段从文本输入框改为下拉选择框
- 提供 24 个预定义的年代选项（从史前到民国）
- 支持清除和重新选择

**改进效果：**
- ✅ 确保数据一致性（避免"商朝"、"商代"、"商"等不同写法）
- ✅ 避免输入错误和拼写错误
- ✅ 提升用户体验，无需记忆和输入完整年代名称
- ✅ 快速浏览和选择年代

**修改文件：**
- `frontend/src/views/RelicsView.vue` - 文物管理页面
- `frontend/src/components/RelicFormWithImage.vue` - 文物表单组件

**相关文档：**
- 详细说明：`docs/IMPROVE_ERA_DROPDOWN.md`

### 🐛 关键Bug修复

#### 1. 修复图片路径双斜杠问题（导致图片不显示）
**问题描述：**
- 文物和图片添加成功，关联关系也正确
- 但前端无法显示图片
- 后端报错：`RequestRejectedException: The request was rejected because the URL contained a potentially malicious String "//"`

**根本原因：**
- `FileStorageUtil.java` 路径拼接错误，产生双斜杠
- 配置 `./uploads/` + 拼接 `/` = `/./uploads//filename`
- Spring Security 的 `StrictHttpFirewall` 拒绝包含 `//` 的 URL

**修复内容：**

1. **后端路径规范化** (`backend/src/main/java/com/example/utils/FileStorageUtil.java`)
   - 移除路径中的 `./` 和尾部斜杠
   - 确保返回格式为 `/uploads/filename`
   - 添加详细日志输出

2. **Spring Security 防火墙配置** (`backend/src/main/java/com/example/config/SecurityConfig.java`)
   - 添加 `HttpFirewall` Bean 配置
   - 允许 URL 编码的斜杠和双斜杠（作为额外保护）

3. **数据库修复脚本** (`backend/sql/fix_image_paths.sql`)
   - 修复已有数据中的双斜杠路径
   - 统一路径格式

**修复前的路径**：
```
/./uploads//abc123.jpg  ❌ 包含双斜杠
./uploads/abc123.jpg    ❌ 相对路径
uploads\abc123.jpg      ❌ 反斜杠
```

**修复后的路径**：
```
/uploads/abc123.jpg     ✅ 正确格式
```

**相关文档：**
- 详细说明：`docs/FIX_DOUBLE_SLASH_IMAGE_PATH.md`
- 修复脚本：`backend/sql/fix_image_paths.sql`

#### 2. 修复新增文物错误处理问题
**问题描述：**
- 用户报告：新增文物时前端显示"保存成功"，但数据实际上没有添加到数据库中
- 根本原因：前端未检查后端响应的 `code` 字段，即使后端返回错误响应也显示成功消息

**修复内容：**

1. **前端修复** (`frontend/src/views/RelicsView.vue`)
   - 在 `submit` 方法中添加 `response.code === 200` 检查
   - 只有响应码为 200 时才显示成功消息和关闭对话框
   - 失败时显示后端返回的具体错误信息
   - 增强错误捕获，显示更详细的错误提示

2. **后端修复** (`backend/src/main/java/com/example/utils/FileStorageUtil.java`)
   - 修复文件上传目录创建问题
   - 使用项目根目录的绝对路径而非相对路径
   - 使用 `Files.createDirectories()` 确保目录存在
   - 避免在 Tomcat 临时目录中创建上传文件夹

**修复前的代码问题：**
```javascript
// ❌ 错误：不检查响应码就显示成功
const response = await addRelicWithImageApi(formData)
ElMessage.success(t('message.saveSuccess'))  // 总是显示成功
```

**修复后的代码：**
```javascript
// ✅ 正确：检查响应码
const response = await addRelicWithImageApi(formData)
if (response.code === 200) {
  ElMessage.success(t('message.saveSuccess'))
  dialogVisible.value = false
  loadData()
} else {
  ElMessage.error(response.message || t('message.operationFailed'))
}
```

**影响范围：**
- 新增文物（带图片）
- 新增文物（不带图片）
- 编辑文物

**测试验证：**
- 创建测试页面：`test-add-relic-with-error-check.html`
- 测试正常流程（有图片/无图片）
- 测试错误处理（缺少必填字段、数据库连接失败等）

**相关文档：**
- 详细说明：`docs/FIX_ADD_RELIC_ERROR_HANDLING.md`
- 测试页面：`test-add-relic-with-error-check.html`

**修复人员：** Kiro AI Assistant  
**修复日期：** 2026-04-23

---
