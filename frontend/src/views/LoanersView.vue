<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="query.realName" :placeholder="$t('loaner.realNamePlaceholder')" clearable style="width: 200px" @keyup.enter="loadData" />
        <el-select v-model="query.museumId" :placeholder="$t('loaner.museumPlaceholder')" clearable style="width: 200px">
          <el-option v-for="item in museumList" :key="item.id" :label="item.museumName" :value="item.id" />
        </el-select>
        <el-button type="primary" @click="search">{{ $t('common.search') }}</el-button>
        <el-button @click="resetSearch">{{ $t('common.reset') }}</el-button>
        <el-button type="success" @click="openAdd">{{ $t('loaner.addLoaner') }}</el-button>
        <el-button type="danger" :disabled="selectedIds.length === 0" @click="batchDelete">{{ $t('common.batchDelete') }}</el-button>
        <el-button type="warning" :disabled="selectedIds.length === 0" @click="batchUpdateStatus">{{ $t('common.batchUpdateStatus') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="username" :label="$t('user.username')" width="140" />
      <el-table-column prop="realName" :label="$t('user.realName')" width="120" />
      <el-table-column prop="museumName" :label="$t('user.museum')" width="180" />
      <el-table-column prop="phone" :label="$t('user.phone')" width="150" />
      <el-table-column prop="email" :label="$t('user.email')" min-width="180" show-overflow-tooltip />
      <el-table-column :label="$t('common.createTime')" width="170">
        <template #default="scope">
          {{ formatDateTime(scope.row.createTime) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.status')" width="90">
        <template #default="scope">
          {{ scope.row.status === 1 ? $t('common.enabled') : $t('common.disabled') }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('user.accountLocked')" width="100">
        <template #default="scope">
          <el-tag :type="scope.row.accountLocked === 1 ? 'danger' : 'success'" size="small">
            {{ scope.row.accountLocked === 1 ? $t('user.locked') : $t('user.unlocked') }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="220" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
          <el-button link type="primary" @click="openEdit(scope.row)">{{ $t('common.edit') }}</el-button>
          <el-button link type="danger" @click="remove(scope.row)">{{ $t('common.delete') }}</el-button>
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
      @current-change="handlePageChange"
    />

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? $t('employee.editEmployee') : $t('employee.addEmployee')" width="560px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px">
        <el-form-item :label="$t('user.username')" prop="username">
          <el-input v-model="form.username" />
        </el-form-item>
        <el-form-item :label="$t('user.password')" prop="password" :required="!form.id">
          <el-input 
            v-model="form.password" 
            type="password" 
            show-password 
            :placeholder="form.id ? $t('profile.passwordPlaceholder') : $t('profile.passwordInvalid')" 
          />
        </el-form-item>
        <el-form-item :label="$t('user.confirmPassword')" prop="confirmPassword" :required="!form.id">
          <el-input 
            v-model="form.confirmPassword" 
            type="password" 
            show-password 
            :placeholder="form.id ? $t('profile.confirmPasswordPlaceholder') : $t('profile.confirmPasswordRequired')" 
          />
        </el-form-item>
        <el-form-item :label="$t('user.realName')" prop="realName">
          <el-input v-model="form.realName" />
        </el-form-item>
        <el-form-item :label="$t('user.museum')" prop="museumId">
          <el-select v-model="form.museumId" :placeholder="$t('user.selectMuseum')" filterable style="width: 100%">
            <el-option
              v-for="museum in museumList"
              :key="museum.id"
              :label="museum.museumName"
              :value="museum.id"
            >
              <span style="float: left">{{ museum.museumName }}</span>
              <span style="float: right; color: var(--el-text-color-secondary); font-size: 13px">
                {{ museum.city }}
              </span>
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('user.phone')" prop="phone">
          <el-input v-model="form.phone" />
        </el-form-item>
        <el-form-item :label="$t('user.email')" prop="email">
          <el-input v-model="form.email" />
        </el-form-item>
        <el-form-item :label="$t('common.status')" prop="status">
          <el-select v-model="form.status" style="width: 100%">
            <el-option :label="$t('common.enabled')" :value="1" />
            <el-option :label="$t('common.disabled')" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('user.accountLocked')" prop="accountLocked">
          <el-select v-model="form.accountLocked" style="width: 100%">
            <el-option :label="$t('user.unlocked')" :value="0" />
            <el-option :label="$t('user.locked')" :value="1" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('employee.employeeDetail')" width="700px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('user.username')">{{ currentDetail.username }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.realName')">{{ currentDetail.realName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.role')">{{ currentDetail.roleName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.status')">
          <el-tag :type="currentDetail.status === 1 ? 'success' : 'info'">
            {{ currentDetail.status === 1 ? $t('common.enabled') : $t('common.disabled') }}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('user.museum')" :span="2">
          <el-tag type="warning" v-if="currentDetail.museumName">
            {{ currentDetail.museumName }}
          </el-tag>
          <span v-else>—</span>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('user.phone')">{{ currentDetail.phone || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.email')">{{ currentDetail.email || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.updateTime')">{{ formatDateTime(currentDetail.updateTime) || '—' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import { getUsersPageApi, getUserRolesApi, addUserApi, updateUserApi, deleteUserApi } from '../api/users'
import { getActiveMuseumsApi, getUserMuseumApi } from '../api/museums'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const allRoles = ref([])
const museumList = ref([])
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const currentUsername = localStorage.getItem('username') || ''
const selectedIds = ref([])
const query = reactive({ pageNum: 1, pageSize: 10, realName: '', museumId: null })
const form = reactive({ 
  id: null, 
  username: '', 
  password: '', 
  confirmPassword: '', 
  realName: '', 
  roleId: null, 
  museumId: null,
  phone: '', 
  email: '', 
  status: 1,
  accountLocked: 0
})

// 获取借展人角色ID
const loanerRole = computed(() => {
  return allRoles.value.find(role => role.roleCode === 'LOANER')
})

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ validator: validatePassword, trigger: 'blur' }],
  confirmPassword: [{ validator: validateConfirmPassword, trigger: 'blur' }],
  realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  museumId: [{ required: true, message: '请选择所属博物馆', trigger: 'change' }],
  phone: [
    { required: true, message: '请输入电话', trigger: 'blur' },
    { pattern: /^1\d{10}$/, message: '请输入正确的手机号码', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
  ],
  status: [{ required: true, message: '请选择状态', trigger: 'change' }]
}

function validatePassword(rule, value, callback) {
  if (!form.id && !value) {
    callback(new Error('请输入密码'))
    return
  }
  if (value) {
    if (value.length < 6 || value.length > 20) {
      callback(new Error('密码长度必须在6-20位之间'))
      return
    }
    if (!/[0-9]/.test(value)) {
      callback(new Error('密码必须包含数字'))
      return
    }
    if (!/[a-zA-Z]/.test(value)) {
      callback(new Error('密码必须包含字母'))
      return
    }
    if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
      callback(new Error('密码必须是6-20位字符，且包含数字和字母'))
      return
    }
  }
  callback()
}

function validateConfirmPassword(rule, value, callback) {
  if (!form.id && !value) {
    callback(new Error('请再次输入密码'))
    return
  }
  if (form.password && !value) {
    callback(new Error('请再次输入密码'))
    return
  }
  if (value && value !== form.password) {
    callback(new Error('两次输入的密码不一致'))
    return
  }
  callback()
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ')
}

const loadData = async () => {
  if (!loanerRole.value) {
    tableData.value = []
    total.value = 0
    return
  }
  
  // 搜索所有借展人
  const res = await getUsersPageApi({
    pageNum: 1,
    pageSize: 10000,
    realName: query.realName,
    roleId: loanerRole.value.id
  })
  
  const loaners = res.data.records || []
  
  // 加载每个借展人的博物馆信息
  const loanersWithMuseum = await Promise.all(
    loaners.map(async (loaner) => {
      try {
        const museumRes = await getUserMuseumApi(loaner.id)
        return {
          ...loaner,
          museumId: museumRes.data?.museumId,
          museumName: museumRes.data?.museumName
        }
      } catch (e) {
        console.error('加载用户博物馆失败:', loaner.id, e)
        return { ...loaner, museumId: null, museumName: null }
      }
    })
  )
  
  // 如果有博物馆筛选，进行过滤
  let filteredLoaners = loanersWithMuseum
  if (query.museumId) {
    filteredLoaners = loanersWithMuseum.filter(loaner => loaner.museumId === query.museumId)
  }
  
  // 手动分页
  total.value = filteredLoaners.length
  const start = (query.pageNum - 1) * query.pageSize
  const end = start + query.pageSize
  tableData.value = filteredLoaners.slice(start, end)
}

const loadRoles = async () => {
  const res = await getUserRolesApi()
  allRoles.value = res.data || []
}

const loadMuseums = async () => {
  try {
    const res = await getActiveMuseumsApi()
    museumList.value = res.data || []
  } catch (e) {
    ElMessage.error(t('common.loadMuseumListFailed'))
  }
}

const search = () => {
  query.pageNum = 1
  loadData()
}

const resetSearch = () => {
  Object.assign(query, { pageNum: 1, pageSize: 10, realName: '', museumId: null })
  loadData()
}

const handlePageChange = (page) => {
  query.pageNum = page
  loadData()
}

const resetForm = () => {
  Object.assign(form, { 
    id: null, 
    username: '', 
    password: '', 
    confirmPassword: '', 
    realName: '', 
    roleId: loanerRole.value?.id || null, 
    museumId: null,
    phone: '', 
    email: '', 
    status: 1,
    accountLocked: 0 
  })
  formRef.value?.clearValidate()
}

const openAdd = () => {
  resetForm()
  dialogVisible.value = true
}

const openEdit = async (row) => {
  Object.assign(form, {
    id: row.id,
    username: row.username,
    password: '',
    confirmPassword: '',
    realName: row.realName,
    roleId: loanerRole.value?.id || null,
    phone: row.phone,
    email: row.email,
    status: row.status,
    accountLocked: row.accountLocked !== undefined ? row.accountLocked : 0,
    museumId: null
  })
  
  // 加载关联的博物馆
  try {
    const res = await getUserMuseumApi(row.id)
    if (res.data && res.data.museumId) {
      form.museumId = res.data.museumId
    }
  } catch (e) {
    console.error('加载用户博物馆失败:', e)
  }
  
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

const viewDetail = async (row) => {
  // 加载完整的详情信息，包括博物馆
  try {
    const res = await getUserMuseumApi(row.id)
    currentDetail.value = {
      ...row,
      museumId: res.data?.museumId,
      museumName: res.data?.museumName
    }
  } catch (e) {
    currentDetail.value = row
  }
  detailDialogVisible.value = true
}

const submit = async () => {
  await formRef.value.validate()
  if (form.id) {
    await updateUserApi(form)
    ElMessage.success(t('common.updateSuccess'))
  } else {
    await addUserApi(form)
    ElMessage.success(t('common.addSuccess'))
  }
  dialogVisible.value = false
  loadData()
}

const remove = async (row) => {
  if (row.username === currentUsername) {
    ElMessage.warning(t('common.cannotDeleteSelf'))
    return
  }
  await ElMessageBox.confirm(t('loaner.deleteConfirm'), t('common.warning'), { type: 'warning' })
  await deleteUserApi(row.id)
  ElMessage.success(t('common.deleteSuccess'))
  loadData()
}

const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.id)
}

const batchDelete = async () => {
  // 检查是否包含当前登录用户
  const currentUser = tableData.value.find(item => 
    selectedIds.value.includes(item.id) && item.username === currentUsername
  )
  if (currentUser) {
    ElMessage.warning(t('common.cannotDeleteSelf'))
    return
  }

  await ElMessageBox.confirm(t('loaner.batchDeleteConfirm', { count: selectedIds.value.length }), t('common.warning'), { type: 'warning' })
  
  try {
    await Promise.all(selectedIds.value.map(id => deleteUserApi(id)))
    ElMessage.success(t('common.batchDeleteSuccess'))
    selectedIds.value = []
    loadData()
  } catch (e) {
    ElMessage.error(t('common.batchDeleteFailed'))
  }
}

const batchUpdateStatus = async () => {
  await ElMessageBox.prompt(t('loaner.selectStatus'), t('loaner.batchUpdateStatusTitle'), {
    confirmButtonText: t('common.confirm'),
    cancelButtonText: t('common.cancel'),
    inputType: 'select',
    inputOptions: [
      { label: t('common.enable'), value: 1 },
      { label: t('common.disable'), value: 2 }
    ],
    inputValidator: (value) => {
      return value !== null && value !== ''
    },
    inputErrorMessage: t('loaner.selectStatusError')
  }).then(async ({ value }) => {
    const status = parseInt(value)
    try {
      const updates = selectedIds.value.map(id => {
        const user = tableData.value.find(item => item.id === id)
        return updateUserApi({ ...user, status })
      })
      await Promise.all(updates)
      ElMessage.success(t('common.batchUpdateStatusSuccess'))
      selectedIds.value = []
      loadData()
    } catch (e) {
      ElMessage.error(t('common.batchUpdateStatusFailed'))
    }
  }).catch(() => {})
}

onMounted(async () => {
  await loadRoles()
  await loadMuseums()
  await loadData()
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
