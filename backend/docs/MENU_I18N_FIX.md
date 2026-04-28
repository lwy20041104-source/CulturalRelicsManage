# 菜单栏国际化修复文档

## 修改日期
2026-04-25

## 问题描述
在切换为英文时，菜单栏的以下菜单项依然显示为中文：
- 首页
- 员工管理
- 用户管理
- 博物馆管理
- 档案管理
- 操作日志
- AI对话历史

## 问题原因
在 `LayoutView.vue` 中，这些菜单项直接使用了中文文本，而没有使用国际化函数 `$t()`。

**问题代码示例**：
```vue
<el-menu-item index="/dashboard">首页</el-menu-item>
<el-menu-item index="/employees">员工管理</el-menu-item>
<el-menu-item index="/museums">博物馆管理</el-menu-item>
```

## 解决方案
将所有硬编码的中文菜单项改为使用国际化函数 `$t()`，并在国际化文件中添加对应的翻译。

## 修改内容

### 1. 修改 LayoutView.vue

**修改前**：
```vue
<el-menu-item index="/dashboard">首页</el-menu-item>
<el-menu-item index="/employees">员工管理</el-menu-item>
<el-menu-item index="/loaners">借展人管理</el-menu-item>
<el-menu-item index="/museums">博物馆管理</el-menu-item>
<el-menu-item index="/archives">档案管理</el-menu-item>
<el-menu-item index="/operation-logs">操作日志</el-menu-item>
<el-menu-item index="/ai-chat-history">AI对话历史</el-menu-item>
```

**修改后**：
```vue
<el-menu-item index="/dashboard">{{ $t('nav.home') }}</el-menu-item>
<el-menu-item index="/employees">{{ $t('nav.employees') }}</el-menu-item>
<el-menu-item index="/loaners">{{ $t('nav.loaners') }}</el-menu-item>
<el-menu-item index="/museums">{{ $t('nav.museums') }}</el-menu-item>
<el-menu-item index="/archives">{{ $t('nav.archives') }}</el-menu-item>
<el-menu-item index="/operation-logs">{{ $t('nav.operationLogs') }}</el-menu-item>
<el-menu-item index="/ai-chat-history">{{ $t('nav.aiChatHistory') }}</el-menu-item>
```

### 2. 添加中文翻译 (zh-CN.js)

在 `nav` 对象中添加以下键值对：

```javascript
nav: {
  home: '首页',
  dataScreen: '数据大屏',
  relics: '文物管理',
  categories: '分类管理',
  loans: '借展管理',
  repairs: '修复管理',
  maintenance: '维护记录',
  experts: '修复专家',
  reports: '数据报表',
  aiQuery: 'AI搜索',
  images: '图片管理',
  system: '系统管理',
  users: '用户管理',
  employees: '员工管理',        // 新增
  loaners: '借展人管理',        // 新增
  museums: '博物馆管理',        // 新增
  archives: '档案管理',         // 新增
  operationLogs: '操作日志',    // 新增
  aiChatHistory: 'AI对话历史',  // 新增
  logout: '退出登录'
},
```

### 3. 添加英文翻译 (en-US.js)

在 `nav` 对象中添加以下键值对：

```javascript
nav: {
  home: 'Home',
  dataScreen: 'Data Screen',
  relics: 'Relics',
  categories: 'Categories',
  loans: 'Loans',
  repairs: 'Repairs',
  maintenance: 'Maintenance',
  experts: 'Experts',
  reports: 'Reports',
  aiQuery: 'AI Query',
  images: 'Images',
  system: 'System',
  users: 'Users',
  employees: 'Employees',           // 新增
  loaners: 'Loaners',               // 新增
  museums: 'Museums',               // 新增
  archives: 'Archives',             // 新增
  operationLogs: 'Operation Logs',  // 新增
  aiChatHistory: 'AI Chat History', // 新增
  logout: 'Logout'
},
```

## 修改的文件列表

1. `frontend/src/views/LayoutView.vue` - 菜单配置
2. `frontend/src/i18n/locales/zh-CN.js` - 中文翻译
3. `frontend/src/i18n/locales/en-US.js` - 英文翻译

## 测试验证

### 测试步骤
1. 启动前端应用
2. 登录后台管理系统
3. 点击顶部导航栏的语言切换按钮
4. 切换到英文
5. 检查左侧菜单栏的所有菜单项是否都显示为英文
6. 切换回中文
7. 检查左侧菜单栏的所有菜单项是否都显示为中文

### 预期结果

**中文模式**：
- 首页
- 数据大屏
- 数据报表
- 员工管理
- 借展人管理
- 博物馆管理
- 文物管理
- 分类管理
- 图片管理
- 档案管理
- 借展管理
- 维护记录
- 修复管理
- 修复专家
- 操作日志
- AI对话历史
- AI搜索

**英文模式**：
- Home
- Data Screen
- Reports
- Employees
- Loaners
- Museums
- Relics
- Categories
- Images
- Archives
- Loans
- Maintenance
- Repairs
- Experts
- Operation Logs
- AI Chat History
- AI Query

## 编译验证
- ✅ 前端构建成功 (npm run build)
- ✅ 所有菜单项已国际化

## 最佳实践

### 国际化规范
1. **所有用户可见的文本都应该使用国际化**
   - 菜单项
   - 按钮文本
   - 标题
   - 提示信息
   - 表单标签
   - 错误消息

2. **使用 `$t()` 函数**
   ```vue
   <!-- ✅ 正确 -->
   <el-button>{{ $t('common.save') }}</el-button>
   
   <!-- ❌ 错误 -->
   <el-button>保存</el-button>
   ```

3. **国际化键名命名规范**
   - 使用小驼峰命名法（camelCase）
   - 按模块分组（如 `nav.`, `common.`, `user.`）
   - 语义清晰，见名知意
   - 避免使用缩写

4. **同步更新所有语言文件**
   - 添加新键时，同时在所有语言文件中添加
   - 保持键名一致
   - 确保翻译准确

### 检查清单
在提交代码前，检查以下项目：
- [ ] 所有硬编码的中文文本已替换为 `$t()` 函数
- [ ] 所有新增的国际化键已在 zh-CN.js 中添加
- [ ] 所有新增的国际化键已在 en-US.js 中添加
- [ ] 翻译准确，符合上下文
- [ ] 前端构建成功
- [ ] 切换语言后界面显示正常

## 相关文档
- [搜索功能统一修改](SEARCH_UNIFICATION.md)
- [AI对话历史主题适配修复](AI_CHAT_HISTORY_THEME_FIX.md)

## 修改人员
AI Assistant (Kiro)
