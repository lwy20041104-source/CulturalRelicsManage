# DeepSeek API Key 获取步骤（图文教程）

## 📋 快速概览

获取 DeepSeek API Key 需要 4 个步骤，大约 5-10 分钟：

```
1️⃣ 注册账号 → 2️⃣ 充值账户 → 3️⃣ 生成 API Key → 4️⃣ 配置到项目
```

---

## 🎯 详细步骤

### 步骤 1：访问并注册

#### 1.1 打开 DeepSeek API 平台
在浏览器中访问：
```
https://platform.deepseek.com
```

⚠️ **注意**：是 `platform.deepseek.com`，不是 `www.deepseek.com`

#### 1.2 注册新账号
点击右上角的 **"Sign Up"** 按钮，选择注册方式：

**方式 A：邮箱注册**
```
1. 输入邮箱地址
2. 设置密码（至少8位，包含字母和数字）
3. 点击发送验证邮件
4. 打开邮箱，点击验证链接
5. 完成注册
```

**方式 B：手机号注册**
```
1. 选择国家/地区代码（中国 +86）
2. 输入手机号码
3. 点击获取验证码
4. 输入收到的验证码
5. 设置密码
6. 完成注册
```

#### 1.3 登录控制台
注册成功后，使用账号密码登录，进入控制台首页。

---

### 步骤 2：充值账户（必需）

⚠️ **重要提示**：DeepSeek API 是付费服务，必须先充值才能使用！

#### 2.1 进入充值页面
在控制台左侧菜单中，找到并点击：
- **"Top up"**（充值）或
- **"Billing"**（账单）→ **"Add credits"**（添加余额）

#### 2.2 选择充值金额
```
💰 建议充值金额：
- 测试使用：$5 - $10（足够数千次查询）
- 正式使用：$20 - $50（根据实际需求）
- 大规模使用：$100+
```

#### 2.3 添加支付方式
支持的支付方式：
- 💳 **国际信用卡**（Visa、MasterCard、American Express）
- 💰 **其他支付方式**（根据地区可能不同）

填写信用卡信息：
```
1. 卡号（16位数字）
2. 持卡人姓名
3. 有效期（MM/YY）
4. CVV 安全码（卡背面3位数字）
5. 账单地址
```

#### 2.4 完成支付
- 点击 **"Pay"** 或 **"Confirm"** 完成支付
- 等待支付成功确认
- 余额会立即更新到账户

#### 2.5 查看余额
在控制台首页可以看到：
```
💰 Current Balance: $5.00
📊 Today's Usage: $0.00
```

---

### 步骤 3：生成 API Key

#### 3.1 进入 API Keys 页面
在左侧菜单栏，点击 **"API keys"**（API 密钥）

#### 3.2 创建新密钥
1. 点击 **"Create new API key"** 按钮
2. 在弹出的对话框中，为密钥命名：
   ```
   建议命名：
   - cultural-relics-system（文物管理系统）
   - my-app-dev（我的应用-开发环境）
   - production-key（生产环境密钥）
   ```
3. 点击 **"Confirm"** 或 **"Create"** 按钮

#### 3.3 复制 API Key
⚠️ **非常重要**：API Key 只显示一次，请立即复制！

```
生成的 API Key 格式：
sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**复制方法**：
1. 点击 API Key 旁边的 📋 复制按钮，或
2. 手动选中整个 API Key，按 Ctrl+C（Windows）或 Cmd+C（Mac）

#### 3.4 保存 API Key
将 API Key 保存到安全的地方：

**✅ 推荐保存位置**：
- 密码管理器（1Password、LastPass、Bitwarden）
- 本地加密文件
- 项目的 `.env` 文件（不要提交到 Git）
- 公司的密钥管理系统

**❌ 不要保存在**：
- 公开的代码仓库
- 聊天记录或邮件
- 云笔记（如果未加密）
- 截图或照片

#### 3.5 如果丢失 API Key
如果忘记保存或丢失了 API Key：
1. 返回 "API keys" 页面
2. 删除旧的 API Key
3. 重新创建新的 API Key

---

### 步骤 4：配置到项目

#### 4.1 打开配置文件
在项目中找到并打开：
```
backend/src/main/resources/application.yml
```

#### 4.2 找到 DeepSeek 配置
搜索 `deepseek:`，找到以下内容：

```yaml
# DeepSeek AI配置
deepseek:
  # DeepSeek API Key（请替换为您的实际API Key）
  api-key: your-deepseek-api-key-here
  # DeepSeek API地址
  api-url: https://api.deepseek.com/v1/chat/completions
  # 使用的模型
  model: deepseek-chat
  # 最大tokens数
  max-tokens: 2000
  # 温度参数（0-2，越高越随机）
  temperature: 0.7
  # 连接超时时间（毫秒）
  connect-timeout: 10000
  # 读取超时时间（毫秒）
  read-timeout: 30000
```

#### 4.3 替换 API Key
将 `your-deepseek-api-key-here` 替换为您复制的实际 API Key：

```yaml
deepseek:
  api-key: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  # 粘贴你的API Key
  # 其他配置保持不变
```

⚠️ **注意事项**：
- 确保 API Key 前后没有多余的空格
- 确保 YAML 格式正确（注意缩进）
- 不要修改其他配置项（除非你知道它们的作用）

#### 4.4 保存文件
- 按 `Ctrl + S`（Windows/Linux）或 `Cmd + S`（Mac）
- 确认文件已保存

---

## 🚀 测试配置

### 方法 1：启动应用测试

#### 1. 启动后端服务
```bash
cd backend
mvn spring-boot:run
```

#### 2. 查看启动日志
如果配置正确，日志中会显示：
```
✅ 成功标志：
INFO  - DeepSeek API 配置加载成功
INFO  - API Key: sk-****...（部分隐藏）
```

如果配置错误，会显示：
```
❌ 错误标志：
WARN  - DeepSeek API Key 未配置或无效
ERROR - 无法连接到 DeepSeek API
```

#### 3. 测试 AI 查询
- 登录系统
- 进入 AI 搜索页面
- 输入测试问题："有哪些文物？"
- 查看是否返回 AI 推荐结果

### 方法 2：使用 curl 测试

在命令行中测试 API Key 是否有效：

**Windows PowerShell**：
```powershell
curl https://api.deepseek.com/v1/chat/completions `
  -H "Authorization: Bearer sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" `
  -H "Content-Type: application/json" `
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"Hello"}],"max_tokens":50}'
```

**Linux/Mac**：
```bash
curl https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"Hello"}],"max_tokens":50}'
```

**成功响应示例**：
```json
{
  "id": "chatcmpl-xxx",
  "object": "chat.completion",
  "created": 1234567890,
  "model": "deepseek-chat",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you today?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 9,
    "total_tokens": 19
  }
}
```

---

## ❓ 常见问题快速解答

### Q1: 注册时需要什么？
- 📧 邮箱或 📱 手机号
- 🔐 密码
- 💳 支付方式（用于充值）

### Q2: 最少充值多少？
- 通常 $5 起
- 建议测试充值 $5-$10

### Q3: 如何查看余额？
- 登录 https://platform.deepseek.com
- 首页显示当前余额和使用情况

### Q4: API Key 泄露了怎么办？
1. 立即登录控制台
2. 删除泄露的 API Key
3. 创建新的 API Key
4. 更新项目配置

### Q5: 国内可以访问吗？
- ✅ 可以，DeepSeek 是中国公司
- ✅ 不需要 VPN
- ✅ 访问速度快

---

## 📞 需要帮助？

### 官方资源
- 🌐 官方网站：https://www.deepseek.com/
- 📚 API 文档：https://api-docs.deepseek.com/
- 🎛️ 控制台：https://platform.deepseek.com/
- 📧 技术支持：support@deepseek.com

### 项目文档
- 📖 快速启动指南：`docs/DEEPSEEK_QUICK_START.md`
- 📊 集成状态报告：`docs/AI_INTEGRATION_STATUS.md`
- 📘 系统使用指南：`docs/BACKUP_SYSTEM_GUIDE.md`

---

## ✅ 完成检查清单

配置完成后，请确认：
- [ ] 已注册 DeepSeek 账号
- [ ] 已充值账户（余额 > $0）
- [ ] 已生成并保存 API Key
- [ ] 已配置到 `application.yml`
- [ ] 已启动应用无错误
- [ ] 已测试 AI 查询功能正常

---

**恭喜！您已成功配置 DeepSeek API Key！** 🎉

现在可以开始使用 AI 智能搜索功能了。

**更新日期**：2026-05-09  
**版本**：v1.0
