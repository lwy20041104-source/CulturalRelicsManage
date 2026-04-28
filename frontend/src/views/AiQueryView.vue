<template>
  <el-card class="ai-page">
    <template #header>
      <div class="page-head">
        <div>
          <h2>{{ $t('ai.aiQuery') }}</h2>
          <p>{{ $t('ai.aiIntro') }}</p>
        </div>
      </div>
    </template>

    <section class="hero-panel">
      <div class="hero-copy">
        <span class="hero-badge">{{ $t('ai.museumAiSearch') }}</span>
        <h3>{{ $t('ai.aiDescription') }}</h3>
        <p>{{ $t('ai.aiIntro') }}</p>
      </div>
      <div class="hero-search">
        <el-input
          v-model="question"
          type="textarea"
          :rows="4"
          resize="none"
          :placeholder="$t('ai.placeholderExample')"
          @keyup.ctrl.enter="runQuery"
        />
        <div class="search-options">
          <el-switch v-model="matchAll" inline-prompt :active-text="$t('ai.strictLabel')" :inactive-text="$t('ai.normalMode')" />
          <span class="option-text">{{ $t('ai.strictMode') }}</span>
        </div>
        <div class="hero-actions">
          <el-button type="primary" size="large" :loading="loading" @click="runQuery">{{ $t('ai.aiQuery') }}</el-button>
          <el-button size="large" @click="useExample('唐朝 青铜器 在库', false)">{{ $t('ai.combinationExample') }}</el-button>
          <el-button size="large" @click="useExample('唐朝 青铜器 在库', true)">{{ $t('ai.strictExample') }}</el-button>
        </div>
      </div>
    </section>

    <section class="quick-prompts">
      <button v-for="item in prompts" :key="item.label" class="prompt-chip" @click="useExample(item.text, item.matchAll)">
        {{ item.label }}
      </button>
    </section>

    <section v-if="result.answer" class="answer-panel">
      <div class="answer-title">{{ $t('ai.aiAnswer') }}</div>
      <div class="answer-content">{{ result.answer }}</div>
    </section>

    <section v-if="searched && result.museumMessage" class="museum-panel" :class="result.museumHit ? 'museum-hit' : 'museum-miss'">
      <div class="museum-title">{{ $t('ai.museumSearchResult') }}</div>
      <div class="museum-content">{{ result.museumMessage }}</div>
    </section>

    <section v-if="result.topReason" class="top-reason-panel">
      <div class="top-reason-title">{{ $t('ai.whyTopOne') }}</div>
      <div class="top-reason-content">{{ result.topReason }}</div>
    </section>

    <section v-if="result.relics.length" class="result-panel">
      <div class="result-head">
        <h3>{{ result.museumHit === false ? $t('ai.webSearchResult') : $t('ai.relatedRelics') }}</h3>
        <span>{{ $t('ai.total') }} {{ result.total || result.relics.length }} {{ $t('ai.items') }}</span>
      </div>

      <div class="result-grid">
        <article v-for="(item, index) in result.relics" :key="item.id" class="relic-card">
          <div class="rank-badge">TOP {{ index + 1 }}</div>
          <div v-if="result.museumHit !== false" class="relevance-chip">
            <span>{{ $t('ai.relevance') }}</span>
            <strong>{{ item.relevancePercent || 0 }}%</strong>
          </div>
          <div class="relic-top">
            <el-image
              v-if="item.imagePath"
              :src="resolveImageUrl(item.imagePath)"
              fit="cover"
              class="relic-image"
              :preview-src-list="[resolveImageUrl(item.imagePath)]"
              preview-teleported
            />
            <div v-else class="relic-image relic-image-empty">{{ $t('common.noData') }}</div>
            <div class="relic-main">
              <div class="relic-title-row">
                <h4>{{ item.relicName || '未命名文物' }}</h4>
                <div v-if="result.museumHit === false" class="source-meta">
                  <span v-if="item.sourceType" class="source-type-badge">{{ item.sourceType }}</span>
                  <span v-if="item.sourceName" class="relic-id">{{ item.sourceName }}</span>
                </div>
                <span v-else class="relic-id">ID {{ item.id }}</span>
              </div>
              <div class="meta-grid">
                <div><label>{{ $t('relic.era') }}</label><span>{{ item.era || '未录入' }}</span></div>
                <div><label>{{ $t('relic.material') }}</label><span>{{ item.material || '未录入' }}</span></div>
                <div><label>{{ $t('relic.status') }}</label><span>{{ item.status || '未录入' }}</span></div>
                <div><label>{{ $t('relic.category') }}</label><span>{{ item.categoryName || '未录入' }}</span></div>
                <div><label>{{ $t('relic.dimensions') }}</label><span>{{ item.dimensions || '未录入' }}</span></div>
                <div><label>{{ $t('relic.weight') }}</label><span>{{ formatWeight(item.weight) }}</span></div>
              </div>
            </div>
          </div>
          <div v-if="result.museumHit !== false && item.matchTags?.length" class="tag-section">
            <strong>{{ $t('ai.matchReason') }}</strong>
            <div class="tag-list">
              <span
                v-for="tag in item.matchTags"
                :key="tag"
                class="match-tag"
                :class="tagClass(tag)"
              >{{ tag }}</span>
            </div>
          </div>
          <div class="content-block">
            <strong>{{ $t('ai.description') }}</strong>
            <p>{{ item.description || '暂无描述' }}</p>
          </div>
          <div v-if="result.museumHit === false && item.sourceUrl" class="content-block">
            <strong>{{ $t('ai.sourceInfo') }}</strong>
            <p>
              <span v-if="item.sourceType" class="source-type-inline">{{ item.sourceType }}</span>
              <span v-if="item.sourceName">{{ item.sourceName }}</span>
            </p>
            <p><a class="source-link" :href="item.sourceUrl" target="_blank" rel="noreferrer">{{ item.sourceUrl }}</a></p>
          </div>
          <div class="content-block intro-block">
            <strong>{{ $t('ai.relatedIntro') }}</strong>
            <p>{{ item.introduction || '暂无介绍' }}</p>
          </div>
        </article>
      </div>
    </section>

    <section v-if="result.webResults?.length && result.museumHit !== false" class="web-panel">
      <div class="result-head">
        <h3>{{ $t('ai.webRelatedSearch') }}</h3>
        <span>{{ $t('ai.total') }} {{ result.webResults.length }} {{ $t('ai.items') }}</span>
      </div>
      <div class="web-list">
        <a v-for="item in result.webResults" :key="item.url" class="web-card" :href="item.url" target="_blank" rel="noreferrer">
          <div class="web-source">{{ item.source }}</div>
          <div class="web-title">{{ item.title }}</div>
          <div class="web-summary">{{ item.summary }}</div>
        </a>
      </div>
    </section>

    <section v-else-if="searched && !loading && !result.relics.length" class="empty-panel">
      <span v-if="result.museumHit === false">{{ $t('ai.noRelicInMuseum') }}</span>
      <span v-else>{{ $t('ai.noResultTip') }}</span>
    </section>
  </el-card>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage } from 'element-plus'
import request from '../api/request'
import { queryRelicAiApi } from '../api/ai'

const { t } = useI18n()

const question = ref('')
const matchAll = ref(false)
const loading = ref(false)
const searched = ref(false)
const result = reactive({ answer: '', total: 0, topReason: '', museumHit: null, museumMessage: '', relics: [], webResults: [] })
const backendBaseURL = request.defaults.baseURL  // http://localhost:8080/api
const prompts = [
  { label: '铜器 ≈ 青铜器', text: '铜器 在库', matchAll: false },
  { label: '组合检索', text: '唐朝 青铜器 在库', matchAll: false },
  { label: '严格全命中', text: '唐朝 青铜器 在库', matchAll: true },
  { label: '修复中的铜器', text: '铜器 修复中', matchAll: false }
]

const resolveImageUrl = (imagePath) => {
  if (!imagePath) return ''
  console.log('resolveImageUrl - 原始路径:', imagePath)
  
  // 如果是外部 URL（百度百科等），使用代理
  if (/^https?:\/\//i.test(imagePath)) {
    console.log('resolveImageUrl - 外部URL，使用代理:', imagePath)
    // Base64 编码 URL
    const encodedUrl = btoa(imagePath)
    const proxyUrl = `${backendBaseURL}/proxy/image?url=${encodedUrl}`
    console.log('resolveImageUrl - 代理URL:', proxyUrl)
    return proxyUrl
  }
  
  // 本地图片路径
  let normalized = String(imagePath).trim().replace(/\\/g, '/')
  if (normalized.startsWith('./')) normalized = normalized.slice(1)
  if (!normalized.startsWith('/')) normalized = `/${normalized}`
  const fullUrl = `${backendBaseURL}${normalized}`
  console.log('resolveImageUrl - 本地URL，拼接后:', fullUrl)
  return fullUrl
}

const formatWeight = (weight) => {
  if (weight === null || weight === undefined || weight === '') return '未录入'
  return `${Number(weight).toFixed(2)} kg`
}

const tagClass = (tag) => {
  if (tag.startsWith('名称')) return 'tag-name'
  if (tag.startsWith('年代')) return 'tag-era'
  if (tag.startsWith('状态')) return 'tag-status'
  return 'tag-default'
}

const useExample = (value, strictMode) => {
  question.value = value
  matchAll.value = !!strictMode
  runQuery()
}

const runQuery = async () => {
  if (!question.value.trim()) {
    ElMessage.warning(t('ai.inputQuery'))
    return
  }
  loading.value = true
  searched.value = true
  try {
    const res = await queryRelicAiApi(question.value, matchAll.value)
    result.answer = res.data.answer || ''
    result.total = res.data.total || 0
    result.topReason = res.data.topReason || ''
    result.museumHit = typeof res.data.museumHit === 'boolean' ? res.data.museumHit : null
    result.museumMessage = res.data.museumMessage || ''
    result.relics = res.data.relics || []
    result.webResults = res.data.webResults || []
    if (result.museumHit === false) {
      result.topReason = ''
    }
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.ai-page {
  border-radius: 18px;
}

.page-head h2 {
  margin: 0 0 8px;
  color: #2f241b;
  font-size: 26px;
}

.page-head p {
  margin: 0;
  color: #7c6b59;
}

.hero-panel {
  display: grid;
  grid-template-columns: 1.1fr 1fr;
  gap: 18px;
  padding: 22px;
  border-radius: 22px;
  background:
    radial-gradient(circle at top left, rgba(214, 170, 112, 0.26), transparent 32%),
    linear-gradient(135deg, #241912 0%, #3c281d 48%, #7b4b29 100%);
  color: #fff8ef;
}

.hero-badge {
  display: inline-flex;
  padding: 5px 10px;
  border-radius: 999px;
  background: rgba(255, 255, 255, 0.14);
  letter-spacing: 0.08em;
  font-size: 12px;
  text-transform: uppercase;
}

.hero-copy h3 {
  margin: 14px 0 10px;
  font-size: 30px;
  line-height: 1.25;
}

.hero-copy p {
  margin: 0;
  color: rgba(255, 248, 239, 0.78);
  line-height: 1.8;
}

.hero-search {
  padding: 16px;
  border-radius: 18px;
  background: rgba(255, 252, 247, 0.92);
}

.search-options {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-top: 12px;
  color: #6a5039;
}

.option-text {
  font-size: 13px;
}

.hero-actions {
  margin-top: 12px;
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.quick-prompts {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
  margin: 18px 0;
}

.prompt-chip {
  border: none;
  background: #f3e6d4;
  color: #6a4d33;
  padding: 10px 14px;
  border-radius: 999px;
  cursor: pointer;
  transition: transform 0.15s ease, background 0.15s ease;
}

.prompt-chip:hover {
  background: #ead3b6;
  transform: translateY(-1px);
}

.answer-panel,
.museum-panel,
.top-reason-panel,
.result-panel,
.web-panel,
.empty-panel {
  margin-top: 18px;
  padding: 18px;
  border-radius: 18px;
  background: #fffaf3;
  border: 1px solid #efdfcb;
}

.answer-title,
.top-reason-title,
.result-head h3 {
  color: #3d2a1d;
  margin: 0;
}

.answer-content,
.top-reason-content {
  margin-top: 10px;
  color: #634a36;
  line-height: 1.8;
}

.top-reason-panel {
  background: linear-gradient(135deg, #fff7eb, #f7ead5);
  border-color: #e7cfae;
}

.museum-hit {
  background: linear-gradient(135deg, #eef8f0, #e3f1e6);
  border-color: #bdd8c2;
}

.museum-miss {
  background: linear-gradient(135deg, #fff6ea, #f7eadf);
  border-color: #e5ccb0;
}

.museum-title {
  color: #3d2a1d;
  font-weight: 700;
}

.museum-content {
  margin-top: 10px;
  color: #634a36;
  line-height: 1.8;
}

.result-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 14px;
  color: #89684b;
}

.result-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
  gap: 16px;
}

.relic-card {
  position: relative;
  padding: 16px;
  border-radius: 18px;
  background: linear-gradient(180deg, #fffdf9, #fbf2e5);
  border: 1px solid #ecd9bf;
}

.rank-badge {
  position: absolute;
  top: 14px;
  right: 14px;
  padding: 4px 10px;
  border-radius: 999px;
  background: #7d4f2b;
  color: #fff7ed;
  font-size: 12px;
}

.relevance-chip {
  display: inline-flex;
  align-items: baseline;
  gap: 6px;
  margin-bottom: 14px;
  padding: 7px 12px;
  border-radius: 999px;
  background: linear-gradient(135deg, #3f2919, #8f5e35);
  color: #fff7ed;
}

.relevance-chip span {
  font-size: 12px;
  opacity: 0.82;
}

.relevance-chip strong {
  font-size: 18px;
}

.relic-top {
  display: flex;
  gap: 14px;
}

.relic-image {
  width: 108px;
  height: 108px;
  border-radius: 16px;
  overflow: hidden;
  flex-shrink: 0;
  background: #f3e4d0;
}

.relic-image-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  color: #97775b;
  font-size: 13px;
}

.relic-main {
  flex: 1;
}

.relic-title-row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
}

.relic-title-row h4 {
  margin: 0;
  font-size: 20px;
  color: #2e2117;
}

.relic-id {
  color: #8a6b4f;
  font-size: 12px;
}

.meta-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 10px;
  margin-top: 12px;
}

.meta-grid div {
  display: flex;
  flex-direction: column;
  gap: 4px;
  padding: 10px;
  border-radius: 12px;
  background: rgba(125, 81, 42, 0.06);
}

.meta-grid label {
  font-size: 12px;
  color: #8b6d51;
}

.meta-grid span {
  color: #4b3526;
}

.tag-section {
  margin-top: 14px;
}

.tag-section strong {
  display: block;
  margin-bottom: 8px;
  color: #5a3e28;
}

.tag-list {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.match-tag {
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 12px;
  border: 1px solid transparent;
}

.tag-name {
  background: #7a3428;
  color: #fff2ed;
  border-color: #9a4a3b;
}

.tag-era {
  background: #cda349;
  color: #3d2b08;
  border-color: #d9b96f;
}

.tag-status {
  background: #2f7a45;
  color: #eefcf1;
  border-color: #4d9862;
}

.tag-default {
  background: #efe1cd;
  color: #6c5037;
  border-color: #e2cfb4;
}

.content-block {
  margin-top: 14px;
}

.content-block strong {
  display: block;
  margin-bottom: 6px;
  color: #5a3e28;
}

.content-block p {
  margin: 0;
  line-height: 1.8;
  color: #654b37;
}

.web-list {
  display: grid;
  gap: 12px;
}

.web-card {
  display: block;
  padding: 14px 16px;
  border-radius: 14px;
  background: #fffdf9;
  border: 1px solid #ecd9bf;
  text-decoration: none;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
}

.web-card:hover {
  transform: translateY(-1px);
  box-shadow: 0 10px 24px rgba(113, 76, 38, 0.08);
}

.web-source {
  color: #a17952;
  font-size: 12px;
}

.web-title {
  margin-top: 6px;
  color: #3e2b1e;
  font-weight: 700;
}

.web-summary {
  margin-top: 6px;
  color: #6a5039;
  line-height: 1.7;
}

.source-link {
  color: #8a5b2f;
  word-break: break-all;
}

.source-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}

.source-type-badge,
.source-type-inline {
  display: inline-flex;
  align-items: center;
  padding: 2px 8px;
  border-radius: 999px;
  background: #efe1ca;
  color: #7a4f27;
  font-size: 12px;
  font-weight: 600;
}

.source-link:hover {
  text-decoration: underline;
}

.intro-block {
  padding-top: 12px;
  border-top: 1px dashed #e7cfb1;
}

.empty-panel {
  text-align: center;
  color: #7d6248;
}

:deep(.el-textarea__inner),
:deep(.el-input__wrapper) {
  box-shadow: 0 0 0 1px #e5d2b9 inset;
}

:deep(.el-textarea__inner:focus),
:deep(.el-input__wrapper.is-focus) {
  box-shadow: 0 0 0 1px #8a5b2f inset;
}

@media (max-width: 960px) {
  .hero-panel {
    grid-template-columns: 1fr;
  }
}
</style>
