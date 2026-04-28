import request from './request'

export const getOperationLogsPageApi = (params) => {
  return request.get('/api/operation-logs/page', { params })
}

export const getOperationLogByIdApi = (id) => {
  return request.get(`/api/operation-logs/${id}`)
}
