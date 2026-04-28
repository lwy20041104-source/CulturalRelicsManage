# 审计日志显示真实姓名修复方案

## 问题描述

当前审计日志显示的是**用户名（username）**而不是**真实姓名（realName）**。

## 根本原因

所有Controller在调用`operationLogService.logDataChange()`时，传入的`operator`参数是从`authentication.getName()`获取的**username**，而不是从数据库查询的**realName**。

```java
// 错误代码
String username = authentication != null ? authentication.getName() : "系统";
operationLogService.logDataChange(
    userId,
    username,  // ❌ 这是用户名，不是真实姓名
    ...
);
```

## 解决方案

### 1. 创建UserContextUtil工具类

已创建`backend/src/main/java/com/example/util/UserContextUtil.java`，提供以下方法：

- `getCurrentUserRealName()` - 获取当前用户的真实姓名
- `getCurrentUsername()` - 获取当前用户的用户名
- `getCurrentUserId()` - 获取当前用户的ID
- `getCurrentUser()` - 获取当前用户的完整信息

### 2. 修改所有Controller

需要修改以下Controller，将获取username的代码替换为使用`UserContextUtil`：

#### 已修改的Controller（2个）
- ✅ CulturalRelicController
- ✅ SysUserController

#### 待修改的Controller（12个）

1. **LoanRecordController**（3个方法）
   - `approve()` - 审批借展申请
   - `returnLoan()` - 归还文物
   - `userReturnLoan()` - 用户主动归还

2. **RepairRecordController**（5个方法）
   - `approveRepair()` - 审批修复申请
   - `startRepair()` - 开始修复
   - `updateProgress()` - 更新修复进度
   - `completeRepair()` - 完成修复
   - `deleteById()` - 删除修复记录

3. **MuseumController**（2个方法）
   - `update()` - 修改博物馆信息
   - `delete()` - 删除博物馆

4. **CulturalRelicCategoryController**（2个方法）
   - `update()` - 修改文物分类
   - `delete()` - 删除文物分类

5. **MaintenanceRecordController**（2个方法）
   - `update()` - 修改保养记录
   - `delete()` - 删除保养记录

6. **RepairExpertController**（2个方法）
   - `update()` - 修改专家信息
   - `deleteById()` - 删除专家

7. **RepairMaterialController**（3个方法）
   - `updateMaterial()` - 更新修复材料
   - `deleteMaterial()` - 删除修复材料
   - `updateStock()` - 更新材料库存

8. **RelicArchiveController**（3个方法）
   - `update()` - 更新文物档案
   - `delete()` - 删除文物档案
   - `publish()` - 发布文物档案

9. **ImageLibraryController**（2个方法）
   - `updateImage()` - 更新图片信息
   - `deleteImage()` - 删除图片

10. **RelicImageRelationController**（2个方法）
    - `setRelicMainImage()` - 设置文物主图
    - `removeRelicMainImage()` - 移除文物主图

11. **BackupController**（2个方法）
    - `deleteBackup()` - 删除备份
    - `updateBackupConfig()` - 更新备份配置

12. **CulturalRelicController**（1个方法）
    - `batchUpdateStatus()` - 批量修改文物状态

### 3. 修改步骤

对于每个Controller：

#### 步骤1：添加UserContextUtil依赖

```java
private final com.example.util.UserContextUtil userContextUtil;

public XxxController(..., com.example.util.UserContextUtil userContextUtil) {
    ...
    this.userContextUtil = userContextUtil;
}
```

#### 步骤2：替换获取用户信息的代码

**替换前：**
```java
org.springframework.security.core.Authentication authentication = 
    org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication();
String username = authentication != null ? authentication.getName() : "系统";
Long userId = 1L;
```

**替换后：**
```java
String realName = userContextUtil.getCurrentUserRealName();
Long userId = userContextUtil.getCurrentUserId();
```

#### 步骤3：更新logDataChange调用

**替换前：**
```java
operationLogService.logDataChange(
    userId,
    username,  // ❌ 用户名
    ...
);
```

**替换后：**
```java
operationLogService.logDataChange(
    userId,
    realName,  // ✅ 真实姓名
    ...
);
```

## 批量修改命令

由于涉及的文件较多，建议使用以下步骤批量修改：

### 1. 查找所有需要修改的位置

```bash
cd backend
grep -r "authentication.getName()" src/main/java/com/example/controller/
```

### 2. 对每个Controller执行以下操作

1. 添加`UserContextUtil`依赖注入
2. 替换所有`authentication.getName()`为`userContextUtil.getCurrentUserRealName()`
3. 替换所有`Long userId = 1L;`为`Long userId = userContextUtil.getCurrentUserId();`

## 验证步骤

修改完成后：

1. **编译代码**
   ```bash
   cd backend
   mvn clean compile -DskipTests
   ```

2. **重启服务**
   ```bash
   mvn spring-boot:run
   ```

3. **测试操作**
   - 执行修改操作
   - 执行删除操作
   - 查看操作日志

4. **检查结果**
   - ✅ 操作人显示**真实姓名**（如"张明远"）
   - ✅ 操作状态显示**"成功"**
   - ✅ 日志详情显示**数据对比**

## 注意事项

1. **删除和新增操作没有数据对比**是正常的：
   - 删除操作：`afterData`为null（因为数据已删除）
   - 新增操作：`beforeData`为null（因为之前没有数据）
   - 只有**修改操作**才会显示完整的数据对比

2. **旧的@OperationLog注解**：
   - 已经移除了大部分注解
   - 保留的注解（如新增用户）会继续使用旧AOP记录日志
   - 旧AOP也会获取realName，所以显示正确

3. **编译顺序**：
   - 必须先创建`UserContextUtil.java`
   - 然后修改所有Controller
   - 最后编译整个项目

## 当前状态

- ✅ UserContextUtil已创建
- ✅ 编译成功（BUILD SUCCESS）
- ⏳ 需要修改剩余12个Controller
- ⏳ 需要重启服务测试

## 下一步

由于涉及的Controller较多，建议：
1. 先修改几个关键Controller（如LoanRecordController、RepairRecordController）
2. 测试验证
3. 确认无误后，再批量修改其他Controller
