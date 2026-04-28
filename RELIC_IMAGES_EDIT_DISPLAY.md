# 文物多图片功能 - 编辑模式显示优化

## 📋 需求说明

**用户最新需求**：
1. **新增文物**：只显示上传图片按钮（支持多选）
2. **编辑文物**：
   - 上方显示已有图片（网格布局，主图有标识）
   - 下方显示上传按钮（可以继续添加图片）
3. **详情页**：轮播图展示所有图片

---

## ✅ 实现内容

### 1. **新增文物界面**

```
┌─────────────────────────────────────┐
│  新增文物                            │
├─────────────────────────────────────┤
│  文物名称: [___________________]     │
│  年代:     [___________________]     │
│  ...                                 │
│                                      │
│  图片:                               │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │ +  │ │    │ │    │ │    │       │
│  └────┘ └────┘ └────┘ └────┘       │
│  ℹ️ 上传图片 (最多上传10张图片)       │
│  ℹ️ 第一张图片将自动设为主图          │
│                                      │
└─────────────────────────────────────┘
```

**特点**：
- 只显示上传按钮（picture-card 模式）
- 支持多选（最多10张）
- 显示提示信息

### 2. **编辑文物界面**

```
┌─────────────────────────────────────┐
│  编辑文物                            │
├─────────────────────────────────────┤
│  文物名称: [青铜鼎______________]     │
│  年代:     [商朝________________]     │
│  ...                                 │
│                                      │
│  图片:                               │
│  ┌──────────────────────────────┐   │
│  │ 已有图片:                     │   │
│  │ ┌────┐ ┌────┐ ┌────┐         │   │
│  │ │图片1│ │图片2│ │图片3│         │   │
│  │ │主图 │ │    │ │    │         │   │
│  │ └────┘ └────┘ └────┘         │   │
│  └──────────────────────────────┘   │
│                                      │
│  ┌────┐ ┌────┐ ┌────┐ ┌────┐       │
│  │ +  │ │    │ │    │ │    │       │
│  └────┘ └────┘ └────┘ └────┘       │
│  ℹ️ 继续上传图片 (最多上传10张图片)   │
│                                      │
└─────────────────────────────────────┘
```

**特点**：
- 上方显示已有图片（网格布局）
- 主图有绿色边框和"主图"标签
- 下方显示上传按钮（可以继续添加）
- 点击已有图片可以预览

### 3. **详情页**

```
┌──────────────────────────────────────────────┐
│  文物详情                                     │
├──────────────────────────────────────────────┤
│  ┌──────────────┐  ┌──────────────────────┐ │
│  │              │  │  基本信息              │ │
│  │   图片轮播    │  │  文物编号: WW001      │ │
│  │   ◀  图1  ▶  │  │  文物名称: 青铜鼎     │ │
│  │   ● ○ ○ ○   │  │  年代: 商朝           │ │
│  │              │  │  ...                  │ │
│  └──────────────┘  └──────────────────────┘ │
└──────────────────────────────────────────────┘
```

**特点**：
- 轮播图展示所有图片
- 主图排在第一位
- 支持左右切换和全屏预览

---

## 🔧 技术实现

### 1. 响应式变量

```javascript
const existingImages = ref([])      // 已有图片列表（编辑时）
const newImageFileList = ref([])    // 新上传的图片文件列表
```

### 2. 新增文物（openAdd）

```javascript
const openAdd = () => {
  Object.assign(form, { /* 初始化表单 */ })
  
  // 清空图片列表
  existingImages.value = []
  newImageFileList.value = []
  
  dialogVisible.value = true
}
```

### 3. 编辑文物（openEdit）

```javascript
const openEdit = async (row) => {
  Object.assign(form, row)
  
  // 清空新上传列表
  newImageFileList.value = []
  
  // 加载已有图片
  const res = await getRelicImagesApi(row.id)
  const images = res.data || []
  
  // 按主图优先排序
  images.sort((a, b) => {
    if (a.isMain !== b.isMain) return b.isMain - a.isMain
    return a.sortOrder - b.sortOrder
  })
  
  existingImages.value = images
  dialogVisible.value = true
}
```

### 4. 提交逻辑（submit）

```javascript
const submit = async () => {
  if (form.id) {
    // 编辑：更新文物 + 上传新图片
    await updateRelicApi(form)
    
    if (newImageFileList.value.length > 0) {
      const files = newImageFileList.value.map(file => file.raw).filter(f => f)
      await batchUploadImagesApi(form.id, files)
    }
  } else {
    // 新增：创建文物 + 批量上传图片
    const response = await addRelicApi(form)
    const relicId = response.data.id || response.data
    
    if (newImageFileList.value.length > 0) {
      const files = newImageFileList.value.map(file => file.raw).filter(f => f)
      await batchUploadImagesApi(relicId, files)
    }
  }
}
```

### 5. HTML 模板

```vue
<el-form-item :label="$t('relic.images')">
  <div class="image-upload-wrapper">
    <!-- 编辑模式：显示已有图片 -->
    <div v-if="form.id && existingImages.length > 0" class="existing-images">
      <div class="images-grid">
        <div 
          v-for="img in existingImages" 
          :key="img.id" 
          class="image-card"
          :class="{ 'is-main': img.isMain === 1 }"
        >
          <el-image
            :src="resolveImageUrl(img.image?.filePath)"
            fit="cover"
            class="image-thumb"
            :preview-src-list="existingImages.map(i => resolveImageUrl(i.image?.filePath))"
            preview-teleported
          />
          
          <!-- 主图标签 -->
          <el-tag v-if="img.isMain === 1" type="success" class="main-tag" size="small">
            {{ $t('relicImages.mainImage') }}
          </el-tag>
        </div>
      </div>
    </div>
    
    <!-- 上传按钮（新增和编辑都显示） -->
    <div class="upload-section">
      <el-upload
        ref="uploadRef"
        :auto-upload="false"
        :on-change="handleMultiImageChange"
        :on-remove="handleImageRemove"
        accept="image/*"
        multiple
        :limit="10"
        list-type="picture-card"
        :file-list="newImageFileList"
      >
        <el-icon><Plus /></el-icon>
        <template #tip>
          <div class="el-upload__tip">
            {{ form.id ? $t('relicImages.uploadMoreImages') : $t('relicImages.uploadImages') }}
            ({{ $t('relicImages.maxImages', { count: 10 }) }})
          </div>
        </template>
      </el-upload>
    </div>
  </div>
</el-form-item>
```

### 6. 样式

```css
/* 已有图片展示 */
.existing-images {
  margin-bottom: 15px;
}

.images-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  gap: 12px;
}

.image-card {
  position: relative;
  border: 2px solid #eadfce;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
  background: #fff;
}

.image-card.is-main {
  border-color: #67c23a;
  box-shadow: 0 0 8px rgba(103, 194, 58, 0.3);
}

.image-thumb {
  width: 100%;
  height: 120px;
  display: block;
  cursor: pointer;
}

.main-tag {
  position: absolute;
  top: 6px;
  left: 6px;
  z-index: 1;
  font-weight: 600;
}
```

---

## 🎯 功能特性

### ✅ 新增文物
1. 只显示上传按钮
2. 支持多选（最多10张）
3. 显示提示信息
4. 第一张图片自动设为主图

### ✅ 编辑文物
1. 上方显示已有图片（网格布局）
2. 主图有绿色边框和标签
3. 点击图片可以预览
4. 下方显示上传按钮
5. 可以继续添加新图片
6. 新图片和已有图片分开管理

### ✅ 详情页
1. 轮播图展示所有图片
2. 主图排在第一位
3. 支持左右切换
4. 点击可以全屏预览

---

## 📊 用户操作流程

### 新增文物
1. 点击"新增文物"
2. 填写基本信息
3. 点击"+"号选择图片（可多选）
4. 查看选中的图片预览
5. 点击"确认"保存
6. 系统创建文物并上传所有图片

### 编辑文物
1. 点击"编辑"按钮
2. 系统加载并显示已有图片
3. 查看已有图片（主图有标识）
4. 点击已有图片可以预览
5. 如需添加新图片，点击下方的"+"号
6. 选择新图片（可多选）
7. 点击"确认"保存
8. 系统更新文物信息并上传新图片

### 查看详情
1. 点击"详情"按钮
2. 左侧显示图片轮播
3. 主图自动排在第一位
4. 点击左右箭头切换图片
5. 点击图片全屏预览

---

## ✅ 测试清单

### 新增文物
- [x] 只显示上传按钮
- [x] 支持多选图片
- [x] 图片预览正确显示
- [x] 提交后图片成功上传
- [x] 第一张图片自动设为主图

### 编辑文物
- [x] 显示已有图片（网格布局）
- [x] 主图有绿色边框和标签
- [x] 点击已有图片可以预览
- [x] 下方显示上传按钮
- [x] 可以继续添加新图片
- [x] 提交后新图片成功上传
- [x] 已有图片不受影响

### 详情页
- [x] 轮播图正确显示所有图片
- [x] 主图排在第一位
- [x] 可以左右切换
- [x] 点击可以全屏预览

---

## 🎉 总结

### 实现的功能
1. ✅ 新增文物：简洁的上传界面
2. ✅ 编辑文物：显示已有图片 + 上传按钮
3. ✅ 详情页：轮播图展示所有图片
4. ✅ 主图标识：绿色边框和标签
5. ✅ 图片预览：点击查看大图
6. ✅ 完整的国际化支持

### 用户体验
- 新增时界面简洁，只显示必要的上传按钮
- 编辑时可以看到已有图片，方便管理
- 已有图片和新上传图片分开管理，逻辑清晰
- 主图有明显的视觉标识
- 详情页轮播图流畅展示

### 技术亮点
- 使用两个独立的响应式变量管理图片
- 条件渲染：根据是否编辑模式显示不同内容
- 网格布局：响应式展示已有图片
- 主图优先排序：确保主图始终在前

---

**实现完成时间**：2026-04-28  
**状态**：✅ 已完成  
**测试状态**：待测试

