# 修复管理界面添加"使用材料"列

## 更新时间
2026-04-27

## 更新内容

### 1. 添加"使用材料"列

在修复管理界面的表格中，在"修复专家"列后面添加了"使用材料"列。

**位置**：修复专家列 → **使用材料列** → 预算费用列

**显示逻辑**：
- ✅ 状态为"修复完成"或"修复中"：显示"查看材料"按钮
- ⏸️ 其他状态：显示"—"（表示暂无）

### 2. 添加材料查看对话框

点击"查看材料"按钮后，弹出对话框显示该修复记录使用的所有材料。

**对话框内容**：
- 材料名称
- 材料编号
- 使用数量（含单位）
- 单价
- 总价
- 备注

**空状态处理**：
- 如果没有使用材料，显示"暂无使用材料"

### 3. 代码变更

#### 前端组件（RepairsView.vue）

**添加表格列**：
```vue
<el-table-column :label="$t('repair.materialsUsed')" width="150">
  <template #default="scope">
    <el-button 
      v-if="scope.row.status === '修复完成' || scope.row.status === '修复中'"
      size="small" 
      type="text" 
      @click="showMaterials(scope.row)"
    >
      {{ $t('repair.viewMaterials') }}
    </el-button>
    <span v-else style="color: #909399;">—</span>
  </template>
</el-table-column>
```

**添加材料对话框**：
```vue
<el-dialog v-model="materialsDialogVisible" :title="$t('repair.materialsUsed')" width="700px">
  <el-table :data="materialsList" border v-loading="materialsLoading">
    <!-- 材料列表 -->
  </el-table>
</el-dialog>
```

**添加导入**：
```javascript
import { getRepairRecordMaterials } from '../api/repairMaterial'
```

**添加变量**：
```javascript
const materialsDialogVisible = ref(false)
const materialsList = ref([])
const materialsLoading = ref(false)
```

**添加方法**：
```javascript
const showMaterials = async (row) => {
  materialsDialogVisible.value = true
  materialsLoading.value = true
  materialsList.value = []
  
  try {
    const res = await getRepairRecordMaterials(row.id)
    materialsList.value = res.data || []
  } catch (error) {
    ElMessage.error(t('repair.loadMaterialsFailed'))
  } finally {
    materialsLoading.value = false
  }
}
```

#### 中文翻译（zh-CN.js）

**repair部分**：
```javascript
repair: {
  // ... 其他翻译
  materialsUsed: '使用材料',
  viewMaterials: '查看材料',
  noMaterials: '暂无使用材料',
  loadMaterialsFailed: '加载材料列表失败',
}
```

**repairMaterials部分**：
```javascript
repairMaterials: {
  // ... 其他翻译
  quantity: '数量',
  totalPrice: '总价',
}
```

#### 英文翻译（en-US.js）

**repair部分**：
```javascript
repair: {
  // ... other translations
  materialsUsed: 'Materials Used',
  viewMaterials: 'View Materials',
  noMaterials: 'No materials used',
  loadMaterialsFailed: 'Failed to load materials',
}
```

**repairMaterials部分**：
```javascript
repairMaterials: {
  // ... other translations
  quantity: 'Quantity',
  totalPrice: 'Total Price',
}
```

### 4. 功能特性

#### 状态判断
- ✅ 只有"修复完成"或"修复中"状态的记录才显示"查看材料"按钮
- ✅ 其他状态（待审批、待修复、已拒绝）显示"—"

#### 数据加载
- ✅ 点击按钮时异步加载材料数据
- ✅ 显示加载状态（loading）
- ✅ 错误处理和提示

#### 界面展示
- ✅ 表格形式展示材料列表
- ✅ 显示数量和单位
- ✅ 显示单价和总价（格式化为货币）
- ✅ 空状态提示

#### 国际化
- ✅ 完整的中英文支持
- ✅ 所有文本都可切换语言

### 5. 界面效果

**表格列**：
```
| 修复专家 | 使用材料      | 预算费用 |
|---------|--------------|---------|
| 张三    | [查看材料]    | ¥500.00 |
| 李四    | —            | ¥300.00 |
```

**材料对话框**：
```
┌─────────────────────────────────────────┐
│ 使用材料                          [×]   │
├─────────────────────────────────────────┤
│ 材料名称 | 材料编号 | 数量 | 单价 | 总价 │
│ 环氧树脂 | MAT001  | 2.5kg| ¥150 | ¥375│
│ 宣纸    | MAT004  | 5张  | ¥50  | ¥250│
├─────────────────────────────────────────┤
│                              [关闭]      │
└─────────────────────────────────────────┘
```

### 6. API调用

使用已有的材料管理API：
```javascript
GET /api/repair-materials/repair-record/{repairRecordId}
```

返回数据格式：
```json
[
  {
    "id": 1,
    "repairRecordId": 1,
    "materialId": 3,
    "materialName": "环氧树脂",
    "materialCode": "MAT001",
    "quantity": 2.5,
    "unit": "kg",
    "unitPrice": 150.00,
    "totalPrice": 375.00,
    "remark": "用于陶瓷粘合"
  }
]
```

### 7. 测试清单

- [ ] 修复管理页面正常加载
- [ ] "使用材料"列显示正确
- [ ] "修复完成"状态显示"查看材料"按钮
- [ ] "修复中"状态显示"查看材料"按钮
- [ ] 其他状态显示"—"
- [ ] 点击"查看材料"按钮打开对话框
- [ ] 材料列表正确显示
- [ ] 数量和单位正确显示
- [ ] 单价和总价格式化正确
- [ ] 空状态提示正确显示
- [ ] 关闭对话框功能正常
- [ ] 中英文切换正常
- [ ] 加载状态显示正常
- [ ] 错误提示正常

### 8. 注意事项

1. **数据依赖**
   - 需要先执行数据库迁移脚本
   - 需要删除repair_record表的materials_used字段
   - 需要创建repair_record_material关联表

2. **状态判断**
   - 状态值需要与后端保持一致
   - 中英文状态值可能不同，需要适配

3. **权限控制**
   - 查看材料不需要特殊权限
   - 所有能查看修复记录的用户都能查看材料

4. **性能考虑**
   - 材料数据按需加载（点击时才加载）
   - 不会影响列表页面的加载速度

### 9. 后续优化建议

1. **材料统计**
   - 在对话框底部显示材料总金额
   - 显示材料使用数量统计

2. **材料管理**
   - 添加"添加材料"按钮（需要权限）
   - 添加"删除材料"功能（需要权限）

3. **导出功能**
   - 支持导出材料使用清单
   - 支持打印材料清单

4. **缓存优化**
   - 缓存已加载的材料数据
   - 避免重复请求

### 10. 相关文档

- [材料管理实现文档](../backend/docs/REPAIR_MATERIAL_IMPLEMENTATION.md)
- [数据库结构变更文档](../backend/docs/REPAIR_MATERIAL_RELATION_DESIGN.md)
- [材料管理API文档](../backend/docs/REPAIR_MATERIAL_IMPLEMENTATION.md#api接口列表)

---

**更新状态**：✅ 完成  
**测试状态**：⏳ 待测试  
**部署状态**：⏳ 待部署
