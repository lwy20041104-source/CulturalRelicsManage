# 备份系统部署指南

## 当前状态

✅ 代码已修复并编译成功  
⏳ 需要执行以下步骤完成部署

## 部署步骤

### 步骤1：执行数据库脚本

在MySQL中执行备份系统的表创建脚本：

```bash
# 方式1：使用命令行
mysql -u root -p cultural_relics < backend/sql/backup_system.sql

# 方式2：使用MySQL客户端
# 1. 打开MySQL Workbench或其他客户端
# 2. 连接到cultural_relics数据库
# 3. 打开并执行 backend/sql/backup_system.sql
```

**创建的表**：
- `sys_backup` - 备份记录表
- `sys_backup_config` - 备份配置表
- `sys_restore` - 恢复记录表

**验证表是否创建成功**：
```sql
USE cultural_relics;
SHOW TABLES LIKE 'sys_%';

-- 应该看到：
-- sys_backup
-- sys_backup_config
-- sys_restore
```

### 步骤2：重启后端服务

**如果后端正在运行**：
1. 在运行后端的终端按 `Ctrl+C` 停止服务
2. 重新启动：
```bash
cd backend
mvn spring-boot:run
```

**如果后端未运行**：
```bash
cd backend
mvn spring-boot:run
```

**验证后端启动成功**：
查看控制台输出，应该看到：
```
Started CulturalRelicsManageApplication in X.XXX seconds
```

### 步骤3：测试备份接口

**使用curl测试**：
```bash
# 测试获取备份列表（需要先登录获取token）
curl http://localhost:8080/api/backup?pageNum=1&pageSize=10 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**使用浏览器测试**：
1. 登录系统
2. 访问"数据备份"菜单
3. 应该能看到空的备份列表（没有404错误）

### 步骤4：创建第一个备份

1. 点击"创建备份"按钮
2. 填写信息：
   - 备份名称：`测试备份`
   - 描述：`第一次手动备份`
   - 是否加密：否（先测试不加密）
3. 点击"确定"
4. 等待几秒后刷新页面
5. 应该看到备份状态变为"成功"

### 步骤5：验证备份文件

**检查备份目录**：
```bash
# 在项目根目录
ls -la backups/

# 应该看到类似的文件：
# backup_20260427_213000.sql
```

**检查文件内容**：
```bash
# 查看文件前几行
head -n 20 backups/backup_*.sql

# 应该看到SQL语句
```

## 常见问题排查

### 问题1：数据库脚本执行失败

**错误信息**：`Table 'sys_backup' already exists`

**解决方法**：
```sql
-- 删除已存在的表（注意：会丢失数据）
DROP TABLE IF EXISTS sys_restore;
DROP TABLE IF EXISTS sys_backup_config;
DROP TABLE IF EXISTS sys_backup;

-- 重新执行脚本
SOURCE backend/sql/backup_system.sql;
```

### 问题2：后端启动后仍然404

**可能原因**：
1. 后端没有重启
2. 编译的class文件没有更新

**解决方法**：
```bash
# 清理并重新编译
cd backend
mvn clean compile

# 重启服务
mvn spring-boot:run
```

### 问题3：备份一直处于"处理中"

**可能原因**：
1. mysqldump命令不可用
2. 数据库权限不足
3. 磁盘空间不足

**解决方法**：

**检查mysqldump**：
```bash
# Windows
where mysqldump

# Linux/Mac
which mysqldump

# 测试命令
mysqldump --version
```

**检查数据库权限**：
```sql
-- 查看当前用户权限
SHOW GRANTS FOR 'root'@'localhost';

-- 如果权限不足，授予权限
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, RELOAD, LOCK TABLES 
ON *.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

**检查磁盘空间**：
```bash
# Windows
dir

# Linux/Mac
df -h
```

**查看后端日志**：
```bash
# 在后端运行的终端查看错误信息
# 或查看日志文件
tail -f backend/logs/spring.log
```

### 问题4：前端显示"加载备份列表失败"

**检查步骤**：

1. **检查后端是否运行**：
```bash
# 访问健康检查接口
curl http://localhost:8080/api/auth/login
```

2. **检查接口路径**：
```bash
# 测试备份接口
curl http://localhost:8080/api/backup?pageNum=1&pageSize=10
```

3. **检查浏览器控制台**：
   - 打开浏览器开发者工具（F12）
   - 查看Network标签
   - 查看请求的URL和响应

4. **检查认证token**：
   - 确保已登录
   - 检查token是否过期
   - 重新登录试试

### 问题5：创建备份失败

**查看错误信息**：
1. 在备份列表中查看"错误信息"列
2. 查看后端日志

**常见错误**：

**错误1**：`mysqldump: command not found`
```bash
# 解决：安装MySQL客户端或配置PATH
# Windows: 添加MySQL bin目录到PATH
# Linux: sudo apt-get install mysql-client
# Mac: brew install mysql-client
```

**错误2**：`Access denied for user`
```sql
-- 解决：检查数据库用户权限
GRANT ALL PRIVILEGES ON cultural_relics.* TO 'root'@'localhost';
FLUSH PRIVILEGES;
```

**错误3**：`No space left on device`
```bash
# 解决：清理磁盘空间或更改备份目录
```

## 验证清单

完成部署后，请验证以下功能：

- [ ] 数据库表创建成功
- [ ] 后端服务启动成功
- [ ] 前端可以访问备份页面（无404错误）
- [ ] 可以查看备份列表（空列表也算成功）
- [ ] 可以创建手动备份
- [ ] 备份状态变为"成功"
- [ ] 可以看到备份文件
- [ ] 可以下载备份文件
- [ ] 可以打开备份配置对话框
- [ ] 中英文切换正常

## 接口测试

### 1. 获取备份列表
```bash
curl -X GET "http://localhost:8080/api/backup?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 2. 创建备份
```bash
curl -X POST "http://localhost:8080/api/backup" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{
    "backupName": "测试备份",
    "description": "API测试",
    "isEncrypted": false
  }'
```

### 3. 获取备份配置
```bash
curl -X GET "http://localhost:8080/api/backup/config" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 性能测试

### 小型数据库（< 100MB）
- 备份时间：10-30秒
- 恢复时间：15-40秒

### 中型数据库（100MB - 1GB）
- 备份时间：1-5分钟
- 恢复时间：2-8分钟

## 安全建议

### 生产环境配置

1. **修改加密密钥**：
```java
// 在BackupService.java中修改
private static final String AES_KEY = "YOUR_SECURE_KEY_32_CHARACTERS!!";
```

2. **配置备份目录权限**：
```bash
# Linux/Mac
chmod 700 backups/
chown app_user:app_group backups/

# Windows
# 使用文件属性设置权限
```

3. **启用备份文件加密**：
   - 在备份配置中启用加密
   - 定期轮换加密密钥

4. **配置自动备份**：
   - 设置每天凌晨2点自动备份
   - 保留最近30天的备份
   - 启用通知功能

## 下一步

部署完成后，建议：

1. **配置自动备份**：
   - 进入"备份配置"
   - 设置备份频率和时间
   - 启用自动备份

2. **测试恢复功能**：
   - 在测试环境测试恢复
   - 验证数据完整性
   - 记录恢复时间

3. **监控备份状态**：
   - 定期检查备份是否成功
   - 监控磁盘空间使用
   - 设置告警通知

4. **制定备份策略**：
   - 每日自动备份
   - 每周长期备份
   - 重要操作前手动备份

## 相关文档

- [实现文档](BACKUP_SYSTEM_IMPLEMENTATION.md)
- [快速开始](BACKUP_QUICK_START.md)
- [404错误修复](BACKUP_404_FIX.md)

## 支持

如遇问题，请：
1. 查看后端日志
2. 查看浏览器控制台
3. 参考故障排查部分
4. 查看相关文档

---

更新时间：2026-04-27 21:30:00
状态：✅ 准备就绪
下一步：执行数据库脚本并重启后端
