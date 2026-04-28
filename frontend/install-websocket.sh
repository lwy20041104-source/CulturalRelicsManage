#!/bin/bash

# WebSocket依赖安装脚本
# 用于安装WebSocket实时推送所需的依赖

echo "================================================"
echo "  WebSocket实时推送依赖安装脚本"
echo "================================================"
echo ""

# 检查是否在frontend目录
if [ ! -f "package.json" ]; then
    echo "❌ 错误：请在frontend目录下运行此脚本"
    echo "   cd frontend && bash install-websocket.sh"
    exit 1
fi

echo "📦 开始安装WebSocket依赖..."
echo ""

# 安装依赖
npm install sockjs-client @stomp/stompjs

# 检查安装结果
if [ $? -eq 0 ]; then
    echo ""
    echo "================================================"
    echo "✅ WebSocket依赖安装成功！"
    echo "================================================"
    echo ""
    echo "已安装的依赖："
    echo "  - sockjs-client: SockJS客户端库"
    echo "  - @stomp/stompjs: STOMP协议客户端"
    echo ""
    echo "下一步操作："
    echo "  1. 启动后端服务: cd backend && mvn spring-boot:run"
    echo "  2. 启动前端服务: npm run dev"
    echo "  3. 登录系统测试WebSocket连接"
    echo "  4. 提交借展或修复申请测试实时通知"
    echo ""
    echo "查看详细文档: frontend/WEBSOCKET_SETUP.md"
    echo "================================================"
else
    echo ""
    echo "================================================"
    echo "❌ WebSocket依赖安装失败"
    echo "================================================"
    echo ""
    echo "请尝试以下解决方法："
    echo "  1. 检查网络连接"
    echo "  2. 清除npm缓存: npm cache clean --force"
    echo "  3. 删除node_modules: rm -rf node_modules"
    echo "  4. 重新安装: npm install"
    echo "  5. 手动安装: npm install sockjs-client @stomp/stompjs"
    echo ""
    echo "================================================"
    exit 1
fi
