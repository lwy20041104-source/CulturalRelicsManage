# 文物图片关联功能（一对一）

## 功能概述

本功能实现了 `image_library` 表和 `cultural_relic` 表的一对一关联，确保：
- 一个文物只能关联一张主图片
- 一张图片只能作为一个文物的主图

## 已完成的工作

### 1. 数据库层
- **SQL脚本**: `backend/sql/relic_image_relation.sql`
  - 创建 `relic_image_relation` 表（一对一关联，两个字段都是UNIQUE）
  - 创建视图 `v_relic_with_image`（方便查询文物及其图片信息）
  - 创建存储过程：
    - `sp_set_relic_main_image(relicId, imageId)` - 设置文物主图
    - `sp_remove_relic_main_image(relicId)` - 移除文物主图
  - 创建函数 `fn_get_relic_image_path(relicId)` - 获取文物图片路径
  - 创建触发器自动删除关联（当文物或图片被删除时）

### 2. 后端实现
- **实体类**: `RelicImageRelation.java`
- **Mapper**: `RelicImageRelationMapper.java`（使用MyBatis注解）
- **Service接口**: `RelicImageRelationService.java`
- **Service实现**: `RelicImageRelationServiceImpl.java`
- **Controller**: `RelicImageRelationController.java`（13个REST API接口）
- **权限配置**: 已在 `SecurityConfig.java` 中配置 `/relic-images/**` 接口权限（ADMIN和CURATOR）

### 3. 编译状态
✅ 后端代码已成功编译打包

## 下一步操作

### 步骤1: 执行SQL脚本创建数据库表

```bash
# 在MySQL中执行
mysql -u root -p1234 cultural_relics < backend/sql/relic_image_relation.sql
```

或者在MySQL客户端中：
```sql
USE cultural_relics;
SOURCE backend/sql/relic_image_relation.sql;
```

### 步骤2: 重启后端服务

后端已重新编译，需要重启服务以加载新代码：

```bash
# 停止当前运行的后端服务
# 然后启动新编译的jar包
cd backend/target
java -jar cultural-relics-manage-1.0.0.jar
```

### 步骤3: 测试API接口

#### 3.1 设置文物主图
```http
POST /api/relic-images/set?relicId=1&imageId=1
Authorization: Bearer <your-token>
```

#### 3.2 获取文物主图信息
```http
GET /api/relic-images/relic/1
Authorization: Bearer <your-token>
```

#### 3.3 获取文物主图路径
```http
GET /api/relic-images/relic/1/path
Authorization: Bearer <your-token>
```

#### 3.4 移除文物主图
```http
DELETE /api/relic-images/remove/1
Authorization: Bearer <your-token>
```

#### 3.5 获取统计信息
```http
GET /api/relic-images/statistics
Authorization: Bearer <your-token>
```

## API接口列表

| 方法 | 路径 | 说明 |
|------|------|------|
| POST | `/relic-images/set` | 设置文物主图 |
| DELETE | `/relic-images/remove/{relicId}` | 移除文物主图 |
| GET | `/relic-images/relic/{relicId}` | 获取文物主图信息 |
| GET | `/relic-images/relic/{relicId}/path` | 获取文物主图路径 |
| POST | `/relic-images/batch/paths` | 批量获取文物图片路径 |
| GET | `/relic-images/relic/{relicId}/has-image` | 检查文物是否有主图 |
| GET | `/relic-images/image/{imageId}/is-linked` | 检查图片是否已关联 |
| GET | `/relic-images/all` | 获取所有关联记录 |
| GET | `/relic-images/statistics` | 获取统计信息 |

## 数据库表结构

```sql
CREATE TABLE relic_image_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_id BIGINT NOT NULL UNIQUE,      -- 文物ID（唯一）
    image_id BIGINT NOT NULL UNIQUE,      -- 图片ID（唯一）
    relation_type VARCHAR(20) DEFAULT 'main',
    sort_order INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (relic_id) REFERENCES cultural_relic(id) ON DELETE CASCADE,
    FOREIGN KEY (image_id) REFERENCES image_library(id) ON DELETE CASCADE
);
```

## 使用示例

### 在Java代码中使用

```java
@Autowired
private RelicImageRelationService relationService;

// 设置文物主图
boolean success = relationService.setRelicMainImage(1L, 1L);

// 获取文物主图路径
String imagePath = relationService.getRelicImagePath(1L);

// 批量获取文物图片路径
List<Long> relicIds = Arrays.asList(1L, 2L, 3L);
Map<Long, String> paths = relationService.getRelicImagePaths(relicIds);

// 检查文物是否有主图
boolean hasImage = relationService.hasMainImage(1L);

// 获取统计信息
int withImage = relationService.countRelicsWithImage();
int withoutImage = relationService.countRelicsWithoutImage();
```

### 在SQL中使用

```sql
-- 使用存储过程设置主图
CALL sp_set_relic_main_image(1, 1);

-- 使用函数获取图片路径
SELECT id, relic_name, fn_get_relic_image_path(id) as image_path 
FROM cultural_relic;

-- 使用视图查询文物及其图片
SELECT * FROM v_relic_with_image WHERE relic_id = 1;

-- 查询所有有主图的文物
SELECT * FROM v_relic_with_image WHERE image_id IS NOT NULL;

-- 查询所有没有主图的文物
SELECT * FROM v_relic_with_image WHERE image_id IS NULL;
```

## 后续集成建议

### 1. 修改文物查询服务

在 `CulturalRelicServiceImpl.java` 中，可以使用关联表获取图片路径：

```java
@Autowired
private RelicImageRelationService relationService;

// 在查询文物列表时，批量获取图片路径
public List<CulturalRelic> listRelics() {
    List<CulturalRelic> relics = relicMapper.selectAll();
    
    // 获取所有文物ID
    List<Long> relicIds = relics.stream()
        .map(CulturalRelic::getId)
        .collect(Collectors.toList());
    
    // 批量获取图片路径
    Map<Long, String> imagePaths = relationService.getRelicImagePaths(relicIds);
    
    // 设置图片路径
    relics.forEach(relic -> {
        String imagePath = imagePaths.get(relic.getId());
        if (imagePath != null) {
            relic.setImagePath(imagePath);
        }
    });
    
    return relics;
}
```

### 2. 前端集成

创建前端API文件 `frontend/src/api/relicImages.js`：

```javascript
import request from '@/utils/request'

// 设置文物主图
export function setRelicMainImageApi(relicId, imageId) {
  return request({
    url: '/relic-images/set',
    method: 'post',
    params: { relicId, imageId }
  })
}

// 获取文物主图路径
export function getRelicImagePathApi(relicId) {
  return request({
    url: `/relic-images/relic/${relicId}/path`,
    method: 'get'
  })
}

// 移除文物主图
export function removeRelicMainImageApi(relicId) {
  return request({
    url: `/relic-images/remove/${relicId}`,
    method: 'delete'
  })
}

// 获取统计信息
export function getRelicImageStatisticsApi() {
  return request({
    url: '/relic-images/statistics',
    method: 'get'
  })
}
```

### 3. 在文物管理页面中使用

在 `RelicsView.vue` 中添加设置主图的功能：

```vue
<template>
  <!-- 在文物列表中添加"设置主图"按钮 -->
  <el-button @click="showImageSelector(relic)">设置主图</el-button>
</template>

<script>
import { setRelicMainImageApi } from '@/api/relicImages'

export default {
  methods: {
    async setMainImage(relicId, imageId) {
      try {
        await setRelicMainImageApi(relicId, imageId)
        this.$message.success('设置主图成功')
        this.loadRelics() // 重新加载列表
      } catch (error) {
        this.$message.error('设置主图失败')
      }
    }
  }
}
</script>
```

## 权限说明

- **ADMIN（管理员）**: 拥有所有权限
- **CURATOR（保管员）**: 拥有所有权限
- **APPROVER（审批员）**: 无权限
- **LOANER（借展人）**: 无权限

## 注意事项

1. **一对一约束**: 系统会自动确保一个文物只有一张主图，一张图片只关联一个文物
2. **级联删除**: 删除文物或图片时，关联记录会自动删除
3. **事务处理**: 设置和移除主图操作都使用了事务，确保数据一致性
4. **权限控制**: 只有ADMIN和CURATOR角色可以操作文物图片关联

## 文件清单

### 后端文件
- `backend/sql/relic_image_relation.sql` - 数据库脚本
- `backend/src/main/java/com/example/entity/RelicImageRelation.java` - 实体类
- `backend/src/main/java/com/example/mapper/RelicImageRelationMapper.java` - Mapper
- `backend/src/main/java/com/example/service/RelicImageRelationService.java` - Service接口
- `backend/src/main/java/com/example/service/impl/RelicImageRelationServiceImpl.java` - Service实现
- `backend/src/main/java/com/example/controller/RelicImageRelationController.java` - Controller
- `backend/src/main/java/com/example/config/SecurityConfig.java` - 权限配置（已更新）

### 待创建的前端文件
- `frontend/src/api/relicImages.js` - API接口（建议创建）
- 在现有页面中集成关联功能（建议）

## 测试建议

1. 测试设置文物主图
2. 测试一对一约束（尝试为同一文物设置多张图片）
3. 测试一对一约束（尝试将同一图片关联到多个文物）
4. 测试移除主图
5. 测试级联删除（删除文物或图片时，关联是否自动删除）
6. 测试批量查询性能
7. 测试权限控制（不同角色的访问权限）

## 完成状态

- ✅ 数据库表设计
- ✅ 后端实体类
- ✅ 后端Mapper
- ✅ 后端Service
- ✅ 后端Controller
- ✅ 权限配置
- ✅ 后端编译
- ⏳ 执行SQL脚本（需要用户操作）
- ⏳ 重启后端服务（需要用户操作）
- ⏳ 前端API集成（可选）
- ⏳ 前端页面集成（可选）
- ⏳ 测试验证（需要用户操作）
