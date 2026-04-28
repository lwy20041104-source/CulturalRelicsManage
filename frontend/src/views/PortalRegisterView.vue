<template>
  <div class="portal-register-page">
    <!-- 背景装饰 -->
    <div class="bg-decoration">
      <div class="decoration-circle circle-1"></div>
      <div class="decoration-circle circle-2"></div>
      <div class="decoration-circle circle-3"></div>
    </div>

    <!-- 左侧展示区 -->
    <div class="register-showcase">
      <div class="showcase-content">
        <div class="museum-icon">🏛️</div>
        <h1 class="showcase-title">加入我们</h1>
        <p class="showcase-subtitle">成为文物借展人，开启文化交流之旅</p>
        
        <div class="benefits-list">
          <div class="benefit-item">
            <div class="benefit-icon">✓</div>
            <div class="benefit-text">
              <h3>便捷的借展申请</h3>
              <p>在线提交借展申请，实时跟踪审批进度</p>
            </div>
          </div>
          <div class="benefit-item">
            <div class="benefit-icon">✓</div>
            <div class="benefit-text">
              <h3>丰富的文物资源</h3>
              <p>浏览海量文物信息，精准查找所需藏品</p>
            </div>
          </div>
          <div class="benefit-item">
            <div class="benefit-icon">✓</div>
            <div class="benefit-text">
              <h3>智能AI助手</h3>
              <p>AI辅助搜索，快速找到符合需求的文物</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 右侧注册表单 -->
    <div class="register-form-section">
      <div class="form-container">
        <!-- 返回登录 -->
        <div class="back-link">
          <el-button text @click="goToLogin">
            <el-icon><ArrowLeft /></el-icon>
            返回登录
          </el-button>
        </div>

        <!-- 注册表单 -->
        <div class="form-header">
          <div class="form-icon">📝</div>
          <h2>借展人注册</h2>
          <p>填写以下信息完成注册</p>
        </div>

        <el-form 
          ref="registerFormRef" 
          :model="registerForm" 
          :rules="registerRules"
          label-width="100px"
          class="portal-register-form"
        >
          <el-form-item label="用户名" prop="username">
            <el-input 
              v-model="registerForm.username" 
              placeholder="4-20位字母、数字或下划线"
              clearable
            >
              <template #prefix>
                <el-icon><User /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="密码" prop="password">
            <el-input 
              v-model="registerForm.password" 
              type="password" 
              placeholder="6-20位字符，必须包含数字和字母"
              show-password
            >
              <template #prefix>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input 
              v-model="registerForm.confirmPassword" 
              type="password" 
              placeholder="请再次输入密码"
              show-password
            >
              <template #prefix>
                <el-icon><Lock /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="真实姓名" prop="realName">
            <el-input 
              v-model="registerForm.realName" 
              placeholder="请输入真实姓名"
              clearable
            >
              <template #prefix>
                <el-icon><UserFilled /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="邮箱" prop="email">
            <el-input 
              v-model="registerForm.email" 
              placeholder="请输入邮箱地址"
              clearable
            >
              <template #prefix>
                <el-icon><Message /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="电话号码" prop="phone">
            <el-input 
              v-model="registerForm.phone" 
              placeholder="请输入手机号码"
              clearable
              maxlength="11"
            >
              <template #prefix>
                <el-icon><Phone /></el-icon>
              </template>
            </el-input>
          </el-form-item>

          <el-form-item label="所属博物馆" prop="museumId">
            <el-select 
              v-model="registerForm.museumId" 
              placeholder="请选择所属博物馆"
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
            <div class="agreement">
              <el-checkbox v-model="registerForm.agree">
                我已阅读并同意
                <el-button type="primary" text size="small">《用户协议》</el-button>
                和
                <el-button type="primary" text size="small">《隐私政策》</el-button>
              </el-checkbox>
            </div>
          </el-form-item>

          <el-form-item>
            <el-button 
              type="primary" 
              size="large" 
              class="register-submit-btn" 
              @click="handleRegister"
              :loading="loading"
            >
              立即注册
            </el-button>
          </el-form-item>
        </el-form>

        <div class="form-footer">
          <p>
            已有账号？
            <el-button type="primary" text @click="goToLogin">
              立即登录
            </el-button>
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { User, Lock, UserFilled, Message, Phone, OfficeBuilding, ArrowLeft } from '@element-plus/icons-vue'
import { registerApi } from '../api/auth'
import { getActiveMuseumsApi } from '../api/museums'

const router = useRouter()
const { t } = useI18n()
const registerFormRef = ref(null)
const loading = ref(false)
const museumList = ref([])

const registerForm = reactive({
  username: '',
  password: '',
  confirmPassword: '',
  realName: '',
  email: '',
  phone: '',
  museumId: null,
  agree: false
})

// 自定义验证规则
const validateUsername = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入用户名'))
  } else if (!/^[a-zA-Z0-9_]{4,20}$/.test(value)) {
    callback(new Error('用户名必须是4-20位字母、数字或下划线'))
  } else {
    callback()
  }
}

const validatePassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入密码'))
  } else if (value.length < 6 || value.length > 20) {
    callback(new Error('密码长度必须在6-20位之间'))
  } else if (!/[0-9]/.test(value)) {
    callback(new Error('密码必须包含数字'))
  } else if (!/[a-zA-Z]/.test(value)) {
    callback(new Error('密码必须包含字母'))
  } else if (!/^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$/.test(value)) {
    callback(new Error('密码必须是6-20位字符，且包含数字和字母'))
  } else {
    if (registerForm.confirmPassword) {
      registerFormRef.value.validateField('confirmPassword')
    }
    callback()
  }
}

const validateConfirmPassword = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请再次输入密码'))
  } else if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const validatePhone = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请输入电话号码'))
  } else if (!/^1[3-9]\d{9}$/.test(value)) {
    callback(new Error('请输入正确的手机号码'))
  } else {
    callback()
  }
}

const validateAgree = (rule, value, callback) => {
  if (!registerForm.agree) {
    callback(new Error('请阅读并同意用户协议和隐私政策'))
  } else {
    callback()
  }
}

const registerRules = {
  username: [
    { required: true, validator: validateUsername, trigger: 'blur' }
  ],
  password: [
    { required: true, validator: validatePassword, trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, validator: validateConfirmPassword, trigger: 'blur' }
  ],
  realName: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  phone: [
    { required: true, validator: validatePhone, trigger: 'blur' }
  ],
  museumId: [
    { required: true, message: '请选择所属博物馆', trigger: 'change' }
  ]
}

onMounted(async () => {
  // 加载博物馆列表
  try {
    const res = await getActiveMuseumsApi()
    museumList.value = res.data || []
  } catch (e) {
    ElMessage.error(t('common.loadMuseumListFailed'))
  }
})

const handleRegister = async () => {
  if (!registerFormRef.value) return
  
  // 验证是否同意协议
  if (!registerForm.agree) {
    ElMessage.warning(t('common.pleaseAgreeTerms'))
    return
  }
  
  await registerFormRef.value.validate(async (valid) => {
    if (!valid) return
    
    loading.value = true
    try {
      // 构建注册请求数据（不包含 confirmPassword 和 agree）
      const requestData = {
        username: registerForm.username,
        password: registerForm.password,
        realName: registerForm.realName,
        email: registerForm.email,
        phone: registerForm.phone,
        museumId: registerForm.museumId
      }
      
      const res = await registerApi(requestData)
      
      if (res.code === 200) {
        ElMessage.success(t('common.registerSuccess'))
        // 延迟跳转到登录页面
        setTimeout(() => {
          router.push('/portal-login')
        }, 1500)
      } else {
        ElMessage.error(res.message || '注册失败')
      }
    } catch (e) {
      const msg = e?.response?.data?.message || e?.message || '注册失败，请稍后重试'
      ElMessage.error(msg)
    } finally {
      loading.value = false
    }
  })
}

const goToLogin = () => {
  router.push('/portal-login')
}
</script>

<style scoped>
.portal-register-page {
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
.register-showcase {
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

.benefits-list {
  margin-bottom: 40px;
}

.benefit-item {
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

.benefit-item:hover {
  background: rgba(255, 253, 248, 0.95);
  border-color: rgba(181, 136, 82, 0.3);
  transform: translateX(10px);
  box-shadow: 0 4px 12px rgba(139, 91, 47, 0.12);
}

.benefit-icon {
  width: 40px;
  height: 40px;
  background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: bold;
  color: white;
  margin-right: 20px;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.2);
}

.benefit-text h3 {
  font-size: 18px;
  margin: 0 0 8px 0;
  font-weight: 600;
  color: #5a4332;
}

.benefit-text p {
  font-size: 14px;
  margin: 0;
  color: #7a6c5b;
  line-height: 1.5;
}

/* 右侧注册表单 */
.register-form-section {
  width: 550px;
  background: rgba(255, 253, 248, 0.98);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  position: relative;
  z-index: 1;
  box-shadow: -10px 0 30px rgba(76, 58, 38, 0.15);
  border-left: 1px solid rgba(181, 136, 82, 0.15);
  overflow-y: auto;
}

.form-container {
  width: 100%;
  max-width: 450px;
}

.back-link {
  margin-bottom: 20px;
}

.back-link .el-button {
  color: #8a5b2f;
  font-size: 14px;
}

.back-link .el-button:hover {
  color: #6d4623;
}

.form-header {
  text-align: center;
  margin-bottom: 30px;
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

.portal-register-form {
  margin-top: 20px;
}

.portal-register-form :deep(.el-form-item) {
  margin-bottom: 20px;
}

.portal-register-form :deep(.el-form-item__label) {
  color: #5a4332;
  font-weight: 500;
}

.portal-register-form :deep(.el-input__wrapper) {
  border-radius: 8px;
  box-shadow: 0 0 0 1px #e6d8c4 inset;
  transition: all 0.3s ease;
  background: rgba(255, 253, 248, 0.8);
}

.portal-register-form :deep(.el-input__wrapper:hover) {
  box-shadow: 0 0 0 1px #b58852 inset;
}

.portal-register-form :deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 2px #8a5b2f inset;
  background: #fff;
}

.agreement {
  width: 100%;
  font-size: 14px;
  color: #7a6c5b;
}

.agreement :deep(.el-checkbox__label) {
  color: #7a6c5b;
}

.agreement :deep(.el-button) {
  color: #8a5b2f;
  padding: 0 4px;
}

.register-submit-btn {
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

.register-submit-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(139, 91, 47, 0.3);
  background: linear-gradient(135deg, #c69563 0%, #9b6a3a 100%);
}

.form-footer {
  text-align: center;
  margin-top: 20px;
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

/* 响应式设计 */
@media (max-width: 1024px) {
  .register-showcase {
    display: none;
  }
  
  .register-form-section {
    width: 100%;
  }
}

@media (max-width: 768px) {
  .register-form-section {
    padding: 20px;
  }
  
  .form-container {
    max-width: 100%;
  }
}
</style>
