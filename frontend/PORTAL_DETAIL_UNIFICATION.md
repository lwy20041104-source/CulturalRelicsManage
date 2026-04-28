# 前台门户文物详情界面统一修改

## 修改时间
2026年4月27日

## 修改文件
`frontend/src/views/PublicPortalView.vue`

## 修改内容

### 1. 文物详情对话框结构（第892-970行）

#### 修改前
```vue
<el-dialog v-model="relicDetailVisible" :title="t('relicDetail')" width="800px">
  <el-descriptions v-if="currentRelic" :column="2" border>
    <!-- 描述列表 -->
  </el-descriptions>
  <div v-if="currentRelic?.imageUrl" class="relic-detail-image">
    <img :src="resolveImageUrl(currentRelic.imageUrl)" :alt="currentRelic.relicName" />
  </div>
</el-dialog>
```

#### 修改后
```vue
<el-dialog 
  v-model="relicDetailVisible" 
  :title="t('relicDetail')" 
  width="1000px"
  class="detail-dialog"
  :close-on-click-modal="false"
>
  <div v-if="currentRelic" class="detail-container">
    <!-- 左侧：图片展示 -->
    <div class="detail-left">
      <div class="detail-image-wrapper">
        <el-image
          v-if="currentRelic.imageUrl"
          :src="resolveImageUrl(currentRelic.imageUrl)"
          fit="contain"
          class="detail-main-image"
          :preview-src-list="[resolveImageUrl(currentRelic.imageUrl)]"
          :initial-index="0"
          preview-teleported
          :z-index="3000"
        >
          <template #error>
            <div class="image-error">
              <el-icon :size="80"><Box /></el-icon>
              <p>{{ t('imageLoadFailed') }}</p>
            </div>
          </template>
        </el-image>
        <div v-else class="no-image-placeholder">
          <el-icon :size="80"><Box /></el-icon>
          <p>{{ t('noImage') }}</p>
        </div>
      </div>
    </div>

    <!-- 右侧：详细信息 -->
    <div class="detail-right">
      <!-- 基本信息 -->
      <div class="detail-section">
        <h3 class="section-title">{{ t('basicInfo') }}</h3>
        <el-descriptions :column="2" border>
          <el-descriptions-item :label="t('relicCode')">{{ currentRelic.relicCode }}</el-descriptions-item>
          <el-descriptions-item :label="t('relicName')">{{ currentRelic.relicName }}</el-descriptions-item>
          <el-descriptions-item :label="t('era')">{{ currentRelic.era }}</el-descriptions-item>
          <el-descriptions-item :label="t('material')">{{ currentRelic.material }}</el-descriptions-item>
          <el-descriptions-item :label="t('category')">{{ currentRelic.categoryName || '—' }}</el-descriptions-item>
          <el-descriptions-item :label="t('status')">
            <el-tag :type="currentRelic.status === '在库' ? 'success' : 'warning'">
              {{ currentRelic.status === '在库' ? t('inStockStatus') : t('loaningStatus') }}
            </el-tag>
          </el-descriptions-item>
          <el-descriptions-item :label="t('dimensions')">{{ currentRelic.dimensions || '—' }}</el-descriptions-item>
          <el-descriptions-item :label="t('weight')">{{ formatWeight(currentRelic.weight) }}</el-descriptions-item>
          <el-descriptions-item :label="t('origin')" :span="2">{{ currentRelic.origin || '—' }}</el-descriptions-item>
          <el-descriptions-item :label="t('description')" :span="2">{{ currentRelic.description || '—' }}</el-descriptions-item>
        </el-descriptions>
      </div>

      <!-- 操作提示 -->
      <div class="detail-section">
        <el-alert
          type="info"
          :closable="false"
          show-icon
        >
          <template #title>
            <span>{{ t('wantMoreInfo') }}</span>
            <el-button type="primary" text size="small" @click="handleLoginFromDetail" style="margin-left: 10px;">
              {{ t('loginForMore') }}
            </el-button>
          </template>
        </el-alert>
      </div>
    </div>
  </div>
</el-dialog>
```

### 2. 新增方法（第1645行）

```javascript
const handleLoginFromDetail = () => {
  relicDetailVisible.value = false
  router.push('/portal-login')
}
```

### 3. 新增翻译键（第1148-1153行，第1233-1238行）

#### 中文翻译
```javascript
basicInfo: '基本信息',
noImage: '暂无图片',
imageLoadFailed: '图片加载失败',
wantMoreInfo: '想了解更多？',
loginForMore: '登录后可查看更多详细信息'
```

#### 英文翻译
```javascript
basicInfo: 'Basic Information',
noImage: 'No Image',
imageLoadFailed: 'Image Load Failed',
wantMoreInfo: 'Want to know more?',
loginForMore: 'Login to view more details'
```

### 4. 新增CSS样式（第4450-4540行）

```css
/* 文物详情对话框样式 */
.detail-dialog :deep(.el-dialog__body) {
  padding: 30px;
}

.detail-container {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: 30px;
}

.detail-left {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-image-wrapper {
  width: 100%;
  height: 400px;
  background: #f7efe4;
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.detail-main-image {
  width: 100%;
  height: 100%;
  cursor: pointer;
}

.image-error,
.no-image-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #9b8d7d;
  gap: 12px;
}

.image-error p,
.no-image-placeholder p {
  margin: 0;
  font-size: 16px;
}

.detail-right {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-section {
  margin-bottom: 20px;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #3d2a1d;
  margin: 0 0 16px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid rgba(181, 136, 82, 0.2);
}

/* 响应式 - 详情对话框 */
@media (max-width: 768px) {
  .detail-container {
    grid-template-columns: 1fr;
  }
  
  .detail-left {
    order: 1;
  }
  
  .detail-right {
    order: 2;
  }
}
```

## 主要变化

### 1. 对话框配置
- ✅ 宽度从 800px 改为 1000px
- ✅ 添加 `class="detail-dialog"`
- ✅ 添加 `:close-on-click-modal="false"`

### 2. 布局结构
- ✅ 采用左右分栏布局（400px + 1fr）
- ✅ 左侧：图片展示区域（400px宽，400px高）
- ✅ 右侧：详细信息区域

### 3. 图片展示
- ✅ 使用 `el-image` 组件替代 `<img>` 标签
- ✅ 支持图片预览功能（点击放大）
- ✅ 添加图片加载失败处理
- ✅ 添加无图片占位符

### 4. 信息展示
- ✅ 添加"基本信息"标题
- ✅ 使用 `el-descriptions` 组件展示信息
- ✅ 添加操作提示区域（引导用户登录）

### 5. 交互功能
- ✅ 点击图片可预览大图
- ✅ 点击"登录后可查看更多详细信息"按钮跳转到登录页

## 与后台管理界面的一致性

现在前台门户的文物详情对话框与后台管理界面（`RelicsView.vue`）保持一致：

| 特性 | 前台门户 | 后台管理 | 状态 |
|------|---------|---------|------|
| 对话框宽度 | 1000px | 1000px | ✅ 一致 |
| 布局结构 | 左右分栏 | 左右分栏 | ✅ 一致 |
| 左侧宽度 | 400px | 450px | ⚠️ 略有差异 |
| 图片高度 | 400px | 400px | ✅ 一致 |
| 信息展示 | el-descriptions | el-descriptions | ✅ 一致 |
| 图片预览 | 支持 | 支持 | ✅ 一致 |

**注意：** 前台左侧宽度为 400px，后台为 450px，这是因为后台有图片轮播和操作按钮，需要更多空间。前台只有单张图片展示，400px 已足够。

## 测试步骤

### 1. 清除浏览器缓存
```
Windows/Linux: Ctrl + Shift + R
Mac: Cmd + Shift + R
```

### 2. 访问前台门户
```
http://localhost:5173/portal
```

### 3. 点击文物卡片
- 查看详情对话框是否显示
- 检查对话框宽度是否为 1000px
- 检查是否为左右分栏布局

### 4. 测试图片功能
- 点击图片查看是否能预览大图
- 测试无图片时的占位符显示
- 测试图片加载失败时的错误提示

### 5. 测试信息展示
- 检查"基本信息"标题是否显示
- 检查所有字段是否正确显示
- 检查状态标签颜色是否正确

### 6. 测试交互功能
- 点击"登录后可查看更多详细信息"按钮
- 检查是否跳转到登录页

### 7. 测试响应式
- 缩小浏览器窗口到 768px 以下
- 检查布局是否变为单列
- 检查图片是否在上方，信息是否在下方

## 验证清单

- ✅ 对话框宽度为 1000px
- ✅ 左右分栏布局（400px + 1fr）
- ✅ 左侧显示图片（400px × 400px）
- ✅ 右侧显示详细信息
- ✅ 有"基本信息"标题
- ✅ 使用 el-descriptions 组件
- ✅ 图片可点击预览
- ✅ 有图片加载失败处理
- ✅ 有无图片占位符
- ✅ 有操作提示区域
- ✅ 支持中英文切换
- ✅ 响应式布局正常

## 注意事项

1. **浏览器缓存**：修改后需要强制刷新浏览器（Ctrl + Shift + R）
2. **图片路径**：确保 `currentRelic.imageUrl` 字段正确
3. **翻译键**：所有文本都使用 `t()` 函数，支持中英文切换
4. **响应式**：在移动端会自动切换为单列布局
5. **图片预览**：使用 Element Plus 的图片预览功能，支持缩放和拖拽

## 相关文件

- `frontend/src/views/PublicPortalView.vue` - 前台门户主页面
- `frontend/src/views/RelicsView.vue` - 后台文物管理页面（参考）
- `frontend/src/views/PublicRelicsView.vue` - 前台文物查询页面（已统一）

---

**状态：** ✅ 已完成  
**测试：** 待用户验证  
**更新时间：** 2026年4月27日
