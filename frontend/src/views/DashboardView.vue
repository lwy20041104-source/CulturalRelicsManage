<template>
  <div>
    <el-row :gutter="16" class="cards">
      <el-col :span="6"><el-card><div class="stat"><div>{{ $t('dataScreen.totalRelics') }}</div><h2>{{ overview.relicTotal || 0 }}</h2></div></el-card></el-col>
      <el-col :span="6"><el-card><div class="stat"><div>{{ $t('dataScreen.inStock') }}</div><h2>{{ overview.inStockTotal || 0 }}</h2></div></el-card></el-col>
      <el-col :span="6"><el-card><div class="stat"><div>{{ $t('dataScreen.onLoan') }}</div><h2>{{ overview.loaningTotal || 0 }}</h2></div></el-card></el-col>
      <el-col :span="6"><el-card><div class="stat"><div>{{ $t('maintenance.title') }}</div><h2>{{ overview.maintenanceTotal || 0 }}</h2></div></el-card></el-col>
    </el-row>

    <el-row :gutter="16" class="charts">
      <el-col :span="12"><el-card><div ref="statusChartRef" class="chart"></div></el-card></el-col>
      <el-col :span="12"><el-card><div ref="loanChartRef" class="chart"></div></el-card></el-col>
    </el-row>
  </div>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import * as echarts from 'echarts'
import { getOverviewApi, getStatusDistributionApi, getLoanFrequencyApi } from '../api/statistics'

const { t } = useI18n()

const overview = reactive({})
const statusChartRef = ref(null)
const loanChartRef = ref(null)

const initCharts = async () => {
  const statusRes = await getStatusDistributionApi()
  const loanRes = await getLoanFrequencyApi()

  const statusChart = echarts.init(statusChartRef.value)
  
  // 状态名称国际化映射
  const statusNameMap = {
    '在库': t('relic.inStock'),
    '借展中': t('relic.onLoan'),
    '修复中': t('relic.repairing'),
    '封存': t('relic.sealed')
  }
  
  // 转换状态数据，使用国际化名称
  const statusData = Object.entries(statusRes.data || {}).map(([name, value]) => ({
    name: statusNameMap[name] || name,
    value
  }))
  
  statusChart.setOption({
    title: { text: t('dataScreen.statusDistribution') },
    tooltip: { trigger: 'item' },
    series: [{ type: 'pie', radius: '65%', data: statusData }]
  })

  const loanChart = echarts.init(loanChartRef.value)
  loanChart.setOption({
    title: { text: t('dataScreen.loanStats') },
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'category', data: Object.keys(loanRes.data || {}) },
    yAxis: { type: 'value' },
    series: [{ type: 'bar', data: Object.values(loanRes.data || {}) }]
  })
}

onMounted(async () => {
  const res = await getOverviewApi()
  Object.assign(overview, res.data || {})
  await initCharts()
})
</script>

<style scoped>
.cards { margin-bottom: 16px; }

.stat {
  color: #5f4f3d;
}

.stat h2 {
  margin: 10px 0 0;
  font-size: 30px;
  color: #2f2a24;
  letter-spacing: 0.5px;
}

.chart {
  height: 340px;
}
</style>
