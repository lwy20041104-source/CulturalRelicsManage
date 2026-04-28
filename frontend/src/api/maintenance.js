import request from './request'

export const getMaintenancePageApi = (params) => request.get('/maintenance', { params })
export const addMaintenanceApi = (data) => request.post('/maintenance', data)
export const updateMaintenanceApi = (data) => request.put('/maintenance', data)
export const deleteMaintenanceApi = (id) => request.delete(`/maintenance/${id}`)
