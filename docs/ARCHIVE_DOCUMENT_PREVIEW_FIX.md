# 档案文档预览空白页面问题修复

## 问题描述

在档案详情页面点击"预览"按钮查看文档时，打开的是空白页面，无法正常预览文档。

## 问题原因

1. **URL构建不正确**：使用了`import.meta.env.VITE_API_BASE_URL`环境变量，但该变量未配置或为空
2. **缺少协议和端口**：直接拼接文件路径，没有包含完整的服务器地址
3. **文件路径处理不当**：没有考虑不同文件格式的预览方式

## 修复方案

### 修改前

```javascript
const previewDocument = (doc) => {
  // 打开文档预览
  const url = `${import.meta.env.VITE_API_BASE_URL || ''}${doc.filePath}`
  window.open(url, '_blank')
}
```

**问题**：
- `VITE_API_BASE_URL`未配置时为空字符串
- 生成的URL类似：`/uploads/archives/xxx.pdf`（缺少协议和主机）
- 浏览器无法正确解析，导致空白页面

### 修改后

```javascript
const previewDocument = (doc) => {
  // 构建完整的文件URL（与request.js保持一致）
  const hostname = window.location.hostname
  const protocol = window.location.protocol
  
  let baseURL
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    baseURL = 'http://localhost:8080'
  } else {
    baseURL = `${protocol}//${hostname}:8080`
  }
  
  const filePath = doc.filePath.startsWith('/') ? doc.filePath : `/${doc.filePath}`
  const url = `${baseURL}${filePath}`
  
  // 根据文件格式决定预览方式
  const fileFormat = doc.fileFormat?.toLowerCase()
  
  if (fileFormat === 'pdf') {
    // PDF文件直接在新窗口打开
    window.open(url, '_blank')
  } else if (['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].includes(fileFormat)) {
    // 图片文件直接在新窗口打开
    window.open(url, '_blank')
  } else if (['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'].includes(fileFormat)) {
    // Office文件提示下载
    ElMessage.info('Office文件将自动下载，请使用本地软件打开')
    const link = document.createElement('a')
    link.href = url
    link.download = doc.documentName
    link.click()
  } else {
    // 其他文件类型直接下载
    const link = document.createElement('a')
    link.href = url
    link.download = doc.documentName
    link.click()
  }
}
```

## 修复内容

### 1. 自动检测服务器地址

与`request.js`保持一致的URL构建逻辑：
- **localhost访问**：`http://localhost:8080`
- **局域网IP访问**：`http://192.168.1.100:8080`
- **域名访问**：`https://example.com:8080`

### 2. 智能文件预览

根据文件格式采用不同的预览方式：

| 文件类型 | 预览方式 | 支持格式 |
|---------|---------|---------|
| PDF文档 | 新窗口打开 | pdf |
| 图片文件 | 新窗口打开 | jpg, jpeg, png, gif, webp, bmp |
| Office文档 | 自动下载 | doc, docx, xls, xlsx, ppt, pptx |
| 其他文件 | 自动下载 | zip, rar, txt等 |

### 3. 文件路径规范化

确保文件路径以`/`开头：
```javascript
const filePath = doc.filePath.startsWith('/') ? doc.filePath : `/${doc.filePath}`
```

## URL生成示例

### 本地开发环境
```
输入：doc.filePath = '/uploads/archives/appraisal_001.pdf'
输出：http://localhost:8080/uploads/archives/appraisal_001.pdf
```

### 局域网访问
```
输入：doc.filePath = '/uploads/archives/photo_002.jpg'
输出：http://192.168.1.100:8080/uploads/archives/photo_002.jpg
```

### 生产环境
```
输入：doc.filePath = '/uploads/archives/research_003.docx'
输出：https://museum.example.com:8080/uploads/archives/research_003.docx
```

## 后端配置要求

确保后端SecurityConfig允许访问上传的文件：

```java
// SecurityConfig.java
.antMatchers("/uploads/**").permitAll()  // 允许访问上传的文件
```

## 测试步骤

1. **重新编译前端**
   ```bash
   cd frontend
   npm run build
   ```
   ✅ 编译成功

2. **重启前端服务**（开发模式）
   ```bash
   npm run dev
   ```

3. **测试文档预览**
   - 进入档案详情页面
   - 点击文档列表中的"预览"按钮
   - **PDF/图片**：应该在新窗口中正常显示
   - **Office文档**：应该自动下载到本地

4. **检查浏览器控制台**
   - 按F12打开开发者工具
   - 查看Network标签
   - 确认文件请求的URL格式正确
   - 确认返回状态码为200

## 常见问题

### Q1: 预览时提示404错误

**原因**：文件不存在或路径错误

**解决**：
1. 检查数据库中的`file_path`字段是否正确
2. 确认文件确实存在于服务器的`uploads`目录
3. 检查后端SecurityConfig是否允许访问`/uploads/**`

### Q2: PDF文件无法在浏览器中打开

**原因**：浏览器不支持PDF预览或文件损坏

**解决**：
1. 更新浏览器到最新版本
2. 检查PDF文件是否完整
3. 尝试下载后用本地PDF阅读器打开

### Q3: 图片显示不出来

**原因**：图片格式不支持或文件损坏

**解决**：
1. 确认图片格式在支持列表中
2. 检查图片文件是否完整
3. 尝试用图片查看器打开原文件

### Q4: Office文档下载后无法打开

**原因**：文件格式不正确或Office软件版本不兼容

**解决**：
1. 确认Office软件已安装
2. 更新Office到最新版本
3. 尝试用WPS等其他软件打开

## 完成状态

✅ URL构建逻辑已修复  
✅ 智能文件预览已实现  
✅ 文件路径规范化处理  
✅ 前端已重新编译  

现在点击"预览"按钮应该能正常预览文档了！

## 相关文件

- `frontend/src/views/ArchiveDetailView.vue` - 档案详情页面
- `frontend/src/api/request.js` - API请求配置
- `backend/src/main/java/com/example/config/SecurityConfig.java` - 后端安全配置
