<template>
  <div class="public-relics-page">
    <!-- 顶部导航栏 -->
    <div class="top-navbar">
      <div class="navbar-content">
        <div class="logo-section">
          <div class="logo-icon">🏛️</div>
          <h1 class="site-title">文物数字化平台</h1>
        </div>
        <div class="nav-actions">
          <el-button type="primary" @click="goToLogin">
            <el-icon><User /></el-icon>
            登录
          </el-button>
          <el-button @click="goToRegister">
            <el-icon><UserFilled /></el-icon>
            注册
          </el-button>
        </div>
      </div>
    </div>

    <!-- 主要内容区 -->
    <div class="main-content">
      <div class="content-container">
        <!-- 页面标题 -->
        <div class="page-header">
          <h2>文物搜索</h2>
          <p class="page-subtitle">浏览全部馆藏文物，了解历史文化</p>
          <el-alert
            type="info"
            :closable="false"
            show-icon
            class="login-tip"
          >
            <template #title>
              <span>当前为访客模式，仅可浏览全部文物。</span>
              <el-button type="primary" text size="small" @click="goToLogin" style="margin-left: 10px;">
                登录后可使用更多功能
              </el-button>
            </template>
          </el-alert>
        </div>

        <!-- 文物列表 -->
        <el-card class="relics-card">
          <div class="relics-grid">
            <div
              v-for="relic in relicsList"
              :key="relic.id"
              class="relic-item"
            >
              <div class="relic-image" @click.stop="viewDetail(relic)">
                <el-image
                  v-if="relic.imagePath"
                  :src="resolveImageUrl(relic.imagePath)"
                  fit="cover"
                  class="image"
                  :preview-src-list="[]"
                />
                <div v-else class="no-image">
                  <el-icon :size="60"><Picture /></el-icon>
                  <p>暂无图片</p>
                </div>
              </div>
              <div class="relic-info" @click="viewDetail(relic)">
                <h3 class="relic-name">{{ relic.relicName }}</h3>
                <div class="relic-meta">
                  <span class="meta-item">
                    <el-icon><Calendar /></el-icon>
                    {{ relic.era || '未知年代' }}
                  </span>
                  <span class="meta-item">
                    <el-icon><Box /></el-icon>
                    {{ relic.material || '未知材质' }}
                  </span>
                </div>
                <div class="relic-status">
                  <el-tag :type="getStatusType(relic.status)" size="small">
                    {{ relic.status }}
                  </el-tag>
                  <span class="relic-code">{{ relic.relicCode }}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- 加载状态 -->
          <div v-if="loading" class="loading-container">
            <el-icon class="is-loading" :size="40"><Loading /></el-icon>
            <p>加载中...</p>
          </div>

          <!-- 空状态 -->
          <el-empty v-if="!loading && relicsList.length === 0" description="暂无文物数据" />

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
        </el-card>
      </div>
    </div>

    <!-- 文物详情对话框 -->
    <el-dialog
      v-model="detailDialogVisible"
      title="文物详情"
      width="1000px"
      class="detail-dialog"
      :close-on-click-modal="false"
    >
      <div v-if="currentRelic" class="detail-container">
        <!-- 左侧：图片展示 -->
        <div class="detail-left">
          <div class="detail-image-wrapper">
            <el-image
              v-if="currentRelic.imagePath"
              :src="resolveImageUrl(currentRelic.imagePath)"
              fit="contain"
              class="detail-main-image"
              :preview-src-list="[resolveImageUrl(currentRelic.imagePath)]"
              :initial-index="0"
              preview-teleported
              :z-index="3000"
            >
              <template #error>
                <div class="image-error">
                  <el-icon :size="80"><Picture /></el-icon>
                  <p>图片加载失败</p>
                </div>
              </template>
            </el-image>
            <div v-else class="no-image-placeholder">
              <el-icon :size="80"><Picture /></el-icon>
              <p>暂无图片</p>
            </div>
          </div>
          
          <!-- 二维码区域 -->
          <div class="qrcode-section">
            <div class="qrcode-header">
              <el-icon><Grid /></el-icon>
              <span>文物二维码</span>
            </div>
            <div v-if="qrcodeLoading" class="qrcode-loading">
              <el-icon class="is-loading" :size="30"><Loading /></el-icon>
              <p>生成中...</p>
            </div>
            <div v-else-if="currentQRCode" class="qrcode-display">
              <img :src="currentQRCode" alt="文物二维码" class="qrcode-img" />
              <p class="qrcode-tip">扫描查看文物信息</p>
              <div class="qrcode-actions">
                <el-button size="small" @click="downloadCurrentQRCode">
                  <el-icon><Download /></el-icon>
                  下载二维码
                </el-button>
              </div>
            </div>
            <div v-else class="qrcode-error">
              <el-icon :size="40"><WarningFilled /></el-icon>
              <p>二维码生成失败</p>
            </div>
          </div>
        </div>

        <!-- 右侧：详细信息 -->
        <div class="detail-right">
          <!-- 基本信息 -->
          <div class="detail-section">
            <h3 class="section-title">基本信息</h3>
            <el-descriptions :column="2" border>
              <el-descriptions-item label="文物编号">{{ currentRelic.relicCode }}</el-descriptions-item>
              <el-descriptions-item label="文物名称">{{ currentRelic.relicName }}</el-descriptions-item>
              <el-descriptions-item label="年代">{{ currentRelic.era || '—' }}</el-descriptions-item>
              <el-descriptions-item label="材质">{{ currentRelic.material || '—' }}</el-descriptions-item>
              <el-descriptions-item label="分类">{{ currentRelic.categoryName || '—' }}</el-descriptions-item>
              <el-descriptions-item label="状态">
                <el-tag :type="getStatusType(currentRelic.status)">
                  {{ currentRelic.status }}
                </el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="尺寸">{{ currentRelic.dimensions || '—' }}</el-descriptions-item>
              <el-descriptions-item label="重量">{{ formatWeight(currentRelic.weight) }}</el-descriptions-item>
              <el-descriptions-item label="来源" :span="2">{{ currentRelic.origin || '—' }}</el-descriptions-item>
              <el-descriptions-item label="描述" :span="2">{{ currentRelic.description || '—' }}</el-descriptions-item>
            </el-descriptions>
          </div>

          <!-- 操作提示 -->
          <div class="detail-section">
            <el-alert
              type="info"
              :closable="false"
              show-icon
            >
              <template #title>
                <span>想了解更多？</span>
                <el-button type="primary" text size="small" @click="goToLogin" style="margin-left: 10px;">
                  登录后可查看更多详细信息
                </el-button>
              </template>
            </el-alert>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 底部 -->
    <div class="footer">
      <p>© 2024 文物数字化管理系统 | 让文物活起来，让历史走进生活</p>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { User, UserFilled, Picture, Calendar, Box, Loading, Grid, Download, WarningFilled, ZoomIn, Tickets as Ticket, Clock, InfoFilled, Collection, Location, Histogram, FullScreen as Expand, Document } from '@element-plus/icons-vue'
import { useI18n } from 'vue-i18n'
import request from '../api/request'

const router = useRouter()
const { t } = useI18n()
const loading = ref(false)
const relicsList = ref([])
const total = ref(0)
const detailDialogVisible = ref(false)
const currentRelic = ref(null)
const currentQRCode = ref('')
const qrcodeLoading = ref(false)

const query = reactive({
  pageNum: 1,
  pageSize: 12
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

const formatWeight = (weight) => {
  if (weight === null || weight === undefined || weight === '') return '—'
  return `${Number(weight).toFixed(2)} kg`
}

const formatDateTime = (dateTime) => {
  if (!dateTime) return '—'
  return dateTime.replace('T', ' ').substring(0, 19)
}

const previewImage = () => {
  if (currentRelic.value && currentRelic.value.imagePath) {
    // Element Plus的图片预览会自动触发
    const imgElement = document.querySelector('.detail-img img')
    if (imgElement) {
      imgElement.click()
    }
  }
}

const getStatusType = (status) => {
  const typeMap = {
    '在库': 'success',
    '借展中': 'warning',
    '修复中': 'danger',
    '封存': 'info'
  }
  return typeMap[status] || 'info'
}

const loadRelics = async () => {
  loading.value = true
  try {
    const res = await request.get('/relics', {
      params: query
    })
    
    // request拦截器已经处理了响应，res就是后端返回的data部分
    // 后端返回格式: Result<PageResult<CulturalRelic>>
    // 拦截器返回: data (即 PageResult<CulturalRelic>)
    if (res && res.data) {
      relicsList.value = res.data.records || []
      total.value = res.data.total || 0
    } else {
      relicsList.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('加载文物列表失败:', error)
    console.error('错误详情:', error.response)
    ElMessage.error(t('common.loadRelicListFailed') + ': ' + (error.message || '未知错误'))
    relicsList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

const handlePageChange = (page) => {
  query.pageNum = page
  loadRelics()
  // 滚动到顶部
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

const viewDetail = async (relic) => {
  currentRelic.value = relic
  currentQRCode.value = ''
  detailDialogVisible.value = true
  
  // 生成二维码
  await generateQRCode(relic.id)
}

const generateQRCode = async (relicId) => {
  qrcodeLoading.value = true
  try {
    // 自动使用当前访问的URL（支持localhost和局域网IP）
    const baseUrl = window.location.origin
    console.log('生成二维码使用的baseUrl:', baseUrl)
    
    const res = await request.get(`/relics/${relicId}/qrcode`, {
      params: { baseUrl }
    })
    
    if (res && res.data) {
      currentQRCode.value = res.data
    } else {
      currentQRCode.value = ''
      console.error('二维码数据为空')
    }
  } catch (error) {
    console.error('生成二维码失败:', error)
    currentQRCode.value = ''
  } finally {
    qrcodeLoading.value = false
  }
}

const downloadCurrentQRCode = () => {
  if (!currentQRCode.value || !currentRelic.value) return
  
  const link = document.createElement('a')
  link.download = `二维码_${currentRelic.value.relicCode}_${currentRelic.value.relicName}.png`
  link.href = currentQRCode.value
  link.click()
  
  ElMessage.success(t('common.qrCodeDownloaded'))
}

const goToLogin = () => {
  router.push('/portal-login')
}

const goToRegister = () => {
  router.push('/portal-register')
}

onMounted(() => {
  loadRelics()
})
</script>

<style scoped>
.public-relics-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f4f1eb 0%, #e8dcc8 100%);
  display: flex;
  flex-direction: column;
}

/* 顶部导航栏 */
.top-navbar {
  background: rgba(255, 255, 255, 0.95);
  border-bottom: 1px solid rgba(181, 136, 82, 0.2);
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.1);
  position: sticky;
  top: 0;
  z-index: 100;
  backdrop-filter: blur(10px);
}

.navbar-content {
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
  gap: 12px;
}

.logo-icon {
  font-size: 36px;
  filter: drop-shadow(0 2px 4px rgba(139, 91, 47, 0.2));
}

.site-title {
  font-size: 24px;
  font-weight: 700;
  color: #5a4332;
  margin: 0;
}

.nav-actions {
  display: flex;
  gap: 12px;
}

/* 主要内容区 */
.main-content {
  flex: 1;
  padding: 40px 24px;
}

.content-container {
  max-width: 1400px;
  margin: 0 auto;
}

/* 页面标题 */
.page-header {
  text-align: center;
  margin-bottom: 40px;
}

.page-header h2 {
  font-size: 36px;
  font-weight: 700;
  color: #5a4332;
  margin: 0 0 12px 0;
}

.page-subtitle {
  font-size: 16px;
  color: #7a6c5b;
  margin: 0 0 24px 0;
}

.login-tip {
  max-width: 600px;
  margin: 0 auto;
}

/* 文物卡片 */
.relics-card {
  background: rgba(255, 255, 255, 0.95);
  border-radius: 16px;
  border: 1px solid rgba(181, 136, 82, 0.2);
  box-shadow: 0 4px 12px rgba(139, 91, 47, 0.08);
}

.relics-card :deep(.el-card__body) {
  padding: 30px;
}

/* 文物网格 */
.relics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
  margin-bottom: 30px;
}

.relic-item {
  background: #fff;
  border: 1px solid rgba(181, 136, 82, 0.15);
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 8px rgba(139, 91, 47, 0.06);
}

.relic-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(139, 91, 47, 0.15);
  border-color: rgba(181, 136, 82, 0.3);
}

.relic-image {
  width: 100%;
  height: 220px;
  background: #f7efe4;
  display: flex;
  align-items: center;
  justify-content: center;
  overflow: hidden;
}

.relic-image .image {
  width: 100%;
  height: 100%;
}

.no-image {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #9b8d7d;
  gap: 8px;
}

.no-image p {
  margin: 0;
  font-size: 14px;
}

.relic-info {
  padding: 16px;
}

.relic-name {
  font-size: 18px;
  font-weight: 600;
  color: #3d2a1d;
  margin: 0 0 12px 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.relic-meta {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-bottom: 12px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #7a6c5b;
}

.meta-item .el-icon {
  color: #b58852;
}

.relic-status {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid #eadfce;
}

.relic-code {
  font-size: 12px;
  color: #9b8d7d;
  font-family: monospace;
}

/* 加载状态 */
.loading-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  color: #7a6c5b;
}

.loading-container p {
  margin-top: 12px;
  font-size: 14px;
}

/* 分页 */
.pagination {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

/* 详情对话框 */
.detail-dialog :deep(.el-dialog__body) {
  padding: 30px;
}

.detail-container {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: 30px;
}

.detail-left {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-image-wrapper {
  width: 100%;
  height: 400px;
  background: #f7efe4;
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.detail-main-image {
  width: 100%;
  height: 100%;
  cursor: pointer;
}

.image-error,
.no-image-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #9b8d7d;
  gap: 12px;
}

.image-error p,
.no-image-placeholder p {
  margin: 0;
  font-size: 16px;
}

/* 二维码区域 */
.qrcode-section {
  background: #fff;
  border: 1px solid rgba(181, 136, 82, 0.2);
  border-radius: 12px;
  padding: 20px;
  text-align: center;
}

.qrcode-header {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-bottom: 16px;
  font-size: 16px;
  font-weight: 600;
  color: #5a4332;
}

.qrcode-header .el-icon {
  font-size: 20px;
  color: #b58852;
}

.qrcode-loading {
  padding: 40px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: #7a6c5b;
}

.qrcode-loading p {
  margin: 0;
  font-size: 14px;
}

.qrcode-display {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.qrcode-img {
  width: 180px;
  height: 180px;
  border: 2px solid #eadfce;
  border-radius: 8px;
  padding: 10px;
  background: #fff;
}

.qrcode-tip {
  margin: 12px 0;
  font-size: 13px;
  color: #7a6c5b;
}

.qrcode-actions {
  margin-top: 8px;
}

.qrcode-error {
  padding: 40px 20px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 12px;
  color: #f56c6c;
}

.qrcode-error p {
  margin: 0;
  font-size: 14px;
}

/* 右侧详细信息 */
.detail-right {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-section {
  margin-bottom: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #3d2a1d;
  margin: 0 0 16px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid rgba(181, 136, 82, 0.2);
}

/* 底部 */
.footer {
  background: rgba(255, 255, 255, 0.95);
  border-top: 1px solid rgba(181, 136, 82, 0.2);
  padding: 24px;
  text-align: center;
}

.footer p {
  margin: 0;
  font-size: 14px;
  color: #7a6c5b;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .relics-grid {
    grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
    gap: 16px;
  }

  .page-header h2 {
    font-size: 28px;
  }

  .site-title {
    font-size: 20px;
  }

  .logo-icon {
    font-size: 28px;
  }
  
  .detail-container {
    grid-template-columns: 1fr;
  }
  
  .detail-left {
    order: 1;
  }
  
  .detail-right {
    order: 2;
  }
}
</style>
