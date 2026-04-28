# 档案打印预览功能实现

## 实现日期
2026-04-27

## 功能概述
为档案管理模块添加了简洁的打印预览功能，用户可以在打印前预览档案内容，打印输出仅包含档案信息和打印时间，无菜单栏等多余元素。

## 实现内容

### 1. 前端UI实现

#### 打印预览对话框
在 `frontend/src/views/ArchivesView.vue` 中添加了简洁的打印预览对话框，包含以下内容：

**对话框结构：**
- 标题：显示"打印预览"
- 宽度：900px（适合A4纸张预览）
- 内容区域：
  - **打印标题**：档案详情（居中显示）
  - **打印时间**：当前打印时间（格式：YYYY-MM-DD HH:mm:ss）
  - **档案基本信息**：档案编号、类型、标题、状态、版本
  - **关联文物信息**：文物名称、编号、分类、年代
  - **档案描述**：完整的档案描述内容
  - **档案管理信息**：创建人、创建时间、更新人、更新时间
  - **附件信息**：文档数量（如果有）
- 底部按钮：
  - 取消按钮：关闭预览
  - 打印按钮：调用浏览器打印功能

#### 表格布局
使用原生HTML表格替代Element Plus的Descriptions组件，确保打印效果更好：
- 标签列：20%宽度，灰色背景，右对齐
- 值列：30%宽度，白色背景
- 每行显示2组标签-值对

#### 响应式变量
```javascript
const printPreviewVisible = ref(false)  // 控制对话框显示
const printPreviewData = ref(null)      // 存储打印数据
const currentPrintTime = ref('')        // 当前打印时间
```

#### 核心函数
```javascript
// 打开打印预览
const handlePrint = async (row) => {
  const res = await printArchiveApi(row.id)
  if (res.code === 200) {
    printPreviewData.value = res.data
    // 生成当前时间
    const now = new Date()
    currentPrintTime.value = `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, '0')}-${String(now.getDate()).padStart(2, '0')} ${String(now.getHours()).padStart(2, '0')}:${String(now.getMinutes()).padStart(2, '0')}:${String(now.getSeconds()).padStart(2, '0')}`
    printPreviewVisible.value = true
  }
}

// 执行打印
const doPrint = () => {
  window.print()
}

// 关闭预览
const closePrintPreview = () => {
  printPreviewVisible.value = false
  printPreviewData.value = null
}
```

### 2. 样式实现

#### 预览样式
- **打印标题**：
  - 居中对齐，24px字体
  - 底部2px深色边框
  - 打印时间显示在标题下方
  
- **信息区块**：
  - 每个区块有标题（16px，底部1px边框）
  - 区块之间间距25px
  - 避免跨页断开

- **表格样式**：
  - 完整边框，边框合并
  - 标签列：灰色背景，右对齐
  - 值列：白色背景
  - 单元格内边距：10px 12px

- **描述区域**：
  - 浅灰背景，圆角边框
  - 1.8倍行高，保留换行
  - 自动换行

#### 打印样式（@media print）
- **隐藏策略**：
  - 隐藏所有页面元素（`visibility: hidden`）
  - 只显示打印区域（`#printArea`）
  - 打印区域绝对定位，占满页面

- **布局优化**：
  - 页面边距：20mm
  - 标题字体：22pt
  - 正文字体：10pt
  - 避免表格和章节标题跨页断开

- **边框处理**：
  - 所有边框在打印时使用黑色
  - 确保边框清晰可见

### 3. 国际化支持

#### 中文翻译（zh-CN.js）
```javascript
archive: {
  printPreview: '打印预览',
  archiveInformation: '档案信息',
  attachedFiles: '附件文档',
  fileCount: '文档数量',
  printTime: '打印时间',
}
```

#### 英文翻译（en-US.js）
```javascript
archive: {
  printPreview: 'Print Preview',
  archiveInformation: 'Archive Information',
  attachedFiles: 'Attached Files',
  fileCount: 'File Count',
  printTime: 'Print Time',
}
```

### 4. 后端API
使用现有的 `printArchiveApi(id)` 接口，返回格式：
```javascript
{
  code: 200,
  data: {
    archiveCode: '档案编号',
    archiveTitle: '档案标题',
    archiveType: '档案类型',
    status: '状态',
    version: '版本号',
    description: '档案描述',
    relic: {
      relicName: '文物名称',
      relicCode: '文物编号',
      categoryName: '分类',
      eraName: '年代'
    },
    createdBy: '创建人',
    createdTime: '创建时间',
    updatedBy: '更新人',
    updatedTime: '更新时间',
    documentCount: 文档数量
  }
}
```

## 用户操作流程

1. 在档案列表中，点击某个档案的"更多"按钮
2. 在下拉菜单中选择"打印"选项
3. 系统加载档案数据并显示打印预览对话框
4. 预览显示档案信息和当前打印时间
5. 点击"打印"按钮，调用浏览器打印功能
6. 在浏览器打印对话框中选择打印机和设置
7. 打印输出仅包含档案信息，无菜单栏等多余元素

## 打印输出特点

### 1. 简洁设计
- ✅ 只包含档案信息和打印时间
- ✅ 无菜单栏、按钮等UI元素
- ✅ 清晰的信息层次结构
- ✅ 专业的文档格式

### 2. 打印内容
- 档案详情标题（居中）
- 打印时间（自动生成）
- 档案基本信息表格
- 关联文物信息表格
- 档案描述（如有）
- 档案管理信息表格
- 附件数量（如有）

### 3. 布局优化
- A4纸张适配
- 20mm页边距
- 避免内容跨页断开
- 表格边框清晰可见
- 字体大小适合打印

## 技术特点

### 1. 打印优化
- 使用 `visibility` 而非 `display` 控制元素显示
- 绝对定位确保打印区域占满页面
- 使用 `page-break-inside: avoid` 避免跨页断开
- 打印时边框使用黑色，确保清晰

### 2. 时间处理
- 打开预览时自动生成当前时间
- 格式：YYYY-MM-DD HH:mm:ss
- 使用 `padStart` 确保两位数显示

### 3. 表格布局
- 使用原生HTML表格
- 响应式宽度分配
- 标签-值对清晰对应
- 支持跨列显示长文本

### 4. 用户体验
- 打印前可预览完整内容
- 支持中英文切换
- 清晰的信息层次
- 专业的打印输出

### 5. 代码质量
- 无语法错误
- 完整的国际化支持
- 清晰的代码结构
- 良好的注释说明

## 测试建议

1. **功能测试**
   - 测试打印预览对话框的打开和关闭
   - 验证档案数据的正确显示
   - 验证打印时间的正确生成
   - 测试打印功能是否正常调用

2. **打印效果测试**
   - 测试不同浏览器的打印效果（Chrome、Firefox、Edge）
   - 测试A4纸张的打印效果
   - 测试保存为PDF功能
   - 验证打印输出无菜单栏等多余元素

3. **布局测试**
   - 测试长文本的显示和换行
   - 测试表格跨页情况
   - 测试边框显示效果
   - 测试页边距是否合适

4. **国际化测试**
   - 切换中英文，验证所有文本正确翻译
   - 验证日期时间格式的显示

5. **边界情况测试**
   - 测试没有文物关联的档案
   - 测试没有描述的档案
   - 测试没有附件的档案
   - 测试没有更新记录的档案

## 相关文件

- `frontend/src/views/ArchivesView.vue` - 档案管理视图（打印预览对话框）
- `frontend/src/api/archives.js` - 档案API（printArchiveApi）
- `frontend/src/i18n/locales/zh-CN.js` - 中文翻译
- `frontend/src/i18n/locales/en-US.js` - 英文翻译

## 后续优化建议

1. **功能增强**
   - 添加打印设置选项（页眉、页脚、页码）
   - 支持选择打印内容（只打印基本信息、包含描述等）
   - 添加打印历史记录
   - 支持批量打印多个档案

2. **格式优化**
   - 添加水印功能
   - 支持自定义打印模板
   - 添加公司/机构Logo
   - 支持电子签章

3. **用户体验**
   - 添加打印预览的缩放功能
   - 支持打印前编辑部分内容
   - 添加打印模板选择
   - 提供打印效果预览

## 完成状态
✅ 已完成 - 功能已完整实现，打印输出简洁专业，无菜单栏等多余元素，支持中英文切换

