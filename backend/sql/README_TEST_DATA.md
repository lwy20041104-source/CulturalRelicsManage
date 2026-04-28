# 备份系统测试数据说明

## 文件说明

### 1. backup_test_data.sql（完整版）
- 包含详细的INSERT语句和注释
- 包含数据验证查询
- 包含统计信息查询
- 适合学习和理解数据结构

### 2. backup_test_data_simple.sql（简化版）
- 只包含INSERT语句
- 执行速度快
- 适合快速测试

## 测试数据内容

### 备份配置（2条）
1. **默认自动备份配置**（已启用）
   - 频率：每天
   - 时间：02:00
   - 保留：30天
   - 最大数量：10个
   - 加密：否

2. **每周备份配置**（未启用）
   - 频率：每周
   - 时间：03:00
   - 保留：90天
   - 最大数量：20个
   - 加密：是

### 备份记录（8条）

#### 成功的备份（5条）
1. **系统上线前备份**（手动，15MB）
   - 时间：2026-04-20 10:00:00
   - 创建人：admin
   - 描述：系统正式上线前的完整备份

2. **每日自动备份-20260421**（自动，16MB）
   - 时间：2026-04-21 02:00:00
   - 创建人：system
   - 描述：系统自动执行的每日备份

3. **重要数据加密备份**（手动，18MB，加密）
   - 时间：2026-04-22 15:00:00
   - 创建人：admin
   - 描述：包含敏感数据的加密备份

4. **每日自动备份-20260426**（自动，20MB）
   - 时间：2026-04-26 02:00:00
   - 创建人：system
   - 描述：系统自动执行的每日备份

5. **数据迁移前备份**（手动，21MB）
   - 时间：2026-04-27 08:00:00
   - 创建人：admin
   - 描述：执行数据迁移操作前的安全备份

#### 失败的备份（2条）
6. **失败的备份任务**（自动）
   - 时间：2026-04-23 02:00:00
   - 创建人：system
   - 错误：磁盘空间不足

7. **权限错误的备份**（手动）
   - 时间：2026-04-24 10:00:00
   - 创建人：curator
   - 错误：数据库权限不足

#### 处理中的备份（1条）
8. **正在执行的备份**（手动）
   - 时间：2026-04-27 21:00:00
   - 创建人：admin
   - 状态：处理中

### 恢复记录（4条）

#### 成功的恢复（2条）
1. 从"系统上线前备份"恢复
   - 时间：2026-04-20 18:00:00
   - 完成：2026-04-20 18:05:30
   - 耗时：5分30秒

2. 从"重要数据加密备份"恢复
   - 时间：2026-04-22 16:00:00
   - 完成：2026-04-22 16:06:15
   - 耗时：6分15秒

#### 失败的恢复（1条）
3. 从"每日自动备份-20260421"恢复失败
   - 时间：2026-04-21 10:00:00
   - 错误：无法连接数据库服务器

#### 处理中的恢复（1条）
4. 从"数据迁移前备份"恢复中
   - 时间：2026-04-27 21:05:00
   - 状态：处理中

## 使用方法

### 方式1：执行完整版（推荐学习）
```bash
mysql -u root -p cultural_relics < backend/sql/backup_test_data.sql
```

执行后会显示：
- 插入的数据列表
- 统计信息
- 备份文件总大小

### 方式2：执行简化版（推荐测试）
```bash
mysql -u root -p cultural_relics < backend/sql/backup_test_data_simple.sql
```

快速插入数据，无额外输出。

### 方式3：使用MySQL客户端
1. 打开MySQL Workbench或其他客户端
2. 连接到cultural_relics数据库
3. 打开并执行SQL文件

## 验证数据

### 查看备份列表
```sql
SELECT 
  id,
  backup_name,
  backup_type,
  backup_status,
  ROUND(file_size / 1024 / 1024, 2) AS 'size_mb',
  is_encrypted,
  created_by,
  DATE_FORMAT(created_time, '%Y-%m-%d %H:%i') AS created
FROM sys_backup
ORDER BY created_time DESC;
```

### 查看恢复记录
```sql
SELECT 
  r.id,
  b.backup_name,
  r.restore_status,
  r.created_by,
  DATE_FORMAT(r.created_time, '%Y-%m-%d %H:%i') AS started,
  DATE_FORMAT(r.completed_time, '%Y-%m-%d %H:%i') AS completed
FROM sys_restore r
LEFT JOIN sys_backup b ON r.backup_id = b.id
ORDER BY r.created_time DESC;
```

### 统计信息
```sql
-- 备份状态统计
SELECT 
  backup_status,
  COUNT(*) AS count,
  ROUND(SUM(file_size) / 1024 / 1024, 2) AS 'total_size_mb'
FROM sys_backup
GROUP BY backup_status;

-- 备份类型统计
SELECT 
  backup_type,
  COUNT(*) AS count
FROM sys_backup
GROUP BY backup_type;

-- 恢复状态统计
SELECT 
  restore_status,
  COUNT(*) AS count
FROM sys_restore
GROUP BY restore_status;
```

## 清空测试数据

如果需要清空测试数据重新插入：

```sql
-- 注意：这会删除所有数据！
DELETE FROM sys_restore WHERE id > 0;
DELETE FROM sys_backup WHERE id > 0;
DELETE FROM sys_backup_config WHERE id > 0;

-- 重置自增ID
ALTER TABLE sys_restore AUTO_INCREMENT = 1;
ALTER TABLE sys_backup AUTO_INCREMENT = 1;
ALTER TABLE sys_backup_config AUTO_INCREMENT = 1;
```

## 前端展示效果

插入测试数据后，在前端"数据备份"页面可以看到：

### 备份列表
- 8条备份记录
- 不同状态的标签（成功/失败/处理中）
- 不同类型的标签（手动/自动）
- 加密标识
- 文件大小显示

### 筛选功能
- 按类型筛选：手动/自动
- 按状态筛选：成功/失败/处理中

### 操作按钮
- 成功的备份可以：下载、恢复、删除
- 失败的备份可以：查看错误、删除
- 处理中的备份：显示处理中状态

## 测试场景

### 场景1：查看备份列表
1. 访问"数据备份"页面
2. 应该看到8条备份记录
3. 验证状态标签颜色正确

### 场景2：筛选功能
1. 选择"手动备份"
2. 应该看到4条记录
3. 选择"成功"状态
4. 应该看到3条记录

### 场景3：查看恢复历史
1. 点击某个备份的"恢复"按钮
2. 在恢复记录中应该能看到历史记录

### 场景4：分页功能
1. 设置每页显示5条
2. 应该有2页
3. 测试翻页功能

### 场景5：中英文切换
1. 切换到英文
2. 所有文本应该显示英文
3. 切换回中文

## 注意事项

1. **备份文件不存在**
   - 测试数据中的备份文件路径是虚拟的
   - 实际文件不存在于文件系统中
   - 下载功能会报错（这是正常的）
   - 如需测试下载，请创建真实的备份

2. **恢复功能测试**
   - 测试数据中的恢复记录是历史记录
   - 可以查看但不能重新执行
   - 如需测试恢复，请使用真实的备份

3. **处理中状态**
   - "处理中"的记录是模拟的
   - 实际不会自动完成
   - 可以手动更新状态测试

4. **时间戳**
   - 测试数据使用的是固定时间
   - 可以根据需要修改为当前时间

## 数据统计

- 备份配置：2条
- 备份记录：8条
  - 成功：5条（总大小：92.8MB）
  - 失败：2条
  - 处理中：1条
- 恢复记录：4条
  - 成功：2条
  - 失败：1条
  - 处理中：1条

## 相关文档

- [备份系统实现文档](../docs/BACKUP_SYSTEM_IMPLEMENTATION.md)
- [快速开始指南](../docs/BACKUP_QUICK_START.md)
- [部署指南](../docs/BACKUP_DEPLOYMENT_GUIDE.md)

---

创建时间：2026-04-27
版本：v1.0
