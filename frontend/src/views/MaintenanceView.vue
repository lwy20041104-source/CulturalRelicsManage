<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-button type="success" @click="openAdd">{{ $t('maintenance.addMaintenance') }}</el-button>
        <el-select v-model="query.status" :placeholder="$t('common.status')" clearable style="width: 150px" @change="loadData">
          <el-option label="待审批" value="待审批" />
          <el-option label="已通过" value="已通过" />
          <el-option label="已拒绝" value="已拒绝" />
        </el-select>
      </div>
    </template>

    <el-table :data="tableData" border :span-method="objectSpanMethod">
      <el-table-column :label="$t('maintenance.relicName')" min-width="160">
        <template #default="scope">
          <div v-if="scope.row.relicName">
            {{ scope.row.relicName }}
          </div>
          <div v-else style="color: #f56c6c; text-align: center;">
            <el-icon style="vertical-align: middle;"><WarningFilled /></el-icon>
            {{ $t('maintenance.relicDeleted') }}
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="maintenanceType" :label="$t('maintenance.maintenanceType')" width="120">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.maintenanceType }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('maintenance.maintenanceDate')" width="170">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ formatDateTime(scope.row.maintenanceDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('maintenance.maintainer')" width="120">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.maintainerName || scope.row.maintainer || '—' }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="maintenanceContent" :label="$t('maintenance.maintenanceContent')">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.maintenanceContent }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.status')" width="100">
        <template #default="scope">
          <template v-if="scope.row.relicName">
            <el-tag v-if="scope.row.status === '待审批'" type="warning">{{ scope.row.status }}</el-tag>
            <el-tag v-else-if="scope.row.status === '已通过'" type="success">{{ scope.row.status }}</el-tag>
            <el-tag v-else-if="scope.row.status === '已拒绝'" type="danger">{{ scope.row.status }}</el-tag>
            <el-tag v-else type="info">{{ scope.row.status || '—' }}</el-tag>
          </template>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" :width="isAdminOrApprover ? 240 : 220">
        <template #default="scope">
          <template v-if="scope.row.relicName">
            <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
            <!-- 管理员和审批员：显示批准和拒绝按钮 -->
            <template v-if="isAdminOrApprover && scope.row.status === '待审批'">
              <el-button link type="success" @click="quickApprove(scope.row, '已通过')">批准</el-button>
              <el-button link type="danger" @click="quickApprove(scope.row, '已拒绝')">拒绝</el-button>
            </template>
            <!-- 保管员：只显示编辑和撤回按钮 -->
            <template v-if="!isAdminOrApprover && scope.row.status === '待审批'">
              <el-button link type="primary" @click="openEdit(scope.row)">{{ $t('common.edit') }}</el-button>
              <el-button link type="danger" @click="remove(scope.row.id)">撤回</el-button>
            </template>
          </template>
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
        <el-form-item :label="$t('maintenance.maintenanceContent')" prop="maintenanceContent"><el-input v-model="form.maintenanceContent" type="textarea" /></el-form-item>
        <el-form-item :label="$t('common.remark')"><el-input v-model="form.remark" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 审批对话框 -->
    <el-dialog v-model="approveDialogVisible" title="审批维护申请" width="560px" class="form-dialog">
      <el-form ref="approveFormRef" :model="approveForm" :rules="approveRules" label-width="100px" class="dialog-form">
        <el-form-item label="文物名称">
          <el-input v-model="approveForm.relicName" disabled />
        </el-form-item>
        <el-form-item label="维护类型">
          <el-input v-model="approveForm.maintenanceType" disabled />
        </el-form-item>
        <el-form-item label="维护内容">
          <el-input v-model="approveForm.maintenanceContent" type="textarea" disabled />
        </el-form-item>
        <el-form-item label="审批结果" prop="status">
          <el-radio-group v-model="approveForm.status">
            <el-radio label="已通过">通过</el-radio>
            <el-radio label="已拒绝">拒绝</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审批备注">
          <el-input v-model="approveForm.approveRemark" type="textarea" :placeholder="approveForm.status === '已拒绝' ? '请填写拒绝原因' : '选填'" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="approveDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitApprove">{{ $t('common.confirm') }}</el-button>
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
        <el-descriptions-item :label="$t('maintenance.maintainer')">{{ currentDetail.maintainerName || currentDetail.maintainer || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.status')">
          <el-tag v-if="currentDetail.status === '待审批'" type="warning">{{ currentDetail.status }}</el-tag>
          <el-tag v-else-if="currentDetail.status === '已通过'" type="success">{{ currentDetail.status }}</el-tag>
          <el-tag v-else-if="currentDetail.status === '已拒绝'" type="danger">{{ currentDetail.status }}</el-tag>
          <el-tag v-else type="info">{{ currentDetail.status || '—' }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approver" label="审批人">{{ currentDetail.approver }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approveDate" label="审批时间">{{ formatDateTime(currentDetail.approveDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approveRemark" label="审批备注" :span="2">{{ currentDetail.approveRemark }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('maintenance.maintenanceContent')" :span="2">{{ currentDetail.maintenanceContent }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.remark" :label="$t('common.remark')" :span="2">{{ currentDetail.remark }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.updateTime')" :span="2">{{ formatDateTime(currentDetail.updateTime) || '—' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { WarningFilled } from '@element-plus/icons-vue'
import { getMaintenancePageApi, addMaintenanceApi, updateMaintenanceApi, deleteMaintenanceApi, approveMaintenanceApi } from '../api/maintenance'
import { getRelicsPageApi } from '../api/relics'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const relicOptions = ref([])
const dialogVisible = ref(false)
const approveDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const approveFormRef = ref()
const query = reactive({ pageNum: 1, pageSize: 10, status: null })
const form = reactive({ id: null, relicId: null, maintenanceType: '日常维护', maintenanceDate: '', maintenanceContent: '', remark: '' })
const approveForm = reactive({ id: null, relicName: '', maintenanceType: '', maintenanceContent: '', status: '已通过', approveRemark: '' })

// 判断当前用户是否是管理员或审批员
const isAdminOrApprover = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN' || role === 'APPROVER'
})

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
  maintenanceContent: [{ required: true, message: t('validation.required'), trigger: 'blur' }]
}

const approveRules = {
  status: [{ required: true, message: '请选择审批结果', trigger: 'change' }]
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
  
  // 简单判断：如果第一次加载且有数据，检查是否有审批按钮的需求
  // 实际上后端会根据角色过滤数据，所以前端只需要检查是否能看到审批相关字段
  if (tableData.value.length > 0) {
    // 如果有记录包含approver字段且不为空，说明可能是管理员视图
    // 但更简单的方法是：如果能看到待审批的记录，就显示相应的按钮
    // 这里我们简化处理：默认显示所有按钮，让后端控制权限
  }
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
  Object.assign(form, { 
    id: row.id, 
    relicId: row.relicId, 
    maintenanceType: row.maintenanceType, 
    maintenanceDate: row.maintenanceDate, 
    maintenanceContent: row.maintenanceContent, 
    remark: row.remark || '' 
  })
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

const openApprove = (row) => {
  Object.assign(approveForm, {
    id: row.id,
    relicName: row.relicName || `ID: ${row.relicId}`,
    maintenanceType: row.maintenanceType,
    maintenanceContent: row.maintenanceContent,
    status: '已通过',
    approveRemark: ''
  })
  approveFormRef.value?.clearValidate()
  approveDialogVisible.value = true
}

const quickApprove = async (row, status) => {
  try {
    const action = status === '已通过' ? '批准' : '拒绝'
    await ElMessageBox.confirm(
      `确定要${action}此维护申请吗？`,
      t('message.warning'),
      {
        type: 'warning',
        confirmButtonText: '确定',
        cancelButtonText: '取消'
      }
    )
    
    // 如果是拒绝，可以选择填写拒绝原因
    let approveRemark = ''
    if (status === '已拒绝') {
      const { value } = await ElMessageBox.prompt(
        '请填写拒绝原因（选填）',
        '拒绝原因',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputType: 'textarea',
          inputPlaceholder: '请输入拒绝原因'
        }
      ).catch(() => ({ value: '' }))
      approveRemark = value || ''
    }
    
    await approveMaintenanceApi({
      id: row.id,
      status: status,
      approveRemark: approveRemark
    })
    
    ElMessage.success(status === '已通过' ? '批准成功' : '已拒绝')
    loadData()
  } catch (e) {
    if (e !== 'cancel') {
      const msg = e?.response?.data?.message || e?.message
      if (msg) {
        ElMessage.error(msg)
      }
    }
  }
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
      ElMessage.success('维护申请已提交')
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

const submitApprove = async () => {
  try {
    await approveFormRef.value.validate()
    
    // 如果是拒绝，检查是否填写了备注
    if (approveForm.status === '已拒绝' && !approveForm.approveRemark) {
      ElMessage.warning('请填写拒绝原因')
      return
    }
    
    await approveMaintenanceApi(approveForm)
    ElMessage.success(approveForm.status === '已通过' ? '审批通过' : '审批拒绝')
    approveDialogVisible.value = false
    loadData()
  } catch (e) {
    const msg = e?.response?.data?.message || e?.message
    if (msg) {
      ElMessage.error(msg)
    }
  }
}

const remove = async (id) => {
  await ElMessageBox.confirm('确定要撤回此维护申请吗？', t('message.warning'), { type: 'warning' })
  await deleteMaintenanceApi(id)
  ElMessage.success('撤回成功')
  loadData()
}

// 合并单元格方法：文物已删除的行，合并所有列
const objectSpanMethod = ({ row, column, rowIndex, columnIndex }) => {
  // 如果文物不存在（已删除），除了第一列（文物信息列）显示提示外，其他列都隐藏
  if (!row.relicName) {
    if (columnIndex === 0) {
      // 第一列（文物信息列）合并所有列
      return {
        rowspan: 1,
        colspan: 7 // 合并所有7列
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

// 检查是否显示审批按钮（如果后端返回错误，说明没有权限，则不显示）
const canApprove = ref(true)

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
