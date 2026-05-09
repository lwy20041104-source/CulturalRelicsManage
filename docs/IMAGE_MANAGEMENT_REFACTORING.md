# 图片管理功能重构说明

## 修改概述

根据需求，对图片管理功能进行了重构，确保图片的上传和管理只能在文物管理界面进行，图片管理界面仅作为查看和下载的展示界面。

## 前端修改

### 1. 图片管理界面（ImageLibraryView.vue）

#### 删除的功能：
- ❌ 上传图片按钮
- ❌ 批量上传按钮
- ❌ 批量删除按钮
- ❌ 单个图片的删除按钮
- ❌ 单个图片的编辑按钮
- ❌ 图片选择复选框
- ❌ 上传对话框
- ❌ 批量上传对话框
- ❌ 编辑对话框

#### 保留的功能：
- ✅ 搜索和筛选功能
- ✅ 图片详情查看
- ✅ 图片下载功能
- ✅ 统计信息查看

#### 新增提示：
在工具栏添加了提示信息：
```
"提示：图片的上传和管理请在文物管理界面进行操作"
```

#### 删除的代码：
- 删除了 `selectedIds`、`uploadDialogVisible`、`batchUploadDialogVisible`、`editDialogVisible` 等状态变量
- 删除了 `uploadForm`、`batchUploadForm`、`editForm` 等表单对象
- 删除了 `uploadRef`、`batchUploadRef`、`uploadFormRef`、`batchUploadFormRef` 等引用
- 删除了 `fileList`、`batchFileList`、`relicsList` 等数据列表
- 删除了 `toggleSelection`、`loadRelicsList`、`openUploadDialog`、`openBatchUploadDialog`、`handleFileChange`、`handleBatchFileChange`、`submitUpload`、`submitBatchUpload`、`openEdit`、`submitEdit`、`remove`、`handleBatchDelete` 等函数
- 删除了相关的 import（`Edit`、`Delete`、`UploadFilled` 图标，以及上传、编辑、删除相关的 API）

### 2. 文物管理界面（RelicsView.vue）

#### 保留的功能：
- ✅ 文物信息的新增和编辑
- ✅ 图片上传功能（单张和批量）
- ✅ 已有图片的查看
- ✅ 图片与文物的关联管理

文物管理界面的图片上传功能保持不变，继续支持：
- 新增文物时上传多张图片（最多10张）
- 编辑文物时查看已有图片
- 编辑文物时上传更多图片
- 第一张图片自动设为主图

## 后端逻辑

### 图片自动同步机制

后端已经实现了完善的图片同步机制，确保文物管理界面的图片操作自动同步到图片库：

#### 1. 上传图片时（RelicImageRelationServiceImpl.java）

```java
// 在 uploadAndSetRelicMainImage 和 batchUploadAndAddImages 方法中：

// 1. 保存文件到存储
String filePath = fileStorageUtil.save(file);

// 2. 创建图片库记录（ImageLibrary）
ImageLibrary imageLibrary = new ImageLibrary();
imageLibrary.setImageName(file.getOriginalFilename());
imageLibrary.setFilePath(filePath);
imageLibrary.setCategory("relic");  // 自动分类为文物图片
imageLibrary.setReferenceType("relic");  // 关联类型
imageLibrary.setReferenceId(relicId);  // 关联的文物ID
// ... 其他字段设置
imageLibraryMapper.insert(imageLibrary);

// 3. 建立文物图片关联（RelicImageRelation）
RelicImageRelation relation = new RelicImageRelation();
relation.setRelicId(relicId);
relation.setImageId(imageLibrary.getId());
relation.setIsMain(isFirstImage ? 1 : 0);  // 第一张设为主图
relationMapper.insert(relation);
```

#### 2. 删除图片时

```java
// 在 removeRelicImage 方法中：

// 1. 删除关联关系
relationMapper.deleteByRelicIdAndImageId(relicId, imageId);

// 2. 清除图片的引用信息
ImageLibrary image = imageLibraryMapper.selectById(imageId);
image.setReferenceType(null);
image.setReferenceId(null);
imageLibraryMapper.updateById(image);

// 3. 如果删除的是主图，自动将第一张图片设为主图
if (wasMainImage) {
    List<RelicImageRelation> remainingImages = relationMapper.selectAllByRelicId(relicId);
    if (!remainingImages.isEmpty()) {
        setMainImage(relicId, remainingImages.get(0).getImageId());
    }
}
```

#### 3. 设置主图时

```java
// 在 setMainImage 方法中：

// 1. 将所有图片设为非主图
relationMapper.batchUpdateIsMain(relicId, 0, "detail");

// 2. 将指定图片设为主图
relationMapper.updateIsMain(relicId, imageId, 1, "main");
```

### 数据库表结构

#### image_library（图片库表）
- `id`: 图片ID
- `image_name`: 图片名称
- `file_path`: 文件路径
- `category`: 分类（relic/exhibition/document/other）
- `reference_type`: 引用类型（relic）
- `reference_id`: 引用ID（文物ID）
- `uploader_id`: 上传者ID
- `uploader_name`: 上传者姓名
- 其他字段...

#### relic_image_relation（文物图片关联表）
- `id`: 关联ID
- `relic_id`: 文物ID
- `image_id`: 图片ID
- `is_main`: 是否主图（1=是，0=否）
- `relation_type`: 关联类型（main/detail）
- `sort_order`: 排序号
- 其他字段...

## 工作流程

### 用户操作流程

1. **上传图片**
   - 用户在文物管理界面新增或编辑文物
   - 上传一张或多张图片
   - 后端自动创建图片库记录
   - 后端自动建立文物与图片的关联
   - 图片自动出现在图片管理界面

2. **查看图片**
   - 用户在图片管理界面可以查看所有图片
   - 可以按分类、名称、标签筛选
   - 可以查看图片详情
   - 可以下载图片

3. **管理图片**
   - 用户在文物管理界面编辑文物
   - 可以查看该文物的所有图片
   - 可以上传更多图片
   - 可以设置主图
   - 可以删除图片
   - 所有操作自动同步到图片管理界面

### 数据同步流程

```
文物管理界面操作 → 后端服务层 → 数据库更新 → 图片管理界面自动刷新
     ↓                  ↓              ↓                    ↓
  上传图片         创建图片记录    image_library      显示新图片
  删除图片         删除图片记录    relic_image_relation  移除图片
  设置主图         更新关联记录    更新is_main字段      更新显示
```

## 优势

1. **统一管理**：所有图片的上传和管理都在文物管理界面进行，避免了数据不一致
2. **自动同步**：后端自动处理图片库和关联关系，无需手动维护
3. **数据完整性**：通过外键约束和事务保证数据一致性
4. **用户友好**：图片管理界面简化为查看和下载，降低操作复杂度
5. **权限控制**：可以更好地控制图片的上传权限（只有能管理文物的用户才能上传图片）

## 注意事项

1. 图片管理界面现在是只读的（除了下载功能）
2. 所有图片的增删改操作必须在文物管理界面进行
3. 删除文物时，相关的图片关联会被自动删除（通过外键约束或服务层处理）
4. 图片文件本身不会被物理删除，只是解除关联（可以根据需要调整）

## 测试建议

1. 测试在文物管理界面上传图片，验证图片是否出现在图片管理界面
2. 测试在文物管理界面删除图片，验证图片是否从图片管理界面消失
3. 测试在文物管理界面设置主图，验证关联关系是否正确更新
4. 测试图片管理界面的搜索和筛选功能
5. 测试图片管理界面的下载功能
6. 测试删除文物时，图片关联是否正确处理

## 后续优化建议

1. 可以考虑在图片管理界面添加"关联文物"信息的显示
2. 可以考虑添加图片的批量导出功能
3. 可以考虑添加图片的标签管理功能（在文物管理界面）
4. 可以考虑添加图片的版本管理功能
5. 可以考虑添加图片的审核流程（如果需要）
