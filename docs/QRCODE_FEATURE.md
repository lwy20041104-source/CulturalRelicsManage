# 文物二维码功能说明

## 功能概述

为每个文物生成唯一的二维码标签，扫描二维码可以查看文物的基本信息。该功能支持二维码的生成、显示、下载和打印。

## 功能特点

### 1. 二维码生成
- **唯一性**：每个文物都有唯一的二维码，基于文物ID生成
- **包含信息**：二维码包含文物编号、文物名称等标识信息
- **扫描跳转**：扫描后跳转到专门的文物信息展示页面（无需登录）

### 2. 二维码内容
- 二维码URL格式：`{前端地址}/qrcode/{文物ID}`
- 二维码标签包含：
  - 二维码图片（200x200像素）
  - 文物编号
  - 文物名称
  - 扫描提示文字

### 3. 操作功能
- **查看二维码**：在文物列表中点击"二维码"按钮
- **下载二维码**：将二维码保存为PNG图片文件
- **打印二维码**：生成打印预览，可直接打印二维码标签

## 技术实现

### 后端实现

#### 1. 依赖库
使用Google ZXing库生成二维码：
```xml
<dependency>
    <groupId>com.google.zxing</groupId>
    <artifactId>core</artifactId>
    <version>3.5.1</version>
</dependency>
<dependency>
    <groupId>com.google.zxing</groupId>
    <artifactId>javase</artifactId>
    <version>3.5.1</version>
</dependency>
```

#### 2. 工具类
- **文件位置**：`backend/src/main/java/com/example/util/QRCodeUtil.java`
- **主要方法**：
  - `generateRelicQRCodeUrl()`：生成二维码URL
  - `generateQRCodeLabelBase64()`：生成带标签的二维码（Base64格式）
  - `generateQRCodeImage()`：生成二维码图片
  - `addTextToImage()`：在图片上添加文字标签

#### 3. API接口
- **文件位置**：`backend/src/main/java/com/example/controller/CulturalRelicController.java`
- **接口列表**：
  - `GET /relics/{id}/qrcode`：生成单个文物二维码
  - `POST /relics/batch/qrcode`：批量生成文物二维码

### 前端实现

#### 1. API接口
- **文件位置**：`frontend/src/api/relics.js`
- **新增接口**：
  - `getRelicByIdApi(id)`：根据ID获取文物详情
  - `generateQRCodeApi(id, baseUrl)`：生成文物二维码
  - `batchGenerateQRCodeApi(ids, baseUrl)`：批量生成二维码

#### 2. 文物列表页面
- **文件位置**：`frontend/src/views/RelicsView.vue`
- **新增功能**：
  - 操作列添加"二维码"按钮
  - 二维码对话框组件
  - 二维码显示、下载、打印功能

#### 3. 二维码扫描页面
- **文件位置**：`frontend/src/views/QRCodeScanView.vue`
- **功能特点**：
  - 无需登录即可访问
  - 展示文物基本信息（编号、名称、年代、材质、分类、状态等）
  - 响应式设计，支持移动端扫描
  - 显示扫描时间

#### 4. 路由配置
- **文件位置**：`frontend/src/router/index.js`
- **新增路由**：`/qrcode/:id` - 二维码扫描页面

## 使用流程

### 1. 生成二维码
1. 进入文物管理页面
2. 在文物列表中找到目标文物
3. 点击操作列的"二维码"按钮
4. 系统自动生成并显示二维码

### 2. 下载二维码
1. 在二维码对话框中
2. 点击"下载二维码"按钮
3. 二维码图片自动保存到本地
4. 文件名格式：`二维码_{文物编号}_{文物名称}.png`

### 3. 打印二维码
1. 在二维码对话框中
2. 点击"打印二维码"按钮
3. 系统生成打印预览页面
4. 包含文物名称、编号、二维码和扫描提示
5. 点击"打印"按钮完成打印

### 4. 扫描二维码
1. 使用手机或扫码设备扫描二维码
2. 自动跳转到文物信息展示页面
3. 无需登录即可查看文物基本信息
4. 可选择"查看详情"进入完整信息页面（需登录）

## 应用场景

### 1. 文物标签管理
- 为每个文物制作实体标签
- 贴在文物展柜或存储位置
- 方便快速识别和查询

### 2. 展览导览
- 观众扫码查看文物信息
- 无需人工讲解
- 提升参观体验

### 3. 库房管理
- 快速定位文物
- 扫码查看存储信息
- 提高管理效率

### 4. 文物盘点
- 扫码记录盘点信息
- 自动生成盘点报告
- 减少人工错误

## 注意事项

1. **URL配置**：确保前端baseUrl配置正确，否则扫描后无法正确跳转
2. **网络访问**：扫描页面需要网络访问，确保服务器可访问
3. **图片质量**：二维码默认200x200像素，可根据需要调整
4. **打印设置**：打印时建议使用A4纸张，边距20mm
5. **移动端适配**：扫描页面已做响应式设计，支持各种屏幕尺寸

## 未来扩展

1. **批量生成**：支持批量生成多个文物的二维码
2. **自定义样式**：支持自定义二维码颜色、Logo等
3. **统计分析**：记录扫码次数、时间等数据
4. **多语言支持**：扫描页面支持多语言切换
5. **离线模式**：支持离线查看已缓存的文物信息

## 相关文件

### 后端文件
- `backend/src/main/java/com/example/util/QRCodeUtil.java` - 二维码工具类
- `backend/src/main/java/com/example/controller/CulturalRelicController.java` - 控制器（新增接口）
- `backend/pom.xml` - Maven依赖配置

### 前端文件
- `frontend/src/views/RelicsView.vue` - 文物列表页面（新增二维码功能）
- `frontend/src/views/QRCodeScanView.vue` - 二维码扫描页面
- `frontend/src/api/relics.js` - API接口定义
- `frontend/src/router/index.js` - 路由配置

### 文档文件
- `docs/QRCODE_FEATURE.md` - 本文档
