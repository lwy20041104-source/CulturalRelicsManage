<template>
  <div class="portal-my-loans-page">
    <el-card class="loans-card">
      <template #header>
        <div class="card-header">
          <span class="header-title">
            <el-icon><Box /></el-icon>
            我的借展记录
          </span>
          <el-button @click="goBack">
            <el-icon><ArrowLeft /></el-icon>
            返回
          </el-button>
        </div>
      </template>

      <div class="loans-container">
        <!-- 统计卡片 -->
        <div class="stats-row">
          <div class="stat-card">
            <div class="stat-icon" style="background: linear-gradient(135deg, #409eff 0%, #1890ff 100%)">
              <el-icon><Clock /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.loaning }}</div>
              <div class="stat-label">借展中</div>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: linear-gradient(135deg, #67c23a 0%, #52c41a 100%)">
              <el-icon><Check /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.returned }}</div>
              <div class="stat-label">已归还</div>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f56c6c 0%, #f5222d 100%)">
              <el-icon><Warning /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.overdue }}</div>
              <div class="stat-label">已逾期</div>
            </div>
          </div>
          <div class="stat-card">
            <div class="stat-icon" style="background: linear-gradient(135deg, #e6a23c 0%, #faad14 100%)">
              <el-icon><Document /></el-icon>
            </div>
            <div class="stat-content">
              <div class="stat-value">{{ stats.pending }}</div>
              <div class="stat-label">待审批</div>
            </div>
          </div>
        </div>

        <!-- 筛选栏 -->
        <div class="filter-bar">
          <el-select v-model="query.status" placeholder="按状态筛选" clearable style="width: 160px">
            <el-option label="待审批" value="待审批" />
            <el-option label="借展中" value="借展中" />
            <el-option label="已归还" value="已归还" />
            <el-option label="已驳回" value="已驳回" />
            <el-option label="逾期" value="逾期" />
          </el-select>
          <el-button type="primary" @click="loadData">
            <el-icon><Search /></el-icon>
            搜索
          </el-button>
          <el-button @click="loadData">
            <el-icon><Refresh /></el-icon>
            刷新
          </el-button>
        </div>

        <!-- 借展记录列表 -->
        <div v-loading="loading" class="loans-list">
          <el-empty v-if="!loading && loansList.length === 0" description="暂无借展记录" />
          
          <div v-for="loan in loansList" :key="loan.id" class="loan-item">
            <div class="loan-header">
              <div class="loan-title">
                <el-tag :type="getStatusType(loan.status)" size="large">
                  {{ loan.status }}
                </el-tag>
                <span class="relic-name">{{ loan.relicName }}</span>
              </div>
              <div class="loan-actions">
                <el-button 
                  v-if="loan.status === '借展中' || loan.status === '逾期'" 
                  type="success" 
                  size="small"
                  @click="handleReturn(loan)"
                >
                  <el-icon><Check /></el-icon>
                  主动归还
                </el-button>
              </div>
            </div>

            <div class="loan-body">
              <div class="loan-info-grid">
                <div class="info-item">
                  <span class="info-label">文物编号：</span>
                  <span class="info-value">{{ loan.relicCode }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">借展单位：</span>
                  <span class="info-value">{{ loan.borrowerUnit }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">联系电话：</span>
                  <span class="info-value">{{ loan.borrowerPhone }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">借展用途：</span>
                  <span class="info-value">{{ loan.purpose || '—' }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">借展日期：</span>
                  <span class="info-value">{{ formatDateTime(loan.loanDate) }}</span>
                </div>
                <div class="info-item">
                  <span class="info-label">预计归还：</span>
                  <span class="info-value" :class="{ 'overdue-text': isOverdue(loan) }">
                    {{ formatDateTime(loan.expectedReturnDate) }}
                    <el-tag v-if="isOverdue(loan)" type="danger" size="small" style="margin-left: 8px">
                      已逾期 {{ getOverdueDays(loan) }} 天
                    </el-tag>
                  </span>
                </div>
                <div v-if="loan.actualReturnDate" class="info-item">
                  <span class="info-label">实际归还：</span>
                  <span class="info-value">{{ formatDateTime(loan.actualReturnDate) }}</span>
                </div>
                <div v-if="loan.approverName" class="info-item">
                  <span class="info-label">审批人：</span>
                  <span class="info-value">{{ loan.approverName }}</span>
                </div>
                <div v-if="loan.approveTime" class="info-item">
                  <span class="info-label">审批时间：</span>
                  <span class="info-value">{{ formatDateTime(loan.approveTime) }}</span>
                </div>
                <div v-if="loan.approveRemark" class="info-item full-width">
                  <span class="info-label">审批意见：</span>
                  <span class="info-value">{{ loan.approveRemark }}</span>
                </div>
              </div>
            </div>

            <div class="loan-footer">
              <span class="create-time">申请时间：{{ formatDateTime(loan.createTime) }}</span>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div v-if="total > 0" class="pagination-container">
          <el-pagination
            v-model:current-page="query.pageNum"
            v-model:page-size="query.pageSize"
            :total="total"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="loadData"
            @current-change="loadData"
          />
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Box, 
  ArrowLeft, 
  Clock, 
  Check, 
  Warning, 
  Document, 
  Refresh,
  Search
} from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { getMyLoansPageApi, userReturnLoanApi } from '../api/loans'

const router = useRouter()
const { t } = useI18n()
const loading = ref(false)
const loansList = ref([])
const total = ref(0)

const query = reactive({
  pageNum: 1,
  pageSize: 10,
  status: ''
})

const stats = computed(() => {
  return {
    loaning: loansList.value.filter(l => l.status === '借展中').length,
    returned: loansList.value.filter(l => l.status === '已归还').length,
    overdue: loansList.value.filter(l => l.status === '逾期').length,
    pending: loansList.value.filter(l => l.status === '待审批').length
  }
})

const formatDateTime = (value) => {
  if (!value) return '—'
  return String(value).replace('T', ' ').substring(0, 16)
}

const getStatusType = (status) => {
  const typeMap = {
    '待审批': 'warning',
    '借展中': 'primary',
    '已归还': 'success',
    '已驳回': 'info',
    '逾期': 'danger'
  }
  return typeMap[status] || 'info'
}

const isOverdue = (loan) => {
  if (loan.status !== '借展中' && loan.status !== '逾期') return false
  if (!loan.expectedReturnDate) return false
  return new Date(loan.expectedReturnDate) < new Date()
}

const getOverdueDays = (loan) => {
  if (!loan.expectedReturnDate) return 0
  const expected = new Date(loan.expectedReturnDate)
  const now = new Date()
  const diff = now - expected
  return Math.floor(diff / (1000 * 60 * 60 * 24))
}

const goBack = () => {
  router.push('/portal')
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await getMyLoansPageApi({
      pageNum: query.pageNum,
      pageSize: query.pageSize,
      status: query.status || undefined
    })
    
    if (res.code === 200) {
      loansList.value = res.data.records || []
      total.value = res.data.total || 0
    } else {
      ElMessage.error(res.message || t('common.loadFailed'))
    }
  } catch (e) {
    ElMessage.error(t('common.loadFailed'))
  } finally {
    loading.value = false
  }
}

const handleReturn = async (loan) => {
  try {
    await ElMessageBox.confirm(
      `确认要归还文物"${loan.relicName}"吗？归还后将通知后台管理员进行确认。`,
      '确认归还',
      {
        confirmButtonText: '确认归还',
        cancelButtonText: t('common.cancel'),
        type: 'warning'
      }
    )
    
    loading.value = true
    const res = await userReturnLoanApi(loan.id)
    
    if (Number(res?.code) === 200) {
      ElMessage.success(t('common.returnSuccess'))
      // 刷新失败不应覆盖归还成功提示
      try {
        await loadData()
      } catch (refreshError) {
        ElMessage.warning(t('common.returnSuccessRefreshFailed'))
      }
    } else {
      ElMessage.error(res.message || t('common.returnFailed'))
    }
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(t('common.returnFailed'))
    }
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.portal-my-loans-page {
  min-height: 100vh;
  padding: 40px 20px;
  background: linear-gradient(135deg, rgba(139, 91, 47, 0.05) 0%, rgba(181, 136, 82, 0.08) 100%);
}

.loans-card {
  max-width: 1200px;
  margin: 0 auto;
  border-radius: 14px;
  box-shadow: 0 4px 20px rgba(139, 91, 47, 0.1);
}

.card-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.header-title {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 18px;
  font-weight: 600;
  color: #2f2a24;
}

.loans-container {
  padding: 20px;
}

/* 统计卡片 */
.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 16px;
  margin-bottom: 24px;
}

.stat-card {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 20px;
  background: #fff;
  border-radius: 12px;
  border: 1px solid #eee3d3;
  transition: all 0.3s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.stat-icon {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: #fff;
}

.stat-content {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: 600;
  color: #2f2a24;
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label {
  font-size: 14px;
  color: #9b8d7d;
}

/* 筛选栏 */
.filter-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

/* 借展记录列表 */
.loans-list {
  min-height: 400px;
}

.loan-item {
  background: #fbf6ee;
  border: 1px solid #eee3d3;
  border-radius: 12px;
  margin-bottom: 16px;
  overflow: hidden;
  transition: all 0.3s;
}

.loan-item:hover {
  box-shadow: 0 4px 12px rgba(139, 91, 47, 0.1);
  transform: translateY(-2px);
}

.loan-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  background: #fdfbf7;
  border-bottom: 1px solid #eee3d3;
}

.loan-title {
  display: flex;
  align-items: center;
  gap: 12px;
}

.relic-name {
  font-size: 16px;
  font-weight: 600;
  color: #2f2a24;
}

.loan-body {
  padding: 20px;
}

.loan-info-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
}

.info-item {
  display: flex;
  align-items: flex-start;
}

.info-item.full-width {
  grid-column: 1 / -1;
}

.info-label {
  font-size: 14px;
  color: #9b8d7d;
  min-width: 90px;
  flex-shrink: 0;
}

.info-value {
  font-size: 14px;
  color: #4f4235;
  flex: 1;
}

.overdue-text {
  color: #f56c6c;
  font-weight: 500;
}

.loan-footer {
  padding: 12px 20px;
  background: #fdfbf7;
  border-top: 1px solid #eee3d3;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.create-time {
  font-size: 13px;
  color: #9b8d7d;
}

/* 分页 */
.pagination-container {
  margin-top: 24px;
  display: flex;
  justify-content: center;
}

/* 响应式 */
@media (max-width: 1024px) {
  .stats-row {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .loan-info-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 768px) {
  .stats-row {
    grid-template-columns: 1fr;
  }
  
  .filter-bar {
    flex-direction: column;
  }
  
  .filter-bar .el-select,
  .filter-bar .el-button {
    width: 100%;
  }
}

:deep(.el-button--primary) {
  background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%);
  border: none;
}

:deep(.el-button--primary:hover) {
  background: linear-gradient(135deg, #c69563 0%, #9b6a3a 100%);
}

:deep(.el-button--success) {
  background: linear-gradient(135deg, #67c23a 0%, #52c41a 100%);
  border: none;
}

:deep(.el-button--success:hover) {
  background: linear-gradient(135deg, #78d34a 0%, #63d52b 100%);
}
</style>
