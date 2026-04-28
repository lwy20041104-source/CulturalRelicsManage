# 文物多图片功能 - 前端实现指南

## 已完成 ✅

### 1. API接口文件 ✅
**文件**：`frontend/src/api/relicImages.js`

**包含的API**：
- `getRelicImagesApi(relicId)` - 获取文物的所有图片
- `batchUploadImagesApi(relicId, files)` - 批量上传图片
- `setMainImageApi(relicId, imageId)` - 设置主图
- `deleteRelicImageApi(relicId, imageId)` - 删除图片
- 其他辅助API

## 待实现 ⏳

### 2. 修改 RelicsView.vue

由于 RelicsView.vue 文件较大且复杂，建议采用**渐进式改造**策略：

#### 方案A：在编辑对话框中添加多图片管理区域（推荐）

**位置**：在现有的单图片上传区域下方添加

**修改步骤**：

1. **在 `<script setup>` 中添加新的响应式数据**：
```javascript
// 在现有的 imagePreview 等变量后添加
const relicImages = ref([])  // 文物的所有图片
const uploadingImages = ref(false)  // 批量上传状态
```

2. **添加多图片管理方法**：
```javascript
// 加载文物的所有图片
const loadRelicImages = async (relicId) => {
  if (!relicId) return
  try {
    const res = await getRelicImagesApi(relicId)
    relicImages.value = res.data || []
  } catch (error) {
    console.error('加载图片失败:', error)
  }
}

// 批量上传图片
const handleBatchUpload = async (fileList) => {
  if (!form.id) {
    ElMessage.warning('请先保存文物信息后再上传图片')
    return
  }
  
  if (fileList.length === 0) return
  if (fileList.length > 10) {
    ElMessage.warning('最多只能上传10张图片')
    return
  }
  
  try {
    uploadingImages.value = true
    const res = await batchUploadImagesApi(form.id, fileList)
    
    if (res.data.successCount > 0) {
      ElMessage.success(`成功上传 ${res.data.successCount} 张图片`)
      await loadRelicImages(form.id)
    }
    
    if (res.data.failedCount > 0) {
      ElMessage.warning(`${res.data.failedCount} 张图片上传失败`)
    }
  } catch (error) {
    ElMessage.error('上传失败: ' + error.message)
  } finally {
    uploadingImages.value = false
  }
}

// 设置主图
const handleSetMainImage = async (image) => {
  try {
    await setMainImageApi(form.id, image.imageId)
    ElMessage.success('主图设置成功')
    await loadRelicImages(form.id)
  } catch (error) {
    ElMessage.error('设置失败: ' + error.message)
  }
}

// 删除图片
const handleDeleteImage = async (image) => {
  try {
    await ElMessageBox.confirm('确定要删除这张图片吗？', '警告', {
      type: 'warning'
    })
    
    await deleteRelicImageApi(form.id, image.imageId)
    ElMessage.success('删除成功')
    await loadRelicImages(form.id)
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败: ' + error.message)
    }
  }
}
```

3. **在 `openEdit` 方法中加载图片**：
```javascript
const openEdit = async (row) => {
  // ... 现有代码 ...
  
  // 加载文物的所有图片
  await loadRelicImages(row.id)
  
  dialogVisible.value = true
}
```

4. **在对话框模板中添加多图片管理区域**：

在现有的单图片上传区域（`<el-form-item :label="$t('relic.image')">`）**之后**添加：

```vue
<!-- 多图片管理区域（仅编辑时显示） -->
<el-form-item v-if="form.id" :label="$t('relicImages.title')">
  <div class="multi-images-manager">
    <!-- 上传区域 -->
    <el-upload
      :auto-upload="false"
      :on-change="handleMultiImageChange"
      :show-file-list="false"
      accept="image/*"
      multiple
      :limit="10"
      class="multi-upload"
    >
      <el-button type="primary" :loading="uploadingImages">
        <el-icon><Plus /></el-icon>
        {{ $t('relicImages.uploadImages') }}
      </el-button>
      <template #tip>
        <div class="el-upload__tip">
          {{ $t('relicImages.maxImages', { count: 10 }) }}
        </div>
      </template>
    </el-upload>
    
    <!-- 图片列表 -->
    <div v-if="relicImages.length > 0" class="images-grid">
      <div 
        v-for="img in relicImages" 
        :key="img.id" 
        class="image-card"
        :class="{ 'is-main': img.isMain === 1 }"
      >
        <el-image
          :src="resolveImageUrl(img.image.filePath)"
          fit="cover"
          class="image-thumb"
          :preview-src-list="relicImages.map(i => resolveImageUrl(i.image.filePath))"
          preview-teleported
        />
        
        <!-- 主图标签 -->
        <el-tag v-if="img.isMain === 1" type="success" class="main-tag">
          {{ $t('relicImages.mainImage') }}
        </el-tag>
        
        <!-- 操作按钮 -->
        <div class="image-actions">
          <el-button 
            v-if="img.isMain !== 1" 
            size="small" 
            type="primary"
            @click="handleSetMainImage(img)"
          >
            {{ $t('relicImages.setAsMain') }}
          </el-button>
          <el-button 
            size="small" 
            type="danger"
            @click="handleDeleteImage(img)"
          >
            {{ $t('relicImages.deleteImage') }}
          </el-button>
        </div>
      </div>
    </div>
    
    <!-- 无图片提示 -->
    <el-empty 
      v-else 
      :description="$t('relicImages.noImages')" 
      :image-size="100"
    />
  </div>
</el-form-item>
```

5. **添加处理多图片选择的方法**：
```javascript
const handleMultiImageChange = async (file, fileList) => {
  // 过滤出新选择的文件
  const files = fileList.map(f => f.raw).filter(f => f)
  
  if (files.length > 0) {
    await handleBatchUpload(files)
  }
}
```

6. **添加样式**：

在 `<style scoped>` 中添加：

```css
/* 多图片管理器 */
.multi-images-manager {
  width: 100%;
}

.multi-upload {
  margin-bottom: 20px;
}

.images-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 15px;
  margin-top: 15px;
}

.image-card {
  position: relative;
  border: 2px solid #eadfce;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
}

.image-card.is-main {
  border-color: #67c23a;
  box-shadow: 0 0 10px rgba(103, 194, 58, 0.3);
}

.image-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.image-thumb {
  width: 100%;
  height: 150px;
  display: block;
}

.main-tag {
  position: absolute;
  top: 8px;
  left: 8px;
  z-index: 1;
}

.image-actions {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.7);
  padding: 8px;
  display: flex;
  gap: 5px;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.image-card:hover .image-actions {
  opacity: 1;
}

.image-actions .el-button {
  flex: 1;
  font-size: 12px;
}
```

#### 方案B：创建独立的多图片管理组件（可选）

如果想要更模块化的实现，可以创建一个独立组件：

**文件**：`frontend/src/components/RelicImagesManager.vue`

```vue
<template>
  <div class="relic-images-manager">
    <!-- 上传按钮 -->
    <el-upload
      :auto-upload="false"
      :on-change="handleImageChange"
      :show-file-list="false"
      accept="image/*"
      multiple
      :limit="10"
    >
      <el-button type="primary" :loading="uploading">
        <el-icon><Plus /></el-icon>
        上传图片
      </el-button>
    </el-upload>
    
    <!-- 图片网格 -->
    <div v-if="images.length > 0" class="images-grid">
      <div v-for="img in images" :key="img.id" class="image-item">
        <el-image :src="img.image.filePath" fit="cover" />
        <el-tag v-if="img.isMain" type="success">主图</el-tag>
        <div class="actions">
          <el-button v-if="!img.isMain" size="small" @click="setMain(img)">
            设为主图
          </el-button>
          <el-button size="small" type="danger" @click="deleteImage(img)">
            删除
          </el-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import { 
  getRelicImagesApi, 
  batchUploadImagesApi, 
  setMainImageApi, 
  deleteRelicImageApi 
} from '../api/relicImages'

const props = defineProps({
  relicId: {
    type: Number,
    required: true
  }
})

const emit = defineEmits(['update'])

const images = ref([])
const uploading = ref(false)

// 加载图片
const loadImages = async () => {
  try {
    const res = await getRelicImagesApi(props.relicId)
    images.value = res.data || []
  } catch (error) {
    console.error('加载图片失败:', error)
  }
}

// 处理图片选择
const handleImageChange = async (file, fileList) => {
  const files = fileList.map(f => f.raw).filter(f => f)
  
  if (files.length === 0) return
  if (files.length > 10) {
    ElMessage.warning('最多只能上传10张图片')
    return
  }
  
  try {
    uploading.value = true
    const res = await batchUploadImagesApi(props.relicId, files)
    
    if (res.data.successCount > 0) {
      ElMessage.success(`成功上传 ${res.data.successCount} 张图片`)
      await loadImages()
      emit('update')
    }
  } catch (error) {
    ElMessage.error('上传失败')
  } finally {
    uploading.value = false
  }
}

// 设置主图
const setMain = async (img) => {
  try {
    await setMainImageApi(props.relicId, img.imageId)
    ElMessage.success('主图设置成功')
    await loadImages()
    emit('update')
  } catch (error) {
    ElMessage.error('设置失败')
  }
}

// 删除图片
const deleteImage = async (img) => {
  try {
    await ElMessageBox.confirm('确定要删除这张图片吗？', '警告', {
      type: 'warning'
    })
    
    await deleteRelicImageApi(props.relicId, img.imageId)
    ElMessage.success('删除成功')
    await loadImages()
    emit('update')
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 监听relicId变化
watch(() => props.relicId, (newId) => {
  if (newId) {
    loadImages()
  }
}, { immediate: true })

defineExpose({ loadImages })
</script>

<style scoped>
.images-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 15px;
  margin-top: 15px;
}

.image-item {
  position: relative;
  border: 2px solid #eee;
  border-radius: 8px;
  overflow: hidden;
}

.image-item .el-image {
  width: 100%;
  height: 150px;
}

.image-item .el-tag {
  position: absolute;
  top: 8px;
  left: 8px;
}

.actions {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.7);
  padding: 8px;
  display: flex;
  gap: 5px;
  opacity: 0;
  transition: opacity 0.3s;
}

.image-item:hover .actions {
  opacity: 1;
}
</style>
```

然后在 RelicsView.vue 中使用：

```vue
<el-form-item v-if="form.id" label="文物图片">
  <RelicImagesManager :relic-id="form.id" @update="loadData" />
</el-form-item>
```

### 3. 国际化配置

**文件**：`frontend/src/i18n/locales/zh-CN.js`

在 `export default` 对象中添加：

```javascript
relicImages: {
  title: '文物图片',
  uploadImages: '上传图片',
  mainImage: '主图',
  setAsMain: '设为主图',
  deleteImage: '删除',
  imageList: '图片列表',
  noImages: '暂无图片',
  uploadSuccess: '上传成功',
  uploadFailed: '上传失败',
  deleteConfirm: '确定要删除这张图片吗？',
  setMainSuccess: '主图设置成功',
  maxImages: '最多上传{count}张图片'
}
```

**文件**：`frontend/src/i18n/locales/en-US.js`

```javascript
relicImages: {
  title: 'Relic Images',
  uploadImages: 'Upload Images',
  mainImage: 'Main Image',
  setAsMain: 'Set as Main',
  deleteImage: 'Delete',
  imageList: 'Image List',
  noImages: 'No Images',
  uploadSuccess: 'Upload Successful',
  uploadFailed: 'Upload Failed',
  deleteConfirm: 'Are you sure to delete this image?',
  setMainSuccess: 'Main image set successfully',
  maxImages: 'Maximum {count} images allowed'
}
```

## 实施建议

### 推荐方案：方案A（直接修改RelicsView.vue）

**优点**：
- 不需要创建新组件
- 与现有代码集成更紧密
- 用户体验更流畅

**缺点**：
- RelicsView.vue 文件会更大
- 需要仔细测试避免影响现有功能

### 实施步骤

1. ✅ 创建 API 接口文件（已完成）
2. ⏳ 在 RelicsView.vue 的 `<script setup>` 中添加新的响应式数据和方法
3. ⏳ 在对话框模板中添加多图片管理区域
4. ⏳ 添加样式
5. ⏳ 添加国际化配置
6. ⏳ 测试功能

### 测试清单

- [ ] 新增文物时，单图片上传功能正常
- [ ] 编辑文物时，可以看到多图片管理区域
- [ ] 批量上传图片功能正常
- [ ] 设置主图功能正常
- [ ] 删除图片功能正常
- [ ] 主图自动切换逻辑正常
- [ ] 图片预览功能正常
- [ ] 国际化切换正常
- [ ] 样式显示正常

## 注意事项

1. **保持向后兼容**：不要删除或修改现有的单图片上传功能
2. **错误处理**：所有API调用都要有try-catch
3. **用户提示**：操作成功/失败都要有明确的提示
4. **加载状态**：上传时显示loading状态
5. **图片限制**：前端验证最多10张图片
6. **权限控制**：只有编辑模式才显示多图片管理

## 相关文件

- ✅ `frontend/src/api/relicImages.js` - API接口（已完成）
- ⏳ `frontend/src/views/RelicsView.vue` - 文物管理界面（待修改）
- ⏳ `frontend/src/i18n/locales/zh-CN.js` - 中文国际化（待添加）
- ⏳ `frontend/src/i18n/locales/en-US.js` - 英文国际化（待添加）
- 📄 `frontend/src/components/RelicImagesManager.vue` - 独立组件（可选）
