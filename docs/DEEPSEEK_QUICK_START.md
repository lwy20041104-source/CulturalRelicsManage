# DeepSeek AI 快速启动指南

## 🚀 5分钟快速配置

### 步骤1：获取 API Key（详细步骤）

#### 1.1 访问 DeepSeek 平台
打开浏览器，访问 DeepSeek API 平台：
```
https://platform.deepseek.com
```

**注意**：这是 API 管理平台，不是主网站 www.deepseek.com

#### 1.2 注册账号
- 点击右上角的 **"Sign Up"**（注册）按钮
- 可以使用以下方式注册：
  - 📧 **邮箱注册**：输入邮箱地址和密码
  - 📱 **手机号注册**：输入手机号码接收验证码
- 完成验证后，登录到控制台

#### 1.3 充值账户（必需步骤）
⚠️ **重要**：在生成 API Key 之前，必须先充值账户

1. 登录后，在左侧菜单找到 **"Top up"**（充值）或 **"Billing"**（账单）
2. 点击 **"Add credits"**（添加余额）
3. 选择充值金额（建议先充值少量测试，如 $5-$10）
4. 添加支付方式：
   - 💳 信用卡（Visa、MasterCard、American Express）
   - 💰 其他支付方式（根据地区可能有所不同）
5. 完成支付

**定价参考**：
- DeepSeek-Chat 模型：约 $0.14/1M 输入 tokens，$0.28/1M 输出 tokens
- $5 可以支持数千次查询，足够测试使用

#### 1.4 生成 API Key
1. 在左侧菜单栏，点击 **"API keys"**（API 密钥）
2. 点击 **"Create new API key"**（创建新的 API 密钥）按钮
3. 为密钥命名（例如：`cultural-relics-system` 或 `my-app-dev`）
4. 点击 **"Confirm"**（确认）

#### 1.5 保存 API Key
⚠️ **非常重要**：API Key 只会显示一次！

1. 复制显示的 API Key（格式：`sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`）
2. 立即保存到安全的地方：
   - ✅ 密码管理器（如 1Password、LastPass）
   - ✅ 本地加密文件
   - ✅ 环境变量配置文件
   - ❌ 不要保存在公开的代码仓库中
   - ❌ 不要分享给他人

3. 如果丢失 API Key，需要重新生成新的密钥

### 步骤2：配置 API Key（1分钟）

#### 2.1 打开配置文件
找到并打开文件：
```
backend/src/main/resources/application.yml
```

#### 2.2 找到 DeepSeek 配置节
在文件中搜索 `deepseek:`，找到以下配置：

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

#### 2.3 替换 API Key
将 `your-deepseek-api-key-here` 替换为您在步骤1中获取的实际 API Key：

```yaml
deepseek:
  api-key: sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx  # 粘贴你的API Key
  # 其他配置保持不变
```

#### 2.4 保存文件
- 按 `Ctrl + S`（Windows/Linux）或 `Cmd + S`（Mac）保存文件
- 确保没有语法错误（注意缩进和冒号）

### 步骤3：启动应用（1分钟）

```bash
cd backend
mvn spring-boot:run
```

### 步骤4：测试功能（1分钟）

#### 方式1：使用前端界面
1. 登录系统
2. 进入 AI 搜索页面
3. 输入问题，例如："有哪些唐朝的文物？"
4. 查看 AI 推荐结果

#### 方式2：使用 API 测试
```bash
curl -X POST http://localhost:8080/api/ai/relics/query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "question": "有哪些唐朝的青铜器？",
    "matchAll": false
  }'
```

---

## 📋 测试用例

### 测试1：基本查询
**问题**：有哪些唐朝的文物？  
**期望**：返回唐朝时期的文物列表

### 测试2：材质查询
**问题**：有哪些青铜器？  
**期望**：返回材质为青铜的文物

### 测试3：分类查询
**问题**：有哪些陶瓷类文物？  
**期望**：返回陶瓷分类的文物

### 测试4：复杂查询
**问题**：有哪些唐朝的青铜器，状态良好的？  
**期望**：返回符合多个条件的文物

### 测试5：模糊查询
**问题**：有什么值得参观的文物？  
**期望**：AI 推荐有价值的文物

---

## 🔍 验证 AI 是否工作

### 查看日志
启动应用后，在日志中查找：

```
✅ 成功标志：
INFO  - 使用 DeepSeek AI 查询文物: question=有哪些唐朝的文物？
INFO  - DeepSeek API 响应码: 200
INFO  - DeepSeek 返回内容: {...}
INFO  - DeepSeek AI 查询完成: 找到3件文物

❌ 失败标志（会自动降级）：
ERROR - DeepSeek AI 分析失败
INFO  - 使用降级方案：关键字搜索
```

### 检查响应
AI 成功时，响应包含：
- `answer`: AI 生成的专业回答
- `topReason`: 推荐理由
- `relics`: 推荐的文物列表（相关度95%）

降级时，响应包含：
- `answer`: "抱歉，AI分析服务暂时不可用..."
- `relics`: 基于关键字匹配的结果（相关度80%）

---

## ⚠️ 常见问题

### Q1: 注册时需要什么信息？
**A**: 
- 📧 邮箱地址或 📱 手机号码
- 🔐 设置密码
- 💳 支付方式（用于充值）

**注意**：DeepSeek 是付费服务，需要先充值才能使用 API

### Q2: 充值需要多少钱？
**A**: 
- **最低充值**：通常 $5 起
- **推荐测试金额**：$5-$10（足够数千次查询）
- **定价**：
  - 输入 tokens：约 $0.14 / 1M tokens
  - 输出 tokens：约 $0.28 / 1M tokens
- **估算**：每次文物查询约 $0.0003-$0.001

### Q3: 支持哪些支付方式？
**A**: 
- 💳 国际信用卡（Visa、MasterCard、American Express）
- 💰 其他支付方式（根据地区可能不同）

**提示**：如果没有国际信用卡，可以考虑：
- 使用虚拟信用卡服务
- 联系 DeepSeek 客服咨询其他支付方式

### Q4: API Key 配置后仍然失败？
**检查清单**：
- [ ] API Key 是否正确复制（没有多余空格或换行）
- [ ] 账户是否已充值（余额 > $0）
- [ ] 网络是否可以访问 `api.deepseek.com`
- [ ] API Key 是否有效（未被删除或过期）
- [ ] YAML 配置格式是否正确（注意缩进）

**测试网络连接**：
```bash
# Windows PowerShell
curl https://api.deepseek.com/v1/chat/completions `
  -H "Authorization: Bearer YOUR_API_KEY" `
  -H "Content-Type: application/json" `
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"Hello"}]}'

# Linux/Mac
curl https://api.deepseek.com/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"model":"deepseek-chat","messages":[{"role":"user","content":"Hello"}]}'
```

### Q5: 如何查看 API 使用情况和余额？
**A**: 
1. 登录 https://platform.deepseek.com
2. 在控制台首页可以看到：
   - 💰 当前余额
   - 📊 今日使用量
   - 📈 历史使用统计
3. 点击 "Usage"（使用情况）查看详细记录

### Q6: API Key 泄露了怎么办？
**A**: 
1. 立即登录 https://platform.deepseek.com
2. 进入 "API keys" 页面
3. 找到泄露的 API Key，点击 **"Delete"**（删除）
4. 创建新的 API Key
5. 更新应用配置文件中的 API Key

### Q7: 可以使用免费的 API 吗？
**A**: 
- ❌ DeepSeek API 目前没有免费额度
- ✅ 但价格非常便宜（比 OpenAI 便宜很多）
- 💡 建议先充值 $5 测试，确认效果后再增加充值

### Q8: 如何控制 API 成本？
**A**: 
1. **设置预算提醒**：在控制台设置余额预警
2. **添加缓存**：相同问题不重复调用 API
3. **优化提示词**：减少不必要的 token 消耗
4. **限制调用频率**：添加请求频率限制
5. **监控使用量**：定期查看 API 使用统计

### Q9: 国内可以访问吗？
**A**: 
- ✅ DeepSeek 是中国公司，国内可以正常访问
- ✅ 不需要 VPN 或代理
- ✅ API 响应速度快

### Q10: 如何验证 API Key 是否有效？
**A**: 
启动应用后，查看日志：

**✅ 成功标志**：
```
INFO  - 使用 DeepSeek AI 查询文物: question=...
INFO  - DeepSeek API 响应码: 200
INFO  - DeepSeek 返回内容: {...}
INFO  - DeepSeek AI 查询完成: 找到X件文物
```

**❌ 失败标志**：
```
ERROR - DeepSeek API 调用失败
ERROR - DeepSeek API 错误: {"error":{"message":"Invalid API key"}}
INFO  - 使用降级方案：关键字搜索
```

---

## 📞 获取帮助

### DeepSeek 官方资源
- 🌐 **官方网站**：https://www.deepseek.com/
- 📚 **API 文档**：https://api-docs.deepseek.com/
- 🎛️ **控制台**：https://platform.deepseek.com/
- 📧 **技术支持**：support@deepseek.com

### 常用链接
- **API 状态**：检查 DeepSeek 服务是否正常
- **定价页面**：查看最新的 API 定价
- **使用示例**：官方提供的代码示例
- **社区论坛**：与其他开发者交流

---

## 🔐 安全最佳实践

### 1. API Key 管理
- ✅ 使用环境变量存储 API Key
- ✅ 不要将 API Key 提交到 Git 仓库
- ✅ 定期轮换 API Key
- ✅ 为不同环境使用不同的 API Key

### 2. 使用环境变量（推荐）

**Windows PowerShell**：
```powershell
$env:DEEPSEEK_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

**Linux/Mac**：
```bash
export DEEPSEEK_API_KEY="sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

**application.yml**：
```yaml
deepseek:
  api-key: ${DEEPSEEK_API_KEY}  # 从环境变量读取
```

### 3. .gitignore 配置
确保 `.gitignore` 包含：
```
# 配置文件
application.yml
application-*.yml

# 环境变量
.env
.env.local

# API Keys
**/api-keys.txt
```

### 4. 生产环境配置
- 使用配置中心（如 Spring Cloud Config）
- 使用密钥管理服务（如 AWS Secrets Manager）
- 限制 API Key 的访问权限
- 启用 API 调用监控和告警

---

## 📊 成本优化建议

### 1. 实施缓存策略
```java
@Cacheable(value = "aiQueryCache", key = "#question", unless = "#result == null")
public AiRelicQueryResponse queryRelics(String question, Boolean matchAll) {
    // AI 查询逻辑
}
```

### 2. 设置请求限流
```java
@RateLimiter(name = "aiQuery", fallbackMethod = "queryRelicsFallback")
public AiRelicQueryResponse queryRelics(String question, Boolean matchAll) {
    // AI 查询逻辑
}
```

### 3. 优化 Token 使用
- 减少发送的文物数量（当前限制100件）
- 压缩文物描述长度（当前限制100字）
- 使用更精简的提示词
- 降低 `max-tokens` 参数

### 4. 监控和告警
```java
// 记录每次调用的成本
double cost = (inputTokens * 0.14 + outputTokens * 0.28) / 1000000;
log.info("API 调用成本: ${}", String.format("%.6f", cost));

// 累计成本超过阈值时告警
if (totalCost > COST_THRESHOLD) {
    sendAlert("DeepSeek API 成本超过阈值");
}
```

---

## ✅ 配置完成检查清单

部署前请确认：
- [ ] 已注册 DeepSeek 账号
- [ ] 已充值账户（余额 > $0）
- [ ] 已生成 API Key
- [ ] 已将 API Key 配置到 `application.yml`
- [ ] 已保存 API Key 到安全位置
- [ ] 已测试网络连接到 `api.deepseek.com`
- [ ] 已启动应用并查看日志
- [ ] 已测试 AI 查询功能
- [ ] 已设置预算提醒
- [ ] 已配置 `.gitignore` 防止泄露

---

**祝您使用愉快！如有问题，请参考上述常见问题或联系技术支持。** 🎉

---

## 📊 监控建议

### 1. 记录 API 调用
```java
// 在 DeepSeekServiceImpl 中添加
log.info("DeepSeek API 调用统计: 输入tokens={}, 输出tokens={}, 耗时={}ms", 
    inputTokens, outputTokens, duration);
```

### 2. 统计成功率
```java
// 记录成功和失败次数
successCount++;
failureCount++;
log.info("DeepSeek API 成功率: {}%", (successCount * 100.0 / (successCount + failureCount)));
```

### 3. 成本追踪
```java
// 计算成本
double cost = (inputTokens * 0.14 + outputTokens * 0.28) / 1000000;
log.info("本次查询成本: ${}", String.format("%.6f", cost));
```

---

## 🎯 性能基准

### 预期性能指标
- **响应时间**: 2-5秒（取决于网络和文物数量）
- **成功率**: >95%（配置正确时）
- **准确率**: >90%（AI推荐相关性）
- **成本**: $0.0003-$0.001 每次查询

### 压力测试
```bash
# 测试100次查询
for i in {1..100}; do
  curl -X POST http://localhost:8080/api/ai/relics/query \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer YOUR_JWT_TOKEN" \
    -d '{"question": "有哪些唐朝的文物？", "matchAll": false}'
  sleep 1
done
```

---

## 📚 进阶配置

### 调整模型参数

#### Temperature（温度）
```yaml
temperature: 0.5  # 更确定性，推荐更准确
temperature: 0.7  # 默认值，平衡
temperature: 1.0  # 更随机，推荐更多样
```

#### Max Tokens（最大输出）
```yaml
max-tokens: 1000  # 简短回答
max-tokens: 2000  # 默认值
max-tokens: 4000  # 详细回答
```

#### Timeout（超时时间）
```yaml
connect-timeout: 5000   # 5秒连接超时
read-timeout: 20000     # 20秒读取超时
```

### 使用环境变量（推荐）

**Linux/Mac**:
```bash
export DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Windows**:
```cmd
set DEEPSEEK_API_KEY=sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**application.yml**:
```yaml
deepseek:
  api-key: ${DEEPSEEK_API_KEY}
```

---

## ✅ 验收清单

部署前检查：
- [ ] API Key 已配置且有效
- [ ] 网络可以访问 DeepSeek API
- [ ] 应用启动无错误
- [ ] 测试查询返回正确结果
- [ ] 日志显示 AI 调用成功
- [ ] 降级策略工作正常
- [ ] 响应时间在可接受范围
- [ ] 前端界面显示正常

---

## 🆘 获取帮助

### 查看日志
```bash
# 实时查看日志
tail -f logs/spring.log

# 搜索错误
grep "ERROR" logs/spring.log

# 搜索 DeepSeek 相关日志
grep "DeepSeek" logs/spring.log
```

### 联系支持
- **DeepSeek 官方文档**: https://platform.deepseek.com/docs
- **API 状态页面**: https://status.deepseek.com/
- **技术支持**: support@deepseek.com

---

**更新日期**: 2026-05-09  
**版本**: v1.0
