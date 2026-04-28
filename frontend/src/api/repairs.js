import request from './request'

/**
 * 分页查询修复记录
 */
export const getRepairsPageApi = (params) => {
  return request.get('/repairs', { params })
}

/**
 * 根据ID查询修复记录详情
 */
export const getRepairByIdApi = (id) => {
  return request.get(`/repairs/${id}`)
}

/**
 * 根据文物ID查询修复记录列表
 */
export const getRepairsByRelicIdApi = (relicId) => {
  return request.get(`/repairs/relic/${relicId}`)
}

/**
 * 提交修复申请
 */
export const applyRepairApi = (data) => {
  return request.post('/repairs/apply', data)
}

/**
 * 更新修复申请（仅限待审批状态）
 */
export const updateRepairApplyApi = (id, data) => {
  return request.put(`/repairs/apply/${id}`, data)
}

/**
 * 审批修复申请
 */
export const approveRepairApi = (data) => {
  return request.put('/repairs/approve', data)
}

/**
 * 开始修复
 */
export const startRepairApi = (id) => {
  return request.put(`/repairs/${id}/start`)
}

/**
 * 更新修复进度
 */
export const updateProgressApi = (data) => {
  return request.put('/repairs/progress', data)
}

/**
 * 完成修复
 */
export const completeRepairApi = (id, data) => {
  return request.put(`/repairs/${id}/complete`, data)
}

/**
 * 删除修复记录
 */
export const deleteRepairApi = (id) => {
  return request.delete(`/repairs/${id}`)
}

/**
 * 统计各状态数量
 */
export const getRepairStatusStatsApi = () => {
  return request.get('/repairs/statistics/status')
}

/**
 * 查询所有启用的专家
 */
export const getEnabledExpertsApi = () => {
  return request.get('/repair-experts/enabled')
}

/**
 * 分页查询专家
 */
export const getExpertsPageApi = (params) => {
  return request.get('/repair-experts', { params })
}

/**
 * 新增专家
 */
export const addExpertApi = (data) => {
  return request.post('/repair-experts', data)
}

/**
 * 更新专家
 */
export const updateExpertApi = (data) => {
  return request.put('/repair-experts', data)
}

/**
 * 删除专家
 */
export const deleteExpertApi = (id) => {
  return request.delete(`/repair-experts/${id}`)
}
