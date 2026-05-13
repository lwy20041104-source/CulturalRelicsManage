<template>
  <div class="login-page">
    <div class="login-panel">
      <div class="title-wrap">
        <div class="seal">藏</div>
        <h1>{{ $t('login.title') }}</h1>
        <p>{{ $t('login.subtitle') }}</p>
      </div>
      
      <!-- 隐藏前台入口提示 -->
      <!-- <div class="portal-tip">
        <el-alert
          :title="$t('login.portalTip')"
          type="info"
          :closable="false"
          show-icon
        >
          <template #default>
            <span>{{ $t('login.portalDesc') }}</span>
            <el-button type="primary" text size="small" @click="goToPortalLogin">
              {{ $t('login.goToPortal') }} →
            </el-button>
          </template>
        </el-alert>
      </div> -->

      <el-form :model="form" @keyup.enter="handleLogin" class="login-form">
        <el-form-item>
          <el-input v-model="form.username" :placeholder="$t('login.usernamePlaceholder')" />
        </el-form-item>
        <el-form-item>
          <el-input v-model="form.password" type="password" :placeholder="$t('login.passwordPlaceholder')" show-password />
        </el-form-item>
        <el-form-item>
          <el-select v-model="form.roleCode" :placeholder="$t('common.pleaseSelect')" style="width: 100%">
            <el-option :label="$t('user.admin')" value="ADMIN" />
            <el-option :label="$t('user.curator')" value="CURATOR" />
            <el-option :label="$t('user.approver')" value="APPROVER" />
          </el-select>
        </el-form-item>
        <el-button type="primary" class="login-btn" @click="handleLogin">{{ $t('login.login') }}</el-button>
        
        <div class="forgot-password-link">
          <el-button type="text" @click="goToForgotPassword">忘记密码？</el-button>
        </div>
      </el-form>
      
      <!-- 语言切换器 -->
      <div class="language-switcher-wrapper">
        <LanguageSwitcher />
      </div>
    </div>
  </div>
</template>

<script setup>
import { onMounted, reactive } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { loginApi, getPermissionsApi } from '../api/auth'
import LanguageSwitcher from '../components/LanguageSwitcher.vue'

const router = useRouter()
const { t } = useI18n()
const form = reactive({ username: '', password: '', roleCode: '' })

onMounted(() => {
  sessionStorage.removeItem('token')
  sessionStorage.removeItem('permissions')
  sessionStorage.removeItem('username')
  sessionStorage.removeItem('realName')
  sessionStorage.removeItem('role')
})

const handleLogin = async () => {
  try {
    const res = await loginApi(form)
    sessionStorage.setItem('token', res.data.token)
    sessionStorage.setItem('username', res.data.username)
    sessionStorage.setItem('realName', res.data.realName || '')
    sessionStorage.setItem('phone', res.data.phone || '')
    sessionStorage.setItem('role', form.roleCode)

    const permsRes = await getPermissionsApi(res.data.username)
    sessionStorage.setItem('permissions', JSON.stringify(permsRes.data || []))

    ElMessage.success(t('login.loginSuccess'))
    router.push('/dashboard')
  } catch (e) {
    console.log('登录错误对象:', e)
    console.log('错误响应:', e?.response)
    console.log('错误数据:', e?.response?.data)
    console.log('错误消息:', e?.response?.data?.message)
    
    // 尝试多种方式获取错误信息
    let msg = e?.response?.data?.message 
           || e?.message 
           || e?.data?.message
           || t('login.loginFailed')
    
    console.log('最终显示的消息:', msg)
    ElMessage.error(msg)
  }
}

/* 隐藏前台入口跳转函数 */
/*
const goToPortalLogin = () => {
  router.push('/portal-login')
}
*/

const goToForgotPassword = () => {
  router.push({ path: '/forgot-password', query: { from: 'admin' } })
}
</script>

<style scoped>
.login-page {
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

.login-panel {
  width: 430px;
  padding: 30px 28px 26px;
  border-radius: 16px;
  background: rgba(255, 253, 248, 0.96);
  border: 1px solid #eadfce;
  box-shadow: 0 20px 50px rgba(76, 58, 38, 0.12);
}

.title-wrap {
  text-align: center;
  margin-bottom: 18px;
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

/* 隐藏前台入口提示的样式 */
/*
.portal-tip {
  margin-bottom: 20px;
}

.portal-tip :deep(.el-alert) {
  border-radius: 8px;
  padding: 12px 16px;
}

.portal-tip :deep(.el-alert__content) {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 8px;
}

.portal-tip :deep(.el-button) {
  font-weight: 600;
  margin-left: 8px;
}
*/

.login-form :deep(.el-form-item) {
  margin-bottom: 16px;
}

.login-form :deep(.el-input__wrapper),
.login-form :deep(.el-select__wrapper) {
  box-shadow: 0 0 0 1px #e6d8c4 inset;
}

.login-form :deep(.el-input__wrapper.is-focus),
.login-form :deep(.el-select__wrapper.is-focused) {
  box-shadow: 0 0 0 1px #8a5b2f inset;
}

.login-btn {
  width: 100%;
  margin-top: 4px;
  height: 40px;
  letter-spacing: 1px;
}

.language-switcher-wrapper {
  margin-top: 20px;
  display: flex;
  justify-content: center;
}

.forgot-password-link {
  margin-top: 12px;
  text-align: center;
}

.forgot-password-link :deep(.el-button) {
  color: #8a5b2f;
  font-size: 13px;
}
</style>
