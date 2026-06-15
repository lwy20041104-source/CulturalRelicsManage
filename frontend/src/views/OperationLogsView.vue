<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="query.operator" :placeholder="$t('operationLog.operator')" clearable style="width: 200px" @keyup.enter="search" />
        <el-select v-model="query.operationType" :placeholder="$t('operationLog.operationType')" clearable style="width: 180px">
          <el-option :label="$t('operationLog.insert')" value="新增" />
          <el-option :label="$t('operationLog.update')" value="修改" />
          <el-option :label="$t('operationLog.delete')" value="删除" />
          <el-option :label="$t('operationLog.search')" value="搜索" />
          <el-option :label="$t('operationLog.login')" value="登录" />
          <el-option :label="$t('operationLog.logout')" value="登出" />
        </el-select>
        <el-input v-model="query.operationModule" :placeholder="$t('operationLog.operationModel')" clearable style="width: 200px" @keyup.enter="search" />
        <el-button type="primary" @click="search">{{ $t('common.search') }}</el-button>
        <el-button @click="resetSearch">{{ $t('common.reset') }}</el-button>

      </div>
    </template>

    <el-table :data="tableData" border v-loading="loading">
      <el-table-column prop="operator" :label="$t('operationLog.operatorName')" width="150" />
      <el-table-column prop="operationType" :label="$t('operationLog.operationType')" width="150" />
      <el-table-column prop="operationModule" :label="$t('operationLog.operationModel')" width="150" />
      <el-table-column prop="operationContent" :label="$t('operationLog.operationContent')" min-width="200" show-overflow-tooltip />
      <el-table-column prop="operationResult" :label="$t('operationLog.operationResult')" width="150">
        <template #default="scope">
          <el-tag :type="scope.row.operationResult === '成功' ? 'success' : 'danger'">
            {{ scope.row.operationResult === '成功' ? $t('common.success') : $t('common.failed') }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="operationTime" :label="$t('operationLog.operationTime')" width="180">
        <template #default="scope">
          {{ formatDateTime(scope.row.operationTime) }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('operationLog.operation')" width="100">
        <template #default="scope">
          <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
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

    <!-- 详情对话框 -->
    <el-dialog v-model="detailDialogVisible" :title="$t('operationLog.logDetail')" width="900px">
      <el-descriptions v-if="currentDetail" :column="2" border>
        <el-descriptions-item :label="$t('operationLog.operatorName')" :span="2">{{ currentDetail.operator }}</el-descriptions-item>
        <el-descriptions-item :label="$t('operationLog.operationType')">{{ currentDetail.operationType }}</el-descriptions-item>
        <el-descriptions-item :label="$t('operationLog.operationModel')">{{ currentDetail.operationModule }}</el-descriptions-item>
        <el-descriptions-item :label="$t('operationLog.operationContent')" :span="2">{{ currentDetail.operationContent }}</el-descriptions-item>
        <el-descriptions-item :label="$t('operationLog.operationResult')">
          <el-tag :type="currentDetail.operationResult === '成功' || currentDetail.operationResult === 'SUCCESS' ? 'success' : 'danger'">
            {{ currentDetail.operationResult === '成功' || currentDetail.operationResult === 'SUCCESS' ? $t('common.success') : $t('common.failed')}}
          </el-tag>
        </el-descriptions-item>
        <el-descriptions-item :label="$t('operationLog.IPAdress')">{{ currentDetail.ipAddress || '—' }}</el-descriptions-item>
        <el-descriptions-item :label="$t('operationLog.operationTime')" :span="2">{{ formatDateTime(currentDetail.operationTime) }}</el-descriptions-item>
        
        <!-- 新增：请求信息 -->
        <el-descriptions-item v-if="currentDetail.requestMethod" :label="$t('operationLog.requestMethod')">
          <el-tag size="small">{{ currentDetail.requestMethod }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.requestUrl" :label="$t('operationLog.requestUrl')">
          {{ currentDetail.requestUrl }}
        </el-descriptions-item>
        
        <!-- 新增：执行时长 -->
        <el-descriptions-item v-if="currentDetail.executionTime" :label="$t('operationLog.executionTime')">
          {{ currentDetail.executionTime }} ms
        </el-descriptions-item>
        
        <!-- 新增：客户端信息 -->
        <el-descriptions-item v-if="currentDetail.browser" :label="$t('operationLog.browser')">
          {{ currentDetail.browser }}
        </el-descriptions-item>
        <el-descriptions-item v-if="currentDetail.os" :label="$t('operationLog.os')" :span="2">
          {{ currentDetail.os }}
        </el-descriptions-item>
        
        <!-- 新增：错误信息 -->
        <el-descriptions-item v-if="currentDetail.errorMessage" :label="$t('operationLog.errorMessage')" :span="2">
          <el-text type="danger">{{ currentDetail.errorMessage }}</el-text>
        </el-descriptions-item>
      </el-descriptions>
      
      <!-- 新增：数据对比区域 -->
      <div v-if="hasDataChanges" style="margin-top: 20px;">
        <el-divider content-position="left">{{ $t('operationLog.dataComparison') }}</el-divider>
        
        <!-- 变更字段列表 -->
        <div v-if="changedFields && changedFields.length > 0" style="margin-bottom: 20px;">
          <el-table :data="changedFields" border size="small">
            <el-table-column prop="label" :label="$t('operationLog.fieldName')" width="150" />
            <el-table-column :label="$t('operationLog.oldValue')" min-width="200">
              <template #default="{ row }">
                <el-text :type="row.changed ? 'danger' : ''">{{ formatValue(row.oldValue) }}</el-text>
              </template>
            </el-table-column>
            <el-table-column :label="$t('operationLog.newValue')" min-width="200">
              <template #default="{ row }">
                <el-text :type="row.changed ? 'success' : ''">{{ formatValue(row.newValue) }}</el-text>
              </template>
            </el-table-column>
            <el-table-column :label="$t('operationLog.changeStatus')" width="100" align="center">
              <template #default="{ row }">
                <el-tag v-if="row.changed" type="warning" size="small">{{ $t('operationLog.changed') }}</el-tag>
                <el-tag v-else type="info" size="small">{{ $t('operationLog.unchanged') }}</el-tag>
              </template>
            </el-table-column>
          </el-table>
        </div>
        
        <!-- 完整数据对比（可折叠） -->
        <el-collapse v-if="currentDetail.beforeData || currentDetail.afterData">
          <el-collapse-item :title="$t('operationLog.fullDataComparison')" name="1">
            <el-row :gutter="20">
              <el-col :span="12" v-if="currentDetail.beforeData">
                <div class="data-panel">
                  <div class="panel-title">{{ $t('operationLog.beforeData') }}</div>
                  <pre class="json-content">{{ formatJson(currentDetail.beforeData) }}</pre>
                </div>
              </el-col>
              <el-col :span="12" v-if="currentDetail.afterData">
                <div class="data-panel">
                  <div class="panel-title">{{ $t('operationLog.afterData') }}</div>
                  <pre class="json-content">{{ formatJson(currentDetail.afterData) }}</pre>
                </div>
              </el-col>
            </el-row>
          </el-collapse-item>
        </el-collapse>
      </div>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, onUnmounted, reactive, ref, computed } from 'vue'
import { useI18n } from 'vue-i18n'

import { getOperationLogsPageApi, getOperationLogByIdApi } from '../api/operationLogs'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const loading = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const query = reactive({ pageNum: 1, pageSize: 10, operator: '', operationType: '', operationModule: '' })

// 计算是否有数据变更
const hasDataChanges = computed(() => {
  return currentDetail.value && (
    currentDetail.value.beforeData || 
    currentDetail.value.afterData || 
    currentDetail.value.changedFields
  )
})

// 解析变更字段
const changedFields = computed(() => {
  if (!currentDetail.value || !currentDetail.value.changedFields) {
    return []
  }
  
  try {
    const fields = JSON.parse(currentDetail.value.changedFields)
    return Array.isArray(fields) ? fields : []
  } catch (e) {
    console.error('解析变更字段失败:', e)
    return []
  }
})

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ')
}

const formatValue = (value) => {
  if (value === null || value === undefined) return '—'
  if (typeof value === 'object') return JSON.stringify(value)
  return String(value)
}

const formatJson = (jsonStr) => {
  if (!jsonStr) return ''
  try {
    const obj = typeof jsonStr === 'string' ? JSON.parse(jsonStr) : jsonStr
    return JSON.stringify(obj, null, 2)
  } catch (e) {
    return jsonStr
  }
}

const loadData = async (silent = false) => {
  try {
    if (!silent) {
      loading.value = true
    }
    const res = await getOperationLogsPageApi(query)
    tableData.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载操作日志失败:', error)
  } finally {
    if (!silent) {
      loading.value = false
    }
  }
}

const search = () => {
  query.pageNum = 1
  loadData()
}

const resetSearch = () => {
  Object.assign(query, { pageNum: 1, pageSize: 10, operator: '', operationType: '', operationModule: '' })
  loadData()
}

const viewDetail = async (row) => {
  const res = await getOperationLogByIdApi(row.id)
  currentDetail.value = res.data
  detailDialogVisible.value = true
}

const handleOperationDone = () => {
  loadData(true)
}

onMounted(() => {
  loadData()
  window.addEventListener('operation-done', handleOperationDone)
})

onUnmounted(() => {
  window.removeEventListener('operation-done', handleOperationDone)
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

/* 数据对比面板样式 */
.data-panel {
  border: 1px solid #eee3d3;
  border-radius: 8px;
  overflow: hidden;
}

.panel-title {
  background: #fbf6ee;
  padding: 10px 15px;
  font-weight: 600;
  color: #4f4235;
  border-bottom: 1px solid #eee3d3;
}

.json-content {
  padding: 15px;
  margin: 0;
  background: #fff;
  color: #4f4235;
  font-size: 13px;
  line-height: 1.6;
  max-height: 400px;
  overflow-y: auto;
  font-family: 'Courier New', Courier, monospace;
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

:deep(.el-collapse) {
  border: 1px solid #eee3d3;
  border-radius: 8px;
}

:deep(.el-collapse-item__header) {
  background: #fbf6ee;
  padding: 0 15px;
  color: #4f4235;
  font-weight: 500;
}

:deep(.el-collapse-item__content) {
  padding: 15px;
}
</style>
