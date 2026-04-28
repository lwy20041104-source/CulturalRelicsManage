<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="queryName" :placeholder="$t('category.categoryName')" style="width: 220px" />
        <el-button type="primary" @click="loadData">{{ $t('common.search') }}</el-button>
        <el-button type="success" @click="openAdd">{{ $t('category.addCategory') }}</el-button>
      </div>
    </template>

    <el-table
      :data="treeData"
      border
      row-key="id"
      :tree-props="{ children: 'children' }"
      :default-expand-all="false"
    >
      <el-table-column prop="categoryName" :label="$t('category.categoryName')" min-width="220" />
      <el-table-column prop="description" :label="$t('category.description')" min-width="220" show-overflow-tooltip />
      <el-table-column :label="$t('category.parentCategory')" width="160">
        <template #default="scope">
          {{ getParentName(scope.row.parentId) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="230">
        <template #default="scope">
          <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
          <el-button link type="primary" @click="openEdit(scope.row)">{{ $t('common.edit') }}</el-button>
          <el-button link type="danger" @click="remove(scope.row.id)">{{ $t('common.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogVisible" :title="form.id ? $t('category.editCategory') : $t('category.addCategory')" width="520px" class="form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px" class="dialog-form">
        <el-form-item :label="$t('category.categoryName')" prop="categoryName"><el-input v-model="form.categoryName" /></el-form-item>
        <el-form-item :label="$t('category.parentCategory')">
          <el-select v-model="form.parentId" style="width: 100%">
            <el-option :label="$t('category.topLevel')" :value="0" />
            <el-option
              v-for="item in parentOptions"
              :key="item.id"
              :label="item.categoryName"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('category.description')"><el-input v-model="form.description" type="textarea" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('category.categoryDetail')" width="700px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('category.categoryName')" :span="2">{{ currentDetail.categoryName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('category.parentCategory')" :span="2">{{ getParentName(currentDetail.parentId) }}</el-descriptions-item>
        <el-descriptions-item :label="$t('category.sortOrder')" :span="2">{{ currentDetail.sortOrder || 0 }}</el-descriptions-item>
        <el-descriptions-item :label="$t('category.description')" :span="2">{{ currentDetail.description || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentDetail.createTime) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('common.updateTime')">{{ formatDateTime(currentDetail.updateTime) || '—' }}</el-descriptions-item>
      </el-descriptions>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { computed, onMounted, reactive, ref } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { useI18n } from 'vue-i18n'
import { getCategoriesApi, addCategoryApi, updateCategoryApi, deleteCategoryApi } from '../api/categories'

const { t } = useI18n()
const tableData = ref([])
const queryName = ref('')
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const form = reactive({ id: null, categoryName: '', parentId: 0, sortOrder: 0, description: '' })
const rules = {
  categoryName: [{ required: true, message: t('category.inputCategoryName'), trigger: 'blur' }]
}

const normalizedQueryName = computed(() => queryName.value.trim())

const filteredData = computed(() => {
  if (!normalizedQueryName.value) return tableData.value
  return tableData.value.filter(i => (i.categoryName || '').includes(normalizedQueryName.value))
})

const categoryMap = computed(() => {
  return filteredData.value.reduce((map, item) => {
    map[item.id] = item
    return map
  }, {})
})

const parentOptions = computed(() => {
  return tableData.value.filter(item => item.id !== form.id && (item.parentId || 0) === 0)
})

const treeData = computed(() => {
  const sortList = (list) => [...list].sort((a, b) => {
    const sortDiff = (a.sortOrder || 0) - (b.sortOrder || 0)
    if (sortDiff !== 0) return sortDiff
    return (a.id || 0) - (b.id || 0)
  })

  const roots = []
  const childrenMap = {}

  filteredData.value.forEach(item => {
    const current = { ...item }
    const parentId = current.parentId || 0
    if (parentId === 0 || !categoryMap.value[parentId]) {
      roots.push(current)
      return
    }
    if (!childrenMap[parentId]) {
      childrenMap[parentId] = []
    }
    childrenMap[parentId].push(current)
  })

  return sortList(roots).map(parent => ({
    ...parent,
    children: sortList(childrenMap[parent.id] || [])
  }))
})

const getParentName = (parentId) => {
  if (!parentId) return t('category.topLevel')
  return categoryMap.value[parentId]?.categoryName || `ID: ${parentId}`
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const loadData = async () => {
  const res = await getCategoriesApi()
  tableData.value = res.data || []
}

const openAdd = () => {
  Object.assign(form, { id: null, categoryName: '', parentId: 0, sortOrder: 0, description: '' })
  dialogVisible.value = true
}

const openEdit = (row) => {
  Object.assign(form, row)
  dialogVisible.value = true
}

const viewDetail = (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
}

const submit = async () => {
  await formRef.value?.validate()
  if (form.id) {
    await updateCategoryApi(form)
    ElMessage.success(t('message.updateSuccess'))
  } else {
    await addCategoryApi(form)
    ElMessage.success(t('message.saveSuccess'))
  }
  dialogVisible.value = false
  loadData()
}

const remove = async (id) => {
  await ElMessageBox.confirm(t('category.deleteConfirm'), t('message.warning'), { type: 'warning' })
  await deleteCategoryApi(id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}

onMounted(loadData)
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
