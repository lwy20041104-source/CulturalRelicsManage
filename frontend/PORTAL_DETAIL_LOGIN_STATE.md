# 前台门户文物详情登录状态区分

## 修改时间
2026年4月27日

## 修改文件
`frontend/src/views/PublicPortalView.vue`

## 问题修复

### 1. 图片显示问题
**问题：** 图片字段名错误，使用了 `imageUrl` 而不是 `imagePath`

**修复：**
```vue
<!-- 修改前 -->
<el-image v-if="currentRelic.imageUrl" :src="resolveImageUrl(currentRelic.imageUrl)">

<!-- 修改后 -->
<el-image v-if="currentRelic.imagePath" :src="resolveImageUrl(currentRelic.imagePath)">
```

### 2. 未登录用户显示简化信息
**问题：** 未登录用户看到的信息过于详细

**修复：** 未登录用户只显示：
- 文物名称
- 年代
- 分类

### 3. 已登录用户不显示登录提示
**问题：** 已登录用户仍然看到"想了解更多？登录后可查看更多详细信息"

**修复：** 根据登录状态显示不同内容

## 详细修改

### 1. 新增登录状态判断（第1525-1527行）

```javascript
const isLoggedIn = computed(() => {
  return !!sessionStorage.getItem('token')
})
```

### 2. 修改详情对话框结构（第892-985行）

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
      <!-- 已登录用户：显示完整信息 -->
      <template v-if="isLoggedIn">
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
      </template>

      <!-- 未登录用户：显示简化信息 -->
      <template v-else>
        <div class="detail-section">
          <h3 class="section-title">{{ t('basicInfo') }}</h3>
          <el-descriptions :column="2" border>
            <el-descriptions-item :label="t('relicName')" :span="2">{{ currentRelic.relicName }}</el-descriptions-item>
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
      </template>
    </div>
  </div>
</el-dialog>
```

## 功能对比

### 已登录用户看到的信息
- ✅ 文物编号
- ✅ 文物名称
- ✅ 年代
- ✅ 材质
- ✅ 分类
- ✅ 状态
- ✅ 尺寸
- ✅ 重量
- ✅ 来源
- ✅ 描述
- ❌ 不显示登录提示

### 未登录用户看到的信息
- ❌ 文物编号（隐藏）
- ✅ 文物名称
- ✅ 年代
- ❌ 材质（隐藏）
- ✅ 分类
- ❌ 状态（隐藏）
- ❌ 尺寸（隐藏）
- ❌ 重量（隐藏）
- ❌ 来源（隐藏）
- ❌ 描述（隐藏）
- ✅ 显示登录提示

## 登录状态判断逻辑

```javascript
const isLoggedIn = computed(() => {
  return !!sessionStorage.getItem('token')
})
```

**判断依据：** 检查 `sessionStorage` 中是否存在 `token`
- 有 token → 已登录
- 无 token → 未登录

## 测试步骤

### 测试1：未登录状态
1. 清除浏览器缓存（Ctrl + Shift + R）
2. 打开浏览器无痕模式
3. 访问 `http://localhost:5173/portal`
4. 点击任意文物卡片查看详情
5. **预期结果：**
   - ✅ 图片正常显示
   - ✅ 只显示：文物名称、年代、分类
   - ✅ 显示"想了解更多？登录后可查看更多详细信息"
   - ✅ 点击"登录后可查看更多详细信息"跳转到登录页

### 测试2：已登录状态
1. 访问 `http://localhost:5173/portal-login`
2. 登录系统
3. 返回首页
4. 点击任意文物卡片查看详情
5. **预期结果：**
   - ✅ 图片正常显示
   - ✅ 显示完整信息（10个字段）
   - ✅ 不显示登录提示

### 测试3：图片显示
1. 选择有图片的文物
2. 点击查看详情
3. **预期结果：**
   - ✅ 图片正常显示
   - ✅ 点击图片可预览大图

4. 选择无图片的文物
5. 点击查看详情
6. **预期结果：**
   - ✅ 显示"暂无图片"占位符

## 验证清单

### 图片显示
- ✅ 使用正确的字段名 `imagePath`
- ✅ 有图片时正常显示
- ✅ 无图片时显示占位符
- ✅ 图片加载失败时显示错误提示
- ✅ 点击图片可预览大图

### 未登录用户
- ✅ 只显示3个字段（文物名称、年代、分类）
- ✅ 显示登录提示
- ✅ 点击登录按钮跳转到登录页

### 已登录用户
- ✅ 显示10个字段（完整信息）
- ✅ 不显示登录提示
- ✅ 可以正常查看所有信息

### 响应式
- ✅ 桌面端：左右分栏布局
- ✅ 移动端：单列布局

## 字段对比表

| 字段 | 未登录 | 已登录 |
|------|--------|--------|
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
| 登录提示 | ✅ | ❌ |

## 注意事项

1. **图片字段名**：确保使用 `imagePath` 而不是 `imageUrl`
2. **登录判断**：基于 `sessionStorage.getItem('token')` 判断
3. **信息保护**：未登录用户只能看到基本信息，保护详细数据
4. **用户体验**：未登录用户看到登录提示，引导注册登录
5. **浏览器缓存**：修改后需要强制刷新（Ctrl + Shift + R）

## 相关文件

- `frontend/src/views/PublicPortalView.vue` - 前台门户主页面
- `frontend/PORTAL_DETAIL_UNIFICATION.md` - 详情界面统一修改文档

---

**状态：** ✅ 已完成  
**测试：** 待用户验证  
**更新时间：** 2026年4月27日
