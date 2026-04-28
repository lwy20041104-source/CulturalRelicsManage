# LoansView 和 RepairsView 国际化实现总结

## 任务概述
为 LoansView.vue 和 RepairsView.vue 实现完整的国际化支持，将所有硬编码的中文文本替换为使用 i18n 翻译键。

## 完成时间
2026-04-25

## 修改的文件

### 1. 翻译文件
- `frontend/src/i18n/locales/zh-CN.js` - 添加了新的翻译键
- `frontend/src/i18n/locales/en-US.js` - 添加了对应的英文翻译

### 2. 视图文件
- `frontend/src/views/LoansView.vue` - 借展管理界面
- `frontend/src/views/RepairsView.vue` - 修复管理界面

## 新增的翻译键

### loan 命名空间新增键（zh-CN.js 和 en-US.js）
```javascript
loanDateNotBeforeToday: '借展日期不能早于今天' / 'Loan date cannot be earlier than today'
returnDateNotBeforeNow: '预计归还日期必须是当前时间及以后' / 'Expected return date must be current time or later'
returnDateAfterLoanDate: '预计归还日期必须晚于借展日期' / 'Expected return date must be later than loan date'
defaultApprover: '审批员' / 'Approver'
approvePass: '审批通过' / 'Approved'
approveReject: '审批驳回' / 'Rejected'
```

### repair 命名空间新增键（zh-CN.js 和 en-US.js）
```javascript
awaitingRepair: '待修复' / 'Awaiting Repair'
rejected: '已拒绝' / 'Rejected'
urgent: '紧急' / 'Urgent'
normal: '普通' / 'Normal'
startRepair: '开始修复' / 'Start Repair'
confirmStartRepair: '确定要开始修复吗？' / 'Are you sure to start repair?'
currencyUnit: '元' / 'CNY'
scoreUnit: '分' / 'pts'
```

## LoansView.vue 修改内容

### 1. 日期验证消息国际化
**修改前：**
```javascript
callback(new Error('借展日期不能早于今天'))
callback(new Error('预计归还日期必须是当前时间及以后'))
callback(new Error('预计归还日期必须晚于借展日期'))
```

**修改后：**
```javascript
callback(new Error(t('loan.loanDateNotBeforeToday')))
callback(new Error(t('loan.returnDateNotBeforeNow')))
callback(new Error(t('loan.returnDateAfterLoanDate')))
```

### 2. 审批功能国际化
**修改前：**
```javascript
await approveLoanApi({ 
  id: row.id, 
  approverName: localStorage.getItem('realName') || '审批员', 
  approveRemark: approved ? '审批通过' : '审批驳回', 
  approved 
})
```

**修改后：**
```javascript
await approveLoanApi({ 
  id: row.id, 
  approverName: localStorage.getItem('realName') || t('loan.defaultApprover'), 
  approveRemark: approved ? t('loan.approvePass') : t('loan.approveReject'), 
  approved 
})
```

### 修改位置
- 第 155 行：借展日期验证消息
- 第 170 行：预计归还日期不能早于当前时间验证消息
- 第 174 行：预计归还日期必须晚于借展日期验证消息
- 第 266 行：审批功能中的默认审批员和审批意见

## RepairsView.vue 修改内容

### 1. 状态和优先级选项国际化
**修改前：**
```vue
<el-option label="待修复" value="待修复" />
<el-option label="已拒绝" value="已拒绝" />
<el-option label="紧急" value="紧急" />
<el-option label="普通" value="普通" />
```

**修改后：**
```vue
<el-option :label="$t('repair.awaitingRepair')" value="待修复" />
<el-option :label="$t('repair.rejected')" value="已拒绝" />
<el-option :label="$t('repair.urgent')" value="紧急" />
<el-option :label="$t('repair.normal')" value="普通" />
```

### 2. 操作按钮国际化
**修改前：**
```vue
<el-button v-if="scope.row.status === '待修复'" link type="warning" @click="startRepair(scope.row.id)">开始修复</el-button>
```

**修改后：**
```vue
<el-button v-if="scope.row.status === '待修复'" link type="warning" @click="startRepair(scope.row.id)">{{ $t('repair.startRepair') }}</el-button>
```

### 3. 货币和评分单位国际化
**修改前：**
```vue
<span class="unit-text">元</span>
<el-descriptions-item>{{ currentDetail.qualityScore }} 分</el-descriptions-item>
```

**修改后：**
```vue
<span class="unit-text">{{ $t('repair.currencyUnit') }}</span>
<el-descriptions-item>{{ currentDetail.qualityScore }} {{ $t('repair.scoreUnit') }}</el-descriptions-item>
```

### 4. JavaScript 代码国际化
**修改前：**
```javascript
const applyForm = reactive({ relicId: null, priority: '普通', ... })
Object.assign(applyForm, { relicId: null, priority: '普通', ... })
await ElMessageBox.confirm('确定要开始修复吗？', t('message.tip'), { type: 'warning' })
```

**修改后：**
```javascript
const applyForm = reactive({ relicId: null, priority: t('repair.normal'), ... })
Object.assign(applyForm, { relicId: null, priority: t('repair.normal'), ... })
await ElMessageBox.confirm(t('repair.confirmStartRepair'), t('message.tip'), { type: 'warning' })
```

### 修改位置
- 第 8 行：待修复状态选项
- 第 11 行：已拒绝状态选项
- 第 14 行：紧急优先级选项
- 第 16 行：普通优先级选项
- 第 59 行：开始修复按钮
- 第 87-91 行：申请表单中的优先级选项
- 第 101 行：预估费用单位
- 第 159 行：实际费用单位（进度更新）
- 第 188 行：实际费用单位（完成修复）
- 第 231 行：质量评分单位
- 第 267 行：申请表单初始化
- 第 321 行：打开申请对话框
- 第 349 行：开始修复确认消息

## 测试验证

### 构建测试
```bash
cd frontend
npm run build
```
✅ 构建成功，无错误

### 功能测试清单

#### LoansView.vue
- [ ] 借展日期验证
  - [ ] 选择今天之前的日期显示错误消息
  - [ ] 错误消息正确显示中英文
- [ ] 预计归还日期验证
  - [ ] 选择当前时间之前的日期显示错误消息
  - [ ] 选择早于借展日期的日期显示错误消息
  - [ ] 错误消息正确显示中英文
- [ ] 审批功能
  - [ ] 批准时显示"审批通过"/"Approved"
  - [ ] 拒绝时显示"审批驳回"/"Rejected"
  - [ ] 默认审批员显示正确
- [ ] 语言切换
  - [ ] 所有文本正确切换

#### RepairsView.vue
- [ ] 状态筛选下拉框
  - [ ] "待修复"/"Awaiting Repair" 显示正确
  - [ ] "已拒绝"/"Rejected" 显示正确
- [ ] 优先级筛选下拉框
  - [ ] "紧急"/"Urgent" 显示正确
  - [ ] "普通"/"Normal" 显示正确
- [ ] 操作按钮
  - [ ] "开始修复"/"Start Repair" 显示正确
- [ ] 表单
  - [ ] 优先级选项显示正确
  - [ ] 货币单位显示"元"/"CNY"
  - [ ] 评分单位显示"分"/"pts"
  - [ ] 默认优先级为"普通"/"Normal"
- [ ] 确认对话框
  - [ ] 开始修复确认消息显示正确
- [ ] 语言切换
  - [ ] 所有文本正确切换

## 技术要点

### 1. 动态翻译键
在 reactive 对象初始化时使用 `t()` 函数：
```javascript
const applyForm = reactive({ 
  priority: t('repair.normal')  // 动态获取翻译
})
```

### 2. 验证消息国际化
在自定义验证函数中使用 `t()` 函数：
```javascript
const validateLoanDate = (rule, value, callback) => {
  if (condition) {
    callback(new Error(t('loan.loanDateNotBeforeToday')))
  }
}
```

### 3. 模板中的翻译
使用 `$t()` 在模板中获取翻译：
```vue
<el-option :label="$t('repair.urgent')" value="紧急" />
```

### 4. 脚本中的翻译
使用 `t()` 在脚本中获取翻译：
```javascript
ElMessageBox.confirm(t('repair.confirmStartRepair'), ...)
```

## 注意事项

1. **已导入 useI18n**：
   - LoansView.vue: `const { t } = useI18n()`
   - RepairsView.vue: `const { t } = useI18n()`

2. **动态值的处理**：
   - 表单初始化时使用 `t()` 获取翻译值
   - 重置表单时也要使用 `t()` 获取翻译值

3. **单位的国际化**：
   - 货币单位：中文"元"，英文"CNY"
   - 评分单位：中文"分"，英文"pts"

4. **验证消息的一致性**：
   - 所有验证消息都使用 i18n 翻译
   - 保持错误消息的专业性和准确性

## 已完成的国际化文件

1. ✅ UsersView.vue - 用户管理
2. ✅ RelicsView.vue - 文物管理
3. ✅ LoansView.vue - 借展管理
4. ✅ RepairsView.vue - 修复管理

## 待完成的国际化文件

根据 CRUD_I18N_QUICK_GUIDE.md，还需要修改：
1. MuseumsView.vue - 博物馆管理
2. EmployeesView.vue - 员工管理
3. LoanersView.vue - 借展人管理
4. CategoriesView.vue - 分类管理
5. MaintenanceView.vue - 维护记录
6. ExpertsView.vue - 修复专家
7. ImageLibraryView.vue - 图片管理
8. ArchivesView.vue - 档案管理
9. OperationLogsView.vue - 操作日志

## 相关文档
- CRUD_I18N_QUICK_GUIDE.md - 快速修改指南
- CRUD_I18N_SUMMARY.md - 总体规划文档
- CRUD_BUTTONS_I18N_GUIDE.md - 详细实施指南
- CRUD_BUTTONS_I18N_IMPLEMENTATION.md - UsersView 和 RelicsView 实现总结
