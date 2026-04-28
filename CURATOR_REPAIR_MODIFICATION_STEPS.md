# 文物保管员修复功能修改 - 实施步骤

## ✅ 已完成

### 1. 创建新视图文件
- ✅ `frontend/src/views/RepairApplyView.vue` - 保管员专用的申请修复界面

### 2. 修改路由配置
- ✅ `frontend/src/router/index.js` - 已添加 `/repair-apply` 路由

### 3. 修改菜单配置
- ✅ `frontend/src/views/LayoutView.vue` - 已添加"申请修复"菜单项

### 4. 添加国际化配置
- ✅ `frontend/src/i18n/locales/zh-CN.js` - 已添加 `repairApply: '申请修复'`
- ✅ `frontend/src/i18n/locales/en-US.js` - 已添加 `repairApply: 'Apply Repair'`

### 5. 创建数据库SQL脚本
- ✅ `backend/sql/add_repair_apply_permission.sql` - 权限配置和通知类型

## 📝 待完成的修改

### 1. 执行数据库脚本

**操作步骤**:
```bash
mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql
```

**验证**:
```sql
-- 查看CURATOR角色权限
SELECT p.permission_code, p.permission_name
FROM sys_role r
JOIN sys_role_permission rp ON r.id = rp.role_id
JOIN sys_permission p ON rp.permission_id = p.id
WHERE r.role_code = 'CURATOR';
```

### 2. 修改后端代码

详细的后端修改步骤请参考：**`BACKEND_MODIFICATIONS_NEEDED.md`**

需要修改的文件：
- ⏳ `backend/src/main/java/com/example/controller/RepairRecordController.java`
- ⏳ `backend/src/main/java/com/example/service/RepairRecordService.java`
- ⏳ `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java`
- ⏳ `backend/src/main/java/com/example/service/NotificationService.java`
- ⏳ `backend/src/main/java/com/example/service/impl/NotificationServiceImpl.java`
- ⏳ `backend/src/main/resources/mapper/RepairRecordMapper.xml`

### 3. 编译和重启

```bash
cd backend
mvn clean compile
# 重启Spring Boot应用
```

## 🧪 测试步骤

### 1. 数据库测试
```bash
mysql -u root -p cultural_relics < backend/sql/add_repair_apply_permission.sql
```

验证：
- CURATOR角色有 repairs:apply 权限
- CURATOR角色没有 repairs:manage 权限
- 通知类型已添加

### 2. 前端测试

#### 测试用户
- 用户名：curator01
- 密码：123456
- 角色：文物保管员（CURATOR）

#### 测试步骤
1. 登录保管员账号
2. 验证菜单只显示"申请修复"，不显示"修复管理"、"修复专家"、"修复材料"
3. 点击"申请修复"，进入申请页面
4. 点击"申请修复"按钮，填写表单
5. 选择文物、材料，验证预估费用自动计算
6. 提交申请，验证成功
7. 查看列表，验证只显示自己申请的记录
8. 验证只能删除"待审批"和"已拒绝"状态的记录

### 3. 通知测试

#### 测试步骤
1. 保管员提交修复申请
2. 使用管理员账号登录，审批通过
3. 保管员登录，验证收到"修复申请已通过"通知
4. 管理员完成修复
5. 保管员登录，验证收到"修复已完成"通知

### 4. 权限测试

#### 测试场景
1. 保管员尝试访问 `/repairs` - 应该被拒绝或跳转到 dashboard
2. 保管员访问 `/repair-apply` - 应该正常显示
3. 保管员尝试审批修复 - 应该没有审批按钮
4. 保管员尝试开始修复 - 应该没有开始修复按钮

## 📊 修改文件清单

### 前端文件
- ✅ `frontend/src/views/RepairApplyView.vue` - 新建
- ⏳ `frontend/src/router/index.js` - 修改
- ⏳ `frontend/src/views/LayoutView.vue` - 修改
- ⏳ `frontend/src/i18n/locales/zh-CN.js` - 修改
- ⏳ `frontend/src/i18n/locales/en-US.js` - 修改

### 后端文件
- ⏳ `backend/sql/add_repair_apply_permission.sql` - 新建
- ⏳ `backend/src/main/java/com/example/controller/RepairRecordController.java` - 修改
- ⏳ `backend/src/main/java/com/example/service/NotificationService.java` - 可能需要修改

### 文档文件
- ✅ `CURATOR_REPAIR_APPLY_MODIFICATION.md` - 设计方案
- ✅ `CURATOR_REPAIR_MODIFICATION_STEPS.md` - 实施步骤（本文档）

## 🎯 预期效果

### 保管员视角
- 菜单简洁，只显示"申请修复"
- 可以申请修复，选择材料
- 可以查看自己的申请记录
- 可以查看申请状态和详情
- 收到审批和完成通知

### 管理员/审批员视角
- 菜单显示完整的修复管理功能
- 可以查看所有修复记录
- 可以审批、修复、完成
- 可以管理专家和材料

---

**创建时间**：2026-04-28  
**状态**：部分完成  
**下一步**：完成剩余的前端和后端修改
