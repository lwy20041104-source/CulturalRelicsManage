# 文物图片关联功能集成文档

## 概述

本文档说明如何将文物管理系统从直接存储图片路径的方式，迁移到使用 `image_library` 和 `relic_image_relation` 表进行图片管理的新架构。

## 数据库架构变更

### 核心表结构

1. **image_library** - 图片库表
   - 存储所有图片的元数据和文件路径
   - 支持图片分类、标签、描述等丰富信息
   - 记录上传者、浏览次数、下载次数等统计信息

2. **relic_image_relation** - 文物图片关联表
   - 建立文物与图片的一对一关联
   - 支持关联类型（main:主图, detail:详情图等）
   - 通过外键约束确保数据一致性

3. **cultural_relic** - 文物表
   - 保留 `image_path` 字段用于向后兼容
   - 新的查询会通过关联表获取图片路径

### 数据库视图

创建了 `v_relic_with_image` 视图，方便查询文物及其主图信息：

```sql
SELECT * FROM v_relic_with_image WHERE relic_id = 1;
```

## 后端实现

### 新增的Service和Mapper

#### 1. RelicImageRelationService

提供文物图片关联的核心功能：

```java
// 为文物上传并设置主图
String uploadAndSetRelicMainImage(Long relicId, MultipartFile file, Long uploaderId, String uploaderName);

// 为文物设置主图（从已有图片库中选择）
boolean setRelicMainImage(Long relicId, Long imageId);

// 移除文物主图
boolean removeRelicMainImage(Long relicId);

// 获取文物的主图路径
String getRelicImagePath(Long relicId);

// 批量获取文物的图片路径
Map<Long, String> getRelicImagePaths(List<Long> relicIds);
```

#### 2. RelicImageRelationMapper

提供数据库操作接口：

```java
// 根据文物ID查询关联（包含图片信息）
RelicImageRelation selectByRelicIdWithImage(Long relicId);

// 批量查询文物的图片路径
Map<Long, Map<String, Object>> selectImagePathsByRelicIds(List<Long> relicIds);

// 统计有主图和无主图的文物数量
int countRelicsWithImage();
int countRelicsWithoutImage();
```

### 修改的Mapper查询

#### CulturalRelicMapper.xml

所有查询文物的SQL都已修改为自动关联图片信息：

```xml
<select id="selectPage" resultType="com.example.entity.CulturalRelic">
    SELECT cr.*, c.category_name AS categoryName, i.file_path AS imagePath
    FROM cultural_relic cr
    LEFT JOIN cultural_relic_category c ON cr.category_id = c.id
    LEFT JOIN relic_image_relation rir ON cr.id = rir.relic_id
    LEFT JOIN image_library i ON rir.image_id = i.id AND i.status = 1
    ...
</select>
```

这样查询文物时，`imagePath` 字段会自动填充为关联图片的路径。

### 新增的Controller

#### RelicImageRelationController

提供RESTful API接口：

- `POST /relic-images/upload/{relicId}` - 上传文物主图
- `POST /relic-images/set` - 设置文物主图
- `DELETE /relic-images/remove/{relicId}` - 移除文物主图
- `GET /relic-images/relic/{relicId}` - 获取文物主图信息
- `GET /relic-images/path/{relicId}` - 获取文物主图路径
- `POST /relic-images/paths` - 批量获取文物图片路径
- `GET /relic-images/statistics` - 统计有主图和无主图的文物数量

### 修改的Controller

#### CulturalRelicController

上传图片接口已修改为使用新的关联服务：

```java
@PostMapping("/{id}/images")
public Result<String> uploadImage(@PathVariable Long id, @RequestParam("file") MultipartFile file) {
    // 使用新的关联服务上传图片
    String path = relicImageRelationService.uploadAndSetRelicMainImage(id, file, uploaderId, uploaderName);
    return Result.success("上传成功", path);
}
```

## 前端实现

### 新增的API文件

#### relicImages.js

提供文物图片关联的前端API：

```javascript
// 为文物上传并设置主图
export const uploadRelicImageApi = (relicId, file) => { ... }

// 为文物设置主图（从已有图片库中选择）
export const setRelicMainImageApi = (relicId, imageId) => { ... }

// 移除文物主图
export const removeRelicMainImageApi = (relicId) => { ... }

// 获取文物的主图信息
export const getRelicMainImageApi = (relicId) => { ... }

// 批量获取文物的图片路径
export const getRelicImagePathsApi = (relicIds) => { ... }

// 统计有主图和无主图的文物数量
export const getRelicImageStatisticsApi = () => { ... }
```

### 修改的API文件

#### relics.js

添加了上传文物图片的接口：

```javascript
// 上传文物图片（使用新的关联方式）
export const uploadRelicImageApi = (id, file) => { ... }
```

## 使用示例

### 后端使用示例

#### 1. 为文物上传主图

```java
@Autowired
private RelicImageRelationService relicImageRelationService;

public void uploadImage(Long relicId, MultipartFile file) {
    String imagePath = relicImageRelationService.uploadAndSetRelicMainImage(
        relicId, file, currentUserId, currentUserName);
    System.out.println("图片已上传: " + imagePath);
}
```

#### 2. 查询文物时自动获取图片

```java
@Autowired
private CulturalRelicMapper culturalRelicMapper;

public CulturalRelic getRelicWithImage(Long id) {
    // 查询结果会自动包含图片路径
    CulturalRelic relic = culturalRelicMapper.selectById(id);
    System.out.println("文物图片: " + relic.getImagePath());
    return relic;
}
```

#### 3. 批量获取文物图片路径

```java
List<Long> relicIds = Arrays.asList(1L, 2L, 3L);
Map<Long, String> imagePaths = relicImageRelationService.getRelicImagePaths(relicIds);
imagePaths.forEach((relicId, path) -> {
    System.out.println("文物" + relicId + "的图片: " + path);
});
```

### 前端使用示例

#### 1. 上传文物图片

```javascript
import { uploadRelicImageApi } from '@/api/relicImages'

async function handleUpload(relicId, file) {
  try {
    const response = await uploadRelicImageApi(relicId, file)
    console.log('上传成功:', response.data)
    // 刷新文物列表
    await loadRelics()
  } catch (error) {
    console.error('上传失败:', error)
  }
}
```

#### 2. 显示文物图片

```vue
<template>
  <div>
    <img v-if="relic.imagePath" :src="getImageUrl(relic.imagePath)" />
    <span v-else>暂无图片</span>
  </div>
</template>

<script>
export default {
  methods: {
    getImageUrl(path) {
      return `${import.meta.env.VITE_API_BASE_URL}${path}`
    }
  }
}
</script>
```

#### 3. 从图片库选择图片

```javascript
import { setRelicMainImageApi } from '@/api/relicImages'

async function selectImageFromLibrary(relicId, imageId) {
  try {
    await setRelicMainImageApi(relicId, imageId)
    console.log('设置成功')
    // 刷新文物信息
    await loadRelicDetail(relicId)
  } catch (error) {
    console.error('设置失败:', error)
  }
}
```

## 数据迁移

如果系统中已有文物数据，需要进行数据迁移：

### 1. 迁移现有图片到图片库

```sql
-- 将 cultural_relic 表中的图片路径迁移到 image_library
INSERT INTO image_library (image_name, original_name, file_path, category, 
                          reference_type, reference_id, status, create_time, update_time)
SELECT 
    CONCAT('relic_', id, '.jpg') as image_name,
    CONCAT('relic_', id, '.jpg') as original_name,
    image_path as file_path,
    'relic' as category,
    'relic' as reference_type,
    id as reference_id,
    1 as status,
    create_time,
    update_time
FROM cultural_relic
WHERE image_path IS NOT NULL AND image_path != '';
```

### 2. 建立关联关系

```sql
-- 为已迁移的图片建立关联
INSERT INTO relic_image_relation (relic_id, image_id, relation_type, create_time, update_time)
SELECT 
    cr.id as relic_id,
    il.id as image_id,
    'main' as relation_type,
    NOW() as create_time,
    NOW() as update_time
FROM cultural_relic cr
JOIN image_library il ON il.reference_id = cr.id AND il.reference_type = 'relic'
WHERE cr.image_path IS NOT NULL AND cr.image_path != '';
```

## 优势

### 1. 统一的图片管理

- 所有图片集中存储在 `image_library` 表
- 支持图片分类、标签、描述等元数据
- 便于图片的统一管理和检索

### 2. 灵活的关联关系

- 支持一对一、一对多等多种关联方式
- 可以为文物添加多张图片（主图、详情图等）
- 一张图片可以被多个模块引用

### 3. 丰富的统计功能

- 统计图片的浏览次数、下载次数
- 按分类、上传者等维度统计
- 统计有图和无图的文物数量

### 4. 更好的数据一致性

- 通过外键约束确保数据一致性
- 删除文物时自动删除关联关系
- 删除图片时自动删除关联关系

### 5. 向后兼容

- 保留 `cultural_relic.image_path` 字段
- 查询时自动填充图片路径
- 现有代码无需大量修改

## 注意事项

1. **文件存储**：图片文件仍然存储在文件系统中，`image_library` 只存储路径
2. **事务处理**：上传图片和建立关联使用事务确保一致性
3. **权限控制**：需要根据用户权限控制图片的上传、删除等操作
4. **性能优化**：对于大量文物的查询，建议使用批量获取图片路径的接口
5. **图片清理**：定期清理未被引用的图片文件

## 后续扩展

1. **多图支持**：修改关联表的唯一约束，支持一个文物关联多张图片
2. **图片压缩**：上传时自动生成缩略图，提高加载速度
3. **图片水印**：为公开的图片添加水印
4. **图片审核**：添加图片审核流程，确保图片质量
5. **CDN集成**：将图片存储到CDN，提高访问速度

## 相关文档

- [文物图片关联表设计](./RELIC_IMAGE_RELATION_FEATURE.md)
- [图片管理功能](./IMAGE_MANAGEMENT_FEATURE.md)
- [数据库设计文档](../backend/sql/relic_image_relation.sql)
