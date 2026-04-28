# 审计日志功能部署检查清单

## 📋 部署前准备

### 1. 环境检查
- [ ] MySQL 5.7+ 或 8.0+
- [ ] Java 8+ 或 Java 11+
- [ ] Maven 3.6+
- [ ] Node.js 14+
- [ ] Redis（可选，用于缓存）

### 2. 备份数据库
```bash
# 备份当前数据库
mysqldump -u root -p cultural_relics > backup_$(date +%Y%m%d_%H%M%S).sql
```

---

## 🗄️ 数据库部署

### 步骤1：执行增强脚本
```bash
mysql -u root -p cultural_relics < backend/sql/audit_log_enhancement.sql
```

### 步骤2：验证数据库变更
```sql
-- 检查sys_operation_log表结构
DESC sys_operation_log;

-- 检查sys_data_change_detail表
DESC sys_data_change_detail;

-- 检查视图
SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW';

-- 检查存储过程
SHOW PROCEDURE STATUS WHERE Db = 'cultural_relics';
```

### 预期结果
- [ ] sys_operation_log表包含以下新字段：
  - ip_address
  - browser
  - os
  - request_method
  - request_url
  - request_params
  - response_status
  - error_message
  - execution_time
  - resource_type
  - resource_id
  - before_data
  - after_data
  - change_summary
  - tags
  - trace_id

- [ ] sys_data_change_detail表创建成功
- [ ] 3个视图创建成功：
  - v_operation_statistics
  - v_user_operation_statistics
  - v_resource_operation_history

- [ ] 2个存储过程创建成功：
  - sp_clean_old_operation_logs
  - sp_get_operation_statistics

---

## 🔧 后端部署

### 步骤1：编译项目
```bash
cd backend
mvn clean compile
```

### 预期结果
- [ ] 编译成功（BUILD SUCCESS）
- [ ] 无编译错误

### 步骤2：运行测试（可选）
```bash
mvn test
```

### 步骤3：打包项目
```bash
mvn clean package -DskipTests
```

### 预期结果
- [ ] 生成jar文件：`target/cultural-relics-manage-1.0.0.jar`

### 步骤4：启动应用
```bash
# 开发环境
mvn spring-boot:run

# 生产环境
java -jar target/cultural-relics-manage-1.0.0.jar
```

### 步骤5：验证后端启动
```bash
# 检查健康状态
curl http://localhost:8080/api/actuator/health

# 检查审计日志接口
curl http://localhost:8080/api/operation-logs?pageNum=1&pageSize=10
```

### 预期结果
- [ ] 应用启动成功
- [ ] 无启动错误
- [ ] 接口响应正常

---

## 🎨 前端部署

### 步骤1：安装依赖
```bash
cd frontend
npm install
```

### 步骤2：启动开发服务器
```bash
npm run dev
```

### 步骤3：构建生产版本
```bash
npm run build
```

### 预期结果
- [ ] 依赖安装成功
- [ ] 开发服务器启动成功
- [ ] 生产构建成功

---

## ✅ 功能验证

### 1. 文物管理审计日志
- [ ] 修改文物信息，检查审计日志记录
- [ ] 删除文物，检查审计日志记录
- [ ] 批量更新状态，检查审计日志记录

### 2. 借展管理审计日志
- [ ] 审批借展，检查审计日志记录
- [ ] 归还文物，检查审计日志记录
- [ ] 删除借展记录，检查审计日志记录

### 3. 修复管理审计日志
- [ ] 创建修复记录，检查审计日志记录
- [ ] 更新修复记录，检查审计日志记录
- [ ] 删除修复记录，检查审计日志记录
- [ ] 开始修复，检查审计日志记录
- [ ] 完成修复，检查审计日志记录

### 4. 用户管理审计日志
- [ ] 更新用户信息，检查审计日志记录
- [ ] 删除用户，检查审计日志记录
- [ ] 重置密码，检查审计日志记录

### 5. 博物馆管理审计日志
- [ ] 更新博物馆信息，检查审计日志记录
- [ ] 删除博物馆，检查审计日志记录

### 6. 分类管理审计日志
- [ ] 修改分类信息，检查审计日志记录
- [ ] 删除分类，检查审计日志记录

### 7. 维护记录审计日志
- [ ] 新增维护记录，检查审计日志记录
- [ ] 修改维护记录，检查审计日志记录
- [ ] 删除维护记录，检查审计日志记录

### 8. 修复专家审计日志
- [ ] 修改专家信息，检查审计日志记录
- [ ] 删除专家，检查审计日志记录

### 9. 修复材料审计日志
- [ ] 更新材料信息，检查审计日志记录
- [ ] 删除材料，检查审计日志记录
- [ ] 更新库存，检查审计日志记录

### 10. 档案管理审计日志
- [ ] 更新档案，检查审计日志记录
- [ ] 删除档案，检查审计日志记录
- [ ] 发布档案，检查审计日志记录

### 11. 图片管理审计日志
- [ ] 更新图片信息，检查审计日志记录
- [ ] 删除图片，检查审计日志记录

---

## 🖥️ 前端界面验证

### 1. 审计日志列表
- [ ] 访问审计日志页面
- [ ] 列表正常显示
- [ ] 分页功能正常
- [ ] 排序功能正常

### 2. 高级搜索
- [ ] 按用户搜索
- [ ] 按操作类型搜索
- [ ] 按模块搜索
- [ ] 按时间范围搜索
- [ ] 按资源类型搜索

### 3. 数据对比
- [ ] 点击"查看详情"按钮
- [ ] 变更字段列表正常显示
- [ ] 完整数据对比正常显示
- [ ] 高亮显示变更内容

### 4. 统计图表
- [ ] 操作类型分布图正常显示
- [ ] 模块操作分布图正常显示
- [ ] 操作趋势图正常显示

### 5. 国际化
- [ ] 切换到英文，界面正常显示
- [ ] 切换到中文，界面正常显示
- [ ] 所有文本正确翻译

---

## 🔍 数据验证

### 1. 检查审计日志记录
```sql
-- 查看最近的审计日志
SELECT * FROM sys_operation_log 
ORDER BY operation_time DESC 
LIMIT 10;

-- 查看数据变更明细
SELECT * FROM sys_data_change_detail 
ORDER BY id DESC 
LIMIT 10;

-- 查看操作统计
SELECT * FROM v_operation_statistics;

-- 查看用户操作统计
SELECT * FROM v_user_operation_statistics;
```

### 2. 验证数据完整性
- [ ] operation_time字段有值
- [ ] user_id字段有值
- [ ] username字段有值
- [ ] operation_type字段有值
- [ ] operation_module字段有值
- [ ] ip_address字段有值
- [ ] resource_type字段有值（对于数据变更操作）
- [ ] resource_id字段有值（对于数据变更操作）
- [ ] before_data字段有值（对于修改/删除操作）
- [ ] after_data字段有值（对于新增/修改操作）

### 3. 验证数据对比
```sql
-- 查看某个资源的变更历史
SELECT * FROM sys_operation_log 
WHERE resource_type = 'RELIC' 
AND resource_id = 1 
ORDER BY operation_time DESC;

-- 查看某个用户的操作历史
SELECT * FROM sys_operation_log 
WHERE user_id = 1 
ORDER BY operation_time DESC 
LIMIT 20;
```

---

## 🚨 常见问题排查

### 问题1：数据库脚本执行失败
**症状**: 执行SQL脚本时报错

**排查步骤**:
1. 检查MySQL版本是否支持
2. 检查数据库字符集是否为utf8mb4
3. 检查是否有足够的权限
4. 查看错误信息，定位具体问题

**解决方案**:
```sql
-- 检查字符集
SHOW VARIABLES LIKE 'character%';

-- 修改字符集（如果需要）
ALTER DATABASE cultural_relics CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 问题2：编译失败
**症状**: Maven编译报错

**排查步骤**:
1. 检查Java版本
2. 检查Maven版本
3. 清理Maven缓存
4. 查看具体编译错误

**解决方案**:
```bash
# 清理Maven缓存
mvn clean

# 强制更新依赖
mvn clean install -U

# 跳过测试编译
mvn clean compile -DskipTests
```

### 问题3：审计日志不记录
**症状**: 执行操作后，审计日志表中没有记录

**排查步骤**:
1. 检查后端日志，查看是否有异常
2. 检查SysOperationLogService是否正确注入
3. 检查数据库连接是否正常
4. 检查事务是否正常提交

**解决方案**:
```java
// 在Controller中添加日志输出
System.out.println("开始记录审计日志...");
try {
    operationLogService.logDataChange(...);
    System.out.println("审计日志记录成功");
} catch (Exception e) {
    System.err.println("审计日志记录失败: " + e.getMessage());
    e.printStackTrace();
}
```

### 问题4：前端界面显示异常
**症状**: 审计日志页面无法正常显示

**排查步骤**:
1. 检查浏览器控制台错误
2. 检查网络请求是否成功
3. 检查后端接口是否正常
4. 检查国际化配置是否正确

**解决方案**:
```javascript
// 在浏览器控制台查看错误
console.log('审计日志数据:', response.data);

// 检查API请求
fetch('http://localhost:8080/api/operation-logs?pageNum=1&pageSize=10')
  .then(res => res.json())
  .then(data => console.log(data));
```

### 问题5：数据对比不显示
**症状**: 点击"查看详情"后，数据对比为空

**排查步骤**:
1. 检查before_data和after_data字段是否有值
2. 检查JSON格式是否正确
3. 检查前端解析逻辑是否正确

**解决方案**:
```sql
-- 检查数据
SELECT 
    id,
    operation_type,
    resource_type,
    resource_id,
    LENGTH(before_data) as before_length,
    LENGTH(after_data) as after_length
FROM sys_operation_log 
WHERE resource_type IS NOT NULL 
ORDER BY operation_time DESC 
LIMIT 10;
```

---

## 📊 性能监控

### 1. 数据库性能
```sql
-- 检查审计日志表大小
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS size_mb
FROM information_schema.TABLES 
WHERE table_schema = 'cultural_relics' 
AND table_name IN ('sys_operation_log', 'sys_data_change_detail');

-- 检查索引使用情况
SHOW INDEX FROM sys_operation_log;

-- 检查慢查询
SHOW VARIABLES LIKE 'slow_query%';
```

### 2. 应用性能
- [ ] 审计日志记录不影响业务操作响应时间
- [ ] 审计日志查询响应时间 < 2秒
- [ ] 数据对比加载时间 < 1秒

### 3. 定期清理
```sql
-- 手动清理90天前的日志
CALL sp_clean_old_operation_logs(90);

-- 设置定时任务（每月1号凌晨2点执行）
CREATE EVENT IF NOT EXISTS clean_old_logs
ON SCHEDULE EVERY 1 MONTH
STARTS '2026-05-01 02:00:00'
DO CALL sp_clean_old_operation_logs(90);
```

---

## 🔒 安全检查

### 1. 权限控制
- [ ] 审计日志查询需要登录
- [ ] 普通用户只能查看自己的操作日志
- [ ] 管理员可以查看所有操作日志
- [ ] 审计日志不能被修改或删除

### 2. 敏感信息
- [ ] 密码字段已脱敏
- [ ] 身份证号已脱敏
- [ ] 手机号已脱敏
- [ ] 邮箱已脱敏

### 3. 日志完整性
- [ ] 所有数据变更操作都有审计日志
- [ ] 审计日志包含完整的操作信息
- [ ] 审计日志不能被篡改

---

## 📝 部署完成确认

### 最终检查清单
- [ ] 数据库脚本执行成功
- [ ] 后端编译成功
- [ ] 后端启动成功
- [ ] 前端构建成功
- [ ] 前端启动成功
- [ ] 所有功能验证通过
- [ ] 所有界面验证通过
- [ ] 数据验证通过
- [ ] 性能监控正常
- [ ] 安全检查通过

### 部署签字
- 部署人员: _______________
- 部署时间: _______________
- 验证人员: _______________
- 验证时间: _______________

---

## 📞 支持联系

如遇到问题，请参考以下文档：
1. `AUDIT_LOG_INTEGRATION_COMPLETE.md` - 集成完成总结
2. `backend/docs/AUDIT_LOG_COMPLETE_GUIDE.md` - 完整实施指南
3. `backend/docs/AUDIT_LOG_QUICK_START.md` - 快速入门
4. `AUDIT_LOG_README.md` - 项目总览

---

**文档版本**: 1.0  
**最后更新**: 2026-04-28  
**适用版本**: v1.0.0
