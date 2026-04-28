import request from './request'

export const getLoansPageApi = (params) => request.get('/loans', { params })
export const addLoanApi = (data) => request.post('/loans', data)
export const approveLoanApi = (data) => request.put('/loans/approve', data)
export const returnLoanApi = (id) => request.put(`/loans/${id}/return`)

// 前台用户端接口
export const getMyLoansPageApi = (params) => request.get('/loans/my', { params })
export const userReturnLoanApi = (id) => request.put(`/loans/${id}/user-return`)
