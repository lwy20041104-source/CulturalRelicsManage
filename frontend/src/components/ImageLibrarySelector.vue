<template>
  <div class="image-library-selector">
    <!-- 搜索栏 -->
    <div class="search-bar">
      <el-input
        v-model="searchKeyword"
        placeholder="搜索图片名称或标签"
        clearable
        @keyup.enter="loadImages"
        style="width: 300px"
      >
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
      <el-select
        v-model="searchCategory"
        placeholder="分类"
        clearable
        style="width: 150px; margin-left: 10px"
        @change="loadImages"
      >
        <el-option label="全部" value="" />
        <el-option label="文物" value="relic" />
        <el-option label="展览" value="exhibition" />
        <el-option label="文档" value="document" />
        <el-option label="其他" value="other" />
      </el-select>
      <el-button type="primary" @click="loadImages" style="margin-left: 10px">
        搜索
      </el-button>
    </div>

    <!-- 图片网格 -->
    <div class="image-grid" v-loading="loading">
      <div
        v-for="image in images"
        :key="image.id"
        class="image-item"
        :class="{ selected: selectedImage?.id === image.id }"
        @click="selectImage(image)"
      >
        <el-image
          :src="resolveImageUrl(image.filePath)"
          fit="cover"
          class="image-thumbnail"
        >
          <template #error>
            <div class="image-error">
              <el-icon><Picture /></el-icon>
            </div>
          </template>
        </el-image>
        <div class="image-info">
          <div class="image-name" :title="image.imageName">
            {{ image.imageName }}
          </div>
          <div class="image-meta">
            {{ formatFileSize(image.fileSize) }}
          </div>
        </div>
        <div v-if="selectedImage?.id === image.id" class="selected-icon">
          <el-icon><Check /></el-icon>
        </div>
      </div>
    </div>

    <!-- 空状态 -->
    <el-empty v-if="!loading && images.length === 0" description="暂无图片" />

    <!-- 分页 -->
    <el-pagination
      v-if="total > 0"
      class="pagination"
      background
      layout="total, prev, pager, next"
      :total="total"
      :page-size="pageSize"
      :current-page="currentPage"
      @current-change="handlePageChange"
    />

    <!-- 底部操作栏 -->
    <div class="footer-actions">
      <el-button @click="handleCancel">取消</el-button>
      <el-button type="primary" @click="handleConfirm" :disabled="!selectedImage">
        确定
      </el-button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { Search, Picture, Check } from '@element-plus/icons-vue'
import { getImagesPageApi } from '@/api/images'

const emit = defineEmits(['select', 'cancel'])

const loading = ref(false)
const images = ref([])
const selectedImage = ref(null)
const searchKeyword = ref('')
const searchCategory = ref('')
const currentPage = ref(1)
const pageSize = ref(20)
const total = ref(0)

onMounted(() => {
  loadImages()
})

// 加载图片列表
const loadImages = async () => {
  try {
    loading.value = true
    const params = {
      pageNum: currentPage.value,
      pageSize: pageSize.value,
      imageName: searchKeyword.value,
      category: searchCategory.value
    }
    const response = await getImagesPageApi(params)
    images.value = response.data.records || []
    total.value = response.data.total || 0
  } catch (error) {
    console.error('加载图片失败:', error)
    ElMessage.error('加载图片失败')
  } finally {
    loading.value = false
  }
}

// 选择图片
const selectImage = (image) => {
  selectedImage.value = image
}

// 翻页
const handlePageChange = (page) => {
  currentPage.value = page
  loadImages()
}

// 确认选择
const handleConfirm = () => {
  if (selectedImage.value) {
    emit('select', selectedImage.value)
  }
}

// 取消
const handleCancel = () => {
  emit('cancel')
}

// 解析图片URL
const resolveImageUrl = (path) => {
  if (!path) return ''
  if (path.startsWith('http')) return path
  return `${import.meta.env.VITE_API_BASE_URL}${path}`
}

// 格式化文件大小
const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}
</script>

<style scoped>
.image-library-selector {
  min-height: 500px;
  display: flex;
  flex-direction: column;
}

.search-bar {
  margin-bottom: 20px;
  display: flex;
  align-items: center;
}

.image-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 16px;
  flex: 1;
  margin-bottom: 20px;
}

.image-item {
  position: relative;
  border: 2px solid transparent;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  background: #f5f7fa;
}

.image-item:hover {
  border-color: #409eff;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.image-item.selected {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.image-thumbnail {
  width: 100%;
  height: 150px;
  display: block;
}

.image-error {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: #f5f7fa;
  color: #909399;
  font-size: 40px;
}

.image-info {
  padding: 8px;
  background: white;
}

.image-name {
  font-size: 14px;
  color: #303133;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 4px;
}

.image-meta {
  font-size: 12px;
  color: #909399;
}

.selected-icon {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 24px;
  height: 24px;
  background: #409eff;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  color: white;
  font-size: 16px;
}

.pagination {
  display: flex;
  justify-content: center;
  margin: 20px 0;
}

.footer-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  padding-top: 20px;
  border-top: 1px solid #dcdfe6;
}
</style>
