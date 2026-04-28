# 文物二维码网络访问配置指南

## 问题说明

**当前问题**：项目在本地开发环境运行，生成的二维码URL是 `http://localhost:5173/qrcode/{id}`，其他设备扫描后无法访问。

**原因**：`localhost` 只能在本机访问，其他设备（手机、平板）无法通过 `localhost` 访问你的电脑。

## 解决方案对比

| 方案 | 适用场景 | 优点 | 缺点 |
|------|---------|------|------|
| 方案1：局域网IP | 临时测试、内网演示 | 配置简单、无需部署 | 只能同一WiFi访问、IP可能变化 |
| 方案2：内网穿透 | 远程演示、临时分享 | 外网可访问、配置简单 | 依赖第三方服务、速度较慢 |
| 方案3：服务器部署 | 正式使用、生产环境 | 稳定可靠、性能好 | 需要服务器、配置复杂 |

---

## 方案1：使用局域网IP（推荐用于测试）

### 适用场景
- ✅ 同一WiFi网络下的设备访问
- ✅ 内网演示、测试
- ✅ 快速验证功能

### 配置步骤

#### 1. 获取本机IP地址

**Windows系统**：
```bash
ipconfig
```
查找 `IPv4 地址`，例如：`192.168.1.100`

**Mac系统**：
```bash
ifconfig | grep "inet "
```

**Linux系统**：
```bash
ip addr show
```

**示例输出**：
```
IPv4 地址: 192.168.1.100
```

#### 2. 确认前端配置（已配置好）

文件：`frontend/vite.config.js`

```javascript
export default defineConfig({
  server: {
    port: 5173,
    host: '0.0.0.0'  // ✅ 已配置，允许局域网访问
  }
})
```

#### 3. 修改后端配置（如需要）

文件：`backend/src/main/resources/application.yml`

添加或修改：
```yaml
server:
  port: 8080
  address: 0.0.0.0  # 允许所有网络接口访问
  servlet:
    context-path: /api
```

#### 4. 修改前端API配置

文件：`frontend/src/api/request.js`

查找 `baseURL` 配置，修改为：
```javascript
const request = axios.create({
  baseURL: 'http://192.168.1.100:8080/api',  // 改为你的IP地址
  timeout: 10000
})
```

#### 5. 修改二维码生成时的baseUrl

**方法A：前端传递正确的baseUrl**

文件：`frontend/src/views/PublicRelicsView.vue`

修改 `generateQRCode` 函数：
```javascript
const generateQRCode = async (relicId) => {
  qrcodeLoading.value = true
  try {
    // 使用当前访问的域名，而不是硬编码localhost
    const baseUrl = window.location.origin  // 自动获取当前URL
    const res = await request.get(`/relics/${relicId}/qrcode`, {
      params: { baseUrl }
    })
    // ...
  }
}
```

**方法B：后端使用环境变量**

文件：`backend/src/main/resources/application.yml`

添加配置：
```yaml
app:
  frontend-url: http://192.168.1.100:5173  # 你的局域网IP
```

文件：`backend/src/main/java/com/example/controller/CulturalRelicController.java`

修改默认值：
```java
@GetMapping("/{id}/qrcode")
public Result<String> generateQRCode(
    @PathVariable Long id, 
    @RequestParam(defaultValue = "${app.frontend-url:http://localhost:5173}") String baseUrl) {
    // ...
}
```

#### 6. 重启服务

```bash
# 重启后端
cd backend
mvn spring-boot:run

# 重启前端
cd frontend
npm run dev
```

#### 7. 测试访问

**在手机上测试**：
1. 确保手机和电脑连接同一WiFi
2. 在手机浏览器输入：`http://192.168.1.100:5173`
3. 如果能访问，说明配置成功

**生成并扫描二维码**：
1. 在电脑上访问：`http://192.168.1.100:5173/public-relics`
2. 点击文物查看详情
3. 下载二维码
4. 用手机扫描二维码
5. 应该能看到文物信息

### 注意事项

⚠️ **IP地址可能变化**
- 路由器可能重新分配IP
- 建议在路由器中设置静态IP

⚠️ **防火墙设置**
- Windows防火墙可能阻止访问
- 需要允许端口 5173 和 8080

⚠️ **同一网络**
- 手机和电脑必须在同一WiFi下
- 不能使用手机流量

---

## 方案2：使用内网穿透（远程访问）

### 适用场景
- ✅ 不在同一网络的设备访问
- ✅ 远程演示
- ✅ 临时分享给他人

### 推荐工具

#### 1. ngrok（国外）
```bash
# 安装ngrok
# 访问 https://ngrok.com/ 注册账号

# 启动前端穿透
ngrok http 5173

# 启动后端穿透
ngrok http 8080
```

#### 2. 花生壳（国内）
- 访问：https://hsk.oray.com/
- 下载客户端
- 配置内网穿透

#### 3. frp（自建）
- 需要有公网服务器
- 配置较复杂但免费

### 配置步骤（以ngrok为例）

#### 1. 安装ngrok
访问 https://ngrok.com/ 下载并安装

#### 2. 启动前端穿透
```bash
ngrok http 5173
```

输出示例：
```
Forwarding  https://abc123.ngrok.io -> http://localhost:5173
```

#### 3. 启动后端穿透
```bash
ngrok http 8080
```

输出示例：
```
Forwarding  https://xyz789.ngrok.io -> http://localhost:8080
```

#### 4. 修改前端API配置
```javascript
const request = axios.create({
  baseURL: 'https://xyz789.ngrok.io/api',  // 使用ngrok提供的URL
  timeout: 10000
})
```

#### 5. 生成二维码时使用ngrok URL
```javascript
const baseUrl = 'https://abc123.ngrok.io'  // 前端的ngrok URL
```

### 注意事项

⚠️ **免费版限制**
- ngrok免费版每次启动URL会变化
- 有连接数限制
- 速度可能较慢

⚠️ **安全性**
- 不要在生产环境使用
- 不要暴露敏感数据

---

## 方案3：部署到服务器（生产环境）

### 适用场景
- ✅ 正式使用
- ✅ 长期运行
- ✅ 多人访问

### 部署步骤概述

#### 1. 准备服务器
- 云服务器（阿里云、腾讯云、AWS等）
- 域名（可选但推荐）
- SSL证书（HTTPS）

#### 2. 前端部署
```bash
# 构建前端
cd frontend
npm run build

# 上传dist目录到服务器
# 使用Nginx托管静态文件
```

#### 3. 后端部署
```bash
# 打包后端
cd backend
mvn clean package

# 上传jar文件到服务器
# 使用systemd或docker运行
```

#### 4. 配置Nginx
```nginx
server {
    listen 80;
    server_name your-domain.com;

    # 前端
    location / {
        root /var/www/frontend/dist;
        try_files $uri $uri/ /index.html;
    }

    # 后端API
    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

#### 5. 配置域名和SSL
```bash
# 使用Let's Encrypt免费SSL证书
certbot --nginx -d your-domain.com
```

### 部署后的URL
- 前端：`https://your-domain.com`
- 后端：`https://your-domain.com/api`
- 二维码：`https://your-domain.com/qrcode/{id}`

---

## 快速测试方案（推荐）

### 最简单的测试方法

#### 1. 修改前端代码（自动获取URL）

文件：`frontend/src/views/PublicRelicsView.vue`

```javascript
const generateQRCode = async (relicId) => {
  qrcodeLoading.value = true
  try {
    // ✅ 自动使用当前访问的URL
    const baseUrl = window.location.origin
    console.log('生成二维码使用的baseUrl:', baseUrl)
    
    const res = await request.get(`/relics/${relicId}/qrcode`, {
      params: { baseUrl }
    })
    // ...
  }
}
```

#### 2. 修改前端API配置（支持多环境）

文件：`frontend/src/api/request.js`

```javascript
// 自动检测环境
const getBaseURL = () => {
  // 如果是localhost，使用localhost
  if (window.location.hostname === 'localhost') {
    return 'http://localhost:8080/api'
  }
  // 否则使用当前域名
  return `${window.location.protocol}//${window.location.hostname}:8080/api`
}

const request = axios.create({
  baseURL: getBaseURL(),
  timeout: 10000
})
```

#### 3. 获取本机IP并访问

```bash
# 获取IP
ipconfig  # Windows
ifconfig  # Mac/Linux

# 假设IP是 192.168.1.100
# 在手机浏览器访问：
http://192.168.1.100:5173
```

#### 4. 测试流程

1. 电脑和手机连接同一WiFi
2. 在手机浏览器输入：`http://192.168.1.100:5173/public-relics`
3. 点击文物查看详情
4. 查看二维码（此时二维码URL应该是 `http://192.168.1.100:5173/qrcode/{id}`）
5. 用另一台手机扫描二维码
6. 应该能正常访问

---

## 常见问题

### Q1: 手机无法访问电脑的IP地址
**解决方法**：
- 检查是否在同一WiFi
- 关闭电脑防火墙测试
- Windows防火墙添加入站规则（端口5173和8080）

### Q2: 二维码扫描后显示localhost
**解决方法**：
- 确认前端代码使用 `window.location.origin`
- 不要硬编码 `localhost`
- 重新生成二维码

### Q3: 后端API请求失败
**解决方法**：
- 检查后端是否绑定 `0.0.0.0`
- 检查CORS配置
- 查看浏览器控制台错误信息

### Q4: IP地址经常变化
**解决方法**：
- 在路由器中设置静态IP
- 使用内网穿透工具
- 部署到服务器

---

## 总结

### 开发测试阶段
✅ **推荐使用方案1（局域网IP）**
- 配置简单
- 速度快
- 适合内部测试

### 演示阶段
✅ **推荐使用方案2（内网穿透）**
- 可以远程访问
- 无需服务器
- 适合临时演示

### 生产环境
✅ **必须使用方案3（服务器部署）**
- 稳定可靠
- 性能好
- 适合正式使用

---

## 代码修改清单

### 必须修改的文件

1. **frontend/src/views/PublicRelicsView.vue**
   - 修改 `generateQRCode` 函数
   - 使用 `window.location.origin` 而不是硬编码

2. **frontend/src/api/request.js**
   - 修改 `baseURL` 配置
   - 支持多环境自动切换

### 可选修改的文件

1. **backend/src/main/resources/application.yml**
   - 添加 `server.address: 0.0.0.0`
   - 添加 `app.frontend-url` 配置

2. **backend/src/main/java/com/example/controller/CulturalRelicController.java**
   - 修改 `generateQRCode` 方法的默认值

---

**文档创建时间**：2024年
**作者**：Kiro AI Assistant
**状态**：✅ 完成
