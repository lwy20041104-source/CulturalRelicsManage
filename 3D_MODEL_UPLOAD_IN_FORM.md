# ✅ 新增/编辑文物表单 - 3D模型上传功能

## 📋 功能概述

在新增和编辑文物的对话框中添加了3D模型上传功能，用户可以在创建或编辑文物时直接上传3D模型。

---

## 🎯 实现的功能

### 1. 新增文物时上传3D模型 ✅

**功能**:
- 在新增文物表单中添加3D模型上传区域
- 支持拖拽上传或点击上传
- 文件类型验证（GLTF/GLB/OBJ）
- 文件大小限制（50MB）
- 上传成功后自动关联到新创建的文物

**使用流程**:
1. 点击"新增文物"按钮
2. 填写文物基本信息
3. 在"3D模型"区域拖拽或点击上传3D模型文件
4. 点击"确定"提交
5. 系统先创建文物，然后上传3D模型并关联

### 2. 编辑文物时管理3D模型 ✅

**功能**:
- 显示已上传的3D模型信息（类型、大小、上传时间）
- 查看3D模型（跳转到3D查看页面）
- 删除已有的3D模型
- 上传新的3D模型（如果没有已上传的模型）

**使用流程**:

**场景A：文物已有3D模型**
1. 点击"编辑"按钮
2. 在"3D模型"区域看到已上传的模型信息
3. 可以点击"查看3D模型"按钮查看
4. 可以点击"删除模型"按钮删除
5. 删除后可以上传新的模型

**场景B：文物没有3D模型**
1. 点击"编辑"按钮
2. 在"3D模型"区域看到上传框
3. 拖拽或点击上传3D模型文件
4. 点击"确定"提交
5. 系统更新文物信息并上传3D模型

---

## 🎨 界面设计

### 新增文物表单

```
┌─────────────────────────────────────────┐
│ 新增文物                          [×]   │
├─────────────────────────────────────────┤
│ 文物编号: [自动生成]                    │
│ 文物名称: [_____________]               │
│ 年代:     [下拉选择▼]                   │
│ 材质:     [_____________]               │
│ ...                                     │
│                                         │
│ 图片:                                   │
│ ┌─────────────────────────────────┐    │
│ │ [+] 上传图片                     │    │
│ └─────────────────────────────────┘    │
│                                         │
│ 3D模型:                                 │
│ ┌─────────────────────────────────┐    │
│ │     📦                           │    │
│ │  将3D模型文件拖到此处，或点击上传  │    │
│ │                                  │    │
│ │  支持格式: GLTF, OBJ             │    │
│ │  最大文件大小: 50MB              │    │
│ └─────────────────────────────────┘    │
│                                         │
│ 描述:     [___________________]         │
│                                         │
│           [取消]  [确定]                │
└─────────────────────────────────────────┘
```

### 编辑文物表单（已有3D模型）

```
┌─────────────────────────────────────────┐
│ 编辑文物                          [×]   │
├─────────────────────────────────────────┤
│ 文物编号: WW20240001                    │
│ 文物名称: [青铜鼎_______]               │
│ ...                                     │
│                                         │
│ 3D模型:                                 │
│ ┌─────────────────────────────────┐    │
│ │ ✓ 已上传3D模型                   │    │
│ │                                  │    │
│ │ 模型类型: GLTF                   │    │
│ │ 文件大小: 2.5 MB                 │    │
│ │ 上传时间: 2024-04-29 15:30       │    │
│ │                                  │    │
│ │ [查看3D模型] [删除模型]          │    │
│ └─────────────────────────────────┘    │
│                                         │
│           [取消]  [确定]                │
└─────────────────────────────────────────┘
```

---

## 💻 技术实现

### 前端变更

**文件**: `frontend/src/views/RelicsView.vue`

#### 1. 新增响应式变量

```javascript
const model3dFileList = ref([])  // 3D模型文件列表
const model3dUploadRef = ref()  // 3D模型上传组件引用
```

#### 2. 新增处理方法

```javascript
// 处理3D模型选择
const handle3DModelChange = (file, fileList) => {
  // 验证文件类型和大小
}

// 处理3D模型移除
const handle3DModelRemove = (file, fileList) => {
  model3dFileList.value = fileList
}

// 删除已有的3D模型
const delete3DModel = async () => {
  // 调用删除API
}

// 格式化文件大小
const formatFileSize = (bytes) => {
  // 转换为 KB/MB/GB
}

// 格式化日期时间
const formatDateTime = (dateTime) => {
  // 格式化为本地时间
}
```

#### 3. 修改 submit 方法

```javascript
const submit = async () => {
  // ... 保存文物信息
  
  // 如果有3D模型，上传
  if (model3dFileList.value.length > 0) {
    const model3dFile = model3dFileList.value[0].raw
    if (model3dFile) {
      const formData = new FormData()
      formData.append('file', model3dFile)
      
      await request.post(`/relics/${relicId}/3d-model`, formData, {
        headers: { 'Content-Type': 'multipart/form-data' }
      })
    }
  }
}
```

#### 4. 修改 openAdd 和 openEdit 方法

```javascript
const openAdd = () => {
  // ... 初始化表单
  
  // 清空3D模型列表
  model3dFileList.value = []
  if (model3dUploadRef.value) {
    model3dUploadRef.value.clearFiles()
  }
}

const openEdit = async (row) => {
  // ... 加载文物信息
  
  // 清空3D模型上传列表
  model3dFileList.value = []
  if (model3dUploadRef.value) {
    model3dUploadRef.value.clearFiles()
  }
}
```

#### 5. 表单模板

```vue
<!-- 3D模型上传区域 -->
<el-form-item :label="$t('relic.model3d')">
  <div class="model3d-upload-wrapper">
    <!-- 编辑模式：显示已有3D模型 -->
    <div v-if="form.id && form.model3dUrl" class="existing-model">
      <el-alert type="success">
        <div class="model-info">
          <p>模型类型: {{ form.model3dType }}</p>
          <p>文件大小: {{ formatFileSize(form.model3dSize) }}</p>
          <p>上传时间: {{ formatDateTime(form.model3dUploadTime) }}</p>
        </div>
        <div class="model-actions">
          <el-button @click="view3DModel(form)">查看3D模型</el-button>
          <el-button @click="delete3DModel">删除模型</el-button>
        </div>
      </el-alert>
    </div>
    
    <!-- 上传3D模型 -->
    <div v-if="!form.model3dUrl" class="upload-3d-section">
      <el-upload
        ref="model3dUploadRef"
        :auto-upload="false"
        :on-change="handle3DModelChange"
        :on-remove="handle3DModelRemove"
        accept=".gltf,.glb,.obj"
        :limit="1"
        :file-list="model3dFileList"
        drag
      >
        <el-icon><UploadFilled /></el-icon>
        <div class="el-upload__text">
          拖拽文件到此处，或<em>点击上传</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">
            支持格式: GLTF (.gltf, .glb), OBJ (.obj)<br>
            最大文件大小: 50MB
          </div>
        </template>
      </el-upload>
    </div>
  </div>
</el-form-item>
```

### 国际化翻译

**中文** (`zh-CN.js`):
```javascript
has3DModel: '已上传3D模型',
modelType: '模型类型',
modelSize: '文件大小',
uploadTime: '上传时间',
delete3DModel: '删除模型',
delete3DModelConfirm: '确认删除该3D模型？',
delete3DModelSuccess: '3D模型删除成功',
delete3DModelFailed: '3D模型删除失败',
upload3DModelSuccess: '3D模型上传成功',
upload3DModelFailed: '3D模型上传失败',
drag3DModelHere: '将3D模型文件拖到此处，或',
clickToUpload: '点击上传',
support3DFormats: '支持格式',
maxFileSize: '最大文件大小',
invalid3DFormat: '只支持 GLTF (.gltf, .glb) 和 OBJ (.obj) 格式',
fileSizeExceeds50MB: '文件大小不能超过 50MB',
```

**英文** (`en-US.js`):
```javascript
has3DModel: '3D Model Uploaded',
modelType: 'Model Type',
modelSize: 'File Size',
uploadTime: 'Upload Time',
delete3DModel: 'Delete Model',
delete3DModelConfirm: 'Confirm to delete this 3D model?',
delete3DModelSuccess: '3D model deleted successfully',
delete3DModelFailed: 'Failed to delete 3D model',
upload3DModelSuccess: '3D model uploaded successfully',
upload3DModelFailed: 'Failed to upload 3D model',
drag3DModelHere: 'Drag 3D model file here, or ',
clickToUpload: 'click to upload',
support3DFormats: 'Supported formats',
maxFileSize: 'Max file size',
invalid3DFormat: 'Only GLTF (.gltf, .glb) and OBJ (.obj) formats are supported',
fileSizeExceeds50MB: 'File size cannot exceed 50MB',
```

### 样式

```css
/* 3D模型上传样式 */
.model3d-upload-wrapper {
  width: 100%;
}

.existing-model {
  margin-bottom: 15px;
}

.model-info {
  margin: 10px 0;
  line-height: 1.8;
}

.model-info p {
  margin: 5px 0;
  color: #606266;
  font-size: 14px;
}

.model-actions {
  margin-top: 12px;
  display: flex;
  gap: 10px;
}

.upload-3d-section {
  width: 100%;
}

.upload-3d-section :deep(.el-upload-dragger) {
  width: 100%;
  padding: 40px 20px;
}

.upload-3d-section :deep(.el-icon--upload) {
  font-size: 60px;
  color: #8b7355;
  margin-bottom: 16px;
}
```

---

## 🧪 测试步骤

### 测试1: 新增文物时上传3D模型

1. **打开新增对话框**
   - 点击"新增文物"按钮
   - 验证表单显示正常

2. **填写基本信息**
   - 填写文物名称、年代、材质等必填字段

3. **上传3D模型**
   - 拖拽一个 GLTF 文件到上传区域
   - 验证文件显示在上传列表中

4. **提交表单**
   - 点击"确定"按钮
   - 验证提示"保存成功"和"3D模型上传成功"

5. **验证结果**
   - 在文物列表中找到新创建的文物
   - 验证"3D模型"列显示图标
   - 点击图标，验证能跳转到3D查看页面

### 测试2: 编辑文物时上传3D模型

1. **打开编辑对话框**
   - 选择一个没有3D模型的文物
   - 点击"编辑"按钮

2. **上传3D模型**
   - 在"3D模型"区域拖拽一个 GLB 文件
   - 验证文件显示在上传列表中

3. **提交表单**
   - 点击"确定"按钮
   - 验证提示"更新成功"和"3D模型上传成功"

4. **验证结果**
   - 在文物列表中验证"3D模型"列显示图标
   - 再次编辑该文物，验证显示3D模型信息

### 测试3: 查看和删除3D模型

1. **打开编辑对话框**
   - 选择一个有3D模型的文物
   - 点击"编辑"按钮

2. **验证显示**
   - 验证显示"已上传3D模型"提示
   - 验证显示模型类型、文件大小、上传时间

3. **查看3D模型**
   - 点击"查看3D模型"按钮
   - 验证跳转到3D查看页面

4. **删除3D模型**
   - 返回编辑对话框
   - 点击"删除模型"按钮
   - 确认删除
   - 验证提示"3D模型删除成功"
   - 验证显示上传框

### 测试4: 文件验证

1. **测试文件类型验证**
   - 尝试上传 .jpg 文件
   - 验证提示"只支持 GLTF (.gltf, .glb) 和 OBJ (.obj) 格式"

2. **测试文件大小验证**
   - 尝试上传超过 50MB 的文件
   - 验证提示"文件大小不能超过 50MB"

3. **测试有效文件**
   - 上传 .gltf 文件 - 应该成功
   - 上传 .glb 文件 - 应该成功
   - 上传 .obj 文件 - 应该成功

---

## 📊 功能对比

### 之前的方式

1. 创建文物
2. 在文物列表找到该文物
3. 点击详情或3D图标
4. 跳转到3D查看页面
5. 上传3D模型

**缺点**: 步骤多，操作繁琐

### 现在的方式

1. 创建文物时直接上传3D模型
2. 完成

**优点**: 一步到位，操作简便

---

## 🎯 用户体验提升

### 1. 操作流程简化 ⭐⭐⭐⭐⭐

- **之前**: 5步操作
- **现在**: 1步操作
- **提升**: 80% 操作步骤减少

### 2. 信息集中管理 ⭐⭐⭐⭐⭐

- 文物基本信息、图片、3D模型在同一个表单中
- 无需跳转页面
- 一次性完成所有信息录入

### 3. 即时反馈 ⭐⭐⭐⭐

- 文件类型验证即时提示
- 文件大小验证即时提示
- 上传成功/失败即时提示

### 4. 灵活管理 ⭐⭐⭐⭐⭐

- 新增时可以上传
- 编辑时可以查看、删除、重新上传
- 支持拖拽上传，操作便捷

---

## 🔧 技术亮点

### 1. 文件验证

- 客户端验证文件类型和大小
- 避免无效文件上传到服务器
- 提升用户体验和系统性能

### 2. 异步上传

- 先保存文物信息
- 再上传3D模型
- 即使3D模型上传失败，文物信息也已保存

### 3. 状态管理

- 使用 ref 管理上传状态
- 清晰的状态流转
- 易于维护和扩展

### 4. 国际化支持

- 所有提示信息支持中英文
- 统一的翻译管理
- 易于添加其他语言

---

## 📝 注意事项

### 1. 文件大小限制

- 前端限制: 50MB
- 后端限制: 50MB
- 建议: 使用压缩后的模型文件

### 2. 文件格式

- 推荐: GLTF (.gltf, .glb)
- 支持: OBJ (.obj)
- 注意: OBJ 需要单独的材质文件

### 3. 上传失败处理

- 文物信息已保存
- 3D模型上传失败会提示
- 可以稍后在编辑时重新上传

### 4. 删除操作

- 删除3D模型需要确认
- 删除后可以重新上传
- 删除操作不可恢复

---

## 🚀 未来优化建议

### 短期优化

1. **上传进度显示** ⭐⭐⭐
   - 显示上传进度条
   - 显示上传速度
   - 显示剩余时间

2. **模型预览** ⭐⭐⭐
   - 上传前预览3D模型
   - 验证模型是否正确
   - 避免上传错误文件

3. **批量上传** ⭐⭐
   - 支持一次上传多个文物的3D模型
   - 显示批量上传进度

### 中期优化

4. **模型压缩** ⭐⭐⭐
   - 自动压缩大文件
   - 优化加载速度
   - 节省存储空间

5. **模型转换** ⭐⭐
   - 自动转换为 GLTF 格式
   - 统一模型格式
   - 提升兼容性

6. **缩略图生成** ⭐⭐
   - 自动生成3D模型缩略图
   - 在列表中显示
   - 提升视觉效果

---

## ✅ 总结

### 完成情况

- ✅ 新增文物时上传3D模型
- ✅ 编辑文物时管理3D模型
- ✅ 查看3D模型信息
- ✅ 删除3D模型
- ✅ 文件类型验证
- ✅ 文件大小验证
- ✅ 国际化支持
- ✅ 样式美化

### 用户价值

1. **操作简化**: 减少80%的操作步骤
2. **信息集中**: 一个表单管理所有信息
3. **即时反馈**: 实时验证和提示
4. **灵活管理**: 支持查看、删除、重新上传

### 技术价值

1. **代码复用**: 复用现有的上传逻辑
2. **易于维护**: 清晰的代码结构
3. **易于扩展**: 预留优化空间
4. **国际化**: 支持多语言

---

**实现人**: Kiro AI Assistant  
**完成时间**: 2026-04-29  
**版本**: 1.0.0  
**状态**: ✅ 完成并可用
