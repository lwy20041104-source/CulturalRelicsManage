import request from './request'

/**
 * 获取材料列表（分页）
 */
export function getMaterialList(params) {
  return request({
    url: '/repair-materials',
    method: 'get',
    params
  })
}

/**
 * 获取所有材料（用于下拉选择）
 */
export function getAllMaterials() {
  return request({
    url: '/repair-materials/all',
    method: 'get'
  })
}

/**
 * 根据ID获取材料
 */
export function getMaterialById(id) {
  return request({
    url: `/repair-materials/${id}`,
    method: 'get'
  })
}

/**
 * 创建材料
 */
export function createMaterial(data) {
  return request({
    url: '/repair-materials',
    method: 'post',
    data
  })
}

/**
 * 更新材料
 */
export function updateMaterial(id, data) {
  return request({
    url: `/repair-materials/${id}`,
    method: 'put',
    data
  })
}

/**
 * 删除材料
 */
export function deleteMaterial(id) {
  return request({
    url: `/repair-materials/${id}`,
    method: 'delete'
  })
}

/**
 * 更新库存
 */
export function updateStock(id, quantity) {
  return request({
    url: `/repair-materials/${id}/stock`,
    method: 'put',
    params: { quantity }
  })
}

/**
 * 获取材料类别列表
 */
export function getCategories() {
  return request({
    url: '/repair-materials/categories',
    method: 'get'
  })
}

/**
 * 获取库存不足的材料
 */
export function getLowStockMaterials(threshold = 10) {
  return request({
    url: '/repair-materials/low-stock',
    method: 'get',
    params: { threshold }
  })
}

/**
 * 获取材料使用统计
 */
export function getMaterialStatistics(id) {
  return request({
    url: `/repair-materials/${id}/statistics`,
    method: 'get'
  })
}

/**
 * 添加材料使用记录
 */
export function addMaterialUsage(data) {
  return request({
    url: '/repair-materials/usage',
    method: 'post',
    data
  })
}

/**
 * 获取修复记录的材料列表
 */
export function getRepairRecordMaterials(repairRecordId) {
  return request({
    url: `/repair-materials/repair-record/${repairRecordId}`,
    method: 'get'
  })
}

/**
 * 删除材料使用记录
 */
export function deleteMaterialUsage(id) {
  return request({
    url: `/repair-materials/usage/${id}`,
    method: 'delete'
  })
}
