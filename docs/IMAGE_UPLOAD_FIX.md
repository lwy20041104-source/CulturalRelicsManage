# 图片上传功能修复说明

## 🐛 问题描述

上传图片时出现以下错误：
```
java.io.FileNotFoundException: C:\Users\...\AppData\Local\Temp\tomcat...\upload_xxx.tmp 
(系统找不到指定的文件。)
```

## 🔍 问题原因

1. **相对路径问题**：配置的上传路径 `./uploads/` 是相对路径，在某些情况下会被解析到 Tomcat 的临时目录
2. **目录不存在**：上传目录没有正确创建
3. **静态资源访问未配置**：上传的图片无法通过 URL 访问
4. **文件读取顺序错误**：在调用 `file.transferTo()` 之后尝试读取 `file.getInputStream()`，导致临时文件已被删除

## ✅ 解决方案

### 1. 修复文件保存逻辑

**文件：** `backend/src/main/java/com/example/service/impl/ImageLibraryServiceImpl.java`

**修改内容：**
- **修复读取顺序**：先读取图片尺寸，再保存文件（避免临时文件被删除）
- 将相对路径转换为绝对路径
- 确保目录创建成功
- 返回统一的 URL 路径格式

```java
@Override
@Transactional
public ImageLibrary uploadImage(MultipartFile file, String imageName, String category,
                               String tags, String description, Long uploaderId,
                               String uploaderName) throws IOException {
    // 先获取图片尺寸（在文件转移之前）
    Integer width = null;
    Integer height = null;
    try {
        BufferedImage image = ImageIO.read(file.getInputStream());
        if (image != null) {
            width = image.getWidth();
            height = image.getHeight();
        }
    } catch (Exception e) {
        // 如果读取图片尺寸失败，继续处理，只是尺寸为空
        System.err.println("无法读取图片尺寸: " + e.getMessage());
    }
    
    // 保存文件（这会转移文件，之后无法再读取 InputStream）
    String filePath = saveFile(file);
    
    // ... 创建图片记录
}

private String saveFile(MultipartFile file) throws IOException {
    // 使用绝对路径，避免相对路径问题
    String absoluteUploadPath = uploadPath;
    if (!uploadPath.startsWith("/") && !uploadPath.matches("^[A-Za-z]:.*")) {
        // 如果是相对路径，转换为项目根目录下的绝对路径
        absoluteUploadPath = System.getProperty("user.dir") + File.separator + uploadPath;
    }
    
    File dir = new File(absoluteUploadPath);
    if (!dir.exists()) {
        boolean created = dir.mkdirs();
        if (!created && !dir.exists()) {
            throw new IOException("无法创建上传目录: " + dir.getAbsolutePath());
        }
    }
    
    String originalFilename = file.getOriginalFilename();
    String suffix = "";
    if (originalFilename != null && originalFilename.contains(".")) {
        suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
    }
    
    String filename = UUID.randomUUID().toString().replace("-", "") + suffix;
    File targetFile = new File(dir, filename);
    file.transferTo(targetFile);
    
    // 返回相对路径用于数据库存储和URL访问
    return "/uploads/" + filename;
}
```

**关键点：**
- ⚠️ **必须先读取图片尺寸，再调用 `file.transferTo()`**
- `file.transferTo()` 会将临时文件移动到目标位置并删除临时文件
- 移动后无法再调用 `file.getInputStream()`

### 2. 配置静态资源访问

**新建文件：** `backend/src/main/java/com/example/config/WebMvcConfig.java`

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Value("${file.upload-path:./uploads/}")
    private String uploadPath;
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置上传文件的访问路径
        String absoluteUploadPath = uploadPath;
        if (!uploadPath.startsWith("/") && !uploadPath.matches("^[A-Za-z]:.*")) {
            absoluteUploadPath = System.getProperty("user.dir") + File.separator + uploadPath;
        }
        
        if (!absoluteUploadPath.endsWith(File.separator)) {
            absoluteUploadPath += File.separator;
        }
        
        // 映射 /uploads/** 到实际的文件系统路径
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absoluteUploadPath);
        
        System.out.println("配置静态资源访问路径: /uploads/** -> " + absoluteUploadPath);
    }
}
```

### 3. 配置安全访问

**文件：** `backend/src/main/java/com/example/config/SecurityConfig.java`

**添加：**
```java
.antMatchers("/uploads/**").permitAll()  // 允许访问上传的图片
```

### 4. 配置文件上传大小限制

**文件：** `backend/src/main/resources/application.yml`

**添加：**
```yaml
spring:
  servlet:
    multipart:
      enabled: true
      max-file-size: 10MB
      max-request-size: 10MB
      file-size-threshold: 0
```

## 🚀 部署步骤

### 1. 停止旧的后端服务

在运行后端的终端窗口按 `Ctrl + C`

### 2. 重新启动后端服务

```bash
cd backend
java -jar target/cultural-relics-manage-1.0.0.jar
```

### 3. 验证上传目录

启动后，应该能在控制台看到：
```
配置静态资源访问路径: /uploads/** -> E:\java\Graduate\...\uploads\
```

### 4. 测试上传功能

1. 登录系统（admin / admin123）
2. 进入"图片管理"页面
3. 点击"上传图片"
4. 选择一张图片上传
5. 上传成功后应该能看到图片预览

## 📁 文件结构

上传后的文件结构：
```
项目根目录/
├── backend/
│   ├── src/
│   └── target/
├── frontend/
└── uploads/              ← 上传的图片存储在这里
    ├── xxx.jpg
    ├── yyy.png
    └── zzz.webp
```

## 🔗 访问路径

上传的图片可以通过以下 URL 访问：
```
http://localhost:8080/api/uploads/文件名.jpg
```

例如：
```
http://localhost:8080/api/uploads/d285bf2856ad428788a332f50cd3c3aa.webp
```

## ⚙️ 配置说明

### 修改上传路径

如果需要修改上传路径，编辑 `application.yml`：

```yaml
file:
  upload-path: ./uploads/          # 相对路径（相对于项目根目录）
  # 或
  upload-path: /var/www/uploads/   # 绝对路径（Linux）
  # 或
  upload-path: D:/uploads/         # 绝对路径（Windows）
```

### 修改文件大小限制

```yaml
spring:
  servlet:
    multipart:
      max-file-size: 10MB      # 单个文件最大 10MB
      max-request-size: 10MB   # 请求最大 10MB
```

## 🧪 测试清单

- [ ] 后端服务启动成功
- [ ] 控制台显示静态资源配置信息
- [ ] uploads 目录自动创建
- [ ] 单张图片上传成功
- [ ] 批量图片上传成功
- [ ] 上传的图片可以预览
- [ ] 上传的图片可以下载
- [ ] 图片 URL 可以直接访问

## ❓ 常见问题

### Q1：上传后图片显示不出来？

**A：** 检查：
1. 后端控制台是否有静态资源配置日志
2. uploads 目录是否存在
3. 图片文件是否真的保存了
4. 浏览器控制台是否有 404 错误

### Q2：上传大文件失败？

**A：** 检查 `application.yml` 中的 `max-file-size` 配置，默认是 10MB。

### Q3：权限不足无法创建目录？

**A：** 
- Windows：确保项目目录有写权限
- Linux：使用 `chmod 755 uploads` 设置权限

### Q4：生产环境如何配置？

**A：** 建议使用绝对路径：
```yaml
file:
  upload-path: /var/www/cultural-relics/uploads/  # Linux
  # 或
  upload-path: D:/www/cultural-relics/uploads/    # Windows
```

## 📊 修改文件清单

| 文件 | 操作 | 说明 |
|------|------|------|
| `ImageLibraryServiceImpl.java` | 修改 | 修复文件保存逻辑 |
| `WebMvcConfig.java` | 新建 | 配置静态资源访问 |
| `SecurityConfig.java` | 修改 | 允许访问上传图片 |
| `application.yml` | 修改 | 配置文件上传限制 |

## 🎯 验证命令

### 检查上传目录
```bash
# Windows
dir uploads

# Linux/Mac
ls -la uploads
```

### 测试图片访问
```bash
curl http://localhost:8080/api/uploads/文件名.jpg
```

---

**修复时间：** 2026-04-23  
**版本：** v1.1.0  
**状态：** ✅ 已修复
