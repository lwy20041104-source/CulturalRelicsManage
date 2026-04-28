# 文物图片关联功能 - 快速开始

## 🎯 功能说明

实现了文物与图片的**一对一关联**：
- 一个文物只能有一张主图
- 一张图片只能关联一个文物

## ✅ 已完成

1. ✅ 数据库表设计和SQL脚本
2. ✅ 后端完整实现（Entity、Mapper、Service、Controller）
3. ✅ 权限配置（ADMIN和CURATOR可访问）
4. ✅ 后端编译成功

## 📋 下一步操作（3步）

### 第1步：执行SQL脚本

在MySQL中执行以下命令创建关联表：

```bash
mysql -u root -p1234 cultural_relics < backend/sql/relic_image_relation.sql
```

或在MySQL客户端中：
```sql
USE cultural_relics;
SOURCE backend/sql/relic_image_relation.sql;
```

### 第2步：重启后端服务

```bash
# 停止当前运行的后端服务（Ctrl+C）
# 然后启动新编译的jar包
cd backend/target
java -jar cultural-relics-manage-1.0.0.jar
```

### 第3步：测试API

使用Postman或其他工具测试：

```http
# 设置文物主图（文物ID=1，图片ID=1）
POST http://localhost:8080/api/relic-images/set?relicId=1&imageId=1
Authorization: Bearer <your-token>

# 获取文物主图路径
GET http://localhost:8080/api/relic-images/relic/1/path
Authorization: Bearer <your-token>

# 获取统计信息
GET http://localhost:8080/api/relic-images/statistics
Authorization: Bearer <your-token>
```

## 📚 API接口速查

| 接口 | 说明 |
|------|------|
| `POST /relic-images/set?relicId=X&imageId=Y` | 设置文物主图 |
| `DELETE /relic-images/remove/{relicId}` | 移除文物主图 |
| `GET /relic-images/relic/{relicId}` | 获取文物主图信息 |
| `GET /relic-images/relic/{relicId}/path` | 获取文物主图路径 |
| `GET /relic-images/statistics` | 获取统计信息 |

## 🔐 权限

- **ADMIN（管理员）**: ✅ 完全访问
- **CURATOR（保管员）**: ✅ 完全访问
- **APPROVER（审批员）**: ❌ 无权限
- **LOANER（借展人）**: ❌ 无权限

## 📖 详细文档

查看完整文档：`docs/RELIC_IMAGE_RELATION_FEATURE.md`

## 🔍 验证成功的标志

1. SQL脚本执行后，数据库中有 `relic_image_relation` 表
2. 后端启动无错误
3. 调用API接口返回正常响应
4. 设置主图后，可以通过API获取到图片路径

## ⚠️ 注意事项

- 确保 `image_library` 和 `cultural_relic` 表已存在
- 设置主图时，文物ID和图片ID必须存在
- 一对一约束会自动处理：设置新主图时会自动删除旧关联
