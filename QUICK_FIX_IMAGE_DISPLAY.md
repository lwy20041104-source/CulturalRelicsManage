# 快速修复：图片不显示问题

## 问题
✅ 文物添加成功  
✅ 图片上传成功  
✅ 关联关系正确  
❌ 但图片不显示  
❌ 后端报错：`RequestRejectedException: URL contained "//"`

## 快速修复步骤

### 步骤 1: 更新后端代码
已修复的文件：
- ✅ `backend/src/main/java/com/example/utils/FileStorageUtil.java`
- ✅ `backend/src/main/java/com/example/config/SecurityConfig.java`

### 步骤 2: 重启后端服务
```bash
# 停止当前服务
# 重新启动后端
```

### 步骤 3: 修复数据库中的旧数据（如果有）
```bash
# 在 MySQL 中执行
mysql -u root -p cultural_relics < backend/sql/fix_image_paths.sql
```

或者手动执行：
```sql
USE cultural_relics;

-- 修复双斜杠
UPDATE image_library 
SET file_path = REPLACE(file_path, '//', '/')
WHERE file_path LIKE '%//%';

-- 修复 ./ 开头
UPDATE image_library 
SET file_path = CONCAT('/', REPLACE(file_path, './', ''))
WHERE file_path LIKE './%';

-- 验证
SELECT id, file_path FROM image_library ORDER BY id DESC LIMIT 5;
```

### 步骤 4: 测试
1. 登录系统
2. 进入"文物管理"
3. 新增一个文物并上传图片
4. 提交后检查图片是否显示

## 验证清单

### ✅ 后端检查
- [ ] 后端日志显示：`返回的相对路径: /uploads/abc123.jpg`（无双斜杠）
- [ ] 没有 `RequestRejectedException` 错误
- [ ] `uploads/` 目录中有图片文件

### ✅ 数据库检查
```sql
-- 检查最新的图片路径
SELECT id, image_name, file_path 
FROM image_library 
ORDER BY id DESC LIMIT 5;

-- 应该看到类似：/uploads/abc123.jpg
```

### ✅ 前端检查
- [ ] 图片正常显示（不是占位符）
- [ ] 浏览器 Network 标签显示图片请求成功（200）
- [ ] 图片 URL 格式：`http://localhost:8080/api/uploads/abc123.jpg`

## 如果仍然不显示

### 检查 1: 查看后端日志
```
创建上传目录: D:\project\uploads
文件已保存到: D:\project\uploads\abc123.jpg
返回的相对路径: /uploads/abc123.jpg  <- 应该是这个格式
```

### 检查 2: 直接访问图片
在浏览器中访问：
```
http://localhost:8080/api/uploads/abc123.jpg
```
- 如果显示图片 → 路径正确，检查前端代码
- 如果 404 → 文件不存在或路径映射错误
- 如果 403 → 权限问题

### 检查 3: 验证文件存在
```bash
# Windows
dir uploads

# Linux/Mac
ls -la uploads/
```

## 常见错误

### 错误 1: 路径仍有双斜杠
**原因**：代码未重新编译  
**解决**：完全重启后端服务

### 错误 2: 图片 404
**原因**：文件不存在或路径映射错误  
**解决**：检查 `WebMvcConfig.java` 的静态资源映射

### 错误 3: 图片 403
**原因**：Spring Security 拦截  
**解决**：检查 `SecurityConfig.java` 中的 `.antMatchers("/uploads/**").permitAll()`

## 技术细节

### 正确的路径格式
```
配置: ./uploads/
↓ 规范化
uploads
↓ 拼接
/uploads/abc123.jpg  ✅
```

### 错误的路径格式
```
配置: ./uploads/
↓ 直接拼接
/./uploads//abc123.jpg  ❌ 双斜杠
```

## 相关文档
- 详细说明：`docs/FIX_DOUBLE_SLASH_IMAGE_PATH.md`
- 修复脚本：`backend/sql/fix_image_paths.sql`
- 更新日志：`CHANGELOG.md`
