import request from './request'

// 分页查询博物馆列表
export const getMuseumsPageApi = (params) => request.get('/museums', { params })

// 获取所有启用的博物馆（用于下拉选择）
export const getActiveMuseumsApi = () => request.get('/museums/active')

// 根据ID获取博物馆详情
export const getMuseumByIdApi = (id) => request.get(`/museums/${id}`)

// 获取用户关联的博物馆
export const getUserMuseumApi = (userId) => request.get(`/users/${userId}/museum`)

// 新增博物馆
export const addMuseumApi = (data) => request.post('/museums', data)

// 更新博物馆
export const updateMuseumApi = (id, data) => request.put(`/museums/${id}`, data)

// 删除博物馆
export const deleteMuseumApi = (id) => request.delete(`/museums/${id}`)
