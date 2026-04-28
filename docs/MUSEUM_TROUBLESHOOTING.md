# 博物馆管理功能故障排查指南

## 问题：前台登录时显示"加载博物馆列表失败"

### 原因分析
1. ✅ **已修复**：Spring Security配置未放行 `/museums/active` 接口（403 Forbidden）
2. ⚠️ **待检查**：数据库表未创建
3. ⚠️ **待检查**：后端服务未重启

---

## 解决步骤

### 步骤1：执行数据库初始化脚本

打开MySQL客户端或命令行，执行以下命令：

```bash
# 方式1：使用命令行
mysql -u root -p cultural_relics < backend/sql/museum_tables.sql

# 方式2：在MySQL客户端中执行
USE cultural_relics;
SOURCE backend/sql/museum_tables.sql;
```

**验证表是否创建成功：**
```sql
-- 检查表是否存在
SHOW TABLES LIKE 'museum';
SHOW TABLES LIKE 'user_museum';

-- 检查博物馆数据
SELECT COUNT(*) FROM museum;
SELECT museum_code, museum_name, city, status FROM museum;
```

**预期结果：**
- museum表应该有10条记录
- user_museum表应该有2条记录（loaner和visitor01的关联）

---

### 步骤2：重启后端服务

**方式1：如果使用IDE（IntelliJ IDEA / Eclipse）**
1. 停止当前运行的Spring Boot应用
2. 重新运行 `CulturalRelicsApplication` 主类

**方式2：如果使用Maven命令行**
```bash
cd backend

# 停止当前服务（Ctrl+C）

# 重新启动
mvn spring-boot:run
```

**方式3：如果使用jar包**
```bash
cd backend

# 停止当前服务（Ctrl+C）

# 重新编译和运行
mvn clean package
java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
```

---

### 步骤3：验证接口是否正常

**测试1：直接访问博物馆接口**

在浏览器中访问：
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
      "museumType": "综合类",
      "province": "北京市",
      "city": "北京市",
      "address": "天安门广场东侧",
      "contactPerson": "张馆长",
      "contactPhone": "010-12345678",
      "contactEmail": "contact@nationalmuseum.cn",
      "description": "中国国家博物馆是世界上单体建筑面积最大的博物馆",
      "status": 1
    },
    // ... 其他9个博物馆
  ]
}
```

**测试2：检查前端控制台**

1. 打开前台登录页面：`http://localhost:5173/portal-login`
2. 打开浏览器开发者工具（F12）
3. 查看Console标签页，应该没有403错误
4. 查看Network标签页，`museums/active` 请求应该返回200状态码

---

## 常见问题

### Q1: 数据库连接失败
**错误信息：** `Communications link failure` 或 `Access denied`

**解决方案：**
1. 检查MySQL服务是否启动
2. 检查 `backend/src/main/resources/application.yml` 中的数据库配置：
   ```yaml
   spring:
     datasource:
       url: jdbc:mysql://localhost:3306/cultural_relics?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
       username: root
       password: your_password  # 修改为你的密码
   ```

### Q2: 表已存在错误
**错误信息：** `Table 'museum' already exists`

**解决方案：**
这不是错误，SQL脚本使用了 `CREATE TABLE IF NOT EXISTS`，可以安全忽略。

### Q3: 外键约束错误
**错误信息：** `Cannot add foreign key constraint`

**解决方案：**
确保 `sys_user` 表已存在。如果不存在，先执行主数据库初始化脚本：
```bash
mysql -u root -p cultural_relics < backend/sql/db.sql
```

### Q4: 前端仍然显示403错误
**可能原因：**
1. 后端服务未重启
2. 浏览器缓存了旧的响应

**解决方案：**
1. 确认后端服务已重启
2. 清除浏览器缓存（Ctrl+Shift+Delete）
3. 硬刷新页面（Ctrl+F5）

### Q5: 博物馆列表为空
**可能原因：**
1. 数据未插入
2. status字段不为1

**解决方案：**
```sql
-- 检查数据
SELECT * FROM museum WHERE status = 1;

-- 如果数据不存在，重新插入
-- 复制 museum_tables.sql 中的 INSERT 语句执行
```

---

## 完整测试流程

### 1. 数据库测试
```sql
-- 连接数据库
USE cultural_relics;

-- 检查表结构
DESC museum;
DESC user_museum;

-- 检查数据
SELECT COUNT(*) as museum_count FROM museum;
SELECT COUNT(*) as user_museum_count FROM user_museum;

-- 查看所有博物馆
SELECT id, museum_code, museum_name, city, status FROM museum ORDER BY id;

-- 查看用户博物馆关联
SELECT 
    u.username, 
    u.real_name, 
    m.museum_name, 
    um.is_primary
FROM user_museum um
JOIN sys_user u ON um.user_id = u.id
JOIN museum m ON um.museum_id = m.id;
```

### 2. 后端测试
```bash
# 检查后端日志，确认没有错误
# 查看启动日志中是否有 MuseumMapper 相关的Bean创建信息
```

### 3. 前端测试
1. 访问前台登录页面：`http://localhost:5173/portal-login`
2. 检查博物馆下拉框是否显示10个博物馆
3. 尝试选择一个博物馆
4. 输入用户名密码登录测试

---

## 修改记录

### 2024-XX-XX
- ✅ 修改 `SecurityConfig.java`，添加 `/museums/active` 接口的匿名访问权限
- ✅ 创建故障排查文档

### 待完成
- ⚠️ 执行数据库初始化脚本
- ⚠️ 重启后端服务
- ⚠️ 测试前台登录功能

---

## 联系支持

如果按照以上步骤仍然无法解决问题，请提供以下信息：

1. 数据库查询结果截图
2. 后端启动日志
3. 浏览器控制台错误信息
4. Network标签页的请求详情

