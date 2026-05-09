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
        <el-button type="info" @click="showStatistics">{{ $t('image.statistics') }}</el-button>
      </div>
    </template>

    <!-- 图片网格视图 -->
    <div class="image-grid">
      <div 
        v-for="image in tableData" 
        :key="image.id" 
        class="image-card"
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
              <el-button size="small" @click.stop="handleDownload(image.id)">
                <el-icon><Download /></el-icon>
                <span class="button-text">{{ $t('image.download') }}</span>
              </el-button>
            </el-button-group>
          </div>
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
import { Picture, View, Download } from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import request from '../api/request'
import {
  getImagesPageApi,
  downloadImageApi,
  getImageByIdApi,
  getImageStatisticsApi
} from '../api/images'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const detailDialogVisible = ref(false)
const statisticsDialogVisible = ref(false)
const currentDetail = ref(null)
const statistics = ref(null)
const categoryChartRef = ref()
const uploaderChartRef = ref()
let categoryChart = null
let uploaderChart = null

const query = reactive({
  pageNum: 1,
  pageSize: 24,
  imageName: '',
  category: '',
  tags: ''
})
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
  transition: all 0.3s;
  background: #fff;
}

.image-card:hover {
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.2);
  transform: translateY(-2px);
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
