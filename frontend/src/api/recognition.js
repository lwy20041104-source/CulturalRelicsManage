import request from './request'

/**
 * 上传图片进行识别
 * @param {File} file 图片文件
 * @returns {Promise}
 */
export const recognizeImageApi = (file) => {
  const formData = new FormData()
  formData.append('file', file)
  
  return request.post('/relic-recognition/recognize', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 通过URL识别图片
 * @param {string} imageUrl 图片URL
 * @returns {Promise}
 */
export const recognizeImageByUrlApi = (imageUrl) => {
  return request.post('/relic-recognition/recognize-by-url', {
    imageUrl
  })
}
