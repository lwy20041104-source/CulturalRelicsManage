# 档案文档预览404错误修复

## 问题描述
档案管理界面的详情页面中，点击"预览"按钮查看档案文档时，浏览器显示404错误，无法访问文件。

## 问题原因
后端应用配置了 `context-path: /api`，这意味着所有的API请求和静态资源都需要通过 `/api` 前缀访问。

- **错误的访问路径**: `http://localhost:8080/uploads/xxx.webp`
- **正确的访问路径**: `http://localhost:8080/api/uploads/xxx.webp`

前端代码在构建文件URL时，没有包含 `/api` 前缀，导致请求的路径不正确。

## 修复方案

### 1. 后端配置确认
确认以下配置正确：

**application.yml**
```yaml
server:
  port: 8080
  servlet:
    context-path: /api

file:
  upload-path: ./uploads/
```

**WebMvcConfig.java**
```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
    registry.addResourceHandler("/uploads/**")
            .addResourceLocations("file:" + absoluteUploadPath);
    
    System.out.println("配置静态资源访问路径: /api/uploads/** -> " + absoluteUploadPath);
}
```

**SecurityConfig.java**
```java
.antMatchers("/uploads/**").permitAll()  // 允许访问上传的图片（/api/uploads/**）
```

### 2. 前端代码修复
修改 `frontend/src/views/ArchiveDetailView.vue` 中的 `previewDocument` 方法：

**修改前**:
```javascript
let baseURL
if (hostname === 'localhost' || hostname === '127.0.0.1') {
  baseURL = 'http://localhost:8080'
} else {
  baseURL = `${protocol}//${hostname}:8080`
}
```

**修改后**:
```javascript
let baseURL
if (hostname === 'localhost' || hostname === '127.0.0.1') {
  baseURL = 'http://localhost:8080/api'  // 添加 /api 前缀
} else {
  baseURL = `${protocol}//${hostname}:8080/api`  // 添加 /api 前缀
}
```

### 3. 添加调试日志
在 `previewDocument` 方法中添加了 `console.log('预览文件URL:', url)`，方便调试时查看实际请求的URL。

## 验证步骤

1. **重启后端服务**
   ```bash
   cd backend
   mvn spring-boot:run
   ```

2. **重新构建前端**
   ```bash
   cd frontend
   npm run build
   ```

3. **测试文件访问**
   - 登录系统
   - 进入"档案管理"菜单
   - 点击任意档案的"详情"按钮
   - 点击文档列表中的"预览"按钮
   - 图片应该在新窗口中正常显示

4. **浏览器开发者工具验证**
   - 打开浏览器开发者工具（F12）
   - 切换到 Network 标签
   - 点击预览按钮
   - 查看请求的URL应该是: `http://localhost:8080/api/uploads/xxx.webp`
   - 响应状态码应该是: `200 OK`

## 文件路径说明

### 数据库中的文件路径格式
```sql
-- archive_document 表中的 file_path 字段
'/uploads/e1f44f18efda4cbf918cc666a368091a.webp'
'/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg'
```

### 实际文件系统路径
```
backend/uploads/e1f44f18efda4cbf918cc666a368091a.webp
backend/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg
```

### 访问URL
```
http://localhost:8080/api/uploads/e1f44f18efda4cbf918cc666a368091a.webp
http://localhost:8080/api/uploads/5bf9f4260a2a4291a12ee2fdd3373c08.jpg
```

## 相关文件

### 后端文件
- `backend/src/main/java/com/example/config/WebMvcConfig.java` - 静态资源映射配置
- `backend/src/main/java/com/example/config/SecurityConfig.java` - 安全配置
- `backend/src/main/resources/application.yml` - 应用配置

### 前端文件
- `frontend/src/views/ArchiveDetailView.vue` - 档案详情页面

### 数据文件
- `backend/sql/archive_insert.sql` - 档案数据插入语句
- `backend/uploads/` - 文件存储目录

## 注意事项

1. **context-path 的影响**: 所有通过 Spring MVC 处理的请求（包括静态资源）都会受到 `context-path` 的影响
2. **文件路径一致性**: 数据库中存储的路径应该是 `/uploads/xxx`，不要包含 `/api` 前缀
3. **前端URL构建**: 前端在构建完整URL时需要添加 `/api` 前缀
4. **跨域访问**: 如果前端和后端不在同一域名，需要确保CORS配置正确

## 编译状态
- ✅ 后端编译成功
- ✅ 前端编译成功

## 修复时间
2026-04-24
