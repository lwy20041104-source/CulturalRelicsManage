# CRUD按钮国际化实现总结

## 任务概述
为 UsersView.vue 和 RelicsView.vue 实现完整的国际化支持，将所有硬编码的中文文本替换为使用 i18n 翻译键。

## 完成时间
2026-04-25

## 修改的文件

### 1. 翻译文件
- `frontend/src/i18n/locales/zh-CN.js` - 添加了新的翻译键
- `frontend/src/i18n/locales/en-US.js` - 添加了对应的英文翻译

### 2. 视图文件
- `frontend/src/views/UsersView.vue` - 用户管理界面
- `frontend/src/views/RelicsView.vue` - 文物管理界面

## 新增的翻译键

### relic 命名空间新增键（zh-CN.js 和 en-US.js）
```javascript
uploadMode: '上传图片' / 'Upload Image'
urlMode: '输入URL' / 'Enter URL'
enterImageUrl: '请输入图片URL地址' / 'Please enter image URL'
remove: '移除' / 'Remove'
dragOrClick: '拖拽文件或' / 'Drag file here, or '
imageUploadTip: '支持 jpg/png/gif，不超过 5MB' / 'Support jpg/png/gif, max 5MB'
qrCodeTitle: '文物二维码' / 'Relic QR Code'
relicCode2: '文物编号：' / 'Relic Code: '
generating: '生成中...' / 'Generating...'
scanQRCodeTip: '扫描二维码可查看文物基本信息' / 'Scan QR code to view relic information'
downloadQRCodeBtn: '下载二维码' / 'Download QR Code'
printQRCodeBtn: '打印二维码' / 'Print QR Code'
onlyImageAllowed: '只能上传图片文件!' / 'Only image files are allowed!'
imageSizeLimit: '图片大小不能超过 5MB!' / 'Image size cannot exceed 5MB!'
imageLoadError: '图片加载失败，请检查URL是否正确' / 'Image load failed, please check URL'
editModeNoUpload: '编辑模式暂不支持更换上传的图片，请使用URL模式' / 'Edit mode does not support changing uploaded images, please use URL mode'
qrCodeGenerateFailed: '生成二维码失败' / 'Failed to generate QR code'
qrCodeDownloaded2: '二维码已下载' / 'QR code downloaded'
qrCodePrintTitle: '文物二维码' / 'Relic QR Code'
scanQRCodeDetail: '扫描二维码查看文物详细信息' / 'Scan QR code to view relic details'
relicDetailTitle: '文物详情' / 'Relic Detail'
```

## UsersView.vue 修改内容

### 1. 密码验证消息国际化
**修改前：**
```javascript
callback(new Error('密码长度不能少于6位'))
callback(new Error('密码长度不能超过20位'))
callback(new Error('密码必须包含数字'))
callback(new Error('密码必须包含字母'))
callback(new Error('密码必须是6-20位字符，且包含数字和字母'))
```

**修改后：**
```javascript
callback(new Error(t('profile.passwordLength')))
callback(new Error(t('profile.passwordLength')))
callback(new Error(t('profile.passwordNeedNumber')))
callback(new Error(t('profile.passwordNeedLetter')))
callback(new Error(t('profile.passwordInvalid')))
```

### 2. 密码输入框占位符国际化
**修改前：**
```vue
:placeholder="form.id ? '6-20位字符，必须包含数字和字母（不修改请留空）' : '6-20位字符，必须包含数字和字母'"
:placeholder="form.id ? '请再次输入密码（不修改请留空）' : '请再次输入密码'"
```

**修改后：**
```vue
:placeholder="$t('profile.passwordPlaceholder')"
:placeholder="$t('profile.confirmPasswordPlaceholder')"
```

### 3. 错误日志消息国际化
**修改前：**
```javascript
console.error('加载用户博物馆失败:', e)
```

**修改后：**
```javascript
console.error(t('message.loadFailed'), e)
```

## RelicsView.vue 修改内容

### 1. 图片上传模式切换按钮
**修改前：**
```vue
<el-radio-button label="upload">上传图片</el-radio-button>
<el-radio-button label="url">输入URL</el-radio-button>
```

**修改后：**
```vue
<el-radio-button label="upload">{{ $t('relic.uploadMode') }}</el-radio-button>
<el-radio-button label="url">{{ $t('relic.urlMode') }}</el-radio-button>
```

### 2. URL输入框和按钮
**修改前：**
```vue
placeholder="请输入图片URL地址"
<el-button size="small" type="danger" @click="clearImageUrl">移除</el-button>
<el-button size="small" type="danger" @click="removeImage">移除</el-button>
```

**修改后：**
```vue
:placeholder="$t('relic.enterImageUrl')"
<el-button size="small" type="danger" @click="clearImageUrl">{{ $t('relic.remove') }}</el-button>
<el-button size="small" type="danger" @click="removeImage">{{ $t('relic.remove') }}</el-button>
```

### 3. 文件上传提示
**修改前：**
```vue
<div class="el-upload__text">拖拽文件或<em>点击上传</em></div>
<div class="el-upload__tip">支持 jpg/png/gif，不超过 5MB</div>
```

**修改后：**
```vue
<div class="el-upload__text">{{ $t('relic.dragOrClick') }}<em>{{ $t('relic.clickToUpload') }}</em></div>
<div class="el-upload__tip">{{ $t('relic.imageUploadTip') }}</div>
```

### 4. 操作列按钮
**修改前：**
```vue
<el-button link type="success" @click="showQRCode(scope.row)">二维码</el-button>
```

**修改后：**
```vue
<el-button link type="success" @click="showQRCode(scope.row)">{{ $t('relic.qrCode') }}</el-button>
```

### 5. 二维码对话框
**修改前：**
```vue
<el-dialog v-model="qrcodeDialogVisible" title="文物二维码" width="500px">
  <p class="qrcode-code">文物编号：{{ currentQRCode.relicCode }}</p>
  <p>生成中...</p>
  <span>扫描二维码可查看文物基本信息</span>
  下载二维码
  打印二维码
</el-dialog>
```

**修改后：**
```vue
<el-dialog v-model="qrcodeDialogVisible" :title="$t('relic.qrCodeTitle')" width="500px">
  <p class="qrcode-code">{{ $t('relic.relicCode2') }}{{ currentQRCode.relicCode }}</p>
  <p>{{ $t('relic.generating') }}</p>
  <span>{{ $t('relic.scanQRCodeTip') }}</span>
  {{ $t('relic.downloadQRCodeBtn') }}
  {{ $t('relic.printQRCodeBtn') }}
</el-dialog>
```

### 6. JavaScript 消息提示
**修改前：**
```javascript
ElMessage.warning('编辑模式暂不支持更换上传的图片，请使用URL模式')
ElMessage.error('只能上传图片文件!')
ElMessage.error('图片大小不能超过 5MB!')
ElMessage.warning('图片加载失败，请检查URL是否正确')
ElMessage.error('生成二维码失败')
ElMessage.success('二维码已下载')
ElMessage.success('打印预览已生成')
```

**修改后：**
```javascript
ElMessage.warning(t('relic.editModeNoUpload'))
ElMessage.error(t('relic.onlyImageAllowed'))
ElMessage.error(t('relic.imageSizeLimit'))
ElMessage.warning(t('relic.imageLoadError'))
ElMessage.error(t('relic.qrCodeGenerateFailed'))
ElMessage.success(t('relic.qrCodeDownloaded2'))
ElMessage.success(t('relic.printPreviewGenerated'))
```

### 7. 打印功能中的文本
**修改前：**
```javascript
<title>文物详情 - ${currentDetail.value.relicName}</title>
<div class="code">文物编号：${currentDetail.value.relicCode}</div>
<button onclick="window.print()">打印</button>
<button onclick="window.close()">关闭</button>
<title>文物二维码 - ${currentQRCode.value.relicName}</title>
<div class="qrcode-code">文物编号：${currentQRCode.value.relicCode}</div>
<div class="qrcode-tip">扫描二维码查看文物详细信息</div>
```

**修改后：**
```javascript
<title>${t('relic.relicDetailTitle')} - ${currentDetail.value.relicName}</title>
<div class="code">${t('relic.relicCode2')}${currentDetail.value.relicCode}</div>
<button onclick="window.print()">${t('relic.print')}</button>
<button onclick="window.close()">${t('common.close')}</button>
<title>${t('relic.qrCodePrintTitle')} - ${currentQRCode.value.relicName}</title>
<div class="qrcode-code">${t('relic.relicCode2')}${currentQRCode.value.relicCode}</div>
<div class="qrcode-tip">${t('relic.scanQRCodeDetail')}</div>
```

## 测试验证

### 构建测试
```bash
cd frontend
npm run build
```
✅ 构建成功，无错误

### 功能测试清单
- [ ] 用户管理界面
  - [ ] 密码验证消息显示正确
  - [ ] 密码输入框占位符显示正确
  - [ ] 切换语言后所有文本正确显示
  
- [ ] 文物管理界面
  - [ ] 图片上传模式切换按钮显示正确
  - [ ] URL输入框占位符显示正确
  - [ ] 文件上传提示显示正确
  - [ ] 二维码对话框所有文本显示正确
  - [ ] 所有消息提示显示正确
  - [ ] 打印功能中的文本显示正确
  - [ ] 切换语言后所有文本正确显示

## 注意事项

1. **模板 vs 脚本**：
   - 模板中使用 `$t('key')`
   - 脚本中使用 `t('key')`

2. **已导入 useI18n**：
   - UsersView.vue: `const { t } = useI18n()`
   - RelicsView.vue: `const { t } = useI18n()`

3. **复用现有翻译键**：
   - 优先使用 `common` 命名空间的通用键
   - 避免重复定义相同含义的翻译

4. **打印功能特殊处理**：
   - 打印内容在模板字符串中，需要使用 `${t('key')}` 格式
   - 确保所有动态内容都使用翻译函数

## 下一步工作

根据 CRUD_I18N_QUICK_GUIDE.md，还需要修改以下文件：
1. MuseumsView.vue - 博物馆管理
2. EmployeesView.vue - 员工管理（已完成部分）
3. LoanersView.vue - 借展人管理（已完成部分）
4. CategoriesView.vue - 分类管理
5. LoansView.vue - 借展管理
6. RepairsView.vue - 修复管理
7. MaintenanceView.vue - 维护记录
8. ExpertsView.vue - 修复专家
9. ImageLibraryView.vue - 图片管理
10. ArchivesView.vue - 档案管理
11. OperationLogsView.vue - 操作日志

## 相关文档
- CRUD_I18N_QUICK_GUIDE.md - 快速修改指南
- CRUD_I18N_SUMMARY.md - 总体规划文档
- CRUD_BUTTONS_I18N_GUIDE.md - 详细实施指南
