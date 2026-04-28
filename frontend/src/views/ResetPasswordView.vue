<template>
  <div class="reset-password-page">
    <div class="reset-password-panel">
      <div class="title-wrap">
        <div class="seal">藏</div>
        <h1>重置密码</h1>
        <p>请输入验证码和新密码</p>
      </div>

      <el-form :model="form" :rules="rules" ref="formRef" class="reset-password-form">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="用户名" disabled />
        </el-form-item>
        
        <el-form-item prop="code">
          <el-input v-model="form.code" placeholder="请输入6位验证码" maxlength="6" />
        </el-form-item>
        
        <el-form-item prop="newPassword">
          <el-input 
            v-model="form.newPassword" 
            type="password" 
            placeholder="请输入新密码" 
            show-password 
          />
        </el-form-item>
        
        <el-form-item prop="confirmPassword">
          <el-input 
            v-model="form.confirmPassword" 
            type="password" 
            placeholder="请再次输入新密码" 
            show-password 
          />
        </el-form-item>
        
        <el-button 
          type="primary" 
          class="submit-btn" 
          @click="handleResetPassword"
          :loading="loading"
        >
          重置密码
        </el-button>
        
        <div class="back-link">
          <el-button type="text" @click="goToForgotPassword">重新发送验证码</el-button>
          <el-button type="text" @click="goToLogin">返回登录</el-button>
        </div>
      </el-form>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useI18n } from 'vue-i18n'
import { useRouter, useRoute } from 'vue-router'
import { resetPasswordApi } from '../api/auth'

const router = useRouter()
const route = useRoute()
const { t } = useI18n()
const formRef = ref(null)
const loading = ref(false)

// 获取来源页面（from参数）
const fromPage = ref(route.query.from || 'admin') // 默认为后台

const form = reactive({
  username: '',
  code: '',
  newPassword: '',
  confirmPassword: ''
})

const validatePassword = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请输入新密码'))
  } else if (value.length < 6) {
    callback(new Error('密码长度不能少于6位'))
  } else {
    if (form.confirmPassword !== '') {
      formRef.value.validateField('confirmPassword')
    }
    callback()
  }
}

const validateConfirmPassword = (rule, value, callback) => {
  if (value === '') {
    callback(new Error('请再次输入新密码'))
  } else if (value !== form.newPassword) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [
    { required: true, message: '用户名不能为空', trigger: 'blur' }
  ],
  code: [
    { required: true, message: '请输入验证码', trigger: 'blur' },
    { pattern: /^\d{6}$/, message: '请输入6位数字验证码', trigger: 'blur' }
  ],
  newPassword: [
    { required: true, validator: validatePassword, trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

onMounted(() => {
  // 从路由参数获取用户名和来源
  const username = route.query.username
  const from = route.query.from
  
  if (username) {
    form.username = username
  } else {
    ElMessage.warning(t('common.pleaseSendCodeFirst'))
    router.push({
      path: '/forgot-password',
      query: { from: fromPage.value }
    })
  }
  
  if (from) {
    fromPage.value = from
  }
})

const handleResetPassword = async () => {
  try {
    await formRef.value.validate()
    loading.value = true
    
    const res = await resetPasswordApi(form)
    ElMessage.success(res.message || '密码重置成功，请使用新密码登录')
    
    // 根据来源跳转到对应的登录页面
    setTimeout(() => {
      if (fromPage.value === 'portal') {
        router.push('/portal-login')
      } else {
        router.push('/login')
      }
    }, 1500)
  } catch (error) {
    if (error?.response?.data?.message) {
      ElMessage.error(error.response.data.message)
    } else if (error !== false) {
      ElMessage.error(t('common.resetPasswordFailed'))
    }
  } finally {
    loading.value = false
  }
}

const goToForgotPassword = () => {
  router.push({
    path: '/forgot-password',
    query: { from: fromPage.value }  // 传递来源
  })
}

const goToLogin = () => {
  // 根据来源跳转到对应的登录页面
  if (fromPage.value === 'portal') {
    router.push('/portal-login')
  } else {
    router.push('/login')
  }
}
</script>

<style scoped>
.reset-password-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 24px;
  background:
    radial-gradient(circle at 12% 15%, rgba(181, 136, 82, 0.16), transparent 32%),
    radial-gradient(circle at 86% 82%, rgba(128, 95, 60, 0.14), transparent 30%),
    #f4f1eb;
}

.reset-password-panel {
  width: 430px;
  padding: 30px 28px 26px;
  border-radius: 16px;
  background: rgba(255, 253, 248, 0.96);
  border: 1px solid #eadfce;
  box-shadow: 0 20px 50px rgba(76, 58, 38, 0.12);
}

.title-wrap {
  text-align: center;
  margin-bottom: 24px;
}

.seal {
  width: 44px;
  height: 44px;
  margin: 0 auto 10px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #8a5b2f;
  color: #fff7ea;
  font-size: 22px;
  font-weight: 700;
}

h1 {
  font-size: 22px;
  margin: 0;
  color: #2f2a24;
}

p {
  margin: 8px 0 0;
  color: #7a6c5b;
  font-size: 13px;
}

.reset-password-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.reset-password-form :deep(.el-input__wrapper) {
  box-shadow: 0 0 0 1px #e6d8c4 inset;
}

.reset-password-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #8a5b2f inset;
}

.submit-btn {
  width: 100%;
  margin-top: 4px;
  height: 40px;
  letter-spacing: 1px;
}

.back-link {
  margin-top: 16px;
  text-align: center;
  display: flex;
  justify-content: center;
  gap: 16px;
}

.back-link :deep(.el-button) {
  color: #8a5b2f;
}
</style>
