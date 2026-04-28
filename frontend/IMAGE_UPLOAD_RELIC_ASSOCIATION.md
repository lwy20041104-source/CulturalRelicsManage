# 图片上传文物关联功能实现

## 📋 需求说明

修改图片管理界面的图片上传功能，要求上传的图片必须与一个文物相关联，否则显示上传失败。

## ✅ 实现内容

### 1. 前端修改

#### 1.1 上传对话框改造
**文件：** `frontend/src/views/ImageLibraryView.vue`

**主要变更：**
- ✅ 添加"关联文物"必选字段
- ✅ 使用下拉选择器选择文物（支持搜索过滤）
- ✅ 分类字段固定为"文物图片"（relic）并禁用编辑
- ✅ 添加表单验证规则
- ✅ 加载文物列表供选择

**新增字段：**
```vue
<el-form-item :label="$t('image.relatedRelic')" prop="relicId" required>
  <el-select 
    v-model="uploadForm.relicId" 
    :placeholder="$t('image.selectRelic')"
    filterable
    style="width: 100%"
    @focus="loadRelicsList"
  >
    <el-option
      v-for="relic in relicsList"
      :key="relic.id"
      :label="`${relic.relicName} (${relic.relicCode})`"
      :value="relic.id"
    />
  </el-select>
</el-form-item>
```

**注意：** 文物实体的字段名为 `relicName`（文物名称）和 `relicCode`（文物编号）。

#### 1.2 批量上传对话框改造
**同样的改造应用于批量上传：**
- ✅ 添加"关联文物"必选字段
- ✅ 分类固定为"relic"
- ✅ 添加表单验证

#### 1.3 表单验证规则
```javascript
const uploadRules = {
  relicId: [
    { required: true, message: t('image.relicRequired'), trigger: 'change' }
  ],
  file: [
    { required: true, message: t('image.fileRequired'), trigger: 'change' }
  ]
}

const batchUploadRules = {
  relicId: [
    { required: true, message: t('image.relicRequired'), trigger: 'change' }
  ],
  files: [
    { required: true, message: t('image.filesRequired'), trigger: 'change' }
  ]
}
```

#### 1.4 上传逻辑修改
**单个上传：**
```javascript
const submitUpload = async () => {
  // 验证表单
  const valid = await uploadFormRef.value?.validate().catch(() => false)
  if (!valid) return

  if (!uploadForm.relicId) {
    ElMessage.error(t('image.relicRequired'))
    return
  }

  const formData = new FormData()
  formData.append('file', fileList.value[0].raw)
  formData.append('relicId', uploadForm.relicId)
  // ... 其他字段
}
```

**批量上传：**
```javascript
const submitBatchUpload = async () => {
  // 验证表单
  const valid = await batchUploadFormRef.value?.validate().catch(() => false)
  if (!valid) return

  if (!batchUploadForm.relicId) {
    ElMessage.error(t('image.relicRequired'))
    return
  }

  const formData = new FormData()
  batchFileList.value.forEach(file => {
    formData.append('files', file.raw)
  })
  formData.append('relicId', batchUploadForm.relicId)
  // ... 其他字段
}
```

#### 1.5 文物列表加载
```javascript
const relicsList = ref([])

const loadRelicsList = async () => {
  if (relicsList.value.length > 0) return
  
  try {
    const res = await getRelicsPageApi({ pageNum: 1, pageSize: 1000 })
    relicsList.value = res.data.records || []
  } catch (error) {
    console.error('加载文物列表失败:', error)
    ElMessage.error(t('message.loadFailed'))
  }
}
```

---

### 2. 后端修改

#### 2.1 上传接口修改
**文件：** `backend/src/main/java/com/example/controller/ImageLibraryController.java`

**单个上传接口：**
```java
@PostMapping("/upload")
@OperationLog(operationType = "新增", operationModule = "图片管理", operationContent = "上传图片")
public Result<ImageLibrary> uploadImage(
        @RequestParam("file") MultipartFile file,
        @RequestParam(value = "imageName", required = false) String imageName,
        @RequestParam(value = "category", required = false) String category,
        @RequestParam(value = "tags", required = false) String tags,
        @RequestParam(value = "description", required = false) String description,
        @RequestParam(value = "relicId", required = false) Long relicId) throws IOException {
    
    // 验证必须关联文物
    if (relicId == null) {
        return Result.error("上传失败：图片必须关联一个文物");
    }
    
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    String username = auth.getName();
    
    ImageLibrary image = imageLibraryService.uploadImage(file, imageName, category, 
                                                        tags, description, null, username);
    
    // 关联到文物
    if (image != null && image.getId() != null) {
        imageLibraryService.linkToReference(image.getId(), "relic", relicId);
    }
    
    return Result.success("上传成功", image);
}
```

**批量上传接口：**
```java
@PostMapping("/batch-upload")
@OperationLog(operationType = "新增", operationModule = "图片管理", operationContent = "批量上传图片")
public Result<List<ImageLibrary>> batchUpload(
        @RequestParam("files") List<MultipartFile> files,
        @RequestParam(value = "category", required = false) String category,
        @RequestParam(value = "relicId", required = false) Long relicId) throws IOException {
    
    // 验证必须关联文物
    if (relicId == null) {
        return Result.error("上传失败：图片必须关联一个文物");
    }
    
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    String username = auth.getName();
    
    List<ImageLibrary> images = imageLibraryService.batchUpload(files, category, null, username);
    
    // 批量关联到文物
    if (images != null && !images.isEmpty()) {
        for (ImageLibrary image : images) {
            if (image != null && image.getId() != null) {
                imageLibraryService.linkToReference(image.getId(), "relic", relicId);
            }
        }
    }
    
    return Result.success("批量上传成功", images);
}
```

**关键验证逻辑：**
1. 检查 `relicId` 参数是否为空
2. 如果为空，返回错误信息："上传失败：图片必须关联一个文物"
3. 上传成功后，调用 `linkToReference` 方法关联图片到文物

---

### 3. 国际化翻译

#### 3.1 中文翻译
**文件：** `frontend/src/i18n/locales/zh-CN.js`

```javascript
image: {
  // ... 其他翻译
  relatedRelic: '关联文物',
  selectRelic: '请选择关联的文物',
  relicRequired: '必须选择关联的文物',
  fileRequired: '请选择要上传的文件',
  filesRequired: '请选择要上传的文件'
}
```

#### 3.2 英文翻译
**文件：** `frontend/src/i18n/locales/en-US.js`

```javascript
image: {
  // ... other translations
  relatedRelic: 'Related Relic',
  selectRelic: 'Please select a related relic',
  relicRequired: 'A related relic must be selected',
  fileRequired: 'Please select a file to upload',
  filesRequired: 'Please select files to upload'
}
```

---

## 🎯 功能特点

### 1. 强制关联验证
- ✅ 前端表单验证：必须选择文物才能提交
- ✅ 后端接口验证：未提供 relicId 返回错误
- ✅ 双重保障确保数据完整性

### 2. 用户体验优化
- ✅ 下拉选择器支持搜索过滤（filterable）
- ✅ 显示文物名称和编号：`文物名称 (文物编号)`
- ✅ 使用正确的字段名：`relicName` 和 `relicCode`
- ✅ 懒加载文物列表（首次点击时加载）
- ✅ 分类自动设置为"文物图片"并禁用编辑
- ✅ 清晰的错误提示信息

### 3. 数据关联
- ✅ 使用 `linkToReference` 方法建立关联
- ✅ 关联类型：`relic`
- ✅ 关联ID：选择的文物ID
- ✅ 支持单个和批量上传

---

## 📊 数据流程

### 上传流程
```
1. 用户打开上传对话框
   ↓
2. 点击文物选择器，加载文物列表
   ↓
3. 选择关联的文物（必选）
   ↓
4. 选择要上传的图片文件
   ↓
5. 填写其他信息（可选）
   ↓
6. 点击确定，前端验证
   ↓
7. 提交到后端，后端验证 relicId
   ↓
8. 上传图片文件
   ↓
9. 创建图片记录
   ↓
10. 建立图片与文物的关联关系
    ↓
11. 返回成功，刷新列表
```

### 验证流程
```
前端验证：
- 表单规则验证（uploadRules/batchUploadRules）
- 手动检查 relicId 是否为空
- 检查文件是否已选择

后端验证：
- 检查 relicId 参数是否为 null
- 如果为 null，返回错误："上传失败：图片必须关联一个文物"
```

---

## 🧪 测试要点

### 功能测试
- [ ] 打开上传对话框，文物选择器正常显示
- [ ] 点击文物选择器，文物列表正常加载
- [ ] 搜索功能正常工作
- [ ] 不选择文物直接上传，显示错误提示
- [ ] 选择文物后上传，上传成功
- [ ] 批量上传功能正常工作
- [ ] 上传后图片与文物正确关联

### 国际化测试
- [ ] 中文界面显示正确
- [ ] 英文界面显示正确
- [ ] 错误提示信息正确翻译

### 边界测试
- [ ] 文物列表为空时的处理
- [ ] 网络错误时的处理
- [ ] 上传大文件的处理
- [ ] 批量上传多个文件的处理

---

## 📝 使用说明

### 单个上传
1. 点击"上传图片"按钮
2. 在"关联文物"下拉框中选择要关联的文物
3. 点击或拖拽上传图片文件
4. 填写图片名称、标签、描述等信息（可选）
5. 点击"确定"完成上传

### 批量上传
1. 点击"批量上传"按钮
2. 在"关联文物"下拉框中选择要关联的文物
3. 选择多个图片文件
4. 点击"确定"完成批量上传

### 注意事项
- ⚠️ 必须选择关联的文物，否则无法上传
- ⚠️ 所有上传的图片分类自动设置为"文物图片"
- ⚠️ 批量上传时，所有图片关联到同一个文物

---

## 🔧 技术细节

### 前端技术栈
- Vue 3 Composition API
- Element Plus UI 组件库
- Vue I18n 国际化
- Axios HTTP 请求

### 后端技术栈
- Spring Boot
- Spring Security
- MyBatis
- MultipartFile 文件上传

### 关键API
- `getRelicsPageApi()` - 获取文物列表
- `uploadImageApi()` - 上传单个图片
- `batchUploadImagesApi()` - 批量上传图片
- `linkToReference()` - 建立关联关系

---

## 📅 修改记录

**日期：** 2026年4月27日  
**修改人：** Kiro AI  
**版本：** v1.0  
**状态：** ✅ 已完成

### 修复记录

#### 修复1：文物字段名错误（2026年4月27日）
**问题：** 下拉框显示 undefined，无法正确显示文物信息

**原因：** 使用了错误的字段名
- 错误：`relic.name` 和 `relic.inventoryNumber`
- 正确：`relic.relicName` 和 `relic.relicCode`

**修复：** 更新了两个下拉选择器的字段名
```vue
<!-- 修复前 -->
:label="`${relic.name} (${relic.inventoryNumber})`"

<!-- 修复后 -->
:label="`${relic.relicName} (${relic.relicCode})`"
```

---

## 🎉 总结

本次修改成功实现了图片上传必须关联文物的需求，通过前后端双重验证确保数据完整性，同时优化了用户体验，提供了清晰的操作流程和错误提示。
