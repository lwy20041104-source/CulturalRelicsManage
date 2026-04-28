# WebSocket实时推送快速开始指南

## 🚀 5分钟快速启动

### 1. 安装依赖（2分钟）

**Windows用户**:
```bash
cd frontend
install-websocket.bat
```

**Linux/Mac用户**:
```bash
cd frontend
bash install-websocket.sh
```

**或手动安装**:
```bash
cd frontend
npm install sockjs-client @stomp/stompjs
```

---

### 2. 启动服务（1分钟）

**启动后端**:
```bash
cd backend
mvn spring-boot:run
```

**启动前端**:
```bash
cd frontend
npm run dev
```

---

### 3. 测试连接（2分钟）

#### 方法1：使用测试页面

1. 登录系统
2. 访问测试页面：`http://localhost:5173/websocket-test`
3. 点击"连接WebSocket"按钮
4. 查看连接状态是否为"已连接"
5. 点击"测试通知"按钮
6. 查看是否收到通知

#### 方法2：实际测试

1. 登录为借展人
2. 提交借展申请
3. 登录为管理员
4. 查看是否收到实时通知（无需刷新页面）

---

## ✅ 验证清单

- [ ] 依赖安装成功
- [ ] 后端服务启动成功
- [ ] 前端服务启动成功
- [ ] WebSocket连接成功
- [ ] 收到测试通知
- [ ] 桌面通知权限已授权
- [ ] 实际业务通知正常

---

## 🎯 预期效果

### 控制台日志
```
🚀 启动WebSocket连接，用户ID: 1
✅ WebSocket连接成功
📡 已订阅通知频道: /user/1/notification
📨 收到WebSocket通知: {...}
```

### 页面效果
- ✅ 右上角通知铃铛显示未读数量
- ✅ 收到通知时显示Element Plus弹窗
- ✅ 桌面显示浏览器原生通知（已授权）
- ✅ 点击通知跳转到相关页面

---

## 🔧 常见问题

### Q1: 依赖安装失败？
**A**: 检查网络连接，或使用淘宝镜像：
```bash
npm config set registry https://registry.npmmirror.com
npm install sockjs-client @stomp/stompjs
```

### Q2: WebSocket连接失败？
**A**: 确保后端服务已启动，检查端口8080是否被占用。

### Q3: 没有桌面通知？
**A**: 点击"请求桌面通知权限"按钮，在浏览器弹窗中点击"允许"。

### Q4: 收不到通知？
**A**: 检查用户ID是否正确，查看控制台是否有错误日志。

---

## 📚 详细文档

- **完整安装指南**: `frontend/WEBSOCKET_SETUP.md`
- **系统状态报告**: `NOTIFICATION_STATUS.md`
- **后端实现文档**: `backend/docs/NOTIFICATION_SYSTEM_IMPLEMENTATION.md`

---

## 🎊 完成！

现在你已经成功启用了WebSocket实时推送和桌面通知功能！

**享受即时通知的便利吧！** 🚀
