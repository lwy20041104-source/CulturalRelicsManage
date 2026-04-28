<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="query.realName" :placeholder="$t('user.realName')" clearable style="width: 200px" @keyup.enter="loadData" />
        <el-select v-model="query.roleId" :placeholder="$t('user.role')" clearable style="width: 180px">
          <el-option v-for="item in roleOptions" :key="item.id" :label="item.roleName" :value="item.id" />
        </el-select>
        <el-button type="primary" @click="search">{{ $t('common.search') }}</el-button>
        <el-button @click="resetSearch">{{ $t('common.reset') }}</el-button>
        <el-button type="success" @click="openAdd">{{ $t('user.addUser') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border>
      <el-table-column prop="username" :label="$t('user.username')" width="140" />
      <el-table-column prop="realName" :label="$t('user.realName')" width="120" />
      <el-table-column prop="roleName" :label="$t('user.role')" width="140" />
      <el-table-column prop="phone" :label="$t('user.phone')" width="150" />
      <el-table-column prop="email" :label="$t('user.email')" min-width="180" show-overflow-tooltip />
      <el-table-column :label="$t('common.createTime')" width="170">
        <template #default="scope">
          {{ formatDateTime(scope.row.createTime) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.updateTime')" width="170">
        <template #default="scope">
          {{ formatDateTime(scope.row.updateTime) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('user.status')" width="90">
        <template #default="scope">
          {{ scope.row.status === 1 ? $t('user.active') : $t('user.inactive') }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="220">
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
      @current-change="(p) => { query.pageNum = p; loadData(); }"
    />

    <el-dialog v-model="dialogVisible" :title="form.id ? $t('user.editUser') : $t('user.addUser')" width="560px" class="form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px" class="dialog-form">
        <el-form-item :label="$t('user.username')" prop="username"><el-input v-model="form.username" /></el-form-item>
        <el-form-item :label="$t('user.password')" prop="password" :required="!form.id">
          <el-input 
            v-model="form.password" 
            type="password" 
            show-password 
            :placeholder="form.id ? $t('profile.passwordPlaceholder') : $t('profile.passwordPlaceholder')" 
          />
        </el-form-item>
        <el-form-item :label="$t('user.confirmPassword')" prop="confirmPassword" :required="!form.id">
          <el-input 
            v-model="form.confirmPassword" 
            type="password" 
            show-password 
            :placeholder="form.id ? $t('profile.confirmPasswordPlaceholder') : $t('profile.confirmPasswordPlaceholder')" 
          />
        </el-form-item>
        <el-form-item :label="$t('user.realName')" prop="realName"><el-input v-model="form.realName" /></el-form-item>
        <el-form-item :label="$t('user.role')" prop="roleId">
          <el-select v-model="form.roleId" :placeholder="$t('common.pleaseSelect')" style="width: 100%" @change="handleRoleChange">
            <el-option v-for="item in roleOptions" :key="item.id" :label="item.roleName" :value="item.id" />
          </el-select>
        </el-form-item>
        <!-- 借展人角色时显示博物馆选择 -->
        <el-form-item v-if="isLoanerRole" :label="$t('user.museum')" prop="museumId" required>
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
        <el-form-item :label="$t('user.phone')" prop="phone"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item :label="$t('user.email')" prop="email"><el-input v-model="form.email" /></el-form-item>
        <el-form-item :label="$t('user.status')" prop="status">
          <el-select v-model="form.status" style="width: 100%">
            <el-option :label="$t('user.active')" :value="1" />
            <el-option :label="$t('user.inactive')" :value="2" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('common.detail')" width="700px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('user.username')">{{ currentDetail.username }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.realName')">{{ currentDetail.realName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.role')">{{ currentDetail.roleName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('user.status')">
          <el-tag :type="currentDetail.status === 1 ? 'success' : 'info'">
            {{ currentDetail.status === 1 ? $t('user.active') : $t('user.inactive') }}
          </el-tag>
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
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUsersPageApi, getUserRolesApi, addUserApi, updateUserApi, deleteUserApi } from '../api/users'
import { getActiveMuseumsApi, getUserMuseumApi } from '../api/museums'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const roleOptions = ref([])
const museumList = ref([])
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const currentUsername = localStorage.getItem('username') || ''
const query = reactive({ pageNum: 1, pageSize: 10, realName: '', roleId: null })
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
  status: 1 
})

// 判断是否为借展人角色
const isLoanerRole = computed(() => {
  if (!form.roleId || !roleOptions.value.length) return false
  const selectedRole = roleOptions.value.find(r => r.id === form.roleId)
  return selectedRole && selectedRole.roleCode === 'LOANER'
})

const rules = {
  username: [{ required: true, message: t('validation.required'), trigger: 'blur' }, { validator: validateUsername, trigger: 'blur' }],
  password: [{ validator: validatePassword, trigger: 'blur' }],
  confirmPassword: [{ validator: validateConfirmPassword, trigger: 'blur' }],
  realName: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  roleId: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  museumId: [{ validator: validateMuseumId, trigger: 'change' }],
  phone: [{ required: true, message: t('validation.required'), trigger: 'blur' }, { validator: validatePhone, trigger: 'blur' }],
  email: [{ required: true, message: t('validation.required'), trigger: 'blur' }, { validator: validateEmail, trigger: 'blur' }],
  status: [{ required: true, message: t('validation.required'), trigger: 'change' }]
}

function validateMuseumId(rule, value, callback) {
  // 新增用户时，如果是借展人角色，博物馆为必填
  if (!form.id && isLoanerRole.value && !value) {
    callback(new Error(t('user.museumRequired')))
    return
  }
  // 编辑用户时，如果是借展人角色，博物馆为必填
  if (form.id && isLoanerRole.value && !value) {
    callback(new Error(t('user.museumRequired')))
    return
  }
  callback()
}

function validateUsername(rule, value, callback) {
  if (!value) {
    callback()
    return
  }
  if (/\s/.test(String(value))) {
    callback(new Error(t('validation.required')))
    return
  }
  callback()
}

function validatePassword(rule, value, callback) {
  // 新增用户时，密码为必填
  if (!form.id && !value) {
    callback(new Error(t('validation.required')))
    return
  }
  // 编辑用户时，如果填写了密码，需要验证
  if (value) {
    // 检查长度
    if (String(value).length < 6) {
      callback(new Error(t('profile.passwordLength')))
      return
    }
    if (String(value).length > 20) {
      callback(new Error(t('profile.passwordLength')))
      return
    }
    // 检查是否包含数字
    if (!/[0-9]/.test(value)) {
      callback(new Error(t('profile.passwordNeedNumber')))
      return
    }
    // 检查是否包含字母
    if (!/[a-zA-Z]/.test(value)) {
      callback(new Error(t('profile.passwordNeedLetter')))
      return
    }
    // 完整验证
    if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
      callback(new Error(t('profile.passwordInvalid')))
      return
    }
  }
  callback()
}

function validateConfirmPassword(rule, value, callback) {
  // 新增用户时，确认密码为必填
  if (!form.id && !value) {
    callback(new Error(t('validation.required')))
    return
  }
  // 如果填写了密码，确认密码也必须填写
  if (form.password && !value) {
    callback(new Error(t('validation.required')))
    return
  }
  // 如果填写了确认密码但没填密码，提示先填密码
  if (!form.password && value) {
    callback(new Error(t('user.pleaseInputPasswordFirst')))
    return
  }
  // 两次密码必须一致
  if (value && value !== form.password) {
    callback(new Error(t('user.passwordNotMatch')))
    return
  }
  callback()
}

function validatePhone(rule, value, callback) {
  if (!value) {
    callback()
    return
  }
  if (!/^1\d{10}$/.test(String(value).trim())) {
    callback(new Error(t('validation.invalidPhone')))
    return
  }
  callback()
}

function validateEmail(rule, value, callback) {
  if (!value) {
    callback()
    return
  }
  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(value).trim())) {
    callback(new Error(t('validation.invalidEmail')))
    return
  }
  callback()
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ')
}

const loadData = async () => {
  const res = await getUsersPageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

const loadRoles = async () => {
  const res = await getUserRolesApi()
  roleOptions.value = res.data || []
}

const search = () => {
  query.pageNum = 1
  loadData()
}

const resetSearch = () => {
  Object.assign(query, { pageNum: 1, pageSize: 10, realName: '', roleId: null })
  loadData()
}

const resetForm = () => {
  Object.assign(form, { id: null, username: '', password: '', confirmPassword: '', realName: '', roleId: null, phone: '', email: '', status: 1 })
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
    roleId: row.roleId,
    phone: row.phone,
    email: row.email,
    status: row.status,
    museumId: null
  })
  
  // 如果是借展人角色，加载关联的博物馆
  const selectedRole = roleOptions.value.find(r => r.id === row.roleId)
  if (selectedRole && selectedRole.roleCode === 'LOANER') {
    try {
      const res = await getUserMuseumApi(row.id)
      if (res.data && res.data.museumId) {
        form.museumId = res.data.museumId
      }
    } catch (e) {
      console.error(t('message.loadFailed'), e)
    }
  }
  
  formRef.value?.clearValidate()
  dialogVisible.value = true
}

const viewDetail = (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
}

const submit = async () => {
  await formRef.value.validate()
  if (form.id) {
    await updateUserApi(form)
    ElMessage.success(t('message.updateSuccess'))
  } else {
    await addUserApi(form)
    ElMessage.success(t('message.saveSuccess'))
  }
  dialogVisible.value = false
  loadData()
}

const remove = async (row) => {
  if (row.username === currentUsername) {
    ElMessage.warning(t('message.operationFailed'))
    return
  }
  await ElMessageBox.confirm(t('message.confirmDelete'), t('message.warning'), { type: 'warning' })
  await deleteUserApi(row.id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}

onMounted(async () => {
  await Promise.all([loadRoles(), loadMuseums(), loadData()])
})

async function loadMuseums() {
  try {
    const res = await getActiveMuseumsApi()
    museumList.value = res.data || []
  } catch (e) {
    ElMessage.error(t('message.loadFailed'))
  }
}

function handleRoleChange() {
  // 如果切换到非借展人角色，清空博物馆选择
  if (!isLoanerRole.value) {
    form.museumId = null
  }
}
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
