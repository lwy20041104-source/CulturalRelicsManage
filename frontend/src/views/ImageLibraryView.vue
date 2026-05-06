<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input 
          v-model="query.imageName" 
          :placeholder="$t('image.imageName')" 
          style="width: 200px" 
          @keyup.enter="loadData" 
          clearable
        />
        <el-select 
          v-model="query.category" 
          :placeholder="$t('image.category')" 
          clearable 
          style="width: 160px"
        >
          <el-option :label="$t('image.relic')" value="relic" />
          <el-option :label="$t('image.exhibition')" value="exhibition" />
          <el-option :label="$t('image.document')" value="document" />
          <el-option :label="$t('image.other')" value="other" />
          <el-option :label="$t('image.uncategorized')" value="uncategorized" />
        </el-select>
        <el-input 
          v-model="query.tags" 
          :placeholder="$t('image.tags')" 
          style="width: 160px" 
          @keyup.enter="loadData" 
          clearable
        />
        <el-button type="primary" @click="loadData">{{ $t('common.search') }}</el-button>
        <el-button type="success" @click="openUploadDialog">{{ $t('image.uploadImage') }}</el-button>
        <el-button type="warning" @click="openBatchUploadDialog">{{ $t('image.batchUpload') }}</el-button>
        <el-button type="danger" @click="handleBatchDelete" :disabled="!selectedIds.length">
          {{ $t('image.batchDelete') }}
        </el-button>
        <el-button type="info" @click="showStatistics">{{ $t('image.statistics') }}</el-button>
      </div>
    </template>

    <!-- 图片网格视图 -->
    <div class="image-grid">
      <div 
        v-for="image in tableData" 
        :key="image.id" 
        class="image-card"
        :class="{ selected: selectedIds.includes(image.id) }"
        @click="toggleSelection(image)"
      >
        <div class="image-wrapper">
          <el-image
            :src="resolveImageUrl(image.filePath)"
            fit="cover"
            class="grid-image"
            :preview-src-list="[resolveImageUrl(image.filePath)]"
            preview-teleported
          >
            <template #error>
              <div class="image-error">
                <el-icon><Picture /></el-icon>
              </div>
            </template>
          </el-image>
          <div class="image-overlay">
            <el-button-group>
              <el-button size="small" @click.stop="viewDetail(image)">
                <el-icon><View /></el-icon>
                <span class="button-text">{{ $t('common.detail') }}</span>
              </el-button>
              <el-button size="small" @click.stop="openEdit(image)">
                <el-icon><Edit /></el-icon>
                <span class="button-text">{{ $t('common.edit') }}</span>
              </el-button>
              <el-button size="small" @click.stop="handleDownload(image.id)">
                <el-icon><Download /></el-icon>
                <span class="button-text">{{ $t('image.download') }}</span>
              </el-button>
              <el-button size="small" type="danger" @click.stop="remove(image.id)">
                <el-icon><Delete /></el-icon>
                <span class="button-text">{{ $t('common.delete') }}</span>
              </el-button>
            </el-button-group>
          </div>
          <el-checkbox 
            v-model="selectedIds" 
            :label="image.id" 
            class="image-checkbox"
            @click.stop
          />
        </div>
        <div class="image-info">
          <div class="image-name" :title="image.imageName">{{ formatImageName(image.imageName) }}</div>
          <div class="image-meta">
            <el-tag size="small" type="info">{{ getCategoryLabel(image.category) }}</el-tag>
            <span class="image-size">{{ formatFileSize(image.fileSize) }}</span>
          </div>
          <div class="image-stats">
            <span><el-icon><View /></el-icon> {{ image.viewCount }}</span>
            <span><el-icon><Download /></el-icon> {{ image.downloadCount }}</span>
          </div>
        </div>
      </div>
    </div>

    <el-pagination
      class="pager"
      background
      layout="total, sizes, prev, pager, next, jumper"
      :total="total"
      :page-size="query.pageSize"
      :page-sizes="[24, 48, 72, 96]"
      :current-page="query.pageNum"
      @size-change="(size) => { query.pageSize = size; loadData(); }"
      @current-change="(page) => { query.pageNum = page; loadData(); }"
    />

    <!-- 上传对话框 -->
    <el-dialog v-model="uploadDialogVisible" :title="$t('image.uploadImage')" width="600px">
      <el-form :model="uploadForm" :rules="uploadRules" ref="uploadFormRef" label-width="120px">
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
        <el-form-item :label="$t('image.selectFile')" prop="file" required>
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :limit="1"
            :on-change="handleFileChange"
            :file-list="fileList"
            accept="image/*"
            drag
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
              {{ $t('image.dragFileHere') }}<em>{{ $t('image.clickToUpload') }}</em>
            </div>
            <template #tip>
              <div class="el-upload__tip">{{ $t('image.uploadTip') }}</div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item :label="$t('image.imageName')">
          <el-input v-model="uploadForm.imageName" :placeholder="$t('image.imageNamePlaceholder')" />
        </el-form-item>
        <el-form-item :label="$t('image.category')">
          <el-select v-model="uploadForm.category" style="width: 100%" disabled>
            <el-option :label="$t('image.relic')" value="relic" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('image.tags')">
          <el-input v-model="uploadForm.tags" :placeholder="$t('image.tagsPlaceholder')" />
        </el-form-item>
        <el-form-item :label="$t('image.description')">
          <el-input v-model="uploadForm.description" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="uploadDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitUpload">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 批量上传对话框 -->
    <el-dialog v-model="batchUploadDialogVisible" :title="$t('image.batchUpload')" width="600px">
      <el-form :model="batchUploadForm" :rules="batchUploadRules" ref="batchUploadFormRef" label-width="120px">
        <el-form-item :label="$t('image.relatedRelic')" prop="relicId" required>
          <el-select 
            v-model="batchUploadForm.relicId" 
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
        <el-form-item :label="$t('image.selectFiles')" prop="files" required>
          <el-upload
            ref="batchUploadRef"
            :auto-upload="false"
            :multiple="true"
            :on-change="handleBatchFileChange"
            :file-list="batchFileList"
            accept="image/*"
            drag
          >
            <el-icon class="el-icon--upload"><upload-filled /></el-icon>
            <div class="el-upload__text">
              {{ $t('image.dragFilesHere') }}<em>{{ $t('image.clickToUpload') }}</em>
            </div>
            <template #tip>
              <div class="el-upload__tip">{{ $t('image.batchUploadTip') }}</div>
            </template>
          </el-upload>
        </el-form-item>
        <el-form-item :label="$t('image.category')">
          <el-select v-model="batchUploadForm.category" style="width: 100%" disabled>
            <el-option :label="$t('image.relic')" value="relic" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="batchUploadDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitBatchUpload">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 编辑对话框 -->
    <el-dialog v-model="editDialogVisible" :title="$t('image.editImage')" width="600px">
      <el-form :model="editForm" label-width="100px">
        <el-form-item :label="$t('image.preview')">
          <el-image
            :src="resolveImageUrl(editForm.filePath)"
            fit="contain"
            style="width: 100%; max-height: 300px"
          />
        </el-form-item>
        <el-form-item :label="$t('image.imageName')">
          <el-input v-model="editForm.imageName" />
        </el-form-item>
        <el-form-item :label="$t('image.category')">
          <el-select v-model="editForm.category" style="width: 100%">
            <el-option :label="$t('image.relic')" value="relic" />
            <el-option :label="$t('image.exhibition')" value="exhibition" />
            <el-option :label="$t('image.document')" value="document" />
            <el-option :label="$t('image.other')" value="other" />
            <el-option :label="$t('image.uncategorized')" value="uncategorized" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('image.tags')">
          <el-input v-model="editForm.tags" />
        </el-form-item>
        <el-form-item :label="$t('image.description')">
          <el-input v-model="editForm.description" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item :label="$t('image.isPublic')">
          <el-switch v-model="editForm.isPublic" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="editDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitEdit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('image.imageDetail')" width="800px">
      <div v-if="currentDetail" class="detail-container">
        <div class="detail-image">
          <el-image
            :src="resolveImageUrl(currentDetail.filePath)"
            fit="contain"
            style="width: 100%"
            :preview-src-list="[resolveImageUrl(currentDetail.filePath)]"
            preview-teleported
          />
        </div>
        <el-descriptions :column="2" border style="margin-top: 20px">
          <el-descriptions-item :label="$t('image.imageName')">{{ formatImageName(currentDetail.imageName) }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.originalName')">{{ formatImageName(currentDetail.originalName) }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.category')">
            <el-tag>{{ getCategoryLabel(currentDetail.category) }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item :label="$t('image.fileSize')">{{ formatFileSize(currentDetail.fileSize) }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.dimensions')">
            {{ currentDetail.width }} × {{ currentDetail.height }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('image.fileType')">{{ currentDetail.fileType }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.uploader')">{{ currentDetail.uploaderName }}</el-descriptions-item>
          <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.viewCount')">{{ currentDetail.viewCount }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.downloadCount')">{{ currentDetail.downloadCount }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.tags')" :span="2">{{ currentDetail.tags || '—' }}</el-descriptions-item>
          <el-descriptions-item :label="$t('image.description')" :span="2">{{ currentDetail.description || '—' }}</el-descriptions-item>
        </el-descriptions>
      </div>
    </el-dialog>

    <!-- 统计对话框 -->
    <el-dialog v-model="statisticsDialogVisible" :title="$t('image.statistics')" width="800px">
      <div v-if="statistics" class="statistics-container">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-card>
              <template #header>{{ $t('image.categoryStats') }}</template>
              <div ref="categoryChartRef" style="height: 300px"></div>
            </el-card>
          </el-col>
          <el-col :span="12">
            <el-card>
              <template #header>{{ $t('image.storageStats') }}</template>
              <el-descriptions :column="1" border>
                <el-descriptions-item :label="$t('image.totalCount')">
                  {{ statistics.storageStats.totalCount }}
                </el-descriptions-item>
                <el-descriptions-item :label="$t('image.totalSize')">
                  {{ formatFileSize(statistics.storageStats.totalSize) }}
                </el-descriptions-item>
                <el-descriptions-item :label="$t('image.avgSize')">
                  {{ formatFileSize(statistics.storageStats.avgSize) }}
                </el-descriptions-item>
                <el-descriptions-item :label="$t('image.maxSize')">
                  {{ formatFileSize(statistics.storageStats.maxSize) }}
                </el-descriptions-item>
              </el-descriptions>
            </el-card>
          </el-col>
        </el-row>
        <el-row :gutter="20" style="margin-top: 20px">
          <el-col :span="24">
            <el-card>
              <template #header>{{ $t('image.uploaderStats') }}</template>
              <div ref="uploaderChartRef" style="height: 300px"></div>
            </el-card>
          </el-col>
        </el-row>
      </div>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref, nextTick } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Picture, View, Edit, Download, Delete, UploadFilled } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import request from '../api/request'
import {
  getImagesPageApi,
  uploadImageApi,
  batchUploadImagesApi,
  updateImageApi,
  deleteImageApi,
  batchDeleteImagesApi,
  downloadImageApi,
  getImageByIdApi,
  getImageStatisticsApi
} from '../api/images'
import { getRelicsPageApi } from '../api/relics'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const selectedIds = ref([])
const uploadDialogVisible = ref(false)
const batchUploadDialogVisible = ref(false)
const editDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const statisticsDialogVisible = ref(false)
const currentDetail = ref(null)
const statistics = ref(null)
const uploadRef = ref()
const batchUploadRef = ref()
const uploadFormRef = ref()
const batchUploadFormRef = ref()
const fileList = ref([])
const batchFileList = ref([])
const categoryChartRef = ref()
const uploaderChartRef = ref()
const relicsList = ref([])
let categoryChart = null
let uploaderChart = null

const query = reactive({
  pageNum: 1,
  pageSize: 24,
  imageName: '',
  category: '',
  tags: ''
})

const uploadForm = reactive({
  relicId: null,
  imageName: '',
  category: 'relic',
  tags: '',
  description: ''
})

const uploadRules = {
  relicId: [
    { required: true, message: t('image.relicRequired'), trigger: 'change' }
  ],
  file: [
    { required: true, message: t('image.fileRequired'), trigger: 'change' }
  ]
}

const editForm = reactive({
  id: null,
  imageName: '',
  category: '',
  tags: '',
  description: '',
  isPublic: 1,
  filePath: ''
})

const batchUploadForm = reactive({
  relicId: null,
  category: 'relic'
})

const batchUploadRules = {
  relicId: [
    { required: true, message: t('image.relicRequired'), trigger: 'change' }
  ],
  files: [
    { required: true, message: t('image.filesRequired'), trigger: 'change' }
  ]
}
const backendBaseURL = request.defaults.baseURL  // http://localhost:8080/api

const resolveImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (/^https?:\/\//i.test(imagePath)) return imagePath
  let normalized = String(imagePath).trim().replace(/\\/g, '/')
  if (normalized.startsWith('./')) normalized = normalized.slice(1)
  if (!normalized.startsWith('/')) normalized = `/${normalized}`
  // 使用完整的 baseURL，包含 /api 前缀
  return `${backendBaseURL}${normalized}`
}

const formatFileSize = (bytes) => {
  if (!bytes || bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return (bytes / Math.pow(k, i)).toFixed(2) + ' ' + sizes[i]
}

const formatDateTime = (dateTimeStr) => {
  if (!dateTimeStr) return ''
  return dateTimeStr.replace('T', ' ')
}

const formatImageName = (imageName) => {
  if (!imageName) return ''
  return imageName.replace(/\.(jpg|jpeg|png|gif|bmp|webp|svg)$/i, '')
}

const getCategoryLabel = (category) => {
  const labels = {
    relic: t('image.relic'),
    exhibition: t('image.exhibition'),
    document: t('image.document'),
    other: t('image.other'),
    uncategorized: t('image.uncategorized')
  }
  return labels[category] || category
}

const loadData = async () => {
  try {
    const res = await getImagesPageApi(query)
    tableData.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载图片列表失败:', error)
    ElMessage.error(t('message.loadFailed'))
  }
}

const toggleSelection = (image) => {
  const index = selectedIds.value.indexOf(image.id)
  if (index > -1) {
    selectedIds.value.splice(index, 1)
  } else {
    selectedIds.value.push(image.id)
  }
}

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

const openUploadDialog = () => {
  Object.assign(uploadForm, {
    relicId: null,
    imageName: '',
    category: 'relic',
    tags: '',
    description: ''
  })
  fileList.value = []
  uploadDialogVisible.value = true
  nextTick(() => {
    uploadFormRef.value?.clearValidate()
  })
}

const openBatchUploadDialog = () => {
  Object.assign(batchUploadForm, {
    relicId: null,
    category: 'relic'
  })
  batchFileList.value = []
  batchUploadDialogVisible.value = true
  nextTick(() => {
    batchUploadFormRef.value?.clearValidate()
  })
}

const handleFileChange = (file, files) => {
  fileList.value = files
}

const handleBatchFileChange = (file, files) => {
  batchFileList.value = files
}

const submitUpload = async () => {
  // 验证表单
  const valid = await uploadFormRef.value?.validate().catch(() => false)
  if (!valid) {
    return
  }

  if (fileList.value.length === 0) {
    ElMessage.warning(t('image.selectFile'))
    return
  }

  if (!uploadForm.relicId) {
    ElMessage.error(t('image.relicRequired'))
    return
  }

  try {
    const formData = new FormData()
    formData.append('file', fileList.value[0].raw)
    formData.append('imageName', uploadForm.imageName)
    formData.append('category', uploadForm.category)
    formData.append('tags', uploadForm.tags)
    formData.append('description', uploadForm.description)
    formData.append('relicId', uploadForm.relicId)

    await uploadImageApi(formData)
    ElMessage.success(t('message.saveSuccess'))
    uploadDialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('上传失败:', error)
    const errorMsg = error.response?.data?.message || t('message.saveFailed')
    ElMessage.error(errorMsg)
  }
}

const submitBatchUpload = async () => {
  // 验证表单
  const valid = await batchUploadFormRef.value?.validate().catch(() => false)
  if (!valid) {
    return
  }

  if (batchFileList.value.length === 0) {
    ElMessage.warning(t('image.selectFiles'))
    return
  }

  if (!batchUploadForm.relicId) {
    ElMessage.error(t('image.relicRequired'))
    return
  }

  try {
    const formData = new FormData()
    batchFileList.value.forEach(file => {
      formData.append('files', file.raw)
    })
    formData.append('category', batchUploadForm.category)
    formData.append('relicId', batchUploadForm.relicId)

    await batchUploadImagesApi(formData)
    ElMessage.success(t('message.saveSuccess'))
    batchUploadDialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('批量上传失败:', error)
    const errorMsg = error.response?.data?.message || t('message.saveFailed')
    ElMessage.error(errorMsg)
  }
}

const openEdit = (row) => {
  Object.assign(editForm, {
    id: row.id,
    imageName: row.imageName,
    category: row.category,
    tags: row.tags,
    description: row.description,
    isPublic: row.isPublic,
    filePath: row.filePath
  })
  editDialogVisible.value = true
}

const submitEdit = async () => {
  try {
    await updateImageApi(editForm.id, {
      imageName: editForm.imageName,
      category: editForm.category,
      tags: editForm.tags,
      description: editForm.description,
      isPublic: editForm.isPublic
    })
    ElMessage.success(t('message.updateSuccess'))
    editDialogVisible.value = false
    loadData()
  } catch (error) {
    console.error('更新失败:', error)
    ElMessage.error(t('message.updateFailed'))
  }
}

const viewDetail = async (row) => {
  try {
    const res = await getImageByIdApi(row.id)
    currentDetail.value = res.data
    detailDialogVisible.value = true
  } catch (error) {
    console.error('加载详情失败:', error)
    ElMessage.error(t('message.loadFailed'))
  }
}

const remove = async (id) => {
  try {
    await ElMessageBox.confirm(t('image.deleteConfirm'), t('message.tip'), { type: 'warning' })
    await deleteImageApi(id)
    ElMessage.success(t('message.deleteSuccess'))
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error(t('message.deleteFailed'))
    }
  }
}

const handleBatchDelete = async () => {
  try {
    await ElMessageBox.confirm(
      t('image.batchDeleteConfirm', { count: selectedIds.value.length }),
      t('message.tip'),
      { type: 'warning' }
    )
    await batchDeleteImagesApi(selectedIds.value)
    ElMessage.success(t('message.deleteSuccess'))
    selectedIds.value = []
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量删除失败:', error)
      ElMessage.error(t('message.deleteFailed'))
    }
  }
}

const handleDownload = async (id) => {
  try {
    const res = await downloadImageApi(id)
    const blob = new Blob([res])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `image_${id}_${new Date().getTime()}.jpg`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('image.downloadSuccess'))
  } catch (error) {
    console.error('下载失败:', error)
    ElMessage.error(t('image.downloadFailed'))
  }
}

const showStatistics = async () => {
  try {
    const res = await getImageStatisticsApi()
    statistics.value = res.data
    statisticsDialogVisible.value = true
    
    await nextTick()
    renderCharts()
  } catch (error) {
    console.error('加载统计信息失败:', error)
    ElMessage.error(t('message.loadFailed'))
  }
}

const renderCharts = () => {
  // 分类统计图表
  if (categoryChartRef.value && statistics.value.categoryStats) {
    if (!categoryChart) {
      categoryChart = echarts.init(categoryChartRef.value)
    }
    
    categoryChart.setOption({
      tooltip: { trigger: 'item' },
      legend: { orient: 'vertical', left: 'left' },
      series: [{
        type: 'pie',
        radius: '50%',
        data: statistics.value.categoryStats.map(item => ({
          name: getCategoryLabel(item.category),
          value: item.count
        })),
        emphasis: {
          itemStyle: {
            shadowBlur: 10,
            shadowOffsetX: 0,
            shadowColor: 'rgba(0, 0, 0, 0.5)'
          }
        }
      }]
    })
  }
  
  // 上传者统计图表
  if (uploaderChartRef.value && statistics.value.uploaderStats) {
    if (!uploaderChart) {
      uploaderChart = echarts.init(uploaderChartRef.value)
    }
    
    uploaderChart.setOption({
      tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
      xAxis: {
        type: 'category',
        data: statistics.value.uploaderStats.map(item => item.uploader_name)
      },
      yAxis: { type: 'value' },
      series: [{
        type: 'bar',
        data: statistics.value.uploaderStats.map(item => item.count),
        itemStyle: { color: '#409EFF' }
      }]
    })
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.view-card {
  border-radius: 14px;
}

.toolbar {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

/* 网格视图样式 */
.image-grid {
  display: grid;
  grid-template-columns: repeat(6, 1fr);
  gap: 20px;
  margin-bottom: 20px;
}

.image-card {
  border: 2px solid #e4e7ed;
  border-radius: 8px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  background: #fff;
}

.image-card:hover {
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.2);
  transform: translateY(-2px);
}

.image-card.selected {
  border-color: #409eff;
  box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.image-wrapper {
  position: relative;
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f5f7fa;
}

.grid-image {
  width: 100%;
  height: 100%;
}

.image-error {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  font-size: 48px;
  color: #c0c4cc;
}

.image-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.6);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.image-card:hover .image-overlay {
  opacity: 1;
}

.image-overlay .el-button {
  display: flex;
  align-items: center;
  gap: 4px;
}

.image-overlay .button-text {
  margin-left: 4px;
  font-size: 12px;
}

.image-checkbox {
  position: absolute;
  top: 10px;
  left: 10px;
  z-index: 10;
}

.image-info {
  padding: 12px;
}

.image-name {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.image-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
  font-size: 12px;
  color: #909399;
}

.image-size {
  font-size: 12px;
  color: #909399;
}

.image-stats {
  display: flex;
  gap: 15px;
  font-size: 12px;
  color: #606266;
}

.image-stats span {
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 详情对话框样式 */
.detail-container {
  padding: 10px;
}

.detail-image {
  text-align: center;
  margin-bottom: 20px;
}

/* 统计对话框样式 */
.statistics-container {
  padding: 10px;
}

/* 分页样式 */
.pager {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

/* 上传提示样式 */
.el-upload__text {
  font-size: 14px;
  color: #606266;
}

.el-upload__text em {
  color: #409eff;
  font-style: normal;
}

.el-upload__tip {
  font-size: 12px;
  color: #909399;
  margin-top: 7px;
}
</style>
