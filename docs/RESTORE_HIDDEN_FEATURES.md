# 隐藏功能恢复指南

本文档详细说明如何恢复项目中已隐藏的功能。所有隐藏的功能代码都完整保留，只是在前端界面中被注释或过滤，可以轻松恢复。

---

## 📋 目录

1. [借展人管理功能](#1-借展人管理功能)
2. [博物馆管理功能](#2-博物馆管理功能)
3. [借展管理功能](#3-借展管理功能)
4. [前台登录入口](#4-前台登录入口)
5. [文物逾期未归还通知](#5-文物逾期未归还通知)

---

## 1. 借展人管理功能

### 📍 隐藏位置
- **文件**: `frontend/src/views/LayoutView.vue`
- **行数**: 约第 16 行

### 🔧 恢复步骤

#### 步骤 1: 打开文件
```bash
frontend/src/views/LayoutView.vue
```

#### 步骤 2: 找到以下代码
```vue
<!-- 隐藏借展人管理和博物馆管理功能 -->
<!-- <el-menu-item v-if="hasPerm('users:manage')" index="/loaners">{{ $t('nav.loaners') }}</el-menu-item> -->
```

#### 步骤 3: 取消注释
将上述代码修改为：
```vue
<!-- 借展人管理功能 -->
<el-menu-item v-if="hasPerm('users:manage')" index="/loaners">{{ $t('nav.loaners') }}</el-menu-item>
```

### ✅ 恢复后效果
- 左侧菜单栏会显示"借展人管理"菜单项
- 点击后跳转到 `/loaners` 路由
- 需要 `users:manage` 权限才能看到

---

## 2. 博物馆管理功能

### 📍 隐藏位置
- **文件**: `frontend/src/views/LayoutView.vue`
- **行数**: 约第 17 行

### 🔧 恢复步骤

#### 步骤 1: 打开文件
```bash
frontend/src/views/LayoutView.vue
```

#### 步骤 2: 找到以下代码
```vue
<!-- <el-menu-item v-if="hasPerm('users:manage')" index="/museums">{{ $t('nav.museums') }}</el-menu-item> -->
```

#### 步骤 3: 取消注释
将上述代码修改为：
```vue
<el-menu-item v-if="hasPerm('users:manage')" index="/museums">{{ $t('nav.museums') }}</el-menu-item>
```

### ✅ 恢复后效果
- 左侧菜单栏会显示"博物馆管理"菜单项
- 点击后跳转到 `/museums` 路由
- 需要 `users:manage` 权限才能看到

---

## 3. 借展管理功能

### 📍 隐藏位置
- **文件**: `frontend/src/views/LayoutView.vue`
- **行数**: 约第 22 行

### 🔧 恢复步骤

#### 步骤 1: 打开文件
```bash
frontend/src/views/LayoutView.vue
```

#### 步骤 2: 找到以下代码
```vue
<!-- 隐藏借展管理功能 -->
<!-- <el-menu-item v-if="hasPerm('loans:manage')" index="/loans">{{ $t('nav.loans') }}</el-menu-item> -->
```

#### 步骤 3: 取消注释
将上述代码修改为：
```vue
<!-- 借展管理功能 -->
<el-menu-item v-if="hasPerm('loans:manage')" index="/loans">{{ $t('nav.loans') }}</el-menu-item>
```

### ✅ 恢复后效果
- 左侧菜单栏会显示"借展管理"菜单项
- 点击后跳转到 `/loans` 路由
- 需要 `loans:manage` 权限才能看到

---

## 4. 前台登录入口

### 📍 隐藏位置
- **文件**: `frontend/src/views/LoginView.vue`
- **涉及内容**: 
  - 前台入口提示框（模板部分）
  - 跳转函数（脚本部分）
  - 相关样式（样式部分）

### 🔧 恢复步骤

#### 步骤 1: 恢复模板部分

打开文件：
```bash
frontend/src/views/LoginView.vue
```

找到以下代码（约第 11-24 行）：
```vue
<!-- 隐藏前台入口提示 -->
<!-- <div class="portal-tip">
  <el-alert
    :title="$t('login.portalTip')"
    type="info"
    :closable="false"
    show-icon
  >
    <template #default>
      <span>{{ $t('login.portalDesc') }}</span>
      <el-button type="primary" text size="small" @click="goToPortalLogin">
        {{ $t('login.goToPortal') }} →
      </el-button>
    </template>
  </el-alert>
</div> -->
```

修改为：
```vue
<!-- 前台入口提示 -->
<div class="portal-tip">
  <el-alert
    :title="$t('login.portalTip')"
    type="info"
    :closable="false"
    show-icon
  >
    <template #default>
      <span>{{ $t('login.portalDesc') }}</span>
      <el-button type="primary" text size="small" @click="goToPortalLogin">
        {{ $t('login.goToPortal') }} →
      </el-button>
    </template>
  </el-alert>
</div>
```

#### 步骤 2: 恢复脚本部分

在同一文件中，找到以下代码（约第 100-105 行）：
```javascript
/* 隐藏前台入口跳转函数 */
/*
const goToPortalLogin = () => {
  router.push('/portal-login')
}
*/
```

修改为：
```javascript
const goToPortalLogin = () => {
  router.push('/portal-login')
}
```

#### 步骤 3: 恢复样式部分

在同一文件中，找到以下代码（约第 160-180 行）：
```css
/* 隐藏前台入口提示的样式 */
/*
.portal-tip {
  margin-bottom: 20px;
}

.portal-tip :deep(.el-alert) {
  border-radius: 8px;
  padding: 12px 16px;
}

.portal-tip :deep(.el-alert__content) {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 8px;
}

.portal-tip :deep(.el-button) {
  font-weight: 600;
  margin-left: 8px;
}
*/
```

修改为：
```css
.portal-tip {
  margin-bottom: 20px;
}

.portal-tip :deep(.el-alert) {
  border-radius: 8px;
  padding: 12px 16px;
}

.portal-tip :deep(.el-alert__content) {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 8px;
}

.portal-tip :deep(.el-button) {
  font-weight: 600;
  margin-left: 8px;
}
```

### ✅ 恢复后效果
- 登录页面会显示前台入口提示框
- 提示框包含"前往前台登录"按钮
- 点击按钮跳转到 `/portal-login` 路由

---

## 5. 文物逾期未归还通知

### 📍 隐藏位置
- **文件 1**: `frontend/src/components/NotificationBell.vue`
- **文件 2**: `frontend/src/views/NotificationsView.vue`

### 🔧 恢复步骤

#### 步骤 1: 恢复通知铃铛组件

打开文件：
```bash
frontend/src/components/NotificationBell.vue
```

##### 1.1 恢复未读通知加载

找到 `loadUnreadNotifications` 函数（约第 170-183 行）：
```javascript
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
```

修改为：
```javascript
// 加载未读通知列表
const loadUnreadNotifications = async () => {
  // 未登录时不加载通知
  if (!sessionStorage.getItem('token')) {
    return
  }
  
  try {
    const res = await getNotificationsApi({ pageNum: 1, pageSize: 10, isRead: false })
    unreadNotifications.value = res.data.records || []
  } catch (error) {
    console.error('加载未读通知失败:', error)
  }
}
```

##### 1.2 恢复全部通知加载

找到 `loadAllNotifications` 函数（约第 185-198 行）：
```javascript
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
```

修改为：
```javascript
// 加载全部通知列表
const loadAllNotifications = async () => {
  // 未登录时不加载通知
  if (!sessionStorage.getItem('token')) {
    return
  }
  
  try {
    const res = await getNotificationsApi({ pageNum: 1, pageSize: 20 })
    allNotifications.value = res.data.records || []
  } catch (error) {
    console.error('加载通知列表失败:', error)
  }
}
```

##### 1.3 恢复WebSocket通知推送

找到 `handleWebSocketNotification` 函数（约第 280-302 行）：
```javascript
// 处理WebSocket推送的通知
const handleWebSocketNotification = (notification) => {
  console.log('📬 处理WebSocket通知:', notification)
  
  // 隐藏逾期未归还的通知
  if (notification.type === 'LOAN_OVERDUE') {
    console.log('🚫 已过滤逾期未归还通知')
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
```

修改为：
```javascript
// 处理WebSocket推送的通知
const handleWebSocketNotification = (notification) => {
  console.log('📬 处理WebSocket通知:', notification)
  
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
```

#### 步骤 2: 恢复通知页面

打开文件：
```bash
frontend/src/views/NotificationsView.vue
```

找到 `loadNotifications` 函数（约第 230-255 行）：
```javascript
// 加载通知列表
const loadNotifications = async () => {
  try {
    loading.value = true
    const params = {
      pageNum: queryForm.pageNum,
      pageSize: queryForm.pageSize
    }
    
    if (queryForm.keyword) {
      params.keyword = queryForm.keyword
    }
    
    if (queryForm.isRead !== null && queryForm.isRead !== undefined) {
      params.isRead = queryForm.isRead
    }
    
    const res = await getNotificationsApi(params)
    // 过滤掉逾期未归还的通知（type为LOAN_OVERDUE）
    notificationsList.value = (res.data.records || []).filter(item => item.type !== 'LOAN_OVERDUE')
    // 重新计算总数（减去被过滤的通知数量）
    const filteredCount = (res.data.records || []).length - notificationsList.value.length
    total.value = (res.data.total || 0) - filteredCount
  } catch (error) {
    console.error('加载通知列表失败:', error)
    ElMessage.error(t('notification.loadFailed'))
  } finally {
    loading.value = false
  }
}
```

修改为：
```javascript
// 加载通知列表
const loadNotifications = async () => {
  try {
    loading.value = true
    const params = {
      pageNum: queryForm.pageNum,
      pageSize: queryForm.pageSize
    }
    
    if (queryForm.keyword) {
      params.keyword = queryForm.keyword
    }
    
    if (queryForm.isRead !== null && queryForm.isRead !== undefined) {
      params.isRead = queryForm.isRead
    }
    
    const res = await getNotificationsApi(params)
    notificationsList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载通知列表失败:', error)
    ElMessage.error(t('notification.loadFailed'))
  } finally {
    loading.value = false
  }
}
```

### ✅ 恢复后效果
- 通知铃铛会显示逾期未归还通知
- 通知列表会显示逾期未归还通知
- WebSocket会推送逾期未归还通知
- 桌面通知会显示逾期未归还通知
- 通知页面会显示逾期未归还通知

---

## 📝 快速恢复清单

### 菜单项恢复（LayoutView.vue）
- [ ] 借展人管理 - 取消第 16 行注释
- [ ] 博物馆管理 - 取消第 17 行注释
- [ ] 借展管理 - 取消第 22 行注释

### 登录页面恢复（LoginView.vue）
- [ ] 前台入口提示框 - 取消第 11-24 行注释
- [ ] 跳转函数 - 取消第 100-105 行注释
- [ ] 相关样式 - 取消第 160-180 行注释

### 通知功能恢复
- [ ] NotificationBell.vue - 删除 3 处过滤代码
- [ ] NotificationsView.vue - 删除 1 处过滤代码

---

## ⚠️ 注意事项

### 1. 代码完整性
所有隐藏的功能代码都完整保留，包括：
- 前端路由配置
- 后端API接口
- 数据库表结构
- 业务逻辑代码

### 2. 权限控制
恢复后的功能仍然受权限控制：
- 借展人管理：需要 `users:manage` 权限
- 博物馆管理：需要 `users:manage` 权限
- 借展管理：需要 `loans:manage` 权限

### 3. 数据完整性
隐藏期间产生的数据仍然保存在数据库中：
- 借展人数据
- 博物馆数据
- 借展记录
- 逾期通知记录

### 4. 测试建议
恢复功能后建议进行以下测试：
- [ ] 菜单项是否正常显示
- [ ] 路由跳转是否正常
- [ ] 数据加载是否正常
- [ ] 权限控制是否生效
- [ ] 通知推送是否正常

---

## 🔍 故障排查

### 问题 1: 恢复后菜单项不显示
**可能原因**：
- 当前用户没有相应权限
- 注释未完全取消

**解决方法**：
1. 检查用户权限配置
2. 确认注释符号已完全删除
3. 清除浏览器缓存并刷新

### 问题 2: 恢复后页面报错
**可能原因**：
- 代码格式错误
- 缺少必要的导入

**解决方法**：
1. 检查代码语法是否正确
2. 确认所有注释符号已正确删除
3. 重启前端开发服务器

### 问题 3: 通知仍然不显示
**可能原因**：
- 过滤代码未完全删除
- 浏览器缓存问题

**解决方法**：
1. 确认所有过滤逻辑已删除
2. 清除浏览器缓存
3. 重新登录系统

---

## 📞 技术支持

如果在恢复过程中遇到问题，请检查：
1. 代码修改是否完整
2. 文件保存是否成功
3. 前端服务是否重启
4. 浏览器缓存是否清除

---

## 📅 文档版本

- **创建日期**: 2026-05-13
- **最后更新**: 2026-05-13
- **版本号**: v1.0
- **适用系统**: 文物管理系统 v1.0

---

**注意**: 本文档基于当前系统版本编写，如果系统有重大更新，请参考最新的技术文档。
