<template>
  <el-card class="view-card">
    <template #header>
      <div class="toolbar">
        <el-input v-model="query.relicName" :placeholder="$t('relic.relicName')" style="width: 200px" @keyup.enter="loadData" />
        <el-select v-model="query.era" :placeholder="$t('relic.era')" clearable style="width: 160px">
          <el-option label="新石器时代" value="新石器时代" />
          <el-option label="夏朝" value="夏朝" />
          <el-option label="商朝" value="商朝" />
          <el-option label="东周" value="东周" />
          <el-option label="西周" value="西周" />
          <el-option label="春秋" value="春秋" />
          <el-option label="战国" value="战国" />
          <el-option label="秦朝" value="秦朝" />
          <el-option label="汉朝" value="汉朝" />
          <el-option label="三国" value="三国" />
          <el-option label="晋朝" value="晋朝" />
          <el-option label="南北朝" value="南北朝" />
          <el-option label="隋朝" value="隋朝" />
          <el-option label="唐朝" value="唐朝" />
          <el-option label="五代十国" value="五代十国" />
          <el-option label="宋朝" value="宋朝" />
          <el-option label="辽朝" value="辽朝" />
          <el-option label="西夏" value="西夏" />
          <el-option label="金朝" value="金朝" />
          <el-option label="元朝" value="元朝" />
          <el-option label="明朝" value="明朝" />
          <el-option label="清朝" value="清朝" />
          <el-option label="民国" value="民国" />
        </el-select>
        <el-select v-model="query.categoryId" :placeholder="$t('relic.category')" clearable style="width: 160px">
          <el-option v-for="item in categoryOptions" :key="item.id" :label="item.categoryName" :value="item.id" />
        </el-select>
        <el-select v-model="query.status" :placeholder="$t('relic.status')" clearable style="width: 140px">
          <el-option :label="$t('relic.inStock')" value="在库" />
          <el-option :label="$t('relic.onLoan')" value="借展中" />
          <el-option :label="$t('relic.repairing')" value="修复中" />
          <el-option :label="$t('relic.sealed')" value="封存" />
        </el-select>
        <el-button type="primary" @click="loadData">{{ $t('common.search') }}</el-button>
        <el-button type="success" @click="openAdd">{{ $t('relic.addRelic') }}</el-button>
        <el-button type="warning" @click="handleBatchStatus" :disabled="!selectedIds.length">{{ $t('relic.batchUpdateStatus') }}</el-button>
        <el-button type="danger" @click="handleBatchDelete" :disabled="!selectedIds.length">{{ $t('relic.batchDelete') }}</el-button>
        <el-dropdown @command="handleExportCommand" style="margin-left: 10px;">
          <el-button type="info">
            {{ $t('common.export') }}<el-icon class="el-icon--right"><arrow-down /></el-icon>
          </el-button>
          <template #dropdown>
            <el-dropdown-menu>
              <el-dropdown-item command="excel">{{ $t('report.exportExcel') }}</el-dropdown-item>
              <el-dropdown-item command="pdf">{{ $t('report.exportPdf') }}</el-dropdown-item>
              <el-dropdown-item command="word">{{ $t('report.exportWord') }}</el-dropdown-item>
            </el-dropdown-menu>
          </template>
        </el-dropdown>
        <el-button type="primary" @click="handleImport">{{ $t('relic.importExcel') }}</el-button>
        <el-button @click="downloadTemplate">{{ $t('relic.downloadTemplate') }}</el-button>
        <el-button @click="handlePrintLabels" :disabled="!selectedIds.length">{{ $t('relic.printLabels') }}</el-button>
      </div>
    </template>

    <el-table :data="tableData" border @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" />
      <el-table-column prop="relicCode" :label="$t('relic.relicCode')" width="120" />
      <el-table-column prop="relicName" :label="$t('relic.relicName')" min-width="180" />
      <el-table-column :label="$t('relic.image')" width="110">
        <template #default="scope">
          <el-image
            v-if="scope.row.imagePath"
            :src="resolveImageUrl(scope.row.imagePath)"
            fit="cover"
            class="thumb"
            :preview-src-list="[resolveImageUrl(scope.row.imagePath)]"
            preview-teleported
          />
          <span v-else class="thumb placeholder">{{ $t('common.noData') }}</span>
        </template>
      </el-table-column>
      <el-table-column prop="era" :label="$t('relic.era')" width="120" />
      <el-table-column prop="material" :label="$t('relic.material')" width="120" />
      <el-table-column prop="status" :label="$t('relic.status')" width="100" />
      <el-table-column prop="categoryName" :label="$t('relic.category')" width="140" />
      <el-table-column :label="$t('relic.dimensions')" width="150">
        <template #default="scope">
          {{ scope.row.dimensions || '—' }}
        </template>
      </el-table-column>
      <el-table-column :label="$t('relic.weight')" width="110">
        <template #default="scope">
          {{ formatWeight(scope.row.weight) }}
        </template>
      </el-table-column>
      <el-table-column prop="description" :label="$t('relic.description')" min-width="220" show-overflow-tooltip />
      <el-table-column :label="$t('common.operation')" width="280">
        <template #default="scope">
          <el-button link type="primary" @click="viewDetail(scope.row)">{{ $t('common.detail') }}</el-button>
          <el-button link type="primary" @click="openEdit(scope.row)">{{ $t('common.edit') }}</el-button>
          <el-button link type="success" @click="showQRCode(scope.row)">{{ $t('relic.qrCode') }}</el-button>
          <el-button link type="danger" @click="remove(scope.row.id)">{{ $t('common.delete') }}</el-button>
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

    <el-dialog v-model="dialogVisible" :title="form.id ? $t('relic.editRelic') : $t('relic.addRelic')" width="700px" class="form-dialog">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px" class="dialog-form">
        <el-form-item :label="$t('relic.relicCode')">
          <el-input v-model="form.relicCode" :disabled="!form.id" :placeholder="form.id ? '' : $t('relic.autoGenerate')" />
        </el-form-item>
        <el-form-item :label="$t('relic.relicName')" prop="relicName"><el-input v-model="form.relicName" /></el-form-item>
        <el-form-item :label="$t('relic.era')" prop="era">
          <el-select v-model="form.era" style="width: 100%" clearable>
            <el-option label="史前" value="史前" />
            <el-option label="夏朝" value="夏朝" />
            <el-option label="商朝" value="商朝" />
            <el-option label="东周" value="东周" />
            <el-option label="西周" value="西周" />
            <el-option label="春秋" value="春秋" />
            <el-option label="战国" value="战国" />
            <el-option label="秦朝" value="秦朝" />
            <el-option label="汉朝" value="汉朝" />
            <el-option label="三国" value="三国" />
            <el-option label="晋朝" value="晋朝" />
            <el-option label="南北朝" value="南北朝" />
            <el-option label="隋朝" value="隋朝" />
            <el-option label="唐朝" value="唐朝" />
            <el-option label="五代十国" value="五代十国" />
            <el-option label="宋朝" value="宋朝" />
            <el-option label="辽朝" value="辽朝" />
            <el-option label="西夏" value="西夏" />
            <el-option label="金朝" value="金朝" />
            <el-option label="元朝" value="元朝" />
            <el-option label="明朝" value="明朝" />
            <el-option label="清朝" value="清朝" />
            <el-option label="民国" value="民国" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('relic.material')" prop="material"><el-input v-model="form.material" /></el-form-item>
        <el-form-item :label="$t('relic.category')" prop="categoryId">
          <el-select v-model="form.categoryId" style="width: 100%" clearable>
            <el-option v-for="item in categoryOptions" :key="item.id" :label="item.categoryName" :value="item.id" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('relic.status')" prop="status">
          <el-select v-model="form.status">
            <el-option :label="$t('relic.inStock')" value="在库" />
            <el-option :label="$t('relic.onLoan')" value="借展中" />
            <el-option :label="$t('relic.repairing')" value="修复中" />
            <el-option :label="$t('relic.sealed')" value="封存" />
          </el-select>
        </el-form-item>
        <el-form-item :label="$t('relic.dimensions')"><el-input v-model="form.dimensions" /></el-form-item>
        <el-form-item :label="$t('relic.weight')">
          <el-input-number v-model="form.weight" :min="0" :precision="2" :controls="false" style="width: 90%" />
          <span class="unit-text">kg</span>
        </el-form-item>
        <el-form-item :label="$t('relic.origin')"><el-input v-model="form.origin" /></el-form-item>
        
        <!-- 图片上传区域 -->
        <el-form-item :label="$t('relic.image')">
          <div class="image-upload-wrapper">
            <!-- 切换模式按钮 -->
            <el-radio-group v-model="imageInputMode" size="small" style="margin-bottom: 10px;">
              <el-radio-button label="upload">{{ $t('relic.uploadMode') }}</el-radio-button>
              <el-radio-button label="url">{{ $t('relic.urlMode') }}</el-radio-button>
            </el-radio-group>
            
            <!-- URL输入模式 -->
            <div v-if="imageInputMode === 'url'" class="url-input-box">
              <el-input
                v-model="form.imagePath"
                :placeholder="$t('relic.enterImageUrl')"
                clearable
                @input="handleUrlInput"
              >
                <template #prepend>
                  <el-icon><Link /></el-icon>
                </template>
              </el-input>
              <!-- URL预览 -->
              <div v-if="form.imagePath && isValidUrl(form.imagePath)" class="url-preview-box">
                <el-image
                  :src="form.imagePath"
                  fit="cover"
                  class="preview-img"
                  :preview-src-list="[form.imagePath]"
                  @error="handleImageError"
                />
                <div class="image-actions">
                  <el-button size="small" type="danger" @click="clearImageUrl">{{ $t('relic.remove') }}</el-button>
                </div>
              </div>
            </div>
            
            <!-- 文件上传模式 -->
            <div v-else>
              <!-- 图片预览 -->
              <div v-if="imagePreview" class="image-preview-box">
                <el-image
                  :src="imagePreview"
                  fit="cover"
                  class="preview-img"
                  :preview-src-list="[imagePreview]"
                />
                <div class="image-actions">
                  <el-button size="small" type="danger" @click="removeImage">{{ $t('relic.remove') }}</el-button>
                </div>
              </div>
              
              <!-- 上传按钮 -->
              <div v-else class="upload-box">
                <el-upload
                  ref="uploadRef"
                  :auto-upload="false"
                  :show-file-list="false"
                  :on-change="handleImageChange"
                  accept="image/*"
                  drag
                >
                  <el-icon class="el-icon--upload"><upload-filled /></el-icon>
                  <div class="el-upload__text">{{ $t('relic.dragOrClick') }}<em>{{ $t('relic.clickToUpload') }}</em></div>
                  <template #tip>
                    <div class="el-upload__tip">{{ $t('relic.imageUploadTip') }}</div>
                  </template>
                </el-upload>
              </div>
            </div>
          </div>
        </el-form-item>
        
        <el-form-item :label="$t('relic.description')"><el-input v-model="form.description" type="textarea" :rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submit" :loading="submitting">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 增强版详情对话框 -->
    <el-dialog 
      v-model="detailDialogVisible" 
      :title="$t('relic.relicDetail')" 
      width="1000px" 
      class="detail-dialog"
      :close-on-click-modal="false"
    >
      <div v-if="currentDetail" class="detail-container">
        <!-- 左侧：图片轮播 -->
        <div class="detail-left">
          <el-carousel 
            v-if="detailImages.length" 
            height="400px" 
            indicator-position="outside"
            class="detail-carousel"
          >
            <el-carousel-item v-for="(img, index) in detailImages" :key="index">
              <el-image
                :src="img"
                fit="contain"
                class="carousel-image"
                :preview-src-list="detailImages"
                :initial-index="index"
                preview-teleported
              />
            </el-carousel-item>
          </el-carousel>
          <div v-else class="no-image-placeholder">
            <el-icon :size="80"><Picture /></el-icon>
            <p>{{ $t('common.noData') }}</p>
          </div>
          
          <!-- 操作按钮 -->
          <div class="detail-actions">
            <el-button type="primary" @click="handleShare">
              <el-icon><Share /></el-icon>
              {{ $t('relic.share') }}
            </el-button>
            <el-button type="success" @click="handlePrintDetail">
              <el-icon><Printer /></el-icon>
              {{ $t('relic.print') }}
            </el-button>
          </div>
        </div>

        <!-- 右侧：详细信息 -->
        <div class="detail-right">
          <!-- 基本信息 -->
          <div class="detail-section">
            <h3 class="section-title">{{ $t('relic.basicInfo') }}</h3>
            <el-descriptions :column="2" border>
              <el-descriptions-item :label="$t('relic.relicCode')">{{ currentDetail.relicCode }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.relicName')">{{ currentDetail.relicName }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.era')">{{ currentDetail.era }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.material')">{{ currentDetail.material }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.category')">{{ currentDetail.categoryName || '—' }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.status')">
                <el-tag :type="getStatusType(currentDetail.status)">
                  {{ currentDetail.status }}
                </el-tag>
              </el-descriptions-item>
              <el-descriptions-item :label="$t('relic.dimensions')">{{ currentDetail.dimensions || '—' }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.weight')">{{ formatWeight(currentDetail.weight) }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.origin')" :span="2">{{ currentDetail.origin || '—' }}</el-descriptions-item>
              <el-descriptions-item :label="$t('relic.description')" :span="2">{{ currentDetail.description || '—' }}</el-descriptions-item>
            </el-descriptions>
          </div>

          <!-- 时间轴 -->
          <div class="detail-section">
            <h3 class="section-title">{{ $t('relic.historyRecords') }}</h3>
            <el-timeline class="detail-timeline">
              <el-timeline-item
                v-for="item in relicTimeline"
                :key="item.id"
                :timestamp="item.time"
                :type="item.type"
                placement="top"
              >
                <div class="timeline-content">
                  <strong>{{ item.title }}</strong>
                  <p>{{ item.content }}</p>
                </div>
              </el-timeline-item>
            </el-timeline>
          </div>

          <!-- 关联文物推荐 -->
          <div class="detail-section" v-if="relatedRelics.length">
            <h3 class="section-title">{{ $t('relic.relatedRelics') }}</h3>
            <div class="related-relics">
              <div 
                v-for="relic in relatedRelics" 
                :key="relic.id" 
                class="related-item"
                @click="viewRelatedDetail(relic)"
              >
                <el-image
                  v-if="relic.imagePath"
                  :src="resolveImageUrl(relic.imagePath)"
                  fit="cover"
                  class="related-image"
                />
                <div v-else class="related-image related-no-image">
                  <el-icon><Picture /></el-icon>
                </div>
                <div class="related-info">
                  <div class="related-name">{{ relic.relicName }}</div>
                  <div class="related-meta">{{ relic.era }} · {{ relic.material }}</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 分享对话框 -->
    <el-dialog v-model="shareDialogVisible" :title="$t('relic.shareRelic')" width="500px">
      <div class="share-content">
        <div class="share-info">
          <h4>{{ currentDetail?.relicName }}</h4>
          <p>{{ currentDetail?.era }} · {{ currentDetail?.material }}</p>
        </div>
        <el-divider />
        <div class="share-options">
          <div class="share-option" @click="copyShareLink">
            <el-icon :size="40"><Link /></el-icon>
            <span>{{ $t('relic.copyLink') }}</span>
          </div>
          <div class="share-option" @click="shareToWeChat">
            <el-icon :size="40"><ChatDotRound /></el-icon>
            <span>{{ $t('relic.wechatShare') }}</span>
          </div>
          <div class="share-option" @click="downloadQRCode">
            <el-icon :size="40"><Download /></el-icon>
            <span>{{ $t('relic.downloadQRCode') }}</span>
          </div>
        </div>
        <div class="share-qrcode">
          <canvas ref="qrcodeCanvas" width="200" height="200"></canvas>
          <p>{{ $t('relic.scanToView') }}</p>
        </div>
      </div>
    </el-dialog>

    <!-- 批量修改状态对话框 -->
    <el-dialog v-model="batchStatusDialogVisible" :title="$t('relic.batchUpdateStatus')" width="400px">
      <el-form label-width="100px">
        <el-form-item :label="$t('relic.selectedCount')">
          <span>{{ selectedIds.length }} {{ $t('common.items') }}</span>
        </el-form-item>
        <el-form-item :label="$t('relic.changeTo')">
          <el-select v-model="batchStatus" style="width: 100%">
            <el-option :label="$t('relic.inStock')" value="在库" />
            <el-option :label="$t('relic.onLoan')" value="借展中" />
            <el-option :label="$t('relic.repairing')" value="修复中" />
            <el-option :label="$t('relic.sealed')" value="封存" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="batchStatusDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitBatchStatus">{{ $t('common.confirm') }}</el-button>
      </template>
    </el-dialog>

    <!-- 导入对话框 -->
    <el-dialog v-model="importDialogVisible" :title="$t('relic.importData')" width="500px">
      <el-alert
        :title="$t('relic.importInstructions')"
        type="info"
        :closable="false"
        style="margin-bottom: 20px"
      >
        <p>{{ $t('relic.importTip1') }}</p>
        <p>{{ $t('relic.importTip2') }}</p>
        <p>{{ $t('relic.importTip3') }}</p>
        <p>{{ $t('relic.importTip4') }}</p>
      </el-alert>
      <el-upload
        drag
        :auto-upload="false"
        :limit="1"
        accept=".xlsx,.xls"
        :on-change="handleFileChange"
      >
        <div class="el-upload__text">
          {{ $t('relic.dragFileHere') }}<em>{{ $t('relic.clickToUpload') }}</em>
        </div>
        <template #tip>
          <div class="el-upload__tip">{{ $t('relic.uploadTip') }}</div>
        </template>
      </el-upload>
      <template #footer>
        <el-button @click="importDialogVisible = false">{{ $t('common.cancel') }}</el-button>
        <el-button type="primary" @click="submitImport">{{ $t('relic.confirmImport') }}</el-button>
      </template>
    </el-dialog>

    <!-- 二维码对话框 -->
    <el-dialog v-model="qrcodeDialogVisible" :title="$t('relic.qrCodeTitle')" width="500px" class="qrcode-dialog">
      <div v-if="currentQRCode" class="qrcode-content">
        <div class="qrcode-info">
          <h3>{{ currentQRCode.relicName }}</h3>
          <p class="qrcode-code">{{ $t('relic.relicCode2') }}{{ currentQRCode.relicCode }}</p>
        </div>
        
        <div class="qrcode-image-box">
          <img v-if="qrcodeImageData" :src="qrcodeImageData" :alt="$t('relic.qrCode')" class="qrcode-image" />
          <div v-else class="qrcode-loading">
            <el-icon class="is-loading" :size="40"><Loading /></el-icon>
            <p>{{ $t('relic.generating') }}</p>
          </div>
        </div>
        
        <div class="qrcode-tips">
          <el-icon><InfoFilled /></el-icon>
          <span>{{ $t('relic.scanQRCodeTip') }}</span>
        </div>
        
        <div class="qrcode-actions">
          <el-button type="primary" @click="downloadQRCodeImage" :disabled="!qrcodeImageData">
            <el-icon><Download /></el-icon>
            {{ $t('relic.downloadQRCodeBtn') }}
          </el-button>
          <el-button @click="printQRCode" :disabled="!qrcodeImageData">
            <el-icon><Printer /></el-icon>
            {{ $t('relic.printQRCodeBtn') }}
          </el-button>
        </div>
      </div>
    </el-dialog>
  </el-card>
</template>

<script setup>
import { onMounted, reactive, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage, ElMessageBox } from 'element-plus'
import { UploadFilled, Link, Loading, InfoFilled, Download, Printer } from '@element-plus/icons-vue'
import request from '../api/request'
import { getCategoriesApi } from '../api/categories'
import { 
  getRelicsPageApi, 
  addRelicApi,
  addRelicWithImageApi,
  updateRelicApi, 
  deleteRelicApi,
  batchDeleteRelicsApi,
  batchUpdateStatusApi,
  exportRelicsApi,
  exportRelicsPdfApi,
  exportRelicsWordApi,
  importRelicsApi,
  downloadTemplateApi,
  generateQRCodeApi
} from '../api/relics'

const { t } = useI18n()

const tableData = ref([])
const total = ref(0)
const categoryOptions = ref([])
const dialogVisible = ref(false)
const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const formRef = ref()
const uploadRef = ref()
const selectedIds = ref([])
const batchStatusDialogVisible = ref(false)
const batchStatus = ref('在库')
const importDialogVisible = ref(false)
const uploadFile = ref(null)
const shareDialogVisible = ref(false)
const qrcodeCanvas = ref(null)
const detailImages = ref([])
const relicTimeline = ref([])
const relatedRelics = ref([])
const submitting = ref(false)
const imageFile = ref(null)
const imagePreview = ref('')
const imageInputMode = ref('upload') // 'upload' 或 'url'
const qrcodeDialogVisible = ref(false)
const currentQRCode = ref(null)
const qrcodeImageData = ref('')
const query = reactive({ pageNum: 1, pageSize: 10, relicName: '', categoryId: null, status: '', era: '' })
const form = reactive({})
const rules = {
  relicName: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  era: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  material: [{ required: true, message: t('validation.required'), trigger: 'blur' }],
  categoryId: [{ required: true, message: t('validation.required'), trigger: 'change' }],
  status: [{ required: true, message: t('validation.required'), trigger: 'change' }]
}
const backendBaseURL = request.defaults.baseURL  // http://localhost:8080/api

const resolveImageUrl = (imagePath) => {
  if (!imagePath) return ''
  if (/^https?:\/\//i.test(imagePath)) return imagePath
  let normalized = String(imagePath).trim().replace(/\\/g, '/')
  if (normalized.startsWith('./')) normalized = normalized.slice(1)
  if (!normalized.startsWith('/')) normalized = `/${normalized}`
  return `${backendBaseURL}${normalized}`
}

const formatWeight = (weight) => {
  if (weight === null || weight === undefined || weight === '') return '—'
  return `${Number(weight).toFixed(2)} kg`
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const loadData = async () => {
  const res = await getRelicsPageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}

const loadCategories = async () => {
  const res = await getCategoriesApi()
  categoryOptions.value = res.data || []
}

const openAdd = () => {
  Object.assign(form, {
    id: null,
    relicCode: '',
    relicName: '',
    era: '',
    material: '',
    categoryId: null,
    status: '在库',
    dimensions: '',
    weight: null,
    origin: '',
    imagePath: '',
    description: ''
    // 不设置 createTime 和 updateTime，让后端自动设置
  })
  // 清空图片
  imageFile.value = null
  imagePreview.value = ''
  imageInputMode.value = 'upload' // 默认为上传模式
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
  dialogVisible.value = true
}

const openEdit = (row) => {
  Object.assign(form, row)
  // 编辑时显示现有图片
  imageFile.value = null
  imagePreview.value = row.imagePath ? resolveImageUrl(row.imagePath) : ''
  
  // 判断是URL还是上传的文件
  if (row.imagePath && /^https?:\/\//i.test(row.imagePath)) {
    imageInputMode.value = 'url'
  } else {
    imageInputMode.value = 'upload'
  }
  
  dialogVisible.value = true
}

const viewDetail = async (row) => {
  currentDetail.value = row
  detailDialogVisible.value = true
  
  // 准备图片列表（支持多图）
  if (row.imagePath) {
    detailImages.value = [resolveImageUrl(row.imagePath)]
  } else {
    detailImages.value = []
  }
  
  // 加载时间轴数据
  await loadRelicTimeline(row.id)
  
  // 加载关联文物
  await loadRelatedRelics(row)
}

const loadRelicTimeline = async (relicId) => {
  // 模拟时间轴数据（实际项目中应该从后端获取）
  relicTimeline.value = [
    {
      id: 1,
      time: formatDateTime(currentDetail.value.createTime),
      type: 'primary',
      title: '文物入库',
      content: '文物正式入库登记，编号：' + currentDetail.value.relicCode
    }
  ]
  
  // 如果有更新时间，添加更新记录
  if (currentDetail.value.updateTime && currentDetail.value.updateTime !== currentDetail.value.createTime) {
    relicTimeline.value.push({
      id: 2,
      time: formatDateTime(currentDetail.value.updateTime),
      type: 'success',
      title: '信息更新',
      content: '文物信息已更新'
    })
  }
  
  // 根据状态添加相应记录
  if (currentDetail.value.status === '借展中') {
    relicTimeline.value.push({
      id: 3,
      time: formatDateTime(currentDetail.value.updateTime),
      type: 'warning',
      title: '借展出库',
      content: '文物已借出展览'
    })
  } else if (currentDetail.value.status === '修复中') {
    relicTimeline.value.push({
      id: 4,
      time: formatDateTime(currentDetail.value.updateTime),
      type: 'danger',
      title: '送修',
      content: '文物已送修复'
    })
  }
  
  // 按时间倒序排列
  relicTimeline.value.sort((a, b) => new Date(b.time) - new Date(a.time))
}

const loadRelatedRelics = async (relic) => {
  // 查找相关文物（同年代或同材质）
  relatedRelics.value = tableData.value
    .filter(item => 
      item.id !== relic.id && 
      (item.era === relic.era || item.material === relic.material || item.categoryId === relic.categoryId)
    )
    .slice(0, 4) // 最多显示4个
}

const viewRelatedDetail = (relic) => {
  viewDetail(relic)
}

const getStatusType = (status) => {
  const typeMap = {
    '在库': 'success',
    '借展中': 'warning',
    '修复中': 'danger',
    '封存': 'info'
  }
  return typeMap[status] || 'info'
}

const handleShare = () => {
  shareDialogVisible.value = true
  // 生成二维码
  setTimeout(() => {
    generateQRCode()
  }, 100)
}

const generateQRCode = () => {
  if (!qrcodeCanvas.value) return
  
  const canvas = qrcodeCanvas.value
  const ctx = canvas.getContext('2d')
  
  // 简单的二维码占位（实际项目中应使用 qrcode 库）
  ctx.fillStyle = '#fff'
  ctx.fillRect(0, 0, 200, 200)
  ctx.fillStyle = '#000'
  ctx.font = '12px Arial'
  ctx.textAlign = 'center'
  ctx.fillText('文物编号', 100, 90)
  ctx.fillText(currentDetail.value.relicCode, 100, 110)
  
  // 绘制简单的方框代表二维码
  for (let i = 0; i < 10; i++) {
    for (let j = 0; j < 10; j++) {
      if (Math.random() > 0.5) {
        ctx.fillRect(20 + i * 16, 20 + j * 16, 14, 14)
      }
    }
  }
}

const copyShareLink = () => {
  const link = `${window.location.origin}/relics/${currentDetail.value.id}`
  navigator.clipboard.writeText(link).then(() => {
    ElMessage.success(t('relic.linkCopied'))
  }).catch(() => {
    ElMessage.error(t('relic.copyFailed'))
  })
}

const shareToWeChat = () => {
  ElMessage.info(t('relic.scanQRCode'))
}

const downloadQRCode = () => {
  if (!qrcodeCanvas.value) return
  
  const canvas = qrcodeCanvas.value
  const link = document.createElement('a')
  link.download = `${t('relic.qrCode')}_${currentDetail.value.relicCode}.png`
  link.href = canvas.toDataURL()
  link.click()
  ElMessage.success(t('relic.qrCodeDownloaded'))
}

const handlePrintDetail = () => {
  if (!currentDetail.value) return
  
  const printWindow = window.open('', '_blank')
  
  const printContent = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>${t('relic.relicDetailTitle')} - ${currentDetail.value.relicName}</title>
      <style>
        @page { size: A4; margin: 20mm; }
        body { 
          font-family: "Microsoft YaHei", Arial, sans-serif; 
          margin: 0; 
          padding: 20px;
          color: #333;
        }
        .header {
          text-align: center;
          border-bottom: 3px solid #333;
          padding-bottom: 20px;
          margin-bottom: 30px;
        }
        .header h1 {
          margin: 0 0 10px;
          font-size: 28px;
        }
        .header .code {
          font-size: 16px;
          color: #666;
        }
        .info-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 15px;
          margin-bottom: 30px;
        }
        .info-item {
          padding: 10px;
          border-bottom: 1px solid #eee;
        }
        .info-label {
          font-weight: bold;
          color: #666;
          margin-bottom: 5px;
        }
        .info-value {
          color: #333;
        }
        .description {
          margin-top: 20px;
          padding: 15px;
          background: #f5f5f5;
          border-radius: 5px;
        }
        @media print {
          body { padding: 0; }
        }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>${currentDetail.value.relicName}</h1>
        <div class="code">${t('relic.relicCode2')}${currentDetail.value.relicCode}</div>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">${t('relic.era')}</div>
          <div class="info-value">${currentDetail.value.era || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${t('relic.material')}</div>
          <div class="info-value">${currentDetail.value.material || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${t('relic.category')}</div>
          <div class="info-value">${currentDetail.value.categoryName || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${t('relic.status')}</div>
          <div class="info-value">${currentDetail.value.status || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${t('relic.dimensions')}</div>
          <div class="info-value">${currentDetail.value.dimensions || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${t('relic.weight')}</div>
          <div class="info-value">${formatWeight(currentDetail.value.weight)}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${t('relic.origin')}</div>
          <div class="info-value">${currentDetail.value.origin || '—'}</div>
        </div>
      </div>
      
      <div class="description">
        <div class="info-label">${t('relic.description')}</div>
        <div class="info-value">${currentDetail.value.description || '—'}</div>
      </div>
    </body>
    </html>
  `
  
  printWindow.document.write(printContent)
  printWindow.document.close()
  
  ElMessage.success(t('relic.printPreviewGenerated'))
}

const submit = async () => {
  try {
    await formRef.value?.validate()
    submitting.value = true
    
    if (form.id) {
      // 编辑模式：使用原有的更新接口
      console.log('编辑文物:', form)
      
      // 如果是URL模式，确保imagePath有值
      if (imageInputMode.value === 'url') {
        // URL模式下，imagePath已经在form中
        console.log('URL模式，imagePath:', form.imagePath)
      } else if (imageFile.value) {
        // 上传模式且有新文件，需要特殊处理
        // 这里可以扩展为支持编辑时上传新图片
        ElMessage.warning(t('relic.editModeNoUpload'))
        submitting.value = false
        return
      }
      
      const response = await updateRelicApi(form)
      console.log('更新响应:', response)
      
      // 检查响应状态
      if (response.code === 200) {
        ElMessage.success(t('message.updateSuccess'))
        dialogVisible.value = false
        loadData()
      } else {
        ElMessage.error(response.message || t('message.operationFailed'))
      }
    } else {
      // 新增模式
      console.log('新增文物 - 模式:', imageInputMode.value)
      console.log('表单数据:', form)
      
      let response
      if (imageInputMode.value === 'url') {
        // URL模式：使用原有接口，imagePath已在form中
        console.log('URL模式，调用 addRelicApi，imagePath:', form.imagePath)
        response = await addRelicApi(form)
        console.log('响应:', response)
      } else if (imageFile.value) {
        // 上传模式且有文件：使用 FormData
        console.log('上传模式，调用 addRelicWithImageApi')
        const formData = new FormData()
        formData.append('relicName', form.relicName)
        formData.append('era', form.era || '')
        formData.append('material', form.material || '')
        formData.append('status', form.status || '在库')
        if (form.categoryId) formData.append('categoryId', form.categoryId)
        if (form.dimensions) formData.append('dimensions', form.dimensions)
        if (form.weight) formData.append('weight', form.weight)
        if (form.origin) formData.append('origin', form.origin)
        if (form.description) formData.append('description', form.description)
        formData.append('imageFile', imageFile.value)
        
        response = await addRelicWithImageApi(formData)
        console.log('响应:', response)
      } else {
        // 无图片：使用原有接口
        console.log('无图片，调用 addRelicApi')
        response = await addRelicApi(form)
        console.log('响应:', response)
      }
      
      // 检查响应状态
      if (response.code === 200) {
        ElMessage.success(t('message.saveSuccess'))
        dialogVisible.value = false
        loadData()
      } else {
        // 显示后端返回的错误信息
        ElMessage.error(response.message || t('message.operationFailed'))
        console.error('保存失败:', response.message)
      }
    }
  } catch (error) {
    console.error('提交失败:', error)
    // 显示更详细的错误信息
    const errorMsg = error.response?.data?.message || error.message || t('message.operationFailed')
    ElMessage.error(errorMsg)
  } finally {
    submitting.value = false
  }
}

// 处理图片选择
const handleImageChange = (file) => {
  const isImage = file.raw.type.startsWith('image/')
  const isLt5M = file.raw.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error(t('relic.onlyImageAllowed'))
    return
  }
  if (!isLt5M) {
    ElMessage.error(t('relic.imageSizeLimit'))
    return
  }

  imageFile.value = file.raw
  
  // 生成预览
  const reader = new FileReader()
  reader.onload = (e) => {
    imagePreview.value = e.target.result
  }
  reader.readAsDataURL(file.raw)
}

// 移除图片
const removeImage = () => {
  imageFile.value = null
  imagePreview.value = ''
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
}

// 验证URL格式
const isValidUrl = (url) => {
  if (!url) return false
  return /^https?:\/\/.+/i.test(url)
}

// 处理URL输入
const handleUrlInput = () => {
  // URL输入时清空文件上传
  imageFile.value = null
  imagePreview.value = ''
  if (uploadRef.value) {
    uploadRef.value.clearFiles()
  }
}

// 清除图片URL
const clearImageUrl = () => {
  form.imagePath = ''
}

// 处理图片加载错误
const handleImageError = () => {
  ElMessage.warning(t('relic.imageLoadError'))
}

const remove = async (id) => {
  await ElMessageBox.confirm(t('relic.deleteConfirm'), t('message.tip'), { type: 'warning' })
  await deleteRelicApi(id)
  ElMessage.success(t('message.deleteSuccess'))
  loadData()
}

const handleSelectionChange = (selection) => {
  selectedIds.value = selection.map(item => item.id)
}

const handleBatchDelete = async () => {
  await ElMessageBox.confirm(t('relic.batchDeleteConfirm', { count: selectedIds.value.length }), t('relic.batchDelete'), { type: 'warning' })
  await batchDeleteRelicsApi(selectedIds.value)
  ElMessage.success(t('relic.batchDeleteSuccess'))
  selectedIds.value = []
  loadData()
}

const handleBatchStatus = () => {
  batchStatusDialogVisible.value = true
}

const submitBatchStatus = async () => {
  await batchUpdateStatusApi(selectedIds.value, batchStatus.value)
  ElMessage.success(t('relic.batchUpdateSuccess'))
  batchStatusDialogVisible.value = false
  selectedIds.value = []
  loadData()
}

const handleExportCommand = (command) => {
  switch (command) {
    case 'excel':
      handleExportExcel()
      break
    case 'pdf':
      handleExportPdf()
      break
    case 'word':
      handleExportWord()
      break
  }
}

const handleExportExcel = async () => {
  try {
    const res = await exportRelicsApi(query)
    const blob = new Blob([res])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${t('relic.relicData')}_${new Date().getTime()}.xlsx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('report.exportExcel') + t('common.success'))
  } catch (error) {
    ElMessage.error(t('message.operationFailed'))
  }
}

const handleExportPdf = async () => {
  try {
    const res = await exportRelicsPdfApi(query)
    const blob = new Blob([res], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${t('relic.relicData')}_${new Date().getTime()}.pdf`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('report.exportPdf') + t('common.success'))
  } catch (error) {
    console.error('导出PDF失败:', error)
    ElMessage.error(t('message.operationFailed'))
  }
}

const handleExportWord = async () => {
  try {
    const res = await exportRelicsWordApi(query)
    const blob = new Blob([res], { type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `${t('relic.relicData')}_${new Date().getTime()}.docx`
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('report.exportWord') + t('common.success'))
  } catch (error) {
    console.error('导出Word失败:', error)
    ElMessage.error(t('message.operationFailed'))
  }
}

const handleImport = () => {
  importDialogVisible.value = true
}

const handleFileChange = (file) => {
  uploadFile.value = file.raw
}

const submitImport = async () => {
  if (!uploadFile.value) {
    ElMessage.warning(t('relic.selectFile'))
    return
  }
  try {
    const res = await importRelicsApi(uploadFile.value)
    ElMessage.success(res.message || t('relic.importSuccess'))
    importDialogVisible.value = false
    uploadFile.value = null
    loadData()
  } catch (error) {
    ElMessage.error(t('relic.importFailed') + '：' + (error.response?.data?.message || error.message))
  }
}

const downloadTemplate = async () => {
  try {
    const res = await downloadTemplateApi()
    const blob = new Blob([res])
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = t('relic.importTemplate') + '.xlsx'
    link.click()
    window.URL.revokeObjectURL(url)
    ElMessage.success(t('message.operationSuccess'))
  } catch (error) {
    ElMessage.error(t('message.operationFailed'))
  }
}

const handlePrintLabels = () => {
  if (!selectedIds.value.length) {
    ElMessage.warning(t('relic.selectRelicsToPrint'))
    return
  }
  
  // 获取选中的文物数据
  const selectedRelics = tableData.value.filter(item => selectedIds.value.includes(item.id))
  
  // 创建打印窗口
  const printWindow = window.open('', '_blank')
  
  // 生成打印内容
  let printContent = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>${t('relic.printLabels')}</title>
      <style>
        @page { size: A4; margin: 10mm; }
        body { font-family: "Microsoft YaHei", Arial, sans-serif; margin: 0; padding: 20px; }
        .label-container { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .label { 
          border: 2px solid #333; 
          padding: 15px; 
          page-break-inside: avoid;
          border-radius: 8px;
          background: #fff;
        }
        .label-title { 
          font-size: 18px; 
          font-weight: bold; 
          margin-bottom: 10px; 
          border-bottom: 2px solid #333;
          padding-bottom: 8px;
        }
        .label-row { 
          display: flex; 
          margin: 8px 0; 
          font-size: 14px;
        }
        .label-key { 
          font-weight: bold; 
          width: 80px; 
          color: #666;
        }
        .label-value { 
          flex: 1;
          color: #333;
        }
        .qr-code {
          text-align: center;
          margin-top: 10px;
          padding-top: 10px;
          border-top: 1px dashed #ccc;
        }
        @media print {
          .no-print { display: none; }
        }
      </style>
    </head>
    <body>
      <div class="no-print" style="margin-bottom: 20px; text-align: center;">
        <button onclick="window.print()" style="padding: 10px 30px; font-size: 16px; cursor: pointer;">${t('relic.print')}</button>
        <button onclick="window.close()" style="padding: 10px 30px; font-size: 16px; cursor: pointer; margin-left: 10px;">${t('common.close')}</button>
      </div>
      <div class="label-container">
  `
  
  selectedRelics.forEach(relic => {
    printContent += `
      <div class="label">
        <div class="label-title">${relic.relicName || t('relic.unnamed')}</div>
        <div class="label-row">
          <span class="label-key">${t('relic.relicCode')}：</span>
          <span class="label-value">${relic.relicCode || '—'}</span>
        </div>
        <div class="label-row">
          <span class="label-key">${t('relic.era')}：</span>
          <span class="label-value">${relic.era || '—'}</span>
        </div>
        <div class="label-row">
          <span class="label-key">${t('relic.material')}：</span>
          <span class="label-value">${relic.material || '—'}</span>
        </div>
        <div class="label-row">
          <span class="label-key">${t('relic.category')}：</span>
          <span class="label-value">${relic.categoryName || '—'}</span>
        </div>
        <div class="label-row">
          <span class="label-key">${t('relic.status')}：</span>
          <span class="label-value">${relic.status || '—'}</span>
        </div>
        <div class="qr-code">
          <div style="font-size: 12px; color: #999;">${t('relic.relicCode')}: ${relic.relicCode}</div>
        </div>
      </div>
    `
  })
  
  printContent += `
      </div>
    </body>
    </html>
  `
  
  printWindow.document.write(printContent)
  printWindow.document.close()
  
  ElMessage.success(t('relic.printPreviewGenerated'))
}

// 显示二维码
const showQRCode = async (row) => {
  currentQRCode.value = row
  qrcodeImageData.value = ''
  qrcodeDialogVisible.value = true
  
  try {
    // 获取前端基础URL
    const baseUrl = window.location.origin
    
    // 调用后端API生成二维码
    const res = await generateQRCodeApi(row.id, baseUrl)
    
    if (res.code === 200 && res.data) {
      // 后端返回的是base64格式的图片
      qrcodeImageData.value = res.data
    } else {
      ElMessage.error(res.message || t('relic.qrCodeGenerateFailed'))
      qrcodeDialogVisible.value = false
    }
  } catch (error) {
    console.error('生成二维码失败:', error)
    ElMessage.error(t('relic.qrCodeGenerateFailed'))
    qrcodeDialogVisible.value = false
  }
}

// 下载二维码图片
const downloadQRCodeImage = () => {
  if (!qrcodeImageData.value || !currentQRCode.value) return
  
  const link = document.createElement('a')
  link.download = `二维码_${currentQRCode.value.relicCode}_${currentQRCode.value.relicName}.png`
  link.href = qrcodeImageData.value
  link.click()
  
  ElMessage.success(t('relic.qrCodeDownloaded2'))
}

// 打印二维码
const printQRCode = () => {
  if (!qrcodeImageData.value || !currentQRCode.value) return
  
  const printWindow = window.open('', '_blank')
  
  const printContent = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>${t('relic.qrCodePrintTitle')} - ${currentQRCode.value.relicName}</title>
      <style>
        @page { size: A4; margin: 20mm; }
        body { 
          font-family: "Microsoft YaHei", Arial, sans-serif; 
          margin: 0; 
          padding: 20px;
          text-align: center;
        }
        .qrcode-container {
          max-width: 400px;
          margin: 0 auto;
          padding: 30px;
          border: 2px solid #333;
          border-radius: 12px;
        }
        .qrcode-title {
          font-size: 24px;
          font-weight: bold;
          margin-bottom: 10px;
          color: #333;
        }
        .qrcode-code {
          font-size: 16px;
          color: #666;
          margin-bottom: 20px;
        }
        .qrcode-img {
          width: 300px;
          height: 300px;
          margin: 20px auto;
        }
        .qrcode-tip {
          font-size: 14px;
          color: #999;
          margin-top: 20px;
        }
        @media print {
          .no-print { display: none; }
        }
      </style>
    </head>
    <body>
      <div class="no-print" style="margin-bottom: 20px;">
        <button onclick="window.print()" style="padding: 10px 30px; font-size: 16px; cursor: pointer;">${t('relic.print')}</button>
        <button onclick="window.close()" style="padding: 10px 30px; font-size: 16px; cursor: pointer; margin-left: 10px;">${t('common.close')}</button>
      </div>
      
      <div class="qrcode-container">
        <div class="qrcode-title">${currentQRCode.value.relicName}</div>
        <div class="qrcode-code">${t('relic.relicCode2')}${currentQRCode.value.relicCode}</div>
        <img src="${qrcodeImageData.value}" alt="${t('relic.qrCode')}" class="qrcode-img" />
        <div class="qrcode-tip">${t('relic.scanQRCodeDetail')}</div>
      </div>
    </body>
    </html>
  `
  
  printWindow.document.write(printContent)
  printWindow.document.close()
  
  ElMessage.success(t('relic.printPreviewGenerated'))
}

onMounted(async () => {
  await Promise.all([loadCategories(), loadData()])
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

.thumb {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  flex-shrink: 0;
  border: 1px solid #eadfce;
  background: #f7efe4;
}

.thumb.placeholder {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #9b8d7d;
  font-size: 12px;
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

.dialog-form :deep(.el-form-item__content) {
  gap: 8px;
}

.unit-text {
  color: #7a6c5b;
  white-space: nowrap;
}

/* 图片上传样式 */
.image-upload-wrapper {
  width: 100%;
}

.image-preview-box {
  text-align: center;
}

.preview-img {
  width: 200px;
  height: 200px;
  border-radius: 8px;
  border: 1px solid #dcdfe6;
  object-fit: cover;
}

.image-actions {
  margin-top: 12px;
}

.upload-box {
  width: 100%;
}

/* URL输入框样式 */
.url-input-box {
  width: 100%;
}

.url-preview-box {
  margin-top: 16px;
  text-align: center;
}

:deep(.el-upload-dragger) {
  padding: 30px 20px;
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  background-color: #fafafa;
  transition: all 0.3s;
}

:deep(.el-upload-dragger:hover) {
  border-color: #409eff;
}

:deep(.el-icon--upload) {
  font-size: 50px;
  color: #c0c4cc;
  margin-bottom: 12px;
}

:deep(.el-upload__text) {
  color: #606266;
  font-size: 14px;
}

:deep(.el-upload__text em) {
  color: #409eff;
  font-style: normal;
}

:deep(.el-upload__tip) {
  margin-top: 8px;
  color: #909399;
  font-size: 12px;
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

/* 详情对话框样式 */
.detail-container {
  display: grid;
  grid-template-columns: 450px 1fr;
  gap: 30px;
  max-height: 70vh;
  overflow-y: auto;
}

.detail-left {
  position: sticky;
  top: 0;
}

.detail-carousel {
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #eadfce;
}

.carousel-image {
  width: 100%;
  height: 100%;
  background: #f7efe4;
}

.no-image-placeholder {
  height: 400px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #f7efe4;
  border-radius: 12px;
  color: #9b8d7d;
}

.detail-actions {
  display: flex;
  gap: 10px;
  margin-top: 20px;
}

.detail-actions .el-button {
  flex: 1;
}

.detail-right {
  overflow-y: auto;
}

.detail-section {
  margin-bottom: 30px;
}

.section-title {
  font-size: 18px;
  font-weight: bold;
  color: #3d2a1d;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 2px solid #eadfce;
}

.detail-timeline {
  padding-left: 10px;
}

.timeline-content strong {
  color: #3d2a1d;
  font-size: 15px;
}

.timeline-content p {
  margin: 5px 0 0;
  color: #7a6c5b;
  font-size: 14px;
}

.related-relics {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 15px;
}

.related-item {
  display: flex;
  gap: 12px;
  padding: 12px;
  border-radius: 12px;
  border: 1px solid #eadfce;
  cursor: pointer;
  transition: all 0.3s;
}

.related-item:hover {
  border-color: #8a5b2f;
  box-shadow: 0 4px 12px rgba(138, 91, 47, 0.1);
  transform: translateY(-2px);
}

.related-image {
  width: 80px;
  height: 80px;
  border-radius: 8px;
  flex-shrink: 0;
  border: 1px solid #eadfce;
}

.related-no-image {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f7efe4;
  color: #9b8d7d;
}

.related-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.related-name {
  font-weight: bold;
  color: #3d2a1d;
  margin-bottom: 5px;
}

.related-meta {
  font-size: 13px;
  color: #7a6c5b;
}

/* 分享对话框样式 */
.share-content {
  text-align: center;
}

.share-info h4 {
  margin: 0 0 5px;
  color: #3d2a1d;
  font-size: 20px;
}

.share-info p {
  margin: 0;
  color: #7a6c5b;
}

.share-options {
  display: flex;
  justify-content: space-around;
  margin: 20px 0;
}

.share-option {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 20px;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.share-option:hover {
  background: #f7efe4;
  transform: translateY(-2px);
}

.share-option span {
  color: #3d2a1d;
  font-size: 14px;
}

.share-qrcode {
  margin-top: 20px;
  padding: 20px;
  background: #f7efe4;
  border-radius: 12px;
}

.share-qrcode canvas {
  border: 2px solid #fff;
  border-radius: 8px;
}

.share-qrcode p {
  margin: 10px 0 0;
  color: #7a6c5b;
  font-size: 14px;
}

/* 二维码对话框样式 */
.qrcode-dialog :deep(.el-dialog__body) {
  padding: 30px;
}

.qrcode-content {
  text-align: center;
}

.qrcode-info h3 {
  margin: 0 0 8px;
  font-size: 22px;
  color: #3d2a1d;
}

.qrcode-code {
  margin: 0 0 20px;
  font-size: 14px;
  color: #7a6c5b;
}

.qrcode-image-box {
  width: 300px;
  height: 300px;
  margin: 0 auto 20px;
  border: 2px solid #eadfce;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
}

.qrcode-image {
  max-width: 100%;
  max-height: 100%;
  display: block;
}

.qrcode-loading {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  color: #7a6c5b;
}

.qrcode-tips {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 12px;
  background: #f7efe4;
  border-radius: 8px;
  color: #7a6c5b;
  font-size: 14px;
  margin-bottom: 20px;
}

.qrcode-actions {
  display: flex;
  gap: 12px;
  justify-content: center;
}

.qrcode-actions .el-button {
  min-width: 140px;
}
</style>