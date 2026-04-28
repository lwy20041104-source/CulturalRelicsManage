# 修复：添加 selectByRoleCode 方法

## 问题描述

后端编译错误：
```
java: 找不到符号
符号:   方法 selectByRoleCode(java.lang.String)
位置: 类型为com.example.mapper.SysRoleMapper的变量 sysRoleMapper
```

## 原因分析

在实现借展人注册功能时，`SysUserServiceImpl` 中调用了 `sysRoleMapper.selectByRoleCode("LOANER")` 方法，但 `SysRoleMapper` 接口中没有定义这个方法。

## 解决方案

在 `SysRoleMapper` 接口中添加 `selectByRoleCode` 方法。

### 修改文件

**文件**：`backend/src/main/java/com/example/mapper/SysRoleMapper.java`

**修改前**：
```java
@Mapper
public interface SysRoleMapper {
    SysRole selectById(@Param("id") Long id);
    List<SysRole> selectEnabledList();
}
```

**修改后**：
```java
@Mapper
public interface SysRoleMapper {
    SysRole selectById(@Param("id") Long id);
    List<SysRole> selectEnabledList();
    
    @Select("SELECT * FROM sys_role WHERE role_code = #{roleCode} AND status = 1 LIMIT 1")
    SysRole selectByRoleCode(@Param("roleCode") String roleCode);
}
```

## 方法说明

### selectByRoleCode

**功能**：根据角色代码查询角色信息

**参数**：
- `roleCode` - 角色代码（如 "ADMIN", "CURATOR", "LOANER" 等）

**返回值**：
- `SysRole` - 角色对象，如果不存在则返回 null

**SQL 查询**：
```sql
SELECT * FROM sys_role 
WHERE role_code = #{roleCode} 
  AND status = 1 
LIMIT 1
```

**查询条件**：
- `role_code` = 指定的角色代码
- `status` = 1（只查询启用的角色）
- `LIMIT 1`（只返回一条记录）

## 使用场景

### 1. 用户注册
在借展人注册时，需要获取借展人角色的ID：
```java
SysRole loanerRole = sysRoleMapper.selectByRoleCode("LOANER");
if (loanerRole == null) {
    throw new IllegalArgumentException("借展人角色不存在，请联系管理员");
}
user.setRoleId(loanerRole.getId());
```

### 2. 用户登录验证
验证用户的角色是否匹配：
```java
SysRole role = sysRoleMapper.selectByRoleCode(roleCode);
if (role == null || !roleCode.equals(role.getRoleCode())) {
    throw new IllegalArgumentException("账号与所选身份不匹配");
}
```

### 3. 权限检查
根据角色代码检查权限：
```java
SysRole role = sysRoleMapper.selectByRoleCode("ADMIN");
if (role != null) {
    // 执行管理员操作
}
```

## 测试验证

### 1. 编译测试
```bash
cd backend
mvn clean compile
```

**预期结果**：
- ✅ 编译成功，没有错误

### 2. 功能测试
```java
// 测试查询借展人角色
SysRole loanerRole = sysRoleMapper.selectByRoleCode("LOANER");
assertNotNull(loanerRole);
assertEquals("LOANER", loanerRole.getRoleCode());
assertEquals("文物借展人", loanerRole.getRoleName());

// 测试查询不存在的角色
SysRole nonExistRole = sysRoleMapper.selectByRoleCode("NONEXIST");
assertNull(nonExistRole);
```

### 3. 注册功能测试
1. 启动后端服务
2. 访问注册页面
3. 填写注册信息
4. 提交注册
5. **预期结果**：
   - ✅ 注册成功
   - ✅ 用户角色为借展人
   - ✅ 没有"借展人角色不存在"的错误

## 数据库准备

确保数据库中有借展人角色：

```sql
-- 查询借展人角色
SELECT * FROM sys_role WHERE role_code = 'LOANER';

-- 如果不存在，插入借展人角色
INSERT INTO sys_role (role_name, role_code, description, status, create_time, update_time)
VALUES ('文物借展人', 'LOANER', '可以申请借展文物', 1, NOW(), NOW());
```

## 相关文件

### 修改的文件
- `backend/src/main/java/com/example/mapper/SysRoleMapper.java` - 添加 selectByRoleCode 方法

### 使用该方法的文件
- `backend/src/main/java/com/example/service/impl/SysUserServiceImpl.java` - 注册功能中使用

## 注意事项

1. **角色代码大小写**：
   - 角色代码通常使用大写（如 "LOANER", "ADMIN"）
   - 查询时要确保大小写匹配

2. **角色状态**：
   - 只查询 `status = 1` 的启用角色
   - 禁用的角色不会被查询到

3. **返回值检查**：
   - 使用前要检查返回值是否为 null
   - 如果为 null，说明角色不存在或已禁用

4. **性能考虑**：
   - 使用 `LIMIT 1` 限制返回结果
   - 建议在 `role_code` 字段上创建索引

## 数据库索引建议

为了提高查询性能，建议在 `role_code` 字段上创建索引：

```sql
-- 创建索引
CREATE INDEX idx_role_code ON sys_role(role_code);

-- 或者创建唯一索引（如果角色代码唯一）
CREATE UNIQUE INDEX uk_role_code ON sys_role(role_code);
```

## 修改日期
2026-04-23

## 修改人员
Kiro AI Assistant
