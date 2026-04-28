<template>
  <el-card class="test-card">
    <template #header>
      <div class="card-header">
        <span>🔌 WebSocket连接测试</span>
        <el-tag :type="connectionStatus.type">{{ connectionStatus.text }}</el-tag>
      </div>
    </template>

    <el-space direction="vertical" :size="20" style="width: 100%">
      <!-- 连接信息 -->
      <el-card shadow="never">
        <template #header>
          <span>📡 连接信息</span>
        </template>
        <el-descriptions :column="2" border>
          <el-descriptions-item label="用户ID">{{ userId || '未登录' }}</el-descriptions-item>
          <el-descriptions-item label="连接状态">
            <el-tag :type="connectionStatus.type">{{ connectionStatus.text }}</el-tag>
          </el-descriptions-item>
          <el-descriptions-item label="WebSocket地址">http://localhost:8080/ws-notification</el-descriptions-item>
          <el-descriptions-item label="订阅频道">/user/{{ userId }}/notification</el-descriptions-item>
          <el-descriptions-item label="收到消息数">{{ receivedMessages.length }}</el-descriptions-item>
          <el-descriptions-item label="最后消息时间">{{ lastMessageTime || '无' }}</el-descriptions-item>
        </el-descriptions>
      </el-card>

      <!-- 操作按钮 -->
      <el-card shadow="never">
        <template #header>
          <span>🎮 操作</span>
        </template>
        <el-space wrap>
          <el-button type="primary" @click="connect" :disabled="isConnected">
            <el-icon><Connection /></el-icon>
            连接WebSocket
          </el-button>
          <el-button type="danger" @click="disconnect" :disabled="!isConnected">
            <el-icon><Close /></el-icon>
            断开连接
          </el-button>
          <el-button type="success" @click="testNotification">
            <el-icon><Bell /></el-icon>
            测试通知
          </el-button>
          <el-button type="warning" @click="requestDesktopPermission">
            <el-icon><Monitor /></el-icon>
            请求桌面通知权限
          </el-button>
          <el-button @click="clearMessages">
            <el-icon><Delete /></el-icon>
            清空消息
          </el-button>
        </el-space>
      </el-card>

      <!-- 桌面通知权限 -->
      <el-card shadow="never">
        <template #header>
          <span>🖥️ 桌面通知权限</span>
        </template>
        <el-alert
          :title="desktopPermission.title"
          :type="desktopPermission.type"
          :description="desktopPermission.description"
          show-icon
          :closable="false"
        />
      </el-card>

      <!-- 收到的消息 -->
      <el-card shadow="never">
        <template #header>
          <div class="card-header">
            <span>📬 收到的消息 ({{ receivedMessages.length }})</span>
            <el-button size="small" @click="clearMessages">清空</el-button>
          </div>
        </template>
        <el-empty v-if="receivedMessages.length === 0" description="暂无消息" />
        <el-timeline v-else>
          <el-timeline-item
            v-for="(msg, index) in receivedMessages"
            :key="index"
            :timestamp="msg.time"
            placement="top"
          >
            <el-card>
              <div class="message-header">
                <el-tag :type="getPriorityType(msg.priority)" size="small">{{ msg.priority }}</el-tag>
                <span class="message-title">{{ msg.title }}</span>
              </div>
              <div class="message-content">{{ msg.content }}</div>
              <div class="message-meta">
                <span>类型: {{ msg.type }}</span>
                <span>关联ID: {{ msg.relatedId || '无' }}</span>
              </div>
            </el-card>
          </el-timeline-item>
        </el-timeline>
      </el-card>

      <!-- 日志 -->
      <el-card shadow="never">
        <template #header>
          <div class="card-header">
            <span>📝 连接日志 ({{ logs.length }})</span>
            <el-button size="small" @click="clearLogs">清空</el-button>
          </div>
        </template>
        <div class="logs-container">
          <div v-for="(log, index) in logs" :key="index" class="log-item" :class="log.type">
            <span class="log-time">{{ log.time }}</span>
            <span class="log-message">{{ log.message }}</span>
          </div>
        </div>
      </el-card>
    </el-space>
  </el-card>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { Connection, Close, Bell, Monitor, Delete } from '@element-plus/icons-vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElNotification } from 'element-plus'
import webSocketService from '../utils/websocket'

const { t } = useI18n()

const userId = ref(sessionStorage.getItem('userId'))
const isConnected = ref(false)
const receivedMessages = ref([])
const logs = ref([])
const lastMessageTime = ref('')

// 连接状态
const connectionStatus = computed(() => {
  if (isConnected.value) {
    return { type: 'success', text: '已连接' }
  }
  return { type: 'info', text: '未连接' }
})

// 桌面通知权限状态
const desktopPermission = computed(() => {
  if (!('Notification' in window)) {
    return {
      type: 'error',
      title: '不支持桌面通知',
      description: '您的浏览器不支持桌面通知功能'
    }
  }
  
  const permission = Notification.permission
  if (permission === 'granted') {
    return {
      type: 'success',
      title: '已授权',
      description: '您已授权桌面通知，可以接收通知弹窗'
    }
  } else if (permission === 'denied') {
    return {
      type: 'error',
      title: '已拒绝',
      description: '您已拒绝桌面通知权限，请在浏览器设置中手动开启'
    }
  } else {
    return {
      type: 'warning',
      title: '未授权',
      description: '请点击"请求桌面通知权限"按钮授权'
    }
  }
})

// 添加日志
const addLog = (message, type = 'info') => {
  const time = new Date().toLocaleTimeString()
  logs.value.unshift({ time, message, type })
  if (logs.value.length > 50) {
    logs.value.pop()
  }
}

// 连接WebSocket
const connect = () => {
  if (!userId.value) {
    ElMessage.error(t('common.pleaseLogin'))
    return
  }
  
  addLog('正在连接WebSocket...', 'info')
  
  try {
    webSocketService.connect(userId.value, handleMessage)
    isConnected.value = true
    addLog('WebSocket连接成功', 'success')
    ElMessage.success('WebSocket连接成功')
  } catch (error) {
    addLog(`WebSocket连接失败: ${error.message}`, 'error')
    ElMessage.error('WebSocket连接失败')
  }
}

// 断开连接
const disconnect = () => {
  webSocketService.disconnect()
  isConnected.value = false
  addLog('WebSocket已断开', 'warning')
  ElMessage.info('WebSocket已断开')
}

// 处理收到的消息
const handleMessage = (notification) => {
  const time = new Date().toLocaleTimeString()
  lastMessageTime.value = time
  
  receivedMessages.value.unshift({
    ...notification,
    time
  })
  
  addLog(`收到通知: ${notification.title}`, 'success')
  
  // 显示Element Plus通知
  ElNotification({
    title: notification.title,
    message: notification.content,
    type: notification.priority === 'HIGH' || notification.priority === 'URGENT' ? 'warning' : 'info',
    duration: 5000
  })
  
  // 显示桌面通知
  if (Notification.permission === 'granted') {
    showDesktopNotification(notification)
  }
}

// 显示桌面通知
const showDesktopNotification = (notification) => {
  const options = {
    body: notification.content,
    icon: '/favicon.ico',
    badge: '/favicon.ico',
    tag: `notification-${notification.id}`,
    requireInteraction: notification.priority === 'URGENT' || notification.priority === 'HIGH'
  }
  
  const desktopNotification = new Notification(notification.title, options)
  
  desktopNotification.onclick = () => {
    window.focus()
    desktopNotification.close()
  }
  
  if (notification.priority !== 'URGENT' && notification.priority !== 'HIGH') {
    setTimeout(() => {
      desktopNotification.close()
    }, 5000)
  }
}

// 测试通知
const testNotification = () => {
  const testMsg = {
    id: Date.now(),
    title: '测试通知',
    content: '这是一条测试通知消息',
    type: 'SYSTEM',
    priority: 'NORMAL',
    relatedId: null
  }
  
  handleMessage(testMsg)
  addLog('发送测试通知', 'info')
}

// 请求桌面通知权限
const requestDesktopPermission = async () => {
  if (!('Notification' in window)) {
    ElMessage.error(t('common.browserNotSupport'))
    return
  }
  
  if (Notification.permission === 'granted') {
    ElMessage.info('您已授权桌面通知')
    return
  }
  
  try {
    const permission = await Notification.requestPermission()
    if (permission === 'granted') {
      ElMessage.success(t('common.permissionGranted'))
      addLog('桌面通知权限已授权', 'success')
    } else {
      ElMessage.warning(t('common.permissionDenied'))
      addLog('桌面通知权限被拒绝', 'warning')
    }
  } catch (error) {
    ElMessage.error(t('common.requestPermissionFailed'))
    addLog(`请求权限失败: ${error.message}`, 'error')
  }
}

// 清空消息
const clearMessages = () => {
  receivedMessages.value = []
  lastMessageTime.value = ''
  ElMessage.success(t('common.messagesCleared'))
}

// 清空日志
const clearLogs = () => {
  logs.value = []
  ElMessage.success(t('common.logsCleared'))
}

// 获取优先级类型
const getPriorityType = (priority) => {
  const map = {
    'URGENT': 'danger',
    'HIGH': 'warning',
    'NORMAL': '',
    'LOW': 'info'
  }
  return map[priority] || ''
}

onMounted(() => {
  addLog('页面加载完成', 'info')
  if (userId.value) {
    addLog(`当前用户ID: ${userId.value}`, 'info')
  } else {
    addLog('未登录，请先登录系统', 'warning')
  }
})

onUnmounted(() => {
  if (isConnected.value) {
    disconnect()
  }
})
</script>

<style scoped>
.test-card {
  max-width: 1200px;
  margin: 20px auto;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.message-header {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.message-title {
  font-weight: 600;
  font-size: 16px;
}

.message-content {
  margin: 10px 0;
  color: #606266;
  line-height: 1.6;
}

.message-meta {
  display: flex;
  gap: 20px;
  font-size: 12px;
  color: #909399;
  margin-top: 10px;
}

.logs-container {
  max-height: 400px;
  overflow-y: auto;
  background: #f5f7fa;
  padding: 10px;
  border-radius: 4px;
}

.log-item {
  padding: 8px;
  margin-bottom: 5px;
  border-radius: 4px;
  font-family: 'Courier New', monospace;
  font-size: 13px;
}

.log-item.info {
  background: #e1f3f8;
  color: #0c5460;
}

.log-item.success {
  background: #d4edda;
  color: #155724;
}

.log-item.warning {
  background: #fff3cd;
  color: #856404;
}

.log-item.error {
  background: #f8d7da;
  color: #721c24;
}

.log-time {
  color: #909399;
  margin-right: 10px;
}

.log-message {
  word-break: break-all;
}
</style>
