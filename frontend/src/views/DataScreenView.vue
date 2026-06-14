<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <div class="toolbar-left">
          <h1>{{ $t('dataScreen.title') }}</h1>
          <div class="current-time">{{ currentTime }}</div>
        </div>
      </div>
    </template>

    <!-- 快捷操作入口 -->
    <div class="quick-actions">
      <el-button type="primary" @click="$router.push('/relics')">
        <el-icon><Box /></el-icon>
        {{ $t('dataScreen.relicManagement') }}
      </el-button>
      <el-button type="success" @click="$router.push('/loans')">
        <el-icon><Promotion /></el-icon>
        {{ $t('dataScreen.loanManagement') }}
      </el-button>
      <el-button type="warning" @click="$router.push('/repairs')">
        <el-icon><Tools /></el-icon>
        {{ $t('dataScreen.repairManagement') }}
      </el-button>
      <el-button type="info" @click="$router.push('/reports')">
        <el-icon><Document /></el-icon>
        {{ $t('dataScreen.dataReports') }}
      </el-button>
      <el-button type="danger" @click="$router.push('/ai-query')">
        <el-icon><Search /></el-icon>
        {{ $t('dataScreen.aiQuery') }}
      </el-button>
    </div>

    <div class="screen-content">
      <!-- 第一行：核心指标 -->
      <div class="metrics-row">
        <div class="metric-card" @click="$router.push('/relics')">
          <div class="metric-icon">📦</div>
          <div class="metric-value">{{ dashboardData.totalRelics || 0 }}</div>
          <div class="metric-label">{{ $t('dataScreen.totalRelics') }}</div>
          <div class="metric-trend">
            <span class="trend-up">↑ 12%</span>
          </div>
        </div>
        <div class="metric-card" @click="$router.push('/relics?status=在库')">
          <div class="metric-icon">🏛️</div>
          <div class="metric-value">{{ dashboardData.inStockRelics || 0 }}</div>
          <div class="metric-label">{{ $t('dataScreen.inStock') }}</div>
          <div class="metric-trend">
            <span class="trend-stable">— 0%</span>
          </div>
        </div>
        <div class="metric-card" @click="$router.push('/loans')">
          <div class="metric-icon">🚚</div>
          <div class="metric-value">{{ dashboardData.loaningRelics || 0 }}</div>
          <div class="metric-label">{{ $t('dataScreen.onLoan') }}</div>
          <div class="metric-trend">
            <span class="trend-up">↑ 8%</span>
          </div>
        </div>
        <div class="metric-card" @click="$router.push('/repairs')">
          <div class="metric-icon">🔧</div>
          <div class="metric-value">{{ dashboardData.repairingRelics || 0 }}</div>
          <div class="metric-label">{{ $t('dataScreen.repairing') }}</div>
          <div class="metric-trend">
            <span class="trend-down">↓ 5%</span>
          </div>
        </div>
      </div>

      <!-- 第一行图表：分类统计和年代分布 -->
      <div class="charts-row-top">
        <div class="chart-card chart-large">
          <div class="chart-header">
            <span class="chart-title">{{ $t('dataScreen.categoryStats') }}</span>
          </div>
          <div ref="categoryChartRef" class="chart-container-large"></div>
        </div>
        <div class="chart-card chart-large">
          <div class="chart-header">
            <span class="chart-title">{{ $t('dataScreen.eraStats') }}</span>
          </div>
          <div ref="eraChartRef" class="chart-container-large"></div>
        </div>
      </div>

      <!-- 第二行：状态分布和业务统计 -->
      <div class="charts-row-bottom">
        <div class="chart-card chart-status">
          <div class="chart-header">
            <span class="chart-title">{{ $t('dataScreen.statusDistribution') }}</span>
          </div>
          <div ref="statusChartRef" class="chart-container-status"></div>
        </div>
        
        <div class="business-card">
          <div class="business-title">{{ locale === 'zh-CN' ? '借展统计与修复统计' : 'Loan & Repair Stats' }}</div>
          <div class="business-stats">
            <div class="stat-item" @click="$router.push('/loans?status=待审批')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '借展待审批' : 'Loan Pending' }}</span>
              <span class="stat-value warning">{{ loanStats.pending || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/loans?status=借展中')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '借展中' : 'Loaning' }}</span>
              <span class="stat-value info">{{ loanStats.loaning || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/loans?status=已归还')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '已归还' : 'Returned' }}</span>
              <span class="stat-value success">{{ loanStats.returned || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/loans?status=已驳回')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '借展已拒绝' : 'Loan Rejected' }}</span>
              <span class="stat-value danger">{{ loanStats.rejected || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/loans?status=逾期')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '逾期' : 'Overdue' }}</span>
              <span class="stat-value danger">{{ loanStats.overdue || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/repairs?status=待审批')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '修复待审批' : 'Repair Pending' }}</span>
              <span class="stat-value warning">{{ repairStats.pending || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/repairs?status=待修复')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '待修复' : 'Waiting Repair' }}</span>
              <span class="stat-value warning">{{ repairStats.waitingRepair || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/repairs?status=修复中')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '修复中' : 'Repairing' }}</span>
              <span class="stat-value info">{{ repairStats.repairing || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/repairs?status=已完成')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '修复已完成' : 'Repair Completed' }}</span>
              <span class="stat-value success">{{ repairStats.completed || 0 }}</span>
            </div>
            <div class="stat-item" @click="$router.push('/repairs?status=已拒绝')">
              <span class="stat-label">{{ locale === 'zh-CN' ? '修复已拒绝' : 'Repair Rejected' }}</span>
              <span class="stat-value danger">{{ repairStats.rejected || 0 }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </el-card>
</template>

<script setup>
import { onMounted, onUnmounted, ref, computed, watch } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { 
  Box, 
  Promotion, 
  Tools, 
  Document, 
  Search 
} from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import { getDashboardDataApi } from '../api/reports'

const { t, locale } = useI18n()

const router = useRouter()
const currentTime = ref('')
const dashboardData = ref({})
const categoryChartRef = ref()
const statusChartRef = ref()
const eraChartRef = ref()

let categoryChart = null
let statusChart = null
let eraChart = null
let timer = null

const loanStats = computed(() => dashboardData.value.loanStats || {})
const repairStats = computed(() => dashboardData.value.repairStats || {})

// 分类名称映射
const translateCategoryName = (name) => {
  const categoryMap = {
    '青铜器': t('category.bronze'),
    '陶器': t('category.pottery'),
    '陶瓷器': t('category.ceramics'),
    '玉器': t('category.jade'),
    '瓷器': t('category.porcelain'),
    '书画': t('category.painting'),
    '雕塑': t('category.sculpture'),
    '家具': t('category.furniture'),
    '金银器': t('category.goldSilver'),
    '碑帖': t('category.stele'),
    '钱币': t('category.coin'),
    '石刻': t('category.stoneCarving'),
    '木器': t('category.woodware'),
    '漆器': t('category.lacquerware'),
    '织绣': t('category.textile'),
    '服饰': t('category.costume'),
    '杂项': t('category.miscellaneous'),
    '佛像': t('category.buddhaStatue'),
    '其他': t('category.other')
  }
  return categoryMap[name] || name
}

// 年代映射
const translateEra = (era) => {
  const eraMap = {
    '新石器时代': t('era.neolithic'),
    '夏朝': t('era.xia'),
    '商代': t('era.shang'),
    '商朝': t('era.shangChao'),
    '商周': t('era.shangZhou'),
    '西周': t('era.xiZhou'),
    '春秋': t('era.chunQiu'),
    '战国': t('era.zhanGuo'),
    '秦代': t('era.qin'),
    '秦朝': t('era.qinChao'),
    '秦汉': t('era.qinHan'),
    '汉代': t('era.han'),
    '汉朝': t('era.hanChao'),
    '东汉': t('era.dongHan'),
    '西汉': t('era.xiHan'),
    '三国': t('era.sanGuo'),
    '晋代': t('era.jin'),
    '金朝': t('era.jinChao'),
    '南北朝': t('era.nanBeiChao'),
    '北魏': t('era.beiWei'),
    '隋代': t('era.sui'),
    '隋朝': t('era.suiChao'),
    '唐代': t('era.tang'),
    '唐朝': t('era.tangChao'),
    '唐宋': t('era.tangSong'),
    '五代十国': t('era.wuDai'),
    '宋代': t('era.song'),
    '北宋': t('era.beiSong'),
    '南宋': t('era.nanSong'),
    '宋朝': t('era.songChao'),
    '辽朝': t('era.liao'),
    '西夏': t('era.xiXia'),
    '元代': t('era.yuan'),
    '元朝': t('era.yuanChao'),
    '明代': t('era.ming'),
    '明朝': t('era.mingChao'),
    '清代': t('era.qing'),
    '清朝': t('era.qingChao'),
    '明清': t('era.mingQing'),
    '近现代': t('era.modern'),
    '民国': t('era.minGuo'),
    '其他': t('era.other')
  }
  return eraMap[era] || era
}

const updateTime = () => {
  const now = new Date()
  currentTime.value = now.toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: false
  })
}

const loadData = async () => {
  try {
    const res = await getDashboardDataApi()
    dashboardData.value = res.data || {}
    
    // 更新图表
    updateCharts()
  } catch (error) {
    console.error('加载数据失败', error)
  }
}

const initCharts = () => {
  // 分类统计图表
  if (categoryChartRef.value) {
    categoryChart = echarts.init(categoryChartRef.value)
  }
  
  // 状态分布图表
  if (statusChartRef.value) {
    statusChart = echarts.init(statusChartRef.value)
  }
  
  // 年代分布图表
  if (eraChartRef.value) {
    eraChart = echarts.init(eraChartRef.value)
  }
  
  // 响应式
  window.addEventListener('resize', () => {
    categoryChart?.resize()
    statusChart?.resize()
    eraChart?.resize()
  })
}

const updateCharts = () => {
  // 分类统计
  if (categoryChart) {
    if (dashboardData.value.categoryStats && dashboardData.value.categoryStats.length > 0) {
      const categoryData = dashboardData.value.categoryStats.map(item => ({
        name: translateCategoryName(item.categoryName || item.category_name),
        value: item.count
      }))
      
      categoryChart.setOption({
        tooltip: { 
          trigger: 'item',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#e0e6ed',
          textStyle: { color: '#333' }
        },
        series: [{
          type: 'pie',
          radius: '65%',
          center: ['50%', '50%'],
          data: categoryData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(64, 158, 255, 0.3)'
            }
          },
          label: { 
            color: '#333', 
            fontSize: 14,
            formatter: '{b}\n{d}%'
          },
          color: ['#409eff', '#67c23a', '#e6a23c', '#f56c6c', '#909399', '#00d4ff']
        }]
      })
    } else {
      categoryChart.setOption({
        title: {
          text: t('common.noData'),
          left: 'center',
          top: 'center',
          textStyle: { color: '#999', fontSize: 14 }
        },
        series: []
      })
    }
  }
  
  // 状态分布
  if (statusChart) {
    const statusData = [
      { name: t('relic.inStock'), value: dashboardData.value.inStockRelics || 0 },
      { name: t('relic.onLoan'), value: dashboardData.value.loaningRelics || 0 },
      { name: t('relic.repairing'), value: dashboardData.value.repairingRelics || 0 }
    ]
    
    statusChart.setOption({
      tooltip: { 
        trigger: 'axis', 
        axisPointer: { type: 'shadow' },
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#e0e6ed',
        textStyle: { color: '#333' }
      },
      grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
      xAxis: {
        type: 'category',
        data: statusData.map(item => item.name),
        axisLabel: { color: '#666', fontSize: 12 },
        axisLine: { lineStyle: { color: '#e0e6ed' } }
      },
      yAxis: {
        type: 'value',
        axisLabel: { color: '#666', fontSize: 12 },
        splitLine: { lineStyle: { color: '#e0e6ed' } }
      },
      series: [{
        type: 'bar',
        data: statusData.map(item => item.value),
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#409eff' },
            { offset: 1, color: '#0066cc' }
          ])
        },
        barWidth: '50%'
      }]
    })
  }
  
  // 年代分布
  if (eraChart) {
    if (dashboardData.value.eraStats && dashboardData.value.eraStats.length > 0) {
      const eraData = dashboardData.value.eraStats.map(item => ({
        name: translateEra(item.era),
        value: item.count
      }))
      
      eraChart.setOption({
        tooltip: { 
          trigger: 'item',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#e0e6ed',
          textStyle: { color: '#333' }
        },
        series: [{
          type: 'pie',
          radius: '65%',
          center: ['50%', '50%'],
          data: eraData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(64, 158, 255, 0.3)'
            }
          },
          label: { 
            color: '#333', 
            fontSize: 14,
            formatter: '{b}\n{d}%'
          },
          color: ['#409eff', '#67c23a', '#e6a23c', '#f56c6c', '#909399', '#00d4ff', '#ff6b9d', '#c990ff']
        }]
      })
    } else {
      eraChart.setOption({
        title: {
          text: t('common.noData'),
          left: 'center',
          top: 'center',
          textStyle: { color: '#999', fontSize: 14 }
        },
        series: []
      })
    }
  }
}

// 监听语言变化，重新渲染图表
watch(locale, () => {
  updateCharts()
})

onMounted(() => {
  updateTime()
  timer = setInterval(updateTime, 1000)
  
  // 延迟初始化图表，确保DOM已渲染
  setTimeout(() => {
    initCharts()
    loadData()
  }, 100)
})

onUnmounted(() => {
  if (timer) clearInterval(timer)
  
  categoryChart?.dispose()
  statusChart?.dispose()
  eraChart?.dispose()
})
</script>

<style scoped>
.view-card {
  border-radius: 14px;
}

/* 工具栏 */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px;
}

.toolbar-left {
  display: flex;
  align-items: center;
  gap: 20px;
}

.toolbar-left h1 {
  font-size: 20px;
  margin: 0;
  color: #4f4235;
  font-weight: 600;
}

.current-time {
  font-size: 14px;
  color: #9b8d7d;
}

/* 快捷操作 */
.quick-actions {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.quick-actions .el-button {
  flex: 1;
  min-width: 140px;
}

/* 核心指标 */
.metrics-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

.metric-card {
  background: #fbf6ee;
  border-radius: 8px;
  padding: 24px;
  text-align: center;
  border: 1px solid #eee3d3;
  transition: all 0.3s;
  cursor: pointer;
}

.metric-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border-color: #d4c4a8;
}

.metric-icon {
  font-size: 40px;
  margin-bottom: 12px;
}

.metric-value {
  font-size: 36px;
  font-weight: 600;
  margin-bottom: 8px;
  color: #8b6f47;
}

.metric-label {
  font-size: 14px;
  color: #6c5037;
  margin-bottom: 8px;
}

.metric-trend {
  font-size: 14px;
  margin-top: 8px;
}

.trend-up {
  color: #52c41a;
}

.trend-down {
  color: #f5222d;
}

.trend-stable {
  color: #9b8d7d;
}

/* 第一行图表区域：分类统计和年代分布 */
.charts-row-top {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

/* 第二行：状态分布和业务统计 */
.charts-row-bottom {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 20px;
}

/* 图表卡片 */
.chart-card {
  background: #fbf6ee;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #eee3d3;
  transition: all 0.3s;
}

.chart-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee3d3;
}

.chart-title {
  font-size: 16px;
  font-weight: 600;
  color: #4f4235;
}

.chart-container {
  height: 320px;
}

.chart-container-large {
  height: 400px;
}

.chart-container-status {
  height: 380px;
}

.chart-large {
  min-width: 0;
}

.chart-status {
  min-width: 0;
}

/* 业务统计 */
.business-card {
  background: #fbf6ee;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #eee3d3;
  display: flex;
  flex-direction: column;
}

.business-card-full {
  width: 100%;
}

.business-title {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee3d3;
  color: #4f4235;
}

.business-stats {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 12px;
  flex: 1;
  align-content: start;
}

.stat-item {
  text-align: center;
  padding: 20px 12px;
  background: #fdfbf7;
  border-radius: 8px;
  transition: all 0.3s;
  cursor: pointer;
  border: 1px solid #eadfce;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.stat-item:hover {
  background: #fef5e7;
  transform: translateY(-2px);
  border-color: #409eff;
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.15);
}

.stat-label {
  display: block;
  font-size: 12px;
  color: #9b8d7d;
  margin-bottom: 10px;
}

.stat-value {
  display: block;
  font-size: 28px;
  font-weight: 600;
  color: #409eff;
}

.stat-value.success {
  color: #52c41a;
}

.stat-value.warning {
  color: #faad14;
}

.stat-value.danger {
  color: #f5222d;
}

.stat-value.info {
  color: #1890ff;
}

/* 响应式 */
@media (max-width: 1400px) {
  .charts-row-top {
    grid-template-columns: 1fr;
  }
  
  .charts-row-bottom {
    grid-template-columns: 1fr;
  }
  
  .business-stats {
    grid-template-columns: repeat(5, 1fr);
  }
}

@media (max-width: 1200px) {
  .metrics-row {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .business-stats {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .metrics-row {
    grid-template-columns: 1fr;
  }
  
  .charts-row-top {
    grid-template-columns: 1fr;
  }
  
  .charts-row-bottom {
    grid-template-columns: 1fr;
  }
  
  .business-stats {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .quick-actions {
    flex-wrap: wrap;
  }
  
  .screen-toolbar {
    flex-direction: column;
    gap: 15px;
  }
}
</style>
