# 前台门户文物详情最终版本

## 修改时间
2026年4月27日

## 修改文件
`frontend/src/views/PublicPortalView.vue`

## 最终需求

### 未登录用户
- ❌ 不显示文物图片
- ❌ 不显示二维码
- ✅ 只显示基本信息（3个字段）
- ✅ 显示登录提示

### 已登录用户
- ✅ 显示文物图片（可预览）
- ✅ 显示完整信息（10个字段）
- ❌ 不显示登录提示

## 详细修改

### 1. 对话框宽度动态调整（第895行）

```vue
<!-- 根据登录状态调整对话框宽度 -->
<el-dialog 
  v-model="relicDetailVisible" 
  :title="t('relicDetail')" 
  :width="isLoggedIn ? '1000px' : '600px'"
  class="detail-dialog"
  :close-on-click-modal="false"
>
```

**说明：**
- 已登录：1000px（需要显示图片，宽度较大）
- 未登录：600px（只显示文字信息，宽度较小）

### 2. 已登录用户布局（第900-960行）

```vue
<!-- 已登录用户：显示完整信息（左右布局） -->
<div v-if="isLoggedIn" class="detail-container">
  <!-- 左侧：图片展示 -->
  <div class="detail-left">
    <div class="detail-image-wrapper">
      <el-image
        v-if="currentRelic.imagePath"
        :src="resolveImageUrl(currentRelic.imagePath)"
        fit="contain"
        class="detail-main-image"
        :preview-src-list="[resolveImageUrl(currentRelic.imagePath)]"
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
  </div>
</div>
```

**布局特点：**
- 左右分栏布局（400px + 1fr）
- 左侧：图片展示区域（400px × 400px）
- 右侧：完整信息（10个字段）
- 图片可点击预览

### 3. 未登录用户布局（第962-985行）

```vue
<!-- 未登录用户：只显示基本信息（单列布局，无图片） -->
<div v-else class="detail-simple">
  <div class="detail-section">
    <h3 class="section-title">{{ t('basicInfo') }}</h3>
    <el-descriptions :column="1" border>
      <el-descriptions-item :label="t('relicName')">{{ currentRelic.relicName }}</el-descriptions-item>
      <el-descriptions-item :label="t('era')">{{ currentRelic.era }}</el-descriptions-item>
      <el-descriptions-item :label="t('category')">{{ currentRelic.categoryName || '—' }}</el-descriptions-item>
    </el-descriptions>
  </div>

  <!-- 登录提示 -->
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
```

**布局特点：**
- 单列布局（无图片）
- 只显示3个基本字段
- 显示登录提示
- 对话框宽度较小（600px）

### 4. 新增 CSS 样式（第4450-4540行）

```css
/* 文物详情对话框样式 */
.detail-dialog :deep(.el-dialog__body) {
  padding: 30px;
}

/* 已登录用户：左右分栏布局 */
.detail-container {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: 30px;
}

/* 未登录用户：单列布局 */
.detail-simple {
  max-width: 100%;
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

.detail-section:last-child {
  margin-bottom: 0;
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

## 功能对比表

| 功能/字段 | 未登录用户 | 已登录用户 |
|----------|-----------|-----------|
| 对话框宽度 | 600px | 1000px |
| 布局方式 | 单列 | 左右分栏 |
| 文物图片 | ❌ 不显示 | ✅ 显示 |
| 图片预览 | ❌ 不可用 | ✅ 可点击预览 |
| 二维码 | ❌ 不显示 | ❌ 不显示 |
| 文物编号 | ❌ | ✅ |
| 文物名称 | ✅ | ✅ |
| 年代 | ✅ | ✅ |
| 材质 | ❌ | ✅ |
| 分类 | ✅ | ✅ |
| 状态 | ❌ | ✅ |
| 尺寸 | ❌ | ✅ |
| 重量 | ❌ | ✅ |
| 来源 | ❌ | ✅ |
| 描述 | ❌ | ✅ |
| 登录提示 | ✅ 显示 | ❌ 不显示 |

## 视觉效果对比

### 未登录用户界面
```
┌─────────────────────────────────────┐
│          文物详情 (600px)            │
├─────────────────────────────────────┤
│                                     │
│  基本信息                            │
│  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  ┌─────────────────────────────┐   │
│  │ 文物名称 │ 青铜鼎            │   │
│  ├─────────────────────────────┤   │
│  │ 年代     │ 商朝              │   │
│  ├─────────────────────────────┤   │
│  │ 分类     │ 青铜器            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ℹ️ 想了解更多？               │   │
│  │    [登录后可查看更多详细信息]  │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 已登录用户界面
```
┌───────────────────────────────────────────────────────────────┐
│                    文物详情 (1000px)                           │
├───────────────────────────────────────────────────────────────┤
│                                                               │
│  ┌──────────────┐  基本信息                                   │
│  │              │  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━  │
│  │              │  ┌─────────────┬─────────────────────┐    │
│  │   文物图片    │  │ 文物编号    │ WW-2024-001        │    │
│  │   (400x400)  │  ├─────────────┼─────────────────────┤    │
│  │              │  │ 文物名称    │ 青铜鼎              │    │
│  │  (可点击预览) │  ├─────────────┼─────────────────────┤    │
│  │              │  │ 年代        │ 商朝                │    │
│  └──────────────┘  ├─────────────┼─────────────────────┤    │
│                    │ 材质        │ 青铜                │    │
│                    ├─────────────┼─────────────────────┤    │
│                    │ 分类        │ 青铜器              │    │
│                    ├─────────────┼─────────────────────┤    │
│                    │ 状态        │ [在库]              │    │
│                    ├─────────────┼─────────────────────┤    │
│                    │ 尺寸        │ 高30cm 宽25cm       │    │
│                    ├─────────────┼─────────────────────┤    │
│                    │ 重量        │ 5.50 kg             │    │
│                    ├─────────────┴─────────────────────┤    │
│                    │ 来源        │ 河南安阳殷墟        │    │
│                    ├─────────────────────────────────────┤    │
│                    │ 描述        │ 商代晚期青铜器...   │    │
│                    └─────────────────────────────────────┘    │
│                                                               │
└───────────────────────────────────────────────────────────────┘
```

## 测试步骤

### 测试1：未登录用户

**前置条件：**
1. 清除浏览器缓存（Ctrl + Shift + R）
2. 清除 sessionStorage（F12 → Application → Session Storage → Clear）
3. 或使用无痕模式（Ctrl + Shift + N）

**操作步骤：**
1. 访问 `http://localhost:5173/portal`
2. 滚动到"文物搜索"部分
3. 点击任意文物卡片

**预期结果：**
- ✅ 对话框宽度为 600px（较窄）
- ✅ 不显示文物图片
- ✅ 不显示二维码
- ✅ 只显示3个字段：文物名称、年代、分类
- ✅ 显示登录提示："想了解更多？登录后可查看更多详细信息"
- ✅ 点击"登录后可查看更多详细信息"跳转到登录页

### 测试2：已登录用户

**前置条件：**
1. 访问 `http://localhost:5173/portal-login`
2. 使用有效账号登录
3. 登录成功后返回首页

**操作步骤：**
1. 滚动到"文物搜索"部分
2. 点击任意文物卡片

**预期结果：**
- ✅ 对话框宽度为 1000px（较宽）
- ✅ 左侧显示文物图片（400px × 400px）
- ✅ 图片可点击预览大图
- ✅ 右侧显示完整信息（10个字段）
- ✅ 不显示登录提示
- ✅ 不显示二维码

### 测试3：从 AI 搜索查看详情

**前置条件：**
- 已登录或未登录

**操作步骤：**
1. 滚动到"AI智能搜索"部分
2. 输入问题并搜索
3. 点击搜索结果中的"查看详情"

**预期结果：**
- 根据登录状态显示对应的详情界面
- 图片字段正确（使用 `imagePath`）

## 关键代码位置

### 1. 对话框宽度动态调整
- 文件：`frontend/src/views/PublicPortalView.vue`
- 位置：第895行
- 代码：`:width="isLoggedIn ? '1000px' : '600px'"`

### 2. 登录状态判断
- 文件：`frontend/src/views/PublicPortalView.vue`
- 位置：第1539-1541行
- 代码：
  ```javascript
  const isLoggedIn = computed(() => {
    return !!sessionStorage.getItem('token')
  })
  ```

### 3. 已登录用户布局
- 文件：`frontend/src/views/PublicPortalView.vue`
- 位置：第900-960行
- 条件：`v-if="isLoggedIn"`

### 4. 未登录用户布局
- 文件：`frontend/src/views/PublicPortalView.vue`
- 位置：第962-985行
- 条件：`v-else`

## 注意事项

1. **浏览器缓存**
   - 修改后必须清除浏览器缓存
   - 推荐使用 Ctrl + Shift + R 强制刷新

2. **登录状态检查**
   - 基于 `sessionStorage.getItem('token')` 判断
   - 登录后 token 会自动存储
   - 退出登录后 token 会被清除

3. **图片字段**
   - 使用 `currentRelic.imagePath` 而不是 `imageUrl`
   - 已修复 `viewRelicDetailFromAi` 函数中的字段名

4. **响应式设计**
   - 移动端（<768px）：已登录用户的布局会变为单列
   - 未登录用户始终是单列布局

5. **二维码**
   - 当前版本不显示二维码（已登录和未登录都不显示）
   - 如需显示，可在已登录用户的左侧区域添加

## 相关文件

- `frontend/src/views/PublicPortalView.vue` - 前台门户主页面（已修改）
- `frontend/PORTAL_DETAIL_UNIFICATION.md` - 详情界面统一修改文档
- `frontend/PORTAL_DETAIL_LOGIN_STATE.md` - 登录状态区分文档
- `frontend/PORTAL_DETAIL_DEBUG_GUIDE.md` - 调试指南

---

**状态：** ✅ 已完成  
**测试：** 待用户验证  
**更新时间：** 2026年4月27日
