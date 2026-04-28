<template>
  <div class="forgot-password-page">
    <div class="forgot-password-panel">
      <div class="title-wrap">
        <div class="seal">藏</div>
        <h1>忘记密码</h1>
        <p>通过邮箱或手机号重置密码</p>
      </div>

      <el-form :model="form" :rules="rules" ref="formRef" class="forgot-password-form">
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" />
        </el-form-item>
        
        <el-form-item prop="verificationType">
          <el-select v-model="form.verificationType" placeholder="请选择验证方式" style="width: 100%">
            <el-option label="邮箱验证" value="EMAIL" />
            <el-option label="手机验证" value="PHONE" />
          </el-select>
        </el-form-item>
        
        <el-form-item v-if="form.verificationType === 'EMAIL'" prop="email">
          <el-input v-model="form.email" placeholder="请输入绑定的邮箱地址" />
        </el-form-item>
        
        <el-form-item v-if="form.verificationType === 'PHONE'" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入绑定的手机号" maxlength="11" />
        </el-form-item>
        
        <el-button 
          type="primary" 
          class="submit-btn" 
          @click="handleSendCode"
          :loading="loading"
        >
          发送验证码
        </el-button>
        
        <div class="back-link">
          <el-button type="text" @click="goBack">返回登录</el-button>
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
import { forgotPasswordApi } from '../api/auth'

const router = useRouter()
const route = useRoute()
const { t } = useI18n()
const formRef = ref(null)
const loading = ref(false)

// 获取来源页面（from参数）
const fromPage = ref(route.query.from || 'admin') // 默认为后台

const form = reactive({
  username: '',
  verificationType: '',
  email: '',
  phone: ''
})

const rules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' }
  ],
  verificationType: [
    { required: true, message: '请选择验证方式', trigger: 'change' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { required: true, message: '请输入手机号', trigger: 'blur' },
    { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号格式', trigger: 'blur' }
  ]
}

const handleSendCode = async () => {
  try {
    await formRef.value.validate()
    loading.value = true
    
    const res = await forgotPasswordApi(form)
    ElMessage.success(res.message || '验证码已发送')
    
    // 跳转到重置密码页面，传递用户名和来源
    router.push({
      path: '/reset-password',
      query: { 
        username: form.username,
        from: fromPage.value  // 传递来源
      }
    })
  } catch (error) {
    if (error?.response?.data?.message) {
      ElMessage.error(error.response.data.message)
    } else if (error !== false) { // 表单验证失败时不显示错误
      ElMessage.error(t('common.sendCodeFailed'))
    }
  } finally {
    loading.value = false
  }
}

const goBack = () => {
  // 根据来源跳转到对应的登录页面
  if (fromPage.value === 'portal') {
    router.push('/portal-login')
  } else {
    router.push('/login')
  }
}
</script>

<style scoped>
.forgot-password-page {
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

.forgot-password-panel {
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

.forgot-password-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.forgot-password-form :deep(.el-input__wrapper),
.forgot-password-form :deep(.el-select__wrapper) {
  box-shadow: 0 0 0 1px #e6d8c4 inset;
}

.forgot-password-form :deep(.el-input__wrapper.is-focus),
.forgot-password-form :deep(.el-select__wrapper.is-focused) {
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
}

.back-link :deep(.el-button) {
  color: #8a5b2f;
}
</style>
