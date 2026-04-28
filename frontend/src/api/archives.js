import request from './request'

/**
 * 分页查询档案列表
 */
export function getArchivesApi(params) {
  return request.get('/archives', { params })
}

/**
 * 获取档案详情
 */
export function getArchiveByIdApi(id) {
  return request.get(`/archives/${id}`)
}

/**
 * 根据文物ID获取档案
 */
export function getArchiveByRelicIdApi(relicId) {
  return request.get(`/archives/relic/${relicId}`)
}

/**
 * 创建档案
 */
export function createArchiveApi(data) {
  return request.post('/archives', data)
}

/**
 * 更新档案
 */
export function updateArchiveApi(data) {
  return request.put('/archives', data)
}

/**
 * 删除档案
 */
export function deleteArchiveApi(id) {
  return request.delete(`/archives/${id}`)
}

/**
 * 上传档案文档
 */
export function uploadDocumentApi(archiveId, formData) {
  return request.post(`/archives/${archiveId}/documents`, formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 删除档案文档
 */
export function deleteDocumentApi(documentId) {
  return request.delete(`/archives/documents/${documentId}`)
}

/**
 * 获取档案文档列表
 */
export function getDocumentsApi(archiveId) {
  return request.get(`/archives/${archiveId}/documents`)
}

/**
 * 获取档案历史记录
 */
export function getHistoryApi(archiveId) {
  return request.get(`/archives/${archiveId}/history`)
}

/**
 * 发布档案
 */
export function publishArchiveApi(id) {
  return request.put(`/archives/${id}/publish`)
}

/**
 * 归档
 */
export function archiveArchiveApi(id) {
  return request.put(`/archives/${id}/archive`)
}

/**
 * 导出档案（PDF）
 */
export function exportPdfApi(id) {
  return request.get(`/archives/${id}/export/pdf`, {
    responseType: 'blob'
  })
}

/**
 * 导出档案（Word）
 */
export function exportWordApi(id) {
  return request.get(`/archives/${id}/export/word`, {
    responseType: 'blob'
  })
}

/**
 * 打印档案
 */
export function printArchiveApi(id) {
  return request.get(`/archives/${id}/print`)
}

/**
 * 生成档案编号
 */
export function generateCodeApi() {
  return request.get('/archives/generate-code')
}

/**
 * 获取可用于创建档案的文物列表（排除已有草稿档案的文物）
 */
export function getAvailableRelicsApi() {
  return request.get('/archives/available-relics')
}
