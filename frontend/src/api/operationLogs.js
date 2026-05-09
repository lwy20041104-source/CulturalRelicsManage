import request from './request'

export const getOperationLogsPageApi = (params) => {
  return request.get('/operation-logs/page', { params })
}

export const getOperationLogByIdApi = (id) => {
  return request.get(`/operation-logs/${id}`)
}
