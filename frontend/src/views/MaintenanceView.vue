<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-button type="success" @click="openAdd">{{ $t('maintenance.addMaintenance') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border>
      <el-table-column :label="$t('maintenance.relicName')" min-width="160">
        <template #default="scope">
          {{ scope.row.relicName || `ID: ${scope.row.relicId}` }}
        </template>
      </el-table-column>
      <el-table-column prop="maintenanceType" :label="$t('maintenance.maintenanceType')" width="120" />
      <el-table-column :label="$t('maintenance.maintenanceDate')" width="170">
        <template #default="scope">
          {{ formatDateTime(scope.row.maintenanceDate) }}
        </template>
      </el-table-column>
      <el-table-column prop="maintainer" :label="$t('maintenance.maintainer')" width="120" />
      <el-table-column prop="maintenanceContent" :label="$t('maintenance.maintenanceContent')" />
      <el-table-column prop="remark" :label="$t('common.remark')" min-width="180" show-overflow-tooltip />
      <el-table-column :label="$t('common.operation')" width="220">
        <template #default="scope">
          <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
          <el-button link type="primary" @click="openEdit(scope.row)">{{ $t('common.edit') }}</el-button>
          <el-button link type="danger" @click="remove(scope.row.id)">{{ $t('common.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      class="pager"
      background
      layout="total, prev, pager, next"
      :total="total"
      :page-size="query.pageSize"
      :current-page="query.pageNum"
      @current-change="(p) => { query.pageNum = p; loadData(); }"
    />

    <el-dialog v-model="dialogVisible" :title="form.id ? $t('maintenance.editMaintenance') : $t('maintenance.addMaintenance')" width="560px" class="form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px" class="dialog-form">
        <el-form-item :label="$t('maintenance.relicName')" prop="relicId">
          <el-select v-model="form.relicId" :placeholder="$t('common.pleaseSelect')" filterable style="width: 100%">
            <el-option
              v-for="item in relicOptions"
              :key="item.id"
              :label="item.relicName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('maintenance.maintenanceType')" prop="maintenanceType">
          <el-select v-model="form.maintenanceType">
            <el-option :label="$t('maintenance.dailyCare')" value="日常维护" />
            <el-option label="修复" value="修复" />
            <el-option :label="$t('maintenance.inspection')" value="检测" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('maintenance.maintenanceDate')" prop="maintenanceDate">
          <el-date-picker 
            v-model="form.maintenanceDate" 
            type="datetime" 
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled-date="disabledMaintenanceDate"
            :placeholder="$t('common.pleaseSelect')"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item :label="$t('maintenance.maintainer')" prop="maintainer"><el-input v-model="form.maintainer" /></el-form-item>
        <el-form-item :label="$t('maintenance.maintenanceContent')" prop="maintenanceContent"><el-input v-model="form.maintenanceContent" type="textarea" /></el-form-item>
        <el-form-item :label="$t('common.remark')"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('common.detail')" width="800px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('maintenance.relicName')">{{ currentDetail.relicName || `ID: ${currentDetail.relicId}` }}</el-descriptions-item>
        <el-descriptions-item :label="$t('maintenance.maintenanceType')">
          <el-tag :type="currentDetail.maintenanceType === '修复' ? 'danger' : currentDetail.maintenanceType === '检测' ? 'warning' : 'success'">
            {{ currentDetail.maintenanceType }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('maintenance.maintenanceDate')">{{ formatDateTime(currentDetail.maintenanceDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('maintenance.maintainer')">{{ currentDetail.maintainer }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('maintenance.maintenanceContent')" :span="2">{{ currentDetail.maintenanceContent }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.remark" :label="$t('common.remark')" :span="2">{{ currentDetail.remark }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.updateTime')" :span="2">{{ formatDateTime(currentDetail.updateTime) || '—' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getMaintenancePageApi, addMaintenanceApi, updateMaintenanceApi, deleteMaintenanceApi } from '../api/maintenance'
import { getRelicsPageApi } from '../api/relics'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const relicOptions = ref([])
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const query = reactive({ pageNum: 1, pageSize: 10 })
const form = reactive({ id: null, relicId: null, maintenanceType: '日常维护', maintenanceDate: '', maintainer: '', maintenanceContent: '', remark: '' })

// 自定义维护日期验证规则
const validateMaintenanceDate = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('validation.required')))
  } else {
    const selectedDate = new Date(value)
    const now = new Date()
    
    if (selectedDate < now) {
      callback(new Error('维护日期必须是当前时间及以后'))
    } else {
      callback()
    }
  }
}

const rules = {
  relicId: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  maintenanceType: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  maintenanceDate: [
    { required: true, message: t('validation.required'), trigger: 'change' },
    { validator: validateMaintenanceDate, trigger: 'change' }
  ],
  maintainer: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  maintenanceContent: [{ required: true, message: t('validation.required'), trigger: 'blur' }]
}

// 禁用当前时间之前的日期（维护日期）
const disabledMaintenanceDate = (time) => {
  const now = new Date()
  return time.getTime() < now.getTime()
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const loadData = async () => {
  const res = await getMaintenancePageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

const loadRelics = async () => {
  const res = await getRelicsPageApi({ pageNum: 1, pageSize: 1000 })
  relicOptions.value = res.data.records || []
}

const resetForm = () => {
  // 设置默认的维护日期为当前日期时间
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  const seconds = String(now.getSeconds()).padStart(2, '0')
  const currentDateTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  
  Object.assign(form, { 
    id: null, 
    relicId: null, 
    maintenanceType: '日常维护', 
    maintenanceDate: currentDateTime,  // 默认为当前日期时间
    maintainer: '', 
    maintenanceContent: '', 
    remark: '' 
  })
  formRef.value?.clearValidate()
}

const openAdd = () => {
  resetForm()
  dialogVisible.value = true
}

const openEdit = (row) => {
  Object.assign(form, { id: row.id, relicId: row.relicId, maintenanceType: row.maintenanceType, maintenanceDate: row.maintenanceDate, maintainer: row.maintainer, maintenanceContent: row.maintenanceContent, remark: row.remark || '' })
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

const viewDetail = (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
}

const submit = async () => {
  try {
    await formRef.value.validate()
    if (form.id) {
      await updateMaintenanceApi(form)
      ElMessage.success(t('message.updateSuccess'))
    } else {
      await addMaintenanceApi(form)
      ElMessage.success(t('message.saveSuccess'))
    }
    dialogVisible.value = false
    loadData()
  } catch (e) {
    const msg = e?.response?.data?.message || e?.message
    if (msg) {
      ElMessage.error(msg)
    }
  }
}

const remove = async (id) => {
  await ElMessageBox.confirm(t('message.confirmDelete'), t('message.warning'), { type: 'warning' })
  await deleteMaintenanceApi(id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}

onMounted(async () => {
  await Promise.all([loadData(), loadRelics()])
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

.pager {
  margin-top: 14px;
  display: flex;
  justify-content: flex-end;
}

:deep(.el-table .cell) {
  color: #4f4235;
}

:deep(.el-table__row:hover > td.el-table__cell) {
  background: #fbf6ee;
}

:deep(.el-dialog) {
  border-radius: 14px;
}

:deep(.el-dialog__header) {
  border-bottom: 1px solid #eee3d3;
  margin-right: 0;
  padding: 16px 20px;
}

:deep(.el-dialog__body) {
  padding: 18px 20px 8px;
}

:deep(.el-dialog__footer) {
  border-top: 1px solid #eee3d3;
  padding: 12px 20px 16px;
}

.dialog-form :deep(.el-form-item__label) {
  color: #5f4f3d;
}

:deep(.el-input__wrapper),
:deep(.el-textarea__inner),
:deep(.el-select__wrapper) {
  box-shadow: 0 0 0 1px #e6d8c4 inset;
}

:deep(.el-input__wrapper.is-focus),
:deep(.el-select__wrapper.is-focused),
:deep(.el-textarea__inner:focus) {
  box-shadow: 0 0 0 1px #8a5b2f inset;
}
</style>
