# WebSocket实时推送安装和配置指南

## 📅 创建日期
2026年4月24日

---

## 🎯 功能说明

WebSocket实时推送功能可以实现：
1. **实时通知推送**：无需轮询，服务器主动推送通知
2. **桌面通知弹窗**：浏览器原生桌面通知
3. **更好的用户体验**：即时收到通知，无延迟
4. **降低服务器负载**：减少频繁的HTTP请求

---

## 📦 安装依赖

### 1. 安装WebSocket相关依赖

```bash
cd frontend
npm install sockjs-client @stomp/stompjs
```

**依赖说明**：
- `sockjs-client`: SockJS客户端库，提供WebSocket的兼容性支持
- `@stomp/stompjs`: STOMP协议客户端，用于WebSocket消息传输

---

### 2. 验证安装

安装完成后，检查 `package.json` 文件：

```json
{
  "dependencies": {
    "sockjs-client": "^1.6.1",
    "@stomp/stompjs": "^7.0.0"
  }
}
```

---

## 🔧 配置说明

### 1. WebSocket工具类

**文件位置**: `frontend/src/utils/websocket.js`

**功能**：
- 连接WebSocket服务器
- 订阅用户专属通知频道
- 自动重连机制
- 断开连接管理

**关键配置**：
```javascript
// WebSocket服务器地址
const socket = new SockJS('http://localhost:8080/ws-notification')

// 订阅频道格式
this.stompClient.subscribe(`/user/${userId}/notification`, callback)

// 重连配置
this.maxReconnectAttempts = 5  // 最大重连次数
this.reconnectDelay = 3000     // 重连延迟（毫秒）
```

---

### 2. 通知铃铛组件

**文件位置**: `frontend/src/components/NotificationBell.vue`

**功能**：
- 启动WebSocket连接
- 接收实时通知
- 显示桌面通知
- 显示Element Plus通知弹窗

**关键代码**：
```javascript
// 启动WebSocket连接
const userId = sessionStorage.getItem('userId')
webSocketService.connect(userId, handleWebSocketNotification)

// 处理收到的通知
const handleWebSocketNotification = (notification) => {
  showDesktopNotification(notification)  // 桌面通知
  ElNotification({ ... })                // 页面通知
  loadUnreadCount()                      // 刷新未读数
}
```

---

## 🖥️ 桌面通知配置

### 1. 浏览器权限

桌面通知需要用户授权，首次使用时会自动请求权限。

**权限状态**：
- `granted`: 已授权，可以显示桌面通知
- `denied`: 已拒绝，无法显示桌面通知
- `default`: 未授权，会自动请求权限

---

### 2. 桌面通知特性

**通知配置**：
```javascript
const options = {
  body: notification.content,           // 通知内容
  icon: '/favicon.ico',                 // 通知图标
  badge: '/favicon.ico',                // 徽章图标
  tag: `notification-${notification.id}`, // 防止重复
  requireInteraction: false,            // 是否需要用户交互
  silent: false                         // 是否静音
}
```

**交互行为**：
- 点击桌面通知：聚焦浏览器窗口并跳转到相关页面
- 自动关闭：普通通知5秒后自动关闭
- 持续显示：紧急/高优先级通知需要用户手动关闭

---

### 3. 通知优先级

| 优先级 | 通知类型 | 自动关闭 | 说明 |
|--------|---------|---------|------|
| URGENT | warning | ❌ 否 | 紧急通知，需要用户交互 |
| HIGH | warning | ❌ 否 | 高优先级，需要用户交互 |
| NORMAL | info | ✅ 是 | 普通通知，5秒后自动关闭 |
| LOW | info | ✅ 是 | 低优先级，5秒后自动关闭 |

---

## 🚀 启动和测试

### 1. 启动后端服务

确保后端服务已启动，WebSocket端点可用：

```bash
cd backend
mvn spring-boot:run
```

**WebSocket端点**: `http://localhost:8080/ws-notification`

---

### 2. 启动前端服务

```bash
cd frontend
npm run dev
```

---

### 3. 测试WebSocket连接

**步骤**：
1. 打开浏览器控制台（F12）
2. 登录系统
3. 查看控制台日志

**预期日志**：
```
🚀 启动WebSocket连接，用户ID: 1
✅ WebSocket连接成功
📡 已订阅通知频道: /user/1/notification
```

---

### 4. 测试实时通知

**方法1：提交借展申请**
1. 登录为借展人
2. 提交借展申请
3. 登录为管理员
4. 查看是否收到实时通知

**方法2：提交修复申请**
1. 登录系统
2. 提交修复申请
3. 登录为管理员
4. 查看是否收到实时通知

**预期结果**：
- ✅ 控制台显示：`📨 收到WebSocket通知: {...}`
- ✅ 页面右上角显示Element Plus通知弹窗
- ✅ 桌面显示浏览器原生通知（如果已授权）
- ✅ 通知铃铛未读数量自动更新

---

### 5. 测试桌面通知

**首次使用**：
1. 收到第一条通知时，浏览器会请求桌面通知权限
2. 点击"允许"授权
3. 后续通知会自动显示桌面通知

**手动授权**：
- Chrome: 设置 → 隐私和安全 → 网站设置 → 通知
- Firefox: 设置 → 隐私与安全 → 权限 → 通知
- Edge: 设置 → Cookie和网站权限 → 通知

**测试步骤**：
1. 确保已授权桌面通知
2. 最小化浏览器窗口
3. 提交借展或修复申请
4. 查看桌面是否弹出通知

---

## 🔍 故障排查

### 1. WebSocket连接失败

**问题**: 控制台显示 `❌ WebSocket连接失败`

**可能原因**：
- 后端服务未启动
- WebSocket端点配置错误
- 防火墙阻止连接
- 跨域问题

**解决方法**：
```bash
# 检查后端服务是否运行
curl http://localhost:8080/actuator/health

# 检查WebSocket端点
curl http://localhost:8080/ws-notification

# 查看后端日志
tail -f backend/logs/application.log
```

---

### 2. 无法收到通知

**问题**: WebSocket已连接，但收不到通知

**检查清单**：
- [ ] 用户ID是否正确（检查sessionStorage）
- [ ] 订阅频道是否正确（`/user/{userId}/notification`）
- [ ] 后端是否正确发送通知
- [ ] 通知接收人是否包含当前用户

**调试方法**：
```javascript
// 在浏览器控制台执行
console.log('用户ID:', sessionStorage.getItem('userId'))
console.log('WebSocket状态:', webSocketService.isConnected())
```

---

### 3. 桌面通知不显示

**问题**: 没有桌面通知弹窗

**可能原因**：
- 浏览器不支持桌面通知
- 用户拒绝了通知权限
- 浏览器设置禁用了通知
- 操作系统通知被禁用

**解决方法**：
```javascript
// 检查浏览器支持
console.log('支持桌面通知:', 'Notification' in window)

// 检查权限状态
console.log('通知权限:', Notification.permission)

// 手动请求权限
Notification.requestPermission().then(permission => {
  console.log('权限结果:', permission)
})
```

---

### 4. WebSocket频繁断开重连

**问题**: 控制台频繁显示重连日志

**可能原因**：
- 网络不稳定
- 后端服务重启
- 心跳超时
- 代理服务器配置问题

**解决方法**：
```javascript
// 调整重连配置（websocket.js）
this.maxReconnectAttempts = 10  // 增加重连次数
this.reconnectDelay = 5000      // 增加重连延迟
```

---

## 📊 性能对比

### 轮询方式 vs WebSocket方式

| 指标 | 轮询方式 | WebSocket方式 |
|------|---------|--------------|
| 实时性 | ⚠️ 最多30秒延迟 | ✅ 即时推送（<1秒） |
| 服务器负载 | ⚠️ 高（每30秒一次请求） | ✅ 低（长连接） |
| 网络流量 | ⚠️ 高（频繁HTTP请求） | ✅ 低（仅推送时传输） |
| 桌面通知 | ❌ 不支持 | ✅ 支持 |
| 用户体验 | ⚠️ 一般 | ✅ 优秀 |
| 实现复杂度 | ✅ 简单 | ⚠️ 较复杂 |
| 浏览器兼容性 | ✅ 所有浏览器 | ✅ 现代浏览器 |

---

## 🧪 测试清单

### 功能测试

- [ ] WebSocket连接成功
- [ ] 订阅通知频道成功
- [ ] 收到实时通知
- [ ] Element Plus通知弹窗显示
- [ ] 桌面通知显示（已授权）
- [ ] 点击通知跳转到相关页面
- [ ] 未读数量自动更新
- [ ] 断开连接后自动重连
- [ ] 手动断开连接成功

---

### 兼容性测试

- [ ] Chrome浏览器
- [ ] Firefox浏览器
- [ ] Edge浏览器
- [ ] Safari浏览器（Mac）
- [ ] Windows系统
- [ ] macOS系统
- [ ] Linux系统

---

### 性能测试

- [ ] 多用户同时在线
- [ ] 频繁发送通知
- [ ] 长时间保持连接
- [ ] 网络断开后重连
- [ ] 内存占用正常
- [ ] CPU占用正常

---

## 📝 配置文件示例

### package.json

```json
{
  "name": "cultural-relics-frontend",
  "version": "1.0.0",
  "dependencies": {
    "vue": "^3.3.4",
    "vue-router": "^4.2.4",
    "element-plus": "^2.3.14",
    "axios": "^1.5.0",
    "sockjs-client": "^1.6.1",
    "@stomp/stompjs": "^7.0.0"
  }
}
```

---

### vite.config.js（如果需要代理）

```javascript
export default {
  server: {
    proxy: {
      '/ws-notification': {
        target: 'http://localhost:8080',
        ws: true,  // 启用WebSocket代理
        changeOrigin: true
      }
    }
  }
}
```

---

## 🎯 最佳实践

### 1. 错误处理

```javascript
try {
  webSocketService.connect(userId, handleWebSocketNotification)
} catch (error) {
  console.error('WebSocket连接失败:', error)
  // 降级到轮询方式
  startPolling()
}
```

---

### 2. 资源清理

```javascript
// 组件卸载时断开连接
onUnmounted(() => {
  webSocketService.disconnect()
})

// 页面隐藏时断开连接（可选）
document.addEventListener('visibilitychange', () => {
  if (document.hidden) {
    webSocketService.disconnect()
  } else {
    webSocketService.connect(userId, handleWebSocketNotification)
  }
})
```

---

### 3. 通知去重

```javascript
// 使用tag防止重复通知
const options = {
  tag: `notification-${notification.id}`
}
```

---

### 4. 用户体验优化

```javascript
// 紧急通知需要用户交互
requireInteraction: notification.priority === 'URGENT'

// 自动关闭普通通知
if (notification.priority !== 'URGENT') {
  setTimeout(() => notification.close(), 5000)
}
```

---

## 🔗 相关文档

- [消息通知系统状态报告](../NOTIFICATION_STATUS.md)
- [消息通知系统实现文档](../backend/docs/NOTIFICATION_SYSTEM_IMPLEMENTATION.md)
- [消息通知自动触发指南](../backend/docs/NOTIFICATION_AUTO_TRIGGER_GUIDE.md)

---

## ✅ 完成状态

- ✅ WebSocket工具类已创建
- ✅ 通知铃铛组件已更新
- ✅ 桌面通知功能已实现
- ✅ 自动重连机制已实现
- ✅ 错误处理已完善
- ✅ 文档已完成

---

**安装依赖后即可使用WebSocket实时推送和桌面通知功能！** 🎊

**安装命令**: `npm install sockjs-client @stomp/stompjs`
