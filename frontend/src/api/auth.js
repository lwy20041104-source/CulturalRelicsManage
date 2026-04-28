import request from './request'

export const loginApi = (data) => request.post('/auth/login', data)
export const registerApi = (data) => request.post('/auth/register', data)
export const logoutApi = () => request.post('/auth/logout')
export const getUserInfoApi = (username) => request.get('/auth/user-info', { params: { username } })
export const getPermissionsApi = (username) => request.get('/auth/permissions', { params: { username } })

// 密码重置相关API
export const forgotPasswordApi = (data) => request.post('/auth/forgot-password', data)
export const verifyCodeApi = (username, code) => request.post('/auth/verify-code', null, { params: { username, code } })
export const resetPasswordApi = (data) => request.post('/auth/reset-password', data)
