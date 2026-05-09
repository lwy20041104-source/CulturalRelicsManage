<template>
  <div class="ai-chat-history-container">
    <el-card>
      

      <!-- 搜索栏 -->
      <el-form :inline="true" :model="queryForm" class="search-form">
        <el-form-item >
          <el-input v-model="queryForm.userName" :placeholder="$t('aiChatHistory.putUserName')" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item >
          <el-input v-model="queryForm.sessionTitle" :placeholder="$t('aiChatHistory.putChatTitle')" clearable style="width: 200px" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            {{ $t('common.search') }}
          </el-button>
          <el-button @click="handleReset">
            <el-icon><Refresh /></el-icon>
            {{ $t('common.reset') }}
          </el-button>
        </el-form-item>
      </el-form>

      <!-- 表格 -->
      <el-table :data="sessionList" border stripe v-loading="loading">
        <el-table-column prop="userName" :label="$t('aiChatHistory.userName')" width="120" />
        <el-table-column prop="sessionTitle" :label="$t('aiChatHistory.chatTitle')" min-width="200" show-overflow-tooltip />
        <el-table-column :label="$t('aiChatHistory.messageNumber')" width="150">
          <template #default="{ row }">
            <el-tag>{{ row.messageCount || 0 }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" :label="$t('common.createTime')" width="180">
          <template #default="{ row }">
            {{ formatDateTime(row.createTime) }}
          </template>
        </el-table-column>
        <el-table-column prop="updateTime" :label="$t('common.updateTime')" width="180">
          <template #default="{ row }">
            {{ formatDateTime(row.updateTime) }}
          </template>
        </el-table-column>
        <el-table-column :label="$t('common.operation')" width="180" fixed="right">
          <template #default="{ row }">
            <el-button type="primary" size=" large" link @click="handleViewDetail(row)">
              {{ $t('common.detail') }}
            </el-button>
            <el-button type="danger" size=" large" link @click="handleDelete(row)">
              {{ $t('common.delete') }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination-container">
        <el-pagination
          v-model:current-page="queryForm.pageNum"
          v-model:page-size="queryForm.pageSize"
          :page-sizes="[10, 20, 50, 100]"
          :total="total"
          background
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="handlePageChange"
          @current-change="handlePageChange"
        />
      </div>
    </el-card>

    <!-- 详情对话框 -->
    <el-dialog v-model="detailVisible" :title="$t('aiChatHistory.chatDetail')" width="900px" :close-on-click-modal="false">
      <div class="dialog-content">
        <!-- 会话信息 -->
        <el-descriptions :column="2" border class="session-info">
          <el-descriptions-item :label="$t('aiChatHistory.userName')" :span="2">{{ currentSession?.userName || '-' }}</el-descriptions-item>
          <el-descriptions-item :label="$t('aiChatHistory.chatTitle')" :span="2">{{ currentSession?.sessionTitle }}</el-descriptions-item>
          <el-descriptions-item :label="$t('common.createTime')">{{ formatDateTime(currentSession?.createTime) }}</el-descriptions-item>
          <el-descriptions-item :label="$t('common.updateTime')">{{ formatDateTime(currentSession?.updateTime) }}</el-descriptions-item>
        </el-descriptions>

        <!-- 对话消息 -->
        <div class="messages-container" v-loading="messagesLoading">
          <h3>{{$t('aiChatHistory.chatRecord')}}</h3>
          <div class="messages-list">
            <div v-if="messageList.length === 0" class="empty-messages">
              <el-empty :description="$t('aiChatHistory.noChatRecord')" />
            </div>
            <div v-for="(msg, index) in messageList" :key="msg.id" class="message-item">
              <div v-if="msg.messageType === 'user'" class="user-message">
                <div class="message-header">
                  <el-icon><User /></el-icon>
                  <span class="message-label">{{$t('aiChatHistory.userAsk')}}</span>
                  <span class="message-time">{{ formatDateTime(msg.createTime) }}</span>
                </div>
                <div class="message-content">{{ msg.content }}</div>
                <div v-if="msg.queryKeyword" class="message-meta">
                  <el-tag size="small">{{$t('aiChatHistory.userAsk')}}: {{ msg.queryKeyword }}</el-tag>
                </div>
              </div>
              <div v-else class="ai-message">
                <div class="message-header">
                  <el-icon><ChatDotRound /></el-icon>
                  <span class="message-label">{{$t('aiChatHistory.aiResponse')}}</span>
                  <span class="message-time">{{ formatDateTime(msg.createTime) }}</span>
                </div>
                <div class="message-content">{{ msg.content }}</div>
                <div class="message-meta">
                  <el-tag size="small" type="success">{{$t('aiChatHistory.resultNumber')}}: {{ msg.resultCount || 0 }}</el-tag>
                  <el-tag v-if="msg.hasExternalResult" size="small" type="warning">{{$t('aiChatHistory.includeExternalResults')}}</el-tag>
                  <el-tag v-if="msg.relicIds" size="small" type="info">{{$t('aiChatHistory.relicID')}}: {{ msg.relicIds }}</el-tag>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <template #footer>
        <el-button @click="detailVisible = false">{{ $t('common.close') }}</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Refresh, View, Delete, User, ChatDotRound } from '@element-plus/icons-vue'
import { useI18n } from 'vue-i18n'
import { 
  getAllSessionsApi,
  getSessionMessagesApi, 
  deleteSessionApi 
} from '../api/aiChat'

const { t } = useI18n()

const loading = ref(false)
const messagesLoading = ref(false)
const detailVisible = ref(false)
const sessionList = ref([])
const messageList = ref([])
const currentSession = ref(null)
const total = ref(0)

const queryForm = reactive({
  userName: '',
  sessionTitle: '',
  pageNum: 1,
  pageSize: 10
})

// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

// 加载会话列表
const loadSessions = async () => {
  try {
    loading.value = true
    const res = await getAllSessionsApi()
    let sessions = res.data || []
    
    // 前端过滤（因为后端API可能不支持分页和搜索）
    if (queryForm.userName) {
      sessions = sessions.filter(s => s.userName && s.userName.includes(queryForm.userName))
    }
    if (queryForm.sessionTitle) {
      sessions = sessions.filter(s => s.sessionTitle.includes(queryForm.sessionTitle))
    }
    
    // 计算总数
    total.value = sessions.length
    
    // 前端分页
    const start = (queryForm.pageNum - 1) * queryForm.pageSize
    const end = start + queryForm.pageSize
    sessionList.value = sessions.slice(start, end)
    
    // 为每个会话加载消息数量
    for (const session of sessionList.value) {
      try {
        const msgRes = await getSessionMessagesApi(session.id)
        session.messageCount = msgRes.data?.length || 0
      } catch (error) {
        session.messageCount = 0
      }
    }
  } catch (error) {
    console.error('加载会话列表失败:', error)
    ElMessage.error(t('common.loadFailed'))
  } finally {
    loading.value = false
  }
}

// 搜索
const handleSearch = () => {
  queryForm.pageNum = 1
  loadSessions()
}

// 分页改变
const handlePageChange = () => {
  loadSessions()
}

// 重置
const handleReset = () => {
  queryForm.userName = ''
  queryForm.sessionTitle = ''
  queryForm.pageNum = 1
  queryForm.pageSize = 10
  loadSessions()
}

// 查看详情
const handleViewDetail = async (row) => {
  currentSession.value = row
  detailVisible.value = true
  
  try {
    messagesLoading.value = true
    const res = await getSessionMessagesApi(row.id)
    messageList.value = res.data || []
  } catch (error) {
    console.error('加载消息失败:', error)
    ElMessage.error(t('common.loadFailed'))
  } finally {
    messagesLoading.value = false
  }
}

// 删除
const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除会话"${row.sessionTitle}"吗？删除后将无法恢复！`,
      t('common.warning'),
      {
        confirmButtonText: t('common.confirm'),
        cancelButtonText: t('common.cancel'),
        type: 'warning'
      }
    )
    
    await deleteSessionApi(row.id)
    ElMessage.success(t('common.deleteSuccess'))
    loadSessions()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除失败:', error)
      ElMessage.error(t('common.deleteFailed'))
    }
  }
}

onMounted(() => {
  loadSessions()
})
</script>

<style scoped>
.ai-chat-history-container {
  padding: 0;
}

.ai-chat-history-container :deep(.el-card) {
  border: 1px solid #eadfce;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(166, 124, 82, 0.08);
}

.ai-chat-history-container :deep(.el-card__header) {
  background: #fdfbf7;
  border-bottom: 1px solid #eadfce;
  padding: 16px 20px;
}

.ai-chat-history-container :deep(.el-card__body) {
  padding: 20px;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  font-size: 16px;
  color: #3d2f1f;
}

.search-form {
  margin-bottom: 20px;
}

.search-form :deep(.el-form-item__label) {
  color: #6c5037;
}

.search-form :deep(.el-input__wrapper) {
  background: #ffffff;
  border-color: #eadfce;
  box-shadow: 0 0 0 1px #eadfce inset;
}

.search-form :deep(.el-input__wrapper:hover) {
  border-color: #a67c52;
  box-shadow: 0 0 0 1px #a67c52 inset;
}

.search-form :deep(.el-input__wrapper.is-focus) {
  border-color: #a67c52;
  box-shadow: 0 0 0 1px #a67c52 inset;
}

/* 表格样式 */
:deep(.el-table) {
  border: 1px solid #eadfce;
  border-radius: 4px;
}

:deep(.el-table th.el-table__cell) {
  background: #fdfbf7;
  color: #3d2f1f;
  font-weight: 600;
  border-color: #eadfce;
}

:deep(.el-table td.el-table__cell) {
  border-color: #eadfce;
  color: #5d4a2f;
}

:deep(.el-table--border .el-table__inner-wrapper::after),
:deep(.el-table--border::before),
:deep(.el-table--border::after) {
  background-color: #eadfce;
}

:deep(.el-table__body tr:hover > td) {
  background-color: #fef5e7 !important;
}

.dialog-content {
  max-height: 70vh;
  overflow-y: auto;
}

.session-info {
  margin-bottom: 20px;
}

.messages-container h3 {
  margin: 20px 0 10px 0;
  font-size: 16px;
  font-weight: 600;
  color: #333;
}

.messages-list {
  max-height: 400px;
  overflow-y: auto;
  padding: 10px;
  background: #f5f7fa;
  border-radius: 8px;
}

.empty-messages {
  padding: 40px 0;
}

.message-item {
  margin-bottom: 16px;
}

.user-message,
.ai-message {
  padding: 12px;
  border-radius: 8px;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.user-message {
  border-left: 3px solid #409eff;
}

.ai-message {
  border-left: 3px solid #67c23a;
}

.message-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  color: #666;
  font-size: 14px;
}

.message-label {
  font-weight: 600;
  color: #333;
}

.message-time {
  margin-left: auto;
  font-size: 12px;
  color: #999;
}

.message-content {
  padding: 8px 0;
  line-height: 1.6;
  color: #333;
  white-space: pre-wrap;
  word-break: break-word;
}

.message-meta {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-top: 8px;
}

.pagination-container {
  margin-top: 20px;
  display: flex;
  justify-content: flex-end;
}

/* 对话框样式 */
:deep(.el-dialog) {
  border: 1px solid #eadfce;
  border-radius: 8px;
}

:deep(.el-dialog__header) {
  background: #fdfbf7;
  border-bottom: 1px solid #eadfce;
  padding: 16px 20px;
  border-radius: 8px 8px 0 0;
}

:deep(.el-dialog__title) {
  color: #3d2f1f;
  font-weight: 600;
}

:deep(.el-dialog__body) {
  padding: 20px;
  color: #5d4a2f;
}

:deep(.el-dialog__footer) {
  border-top: 1px solid #eadfce;
  padding: 16px 20px;
}

:deep(.el-descriptions__label) {
  background: #fdfbf7;
  color: #6c5037;
  font-weight: 500;
}

:deep(.el-descriptions__content) {
  color: #5d4a2f;
}

:deep(.el-descriptions--border .el-descriptions__cell) {
  border-color: #eadfce;
}

:deep(.el-tag) {
  border-color: transparent;
}
</style>
