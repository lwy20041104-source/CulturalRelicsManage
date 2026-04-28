# 文物图片关联功能更新日志

## 版本 2.0.0 - 2025-04-23

### 重大变更

#### 数据库架构升级

1. **新增表结构**
   - `image_library` - 图片库表，统一管理所有图片
   - `relic_image_relation` - 文物图片关联表，建立一对一关联
   - `v_relic_with_image` - 视图，方便查询文物及其主图

2. **存储过程和函数**
   - `sp_set_relic_main_image` - 为文物设置主图
   - `sp_remove_relic_main_image` - 移除文物主图
   - `fn_get_relic_image_path` - 获取文物主图路径

3. **触发器**
   - `tr_delete_relic_image_relation` - 删除文物时自动删除关联
   - `tr_delete_image_relic_relation` - 删除图片时自动删除关联

#### 后端实现

1. **新增Service**
   - `RelicImageRelationService` - 文物图片关联服务接口
   - `RelicImageRelationServiceImpl` - 服务实现类

2. **新增Mapper**
   - `RelicImageRelationMapper` - 文物图片关联数据访问接口
   - 提供查询、插入、更新、删除等操作

3. **新增Controller**
   - `RelicImageRelationController` - 文物图片关联REST API
   - 提供上传、设置、移除、查询等接口

4. **修改Mapper查询**
   - `CulturalRelicMapper.xml` - 所有查询自动关联图片信息
   - `selectPage` - 分页查询时包含图片路径
   - `selectById` - 单个查询时包含图片路径
   - `selectAll` - 全部查询时包含图片路径
   - `selectAvailableForRepair` - 可修复文物查询时包含图片路径

5. **修改Controller**
   - `CulturalRelicController` - 上传图片接口使用新的关联服务

#### 前端实现

1. **新增API文件**
   - `frontend/src/api/relicImages.js` - 文物图片关联API
   - 提供上传、设置、移除、查询等方法

2. **更新API文件**
   - `frontend/src/api/relics.js` - 添加上传图片接口

3. **新增组件**
   - `RelicImageUpload.vue` - 文物图片上传组件
   - 支持直接上传和从图片库选择

### 新增功能

#### 1. 统一图片管理

- 所有图片集中存储在 `image_library` 表
- 支持图片分类、标签、描述等元数据
- 记录上传者、浏览次数、下载次数等统计信息

#### 2. 灵活的关联方式

- 支持一对一关联（当前实现）
- 预留扩展为一对多的可能性
- 支持多种关联类型（main、detail等）

#### 3. 丰富的查询接口

- 获取文物的主图信息
- 批量获取文物图片路径
- 根据图片ID查询关联的文物
- 统计有主图和无主图的文物数量

#### 4. 完善的事务处理

- 上传图片和建立关联使用事务
- 删除时自动清理关联关系
- 确保数据一致性

### API变更

#### 新增接口

**文物图片关联**

```
POST   /relic-images/upload/{relicId}     - 上传文物主图
POST   /relic-images/set                  - 设置文物主图
DELETE /relic-images/remove/{relicId}     - 移除文物主图
GET    /relic-images/relic/{relicId}      - 获取文物主图信息
GET    /relic-images/path/{relicId}       - 获取文物主图路径
POST   /relic-images/paths                - 批量获取文物图片路径
GET    /relic-images/image/{imageId}      - 根据图片ID查询关联的文物
GET    /relic-images/statistics           - 统计有主图和无主图的文物数量
GET    /relic-images/all                  - 查询所有关联
```

#### 修改接口

**文物管理**

```
POST /relics/{id}/images - 上传文物图片（内部实现改为使用关联服务）
```

**文物查询**

所有文物查询接口返回的数据中，`imagePath` 字段现在通过关联表获取：

```
GET /relics           - 分页查询文物（包含图片路径）
GET /relics/{id}      - 查询单个文物（包含图片路径）
```

### 数据迁移

如果系统中已有文物数据，需要执行以下迁移步骤：

1. **备份数据**
   ```sql
   -- 备份 cultural_relic 表
   CREATE TABLE cultural_relic_backup AS SELECT * FROM cultural_relic;
   ```

2. **迁移图片到图片库**
   ```sql
   -- 执行迁移脚本（见文档）
   ```

3. **建立关联关系**
   ```sql
   -- 执行关联脚本（见文档）
   ```

4. **验证数据**
   ```sql
   -- 检查迁移结果
   SELECT COUNT(*) FROM relic_image_relation;
   ```

### 向后兼容

1. **保留字段**
   - `cultural_relic.image_path` 字段保留
   - 查询时自动填充为关联图片的路径
   - 现有代码无需修改

2. **API兼容**
   - 原有的上传接口 `POST /relics/{id}/images` 仍然可用
   - 内部实现改为使用新的关联服务

3. **前端兼容**
   - 文物对象的 `imagePath` 属性仍然可用
   - 显示图片的代码无需修改

### 性能优化

1. **批量查询**
   - 提供批量获取图片路径的接口
   - 减少数据库查询次数

2. **索引优化**
   - `relic_image_relation` 表添加索引
   - 提高关联查询性能

3. **缓存支持**
   - 预留缓存接口
   - 可以缓存常用的图片路径

### 安全性增强

1. **权限控制**
   - 上传图片需要登录
   - 记录上传者信息

2. **文件验证**
   - 验证文件类型
   - 限制文件大小

3. **事务保护**
   - 使用事务确保数据一致性
   - 失败时自动回滚

### 已知问题

1. **图片清理**
   - 删除关联后，图片文件不会自动删除
   - 需要定期清理未被引用的图片文件

2. **并发控制**
   - 同时上传多张图片可能导致竞争
   - 建议前端控制上传顺序

### 后续计划

#### v2.1.0 - 多图支持

- 支持一个文物关联多张图片
- 区分主图和详情图
- 支持图片排序

#### v2.2.0 - 图片处理

- 自动生成缩略图
- 图片压缩和优化
- 添加水印功能

#### v2.3.0 - CDN集成

- 支持将图片上传到CDN
- 提高图片加载速度
- 降低服务器带宽压力

#### v2.4.0 - 图片审核

- 添加图片审核流程
- 支持图片质量检查
- 违规图片自动拦截

### 文档更新

1. **新增文档**
   - `RELIC_IMAGE_INTEGRATION.md` - 集成文档
   - `CHANGELOG_RELIC_IMAGE.md` - 更新日志

2. **更新文档**
   - `RELIC_IMAGE_RELATION_FEATURE.md` - 功能说明
   - `IMAGE_MANAGEMENT_FEATURE.md` - 图片管理

### 测试建议

1. **单元测试**
   - 测试 Service 层的各个方法
   - 测试 Mapper 层的查询语句

2. **集成测试**
   - 测试上传图片流程
   - 测试删除文物时的级联删除
   - 测试查询文物时的图片关联

3. **性能测试**
   - 测试批量查询的性能
   - 测试大量文物的分页查询

4. **前端测试**
   - 测试图片上传组件
   - 测试图片显示
   - 测试从图片库选择

### 升级步骤

1. **备份数据库**
   ```bash
   mysqldump -u root -p cultural_relics > backup.sql
   ```

2. **执行数据库脚本**
   ```bash
   mysql -u root -p cultural_relics < backend/sql/relic_image_relation.sql
   ```

3. **更新后端代码**
   ```bash
   cd backend
   mvn clean install
   ```

4. **更新前端代码**
   ```bash
   cd frontend
   npm install
   npm run build
   ```

5. **重启服务**
   ```bash
   # 重启后端服务
   # 重启前端服务
   ```

6. **验证功能**
   - 测试文物查询
   - 测试图片上传
   - 测试图片显示

### 回滚方案

如果升级后出现问题，可以按以下步骤回滚：

1. **恢复数据库**
   ```bash
   mysql -u root -p cultural_relics < backup.sql
   ```

2. **恢复代码**
   ```bash
   git checkout <previous-version>
   ```

3. **重启服务**

### 技术支持

如有问题，请联系开发团队或查看相关文档：

- 集成文档：`docs/RELIC_IMAGE_INTEGRATION.md`
- 功能说明：`docs/RELIC_IMAGE_RELATION_FEATURE.md`
- 数据库脚本：`backend/sql/relic_image_relation.sql`

---

**更新时间**: 2025-04-23  
**版本**: 2.0.0  
**作者**: 开发团队
