# 图片上传文物选择器修复

## 🐛 问题描述

上传图片时选择文物下拉框中显示 `undefined`，无法正确显示文物信息。

## 🔍 问题原因

使用了错误的字段名来显示文物信息：
- **错误字段**：`relic.name` 和 `relic.inventoryNumber`
- **正确字段**：`relic.relicName` 和 `relic.relicCode`

根据后端实体类 `CulturalRelic.java` 的定义：
```java
public class CulturalRelic {
    private Long id;
    private String relicCode;      // 文物编号
    private String relicName;      // 文物名称
    // ... 其他字段
}
```

## ✅ 修复方案

### 修改文件
`frontend/src/views/ImageLibraryView.vue`

### 修改内容

#### 1. 单个上传对话框
```vue
<!-- 修复前 -->
<el-option
  v-for="relic in relicsList"
  :key="relic.id"
  :label="`${relic.name} (${relic.inventoryNumber})`"
  :value="relic.id"
/>

<!-- 修复后 -->
<el-option
  v-for="relic in relicsList"
  :key="relic.id"
  :label="`${relic.relicName} (${relic.relicCode})`"
  :value="relic.id"
/>
```

#### 2. 批量上传对话框
```vue
<!-- 修复前 -->
<el-option
  v-for="relic in relicsList"
  :key="relic.id"
  :label="`${relic.name} (${relic.inventoryNumber})`"
  :value="relic.id"
/>

<!-- 修复后 -->
<el-option
  v-for="relic in relicsList"
  :key="relic.id"
  :label="`${relic.relicName} (${relic.relicCode})`"
  :value="relic.id"
/>
```

## 📊 修复效果

### 修复前
```
下拉框显示：
- undefined (undefined)
- undefined (undefined)
- undefined (undefined)
```

### 修复后
```
下拉框显示：
- 青铜鼎 (WW001)
- 玉璧 (WW002)
- 陶罐 (WW003)
```

## 🧪 测试验证

- [x] 打开上传图片对话框
- [x] 点击"关联文物"下拉框
- [x] 验证文物列表正确显示文物名称和编号
- [x] 验证搜索功能正常工作
- [x] 验证选择文物后可以正常上传

## 📝 注意事项

在处理文物数据时，请使用正确的字段名：
- ✅ `relicName` - 文物名称
- ✅ `relicCode` - 文物编号
- ❌ `name` - 不存在
- ❌ `inventoryNumber` - 不存在

## 📅 修复信息

**修复日期：** 2026年4月27日  
**修复人员：** Kiro AI  
**问题级别：** 高（影响核心功能）  
**修复状态：** ✅ 已完成
