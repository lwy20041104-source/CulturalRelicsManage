# 备份功能故障排查指南

## 快速诊断

### 步骤1: 检查后端日志

创建备份后，立即查看后端控制台或日志文件，寻找以下关键信息：

**成功的日志示例：**
```
INFO  开始执行备份: backup_20260509_143022.sql
INFO  备份文件路径: backups\backup_20260509_143022.sql
INFO  数据库名: cultural_relics
INFO  执行命令 (Windows): mysqldump -uroot -p**** --databases cultural_relics ...
INFO  命令执行完成，退出码: 0
INFO  备份成功: backup_20260509_143022.sql, 文件大小: 1234567 bytes
```

**失败的日志示例：**
```
ERROR 备份失败: 备份文件未创建或文件大小为0
ERROR 错误信息: mysqldump: command not found
```

### 步骤2: 手动测试 mysqldump 命令

在服务器上打开命令行，手动执行备份命令：

**Windows:**
```cmd
cd /d D:\projects\cultural-relics-backend
mysqldump -uroot -pYourPassword --databases cultural_relics --result-file=test_backup.sql
```

**Linux:**
```bash
cd /path/to/project
mysqldump -uroot -pYourPassword --databases cultural_relics --result-file=test_backup.sql
```

**预期结果：**
- 命令执行成功，没有错误信息
- 在当前目录生成 `test_backup.sql` 文件
- 文件大小大于 0

### 步骤3: 检查文件系统

1. 检查 `backups` 目录是否存在
2. 检查目录权限（是否可写）
3. 检查是否有备份文件生成
4. 检查文件大小

**Windows:**
```cmd
dir backups
```

**Linux:**
```bash
ls -lh backups/
```

## 常见问题及解决方案

### 问题1: mysqldump 命令未找到

**症状：**
- 后端日志显示：`mysqldump: command not found` 或 `'mysqldump' 不是内部或外部命令`
- 备份状态一直是"处理中"
- 文件大小为 0B

**解决方案：**

#### Windows 系统：

1. **检查 MySQL 是否已安装：**
   ```cmd
   mysql --version
   ```

2. **找到 MySQL 安装目录：**
   - 通常在：`C:\Program Files\MySQL\MySQL Server 8.0\bin`
   - 或 XAMPP：`C:\xampp\mysql\bin`
   - 或 WAMP：`C:\wamp64\bin\mysql\mysql8.0.x\bin`

3. **添加到系统 PATH：**
   - 右键"此电脑" → "属性" → "高级系统设置"
   - 点击"环境变量"
   - 在"系统变量"中找到"Path"，点击"编辑"
   - 点击"新建"，添加 MySQL 的 bin 目录路径
   - 点击"确定"保存

4. **验证：**
   ```cmd
   mysqldump --version
   ```

5. **重启后端服务**

#### Linux 系统：

1. **安装 MySQL 客户端：**
   ```bash
   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install mysql-client
   
   # CentOS/RHEL
   sudo yum install mysql
   
   # 或安装完整的 MySQL
   sudo apt-get install mysql-server
   ```

2. **验证：**
   ```bash
   mysqldump --version
   ```

3. **重启后端服务**

### 问题2: 数据库连接失败

**症状：**
- 后端日志显示：`Access denied for user 'root'@'localhost'`
- 备份状态变为"失败"
- 错误信息中包含 "1045" 错误码

**解决方案：**

1. **检查数据库配置：**
   打开 `application.properties` 或 `application.yml`：
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/cultural_relics?...
   spring.datasource.username=root
   spring.datasource.password=YourPassword
   ```

2. **测试数据库连接：**
   ```bash
   mysql -uroot -pYourPassword -e "SHOW DATABASES;"
   ```

3. **检查用户权限：**
   ```sql
   -- 登录 MySQL
   mysql -uroot -p
   
   -- 查看权限
   SHOW GRANTS FOR 'root'@'localhost';
   
   -- 如果权限不足，授予权限
   GRANT ALL PRIVILEGES ON cultural_relics.* TO 'root'@'localhost';
   FLUSH PRIVILEGES;
   ```

### 问题3: 密码包含特殊字符

**症状：**
- 命令执行失败
- 错误信息显示语法错误

**解决方案：**

**方法1: 使用配置文件（推荐）**

1. 创建 MySQL 配置文件 `.my.cnf`（Linux）或 `my.ini`（Windows）：
   ```ini
   [client]
   user=root
   password=Your@Complex#Password!
   ```

2. 修改备份命令，使用配置文件：
   ```bash
   mysqldump --defaults-file=/path/to/.my.cnf --databases cultural_relics --result-file=backup.sql
   ```

**方法2: 转义特殊字符**

在代码中对密码进行转义处理。

**方法3: 使用环境变量**

```bash
export MYSQL_PWD='Your@Complex#Password!'
mysqldump -uroot --databases cultural_relics --result-file=backup.sql
```

### 问题4: 权限不足，无法创建备份目录

**症状：**
- 后端日志显示：`Permission denied` 或 `拒绝访问`
- 备份目录未创建

**解决方案：**

**Windows:**
```cmd
# 检查目录权限
icacls backups

# 授予完全控制权限
icacls backups /grant Users:F
```

**Linux:**
```bash
# 检查目录权限
ls -ld backups

# 修改权限
chmod 755 backups

# 或修改所有者
sudo chown -R your_user:your_group backups
```

### 问题5: 磁盘空间不足

**症状：**
- 备份文件大小为 0
- 后端日志显示：`No space left on device`

**解决方案：**

1. **检查磁盘空间：**
   ```bash
   # Windows
   dir
   
   # Linux
   df -h
   ```

2. **清理旧备份：**
   - 在备份管理界面点击"清理过期备份"
   - 或手动删除 `backups` 目录下的旧文件

3. **扩展磁盘空间**

### 问题6: 数据库太大，备份超时

**症状：**
- 备份一直处于"处理中"状态
- 长时间没有完成

**解决方案：**

1. **增加超时时间：**
   修改 mysqldump 命令，添加超时参数：
   ```bash
   mysqldump --max_allowed_packet=512M --net_buffer_length=16384 ...
   ```

2. **分表备份：**
   不备份整个数据库，只备份重要的表。

3. **使用压缩：**
   ```bash
   mysqldump ... | gzip > backup.sql.gz
   ```

### 问题7: Windows 路径包含空格或中文

**症状：**
- 命令执行失败
- 文件路径错误

**解决方案：**

确保文件路径用引号包裹：
```java
String command = String.format(
    "mysqldump -u%s -p%s --databases %s --result-file=\"%s\"",
    dbUsername, dbPassword, dbName, filePath
);
```

## 调试技巧

### 1. 启用详细日志

在 `application.properties` 中添加：
```properties
logging.level.com.example.service.BackupService=DEBUG
```

### 2. 手动执行备份命令

从后端日志中复制完整的 mysqldump 命令（替换 **** 为实际密码），在命令行中手动执行，查看详细错误信息。

### 3. 检查进程

**Windows:**
```cmd
tasklist | findstr mysqldump
```

**Linux:**
```bash
ps aux | grep mysqldump
```

### 4. 查看 MySQL 错误日志

**Windows:**
```
C:\ProgramData\MySQL\MySQL Server 8.0\Data\*.err
```

**Linux:**
```bash
sudo tail -f /var/log/mysql/error.log
```

## 测试清单

创建备份后，按以下清单逐项检查：

- [ ] 后端日志显示"开始执行备份"
- [ ] 后端日志显示正确的数据库名
- [ ] 后端日志显示正确的文件路径
- [ ] 后端日志显示"命令执行完成，退出码: 0"
- [ ] 后端日志显示"备份成功"和文件大小
- [ ] 后端日志显示"备份记录已更新: status=success"
- [ ] 数据库中备份记录的 `backup_status` 为 'success'
- [ ] 数据库中备份记录的 `file_size` 大于 0
- [ ] `backups` 目录下存在备份文件
- [ ] 备份文件大小与数据库记录一致
- [ ] 备份文件可以用文本编辑器打开（如果未加密）
- [ ] 备份文件包含正确的 SQL 语句

## 联系支持

如果以上方法都无法解决问题，请提供以下信息：

1. 操作系统版本
2. MySQL 版本
3. Java 版本
4. 完整的后端日志（从"开始执行备份"到"备份记录已更新"）
5. 手动执行 mysqldump 命令的结果
6. `backups` 目录的权限信息
7. 磁盘空间信息

---

**文档版本**: 1.0  
**最后更新**: 2026-05-09
