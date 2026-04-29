<template>
  <div class="notifications-page">
    <el-card class="notifications-card">
      <template #header>
        <div class="card-header">
          <div class="header-left">
            <el-button @click="goBack" class="back-button">
              <el-icon><ArrowLeft /></el-icon>
              {{ t('notification.back') }}
            </el-button>
            <span class="header-title">
              <el-icon><Bell /></el-icon>
              {{ t('notification.title') }}
            </span>
          </div>
          <div class="header-right">
            <el-button 
              type="success"
              @click="markAllUnreadAsRead"
            >
              <el-icon><Check /></el-icon>
              {{ t('notification.markAllRead') }}
            </el-button>
            <el-button 
              v-if="selectedIds.length > 0" 
              type="warning"
              @click="batchMarkRead"
            >
              <el-icon><Check /></el-icon>
              {{ t('notification.batchMarkRead') }}
            </el-button>
            <el-button 
              v-if="selectedIds.length > 0" 
              type="danger" 
              @click="batchDelete"
            >
              <el-icon><Delete /></el-icon>
              {{ t('notification.batchDelete') }}
            </el-button>
          </div>
        </div>
      </template>

      <!-- 搜索栏 -->
      <div class="search-bar">
        <el-form :inline="true" :model="queryForm" class="search-form">
          <el-form-item>
            <el-input
              v-model="queryForm.keyword"
              :placeholder="t('notification.searchPlaceholder')"
              clearable
              style="width: 250px"
              @keyup.enter="handleSearch"
            >
              <template #prefix>
                <el-icon><Search /></el-icon>
              </template>
            </el-input>
          </el-form-item>
          
          <el-form-item>
            <el-select
              v-model="queryForm.isRead"
              :placeholder="t('notification.status')"
              clearable
              style="width: 150px"
            >
              <el-option :label="t('notification.statusAll')" :value="null" />
              <el-option :label="t('notification.statusUnread')" :value="false" />
              <el-option :label="t('notification.statusRead')" :value="true" />
            </el-select>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" @click="handleSearch">
              <el-icon><Search /></el-icon>
              {{ t('common.search') }}
            </el-button>
            <el-button @click="handleReset">
              <el-icon><Refresh /></el-icon>
              {{ t('common.reset') }}
            </el-button>
          </el-form-item>
        </el-form>
      </div>

      <!-- 通知列表 -->
      <el-table
        v-loading="loading"
        :data="notificationsList"
        border
        stripe
        @selection-change="handleSelectionChange"
        class="notifications-table"
      >
        <el-table-column type="selection" width="55" align="center" />
        
        <el-table-column :label="t('notification.status')" width="100" align="center">
          <template #default="{ row }">
            <el-tag :type="row.isRead ? 'info' : 'success'" size="small">
              {{ row.isRead ? t('notification.read') : t('notification.unread') }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column :label="t('notification.priority')" width="100" align="center">
          <template #default="{ row }">
            <el-tag 
              v-if="row.priority === 'URGENT'" 
              type="danger" 
              size="small"
              effect="dark"
            >
              {{ t('notification.priorityUrgent') }}
            </el-tag>
            <el-tag 
              v-else-if="row.priority === 'HIGH'" 
              type="warning" 
              size="small"
            >
              {{ t('notification.priorityHigh') }}
            </el-tag>
            <el-tag 
              v-else-if="row.priority === 'LOW'" 
              type="info" 
              size="small"
            >
              {{ t('notification.priorityLow') }}
            </el-tag>
            <el-tag 
              v-else 
              size="small"
            >
              {{ t('notification.priorityNormal') }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column prop="title" :label="t('common.title')" min-width="200" show-overflow-tooltip>
          <template #default="{ row }">
            <span :class="{ 'unread-title': !row.isRead }">{{ row.title }}</span>
          </template>
        </el-table-column>
        
        <el-table-column prop="content" :label="t('notification.content')" min-width="300" show-overflow-tooltip />
        
        <el-table-column prop="senderName" :label="t('notification.sender')" width="120" show-overflow-tooltip />
        
        <el-table-column :label="t('notification.time')" width="180" align="center">
          <template #default="{ row }">
            {{ formatDateTime(row.createTime) }}
          </template>
        </el-table-column>
        
        <el-table-column :label="t('notification.operation')" width="180" align="center" fixed="right">
          <template #default="{ row }">
            <el-button 
              v-if="!row.isRead" 
              type="primary" 
              size="small" 
              link
              @click="markRead(row.id)"
            >
              {{ t('notification.markRead') }}
            </el-button>
            <el-button 
              type="danger" 
              size="small" 
              link
              @click="handleDelete(row.id)"
            >
              {{ t('common.delete') }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <div class="pagination-info">
          {{ t('notification.total') }} {{ total }} {{ t('notification.items') }}
          <span v-if="selectedIds.length > 0" class="selected-info">
            （{{ t('notification.selected') }} {{ selectedIds.length }} {{ t('notification.items') }}）
          </span>
        </div>
        <el-pagination
          v-model:current-page="queryForm.pageNum"
          v-model:page-size="queryForm.pageSize"
          :total="total"
          :page-sizes="[10, 20, 50, 100]"
          background
          layout="sizes, prev, pager, next, jumper"
          @size-change="loadNotifications"
          @current-change="loadNotifications"
        />
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onBeforeUnmount } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  ArrowLeft, 
  Bell, 
  Search, 
  Refresh, 
  Check, 
  Delete 
} from '@element-plus/icons-vue'
import { useI18n } from 'vue-i18n'
import { useRouter } from 'vue-router'
import { 
  getNotificationsApi, 
  markAsReadApi, 
  markAllAsReadApi, 
  deleteNotificationApi 
} from '../api/notifications'

const { t } = useI18n()
const router = useRouter()

const loading = ref(false)
const notificationsList = ref([])
const total = ref(0)
const selectedIds = ref([])

const queryForm = reactive({
  pageNum: 1,
  pageSize: 20,
  keyword: '',
  isRead: null
})

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '—'
  return new Date(dateTime).toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}

// 加载通知列表
const loadNotifications = async () => {
  try {
    loading.value = true
    const params = {
      pageNum: queryForm.pageNum,
      pageSize: queryForm.pageSize
    }
    
    if (queryForm.keyword) {
      params.keyword = queryForm.keyword
    }
    
    if (queryForm.isRead !== null && queryForm.isRead !== undefined) {
      params.isRead = queryForm.isRead
    }
    
    const res = await getNotificationsApi(params)
    notificationsList.value = res.data.records || []
    total.value = res.data.total || 0
  } catch (error) {
    console.error('加载通知列表失败:', error)
    ElMessage.error(t('notification.loadFailed'))
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  queryForm.pageNum = 1
  loadNotifications()
}

// 重置
const handleReset = () => {
  queryForm.keyword = ''
  queryForm.isRead = null
  queryForm.pageNum = 1
  loadNotifications()
}

// 选择变化
const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.id)
}

// 标记单条为已读
const markRead = async (id) => {
  try {
    await markAsReadApi(id)
    ElMessage.success(t('notification.markReadSuccess'))
    loadNotifications()
  } catch (error) {
    ElMessage.error(t('notification.markReadFailed'))
  }
}

// 批量标记已读
const batchMarkRead = async () => {
  if (selectedIds.value.length === 0) {
    ElMessage.warning(t('common.pleaseSelect'))
    return
  }
  
  try {
    await markAllAsReadApi(selectedIds.value)
    ElMessage.success(t('notification.batchMarkReadSuccess'))
    selectedIds.value = []
    loadNotifications()
  } catch (error) {
    ElMessage.error(t('notification.batchMarkReadFailed'))
  }
}

// 全部已读（标记所有未读通知为已读）
const markAllUnreadAsRead = async () => {
  try {
    // 获取所有未读通知的ID
    const unreadNotifications = notificationsList.value.filter(n => !n.isRead)
    
    if (unreadNotifications.length === 0) {
      ElMessage.info(t('notification.noUnreadNotifications'))
      return
    }
    
    await ElMessageBox.confirm(
      t('notification.markAllReadConfirm').replace('{count}', unreadNotifications.length),
      t('common.warning'),
      {
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel'),
        type: 'info'
      }
    )
    
    const unreadIds = unreadNotifications.map(n => n.id)
    await markAllAsReadApi(unreadIds)
    ElMessage.success(t('notification.markAllReadSuccess'))
    loadNotifications()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(t('notification.markAllReadFailed'))
    }
  }
}

// 删除单条
const handleDelete = async (id) => {
  try {
    await ElMessageBox.confirm(
      t('notification.deleteConfirm'),
      t('common.warning'),
      {
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel'),
        type: 'warning'
      }
    )
    
    await deleteNotificationApi(id)
    ElMessage.success(t('notification.deleteSuccess'))
    loadNotifications()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(t('notification.deleteFailed'))
    }
  }
}

// 批量删除
const batchDelete = async () => {
  if (selectedIds.value.length === 0) {
    ElMessage.warning(t('common.pleaseSelect'))
    return
  }
  
  try {
    await ElMessageBox.confirm(
      t('notification.batchDeleteConfirm').replace('{count}', selectedIds.value.length),
      t('common.warning'),
      {
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel'),
        type: 'warning'
      }
    )
    
    // 批量删除
    await Promise.all(selectedIds.value.map(id => deleteNotificationApi(id)))
    ElMessage.success(t('notification.batchDeleteSuccess'))
    selectedIds.value = []
    loadNotifications()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error(t('notification.batchDeleteFailed'))
    }
  }
}

// 返回
const goBack = () => {
  router.back()
}

onMounted(() => {
  loadNotifications()
})

// 组件卸载前清理
onBeforeUnmount(() => {
  selectedIds.value = []
})
</script>

<style scoped>
.notifications-page {
  min-height: 100vh;
  padding: 20px;
  background: linear-gradient(135deg, rgba(139, 91, 47, 0.05) 0%, rgba(181, 136, 82, 0.08) 100%);
}

.notifications-card {
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(139, 91, 47, 0.1);
  border: 1px solid #eadfce;
}

.notifications-card :deep(.el-card__header) {
  background: #fdfbf7;
  border-bottom: 1px solid #eadfce;
  padding: 16px 20px;
}

.notifications-card :deep(.el-card__body) {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 16px;
}

.back-button {
  border: 1px solid #eadfce;
  background: #fff;
  color: #6c5037;
}

.back-button:hover {
  background: #fef5e7;
  border-color: #b58852;
  color: #8a5b2f;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: #3d2f1f;
}

.header-right {
  display: flex;
  gap: 12px;
}

.search-bar {
  margin-bottom: 20px;
  padding: 16px;
  background: #fdfbf7;
  border-radius: 8px;
  border: 1px solid #eee3d3;
}

.search-form {
  margin: 0;
}

.search-form :deep(.el-form-item) {
  margin-bottom: 0;
}

.search-form :deep(.el-input__wrapper) {
  background: #ffffff;
  border-color: #eadfce;
  box-shadow: 0 0 0 1px #eadfce inset;
}

.search-form :deep(.el-input__wrapper:hover) {
  border-color: #b58852;
  box-shadow: 0 0 0 1px #b58852 inset;
}

.search-form :deep(.el-input__wrapper.is-focus) {
  border-color: #b58852;
  box-shadow: 0 0 0 1px #b58852 inset;
}

/* 表格样式 */
.notifications-table {
  border: 1px solid #eadfce;
  border-radius: 8px;
  overflow: hidden;
}

.notifications-table :deep(.el-table__header th) {
  background: #fdfbf7;
  color: #3d2f1f;
  font-weight: 600;
  border-color: #eadfce;
}

.notifications-table :deep(.el-table__body td) {
  border-color: #eadfce;
  color: #5d4a2f;
}

.notifications-table :deep(.el-table--border .el-table__inner-wrapper::after),
.notifications-table :deep(.el-table--border::before),
.notifications-table :deep(.el-table--border::after) {
  background-color: #eadfce;
}

.notifications-table :deep(.el-table__body tr:hover > td) {
  background-color: #fef5e7 !important;
}

.unread-title {
  font-weight: 600;
  color: #3d2f1f;
}

/* 分页 */
.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.pagination-info {
  font-size: 14px;
  color: #6c5037;
}

.selected-info {
  color: #b58852;
  font-weight: 500;
}

:deep(.el-button--primary) {
  background: linear-gradient(135deg, var(--color-primary, #b58852) 0%, var(--color-primary-dark, #8a5b2f) 100%);
  border: none;
  color: #fff;
}

:deep(.el-button--primary:hover) {
  background: linear-gradient(135deg, var(--color-primary-light, #c69563) 0%, var(--color-primary, #b58852) 100%);
}

:deep(.el-button--warning) {
  background: linear-gradient(135deg, #e6a23c 0%, #d48806 100%);
  border: none;
  color: #fff;
}

:deep(.el-button--warning:hover) {
  background: linear-gradient(135deg, #f0b44d 0%, #e59917 100%);
}

:deep(.el-button--danger:not(.is-link)) {
  background: linear-gradient(135deg, #f56c6c 0%, #f5222d 100%);
  border: none;
  color: #fff;
}

:deep(.el-button--danger:not(.is-link):hover) {
  background: linear-gradient(135deg, #f78989 0%, #ff4d4f 100%);
}

:deep(.el-button--danger.is-link) {
  background: transparent;
  border: none;
  color: #f56c6c;
}

:deep(.el-button--danger.is-link:hover) {
  background: transparent;
  color: #f78989;
}

:deep(.el-pagination.is-background .el-pager li:not(.is-disabled).is-active) {
  background-color: var(--color-primary, #b58852);
}

:deep(.el-pagination.is-background .el-pager li:not(.is-disabled):hover) {
  color: var(--color-primary, #b58852);
}
</style>
