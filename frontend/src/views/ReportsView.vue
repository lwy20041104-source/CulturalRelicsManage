<template>
  <el-card class="view-card">
    <el-tabs v-model="activeTab" type="border-card">
      <!-- 年度报告 -->
      <el-tab-pane :label="$t('report.annualReport')" name="annual">
        <div class="tab-content">
          <div class="toolbar">
            <el-select v-model="annualYear" style="width: 150px">
              <el-option v-for="y in years" :key="y" :label="`${y}${$t('report.year')}`" :value="y" />
            </el-select>
            <el-button type="primary" @click="loadAnnualReport">{{ $t('report.query') }}</el-button>
            <el-button @click="exportReport('annual', annualYear)">{{ $t('report.exportExcel') }}</el-button>
          </div>
          
          <div v-if="annualData" class="report-content">
            <div class="summary-cards">
              <div class="summary-card">
                <div class="card-label">{{ $t('report.annualLoans') }}</div>
                <div class="card-value">{{ annualData.annualLoans || 0 }}</div>
              </div>
              <div class="summary-card">
                <div class="card-label">{{ $t('report.annualMaintenance') }}</div>
                <div class="card-value">{{ annualData.annualMaintenance || 0 }}</div>
              </div>
              <div class="summary-card">
                <div class="card-label">{{ $t('report.annualRepairs') }}</div>
                <div class="card-value">{{ annualData.annualRepairs || 0 }}</div>
              </div>
              <div class="summary-card">
                <div class="card-label">{{ $t('report.newRelics') }}</div>
                <div class="card-value">{{ annualData.newRelicsCount || 0 }}</div>
              </div>
            </div>
            
            <div ref="annualChartRef" class="chart" style="height: 400px;"></div>
          </div>
        </div>
      </el-tab-pane>

      <!-- 趋势分析 -->
      <el-tab-pane :label="$t('report.trendAnalysis')" name="trend">
        <div class="tab-content">
          <div class="toolbar">
            <el-date-picker
              v-model="trendDateRange"
              type="daterange"
              range-separator="-"
              :start-placeholder="$t('report.startDate')"
              :end-placeholder="$t('report.endDate')"
              value-format="YYYY-MM-DD"
            />
            <el-select v-model="trendType" style="width: 150px">
              <el-option :label="$t('report.loanTrend')" value="loan" />
              <el-option :label="$t('report.maintenanceTrend')" value="maintenance" />
              <el-option :label="$t('report.repairTrend')" value="repair" />
              <el-option :label="$t('report.relicTrend')" value="relic" />
            </el-select>
            <el-button type="primary" @click="loadTrendAnalysis">{{ $t('report.analyze') }}</el-button>
          </div>
          
          <div ref="trendChartRef" class="chart" style="height: 450px;"></div>
        </div>
      </el-tab-pane>

      <!-- 对比分析 -->
      <el-tab-pane :label="$t('report.comparisonAnalysis')" name="comparison">
        <div class="tab-content">
          <div class="toolbar">
            <el-select v-model="comparisonYear1" style="width: 150px">
              <el-option v-for="y in years" :key="y" :label="`${y}${$t('report.year')}`" :value="y" />
            </el-select>
            <span style="margin: 0 10px;">vs</span>
            <el-select v-model="comparisonYear2" style="width: 150px">
              <el-option v-for="y in years" :key="y" :label="`${y}${$t('report.year')}`" :value="y" />
            </el-select>
            <el-button type="primary" @click="loadComparisonAnalysis">{{ $t('report.compare') }}</el-button>
          </div>
          
          <div v-if="comparisonData" class="comparison-content">
            <div ref="comparisonChartRef" class="chart" style="height: 400px;"></div>
            
            <div class="growth-rate">
              <h3>{{ $t('report.yearComparison') }}</h3>
              <el-table :data="growthRateData" border>
                <el-table-column prop="type" :label="$t('common.status')" />
                <el-table-column prop="year1" :label="`${comparisonYear1}${$t('report.year')}`" />
                <el-table-column prop="year2" :label="`${comparisonYear2}${$t('report.year')}`" />
                <el-table-column prop="rate" :label="$t('report.yearComparison')">
                  <template #default="scope">
                    <span :class="scope.row.rate >= 0 ? 'positive' : 'negative'">
                      {{ scope.row.rate >= 0 ? '+' : '' }}{{ scope.row.rate.toFixed(2) }}%
                    </span>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </div>
        </div>
      </el-tab-pane>
    </el-tabs>
  </el-card>
</template>

<script setup>
import { onMounted, ref, computed, nextTick } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts'
import {
  getAnnualReportApi,
  getTrendAnalysisApi,
  getComparisonAnalysisApi
} from '../api/reports'

const { t } = useI18n()

const activeTab = ref('annual')
const annualYear = ref(new Date().getFullYear())
const annualData = ref(null)
const annualChartRef = ref()
let annualChart = null

const trendDateRange = ref([])
const trendType = ref('loan')
const trendChartRef = ref()
let trendChart = null

const comparisonYear1 = ref(new Date().getFullYear() - 1)
const comparisonYear2 = ref(new Date().getFullYear())
const comparisonData = ref(null)
const comparisonChartRef = ref()
let comparisonChart = null

const years = computed(() => {
  const currentYear = new Date().getFullYear()
  return Array.from({ length: 10 }, (_, i) => currentYear - i)
})

const growthRateData = computed(() => {
  if (!comparisonData.value) return []
  
  const { year1Data, year2Data, growthRate } = comparisonData.value
  
  return [
    {
      type: t('report.loans'),
      year1: year1Data.loans,
      year2: year2Data.loans,
      rate: growthRate.loans
    },
    {
      type: t('report.maintenance'),
      year1: year1Data.maintenance,
      year2: year2Data.maintenance,
      rate: growthRate.maintenance
    },
    {
      type: t('report.repairs'),
      year1: year1Data.repairs,
      year2: year2Data.repairs,
      rate: growthRate.repairs
    }
  ]
})

const loadAnnualReport = async () => {
  try {
    const res = await getAnnualReportApi(annualYear.value)
    annualData.value = res.data
    
    // 等待DOM更新后再初始化图表
    await nextTick()
    
    // 绘制图表
    if (!annualChart && annualChartRef.value) {
      annualChart = echarts.init(annualChartRef.value)
    }
    
    if (!annualChart) {
      console.error('图表初始化失败: annualChartRef未找到')
      return
    }
    
    const monthlyTrend = annualData.value.monthlyTrend || []
    
    annualChart.setOption({
      title: { text: `${annualYear.value}${t('report.year')}${t('report.monthlyTrend')}` },
      tooltip: { trigger: 'axis' },
      legend: { data: [t('report.loans'), t('report.maintenance'), t('report.repairs'), t('report.newRelics')] },
      xAxis: {
        type: 'category',
        data: monthlyTrend.map(item => `${item.month}${t('dataScreen.january').replace('Jan', '').replace('1月', '月')}`)
      },
      yAxis: { type: 'value' },
      series: [
        {
          name: t('report.loans'),
          type: 'line',
          data: monthlyTrend.map(item => item.loans),
          smooth: true
        },
        {
          name: t('report.maintenance'),
          type: 'line',
          data: monthlyTrend.map(item => item.maintenance),
          smooth: true
        },
        {
          name: t('report.repairs'),
          type: 'line',
          data: monthlyTrend.map(item => item.repairs),
          smooth: true
        },
        {
          name: t('report.newRelics'),
          type: 'line',
          data: monthlyTrend.map(item => item.newRelics || 0),
          smooth: true
        }
      ]
    })
  } catch (error) {
    console.error('加载年度报告失败:', error)
    ElMessage.error(t('report.loadFailed'))
  }
}

const loadTrendAnalysis = async () => {
  if (!trendDateRange.value || trendDateRange.value.length !== 2) {
    ElMessage.warning(t('report.selectDateRange'))
    return
  }
  
  try {
    const [startDate, endDate] = trendDateRange.value
    const res = await getTrendAnalysisApi(startDate, endDate, trendType.value)
    
    // 等待DOM更新后再初始化图表
    await nextTick()
    
    if (!trendChart && trendChartRef.value) {
      trendChart = echarts.init(trendChartRef.value)
    }
    
    if (!trendChart) {
      console.error('趋势图表初始化失败: trendChartRef未找到')
      return
    }
    
    const dataPoints = res.data.dataPoints || []
    
    trendChart.setOption({
      title: { text: t('report.trendAnalysis') },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: dataPoints.map(item => item.date)
      },
      yAxis: { type: 'value' },
      series: [{
        type: 'line',
        data: dataPoints.map(item => item.count),
        smooth: true,
        areaStyle: {}
      }]
    })
  } catch (error) {
    console.error('加载趋势分析失败:', error)
    ElMessage.error(t('report.loadFailed'))
  }
}

const loadComparisonAnalysis = async () => {
  try {
    const res = await getComparisonAnalysisApi(comparisonYear1.value, comparisonYear2.value)
    comparisonData.value = res.data
    
    console.log('对比分析数据:', comparisonData.value)
    
    // 等待DOM更新后再初始化图表
    await nextTick()
    
    if (!comparisonChart && comparisonChartRef.value) {
      comparisonChart = echarts.init(comparisonChartRef.value)
    }
    
    if (!comparisonChart) {
      console.error('对比图表初始化失败: comparisonChartRef未找到')
      return
    }
    
    const { year1Data, year2Data } = comparisonData.value
    
    comparisonChart.setOption({
      title: { text: t('report.yearComparison') },
      tooltip: { trigger: 'axis' },
      legend: { data: [`${comparisonYear1.value}${t('report.year')}`, `${comparisonYear2.value}${t('report.year')}`] },
      xAxis: {
        type: 'category',
        data: [t('report.loans'), t('report.maintenance'), t('report.repairs'), t('report.relics')]
      },
      yAxis: { type: 'value' },
      series: [
        {
          name: `${comparisonYear1.value}${t('report.year')}`,
          type: 'bar',
          data: [year1Data.loans, year1Data.maintenance, year1Data.repairs, year1Data.relics || 0]
        },
        {
          name: `${comparisonYear2.value}${t('report.year')}`,
          type: 'bar',
          data: [year2Data.loans, year2Data.maintenance, year2Data.repairs, year2Data.relics || 0]
        }
      ]
    })
  } catch (error) {
    console.error('加载对比分析失败:', error)
    ElMessage.error(t('report.loadFailed'))
  }
}

const exportReport = async (reportType, year) => {
  try {
    const { exportExcelApi } = await import('../api/reports')
    const res = await exportExcelApi(reportType, year)
    const blob = new Blob([res])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${t('report.report')}_${reportType}_${year || new Date().getFullYear()}_${new Date().getTime()}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('report.exportExcel') + t('common.success'))
  } catch (error) {
    console.error('导出报表失败:', error)
    ElMessage.error(t('message.operationFailed'))
  }
}

onMounted(() => {
  loadAnnualReport()
})
</script>

<style scoped>
.view-card {
  border-radius: 14px;
}

.tab-content {
  padding: 20px;
}

.toolbar {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 20px;
}

.summary-cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

.summary-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 30px;
  text-align: center;
  color: #fff;
}

.card-label {
  font-size: 16px;
  margin-bottom: 10px;
  opacity: 0.9;
}

.card-value {
  font-size: 36px;
  font-weight: bold;
}

.chart {
  margin-top: 20px;
}

.comparison-content {
  margin-top: 20px;
}

.growth-rate {
  margin-top: 30px;
}

.growth-rate h3 {
  margin-bottom: 15px;
}

.positive {
  color: #52c41a;
  font-weight: bold;
}

.negative {
  color: #f5222d;
  font-weight: bold;
}
</style>
