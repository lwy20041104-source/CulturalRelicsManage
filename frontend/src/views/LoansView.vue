<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-select v-model="query.status" :placeholder="$t('loan.status')" clearable style="width: 160px">
          <el-option :label="$t('loan.pending')" value="待审批" />
          <el-option :label="$t('loan.onLoan')" value="借展中" />
          <el-option :label="$t('loan.returned')" value="已归还" />
          <el-option :label="$t('dataScreen.overdue')" value="逾期" />
          <el-option :label="$t('loan.rejected')" value="已驳回" />
        </el-select>
        <el-button type="primary" @click="loadData">{{ $t('common.search') }}</el-button>
        <el-button type="danger" @click="loadOverdue">{{ $t('loan.overdueQuery') }}</el-button>
        <el-button type="success" @click="openAdd">{{ $t('loan.addLoan') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border :span-method="objectSpanMethod">
      <el-table-column :label="$t('loan.relicName')" min-width="160">
        <template #default="scope">
          <div v-if="scope.row.relicName">
            {{ scope.row.relicName }}
          </div>
          <div v-else style="color: #f56c6c; text-align: center;">
            <el-icon style="vertical-align: middle;"><WarningFilled /></el-icon>
            {{ $t('loan.relicDeleted') }}
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="borrowerUnit" :label="$t('loan.borrowerUnit')">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.borrowerUnit }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="borrowerName" :label="$t('loan.borrower')" width="110">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.borrowerName }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="borrowerPhone" :label="$t('loan.borrowerPhone')" width="150">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.borrowerPhone }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('loan.loanDate')" width="170">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ formatDateTime(scope.row.loanDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('loan.expectedReturnDate')" width="170">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ formatDateTime(scope.row.expectedReturnDate) }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="status" :label="$t('loan.status')" width="100">
        <template #default="scope">
          <span v-if="scope.row.relicName">{{ scope.row.status }}</span>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="310">
        <template #default="scope">
          <template v-if="scope.row.relicName">
            <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
            <el-button v-if="scope.row.status === '待审批'" link type="primary" @click="approve(scope.row, true)">{{ $t('loan.approve') }}</el-button>
            <el-button v-if="scope.row.status === '待审批'" link type="danger" @click="approve(scope.row, false)">{{ $t('loan.reject') }}</el-button>
            <el-button v-if="scope.row.status === '借展中' || scope.row.status === '逾期'" link type="success" @click="returnLoan(scope.row.id)">{{ $t('loan.returnLoan') }}</el-button>
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

    <el-dialog v-model="dialogVisible" :title="$t('loan.addLoan')" width="600px" class="form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="120px" class="dialog-form">
        <el-form-item :label="$t('loan.relicName')" prop="relicId">
          <el-select v-model="form.relicId" :placeholder="$t('common.pleaseSelect')" filterable style="width: 100%">
            <el-option
              v-for="item in relicOptions"
              :key="item.id"
              :label="item.relicName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('loan.borrowerUnit')" prop="borrowerUnit"><el-input v-model="form.borrowerUnit" /></el-form-item>
        <el-form-item :label="$t('loan.borrower')" prop="borrowerName"><el-input v-model="form.borrowerName" /></el-form-item>
        <el-form-item :label="$t('loan.borrowerPhone')" prop="borrowerPhone"><el-input v-model="form.borrowerPhone" /></el-form-item>
        <el-form-item :label="$t('loan.loanDate')" prop="loanDate">
          <el-date-picker 
            v-model="form.loanDate" 
            type="datetime" 
            value-format="YYYY-MM-DD HH:mm:ss" 
            :disabled-date="disabledLoanDate"
            :placeholder="$t('common.pleaseSelect')"
            style="width: 100%" 
          />
        </el-form-item>
        <el-form-item :label="$t('loan.expectedReturnDate')" prop="expectedReturnDate">
          <el-date-picker 
            v-model="form.expectedReturnDate" 
            type="datetime" 
            value-format="YYYY-MM-DD HH:mm:ss" 
            :disabled-date="disabledReturnDate"
            :placeholder="$t('common.pleaseSelect')"
            style="width: 100%" 
          />
        </el-form-item>
        <el-form-item :label="$t('loan.purpose')" prop="purpose"><el-input v-model="form.purpose" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.submit') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('common.detail')" width="800px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('loan.relicName')">{{ currentDetail.relicName || `ID: ${currentDetail.relicId}` }}</el-descriptions-item>
        <el-descriptions-item :label="$t('loan.status')">
          <el-tag :type="currentDetail.status === '已归还' ? 'success' : currentDetail.status === '逾期' ? 'danger' : 'warning'">
            {{ currentDetail.status }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('loan.borrowerUnit')">{{ currentDetail.borrowerUnit }}</el-descriptions-item>
        <el-descriptions-item :label="$t('loan.borrower')">{{ currentDetail.borrowerName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('loan.borrowerPhone')">{{ currentDetail.borrowerPhone }}</el-descriptions-item>
        <el-descriptions-item :label="$t('loan.loanDate')">{{ formatDateTime(currentDetail.loanDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('loan.expectedReturnDate')">{{ formatDateTime(currentDetail.expectedReturnDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.actualReturnDate" :label="$t('loan.actualReturnDate')">{{ formatDateTime(currentDetail.actualReturnDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approverName" :label="$t('loan.approver')">{{ currentDetail.approverName }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approveRemark" :label="$t('loan.approveRemark')" :span="2">{{ currentDetail.approveRemark }}</el-descriptions-item>
        <el-descriptions-item :label="$t('loan.purpose')" :span="2">{{ currentDetail.purpose || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.updateTime')">{{ formatDateTime(currentDetail.updateTime) || '—' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage } from 'element-plus'
import { WarningFilled } from '@element-plus/icons-vue'
import { getLoansPageApi, addLoanApi, approveLoanApi, returnLoanApi, getOverdueLoansApi } from '../api/loans'
import { getRelicsPageApi } from '../api/relics'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const relicOptions = ref([])
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const query = reactive({ pageNum: 1, pageSize: 10, status: '' })
const form = reactive({ relicId: null, borrowerName: '', borrowerUnit: '', borrowerPhone: '', loanDate: '', expectedReturnDate: '', purpose: '' })

// 自定义日期验证规则
const validateLoanDate = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('validation.required')))
  } else {
    const selectedDate = new Date(value)
    const now = new Date()
    // 将当前时间设置为今天的开始（00:00:00）
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate())
    
    if (selectedDate < today) {
      callback(new Error(t('loan.loanDateNotBeforeToday')))
    } else {
      callback()
    }
  }
}

const validateReturnDate = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('validation.required')))
  } else {
    const returnDate = new Date(value)
    const now = new Date()
    
    if (returnDate < now) {
      callback(new Error(t('loan.returnDateNotBeforeNow')))
    } else if (form.loanDate) {
      const loanDate = new Date(form.loanDate)
      if (returnDate <= loanDate) {
        callback(new Error(t('loan.returnDateAfterLoanDate')))
      } else {
        callback()
      }
    } else {
      callback()
    }
  }
}

const rules = {
  relicId: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  borrowerUnit: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  borrowerName: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  borrowerPhone: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  loanDate: [
    { required: true, message: t('validation.required'), trigger: 'change' },
    { validator: validateLoanDate, trigger: 'change' }
  ],
  expectedReturnDate: [
    { required: true, message: t('validation.required'), trigger: 'change' },
    { validator: validateReturnDate, trigger: 'change' }
  ],
  purpose: [{ required: true, message: t('validation.required'), trigger: 'blur' }]
}

// 禁用今天之前的日期（借展日期）
const disabledLoanDate = (time) => {
  const today = new Date()
  today.setHours(0, 0, 0, 0)
  return time.getTime() < today.getTime()
}

// 禁用当前时间之前的日期（预计归还日期）
const disabledReturnDate = (time) => {
  const now = new Date()
  return time.getTime() < now.getTime()
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const loadData = async () => {
  const res = await getLoansPageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

const loadRelics = async () => {
  const res = await getRelicsPageApi({ pageNum: 1, pageSize: 1000, status: '在库' })
  relicOptions.value = res.data.records || []
}

const openAdd = () => {
  // 设置默认的借展日期为当前日期时间
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  const seconds = String(now.getSeconds()).padStart(2, '0')
  const currentDateTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  
  Object.assign(form, { 
    relicId: null, 
    borrowerName: '', 
    borrowerUnit: '', 
    borrowerPhone: '', 
    loanDate: currentDateTime,  // 默认为当前日期时间
    expectedReturnDate: '', 
    purpose: '' 
  })
  dialogVisible.value = true
}

const viewDetail = (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
}

const submit = async () => {
  await formRef.value?.validate()
  await addLoanApi(form)
  ElMessage.success(t('message.saveSuccess'))
  dialogVisible.value = false
  loadData()
}

const approve = async (row, approved) => {
  await approveLoanApi({ 
    id: row.id, 
    approverName: localStorage.getItem('realName') || t('loan.defaultApprover'), 
    approveRemark: approved ? t('loan.approvePass') : t('loan.approveReject'), 
    approved 
  })
  ElMessage.success(t('loan.approveSuccess'))
  loadData()
}

const returnLoan = async (id) => {
  await returnLoanApi(id)
  ElMessage.success(t('loan.returnSuccess'))
  loadData()
}

const loadOverdue = async () => {
  const params = { pageNum: query.pageNum, pageSize: query.pageSize }
  const res = await getOverdueLoansApi(params)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

// 合并单元格方法：文物已删除的行，合并所有列
const objectSpanMethod = ({ row, column, rowIndex, columnIndex }) => {
  // 如果文物不存在（已删除），除了第一列（文物信息列）显示提示外，其他列都隐藏
  if (!row.relicName) {
    if (columnIndex === 0) {
      // 第一列（文物信息列）合并所有列
      return {
        rowspan: 1,
        colspan: 8 // 合并所有8列
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
