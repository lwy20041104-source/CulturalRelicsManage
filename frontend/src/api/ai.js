import request from './request'

export const queryRelicAiApi = (question, matchAll = false) => request.post('/ai/relics/query', { question, matchAll })
