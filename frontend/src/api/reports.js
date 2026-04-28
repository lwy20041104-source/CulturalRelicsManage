import request from './request'

/**
 * 获取数据大屏数据
 */
export const getDashboardDataApi = () => {
  return request.get('/reports/dashboard')
}

/**
 * 获取年度统计报告
 */
export const getAnnualReportApi = (year) => {
  return request.get('/reports/annual', { params: { year } })
}

/**
 * 获取趋势分析数据
 */
export const getTrendAnalysisApi = (startDate, endDate, type) => {
  return request.get('/reports/trend', {
    params: { startDate, endDate, type }
  })
}

/**
 * 获取对比分析数据
 */
export const getComparisonAnalysisApi = (year1, year2) => {
  return request.get('/reports/comparison', {
    params: { year1, year2 }
  })
}

/**
 * 获取分类统计
 */
export const getCategoryStatsApi = () => {
  return request.get('/reports/category-stats')
}

/**
 * 获取状态统计
 */
export const getStatusStatsApi = () => {
  return request.get('/reports/status-stats')
}

/**
 * 导出Excel报表
 */
export const exportExcelApi = (reportType, year) => {
  return request.get('/reports/export/excel', {
    params: { reportType, year },
    responseType: 'blob'
  })
}

/**
 * 导出PDF报表
 */
export const exportPdfApi = (reportType, year) => {
  return request.get('/reports/export/pdf', {
    params: { reportType, year },
    responseType: 'blob'
  })
}

/**
 * 自定义报表查询
 */
export const getCustomReportApi = (params) => {
  return request.post('/reports/custom', params)
}
