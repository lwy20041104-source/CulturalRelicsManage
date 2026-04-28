<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input
          v-model="queryParams.museumName"
          :placeholder="$t('museum.museumNamePlaceholder')"
          clearable
          style="width: 200px"
          @clear="handleQuery"
          @keyup.enter="handleQuery"
        />
        <el-input
          v-model="queryParams.city"
          :placeholder="$t('museum.cityPlaceholder')"
          clearable
          style="width: 150px"
          @clear="handleQuery"
          @keyup.enter="handleQuery"
        />
        <el-select
          v-model="queryParams.status"
          :placeholder="$t('museum.statusPlaceholder')"
          clearable
          style="width: 120px"
        >
          <el-option :label="$t('museum.hasCooperation')" :value="1" />
          <el-option :label="$t('museum.noCooperation')" :value="0" />
        </el-select>
        <el-button type="primary" @click="handleQuery">{{ $t('common.search') }}</el-button>
        <el-button @click="handleReset">{{ $t('common.reset') }}</el-button>
        <el-button type="success" @click="handleAdd">{{ $t('museum.addMuseum') }}</el-button>
        <el-button type="danger" :disabled="selectedIds.length === 0" @click="batchDelete">{{ $t('common.batchDelete') }}</el-button>
        <el-button type="warning" :disabled="selectedIds.length === 0" @click="batchUpdateStatus">{{ $t('common.batchUpdateStatus') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border v-loading="loading" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="museumCode" :label="$t('museum.museumCode')" width="120" />
      <el-table-column prop="museumName" :label="$t('museum.museumName')" min-width="150" />
      <el-table-column prop="museumType" :label="$t('museum.museumType')" width="100" />
      <el-table-column prop="province" :label="$t('museum.province')" width="100" />
      <el-table-column prop="city" :label="$t('museum.city')" width="100" />
      <el-table-column prop="address" :label="$t('museum.address')" min-width="180" show-overflow-tooltip />
      <el-table-column prop="contactPerson" :label="$t('museum.contactPerson')" width="100" />
      <el-table-column prop="contactPhone" :label="$t('museum.contactPhone')" width="120" />
      <el-table-column prop="status" :label="$t('museum.cooperationStatus')" width="100">
        <template #default="scope">
          <el-tag :type="scope.row.status === 1 ? 'success' : 'info'">
            {{ scope.row.status === 1 ? $t('museum.hasCooperation') : $t('museum.noCooperation') }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="180" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="handleEdit(scope.row)">{{ $t('common.edit') }}</el-button>
          <el-button link type="danger" @click="handleDelete(scope.row)">{{ $t('common.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      class="pager"
      background
      layout="total, prev, pager, next"
      :total="total"
      :page-size="queryParams.pageSize"
      :current-page="queryParams.pageNum"
      @current-change="handlePageChange"
    />
  </el-card>

  <!-- 新增/编辑对话框 -->
  <el-dialog
    v-model="dialogVisible"
    :title="dialogTitle"
    width="560px"
    @close="handleDialogClose"
  >
    <el-form
      ref="formRef"
      :model="form"
      :rules="rules"
      label-width="100px"
    >
      <el-form-item :label="$t('museum.museumCode')" prop="museumCode">
        <el-input v-model="form.museumCode" :disabled="isEdit" />
      </el-form-item>
      <el-form-item :label="$t('museum.museumName')" prop="museumName">
        <el-input v-model="form.museumName" />
      </el-form-item>
      <el-form-item :label="$t('museum.museumType')" prop="museumType">
        <el-select v-model="form.museumType" :placeholder="$t('museum.selectTypePlaceholder')" style="width: 100%">
          <el-option :label="$t('museum.typeComprehensive')" :value="t('museum.typeComprehensive')" />
          <el-option :label="$t('museum.typeHistory')" :value="t('museum.typeHistory')" />
          <el-option :label="$t('museum.typeArt')" :value="t('museum.typeArt')" />
          <el-option :label="$t('museum.typeScience')" :value="t('museum.typeScience')" />
          <el-option :label="$t('museum.typeNature')" :value="t('museum.typeNature')" />
          <el-option :label="$t('museum.typeSpecial')" :value="t('museum.typeSpecial')" />
        </el-select>
      </el-form-item>
      <el-form-item :label="$t('museum.cooperationStatus')" prop="status">
        <el-radio-group v-model="form.status">
          <el-radio :label="1">{{ $t('museum.hasCooperation') }}</el-radio>
          <el-radio :label="0">{{ $t('museum.noCooperation') }}</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item :label="$t('museum.province')" prop="province">
        <el-input v-model="form.province" />
      </el-form-item>
      <el-form-item :label="$t('museum.city')" prop="city">
        <el-input v-model="form.city" />
      </el-form-item>
      <el-form-item :label="$t('museum.address')" prop="address">
        <el-input v-model="form.address" />
      </el-form-item>
      <el-form-item :label="$t('museum.contactPerson')" prop="contactPerson">
        <el-input v-model="form.contactPerson" />
      </el-form-item>
      <el-form-item :label="$t('museum.contactPhone')" prop="contactPhone">
        <el-input v-model="form.contactPhone" maxlength="11" />
      </el-form-item>
      <el-form-item :label="$t('museum.contactEmail')" prop="contactEmail">
        <el-input v-model="form.contactEmail" />
      </el-form-item>
      <el-form-item :label="$t('museum.description')" prop="description">
        <el-input
          v-model="form.description"
          type="textarea"
          :rows="3"
        />
      </el-form-item>
    </el-form>

    <template #footer>
      <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
      <el-button type="primary" @click="handleSubmit" :loading="submitLoading">
        {{ $t('common.confirm') }}
      </el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import {
  getMuseumsPageApi,
  addMuseumApi,
  updateMuseumApi,
  deleteMuseumApi
} from '../api/museums'

const { t } = useI18n()

const loading = ref(false)
const tableData = ref([])
const total = ref(0)
const selectedIds = ref([])

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  museumName: '',
  city: '',
  status: null
})

const dialogVisible = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)
const submitLoading = ref(false)
const formRef = ref(null)

const form = reactive({
  id: null,
  museumCode: '',
  museumName: '',
  museumType: '',
  province: '',
  city: '',
  address: '',
  contactPerson: '',
  contactPhone: '',
  contactEmail: '',
  description: '',
  status: 1
})

const rules = {
  museumCode: [
    { required: true, message: t('museum.codeRequired'), trigger: 'blur' },
    { min: 2, max: 20, message: t('museum.codeLength'), trigger: 'blur' }
  ],
  museumName: [
    { required: true, message: t('museum.nameRequired'), trigger: 'blur' },
    { min: 2, max: 50, message: t('museum.nameLength'), trigger: 'blur' }
  ],
  museumType: [
    { required: true, message: t('museum.typeRequired'), trigger: 'change' }
  ],
  province: [
    { required: true, message: t('museum.provinceRequired'), trigger: 'blur' }
  ],
  city: [
    { required: true, message: t('museum.cityRequired'), trigger: 'blur' }
  ],
  contactPhone: [
    { pattern: /^1\d{10}$/, message: t('museum.phoneInvalid'), trigger: 'blur' }
  ],
  contactEmail: [
    { type: 'email', message: t('museum.emailInvalid'), trigger: 'blur' }
  ]
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getMuseumsPageApi(queryParams)
    if (res.code === 200) {
      tableData.value = res.data.records
      total.value = res.data.total
    } else {
      ElMessage.error(res.message || t('museum.loadFailed'))
    }
  } catch (e) {
    ElMessage.error(t('museum.loadFailed'))
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.pageNum = 1
  loadData()
}

const handlePageChange = (page) => {
  queryParams.pageNum = page
  loadData()
}

const handleReset = () => {
  queryParams.museumName = ''
  queryParams.city = ''
  queryParams.status = null
  handleQuery()
}

const handleAdd = () => {
  dialogTitle.value = t('museum.addMuseum')
  isEdit.value = false
  dialogVisible.value = true
}

const handleEdit = (row) => {
  dialogTitle.value = t('museum.editMuseum')
  isEdit.value = true
  Object.assign(form, row)
  dialogVisible.value = true
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      t('museum.deleteConfirm', { name: row.museumName }),
      t('common.tip'),
      {
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel'),
        type: 'warning'
      }
    )

    const res = await deleteMuseumApi(row.id)
    if (res.code === 200) {
      ElMessage.success(t('common.deleteSuccess'))
      loadData()
    } else {
      ElMessage.error(res.message || t('common.deleteFailed'))
    }
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(t('common.deleteFailed'))
    }
  }
}

const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.id)
}

const batchDelete = async () => {
  await ElMessageBox.confirm(t('museum.batchDeleteConfirm', { count: selectedIds.value.length }), t('common.warning'), { type: 'warning' })
  
  try {
    await Promise.all(selectedIds.value.map(id => deleteMuseumApi(id)))
    ElMessage.success(t('museum.batchDeleteSuccess'))
    selectedIds.value = []
    loadData()
  } catch (e) {
    ElMessage.error(t('museum.batchDeleteFailed'))
  }
}

const batchUpdateStatus = async () => {
  await ElMessageBox.prompt(t('museum.selectStatus'), t('museum.batchUpdateStatusTitle'), {
    confirmButtonText: t('common.confirm'),
    cancelButtonText: t('common.cancel'),
    inputType: 'select',
    inputOptions: [
      { label: t('museum.hasCooperation'), value: 1 },
      { label: t('museum.noCooperation'), value: 0 }
    ],
    inputValidator: (value) => {
      return value !== null && value !== ''
    },
    inputErrorMessage: t('museum.selectStatusError')
  }).then(async ({ value }) => {
    const status = parseInt(value)
    try {
      const updates = selectedIds.value.map(id => {
        const museum = tableData.value.find(item => item.id === id)
        return updateMuseumApi(id, { ...museum, status })
      })
      await Promise.all(updates)
      ElMessage.success(t('museum.batchUpdateStatusSuccess'))
      selectedIds.value = []
      loadData()
    } catch (e) {
      ElMessage.error(t('museum.batchUpdateStatusFailed'))
    }
  }).catch(() => {})
}

const handleDialogClose = () => {
  formRef.value?.resetFields()
  Object.assign(form, {
    id: null,
    museumCode: '',
    museumName: '',
    museumType: '',
    province: '',
    city: '',
    address: '',
    contactPerson: '',
    contactPhone: '',
    contactEmail: '',
    description: '',
    status: 1
  })
}

const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (!valid) return

    submitLoading.value = true
    try {
      const res = isEdit.value
        ? await updateMuseumApi(form.id, form)
        : await addMuseumApi(form)

      if (res.code === 200) {
        ElMessage.success(isEdit.value ? t('common.updateSuccess') : t('common.addSuccess'))
        dialogVisible.value = false
        loadData()
      } else {
        ElMessage.error(res.message || t('common.failed'))
      }
    } catch (e) {
      ElMessage.error(e?.response?.data?.message || t('common.failed'))
    } finally {
      submitLoading.value = false
    }
  })
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

:deep(.el-form-item__label) {
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
