# 前端消息通知功能实现文档

## 实现日期
2026年4月24日

## 功能概述
在前端顶部导航栏的中英文切换按钮旁边添加了消息通知图标，用户可以实时查看和管理系统通知。

## 实现内容

### 1. 通知API接口 (`frontend/src/api/notifications.js`)

创建了完整的通知API接口：

```javascript
- getNotificationsApi(params)      // 获取通知列表（支持分页和筛选）
- markAsReadApi(id)                // 标记单条通知为已读
- markAllAsReadApi(notificationIds) // 批量标记为已读
- getUnreadCountApi()              // 获取未读通知数量
- deleteNotificationApi(id)        // 删除通知
```

### 2. 通知组件 (`frontend/src/components/NotificationBell.vue`)

#### 核心功能
- **铃铛图标**：显示在顶部导航栏，带有未读数量徽章
- **弹出面板**：点击铃铛图标弹出通知列表
- **双标签页**：
  - 未读通知：只显示未读消息，显示未读数量
  - 全部通知：显示所有消息，包括已读和未读
- **实时轮询**：每30秒自动刷新通知列表
- **优先级标识**：高优先级和紧急通知带有红色标签
- **时间格式化**：智能显示相对时间（刚刚、X分钟前、X小时前等）

#### 交互功能
- **点击通知**：
  - 自动标记为已读
  - 根据通知类型跳转到相应页面（借展管理/修复管理）
- **全部已读**：一键标记所有未读通知为已读
- **删除通知**：单条删除，带确认提示
- **查看全部**：跳转到通知列表页面（待开发）

#### 样式设计
- 采用项目统一的文物主题配色
- 高优先级通知带有左侧红色边框
- 已读通知显示为半透明
- 空状态显示友好的提示信息

### 3. 布局集成 (`frontend/src/views/LayoutView.vue`)

在顶部导航栏的 `header-actions` 区域添加了通知组件：

```vue
<div class="header-actions">
  <NotificationBell />      <!-- 新增：通知铃铛 -->
  <LanguageSwitcher />      <!-- 原有：语言切换 -->
  <el-button>退出登录</el-button>
</div>
```

### 4. 国际化支持

#### 中文翻译 (`frontend/src/i18n/locales/zh-CN.js`)
```javascript
notification: {
  title: '消息通知',
  unread: '未读',
  all: '全部',
  markAllRead: '全部已读',
  noUnread: '暂无未读消息',
  noNotifications: '暂无消息',
  deleteConfirm: '确定要删除这条通知吗？',
  // ... 更多翻译
}
```

#### 英文翻译 (`frontend/src/i18n/locales/en-US.js`)
```javascript
notification: {
  title: 'Notifications',
  unread: 'Unread',
  all: 'All',
  markAllRead: 'Mark All Read',
  // ... 更多翻译
}
```

## 通知类型映射

### 借展相关
- **LOAN_APPLY**: 借展申请 → 跳转到借展管理页面
- **LOAN_APPROVED**: 借展审批通过 → 跳转到借展管理页面
- **LOAN_REJECTED**: 借展审批拒绝 → 跳转到借展管理页面
- **LOAN_OVERDUE**: 借展逾期 → 跳转到借展管理页面

### 修复相关
- **REPAIR_APPLY**: 修复申请 → 跳转到修复管理页面
- **REPAIR_APPROVED**: 修复审批通过 → 跳转到修复管理页面
- **REPAIR_REJECTED**: 修复审批拒绝 → 跳转到修复管理页面

## 优先级显示

### 普通优先级 (NORMAL, LOW)
- 无特殊标识
- 正常显示

### 高优先级 (HIGH, URGENT)
- 显示红色标签（"重要"或"紧急"）
- 左侧红色边框
- 更醒目的视觉效果

## 技术特性

### 1. 自动轮询
- 组件挂载时立即加载通知
- 每30秒自动刷新一次
- 组件卸载时自动停止轮询
- 避免内存泄漏

### 2. 智能时间显示
```javascript
- 1分钟内：刚刚
- 1小时内：X分钟前
- 24小时内：X小时前
- 7天内：X天前
- 超过7天：显示具体日期
```

### 3. 响应式设计
- 弹出面板宽度：400px
- 最大高度：500px
- 通知列表高度：350px
- 支持滚动查看更多通知

### 4. 用户体验优化
- 空状态友好提示
- 加载状态处理
- 错误提示
- 操作确认
- 成功反馈

## 使用说明

### 用户操作流程

1. **查看通知**
   - 点击顶部导航栏的铃铛图标
   - 查看未读通知数量徽章
   - 在弹出面板中浏览通知

2. **切换标签**
   - 点击"未读"标签查看未读消息
   - 点击"全部"标签查看所有消息

3. **标记已读**
   - 点击单条通知自动标记为已读
   - 点击"全部已读"按钮批量标记

4. **删除通知**
   - 在"全部"标签页中
   - 点击通知右下角的"删除"按钮
   - 确认后删除

5. **跳转页面**
   - 点击借展相关通知 → 跳转到借展管理
   - 点击修复相关通知 → 跳转到修复管理

## 待开发功能

### 1. 通知列表页面
- 完整的通知列表页面
- 支持更多筛选条件
- 支持搜索功能
- 支持批量操作

### 2. 实时推送
- 集成WebSocket
- 实时接收新通知
- 桌面通知提醒
- 声音提醒

### 3. 通知设置
- 用户自定义通知偏好
- 选择接收的通知类型
- 设置提醒方式

### 4. 通知分组
- 按日期分组
- 按类型分组
- 按优先级分组

## 测试建议

### 1. 功能测试
- [ ] 通知列表正常加载
- [ ] 未读数量显示正确
- [ ] 标记已读功能正常
- [ ] 批量标记已读功能正常
- [ ] 删除通知功能正常
- [ ] 点击通知跳转正确
- [ ] 自动轮询正常工作

### 2. 界面测试
- [ ] 铃铛图标显示正常
- [ ] 未读徽章显示正常
- [ ] 弹出面板样式正确
- [ ] 通知列表滚动正常
- [ ] 空状态显示正常
- [ ] 优先级标识显示正确

### 3. 国际化测试
- [ ] 中文界面显示正确
- [ ] 英文界面显示正确
- [ ] 语言切换正常

### 4. 性能测试
- [ ] 大量通知时性能正常
- [ ] 轮询不影响页面性能
- [ ] 内存占用正常

## 相关文件

### 新增文件
- `frontend/src/api/notifications.js` - 通知API接口
- `frontend/src/components/NotificationBell.vue` - 通知组件
- `frontend/docs/NOTIFICATION_FRONTEND_IMPLEMENTATION.md` - 本文档

### 修改文件
- `frontend/src/views/LayoutView.vue` - 添加通知组件
- `frontend/src/i18n/locales/zh-CN.js` - 添加中文翻译
- `frontend/src/i18n/locales/en-US.js` - 添加英文翻译

## 后端依赖

前端通知功能依赖以下后端API：

- `GET /api/notifications` - 获取通知列表
- `PUT /api/notifications/{id}/read` - 标记已读
- `PUT /api/notifications/read-all` - 批量标记已读
- `GET /api/notifications/unread-count` - 获取未读数量
- `DELETE /api/notifications/{id}` - 删除通知

详见后端文档：`backend/docs/NOTIFICATION_SYSTEM_IMPLEMENTATION.md`

## 启动说明

### 1. 确保后端服务运行
```bash
cd backend
mvn clean package -DskipTests
java -jar target/cultural-relics-manage-1.0.0.jar
```

### 2. 启动前端开发服务器
```bash
cd frontend
npm install
npm run dev
```

### 3. 访问系统
- 前端地址：http://localhost:5173
- 后端地址：http://localhost:8080
- API文档：http://localhost:8080/doc.html

### 4. 测试通知功能
1. 登录系统（使用管理员或相关角色账号）
2. 查看顶部导航栏的铃铛图标
3. 提交借展申请或修复申请触发通知
4. 点击铃铛图标查看通知

## 注意事项

1. **权限控制**：通知功能需要用户登录后才能使用
2. **轮询频率**：当前设置为30秒，可根据实际需求调整
3. **通知数量**：弹出面板默认显示最近20条通知
4. **浏览器兼容**：建议使用Chrome、Firefox、Edge等现代浏览器
5. **网络要求**：需要稳定的网络连接以保证轮询正常工作

## 未来优化方向

1. **性能优化**
   - 使用虚拟滚动处理大量通知
   - 优化轮询策略（智能轮询）
   - 添加缓存机制

2. **用户体验**
   - 添加通知动画效果
   - 支持通知分组折叠
   - 添加快捷操作按钮

3. **功能扩展**
   - 支持通知搜索
   - 支持通知导出
   - 添加通知统计图表

4. **移动端适配**
   - 响应式布局优化
   - 触摸手势支持
   - 移动端专用界面
