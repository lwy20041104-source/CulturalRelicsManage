# 文物多图片功能实施方案

## 需求说明

将文物与图片的关系从**一对一**改为**一对多**，允许一个文物关联多张图片，并在前端文物管理界面支持多图片上传。

## 实施步骤

### 第一阶段：数据库改造 ✅

**文件**：`backend/sql/migrate_relic_images_one_to_many.sql`

**改造内容**：
1. 移除 `relic_id` 的 UNIQUE 约束（允许一个文物有多张图片）
2. 保留 `image_id` 的 UNIQUE 约束（一张图片只属于一个文物）
3. 添加 `is_main` 字段（标识主图）
4. 迁移现有数据（所有现有图片标记为主图）
5. 重建触发器
6. 创建辅助存储过程

**执行命令**：
```bash
mysql -u root -p cultural_relics_management < backend/sql/migrate_relic_images_one_to_many.sql
```

### 第二阶段：后端实体类改造

**文件**：`backend/src/main/java/com/example/entity/RelicImageRelation.java`

**新增字段**：
```java
private Integer isMain;  // 是否为主图（1:是, 0:否）
```

### 第三阶段：后端Service改造

**文件**：`backend/src/main/java/com/example/service/RelicImageRelationService.java`

**新增方法**：
```java
// 获取文物的所有图片
List<RelicImageRelation> getRelicImages(Long relicId);

// 批量添加文物图片
boolean addRelicImages(Long relicId, List<Long> imageIds);

// 删除文物的某张图片
boolean removeRelicImage(Long relicId, Long imageId);

// 设置主图
boolean setMainImage(Long relicId, Long imageId);
```

### 第四阶段：后端Controller改造

**文件**：`backend/src/main/java/com/example/controller/RelicImageRelationController.java`

**新增接口**：
```java
// GET /relic-images/list/{relicId} - 获取文物的所有图片
// POST /relic-images/batch-upload/{relicId} - 批量上传图片
// DELETE /relic-images/{relicId}/{imageId} - 删除某张图片
// PUT /relic-images/set-main - 设置主图
```

### 第五阶段：前端界面改造

**文件**：`frontend/src/views/RelicsView.vue`

**改造内容**：
1. 修改新增/编辑对话框，支持多图片上传
2. 使用 `el-upload` 组件的多文件上传功能
3. 显示已上传的图片列表
4. 支持设置主图
5. 支持删除图片
6. 图片预览功能

**UI设计**：
```
┌─────────────────────────────────────┐
│ 文物图片                             │
├─────────────────────────────────────┤
│ [+上传图片]                          │
│                                     │
│ ┌────┐ ┌────┐ ┌────┐               │
│ │图1 │ │图2 │ │图3 │               │
│ │主图│ │    │ │    │               │
│ └────┘ └────┘ └────┘               │
│ [设为主图] [删除]                    │
└─────────────────────────────────────┘
```

### 第六阶段：国际化配置

**文件**：
- `frontend/src/i18n/locales/zh-CN.js`
- `frontend/src/i18n/locales/en-US.js`

**新增文本**：
```javascript
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
```

## 技术细节

### 数据库表结构（新）

```sql
CREATE TABLE relic_image_relation (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    relic_id BIGINT NOT NULL,              -- 文物ID（可重复）
    image_id BIGINT NOT NULL,              -- 图片ID（唯一）
    relation_type VARCHAR(20) DEFAULT 'detail',
    is_main TINYINT DEFAULT 0,             -- 是否主图
    sort_order INT DEFAULT 0,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    UNIQUE KEY uk_image_id (image_id),     -- 一张图片只属于一个文物
    KEY idx_relic_id (relic_id),           -- 一个文物可以有多张图片
    KEY idx_is_main (is_main)
);
```

### 业务规则

1. **主图规则**：
   - 每个文物必须有且只有一张主图
   - 第一张上传的图片自动设为主图
   - 可以手动更改主图
   - 删除主图时，自动将第一张图片设为主图

2. **图片数量限制**：
   - 建议限制每个文物最多上传 10 张图片
   - 前端和后端都需要验证

3. **图片排序**：
   - 使用 `sort_order` 字段控制显示顺序
   - 主图的 `sort_order` 为 0
   - 其他图片按上传顺序递增

4. **删除逻辑**：
   - 删除文物时，级联删除所有关联图片
   - 删除图片时，自动删除关联关系
   - 如果删除的是主图，需要重新指定主图

### API接口设计

#### 1. 获取文物的所有图片
```
GET /relic-images/list/{relicId}

Response:
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "relicId": 1,
      "imageId": 1,
      "isMain": 1,
      "sortOrder": 0,
      "image": {
        "id": 1,
        "fileName": "image1.jpg",
        "filePath": "/uploads/images/image1.jpg"
      }
    }
  ]
}
```

#### 2. 批量上传图片
```
POST /relic-images/batch-upload/{relicId}
Content-Type: multipart/form-data

FormData:
- files: File[]

Response:
{
  "code": 200,
  "message": "上传成功",
  "data": {
    "successCount": 3,
    "failedCount": 0,
    "imagePaths": ["/uploads/images/1.jpg", "/uploads/images/2.jpg"]
  }
}
```

#### 3. 设置主图
```
PUT /relic-images/set-main
Content-Type: application/json

Body:
{
  "relicId": 1,
  "imageId": 2
}

Response:
{
  "code": 200,
  "message": "主图设置成功",
  "data": true
}
```

#### 4. 删除图片
```
DELETE /relic-images/{relicId}/{imageId}

Response:
{
  "code": 200,
  "message": "删除成功",
  "data": true
}
```

### 前端组件设计

#### el-upload 配置
```vue
<el-upload
  :action="uploadUrl"
  :headers="uploadHeaders"
  :on-success="handleUploadSuccess"
  :on-error="handleUploadError"
  :before-upload="beforeUpload"
  :file-list="fileList"
  list-type="picture-card"
  :limit="10"
  multiple
  accept="image/*"
>
  <el-icon><Plus /></el-icon>
</el-upload>
```

#### 图片列表显示
```vue
<div class="image-list">
  <div v-for="img in images" :key="img.id" class="image-item">
    <el-image :src="img.image.filePath" fit="cover" />
    <el-tag v-if="img.isMain" type="success">主图</el-tag>
    <div class="image-actions">
      <el-button v-if="!img.isMain" size="small" @click="setAsMain(img)">
        设为主图
      </el-button>
      <el-button size="small" type="danger" @click="deleteImage(img)">
        删除
      </el-button>
    </div>
  </div>
</div>
```

## 测试计划

### 数据库测试
1. ✅ 执行迁移脚本
2. ✅ 验证表结构
3. ✅ 验证数据迁移
4. ✅ 测试触发器

### 后端测试
1. 测试获取文物所有图片
2. 测试批量上传图片
3. 测试设置主图
4. 测试删除图片
5. 测试主图自动切换逻辑

### 前端测试
1. 测试多图片上传
2. 测试图片预览
3. 测试设置主图
4. 测试删除图片
5. 测试图片数量限制
6. 测试编辑时加载已有图片

### 集成测试
1. 新增文物并上传多张图片
2. 编辑文物并修改图片
3. 删除文物验证图片级联删除
4. 查看文物详情验证图片显示

## 风险评估

### 高风险
- ❌ 数据库迁移失败导致数据丢失
  - **缓解措施**：迁移前自动备份数据

### 中风险
- ⚠️ 现有功能受影响
  - **缓解措施**：充分测试，保持API兼容性

### 低风险
- ⚠️ 前端UI适配问题
  - **缓解措施**：渐进式改造，保留旧功能

## 实施时间表

| 阶段 | 任务 | 预计时间 | 状态 |
|------|------|----------|------|
| 1 | 数据库迁移脚本 | 30分钟 | ✅ 已完成 |
| 2 | 后端实体类改造 | 15分钟 | ⏳ 待执行 |
| 3 | 后端Service改造 | 45分钟 | ⏳ 待执行 |
| 4 | 后端Controller改造 | 30分钟 | ⏳ 待执行 |
| 5 | 前端界面改造 | 60分钟 | ⏳ 待执行 |
| 6 | 国际化配置 | 15分钟 | ⏳ 待执行 |
| 7 | 测试验证 | 45分钟 | ⏳ 待执行 |

**总计**：约 4 小时

## 回滚方案

如果迁移后出现问题，可以执行以下回滚步骤：

```sql
-- 1. 删除新表
DROP TABLE IF EXISTS relic_image_relation;

-- 2. 从备份恢复
CREATE TABLE relic_image_relation AS
SELECT * FROM relic_image_relation_backup_20260428;

-- 3. 重建索引和约束
ALTER TABLE relic_image_relation
ADD UNIQUE KEY uk_relic_id (relic_id),
ADD UNIQUE KEY uk_image_id (image_id);

-- 4. 重建触发器
-- （执行原始的触发器创建语句）
```

## 相关文档

- `backend/sql/migrate_relic_images_one_to_many.sql` - 数据库迁移脚本
- `backend/src/main/java/com/example/entity/RelicImageRelation.java` - 实体类
- `backend/src/main/java/com/example/service/RelicImageRelationService.java` - Service接口
- `backend/src/main/java/com/example/controller/RelicImageRelationController.java` - Controller
- `frontend/src/views/RelicsView.vue` - 前端界面
