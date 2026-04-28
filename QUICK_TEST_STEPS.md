# 快速测试步骤 - 新增文物错误处理修复

## 问题回顾
- **现象**: 前端显示"保存成功"，但数据库中没有数据
- **原因**: 前端未检查 `response.code === 200`，即使后端返回错误也显示成功

## 已修复内容
✅ 前端 `RelicsView.vue` - 添加响应码检查  
✅ 后端 `FileStorageUtil.java` - 修复上传目录创建  
✅ 创建测试页面和文档

## 测试步骤

### 方法1: 使用测试页面（推荐）
1. 启动后端服务（确保运行在 http://localhost:8080）
2. 在浏览器中打开 `test-add-relic-with-error-check.html`
3. 按顺序执行三个测试：
   - 测试1: 带图片新增（选择图片后提交）
   - 测试2: 不带图片新增（直接提交）
   - 测试3: 错误处理（点击按钮触发）
4. 观察日志区域的输出和状态标记

### 方法2: 使用前端应用
1. 启动后端服务
2. 启动前端应用
3. 登录系统
4. 进入"文物管理"页面
5. 点击"新增文物"按钮
6. 填写表单并上传图片
7. 点击"确认"

**预期结果（成功）:**
- ✅ 显示"保存成功"消息
- ✅ 对话框自动关闭
- ✅ 列表自动刷新，显示新增的文物
- ✅ 数据库中有对应记录
- ✅ 图片文件保存在 `uploads/` 目录

**预期结果（失败）:**
- ❌ 显示具体错误消息（如"数据库连接失败"）
- ❌ 对话框保持打开状态
- ❌ 列表不刷新
- ❌ 可以修改数据后重新提交

### 方法3: 模拟错误测试
1. 停止数据库服务
2. 尝试新增文物
3. **预期**: 前端显示错误消息，不显示"保存成功"

## 验证要点

### ✅ 成功场景
- [ ] 前端显示"保存成功"
- [ ] 对话框关闭
- [ ] 列表刷新
- [ ] 数据库有记录
- [ ] 图片文件存在

### ❌ 失败场景
- [ ] 前端显示错误消息（不是"保存成功"）
- [ ] 对话框保持打开
- [ ] 列表不刷新
- [ ] 数据库无记录
- [ ] 可以重新提交

## 检查点

### 后端检查
```bash
# 检查 uploads 目录是否创建
ls -la uploads/

# 检查数据库记录
mysql -u root -p
use cultural_relics;
SELECT * FROM cultural_relic ORDER BY id DESC LIMIT 5;
SELECT * FROM image_library ORDER BY id DESC LIMIT 5;
SELECT * FROM relic_image_relation ORDER BY id DESC LIMIT 5;
```

### 前端检查
打开浏览器开发者工具（F12）：
1. **Console 标签**: 查看日志输出
   - 应该看到 "新增文物 - 有图片: true/false"
   - 应该看到 "响应: {code: 200, ...}" 或错误信息
2. **Network 标签**: 查看请求响应
   - 找到 `/relics/with-image` 或 `/relics` 请求
   - 查看 Response 内容，确认 `code` 字段值

## 常见问题

### Q1: 前端仍然显示"保存成功"但数据库没有数据
**A**: 检查前端代码是否已更新，确保有 `if (response.code === 200)` 检查

### Q2: 后端报错 "FileNotFoundException"
**A**: 检查 `FileStorageUtil.java` 是否已更新，确保使用绝对路径

### Q3: 图片上传失败
**A**: 
- 检查 `uploads/` 目录是否存在且有写权限
- 检查图片大小是否超过 5MB
- 检查图片格式是否支持

### Q4: 数据库连接失败
**A**: 
- 检查 MySQL 服务是否运行
- 检查 `application.yml` 中的数据库配置
- 检查数据库用户名密码是否正确

## 相关文件

### 修改的文件
- `frontend/src/views/RelicsView.vue` - 添加响应码检查
- `backend/src/main/java/com/example/utils/FileStorageUtil.java` - 修复路径问题

### 测试文件
- `test-add-relic-with-error-check.html` - 独立测试页面

### 文档文件
- `docs/FIX_ADD_RELIC_ERROR_HANDLING.md` - 详细修复说明
- `CHANGELOG.md` - 更新日志

## 下一步

如果测试通过：
1. ✅ 提交代码到版本控制
2. ✅ 部署到测试环境
3. ✅ 通知团队成员

如果测试失败：
1. ❌ 查看控制台错误日志
2. ❌ 检查网络请求响应
3. ❌ 参考 `docs/FIX_ADD_RELIC_ERROR_HANDLING.md` 排查问题
