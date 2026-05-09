# 硬编码修复检查清单

## 修复验证清单

### ✅ 代码修复（已完成）

- [x] **BackupController.java**
  - [x] createBackup() 方法 - 使用 getCurrentUserRealName()
  - [x] restoreDatabase() 方法 - 使用 getCurrentUserRealName()

- [x] **CulturalRelicController.java**
  - [x] saveWithImage() 方法 - 使用 getCurrentUserRealName() 和 getCurrentUserId()
  - [x] uploadImage() 方法 - 使用 getCurrentUserRealName() 和 getCurrentUserId()
  - [x] delete() 方法 - 使用 getCurrentUserRealName() 和 getCurrentUserId()

- [x] **SysUserController.java**
  - [x] update() 方法 - 使用 getCurrentUserRealName() 和 getCurrentUserId()
  - [x] delete() 方法 - 使用 getCurrentUserRealName() 和 getCurrentUserId()

- [x] **RelicImageRelationController.java**
  - [x] uploadRelicImage() 方法 - 使用 getCurrentUserRealName() 和 getCurrentUserId()

- [x] **编译检查**
  - [x] 所有修改的文件无编译错误
  - [x] 所有依赖注入正确

### 📋 功能测试（待执行）

#### 1. 备份管理测试
- [ ] 使用不同用户登录
- [ ] 创建手动备份
- [ ] 检查备份列表中的"创建人"字段
- [ ] 验证显示的是真实姓名（如"张三"）而不是"admin"
- [ ] 执行数据库恢复
- [ ] 检查恢复记录中的"创建人"字段

**测试数据**：
```
用户1：username=admin, realName=系统管理员
用户2：username=curator1, realName=张三
用户3：username=curator2, realName=李四
```

**预期结果**：
```
admin 创建的备份 → 创建人显示"系统管理员"
curator1 创建的备份 → 创建人显示"张三"
curator2 创建的备份 → 创建人显示"李四"
```

#### 2. 文物管理测试
- [ ] 使用不同用户登录
- [ ] 新增文物（含图片）
- [ ] 上传文物图片
- [ ] 删除文物
- [ ] 检查审计日志中的操作人
- [ ] 验证显示的是真实姓名

**测试场景**：
```
场景1：curator1（张三）新增文物
  → 审计日志应显示操作人为"张三"
  
场景2：curator2（李四）上传图片
  → 图片上传者应显示为"李四"
  
场景3：admin（系统管理员）删除文物
  → 审计日志应显示操作人为"系统管理员"
```

#### 3. 用户管理测试
- [ ] 使用管理员登录
- [ ] 修改用户信息
- [ ] 删除用户
- [ ] 检查审计日志
- [ ] 验证操作人显示正确

**测试步骤**：
```
1. admin（系统管理员）登录
2. 修改 curator1 的信息
3. 查看审计日志
4. 验证操作人显示"系统管理员"而不是"admin"或"1"
```

#### 4. 图片管理测试
- [ ] 使用不同用户登录
- [ ] 上传文物主图
- [ ] 批量上传图片
- [ ] 检查图片记录中的上传者
- [ ] 验证显示的是真实姓名

**测试数据**：
```
curator1（张三）上传图片 → 上传者显示"张三"
curator2（李四）上传图片 → 上传者显示"李四"
```

### 🔍 数据库验证（待执行）

#### 1. 检查备份记录
```sql
-- 查询最近的备份记录
SELECT 
    id,
    backup_name,
    created_by,  -- 应该是真实姓名
    created_time
FROM sys_backup
ORDER BY created_time DESC
LIMIT 10;
```

**预期结果**：
- created_by 字段显示真实姓名（如"张三"、"李四"）
- 不应该出现 "admin" 或 "1"

#### 2. 检查审计日志
```sql
-- 查询最近的审计日志
SELECT 
    id,
    operator_id,
    operator_name,  -- 应该是真实姓名
    operation_type,
    operation_module,
    operation_time
FROM sys_operation_log
ORDER BY operation_time DESC
LIMIT 20;
```

**预期结果**：
- operator_name 字段显示真实姓名
- operator_id 字段显示正确的用户ID（不是固定的1）

#### 3. 检查恢复记录
```sql
-- 查询恢复记录
SELECT 
    id,
    backup_id,
    created_by,  -- 应该是真实姓名
    restore_status,
    created_time
FROM sys_restore
ORDER BY created_time DESC
LIMIT 10;
```

**预期结果**：
- created_by 字段显示真实姓名

#### 4. 检查图片库记录
```sql
-- 查询图片上传记录
SELECT 
    id,
    image_name,
    uploader_id,
    uploader_name,  -- 应该是真实姓名
    upload_time
FROM image_library
ORDER BY upload_time DESC
LIMIT 10;
```

**预期结果**：
- uploader_name 字段显示真实姓名
- uploader_id 字段显示正确的用户ID

### 🧪 边界测试（待执行）

#### 1. 用户无真实姓名
- [ ] 创建一个没有设置 real_name 的用户
- [ ] 使用该用户执行操作
- [ ] 验证显示用户名（username）而不是空值

**测试步骤**：
```sql
-- 创建测试用户（无真实姓名）
INSERT INTO sys_user (username, password, role, real_name) 
VALUES ('testuser', 'password', 'STAFF', NULL);

-- 或者清空真实姓名
UPDATE sys_user SET real_name = NULL WHERE username = 'testuser';
```

**预期结果**：
- 操作记录应显示用户名 "testuser"
- 不应该显示 NULL 或空字符串

#### 2. 未登录用户
- [ ] 测试未认证的请求（如果有公开接口）
- [ ] 验证显示"系统"

**预期结果**：
- 操作人显示"系统"
- 用户ID为 null

#### 3. 认证异常
- [ ] 模拟认证信息异常
- [ ] 验证系统不会崩溃
- [ ] 验证显示默认值

**预期结果**：
- 不抛出异常
- 显示"系统"作为默认值

### 📊 性能测试（可选）

#### 1. 并发测试
- [ ] 多个用户同时执行操作
- [ ] 验证每个操作记录的用户信息正确
- [ ] 检查是否有用户信息混淆

#### 2. 响应时间
- [ ] 测量修复前后的响应时间
- [ ] 验证性能没有明显下降
- [ ] 如果性能下降明显，考虑添加缓存

**基准测试**：
```
操作：创建备份
修复前：平均响应时间 XXms
修复后：平均响应时间 XXms
差异：应该在可接受范围内（<10%）
```

### 📝 文档检查（已完成）

- [x] 创建 HARDCODE_FIX_SUMMARY.md
- [x] 创建 HARDCODE_FIX_CHECKLIST.md
- [x] 更新 BACKUP_CREATOR_FIX.md
- [x] 更新 BACKUP_SYSTEM_GUIDE.md

### 🚀 部署前检查

- [ ] 所有代码已提交到版本控制
- [ ] 代码已通过 Code Review
- [ ] 所有测试用例已通过
- [ ] 数据库验证已完成
- [ ] 文档已更新
- [ ] 已通知相关人员

### ⚠️ 回滚计划

如果修复后出现问题，可以快速回滚：

#### 回滚步骤
1. 恢复修改前的代码版本
2. 重新部署应用
3. 验证系统功能正常

#### 回滚影响
- 操作记录会再次显示硬编码的值
- 不影响已有的数据
- 不影响系统功能

### 📞 问题报告

如果在测试过程中发现问题，请记录以下信息：

#### 问题模板
```
问题描述：
重现步骤：
1. 
2. 
3. 

预期结果：
实际结果：
影响范围：
严重程度：[低/中/高/紧急]
截图/日志：
```

### ✅ 最终验收标准

修复被认为成功需要满足以下所有条件：

1. **功能正确性**
   - [ ] 所有操作记录显示真实姓名
   - [ ] 审计日志显示正确的用户信息
   - [ ] 没有硬编码的 "admin" 或 "1"

2. **边界情况**
   - [ ] 无真实姓名的用户显示用户名
   - [ ] 未登录用户显示"系统"
   - [ ] 异常情况不会导致系统崩溃

3. **性能要求**
   - [ ] 响应时间没有明显增加
   - [ ] 系统稳定性没有下降

4. **文档完整**
   - [ ] 所有修改都有文档记录
   - [ ] 测试结果已归档

5. **代码质量**
   - [ ] 无编译错误
   - [ ] 无代码警告
   - [ ] 符合项目编码规范

## 测试执行记录

### 测试人员：___________
### 测试日期：___________

| 测试项 | 状态 | 备注 |
|--------|------|------|
| 备份管理测试 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |
| 文物管理测试 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |
| 用户管理测试 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |
| 图片管理测试 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |
| 数据库验证 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |
| 边界测试 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |
| 性能测试 | ⬜ 未测试 / ✅ 通过 / ❌ 失败 | |

### 总体评价：
```
⬜ 通过验收，可以部署
⬜ 需要修复问题后重新测试
⬜ 需要回滚修改
```

### 测试结论：
```
（在此填写测试结论和建议）
```

---

**创建日期**：2026-05-09  
**最后更新**：2026-05-09  
**版本**：v1.0
