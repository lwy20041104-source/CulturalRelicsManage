# 公开文物查询功能说明

## 功能概述

在前台登录页面添加公开的文物查询功能，未登录用户也可以浏览全部文物信息，但不能进行条件筛选。

## 需求说明

1. **前台登录页面修改**：将"智能文物检索"改为"文物查询"
2. **无需登录访问**：未登录用户可以访问文物查询页面
3. **功能限制**：只能查看全部文物列表，不能进行条件查询（年代、材质、分类等筛选）
4. **引导登录**：页面提示用户登录后可使用更多功能

## 实现内容

### 1. 前台登录页面修改

#### 文件：`frontend/src/i18n/locales/zh-CN.js`
- 修改 `portalLogin.feature1Title`：从"智能文物检索"改为"文物查询"
- 修改 `portalLogin.feature1Desc`：从"通过AI技术快速查找文物信息，支持多维度搜索"改为"浏览全部馆藏文物信息，了解文物详细资料"

#### 文件：`frontend/src/i18n/locales/en-US.js`
- 修改 `portalLogin.feature1Title`：从"Smart Relic Search"改为"Relic Query"
- 修改 `portalLogin.feature1Desc`：从"Quickly find relic information with AI technology"改为"Browse all museum collections and learn detailed information"

#### 文件：`frontend/src/views/PortalLoginView.vue`
- 为第一个功能卡片添加点击事件：`@click="goToPublicRelics"`
- 添加跳转函数：`goToPublicRelics()`，跳转到 `/public-relics`

### 2. 公开文物查询页面

#### 文件：`frontend/src/views/PublicRelicsView.vue`（新建）

**页面结构**：
- **顶部导航栏**：
  - Logo和网站标题
  - 登录和注册按钮
  
- **页面标题**：
  - 标题："文物查询"
  - 副标题："浏览全部馆藏文物，了解历史文化"
  - 提示信息：当前为访客模式，登录后可使用更多功能
  
- **文物列表**：
  - 网格布局展示文物卡片
  - 每个卡片包含：
    - 文物图片（或占位图）
    - 文物名称
    - 年代和材质
    - 状态标签
    - 文物编号
  - 点击卡片查看详情
  
- **分页组件**：
  - 显示总数
  - 上一页/下一页
  - 页码选择
  
- **文物详情对话框**：
  - 文物图片
  - 基本信息表格
  - 所有字段展示

**功能特点**：
- ✅ 无需登录即可访问
- ✅ 只能查看全部文物，不能筛选
- ✅ 支持分页浏览
- ✅ 点击查看详情
- ✅ 响应式设计，支持移动端
- ✅ 美观的UI设计

### 3. 路由配置

#### 文件：`frontend/src/router/index.js`

**新增路由**：
```javascript
{ path: '/public-relics', component: PublicRelicsView }
```

**路由守卫修改**：
```javascript
// 公开文物查询页面无需登录
else if (to.path === '/public-relics') {
  next()
}
```

## 技术实现

### 1. 数据加载
```javascript
const loadRelics = async () => {
  loading.value = true
  try {
    const res = await request.get('/relics', {
      params: query  // 只包含 pageNum 和 pageSize
    })
    // 处理响应数据
  } catch (error) {
    // 错误处理
  } finally {
    loading.value = false
  }
}
```

### 2. 图片URL解析
```javascript
const resolveImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (/^https?:\/\//i.test(imagePath)) return imagePath
  // 处理相对路径
  return `${backendBaseURL}${normalized}`
}
```

### 3. 状态标签颜色
```javascript
const getStatusType = (status) => {
  const typeMap = {
    '在库': 'success',
    '借展中': 'warning',
    '修复中': 'danger',
    '封存': 'info'
  }
  return typeMap[status] || 'info'
}
```

## 页面截图说明

### 1. 前台登录页面
- 左侧展示区第一个功能卡片
- 标题："文物查询"
- 描述："浏览全部馆藏文物信息，了解文物详细资料"
- 点击可跳转到公开文物查询页面

### 2. 公开文物查询页面
- 顶部导航栏：Logo + 登录/注册按钮
- 页面标题和提示信息
- 文物网格列表（3-4列）
- 底部分页组件

### 3. 文物详情对话框
- 大图展示
- 详细信息表格
- 所有字段完整显示

## 使用流程

### 访客浏览流程
1. 访问前台登录页面 `/portal-login`
2. 点击"文物查询"功能卡片
3. 跳转到公开文物查询页面 `/public-relics`
4. 浏览文物列表
5. 点击文物卡片查看详情
6. 如需更多功能，点击"登录"按钮

### 登录用户流程
1. 登录后可访问完整功能
2. 可以使用条件筛选
3. 可以申请借展
4. 可以使用AI查询

## 功能对比

| 功能 | 访客模式 | 登录模式 |
|------|---------|---------|
| 浏览文物列表 | ✅ | ✅ |
| 查看文物详情 | ✅ | ✅ |
| 条件筛选 | ❌ | ✅ |
| 申请借展 | ❌ | ✅ |
| AI智能查询 | ❌ | ✅ |
| 查看借展记录 | ❌ | ✅ |

## 安全考虑

1. **无需认证**：公开页面不需要Token验证
2. **只读访问**：只能查看，不能修改
3. **功能限制**：不能使用高级功能
4. **数据保护**：敏感信息不显示

## 性能优化

1. **分页加载**：每页12条数据
2. **图片懒加载**：使用Element Plus的Image组件
3. **响应式设计**：自适应不同屏幕尺寸
4. **缓存策略**：浏览器缓存静态资源

## 未来扩展

1. **搜索功能**：添加简单的关键词搜索
2. **排序功能**：按年代、名称等排序
3. **收藏功能**：游客可收藏感兴趣的文物
4. **分享功能**：分享文物到社交媒体
5. **统计功能**：记录浏览次数

## 相关文件

### 前端文件（4个）
1. `frontend/src/views/PublicRelicsView.vue` - 公开文物查询页面（新建）
2. `frontend/src/views/PortalLoginView.vue` - 前台登录页面（修改）
3. `frontend/src/router/index.js` - 路由配置（修改）
4. `frontend/src/i18n/locales/zh-CN.js` - 中文国际化（修改）
5. `frontend/src/i18n/locales/en-US.js` - 英文国际化（修改）

### 后端接口
- `GET /relics` - 获取文物列表（已有接口，无需修改）
- 支持分页参数：`pageNum`、`pageSize`
- 返回数据：文物列表和总数

### 文档文件
- `docs/PUBLIC_RELICS_FEATURE.md` - 本文档

## 测试要点

### 1. 功能测试
- ✅ 未登录可访问 `/public-relics`
- ✅ 文物列表正常显示
- ✅ 分页功能正常
- ✅ 详情对话框正常
- ✅ 图片正常显示
- ✅ 登录按钮跳转正常

### 2. 界面测试
- ✅ 响应式布局正常
- ✅ 移动端显示正常
- ✅ 样式美观统一
- ✅ 交互流畅

### 3. 性能测试
- ✅ 页面加载速度快
- ✅ 图片加载正常
- ✅ 分页切换流畅

## 总结

公开文物查询功能已完整实现，主要特点：

✅ **无需登录**：访客可直接浏览文物
✅ **功能限制**：只能查看全部文物，不能筛选
✅ **引导登录**：提示用户登录获取更多功能
✅ **美观易用**：响应式设计，用户体验良好
✅ **安全可靠**：只读访问，数据安全

该功能为博物馆提供了一个公开的文物展示窗口，让更多人了解馆藏文物，同时引导用户注册登录使用完整功能。

---

**实现时间**：2024年
**开发者**：Kiro AI Assistant
**状态**：✅ 已完成


---

## 更新：详情页添加二维码功能

### 更新时间
2024年

### 更新内容

在公开文物查询页面的详情对话框中添加文物二维码显示功能。

### 实现功能

#### 1. 详情对话框布局调整
- 将对话框宽度从800px增加到900px
- 采用左右两栏布局：
  - 左侧：文物图片 + 二维码区域（400px宽）
  - 右侧：文物详细信息

#### 2. 二维码区域
**位置**：文物图片下方

**内容**：
- 标题："文物二维码"（带图标）
- 二维码图片（200x200像素）
- 提示文字："扫描查看文物信息"
- 下载按钮

**状态**：
- 加载中：显示loading动画和"生成中..."文字
- 成功：显示二维码图片和下载按钮
- 失败：显示错误图标和"二维码生成失败"文字

#### 3. 自动生成二维码
- 点击文物卡片查看详情时自动生成二维码
- 调用后端API：`GET /relics/{id}/qrcode`
- 传递参数：`baseUrl`（当前网站地址）
- 返回Base64格式的二维码图片

#### 4. 下载功能
- 点击"下载"按钮可下载二维码
- 文件名格式：`二维码_{文物编号}_{文物名称}.png`
- 使用浏览器原生下载功能

### 技术实现

#### 前端实现

**文件**：`frontend/src/views/PublicRelicsView.vue`

**新增状态变量**：
```javascript
const currentQRCode = ref('')  // 当前二维码Base64数据
const qrcodeLoading = ref(false)  // 二维码加载状态
```

**新增函数**：
```javascript
// 生成二维码
const generateQRCode = async (relicId) => {
  qrcodeLoading.value = true
  try {
    const baseUrl = window.location.origin
    const res = await request.get(`/relics/${relicId}/qrcode`, {
      params: { baseUrl }
    })
    if (res && res.data) {
      currentQRCode.value = res.data
    }
  } catch (error) {
    console.error('生成二维码失败:', error)
    currentQRCode.value = ''
  } finally {
    qrcodeLoading.value = false
  }
}

// 下载二维码
const downloadCurrentQRCode = () => {
  if (!currentQRCode.value || !currentRelic.value) return
  const link = document.createElement('a')
  link.download = `二维码_${currentRelic.value.relicCode}_${currentRelic.value.relicName}.png`
  link.href = currentQRCode.value
  link.click()
  ElMessage.success('二维码已下载')
}
```

**修改viewDetail函数**：
```javascript
const viewDetail = async (relic) => {
  currentRelic.value = relic
  currentQRCode.value = ''
  detailDialogVisible.value = true
  
  // 生成二维码
  await generateQRCode(relic.id)
}
```

**新增图标导入**：
```javascript
import { Grid, Download, WarningFilled } from '@element-plus/icons-vue'
```

#### 后端配置

**文件**：`backend/src/main/java/com/example/config/SecurityConfig.java`

**新增配置**：
```java
.antMatchers(HttpMethod.GET, "/relics/{id}/qrcode").permitAll()  // 允许公开访问文物二维码
```

**说明**：
- 允许未登录用户访问二维码生成接口
- 与文物列表和详情接口保持一致的访问权限

### 样式设计

#### 二维码区域样式
```css
.qrcode-section {
  background: #fff;
  border: 1px solid rgba(181, 136, 82, 0.2);
  border-radius: 12px;
  padding: 20px;
  text-align: center;
}

.qrcode-img {
  width: 200px;
  height: 200px;
  border: 2px solid #eadfce;
  border-radius: 8px;
  padding: 10px;
  background: #fff;
}
```

#### 响应式设计
- 移动端：左右布局改为上下布局
- 二维码区域在移动端显示在文物信息下方

### 用户体验

#### 1. 流畅的交互
- 点击文物卡片后立即打开详情对话框
- 二维码在后台异步加载，不阻塞对话框显示
- 加载过程显示loading动画

#### 2. 清晰的提示
- 加载中：显示"生成中..."
- 成功：显示"扫描查看文物信息"
- 失败：显示"二维码生成失败"

#### 3. 便捷的操作
- 一键下载二维码
- 文件名自动包含文物编号和名称
- 下载成功后显示提示消息

### 应用场景

#### 1. 访客分享
- 访客查看文物详情时可下载二维码
- 分享给朋友，扫码即可查看文物信息

#### 2. 展览使用
- 博物馆可以使用公开页面展示文物
- 下载二维码制作展览标签

#### 3. 教育推广
- 教师可以下载文物二维码
- 用于教学材料和课件

### 测试要点

#### 1. 功能测试
- ✅ 点击文物卡片打开详情对话框
- ✅ 二维码自动生成
- ✅ 二维码图片正常显示
- ✅ 下载按钮正常工作
- ✅ 下载的文件名正确

#### 2. 状态测试
- ✅ 加载中状态显示正常
- ✅ 成功状态显示正常
- ✅ 失败状态显示正常（模拟网络错误）

#### 3. 响应式测试
- ✅ PC端布局正常（左右布局）
- ✅ 移动端布局正常（上下布局）
- ✅ 二维码图片大小适配

### 修改文件清单

#### 前端文件（1个）
1. `frontend/src/views/PublicRelicsView.vue`
   - 修改详情对话框布局
   - 添加二维码区域
   - 添加生成和下载功能
   - 添加相关样式

#### 后端文件（1个）
1. `backend/src/main/java/com/example/config/SecurityConfig.java`
   - 添加二维码接口的公开访问权限

#### 文档文件（1个）
1. `docs/PUBLIC_RELICS_FEATURE.md` - 本文档（更新）

### 效果展示

#### 详情对话框布局
```
┌─────────────────────────────────────────────────────────┐
│                     文物详情                              │
├──────────────────┬──────────────────────────────────────┤
│                  │                                      │
│   文物图片        │        文物名称                       │
│  (350px高)       │                                      │
│                  │   ┌──────────────────────────┐      │
│                  │   │ 文物编号 │ 状态           │      │
├──────────────────┤   ├──────────────────────────┤      │
│  文物二维码       │   │ 年代     │ 材质           │      │
│                  │   ├──────────────────────────┤      │
│  ┌────────┐     │   │ 分类     │ 尺寸           │      │
│  │        │     │   ├──────────────────────────┤      │
│  │ QR码   │     │   │ 重量     │ 来源           │      │
│  │        │     │   ├──────────────────────────┤      │
│  └────────┘     │   │ 描述                      │      │
│                  │   └──────────────────────────┘      │
│ 扫描查看文物信息  │                                      │
│  [下载]          │                                      │
└──────────────────┴──────────────────────────────────────┘
```

### 总结

成功在公开文物查询页面的详情对话框中添加了二维码功能：

✅ **自动生成**：打开详情时自动生成二维码
✅ **美观展示**：专门的二维码区域，样式统一
✅ **便捷下载**：一键下载，文件名自动生成
✅ **状态反馈**：加载、成功、失败状态清晰
✅ **响应式设计**：PC和移动端都能正常显示
✅ **公开访问**：无需登录即可使用

该功能增强了公开文物查询页面的实用性，方便访客分享和传播文物信息。

---

**更新时间**：2024年
**更新者**：Kiro AI Assistant
**状态**：✅ 已完成
