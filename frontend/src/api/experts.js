import request from './request'

/**
 * 查询所有启用的专家（用于下拉选择）
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
 * 根据ID查询专家详情
 */
export const getExpertByIdApi = (id) => {
  return request.get(`/repair-experts/${id}`)
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
