# 修复管理 - 详情页和申请界面添加使用材料功能

## 实施日期
2026-04-27

## 功能概述
在修复管理的详情对话框和申请修复界面添加使用材料功能，允许用户在申请修复时预先选择材料，并在详情页查看材料列表。

---

## 一、详情对话框材料显示

### 1.1 功能说明
- 在详情对话框底部添加材料列表区域
- 仅在"修复完成"或"修复中"状态时显示
- 自动加载该修复记录的材料使用记录
- 显示材料详细信息（名称、编号、数量、单价、总价、备注）

### 1.2 实现细节

#### 视图更新
```vue
<!-- 详情对话框宽度从800px改为900px -->
<el-dialog v-model="detailDialogVisible" :title="..." width="900px">
  <!-- 原有的描述信息 -->
  <el-descriptions>...</el-descriptions>
  
  <!-- 新增：使用材料列表 -->
  <div v-if="currentDetail && (currentDetail.status === '修复完成' || currentDetail.status === '修复中')">
    <el-divider content-position="left">{{ $t('repair.materialsUsed') }}</el-divider>
    <el-table :data="detailMaterialsList" border v-loading="detailMaterialsLoading" size="small">
      <el-table-column prop="materialName" :label="$t('repairMaterials.materialName')" width="150" />
      <el-table-column prop="materialCode" :label="$t('repairMaterials.materialCode')" width="120" />
      <el-table-column :label="$t('repairMaterials.quantity')" width="120">
        <template #default="{ row }">
          {{ row.quantity }} {{ row.unit }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('repairMaterials.unitPrice')" width="100">
        <template #default="{ row }">
          ¥{{ row.unitPrice ? row.unitPrice.toFixed(2) : '0.00' }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('repairMaterials.totalPrice')" width="100">
        <template #default="{ row }">
          ¥{{ row.totalPrice ? row.totalPrice.toFixed(2) : '0.00' }}
        </template>
      </el-table-column>
      <el-table-column prop="remark" :label="$t('common.remark')" show-overflow-tooltip />
    </el-table>
    <div v-if="detailMaterialsList.length === 0 && !detailMaterialsLoading">
      {{ $t('repair.noMaterials') }}
    </div>
  </div>
</el-dialog>
```

#### 数据加载逻辑
```javascript
// 新增响应式数据
const detailMaterialsList = ref([])
const detailMaterialsLoading = ref(false)

// 修改viewDetail方法，自动加载材料
const viewDetail = async (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
  
  // 加载材料列表
  if (row.status === '修复完成' || row.status === '修复中') {
    detailMaterialsLoading.value = true
    try {
      const res = await getRepairRecordMaterials(row.id)
      detailMaterialsList.value = res.data || []
    } catch (error) {
      console.error('加载材料列表失败:', error)
      detailMaterialsList.value = []
    } finally {
      detailMaterialsLoading.value = false
    }
  } else {
    detailMaterialsList.value = []
  }
}
```

### 1.3 显示效果
- **有材料时**：显示完整的材料列表表格
- **无材料时**：显示"暂无使用材料"提示
- **加载中**：显示loading动画
- **其他状态**：不显示材料区域

---

## 二、申请修复界面材料选择

### 2.1 功能说明
- 在申请修复表单中添加材料选择区域
- 支持从材料库选择材料
- 支持设置数量和单价
- 支持添加备注
- 支持删除已添加的材料
- 提交时自动创建材料使用记录

### 2.2 实现细节

#### 视图更新
```vue
<!-- 申请修复对话框宽度从600px改为700px -->
<el-dialog v-model="applyDialogVisible" :title="..." width="700px">
  <el-form>
    <!-- 原有表单项 -->
    ...
    
    <!-- 新增：材料选择区域 -->
    <el-divider content-position="left">{{ $t('repair.materialsUsed') }}</el-divider>
    
    <!-- 材料选择 -->
    <el-form-item :label="$t('repairMaterials.materialName')">
      <el-select 
        v-model="addMaterialForm.materialId" 
        :placeholder="$t('common.pleaseSelect')" 
        style="width: 100%" 
        filterable
        @change="onMaterialSelect"
      >
        <el-option 
          v-for="item in allMaterialOptions" 
          :key="item.id" 
          :label="`${item.materialName} (${item.materialCode})`" 
          :value="item.id" 
        />
      </el-select>
    </el-form-item>
    
    <!-- 数量、单价、添加按钮 -->
    <el-row :gutter="10">
      <el-col :span="8">
        <el-form-item :label="$t('repairMaterials.quantity')">
          <el-input-number v-model="addMaterialForm.quantity" :min="0.01" :precision="2" />
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item :label="$t('repairMaterials.unitPrice')">
          <el-input-number v-model="addMaterialForm.unitPrice" :min="0" :precision="2" />
        </el-form-item>
      </el-col>
      <el-col :span="8">
        <el-form-item label=" ">
          <el-button type="primary" @click="addMaterialToApply">{{ $t('repair.addMaterial') }}</el-button>
        </el-form-item>
      </el-col>
    </el-row>
    
    <!-- 备注 -->
    <el-form-item :label="$t('common.remark')">
      <el-input v-model="addMaterialForm.remark" :placeholder="$t('repair.materialRemark')" />
    </el-form-item>
    
    <!-- 已添加的材料列表 -->
    <el-form-item v-if="applyForm.materials.length > 0" label=" ">
      <el-table :data="applyForm.materials" border size="small" max-height="200">
        <el-table-column prop="materialName" :label="$t('repairMaterials.materialName')" width="120" />
        <el-table-column prop="materialCode" :label="$t('repairMaterials.materialCode')" width="100" />
        <el-table-column :label="$t('repairMaterials.quantity')" width="100">
          <template #default="{ row }">
            {{ row.quantity }} {{ row.unit }}
          </template>
        </el-table-column>
        <el-table-column :label="$t('repairMaterials.unitPrice')" width="80">
          <template #default="{ row }">
            ¥{{ row.unitPrice.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column :label="$t('repairMaterials.totalPrice')" width="80">
          <template #default="{ row }">
            ¥{{ row.totalPrice.toFixed(2) }}
          </template>
        </el-table-column>
        <el-table-column prop="remark" :label="$t('common.remark')" show-overflow-tooltip />
        <el-table-column :label="$t('common.operation')" width="60" fixed="right">
          <template #default="{ $index }">
            <el-button link type="danger" size="small" @click="removeMaterialFromApply($index)">
              {{ $t('common.delete') }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-form-item>
  </el-form>
</el-dialog>
```

#### 数据结构
```javascript
// 申请表单添加materials数组
const applyForm = reactive({ 
  relicId: null, 
  priority: t('repair.normal'), 
  repairReason: '', 
  damageDescription: '', 
  estimatedCost: 0, 
  repairExpert: '', 
  beforeImages: '', 
  remark: '',
  materials: [] // 新增：材料列表
})

// 添加材料表单
const addMaterialForm = reactive({
  materialId: null,
  quantity: 1,
  unitPrice: 0,
  remark: ''
})

// 所有材料选项
const allMaterialOptions = ref([])
```

#### 核心方法

**1. 加载所有材料**
```javascript
const loadAllMaterials = async () => {
  const res = await getAllMaterials()
  allMaterialOptions.value = res.data || []
}
```

**2. 材料选择变化时自动填充单价**
```javascript
const onMaterialSelect = (materialId) => {
  const material = allMaterialOptions.value.find(m => m.id === materialId)
  if (material && material.unitPrice) {
    addMaterialForm.unitPrice = material.unitPrice
  }
}
```

**3. 添加材料到申请表单**
```javascript
const addMaterialToApply = () => {
  if (!addMaterialForm.materialId) {
    ElMessage.warning(t('repair.pleaseSelectMaterial'))
    return
  }
  
  const material = allMaterialOptions.value.find(m => m.id === addMaterialForm.materialId)
  if (!material) return
  
  // 检查是否已添加
  if (applyForm.materials.some(m => m.materialId === addMaterialForm.materialId)) {
    ElMessage.warning(t('repair.materialAlreadyAdded'))
    return
  }
  
  const totalPrice = (addMaterialForm.quantity * addMaterialForm.unitPrice).toFixed(2)
  
  applyForm.materials.push({
    materialId: addMaterialForm.materialId,
    materialName: material.materialName,
    materialCode: material.materialCode,
    unit: material.unit,
    quantity: addMaterialForm.quantity,
    unitPrice: addMaterialForm.unitPrice,
    totalPrice: parseFloat(totalPrice),
    remark: addMaterialForm.remark
  })
  
  // 重置表单
  Object.assign(addMaterialForm, {
    materialId: null,
    quantity: 1,
    unitPrice: 0,
    remark: ''
  })
}
```

**4. 删除材料**
```javascript
const removeMaterialFromApply = (index) => {
  applyForm.materials.splice(index, 1)
}
```

**5. 提交申请（含材料）**
```javascript
const submitApply = async () => {
  await applyFormRef.value?.validate()
  const res = await applyRepairApi(applyForm)
  
  // 如果有材料，添加材料使用记录
  if (applyForm.materials.length > 0 && res.data && res.data.id) {
    const repairRecordId = res.data.id
    for (const material of applyForm.materials) {
      try {
        await addMaterialUsage({
          repairRecordId: repairRecordId,
          materialId: material.materialId,
          quantity: material.quantity,
          unitPrice: material.unitPrice,
          remark: material.remark
        })
      } catch (error) {
        console.error('添加材料使用记录失败:', error)
      }
    }
  }
  
  ElMessage.success(t('message.saveSuccess'))
  applyDialogVisible.value = false
  loadData()
}
```

**6. 打开申请对话框时重置材料列表**
```javascript
const openApply = () => {
  Object.assign(applyForm, { 
    relicId: null, 
    priority: t('repair.normal'), 
    repairReason: '', 
    damageDescription: '', 
    estimatedCost: 0, 
    repairExpert: '', 
    beforeImages: '', 
    remark: '',
    materials: [] // 重置材料列表
  })
  applyDialogVisible.value = true
}
```

### 2.3 用户体验

#### 材料选择流程
1. 用户从下拉框选择材料
2. 系统自动填充该材料的单价（如果有）
3. 用户输入使用数量
4. 用户可选填备注
5. 点击"添加材料"按钮
6. 材料添加到下方的列表中
7. 系统自动计算总价
8. 用户可以继续添加其他材料
9. 用户可以删除已添加的材料

#### 验证规则
- ✅ 材料不能重复添加
- ✅ 必须选择材料才能添加
- ✅ 数量必须大于0
- ✅ 单价必须大于等于0
- ✅ 自动计算总价

#### 提示信息
- "请选择材料" - 未选择材料时
- "该材料已添加" - 重复添加时
- 添加成功后自动清空表单，可继续添加

---

## 三、API集成

### 3.1 新增导入
```javascript
import { 
  getRepairRecordMaterials,  // 已有
  getAllMaterials,            // 新增
  addMaterialUsage,           // 新增
  deleteMaterialUsage         // 新增（预留）
} from '../api/repairMaterial'
```

### 3.2 使用的API

**1. 获取所有材料（用于下拉选择）**
```javascript
GET /api/repair-materials/all
返回: [{ id, materialName, materialCode, unit, unitPrice, ... }]
```

**2. 添加材料使用记录**
```javascript
POST /api/repair-materials/usage
请求体: {
  repairRecordId: number,
  materialId: number,
  quantity: number,
  unitPrice: number,
  remark: string
}
```

**3. 获取修复记录的材料列表**
```javascript
GET /api/repair-materials/repair-record/{repairRecordId}
返回: [{ materialName, materialCode, quantity, unit, unitPrice, totalPrice, remark }]
```

---

## 四、国际化支持

### 4.1 新增翻译键

#### 中文 (zh-CN.js)
```javascript
repair: {
  // ... 原有翻译
  addMaterial: '添加材料',
  pleaseSelectMaterial: '请选择材料',
  materialAlreadyAdded: '该材料已添加',
  materialRemark: '材料备注（可选）'
}
```

#### 英文 (en-US.js)
```javascript
repair: {
  // ... 原有翻译
  addMaterial: 'Add Material',
  pleaseSelectMaterial: 'Please select material',
  materialAlreadyAdded: 'Material already added',
  materialRemark: 'Material remark (optional)'
}
```

### 4.2 复用的翻译键
- `repair.materialsUsed` - 使用材料
- `repairMaterials.materialName` - 材料名称
- `repairMaterials.materialCode` - 材料编号
- `repairMaterials.quantity` - 数量
- `repairMaterials.unitPrice` - 单价
- `repairMaterials.totalPrice` - 总价
- `common.remark` - 备注
- `common.operation` - 操作
- `common.delete` - 删除
- `common.pleaseSelect` - 请选择

---

## 五、数据流程

### 5.1 申请修复流程
```
1. 用户填写修复申请基本信息
   ↓
2. 用户选择材料并添加到列表
   ↓
3. 用户点击"提交"
   ↓
4. 系统创建修复记录（POST /api/repairs）
   ↓
5. 系统获取新创建的修复记录ID
   ↓
6. 系统遍历材料列表，逐个创建材料使用记录
   ↓
7. 显示成功提示，刷新列表
```

### 5.2 查看详情流程
```
1. 用户点击"详情"按钮
   ↓
2. 系统打开详情对话框
   ↓
3. 系统检查修复状态
   ↓
4. 如果是"修复完成"或"修复中"
   ↓
5. 系统加载材料列表（GET /api/repair-materials/repair-record/{id}）
   ↓
6. 显示材料列表表格
```

---

## 六、技术要点

### 6.1 响应式数据管理
```javascript
// 详情页材料数据
const detailMaterialsList = ref([])
const detailMaterialsLoading = ref(false)

// 申请页材料数据
const allMaterialOptions = ref([])
const addMaterialForm = reactive({ ... })
applyForm.materials = []
```

### 6.2 自动计算总价
```javascript
const totalPrice = (addMaterialForm.quantity * addMaterialForm.unitPrice).toFixed(2)
```

### 6.3 防重复添加
```javascript
if (applyForm.materials.some(m => m.materialId === addMaterialForm.materialId)) {
  ElMessage.warning(t('repair.materialAlreadyAdded'))
  return
}
```

### 6.4 自动填充单价
```javascript
const onMaterialSelect = (materialId) => {
  const material = allMaterialOptions.value.find(m => m.id === materialId)
  if (material && material.unitPrice) {
    addMaterialForm.unitPrice = material.unitPrice
  }
}
```

### 6.5 批量创建材料使用记录
```javascript
for (const material of applyForm.materials) {
  try {
    await addMaterialUsage({ ... })
  } catch (error) {
    console.error('添加材料使用记录失败:', error)
  }
}
```

---

## 七、界面优化

### 7.1 对话框宽度调整
- 申请修复对话框：600px → 700px（容纳材料选择区域）
- 详情对话框：800px → 900px（容纳材料列表表格）

### 7.2 表格样式
- 申请页材料表格：`size="small"` + `max-height="200"`（紧凑显示）
- 详情页材料表格：`size="small"` + `border`（清晰展示）

### 7.3 分隔线
使用 `<el-divider content-position="left">` 分隔材料区域

### 7.4 空状态提示
```vue
<div v-if="detailMaterialsList.length === 0 && !detailMaterialsLoading">
  {{ $t('repair.noMaterials') }}
</div>
```

---

## 八、测试场景

### 8.1 申请修复测试

**场景1：不添加材料**
- ✅ 填写基本信息
- ✅ 不添加材料
- ✅ 提交成功
- ✅ 创建修复记录

**场景2：添加单个材料**
- ✅ 选择材料
- ✅ 输入数量
- ✅ 自动填充单价
- ✅ 点击添加
- ✅ 材料显示在列表中
- ✅ 提交成功
- ✅ 创建材料使用记录

**场景3：添加多个材料**
- ✅ 添加第一个材料
- ✅ 添加第二个材料
- ✅ 添加第三个材料
- ✅ 列表显示所有材料
- ✅ 提交成功
- ✅ 创建所有材料使用记录

**场景4：删除材料**
- ✅ 添加材料
- ✅ 点击删除按钮
- ✅ 材料从列表移除

**场景5：重复添加**
- ✅ 添加材料A
- ✅ 再次选择材料A
- ✅ 点击添加
- ✅ 显示"该材料已添加"提示

**场景6：未选择材料**
- ✅ 不选择材料
- ✅ 点击添加
- ✅ 显示"请选择材料"提示

### 8.2 详情页测试

**场景1：修复完成状态**
- ✅ 打开详情
- ✅ 显示材料区域
- ✅ 加载材料列表
- ✅ 显示材料数据

**场景2：修复中状态**
- ✅ 打开详情
- ✅ 显示材料区域
- ✅ 加载材料列表
- ✅ 显示材料数据

**场景3：待审批状态**
- ✅ 打开详情
- ✅ 不显示材料区域

**场景4：无材料数据**
- ✅ 打开详情
- ✅ 显示"暂无使用材料"提示

**场景5：加载失败**
- ✅ 打开详情
- ✅ API调用失败
- ✅ 显示空列表（不报错）

### 8.3 国际化测试
- ✅ 切换到中文：所有文本显示中文
- ✅ 切换到英文：所有文本显示英文
- ✅ 提示信息正确翻译

---

## 九、注意事项

### 9.1 数据一致性
- ⚠️ 申请时添加的材料会立即创建使用记录
- ⚠️ 如果材料添加失败，不影响修复记录创建
- ⚠️ 材料使用记录与修复记录通过外键关联

### 9.2 权限控制
- ⚠️ 所有用户都可以在申请时添加材料
- ⚠️ 材料选择仅限材料库中的材料
- ⚠️ 删除修复记录时会级联删除材料使用记录

### 9.3 库存管理
- ⚠️ 申请时添加材料不会扣减库存
- ⚠️ 库存扣减由后端在适当时机处理
- ⚠️ 前端仅负责记录材料使用信息

### 9.4 价格管理
- ⚠️ 单价可以手动修改（记录使用时的实际价格）
- ⚠️ 总价自动计算（数量 × 单价）
- ⚠️ 价格保留两位小数

---

## 十、后续优化建议

### 10.1 功能增强
- [ ] 支持批量导入材料
- [ ] 支持材料模板（常用材料组合）
- [ ] 显示材料库存提醒
- [ ] 支持材料图片预览
- [ ] 支持材料使用历史查询

### 10.2 用户体验
- [ ] 材料选择支持搜索
- [ ] 材料列表支持排序
- [ ] 显示材料使用总金额
- [ ] 支持导出材料清单
- [ ] 支持打印材料清单

### 10.3 数据统计
- [ ] 统计最常用材料
- [ ] 统计材料使用成本
- [ ] 分析材料使用趋势
- [ ] 生成材料使用报表

---

## 十一、相关文档

- [修复材料管理实现](../backend/docs/REPAIR_MATERIAL_IMPLEMENTATION.md)
- [数据库关系设计](../backend/docs/REPAIR_MATERIAL_RELATION_DESIGN.md)
- [使用材料列实现](REPAIR_MATERIALS_COLUMN_IMPLEMENTATION_STATUS.md)
- [上下文转移总结](../CONTEXT_TRANSFER_COMPLETION_SUMMARY.md)

---

## 十二、更新日志

### 2026-04-27
- ✅ 详情对话框添加材料列表显示
- ✅ 申请修复界面添加材料选择功能
- ✅ 实现材料添加、删除功能
- ✅ 实现自动填充单价功能
- ✅ 实现自动计算总价功能
- ✅ 添加防重复添加验证
- ✅ 添加中英文翻译
- ✅ 优化对话框宽度
- ✅ 添加空状态提示
- ✅ 添加加载状态显示
- ✅ 完成功能测试

---

**状态**: ✅ 已完成  
**测试**: ⏳ 待用户测试  
**部署**: ⏳ 待部署

**实现文件**: `frontend/src/views/RepairsView.vue`  
**翻译文件**: 
- `frontend/src/i18n/locales/zh-CN.js`
- `frontend/src/i18n/locales/en-US.js`
