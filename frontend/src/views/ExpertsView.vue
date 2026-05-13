<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="query.expertName" :placeholder="$t('expert.expertName')" style="width: 200px" @keyup.enter="loadData" />
        <el-input v-model="query.specialty" :placeholder="$t('expert.specialty')" style="width: 200px" @keyup.enter="loadData" />
        <el-button type="primary" @click="loadData">{{ $t('common.search') }}</el-button>
        <el-button type="success" @click="openAdd">{{ $t('expert.addExpert') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border>
      <el-table-column prop="expertName" :label="$t('expert.expertName')" width="120" />
      <el-table-column prop="specialty" :label="$t('expert.specialty')" min-width="150" />
      <el-table-column prop="title" :label="$t('user.role')" width="120" />
      <el-table-column prop="phone" :label="$t('expert.phone')" width="140" />
      <el-table-column prop="email" :label="$t('expert.email')" min-width="180" show-overflow-tooltip />
      <el-table-column prop="workYears" :label="$t('expert.experience')" width="100">
        <template #default="scope">
          {{ scope.row.workYears ? `${scope.row.workYears}${$t('expert.years')}` : '—' }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.status')" width="90">
        <template #default="scope">
          <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
            {{ scope.row.status === 1 ? $t('user.active') : $t('user.inactive') }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="230" fixed="right">
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

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? $t('expert.editExpert') : $t('expert.addExpert')" width="600px" class="form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px" class="dialog-form">
        <el-form-item v-if="form.id" :label="$t('repair.repairCode')">
          <el-input v-model="form.expertCode" disabled />
        </el-form-item>
        <el-form-item :label="$t('expert.expertName')" prop="expertName">
          <el-input v-model="form.expertName" />
        </el-form-item>
        <el-form-item :label="$t('expert.specialty')" prop="specialty">
          <el-input v-model="form.specialty" :placeholder="$t('common.pleaseInput')" />
        </el-form-item>
        <el-form-item :label="$t('user.role')" prop="title">
          <el-select v-model="form.title" style="width: 100%">
            <el-option label="初级修复师" value="初级修复师" />
            <el-option label="中级修复师" value="中级修复师" />
            <el-option label="高级修复师" value="高级修复师" />
            <el-option label="研究员" value="研究员" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('expert.phone')" prop="phone">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item :label="$t('expert.email')" prop="email">
          <el-input v-model="form.email" />
        </el-form-item>
        <el-form-item :label="$t('expert.experience')">
          <el-input-number v-model="form.workYears" :min="0" :max="50" :controls="false" style="width: 90%" />
          <span class="unit-text">{{ $t('expert.years') }}</span>
        </el-form-item>
        <el-form-item :label="$t('expert.certification')">
          <el-input v-model="form.certification" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item :label="$t('common.status')" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :label="1">{{ $t('user.active') }}</el-radio>
            <el-radio :label="0">{{ $t('user.inactive') }}</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item :label="$t('common.remark')">
          <el-input v-model="form.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('expert.title') + $t('common.detail')" width="800px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item label="ID">{{ currentDetail.id }}</el-descriptions-item>
        <el-descriptions-item :label="$t('expert.expertName')">{{ currentDetail.expertName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('expert.specialty')">{{ currentDetail.specialty || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.role')">{{ currentDetail.title || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('expert.experience')">{{ currentDetail.workYears ? `${currentDetail.workYears}${$t('expert.years')}` : '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('expert.phone')">{{ currentDetail.phone || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('expert.email')">{{ currentDetail.email || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.status')">
          <el-tag :type="currentDetail.status === 1 ? 'success' : 'info'">
            {{ currentDetail.status === 1 ? $t('user.active') : $t('user.inactive') }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('expert.certification')" :span="2">{{ currentDetail.certification || '—' }}</el-descriptions-item>
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
import { getExpertsPageApi, addExpertApi, updateExpertApi, deleteExpertApi } from '../api/experts'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const query = reactive({ pageNum: 1, pageSize: 10, expertName: '', specialty: '' })
const form = reactive({
  id: null,
  expertCode: '',
  expertName: '',
  specialty: '',
  title: '',
  phone: '',
  email: '',
  workYears: null,
  certification: '',
  status: 1,
  remark: ''
})
const rules = {
  expertName: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  specialty: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  title: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  phone: [
    { required: true, message: t('validation.required'), trigger: 'blur' },
    { pattern: /^1\d{10}$/, message: t('validation.invalidPhone'), trigger: 'blur' }
  ],
  email: [
    { type: 'email', message: t('validation.invalidEmail'), trigger: 'blur' }
  ],
  status: [{ required: true, message: t('validation.required'), trigger: 'change' }]
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const loadData = async () => {
  const res = await getExpertsPageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

const resetForm = () => {
  Object.assign(form, {
    id: null,
    expertCode: '',
    expertName: '',
    specialty: '',
    title: '',
    phone: '',
    email: '',
    workYears: null,
    certification: '',
    status: 1,
    remark: ''
  })
  formRef.value?.clearValidate()
}

const openAdd = () => {
  resetForm()
  dialogVisible.value = true
}

const openEdit = (row) => {
  Object.assign(form, {
    id: row.id,
    expertCode: row.expertCode,
    expertName: row.expertName,
    specialty: row.specialty,
    title: row.title,
    phone: row.phone,
    email: row.email,
    workYears: row.workYears,
    certification: row.certification,
    status: row.status,
    remark: row.remark || ''
  })
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

const viewDetail = (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
}

const submit = async () => {
  await formRef.value?.validate()
  if (form.id) {
    await updateExpertApi(form)
    ElMessage.success(t('message.updateSuccess'))
  } else {
    await addExpertApi(form)
    ElMessage.success(t('message.saveSuccess'))
  }
  dialogVisible.value = false
  loadData()
}

const remove = async (id) => {
  await ElMessageBox.confirm(t('message.confirmDelete'), t('message.tip'), { type: 'warning' })
  await deleteExpertApi(id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}

onMounted(loadData)
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

.unit-text {
  color: #7a6c5b;
  white-space: nowrap;
  margin-left: 8px;
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

.dialog-form :deep(.el-form-item__content) {
  gap: 8px;
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
