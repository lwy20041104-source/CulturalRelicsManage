# RelicsView 3D模型管理修复总结

## 问题描述

用户在 `RelicsView.vue`（文物管理列表页面）中遇到两个问题：

1. **删除3D模型失败**
   - 错误：`DELETE http://localhost:8080/api/relics/4/3d-model?filename=Box.glb 404 (Not Found)`
   - 原因：使用了旧的删除端点，该端点已不存在

2. **没有输入链接的选项**
   - 只能上传文件，无法输入在线链接
   - 缺少与 `Relic3DView.vue` 一致的功能

## 根本原因

### 问题1：删除端点不匹配
- **旧端点**：`DELETE /api/relics/{id}/3d-model?filename=xxx`
- **新端点**：`DELETE /api/relics/{id}/3d-model-url`
- RelicsView 使用的是旧端点，导致404错误

### 问题2：功能不完整
- RelicsView 只有文件上传功能
- 缺少链接输入功能
- 与 Relic3DView 的功能不一致

## 解决方案

### 1. 添加选项卡界面

**修改前**：只有文件上传
```vue
<div v-if="!form.model3dUrl" class="upload-3d-section">
  <el-upload ...>
    上传3D模型
  </el-upload>
</div>
```

**修改后**：选项卡切换（文件/链接）
```vue
<div v-if="!form.model3dUrl">
  <el-tabs v-model="model3dUploadMode">
    <!-- 上传文件 -->
    <el-tab-pane label="上传文件" name="file">
      <el-upload ...>
        上传3D模型
      </el-upload>
    </el-tab-pane>
    
    <!-- 输入链接 -->
    <el-tab-pane label="输入链接" name="url">
      <el-input v-model="model3dUrlInput" placeholder="请输入3D模型链接...">
        <template #prepend>
          <el-icon><Link /></el-icon>
        </template>
      </el-input>
    </el-tab-pane>
  </el-tabs>
</div>
```

### 2. 添加状态变量

```javascript
const model3dUploadMode = ref('file')  // 'file' 或 'url'
const model3dUrlInput = ref('')  // 3D模型链接输入
```

### 3. 修复删除方法

**修改前**：
```javascript
const delete3DModel = async () => {
  const filename = form.model3dUrl.split('/').pop()
  await request.delete(`/relics/${form.id}/3d-model`, {
    params: { filename }
  })
}
```

**修改后**：
```javascript
const delete3DModel = async () => {
  // 使用新的删除端点（不需要filename参数）
  await request.delete(`/relics/${form.id}/3d-model-url`)
  
  // 清除表单中的3D模型信息
  form.model3dUrl = null
  form.model3dUploadTime = null
}
```

### 4. 修改提交逻辑

**编辑模式**：
```javascript
// 处理3D模型上传或链接
if (model3dUploadMode.value === 'file' && model3dFileList.value.length > 0) {
  // 文件上传模式
  const formData = new FormData()
  formData.append('file', model3dFile)
  await request.post(`/relics/${form.id}/3d-model`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
} else if (model3dUploadMode.value === 'url' && model3dUrlInput.value) {
  // 链接模式
  await request.post(`/relics/${form.id}/3d-model-url`, {
    modelUrl: model3dUrlInput.value
  })
}
```

**新增模式**：同样的逻辑，使用 `relicId` 而不是 `form.id`

### 5. 重置状态

在 `openAdd()` 和 `openEdit()` 方法中重置状态：
```javascript
model3dFileList.value = []
model3dUrlInput.value = ''
model3dUploadMode.value = 'file'
```

### 6. 添加国际化翻译

**中文**：
```javascript
uploadFile: '上传文件',
inputLink: '输入链接',
input3DModelLink: '请输入3D模型链接（支持Sketchfab、直接模型文件链接等）',
support3DLinks: '支持Sketchfab链接、直接模型文件链接（.gltf, .glb, .obj）等',
save3DModelLinkSuccess: '3D模型链接保存成功',
save3DModelLinkFailed: '3D模型链接保存失败',
```

**英文**：
```javascript
uploadFile: 'Upload File',
inputLink: 'Input Link',
input3DModelLink: 'Please enter 3D model link (supports Sketchfab, direct model file links, etc.)',
support3DLinks: 'Supports Sketchfab links, direct model file links (.gltf, .glb, .obj), etc.',
save3DModelLinkSuccess: '3D model link saved successfully',
save3DModelLinkFailed: 'Failed to save 3D model link',
```

## 新的UI布局

### 编辑文物对话框 - 有3D模型时

```
┌─────────────────────────────────────────┐
│  3D模型                                  │
├─────────────────────────────────────────┤
│  ✅ 已上传3D模型                         │
│  模型链接：https://sketchfab.com/...    │
│  上传时间：2026-05-06 17:00:00          │
│  [查看3D模型] [删除模型]                 │
└─────────────────────────────────────────┘
```

### 编辑文物对话框 - 无3D模型时

```
┌─────────────────────────────────────────┐
│  3D模型                                  │
├─────────────────────────────────────────┤
│  [上传文件]  [输入链接]                  │
│  ┌─────────────────────────────────┐    │
│  │  输入链接选项卡：                │    │
│  │  🔗 请输入3D模型链接...          │    │
│  │  支持Sketchfab链接、直接模型...  │    │
│  └─────────────────────────────────┘    │
└─────────────────────────────────────────┘
```

## API端点对照

| 操作 | 旧端点（已废弃） | 新端点 |
|-----|----------------|--------|
| 上传文件 | `POST /relics/{id}/3d-model` | `POST /relics/{id}/3d-model` ✅ |
| 保存链接 | ❌ 不存在 | `POST /relics/{id}/3d-model-url` ✅ |
| 删除模型 | `DELETE /relics/{id}/3d-model?filename=xxx` ❌ | `DELETE /relics/{id}/3d-model-url` ✅ |
| 获取信息 | `GET /relics/{id}/3d-model` | `GET /relics/{id}/3d-model` ✅ |

## 工作流程

### 场景1：编辑文物 - 上传文件

1. 点击"编辑"按钮打开对话框
2. 如果没有3D模型，显示选项卡
3. 在"上传文件"选项卡中拖拽或选择文件
4. 点击"确定"提交
5. 文件上传到服务器
6. 保存URL到数据库

### 场景2：编辑文物 - 输入链接

1. 点击"编辑"按钮打开对话框
2. 切换到"输入链接"选项卡
3. 输入Sketchfab或其他模型链接
4. 点击"确定"提交
5. 链接保存到数据库

### 场景3：删除3D模型

1. 点击"编辑"按钮打开对话框
2. 看到"已上传3D模型"提示
3. 点击"删除模型"按钮
4. 确认删除
5. 调用新的删除端点
6. 清空数据库中的模型URL

## 编译验证

### 前端编译
```bash
npm run build
```
**结果**：✅ 编译成功
- 编译时间：13.06秒
- 模块数：2439个
- 主包大小：3,241.20 kB（gzip: 1,003.72 kB）

### 后端编译
```bash
mvn clean compile -DskipTests
```
**结果**：✅ 编译成功（之前已验证）

## 修改的文件清单

### 前端文件（3个）
1. `frontend/src/views/RelicsView.vue`
   - 添加选项卡界面
   - 添加链接输入功能
   - 修复删除端点
   - 修改提交逻辑
   - 重置状态管理

2. `frontend/src/i18n/locales/zh-CN.js`
   - 添加中文翻译

3. `frontend/src/i18n/locales/en-US.js`
   - 添加英文翻译

**总计：3个文件修改**

## 功能对比

| 功能 | Relic3DView | RelicsView（修复前） | RelicsView（修复后） |
|-----|------------|-------------------|-------------------|
| 上传文件 | ✅ | ✅ | ✅ |
| 输入链接 | ✅ | ❌ | ✅ |
| 删除模型 | ✅ | ❌ (404错误) | ✅ |
| 查看模型 | ✅ | ✅ | ✅ |
| 选项卡界面 | ✅ | ❌ | ✅ |

## 测试步骤

### 1. 测试文件上传
1. 打开文物管理页面
2. 点击"编辑"按钮
3. 在"上传文件"选项卡中选择3D模型文件
4. 点击"确定"
5. 验证文件上传成功

### 2. 测试链接输入
1. 打开文物管理页面
2. 点击"编辑"按钮
3. 切换到"输入链接"选项卡
4. 输入Sketchfab链接
5. 点击"确定"
6. 验证链接保存成功

### 3. 测试删除功能
1. 打开有3D模型的文物编辑对话框
2. 点击"删除模型"按钮
3. 确认删除
4. 验证删除成功（不再出现404错误）

### 4. 测试查看功能
1. 打开有3D模型的文物编辑对话框
2. 点击"查看3D模型"按钮
3. 验证跳转到3D展示页面

## 常见问题排查

### 问题1：删除仍然404
**检查**：确认后端已部署新代码
**解决**：重启后端服务

### 问题2：链接保存失败
**检查**：查看浏览器控制台和网络请求
**解决**：确认token有效，用户有权限

### 问题3：选项卡不显示
**检查**：确认 `form.model3dUrl` 为空
**解决**：如果已有模型，先删除再添加

## 完成时间
2026-05-06

## 状态
✅ 选项卡界面添加完成
✅ 链接输入功能添加完成
✅ 删除端点修复完成
✅ 提交逻辑修改完成
✅ 国际化翻译添加完成
✅ 前端编译成功
✅ 功能测试就绪
