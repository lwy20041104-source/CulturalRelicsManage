<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="query.relicName" :placeholder="$t('repair.relicName')" style="width: 200px" @keyup.enter="loadData" />
        <el-select v-model="query.status" :placeholder="$t('repair.status')" clearable style="width: 140px">
          <el-option :label="$t('repair.pending')" value="待审批" />
          <el-option :label="$t('repair.awaitingRepair')" value="待修复" />
          <el-option :label="$t('repair.repairing')" value="修复中" />
          <el-option :label="$t('repair.completed')" value="修复完成" />
          <el-option :label="$t('repair.rejected')" value="已拒绝" />
        </el-select>
        <el-button type="primary" @click="loadData">{{ $t('common.search') }}</el-button>
        <el-button type="success" @click="openApply">{{ $t('repair.addRepair') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border>
      <el-table-column prop="relicName" :label="$t('repair.relicName')" min-width="150" />
      <el-table-column prop="status" :label="$t('repair.status')" width="100">
        <template #default="scope">
          <el-tag :type="getStatusType(scope.row.status)">{{ scope.row.status }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="repairReason" :label="$t('repair.repairReason')" min-width="180" show-overflow-tooltip />
      <el-table-column prop="priority" :label="$t('repair.priority')" width="90">
        <template #default="scope">
          <el-tag :type="getPriorityType(scope.row.priority)" size="small">{{ scope.row.priority }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="applyDate" :label="$t('repair.applyDate')" width="160">
        <template #default="scope">
          {{ formatDateTime(scope.row.applyDate) }}
        </template>
      </el-table-column>
      <el-table-column prop="approver" :label="$t('repair.approver')" width="100" />
      <el-table-column prop="repairExpert" :label="$t('repair.repairExpert')" width="110" />
      <el-table-column prop="estimatedCost" :label="$t('repair.estimatedCost')" width="110">
        <template #default="scope">
          {{ formatCost(scope.row.estimatedCost) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('common.operation')" width="200" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
          <el-button v-if="scope.row.status === '待审批'" link type="warning" @click="withdraw(scope.row.id)">{{ $t('repair.withdraw') }}</el-button>
          <el-button v-if="scope.row.status === '已拒绝'" link type="danger" @click="remove(scope.row.id)">{{ $t('common.delete') }}</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      class="pager"
      background
      layout="total, prev, pager, next"
      :total="total"
      :page-size="query.pageSize"
      :current-page="query.pageNum"
      @current-change="(p) => { query.pageNum = p; loadData(); }"
    />

    <!-- 申请修复对话框 -->
    <el-dialog v-model="applyDialogVisible" :title="$t('repair.addRepair')" width="700px">
      <el-form ref="applyFormRef" :model="applyForm" :rules="applyRules" label-width="110px">
        <el-form-item :label="$t('repair.relicName')" prop="relicId">
          <el-select v-model="applyForm.relicId" :placeholder="$t('common.pleaseSelect')" style="width: 100%" filterable>
            <el-option v-for="item in relicOptions" :key="item.id" :label="`${item.relicName} (${item.relicCode})`" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('repair.priority')" prop="priority">
          <el-select v-model="applyForm.priority" style="width: 100%">
            <el-option :label="$t('repair.urgent')" value="紧急" />
            <el-option :label="$t('repair.high')" value="高" />
            <el-option :label="$t('repair.normal')" value="普通" />
            <el-option :label="$t('repair.low')" value="低" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('repair.repairReason')" prop="repairReason">
          <el-input v-model="applyForm.repairReason" maxlength="255" show-word-limit />
        </el-form-item>
        <el-form-item :label="$t('repair.damageDescription')" prop="damageDescription">
          <el-input v-model="applyForm.damageDescription" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item :label="$t('repair.repairExpert')">
          <el-select v-model="applyForm.repairExpert" :placeholder="$t('common.pleaseSelect')" clearable style="width: 100%">
            <el-option v-for="item in expertOptions" :key="item.expertName" :label="`${item.expertName} (${item.specialty})`" :value="item.expertName" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('repair.beforeImages')">
          <el-input v-model="applyForm.beforeImages" :placeholder="$t('common.pleaseInput')" />
        </el-form-item>
        
        <!-- 材料选择区域 -->
        <el-divider content-position="left">{{ $t('repair.materialsUsed') }}</el-divider>
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
        <el-row :gutter="10">
          <el-col :span="8">
            <el-form-item :label="$t('repairMaterials.quantity')">
              <el-input-number v-model="addMaterialForm.quantity" :min="0.01" :precision="2" :controls="false" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item :label="$t('repairMaterials.unitPrice')">
              <el-input-number v-model="addMaterialForm.unitPrice" :min="0" :precision="2" :controls="false" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label=" ">
              <el-button type="primary" @click="addMaterialToApply" style="width: 100%">{{ $t('repair.addMaterial') }}</el-button>
            </el-form-item>
          </el-col>
        </el-row>
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
                <el-button link type="danger" size="small" @click="removeMaterialFromApply($index)">{{ $t('common.delete') }}</el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <!-- 显示预估费用总计 -->
          <div style="margin-top: 10px; text-align: right; font-size: 14px;">
            <span style="color: #606266; margin-right: 10px;">{{ $t('repair.estimatedCost') }}:</span>
            <span style="color: #E6A23C; font-weight: bold; font-size: 16px;">¥{{ calculateTotalCost().toFixed(2) }}</span>
          </div>
        </el-form-item>
        
        <el-form-item :label="$t('common.remark')">
          <el-input v-model="applyForm.remark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="applyDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitApply">{{ $t('common.submit') }}</el-button>
      </template>
    </el-dialog>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('repair.title') + $t('common.detail')" width="900px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('repair.relicName')">{{ currentDetail.relicName }} ({{ currentDetail.relicCode }})</el-descriptions-item>
        <el-descriptions-item :label="$t('repair.status')">
          <el-tag :type="getStatusType(currentDetail.status)">{{ currentDetail.status }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('repair.priority')">
          <el-tag :type="getPriorityType(currentDetail.priority)">{{ currentDetail.priority }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('repair.applicant')">{{ currentDetail.applicantName }}</el-descriptions-item>
        <el-descriptions-item :label="$t('repair.applyDate')">{{ formatDateTime(currentDetail.applyDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('repair.repairReason')" :span="2">{{ currentDetail.repairReason }}</el-descriptions-item>
        <el-descriptions-item :label="$t('repair.damageDescription')" :span="2">{{ currentDetail.damageDescription || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('repair.estimatedCost')">{{ formatCost(currentDetail.estimatedCost) }}</el-descriptions-item>
        <el-descriptions-item :label="$t('repair.actualCost')">{{ formatCost(currentDetail.actualCost) }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approver" :label="$t('repair.approver')">{{ currentDetail.approver }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approveDate" :label="$t('repair.approveDate')">{{ formatDateTime(currentDetail.approveDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.approveRemark" :label="$t('repair.approveRemark')" :span="2">{{ currentDetail.approveRemark }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.repairExpert" :label="$t('repair.repairExpert')">{{ currentDetail.repairExpert }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.startDate" :label="$t('repair.startDate')">{{ formatDateTime(currentDetail.startDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.completeDate" :label="$t('repair.completeDate')">{{ formatDateTime(currentDetail.completeDate) || '—' }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.qualityScore" :label="$t('repair.qualityScore')">{{ currentDetail.qualityScore }} {{ $t('repair.scoreUnit') }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.repairProcess" :label="$t('repair.repairProcess')" :span="2">{{ currentDetail.repairProcess }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.repairMethod" :label="$t('repair.repairMethod')" :span="2">{{ currentDetail.repairMethod }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.materialsUsed" :label="$t('repair.materialsUsed')" :span="2">{{ currentDetail.materialsUsed }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.qualityRemark" :label="$t('repair.qualityRemark')" :span="2">{{ currentDetail.qualityRemark }}</el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.remark" :label="$t('common.remark')" :span="2">{{ currentDetail.remark }}</el-descriptions-item>
      </el-descriptions>
      
      <!-- 使用材料列表 -->
      <div v-if="currentDetail && (currentDetail.status === '修复完成' || currentDetail.status === '修复中')" style="margin-top: 20px;">
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
        <div v-if="detailMaterialsList.length === 0 && !detailMaterialsLoading" style="text-align: center; padding: 20px; color: #909399;">
          {{ $t('repair.noMaterials') }}
        </div>
      </div>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getRepairsPageApi, applyRepairApi, deleteRepairApi, getEnabledExpertsApi } from '../api/repairs'
import { getAvailableForRepairApi } from '../api/relics'
import { getRepairRecordMaterials, getAllMaterials, addMaterialUsage } from '../api/repairMaterial'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const allMaterialOptions = ref([])
const relicOptions = ref([])
const expertOptions = ref([])
const applyDialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const detailMaterialsList = ref([])
const detailMaterialsLoading = ref(false)
const applyFormRef = ref()

const query = reactive({ pageNum: 1, pageSize: 10, status: '', relicName: '' })
const applyForm = reactive({ 
  relicId: null, 
  priority: t('repair.normal'), 
  repairReason: '', 
  damageDescription: '', 
  estimatedCost: 0, 
  repairExpert: '', 
  beforeImages: '', 
  remark: '',
  materials: []
})

const addMaterialForm = reactive({
  materialId: null,
  quantity: 1,
  unitPrice: 0,
  remark: ''
})

const applyRules = {
  relicId: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  priority: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  repairReason: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  damageDescription: [{ required: true, message: t('validation.required'), trigger: 'blur' }]
}

const getStatusType = (status) => {
  const map = { '待审批': 'info', '待修复': 'warning', '修复中': 'primary', '修复完成': 'success', '已拒绝': 'danger' }
  return map[status] || ''
}

const getPriorityType = (priority) => {
  const map = { '紧急': 'danger', '高': 'warning', '普通': '', '低': 'info' }
  return map[priority] || ''
}

const formatCost = (cost) => {
  if (cost === null || cost === undefined || cost === 0) return '—'
  return `¥${Number(cost).toFixed(2)}`
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const loadData = async () => {
  const res = await getRepairsPageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

const loadRelics = async () => {
  const res = await getAvailableForRepairApi()
  relicOptions.value = res.data || []
}

const loadExperts = async () => {
  const res = await getEnabledExpertsApi()
  expertOptions.value = res.data || []
}

const loadAllMaterials = async () => {
  const res = await getAllMaterials()
  allMaterialOptions.value = res.data || []
}

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
    materials: []
  })
  applyDialogVisible.value = true
}

const addMaterialToApply = () => {
  if (!addMaterialForm.materialId) {
    ElMessage.warning(t('repair.pleaseSelectMaterial'))
    return
  }
  
  const material = allMaterialOptions.value.find(m => m.id === addMaterialForm.materialId)
  if (!material) return
  
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
  
  Object.assign(addMaterialForm, {
    materialId: null,
    quantity: 1,
    unitPrice: 0,
    remark: ''
  })
}

const removeMaterialFromApply = (index) => {
  applyForm.materials.splice(index, 1)
}

const onMaterialSelect = (materialId) => {
  const material = allMaterialOptions.value.find(m => m.id === materialId)
  if (material && material.unitPrice) {
    addMaterialForm.unitPrice = material.unitPrice
  }
}

const calculateTotalCost = () => {
  return applyForm.materials.reduce((total, material) => {
    return total + (material.totalPrice || 0)
  }, 0)
}

const submitApply = async () => {
  await applyFormRef.value?.validate()
  
  applyForm.estimatedCost = calculateTotalCost()
  
  const res = await applyRepairApi(applyForm)
  
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

const viewDetail = async (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
  
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

const remove = async (id) => {
  await ElMessageBox.confirm(t('repair.deleteRejectedConfirm'), t('message.tip'), { type: 'warning' })
  await deleteRepairApi(id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}

const withdraw = async (id) => {
  await ElMessageBox.confirm(t('repair.withdrawConfirm'), t('message.tip'), { type: 'warning' })
  await deleteRepairApi(id)
  ElMessage.success(t('repair.withdrawSuccess'))
  loadData()
}

onMounted(async () => {
  await Promise.all([loadData(), loadRelics(), loadExperts(), loadAllMaterials()])
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

.unit-text {
  color: #7a6c5b;
  white-space: nowrap;
  margin-left: 8px;
}
</style>
