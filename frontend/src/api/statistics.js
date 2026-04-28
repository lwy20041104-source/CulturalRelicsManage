import request from './request'

export const getOverviewApi = () => request.get('/statistics/overview')
export const getCategoryDistributionApi = () => request.get('/statistics/category-distribution')
export const getLoanFrequencyApi = () => request.get('/statistics/loan-frequency')
export const getStatusDistributionApi = () => request.get('/statistics/status-distribution')
