<template>
  <div class="public-guest">
    <!-- 顶部导航栏 -->
    <header class="guest-header">
      <div class="header-container">
        <div class="logo-section">
          <h1>🏛️ {{ t('guestView.systemTitle') }}</h1>
          <p class="subtitle">{{ t('guestView.systemSubtitle') }}</p>
          <span class="guest-badge">{{ t('guestView.guestMode') }}</span>
        </div>
        <div class="header-right">
          <LanguageSwitcher />
          <el-button type="primary" size="small" @click="router.push('/portal-login')">
            <el-icon><User /></el-icon>
            {{ t('guestView.login') }}
          </el-button>
          <el-button size="small" @click="router.push('/portal-register')">
            {{ t('guestView.register') }}
          </el-button>
        </div>
      </div>
    </header>

    <!-- 主要内容 -->
    <main class="guest-main">
      <!-- 欢迎横幅 -->
      <section class="welcome-banner">
        <div class="banner-content">
          <h2>{{ t('guestView.welcomeTitle') }}</h2>
          <p>{{ t('guestView.welcomeSubtitle') }}</p>
          <div class="banner-actions">
            <el-button type="primary" size="large" @click="router.push('/portal-login')">
              <el-icon><User /></el-icon>
              {{ t('guestView.loginToExplore') }}
            </el-button>
            <el-button size="large" @click="router.push('/portal-register')">
              {{ t('portalLogin.registerNow') }}
            </el-button>
          </div>
        </div>
      </section>

      <!-- 文物展示区 -->
      <section class="relics-section">
        <div class="section-header">
          <h3>{{ t('guestView.relicsGallery') }}</h3>
          <p>{{ t('guestView.loginToViewDetails') }}</p>
        </div>

        <!-- 搜索栏 -->
        <div class="search-bar">
          <el-input
            v-model="query.relicName"
            :placeholder="t('guestView.searchPlaceholder')"
            style="width: 300px"
            @keyup.enter="searchRelics"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-select
            v-model="query.categoryId"
            :placeholder="t('guestView.selectCategory')"
            clearable
            style="width: 200px"
          >
            <el-option
              v-for="cat in categories"
              :key="cat.id"
              :label="cat.categoryName"
              :value="cat.id"
            />
          </el-select>
          <el-button type="primary" @click="searchRelics">
            <el-icon><Search /></el-icon>
            {{ t('common.search') }}
          </el-button>
        </div>

        <!-- 文物网格 -->
        <div v-loading="loading" class="relics-grid">
          <div
            v-for="relic in relicsList"
            :key="relic.id"
            class="relic-card"
            @click="handleRelicClick"
          >
            <div class="relic-image">
              <img
                v-if="relic.imagePath"
                :src="resolveImageUrl(relic.imagePath)"
                :alt="relic.relicName"
              />
              <div v-else class="no-image">
                <el-icon :size="60"><Picture /></el-icon>
              </div>
              <div class="login-overlay">
                <el-icon :size="40"><Lock /></el-icon>
                <p>{{ t('guestView.loginToView') }}</p>
              </div>
            </div>
            <div class="relic-info">
              <h4>{{ relic.relicName }}</h4>
              <p class="relic-meta">
                <span>{{ relic.era }}</span>
                <span v-if="relic.categoryName">· {{ relic.categoryName }}</span>
              </p>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <el-pagination
          v-if="total > 0"
          class="pagination"
          background
          layout="total, prev, pager, next"
          :total="total"
          :page-size="query.pageSize"
          :current-page="query.pageNum"
          @current-change="handlePageChange"
        />
      </section>

      <!-- 功能介绍 -->
      <section class="features-section">
        <h3>{{ t('guestView.featuresTitle') }}</h3>
        <div class="features-grid">
          <div class="feature-card">
            <el-icon :size="48" class="feature-icon"><View /></el-icon>
            <h4>{{ t('guestView.featureViewTitle') }}</h4>
            <p>{{ t('guestView.featureViewDesc') }}</p>
          </div>
          <div class="feature-card">
            <el-icon :size="48" class="feature-icon"><Search /></el-icon>
            <h4>{{ t('guestView.featureSearchTitle') }}</h4>
            <p>{{ t('guestView.featureSearchDesc') }}</p>
          </div>
          <div class="feature-card">
            <el-icon :size="48" class="feature-icon"><Document /></el-icon>
            <h4>{{ t('guestView.featureLoanTitle') }}</h4>
            <p>{{ t('guestView.featureLoanDesc') }}</p>
          </div>
        </div>
      </section>
    </main>

    <!-- 页脚 -->
    <footer class="guest-footer">
      <p>{{ t('guestView.footer') }}</p>
    </footer>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { User, Search, Picture, Lock, View, Document } from '@element-plus/icons-vue'
import LanguageSwitcher from '../components/LanguageSwitcher.vue'
import { getRelicsPageApi } from '../api/relics'
import { getCategoriesApi } from '../api/categories'
import request from '../api/request'

const router = useRouter()
const { t } = useI18n()
const loading = ref(false)
const relicsList = ref([])
const categories = ref([])
const total = ref(0)

const query = reactive({
  pageNum: 1,
  pageSize: 12,
  relicName: '',
  categoryId: null
})

const backendBaseURL = request.defaults.baseURL

const resolveImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (/^https?:\/\//i.test(imagePath)) return imagePath
  let normalized = String(imagePath).trim().replace(/\\/g, '/')
  if (normalized.startsWith('./')) normalized = normalized.slice(1)
  if (!normalized.startsWith('/')) normalized = `/${normalized}`
  return `${backendBaseURL}${normalized}`
}

const loadCategories = async () => {
  try {
    const res = await getCategoriesApi({ pageNum: 1, pageSize: 100 })
    categories.value = res.data.records || []
  } catch (error) {
    console.error('加载分类失败:', error)
  }
}

const searchRelics = async () => {
  loading.value = true
  try {
    const res = await getRelicsPageApi(query)
    relicsList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('搜索文物失败:', error)
    ElMessage.error(t('guestView.searchFailed'))
  } finally {
    loading.value = false
  }
}

const handlePageChange = (page) => {
  query.pageNum = page
  searchRelics()
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const handleRelicClick = () => {
  ElMessageBox.confirm(
    t('guestView.loginPromptMessage'),
    t('guestView.loginPromptTitle'),
    {
      confirmButtonText: t('guestView.goToLogin'),
      cancelButtonText: t('common.cancel'),
      type: 'info'
    }
  ).then(() => {
    router.push('/portal-login')
  }).catch(() => {
    // 用户取消
  })
}

onMounted(() => {
  loadCategories()
  searchRelics()
})
</script>

<style scoped>
.public-guest {
  min-height: 100vh;
  background: 
    radial-gradient(circle at 15% 20%, rgba(181, 136, 82, 0.18), transparent 35%),
    radial-gradient(circle at 85% 80%, rgba(128, 95, 60, 0.16), transparent 32%),
    radial-gradient(circle at 50% 50%, rgba(139, 91, 47, 0.08), transparent 50%),
    #f4f1eb;
  display: flex;
  flex-direction: column;
}

/* 头部 */
.guest-header {
  background: rgba(255, 253, 248, 0.98);
  border-bottom: 1px solid rgba(181, 136, 82, 0.15);
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
  backdrop-filter: blur(10px);
}

.header-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 16px 24px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 16px;
}

.logo-section h1 {
  font-size: 24px;
  font-weight: 700;
  color: #8a5b2f;
  margin: 0;
}

.subtitle {
  font-size: 12px;
  color: #7a6c5b;
  margin: 0;
}

.guest-badge {
  background: rgba(181, 136, 82, 0.15);
  color: #8a5b2f;
  padding: 4px 12px;
  border-radius: 12px;
  font-size: 12px;
  border: 1px solid rgba(181, 136, 82, 0.3);
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

/* 主要内容 */
.guest-main {
  flex: 1;
  padding: 40px 24px;
}

/* 欢迎横幅 */
.welcome-banner {
  background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%);
  border-radius: 16px;
  padding: 60px 40px;
  text-align: center;
  color: white;
  margin-bottom: 40px;
  box-shadow: 0 4px 15px rgba(139, 91, 47, 0.25);
}

.banner-content h2 {
  font-size: 36px;
  font-weight: 700;
  margin: 0 0 16px 0;
}

.banner-content p {
  font-size: 18px;
  margin: 0 0 32px 0;
  opacity: 0.9;
}

.banner-actions {
  display: flex;
  gap: 16px;
  justify-content: center;
}

/* 文物展示区 */
.relics-section {
  max-width: 1400px;
  margin: 0 auto 40px;
}

.section-header {
  text-align: center;
  margin-bottom: 32px;
}

.section-header h3 {
  font-size: 28px;
  font-weight: 700;
  color: #5a4332;
  margin: 0 0 8px 0;
}

.section-header p {
  font-size: 16px;
  color: #7a6c5b;
  margin: 0;
}

.search-bar {
  display: flex;
  gap: 12px;
  justify-content: center;
  margin-bottom: 32px;
  flex-wrap: wrap;
}

.relics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
  margin-bottom: 32px;
}

.relic-card {
  background: rgba(255, 253, 248, 0.95);
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.08);
  position: relative;
  border: 1px solid rgba(181, 136, 82, 0.2);
}

.relic-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(139, 91, 47, 0.15);
  border-color: rgba(181, 136, 82, 0.4);
}

.relic-image {
  width: 100%;
  height: 220px;
  background: #f7efe4;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
  position: relative;
}

.relic-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  display: flex;
  flex-direction: column;
  align-items: center;
  color: #c4b5a0;
}

.login-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: white;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.relic-card:hover .login-overlay {
  opacity: 1;
}

.login-overlay p {
  margin: 8px 0 0 0;
  font-size: 14px;
}

.relic-info {
  padding: 16px;
}

.relic-info h4 {
  font-size: 16px;
  font-weight: 600;
  color: #5a4332;
  margin: 0 0 8px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.relic-meta {
  font-size: 14px;
  color: #8b7355;
  margin: 0;
}

.relic-meta span {
  margin-right: 8px;
}

.pagination {
  display: flex;
  justify-content: center;
}

/* 功能介绍 */
.features-section {
  max-width: 1400px;
  margin: 0 auto;
  text-align: center;
}

.features-section h3 {
  font-size: 28px;
  font-weight: 700;
  color: #5a4332;
  margin: 0 0 32px 0;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
}

.feature-card {
  background: rgba(255, 253, 248, 0.95);
  border-radius: 12px;
  padding: 32px;
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.08);
  transition: all 0.3s ease;
  border: 1px solid rgba(181, 136, 82, 0.2);
}

.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(139, 91, 47, 0.15);
  border-color: rgba(181, 136, 82, 0.4);
}

.feature-icon {
  color: #b58852;
}

.feature-card h4 {
  font-size: 20px;
  font-weight: 600;
  color: #5a4332;
  margin: 16px 0 8px 0;
}

.feature-card p {
  font-size: 14px;
  color: #7a6c5b;
  margin: 0;
  line-height: 1.6;
}

/* 页脚 */
.guest-footer {
  background: rgba(255, 253, 248, 0.98);
  border-top: 1px solid rgba(181, 136, 82, 0.15);
  padding: 24px;
  text-align: center;
}

.guest-footer p {
  margin: 0;
  font-size: 14px;
  color: #7a6c5b;
}

/* 响应式 */
@media (max-width: 768px) {
  .banner-content h2 {
    font-size: 28px;
  }

  .banner-content p {
    font-size: 16px;
  }

  .banner-actions {
    flex-direction: column;
  }

  .search-bar {
    flex-direction: column;
  }

  .search-bar > * {
    width: 100% !important;
  }

  .relics-grid {
    grid-template-columns: 1fr;
  }

  .features-grid {
    grid-template-columns: 1fr;
  }
}
</style>
