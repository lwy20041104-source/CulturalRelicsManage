import request from './request'

export const getCategoriesApi = (params) => request.get('/categories', { params })
export const addCategoryApi = (data) => request.post('/categories', data)
export const updateCategoryApi = (data) => request.put('/categories', data)
export const deleteCategoryApi = (id) => request.delete(`/categories/${id}`)
