# 数据备份系统快速参考

## 快速开始

### 创建备份（3步）
1. 进入"系统管理" → "数据备份"
2. 点击"创建备份"按钮
3. 填写备份名称，点击"确定"

### 恢复数据（2步）
1. 在备份列表找到要恢复的备份
2. 点击"恢复"按钮，确认操作

### 下载备份（1步）
- 点击备份记录的"下载"按钮

## 核心特性

| 特性 | 说明 |
|------|------|
| 备份方式 | Java原生（不依赖外部命令） |
| 跨平台 | Windows/Linux/Mac 全支持 |
| 加密 | 支持AES加密 |
| 异步执行 | 不阻塞用户操作 |
| 审计日志 | 记录所有操作 |

## 权限要求

| 操作 | 所需角色 |
|------|----------|
| 创建备份 | ADMIN |
| 查看备份 | ADMIN, CURATOR |
| 下载备份 | ADMIN, CURATOR |
| 恢复数据库 | ADMIN |
| 删除备份 | ADMIN |
| 配置管理 | ADMIN |

## 备份状态

| 状态 | 说明 | 可执行操作 |
|------|------|------------|
| 处理中 | 正在备份 | 等待完成 |
| 成功 | 备份完成 | 下载、恢复、删除 |
| 失败 | 备份失败 | 查看错误、删除 |

## 文件位置

```
backend/
└── backups/
    ├── backup_20260509_145118.sql
    ├── backup_20260509_150230.sql
    └── ...
```

## 命名规则

```
backup_YYYYMMDD_HHmmss.sql
       │       │
       │       └─ 时间（时分秒）
       └───────── 日期（年月日）
```

## API 端点

| 方法 | 路径 | 说明 |
|------|------|------|
| GET | /backup | 查询备份列表 |
| POST | /backup | 创建备份 |
| DELETE | /backup/{id} | 删除备份 |
| GET | /backup/{id}/download | 下载备份 |
| POST | /backup/{id}/restore | 恢复数据库 |
| GET | /backup/config | 获取配置 |
| PUT | /backup/config | 更新配置 |
| POST | /backup/clean | 清理过期备份 |

## 配置参数

| 参数 | 类型 | 说明 | 默认值 |
|------|------|------|--------|
| isEnabled | Boolean | 是否启用自动备份 | true |
| backupFrequency | String | 备份频率 | daily |
| backupTime | String | 备份时间 | 02:00 |
| retentionDays | Integer | 保留天数 | 30 |
| maxBackupCount | Integer | 最大备份数 | 10 |
| isEncrypted | Boolean | 是否加密 | false |
| notificationEnabled | Boolean | 是否通知 | true |

## 常用操作

### 查看备份日志
```bash
# 后端日志位置
tail -f backend/logs/application.log | grep -i backup
```

### 手动清理备份
```bash
# 删除30天前的备份文件
find backend/backups -name "backup_*.sql" -mtime +30 -delete
```

### 检查备份文件
```bash
# 查看备份文件大小
ls -lh backend/backups/

# 查看备份文件内容（前10行）
head -n 10 backend/backups/backup_20260509_145118.sql
```

## 故障排查

### 问题：备份一直处理中
```
1. 检查后端日志
2. 检查数据库连接
3. 检查磁盘空间
```

### 问题：恢复失败
```
1. 验证备份文件完整性
2. 检查数据库权限
3. 查看详细错误日志
```

### 问题：文件大小为0
```
已修复：现在使用Java原生方式
如仍出现，检查文件系统权限
```

## 最佳实践

✅ **DO（推荐）**
- 定期创建备份
- 重要操作前手动备份
- 使用加密保护敏感数据
- 定期测试恢复功能
- 保留多个历史版本

❌ **DON'T（避免）**
- 不要在业务高峰期备份
- 不要删除所有备份
- 不要在生产环境随意恢复
- 不要忽略备份失败通知

## 技术栈

```
前端：Vue 3 + Element Plus
后端：Spring Boot + MyBatis
数据库：MySQL 8.0
加密：AES
认证：Spring Security
```

## 核心类

```
BackupController      - 控制器
BackupService         - 业务逻辑
DatabaseBackupUtil    - 备份工具
UserContextUtil       - 用户上下文
```

## 数据库表

```
sys_backup            - 备份记录
sys_backup_config     - 备份配置
sys_restore           - 恢复记录
```

## 更新历史

| 日期 | 版本 | 更新内容 |
|------|------|----------|
| 2026-05-09 | v2.0 | 修复创建人显示、Java原生备份 |
| 2026-05-08 | v1.1 | 修复file_path问题 |
| 2026-05-07 | v1.0 | 初始版本 |

## 联系方式

- 技术支持：系统管理员
- 文档位置：`docs/BACKUP_SYSTEM_GUIDE.md`
- 问题反馈：通过系统内部工单

---

**提示**：详细文档请参考 `BACKUP_SYSTEM_GUIDE.md`
