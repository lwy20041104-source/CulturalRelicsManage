import request from './request'

// 创建新会话
export const createSessionApi = (title) => {
  return request.post('/ai-chat/sessions', { title })
}

// 获取用户的会话列表
export const getSessionsApi = () => {
  return request.get('/ai-chat/sessions')
}

// 获取所有会话列表（管理员）
export const getAllSessionsApi = () => {
  return request.get('/ai-chat/sessions/all')
}

// 获取会话的消息历史
export const getSessionMessagesApi = (sessionId) => {
  return request.get(`/ai-chat/sessions/${sessionId}/messages`)
}

// 删除会话
export const deleteSessionApi = (sessionId) => {
  return request.delete(`/ai-chat/sessions/${sessionId}`)
}

// 更新会话标题
export const updateSessionTitleApi = (sessionId, title) => {
  return request.put(`/ai-chat/sessions/${sessionId}/title`, { title })
}

// AI查询（带会话ID）
export const queryRelicAiWithSessionApi = (question, matchAll, sessionId) => {
  return request.post('/ai/relics/query', {
    question,
    matchAll,
    sessionId
  })
}
