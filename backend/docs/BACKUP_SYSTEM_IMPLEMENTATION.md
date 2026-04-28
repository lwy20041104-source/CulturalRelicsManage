# 数据备份恢复系统实现文档

## 概述
本文档记录了文物管理系统的数据备份恢复功能的完整实现过程。

## 实现状态
✅ **已完成** - 所有功能已实现并通过编译验证

## 功能特性

### 1. 备份管理
- ✅ 手动备份创建
- ✅ 自动备份（通过配置定时任务）
- ✅ 备份列表查询（分页）
- ✅ 备份文件下载
- ✅ 备份文件删除
- ✅ 备份文件加密（AES加密）
- ✅ 过期备份自动清理

### 2. 恢复管理
- ✅ 数据库一键恢复
- ✅ 恢复记录追踪
- ✅ 加密备份自动解密

### 3. 配置管理
- ✅ 备份策略配置
- ✅ 备份频率设置（每日/每周/每月）
- ✅ 备份时间设置
- ✅ 保留天数设置
- ✅ 最大备份数量限制
- ✅ 加密选项
- ✅ 通知开关

## 技术架构

### 后端实现

#### 1. 数据库表结构
```sql
-- 备份记录表
sys_backup (
  id, backup_name, backup_type, backup_status, file_name, 
  file_path, file_size, is_encrypted, description, 
  error_message, created_by, created_time
)

-- 备份配置表
sys_backup_config (
  id, config_name, is_enabled, backup_frequency, backup_time,
  retention_days, max_backup_count, is_encrypted, 
  notification_enabled, created_time, updated_time
)

-- 恢复记录表
sys_restore (
  id, backup_id, restore_status, restore_type, error_message,
  created_by, created_time, completed_time
)
```

#### 2. 核心类文件

**实体类**
- `SysBackup.java` - 备份记录实体
- `SysBackupConfig.java` - 备份配置实体
- `SysRestore.java` - 恢复记录实体

**Mapper接口**
- `SysBackupMapper.java` - 备份数据访问层
- `SysBackupConfigMapper.java` - 配置数据访问层
- `SysRestoreMapper.java` - 恢复数据访问层

**服务层**
- `BackupService.java` - 备份恢复核心业务逻辑
  - 分页查询备份列表
  - 创建手动备份
  - 执行备份（异步）
  - 文件加密/解密
  - 删除备份
  - 下载备份
  - 恢复数据库（异步）
  - 配置管理
  - 清理过期备份

**控制器**
- `BackupController.java` - RESTful API接口
  - `GET /api/backup` - 查询备份列表
  - `POST /api/backup` - 创建备份
  - `DELETE /api/backup/{id}` - 删除备份
  - `GET /api/backup/{id}/download` - 下载备份
  - `POST /api/backup/{id}/restore` - 恢复数据库
  - `GET /api/backup/config` - 获取配置
  - `PUT /api/backup/config` - 更新配置
  - `POST /api/backup/clean` - 清理过期备份

#### 3. 权限控制
- 管理员（ADMIN）：所有操作权限
- 馆长（CURATOR）：查询和下载权限

### 前端实现

#### 1. 视图组件
- `BackupView.vue` - 备份管理主界面
  - 备份列表展示（表格）
  - 创建备份对话框
  - 备份配置对话框
  - 操作按钮（下载、恢复、删除）
  - 状态标签显示
  - 分页控件

#### 2. API接口
- `backup.js` - 前端API封装
  - getBackupList() - 获取备份列表
  - createBackup() - 创建备份
  - deleteBackup() - 删除备份
  - downloadBackup() - 下载备份
  - restoreDatabase() - 恢复数据库
  - getBackupConfig() - 获取配置
  - updateBackupConfig() - 更新配置
  - cleanExpiredBackups() - 清理过期备份

#### 3. 路由配置
```javascript
{
  path: '/backup',
  name: 'Backup',
  component: BackupView,
  meta: { requiresAuth: true, roles: ['ADMIN', 'CURATOR'] }
}
```

#### 4. 国际化支持
- 中文翻译（zh-CN.js）
- 英文翻译（en-US.js）
- 支持所有界面文本、按钮、提示信息

## 部署步骤

### 1. 数据库初始化
```bash
# 执行SQL脚本创建表
mysql -u root -p cultural_relics < backend/sql/backup_system.sql
```

### 2. 后端配置
确保 `application.yml` 中配置了正确的数据库连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/cultural_relics
    username: root
    password: your_password
```

### 3. 系统要求
- MySQL客户端工具（mysqldump, mysql命令）
- 确保应用有文件系统写权限（创建backups目录）
- 建议配置定时任务执行自动备份

### 4. 启动应用
```bash
# 后端
cd backend
mvn spring-boot:run

# 前端
cd frontend
npm run dev
```

## 使用指南

### 创建手动备份
1. 登录系统（管理员账号）
2. 进入"备份管理"页面
3. 点击"创建备份"按钮
4. 填写备份名称和描述
5. 选择是否加密
6. 点击"确定"开始备份

### 恢复数据库
1. 在备份列表中找到要恢复的备份
2. 确认备份状态为"成功"
3. 点击"恢复"按钮
4. 确认恢复操作
5. 等待恢复完成

### 配置自动备份
1. 点击"备份配置"按钮
2. 设置备份频率（每日/每周/每月）
3. 设置备份时间
4. 设置保留天数
5. 设置最大备份数量
6. 保存配置

### 清理过期备份
1. 点击"清理过期备份"按钮
2. 系统自动删除超过保留天数的备份

## 安全特性

### 1. 文件加密
- 使用AES加密算法
- 加密密钥：CulturalRelicsBackupKey2026
- 建议：生产环境应使用密钥管理系统

### 2. 权限控制
- 基于Spring Security的角色权限控制
- 操作日志记录（使用@OperationLog注解）

### 3. 文件管理
- 备份文件存储在独立目录
- 自动清理过期备份
- 支持文件大小限制

## 注意事项

### 1. 系统依赖
- 需要安装MySQL客户端工具
- Windows系统需要配置环境变量
- Linux/Mac系统通常已预装

### 2. 性能考虑
- 备份和恢复操作是异步执行的
- 大型数据库备份可能需要较长时间
- 建议在业务低峰期执行备份

### 3. 存储空间
- 定期检查备份目录空间
- 合理设置保留天数和最大备份数量
- 考虑使用外部存储或云存储

### 4. 恢复风险
- 恢复操作会覆盖当前数据库
- 建议在恢复前先创建当前数据库的备份
- 测试环境验证后再在生产环境执行

## 故障排查

### 备份失败
1. 检查MySQL客户端是否安装
2. 检查数据库连接配置
3. 检查文件系统权限
4. 查看错误日志

### 恢复失败
1. 确认备份文件完整性
2. 检查数据库用户权限
3. 验证备份文件格式
4. 查看错误日志

### 加密问题
1. 确认加密密钥配置正确
2. 检查Java加密扩展是否安装
3. 验证文件读写权限

## 后续优化建议

### 1. 功能增强
- [ ] 支持增量备份
- [ ] 支持远程存储（OSS、S3等）
- [ ] 支持备份文件压缩
- [ ] 支持多数据库备份
- [ ] 支持备份验证

### 2. 性能优化
- [ ] 备份进度显示
- [ ] 并发备份控制
- [ ] 备份文件分片
- [ ] 断点续传支持

### 3. 安全增强
- [ ] 密钥轮换机制
- [ ] 备份文件签名验证
- [ ] 访问审计日志
- [ ] 多因素认证

## 编译验证

最后编译时间：2026-04-27 21:25:55
编译状态：✅ SUCCESS
编译输出：166 source files compiled successfully

## 相关文档
- [快速开始指南](BACKUP_QUICK_START.md)
- [API接口文档](../README.md)
- [数据库脚本](../sql/backup_system.sql)

## 更新日志

### 2026-04-27
- ✅ 完成所有后端代码实现
- ✅ 完成所有前端代码实现
- ✅ 修复编译错误
- ✅ 添加国际化支持
- ✅ 通过编译验证
