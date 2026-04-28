# 数据导出格式功能说明

## 功能概述

系统现已支持多种格式的数据导出功能，包括：
- ✅ **Excel格式** (.xlsx) - 已有功能
- ✨ **PDF格式** (.pdf) - 新增功能
- ✨ **Word格式** (.docx) - 新增功能

---

## 技术实现

### 1. 依赖库

#### Excel导出
- **Apache POI 5.2.3**
  - poi：核心库
  - poi-ooxml：支持.xlsx格式

#### PDF导出
- **iText7 7.2.5**
  - itext7-core：PDF核心库
  - html2pdf：HTML转PDF
  - font-asian：中文字体支持

#### Word导出
- **Apache POI 5.2.3**
  - poi-ooxml：支持.docx格式
  - poi-scratchpad：Word文档处理

### 2. Maven依赖配置

```xml
<!-- Apache POI for Excel & Word -->
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi</artifactId>
    <version>5.2.3</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-ooxml</artifactId>
    <version>5.2.3</version>
</dependency>
<dependency>
    <groupId>org.apache.poi</groupId>
    <artifactId>poi-scratchpad</artifactId>
    <version>5.2.3</version>
</dependency>

<!-- iText for PDF -->
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itext7-core</artifactId>
    <version>7.2.5</version>
    <type>pom</type>
</dependency>
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>html2pdf</artifactId>
    <version>4.0.5</version>
</dependency>
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>font-asian</artifactId>
    <version>7.2.5</version>
</dependency>
```

---

## API接口

### 1. 导出Excel
**接口地址：** `GET /api/relics/export`

**请求参数：**
- relicName（可选）：文物名称
- categoryId（可选）：分类ID
- status（可选）：状态
- era（可选）：年代

**响应：** 下载Excel文件

**示例：**
```bash
curl -O "http://localhost:8080/api/relics/export?status=在库"
```

---

### 2. 导出PDF ✨ NEW
**接口地址：** `GET /api/relics/export/pdf`

**请求参数：**
- relicName（可选）：文物名称
- categoryId（可选）：分类ID
- status（可选）：状态
- era（可选）：年代

**响应：** 下载PDF文件

**示例：**
```bash
curl -O "http://localhost:8080/api/relics/export/pdf?status=在库"
```

---

### 3. 导出Word ✨ NEW
**接口地址：** `GET /api/relics/export/word`

**请求参数：**
- relicName（可选）：文物名称
- categoryId（可选）：分类ID
- status（可选）：状态
- era（可选）：年代

**响应：** 下载Word文件

**示例：**
```bash
curl -O "http://localhost:8080/api/relics/export/word?status=在库"
```

---

## 导出内容

### 数据字段
所有格式的导出文件都包含以下字段：

| 字段 | 说明 |
|------|------|
| 编号 | 文物编号 |
| 名称 | 文物名称 |
| 年代 | 文物年代 |
| 材质 | 文物材质 |
| 分类 | 文物分类 |
| 状态 | 文物状态 |
| 尺寸 | 文物尺寸 |
| 重量(kg) | 文物重量 |
| 来源 | 文物来源 |
| 描述 | 文物描述 |

### 文件结构

#### Excel格式
- 标题行：灰色背景，加粗字体
- 数据行：标准格式
- 自动调整列宽
- 文件名：`文物数据_yyyyMMddHHmmss.xlsx`

#### PDF格式
- 标题：居中，18号字体，加粗
- 导出时间：右对齐，10号字体
- 表格：带边框，表头灰色背景
- 页脚：显示总记录数
- 中文字体：宋体（STSong-Light）
- 文件名：`文物数据_yyyyMMddHHmmss.pdf`

#### Word格式
- 标题：居中，18号字体，加粗
- 导出时间：右对齐，10号字体
- 表格：带边框，表头灰色背景
- 页脚：显示总记录数
- 中文字体：宋体
- 文件名：`文物数据_yyyyMMddHHmmss.docx`

---

## 使用方法

### 前端调用示例

```javascript
// 导出Excel
const exportExcel = () => {
  window.location.href = `/api/relics/export?status=在库`
}

// 导出PDF
const exportPdf = () => {
  window.location.href = `/api/relics/export/pdf?status=在库`
}

// 导出Word
const exportWord = () => {
  window.location.href = `/api/relics/export/word?status=在库`
}
```

### 前端按钮示例

```vue
<template>
  <el-dropdown>
    <el-button type="primary">
      导出数据 <el-icon><ArrowDown /></el-icon>
    </el-button>
    <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item @click="exportExcel">
          <el-icon><Document /></el-icon> 导出Excel
        </el-dropdown-item>
        <el-dropdown-item @click="exportPdf">
          <el-icon><Document /></el-icon> 导出PDF
        </el-dropdown-item>
        <el-dropdown-item @click="exportWord">
          <el-icon><Document /></el-icon> 导出Word
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
</template>
```

---

## 测试步骤

### 1. 更新Maven依赖
```bash
cd backend
mvn clean install
```

### 2. 重启后端服务
```bash
mvn spring-boot:run
```

### 3. 测试导出功能

#### 方法1：使用浏览器
1. 访问：`http://localhost:8080/api/relics/export/pdf`
2. 浏览器会自动下载PDF文件

#### 方法2：使用curl
```bash
# 导出Excel
curl -O "http://localhost:8080/api/relics/export"

# 导出PDF
curl -O "http://localhost:8080/api/relics/export/pdf"

# 导出Word
curl -O "http://localhost:8080/api/relics/export/word"
```

#### 方法3：使用Postman
1. 创建GET请求
2. URL：`http://localhost:8080/api/relics/export/pdf`
3. 点击Send
4. 点击Save Response → Save to a file

---

## 性能优化

### 1. 数据量限制
当前实现限制最多导出10000条记录，避免内存溢出。

```java
List<CulturalRelic> relics = culturalRelicMapper.selectPage(0, 10000, relicName, categoryId, status, era);
```

### 2. 分页导出（建议）
对于大数据量，建议实现分页导出：

```java
// 分批查询
int pageSize = 1000;
int pageNum = 0;
while (true) {
    List<CulturalRelic> relics = culturalRelicMapper.selectPage(pageNum * pageSize, pageSize, ...);
    if (relics.isEmpty()) break;
    // 写入文件
    pageNum++;
}
```

### 3. 异步导出（建议）
对于大文件，建议使用异步导出：

```java
@Async
public CompletableFuture<String> exportAsync(...) {
    // 生成文件
    // 保存到临时目录
    // 返回下载链接
}
```

---

## 故障排查

### 问题1：PDF中文乱码
**原因：** 缺少中文字体支持

**解决方案：**
1. 确认已添加font-asian依赖
2. 使用STSong-Light字体
3. 设置UniGB-UCS2-H编码

```java
PdfFont font = PdfFontFactory.createFont("STSong-Light", "UniGB-UCS2-H");
document.setFont(font);
```

### 问题2：Word表格格式错乱
**原因：** 单元格内容过长

**解决方案：**
1. 设置表格宽度为100%
2. 限制单元格内容长度
3. 使用自动换行

### 问题3：导出文件为空
**原因：** 查询条件过滤了所有数据

**解决方案：**
1. 检查查询参数
2. 查看后端日志
3. 验证数据库数据

### 问题4：Maven依赖下载失败
**原因：** 网络问题或仓库配置

**解决方案：**
```bash
# 清理Maven缓存
mvn clean

# 强制更新依赖
mvn clean install -U

# 使用阿里云镜像
# 在pom.xml中添加：
<repositories>
    <repository>
        <id>aliyun</id>
        <url>https://maven.aliyun.com/repository/public</url>
    </repository>
</repositories>
```

---

## 扩展功能建议

### 1. 自定义导出字段
允许用户选择要导出的字段：

```java
public void exportPdf(List<String> fields, ...) {
    // 根据fields动态生成表头和数据
}
```

### 2. 导出模板自定义
支持用户自定义导出模板：

```java
public void exportWithTemplate(String templateId, ...) {
    // 加载模板
    // 填充数据
}
```

### 3. 导出历史记录
记录导出操作，方便追溯：

```sql
CREATE TABLE export_history (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT,
    export_type VARCHAR(20),
    file_name VARCHAR(200),
    record_count INT,
    create_time DATETIME
);
```

### 4. 批量导出
支持导出多个模块的数据：

```java
public void exportAll(HttpServletResponse response) {
    // 导出文物数据
    // 导出借展记录
    // 导出修复记录
    // 打包为ZIP文件
}
```

---

## 总结

### 已实现功能
- ✅ Excel格式导出
- ✅ PDF格式导出（新增）
- ✅ Word格式导出（新增）
- ✅ 中文字体支持
- ✅ 自动文件命名
- ✅ 数据过滤导出

### 技术特点
- 📦 使用成熟的开源库
- 🎨 统一的文档格式
- 🌏 完整的中文支持
- 🚀 简洁的API接口
- 📝 详细的操作日志

### 应用场景
- 📊 数据备份
- 📈 报表生成
- 📋 数据分析
- 📄 文档归档
- 🔍 数据审计

