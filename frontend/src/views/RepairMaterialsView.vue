<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input
          v-model="searchForm.materialName"
          :placeholder="$t('repairMaterials.materialName')"
          style="width: 200px"
          clearable
          @clear="loadData"
          @keyup.enter="loadData"
        />
        <el-select
          v-model="searchForm.category"
          :placeholder="$t('repairMaterials.category')"
          clearable
          @clear="loadData"
          style="width: 180px"
        >
          <el-option
            v-for="cat in categories"
            :key="cat"
            :label="cat"
            :value="cat"
          />
        </el-select>
        <el-button type="primary" @click="loadData">
          {{ $t('common.search') }}
        </el-button>
        <el-button @click="resetSearch">
          {{ $t('common.reset') }}
        </el-button>
        <el-button type="success" v-if="canEdit" @click="showCreateDialog">
          {{ $t('repairMaterials.addMaterial') }}
        </el-button>
        <el-button type="warning" @click="showLowStock">
          {{ $t('repairMaterials.lowStock') }}
        </el-button>
      </div>
    </template>

    <el-table :data="materials" border v-loading="loading">
      <el-table-column prop="materialCode" :label="$t('repairMaterials.materialCode')" width="120" />
      <el-table-column prop="materialName" :label="$t('repairMaterials.materialName')" width="150" />
      <el-table-column prop="category" :label="$t('repairMaterials.category')" width="200" />
      <el-table-column :label="$t('repairMaterials.unitPrice')" width="100">
        <template #default="{ row }">
          ¥{{ row.unitPrice ? row.unitPrice.toFixed(2) : '0.00' }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('repairMaterials.stockQuantity')" width="120">
        <template #default="{ row }">
          <el-tag :type="getStockType(row.stockQuantity)">
            {{ row.stockQuantity }} {{ row.unit }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="supplier" :label="$t('repairMaterials.supplier')" width="150" />
      <el-table-column prop="remark" :label="$t('common.remark')" show-overflow-tooltip />
      <el-table-column :label="$t('common.operation')" width="280" fixed="right">
        <template #default="{ row }">
          <el-button link type="primary" @click="showStatistics(row)">
            {{ $t('repairMaterials.statistics') }}
          </el-button>
          <el-button v-if="canEdit" link type="warning" @click="showUpdateStock(row)">
            {{ $t('repairMaterials.updateStock') }}
          </el-button>
          <el-button v-if="canEdit" link type="primary" @click="showEditDialog(row)">
            {{ $t('common.edit') }}
          </el-button>
          <el-button v-if="canEdit" link type="danger" @click="handleDelete(row)">
            {{ $t('common.delete') }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      v-model:current-page="pagination.pageNum"
      v-model:page-size="pagination.pageSize"
      :total="pagination.total"
      :page-sizes="[10, 20, 50, 100]"
      layout="total, sizes, prev, pager, next, jumper"
      @size-change="loadData"
      @current-change="loadData"
      class="pager"
      background
    />
  </el-card>

    <!-- 创建/编辑对话框 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogTitle"
      width="600px"
      class="form-dialog"
    >
      <el-form :model="form" :rules="rules" ref="formRef" label-width="120px" class="dialog-form">
        <el-form-item :label="$t('repairMaterials.materialCode')" prop="materialCode">
          <el-input v-model="form.materialCode" />
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.materialName')" prop="materialName">
          <el-input v-model="form.materialName" />
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.category')" prop="category">
          <el-input v-model="form.category" />
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.unit')" prop="unit">
          <el-input v-model="form.unit" />
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.unitPrice')" prop="unitPrice">
          <el-input-number v-model="form.unitPrice" :min="0" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.stockQuantity')" prop="stockQuantity">
          <el-input-number v-model="form.stockQuantity" :min="0" :precision="2" style="width: 100%" />
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.supplier')">
          <el-input v-model="form.supplier" />
        </el-form-item>
        <el-form-item :label="$t('common.remark')">
          <el-input v-model="form.remark" type="textarea" :rows="3" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="handleSubmit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 更新库存对话框 -->
    <el-dialog
      v-model="stockDialogVisible"
      :title="$t('repairMaterials.updateStock')"
      width="400px"
      class="form-dialog"
    >
      <el-form :model="stockForm" label-width="100px" class="dialog-form">
        <el-form-item :label="$t('repairMaterials.materialName')">
          <span>{{ currentMaterial?.materialName }}</span>
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.currentStock')">
          <span>{{ currentMaterial?.stockQuantity }} {{ currentMaterial?.unit }}</span>
        </el-form-item>
        <el-form-item :label="$t('repairMaterials.changeQuantity')">
          <el-input-number v-model="stockForm.quantity" :precision="2" style="width: 100%" />
          <div class="stock-hint">
            {{ $t('repairMaterials.positiveIncrease') }}
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="stockDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="handleUpdateStock">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 统计对话框 -->
    <el-dialog
      v-model="statsDialogVisible"
      :title="$t('repairMaterials.usageStatistics')"
      width="800px"
    >
      <div v-if="statistics">
        <el-descriptions :column="2" border>
          <el-descriptions-item :label="$t('repairMaterials.materialName')">
            {{ statistics.material?.materialName }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('repairMaterials.materialCode')">
            {{ statistics.material?.materialCode }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('repairMaterials.totalUsage')">
            {{ statistics.totalQuantity }} {{ statistics.material?.unit }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('repairMaterials.totalAmount')">
            ¥{{ statistics.totalAmount?.toFixed(2) }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('repairMaterials.usageCount')">
            {{ statistics.usageCount }} {{ $t('repairMaterials.times') }}
          </el-descriptions-item>
          <el-descriptions-item :label="$t('repairMaterials.currentStock')">
            {{ statistics.material?.stockQuantity }} {{ statistics.material?.unit }}
          </el-descriptions-item>
        </el-descriptions>
      </div>
      <template #footer>
        <el-button @click="statsDialogVisible = false">{{ $t('common.close') }}</el-button>
      </template>
    </el-dialog>

    <!-- 库存不足对话框 -->
    <el-dialog
      v-model="lowStockDialogVisible"
      :title="$t('repairMaterials.lowStockAlert')"
      width="700px"
    >
      <el-table :data="lowStockMaterials" border>
        <el-table-column prop="materialName" :label="$t('repairMaterials.materialName')" />
        <el-table-column prop="materialCode" :label="$t('repairMaterials.materialCode')" />
        <el-table-column :label="$t('repairMaterials.stockQuantity')">
          <template #default="{ row }">
            <el-tag type="danger">
              {{ row.stockQuantity }} {{ row.unit }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="supplier" :label="$t('repairMaterials.supplier')" />
      </el-table>
      <template #footer>
        <el-button @click="lowStockDialogVisible = false">{{ $t('common.close') }}</el-button>
      </template>
    </el-dialog>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import {
  getMaterialList,
  createMaterial,
  updateMaterial,
  deleteMaterial,
  updateStock,
  getCategories,
  getLowStockMaterials,
  getMaterialStatistics
} from '../api/repairMaterial'

const { t } = useI18n()

// 判断当前用户是否可以编辑（仅管理员和保管员）
const canEdit = computed(() => {
  const role = sessionStorage.getItem('role')
  return role === 'ADMIN' || role === 'CURATOR'
})

// 数据
const loading = ref(false)
const materials = ref([])
const categories = ref([])
const pagination = reactive({
  pageNum: 1,
  pageSize: 10,
  total: 0
})

const searchForm = reactive({
  materialName: '',
  category: ''
})

// 对话框
const dialogVisible = ref(false)
const dialogTitle = computed(() => 
  form.id ? t('common.edit') : t('repairMaterials.addMaterial')
)
const formRef = ref(null)
const form = reactive({
  id: null,
  materialCode: '',
  materialName: '',
  category: '',
  unit: '',
  unitPrice: 0,
  stockQuantity: 0,
  supplier: '',
  remark: ''
})

const rules = {
  materialName: [{ required: true, message: t('common.required'), trigger: 'blur' }],
  category: [{ required: true, message: t('common.required'), trigger: 'blur' }],
  unit: [{ required: true, message: t('common.required'), trigger: 'blur' }]
}

// 库存对话框
const stockDialogVisible = ref(false)
const currentMaterial = ref(null)
const stockForm = reactive({
  quantity: 0
})

// 统计对话框
const statsDialogVisible = ref(false)
const statistics = ref(null)

// 库存不足对话框
const lowStockDialogVisible = ref(false)
const lowStockMaterials = ref([])

// 方法
const loadData = async () => {
  loading.value = true
  try {
    const params = {
      pageNum: pagination.pageNum,
      pageSize: pagination.pageSize,
      ...searchForm
    }
    const res = await getMaterialList(params)
    materials.value = res.data.records
    pagination.total = res.data.total
  } catch (error) {
    ElMessage.error(t('common.loadFailed'))
  } finally {
    loading.value = false
  }
}

const loadCategories = async () => {
  try {
    const res = await getCategories()
    categories.value = res.data
  } catch (error) {
    console.error('加载类别失败', error)
  }
}

const resetSearch = () => {
  searchForm.materialName = ''
  searchForm.category = ''
  loadData()
}

const showCreateDialog = () => {
  Object.assign(form, {
    id: null,
    materialCode: '',
    materialName: '',
    category: '',
    unit: '',
    unitPrice: 0,
    stockQuantity: 0,
    supplier: '',
    remark: ''
  })
  dialogVisible.value = true
}

const showEditDialog = (row) => {
  Object.assign(form, { ...row })
  dialogVisible.value = true
}

const handleSubmit = async () => {
  await formRef.value.validate()
  try {
    if (form.id) {
      await updateMaterial(form.id, form)
      ElMessage.success(t('common.updateSuccess'))
    } else {
      await createMaterial(form)
      ElMessage.success(t('common.createSuccess'))
    }
    dialogVisible.value = false
    loadData()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || t('common.operationFailed'))
  }
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      t('common.deleteConfirm'),
      t('common.warning'),
      { type: 'warning' }
    )
    await deleteMaterial(row.id)
    ElMessage.success(t('common.deleteSuccess'))
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(error.response?.data?.message || t('common.deleteFailed'))
    }
  }
}

const showUpdateStock = (row) => {
  currentMaterial.value = row
  stockForm.quantity = 0
  stockDialogVisible.value = true
}

const handleUpdateStock = async () => {
  try {
    await updateStock(currentMaterial.value.id, stockForm.quantity)
    ElMessage.success(t('common.updateSuccess'))
    stockDialogVisible.value = false
    loadData()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || t('common.operationFailed'))
  }
}

const showStatistics = async (row) => {
  try {
    const res = await getMaterialStatistics(row.id)
    statistics.value = res.data
    statsDialogVisible.value = true
  } catch (error) {
    ElMessage.error(t('common.loadFailed'))
  }
}

const showLowStock = async () => {
  try {
    const res = await getLowStockMaterials(10)
    lowStockMaterials.value = res.data
    lowStockDialogVisible.value = true
  } catch (error) {
    ElMessage.error(t('common.loadFailed'))
  }
}

const getStockType = (quantity) => {
  if (quantity <= 5) return 'danger'
  if (quantity <= 10) return 'warning'
  return 'success'
}

onMounted(() => {
  loadData()
  loadCategories()
})
</script>

<style scoped>
.view-card {
  border-radius: 14px;
}

.toolbar {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.pager {
  margin-top: 14px;
  display: flex;
  justify-content: flex-end;
}

.stock-hint {
  font-size: 12px;
  color: #909399;
  margin-top: 5px;
}

:deep(.el-table .cell) {
  color: #4f4235;
}

:deep(.el-table__row:hover > td.el-table__cell) {
  background: #fbf6ee;
}

:deep(.el-dialog) {
  border-radius: 14px;
}

:deep(.el-dialog__header) {
  border-bottom: 1px solid #eee3d3;
  margin-right: 0;
  padding: 16px 20px;
}

:deep(.el-dialog__body) {
  padding: 18px 20px 8px;
}

:deep(.el-dialog__footer) {
  border-top: 1px solid #eee3d3;
  padding: 12px 20px 16px;
}

.dialog-form :deep(.el-form-item__label) {
  color: #5f4f3d;
}

.dialog-form :deep(.el-form-item__content) {
  gap: 8px;
}

:deep(.el-input__wrapper),
:deep(.el-textarea__inner),
:deep(.el-select__wrapper) {
  box-shadow: 0 0 0 1px #e6d8c4 inset;
}

:deep(.el-input__wrapper.is-focus),
:deep(.el-select__wrapper.is-focused),
:deep(.el-textarea__inner:focus) {
  box-shadow: 0 0 0 1px #8a5b2f inset;
}
</style>
