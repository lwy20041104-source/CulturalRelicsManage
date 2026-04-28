import request from './request'

/**
 * 获取用户通知列表
 */
export const getNotificationsApi = (params) => {
  return request.get('/notifications/list', { params })
}

/**
 * 标记通知为已读
 */
export const markAsReadApi = (id) => {
  return request.put(`/notifications/${id}/read`)
}

/**
 * 批量标记为已读
 */
export const markAllAsReadApi = (notificationIds) => {
  return request.put('/notifications/read-all', notificationIds)
}

/**
 * 获取未读通知数量
 */
export const getUnreadCountApi = () => {
  return request.get('/notifications/unread-count')
}

/**
 * 删除通知
 */
export const deleteNotificationApi = (id) => {
  return request.delete(`/notifications/${id}`)
}

/**
 * 获取通知统计信息
 */
export const getNotificationStatisticsApi = (params) => {
  return request.get('/notifications/statistics', { params })
}
