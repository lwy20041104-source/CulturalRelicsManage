# 前台借展人文物查询界面图片修复

## 🐛 问题描述

前台借展人的文物查询界面图片无法显示。

## 🔍 问题原因

前台页面使用了错误的字段名：

```vue
<!-- ❌ 错误：使用 imageUrl -->
<img :src="resolveImageUrl(relic.imageUrl)" />

<!-- ✅ 正确：使用 imagePath -->
<img :src="resolveImageUrl(relic.imagePath)" />
```

**原因分析：**
1. 后端 `CulturalRelic` 实体类的字段名是 `imagePath`
2. 数据库 `cultural_relic` 表的字段名是 `image_path`
3. 前台页面错误地使用了 `imageUrl`

## ✅ 解决方案

### 修改文件

**文件：** `frontend/src/views/PublicPortalView.vue`

**修改位置：** 文物列表渲染部分（第348行）

**修改前：**
```vue
<div class="relic-image">
  <img :src="resolveImageUrl(relic.imageUrl)" :alt="relic.relicName" />
</div>
```

**修改后：**
```vue
<div class="relic-image">
  <img :src="resolveImageUrl(relic.imagePath)" :alt="relic.relicName" />
</div>
```

### 其他位置

**AI查询结果：** 已经正确使用 `relic.imagePath` ✅

**详情对话框：** 使用 `currentRelic.imageUrl`，但在 `viewRelicDetail` 函数中已经将 `imagePath` 赋值给 `imageUrl` ✅

```javascript
const viewRelicDetail = (relic) => {
  currentRelic.value = {
    // ...
    imageUrl: relic.imagePath  // 正确转换
  }
}
```

## 🎯 字段名对照表

| 位置 | 字段名 | 说明 |
|------|--------|------|
| 数据库表 | `image_path` | 下划线命名 |
| 后端实体类 | `imagePath` | 驼峰命名 |
| 前端API响应 | `imagePath` | 与后端一致 |
| 前端文物列表 | `relic.imagePath` | ✅ 正确 |
| 前端详情对话框 | `currentRelic.imageUrl` | ✅ 已转换 |
| AI查询结果 | `relic.imagePath` | ✅ 正确 |

## 🚀 验证步骤

### 1. 刷新前台页面

访问前台登录页面：
```
http://localhost:5173/portal-login
```

### 2. 登录借展人账号

使用任意借展人账号登录（例如：loaner / loaner123）

### 3. 查看文物列表

登录后应该能看到文物列表，每个文物卡片都应该显示图片。

### 4. 检查浏览器控制台

按 F12 打开开发者工具，查看：

**Console 标签：**
```
resolveImageUrl 输入: /uploads/xxx.jpg
本地图片路径转换为: http://localhost:8080/api/uploads/xxx.jpg
```

**Network 标签：**
- 请求 URL：`http://localhost:8080/api/uploads/xxx.jpg`
- 状态码：`200 OK`

### 5. 测试AI查询

在AI查询框中输入关键词，查看查询结果中的图片是否显示。

### 6. 测试详情对话框

点击任意文物卡片，查看详情对话框中的图片是否显示。

## 📝 注意事项

### 1. 数据库中的图片路径

确保数据库中的 `image_path` 字段有值：

```sql
-- 查看文物图片路径
SELECT id, relic_name, image_path FROM cultural_relic WHERE image_path IS NOT NULL;

-- 如果没有图片路径，可以添加测试数据
UPDATE cultural_relic 
SET image_path = '/uploads/test.jpg' 
WHERE id = 1;
```

### 2. 图片文件必须存在

确保 `uploads` 目录中有对应的图片文件：

```bash
# 检查 uploads 目录
dir uploads
# 或
ls uploads
```

### 3. 占位图

如果图片路径为空或图片加载失败，会显示占位图：
```
https://via.placeholder.com/300x200?text=No+Image
```

## 🔧 故障排查

### 问题1：图片还是不显示

**检查：**
1. 是否刷新了页面（Ctrl+F5）
2. 浏览器控制台是否有错误
3. Network 标签中图片请求的状态码

**解决：**
- 如果控制台显示 `resolveImageUrl 输入: undefined`，说明数据库中没有图片路径
- 如果状态码是 404，说明图片文件不存在
- 如果状态码是 403，说明权限配置有问题

### 问题2：部分图片显示，部分不显示

**检查：**
```sql
-- 查看哪些文物有图片路径
SELECT id, relic_name, image_path 
FROM cultural_relic 
WHERE image_path IS NOT NULL;
```

**解决：**
为没有图片的文物添加图片路径，或者上传图片。

### 问题3：AI查询结果图片显示，但列表不显示

**检查：**
AI查询和文物列表使用的是不同的API，确保两个API都返回了 `imagePath` 字段。

## 📊 修改统计

- **修改文件数：** 1 个文件
- **修改行数：** 1 行
- **影响页面：** 前台借展人文物查询页面
- **修复时间：** 2026-04-23

## ✅ 验证结果

- [ ] 文物列表图片正常显示
- [ ] AI查询结果图片正常显示
- [ ] 详情对话框图片正常显示
- [ ] 图片URL格式正确
- [ ] 图片加载成功

---

**修复完成时间：** 2026-04-23  
**版本：** v1.1.0  
**状态：** ✅ 已修复
