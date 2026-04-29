# ⚡ 快速修复指南 - APPROVER 查询维护记录问题

## 🎯 问题
申请审批员（APPROVER）无法查询到全部的维护记录

## 🔍 原因
数据库表 `maintenance_record` 缺少必要字段（`maintainer_id`、`status` 等）

## ✅ 解决方案（3步）

### 步骤 1：执行修复脚本

```bash
cd backend/sql
mysql -h localhost -u root -p cultural_relics < DIAGNOSE_AND_FIX_APPROVER_ACCESS.sql
```

**或者**使用数据库管理工具（Navicat/MySQL Workbench）执行该脚本

### 步骤 2：重启后端

```bash
cd backend
# 如果后端正在运行，先停止（Ctrl+C）
mvn spring-boot:run
```

### 步骤 3：测试功能

1. 访问：`http://localhost:5173/login`
2. 登录：`approver01` / `123456`
3. 点击"维护管理"菜单
4. 应该能看到所有维护记录（至少5条测试数据）

## 📊 预期结果

### 后端日志应该显示：
```
=== 维护记录查询权限检查 ===
用户名: approver01
权限列表: [ROLE_APPROVER]
  - ROLE_APPROVER
检查权限: ROLE_APPROVER -> true
是否是管理员或审批员: true
管理员/审批员权限：显示所有维护记录
=== 权限检查完成 ===
```

### 前端应该显示：
- ✅ 所有用户创建的维护记录
- ✅ 不同状态的记录（待审批、已通过、已拒绝）
- ✅ 至少 5 条测试数据

## 🔧 脚本功能

修复脚本会自动：
1. ✅ 检查并添加缺少的字段
2. ✅ 更新现有数据
3. ✅ 创建索引
4. ✅ 插入测试数据
5. ✅ 验证修复结果

## 📁 相关文件

- `backend/sql/DIAGNOSE_AND_FIX_APPROVER_ACCESS.sql` - 修复脚本（执行这个）
- `APPROVER_ISSUE_SOLUTION.md` - 详细解决方案文档
- `APPROVER_MAINTENANCE_DEBUG_GUIDE.md` - 调试指南

## 🆘 如果还有问题

1. 查看脚本执行输出（应该显示"✅ 数据库修复完成！"）
2. 查看后端日志（确认权限检查输出）
3. 清除浏览器缓存并重新登录
4. 参考 `APPROVER_ISSUE_SOLUTION.md` 获取详细帮助

---

**就这么简单！3步搞定！** 🚀
