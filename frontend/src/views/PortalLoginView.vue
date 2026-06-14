<template>
  <div class="portal-login-page">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="decoration-circle circle-1"></div>
      <div class="decoration-circle circle-2"></div>
      <div class="decoration-circle circle-3"></div>
    </div>

    <!-- 左侧展示区 -->
    <div class="login-showcase">
      <div class="showcase-content">
        <div class="museum-icon">🏛️</div>
        <h1 class="showcase-title">{{ $t('portalLogin.welcomeTitle') }}</h1>
        <p class="showcase-subtitle">{{ $t('portalLogin.welcomeSubtitle') }}</p>
        
        <div class="features-list">
          <div class="feature-item" @click="goToPublicRelics" style="cursor: pointer;">
            <div class="feature-icon">🔍</div>
            <div class="feature-text">
              <h3>{{ $t('portalLogin.feature1Title') }}</h3>
              <p>{{ $t('portalLogin.feature1Desc') }}</p>
            </div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">📋</div>
            <div class="feature-text">
              <h3>{{ $t('portalLogin.feature2Title') }}</h3>
              <p>{{ $t('portalLogin.feature2Desc') }}</p>
            </div>
          </div>
          <div class="feature-item">
            <div class="feature-icon">🤖</div>
            <div class="feature-text">
              <h3>{{ $t('portalLogin.feature3Title') }}</h3>
              <p>{{ $t('portalLogin.feature3Desc') }}</p>
            </div>
          </div>
        </div>

        <div class="showcase-footer">
          <p>{{ $t('portalLogin.showcaseFooter') }}</p>
        </div>
      </div>
    </div>

    <!-- 右侧登录表单 -->
    <div class="login-form-section">
      <div class="form-container">
        <!-- 返回后台管理入口 -->
        <div class="admin-link">
          <el-button text @click="goToAdminLogin">
            <el-icon><Setting /></el-icon>
            {{ $t('portalLogin.adminLogin') }}
          </el-button>
        </div>

        <!-- 登录表单 -->
        <div class="form-header">
          <div class="form-icon">👤</div>
          <h2>{{ $t('portalLogin.loginTitle') }}</h2>
          <p>{{ $t('portalLogin.loginSubtitle') }}</p>
        </div>

        <el-form 
          ref="loginFormRef" 
          :model="loginForm" 
          :rules="loginRules" 
          @keyup.enter="handleLogin"
          class="portal-login-form"
        >
          <el-form-item prop="username">
            <el-input 
              v-model="loginForm.username" 
              :placeholder="$t('portalLogin.usernamePlaceholder')"
              size="large"
              clearable
            >
              <template #prefix>
                <el-icon><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="password">
            <el-input 
              v-model="loginForm.password" 
              type="password" 
              :placeholder="$t('portalLogin.passwordPlaceholder')"
              size="large"
              show-password
            >
              <template #prefix>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item prop="museumId">
            <el-select 
              v-model="loginForm.museumId" 
              :placeholder="$t('portalLogin.selectMuseum')"
              size="large"
              filterable
              style="width: 100%"
            >
              <template #prefix>
                <el-icon><OfficeBuilding /></el-icon>
              </template>
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

          <el-form-item>
            <div class="form-options">
              <el-checkbox v-model="loginForm.remember">
                {{ $t('portalLogin.rememberMe') }}
              </el-checkbox>
              <el-button type="primary" text size="small" @click="goToForgotPassword">
                {{ $t('portalLogin.forgotPassword') }}
              </el-button>
            </div>
          </el-form-item>

          <el-form-item>
            <el-button 
              type="primary" 
              size="large" 
              class="login-submit-btn" 
              @click="handleLogin"
              :loading="loading"
            >
              {{ $t('portalLogin.loginButton') }}
            </el-button>
          </el-form-item>
        </el-form>

        <div class="form-footer">
          <p>
            {{ $t('portalLogin.noAccount') }}
            <el-button type="primary" text @click="handleRegister">
              {{ $t('portalLogin.registerNow') }}
            </el-button>
          </p>
        </div>

        <!-- 语言切换 -->
        <div class="language-switcher-portal">
          <LanguageSwitcher />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { User, Lock, Setting, OfficeBuilding } from '@element-plus/icons-vue'
import { loginApi, getPermissionsApi } from '../api/auth'
import { getActiveMuseumsApi } from '../api/museums'
import LanguageSwitcher from '../components/LanguageSwitcher.vue'

const router = useRouter()
const { t } = useI18n()
const loginFormRef = ref(null)
const loading = ref(false)
const museumList = ref([])

const loginForm = reactive({
  username: '',
  password: '',
  museumId: null,
  remember: false,
  roleCode: 'LOANER' // 固定为借展人角色
})

const loginRules = {
  username: [
    { required: true, message: t('portalLogin.usernameRequired'), trigger: 'blur' }
  ],
  password: [
    { required: true, message: t('portalLogin.passwordRequired'), trigger: 'blur' },
    { min: 6, message: t('portalLogin.passwordMinLength'), trigger: 'blur' }
  ],
  museumId: [
    { required: true, message: t('portalLogin.museumRequired'), trigger: 'change' }
  ]
}

onMounted(async () => {
  // 加载博物馆列表
  try {
    const res = await getActiveMuseumsApi()
    museumList.value = res.data || []
  } catch (e) {
    ElMessage.error(t('portalLogin.loadMuseumsFailed'))
  }
})

const handleLogin = async () => {
  if (!loginFormRef.value) return
  
  await loginFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      const res = await loginApi(loginForm)
      
      // 验证是否为借展人角色
      if (loginForm.roleCode !== 'LOANER') {
        ElMessage.warning(t('portalLogin.onlyLoanerAllowed'))
        loading.value = false
        return
      }

      // 获取选中的博物馆信息
      const selectedMuseum = museumList.value.find(m => m.id === loginForm.museumId)
      const museumName = selectedMuseum ? selectedMuseum.museumName : ''

      sessionStorage.setItem('token', res.data.token)
      sessionStorage.setItem('username', res.data.username)
      sessionStorage.setItem('realName', res.data.realName || '')
      sessionStorage.setItem('phone', res.data.phone || '')
      sessionStorage.setItem('role', 'LOANER')
      sessionStorage.setItem('museumId', loginForm.museumId)
      sessionStorage.setItem('museumName', museumName)

      const permsRes = await getPermissionsApi(res.data.username)
      sessionStorage.setItem('permissions', JSON.stringify(permsRes.data || []))

      ElMessage.success(t('portalLogin.loginSuccess'))
      
      // 跳转到前台门户
      router.push('/portal')
    } catch (e) {
      // 尝试多种方式获取错误信息
      let msg = e?.response?.data?.message 
             || e?.message 
             || e?.data?.message
             || t('portalLogin.loginFailed')
      
      ElMessage.error(msg)
    } finally {
      loading.value = false
    }
  })
}

const goToAdminLogin = () => {
  router.push('/login')
}

const handleRegister = () => {
  router.push('/portal-register')
}

const goToForgotPassword = () => {
  router.push({ path: '/forgot-password', query: { from: 'portal' } })
}

const goToPublicRelics = () => {
  router.push('/portal-guest')
}
</script>

<style scoped>
.portal-login-page {
  min-height: 100vh;
  display: flex;
  position: relative;
  overflow: hidden;
  background:
    radial-gradient(circle at 15% 20%, rgba(181, 136, 82, 0.18), transparent 35%),
    radial-gradient(circle at 85% 80%, rgba(128, 95, 60, 0.16), transparent 32%),
    radial-gradient(circle at 50% 50%, rgba(139, 91, 47, 0.08), transparent 50%),
    #f4f1eb;
}

/* 背景装饰 */
.bg-decoration {
  position: absolute;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;
}

.decoration-circle {
  position: absolute;
  border-radius: 50%;
  background: rgba(181, 136, 82, 0.08);
  animation: float 20s infinite ease-in-out;
  border: 1px solid rgba(181, 136, 82, 0.12);
}

.circle-1 {
  width: 300px;
  height: 300px;
  top: -100px;
  left: -100px;
  animation-delay: 0s;
}

.circle-2 {
  width: 200px;
  height: 200px;
  bottom: -50px;
  right: 10%;
  animation-delay: 5s;
}

.circle-3 {
  width: 150px;
  height: 150px;
  top: 50%;
  left: 20%;
  animation-delay: 10s;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0) scale(1);
  }
  50% {
    transform: translateY(-30px) scale(1.05);
  }
}

/* 左侧展示区 */
.login-showcase {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px;
  position: relative;
  z-index: 1;
  background: linear-gradient(135deg, rgba(139, 91, 47, 0.05) 0%, rgba(181, 136, 82, 0.08) 100%);
}

.showcase-content {
  max-width: 600px;
  color: #4a3a28;
}

.museum-icon {
  font-size: 80px;
  margin-bottom: 30px;
  animation: bounce 2s infinite;
  filter: drop-shadow(0 4px 8px rgba(139, 91, 47, 0.2));
}

@keyframes bounce {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.showcase-title {
  font-size: 48px;
  font-weight: 700;
  margin: 0 0 20px 0;
  line-height: 1.2;
  color: #5a4332;
  text-shadow: 0 2px 4px rgba(139, 91, 47, 0.1);
}

.showcase-subtitle {
  font-size: 20px;
  margin: 0 0 50px 0;
  color: #7a6c5b;
  line-height: 1.6;
}

.features-list {
  margin-bottom: 40px;
}

.feature-item {
  display: flex;
  align-items: flex-start;
  margin-bottom: 30px;
  padding: 24px;
  background: rgba(255, 253, 248, 0.8);
  border: 1px solid rgba(181, 136, 82, 0.2);
  border-radius: 12px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.08);
}

.feature-item:hover {
  background: rgba(255, 253, 248, 0.95);
  border-color: rgba(181, 136, 82, 0.3);
  transform: translateX(10px);
  box-shadow: 0 4px 12px rgba(139, 91, 47, 0.12);
}

.feature-icon {
  font-size: 36px;
  margin-right: 20px;
  flex-shrink: 0;
  filter: grayscale(0.2) sepia(0.3);
}

.feature-text h3 {
  font-size: 18px;
  margin: 0 0 8px 0;
  font-weight: 600;
  color: #5a4332;
}

.feature-text p {
  font-size: 14px;
  margin: 0;
  color: #7a6c5b;
  line-height: 1.5;
}

.showcase-footer {
  padding-top: 30px;
  border-top: 1px solid rgba(181, 136, 82, 0.2);
  color: #8b7355;
  font-size: 14px;
}

/* 右侧登录表单 */
.login-form-section {
  width: 500px;
  background: rgba(255, 253, 248, 0.98);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  position: relative;
  z-index: 1;
  box-shadow: -10px 0 30px rgba(76, 58, 38, 0.15);
  border-left: 1px solid rgba(181, 136, 82, 0.15);
}

.form-container {
  width: 100%;
  max-width: 400px;
}

.admin-link {
  text-align: right;
  margin-bottom: 20px;
}

.admin-link .el-button {
  color: #8a5b2f;
  font-size: 14px;
}

.admin-link .el-button:hover {
  color: #6d4623;
}

.form-header {
  text-align: center;
  margin-bottom: 40px;
}

.form-icon {
  width: 70px;
  height: 70px;
  margin: 0 auto 20px;
  background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  box-shadow: 0 4px 15px rgba(139, 91, 47, 0.25);
}

.form-header h2 {
  font-size: 28px;
  color: #2f2a24;
  margin: 0 0 10px 0;
  font-weight: 600;
}

.form-header p {
  font-size: 14px;
  color: #7a6c5b;
  margin: 0;
}

.portal-login-form {
  margin-top: 30px;
}

.portal-login-form :deep(.el-form-item) {
  margin-bottom: 24px;
}

.portal-login-form :deep(.el-input__wrapper) {
  border-radius: 8px;
  box-shadow: 0 0 0 1px #e6d8c4 inset;
  transition: all 0.3s ease;
  background: rgba(255, 253, 248, 0.8);
}

.portal-login-form :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #b58852 inset;
}

.portal-login-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px #8a5b2f inset;
  background: #fff;
}

.form-options {
  width: 100%;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.form-options :deep(.el-checkbox__label) {
  color: #7a6c5b;
}

.form-options :deep(.el-button) {
  color: #8a5b2f;
}

.login-submit-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: 600;
  border-radius: 8px;
  background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%);
  border: none;
  letter-spacing: 1px;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.2);
}

.login-submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 91, 47, 0.3);
  background: linear-gradient(135deg, #c69563 0%, #9b6a3a 100%);
}

.form-footer {
  text-align: center;
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #e6d8c4;
}

.form-footer p {
  font-size: 14px;
  color: #7a6c5b;
  margin: 0;
}

.form-footer .el-button {
  font-size: 14px;
  font-weight: 600;
  color: #8a5b2f;
}

.form-footer .el-button:hover {
  color: #6d4623;
}

.language-switcher-portal {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}

/* 响应式设计 */
@media (max-width: 1024px) {
  .login-showcase {
    display: none;
  }
  
  .login-form-section {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .login-form-section {
    padding: 20px;
  }
  
  .form-container {
    max-width: 100%;
  }
}
</style>
