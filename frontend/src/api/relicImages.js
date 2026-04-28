import request from './request'

/**
 * 文物图片关联API
 */

// 为文物上传并设置主图
export const uploadRelicImageApi = (relicId, file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request.post(`/relic-images/upload/${relicId}`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 为文物设置主图（从已有图片库中选择）
export const setRelicMainImageApi = (relicId, imageId) => {
  return request.post('/relic-images/set', null, {
    params: { relicId, imageId }
  })
}

// 移除文物主图
export const removeRelicMainImageApi = (relicId) => {
  return request.delete(`/relic-images/remove/${relicId}`)
}

// 获取文物的主图信息
export const getRelicMainImageApi = (relicId) => {
  return request.get(`/relic-images/relic/${relicId}`)
}

// 获取文物的主图路径
export const getRelicImagePathApi = (relicId) => {
  return request.get(`/relic-images/path/${relicId}`)
}

// 批量获取文物的图片路径
export const getRelicImagePathsApi = (relicIds) => {
  return request.post('/relic-images/paths', relicIds)
}

// 根据图片ID查询关联的文物
export const getRelicByImageIdApi = (imageId) => {
  return request.get(`/relic-images/image/${imageId}`)
}

// 统计有主图和无主图的文物数量
export const getRelicImageStatisticsApi = () => {
  return request.get('/relic-images/statistics')
}

// 查询所有关联
export const getAllRelicImageRelationsApi = () => {
  return request.get('/relic-images/all')
}
