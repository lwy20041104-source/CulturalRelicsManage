# 文物多图片功能实施进度

## 已完成的工作 ✅

### 1. 数据库迁移脚本 ✅
**文件**：`backend/sql/migrate_relic_images_one_to_many.sql`

**内容**：
- ✅ 创建备份表 `relic_image_relation_backup_20260428`
- ✅ 删除旧表的 UNIQUE 约束
- ✅ 添加 `is_main` 字段
- ✅ 迁移现有数据
- ✅ 重建触发器
- ✅ 创建辅助存储过程 `sp_set_relic_main_image`

**执行方式**：
```bash
mysql -u root -p cultural_relics_management < backend/sql/migrate_relic_images_one_to_many.sql
```

### 2. 后端实体类更新 ✅
**文件**：`backend/src/main/java/com/example/entity/RelicImageRelation.java`

**修改**：
- ✅ 添加 `isMain` 字段
- ✅ 添加 getter/setter 方法
- ✅ 更新 toString() 方法

### 3. 后端Service接口更新 ✅
**文件**：`backend/src/main/java/com/example/service/RelicImageRelationService.java`

**新增方法**：
- ✅ `getRelicImages(Long relicId)` - 获取文物的所有图片
- ✅ `addRelicImages(Long relicId, List<Long> imageIds, boolean setFirstAsMain)` - 批量添加图片
- ✅ `removeRelicImage(Long relicId, Long imageId)` - 删除某张图片
- ✅ `setMainImage(Long relicId, Long imageId)` - 设置主图

### 4. 实施方案文档 ✅
**文件**：`RELIC_MULTI_IMAGES_IMPLEMENTATION_PLAN.md`

**内容**：
- ✅ 完整的实施方案
- ✅ 技术细节说明
- ✅ API接口设计
- ✅ 前端组件设计
- ✅ 测试计划
- ✅ 风险评估
- ✅ 回滚方案

## 待完成的工作 ⏳

### 5. 后端Service实现类 ⏳
**文件**：`backend/src/main/java/com/example/service/impl/RelicImageRelationServiceImpl.java`

**需要实现的方法**：
```java
@Override
public List<RelicImageRelation> getRelicImages(Long relicId) {
    // 查询文物的所有图片，按is_main DESC, sort_order ASC排序
}

@Override
public boolean addRelicImages(Long relicId, List<Long> imageIds, boolean setFirstAsMain) {
    // 批量添加图片关联
    // 如果setFirstAsMain=true且文物没有主图，将第一张设为主图
}

@Override
public boolean removeRelicImage(Long relicId, Long imageId) {
    // 删除图片关联
    // 如果删除的是主图，自动将下一张图片设为主图
}

@Override
public boolean setMainImage(Long relicId, Long imageId) {
    // 将文物的所有图片设为非主图
    // 将指定图片设为主图
}
```

### 6. 后端Mapper接口 ⏳
**文件**：`backend/src/main/java/com/example/mapper/RelicImageRelationMapper.java`

**需要添加的方法**：
```java
// 查询文物的所有图片
List<RelicImageRelation> selectByRelicId(@Param("relicId") Long relicId);

// 批量插入
int batchInsert(@Param("relations") List<RelicImageRelation> relations);

// 删除指定关联
int deleteByRelicIdAndImageId(@Param("relicId") Long relicId, @Param("imageId") Long imageId);

// 更新主图状态
int updateIsMain(@Param("relicId") Long relicId, @Param("imageId") Long imageId, @Param("isMain") Integer isMain);

// 批量更新主图状态
int batchUpdateIsMain(@Param("relicId") Long relicId, @Param("isMain") Integer isMain);
```

### 7. 后端Mapper XML ⏳
**文件**：`backend/src/main/resources/mapper/RelicImageRelationMapper.xml`

**需要添加的SQL**：
- SELECT查询（关联image_library表）
- 批量INSERT
- DELETE语句
- UPDATE语句

### 8. 后端Controller新增接口 ⏳
**文件**：`backend/src/main/java/com/example/controller/RelicImageRelationController.java`

**需要添加的接口**：
```java
// GET /relic-images/list/{relicId} - 获取文物的所有图片
@GetMapping("/list/{relicId}")
public Result<List<RelicImageRelation>> getRelicImages(@PathVariable Long relicId)

// POST /relic-images/batch-upload/{relicId} - 批量上传图片
@PostMapping("/batch-upload/{relicId}")
public Result<Map<String, Object>> batchUploadImages(@PathVariable Long relicId, @RequestParam("files") MultipartFile[] files)

// DELETE /relic-images/{relicId}/{imageId} - 删除某张图片
@DeleteMapping("/{relicId}/{imageId}")
public Result<Boolean> removeImage(@PathVariable Long relicId, @PathVariable Long imageId)

// PUT /relic-images/set-main - 设置主图
@PutMapping("/set-main")
public Result<Boolean> setMainImage(@RequestBody Map<String, Long> params)
```

### 9. 前端界面改造 ⏳
**文件**：`frontend/src/views/RelicsView.vue`

**需要修改的部分**：
1. 在新增/编辑对话框中添加多图片上传组件
2. 显示已上传的图片列表
3. 支持设置主图
4. 支持删除图片
5. 图片预览功能

**关键代码**：
```vue
<template>
  <!-- 在对话框中添加 -->
  <el-form-item label="文物图片">
    <el-upload
      :action="uploadUrl"
      :headers="uploadHeaders"
      :on-success="handleUploadSuccess"
      :file-list="imageList"
      list-type="picture-card"
      :limit="10"
      multiple
      accept="image/*"
    >
      <el-icon><Plus /></el-icon>
    </el-upload>
    
    <!-- 图片列表 -->
    <div class="image-list">
      <div v-for="img in relicImages" :key="img.id" class="image-item">
        <el-image :src="img.image.filePath" fit="cover" />
        <el-tag v-if="img.isMain" type="success">主图</el-tag>
        <div class="actions">
          <el-button v-if="!img.isMain" size="small" @click="setAsMain(img)">
            设为主图
          </el-button>
          <el-button size="small" type="danger" @click="deleteImage(img)">
            删除
          </el-button>
        </div>
      </div>
    </div>
  </el-form-item>
</template>

<script setup>
// 添加相关方法
const relicImages = ref([])

const loadRelicImages = async (relicId) => {
  const res = await getRelicImagesApi(relicId)
  relicImages.value = res.data
}

const handleUploadSuccess = (response, file, fileList) => {
  // 上传成功后刷新图片列表
  loadRelicImages(currentRelic.value.id)
}

const setAsMain = async (img) => {
  await setMainImageApi(img.relicId, img.imageId)
  ElMessage.success('主图设置成功')
  loadRelicImages(img.relicId)
}

const deleteImage = async (img) => {
  await ElMessageBox.confirm('确定要删除这张图片吗？', '警告', {
    type: 'warning'
  })
  await deleteRelicImageApi(img.relicId, img.imageId)
  ElMessage.success('删除成功')
  loadRelicImages(img.relicId)
}
</script>
```

### 10. 前端API接口 ⏳
**文件**：`frontend/src/api/relicImages.js`（新建）

**需要添加的API**：
```javascript
import request from '../utils/request'

// 获取文物的所有图片
export const getRelicImagesApi = (relicId) => {
  return request.get(`/relic-images/list/${relicId}`)
}

// 批量上传图片
export const batchUploadImagesApi = (relicId, files) => {
  const formData = new FormData()
  files.forEach(file => {
    formData.append('files', file)
  })
  return request.post(`/relic-images/batch-upload/${relicId}`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

// 设置主图
export const setMainImageApi = (relicId, imageId) => {
  return request.put('/relic-images/set-main', { relicId, imageId })
}

// 删除图片
export const deleteRelicImageApi = (relicId, imageId) => {
  return request.delete(`/relic-images/${relicId}/${imageId}`)
}
```

### 11. 国际化配置 ⏳
**文件**：
- `frontend/src/i18n/locales/zh-CN.js`
- `frontend/src/i18n/locales/en-US.js`

**需要添加的文本**：
```javascript
// zh-CN.js
relicImages: {
  title: '文物图片',
  uploadImages: '上传图片',
  mainImage: '主图',
  setAsMain: '设为主图',
  deleteImage: '删除图片',
  imageList: '图片列表',
  noImages: '暂无图片',
  uploadSuccess: '上传成功',
  uploadFailed: '上传失败',
  deleteConfirm: '确定要删除这张图片吗？',
  setMainSuccess: '主图设置成功',
  maxImages: '最多上传{count}张图片'
}

// en-US.js
relicImages: {
  title: 'Relic Images',
  uploadImages: 'Upload Images',
  mainImage: 'Main Image',
  setAsMain: 'Set as Main',
  deleteImage: 'Delete Image',
  imageList: 'Image List',
  noImages: 'No Images',
  uploadSuccess: 'Upload Successful',
  uploadFailed: 'Upload Failed',
  deleteConfirm: 'Are you sure to delete this image?',
  setMainSuccess: 'Main image set successfully',
  maxImages: 'Maximum {count} images allowed'
}
```

## 执行顺序建议

1. **先执行数据库迁移** ⚠️
   ```bash
   mysql -u root -p cultural_relics_management < backend/sql/migrate_relic_images_one_to_many.sql
   ```

2. **完成后端改造**（按顺序）
   - Mapper接口和XML
   - Service实现类
   - Controller新增接口
   - 编译测试

3. **完成前端改造**
   - API接口文件
   - 界面组件
   - 国际化配置
   - 测试验证

## 测试检查清单

### 数据库测试
- [ ] 执行迁移脚本成功
- [ ] 验证表结构正确
- [ ] 验证数据迁移完整
- [ ] 测试触发器工作正常

### 后端测试
- [ ] 获取文物所有图片
- [ ] 批量上传图片
- [ ] 设置主图
- [ ] 删除图片
- [ ] 主图自动切换

### 前端测试
- [ ] 多图片上传
- [ ] 图片预览
- [ ] 设置主图
- [ ] 删除图片
- [ ] 图片数量限制
- [ ] 编辑时加载已有图片

### 集成测试
- [ ] 新增文物并上传多张图片
- [ ] 编辑文物并修改图片
- [ ] 删除文物验证图片级联删除
- [ ] 查看文物详情验证图片显示

## 注意事项

1. **数据库迁移前务必备份**
2. **测试环境先验证，再部署到生产环境**
3. **保持API向后兼容，避免影响现有功能**
4. **前端需要处理图片上传失败的情况**
5. **后端需要验证图片数量限制（建议最多10张）**

## 相关文件

- ✅ `backend/sql/migrate_relic_images_one_to_many.sql` - 数据库迁移脚本
- ✅ `backend/src/main/java/com/example/entity/RelicImageRelation.java` - 实体类
- ✅ `backend/src/main/java/com/example/service/RelicImageRelationService.java` - Service接口
- ⏳ `backend/src/main/java/com/example/service/impl/RelicImageRelationServiceImpl.java` - Service实现
- ⏳ `backend/src/main/java/com/example/mapper/RelicImageRelationMapper.java` - Mapper接口
- ⏳ `backend/src/main/resources/mapper/RelicImageRelationMapper.xml` - Mapper XML
- ⏳ `backend/src/main/java/com/example/controller/RelicImageRelationController.java` - Controller
- ⏳ `frontend/src/api/relicImages.js` - 前端API
- ⏳ `frontend/src/views/RelicsView.vue` - 前端界面
- ⏳ `frontend/src/i18n/locales/zh-CN.js` - 中文国际化
- ⏳ `frontend/src/i18n/locales/en-US.js` - 英文国际化
- ✅ `RELIC_MULTI_IMAGES_IMPLEMENTATION_PLAN.md` - 实施方案
- ✅ `RELIC_MULTI_IMAGES_PROGRESS.md` - 进度跟踪（本文档）
