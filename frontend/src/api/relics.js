import request from './request'

export const getRelicsPageApi = (params) => request.get('/relics', { params })
export const addRelicApi = (data) => request.post('/relics', data)

// 新增文物（支持图片上传）
export const addRelicWithImageApi = (formData) => {
  return request.post('/relics/with-image', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export const updateRelicApi = (data) => request.put('/relics', data)
export const deleteRelicApi = (id) => request.delete(`/relics/${id}`)

// 批量操作
export const batchDeleteRelicsApi = (ids) => request.delete('/relics/batch', { data: ids })
export const batchUpdateStatusApi = (ids, status) => request.put('/relics/batch/status', { ids, status })

// 导入导出
export const exportRelicsApi = (params) => {
  return request.get('/relics/export', {
    params,
    responseType: 'blob'
  })
}

export const exportRelicsPdfApi = (params) => {
  return request.get('/relics/export/pdf', {
    params,
    responseType: 'blob'
  })
}

export const exportRelicsWordApi = (params) => {
  return request.get('/relics/export/word', {
    params,
    responseType: 'blob'
  })
}

export const importRelicsApi = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request.post('/relics/import', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

export const downloadTemplateApi = () => {
  return request.get('/relics/template', {
    responseType: 'blob'
  })
}

// 获取可用于修复的文物列表
export const getAvailableForRepairApi = () => request.get('/relics/available-for-repair')

// 上传文物图片（使用新的关联方式）
export const uploadRelicImageApi = (id, file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request.post(`/relics/${id}/images`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 根据ID获取文物详情
export const getRelicByIdApi = (id) => request.get(`/relics/${id}`)

// 生成文物二维码
export const generateQRCodeApi = (id, baseUrl) => {
  return request.get(`/relics/${id}/qrcode`, {
    params: { baseUrl }
  })
}

// 批量生成文物二维码
export const batchGenerateQRCodeApi = (ids, baseUrl) => {
  return request.post('/relics/batch/qrcode', ids, {
    params: { baseUrl }
  })
}
