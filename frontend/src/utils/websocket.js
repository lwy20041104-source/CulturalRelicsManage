import SockJS from 'sockjs-client'
import { Stomp } from '@stomp/stompjs'

/**
 * WebSocket服务类
 * 用于实时推送通知消息
 */
class WebSocketService {
  constructor() {
    this.stompClient = null
    this.connected = false
    this.reconnectAttempts = 0
    this.maxReconnectAttempts = 5
    this.reconnectDelay = 3000
    this.messageCallback = null
    this.userId = null
  }

  /**
   * 连接WebSocket服务器
   * @param {string} userId - 用户ID
   * @param {function} onMessageCallback - 收到消息时的回调函数
   */
  connect(userId, onMessageCallback) {
    if (this.connected) {
      console.log('WebSocket已连接')
      return
    }

    this.userId = userId
    this.messageCallback = onMessageCallback

    // 创建SockJS连接
    const socket = new SockJS('http://localhost:8080/ws-notification')
    this.stompClient = Stomp.over(socket)

    // 禁用调试日志（生产环境）
    this.stompClient.debug = () => {}

    // 连接到WebSocket服务器
    this.stompClient.connect(
      {},
      () => {
        console.log('✅ WebSocket连接成功')
        this.connected = true
        this.reconnectAttempts = 0

        // 订阅用户专属通知频道
        this.stompClient.subscribe(`/user/${userId}/notification`, (message) => {
          try {
            const notification = JSON.parse(message.body)
            console.log('📨 收到WebSocket通知:', notification)
            
            // 调用回调函数处理通知
            if (this.messageCallback) {
              this.messageCallback(notification)
            }
          } catch (error) {
            console.error('❌ 解析WebSocket消息失败:', error)
          }
        })

        console.log(`📡 已订阅通知频道: /user/${userId}/notification`)
      },
      (error) => {
        console.error('❌ WebSocket连接失败:', error)
        this.connected = false
        this.reconnect()
      }
    )

    // 监听连接断开事件
    socket.onclose = () => {
      console.warn('⚠️ WebSocket连接已断开')
      this.connected = false
      this.reconnect()
    }
  }

  /**
   * 重新连接WebSocket
   */
  reconnect() {
    if (this.reconnectAttempts < this.maxReconnectAttempts) {
      this.reconnectAttempts++
      console.log(`🔄 尝试重连WebSocket (${this.reconnectAttempts}/${this.maxReconnectAttempts})...`)
      
      setTimeout(() => {
        if (this.userId && this.messageCallback) {
          this.connect(this.userId, this.messageCallback)
        }
      }, this.reconnectDelay)
    } else {
      console.error('❌ WebSocket重连失败，已达到最大重连次数')
    }
  }

  /**
   * 断开WebSocket连接
   */
  disconnect() {
    if (this.stompClient && this.connected) {
      this.stompClient.disconnect(() => {
        console.log('👋 WebSocket已断开')
      })
      this.connected = false
      this.reconnectAttempts = 0
      this.userId = null
      this.messageCallback = null
    }
  }

  /**
   * 检查连接状态
   * @returns {boolean} 是否已连接
   */
  isConnected() {
    return this.connected
  }
}

// 导出单例
export default new WebSocketService()
