# 博物馆管理功能快速启动指南

## 🎯 目标
修复前台登录页面"加载博物馆列表失败"的问题

## ✅ 已完成
- [x] 创建博物馆相关的后端代码（Entity、Mapper、Service、Controller）
- [x] 创建前端API接口（museums.js）
- [x] 修改前台登录页面，添加博物馆选择框
- [x] 修改用户管理页面，支持博物馆分配
- [x] **修复SecurityConfig，允许匿名访问博物馆列表接口**

## 📋 待完成步骤

### 步骤1：初始化数据库表（必须）⭐

打开命令行，执行以下命令：

```bash
# Windows系统
mysql -u root -p
# 输入密码：1234

# 然后执行
USE cultural_relics;
SOURCE backend/sql/museum_tables.sql;

# 或者直接一行命令
mysql -u root -p1234 cultural_relics < backend/sql/museum_tables.sql
```

**验证是否成功：**
```sql
USE cultural_relics;
SELECT COUNT(*) FROM museum;  -- 应该返回10
SELECT museum_name, city FROM museum LIMIT 5;
```

---

### 步骤2：重启后端服务（必须）⭐

**如果使用IDE（推荐）：**
1. 在IntelliJ IDEA或Eclipse中停止当前运行的应用
2. 找到 `CulturalRelicsApplication.java` 文件
3. 右键 -> Run 'CulturalRelicsApplication'

**如果使用命令行：**
```bash
cd backend

# 停止当前服务（按Ctrl+C）

# 重新启动
mvn spring-boot:run
```

**确认启动成功：**
- 查看控制台输出，应该看到：
  ```
  Started CulturalRelicsApplication in X.XXX seconds
  ```
- 没有红色的ERROR日志

---

### 步骤3：测试接口（验证）

**方法1：浏览器直接访问**

打开浏览器，访问：
```
http://localhost:8080/api/museums/active
```

**预期结果：**
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "museumCode": "MUS001",
      "museumName": "国家博物馆",
      "city": "北京市",
      ...
    },
    ...
  ]
}
```

**方法2：使用curl命令**
```bash
curl http://localhost:8080/api/museums/active
```

---

### 步骤4：测试前台登录页面

1. 确保前端服务正在运行：
   ```bash
   cd frontend
   npm run dev
   ```

2. 打开浏览器访问：
   ```
   http://localhost:5173/portal-login
   ```

3. 检查博物馆下拉框：
   - 应该显示10个博物馆选项
   - 每个选项显示博物馆名称和城市
   - 可以搜索过滤

4. 测试登录：
   - 用户名：`loaner`
   - 密码：`123456`
   - 选择博物馆：`国家博物馆`
   - 点击"立即登录"

---

## 🔍 故障排查

### 问题1：数据库连接失败

**错误信息：**
```
Communications link failure
```

**解决方案：**
1. 检查MySQL服务是否启动
2. 检查密码是否正确（当前配置：root/1234）
3. 修改 `backend/src/main/resources/application.yml` 中的密码

---

### 问题2：表不存在

**错误信息：**
```
Table 'cultural_relics.museum' doesn't exist
```

**解决方案：**
重新执行步骤1的数据库初始化脚本

---

### 问题3：仍然显示403错误

**可能原因：**
- 后端服务未重启
- 浏览器缓存

**解决方案：**
1. 确认后端服务已重启（查看启动时间）
2. 清除浏览器缓存（Ctrl+Shift+Delete）
3. 硬刷新页面（Ctrl+F5）

---

### 问题4：博物馆列表为空

**检查步骤：**
```sql
-- 1. 检查数据是否存在
SELECT * FROM museum;

-- 2. 检查status字段
SELECT * FROM museum WHERE status = 1;

-- 3. 如果没有数据，重新插入
-- 复制 museum_tables.sql 中的 INSERT 语句执行
```

---

## 📝 完整测试清单

- [ ] 数据库表已创建（museum、user_museum）
- [ ] 数据库有10条博物馆记录
- [ ] 后端服务已重启
- [ ] 访问 `/api/museums/active` 返回200状态码
- [ ] 前台登录页面显示博物馆下拉框
- [ ] 博物馆下拉框有10个选项
- [ ] 可以搜索过滤博物馆
- [ ] 选择博物馆后可以正常登录

---

## 🎉 成功标志

当你看到以下情况时，说明功能已正常工作：

1. ✅ 前台登录页面加载时，博物馆下拉框自动填充10个博物馆
2. ✅ 浏览器控制台没有403或其他错误
3. ✅ 可以选择博物馆并成功登录
4. ✅ 后台用户管理页面，新增借展人时显示博物馆选择框

---

## 📞 需要帮助？

如果遇到问题，请提供：
1. 数据库查询结果截图
2. 后端控制台日志
3. 浏览器控制台错误信息
4. Network标签页的请求详情

---

## 🔗 相关文档

- [博物馆功能实现文档](./MUSEUM_FEATURE.md)
- [故障排查指南](./MUSEUM_TROUBLESHOOTING.md)
- [项目分析报告](./PROJECT_ANALYSIS.md)

