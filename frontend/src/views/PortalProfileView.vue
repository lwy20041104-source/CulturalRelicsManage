<template>
  <div class="portal-profile-page">
    <el-card class="profile-card">
      <template #header>
        <div class="card-header">
          <span class="header-title">
            <el-icon><User /></el-icon>
            {{ $t('profile.title') }}
          </span>
          <el-button @click="goBack">
            <el-icon><ArrowLeft /></el-icon>
            {{ $t('profile.back') }}
          </el-button>
        </div>
      </template>

      <div class="profile-container">
        <!-- 个人信息展示 -->
        <div v-if="!isEditing" class="profile-display">
          <el-descriptions :column="2" border>
            <el-descriptions-item :label="$t('profile.username')">
              <el-tag>{{ profile.username }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.realName')">
              {{ profile.realName || '—' }}
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.role')">
              <el-tag type="success">{{ profile.roleName }}</el-tag>
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.status')">
              <el-tag :type="profile.status === 1 ? 'success' : 'info'">
                {{ profile.status === 1 ? $t('profile.enabled') : $t('profile.disabled') }}
              </el-tag>
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.museum')" :span="2">
              <el-tag type="warning" v-if="profile.museumName">
                <el-icon><OfficeBuilding /></el-icon>
                {{ profile.museumName }}
              </el-tag>
              <span v-else>—</span>
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.email')">
              {{ profile.email || '—' }}
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.phone')">
              {{ profile.phone || '—' }}
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.createTime')">
              {{ formatDateTime(profile.createTime) }}
            </el-descriptions-item>
            <el-descriptions-item :label="$t('profile.updateTime')">
              {{ formatDateTime(profile.updateTime) }}
            </el-descriptions-item>
          </el-descriptions>

          <div class="action-buttons">
            <el-button type="primary" @click="startEdit">
              <el-icon><Edit /></el-icon>
              {{ $t('profile.editProfile') }}
            </el-button>
          </div>
        </div>

        <!-- 个人信息编辑 -->
        <div v-else class="profile-edit">
          <el-form 
            ref="formRef" 
            :model="editForm" 
            :rules="rules" 
            label-width="120px"
            class="edit-form"
          >
            <el-form-item :label="$t('profile.username')" prop="username">
              <el-input v-model="editForm.username" :placeholder="$t('profile.usernamePlaceholder')" />
              <div class="form-tip">{{ $t('profile.usernameTip') }}</div>
            </el-form-item>

            <el-form-item :label="$t('profile.realName')">
              <el-input v-model="profile.realName" disabled />
              <div class="form-tip">{{ $t('profile.realNameTip') }}</div>
            </el-form-item>

            <el-form-item :label="$t('profile.role')">
              <el-input v-model="profile.roleName" disabled />
              <div class="form-tip">{{ $t('profile.roleTip') }}</div>
            </el-form-item>

            <el-form-item :label="$t('profile.museum')" prop="museumId">
              <el-select 
                v-model="editForm.museumId" 
                :placeholder="$t('profile.selectMuseum')"
                filterable
                style="width: 100%"
              >
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

            <el-form-item :label="$t('profile.email')" prop="email">
              <el-input v-model="editForm.email" :placeholder="$t('profile.emailPlaceholder')" />
            </el-form-item>

            <el-form-item :label="$t('profile.phone')" prop="phone">
              <el-input v-model="editForm.phone" :placeholder="$t('profile.phonePlaceholder')" maxlength="11" />
            </el-form-item>

            <el-form-item :label="$t('profile.changePassword')" prop="password">
              <el-input 
                v-model="editForm.password" 
                type="password" 
                show-password 
                :placeholder="$t('profile.passwordPlaceholder')" 
              />
            </el-form-item>

            <el-form-item :label="$t('profile.confirmPassword')" prop="confirmPassword">
              <el-input 
                v-model="editForm.confirmPassword" 
                type="password" 
                show-password 
                :placeholder="$t('profile.confirmPasswordPlaceholder')" 
              />
            </el-form-item>

            <el-form-item>
              <el-button type="primary" @click="submitEdit" :loading="loading">
                <el-icon><Check /></el-icon>
                {{ $t('profile.saveChanges') }}
              </el-button>
              <el-button @click="cancelEdit">
                <el-icon><Close /></el-icon>
                {{ $t('profile.cancel') }}
              </el-button>
            </el-form-item>
          </el-form>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { User, Edit, Check, Close, OfficeBuilding, ArrowLeft } from '@element-plus/icons-vue'
import { getProfileApi, updateProfileApi } from '../api/users'
import { getActiveMuseumsApi } from '../api/museums'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'

const router = useRouter()
const { t } = useI18n()
const profile = ref({})
const museumList = ref([])
const isEditing = ref(false)
const loading = ref(false)
const formRef = ref(null)

const editForm = reactive({
  username: '',
  email: '',
  phone: '',
  museumId: null,
  password: '',
  confirmPassword: ''
})

// 验证规则
const validateUsername = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('profile.usernameRequired')))
  } else if (/\s/.test(value)) {
    callback(new Error(t('profile.usernameNoSpace')))
  } else {
    callback()
  }
}

const validateEmail = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('profile.emailRequired')))
  } else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) {
    callback(new Error(t('profile.emailInvalid')))
  } else {
    callback()
  }
}

const validatePhone = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('profile.phoneRequired')))
  } else if (!/^1\d{10}$/.test(value)) {
    callback(new Error(t('profile.phoneInvalid')))
  } else {
    callback()
  }
}

const validateMuseumId = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('profile.museumRequired')))
  } else {
    callback()
  }
}

const validatePassword = (rule, value, callback) => {
  // 如果填写了密码，需要验证
  if (value) {
    if (value.length < 6 || value.length > 20) {
      callback(new Error(t('profile.passwordLength')))
      return
    }
    if (!/[0-9]/.test(value)) {
      callback(new Error(t('profile.passwordNeedNumber')))
      return
    }
    if (!/[a-zA-Z]/.test(value)) {
      callback(new Error(t('profile.passwordNeedLetter')))
      return
    }
    if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
      callback(new Error(t('profile.passwordInvalid')))
      return
    }
  }
  callback()
}

const validateConfirmPassword = (rule, value, callback) => {
  // 如果填写了密码，确认密码也必须填写
  if (editForm.password && !value) {
    callback(new Error(t('profile.confirmPasswordRequired')))
    return
  }
  // 两次密码必须一致
  if (value && value !== editForm.password) {
    callback(new Error(t('profile.passwordNotMatch')))
    return
  }
  callback()
}

const rules = {
  username: [{ required: true, validator: validateUsername, trigger: 'blur' }],
  email: [{ required: true, validator: validateEmail, trigger: 'blur' }],
  phone: [{ required: true, validator: validatePhone, trigger: 'blur' }],
  museumId: [{ required: true, validator: validateMuseumId, trigger: 'change' }],
  password: [{ validator: validatePassword, trigger: 'blur' }],
  confirmPassword: [{ validator: validateConfirmPassword, trigger: 'blur' }]
}

const formatDateTime = (value) => {
  if (!value) return '—'
  return String(value).replace('T', ' ')
}

const goBack = () => {
  router.push('/portal')
}

const loadProfile = async () => {
  try {
    const res = await getProfileApi()
    if (res.code === 200) {
      profile.value = res.data
    } else {
      ElMessage.error(res.message || t('profile.loadFailed'))
    }
  } catch (e) {
    ElMessage.error(t('profile.loadFailed'))
  }
}

const loadMuseums = async () => {
  try {
    const res = await getActiveMuseumsApi()
    museumList.value = res.data || []
  } catch (e) {
    ElMessage.error(t('profile.loadMuseumsFailed'))
  }
}

const startEdit = () => {
  // 复制当前信息到编辑表单
  editForm.username = profile.value.username
  editForm.email = profile.value.email
  editForm.phone = profile.value.phone
  editForm.museumId = profile.value.museumId
  editForm.password = ''
  editForm.confirmPassword = ''
  
  isEditing.value = true
}

const cancelEdit = () => {
  isEditing.value = false
  formRef.value?.clearValidate()
}

const submitEdit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      // 构建更新数据
      const updateData = {
        username: editForm.username,
        email: editForm.email,
        phone: editForm.phone,
        museumId: editForm.museumId
      }
      
      // 如果修改了密码，添加密码字段
      if (editForm.password) {
        updateData.password = editForm.password
      }
      
      const res = await updateProfileApi(updateData)
      
      if (res.code === 200) {
        ElMessage.success(t('profile.updateSuccess'))
        
        // 如果修改了用户名，需要更新localStorage
        if (editForm.username !== profile.value.username) {
          localStorage.setItem('username', editForm.username)
        }
        
        isEditing.value = false
        await loadProfile()
      } else {
        ElMessage.error(res.message || t('profile.updateFailed'))
      }
    } catch (e) {
      const msg = e?.response?.data?.message || e?.message || t('profile.updateFailed')
      ElMessage.error(msg)
    } finally {
      loading.value = false
    }
  })
}

onMounted(async () => {
  await Promise.all([loadProfile(), loadMuseums()])
})
</script>

<style scoped>
.portal-profile-page {
  min-height: 100vh;
  padding: 40px 20px;
  background: linear-gradient(135deg, rgba(139, 91, 47, 0.05) 0%, rgba(181, 136, 82, 0.08) 100%);
}

.profile-card {
  max-width: 900px;
  margin: 0 auto;
  border-radius: 14px;
  box-shadow: 0 4px 20px rgba(139, 91, 47, 0.1);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: #2f2a24;
}

.profile-container {
  padding: 20px;
}

.profile-display {
  animation: fadeIn 0.3s ease;
}

.action-buttons {
  margin-top: 30px;
  text-align: center;
}

.profile-edit {
  animation: fadeIn 0.3s ease;
}

.edit-form {
  max-width: 600px;
  margin: 0 auto;
}

.form-tip {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

:deep(.el-descriptions) {
  margin-bottom: 20px;
}

:deep(.el-descriptions__label) {
  color: #5f4f3d;
  font-weight: 500;
}

:deep(.el-descriptions__content) {
  color: #4f4235;
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

:deep(.el-input.is-disabled .el-input__wrapper) {
  background-color: #f5f5f5;
}

:deep(.el-button--primary) {
  background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%);
  border: none;
}

:deep(.el-button--primary:hover) {
  background: linear-gradient(135deg, #c69563 0%, #9b6a3a 100%);
}
</style>
