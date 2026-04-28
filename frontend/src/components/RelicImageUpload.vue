<template>
  <div class="relic-image-upload">
    <!-- 图片预览 -->
    <div class="image-preview" v-if="imageUrl">
      <el-image
        :src="imageUrl"
        fit="cover"
        :preview-src-list="[imageUrl]"
        class="preview-image"
      >
        <template #error>
          <div class="image-slot">
            <el-icon><icon-picture /></el-icon>
          </div>
        </template>
      </el-image>
      <div class="image-actions">
        <el-button
          type="danger"
          size="small"
          :icon="Delete"
          @click="handleRemove"
          :loading="removing"
        >
          移除图片
        </el-button>
      </div>
    </div>

    <!-- 上传按钮 -->
    <el-upload
      v-else
      class="upload-container"
      :action="uploadUrl"
      :headers="uploadHeaders"
      :show-file-list="false"
      :before-upload="beforeUpload"
      :on-success="handleSuccess"
      :on-error="handleError"
      accept="image/*"
    >
      <el-button type="primary" :icon="Upload" :loading="uploading">
        {{ uploading ? '上传中...' : '上传图片' }}
      </el-button>
      <template #tip>
        <div class="el-upload__tip">
          支持 jpg/png/gif 格式，文件大小不超过 5MB
        </div>
      </template>
    </el-upload>

    <!-- 或从图片库选择 -->
    <div class="select-from-library" v-if="!imageUrl">
      <el-divider>或</el-divider>
      <el-button @click="showImageLibrary" :icon="FolderOpened">
        从图片库选择
      </el-button>
    </div>

    <!-- 图片库选择对话框 -->
    <el-dialog
      v-model="libraryVisible"
      title="选择图片"
      width="80%"
      :close-on-click-modal="false"
    >
      <ImageLibrarySelector
        @select="handleSelectFromLibrary"
        @cancel="libraryVisible = false"
      />
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { Upload, Delete, FolderOpened, Picture as IconPicture } from '@element-plus/icons-vue'
import { uploadRelicImageApi, removeRelicMainImageApi, setRelicMainImageApi } from '@/api/relicImages'
import ImageLibrarySelector from './ImageLibrarySelector.vue'

const props = defineProps({
  relicId: {
    type: Number,
    required: true
  },
  modelValue: {
    type: String,
    default: ''
  }
})

const emit = defineEmits(['update:modelValue', 'change'])

const imageUrl = ref(props.modelValue)
const uploading = ref(false)
const removing = ref(false)
const libraryVisible = ref(false)

// 监听外部值变化
watch(() => props.modelValue, (newVal) => {
  imageUrl.value = newVal
})

// 上传地址（这里使用自定义上传方法，所以action可以是空字符串）
const uploadUrl = computed(() => '')

// 上传请求头
const uploadHeaders = computed(() => {
  const token = localStorage.getItem('token')
  return token ? { Authorization: `Bearer ${token}` } : {}
})

// 完整的图片URL
const fullImageUrl = computed(() => {
  if (!imageUrl.value) return ''
  if (imageUrl.value.startsWith('http')) return imageUrl.value
  return `${import.meta.env.VITE_API_BASE_URL}${imageUrl.value}`
})

// 上传前验证
const beforeUpload = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt5M = file.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }

  uploading.value = true
  
  // 使用自定义上传方法
  uploadRelicImageApi(props.relicId, file)
    .then(response => {
      handleSuccess(response)
    })
    .catch(error => {
      handleError(error)
    })
  
  return false // 阻止默认上传行为
}

// 上传成功
const handleSuccess = (response) => {
  uploading.value = false
  if (response.code === 200) {
    imageUrl.value = response.data
    emit('update:modelValue', response.data)
    emit('change', response.data)
    ElMessage.success('上传成功')
  } else {
    ElMessage.error(response.message || '上传失败')
  }
}

// 上传失败
const handleError = (error) => {
  uploading.value = false
  console.error('上传失败:', error)
  ElMessage.error('上传失败，请重试')
}

// 移除图片
const handleRemove = async () => {
  try {
    removing.value = true
    await removeRelicMainImageApi(props.relicId)
    imageUrl.value = ''
    emit('update:modelValue', '')
    emit('change', '')
    ElMessage.success('移除成功')
  } catch (error) {
    console.error('移除失败:', error)
    ElMessage.error('移除失败，请重试')
  } finally {
    removing.value = false
  }
}

// 显示图片库
const showImageLibrary = () => {
  libraryVisible.value = true
}

// 从图片库选择
const handleSelectFromLibrary = async (image) => {
  try {
    await setRelicMainImageApi(props.relicId, image.id)
    imageUrl.value = image.filePath
    emit('update:modelValue', image.filePath)
    emit('change', image.filePath)
    libraryVisible.value = false
    ElMessage.success('设置成功')
  } catch (error) {
    console.error('设置失败:', error)
    ElMessage.error('设置失败，请重试')
  }
}
</script>

<style scoped>
.relic-image-upload {
  width: 100%;
}

.image-preview {
  text-align: center;
}

.preview-image {
  width: 300px;
  height: 300px;
  border-radius: 8px;
  margin-bottom: 16px;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 30px;
}

.image-actions {
  margin-top: 16px;
}

.upload-container {
  text-align: center;
}

.select-from-library {
  margin-top: 20px;
  text-align: center;
}

.el-upload__tip {
  margin-top: 8px;
  color: #909399;
  font-size: 12px;
}
</style>
