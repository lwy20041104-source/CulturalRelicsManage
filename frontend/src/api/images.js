import request from './request'

/**
 * 上传图片
 */
export const uploadImageApi = (formData) => {
  return request.post('/images/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/**
 * 批量上传图片
 */
export const batchUploadImagesApi = (formData) => {
  return request.post('/images/batch-upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/**
 * 分页查询图片
 */
export const getImagesPageApi = (params) => {
  return request.get('/images', { params })
}

/**
 * 获取图片详情
 */
export const getImageByIdApi = (id) => {
  return request.get(`/images/${id}`)
}

/**
 * 更新图片信息
 */
export const updateImageApi = (id, data) => {
  return request.put(`/images/${id}`, null, { params: data })
}

/**
 * 删除图片
 */
export const deleteImageApi = (id) => {
  return request.delete(`/images/${id}`)
}

/**
 * 批量删除图片
 */
export const batchDeleteImagesApi = (ids) => {
  return request.delete('/images/batch', { data: ids })
}

/**
 * 物理删除图片
 */
export const physicalDeleteImageApi = (id) => {
  return request.delete(`/images/${id}/physical`)
}

/**
 * 关联图片到对象
 */
export const linkImageToReferenceApi = (id, referenceType, referenceId) => {
  return request.put(`/images/${id}/link`, null, {
    params: { referenceType, referenceId }
  })
}

/**
 * 获取关联的图片列表
 */
export const getImagesByReferenceApi = (referenceType, referenceId) => {
  return request.get(`/images/reference/${referenceType}/${referenceId}`)
}

/**
 * 下载图片
 */
export const downloadImageApi = (id) => {
  return request.get(`/images/${id}/download`, {
    responseType: 'blob'
  })
}

/**
 * 搜索图片
 */
export const searchImagesApi = (keyword) => {
  return request.get('/images/search', { params: { keyword } })
}

/**
 * 获取统计信息
 */
export const getImageStatisticsApi = () => {
  return request.get('/images/statistics')
}
