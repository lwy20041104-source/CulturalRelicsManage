<template>
  <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="文物编号">
          <el-input v-model="form.relicCode" disabled placeholder="自动生成" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="文物名称" prop="relicName">
          <el-input v-model="form.relicName" placeholder="请输入文物名称" />
        </el-form-item>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="年代" prop="era">
          <el-select v-model="form.era" placeholder="请选择年代" style="width: 100%" clearable>
            <el-option label="史前" value="史前" />
            <el-option label="夏朝" value="夏朝" />
            <el-option label="商朝" value="商朝" />
            <el-option label="东周" value="东周" />
            <el-option label="西周" value="西周" />
            <el-option label="春秋" value="春秋" />
            <el-option label="战国" value="战国" />
            <el-option label="秦朝" value="秦朝" />
            <el-option label="汉朝" value="汉朝" />
            <el-option label="三国" value="三国" />
            <el-option label="晋朝" value="晋朝" />
            <el-option label="南北朝" value="南北朝" />
            <el-option label="隋朝" value="隋朝" />
            <el-option label="唐朝" value="唐朝" />
            <el-option label="五代十国" value="五代十国" />
            <el-option label="宋朝" value="宋朝" />
            <el-option label="辽朝" value="辽朝" />
            <el-option label="西夏" value="西夏" />
            <el-option label="金朝" value="金朝" />
            <el-option label="元朝" value="元朝" />
            <el-option label="明朝" value="明朝" />
            <el-option label="清朝" value="清朝" />
            <el-option label="民国" value="民国" />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="材质" prop="material">
          <el-input v-model="form.material" placeholder="请输入材质" />
        </el-form-item>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="分类" prop="categoryId">
          <el-select v-model="form.categoryId" placeholder="请选择分类" style="width: 100%">
            <el-option
              v-for="item in categoryOptions"
              :key="item.id"
              :label="item.categoryName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="状态" prop="status">
          <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
            <el-option label="在库" value="在库" />
            <el-option label="借展中" value="借展中" />
            <el-option label="修复中" value="修复中" />
            <el-option label="封存" value="封存" />
          </el-select>
        </el-form-item>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-form-item label="尺寸">
          <el-input v-model="form.dimensions" placeholder="例如：高30cm，宽20cm" />
        </el-form-item>
      </el-col>
      <el-col :span="12">
        <el-form-item label="重量">
          <el-input-number
            v-model="form.weight"
            :min="0"
            :precision="2"
            :controls="false"
            placeholder="请输入重量"
            style="width: calc(100% - 30px)"
          />
          <span style="margin-left: 8px">kg</span>
        </el-form-item>
      </el-col>
    </el-row>

    <el-form-item label="产地">
      <el-input v-model="form.origin" placeholder="请输入产地" />
    </el-form-item>

    <el-form-item label="描述">
      <el-input
        v-model="form.description"
        type="textarea"
        :rows="3"
        placeholder="请输入文物描述"
      />
    </el-form-item>

    <!-- 图片上传区域 -->
    <el-form-item label="文物图片">
      <div class="image-upload-area">
        <!-- 已有图片预览 -->
        <div v-if="imagePreview" class="image-preview-container">
          <el-image
            :src="imagePreview"
            fit="cover"
            class="preview-image"
            :preview-src-list="[imagePreview]"
          />
          <div class="image-actions">
            <el-button
              type="danger"
              size="small"
              :icon="Delete"
              @click="removeImage"
            >
              移除
            </el-button>
          </div>
        </div>

        <!-- 上传按钮 -->
        <div v-else class="upload-area">
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :show-file-list="false"
            :on-change="handleFileChange"
            accept="image/*"
            drag
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
              拖拽文件到此处或<em>点击上传</em>
            </div>
            <template #tip>
              <div class="el-upload__tip">
                支持 jpg/png/gif 格式，文件大小不超过 5MB
              </div>
            </template>
          </el-upload>

          <el-divider>或</el-divider>

          <el-button @click="showImageLibrary" :icon="FolderOpened">
            从图片库选择
          </el-button>
        </div>
      </div>
    </el-form-item>

    <!-- 图片库选择对话框 -->
    <el-dialog
      v-model="libraryVisible"
      title="选择图片"
      width="80%"
      :close-on-click-modal="false"
    >
      <ImageLibrarySelector
        v-if="libraryVisible"
        @select="handleSelectFromLibrary"
        @cancel="libraryVisible = false"
      />
    </el-dialog>
  </el-form>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Delete, FolderOpened, UploadFilled } from '@element-plus/icons-vue'
import ImageLibrarySelector from './ImageLibrarySelector.vue'

const props = defineProps({
  modelValue: {
    type: Object,
    default: () => ({})
  },
  categoryOptions: {
    type: Array,
    default: () => []
  }
})

const emit = defineEmits(['update:modelValue'])

const formRef = ref(null)
const uploadRef = ref(null)
const libraryVisible = ref(false)
const imageFile = ref(null)
const imagePreview = ref('')
const selectedImageId = ref(null)

const form = computed({
  get: () => props.modelValue,
  set: (val) => emit('update:modelValue', val)
})

// 表单验证规则
const rules = {
  relicName: [{ required: true, message: '请输入文物名称', trigger: 'blur' }],
  era: [{ required: true, message: '请选择年代', trigger: 'change' }],
  material: [{ required: true, message: '请输入材质', trigger: 'blur' }],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }]
}

// 监听表单中的imagePath变化
watch(() => form.value.imagePath, (newVal) => {
  if (newVal && !imageFile.value && !selectedImageId.value) {
    imagePreview.value = resolveImageUrl(newVal)
  }
})

// 处理文件选择
const handleFileChange = (file) => {
  const isImage = file.raw.type.startsWith('image/')
  const isLt5M = file.raw.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return
  }

  imageFile.value = file.raw
  selectedImageId.value = null
  
  // 生成预览
  const reader = new FileReader()
  reader.onload = (e) => {
    imagePreview.value = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

// 从图片库选择
const showImageLibrary = () => {
  libraryVisible.value = true
}

const handleSelectFromLibrary = (image) => {
  selectedImageId.value = image.id
  imageFile.value = null
  imagePreview.value = resolveImageUrl(image.filePath)
  libraryVisible.value = false
  ElMessage.success('已选择图片')
}

// 移除图片
const removeImage = () => {
  imageFile.value = null
  selectedImageId.value = null
  imagePreview.value = ''
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
}

// 解析图片URL
const resolveImageUrl = (path) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  return `${import.meta.env.VITE_API_BASE_URL}${path}`
}

// 获取表单数据（包含图片）
const getFormData = () => {
  const formData = new FormData()
  
  // 添加文物基本信息
  Object.keys(form.value).forEach(key => {
    if (form.value[key] !== null && form.value[key] !== undefined && form.value[key] !== '') {
      formData.append(key, form.value[key])
    }
  })
  
  // 添加图片
  if (imageFile.value) {
    formData.append('imageFile', imageFile.value)
  } else if (selectedImageId.value) {
    formData.append('imageId', selectedImageId.value)
  }
  
  return formData
}

// 验证表单
const validate = async () => {
  if (!formRef.value) return false
  return await formRef.value.validate()
}

// 重置表单
const resetFields = () => {
  if (formRef.value) {
    formRef.value.resetFields()
  }
  removeImage()
}

// 暴露方法给父组件
defineExpose({
  validate,
  resetFields,
  getFormData
})
</script>

<style scoped>
.image-upload-area {
  width: 100%;
}

.image-preview-container {
  text-align: center;
}

.preview-image {
  width: 300px;
  height: 300px;
  border-radius: 8px;
  border: 1px solid #dcdfe6;
}

.image-actions {
  margin-top: 16px;
}

.upload-area {
  text-align: center;
}

.el-upload__tip {
  margin-top: 8px;
  color: #909399;
  font-size: 12px;
}

:deep(.el-upload-dragger) {
  padding: 40px;
}

:deep(.el-icon--upload) {
  font-size: 67px;
  color: #c0c4cc;
  margin-bottom: 16px;
}
</style>
