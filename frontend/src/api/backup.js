import request from './request'

/**
 * 分页查询备份列表
 */
export function getBackupListApi(params) {
  return request.get('/backup', { params })
}

/**
 * 创建手动备份
 */
export function createBackupApi(data) {
  return request.post('/backup', data)
}

/**
 * 删除备份
 */
export function deleteBackupApi(id) {
  return request.delete(`/backup/${id}`)
}

/**
 * 下载备份文件
 */
export function downloadBackupApi(id) {
  return request.get(`/backup/${id}/download`, {
    responseType: 'blob'
  })
}

/**
 * 恢复数据库
 */
export function restoreDatabaseApi(id) {
  return request.post(`/backup/${id}/restore`)
}

/**
 * 获取备份配置
 */
export function getBackupConfigApi() {
  return request.get('/backup/config')
}

/**
 * 更新备份配置
 */
export function updateBackupConfigApi(data) {
  return request.put('/backup/config', data)
}

/**
 * 清理过期备份
 */
export function cleanExpiredBackupsApi() {
  return request.post('/backup/clean')
}
