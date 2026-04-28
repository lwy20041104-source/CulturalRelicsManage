<template>
  <div class="qrcode-scan-page">
    <div class="scan-container">
      <!-- 加载中 -->
      <div v-if="loading" class="loading-box">
        <el-icon class="is-loading" :size="50"><Loading /></el-icon>
        <p>加载中...</p>
      </div>

      <!-- 文物不存在 -->
      <div v-else-if="!relic" class="error-box">
        <el-icon :size="80" color="#f56c6c"><WarningFilled /></el-icon>
        <h2>文物不存在</h2>
        <p>该二维码对应的文物信息未找到</p>
        <el-button type="primary" @click="goHome">返回首页</el-button>
      </div>

      <!-- 文物信息展示 -->
      <div v-else class="relic-info-box">
        <!-- 头部 -->
        <div class="info-header">
          <div class="header-icon">
            <el-icon :size="40"><Memo /></el-icon>
          </div>
          <h1>{{ relic.relicName }}</h1>
          <p class="relic-code">文物编号：{{ relic.relicCode }}</p>
        </div>

        <!-- 图片 -->
        <div class="info-image" v-if="relic.imagePath">
          <el-image
            :src="resolveImageUrl(relic.imagePath)"
            fit="cover"
            :preview-src-list="[resolveImageUrl(relic.imagePath)]"
          />
        </div>
        <div v-else class="info-image no-image">
          <el-icon :size="60"><Picture /></el-icon>
          <p>暂无图片</p>
        </div>

        <!-- 基本信息 -->
        <div class="info-section">
          <h3>基本信息</h3>
          <div class="info-grid">
            <div class="info-item">
              <span class="label">年代</span>
              <span class="value">{{ relic.era || '—' }}</span>
            </div>
            <div class="info-item">
              <span class="label">材质</span>
              <span class="value">{{ relic.material || '—' }}</span>
            </div>
            <div class="info-item">
              <span class="label">分类</span>
              <span class="value">{{ relic.categoryName || '—' }}</span>
            </div>
            <div class="info-item">
              <span class="label">状态</span>
              <el-tag :type="getStatusType(relic.status)">
                {{ relic.status || '—' }}
              </el-tag>
            </div>
            <div class="info-item">
              <span class="label">尺寸</span>
              <span class="value">{{ relic.dimensions || '—' }}</span>
            </div>
            <div class="info-item">
              <span class="label">重量</span>
              <span class="value">{{ formatWeight(relic.weight) }}</span>
            </div>
            <div class="info-item full-width">
              <span class="label">来源</span>
              <span class="value">{{ relic.origin || '—' }}</span>
            </div>
            <div class="info-item full-width">
              <span class="label">描述</span>
              <span class="value">{{ relic.description || '—' }}</span>
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="info-actions">
          <el-button type="primary" @click="viewDetail">查看详情</el-button>
          <el-button @click="goHome">返回首页</el-button>
        </div>

        <!-- 底部信息 -->
        <div class="info-footer">
          <p>文物数字化管理系统</p>
          <p class="scan-time">扫描时间：{{ currentTime }}</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { ElMessage } from 'element-plus'
import { Loading, WarningFilled, Memo, Picture } from '@element-plus/icons-vue'
import { getRelicByIdApi } from '../api/relics'
import request from '../api/request'

const route = useRoute()
const router = useRouter()
const { t } = useI18n()

const relic = ref(null)
const loading = ref(true)
const currentTime = ref('')

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

const getStatusType = (status) => {
  const typeMap = {
    '在库': 'success',
    '借展中': 'warning',
    '修复中': 'danger',
    '封存': 'info'
  }
  return typeMap[status] || 'info'
}

const loadRelicInfo = async () => {
  try {
    loading.value = true
    const relicId = route.params.id
    
    if (!relicId) {
      ElMessage.error(t('common.relicIdNotExist'))
      relic.value = null
      return
    }

    const res = await getRelicByIdApi(relicId)
    if (res.code === 200 && res.data) {
      relic.value = res.data
    } else {
      relic.value = null
      ElMessage.error(res.message || '获取文物信息失败')
    }
  } catch (error) {
    console.error('加载文物信息失败:', error)
    relic.value = null
    ElMessage.error(t('common.loadRelicFailed'))
  } finally {
    loading.value = false
  }
}

const viewDetail = () => {
  // 跳转到文物详情页（需要登录）
  router.push(`/relics/${relic.value.id}`)
}

const goHome = () => {
  router.push('/')
}

onMounted(() => {
  // 设置当前时间
  currentTime.value = new Date().toLocaleString('zh-CN')
  
  // 加载文物信息
  loadRelicInfo()
})
</script>

<style scoped>
.qrcode-scan-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #f4f1eb 0%, #e8dcc8 100%);
  padding: 20px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.scan-container {
  width: 100%;
  max-width: 600px;
  margin: 0 auto;
}

/* 加载中 */
.loading-box {
  background: white;
  border-radius: 16px;
  padding: 60px 40px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.loading-box p {
  margin-top: 20px;
  font-size: 16px;
  color: #666;
}

/* 错误提示 */
.error-box {
  background: white;
  border-radius: 16px;
  padding: 60px 40px;
  text-align: center;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.error-box h2 {
  margin: 20px 0 10px;
  font-size: 24px;
  color: #333;
}

.error-box p {
  margin-bottom: 30px;
  font-size: 14px;
  color: #999;
}

/* 文物信息 */
.relic-info-box {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}

.info-header {
  background: linear-gradient(135deg, #8a5b2f 0%, #6d4623 100%);
  color: white;
  padding: 30px 20px;
  text-align: center;
}

.header-icon {
  width: 80px;
  height: 80px;
  margin: 0 auto 20px;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
}

.info-header h1 {
  margin: 0 0 10px;
  font-size: 24px;
  font-weight: 600;
}

.relic-code {
  margin: 0;
  font-size: 14px;
  opacity: 0.9;
}

.info-image {
  width: 100%;
  height: 300px;
  background: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
}

.info-image :deep(.el-image) {
  width: 100%;
  height: 100%;
}

.info-image.no-image {
  flex-direction: column;
  color: #ccc;
}

.info-image.no-image p {
  margin-top: 10px;
  font-size: 14px;
}

.info-section {
  padding: 30px 20px;
}

.info-section h3 {
  margin: 0 0 20px;
  font-size: 18px;
  color: #333;
  border-left: 4px solid #8a5b2f;
  padding-left: 12px;
}

.info-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-item .label {
  font-size: 12px;
  color: #999;
}

.info-item .value {
  font-size: 14px;
  color: #333;
  word-break: break-all;
}

.info-actions {
  padding: 0 20px 30px;
  display: flex;
  gap: 12px;
}

.info-actions .el-button {
  flex: 1;
}

.info-footer {
  background: #f9f9f9;
  padding: 20px;
  text-align: center;
  border-top: 1px solid #eee;
}

.info-footer p {
  margin: 0;
  font-size: 12px;
  color: #999;
}

.scan-time {
  margin-top: 8px !important;
  color: #ccc !important;
}

/* 响应式 */
@media (max-width: 768px) {
  .qrcode-scan-page {
    padding: 10px;
  }

  .info-header h1 {
    font-size: 20px;
  }

  .info-image {
    height: 250px;
  }

  .info-grid {
    grid-template-columns: 1fr;
  }
}
</style>
