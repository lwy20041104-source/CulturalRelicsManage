<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input 
          v-model="query.archiveCode" 
          :placeholder="$t('archive.archiveCode')" 
          style="width: 200px" 
          clearable
          @keyup.enter="loadData" 
        />
        <el-select 
          v-model="query.archiveType" 
          :placeholder="$t('archive.archiveType')" 
          clearable 
          style="width: 160px"
        >
          <el-option :label="$t('archive.completeArchive')" value="complete" />
          <el-option :label="$t('archive.basicArchive')" value="basic" />
          <el-option :label="$t('archive.pictureArchive')" value="image" />
          <el-option :label="$t('archive.fileArchive')" value="document" />
        </el-select>
        <el-select 
          v-model="query.status" 
          :placeholder="$t('common.status')" 
          clearable 
          style="width: 140px"
        >
          <el-option :label="$t('archive.draft')" value="draft" />
          <el-option :label="$t('archive.published')" value="published" />
          <el-option :label="$t('archive.archived')" value="archived" />
        </el-select>
        <el-button type="primary" @click="loadData">
          <el-icon><Search /></el-icon>
          {{$t('common.search')}}
        </el-button>
        <el-button type="success" @click="openAdd">
          <el-icon><Plus /></el-icon>
          {{$t('archive.addArchive')}}
        </el-button>
      </div>
    </template>

    <el-table :data="tableData" border v-loading="loading" :span-method="objectSpanMethod">
      <el-table-column prop="archiveCode" :label="$t('archive.archiveCode')" width="140">
        <template #default="scope">
          <span v-if="scope.row.relic">{{ scope.row.archiveCode }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('archive.relicInformation')" min-width="200">
        <template #default="scope">
          <div v-if="scope.row.relic">
            <div>{{ scope.row.relic.relicName }}</div>
            <div style="font-size: 12px; color: #999;">{{ scope.row.relic.relicCode }}</div>
          </div>
          <div v-else style="color: #f56c6c; text-align: center;">
            <el-icon style="vertical-align: middle;"><WarningFilled /></el-icon>
            {{ $t('archive.relicDeleted') }}
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="archiveTitle" :label="$t('archive.archiveTitle')" min-width="200" show-overflow-tooltip>
        <template #default="scope">
          <span v-if="scope.row.relic">{{ scope.row.archiveTitle }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('archive.archiveType')" width="150">
        <template #default="scope">
          <el-tag v-if="scope.row.relic" :type="getArchiveTypeTag(scope.row.archiveType)">
            {{ getArchiveTypeName(scope.row.archiveType) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('archive.version')" width="80" align="center">
        <template #default="scope">
          <span v-if="scope.row.relic">v{{ scope.row.version }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.status')" width="100">
        <template #default="scope">
          <el-tag v-if="scope.row.relic" :type="getStatusTag(scope.row.status)">
            {{ getStatusName(scope.row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('archive.fileNumber')" width="150" align="center">
        <template #default="scope">
          <template v-if="scope.row.relic">
            <el-badge :value="scope.row.documentCount" :max="99" v-if="scope.row.documentCount > 0">
              <el-icon><Document /></el-icon>
            </el-badge>
            <span v-else style="color: #ccc;">0</span>
          </template>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.createTime')" width="160">
        <template #default="scope">
          <span v-if="scope.row.relic">{{ formatDateTime(scope.row.createdTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.action')" width="300" fixed="right">
        <template #default="scope">
          <template v-if="scope.row.relic">
            <el-button link type="primary" @click="viewDetail(scope.row)">
              <el-icon><View /></el-icon>
              {{$t('common.detail')}}
            </el-button>
            <el-button link type="primary" @click="openEdit(scope.row)" v-if="scope.row.status === 'draft'">
              <el-icon><Edit /></el-icon>
              {{$t('common.edit')}}
            </el-button>
            <el-dropdown @command="(cmd) => handleCommand(cmd, scope.row)" style="margin-left: 8px;">
              <el-button link type="primary">
                {{$t('archive.more')}}<el-icon class="el-icon--right"><arrow-down /></el-icon>
              </el-button>
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="publish" v-if="scope.row.status === 'draft'">
                    <el-icon><Check /></el-icon>
                    {{ $t('archive.publish') }}
                  </el-dropdown-item>
                  <el-dropdown-item command="archive" v-if="scope.row.status === 'published'">
                    <el-icon><Box /></el-icon>
                    {{ $t('archive.archive') }}
                  </el-dropdown-item>
                  <el-dropdown-item command="exportPdf">
                    <el-icon><Download /></el-icon>
                    {{ $t('report.exportPdf') }}
                  </el-dropdown-item>
                  <el-dropdown-item command="exportWord">
                    <el-icon><Download /></el-icon>
                  {{ $t('report.exportWord') }}
                </el-dropdown-item>
                <el-dropdown-item command="print">
                  <el-icon><Printer /></el-icon>
                  {{ $t('report.print') }}
                </el-dropdown-item>
                <el-dropdown-item command="delete" divided v-if="scope.row.status === 'draft'">
                  <el-icon><Delete /></el-icon>
                  {{ $t('common.delete') }}
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
          </template>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-model:current-page="query.pageNum"
      v-model:page-size="query.pageSize"
      :total="total"
      :page-sizes="[10, 20, 50, 100]"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="loadData"
      @current-change="loadData"
      style="margin-top: 20px; justify-content: flex-end;"
    />

    <!-- 打印预览对话框 -->
    <el-dialog
      v-model="printPreviewVisible"
      :title="$t('archive.printPreview')"
      width="900px"
      @close="closePrintPreview"
    >
      <div v-if="printPreviewData" class="print-preview-content" id="printArea">
        <!-- 打印标题 v2.0 -->
        <div class="print-header">
          <h1>{{ $t('archive.archiveDetail') }}</h1>
          <div class="print-time">{{ $t('archive.printTime') }}: {{ currentPrintTime }}</div>
        </div>

        <!-- 档案基本信息 -->
        <div class="info-section">
          <h3>{{ $t('archive.archiveBasicInformation') }}</h3>
          <table class="info-table">
            <tr>
              <td class="label">{{ $t('archive.archiveCode') }}:</td>
              <td class="value">{{ printPreviewData.archiveCode }}</td>
              <td class="label">{{ $t('archive.archiveType') }}:</td>
              <td class="value">{{ getArchiveTypeName(printPreviewData.archiveType) }}</td>
            </tr>
            <tr>
              <td class="label">{{ $t('archive.archiveTitle') }}:</td>
              <td class="value" colspan="3">{{ printPreviewData.archiveTitle }}</td>
            </tr>
            <tr>
              <td class="label">{{ $t('common.status') }}:</td>
              <td class="value">{{ getStatusName(printPreviewData.status) }}</td>
              <td class="label">{{ $t('archive.version') }}:</td>
              <td class="value">v{{ printPreviewData.version }}</td>
            </tr>
          </table>
        </div>

        <!-- 关联文物信息 -->
        <div class="info-section" v-if="printPreviewData.relic">
          <h3>{{ $t('archive.relatedCulturalRelicInformation') }}</h3>
          <table class="info-table">
            <tr>
              <td class="label">{{ $t('relic.relicName') }}:</td>
              <td class="value">{{ printPreviewData.relic.relicName }}</td>
              <td class="label">{{ $t('relic.relicCode') }}:</td>
              <td class="value">{{ printPreviewData.relic.relicCode }}</td>
            </tr>
            <tr v-if="printPreviewData.relic.categoryName || printPreviewData.relic.eraName">
              <td class="label">{{ $t('relic.category') }}:</td>
              <td class="value">{{ printPreviewData.relic.categoryName || '—' }}</td>
              <td class="label">{{ $t('relic.era') }}:</td>
              <td class="value">{{ printPreviewData.relic.eraName || '—' }}</td>
            </tr>
          </table>
        </div>

        <!-- 档案描述 -->
        <div class="info-section" v-if="printPreviewData.description">
          <h3>{{ $t('archive.archiveDescription') }}</h3>
          <div class="description-text">{{ printPreviewData.description }}</div>
        </div>

        <!-- 档案管理信息 -->
        <div class="info-section">
          <h3>{{ $t('archive.archiveInformation') }}</h3>
          <table class="info-table">
            <tr>
              <td class="label">{{ $t('common.creator') }}:</td>
              <td class="value">{{ printPreviewData.createdBy || '—' }}</td>
              <td class="label">{{ $t('common.createTime') }}:</td>
              <td class="value">{{ formatDateTime(printPreviewData.createdTime) }}</td>
            </tr>
            <tr v-if="printPreviewData.updatedBy || printPreviewData.updatedTime">
              <td class="label">{{ $t('common.updater') }}:</td>
              <td class="value">{{ printPreviewData.updatedBy || '—' }}</td>
              <td class="label">{{ $t('common.updateTime') }}:</td>
              <td class="value">{{ formatDateTime(printPreviewData.updatedTime) || '—' }}</td>
            </tr>
          </table>
        </div>

        <!-- 附件信息 -->
        <div class="info-section" v-if="printPreviewData.documentCount > 0">
          <h3>{{ $t('archive.attachedFiles') }}</h3>
          <div class="description-text">{{ $t('archive.fileCount') }}: {{ printPreviewData.documentCount }}</div>
        </div>
      </div>

      <template #footer>
        <el-button @click="closePrintPreview">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="doPrint">
          <el-icon><Printer /></el-icon>
          {{ $t('report.print') }}
        </el-button>
      </template>
    </el-dialog>

    <!-- 新建/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="700px"
      @close="resetForm"
    >
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item :label="$t('relic.relic')" prop="relicId">
          <el-select 
            v-model="form.relicId" 
            :placeholder="$t('relic.selectRelic')" 
            filterable
            style="width: 100%"
          >
            <el-option
              v-for="relic in relicOptions"
              :key="relic.id"
              :label="`${relic.relicName} (${relic.relicCode})`"
              :value="relic.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('archive.archiveCode')" prop="archiveCode">
          <el-input v-model="form.archiveCode" :placeholder="$t('archive.automaticallyGenerated')" disabled />
        </el-form-item>
        <el-form-item :label="$t('archive.archiveTitle')" prop="archiveTitle">
          <el-input v-model="form.archiveTitle" :placeholder="$t('archive.putArchiveTitle')" />
        </el-form-item>
        <el-form-item :label="$t('archive.archiveType')" prop="archiveType">
          <el-radio-group v-model="form.archiveType">
            <el-radio label="complete">{{$t('archive.completeArchive')}}</el-radio>
            <el-radio label="basic">{{$t('archive.basicArchive')}}</el-radio>
            <el-radio label="image">{{$t('archive.pictureArchive')}}</el-radio>
            <el-radio label="document">{{$t('archive.fileArchive')}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="$t('archive.archiveDescription')">
          <el-input 
            v-model="form.description" 
            type="textarea" 
            :rows="4"
            :placeholder="$t('archive.putArchiveDescription')"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{$t('common.cancel')}}</el-button>
        <el-button type="primary" @click="submitForm" :loading="submitting">
          {{$t('common.confirm')}}
        </el-button>
      </template>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import {
  Search, Plus, View, Edit, ArrowDown, Check, Box, Download, Printer, Delete, Document, WarningFilled
} from '@element-plus/icons-vue'
import {
  getArchivesApi,
  createArchiveApi,
  updateArchiveApi,
  deleteArchiveApi,
  publishArchiveApi,
  archiveArchiveApi,
  exportPdfApi,
  exportWordApi,
  printArchiveApi,
  generateCodeApi,
  getAvailableRelicsApi
} from '../api/archives'

const { t } = useI18n()
const router = useRouter()
const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const dialogTitle = ref('')
const submitting = ref(false)
const formRef = ref(null)
const relicOptions = ref([])

const query = reactive({
  pageNum: 1,
  pageSize: 10,
  archiveCode: '',
  archiveType: '',
  status: ''
})

const form = reactive({
  id: null,
  relicId: null,
  archiveCode: '',
  archiveTitle: '',
  archiveType: 'complete',
  description: ''
})

const rules = {
  relicId: [{ required: true, message: '请选择文物', trigger: 'change' }],
  archiveTitle: [{ required: true, message: '请输入档案标题', trigger: 'blur' }],
  archiveType: [{ required: true, message: '请选择档案类型', trigger: 'change' }]
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getArchivesApi(query)
    if (res.code === 200) {
      tableData.value = res.data.records || []
      total.value = res.data.total || 0
    }
  } catch (error) {
    console.error('加载档案列表失败:', error)
    ElMessage.error(t('common.loadArchiveListFailed'))
  } finally {
    loading.value = false
  }
}

const loadRelics = async () => {
  try {
    // 使用新的API获取可用于创建档案的文物列表（排除已有草稿档案的文物）
    const res = await getAvailableRelicsApi()
    if (res.code === 200) {
      relicOptions.value = res.data || []
    }
  } catch (error) {
    console.error('加载文物列表失败:', error)
  }
}

const openAdd = async () => {
  dialogTitle.value = '新建档案'
  resetForm()
  
  // 重新加载可用文物列表（确保获取最新的可用文物）
  await loadRelics()
  
  // 生成档案编号
  try {
    const res = await generateCodeApi()
    if (res.code === 200) {
      form.archiveCode = res.data
    }
  } catch (error) {
    console.error('生成档案编号失败:', error)
  }
  
  dialogVisible.value = true
}

const openEdit = (row) => {
  dialogTitle.value = '编辑档案'
  Object.assign(form, {
    id: row.id,
    relicId: row.relicId,
    archiveCode: row.archiveCode,
    archiveTitle: row.archiveTitle,
    archiveType: row.archiveType,
    description: row.description
  })
  dialogVisible.value = true
}

const submitForm = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitting.value = true
    try {
      const api = form.id ? updateArchiveApi : createArchiveApi
      const res = await api(form)
      
      if (res.code === 200) {
        ElMessage.success(form.id ? '更新成功' : '创建成功')
        dialogVisible.value = false
        loadData()
      } else {
        ElMessage.error(res.message || '操作失败')
      }
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error(t('common.operationFailed'))
    } finally {
      submitting.value = false
    }
  })
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    relicId: null,
    archiveCode: '',
    archiveTitle: '',
    archiveType: 'complete',
    description: ''
  })
  if (formRef.value) {
    formRef.value.clearValidate()
  }
}

const viewDetail = (row) => {
  router.push(`/archives/${row.id}`)
}

const handleCommand = async (command, row) => {
  switch (command) {
    case 'publish':
      await handlePublish(row)
      break
    case 'archive':
      await handleArchive(row)
      break
    case 'exportPdf':
      await handleExportPdf(row)
      break
    case 'exportWord':
      await handleExportWord(row)
      break
    case 'print':
      await handlePrint(row)
      break
    case 'delete':
      await handleDelete(row)
      break
  }
}

const handlePublish = async (row) => {
  try {
    await ElMessageBox.confirm('确定要发布此档案吗？发布后将无法编辑。', '提示', {
      type: 'warning'
    })
    
    const res = await publishArchiveApi(row.id)
    if (res.code === 200) {
      ElMessage.success(t('common.publishSuccess'))
      loadData()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('发布失败:', error)
      ElMessage.error(t('common.publishFailed'))
    }
  }
}

const handleArchive = async (row) => {
  try {
    await ElMessageBox.confirm('确定要归档此档案吗？', '提示', {
      type: 'warning'
    })
    
    const res = await archiveArchiveApi(row.id)
    if (res.code === 200) {
      ElMessage.success(t('common.archiveSuccess'))
      loadData()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('归档失败:', error)
      ElMessage.error(t('common.archiveFailed'))
    }
  }
}

const handleExportPdf = async (row) => {
  try {
    const res = await exportPdfApi(row.id)
    const blob = new Blob([res], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `档案_${row.archiveCode}.pdf`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('common.exportSuccess'))
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error(t('common.exportFailed'))
  }
}

const handleExportWord = async (row) => {
  try {
    const res = await exportWordApi(row.id)
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `档案_${row.archiveCode}.docx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('common.exportSuccess'))
  } catch (error) {
    console.error('导出失败:', error)
    ElMessage.error(t('common.exportFailed'))
  }
}

const handlePrint = async (row) => {
  try {
    const res = await printArchiveApi(row.id)
    if (res.code === 200) {
      // 打开打印预览对话框
      printPreviewData.value = res.data
      // 设置当前打印时间
      const now = new Date()
      currentPrintTime.value = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`
      printPreviewVisible.value = true
    }
  } catch (error) {
    console.error('打印失败:', error)
    ElMessage.error(t('common.printFailed'))
  }
}

// 打印预览相关
const printPreviewVisible = ref(false)
const printPreviewData = ref(null)
const currentPrintTime = ref('')

const doPrint = () => {
  // 使用浏览器打印功能
  window.print()
}

const closePrintPreview = () => {
  printPreviewVisible.value = false
  printPreviewData.value = null
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(t('archive.deleteConfirm'), t('common.warning'), {
      type: 'error',
      confirmButtonText: t('common.confirm'),
      cancelButtonText: t('common.cancel')
    })
    
    const res = await deleteArchiveApi(row.id)
    if (res.code === 200) {
      ElMessage.success(t('common.deleteSuccess'))
      loadData()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error(t('common.deleteFailed'))
    }
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

const formatDateTime = (dateTime) => {
  if (!dateTime) return '—'
  return dateTime.replace('T', ' ')
}

// 合并单元格方法：文物已删除的行，合并所有列
const objectSpanMethod = ({ row, column, rowIndex, columnIndex }) => {
  // 如果文物不存在（已删除），除了第二列（文物信息列）显示提示外，其他列都隐藏
  if (!row.relic) {
    if (columnIndex === 1) {
      // 第二列（文物信息列）合并所有列
      return {
        rowspan: 1,
        colspan: 9 // 合并所有9列
      }
    } else {
      // 其他列隐藏
      return {
        rowspan: 0,
        colspan: 0
      }
    }
  }
  // 正常情况不合并
  return {
    rowspan: 1,
    colspan: 1
  }
}

onMounted(() => {
  loadData()
  loadRelics()
})
</script>

<style scoped>
.view-card {
  margin: 20px;
}

.toolbar {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

:deep(.el-table) {
  margin-top: 20px;
}

/* 打印预览样式 */
.print-preview-content {
  padding: 20px;
  font-family: 'Microsoft YaHei', Arial, sans-serif;
}

.print-header {
  text-align: center;
  margin-bottom: 30px;
  padding-bottom: 15px;
  border-bottom: 2px solid #303133;
}

.print-header h1 {
  font-size: 24px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 10px 0;
}

.print-time {
  font-size: 14px;
  color: #606266;
  margin-top: 8px;
}

.info-section {
  margin-bottom: 25px;
  page-break-inside: avoid;
}

.info-section h3 {
  font-size: 16px;
  font-weight: 600;
  color: #303133;
  margin: 0 0 12px 0;
  padding-bottom: 6px;
  border-bottom: 1px solid #dcdfe6;
}

.info-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 10px;
}

.info-table td {
  padding: 10px 12px;
  border: 1px solid #dcdfe6;
  font-size: 14px;
  line-height: 1.6;
}

.info-table .label {
  width: 20%;
  background-color: #f5f7fa;
  color: #606266;
  font-weight: 500;
  text-align: right;
}

.info-table .value {
  width: 30%;
  color: #303133;
}

.description-text {
  padding: 15px;
  background-color: #f5f7fa;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  line-height: 1.8;
  white-space: pre-wrap;
  word-wrap: break-word;
  color: #303133;
  font-size: 14px;
}

/* 打印样式 */
@media print {
  /* 隐藏所有页面元素 */
  body * {
    visibility: hidden;
  }

  /* 只显示打印区域 */
  #printArea,
  #printArea * {
    visibility: visible;
  }

  /* 打印区域占满页面 */
  #printArea {
    position: absolute;
    left: 0;
    top: 0;
    width: 100%;
    padding: 20mm;
  }

  /* 优化打印布局 */
  .print-header h1 {
    font-size: 22pt;
    margin-bottom: 8pt;
  }

  .print-time {
    font-size: 10pt;
  }

  .info-section {
    margin-bottom: 15pt;
    page-break-inside: avoid;
  }

  .info-section h3 {
    font-size: 14pt;
    margin-bottom: 8pt;
    page-break-after: avoid;
  }

  .info-table {
    page-break-inside: avoid;
  }

  .info-table td {
    padding: 6pt 8pt;
    font-size: 10pt;
  }

  .description-text {
    padding: 10pt;
    font-size: 10pt;
    page-break-inside: avoid;
  }

  /* 确保边框在打印时显示 */
  .info-table td,
  .description-text {
    border: 1px solid #000 !important;
  }

  .print-header {
    border-bottom: 2px solid #000 !important;
  }

  .info-section h3 {
    border-bottom: 1px solid #000 !important;
  }
}
</style>
