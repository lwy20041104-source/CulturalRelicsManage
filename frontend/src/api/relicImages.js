import request from './request'

/**
 * 文物图片管理API
 */

/**
 * 获取文物的所有图片
 * @param {Number} relicId 文物ID
 */
export const getRelicImagesApi = (relicId) => {
  return request.get(`/relic-images/list/${relicId}`)
}

/**
 * 获取文物的主图信息
 * @param {Number} relicId 文物ID
 */
export const getRelicMainImageApi = (relicId) => {
  return request.get(`/relic-images/relic/${relicId}`)
}

/**
 * 获取文物的主图路径
 * @param {Number} relicId 文物ID
 */
export const getRelicImagePathApi = (relicId) => {
  return request.get(`/relic-images/path/${relicId}`)
}

/**
 * 批量上传文物图片
 * @param {Number} relicId 文物ID
 * @param {FileList} files 文件列表
 */
export const batchUploadImagesApi = (relicId, files) => {
  const formData = new FormData()
  for (let i = 0; i < files.length; i++) {
    formData.append('files', files[i])
  }
  return request.post(`/relic-images/batch-upload/${relicId}`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 上传单张文物图片
 * @param {Number} relicId 文物ID
 * @param {File} file 文件
 */
export const uploadRelicImageApi = (relicId, file) => {
  const formData = new FormData()
  formData.append('file', file)
  return request.post(`/relic-images/upload/${relicId}`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 设置主图
 * @param {Number} relicId 文物ID
 * @param {Number} imageId 图片ID
 */
export const setMainImageApi = (relicId, imageId) => {
  return request.put('/relic-images/set-main', { relicId, imageId })
}

/**
 * 删除文物图片
 * @param {Number} relicId 文物ID
 * @param {Number} imageId 图片ID
 */
export const deleteRelicImageApi = (relicId, imageId) => {
  return request.delete(`/relic-images/${relicId}/${imageId}`)
}

/**
 * 为文物设置主图（从已有图片库中选择）
 * @param {Number} relicId 文物ID
 * @param {Number} imageId 图片ID
 */
export const setRelicMainImageApi = (relicId, imageId) => {
  return request.post('/relic-images/set', null, {
    params: { relicId, imageId }
  })
}

/**
 * 移除文物主图
 * @param {Number} relicId 文物ID
 */
export const removeRelicMainImageApi = (relicId) => {
  return request.delete(`/relic-images/remove/${relicId}`)
}

/**
 * 批量获取文物的图片路径
 * @param {Array} relicIds 文物ID列表
 */
export const getRelicImagePathsApi = (relicIds) => {
  return request.post('/relic-images/paths', relicIds)
}

/**
 * 根据图片ID查询关联的文物
 * @param {Number} imageId 图片ID
 */
export const getRelicByImageIdApi = (imageId) => {
  return request.get(`/relic-images/image/${imageId}`)
}

/**
 * 获取文物图片统计
 */
export const getRelicImageStatisticsApi = () => {
  return request.get('/relic-images/statistics')
}

/**
 * 查询所有文物图片关联
 */
export const getAllRelicImagesApi = () => {
  return request.get('/relic-images/all')
}
