import request from './request'

export const getUsersPageApi = (params) => request.get('/users', { params })
export const getUserRolesApi = () => request.get('/users/roles')
export const addUserApi = (data) => request.post('/users', data)
export const updateUserApi = (data) => request.put('/users', data)
export const deleteUserApi = (id) => request.delete(`/users/${id}`)

// 个人信息相关API
export const getProfileApi = () => request.get('/users/profile')
export const updateProfileApi = (data) => request.put('/users/profile', data)

// 用户解锁
export const unlockUserApi = (userId) => request.post(`/users/${userId}/unlock`)
export const unlockUserByUsernameApi = (username) => request.post('/users/unlock-by-username', null, { params: { username } })
