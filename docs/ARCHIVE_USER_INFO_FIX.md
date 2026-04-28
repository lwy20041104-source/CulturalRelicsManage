# 档案管理用户信息修复

## 问题描述
档案管理模块中，创建人、操作人、上传人显示的是用户名（username）而不是真实姓名（real_name），并且缺少用户ID的记录。

### 具体问题
1. **relic_archive表**
   - `created_by` 字段未记录创建人ID
   - `created_by_name` 字段记录的是username，而不是real_name

2. **archive_history表**
   - `operator_id` 字段未记录操作人ID
   - `operator_name` 字段记录的是username，而不是real_name

3. **archive_document表**
   - `uploader_id` 字段未记录上传人ID
   - `uploader_name` 字段记录的是username，而不是real_name

## 修复方案

### 1. 注入用户服务
在 `RelicArchiveServiceImpl.java` 中注入 `SysUserService`：

```java
@Autowired
private com.example.service.SysUserService sysUserService;
```

### 2. 修改创建档案逻辑
在 `createArchive` 方法中，通过username获取完整用户信息：

**修改前**:
```java
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth != null) {
    archive.setCreatedByName(auth.getName());
}
```

**修改后**:
```java
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth != null) {
    String username = auth.getName();
    SysUser user = sysUserService.getUserByUsername(username);
    if (user != null) {
        archive.setCreatedBy(user.getId());  // 设置用户ID
        archive.setCreatedByName(user.getRealName() != null ? user.getRealName() : username);  // 优先使用真实姓名
    } else {
        archive.setCreatedByName(username);  // 降级处理
    }
}
```

### 3. 修改上传文档逻辑
在 `uploadDocument` 方法中：

**修改前**:
```java
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth != null) {
    document.setUploaderName(auth.getName());
}
```

**修改后**:
```java
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth != null) {
    String username = auth.getName();
    SysUser user = sysUserService.getUserByUsername(username);
    if (user != null) {
        document.setUploaderId(user.getId());  // 设置用户ID
        document.setUploaderName(user.getRealName() != null ? user.getRealName() : username);  // 优先使用真实姓名
    } else {
        document.setUploaderName(username);  // 降级处理
    }
}
```

### 4. 修改记录历史逻辑
在 `recordHistory` 方法中：

**修改前**:
```java
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth != null) {
    history.setOperatorName(auth.getName());
}
```

**修改后**:
```java
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth != null) {
    String username = auth.getName();
    SysUser user = sysUserService.getUserByUsername(username);
    if (user != null) {
        history.setOperatorId(user.getId());  // 设置用户ID
        history.setOperatorName(user.getRealName() != null ? user.getRealName() : username);  // 优先使用真实姓名
    } else {
        history.setOperatorName(username);  // 降级处理
    }
}
```

## 修复效果

### 修复前
- 创建人显示：`admin`（username）
- 操作人显示：`curator1`（username）
- 上传人显示：`admin`（username）
- 用户ID字段：`NULL`

### 修复后
- 创建人显示：`系统管理员`（real_name）
- 操作人显示：`张三`（real_name）
- 上传人显示：`李四`（real_name）
- 用户ID字段：正确记录用户ID

### 降级处理
如果用户的 `real_name` 为空，则使用 `username` 作为显示名称，确保系统稳定性。

## 数据库字段说明

### relic_archive表
```sql
CREATE TABLE `relic_archive` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_by` bigint DEFAULT NULL COMMENT '创建人ID',
  `created_by_name` varchar(100) DEFAULT NULL COMMENT '创建人姓名',
  -- 其他字段...
  PRIMARY KEY (`id`)
);
```

### archive_history表
```sql
CREATE TABLE `archive_history` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `operator_id` bigint DEFAULT NULL COMMENT '操作人ID',
  `operator_name` varchar(100) DEFAULT NULL COMMENT '操作人姓名',
  -- 其他字段...
  PRIMARY KEY (`id`)
);
```

### archive_document表
```sql
CREATE TABLE `archive_document` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `uploader_id` bigint DEFAULT NULL COMMENT '上传人ID',
  `uploader_name` varchar(100) DEFAULT NULL COMMENT '上传人姓名',
  -- 其他字段...
  PRIMARY KEY (`id`)
);
```

## 测试验证

### 测试步骤
1. **创建档案**
   - 使用admin账号登录（real_name: 系统管理员）
   - 创建新档案
   - 查看档案列表，创建人应显示"系统管理员"

2. **上传文档**
   - 使用curator1账号登录（real_name: 张三）
   - 进入档案详情页
   - 上传文档
   - 查看文档列表，上传人应显示"张三"

3. **查看历史记录**
   - 进入档案详情页
   - 查看操作历史
   - 操作人应显示真实姓名

4. **数据库验证**
   ```sql
   -- 查看档案创建人信息
   SELECT id, archive_code, created_by, created_by_name 
   FROM relic_archive 
   ORDER BY id DESC LIMIT 5;
   
   -- 查看文档上传人信息
   SELECT id, document_name, uploader_id, uploader_name 
   FROM archive_document 
   ORDER BY id DESC LIMIT 5;
   
   -- 查看历史操作人信息
   SELECT id, operation_type, operator_id, operator_name 
   FROM archive_history 
   ORDER BY id DESC LIMIT 5;
   ```

### 预期结果
- 所有的 `*_id` 字段应该有正确的用户ID值
- 所有的 `*_name` 字段应该显示用户的真实姓名（real_name）
- 如果用户没有设置real_name，则显示username

## 用户信息获取流程

```
1. 获取Authentication对象
   ↓
2. 从Authentication获取username
   ↓
3. 通过SysUserService.getUserByUsername(username)获取完整用户信息
   ↓
4. 从SysUser对象中获取id和realName
   ↓
5. 设置到实体对象中
   - 优先使用realName
   - 如果realName为空，使用username
   - 同时设置userId
```

## 相关文件

### 后端文件
- `backend/src/main/java/com/example/service/impl/RelicArchiveServiceImpl.java` - 修改用户信息获取逻辑
- `backend/src/main/java/com/example/entity/SysUser.java` - 用户实体类
- `backend/src/main/java/com/example/service/SysUserService.java` - 用户服务接口

### 数据库表
- `relic_archive` - 档案主表
- `archive_document` - 档案文档表
- `archive_history` - 档案历史表
- `sys_user` - 系统用户表

## 注意事项

1. **性能考虑**
   - 每次创建档案、上传文档、记录历史都会查询一次用户表
   - 如果性能成为问题，可以考虑在Authentication中缓存用户信息
   - 或者使用Redis缓存用户信息

2. **降级处理**
   - 如果用户服务不可用或用户不存在，使用username作为降级方案
   - 确保系统在异常情况下仍能正常运行

3. **数据一致性**
   - 用户ID和用户姓名应该保持一致
   - 如果用户修改了real_name，历史记录中的姓名不会自动更新（这是正常的，保留历史快照）

4. **空值处理**
   - 如果用户的real_name为NULL，使用username
   - 如果用户不存在，只设置username，不设置userId

## 编译状态
- ✅ 后端编译成功
- ✅ 用户信息获取逻辑已修复

## 修复时间
2026-04-24
