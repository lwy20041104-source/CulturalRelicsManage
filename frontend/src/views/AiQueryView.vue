<template>
  <div class="ai-page">
    <div class="ai-container">
      <!-- 左侧：历史会话列表 -->
      <div class="ai-sidebar">
        <div class="sidebar-header">
          <div class="sidebar-logo">
            <div class="logo-icon">🤖</div>
            <span class="logo-text">{{ $t('ai.chatHistory') }}</span>
          </div>
          <el-button class="new-chat-btn" type="primary" size="small" circle @click="createNewSession">
            <el-icon><Plus /></el-icon>
          </el-button>
        </div>
        <div class="sidebar-content" v-loading="sessionsLoading">
          <div v-if="sessionList.length === 0" class="empty-sessions">
            <div class="empty-icon">💬</div>
            <p class="empty-text">{{ $t('ai.noHistory') }}</p>
            <p class="empty-hint">{{ $t('ai.startNewChat') }}</p>
          </div>
          <div class="sessions-list">
            <div
              v-for="session in sessionList"
              :key="session.id"
              class="session-item"
              :class="{ active: currentSessionId === session.id }"
              @click="switchSession(session)"
            >
              <div class="session-icon">
                <el-icon><ChatDotRound /></el-icon>
              </div>
              <div class="session-info">
                <div class="session-title">{{ session.sessionTitle }}</div>
                <div class="session-time">{{ formatSessionTime(session.updateTime) }}</div>
              </div>
              <div class="session-actions">
                <el-button
                  class="delete-btn"
                  type="danger"
                  size="small"
                  text
                  circle
                  @click.stop="deleteSession(session.id)"
                >
                  <el-icon><Delete /></el-icon>
                </el-button>
              </div>
            </div>
          </div>
        </div>
        <div class="sidebar-footer">
          <div class="user-profile">
            <div class="profile-avatar">
              <el-icon><User /></el-icon>
            </div>
            <div class="profile-info">
              <div class="profile-name">{{ userName }}</div>
              <div class="profile-status">{{ $t('ai.online') }}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- 右侧：对话区域 -->
      <div class="ai-chat-box">
        <div class="chat-messages" ref="chatMessages">
          <!-- 欢迎消息 -->
          <div v-if="chatHistory.length === 0" class="welcome-message">
            <div class="welcome-icon">🤖</div>
            <h3>{{ $t('ai.aiWelcome') }}</h3>
            <p>{{ $t('ai.aiWelcomeDesc') }}</p>
            <div class="example-queries">
              <el-tag @click="aiQuery = '司母戊鼎'">司母戊鼎</el-tag>
              <el-tag @click="aiQuery = '汝窑天青釉盏'">汝窑天青釉盏</el-tag>
              <el-tag @click="aiQuery = '清明上河图'">清明上河图</el-tag>
              <el-tag @click="aiQuery = '兵马俑'">兵马俑</el-tag>
            </div>
          </div>

          <!-- 对话历史 -->
          <div v-for="(msg, index) in chatHistory" :key="index" class="message-group">
            <!-- 用户消息 -->
            <div class="message user-message">
              <div class="message-avatar">
                <el-icon><User /></el-icon>
              </div>
              <div class="message-content">
                <div class="message-text">{{ msg.question }}</div>
                <div class="message-time">{{ msg.time }}</div>
              </div>
            </div>

            <!-- AI回复 -->
            <div class="message ai-message">
              <div class="message-avatar ai-avatar">
                <el-icon><ChatDotRound /></el-icon>
              </div>
              <div class="message-content">
                <!-- 文字回答 -->
                <div class="message-text">{{ msg.response.answer }}</div>
                
                <!-- 文物卡片 -->
                <div v-if="msg.response.relics && msg.response.relics.length > 0" class="message-relics">
                  <div
                    v-for="relic in msg.response.relics"
                    :key="relic.id"
                    class="relic-card-mini"
                  >
                    <!-- 卡片头部 -->
                    <div class="relic-card-header">
                      <div class="relic-card-title">
                        <h4>{{ relic.relicName }}</h4>
                        <el-tag type="success" size="small">{{ $t('ai.collectionTag') }}</el-tag>
                      </div>
                    </div>

                    <!-- 卡片内容 -->
                    <div class="relic-card-body">
                      <!-- 图片 -->
                      <div v-if="relic.imagePath" class="relic-card-image">
                        <img 
                          :src="resolveImageUrl(relic.imagePath)" 
                          :alt="relic.relicName"
                        />
                      </div>
                      <div v-else class="relic-card-image">
                        <div class="no-image">{{ $t('common.noImage') }}</div>
                      </div>

                      <!-- 信息 -->
                      <div class="relic-card-info">
                        <div class="info-item" v-if="relic.era">
                          <span class="label">{{ $t('relic.era') }}</span>
                          <span class="value">{{ relic.era }}</span>
                        </div>
                        <div class="info-item" v-if="relic.material">
                          <span class="label">{{ $t('relic.material') }}</span>
                          <span class="value">{{ relic.material }}</span>
                        </div>
                        <div class="info-item" v-if="relic.categoryName">
                          <span class="label">{{ $t('relic.category') }}</span>
                          <span class="value">{{ relic.categoryName }}</span>
                        </div>
                        <div class="info-item" v-if="relic.status">
                          <span class="label">{{ $t('relic.status') }}</span>
                          <span class="value">{{ relic.status }}</span>
                        </div>
                      </div>
                    </div>

                    <!-- 描述 -->
                    <div class="relic-card-description">
                      {{ relic.description || relic.introduction }}
                    </div>

                    <!-- 相关度 -->
                    <div class="relic-card-footer">
                      <div v-if="relic.relevancePercent" class="relevance-bar">
                        <span>{{ $t('ai.relevance') }} {{ relic.relevancePercent }}%</span>
                        <div class="progress-bar">
                          <div
                            class="progress-fill"
                            :style="{ width: relic.relevancePercent + '%', background: getRelevanceColor(relic.relevancePercent) }"
                          ></div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <div class="message-time">{{ msg.time }}</div>
              </div>
            </div>
          </div>

          <!-- 加载中 -->
          <div v-if="loading" class="message ai-message">
            <div class="message-avatar ai-avatar">
              <el-icon><ChatDotRound /></el-icon>
            </div>
            <div class="message-content">
              <div class="message-text typing">
                <el-icon class="is-loading"><Loading /></el-icon>
                {{ $t('ai.thinking') }}
              </div>
            </div>
          </div>
        </div>

        <!-- 输入区域 -->
        <div class="chat-input">
          <div class="chat-input-container">
            <div class="input-wrapper">
              <el-input
                v-model="aiQuery"
                :placeholder="$t('ai.aiInputPlaceholder')"
                @keyup.enter="sendAiQuery"
                size="large"
                class="chat-textarea"
                type="textarea"
                :rows="1"
                :autosize="{ minRows: 1, maxRows: 4 }"
              />
            </div>
            <el-button 
              class="send-button" 
              type="primary" 
              @click="sendAiQuery" 
              :loading="loading" 
              :disabled="!aiQuery.trim()"
              circle
              size="large"
            >
              <el-icon :size="20"><Promotion /></el-icon>
            </el-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, nextTick, onMounted } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, ChatDotRound, Delete, User, Loading, Promotion } from '@element-plus/icons-vue'
import request from '../api/request'
import { getSessionsApi, deleteSessionApi, queryRelicAiWithSessionApi, getSessionMessagesApi } from '../api/aiChat'

const { t } = useI18n()

// 用户信息
const userName = ref('')

// 会话相关
const sessionList = ref([])
const currentSessionId = ref(null)
const sessionsLoading = ref(false)

// 对话相关
const aiQuery = ref('')
const loading = ref(false)
const chatHistory = ref([])
const chatMessages = ref(null)

const backendBaseURL = request.defaults.baseURL

// 加载用户信息
const loadUserInfo = async () => {
  try {
    // 从 sessionStorage 获取用户信息
    userName.value = sessionStorage.getItem('realName') || sessionStorage.getItem('username') || '用户'
  } catch (error) {
    console.error('加载用户信息失败:', error)
    userName.value = '用户'
  }
}

// 加载会话列表
const loadSessions = async () => {
  sessionsLoading.value = true
  try {
    const res = await getSessionsApi()
    if (res.code === 200) {
      sessionList.value = res.data || []
    }
  } catch (error) {
    console.error('加载会话列表失败:', error)
    ElMessage.error(t('ai.loadSessionsFailed'))
  } finally {
    sessionsLoading.value = false
  }
}

// 创建新会话
const createNewSession = () => {
  currentSessionId.value = null
  chatHistory.value = []
  aiQuery.value = ''
}

// 加载会话消息
const loadSessionMessages = async (sessionId) => {
  try {
    loading.value = true
    const res = await getSessionMessagesApi(sessionId)
    const messages = res.data || []
    
    // 转换消息格式为chatHistory格式
    chatHistory.value = []
    
    // 将消息按创建时间排序
    const sortedMessages = messages.sort((a, b) => {
      return new Date(a.createTime) - new Date(b.createTime)
    })
    
    // 将消息按类型分组
    const userMessages = sortedMessages.filter(m => m.messageType === 'user')
    const aiMessages = sortedMessages.filter(m => m.messageType === 'ai')
    
    // 配对用户消息和AI回复
    const pairCount = Math.min(userMessages.length, aiMessages.length)
    
    for (let i = 0; i < pairCount; i++) {
      const userMsg = userMessages[i]
      const aiMsg = aiMessages[i]
      
      try {
        // 尝试解析AI响应
        let aiResponse
        if (typeof aiMsg.content === 'string') {
          try {
            // 尝试解析JSON字符串
            aiResponse = JSON.parse(aiMsg.content)
          } catch (parseError) {
            console.error('JSON解析失败，使用原始内容:', parseError, aiMsg.content)
            // 如果解析失败，创建一个简单的响应对象
            aiResponse = {
              answer: aiMsg.content,
              relics: [],
              total: 0,
              museumHit: false,
              museumMessage: '',
              topReason: '',
              webResults: []
            }
          }
        } else {
          // 如果已经是对象，直接使用
          aiResponse = aiMsg.content
        }
        
        // 确保aiResponse有必要的字段
        if (!aiResponse.relics) aiResponse.relics = []
        if (!aiResponse.webResults) aiResponse.webResults = []
        if (aiResponse.total === undefined) aiResponse.total = 0
        
        chatHistory.value.push({
          question: userMsg.content,
          response: aiResponse,
          time: formatTime(aiMsg.createTime)
        })
      } catch (e) {
        console.error('处理消息失败:', e, userMsg, aiMsg)
      }
    }
    
    await nextTick()
    scrollToBottom()
  } catch (error) {
    console.error('加载会话消息失败:', error)
    ElMessage.error(t('ai.loadHistoryFailed'))
  } finally {
    loading.value = false
  }
}

// 切换会话
const switchSession = async (session) => {
  currentSessionId.value = session.id
  await loadSessionMessages(session.id)
}

// 删除会话
const deleteSession = async (sessionId) => {
  try {
    await ElMessageBox.confirm(
      t('ai.confirmDeleteSession'),
      t('common.warning'),
      {
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel'),
        type: 'warning'
      }
    )
    
    const res = await deleteSessionApi(sessionId)
    if (res.code === 200) {
      ElMessage.success(t('ai.deleteSessionSuccess'))
      await loadSessions()
      
      // 如果删除的是当前会话，清空对话
      if (currentSessionId.value === sessionId) {
        createNewSession()
      }
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除会话失败:', error)
      ElMessage.error(t('ai.deleteSessionFailed'))
    }
  }
}

// 发送AI查询
const sendAiQuery = async () => {
  if (!aiQuery.value.trim()) {
    ElMessage.warning(t('ai.inputQuery'))
    return
  }

  const question = aiQuery.value
  aiQuery.value = ''
  loading.value = true

  // 添加用户消息到历史
  chatHistory.value.push({
    question,
    response: {},
    time: formatTime(new Date())
  })

  await nextTick()
  scrollToBottom()

  try {
    const res = await queryRelicAiWithSessionApi(question, false, currentSessionId.value)
    
    if (res.code === 200) {
      // 更新最后一条消息的响应
      const lastMsg = chatHistory.value[chatHistory.value.length - 1]
      lastMsg.response = res.data
      
      // 更新当前会话ID
      if (res.data.sessionId) {
        currentSessionId.value = res.data.sessionId
      }
      
      // 重新加载会话列表
      await loadSessions()
      
      await nextTick()
      scrollToBottom()
    }
  } catch (error) {
    console.error('AI对话失败:', error)
    ElMessage.error(t('ai.queryFailed'))
    // 移除失败的消息
    chatHistory.value.pop()
  } finally {
    loading.value = false
  }
}

// 图片URL解析
const resolveImageUrl = (imagePath) => {
  if (!imagePath) return ''
  
  // 如果是外部 URL，使用代理
  if (/^https?:\/\//i.test(imagePath)) {
    const encodedUrl = btoa(imagePath)
    return `${backendBaseURL}/proxy/image?url=${encodedUrl}`
  }
  
  // 本地图片路径
  let normalized = String(imagePath).trim().replace(/\\/g, '/')
  if (normalized.startsWith('./')) normalized = normalized.slice(1)
  if (!normalized.startsWith('/')) normalized = `/${normalized}`
  return `${backendBaseURL}${normalized}`
}

// 相关度颜色
const getRelevanceColor = (percent) => {
  if (percent >= 80) return 'linear-gradient(135deg, #67c23a 0%, #85ce61 100%)'
  if (percent >= 60) return 'linear-gradient(135deg, #409eff 0%, #66b1ff 100%)'
  if (percent >= 40) return 'linear-gradient(135deg, #e6a23c 0%, #ebb563 100%)'
  return 'linear-gradient(135deg, #f56c6c 0%, #f78989 100%)'
}

// 格式化时间
const formatTime = (date) => {
  if (!date) return ''
  const d = new Date(date)
  const now = new Date()
  const diff = now - d
  
  if (diff < 60000) return t('ai.justNow')
  if (diff < 3600000) return Math.floor(diff / 60000) + t('ai.minutesAgo')
  if (diff < 86400000) return Math.floor(diff / 3600000) + t('ai.hoursAgo')
  
  return d.toLocaleString()
}

// 格式化会话时间
const formatSessionTime = (date) => {
  if (!date) return ''
  const d = new Date(date)
  const now = new Date()
  const diff = now - d
  
  if (diff < 86400000) {
    return d.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' })
  }
  
  return d.toLocaleDateString('zh-CN', { month: '2-digit', day: '2-digit' })
}

// 滚动到底部
const scrollToBottom = () => {
  if (chatMessages.value) {
    chatMessages.value.scrollTop = chatMessages.value.scrollHeight
  }
}

// 初始化
onMounted(async () => {
  await loadUserInfo()
  await loadSessions()
})
</script>

<style scoped>
.ai-page {
  height: calc(100vh - 120px);
  padding: 0;
  margin: 0;
  background: #f5f5f5;
}

.ai-container {
  display: flex;
  height: 100%;
  background: #fff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
}

/* 左侧边栏 */
.ai-sidebar {
  width: 280px;
  background: linear-gradient(180deg, #2c3e50 0%, #34495e 100%);
  display: flex;
  flex-direction: column;
  border-right: 1px solid #e0e0e0;
}

.sidebar-header {
  padding: 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 12px;
}

.logo-icon {
  font-size: 28px;
}

.logo-text {
  font-size: 18px;
  font-weight: 600;
  color: #fff;
}

.new-chat-btn {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
}

.sidebar-content {
  flex: 1;
  overflow-y: auto;
  padding: 12px;
}

.empty-sessions {
  text-align: center;
  padding: 40px 20px;
  color: rgba(255, 255, 255, 0.6);
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
}

.empty-text {
  font-size: 16px;
  margin-bottom: 8px;
  color: rgba(255, 255, 255, 0.8);
}

.empty-hint {
  font-size: 13px;
  color: rgba(255, 255, 255, 0.5);
}

.sessions-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.session-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.2s;
  background: rgba(255, 255, 255, 0.05);
}

.session-item:hover {
  background: rgba(255, 255, 255, 0.1);
}

.session-item.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.session-icon {
  font-size: 20px;
  color: rgba(255, 255, 255, 0.8);
}

.session-info {
  flex: 1;
  min-width: 0;
}

.session-title {
  font-size: 14px;
  font-weight: 500;
  color: #fff;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.session-time {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
  margin-top: 4px;
}

.session-actions {
  opacity: 0;
  transition: opacity 0.2s;
}

.session-item:hover .session-actions {
  opacity: 1;
}

.delete-btn {
  padding: 4px;
}

.sidebar-footer {
  padding: 16px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 12px;
}

.profile-avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 20px;
}

.profile-info {
  flex: 1;
}

.profile-name {
  font-size: 14px;
  font-weight: 500;
  color: #fff;
}

.profile-status {
  font-size: 12px;
  color: rgba(255, 255, 255, 0.6);
}

/* 右侧对话区 */
.ai-chat-box {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #f8f9fa;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  padding: 24px;
}

.welcome-message {
  text-align: center;
  padding: 60px 20px;
}

.welcome-icon {
  font-size: 64px;
  margin-bottom: 20px;
}

.welcome-message h3 {
  font-size: 24px;
  color: #2c3e50;
  margin-bottom: 12px;
}

.welcome-message p {
  font-size: 16px;
  color: #7f8c8d;
  margin-bottom: 24px;
}

.example-queries {
  display: flex;
  gap: 12px;
  justify-content: center;
  flex-wrap: wrap;
}

.example-queries .el-tag {
  cursor: pointer;
  font-size: 14px;
  padding: 8px 16px;
  transition: all 0.2s;
}

.example-queries .el-tag:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.message-group {
  margin-bottom: 24px;
}

.message {
  display: flex;
  gap: 12px;
  margin-bottom: 16px;
}

.message-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
  font-size: 18px;
  flex-shrink: 0;
}

.ai-avatar {
  background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
}

.message-content {
  flex: 1;
  min-width: 0;
}

.user-message .message-content {
  max-width: 70%;
}

.message-text {
  background: #fff;
  padding: 12px 16px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  line-height: 1.6;
  color: #2c3e50;
}

.user-message .message-text {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
}

.message-text.typing {
  display: flex;
  align-items: center;
  gap: 8px;
}

.message-time {
  font-size: 12px;
  color: #95a5a6;
  margin-top: 6px;
}

.message-relics {
  margin-top: 16px;
  display: grid;
  gap: 16px;
}

.relic-card-mini {
  background: #fff;
  border-radius: 12px;
  padding: 16px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s;
}

.relic-card-mini:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.relic-card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.relic-card-title {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.relic-card-title h4 {
  margin: 0;
  font-size: 16px;
  color: #2c3e50;
}

.relic-card-body {
  display: flex;
  gap: 16px;
  margin-bottom: 12px;
}

.relic-card-image {
  width: 120px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  flex-shrink: 0;
  background: #f0f0f0;
}

.relic-card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.no-image {
  width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #95a5a6;
  font-size: 14px;
}

.relic-card-info {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item .label {
  font-size: 12px;
  color: #95a5a6;
}

.info-item .value {
  font-size: 14px;
  color: #2c3e50;
  font-weight: 500;
}

.relic-card-description {
  font-size: 14px;
  line-height: 1.6;
  color: #7f8c8d;
  margin-bottom: 12px;
}

.relic-card-footer {
  padding-top: 12px;
  border-top: 1px solid #ecf0f1;
}

.relevance-bar {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.relevance-bar span {
  font-size: 13px;
  color: #7f8c8d;
}

.progress-bar {
  height: 6px;
  background: #ecf0f1;
  border-radius: 3px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  border-radius: 3px;
  transition: width 0.3s;
}

/* 输入区域 */
.chat-input {
  padding: 20px;
  background: #fff;
  border-top: 1px solid #e0e0e0;
}

.chat-input-container {
  display: flex;
  gap: 12px;
  align-items: flex-end;
}

.input-wrapper {
  flex: 1;
}

.chat-textarea {
  border-radius: 12px;
}

.send-button {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  width: 48px;
  height: 48px;
}

.send-button:hover {
  transform: scale(1.05);
}

.send-button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* 滚动条样式 */
.sidebar-content::-webkit-scrollbar,
.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.sidebar-content::-webkit-scrollbar-thumb,
.chat-messages::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.2);
  border-radius: 3px;
}

.sidebar-content::-webkit-scrollbar-thumb:hover,
.chat-messages::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, 0.3);
}

/* 响应式 */
@media (max-width: 768px) {
  .ai-sidebar {
    width: 240px;
  }
  
  .relic-card-body {
    flex-direction: column;
  }
  
  .relic-card-image {
    width: 100%;
    height: 200px;
  }
}
</style>
