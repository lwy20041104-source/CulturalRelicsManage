# 搜索功能统一修改文档

## 修改日期
2026-04-25

## 修改目的
统一全部界面的搜索功能，要求：
1. 输入条件后必须点击"搜索"按钮才执行查询
2. 将所有"查询"改为"搜索"

## 问题描述
系统中存在不一致的搜索行为：
- 部分界面：输入条件后需要点击"查询"或"搜索"按钮才执行查询
- 部分界面：输入条件后自动执行查询（使用 `@change` 事件）
- 术语不统一：部分使用"查询"，部分使用"搜索"

## 修改内容

### 1. 移除自动查询功能

#### 1.1 PublicPortalView.vue - 我的借展筛选
**修改前**:
```vue
<el-select v-model="myLoansQuery.status" @change="loadMyLoans">
```

**修改后**:
```vue
<el-select v-model="myLoansQuery.status">
  <!-- 移除 @change 事件 -->
</el-select>
<el-button type="primary" @click="loadMyLoans">
  <el-icon><Search /></el-icon>
  搜索
</el-button>
```

#### 1.2 PortalMyLoansView.vue - 筛选栏
**修改前**:
```vue
<el-select v-model="query.status" @change="loadData">
```

**修改后**:
```vue
<el-select v-model="query.status">
  <!-- 移除 @change 事件 -->
</el-select>
<el-button type="primary" @click="loadData">
  <el-icon><Search /></el-icon>
  搜索
</el-button>
```

#### 1.3 MuseumsView.vue - 合作状态筛选
**修改前**:
```vue
<el-select v-model="queryParams.status" @change="handleQuery">
```

**修改后**:
```vue
<el-select v-model="queryParams.status">
  <!-- 移除 @change 事件 -->
</el-select>
```

### 2. 统一术语：将"查询"改为"搜索"

#### 2.1 按钮文本修改

| 文件 | 修改前 | 修改后 |
|------|--------|--------|
| PublicPortalView.vue | `查询` | `搜索` |
| MuseumsView.vue | `查询` | `搜索` |
| LoanersView.vue | `查询` | `搜索` |
| EmployeesView.vue | `查询` | `搜索` |
| AiChatHistoryView.vue | `查询` | `搜索` |

#### 2.2 页面标题修改

| 文件 | 修改前 | 修改后 |
|------|--------|--------|
| PublicPortalView.vue | `文物查询` | `文物搜索` |
| PublicPortalView.vue | `分类查询` | `分类搜索` |
| PublicPortalView.vue | `AI查询` | `AI搜索` |
| PublicRelicsView.vue | `文物查询` | `文物搜索` |

#### 2.3 注释修改

| 文件 | 修改前 | 修改后 |
|------|--------|--------|
| PublicPortalView.vue | `<!-- 文物查询 -->` | `<!-- 文物搜索 -->` |
| PublicPortalView.vue | `<!-- 分类查询 -->` | `<!-- 分类搜索 -->` |
| PublicPortalView.vue | `<!-- AI查询 -->` | `<!-- AI搜索 -->` |
| PublicPortalView.vue | `/* 文物查询 */` | `/* 文物搜索 */` |
| PublicPortalView.vue | `/* 分类查询 */` | `/* 分类搜索 */` |
| PublicPortalView.vue | `/* AI查询 */` | `/* AI搜索 */` |
| PublicPortalView.vue | `/* AI查询响应式 */` | `/* AI搜索响应式 */` |
| LoanersView.vue | `// 查询所有借展人` | `// 搜索所有借展人` |
| EmployeesView.vue | `// 如果选择了特定角色，直接查询` | `// 如果选择了特定角色，直接搜索` |
| EmployeesView.vue | `// 如果没有选择角色，需要查询所有员工角色` | `// 如果没有选择角色，需要搜索所有员工角色` |
| EmployeesView.vue | `// 查询所有员工` | `// 搜索所有员工` |
| AiChatHistoryView.vue | `// 查询` | `// 搜索` |

#### 2.4 代码逻辑中的文本修改

| 文件 | 位置 | 修改前 | 修改后 |
|------|------|--------|--------|
| PublicPortalView.vue | 国际化 | `navRelics: '文物查询'` | `navRelics: '文物搜索'` |
| PublicPortalView.vue | 国际化 | `navCategories: '分类查询'` | `navCategories: '分类搜索'` |
| PublicPortalView.vue | 国际化 | `navAi: 'AI查询'` | `navAi: 'AI搜索'` |
| PublicPortalView.vue | 国际化 | `featureRelics: '文物查询'` | `featureRelics: '文物搜索'` |
| PublicPortalView.vue | 国际化 | `featureAi: 'AI智能查询'` | `featureAi: 'AI智能搜索'` |
| PublicPortalView.vue | 国际化 | `aiWelcomeDesc: '您可以向我查询...'` | `aiWelcomeDesc: '您可以向我搜索...'` |
| PublicPortalView.vue | 国际化 | `queryFailed: '查询失败'` | `searchFailed: '搜索失败'` |
| PublicPortalView.vue | 国际化 | `queryRelicsFailed: '查询文物失败'` | `searchRelicsFailed: '搜索文物失败'` |
| PublicPortalView.vue | 国际化 | `featureAi: 'AI Smart Query'` | `featureAi: 'AI Smart Search'` |
| PublicPortalView.vue | console.log | `'查询文物失败'` | `'搜索文物失败'` |
| PublicPortalView.vue | console.log | `'发送AI查询'` | `'发送AI搜索'` |
| PublicPortalView.vue | console.log | `'AI查询响应'` | `'AI搜索响应'` |
| PublicPortalView.vue | console.log | `'AI查询失败'` | `'AI搜索失败'` |
| PortalRegisterView.vue | 页面文本 | `AI辅助查询` | `AI辅助搜索` |

#### 2.5 国际化文件修改 (zh-CN.js)

| 键名 | 修改前 | 修改后 |
|------|--------|--------|
| `nav.aiQuery` | `'AI查询'` | `'AI搜索'` |
| `portalLogin.feature1Title` | `'文物查询'` | `'文物搜索'` |
| `dataScreen.aiQuery` | `'AI查询'` | `'AI搜索'` |
| `ai.title` | `'AI智能查询'` | `'AI智能搜索'` |
| `ai.example1` | `'查询清代的青铜器'` | `'搜索清代的青铜器'` |
| `ai.aiQuery` | `'AI 查询'` | `'AI 搜索'` |
| `ai.noResultTip` | `'未查询到相关文物...'` | `'未搜索到相关文物...'` |
| `report.query` | `'查询'` | `'搜索'` |

### 3. 添加搜索图标

为需要添加搜索按钮的界面导入 Search 图标：

**PortalMyLoansView.vue**:
```javascript
import { 
  Box, 
  ArrowLeft, 
  Clock, 
  Check, 
  Warning, 
  Document, 
  Refresh,
  Search  // 新增
} from '@element-plus/icons-vue'
```

## 特殊说明

### 保留"查询"的场景
以下场景保留"查询"一词，因为它们表示操作类型或日志记录，而非用户界面的搜索功能：

1. **OperationLogsView.vue** - 操作类型选项
   ```vue
   <el-option label="查询" value="查询" />
   ```
   这里的"查询"是操作日志的类型，表示用户执行了查询操作，应该保留。

2. **操作日志记录** - 后端日志中记录的操作类型
   系统记录用户操作时，"查询"作为操作类型应该保留。

## 修改的文件列表

### 前端视图文件
1. `frontend/src/views/PublicPortalView.vue`
2. `frontend/src/views/PortalMyLoansView.vue`
3. `frontend/src/views/MuseumsView.vue`
4. `frontend/src/views/LoanersView.vue`
5. `frontend/src/views/EmployeesView.vue`
6. `frontend/src/views/AiChatHistoryView.vue`
7. `frontend/src/views/PublicRelicsView.vue`

### 国际化文件
8. `frontend/src/i18n/locales/zh-CN.js`

## 用户体验改进

### 修改前的问题
1. **行为不一致**：用户在不同界面遇到不同的搜索行为，造成困惑
2. **意外触发**：下拉选择状态时自动触发搜索，可能导致不必要的网络请求
3. **术语混乱**："查询"和"搜索"混用，降低了界面的专业性

### 修改后的优势
1. **行为统一**：所有界面都需要点击"搜索"按钮才执行搜索
2. **用户可控**：用户可以先设置好所有筛选条件，再一次性执行搜索
3. **术语统一**：全部使用"搜索"，提升界面一致性和专业性
4. **性能优化**：减少不必要的自动查询，降低服务器负载

## 测试建议

### 功能测试
1. 测试所有搜索界面，确认必须点击"搜索"按钮才执行查询
2. 测试下拉选择、输入框等筛选条件，确认不会自动触发搜索
3. 测试搜索按钮的响应和结果显示

### 界面测试
1. 检查所有界面的按钮文本是否统一为"搜索"
2. 检查页面标题和导航菜单是否使用"搜索"
3. 检查错误提示信息是否使用"搜索"

### 国际化测试
1. 切换到中文，检查所有"搜索"相关文本
2. 切换到英文，检查所有"Search"相关文本

## 编译验证
- ✅ 前端构建成功 (npm run build)
- ✅ 所有修改已通过验证

## 相关文档
- [用户主动归还文物功能](USER_RETURN_FEATURE.md)
- [借展状态统一修复](LOAN_STATUS_UNIFICATION.md)

## 修改人员
AI Assistant (Kiro)
