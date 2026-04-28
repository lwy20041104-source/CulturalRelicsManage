<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-select 
          v-model="query.backupType" 
          :placeholder="$t('backup.backupType')" 
          clearable 
          style="width: 150px"
        >
          <el-option :label="$t('backup.manual')" value="manual" />
          <el-option :label="$t('backup.auto')" value="auto" />
        </el-select>
        <el-select 
          v-model="query.backupStatus" 
          :placeholder="$t('common.status')" 
          clearable 
          style="width: 150px"
        >
          <el-option :label="$t('backup.processing')" value="processing" />
          <el-option :label="$t('backup.success')" value="success" />
          <el-option :label="$t('backup.failed')" value="failed" />
        </el-select>
        <el-button type="primary" @click="loadData">
          <el-icon><Search /></el-icon>
          {{$t('common.search')}}
        </el-button>
        <el-button type="success" @click="openCreateDialog">
          <el-icon><Plus /></el-icon>
          {{$t('backup.createBackup')}}
        </el-button>
        <el-button type="warning" @click="openConfigDialog">
          <el-icon><Setting /></el-icon>
          {{$t('backup.backupConfig')}}
        </el-button>
        <el-button type="danger" @click="cleanExpiredBackups">
          <el-icon><Delete /></el-icon>
          {{$t('backup.cleanExpired')}}
        </el-button>
      </div>
    </template>

    <el-table :data="tableData" border v-loading="loading">
      <el-table-column prop="backupName" :label="$t('backup.backupName')" min-width="200" show-overflow-tooltip />
      <el-table-column :label="$t('backup.backupType')" width="100">
        <template #default="scope">
          <el-tag :type="scope.row.backupType === 'manual' ? 'primary' : 'success'">
            {{ scope.row.backupType === 'manual' ? $t('backup.manual') : $t('backup.auto') }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.status')" width="100">
        <template #default="scope">
          <el-tag :type="getStatusTag(scope.row.backupStatus)">
            {{ getStatusName(scope.row.backupStatus) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('backup.fileSize')" width="120">
        <template #default="scope">
          {{ formatFileSize(scope.row.fileSize) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('backup.isEncrypted')" width="100" align="center">
        <template #default="scope">
          <el-icon v-if="scope.row.isEncrypted" color="#67C23A"><Lock /></el-icon>
          <el-icon v-else color="#909399"><Unlock /></el-icon>
        </template>
      </el-table-column>
      <el-table-column prop="createdBy" :label="$t('common.creator')" width="120" />
      <el-table-column :label="$t('common.createTime')" width="160">
        <template #default="scope">
          {{ formatDateTime(scope.row.createdTime) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.action')" width="280" fixed="right">
        <template #default="scope">
          <el-button 
            link 
            type="primary" 
            @click="downloadBackup(scope.row)"
            :disabled="scope.row.backupStatus !== 'success'"
          >
            <el-icon><Download /></el-icon>
            {{$t('backup.download')}}
          </el-button>
          <el-button 
            link 
            type="warning" 
            @click="restoreBackup(scope.row)"
            :disabled="scope.row.backupStatus !== 'success'"
          >
            <el-icon><RefreshRight /></el-icon>
            {{$t('backup.restore')}}
          </el-button>
          <el-button 
            link 
            type="danger" 
            @click="deleteBackup(scope.row)"
          >
            <el-icon><Delete /></el-icon>
            {{$t('common.delete')}}
          </el-button>
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

    <!-- 创建备份对话框 -->
    <el-dialog
      v-model="createDialogVisible"
      :title="$t('backup.createBackup')"
      width="600px"
      @close="resetCreateForm"
    >
      <el-form :model="createForm" :rules="createRules" ref="createFormRef" label-width="120px">
        <el-form-item :label="$t('backup.backupName')" prop="backupName">
          <el-input v-model="createForm.backupName" :placeholder="$t('backup.backupNamePlaceholder')" />
        </el-form-item>
        <el-form-item :label="$t('backup.description')">
          <el-input 
            v-model="createForm.description" 
            type="textarea" 
            :rows="3"
            :placeholder="$t('backup.descriptionPlaceholder')"
          />
        </el-form-item>
        <el-form-item :label="$t('backup.isEncrypted')">
          <el-switch v-model="createForm.isEncrypted" />
          <span style="margin-left: 10px; color: #909399; font-size: 12px;">
            {{ $t('backup.encryptionTip') }}
          </span>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="createDialogVisible = false">{{$t('common.cancel')}}</el-button>
        <el-button type="primary" @click="submitCreate" :loading="submitting">
          {{$t('common.confirm')}}
        </el-button>
      </template>
    </el-dialog>

    <!-- 备份配置对话框 -->
    <el-dialog
      v-model="configDialogVisible"
      :title="$t('backup.backupConfig')"
      width="700px"
    >
      <el-form :model="configForm" label-width="140px">
        <el-form-item :label="$t('backup.enableAutoBackup')">
          <el-switch v-model="configForm.isEnabled" />
        </el-form-item>
        <el-form-item :label="$t('backup.backupFrequency')">
          <el-radio-group v-model="configForm.backupFrequency">
            <el-radio label="daily">{{$t('backup.daily')}}</el-radio>
            <el-radio label="weekly">{{$t('backup.weekly')}}</el-radio>
            <el-radio label="monthly">{{$t('backup.monthly')}}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="$t('backup.backupTime')">
          <el-time-select
            v-model="configForm.backupTime"
            start="00:00"
            step="01:00"
            end="23:00"
            :placeholder="$t('backup.selectTime')"
          />
        </el-form-item>
        <el-form-item :label="$t('backup.retentionDays')">
          <el-input-number v-model="configForm.retentionDays" :min="1" :max="365" />
          <span style="margin-left: 10px; color: #909399; font-size: 12px;">
            {{ $t('backup.retentionDaysTip') }}
          </span>
        </el-form-item>
        <el-form-item :label="$t('backup.maxBackupCount')">
          <el-input-number v-model="configForm.maxBackupCount" :min="1" :max="100" />
        </el-form-item>
        <el-form-item :label="$t('backup.enableEncryption')">
          <el-switch v-model="configForm.isEncrypted" />
        </el-form-item>
        <el-form-item :label="$t('backup.enableNotification')">
          <el-switch v-model="configForm.notificationEnabled" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="configDialogVisible = false">{{$t('common.cancel')}}</el-button>
        <el-button type="primary" @click="submitConfig" :loading="submitting">
          {{$t('common.confirm')}}
        </el-button>
      </template>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import {
  Search, Plus, Setting, Delete, Download, RefreshRight, Lock, Unlock
} from '@element-plus/icons-vue'
import {
  getBackupListApi,
  createBackupApi,
  deleteBackupApi,
  downloadBackupApi,
  restoreDatabaseApi,
  getBackupConfigApi,
  updateBackupConfigApi,
  cleanExpiredBackupsApi
} from '../api/backup'

const { t } = useI18n()
const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const createDialogVisible = ref(false)
const configDialogVisible = ref(false)
const submitting = ref(false)
const createFormRef = ref(null)

const query = reactive({
  pageNum: 1,
  pageSize: 10,
  backupType: '',
  backupStatus: ''
})

const createForm = reactive({
  backupName: '',
  description: '',
  isEncrypted: false
})

const configForm = reactive({
  id: null,
  isEnabled: true,
  backupFrequency: 'daily',
  backupTime: '02:00',
  retentionDays: 30,
  maxBackupCount: 10,
  isEncrypted: false,
  notificationEnabled: true
})

const createRules = {
  backupName: [{ required: true, message: '请输入备份名称', trigger: 'blur' }]
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getBackupListApi(query)
    if (res.code === 200) {
      tableData.value = res.data.records || []
      total.value = res.data.total || 0
    }
  } catch (error) {
    console.error('加载备份列表失败:', error)
    ElMessage.error(t('backup.loadFailed'))
  } finally {
    loading.value = false
  }
}

const openCreateDialog = () => {
  resetCreateForm()
  createDialogVisible.value = true
}

const resetCreateForm = () => {
  Object.assign(createForm, {
    backupName: '',
    description: '',
    isEncrypted: false
  })
  if (createFormRef.value) {
    createFormRef.value.clearValidate()
  }
}

const submitCreate = async () => {
  if (!createFormRef.value) return
  
  await createFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitting.value = true
    try {
      const res = await createBackupApi(createForm)
      if (res.code === 200) {
        ElMessage.success(t('backup.createSuccess'))
        createDialogVisible.value = false
        loadData()
      } else {
        ElMessage.error(res.message || t('backup.createFailed'))
      }
    } catch (error) {
      console.error('创建备份失败:', error)
      ElMessage.error(t('backup.createFailed'))
    } finally {
      submitting.value = false
    }
  })
}

const downloadBackup = async (row) => {
  try {
    const res = await downloadBackupApi(row.id)
    const blob = new Blob([res])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = row.fileName
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('backup.downloadSuccess'))
  } catch (error) {
    console.error('下载备份失败:', error)
    ElMessage.error(t('backup.downloadFailed'))
  }
}

const restoreBackup = async (row) => {
  try {
    await ElMessageBox.confirm(
      t('backup.restoreConfirm'),
      t('common.warning'),
      {
        type: 'warning',
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel')
      }
    )
    
    const res = await restoreDatabaseApi(row.id)
    if (res.code === 200) {
      ElMessage.success(t('backup.restoreSuccess'))
      loadData()
    } else {
      ElMessage.error(res.message || t('backup.restoreFailed'))
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('恢复失败:', error)
      ElMessage.error(t('backup.restoreFailed'))
    }
  }
}

const deleteBackup = async (row) => {
  try {
    await ElMessageBox.confirm(
      t('backup.deleteConfirm'),
      t('common.warning'),
      {
        type: 'error',
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel')
      }
    )
    
    const res = await deleteBackupApi(row.id)
    if (res.code === 200) {
      ElMessage.success(t('common.deleteSuccess'))
      loadData()
    } else {
      ElMessage.error(res.message || t('common.deleteFailed'))
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error(t('common.deleteFailed'))
    }
  }
}

const openConfigDialog = async () => {
  try {
    const res = await getBackupConfigApi()
    if (res.code === 200) {
      Object.assign(configForm, res.data)
    }
    configDialogVisible.value = true
  } catch (error) {
    console.error('加载配置失败:', error)
    ElMessage.error(t('backup.loadConfigFailed'))
  }
}

const submitConfig = async () => {
  submitting.value = true
  try {
    const res = await updateBackupConfigApi(configForm)
    if (res.code === 200) {
      ElMessage.success(t('backup.updateConfigSuccess'))
      configDialogVisible.value = false
    } else {
      ElMessage.error(res.message || t('backup.updateConfigFailed'))
    }
  } catch (error) {
    console.error('更新配置失败:', error)
    ElMessage.error(t('backup.updateConfigFailed'))
  } finally {
    submitting.value = false
  }
}

const cleanExpiredBackups = async () => {
  try {
    await ElMessageBox.confirm(
      t('backup.cleanExpiredConfirm'),
      t('common.warning'),
      {
        type: 'warning',
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel')
      }
    )
    
    const res = await cleanExpiredBackupsApi()
    if (res.code === 200) {
      ElMessage.success(t('backup.cleanSuccess'))
      loadData()
    } else {
      ElMessage.error(res.message || t('backup.cleanFailed'))
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('清理失败:', error)
      ElMessage.error(t('backup.cleanFailed'))
    }
  }
}

const getStatusTag = (status) => {
  const map = {
    processing: 'warning',
    success: 'success',
    failed: 'danger'
  }
  return map[status] || ''
}

const getStatusName = (status) => {
  const map = {
    processing: t('backup.processing'),
    success: t('backup.success'),
    failed: t('backup.failed')
  }
  return map[status] || status
}

const formatFileSize = (bytes) => {
  if (!bytes || bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i]
}

const formatDateTime = (dateTime) => {
  if (!dateTime) return '—'
  return dateTime.replace('T', ' ')
}

onMounted(() => {
  loadData()
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
</style>
