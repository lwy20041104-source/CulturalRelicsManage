# 新增文物时自动处理图片功能

## 概述

本文档说明如何在新增文物时自动将图片存放到 `image_library` 表，并在 `relic_image_relation` 表中记录对应关系。

## 功能特性

### 1. 自动图片管理

- 新增文物时可以同时上传图片
- 图片自动存储到 `image_library` 表
- 自动建立文物与图片的关联关系
- 支持从图片库选择已有图片

### 2. 事务保护

- 文物保存和图片处理在同一事务中
- 任何步骤失败都会自动回滚
- 确保数据一致性

### 3. 灵活的图片来源

- **直接上传**：上传新图片文件
- **图片库选择**：从已有图片库中选择
- **可选操作**：图片不是必需的

## 后端实现

### 1. Service层

#### CulturalRelicService 接口

```java
/**
 * 保存文物并处理图片
 * @param relic 文物信息
 * @param imageFile 图片文件（可选）
 * @param imageId 图片ID（可选，从图片库选择）
 * @param uploaderId 上传者ID
 * @param uploaderName 上传者姓名
 * @return 保存后的文物ID
 */
Long saveWithImage(CulturalRelic relic, MultipartFile imageFile, Long imageId, 
                   Long uploaderId, String uploaderName) throws Exception;
```

#### CulturalRelicServiceImpl 实现

```java
@Override
@Transactional(rollbackFor = Exception.class)
public Long saveWithImage(CulturalRelic relic, MultipartFile imageFile, 
                         Long imageId, Long uploaderId, String uploaderName) throws Exception {
    // 1. 保存文物基本信息
    relic.setRelicCode(generateNextRelicCode());
    culturalRelicMapper.insert(relic);
    Long relicId = relic.getId();
    
    // 2. 处理图片
    if (imageFile != null && !imageFile.isEmpty()) {
        // 上传新图片并建立关联
        String imagePath = relicImageRelationService.uploadAndSetRelicMainImage(
            relicId, imageFile, uploaderId, uploaderName);
    } else if (imageId != null) {
        // 从图片库选择已有图片
        relicImageRelationService.setRelicMainImage(relicId, imageId);
    }
    
    return relicId;
}
```

### 2. Controller层

#### 新增接口

```java
@PostMapping("/with-image")
@OperationLog(operationType = "新增", operationModule = "文物管理", operationContent = "新增文物（含图片）")
public Result<Long> saveWithImage(
        @RequestParam("relicName") String relicName,
        @RequestParam(value = "era", required = false) String era,
        @RequestParam(value = "material", required = false) String material,
        @RequestParam(value = "categoryId", required = false) Long categoryId,
        @RequestParam(value = "status", defaultValue = "在库") String status,
        @RequestParam(value = "dimensions", required = false) String dimensions,
        @RequestParam(value = "weight", required = false) Double weight,
        @RequestParam(value = "origin", required = false) String origin,
        @RequestParam(value = "description", required = false) String description,
        @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
        @RequestParam(value = "imageId", required = false) Long imageId)
```

### 3. 处理流程

```
1. 接收文物基本信息和图片（文件或ID）
   ↓
2. 开启事务
   ↓
3. 生成文物编号
   ↓
4. 保存文物到 cultural_relic 表
   ↓
5. 获取文物ID
   ↓
6. 如果有图片文件：
   - 保存文件到文件系统
   - 创建 image_library 记录
   - 创建 relic_image_relation 关联
   ↓
7. 如果有图片ID：
   - 验证图片存在
   - 创建 relic_image_relation 关联
   ↓
8. 提交事务
   ↓
9. 返回文物ID
```

## 前端实现

### 1. API接口

#### relics.js

```javascript
// 新增文物（支持图片上传）
export const addRelicWithImageApi = (formData) => {
  return request.post('/relics/with-image', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}
```

### 2. 表单组件

#### RelicFormWithImage.vue

增强版文物表单组件，支持：

- 文物基本信息输入
- 图片拖拽上传
- 图片预览
- 从图片库选择
- 表单验证

**主要方法：**

```javascript
// 获取表单数据（包含图片）
const getFormData = () => {
  const formData = new FormData()
  
  // 添加文物基本信息
  Object.keys(form.value).forEach(key => {
    if (form.value[key] !== null && form.value[key] !== undefined) {
      formData.append(key, form.value[key])
    }
  })
  
  // 添加图片
  if (imageFile.value) {
    formData.append('imageFile', imageFile.value)
  } else if (selectedImageId.value) {
    formData.append('imageId', selectedImageId.value)
  }
  
  return formData
}
```

### 3. 图片库选择器

#### ImageLibrarySelector.vue

图片库选择组件，支持：

- 图片搜索和过滤
- 图片预览
- 分页浏览
- 选择确认

## 使用示例

### 后端使用

#### 1. 直接上传图片

```java
@Autowired
private CulturalRelicService culturalRelicService;

public void addRelicWithImage(CulturalRelic relic, MultipartFile imageFile) {
    Long relicId = culturalRelicService.saveWithImage(
        relic, imageFile, null, currentUserId, currentUserName);
    System.out.println("文物已保存，ID: " + relicId);
}
```

#### 2. 从图片库选择

```java
public void addRelicWithExistingImage(CulturalRelic relic, Long imageId) {
    Long relicId = culturalRelicService.saveWithImage(
        relic, null, imageId, currentUserId, currentUserName);
    System.out.println("文物已保存，ID: " + relicId);
}
```

#### 3. 不添加图片

```java
public void addRelicWithoutImage(CulturalRelic relic) {
    Long relicId = culturalRelicService.saveWithImage(
        relic, null, null, currentUserId, currentUserName);
    System.out.println("文物已保存，ID: " + relicId);
}
```

### 前端使用

#### 1. 在视图中使用表单组件

```vue
<template>
  <el-dialog v-model="dialogVisible" title="新增文物" width="800px">
    <RelicFormWithImage
      ref="formRef"
      v-model="form"
      :category-options="categoryOptions"
    />
    <template #footer>
      <el-button @click="dialogVisible = false">取消</el-button>
      <el-button type="primary" @click="handleSubmit">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup>
import { ref } from 'vue'
import { ElMessage } from 'element-plus'
import RelicFormWithImage from '@/components/RelicFormWithImage.vue'
import { addRelicWithImageApi } from '@/api/relics'

const dialogVisible = ref(false)
const formRef = ref(null)
const form = ref({
  relicName: '',
  era: '',
  material: '',
  categoryId: null,
  status: '在库',
  dimensions: '',
  weight: null,
  origin: '',
  description: ''
})

const handleSubmit = async () => {
  try {
    // 验证表单
    await formRef.value.validate()
    
    // 获取FormData（包含图片）
    const formData = formRef.value.getFormData()
    
    // 提交
    const response = await addRelicWithImageApi(formData)
    
    ElMessage.success('新增成功')
    dialogVisible.value = false
    
    // 刷新列表
    loadRelics()
  } catch (error) {
    console.error('新增失败:', error)
    ElMessage.error('新增失败')
  }
}
</script>
```

#### 2. 简单的表单提交

```javascript
import { addRelicWithImageApi } from '@/api/relics'

async function submitRelic(relicData, imageFile) {
  const formData = new FormData()
  
  // 添加文物信息
  formData.append('relicName', relicData.relicName)
  formData.append('era', relicData.era)
  formData.append('material', relicData.material)
  formData.append('status', relicData.status)
  
  // 添加图片（可选）
  if (imageFile) {
    formData.append('imageFile', imageFile)
  }
  
  try {
    const response = await addRelicWithImageApi(formData)
    console.log('文物ID:', response.data)
  } catch (error) {
    console.error('提交失败:', error)
  }
}
```

## 数据流程

### 1. 上传新图片

```
用户选择图片文件
    ↓
前端生成预览
    ↓
用户填写文物信息
    ↓
点击提交
    ↓
构建FormData（文物信息 + 图片文件）
    ↓
调用 POST /relics/with-image
    ↓
后端接收请求
    ↓
开启事务
    ↓
保存文物 → cultural_relic
    ↓
保存图片文件 → 文件系统
    ↓
创建图片记录 → image_library
    ↓
创建关联记录 → relic_image_relation
    ↓
提交事务
    ↓
返回文物ID
    ↓
前端显示成功消息
```

### 2. 从图片库选择

```
用户点击"从图片库选择"
    ↓
打开图片库选择器
    ↓
浏览/搜索图片
    ↓
选择图片
    ↓
用户填写文物信息
    ↓
点击提交
    ↓
构建FormData（文物信息 + 图片ID）
    ↓
调用 POST /relics/with-image
    ↓
后端接收请求
    ↓
开启事务
    ↓
保存文物 → cultural_relic
    ↓
验证图片存在 → image_library
    ↓
创建关联记录 → relic_image_relation
    ↓
提交事务
    ↓
返回文物ID
    ↓
前端显示成功消息
```

## 数据库变化

### 新增文物时的数据库操作

#### 1. 插入文物记录

```sql
INSERT INTO cultural_relic (
    relic_code, relic_name, era, material, category_id, 
    status, dimensions, weight, origin, description, 
    create_time, update_time
) VALUES (
    'CR2026001', '青铜鼎', '商代', '青铜', 1,
    '在库', '高30cm', 15.5, '河南安阳', '商代青铜礼器',
    NOW(), NOW()
);
-- 返回 relic_id = 1
```

#### 2. 插入图片记录（如果上传新图片）

```sql
INSERT INTO image_library (
    image_name, original_name, file_path, file_size, file_type,
    width, height, category, uploader_id, uploader_name,
    reference_type, reference_id, is_public, status,
    create_time, update_time
) VALUES (
    'relic_1.jpg', 'bronze_ding.jpg', '/uploads/2025/04/relic_1.jpg',
    1024000, 'image/jpeg', 800, 600, 'relic', 1, '管理员',
    'relic', 1, 1, 1, NOW(), NOW()
);
-- 返回 image_id = 1
```

#### 3. 插入关联记录

```sql
INSERT INTO relic_image_relation (
    relic_id, image_id, relation_type, sort_order,
    create_time, update_time
) VALUES (
    1, 1, 'main', 1, NOW(), NOW()
);
```

### 查询文物时自动获取图片

```sql
SELECT 
    cr.*,
    c.category_name AS categoryName,
    i.file_path AS imagePath
FROM cultural_relic cr
LEFT JOIN cultural_relic_category c ON cr.category_id = c.id
LEFT JOIN relic_image_relation rir ON cr.id = rir.relic_id
LEFT JOIN image_library i ON rir.image_id = i.id AND i.status = 1
WHERE cr.id = 1;
```

## 错误处理

### 1. 文件验证失败

```java
// 前端验证
if (!file.type.startsWith('image/')) {
    ElMessage.error('只能上传图片文件!')
    return
}
if (file.size > 5 * 1024 * 1024) {
    ElMessage.error('图片大小不能超过 5MB!')
    return
}
```

### 2. 事务回滚

```java
@Transactional(rollbackFor = Exception.class)
public Long saveWithImage(...) {
    try {
        // 保存文物
        culturalRelicMapper.insert(relic);
        
        // 处理图片
        if (imageFile != null) {
            relicImageRelationService.uploadAndSetRelicMainImage(...);
        }
        
        return relic.getId();
    } catch (Exception e) {
        // 事务自动回滚
        log.error("保存文物失败", e);
        throw e;
    }
}
```

### 3. 图片不存在

```java
if (imageId != null) {
    ImageLibrary image = imageLibraryMapper.selectById(imageId);
    if (image == null || image.getStatus() != 1) {
        throw new IllegalArgumentException("图片不存在或已删除");
    }
}
```

## 优势

### 1. 数据一致性

- 文物和图片在同一事务中处理
- 任何步骤失败都会回滚
- 不会出现孤立的文物或图片记录

### 2. 用户体验

- 一次操作完成文物和图片的添加
- 支持拖拽上传，操作便捷
- 实时预览，所见即所得

### 3. 灵活性

- 支持上传新图片
- 支持从图片库选择
- 图片是可选的，不强制要求

### 4. 可维护性

- 图片统一管理在 image_library
- 关联关系清晰明确
- 便于后续扩展（如多图支持）

## 注意事项

1. **文件大小限制**：前端和后端都应该限制文件大小
2. **文件类型验证**：只允许上传图片格式
3. **事务超时**：大文件上传可能需要调整事务超时时间
4. **并发控制**：高并发场景下注意文物编号的生成
5. **存储空间**：定期清理未被引用的图片文件

## 后续扩展

### 1. 多图支持

修改关联表的唯一约束，支持一个文物关联多张图片：

```sql
-- 移除 relic_id 的唯一约束
ALTER TABLE relic_image_relation DROP INDEX relic_id;

-- 添加复合唯一约束
ALTER TABLE relic_image_relation 
ADD UNIQUE KEY uk_relic_image (relic_id, image_id);
```

### 2. 图片批量上传

支持一次上传多张图片：

```java
public Long saveWithImages(CulturalRelic relic, List<MultipartFile> imageFiles, 
                          Long uploaderId, String uploaderName)
```

### 3. 图片压缩

上传时自动生成缩略图：

```java
// 生成缩略图
BufferedImage thumbnail = Thumbnails.of(imageFile.getInputStream())
    .size(300, 300)
    .asBufferedImage();
```

## 相关文档

- [文物图片关联功能集成](./RELIC_IMAGE_INTEGRATION.md)
- [文物图片关联表设计](./RELIC_IMAGE_RELATION_FEATURE.md)
- [图片管理功能](./IMAGE_MANAGEMENT_FEATURE.md)
