<template>
  <el-popover
    v-if="!isOnNotificationsPage"
    placement="bottom"
    :width="400"
    trigger="click"
    popper-class="notification-popover"
  >
    <template #reference>
      <el-badge :value="unreadCount" :hidden="unreadCount === 0" :max="99" class="notification-badge">
        <el-button :icon="Bell" size="small" class="notification-button" />
      </el-badge>
    </template>
    
    <div class="notification-container">
      <div class="notification-header">
        <span class="notification-title">{{ $t('notification.title') || '消息通知' }}</span>
        <el-button 
          v-if="unreadCount > 0" 
          link 
          size="small" 
          @click="markAllRead"
        >
          {{ $t('notification.markAllRead') || '全部已读' }}
        </el-button>
      </div>
      
      <el-tabs v-model="activeTab" class="notification-tabs">
        <el-tab-pane :label="`${$t('notification.unread') || '未读'}(${unreadCount})`" name="unread">
          <div class="notification-list">
            <div 
              v-if="unreadNotifications.length === 0" 
              class="empty-state"
            >
              <el-empty :description="$t('notification.noUnread') || '暂无未读消息'" :image-size="80" />
            </div>
            <div 
              v-for="item in unreadNotifications" 
              :key="item.id"
              class="notification-item"
              :class="{ 'high-priority': item.priority === 'HIGH' || item.priority === 'URGENT' }"
              @click="handleNotificationClick(item)"
            >
              <div class="notification-content">
                <div class="notification-item-title">
                  <el-tag 
                    v-if="item.priority === 'HIGH' || item.priority === 'URGENT'" 
                    type="danger" 
                    size="small"
                    effect="dark"
                  >
                    {{ item.priority === 'URGENT' ? '紧急' : '重要' }}
                  </el-tag>
                  {{ item.title }}
                </div>
                <div class="notification-item-content">{{ item.content }}</div>
                <div class="notification-item-time">{{ formatTime(item.createTime) }}</div>
              </div>
            </div>
          </div>
        </el-tab-pane>
        
        <el-tab-pane :label="$t('notification.all') || '全部'" name="all">
          <div class="notification-list">
            <div 
              v-if="allNotifications.length === 0" 
              class="empty-state"
            >
              <el-empty :description="$t('notification.noNotifications') || '暂无消息'" :image-size="80" />
            </div>
            <div 
              v-for="item in allNotifications" 
              :key="item.id"
              class="notification-item"
              :class="{ 'is-read': item.isRead, 'high-priority': item.priority === 'HIGH' || item.priority === 'URGENT' }"
              @click="handleNotificationClick(item)"
            >
              <div class="notification-content">
                <div class="notification-item-title">
                  <el-tag 
                    v-if="item.priority === 'HIGH' || item.priority === 'URGENT'" 
                    type="danger" 
                    size="small"
                    effect="dark"
                  >
                    {{ item.priority === 'URGENT' ? '紧急' : '重要' }}
                  </el-tag>
                  {{ item.title }}
                </div>
                <div class="notification-item-content">{{ item.content }}</div>
                <div class="notification-item-footer">
                  <span class="notification-item-time">{{ formatTime(item.createTime) }}</span>
                  <el-button 
                    link 
                    size="small" 
                    type="danger"
                    @click.stop="handleDelete(item.id)"
                  >
                    {{ $t('common.delete') || '删除' }}
                  </el-button>
                </div>
              </div>
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
      
      <div class="notification-footer">
        <el-button link @click="viewAll">{{ $t('notification.viewAll') || '查看全部' }}</el-button>
      </div>
    </div>
  </el-popover>
  
  <!-- 在通知页面时只显示铃铛图标 -->
  <el-badge 
    v-else 
    :value="unreadCount" 
    :hidden="unreadCount === 0" 
    :max="99" 
    class="notification-badge"
  >
    <el-button :icon="Bell" size="small" class="notification-button" disabled />
  </el-badge>
</template>

<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import { Bell } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox, ElNotification } from 'element-plus'
import { useI18n } from 'vue-i18n'
import { useRouter, useRoute } from 'vue-router'
import { 
  getNotificationsApi, 
  markAsReadApi, 
  markAllAsReadApi, 
  getUnreadCountApi,
  deleteNotificationApi 
} from '../api/notifications'
import webSocketService from '../utils/websocket'

const { t } = useI18n()
const router = useRouter()
const route = useRoute()

// 检测是否在通知页面
const isOnNotificationsPage = computed(() => {
  return route.path === '/notifications'
})

const unreadCount = ref(0)
const unreadNotifications = ref([])
const allNotifications = ref([])
const activeTab = ref('unread')
let pollingTimer = null

// 加载未读通知数量
const loadUnreadCount = async () => {
  // 未登录时不加载通知
  if (!sessionStorage.getItem('token')) {
    return
  }
  
  try {
    const res = await getUnreadCountApi()
    unreadCount.value = res.data || 0
  } catch (error) {
    console.error('加载未读通知数量失败:', error)
  }
}

// 加载未读通知列表
const loadUnreadNotifications = async () => {
  // 未登录时不加载通知
  if (!sessionStorage.getItem('token')) {
    return
  }
  
  try {
    const res = await getNotificationsApi({ pageNum: 1, pageSize: 10, isRead: false })
    // 过滤掉逾期未归还的通知（type为LOAN_OVERDUE）
    unreadNotifications.value = (res.data.records || []).filter(item => item.type !== 'LOAN_OVERDUE')
  } catch (error) {
    console.error('加载未读通知失败:', error)
  }
}

// 加载全部通知列表
const loadAllNotifications = async () => {
  // 未登录时不加载通知
  if (!sessionStorage.getItem('token')) {
    return
  }
  
  try {
    const res = await getNotificationsApi({ pageNum: 1, pageSize: 20 })
    // 过滤掉逾期未归还的通知（type为LOAN_OVERDUE）
    allNotifications.value = (res.data.records || []).filter(item => item.type !== 'LOAN_OVERDUE')
  } catch (error) {
    console.error('加载通知列表失败:', error)
  }
}

// 标记单条通知为已读
const markRead = async (id) => {
  try {
    await markAsReadApi(id)
    await loadUnreadCount()
    await loadUnreadNotifications()
    await loadAllNotifications()
  } catch (error) {
    console.error('标记已读失败:', error)
  }
}

// 标记全部为已读
const markAllRead = async () => {
  if (unreadNotifications.value.length === 0) {
    return
  }
  
  try {
    const ids = unreadNotifications.value.map(item => item.id)
    await markAllAsReadApi(ids)
    ElMessage.success(t('notification.markAllReadSuccess') || '已全部标记为已读')
    await loadUnreadCount()
    await loadUnreadNotifications()
    await loadAllNotifications()
  } catch (error) {
    ElMessage.error(t('notification.markAllReadFailed') || '标记失败')
  }
}

// 删除通知
const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm(
      t('notification.deleteConfirm') || '确定要删除这条通知吗？',
      t('common.warning') || '提示',
      {
        confirmButtonText: t('common.confirm') || '确定',
        cancelButtonText: t('common.cancel') || '取消',
        type: 'warning'
      }
    )
    
    await deleteNotificationApi(id)
    ElMessage.success(t('notification.deleteSuccess') || '删除成功')
    await loadUnreadCount()
    await loadUnreadNotifications()
    await loadAllNotifications()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(t('notification.deleteFailed') || '删除失败')
    }
  }
}

// 点击通知
const handleNotificationClick = async (item) => {
  if (!item.isRead) {
    await markRead(item.id)
  }
  
  // 根据通知类型跳转到相应页面
  if (item.relatedType === 'LOAN' && item.relatedId) {
    router.push('/loans')
  } else if (item.relatedType === 'REPAIR' && item.relatedId) {
    router.push('/repairs')
  } else if (item.relatedType === 'MAINTENANCE' && item.relatedId) {
    router.push('/maintenance')
  }
}

// 查看全部
const viewAll = () => {
  router.push('/notifications')
}

// 格式化时间
const formatTime = (time) => {
  if (!time) return ''
  
  const date = new Date(time)
  const now = new Date()
  const diff = now - date
  
  // 1分钟内
  if (diff < 60000) {
    return t('notification.justNow') || '刚刚'
  }
  
  // 1小时内
  if (diff < 3600000) {
    const minutes = Math.floor(diff / 60000)
    return `${minutes}${t('notification.minutesAgo') || '分钟前'}`
  }
  
  // 24小时内
  if (diff < 86400000) {
    const hours = Math.floor(diff / 3600000)
    return `${hours}${t('notification.hoursAgo') || '小时前'}`
  }
  
  // 7天内
  if (diff < 604800000) {
    const days = Math.floor(diff / 86400000)
    return `${days}${t('notification.daysAgo') || '天前'}`
  }
  
  // 超过7天显示具体日期
  return date.toLocaleDateString()
}

// 开始轮询
const startPolling = () => {
  loadUnreadCount()
  loadUnreadNotifications()
  loadAllNotifications()
  
  // 连接WebSocket
  const userId = sessionStorage.getItem('userId')
  if (userId) {
    webSocketService.connect(userId, handleWebSocketNotification)
  } else {
    console.warn('⚠️ 未找到用户ID，无法连接WebSocket')
  }
  
  // 每30秒轮询一次（作为WebSocket的备份）
  pollingTimer = setInterval(() => {
    loadUnreadCount()
    if (activeTab.value === 'unread') {
      loadUnreadNotifications()
    } else {
      loadAllNotifications()
    }
  }, 30000)
}

// 停止轮询
const stopPolling = () => {
  if (pollingTimer) {
    clearInterval(pollingTimer)
    pollingTimer = null
  }
  
  // 断开WebSocket
  webSocketService.disconnect()
}

// 处理WebSocket推送的通知
const handleWebSocketNotification = (notification) => {
  
  // 隐藏逾期未归还的通知
  if (notification.type === 'LOAN_OVERDUE') {
    return
  }
  
  // 显示桌面通知
  showDesktopNotification(notification)
  
  // 显示Element Plus通知
  const notificationType = getNotificationType(notification.priority)
  ElNotification({
    title: notification.title,
    message: notification.content,
    type: notificationType,
    duration: 5000,
    onClick: () => {
      handleNotificationClick(notification)
    }
  })
  
  // 刷新通知列表
  loadUnreadCount()
  loadUnreadNotifications()
  loadAllNotifications()
}

// 显示桌面通知
const showDesktopNotification = (notification) => {
  // 检查浏览器是否支持桌面通知
  if (!('Notification' in window)) {
    console.warn('⚠️ 浏览器不支持桌面通知')
    return
  }
  
  // 检查通知权限
  if (Notification.permission === 'granted') {
    // 已授权，直接显示通知
    createDesktopNotification(notification)
  } else if (Notification.permission !== 'denied') {
    // 未授权，请求权限
    Notification.requestPermission().then(permission => {
      if (permission === 'granted') {
        createDesktopNotification(notification)
      }
    })
  }
}

// 创建桌面通知
const createDesktopNotification = (notification) => {
  const options = {
    body: notification.content,
    icon: '/favicon.ico', // 使用网站图标
    badge: '/favicon.ico',
    tag: `notification-${notification.id}`, // 防止重复通知
    requireInteraction: notification.priority === 'URGENT' || notification.priority === 'HIGH', // 紧急通知需要用户交互
    silent: false,
    data: notification // 保存通知数据
  }
  
  try {
    const desktopNotification = new Notification(notification.title, options)
    
    // 点击桌面通知时的处理
    desktopNotification.onclick = () => {
      window.focus() // 聚焦到浏览器窗口
      handleNotificationClick(notification)
      desktopNotification.close()
    }
    
    // 自动关闭通知（除非是紧急通知）
    if (notification.priority !== 'URGENT' && notification.priority !== 'HIGH') {
      setTimeout(() => {
        desktopNotification.close()
      }, 5000)
    }
  } catch (error) {
    console.error('❌ 创建桌面通知失败:', error)
  }
}

// 获取通知类型
const getNotificationType = (priority) => {
  if (priority === 'URGENT' || priority === 'HIGH') {
    return 'warning'
  }
  return 'info'
}

onMounted(() => {
  startPolling()
})

onUnmounted(() => {
  stopPolling()
})
</script>

<style scoped>
.notification-badge {
  cursor: pointer;
}

.notification-button {
  border: 1px solid transparent;
  background: transparent;
  color: #606266;
  padding: 8px 12px;
  border-radius: 6px;
  transition: all 0.3s;
  min-width: auto;
}

.notification-button:hover {
  background: #f5f7fa;
  color: #409eff;
  border-color: transparent;
}

.notification-container {
  max-height: 500px;
  display: flex;
  flex-direction: column;
}

.notification-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  border-bottom: 1px solid #eadfce;
}

.notification-title {
  font-size: 16px;
  font-weight: 600;
  color: #3d2f1f;
}

.notification-tabs {
  flex: 1;
  overflow: hidden;
}

.notification-tabs :deep(.el-tabs__header) {
  margin: 0;
  padding: 0 16px;
}

.notification-tabs :deep(.el-tabs__content) {
  height: 350px;
  overflow-y: auto;
}

.notification-list {
  padding: 8px 0;
}

.empty-state {
  padding: 40px 0;
  text-align: center;
}

.notification-item {
  padding: 12px 16px;
  cursor: pointer;
  transition: background-color 0.2s;
  border-bottom: 1px solid #f5f5f5;
}

.notification-item:hover {
  background-color: #fff9f0;
}

.notification-item.is-read {
  opacity: 0.6;
}

.notification-item.high-priority {
  border-left: 3px solid #f56c6c;
}

.notification-content {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.notification-item-title {
  font-size: 14px;
  font-weight: 500;
  color: #3d2f1f;
  display: flex;
  align-items: center;
  gap: 8px;
}

.notification-item-content {
  font-size: 13px;
  color: #6c5037;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.notification-item-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.notification-item-time {
  font-size: 12px;
  color: #9b8d7d;
}

.notification-footer {
  padding: 12px 16px;
  border-top: 1px solid #eadfce;
  text-align: center;
}
</style>

<style>
.notification-popover {
  padding: 0 !important;
}
</style>
