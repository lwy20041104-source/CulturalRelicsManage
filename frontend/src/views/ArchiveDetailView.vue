<template>
  <div class="archive-detail-container">
    <el-card class="header-card" v-loading="loading">
      <template #header>
        <div class="header-toolbar">
          <el-button @click="goBack">
            <el-icon><ArrowLeft /></el-icon>
            {{$t('common.back')}}
          </el-button>
          <div class="header-actions">
            <el-button type="primary" @click="openUploadDialog" v-if="archive.status === 'draft'">
              <el-icon><Upload /></el-icon>
              {{$t('common.putFile')}}
            </el-button>
            <el-button type="success" @click="handlePublish" v-if="archive.status === 'draft'">
              <el-icon><Check /></el-icon>
              {{$t('archive.publish')}}
            </el-button>
            <el-button type="warning" @click="handleArchive" v-if="archive.status === 'published'">
              <el-icon><Box /></el-icon>
              {{$t('archive.archive')}}
            </el-button>
            <el-button @click="handleExportPdf">
              <el-icon><Download /></el-icon>
              {{$t('report.exportPdf')}}
            </el-button>
            <el-button @click="handleExportWord">
              <el-icon><Download /></el-icon>
              {{$t('report.exportWord')}}
            </el-button>
            <el-button @click="handlePrint">
              <el-icon><Printer /></el-icon>
              {{$t('relic.print')}}
            </el-button>
          </div>
        </div>
      </template>

      <!-- 档案基本信息 -->
      <div class="info-section">
        <h3>{{$t('archive.archiveBasicInformation')}}</h3>
        <el-descriptions :column="2" border>
          <el-descriptions-item :label="$t('archive.archiveCode')">
            {{ archive.archiveCode }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('archive.archiveTitle')">
            {{ archive.archiveTitle }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('archive.archiveType')">
            <el-tag :type="getArchiveTypeTag(archive.archiveType)">
              {{ getArchiveTypeName(archive.archiveType) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item :label="$t('common.status')">
            <el-tag :type="getStatusTag(archive.status)">
              {{ getStatusName(archive.status) }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item :label="$t('archive.version')">
            v{{ archive.version }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('archive.fileNumber')">
            {{ archive.documentCount || 0 }} 个
          </el-descriptions-item>
          <el-descriptions-item :label="$t('archive.creator')">
            {{ archive.createdByName }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('common.createTime')">
            {{ formatDateTime(archive.createdTime) }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('archive.archiveDescription')" :span="2">
            {{ archive.description || '—' }}
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- 文物信息 -->
      <div class="info-section" v-if="archive.relic">
        <h3>{{$t('archive.relatedCulturalRelicInformation')}}</h3>
        <el-descriptions :column="2" border>
          <el-descriptions-item :label="$t('relic.relicCode')">
            {{ archive.relic.relicCode }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('relic.relicName')">
            {{ archive.relic.relicName }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('relic.era')">
            {{ archive.relic.era }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('relic.material')">
            {{ archive.relic.material }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('category.categoryName')">
            {{ archive.relic.categoryName }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('relic.status')">
            {{ archive.relic.status }}
          </el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- 文档管理 -->
      <div class="info-section">
        <h3>{{$t('archive.archiveFile')}}</h3>
        <el-table :data="documents" border>
          <el-table-column prop="documentName" :label="$t('archive.archiveName')" min-width="200" show-overflow-tooltip />
          <el-table-column :label="$t('archive.archiveType')" width="120">
            <template #default="scope">
              <el-tag size="small">{{ getDocumentTypeName(scope.row.documentType) }}</el-tag>
            </template>
          </el-table-column>
          <el-table-column :label="$t('archive.fileFormat')" width="150">
            <template #default="scope">
              {{ scope.row.fileFormat?.toUpperCase() }}
            </template>
          </el-table-column>
          <el-table-column :label="$t('archive.fileSize')" width="120">
            <template #default="scope">
              {{ formatFileSize(scope.row.fileSize) }}
            </template>
          </el-table-column>
          <el-table-column prop="uploaderName" :label="$t('archive.uploader')" width="120" />
          <el-table-column :label="$t('archive.uploadTime')" width="200">
            <template #default="scope">
              {{ formatDateTime(scope.row.uploadTime) }}
            </template>
          </el-table-column>
          <el-table-column :label="$t('common.operation')" width="150" fixed="right">
            <template #default="scope">
              <el-button link type="primary" @click="previewDocument(scope.row)">
                <el-icon><View /></el-icon>
                {{$t('image.preview')}}
              </el-button>
              <el-button link type="danger" @click="deleteDocument(scope.row)" v-if="archive.status === 'draft'">
                <el-icon><Delete /></el-icon>
                {{$t('common.delete')}}
              </el-button>
            </template>
          </el-table-column>
        </el-table>
        <el-empty v-if="!documents || documents.length === 0" description="暂无文档" />
      </div>

      <!-- 历史记录 -->
      <div class="info-section">
        <h3>{{$t('archive.operationHistory')}}</h3>
        <el-timeline>
          <el-timeline-item
            v-for="item in histories"
            :key="item.id"
            :timestamp="formatDateTime(item.operationTime)"
            placement="top"
          >
            <el-card>
              <div class="history-item">
                <div class="history-header">
                  <el-tag :type="getOperationTypeTag(item.operationType)" size="small">
                    {{ getOperationTypeName(item.operationType) }}
                  </el-tag>
                  <span class="history-operator">{{ item.operatorName }}</span>
                </div>
                <div class="history-content">{{ item.operationContent }}</div>
                <div class="history-log" v-if="item.changeLog">
                  <el-text type="info" size="small">{{ item.changeLog }}</el-text>
                </div>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
        <el-empty v-if="!histories || histories.length === 0" description="暂无历史记录" />
      </div>
    </el-card>

    <!-- 上传文档对话框 -->
    <el-dialog v-model="uploadDialogVisible" :title="$t('common.putFile')" width="500px">
      <el-form :model="uploadForm" :rules="uploadRules" ref="uploadFormRef" label-width="100px">
        <el-form-item :label="$t('archive.fileType')" prop="documentType">
          <el-select v-model="uploadForm.documentType" :placeholder="$t('archive.selectFileType')" style="width: 100%">
            <el-option :label="$t('archive.appraisalReport')" value="appraisal" />
            <el-option :label="$t('archive.repairReport')" value="repair" />
            <el-option :label="$t('archive.researchPaper')" value="research" />
            <el-option :label="$t('archive.certificate')" value="certificate" />
            <el-option :label="$t('archive.picture')" value="photo" />
            <el-option :label="$t('archive.other')" value="other" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('archive.fileExplanation')">
          <el-input v-model="uploadForm.description" type="textarea" :rows="3" :placeholder="$t('archive.putFileExplanation')" />
        </el-form-item>
        <el-form-item :label="$t('relic.selectFile')" prop="file">
          <el-upload
            ref="uploadRef"
            :auto-upload="false"
            :limit="1"
            :on-change="handleFileChange"
            :file-list="fileList"
          >
            <el-button type="primary">{{$t('relic.selectFile')}}</el-button>
            <template #tip>
              <div class="el-upload__tip">
                {{$t('archive.supportsPDFWordExcelImagesAndOtherFormatsWithASingleFileNotExceeding50MB')}}
              </div>
            </template>
          </el-upload>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="uploadDialogVisible = false">{{$t('common.cancel')}}</el-button>
        <el-button type="primary" @click="submitUpload" :loading="uploading">
          {{$t('archive.upload')}}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import {
  ArrowLeft, Upload, Check, Box, Download, Printer, View, Delete
} from '@element-plus/icons-vue'
import {
  getArchiveByIdApi,
  getDocumentsApi,
  getHistoryApi,
  uploadDocumentApi,
  deleteDocumentApi,
  publishArchiveApi,
  archiveArchiveApi,
  exportPdfApi,
  exportWordApi,
  printArchiveApi
} from '../api/archives'

const { t } = useI18n()

const router = useRouter()
const route = useRoute()
const loading = ref(false)
const uploading = ref(false)
const uploadDialogVisible = ref(false)
const uploadFormRef = ref(null)
const uploadRef = ref(null)
const fileList = ref([])

const archive = ref({})
const documents = ref([])
const histories = ref([])

const uploadForm = reactive({
  documentType: '',
  description: '',
  file: null
})

const uploadRules = {
  documentType: [{ required: true, message: '请选择文档类型', trigger: 'change' }],
  file: [{ required: true, message: '请选择文件', trigger: 'change' }]
}

const loadArchiveDetail = async () => {
  loading.value = true
  try {
    const id = route.params.id
    const res = await getArchiveByIdApi(id)
    if (res.code === 200) {
      archive.value = res.data || {}
      documents.value = res.data.documents || []
      histories.value = res.data.histories || []
    }
  } catch (error) {
    console.error('加载档案详情失败:', error)
    ElMessage.error(t('common.loadArchiveDetailFailed'))
  } finally {
    loading.value = false
  }
}

const goBack = () => {
  router.back()
}

const openUploadDialog = () => {
  uploadForm.documentType = ''
  uploadForm.description = ''
  uploadForm.file = null
  fileList.value = []
  uploadDialogVisible.value = true
}

const handleFileChange = (file) => {
  uploadForm.file = file.raw
}

const submitUpload = async () => {
  if (!uploadFormRef.value) return
  
  await uploadFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    if (!uploadForm.file) {
      ElMessage.warning(t('common.pleaseSelectFile'))
      return
    }
    
    uploading.value = true
    try {
      const formData = new FormData()
      formData.append('file', uploadForm.file)
      formData.append('documentType', uploadForm.documentType)
      formData.append('description', uploadForm.description || '')
      
      const res = await uploadDocumentApi(archive.value.id, formData)
      
      if (res.code === 200) {
        ElMessage.success(t('common.uploadSuccess'))
        uploadDialogVisible.value = false
        loadArchiveDetail()
      } else {
        ElMessage.error(res.message || t('common.uploadFailed'))
      }
    } catch (error) {
      console.error('上传失败:', error)
      ElMessage.error(t('common.uploadFailed'))
    } finally {
      uploading.value = false
    }
  })
}

const previewDocument = (doc) => {
  // 构建完整的文件URL
  // 后端的 context-path 是 /api，所以静态资源路径是 /api/uploads/**
  const hostname = window.location.hostname
  const protocol = window.location.protocol
  
  let baseURL
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    baseURL = 'http://localhost:8080/api'
  } else {
    baseURL = `${protocol}//${hostname}:8080/api`
  }
  
  const filePath = doc.filePath.startsWith('/') ? doc.filePath : `/${doc.filePath}`
  const url = `${baseURL}${filePath}`
  
  // 根据文件格式决定预览方式
  const fileFormat = doc.fileFormat?.toLowerCase()
  
  if (fileFormat === 'pdf') {
    // PDF文件直接在新窗口打开
    window.open(url, '_blank')
  } else if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].includes(fileFormat)) {
    // 图片文件直接在新窗口打开
    window.open(url, '_blank')
  } else if (['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].includes(fileFormat)) {
    // Office文件提示下载
    ElMessage.info('Office文件将自动下载，请使用本地软件打开')
    const link = document.createElement('a')
    link.href = url
    link.download = doc.documentName
    link.click()
  } else {
    // 其他文件类型直接下载
    const link = document.createElement('a')
    link.href = url
    link.download = doc.documentName
    link.click()
  }
}

const deleteDocument = async (doc) => {
  try {
    await ElMessageBox.confirm('确定要删除此文档吗？', '警告', {
      type: 'warning'
    })
    
    const res = await deleteDocumentApi(doc.id)
    if (res.code === 200) {
      ElMessage.success(t('common.deleteSuccess'))
      loadArchiveDetail()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error(t('common.deleteFailed'))
    }
  }
}

const handlePublish = async () => {
  try {
    await ElMessageBox.confirm('确定要发布此档案吗？发布后将无法编辑。', '提示', {
      type: 'warning'
    })
    
    const res = await publishArchiveApi(archive.value.id)
    if (res.code === 200) {
      ElMessage.success(t('common.publishSuccess'))
      loadArchiveDetail()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('发布失败:', error)
      ElMessage.error(t('common.publishFailed'))
    }
  }
}

const handleArchive = async () => {
  try {
    await ElMessageBox.confirm('确定要归档此档案吗？', '提示', {
      type: 'warning'
    })
    
    const res = await archiveArchiveApi(archive.value.id)
    if (res.code === 200) {
      ElMessage.success(t('common.archiveSuccess'))
      loadArchiveDetail()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('归档失败:', error)
      ElMessage.error(t('common.archiveFailed'))
    }
  }
}

const handleExportPdf = async () => {
  try {
    const res = await exportPdfApi(archive.value.id)
    const blob = new Blob([res], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `档案_${archive.value.archiveCode}.pdf`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('common.exportSuccess'))
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error(t('common.exportFailed'))
  }
}

const handleExportWord = async () => {
  try {
    const res = await exportWordApi(archive.value.id)
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `档案_${archive.value.archiveCode}.docx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('common.exportSuccess'))
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error(t('common.exportFailed'))
  }
}

const handlePrint = async () => {
  try {
    window.print()
    ElMessage.success(t('common.printSuccess'))
  } catch (error) {
    console.error('打印失败:', error)
    ElMessage.error(t('common.printFailed'))
  }
}

const getArchiveTypeName = (type) => {
  const map = {
    complete: '完整档案',
    basic: '基础档案',
    image: '图片档案',
    document: '文档档案'
  }
  return map[type] || type
}

const getArchiveTypeTag = (type) => {
  const map = {
    complete: '',
    basic: 'info',
    image: 'warning',
    document: 'success'
  }
  return map[type] || ''
}

const getStatusName = (status) => {
  const map = {
    draft: '草稿',
    published: '已发布',
    archived: '已归档'
  }
  return map[status] || status
}

const getStatusTag = (status) => {
  const map = {
    draft: 'info',
    published: 'success',
    archived: 'warning'
  }
  return map[status] || ''
}

const getDocumentTypeName = (type) => {
  const map = {
    appraisal: '鉴定报告',
    repair: '修复记录',
    research: '研究论文',
    certificate: '证书',
    photo: '照片',
    other: '其他'
  }
  return map[type] || type
}

const getOperationTypeName = (type) => {
  const map = {
    create: '创建',
    update: '更新',
    upload: '上传',
    delete: '删除',
    export: '导出',
    print: '打印',
    publish: '发布',
    archive: '归档'
  }
  return map[type] || type
}

const getOperationTypeTag = (type) => {
  const map = {
    create: 'success',
    update: 'primary',
    upload: 'success',
    delete: 'danger',
    export: 'info',
    print: 'info',
    publish: 'success',
    archive: 'warning'
  }
  return map[type] || ''
}

const formatDateTime = (dateTime) => {
  if (!dateTime) return '—'
  return dateTime.replace('T', ' ')
}

const formatFileSize = (bytes) => {
  if (!bytes) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

onMounted(() => {
  loadArchiveDetail()
})
</script>

<style scoped>
.archive-detail-container {
  padding: 20px;
}

.header-card {
  margin-bottom: 20px;
}

.header-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-actions {
  display: flex;
  gap: 10px;
}

.info-section {
  margin-bottom: 30px;
}

.info-section h3 {
  margin-bottom: 15px;
  font-size: 16px;
  font-weight: bold;
  color: #303133;
}

.history-item {
  padding: 5px 0;
}

.history-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 8px;
}

.history-operator {
  font-weight: bold;
  color: #606266;
}

.history-content {
  margin-bottom: 5px;
  color: #303133;
}

.history-log {
  margin-top: 5px;
}

@media print {
  .header-toolbar,
  .el-button {
    display: none !important;
  }
}
</style>
