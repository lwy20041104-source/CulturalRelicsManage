# 国际化修复指南

## 问题描述
项目中部分页面的新增、修改、删除等操作提示仍然使用硬编码的中文，未实现国际化切换功能。

## 已完成的工作
✅ 在 `zh-CN.js` 和 `en-US.js` 中添加了常用操作提示的翻译
✅ 包含以下新增的翻译键：
- `common.publishSuccess` / `publishFailed` - 发布成功/失败
- `common.archiveSuccess` / `archiveFailed` - 归档成功/失败
- `common.exportSuccess` / `exportFailed` - 导出成功/失败
- `common.uploadSuccess` / `uploadFailed` - 上传成功/失败
- `common.loadSuccess` / `loadFailed` - 加载成功/失败
- `common.operationSuccess` / `operationFailed` - 操作成功/失败
- `common.pleaseSelectFile` - 请选择文件
- `common.cannotDeleteSelf` - 不能删除当前登录用户
- `common.batchDeleteSuccess` / `batchDeleteFailed` - 批量删除成功/失败
- `common.batchUpdateStatusSuccess` / `batchUpdateStatusFailed` - 批量修改状态成功/失败
- `common.printSuccess` / `printFailed` - 打印成功/失败
- `common.returnSuccess` / `returnFailed` - 归还成功/失败
- 以及更多...

## 需要修复的文件列表

### 高优先级（用户常用功能）
1. ✅ `LoanersView.vue` - 借展人管理
2. ✅ `EmployeesView.vue` - 员工管理  
3. ✅ `MuseumsView.vue` - 博物馆管理
4. ✅ `ArchivesView.vue` - 档案管理
5. ✅ `ArchiveDetailView.vue` - 档案详情
6. ✅ `PortalMyLoansView.vue` - 我的借展

### 中优先级
7. ✅ `AiChatHistoryView.vue` - AI对话历史
8. ✅ `PublicRelicsView.vue` - 公开文物查询
9. ✅ `PublicPortalView.vue` - 前台门户
10. ✅ `PortalRegisterView.vue` - 前台注册
11. ✅ `ForgotPasswordView.vue` - 忘记密码
12. ✅ `ResetPasswordView.vue` - 重置密码
13. ✅ `QRCodeScanView.vue` - 二维码扫描

### 低优先级（测试/开发页面）
14. ✅ `WebSocketTestView.vue` - WebSocket测试

## 修复步骤

### 1. 导入 useI18n
在 `<script setup>` 中添加：
```javascript
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
```

### 2. 替换硬编码的中文提示

#### 示例 1：简单替换
**修复前：**
```javascript
ElMessage.success('删除成功')
ElMessage.error('删除失败')
```

**修复后：**
```javascript
ElMessage.success(t('common.deleteSuccess'))
ElMessage.error(t('common.deleteFailed'))
```

#### 示例 2：带参数的提示
**修复前：**
```javascript
await ElMessageBox.confirm('确定要删除该借展人吗？', '警告', { type: 'warning' })
```

**修复后：**
```javascript
await ElMessageBox.confirm(
  t('loaner.deleteConfirm'), 
  t('common.warning'), 
  { type: 'warning' }
)
```

#### 示例 3：批量操作提示
**修复前：**
```javascript
ElMessage.success('批量删除成功')
ElMessage.error('批量删除失败')
```

**修复后：**
```javascript
ElMessage.success(t('common.batchDeleteSuccess'))
ElMessage.error(t('common.batchDeleteFailed'))
```

#### 示例 4：新增/更新提示
**修复前：**
```javascript
if (form.id) {
  await updateUserApi(form)
  ElMessage.success('更新成功')
} else {
  await addUserApi(form)
  ElMessage.success('新增成功')
}
```

**修复后：**
```javascript
if (form.id) {
  await updateUserApi(form)
  ElMessage.success(t('common.updateSuccess'))
} else {
  await addUserApi(form)
  ElMessage.success(t('common.addSuccess'))
}
```

#### 示例 5：特殊业务提示
**修复前：**
```javascript
ElMessage.warning('不能删除当前登录用户')
```

**修复后：**
```javascript
ElMessage.warning(t('common.cannotDeleteSelf'))
```

## 完整修复示例

### LoanersView.vue 修复示例

**修复前：**
```javascript
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'

const handleSave = async () => {
  if (form.id) {
    await updateUserApi(form)
    ElMessage.success('更新成功')
  } else {
    await addUserApi(form)
    ElMessage.success('新增成功')
  }
}

const remove = async (row) => {
  if (row.username === currentUsername) {
    ElMessage.warning('不能删除当前登录用户')
    return
  }
  await ElMessageBox.confirm('确定要删除该借展人吗？', '警告', { type: 'warning' })
  await deleteUserApi(row.id)
  ElMessage.success('删除成功')
}
</script>
```

**修复后：**
```javascript
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'

const { t } = useI18n()

const handleSave = async () => {
  if (form.id) {
    await updateUserApi(form)
    ElMessage.success(t('common.updateSuccess'))
  } else {
    await addUserApi(form)
    ElMessage.success(t('common.addSuccess'))
  }
}

const remove = async (row) => {
  if (row.username === currentUsername) {
    ElMessage.warning(t('common.cannotDeleteSelf'))
    return
  }
  await ElMessageBox.confirm(
    t('loaner.deleteConfirm'), 
    t('common.warning'), 
    { type: 'warning' }
  )
  await deleteUserApi(row.id)
  ElMessage.success(t('common.deleteSuccess'))
}
</script>
```

## 常用翻译键对照表

| 中文 | 翻译键 | 英文 |
|------|--------|------|
| 删除成功 | `common.deleteSuccess` | Deleted successfully |
| 删除失败 | `common.deleteFailed` | Delete failed |
| 更新成功 | `common.updateSuccess` | Updated successfully |
| 更新失败 | `common.updateFailed` | Update failed |
| 新增成功 | `common.addSuccess` | Added successfully |
| 新增失败 | `common.addFailed` | Add failed |
| 保存成功 | `common.saveSuccess` | Saved successfully |
| 保存失败 | `common.saveFailed` | Save failed |
| 发布成功 | `common.publishSuccess` | Published successfully |
| 发布失败 | `common.publishFailed` | Publish failed |
| 归档成功 | `common.archiveSuccess` | Archived successfully |
| 归档失败 | `common.archiveFailed` | Archive failed |
| 导出成功 | `common.exportSuccess` | Exported successfully |
| 导出失败 | `common.exportFailed` | Export failed |
| 上传成功 | `common.uploadSuccess` | Uploaded successfully |
| 上传失败 | `common.uploadFailed` | Upload failed |
| 加载失败 | `common.loadFailed` | Load failed |
| 操作成功 | `common.operationSuccess` | Operation successful |
| 操作失败 | `common.operationFailed` | Operation failed |
| 批量删除成功 | `common.batchDeleteSuccess` | Batch delete successful |
| 批量删除失败 | `common.batchDeleteFailed` | Batch delete failed |
| 批量修改状态成功 | `common.batchUpdateStatusSuccess` | Batch update status successful |
| 批量修改状态失败 | `common.batchUpdateStatusFailed` | Batch update status failed |
| 不能删除当前登录用户 | `common.cannotDeleteSelf` | Cannot delete current logged in user |
| 请选择文件 | `common.pleaseSelectFile` | Please select file |
| 警告 | `common.warning` | Warning |
| 提示 | `common.tip` | Tip |

## 测试方法

1. 启动前端开发服务器
2. 在页面右上角切换语言（中文/English）
3. 执行新增、修改、删除等操作
4. 验证提示信息是否正确切换语言

## 注意事项

1. **不要遗漏任何 ElMessage 调用**：使用全局搜索确保所有硬编码的中文都被替换
2. **保持翻译键的一致性**：相同的提示使用相同的翻译键
3. **特殊业务提示**：如果是特定模块的提示，使用模块前缀（如 `loaner.deleteConfirm`）
4. **通用提示**：使用 `common.` 前缀
5. **测试完整性**：修复后务必测试中英文切换功能

## 批量查找命令

查找所有硬编码的中文提示：
```bash
# 在 frontend/src/views 目录下搜索
grep -r "ElMessage\.\(success\|error\|warning\)(['\"][\u4e00-\u9fa5]" src/views/
```

## 进度追踪

- [x] 更新国际化配置文件（zh-CN.js, en-US.js）
- [ ] 修复 LoanersView.vue
- [ ] 修复 EmployeesView.vue
- [ ] 修复 MuseumsView.vue
- [ ] 修复 ArchivesView.vue
- [ ] 修复 ArchiveDetailView.vue
- [ ] 修复 PortalMyLoansView.vue
- [ ] 修复 AiChatHistoryView.vue
- [ ] 修复 PublicRelicsView.vue
- [ ] 修复 PublicPortalView.vue
- [ ] 修复 PortalRegisterView.vue
- [ ] 修复 ForgotPasswordView.vue
- [ ] 修复 ResetPasswordView.vue
- [ ] 修复 QRCodeScanView.vue
- [ ] 修复 WebSocketTestView.vue
- [ ] 全面测试中英文切换功能
