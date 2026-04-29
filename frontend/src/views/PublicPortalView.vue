<template>
  <div class="public-portal">
    <!-- 顶部导航栏 -->
    <header class="portal-header">
      <div class="header-container">
        <div class="logo-section">
          <h1>🏛️ {{ t('systemTitle') }}</h1>
          <p class="subtitle">{{ t('systemSubtitle') }}</p>
          <div class="user-info-below">
            <el-icon><User /></el-icon>
            <span class="username-link" @click="goToProfile">{{ userName }}</span>
          </div>
        </div>
        <div class="header-right">
          <!-- 通知铃铛 -->
          <NotificationBell />
          <!-- 暗黑模式切换 -->
          <DarkModeToggle />
          <!-- 主题切换 -->
          <ThemeSwitcher />
          <!-- 语言切换 -->
          <LanguageSwitcher />
          <el-button type="danger" size="small" @click="handleLogout">
            <el-icon><SwitchButton /></el-icon>
            {{ t('logout') }}
          </el-button>
        </div>
        <nav class="nav-menu">
          <a href="#home" @click.prevent="activeSection = 'home'" :class="{ active: activeSection === 'home' }">
            <el-icon><HomeFilled /></el-icon>
            {{ t('navHome') }}
          </a>
          <a href="#data-screen" @click.prevent="activeSection = 'data-screen'" :class="{ active: activeSection === 'data-screen' }">
            <el-icon><DataAnalysis /></el-icon>
            {{ t('navDataScreen') }}
          </a>
          <a href="#reports" @click.prevent="activeSection = 'reports'" :class="{ active: activeSection === 'reports' }">
            <el-icon><Document /></el-icon>
            {{ t('navReports') }}
          </a>
          <a href="#relics" @click.prevent="activeSection = 'relics'" :class="{ active: activeSection === 'relics' }">
            <el-icon><Box /></el-icon>
            {{ t('navRelics') }}
          </a>
          <a href="#categories" @click.prevent="activeSection = 'categories'" :class="{ active: activeSection === 'categories' }">
            <el-icon><Grid /></el-icon>
            {{ t('navCategories') }}
          </a>
          <a href="#loan" @click.prevent="activeSection = 'loan'" :class="{ active: activeSection === 'loan' }">
            <el-icon><Promotion /></el-icon>
            {{ t('navLoan') }}
          </a>
          <a href="#my-loans" @click.prevent="activeSection = 'my-loans'" :class="{ active: activeSection === 'my-loans' }">
            <el-icon><List /></el-icon>
            {{ t('navMyLoans') }}
          </a>
          <a href="#ai" @click.prevent="activeSection = 'ai'" :class="{ active: activeSection === 'ai' }">
            <el-icon><Search /></el-icon>
            {{ t('navAi') }}
          </a>
        </nav>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="portal-main">
      <!-- 首页 -->
      <section v-show="activeSection === 'home'" class="section-home">
        <div class="hero-banner">
          <h2>{{ t('heroTitle') }}</h2>
          <p>{{ t('heroSubtitle') }}</p>
          <div class="hero-actions">
            <el-button type="primary" size="large" @click="activeSection = 'relics'">
              <el-icon><Search /></el-icon>
              {{ t('startExplore') }}
            </el-button>
            <el-button size="large" @click="activeSection = 'loan'">
              <el-icon><Promotion /></el-icon>
              {{ t('applyLoan') }}
            </el-button>
          </div>
        </div>

        <div class="feature-cards">
          <div class="feature-card" @click="activeSection = 'data-screen'">
            <el-icon class="feature-icon"><DataAnalysis /></el-icon>
            <h3>{{ t('featureDataScreen') }}</h3>
            <p>{{ t('featureDataScreenDesc') }}</p>
          </div>
          <div class="feature-card" @click="activeSection = 'relics'">
            <el-icon class="feature-icon"><Box /></el-icon>
            <h3>{{ t('featureRelics') }}</h3>
            <p>{{ t('featureRelicsDesc') }}</p>
          </div>
          <div class="feature-card" @click="activeSection = 'ai'">
            <el-icon class="feature-icon"><Search /></el-icon>
            <h3>{{ t('featureAi') }}</h3>
            <p>{{ t('featureAiDesc') }}</p>
          </div>
          <div class="feature-card" @click="activeSection = 'loan'">
            <el-icon class="feature-icon"><Promotion /></el-icon>
            <h3>{{ t('featureLoan') }}</h3>
            <p>{{ t('featureLoanDesc') }}</p>
          </div>
        </div>
      </section>

      <!-- 数据大屏 -->
      <section v-show="activeSection === 'data-screen'" class="section-data-screen">
        <h2 class="section-title">{{ t('navDataScreen') }}</h2>
        
        <div class="screen-content-portal">
          <!-- 核心指标 -->
          <div class="metrics-row-portal">
            <div class="metric-card-portal">
              <div class="metric-icon-portal">📦</div>
              <div class="metric-value-portal">{{ dashboardData.totalRelics || 0 }}</div>
              <div class="metric-label-portal">{{ locale === 'zh' ? '文物总数' : 'Total Relics' }}</div>
            </div>
            <div class="metric-card-portal">
              <div class="metric-icon-portal">🏛️</div>
              <div class="metric-value-portal">{{ dashboardData.inStockRelics || 0 }}</div>
              <div class="metric-label-portal">{{ locale === 'zh' ? '在库文物' : 'In Stock' }}</div>
            </div>
            <div class="metric-card-portal">
              <div class="metric-icon-portal">🚚</div>
              <div class="metric-value-portal">{{ dashboardData.loaningRelics || 0 }}</div>
              <div class="metric-label-portal">{{ locale === 'zh' ? '借出文物' : 'On Loan' }}</div>
            </div>
            <div class="metric-card-portal">
              <div class="metric-icon-portal">🔧</div>
              <div class="metric-value-portal">{{ dashboardData.repairingRelics || 0 }}</div>
              <div class="metric-label-portal">{{ locale === 'zh' ? '修复中' : 'Repairing' }}</div>
            </div>
          </div>

          <!-- 第一行图表：分类统计和年代分布 -->
          <div class="charts-row-top-portal">
            <div class="chart-card-portal chart-large-portal">
              <div class="chart-header-portal">
                <span class="chart-title-portal">{{ locale === 'zh' ? '分类统计' : 'Category Stats' }}</span>
              </div>
              <div ref="categoryChartPortalRef" class="chart-container-large-portal"></div>
            </div>
            <div class="chart-card-portal chart-large-portal">
              <div class="chart-header-portal">
                <span class="chart-title-portal">{{ locale === 'zh' ? '年代统计' : 'Era Stats' }}</span>
              </div>
              <div ref="eraChartPortalRef" class="chart-container-large-portal"></div>
            </div>
          </div>

          <!-- 第二行：状态分布和业务统计 -->
          <div class="charts-row-bottom-portal">
            <div class="chart-card-portal chart-status-portal">
              <div class="chart-header-portal">
                <span class="chart-title-portal">{{ locale === 'zh' ? '状态分布' : 'Status Distribution' }}</span>
              </div>
              <div ref="statusChartPortalRef" class="chart-container-status-portal"></div>
            </div>
            
            <div class="business-card-portal">
              <div class="business-title-portal">{{ locale === 'zh' ? '借展统计与修复统计' : 'Loan & Repair Stats' }}</div>
              <div class="business-stats-portal">
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '借展待审批' : 'Loan Pending' }}</span>
                  <span class="stat-value-portal warning">{{ loanStatsPortal.pending || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '借展中' : 'Loaning' }}</span>
                  <span class="stat-value-portal info">{{ loanStatsPortal.loaning || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '已归还' : 'Returned' }}</span>
                  <span class="stat-value-portal success">{{ loanStatsPortal.returned || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '借展已拒绝' : 'Loan Rejected' }}</span>
                  <span class="stat-value-portal danger">{{ loanStatsPortal.rejected || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '逾期' : 'Overdue' }}</span>
                  <span class="stat-value-portal danger">{{ loanStatsPortal.overdue || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '修复待审批' : 'Repair Pending' }}</span>
                  <span class="stat-value-portal warning">{{ repairStatsPortal.pending || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '待修复' : 'Waiting Repair' }}</span>
                  <span class="stat-value-portal warning">{{ repairStatsPortal.waitingRepair || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '修复中' : 'Repairing' }}</span>
                  <span class="stat-value-portal info">{{ repairStatsPortal.repairing || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '修复已完成' : 'Repair Completed' }}</span>
                  <span class="stat-value-portal success">{{ repairStatsPortal.completed || 0 }}</span>
                </div>
                <div class="stat-item-portal">
                  <span class="stat-label-portal">{{ locale === 'zh' ? '修复已拒绝' : 'Repair Rejected' }}</span>
                  <span class="stat-value-portal danger">{{ repairStatsPortal.rejected || 0 }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- 数据报表 -->
      <section v-show="activeSection === 'reports'" class="section-reports">
        <h2 class="section-title">{{ t('navReports') }}</h2>
        <div class="reports-container">
          <el-card class="report-card">
            <el-tabs v-model="activeReportTab" type="border-card">
              <!-- 年度报告 -->
              <el-tab-pane :label="locale === 'zh' ? '年度报告' : 'Annual Report'" name="annual">
                <div class="tab-content">
                  <div class="toolbar">
                    <el-select v-model="annualYear" style="width: 150px">
                      <el-option v-for="y in years" :key="y" :label="`${y}${locale === 'zh' ? '年' : ''}`" :value="y" />
                    </el-select>
                    <el-button type="primary" @click="loadAnnualReport">{{ locale === 'zh' ? '搜索' : 'Search' }}</el-button>
                  </div>
                  
                  <div v-if="annualData" class="report-content">
                    <div class="summary-cards">
                      <div class="summary-card">
                        <div class="card-label">{{ locale === 'zh' ? '年度借展' : 'Annual Loans' }}</div>
                        <div class="card-value">{{ annualData.annualLoans || 0 }}</div>
                      </div>
                      <div class="summary-card">
                        <div class="card-label">{{ locale === 'zh' ? '年度保养' : 'Annual Maintenance' }}</div>
                        <div class="card-value">{{ annualData.annualMaintenance || 0 }}</div>
                      </div>
                      <div class="summary-card">
                        <div class="card-label">{{ locale === 'zh' ? '年度修复' : 'Annual Repairs' }}</div>
                        <div class="card-value">{{ annualData.annualRepairs || 0 }}</div>
                      </div>
                      <div class="summary-card">
                        <div class="card-label">{{ locale === 'zh' ? '新增文物' : 'New Relics' }}</div>
                        <div class="card-value">{{ annualData.newRelicsCount || 0 }}</div>
                      </div>
                    </div>
                    
                    <div ref="annualChartRef" class="chart" style="height: 400px;"></div>
                  </div>
                </div>
              </el-tab-pane>

              <!-- 趋势分析 -->
              <el-tab-pane :label="locale === 'zh' ? '趋势分析' : 'Trend Analysis'" name="trend">
                <div class="tab-content">
                  <div class="toolbar">
                    <el-date-picker
                      v-model="trendDateRange"
                      type="daterange"
                      range-separator="-"
                      :start-placeholder="locale === 'zh' ? '开始日期' : 'Start Date'"
                      :end-placeholder="locale === 'zh' ? '结束日期' : 'End Date'"
                      value-format="YYYY-MM-DD"
                    />
                    <el-select v-model="trendType" style="width: 150px">
                      <el-option :label="locale === 'zh' ? '借展趋势' : 'Loan Trend'" value="loan" />
                      <el-option :label="locale === 'zh' ? '保养趋势' : 'Maintenance Trend'" value="maintenance" />
                      <el-option :label="locale === 'zh' ? '修复趋势' : 'Repair Trend'" value="repair" />
                      <el-option :label="locale === 'zh' ? '文物趋势' : 'Relic Trend'" value="relic" />
                    </el-select>
                    <el-button type="primary" @click="loadTrendAnalysis">{{ locale === 'zh' ? '分析' : 'Analyze' }}</el-button>
                  </div>
                  
                  <div ref="trendChartRef" class="chart" style="height: 450px;"></div>
                </div>
              </el-tab-pane>

              <!-- 对比分析 -->
              <el-tab-pane :label="locale === 'zh' ? '对比分析' : 'Comparison Analysis'" name="comparison">
                <div class="tab-content">
                  <div class="toolbar">
                    <el-select v-model="comparisonYear1" style="width: 150px">
                      <el-option v-for="y in years" :key="y" :label="`${y}${locale === 'zh' ? '年' : ''}`" :value="y" />
                    </el-select>
                    <span style="margin: 0 10px;">vs</span>
                    <el-select v-model="comparisonYear2" style="width: 150px">
                      <el-option v-for="y in years" :key="y" :label="`${y}${locale === 'zh' ? '年' : ''}`" :value="y" />
                    </el-select>
                    <el-button type="primary" @click="loadComparisonAnalysis">{{ locale === 'zh' ? '对比' : 'Compare' }}</el-button>
                  </div>
                  
                  <div v-if="comparisonData" class="comparison-content">
                    <div ref="comparisonChartRef" class="chart" style="height: 400px;"></div>
                    
                    <div class="growth-rate">
                      <h3>{{ locale === 'zh' ? '同比增长率' : 'Year-over-Year Growth' }}</h3>
                      <el-table :data="growthRateData" border>
                        <el-table-column prop="type" :label="locale === 'zh' ? '类型' : 'Type'" />
                        <el-table-column prop="year1" :label="`${comparisonYear1}${locale === 'zh' ? '年' : ''}`" />
                        <el-table-column prop="year2" :label="`${comparisonYear2}${locale === 'zh' ? '年' : ''}`" />
                        <el-table-column prop="rate" :label="locale === 'zh' ? '增长率' : 'Growth Rate'">
                          <template #default="scope">
                            <span :class="scope.row.rate >= 0 ? 'positive' : 'negative'">
                              {{ scope.row.rate >= 0 ? '+' : '' }}{{ scope.row.rate.toFixed(2) }}%
                            </span>
                          </template>
                        </el-table-column>
                      </el-table>
                    </div>
                  </div>
                </div>
              </el-tab-pane>
            </el-tabs>
          </el-card>
        </div>
      </section>

      <!-- 文物搜索 -->
      <section v-show="activeSection === 'relics'" class="section-relics">
        <h2 class="section-title">{{ t('navRelics') }}</h2>
        <div class="search-bar">
          <el-input
            v-model="relicQuery.relicName"
            :placeholder="t('searchPlaceholder')"
            clearable
            style="width: 300px"
          >
            <template #prefix>
              <el-icon><Search /></el-icon>
            </template>
          </el-input>
          <el-select v-model="relicQuery.categoryId" :placeholder="t('selectCategory')" clearable style="width: 200px">
            <el-option
              v-for="cat in categoryList"
              :key="cat.id"
              :label="cat.categoryName"
              :value="cat.id"
            />
          </el-select>
          <el-select v-model="relicQuery.era" :placeholder="t('selectEra')" clearable style="width: 200px">
            <el-option label="商周" value="商周" />
            <el-option label="秦汉" value="秦汉" />
            <el-option label="唐宋" value="唐宋" />
            <el-option label="明清" value="明清" />
          </el-select>
          <el-button type="primary" @click="searchRelics">
            <el-icon><Search /></el-icon>
            {{ t('searchBtn') }}
          </el-button>
        </div>

        <div class="relics-grid">
          <div v-for="relic in relicList" :key="relic.id" class="relic-card" @click="viewRelicDetail(relic)">
            <div class="relic-image">
              <img :src="resolveImageUrl(relic.imagePath)" :alt="relic.relicName" />
            </div>
            <div class="relic-info">
              <h3>{{ relic.relicName }}</h3>
              <p class="relic-era">{{ relic.era }}</p>
              <p class="relic-category">{{ relic.categoryName }}</p>
              <el-tag :type="relic.status === '在库' ? 'success' : 'warning'" size="small">
                {{ relic.status === '在库' ? t('inStockStatus') : t('loaningStatus') }}
              </el-tag>
            </div>
          </div>
        </div>

        <el-pagination
          v-if="relicTotal > 0"
          class="pagination"
          background
          layout="total, prev, pager, next"
          :total="relicTotal"
          :page-size="relicQuery.pageSize"
          :current-page="relicQuery.pageNum"
          @current-change="handleRelicPageChange"
        />
      </section>

      <!-- 分类搜索 -->
      <section v-show="activeSection === 'categories'" class="section-categories">
        <h2 class="section-title">{{ t('navCategories') }}</h2>
        <div class="categories-intro">
          <p>{{ locale === 'zh' ? '探索我们丰富的文物收藏，按分类浏览不同时期的珍贵文物' : 'Explore our rich collection of cultural relics by category' }}</p>
        </div>
        <div class="categories-grid">
          <div
            v-for="(category, index) in categoryList"
            :key="category.id"
            class="category-card"
            :class="`category-card-${index % 6}`"
            @click="viewCategoryRelics(category)"
          >
            <div class="category-card-inner">
              <div class="category-icon-wrapper">
                <div class="category-icon">{{ getCategoryIcon(category.categoryName) }}</div>
                <div class="category-badge">{{ category.relicCount || 0 }}</div>
              </div>
              <h3>{{ category.categoryName }}</h3>
              <p class="category-desc">{{ category.description || t('noDescription') }}</p>
              <div class="category-divider"></div>
              <div class="category-action">
                <el-button type="primary" size="small" round>
                  <el-icon><View /></el-icon>
                  {{ t('viewRelics') }}
                </el-button>
              </div>
            </div>
            <div class="category-overlay"></div>
          </div>
        </div>
      </section>

      <!-- 申请借展 -->
      <section v-show="activeSection === 'loan'" class="section-loan">
        <h2 class="section-title">{{ t('navLoan') }}</h2>
        <el-card class="loan-form-card">
          <el-form ref="loanFormRef" :model="loanForm" :rules="loanRules" label-width="120px">
            <el-form-item :label="t('relicName')" prop="relicId">
              <el-select v-model="loanForm.relicId" :placeholder="t('selectRelic')" filterable style="width: 100%">
                <el-option
                  v-for="relic in availableRelics"
                  :key="relic.id"
                  :label="relic.relicName"
                  :value="relic.id"
                />
              </el-select>
            </el-form-item>
            <el-form-item :label="t('borrowerUnit')" prop="borrowerUnit">
              <el-input v-model="loanForm.borrowerUnit" :placeholder="t('borrowerUnit')" disabled />
            </el-form-item>
            <el-form-item :label="t('borrowerName')" prop="borrowerName">
              <el-input v-model="loanForm.borrowerName" disabled />
            </el-form-item>
            <el-form-item :label="t('borrowerPhone')" prop="borrowerPhone">
              <el-input v-model="loanForm.borrowerPhone" disabled />
            </el-form-item>
            <el-form-item :label="t('loanDate')" prop="loanDate">
              <el-date-picker
                v-model="loanForm.loanDate"
                type="datetime"
                :placeholder="t('loanDate')"
                value-format="YYYY-MM-DD HH:mm:ss"
                disabled
                style="width: 100%"
              />
            </el-form-item>
            <el-form-item :label="t('expectedReturnDate')" prop="expectedReturnDate">
              <el-date-picker
                v-model="loanForm.expectedReturnDate"
                type="datetime"
                :placeholder="t('expectedReturnDate')"
                value-format="YYYY-MM-DD HH:mm:ss"
                :disabled-date="disabledReturnDate"
                style="width: 100%"
              />
            </el-form-item>
            <el-form-item :label="t('purpose')" prop="purpose">
              <el-input
                v-model="loanForm.purpose"
                type="textarea"
                :rows="4"
                :placeholder="t('purpose')"
              />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="submitLoanApplication">{{ t('submit') }}</el-button>
              <el-button @click="resetLoanForm">{{ t('reset') }}</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </section>

      <!-- 我的借展 -->
      <section v-show="activeSection === 'my-loans'" class="section-my-loans">
        <h2 class="section-title">{{ t('navMyLoans') }}</h2>
        
        <!-- 统计卡片 -->
        <div class="my-loans-stats">
          <div class="stat-card-my-loans">
            <div class="stat-icon-my-loans" style="background: linear-gradient(135deg, #409eff 0%, #1890ff 100%)">
              <el-icon><Clock /></el-icon>
            </div>
            <div class="stat-content-my-loans">
              <div class="stat-value-my-loans">{{ myLoansStats.loaning }}</div>
              <div class="stat-label-my-loans">{{ locale === 'zh' ? '借展中' : 'On Loan' }}</div>
            </div>
          </div>
          <div class="stat-card-my-loans">
            <div class="stat-icon-my-loans" style="background: linear-gradient(135deg, #67c23a 0%, #52c41a 100%)">
              <el-icon><Check /></el-icon>
            </div>
            <div class="stat-content-my-loans">
              <div class="stat-value-my-loans">{{ myLoansStats.returned }}</div>
              <div class="stat-label-my-loans">{{ locale === 'zh' ? '已归还' : 'Returned' }}</div>
            </div>
          </div>
          <div class="stat-card-my-loans">
            <div class="stat-icon-my-loans" style="background: linear-gradient(135deg, #f56c6c 0%, #f5222d 100%)">
              <el-icon><Warning /></el-icon>
            </div>
            <div class="stat-content-my-loans">
              <div class="stat-value-my-loans">{{ myLoansStats.overdue }}</div>
              <div class="stat-label-my-loans">{{ locale === 'zh' ? '已逾期' : 'Overdue' }}</div>
            </div>
          </div>
          <div class="stat-card-my-loans">
            <div class="stat-icon-my-loans" style="background: linear-gradient(135deg, #e6a23c 0%, #faad14 100%)">
              <el-icon><Document /></el-icon>
            </div>
            <div class="stat-content-my-loans">
              <div class="stat-value-my-loans">{{ myLoansStats.pending }}</div>
              <div class="stat-label-my-loans">{{ locale === 'zh' ? '待审批' : 'Pending' }}</div>
            </div>
          </div>
        </div>

        <!-- 筛选栏 -->
        <div class="my-loans-filter">
          <el-select v-model="myLoansQuery.status" :placeholder="locale === 'zh' ? '按状态筛选' : 'Filter by status'" clearable style="width: 160px">
            <el-option :label="locale === 'zh' ? '待审批' : 'Pending'" value="待审批" />
            <el-option :label="locale === 'zh' ? '借展中' : 'On Loan'" value="借展中" />
            <el-option :label="locale === 'zh' ? '已归还' : 'Returned'" value="已归还" />
            <el-option :label="locale === 'zh' ? '已驳回' : 'Rejected'" value="已驳回" />
            <el-option :label="locale === 'zh' ? '逾期' : 'Overdue'" value="逾期" />
          </el-select>
          <el-button type="primary" @click="loadMyLoans">
            <el-icon><Search /></el-icon>
            {{ locale === 'zh' ? '搜索' : 'Search' }}
          </el-button>
          <el-button type="primary" @click="loadMyLoans">
            <el-icon><Refresh /></el-icon>
            {{ locale === 'zh' ? '刷新' : 'Refresh' }}
          </el-button>
        </div>

        <!-- 借展记录列表 -->
        <div v-loading="myLoansLoading" class="my-loans-list">
          <el-empty v-if="!myLoansLoading && myLoansList.length === 0" :description="locale === 'zh' ? '暂无借展记录' : 'No loan records'" />
          
          <div v-for="loan in myLoansList" :key="loan.id" class="my-loan-item">
            <div class="my-loan-header">
              <div class="my-loan-title">
                <el-tag :type="getMyLoanStatusType(loan.status)" size="large">
                  {{ loan.status }}
                </el-tag>
                <span class="my-loan-relic-name">{{ loan.relicName }}</span>
              </div>
              <div class="my-loan-actions">
                <el-button 
                  v-if="loan.status === '借展中' || loan.status === '逾期'" 
                  type="success" 
                  size="small"
                  @click="handleMyLoanReturn(loan)"
                >
                  <el-icon><Check /></el-icon>
                  {{ locale === 'zh' ? '主动归还' : 'Return' }}
                </el-button>
              </div>
            </div>

            <div class="my-loan-body">
              <div class="my-loan-info-grid">
                <div class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '文物编号：' : 'Relic Code:' }}</span>
                  <span class="my-loan-info-value">{{ loan.relicCode }}</span>
                </div>
                <div class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '借展单位：' : 'Unit:' }}</span>
                  <span class="my-loan-info-value">{{ loan.borrowerUnit }}</span>
                </div>
                <div class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '联系电话：' : 'Phone:' }}</span>
                  <span class="my-loan-info-value">{{ loan.borrowerPhone }}</span>
                </div>
                <div class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '借展用途：' : 'Purpose:' }}</span>
                  <span class="my-loan-info-value">{{ loan.purpose || '—' }}</span>
                </div>
                <div class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '借展日期：' : 'Loan Date:' }}</span>
                  <span class="my-loan-info-value">{{ formatMyLoanDateTime(loan.loanDate) }}</span>
                </div>
                <div class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '预计归还：' : 'Expected Return:' }}</span>
                  <span class="my-loan-info-value" :class="{ 'my-loan-overdue-text': isMyLoanOverdue(loan) }">
                    {{ formatMyLoanDateTime(loan.expectedReturnDate) }}
                    <el-tag v-if="isMyLoanOverdue(loan)" type="danger" size="small" style="margin-left: 8px">
                      {{ locale === 'zh' ? `已逾期 ${getMyLoanOverdueDays(loan)} 天` : `Overdue ${getMyLoanOverdueDays(loan)} days` }}
                    </el-tag>
                  </span>
                </div>
                <div v-if="loan.actualReturnDate" class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '实际归还：' : 'Actual Return:' }}</span>
                  <span class="my-loan-info-value">{{ formatMyLoanDateTime(loan.actualReturnDate) }}</span>
                </div>
                <div v-if="loan.approverName" class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '审批人：' : 'Approver:' }}</span>
                  <span class="my-loan-info-value">{{ loan.approverName }}</span>
                </div>
                <div v-if="loan.approveTime" class="my-loan-info-item">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '审批时间：' : 'Approve Time:' }}</span>
                  <span class="my-loan-info-value">{{ formatMyLoanDateTime(loan.approveTime) }}</span>
                </div>
                <div v-if="loan.approveRemark" class="my-loan-info-item my-loan-full-width">
                  <span class="my-loan-info-label">{{ locale === 'zh' ? '审批意见：' : 'Remark:' }}</span>
                  <span class="my-loan-info-value">{{ loan.approveRemark }}</span>
                </div>
              </div>
            </div>

            <div class="my-loan-footer">
              <span class="my-loan-create-time">{{ locale === 'zh' ? '申请时间：' : 'Applied:' }}{{ formatMyLoanDateTime(loan.createTime) }}</span>
            </div>
          </div>
        </div>

        <!-- 分页 -->
        <div v-if="myLoansTotal > 0" class="my-loans-pagination">
          <el-pagination
            v-model:current-page="myLoansQuery.pageNum"
            v-model:page-size="myLoansQuery.pageSize"
            :total="myLoansTotal"
            :page-sizes="[10, 20, 50]"
            layout="total, sizes, prev, pager, next, jumper"
            @size-change="loadMyLoans"
            @current-change="loadMyLoans"
          />
        </div>
      </section>

      <!-- AI搜索 - ChatGPT风格布局 -->
      <section v-show="activeSection === 'ai'" class="section-ai">
        <div class="ai-container">
          <!-- 左侧：历史会话列表 -->
          <div class="ai-sidebar">
            <div class="sidebar-header">
              <div class="sidebar-logo">
                <div class="logo-icon">🤖</div>
                <span class="logo-text">{{ t('chatHistory') }}</span>
              </div>
              <el-button class="new-chat-btn" type="primary" size="small" circle @click="createNewSession">
                <el-icon><Plus /></el-icon>
              </el-button>
            </div>
            <div class="sidebar-content" v-loading="sessionsLoading">
              <div v-if="sessionList.length === 0" class="empty-sessions">
                <div class="empty-icon">💬</div>
                <p class="empty-text">{{ t('noHistory') }}</p>
                <p class="empty-hint">{{ locale === 'zh' ? '开始新对话探索文物世界' : 'Start a new chat to explore' }}</p>
              </div>
              <div class="sessions-list">
                <div
                  v-for="session in sessionList"
                  :key="session.id"
                  class="session-item"
                  :class="{ active: currentSessionId === session.id }"
                  @click="switchSession(session)"
                >
                  <div class="session-icon">
                    <el-icon><ChatDotRound /></el-icon>
                  </div>
                  <div class="session-info">
                    <div class="session-title">{{ session.sessionTitle }}</div>
                    <div class="session-time">{{ formatSessionTime(session.updateTime) }}</div>
                  </div>
                  <div class="session-actions">
                    <el-button
                      class="delete-btn"
                      type="danger"
                      size="small"
                      text
                      circle
                      @click.stop="deleteSession(session.id)"
                    >
                      <el-icon><Delete /></el-icon>
                    </el-button>
                  </div>
                </div>
              </div>
            </div>
            <div class="sidebar-footer">
              <div class="user-profile">
                <div class="profile-avatar">
                  <el-icon><User /></el-icon>
                </div>
                <div class="profile-info">
                  <div class="profile-name">{{ userName }}</div>
                  <div class="profile-status">{{ locale === 'zh' ? '在线' : 'Online' }}</div>
                </div>
              </div>
            </div>
          </div>

          <!-- 右侧：对话区域 -->
          <div class="ai-chat-box">
            <div class="chat-messages" ref="chatMessages">
              <!-- 欢迎消息 -->
              <div v-if="chatHistory.length === 0" class="welcome-message">
                <div class="welcome-icon">🤖</div>
                <h3>{{ t('aiWelcome') }}</h3>
                <p>{{ t('aiWelcomeDesc') }}</p>
                <div class="example-queries">
                  <el-tag @click="aiQuery = locale === 'zh' ? '司母戊鼎' : 'Tell me about Tang Dynasty relics'">
                    {{ locale === 'zh' ? '司母戊鼎' : 'Tang Dynasty relics' }}
                  </el-tag>
                  <el-tag @click="aiQuery = locale === 'zh' ? '汝窑天青釉盏' : 'Four-goat Square Zun'">
                    {{ locale === 'zh' ? '汝窑天青釉盏' : 'Four-goat Square Zun' }}
                  </el-tag>
                  <el-tag @click="aiQuery = locale === 'zh' ? '清明上河图' : 'What bronze wares are there'">
                    {{ locale === 'zh' ? '清明上河图' : 'Bronze wares' }}
                  </el-tag>
                  <el-tag @click="aiQuery = locale === 'zh' ? '兵马俑' : 'Terracotta Warriors'">
                    {{ locale === 'zh' ? '兵马俑' : 'Terracotta Warriors' }}
                  </el-tag>
                </div>
              </div>

              <!-- 对话历史 -->
              <div v-for="(msg, index) in chatHistory" :key="index" class="message-group">
                <!-- 用户消息 -->
                <div class="message user-message">
                  <div class="message-avatar">
                    <el-icon><User /></el-icon>
                  </div>
                  <div class="message-content">
                    <div class="message-text">{{ msg.question }}</div>
                    <div class="message-time">{{ msg.time }}</div>
                  </div>
                </div>

                <!-- AI回复 -->
                <div class="message ai-message">
                  <div class="message-avatar ai-avatar">
                    <el-icon><ChatDotRound /></el-icon>
                  </div>
                  <div class="message-content">
                    <!-- 文字回答 -->
                    <div class="message-text">{{ msg.response.answer }}</div>
                    
                    <!-- 文物卡片 -->
                    <div v-if="msg.response.relics && msg.response.relics.length > 0" class="message-relics">
                      <div
                        v-for="relic in msg.response.relics"
                        :key="relic.id"
                        class="relic-card-mini"
                        :class="{ 'external-relic': relic.external }"
                      >
                        <!-- 卡片头部 -->
                        <div class="relic-card-header">
                          <div class="relic-card-title">
                            <h4>{{ relic.relicName }}</h4>
                            <el-tag v-if="relic.external" type="warning" size="small">
                              {{ relic.sourceType }}
                            </el-tag>
                            <el-tag v-else type="success" size="small">{{ t('collectionTag') }}</el-tag>
                          </div>
                          <el-button
                            v-if="!relic.external"
                            type="primary"
                            size="small"
                            link
                            @click="viewRelicDetailFromAi(relic)"
                          >
                            {{ t('viewDetail') }}
                          </el-button>
                        </div>

                        <!-- 卡片内容 -->
                        <div class="relic-card-body">
                          <!-- 图片 -->
                          <div v-if="relic.imagePath" class="relic-card-image">
                            <img 
                              :src="resolveImageUrl(relic.imagePath)" 
                              :alt="relic.relicName"
                              @error="(e) => { console.error('图片加载失败:', relic.imagePath, e); e.target.src = 'https://via.placeholder.com/300x200?text=Image+Error' }"
                              @load="() => console.log('图片加载成功:', relic.imagePath)"
                            />
                          </div>
                          <div v-else class="relic-card-image">
                            <img src="https://via.placeholder.com/300x200?text=No+Image" :alt="relic.relicName" />
                          </div>

                          <!-- 信息 -->
                          <div class="relic-card-info">
                            <div class="info-item" v-if="relic.era">
                              <span class="label">{{ t('era') }}</span>
                              <span class="value">{{ relic.era }}</span>
                            </div>
                            <div class="info-item" v-if="relic.material">
                              <span class="label">{{ t('material') }}</span>
                              <span class="value">{{ relic.material }}</span>
                            </div>
                            <div class="info-item" v-if="relic.categoryName">
                              <span class="label">{{ t('category') }}</span>
                              <span class="value">{{ relic.categoryName }}</span>
                            </div>
                            <div class="info-item" v-if="relic.status">
                              <span class="label">{{ t('status') }}</span>
                              <span class="value">{{ relic.status === '在库' ? t('inStockStatus') : t('loaningStatus') }}</span>
                            </div>
                          </div>
                        </div>

                        <!-- 描述 -->
                        <div class="relic-card-description">
                          {{ relic.description || relic.introduction }}
                        </div>

                        <!-- 相关度或外部链接 -->
                        <div class="relic-card-footer">
                          <div v-if="!relic.external && relic.relevancePercent" class="relevance-bar">
                            <span>{{ t('relevance') }} {{ relic.relevancePercent }}%</span>
                            <div class="progress-bar">
                              <div
                                class="progress-fill"
                                :style="{ width: relic.relevancePercent + '%', background: getRelevanceColor(relic.relevancePercent) }"
                              ></div>
                            </div>
                          </div>
                          <div v-if="relic.external" class="external-info">
                            <el-tag type="warning" size="small">
                              <el-icon><Warning /></el-icon>
                              {{ t('externalWarning') }}
                            </el-tag>
                            <el-button
                              v-if="relic.sourceUrl"
                              type="primary"
                              size="small"
                              link
                              @click="openExternalLink(relic.sourceUrl)"
                            >
                              <el-icon><Link /></el-icon>
                              {{ t('visit') }}{{ relic.sourceName }}
                            </el-button>
                          </div>
                        </div>
                      </div>
                    </div>

                    <div class="message-time">{{ msg.time }}</div>
                  </div>
                </div>
              </div>

              <!-- 加载中 -->
              <div v-if="aiLoading" class="message ai-message">
                <div class="message-avatar ai-avatar">
                  <el-icon><ChatDotRound /></el-icon>
                </div>
                <div class="message-content">
                  <div class="message-text typing">
                    <el-icon class="is-loading"><Loading /></el-icon>
                    {{ t('thinking') }}
                  </div>
                </div>
              </div>
            </div>

            <!-- 输入区域 -->
            <div class="chat-input">
              <div class="chat-input-container">
                <div class="input-wrapper">
                  <el-input
                    v-model="aiQuery"
                    :placeholder="t('aiInputPlaceholder')"
                    @keyup.enter="sendAiQuery"
                    size="large"
                    class="chat-textarea"
                    type="textarea"
                    :rows="1"
                    :autosize="{ minRows: 1, maxRows: 4 }"
                  />
                </div>
                <el-button 
                  class="send-button" 
                  type="primary" 
                  @click="sendAiQuery" 
                  :loading="aiLoading" 
                  :disabled="!aiQuery.trim()"
                  circle
                  size="large"
                >
                  <el-icon :size="20"><Promotion /></el-icon>
                </el-button>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- 文物详情对话框 - 增强版 -->
    <el-dialog 
      v-model="relicDetailVisible" 
      :title="t('relicDetail')" 
      width="1000px"
      class="detail-dialog"
      :close-on-click-modal="false"
    >
      <div v-if="currentRelic" class="detail-container">
        <!-- 左侧：图片轮播 -->
        <div class="detail-left">
          <el-carousel 
            v-if="detailImages.length > 0" 
            height="400px" 
            indicator-position="outside"
            class="detail-carousel"
            :autoplay="detailImages.length > 1"
          >
            <el-carousel-item v-for="(img, index) in detailImages" :key="index">
              <el-image
                :src="img"
                fit="contain"
                class="carousel-image"
                :preview-src-list="detailImages"
                :initial-index="index"
                preview-teleported
                :z-index="3000"
              />
            </el-carousel-item>
          </el-carousel>
          <div v-else class="no-image-placeholder">
            <el-icon :size="80"><Box /></el-icon>
            <p>{{ t('noImage') }}</p>
          </div>
          
          <!-- 操作按钮 -->
          <div class="detail-actions">
            <el-button type="primary" @click="handleShare">
              <el-icon><Link /></el-icon>
              {{ t('share') }}
            </el-button>
            <el-button type="success" @click="handlePrintDetail">
              <el-icon><Document /></el-icon>
              {{ t('print') }}
            </el-button>
            <el-button 
              v-if="currentRelic.model3dUrl" 
              type="warning" 
              @click="view3DModel(currentRelic)"
            >
              <el-icon><View /></el-icon>
              {{ t('view3DModel') }}
            </el-button>
          </div>
        </div>

        <!-- 右侧：详细信息 -->
        <div class="detail-right">
          <!-- 基本信息 -->
          <div class="detail-section">
            <h3 class="section-title">{{ t('basicInfo') }}</h3>
            <el-descriptions :column="2" border>
              <el-descriptions-item :label="t('relicCode')">{{ currentRelic.relicCode }}</el-descriptions-item>
              <el-descriptions-item :label="t('relicName')">{{ currentRelic.relicName }}</el-descriptions-item>
              <el-descriptions-item :label="t('era')">{{ currentRelic.era }}</el-descriptions-item>
              <el-descriptions-item :label="t('material')">{{ currentRelic.material }}</el-descriptions-item>
              <el-descriptions-item :label="t('category')">{{ currentRelic.categoryName || '—' }}</el-descriptions-item>
              <el-descriptions-item :label="t('status')">
                <el-tag :type="getStatusType(currentRelic.status)">
                  {{ currentRelic.status }}
                </el-tag>
              </el-descriptions-item>
              <el-descriptions-item :label="t('dimensions')">{{ currentRelic.dimensions || '—' }}</el-descriptions-item>
              <el-descriptions-item :label="t('weight')">{{ formatWeight(currentRelic.weight) }}</el-descriptions-item>
              <el-descriptions-item :label="t('origin')" :span="2">{{ currentRelic.origin || '—' }}</el-descriptions-item>
              <el-descriptions-item :label="t('description')" :span="2">{{ currentRelic.description || '—' }}</el-descriptions-item>
            </el-descriptions>
          </div>

          <!-- 时间轴 -->
          <div class="detail-section">
            <h3 class="section-title">{{ t('historyRecords') }}</h3>
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
            <h3 class="section-title">{{ t('relatedRelics') }}</h3>
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
                  <el-icon><Box /></el-icon>
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
    <el-dialog v-model="shareDialogVisible" :title="t('shareRelic')" width="500px">
      <div class="share-content">
        <div class="share-info">
          <h4>{{ currentRelic?.relicName }}</h4>
          <p>{{ currentRelic?.era }} · {{ currentRelic?.material }}</p>
        </div>
        <el-divider />
        <div class="share-options">
          <el-button type="primary" @click="copyShareLink">
            <el-icon><Link /></el-icon>
            {{ t('copyLink') }}
          </el-button>
          <el-button type="success" @click="downloadQRCode">
            <el-icon><Download /></el-icon>
            {{ t('downloadQRCode') }}
          </el-button>
        </div>
        <div class="qrcode-container">
          <canvas ref="qrcodeCanvas" width="200" height="200"></canvas>
        </div>
      </div>
    </el-dialog>

    <!-- 页脚 -->
    <footer class="portal-footer">
      <p>{{ t('footer') }}</p>
    </footer>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, onUnmounted, nextTick, computed, watch } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  User, 
  SwitchButton, 
  HomeFilled, 
  DataAnalysis, 
  Document, 
  Box, 
  Grid, 
  Promotion, 
  Search,
  Loading,
  Link,
  ChatDotRound,
  Warning,
  Plus,
  Delete,
  View,
  List,
  Clock,
  Check,
  Refresh,
  Download,
  Picture
} from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
import NotificationBell from '../components/NotificationBell.vue'
import LanguageSwitcher from '../components/LanguageSwitcher.vue'
import ThemeSwitcher from '../components/ThemeSwitcher.vue'
import DarkModeToggle from '../components/DarkModeToggle.vue'
import { getRelicsPageApi } from '../api/relics'
import { getCategoriesApi } from '../api/categories'
import { addLoanApi, getMyLoansPageApi, userReturnLoanApi } from '../api/loans'
import { getOverviewApi } from '../api/statistics'
import { queryRelicAiApi } from '../api/ai'
import { 
  getSessionsApi, 
  getSessionMessagesApi, 
  createSessionApi, 
  deleteSessionApi,
  queryRelicAiWithSessionApi 
} from '../api/aiChat'
import {
  getAnnualReportApi,
  getTrendAnalysisApi,
  getComparisonAnalysisApi,
  getDashboardDataApi
} from '../api/reports'
import request from '../api/request'
import * as echarts from 'echarts'

const router = useRouter()

// 语言切换 - 兼容LanguageSwitcher组件
const storedLocale = localStorage.getItem('locale') || localStorage.getItem('portalLocale') || 'zh-CN'
// 将locale映射为前台使用的简化格式
const locale = ref(storedLocale.startsWith('zh') ? 'zh' : 'en')

// 监听locale变化，同步到localStorage
watch(locale, (newVal) => {
  const fullLocale = newVal === 'zh' ? 'zh-CN' : 'en-US'
  localStorage.setItem('locale', fullLocale)
  localStorage.setItem('portalLocale', newVal)
})

// 监听localStorage的locale变化（由LanguageSwitcher触发）
const syncLocale = () => {
  const storedLocale = localStorage.getItem('locale')
  if (storedLocale) {
    locale.value = storedLocale.startsWith('zh') ? 'zh' : 'en'
  }
}

// 页面加载时同步一次
syncLocale()

const translations = {
  zh: {
    systemTitle: '文物数字化管理系统',
    systemSubtitle: 'Cultural Relics Digital Management System',
    logout: '退出登录',
    navHome: '首页',
    navDataScreen: '数据大屏',
    navReports: '数据报表',
    navRelics: '文物查询',
    navCategories: '分类查询',
    navLoan: '申请借展',
    navMyLoans: '我的借展',
    navAi: 'AI搜索',
    heroTitle: '探索中华文明瑰宝',
    heroSubtitle: '数字化管理，让文物保护更智能',
    startExplore: '开始探索',
    applyLoan: '申请借展',
    featureDataScreen: '数据大屏',
    featureDataScreenDesc: '实时查看文物管理数据统计',
    featureRelics: '文物搜索',
    featureRelicsDesc: '快速检索文物信息',
    featureAi: 'AI智能搜索',
    featureAiDesc: '智能问答，了解文物知识',
    featureLoan: '借展申请',
    featureLoanDesc: '在线提交借展申请',
    relicTotal: '文物总数',
    inStock: '在库文物',
    loaning: '借出文物',
    categoryCount: '文物分类',
    categoryList: '文物分类列表',
    categoryName: '分类名称',
    description: '描述',
    searchPlaceholder: '请输入文物名称',
    selectRelic: '选择文物',
    selectCategory: '选择分类',
    selectEra: '选择年代',
    searchBtn: '搜索',
    viewRelics: '查看文物',
    noDescription: '暂无描述',
    relicName: '文物名称',
    borrowerUnit: '借展单位', 
    borrowerName: '借展人',
    borrowerPhone: '联系电话',
    loanDate: '借展日期',
    expectedReturnDate: '预计归还日期',
    purpose: '借展目的',
    submit: '提交申请',
    reset: '重置',
    aiWelcome: '您好！我是文物智能助手',
    aiWelcomeDesc: '您可以向我搜索任何文物的信息，例如：',
    aiInputPlaceholder: '请输入您的问题...',
    send: '发送',
    thinking: '正在思考中...',
    pageLoadFailed: '页面数据加载失败，请刷新重试',
    chatHistory: '对话历史',
    newChat: '新对话',
    noHistory: '暂无历史对话',
    deleteConfirm: '确定要删除这个对话吗？',
    confirm: '确定',
    cancel: '取消',
    deleteSuccess: '删除成功',
    deleteFailed: '删除失败',
    newChatCreated: '已创建新对话',
    relicDetail: '文物详情',
    relicCode: '文物编号',
    era: '年代',
    material: '材质',
    category: '分类',
    status: '状态',
    dimensions: '尺寸',
    weight: '重量',
    origin: '来源',
    inStockStatus: '在库',
    loaningStatus: '借出',
    viewDetail: '查看详情',
    relevance: '相关度',
    externalWarning: '外部资料仅供参考',
    visit: '访问',
    collectionTag: '馆藏',
    logoutConfirm: '确定要退出登录吗？',
    logoutSuccess: '已退出登录',
    loanSubmitSuccess: '借展申请提交成功，请等待审批',
    submitFailed: '提交失败，请检查表单',
    searchFailed: '搜索失败，请稍后重试',
    loadFailed: '加载数据失败',
    loadStatisticsFailed: '加载统计数据失败',
    loadCategoriesFailed: '加载分类数据失败',
    searchRelicsFailed: '搜索文物失败',
    loadRelicsFailed: '加载可借展文物失败',
    loadHistoryFailed: '加载历史消息失败',
    inputQuestion: '请输入问题',
    footer: '文物数字化管理系统 | Cultural Relics Digital Management System',
    basicInfo: '基本信息',
    noImage: '暂无图片',
    imageLoadFailed: '图片加载失败',
    share: '分享',
    print: '打印',
    view3DModel: '查看3D模型',
    historyRecords: '历史记录',
    relatedRelics: '相关文物',
    shareRelic: '分享文物',
    copyLink: '复制链接',
    downloadQRCode: '下载二维码',
    linkCopied: '链接已复制',
    qrCodeDownloaded: '二维码已下载'
  },
  en: {
    systemTitle: 'Cultural Relics Digital Management System',
    systemSubtitle: 'Protecting Heritage Through Technology',
    logout: 'Logout',
    navHome: 'Home',
    navDataScreen: 'Dashboard',
    navReports: 'Reports',
    navRelics: 'Relics',
    navCategories: 'Categories',
    navLoan: 'Loan Application',
    navMyLoans: 'My Loans',
    navAi: 'AI Query',
    heroTitle: 'Explore Chinese Cultural Treasures',
    heroSubtitle: 'Digital Management for Smarter Heritage Protection',
    startExplore: 'Start Exploring',
    applyLoan: 'Apply for Loan',
    featureDataScreen: 'Dashboard',
    featureDataScreenDesc: 'Real-time cultural relics management statistics',
    featureRelics: 'Relic Search',
    featureRelicsDesc: 'Quick search for relic information',
    featureAi: 'AI Smart Search',
    featureAiDesc: 'Intelligent Q&A about cultural relics',
    featureLoan: 'Loan Application',
    featureLoanDesc: 'Submit loan applications online',
    relicTotal: 'Total Relics',
    inStock: 'In Stock',
    loaning: 'On Loan',
    categoryCount: 'Categories',
    categoryList: 'Category List',
    categoryName: 'Category Name',
    description: 'Description',
    searchPlaceholder: 'Enter relic name',
    selectCategory: 'Select Category',
    selectEra: 'Select Era',
    searchBtn: 'Search',
    viewRelics: 'View Relics',
    noDescription: 'No description',
    relicName: 'Relic Name',
    borrowerUnit: 'Borrowing Institution',
    borrowerName: 'Borrower Name',
    borrowerPhone: 'Contact Phone',
    loanDate: 'Loan Date',
    expectedReturnDate: 'Expected Return Date',
    purpose: 'Loan Purpose',
    submit: 'Submit',
    reset: 'Reset',
    aiWelcome: 'Hello! I am your Cultural Relics AI Assistant',
    aiWelcomeDesc: 'You can ask me any questions about cultural relics, for example:',
    aiInputPlaceholder: 'Enter your question...',
    send: 'Send',
    thinking: 'Thinking...',
    pageLoadFailed: 'Page data loading failed, please refresh and try again',
    chatHistory: 'Chat History',
    newChat: 'New Chat',
    noHistory: 'No chat history',
    deleteConfirm: 'Are you sure you want to delete this conversation?',
    confirm: 'Confirm',
    cancel: 'Cancel',
    deleteSuccess: 'Deleted successfully',
    deleteFailed: 'Delete failed',
    newChatCreated: 'New chat created',
    relicDetail: 'Relic Details',
    relicCode: 'Relic Code',
    era: 'Era',
    material: 'Material',
    category: 'Category',
    status: 'Status',
    dimensions: 'Dimensions',
    weight: 'Weight',
    origin: 'Origin',
    inStockStatus: 'In Stock',
    loaningStatus: 'On Loan',
    viewDetail: 'View Details',
    relevance: 'Relevance',
    externalWarning: 'External information for reference only',
    visit: 'Visit',
    collectionTag: 'Collection',
    logoutConfirm: 'Are you sure you want to logout?',
    logoutSuccess: 'Logged out successfully',
    loanSubmitSuccess: 'Loan application submitted successfully, please wait for approval',
    submitFailed: 'Submission failed, please check the form',
    queryFailed: 'Query failed, please try again later',
    loadFailed: 'Failed to load data',
    loadStatisticsFailed: 'Failed to load statistics',
    loadCategoriesFailed: 'Failed to load categories',
    queryRelicsFailed: 'Failed to query relics',
    loadRelicsFailed: 'Failed to load available relics',
    loadHistoryFailed: 'Failed to load history',
    inputQuestion: 'Please enter a question',
    footer: 'Cultural Relics Digital Management System',
    basicInfo: 'Basic Information',
    noImage: 'No Image',
    imageLoadFailed: 'Image Load Failed',
    share: 'Share',
    print: 'Print',
    view3DModel: 'View 3D Model',
    historyRecords: 'History Records',
    relatedRelics: 'Related Relics',
    shareRelic: 'Share Relic',
    copyLink: 'Copy Link',
    downloadQRCode: 'Download QR Code',
    linkCopied: 'Link Copied',
    qrCodeDownloaded: 'QR Code Downloaded'
  }
}

const t = (key) => {
  // 支持嵌套键，如 'relic.inStock'
  if (key.includes('.')) {
    const parts = key.split('.')
    if (parts[0] === 'relic') {
      const relicTranslations = {
        inStock: locale.value === 'zh' ? '在库' : 'In Stock',
        onLoan: locale.value === 'zh' ? '借展中' : 'On Loan',
        repairing: locale.value === 'zh' ? '修复中' : 'Repairing',
        sealed: locale.value === 'zh' ? '封存' : 'Sealed'
      }
      return relicTranslations[parts[1]] || key
    } else if (parts[0] === 'common') {
      const commonTranslations = {
        noData: locale.value === 'zh' ? '暂无数据' : 'No Data'
      }
      return commonTranslations[parts[1]] || key
    }
  }
  return translations[locale.value][key] || key
}

// 分类名称映射
const translateCategoryName = (name) => {
  const categoryMap = {
    '青铜器': locale.value === 'zh' ? '青铜器' : 'Bronze',
    '陶器': locale.value === 'zh' ? '陶器' : 'Pottery',
    '陶瓷器': locale.value === 'zh' ? '陶瓷器' : 'Ceramics',
    '玉器': locale.value === 'zh' ? '玉器' : 'Jade',
    '瓷器': locale.value === 'zh' ? '瓷器' : 'Porcelain',
    '书画': locale.value === 'zh' ? '书画' : 'Painting & Calligraphy',
    '雕塑': locale.value === 'zh' ? '雕塑' : 'Sculpture',
    '家具': locale.value === 'zh' ? '家具' : 'Furniture',
    '金银器': locale.value === 'zh' ? '金银器' : 'Gold & Silver',
    '碑帖': locale.value === 'zh' ? '碑帖' : 'Stele & Rubbing',
    '钱币': locale.value === 'zh' ? '钱币' : 'Coins',
    '石刻': locale.value === 'zh' ? '石刻' : 'Stone Carving',
    '木器': locale.value === 'zh' ? '木器' : 'Woodware',
    '漆器': locale.value === 'zh' ? '漆器' : 'Lacquerware',
    '织绣': locale.value === 'zh' ? '织绣' : 'Textile',
    '服饰': locale.value === 'zh' ? '服饰' : 'Costume',
    '杂项': locale.value === 'zh' ? '杂项' : 'Miscellaneous',
    '佛像': locale.value === 'zh' ? '佛像' : 'Buddha Statue',
    '其他': locale.value === 'zh' ? '其他' : 'Other'
  }
  return categoryMap[name] || name
}

// 年代映射
const translateEra = (era) => {
  const eraMap = {
    '新石器时代': locale.value === 'zh' ? '新石器时代' : 'Neolithic Age',
    '夏朝': locale.value === 'zh' ? '夏朝' : 'Xia Dynasty',
    '商代': locale.value === 'zh' ? '商代' : 'Shang Dynasty',
    '商朝': locale.value === 'zh' ? '商朝' : 'Shang Dynasty',
    '商周': locale.value === 'zh' ? '商周' : 'Shang-Zhou',
    '西周': locale.value === 'zh' ? '西周' : 'Western Zhou',
    '春秋': locale.value === 'zh' ? '春秋' : 'Spring & Autumn',
    '战国': locale.value === 'zh' ? '战国' : 'Warring States',
    '秦代': locale.value === 'zh' ? '秦代' : 'Qin Dynasty',
    '秦朝': locale.value === 'zh' ? '秦朝' : 'Qin Dynasty',
    '秦汉': locale.value === 'zh' ? '秦汉' : 'Qin-Han',
    '汉代': locale.value === 'zh' ? '汉代' : 'Han Dynasty',
    '汉朝': locale.value === 'zh' ? '汉朝' : 'Han Dynasty',
    '东汉': locale.value === 'zh' ? '东汉' : 'Eastern Han',
    '西汉': locale.value === 'zh' ? '西汉' : 'Western Han',
    '三国': locale.value === 'zh' ? '三国' : 'Three Kingdoms',
    '晋代': locale.value === 'zh' ? '晋代' : 'Jin Dynasty',
    '金朝': locale.value === 'zh' ? '金朝' : 'Jin Dynasty',
    '南北朝': locale.value === 'zh' ? '南北朝' : 'Northern & Southern',
    '北魏': locale.value === 'zh' ? '北魏' : 'Northern Wei',
    '隋代': locale.value === 'zh' ? '隋代' : 'Sui Dynasty',
    '隋朝': locale.value === 'zh' ? '隋朝' : 'Sui Dynasty',
    '唐代': locale.value === 'zh' ? '唐代' : 'Tang Dynasty',
    '唐朝': locale.value === 'zh' ? '唐朝' : 'Tang Dynasty',
    '唐宋': locale.value === 'zh' ? '唐宋' : 'Tang-Song',
    '五代十国': locale.value === 'zh' ? '五代十国' : 'Five Dynasties',
    '宋代': locale.value === 'zh' ? '宋代' : 'Song Dynasty',
    '北宋': locale.value === 'zh' ? '北宋' : 'Northern Song',
    '南宋': locale.value === 'zh' ? '南宋' : 'Southern Song',
    '宋朝': locale.value === 'zh' ? '宋朝' : 'Song Dynasty',
    '辽朝': locale.value === 'zh' ? '辽朝' : 'Liao Dynasty',
    '西夏': locale.value === 'zh' ? '西夏' : 'Western Xia',
    '元代': locale.value === 'zh' ? '元代' : 'Yuan Dynasty',
    '元朝': locale.value === 'zh' ? '元朝' : 'Yuan Dynasty',
    '明代': locale.value === 'zh' ? '明代' : 'Ming Dynasty',
    '明朝': locale.value === 'zh' ? '明朝' : 'Ming Dynasty',
    '清代': locale.value === 'zh' ? '清代' : 'Qing Dynasty',
    '清朝': locale.value === 'zh' ? '清朝' : 'Qing Dynasty',
    '明清': locale.value === 'zh' ? '明清' : 'Ming-Qing',
    '近现代': locale.value === 'zh' ? '近现代' : 'Modern',
    '民国': locale.value === 'zh' ? '民国' : 'Republic of China',
    '其他': locale.value === 'zh' ? '其他' : 'Other'
  }
  return eraMap[era] || era
}

// 从localStorage恢复上次访问的页面，如果没有则默认为首页
const activeSection = ref(localStorage.getItem('portalActiveSection') || 'home')

const statistics = ref({})
const categoryList = ref([])
const relicList = ref([])
const relicTotal = ref(0)
const availableRelics = ref([])
const currentRelic = ref(null)
const relicDetailVisible = ref(false)
const detailImages = ref([])
const relicTimeline = ref([])
const relatedRelics = ref([])
const shareDialogVisible = ref(false)
const qrcodeCanvas = ref(null)
const aiLoading = ref(false)
const aiQuery = ref('')
const chatHistory = ref([])
const currentSessionId = ref(null)
const sessionList = ref([])
const sessionsLoading = ref(false)
const chatMessages = ref(null)
const loanFormRef = ref()

// 我的借展相关
const myLoansLoading = ref(false)
const myLoansList = ref([])
const myLoansTotal = ref(0)
const myLoansQuery = reactive({
  pageNum: 1,
  pageSize: 10,
  status: ''
})
// 独立的统计数据，不随筛选条件变化
const myLoansStats = reactive({
  loaning: 0,
  returned: 0,
  overdue: 0,
  pending: 0
})

// 监听activeSection变化，自动加载对应数据
watch(activeSection, async (newSection) => {
  console.log('切换到section:', newSection)
  
  // 保存当前页面到localStorage，以便刷新后恢复
  localStorage.setItem('portalActiveSection', newSection)
  
  if (newSection === 'data-screen') {
    // 切换到数据大屏时，等待DOM渲染完成后再初始化图表
    await nextTick()
    setTimeout(() => {
      console.log('数据大屏页面已显示，开始初始化图表...')
      // 销毁旧的图表实例并重置为null
      if (categoryChartPortal) {
        categoryChartPortal.dispose()
        categoryChartPortal = null
      }
      if (statusChartPortal) {
        statusChartPortal.dispose()
        statusChartPortal = null
      }
      if (eraChartPortal) {
        eraChartPortal.dispose()
        eraChartPortal = null
      }
      
      // 重新初始化
      initDashboardCharts()
      loadDashboardData()
    }, 300)
  } else if (newSection === 'reports') {
    // 切换到报表时，如果还没有加载过年度报告，则加载
    if (!annualData.value) {
      console.log('首次进入报表页面，加载年度报告...')
      await nextTick()
      setTimeout(() => {
        loadAnnualReport()
      }, 100)
    }
  } else if (newSection === 'loan') {
    // 切换到借展页面时，初始化借展日期为当前时间，并填充用户信息
    if (!loanForm.loanDate) {
      const now = new Date()
      const year = now.getFullYear()
      const month = String(now.getMonth() + 1).padStart(2, '0')
      const day = String(now.getDate()).padStart(2, '0')
      const hours = String(now.getHours()).padStart(2, '0')
      const minutes = String(now.getMinutes()).padStart(2, '0')
      const seconds = String(now.getSeconds()).padStart(2, '0')
      loanForm.loanDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
    }
    // 自动填充当前用户的姓名、电话和博物馆
    if (!loanForm.borrowerName) {
      loanForm.borrowerName = sessionStorage.getItem('realName') || sessionStorage.getItem('username') || ''
    }
    if (!loanForm.borrowerPhone) {
      loanForm.borrowerPhone = sessionStorage.getItem('phone') || ''
    }
    if (!loanForm.borrowerUnit) {
      loanForm.borrowerUnit = sessionStorage.getItem('museumName') || ''
    }
  } else if (newSection === 'my-loans') {
    // 切换到我的借展页面时，加载借展记录和统计数据
    loadMyLoansStats()  // 先加载统计数据
    loadMyLoans()       // 再加载列表数据
  }
})

// 监听语言变化，重新渲染图表
watch(locale, () => {
  // 如果当前在数据大屏页面，重新渲染图表
  if (activeSection.value === 'data-screen' && dashboardData.value) {
    updateDashboardCharts()
  }
})

// 报表相关
const activeReportTab = ref('annual')
const annualYear = ref(new Date().getFullYear())
const annualData = ref(null)
const annualChartRef = ref()
let annualChart = null

const trendDateRange = ref([])
const trendType = ref('loan')
const trendChartRef = ref()
let trendChart = null

const comparisonYear1 = ref(new Date().getFullYear() - 1)
const comparisonYear2 = ref(new Date().getFullYear())
const comparisonData = ref(null)
const comparisonChartRef = ref()
let comparisonChart = null

const years = computed(() => {
  const currentYear = new Date().getFullYear()
  return Array.from({ length: 10 }, (_, i) => currentYear - i)
})

const growthRateData = computed(() => {
  if (!comparisonData.value) return []
  
  const { year1Data, year2Data, growthRate } = comparisonData.value
  
  return [
    {
      type: locale.value === 'zh' ? '借展' : 'Loans',
      year1: year1Data.loans,
      year2: year2Data.loans,
      rate: growthRate.loans
    },
    {
      type: locale.value === 'zh' ? '保养' : 'Maintenance',
      year1: year1Data.maintenance,
      year2: year2Data.maintenance,
      rate: growthRate.maintenance
    },
    {
      type: locale.value === 'zh' ? '修复' : 'Repairs',
      year1: year1Data.repairs,
      year2: year2Data.repairs,
      rate: growthRate.repairs
    }
  ]
})

// 数据大屏相关
const dashboardData = ref({})
const categoryChartPortalRef = ref()
const statusChartPortalRef = ref()
const eraChartPortalRef = ref()

let categoryChartPortal = null
let statusChartPortal = null
let eraChartPortal = null

const loanStatsPortal = computed(() => dashboardData.value.loanStats || {})
const repairStatsPortal = computed(() => dashboardData.value.repairStats || {})

const userName = computed(() => {
  return sessionStorage.getItem('realName') || sessionStorage.getItem('username') || '借展人'
})

const isLoggedIn = computed(() => {
  return !!sessionStorage.getItem('token')
})

const goToProfile = () => {
  router.push('/portal-profile')
}

// 我的借展相关方法
const loadMyLoans = async () => {
  myLoansLoading.value = true
  try {
    const res = await getMyLoansPageApi({
      pageNum: myLoansQuery.pageNum,
      pageSize: myLoansQuery.pageSize,
      status: myLoansQuery.status || undefined
    })
    
    if (res.code === 200) {
      myLoansList.value = res.data.records || []
      myLoansTotal.value = res.data.total || 0
    } else {
      ElMessage.error(res.message || (locale.value === 'zh' ? '加载失败' : 'Load failed'))
    }
  } catch (e) {
    ElMessage.error(locale.value === 'zh' ? '加载失败' : 'Load failed')
  } finally {
    myLoansLoading.value = false
  }
}

// 加载我的借展统计数据
const loadMyLoansStats = async () => {
  try {
    // 并行查询各个状态的总数
    const [loaningRes, returnedRes, overdueRes, pendingRes] = await Promise.all([
      getMyLoansPageApi({ pageNum: 1, pageSize: 1, status: '借展中' }),
      getMyLoansPageApi({ pageNum: 1, pageSize: 1, status: '已归还' }),
      getMyLoansPageApi({ pageNum: 1, pageSize: 1, status: '逾期' }),
      getMyLoansPageApi({ pageNum: 1, pageSize: 1, status: '待审批' })
    ])
    
    myLoansStats.loaning = loaningRes.code === 200 ? (loaningRes.data.total || 0) : 0
    myLoansStats.returned = returnedRes.code === 200 ? (returnedRes.data.total || 0) : 0
    myLoansStats.overdue = overdueRes.code === 200 ? (overdueRes.data.total || 0) : 0
    myLoansStats.pending = pendingRes.code === 200 ? (pendingRes.data.total || 0) : 0
  } catch (e) {
    console.error('加载统计数据失败:', e)
  }
}

const formatMyLoanDateTime = (value) => {
  if (!value) return '—'
  return String(value).replace('T', ' ').substring(0, 16)
}

const getMyLoanStatusType = (status) => {
  const typeMap = {
    '待审批': 'warning',
    '借展中': 'primary',
    '已归还': 'success',
    '已驳回': 'info',
    '逾期': 'danger'
  }
  return typeMap[status] || 'info'
}

const isMyLoanOverdue = (loan) => {
  if (loan.status !== '借展中' && loan.status !== '逾期') return false
  if (!loan.expectedReturnDate) return false
  return new Date(loan.expectedReturnDate) < new Date()
}

const getMyLoanOverdueDays = (loan) => {
  if (!loan.expectedReturnDate) return 0
  const expected = new Date(loan.expectedReturnDate)
  const now = new Date()
  const diff = now - expected
  return Math.floor(diff / (1000 * 60 * 60 * 24))
}

const handleMyLoanReturn = async (loan) => {
  try {
    await ElMessageBox.confirm(
      locale.value === 'zh' 
        ? `确认要归还文物"${loan.relicName}"吗？归还后将通知后台管理员进行确认。`
        : `Confirm to return "${loan.relicName}"? Administrators will be notified.`,
      locale.value === 'zh' ? '确认归还' : 'Confirm Return',
      {
        confirmButtonText: locale.value === 'zh' ? '确认归还' : 'Confirm',
        cancelButtonText: locale.value === 'zh' ? '取消' : 'Cancel',
        type: 'warning'
      }
    )
    
    myLoansLoading.value = true
    const res = await userReturnLoanApi(loan.id)
    
    if (Number(res?.code) === 200) {
      ElMessage.success(locale.value === 'zh' ? '归还申请已提交，请等待管理员确认' : 'Return request submitted')
      // 刷新失败不应覆盖归还成功提示
      try {
        await loadMyLoansStats()
        await loadMyLoans()
      } catch (refreshError) {
        ElMessage.warning(locale.value === 'zh' ? '归还申请成功，但列表刷新失败，请手动刷新页面' : 'Return request succeeded, but failed to refresh data')
      }
    } else {
      ElMessage.error(res.message || (locale.value === 'zh' ? '归还失败' : 'Return failed'))
    }
  } catch (e) {
    if (e !== 'cancel') {
      ElMessage.error(locale.value === 'zh' ? '归还失败' : 'Return failed')
    }
  } finally {
    myLoansLoading.value = false
  }
}

const handleLogout = async () => {
  try {
    await ElMessageBox.confirm(t('logoutConfirm'), t('confirm'), {
      confirmButtonText: t('confirm'),
      cancelButtonText: t('cancel'),
      type: 'warning'
    })
    sessionStorage.clear()
    ElMessage.success(t('logoutSuccess'))
    router.push('/login')
  } catch {
    // 用户取消
  }
}

const relicQuery = reactive({
  pageNum: 1,
  pageSize: 12,
  relicName: '',
  categoryId: null,
  era: '',
  status: ''
})

const loanForm = reactive({
  relicId: null,
  borrowerUnit: sessionStorage.getItem('museumName') || '',
  borrowerName: sessionStorage.getItem('realName') || sessionStorage.getItem('username') || '',
  borrowerPhone: sessionStorage.getItem('phone') || '',
  loanDate: '',
  expectedReturnDate: '',
  purpose: ''
})

// 自定义预计归还日期验证规则
const validateReturnDate = (rule, value, callback) => {
  if (!value) {
    callback(new Error('请选择预计归还日期'))
  } else {
    const returnDate = new Date(value)
    const now = new Date()
    
    if (returnDate < now) {
      callback(new Error('预计归还日期必须是当前时间及以后'))
    } else if (loanForm.loanDate) {
      const loanDate = new Date(loanForm.loanDate)
      if (returnDate <= loanDate) {
        callback(new Error('预计归还日期必须晚于借展日期'))
      } else {
        callback()
      }
    } else {
      callback()
    }
  }
}

const loanRules = {
  relicId: [{ required: true, message: '请选择文物', trigger: 'change' }],
  borrowerUnit: [{ required: true, message: '请输入借展单位', trigger: 'blur' }], 
  borrowerName: [{ required: true, message: '请输入借展人姓名', trigger: 'blur' }],
  borrowerPhone: [{ required: true, message: '请输入联系电话', trigger: 'blur' }],
  loanDate: [{ required: true, message: '请选择借展日期', trigger: 'change' }],
  expectedReturnDate: [
    { required: true, message: '请选择预计归还日期', trigger: 'change' },
    { validator: validateReturnDate, trigger: 'change' }
  ],
  purpose: [{ required: true, message: '请输入借展目的', trigger: 'blur' }]
}

// 禁用当前时间之前的日期（预计归还日期）
const disabledReturnDate = (time) => {
  const now = new Date()
  return time.getTime() < now.getTime()
}

const backendBaseURL = request.defaults.baseURL  // http://localhost:8080/api

const resolveImageUrl = (imagePath) => {
  console.log('resolveImageUrl 输入:', imagePath)
  if (!imagePath) {
    console.log('图片路径为空，返回占位图')
    return 'https://via.placeholder.com/300x200?text=No+Image'
  }
  
  // 如果是外部HTTP/HTTPS图片，使用代理
  if (/^https?:\/\//i.test(imagePath)) {
    console.log('图片路径是外部URL，使用代理:', imagePath)
    // Base64 编码 URL
    const encodedUrl = btoa(imagePath)
    const proxyUrl = `${backendBaseURL}/proxy/image?url=${encodedUrl}`
    console.log('代理URL:', proxyUrl)
    return proxyUrl
  }
  
  // 本地图片路径处理
  let normalized = String(imagePath).trim().replace(/\\/g, '/')
  if (normalized.startsWith('./')) normalized = normalized.slice(1)
  if (!normalized.startsWith('/')) normalized = `/${normalized}`
  // 使用完整的 baseURL，包含 /api 前缀
  const fullUrl = `${backendBaseURL}${normalized}`
  console.log('本地图片路径转换为:', fullUrl)
  return fullUrl
}

const formatWeight = (weight) => {
  if (weight === null || weight === undefined || weight === '') return '—'
  return `${Number(weight).toFixed(2)} kg`
}

const formatDateTime = (value) => {
  if (!value) return ''
  return String(value).replace('T', ' ').substring(0, 19)
}

const getStatusType = (status) => {
  const statusMap = {
    '在库': 'success',
    'In Stock': 'success',
    '借展中': 'warning',
    'On Loan': 'warning',
    '修复中': 'danger',
    'Repairing': 'danger'
  }
  return statusMap[status] || 'info'
}

const viewRelatedDetail = async (relic) => {
  // 查看关联文物详情
  await viewRelicDetail(relic)
}

const view3DModel = (relic) => {
  if (relic.model3dUrl) {
    window.open(relic.model3dUrl, '_blank')
  }
}

const handleShare = () => {
  shareDialogVisible.value = true
  // 生成二维码
  nextTick(() => {
    if (qrcodeCanvas.value) {
      const canvas = qrcodeCanvas.value
      const ctx = canvas.getContext('2d')
      
      // 清空画布
      ctx.clearRect(0, 0, 200, 200)
      
      // 绘制白色背景
      ctx.fillStyle = '#ffffff'
      ctx.fillRect(0, 0, 200, 200)
      
      // 绘制简单的二维码占位符
      ctx.fillStyle = '#000000'
      ctx.fillRect(50, 50, 100, 100)
      
      // 绘制文字
      ctx.fillStyle = '#333333'
      ctx.font = '12px Arial'
      ctx.textAlign = 'center'
      ctx.fillText(locale.value === 'zh' ? '文物编号' : 'Relic Code', 100, 170)
      ctx.fillText(currentRelic.value.relicCode, 100, 185)
    }
  })
}

const copyShareLink = () => {
  const link = `${window.location.origin}/relics/${currentRelic.value.id}`
  navigator.clipboard.writeText(link).then(() => {
    ElMessage.success(t('linkCopied'))
  }).catch(() => {
    ElMessage.error(locale.value === 'zh' ? '复制失败' : 'Copy failed')
  })
}

const downloadQRCode = () => {
  const canvas = qrcodeCanvas.value
  const link = document.createElement('a')
  link.download = `${locale.value === 'zh' ? '二维码' : 'QRCode'}_${currentRelic.value.relicCode}.png`
  link.href = canvas.toDataURL()
  link.click()
  ElMessage.success(t('qrCodeDownloaded'))
}

const handlePrintDetail = () => {
  if (!currentRelic.value) return
  
  const printWindow = window.open('', '_blank')
  const content = `
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>${locale.value === 'zh' ? '文物详情' : 'Relic Details'} - ${currentRelic.value.relicName}</title>
      <style>
        @page { size: A4; margin: 20mm; }
        body {
          font-family: Arial, sans-serif;
          line-height: 1.6;
          color: #333;
        }
        .header {
          text-align: center;
          border-bottom: 2px solid #333;
          padding-bottom: 10px;
          margin-bottom: 20px;
        }
        .header h1 {
          margin: 0;
          font-size: 24px;
        }
        .header .code {
          color: #666;
          font-size: 14px;
        }
        .info-grid {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 15px;
          margin-bottom: 20px;
        }
        .info-item {
          border: 1px solid #ddd;
          padding: 10px;
          border-radius: 4px;
        }
        .info-label {
          font-weight: bold;
          color: #666;
          font-size: 12px;
          margin-bottom: 5px;
        }
        .info-value {
          font-size: 14px;
        }
        .description {
          border: 1px solid #ddd;
          padding: 15px;
          border-radius: 4px;
          margin-top: 20px;
        }
      </style>
    </head>
    <body>
      <div class="header">
        <h1>${currentRelic.value.relicName}</h1>
        <div class="code">${locale.value === 'zh' ? '文物编号：' : 'Relic Code: '}${currentRelic.value.relicCode}</div>
      </div>
      
      <div class="info-grid">
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '年代' : 'Era'}</div>
          <div class="info-value">${currentRelic.value.era || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '材质' : 'Material'}</div>
          <div class="info-value">${currentRelic.value.material || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '类别' : 'Category'}</div>
          <div class="info-value">${currentRelic.value.categoryName || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '状态' : 'Status'}</div>
          <div class="info-value">${currentRelic.value.status || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '尺寸' : 'Dimensions'}</div>
          <div class="info-value">${currentRelic.value.dimensions || '—'}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '重量' : 'Weight'}</div>
          <div class="info-value">${formatWeight(currentRelic.value.weight)}</div>
        </div>
        <div class="info-item">
          <div class="info-label">${locale.value === 'zh' ? '来源' : 'Origin'}</div>
          <div class="info-value">${currentRelic.value.origin || '—'}</div>
        </div>
      </div>
      
      <div class="description">
        <div class="info-label">${locale.value === 'zh' ? '描述' : 'Description'}</div>
        <div class="info-value">${currentRelic.value.description || '—'}</div>
      </div>
    </body>
    </html>
  `
  printWindow.document.write(content)
  printWindow.document.close()
  printWindow.onload = () => {
    printWindow.print()
  }
}

const loadStatistics = async () => {
  try {
    console.log('开始加载统计数据...')
    const res = await getOverviewApi()
    console.log('统计数据响应:', res)
    statistics.value = res.data || {}
    console.log('统计数据已设置:', statistics.value)
  } catch (error) {
    console.error('加载统计数据失败:', error)
    ElMessage.error(t('loadStatisticsFailed'))
  }
}

const loadCategories = async () => {
  try {
    console.log('开始加载分类数据...')
    const res = await getCategoriesApi({ parentId: null })
    console.log('分类数据响应:', res)
    categoryList.value = res.data || []
    console.log('分类数据已设置:', categoryList.value)
  } catch (error) {
    console.error('加载分类失败:', error)
    ElMessage.error(t('loadCategoriesFailed'))
  }
}

const searchRelics = async () => {
  try {
    console.log('开始搜索文物...', relicQuery)
    const res = await getRelicsPageApi(relicQuery)
    console.log('文物数据响应:', res)
    relicList.value = res.data.records || []
    relicTotal.value = res.data.total || 0
    console.log('文物数据已设置:', relicList.value.length, '条')
  } catch (error) {
    console.error('搜索文物失败:', error)
    ElMessage.error(t('searchRelicsFailed'))
  }
}

const handleRelicPageChange = (page) => {
  relicQuery.pageNum = page
  searchRelics()
}

const viewRelicDetail = async (relic) => {
  currentRelic.value = relic
  relicDetailVisible.value = true
  
  // 加载文物的所有图片用于轮播
  detailImages.value = []
  if (relic.imagePath) {
    detailImages.value.push(resolveImageUrl(relic.imagePath))
    console.log('添加主图片:', resolveImageUrl(relic.imagePath))
  }
  
  // 尝试加载更多图片（如果有关联图片API）
  try {
    // 使用 /list/ 端点获取所有图片，而不是 /relic/ 端点（只返回主图）
    const response = await request.get(`/relic-images/list/${relic.id}`)
    console.log('关联图片API响应:', response)
    
    // 处理返回的数据（可能是对象或数组）
    let relicImages = []
    if (response.data) {
      // 如果是数组，直接使用
      if (Array.isArray(response.data)) {
        relicImages = response.data
      } 
      // 如果是单个对象，转换为数组
      else if (typeof response.data === 'object') {
        relicImages = [response.data]
      }
    }
    
    console.log('处理后的图片列表:', relicImages)
    
    if (relicImages.length > 0) {
      relicImages.forEach(item => {
        // 尝试从不同的字段获取图片路径
        let imagePath = null
        
        // 方式1：从 image.filePath 获取
        if (item.image && item.image.filePath) {
          imagePath = item.image.filePath
        }
        // 方式2：从 imagePath 获取
        else if (item.imagePath) {
          imagePath = item.imagePath
        }
        // 方式3：从 filePath 获取
        else if (item.filePath) {
          imagePath = item.filePath
        }
        
        if (imagePath) {
          const url = resolveImageUrl(imagePath)
          if (!detailImages.value.includes(url)) {
            detailImages.value.push(url)
            console.log('添加关联图片:', url)
          }
        }
      })
    }
  } catch (e) {
    console.log('加载关联图片失败（这是正常的，如果没有关联图片）:', e.message)
  }
  
  console.log('最终图片列表:', detailImages.value)
  console.log('图片数量:', detailImages.value.length)
  
  // 构建时间轴数据
  relicTimeline.value = [
    {
      id: 1,
      time: formatDateTime(relic.createTime),
      type: 'primary',
      title: locale.value === 'zh' ? '文物入库' : 'Relic Registered',
      content: locale.value === 'zh' 
        ? `文物正式入库登记，编号：${relic.relicCode}` 
        : `Relic registered with code: ${relic.relicCode}`
    }
  ]
  
  // 如果有更新时间，添加更新记录
  if (relic.updateTime && relic.updateTime !== relic.createTime) {
    relicTimeline.value.push({
      id: 2,
      time: formatDateTime(relic.updateTime),
      type: 'success',
      title: locale.value === 'zh' ? '信息更新' : 'Information Updated',
      content: locale.value === 'zh' ? '文物信息已更新' : 'Relic information updated'
    })
  }
  
  // 根据状态添加相应记录
  if (relic.status === '借展中' || relic.status === 'On Loan') {
    relicTimeline.value.push({
      id: 3,
      time: formatDateTime(relic.updateTime),
      type: 'warning',
      title: locale.value === 'zh' ? '借展出库' : 'Loaned Out',
      content: locale.value === 'zh' ? '文物已借出展览' : 'Relic loaned for exhibition'
    })
  } else if (relic.status === '修复中' || relic.status === 'Repairing') {
    relicTimeline.value.push({
      id: 4,
      time: formatDateTime(relic.updateTime),
      type: 'danger',
      title: locale.value === 'zh' ? '送修' : 'Under Repair',
      content: locale.value === 'zh' ? '文物送修中' : 'Relic under repair'
    })
  }
  
  // 加载关联文物（同类别或同年代）
  try {
    const response = await getRelicsPageApi({
      pageNum: 1,
      pageSize: 4,
      categoryId: relic.categoryId
    })
    relatedRelics.value = (response.data.records || [])
      .filter(r => r.id !== relic.id)
      .slice(0, 3)
    console.log('关联文物:', relatedRelics.value.length, '个')
  } catch (e) {
    console.log('加载关联文物失败:', e.message)
    relatedRelics.value = []
  }
}

const viewCategoryRelics = (category) => {
  activeSection.value = 'relics'
  relicQuery.categoryId = category.id
  relicQuery.pageNum = 1
  searchRelics()
}

// 根据分类名称返回对应的图标
const getCategoryIcon = (categoryName) => {
  const iconMap = {
    '青铜器': '🔔',
    '陶瓷器': '🏺',
    '书画': '🖼️',
    '玉器': '💎',
    '金银器': '👑',
    '碑帖': '📜',
    '钱币': '🪙',
    '服饰': '👘',
    '佛像': '🙏',
    '家具': '🪑',
    '漆器': '🎨',
    '杂项': '📦'
  }
  return iconMap[categoryName] || '📂'
}

const loadAvailableRelics = async () => {
  try {
    console.log('开始加载可借展文物...')
    const res = await getRelicsPageApi({ pageNum: 1, pageSize: 1000, status: '在库' })
    console.log('可借展文物响应:', res)
    availableRelics.value = res.data.records || []
    console.log('可借展文物已设置:', availableRelics.value.length, '条')
  } catch (error) {
    console.error('加载可借展文物失败:', error)
    ElMessage.error(t('loadRelicsFailed'))
  }
}

const submitLoanApplication = async () => {
  try {
    await loanFormRef.value?.validate()
    await addLoanApi(loanForm)
    ElMessage.success(t('loanSubmitSuccess'))
    resetLoanForm()
  } catch (error) {
    if (error !== false) {
      ElMessage.error(t('submitFailed'))
    }
  }
}

const resetLoanForm = () => {
  // 设置默认的借展日期为当前日期时间
  const now = new Date()
  const year = now.getFullYear()
  const month = String(now.getMonth() + 1).padStart(2, '0')
  const day = String(now.getDate()).padStart(2, '0')
  const hours = String(now.getHours()).padStart(2, '0')
  const minutes = String(now.getMinutes()).padStart(2, '0')
  const seconds = String(now.getSeconds()).padStart(2, '0')
  const currentDateTime = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
  
  // 获取当前用户的姓名、电话和博物馆
  const currentUserName = sessionStorage.getItem('realName') || sessionStorage.getItem('username') || ''
  const currentUserPhone = sessionStorage.getItem('phone') || ''
  const currentMuseumName = sessionStorage.getItem('museumName') || ''
  
  Object.assign(loanForm, {
    relicId: null,
    borrowerUnit: currentMuseumName,  // 自动填充当前用户所属博物馆
    borrowerName: currentUserName,  // 自动填充当前用户姓名
    borrowerPhone: currentUserPhone,  // 自动填充当前用户电话
    loanDate: currentDateTime,  // 默认为当前日期时间
    expectedReturnDate: '',
    purpose: ''
  })
  loanFormRef.value?.clearValidate()
}

const sendAiQuery = async () => {
  if (!aiQuery.value.trim()) {
    ElMessage.warning(t('inputQuestion'))
    return
  }

  const question = aiQuery.value
  aiQuery.value = ''
  aiLoading.value = true

  try {
    console.log('发送AI搜索:', question, 'sessionId:', currentSessionId.value)
    const res = await queryRelicAiWithSessionApi(question, false, currentSessionId.value)
    console.log('AI搜索响应:', res)
    console.log('返回的文物数据:', res.data.relics)
    
    // 检查每个文物的图片路径
    if (res.data.relics && res.data.relics.length > 0) {
      res.data.relics.forEach((relic, index) => {
        console.log(`文物 ${index + 1} [${relic.relicName}] 图片路径:`, relic.imagePath)
      })
    }
    
    // 如果返回了新的sessionId，保存它
    if (res.data.sessionId) {
      currentSessionId.value = res.data.sessionId
      // 刷新会话列表
      await loadSessions()
    }
    
    // 添加到对话历史
    chatHistory.value.push({
      question: question,
      response: res.data,
      time: new Date().toLocaleTimeString()
    })

    // 滚动到底部
    nextTick(() => {
      if (chatMessages.value) {
        chatMessages.value.scrollTop = chatMessages.value.scrollHeight
      }
    })
  } catch (error) {
    console.error('AI搜索失败:', error)
    ElMessage.error(t('searchFailed'))
    
    // 添加错误消息到对话历史
    chatHistory.value.push({
      question: question,
      response: {
        answer: t('queryFailed'),
        relics: [],
        total: 0
      },
      time: new Date().toLocaleTimeString()
    })
  } finally {
    aiLoading.value = false
  }
}

const viewRelicDetailFromAi = (relic) => {
  // 如果是馆藏文物，显示详情对话框
  if (!relic.external && relic.id > 0) {
    currentRelic.value = {
      id: relic.id,
      relicCode: '',
      relicName: relic.relicName,
      era: relic.era,
      material: relic.material,
      categoryName: relic.categoryName,
      status: relic.status,
      dimensions: relic.dimensions,
      weight: relic.weight,
      origin: '',
      description: relic.description,
      imagePath: relic.imagePath
    }
    relicDetailVisible.value = true
  }
}

const getRelevanceColor = (percent) => {
  if (percent >= 80) return '#67c23a'
  if (percent >= 60) return '#e6a23c'
  return '#f56c6c'
}

const openExternalLink = (url) => {
  window.open(url, '_blank')
}

// 加载会话列表
const loadSessions = async () => {
  try {
    sessionsLoading.value = true
    const res = await getSessionsApi()
    sessionList.value = res.data || []
    console.log('会话列表已加载:', sessionList.value.length)
  } catch (error) {
    console.error('加载会话列表失败:', error)
  } finally {
    sessionsLoading.value = false
  }
}

// 加载会话消息
const loadSessionMessages = async (sessionId) => {
  try {
    aiLoading.value = true
    const res = await getSessionMessagesApi(sessionId)
    const messages = res.data || []
    
    // 转换消息格式为chatHistory格式
    chatHistory.value = []
    for (let i = 0; i < messages.length; i += 2) {
      const userMsg = messages[i]
      const aiMsg = messages[i + 1]
      
      if (userMsg && userMsg.messageType === 'user' && aiMsg && aiMsg.messageType === 'ai') {
        chatHistory.value.push({
          question: userMsg.content,
          response: {
            answer: aiMsg.content,
            relics: [], // 历史消息暂不加载详细文物信息
            total: aiMsg.resultCount || 0
          },
          time: new Date(aiMsg.createTime).toLocaleTimeString()
        })
      }
    }
    
    console.log('会话消息已加载:', chatHistory.value.length)
    
    // 滚动到底部
    nextTick(() => {
      if (chatMessages.value) {
        chatMessages.value.scrollTop = chatMessages.value.scrollHeight
      }
    })
  } catch (error) {
    console.error('加载会话消息失败:', error)
    ElMessage.error(t('loadHistoryFailed'))
  } finally {
    aiLoading.value = false
  }
}

// 切换会话
const switchSession = async (session) => {
  currentSessionId.value = session.id
  await loadSessionMessages(session.id)
}

// 格式化会话时间 - ChatGPT风格
const formatSessionTime = (dateTime) => {
  if (!dateTime) return ''
  
  const now = new Date()
  const date = new Date(dateTime)
  const diffMs = now - date
  const diffMins = Math.floor(diffMs / 60000)
  const diffHours = Math.floor(diffMs / 3600000)
  const diffDays = Math.floor(diffMs / 86400000)
  
  if (diffMins < 1) {
    return locale.value === 'zh' ? '刚刚' : 'Just now'
  } else if (diffMins < 60) {
    return locale.value === 'zh' ? `${diffMins}分钟前` : `${diffMins}m ago`
  } else if (diffHours < 24) {
    return locale.value === 'zh' ? `${diffHours}小时前` : `${diffHours}h ago`
  } else if (diffDays === 1) {
    return locale.value === 'zh' ? '昨天' : 'Yesterday'
  } else if (diffDays < 7) {
    return locale.value === 'zh' ? `${diffDays}天前` : `${diffDays}d ago`
  } else {
    return date.toLocaleDateString(locale.value === 'zh' ? 'zh-CN' : 'en-US', {
      month: 'short',
      day: 'numeric'
    })
  }
}

// 新建会话
const createNewSession = () => {
  currentSessionId.value = null
  chatHistory.value = []
  ElMessage.success(t('newChatCreated'))
}

// 删除会话
const deleteSession = async (sessionId) => {
  try {
    await ElMessageBox.confirm(t('deleteConfirm'), t('confirm'), {
      confirmButtonText: t('confirm'),
      cancelButtonText: t('cancel'),
      type: 'warning'
    })
    
    await deleteSessionApi(sessionId)
    ElMessage.success(t('deleteSuccess'))
    
    // 如果删除的是当前会话，清空对话
    if (currentSessionId.value === sessionId) {
      currentSessionId.value = null
      chatHistory.value = []
    }
    
    // 刷新会话列表
    await loadSessions()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除会话失败:', error)
      ElMessage.error(t('deleteFailed'))
    }
  }
}

// 加载年度报告
const loadAnnualReport = async () => {
  try {
    console.log('加载年度报告，年份:', annualYear.value)
    const res = await getAnnualReportApi(annualYear.value)
    console.log('年度报告API响应:', res)
    annualData.value = res.data
    
    await nextTick()
    
    if (!annualChart && annualChartRef.value) {
      annualChart = echarts.init(annualChartRef.value)
      console.log('年度报告图表已初始化')
    }
    
    if (!annualChart) {
      console.error('年度报告图表初始化失败')
      return
    }
    
    const monthlyTrend = annualData.value.monthlyTrend || []
    console.log('月度趋势数据:', monthlyTrend)
    
    annualChart.setOption({
      title: { 
        text: `${annualYear.value}${locale.value === 'zh' ? '年月度趋势' : ' Monthly Trend'}`,
        textStyle: { color: '#3d2f1f' }
      },
      tooltip: { trigger: 'axis' },
      legend: { 
        data: [
          locale.value === 'zh' ? '借展' : 'Loans',
          locale.value === 'zh' ? '保养' : 'Maintenance',
          locale.value === 'zh' ? '修复' : 'Repairs',
          locale.value === 'zh' ? '新增文物' : 'New Relics'
        ]
      },
      xAxis: {
        type: 'category',
        data: monthlyTrend.map(item => `${item.month}${locale.value === 'zh' ? '月' : ''}`)
      },
      yAxis: { type: 'value' },
      series: [
        {
          name: locale.value === 'zh' ? '借展' : 'Loans',
          type: 'line',
          data: monthlyTrend.map(item => item.loans),
          smooth: true,
          itemStyle: { color: '#4facfe' }
        },
        {
          name: locale.value === 'zh' ? '保养' : 'Maintenance',
          type: 'line',
          data: monthlyTrend.map(item => item.maintenance),
          smooth: true,
          itemStyle: { color: '#00f2fe' }
        },
        {
          name: locale.value === 'zh' ? '修复' : 'Repairs',
          type: 'line',
          data: monthlyTrend.map(item => item.repairs),
          smooth: true,
          itemStyle: { color: '#83bff6' }
        },
        {
          name: locale.value === 'zh' ? '新增文物' : 'New Relics',
          type: 'line',
          data: monthlyTrend.map(item => item.newRelics || 0),
          smooth: true,
          itemStyle: { color: '#188df0' }
        }
      ]
    })
  } catch (error) {
    console.error('加载年度报告失败:', error)
    ElMessage.error(locale.value === 'zh' ? '加载年度报告失败' : 'Failed to load annual report')
  }
}

// 加载趋势分析
const loadTrendAnalysis = async () => {
  if (!trendDateRange.value || trendDateRange.value.length !== 2) {
    ElMessage.warning(locale.value === 'zh' ? '请选择日期范围' : 'Please select date range')
    return
  }
  
  try {
    const [startDate, endDate] = trendDateRange.value
    console.log('加载趋势分析:', { startDate, endDate, type: trendType.value })
    const res = await getTrendAnalysisApi(startDate, endDate, trendType.value)
    console.log('趋势分析API响应:', res)
    
    await nextTick()
    
    if (!trendChart && trendChartRef.value) {
      trendChart = echarts.init(trendChartRef.value)
      console.log('趋势分析图表已初始化')
    }
    
    if (!trendChart) {
      console.error('趋势分析图表初始化失败')
      return
    }
    
    const dataPoints = res.data.dataPoints || []
    console.log('趋势数据点:', dataPoints)
    
    trendChart.setOption({
      title: { 
        text: locale.value === 'zh' ? '趋势分析' : 'Trend Analysis',
        textStyle: { color: '#3d2f1f' }
      },
      tooltip: { trigger: 'axis' },
      xAxis: {
        type: 'category',
        data: dataPoints.map(item => item.date)
      },
      yAxis: { type: 'value' },
      series: [{
        type: 'line',
        data: dataPoints.map(item => item.count),
        smooth: true,
        areaStyle: { color: 'rgba(79, 172, 254, 0.2)' },
        itemStyle: { color: '#4facfe' }
      }]
    })
  } catch (error) {
    console.error('加载趋势分析失败:', error)
    ElMessage.error(locale.value === 'zh' ? '加载趋势分析失败' : 'Failed to load trend analysis')
  }
}

// 加载对比分析
const loadComparisonAnalysis = async () => {
  try {
    console.log('加载对比分析:', { year1: comparisonYear1.value, year2: comparisonYear2.value })
    const res = await getComparisonAnalysisApi(comparisonYear1.value, comparisonYear2.value)
    console.log('对比分析API响应:', res)
    comparisonData.value = res.data
    
    await nextTick()
    
    if (!comparisonChart && comparisonChartRef.value) {
      comparisonChart = echarts.init(comparisonChartRef.value)
      console.log('对比分析图表已初始化')
    }
    
    if (!comparisonChart) {
      console.error('对比分析图表初始化失败')
      return
    }
    
    const { year1Data, year2Data } = comparisonData.value
    console.log('对比数据:', { year1Data, year2Data })
    
    comparisonChart.setOption({
      title: { 
        text: locale.value === 'zh' ? '年度对比' : 'Year Comparison',
        textStyle: { color: '#3d2f1f' }
      },
      tooltip: { trigger: 'axis' },
      legend: { 
        data: [
          `${comparisonYear1.value}${locale.value === 'zh' ? '年' : ''}`,
          `${comparisonYear2.value}${locale.value === 'zh' ? '年' : ''}`
        ]
      },
      xAxis: {
        type: 'category',
        data: [
          locale.value === 'zh' ? '借展' : 'Loans',
          locale.value === 'zh' ? '保养' : 'Maintenance',
          locale.value === 'zh' ? '修复' : 'Repairs',
          locale.value === 'zh' ? '文物' : 'Relics'
        ]
      },
      yAxis: { type: 'value' },
      series: [
        {
          name: `${comparisonYear1.value}${locale.value === 'zh' ? '年' : ''}`,
          type: 'bar',
          data: [year1Data.loans, year1Data.maintenance, year1Data.repairs, year1Data.relics || 0],
          itemStyle: { color: '#4facfe' }
        },
        {
          name: `${comparisonYear2.value}${locale.value === 'zh' ? '年' : ''}`,
          type: 'bar',
          data: [year2Data.loans, year2Data.maintenance, year2Data.repairs, year2Data.relics || 0],
          itemStyle: { color: '#00f2fe' }
        }
      ]
    })
  } catch (error) {
    console.error('加载对比分析失败:', error)
    ElMessage.error(locale.value === 'zh' ? '加载对比分析失败' : 'Failed to load comparison analysis')
  }
}

// 加载数据大屏数据
const loadDashboardData = async () => {
  try {
    console.log('开始加载数据大屏数据...')
    const res = await getDashboardDataApi()
    console.log('数据大屏API响应:', res)
    dashboardData.value = res.data || {}
    console.log('数据大屏数据已设置:', dashboardData.value)
    
    await nextTick()
    updateDashboardCharts()
  } catch (error) {
    console.error('加载数据大屏失败:', error)
    ElMessage.error(locale.value === 'zh' ? '加载数据大屏失败' : 'Failed to load dashboard')
  }
}

// 初始化数据大屏图表
const initDashboardCharts = () => {
  console.log('初始化数据大屏图表...')
  console.log('图表ref状态:', {
    category: !!categoryChartPortalRef.value,
    status: !!statusChartPortalRef.value,
    era: !!eraChartPortalRef.value
  })
  console.log('图表实例状态:', {
    categoryChart: !!categoryChartPortal,
    statusChart: !!statusChartPortal,
    eraChart: !!eraChartPortal
  })
  
  if (categoryChartPortalRef.value && !categoryChartPortal) {
    const width = categoryChartPortalRef.value.clientWidth
    const height = categoryChartPortalRef.value.clientHeight
    console.log('分类图表容器尺寸:', { width, height })
    if (width > 0 && height > 0) {
      categoryChartPortal = echarts.init(categoryChartPortalRef.value)
      console.log('✅ 分类图表已初始化')
    } else {
      console.error('❌ 分类图表容器尺寸为0，无法初始化')
    }
  }
  if (statusChartPortalRef.value && !statusChartPortal) {
    const width = statusChartPortalRef.value.clientWidth
    const height = statusChartPortalRef.value.clientHeight
    console.log('状态图表容器尺寸:', { width, height })
    if (width > 0 && height > 0) {
      statusChartPortal = echarts.init(statusChartPortalRef.value)
      console.log('✅ 状态图表已初始化')
    } else {
      console.error('❌ 状态图表容器尺寸为0')
    }
  }
  if (eraChartPortalRef.value && !eraChartPortal) {
    const width = eraChartPortalRef.value.clientWidth
    const height = eraChartPortalRef.value.clientHeight
    console.log('年代图表容器尺寸:', { width, height })
    if (width > 0 && height > 0) {
      eraChartPortal = echarts.init(eraChartPortalRef.value)
      console.log('✅ 年代图表已初始化')
    } else {
      console.error('❌ 年代图表容器尺寸为0')
    }
  }
  
  // 添加窗口resize监听（只添加一次）
  if (!window.__portalChartsResizeAdded) {
    window.addEventListener('resize', () => {
      categoryChartPortal?.resize()
      statusChartPortal?.resize()
      eraChartPortal?.resize()
    })
    window.__portalChartsResizeAdded = true
  }
}

// 更新数据大屏图表
const updateDashboardCharts = () => {
  console.log('开始更新数据大屏图表...')
  console.log('图表实例状态:', {
    category: !!categoryChartPortal,
    status: !!statusChartPortal,
    era: !!eraChartPortal
  })
  
  // 分类统计
  if (categoryChartPortal) {
    if (dashboardData.value.categoryStats && dashboardData.value.categoryStats.length > 0) {
      console.log('更新分类图表，数据:', dashboardData.value.categoryStats)
      const categoryData = dashboardData.value.categoryStats.map(item => ({
        name: translateCategoryName(item.categoryName || item.category_name),
        value: item.count
      }))
      
      categoryChartPortal.setOption({
        tooltip: { 
          trigger: 'item',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#e0e6ed',
          textStyle: { color: '#333' }
        },
        series: [{
          type: 'pie',
          radius: '65%',
          center: ['50%', '50%'],
          data: categoryData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(64, 158, 255, 0.3)'
            }
          },
          label: { 
            color: '#333', 
            fontSize: 14,
            formatter: '{b}\n{d}%'
          },
          color: ['#409eff', '#67c23a', '#e6a23c', '#f56c6c', '#909399', '#00d4ff']
        }]
      })
    } else {
      categoryChartPortal.setOption({
        title: {
          text: t('common.noData'),
          left: 'center',
          top: 'center',
          textStyle: { color: '#999', fontSize: 14 }
        },
        series: []
      })
    }
  }
  
  // 状态分布
  if (statusChartPortal) {
    const statusData = [
      { name: t('relic.inStock'), value: dashboardData.value.inStockRelics || 0 },
      { name: t('relic.onLoan'), value: dashboardData.value.loaningRelics || 0 },
      { name: t('relic.repairing'), value: dashboardData.value.repairingRelics || 0 }
    ]
    
    statusChartPortal.setOption({
      tooltip: { 
        trigger: 'axis', 
        axisPointer: { type: 'shadow' },
        backgroundColor: 'rgba(255, 255, 255, 0.95)',
        borderColor: '#e0e6ed',
        textStyle: { color: '#333' }
      },
      grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
      xAxis: {
        type: 'category',
        data: statusData.map(item => item.name),
        axisLabel: { color: '#666', fontSize: 12 },
        axisLine: { lineStyle: { color: '#e0e6ed' } }
      },
      yAxis: {
        type: 'value',
        axisLabel: { color: '#666', fontSize: 12 },
        splitLine: { lineStyle: { color: '#e0e6ed' } }
      },
      series: [{
        type: 'bar',
        data: statusData.map(item => item.value),
        itemStyle: {
          color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
            { offset: 0, color: '#409eff' },
            { offset: 1, color: '#0066cc' }
          ])
        },
        barWidth: '50%'
      }]
    })
  }
  
  // 年代分布
  if (eraChartPortal) {
    if (dashboardData.value.eraStats && dashboardData.value.eraStats.length > 0) {
      const eraData = dashboardData.value.eraStats.map(item => ({
        name: translateEra(item.era),
        value: item.count
      }))
      
      eraChartPortal.setOption({
        tooltip: { 
          trigger: 'item',
          backgroundColor: 'rgba(255, 255, 255, 0.95)',
          borderColor: '#e0e6ed',
          textStyle: { color: '#333' }
        },
        series: [{
          type: 'pie',
          radius: '65%',
          center: ['50%', '50%'],
          data: eraData,
          emphasis: {
            itemStyle: {
              shadowBlur: 10,
              shadowOffsetX: 0,
              shadowColor: 'rgba(64, 158, 255, 0.3)'
            }
          },
          label: { 
            color: '#333', 
            fontSize: 14,
            formatter: '{b}\n{d}%'
          },
          color: ['#409eff', '#67c23a', '#e6a23c', '#f56c6c', '#909399', '#00d4ff', '#ff6b9d', '#c990ff']
        }]
      })
    } else {
      eraChartPortal.setOption({
        title: {
          text: t('common.noData'),
          left: 'center',
          top: 'center',
          textStyle: { color: '#999', fontSize: 14 }
        },
        series: []
      })
    }
  }
}

onMounted(async () => {
  // 初始化借展表单的用户信息和博物馆
  loanForm.borrowerName = sessionStorage.getItem('realName') || sessionStorage.getItem('username') || ''
  loanForm.borrowerPhone = sessionStorage.getItem('phone') || ''
  loanForm.borrowerUnit = sessionStorage.getItem('museumName') || ''
  
  try {
    await loadStatistics()
    await loadCategories()
    await searchRelics()
    await loadAvailableRelics()
    await loadSessions()
    
    // 如果页面加载时就在数据大屏页面（刷新场景），需要初始化图表
    if (activeSection.value === 'data-screen') {
      await nextTick()
      setTimeout(() => {
        initDashboardCharts()
        loadDashboardData()
      }, 300)
    } else if (activeSection.value === 'my-loans') {
      // 如果页面加载时在我的借展页面，加载数据
      console.log('页面加载时在我的借展页面，加载数据...')
      loadMyLoansStats()
      loadMyLoans()
    }
  } catch (error) {
    console.error('=== 数据加载失败 ===', error)
    console.error('错误详情:', error.message)
    console.error('错误堆栈:', error.stack)
    ElMessage.error(t('pageLoadFailed'))
  }
})

onUnmounted(() => {
  // 清理图表实例
  if (categoryChartPortal) {
    categoryChartPortal.dispose()
    categoryChartPortal = null
  }
  if (statusChartPortal) {
    statusChartPortal.dispose()
    statusChartPortal = null
  }
  if (eraChartPortal) {
    eraChartPortal.dispose()
    eraChartPortal = null
  }
  if (annualChart) {
    annualChart.dispose()
    annualChart = null
  }
  if (trendChart) {
    trendChart.dispose()
    trendChart = null
  }
  if (comparisonChart) {
    comparisonChart.dispose()
    comparisonChart = null
  }
})
</script>

<style scoped>
.public-portal {
  min-height: 100vh;
  background: linear-gradient(135deg, var(--bg-aside) 0%, var(--bg-main) 100%);
  transition: background 0.3s ease;
}

/* 顶部导航栏 */
.portal-header {
  background: var(--bg-aside);
  color: var(--text-primary);
  padding: 20px 0;
  box-shadow: 0 2px 4px rgba(139, 111, 71, 0.08);
  position: sticky;
  top: 0;
  z-index: 1000;
  border-bottom: 1px solid var(--border-light);
  transition: background-color 0.3s ease, border-color 0.3s ease;
}

.header-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 20px;
  position: relative;
}

.header-right {
  position: absolute;
  top: 20px;
  right: 20px;
  display: flex;
  align-items: center;
  gap: 12px;
}

.user-info-below {
  display: flex;
  align-items: center;
  gap: 8px;
  color: var(--text-secondary);
  background: transparent;
  padding: 0;
  border-radius: 0;
  font-size: 14px;
  border: none;
  margin-top: 8px;
  width: fit-content;
}

.user-info-below .username-link {
  color: var(--color-primary-light);
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s;
}

.user-info-below .username-link:hover {
  color: var(--color-primary);
  text-decoration: underline;
}

.logo-section h1 {
  margin: 0;
  font-size: 28px;
  font-weight: 600;
  color: var(--text-primary);
}

.subtitle {
  margin: 5px 0 0;
  font-size: 14px;
  opacity: 0.8;
  color: var(--text-light);
}

.nav-menu {
  display: flex;
  gap: 8px;
  margin-top: 20px;
  flex-wrap: wrap;
}

.nav-menu a {
  color: var(--text-tertiary);
  text-decoration: none;
  padding: 10px 18px;
  border-radius: 10px;
  transition: all 0.3s;
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--bg-main);
  border: 1px solid var(--border-light);
}

.nav-menu a:hover {
  background: var(--bg-hover);
  transform: translateY(-1px);
  border-color: var(--color-primary);
  color: var(--color-primary);
}

.nav-menu a.active {
  background: var(--color-primary);
  color: #ffffff;
  font-weight: 500;
  border-color: var(--color-primary);
}

/* 主内容区 */
.portal-main {
  max-width: 1400px;
  margin: 0 auto;
  padding: 40px 20px;
  min-height: calc(100vh - 200px);
}

.section-title {
  font-size: 32px;
  margin-bottom: 30px;
  color: #3d2f1f;
  text-align: center;
  font-weight: 600;
}

/* 首页 */
.hero-banner {
  text-align: center;
  padding: 80px 20px;
  background: linear-gradient(135deg, #fff9f0 0%, #fef5e7 100%);
  border-radius: 20px;
  box-shadow: 0 4px 16px rgba(43, 33, 24, 0.08);
  margin-bottom: 40px;
  border: 1px solid rgba(203, 164, 115, 0.15);
}

.hero-banner h2 {
  font-size: 48px;
  margin: 0 0 20px;
  background: linear-gradient(135deg, #8b6f47 0%, #5d4a2f 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  font-weight: 700;
}

.hero-banner p {
  font-size: 20px;
  color: #6b5744;
  margin-bottom: 40px;
}

.hero-actions {
  display: flex;
  gap: 20px;
  justify-content: center;
}

.feature-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
}

.feature-card {
  background: linear-gradient(135deg, #ffffff 0%, #fefdfb 100%);
  padding: 40px 30px;
  border-radius: 16px;
  text-align: center;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 2px 12px rgba(43, 33, 24, 0.06);
  border: 1px solid rgba(203, 164, 115, 0.12);
}

.feature-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 8px 24px rgba(43, 33, 24, 0.12);
  border-color: rgba(203, 164, 115, 0.25);
}

.feature-icon {
  font-size: 48px;
  color: #a67c52;
  margin-bottom: 20px;
}

.feature-card h3 {
  font-size: 24px;
  margin: 0 0 12px;
  color: #3d2f1f;
  font-weight: 600;
}

.feature-card p {
  color: #6b5744;
  margin: 0;
  line-height: 1.6;
}

/* 数据大屏 */
.section-data-screen {
  background: linear-gradient(135deg, #fdfbf7 0%, #f5ede0 100%);
  border-radius: 20px;
  padding: 40px;
  margin: -20px;
}

.screen-content-portal {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

/* 核心指标 */
.metrics-row-portal {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.metric-card-portal {
  background: #fbf6ee;
  border-radius: 8px;
  padding: 24px;
  text-align: center;
  border: 1px solid #eee3d3;
  transition: all 0.3s;
  cursor: pointer;
}

.metric-card-portal:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border-color: #d4c4a8;
}

.metric-icon-portal {
  font-size: 40px;
  margin-bottom: 12px;
}

.metric-value-portal {
  font-size: 36px;
  font-weight: 600;
  margin-bottom: 8px;
  color: #8b6f47;
}

.metric-label-portal {
  font-size: 14px;
  color: #6c5037;
  margin-bottom: 8px;
}

/* 第一行图表：分类统计和年代分布 */
.charts-row-top-portal {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 16px;
  margin-bottom: 20px;
}

/* 第二行：状态分布和业务统计 */
.charts-row-bottom-portal {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 20px;
}

/* 图表卡片 */
.chart-card-portal {
  background: #fbf6ee;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #eee3d3;
  transition: all 0.3s;
}

.chart-card-portal:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.chart-large-portal {
  min-width: 0;
}

.chart-status-portal {
  min-width: 0;
}

.chart-header-portal {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee3d3;
}

.chart-title-portal {
  font-size: 16px;
  font-weight: 600;
  color: #4f4235;
}

.chart-container-large-portal {
  height: 400px;
}

.chart-container-status-portal {
  height: 380px;
}

/* 业务统计 */
.business-card-portal {
  background: #fbf6ee;
  border-radius: 8px;
  padding: 20px;
  border: 1px solid #eee3d3;
  display: flex;
  flex-direction: column;
}

.business-title-portal {
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 1px solid #eee3d3;
  color: #4f4235;
}

.business-stats-portal {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 12px;
  flex: 1;
  align-content: start;
}

.stat-item-portal {
  text-align: center;
  padding: 20px 12px;
  background: #ffffff;
  border-radius: 8px;
  transition: all 0.3s;
  cursor: pointer;
  border: 1px solid #eee3d3;
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.stat-item-portal:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border-color: #d4c4a8;
}

.stat-label-portal {
  display: block;
  font-size: 12px;
  color: #6c5037;
  margin-bottom: 10px;
}

.stat-value-portal {
  display: block;
  font-size: 28px;
  font-weight: 600;
  color: #8b6f47;
}

.stat-value-portal.success {
  color: #67c23a;
}

.stat-value-portal.warning {
  color: #e6a23c;
}

.stat-value-portal.danger {
  color: #f56c6c;
}

.stat-value-portal.info {
  color: #409eff;
}

/* 响应式 */
@media (max-width: 1400px) {
  .charts-row-top-portal {
    grid-template-columns: 1fr;
  }
  
  .charts-row-bottom-portal {
    grid-template-columns: 1fr;
  }
  
  .business-stats-portal {
    grid-template-columns: repeat(5, 1fr);
  }
}

@media (max-width: 1200px) {
  .metrics-row-portal {
    grid-template-columns: repeat(2, 1fr);
  }
  
  .business-stats-portal {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 768px) {
  .metrics-row-portal {
    grid-template-columns: 1fr;
  }
  
  .charts-row-top-portal {
    grid-template-columns: 1fr;
  }
  
  .charts-row-bottom-portal {
    grid-template-columns: 1fr;
  }
  
  .business-stats-portal {
    grid-template-columns: repeat(2, 1fr);
  }
}

/* 数据报表 */
.reports-container {
  max-width: 1200px;
  margin: 0 auto;
}

.report-card {
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(43, 33, 24, 0.06);
  border: 1px solid rgba(203, 164, 115, 0.12);
}

.report-card :deep(.el-card__header) {
  background: linear-gradient(135deg, #fefdfb 0%, #faf7f2 100%);
  border-bottom: 1px solid rgba(203, 164, 115, 0.15);
  color: #3d2f1f;
  font-weight: 600;
}

.report-card :deep(.el-tabs__header) {
  background: linear-gradient(135deg, #fefdfb 0%, #faf7f2 100%);
}

.report-card :deep(.el-tabs__item) {
  color: #6b5744;
}

.report-card :deep(.el-tabs__item.is-active) {
  color: #a67c52;
}

.tab-content {
  padding: 20px;
}

.toolbar {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
}

.summary-cards {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  margin-bottom: 30px;
}

@media (max-width: 1200px) {
  .summary-cards {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .summary-cards {
    grid-template-columns: 1fr;
  }
}

.summary-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border-radius: 12px;
  padding: 30px;
  text-align: center;
  color: #fff9f0;
  box-shadow: 0 4px 12px rgba(43, 33, 24, 0.15);
  transition: all 0.3s;
}

.summary-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 20px rgba(43, 33, 24, 0.2);
}

.card-label {
  font-size: 16px;
  margin-bottom: 10px;
  opacity: 0.9;
}

.card-value {
  font-size: 36px;
  font-weight: bold;
}

.chart {
  margin-top: 20px;
  background: linear-gradient(135deg, #ffffff 0%, #fefdfb 100%);
  border-radius: 12px;
  padding: 20px;
  border: 1px solid rgba(203, 164, 115, 0.12);
}

.comparison-content {
  margin-top: 20px;
}

.growth-rate {
  margin-top: 30px;
}

.growth-rate h3 {
  margin-bottom: 15px;
  color: #3d2f1f;
  font-weight: 600;
}

.positive {
  color: #52c41a;
  font-weight: bold;
}

.negative {
  color: #f5222d;
  font-weight: bold;
}

/* 文物搜索 */
.search-bar {
  display: flex;
  gap: 12px;
  margin-bottom: 30px;
  flex-wrap: wrap;
  background: white;
  padding: 24px;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.relics-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 24px;
  margin-bottom: 30px;
}

.relic-card {
  background: white;
  border-radius: 16px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.3s;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.relic-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
}

.relic-image {
  width: 100%;
  height: 200px;
  overflow: hidden;
  background: #f5f5f5;
}

.relic-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s;
}

.relic-card:hover .relic-image img {
  transform: scale(1.1);
}

.relic-info {
  padding: 20px;
}

.relic-info h3 {
  margin: 0 0 8px;
  font-size: 18px;
  color: #333;
}

.relic-era {
  color: #666;
  font-size: 14px;
  margin: 4px 0;
}

.relic-category {
  color: #999;
  font-size: 13px;
  margin: 4px 0 12px;
}

.pagination {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

/* 分类搜索 */
.section-categories {
  animation: fadeIn 0.6s ease-in-out;
}

.categories-intro {
  text-align: center;
  margin-bottom: 40px;
  padding: 0 20px;
}

.categories-intro p {
  font-size: 18px;
  color: #6b5744;
  line-height: 1.8;
  max-width: 800px;
  margin: 0 auto;
}

.categories-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 30px;
  padding: 0 10px;
}

@media (max-width: 768px) {
  .categories-grid {
    grid-template-columns: 1fr;
  }
}

.category-card {
  position: relative;
  background: white;
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 4px 20px rgba(43, 33, 24, 0.08);
  overflow: hidden;
  border: 2px solid transparent;
}

.category-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 5px;
  background: linear-gradient(90deg, #a67c52 0%, #8b6f47 100%);
  transform: scaleX(0);
  transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}

.category-card:hover::before {
  transform: scaleX(1);
}

.category-card:hover {
  transform: translateY(-12px) scale(1.02);
  box-shadow: 0 20px 40px rgba(43, 33, 24, 0.18);
  border-color: rgba(166, 124, 82, 0.3);
}

/* 不同颜色主题 */
.category-card-0 { --theme-color: #a67c52; --theme-light: #f5ede0; }
.category-card-1 { --theme-color: #8b6f47; --theme-light: #ede0cf; }
.category-card-2 { --theme-color: #c9a882; --theme-light: #faf7f2; }
.category-card-3 { --theme-color: #b89968; --theme-light: #f0e6d6; }
.category-card-4 { --theme-color: #9d7e54; --theme-light: #f5ede0; }
.category-card-5 { --theme-color: #7a6c5b; --theme-light: #e8dfd0; }

.category-card-inner {
  padding: 40px 30px;
  position: relative;
  z-index: 2;
  text-align: center;
}

.category-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: linear-gradient(135deg, var(--theme-light, #f5ede0) 0%, rgba(255, 255, 255, 0.9) 100%);
  opacity: 0;
  transition: opacity 0.4s;
  z-index: 1;
}

.category-card:hover .category-overlay {
  opacity: 1;
}

.category-icon-wrapper {
  position: relative;
  display: inline-block;
  margin-bottom: 20px;
}

.category-icon {
  font-size: 72px;
  margin-bottom: 0;
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-block;
  filter: drop-shadow(0 4px 8px rgba(43, 33, 24, 0.1));
}

.category-card:hover .category-icon {
  transform: scale(1.15) rotate(5deg);
  filter: drop-shadow(0 8px 16px rgba(43, 33, 24, 0.2));
}

.category-badge {
  position: absolute;
  top: -5px;
  right: -10px;
  background: linear-gradient(135deg, #ff6b6b 0%, #ee5a6f 100%);
  color: white;
  font-size: 12px;
  font-weight: bold;
  padding: 4px 10px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(238, 90, 111, 0.4);
  animation: pulse 2s infinite;
}

@keyframes pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
}

.category-card h3 {
  font-size: 24px;
  margin: 0 0 12px;
  color: #3d2f1f;
  font-weight: 700;
  transition: all 0.3s;
  letter-spacing: 0.5px;
}

.category-card:hover h3 {
  color: var(--theme-color, #a67c52);
  transform: translateY(-2px);
}

.category-desc {
  color: #6b5744;
  font-size: 15px;
  margin: 0 0 20px;
  min-height: 48px;
  line-height: 1.6;
  transition: all 0.3s;
}

.category-card:hover .category-desc {
  color: #5d4a2f;
}

.category-divider {
  height: 2px;
  background: linear-gradient(90deg, transparent 0%, var(--theme-color, #a67c52) 50%, transparent 100%);
  margin: 20px 0;
  opacity: 0.3;
  transition: opacity 0.3s;
}

.category-card:hover .category-divider {
  opacity: 0.6;
}

.category-action {
  text-align: center;
  margin-top: 20px;
}

.category-action .el-button {
  transition: all 0.3s;
  background: linear-gradient(135deg, var(--theme-color, #a67c52) 0%, var(--theme-color, #8b6f47) 100%);
  border: none;
  padding: 10px 24px;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(166, 124, 82, 0.3);
}

.category-action .el-button:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(166, 124, 82, 0.4);
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* 申请借展 */
.loan-form-card {
  max-width: 800px;
  margin: 0 auto;
  border-radius: 16px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* AI搜索 - ChatGPT风格布局 */
.section-ai {
  padding: 0;
  margin: -20px;
  height: calc(100vh - 200px);
  min-height: 600px;
}

.section-ai .section-title {
  display: none;
}

.ai-container {
  display: flex;
  flex-direction: row;
  gap: 0;
  height: 100%;
  width: 100%;
  border-radius: 0;
  overflow: hidden;
  box-shadow: none;
  background: #fdfbf7;
}

.ai-sidebar {
  width: 260px;
  min-width: 260px;
  max-width: 260px;
  background: #fdfbf7;
  display: flex;
  flex-direction: column;
  overflow: hidden;
  border-right: 1px solid #eadfce;
  flex-shrink: 0;
  height: 100%;
}

.sidebar-header {
  padding: 16px 16px;
  border-bottom: 1px solid #eadfce;
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #fdfbf7;
}

.sidebar-logo {
  display: flex;
  align-items: center;
  gap: 8px;
}

.logo-icon {
  font-size: 20px;
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-3px);
  }
}

.logo-text {
  font-size: 15px;
  font-weight: 600;
  color: #5d4a2f;
}

.new-chat-btn {
  width: 32px;
  height: 32px;
  background: linear-gradient(135deg, #a67c52 0%, #8b6f47 100%);
  border: none;
  color: #ffffff;
  transition: all 0.3s;
  padding: 0;
  border-radius: 6px;
}

.new-chat-btn:hover {
  background: linear-gradient(135deg, #8b6f47 0%, #6d5638 100%);
  transform: scale(1.05);
}

.sidebar-content {
  flex: 1;
  overflow-y: auto;
  padding: 12px;
  background: #fdfbf7;
}

.sidebar-content::-webkit-scrollbar {
  width: 6px;
}

.sidebar-content::-webkit-scrollbar-track {
  background: transparent;
}

.sidebar-content::-webkit-scrollbar-thumb {
  background: #c9a882;
  border-radius: 3px;
}

.sidebar-content::-webkit-scrollbar-thumb:hover {
  background: #a67c52;
}

.empty-sessions {
  padding: 60px 20px;
  text-align: center;
}

.empty-icon {
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.3;
}

.empty-text {
  font-size: 14px;
  color: #6c5037;
  margin: 0 0 8px;
  font-weight: 500;
}

.empty-hint {
  font-size: 12px;
  color: #8b7355;
  margin: 0;
  line-height: 1.4;
}

.sessions-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.session-item {
  padding: 10px 12px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  gap: 10px;
  background: transparent;
  position: relative;
  overflow: hidden;
}

.session-item:hover {
  background: #f5ede0;
}

.session-item.active {
  background: #fef5e7;
  border-left: 3px solid #a67c52;
}

.session-icon {
  width: 32px;
  height: 32px;
  border-radius: 8px;
  background: linear-gradient(135deg, #a67c52 0%, #8b6f47 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 16px;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.2);
}

.session-item.active .session-icon {
  background: linear-gradient(135deg, #3370ff 0%, #2b5dd1 100%);
  box-shadow: 0 2px 8px rgba(51, 112, 255, 0.3);
}

.session-info {
  flex: 1;
  min-width: 0;
}

.session-title {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #1f2329;
  line-height: 1.4;
}

.session-item.active .session-title {
  color: #a67c52;
  font-weight: 500;
}

.session-time {
  font-size: 12px;
  color: #8b7355;
  line-height: 1.2;
}

.session-actions {
  opacity: 0;
  transition: opacity 0.2s;
}

.session-item:hover .session-actions {
  opacity: 1;
}

.delete-btn {
  width: 24px;
  height: 24px;
  color: #f54a45;
  transition: all 0.2s;
  padding: 0;
}

.delete-btn:hover {
  background: #fee;
  transform: scale(1.1);
}

.sidebar-footer {
  padding: 16px;
  border-top: 1px solid #eadfce;
  background: #fdfbf7;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 8px;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.2s;
}

.user-profile:hover {
  background: #f5ede0;
}

.profile-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: linear-gradient(135deg, #a67c52 0%, #8b6f47 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 18px;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(166, 124, 82, 0.3);
}

.profile-info {
  flex: 1;
  min-width: 0;
}

.profile-name {
  font-size: 14px;
  font-weight: 500;
  color: #5d4a2f;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  margin-bottom: 2px;
}

.profile-status {
  font-size: 12px;
  color: #00c160;
  display: flex;
  align-items: center;
  gap: 4px;
}

.profile-status::before {
  content: '';
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #00c160;
  box-shadow: 0 0 8px rgba(0, 193, 96, 0.6);
  animation: pulse-dot 2s infinite;
}

@keyframes pulse-dot {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.ai-chat-box {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  background: #fdfbf7;
  overflow: hidden;
  height: 100%;
}

.chat-messages {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  background: #fdfbf7;
  height: 100%;
  padding: 0;
}

.chat-messages::-webkit-scrollbar {
  width: 6px;
}

.chat-messages::-webkit-scrollbar-track {
  background: transparent;
}

.chat-messages::-webkit-scrollbar-thumb {
  background: #c9a882;
  border-radius: 3px;
}

.chat-messages::-webkit-scrollbar-thumb:hover {
  background: #a67c52;
}

.welcome-message {
  text-align: center;
  padding: 100px 40px;
  color: #5d4a2f;
  max-width: 800px;
  margin: 0 auto;
}

.welcome-icon {
  font-size: 72px;
  margin-bottom: 24px;
  animation: float 3s ease-in-out infinite;
}

.welcome-message h3 {
  font-size: 32px;
  color: #1f2329;
  margin: 0 0 16px;
  font-weight: 600;
}

.welcome-message p {
  font-size: 16px;
  margin: 0 0 40px;
  color: #646a73;
  line-height: 1.6;
}

.example-queries {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 12px;
  max-width: 600px;
  margin: 0 auto;
}

@media (max-width: 768px) {
  .example-queries {
    grid-template-columns: 1fr;
  }
}

.example-queries .el-tag {
  cursor: pointer;
  transition: all 0.3s;
  background: #ffffff;
  border: 1px solid #e5e5e6;
  color: #1f2329;
  padding: 14px 20px;
  font-size: 14px;
  border-radius: 8px;
  text-align: center;
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

.example-queries .el-tag:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(51, 112, 255, 0.15);
  border-color: #3370ff;
  color: #3370ff;
}

.message-group {
  margin-bottom: 0;
  animation: fadeInUp 0.4s ease-out;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.message {
  display: flex;
  gap: 16px;
  padding: 24px 20px;
  transition: background 0.2s;
  max-width: 900px;
  margin: 0 auto;
}

.message:hover {
  background: rgba(0, 0, 0, 0.02);
}

.user-message {
  background: #ffffff;
}

.ai-message {
  background: #f7f7f8;
}

.message-avatar {
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
  font-size: 18px;
  flex-shrink: 0;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.user-message .message-avatar {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.ai-avatar {
  background: linear-gradient(135deg, #3370ff 0%, #2b5dd1 100%);
}

.message-content {
  flex: 1;
  max-width: 100%;
}

.message-text {
  padding: 0;
  border-radius: 0;
  word-wrap: break-word;
  line-height: 1.7;
  font-size: 15px;
  color: #1f2329;
  white-space: pre-wrap;
}

.message-text.typing {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #646a73;
}

.message-time {
  font-size: 12px;
  color: #8f959e;
  margin-top: 8px;
  padding: 0;
}

.message-relics {
  margin-top: 16px;
  display: grid;
  gap: 12px;
}

.relic-card-mini {
  background: linear-gradient(135deg, #fefdfb 0%, #faf7f2 100%);
  border-radius: 12px;
  padding: 16px;
  border: 1px solid rgba(203, 164, 115, 0.2);
  transition: all 0.3s;
}

.relic-card-mini:hover {
  box-shadow: 0 4px 16px rgba(43, 33, 24, 0.12);
  transform: translateY(-2px);
  border-color: rgba(203, 164, 115, 0.35);
}

.relic-card-mini.external-relic {
  border-color: #d4a574;
  background: linear-gradient(135deg, #fff9f0 0%, #fef5e7 100%);
}

.relic-card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
  padding-bottom: 12px;
  border-bottom: 1px solid rgba(203, 164, 115, 0.15);
}

.relic-card-title {
  display: flex;
  align-items: center;
  gap: 8px;
  flex: 1;
}

.relic-card-title h4 {
  margin: 0;
  font-size: 16px;
  color: #3d2f1f;
  font-weight: 600;
}

.relic-card-body {
  display: flex;
  gap: 16px;
  margin-bottom: 12px;
}

.relic-card-image {
  width: 120px;
  height: 120px;
  border-radius: 8px;
  overflow: hidden;
  background: linear-gradient(135deg, #faf7f2 0%, #f5ede0 100%);
  flex-shrink: 0;
  border: 1px solid rgba(203, 164, 115, 0.15);
}

.relic-card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.relic-card-info {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 8px;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.info-item .label {
  font-size: 12px;
  color: #8b7355;
}

.info-item .value {
  font-size: 14px;
  color: #3d2f1f;
  font-weight: 500;
}

.relic-card-description {
  font-size: 14px;
  color: #6b5744;
  line-height: 1.6;
  margin-bottom: 12px;
  max-height: 60px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 3;
  -webkit-box-orient: vertical;
}

.relic-card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 12px;
  border-top: 1px solid rgba(203, 164, 115, 0.15);
}

.relevance-bar {
  flex: 1;
}

.relevance-bar span {
  font-size: 12px;
  color: #6b5744;
  display: block;
  margin-bottom: 4px;
}

.progress-bar {
  height: 6px;
  background: rgba(203, 164, 115, 0.15);
  border-radius: 3px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  transition: width 0.3s;
  border-radius: 3px;
}

.chat-input {
  padding: 24px;
  background: linear-gradient(to top, #f5ede0, #fdfbf7);
  border-top: 1px solid #eadfce;
  flex-shrink: 0;
}

.chat-input-container {
  max-width: 900px;
  margin: 0 auto;
  display: flex;
  align-items: flex-end;
  gap: 12px;
  background: #ffffff;
  padding: 12px;
  border-radius: 24px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  transition: all 0.3s ease;
}

.chat-input-container:hover {
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.12);
}

.chat-input-container:focus-within {
  box-shadow: 0 4px 24px rgba(51, 112, 255, 0.2);
  border: 1px solid rgba(51, 112, 255, 0.3);
}

.input-wrapper {
  flex: 1;
  display: flex;
  align-items: center;
}

.chat-input :deep(.chat-textarea) {
  flex: 1;
}

.chat-input :deep(.chat-textarea .el-textarea__inner) {
  border: none;
  background: transparent;
  box-shadow: none;
  padding: 8px 12px;
  font-size: 15px;
  line-height: 1.6;
  color: #1f2329;
  resize: none;
  min-height: 40px !important;
}

.chat-input :deep(.chat-textarea .el-textarea__inner:focus) {
  border: none;
  box-shadow: none;
}

.chat-input :deep(.chat-textarea .el-textarea__inner::placeholder) {
  color: #8f959e;
}

.send-button {
  flex-shrink: 0;
  width: 48px;
  height: 48px;
  background: linear-gradient(135deg, #a67c52 0%, #8b6f47 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(166, 124, 82, 0.4);
  transition: all 0.3s ease;
}

.send-button:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.05);
  box-shadow: 0 6px 20px rgba(166, 124, 82, 0.5);
  background: linear-gradient(135deg, #8b6f47 0%, #6d5638 100%);
}

.send-button:active:not(:disabled) {
  transform: translateY(0) scale(0.98);
}

.send-button:disabled {
  background: #e5e5e6;
  box-shadow: none;
  cursor: not-allowed;
}

.send-button :deep(.el-icon) {
  color: white;
}

/* AI搜索响应式 */
@media (max-width: 768px) {
  .ai-container {
    flex-direction: column;
  }
  
  .ai-sidebar {
    width: 100%;
    min-width: 100%;
    max-width: 100%;
    height: 280px;
    border-right: none;
    border-bottom: 1px solid #e5e5e6;
  }
  
  .ai-chat-box {
    height: calc(100% - 280px);
  }
}

/* 文物详情 */
.relic-detail-image {
  margin-top: 20px;
  text-align: center;
}

.relic-detail-image img {
  max-width: 100%;
  max-height: 400px;
  border-radius: 12px;
  box-shadow: 0 4px 16px rgba(43, 33, 24, 0.12);
  border: 1px solid rgba(203, 164, 115, 0.15);
}

/* 页脚 */
.portal-footer {
  background: linear-gradient(180deg, #8b6f47, #6d5638);
  color: #fdfbf7;
  text-align: center;
  padding: 30px 20px;
  margin-top: 60px;
  border-top: 1px solid rgba(166, 124, 82, 0.3);
}

.portal-footer p {
  margin: 0;
  font-size: 14px;
}

/* 我的借展 */
.section-my-loans {
  padding: 30px;
  max-width: 1400px;
  margin: 0 auto;
}

.my-loans-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 20px;
  margin-bottom: 30px;
}

.stat-card-my-loans {
  background: white;
  border-radius: 12px;
  padding: 24px;
  display: flex;
  align-items: center;
  gap: 20px;
  box-shadow: 0 2px 12px rgba(43, 33, 24, 0.08);
  border: 1px solid rgba(203, 164, 115, 0.15);
  transition: all 0.3s ease;
}

.stat-card-my-loans:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 24px rgba(43, 33, 24, 0.12);
}

.stat-icon-my-loans {
  width: 56px;
  height: 56px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 24px;
  color: white;
}

.stat-content-my-loans {
  flex: 1;
}

.stat-value-my-loans {
  font-size: 32px;
  font-weight: 700;
  color: #2b2118;
  line-height: 1;
  margin-bottom: 8px;
}

.stat-label-my-loans {
  font-size: 14px;
  color: #8b7355;
}

.my-loans-filter {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  padding: 20px;
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 12px rgba(43, 33, 24, 0.08);
  border: 1px solid rgba(203, 164, 115, 0.15);
}

.my-loans-list {
  display: flex;
  flex-direction: column;
  gap: 20px;
  min-height: 400px;
}

.my-loan-item {
  background: white;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 12px rgba(43, 33, 24, 0.08);
  border: 1px solid rgba(203, 164, 115, 0.15);
  transition: all 0.3s ease;
}

.my-loan-item:hover {
  box-shadow: 0 6px 24px rgba(43, 33, 24, 0.12);
  transform: translateY(-2px);
}

.my-loan-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 16px;
  border-bottom: 1px solid rgba(203, 164, 115, 0.15);
}

.my-loan-title {
  display: flex;
  align-items: center;
  gap: 16px;
}

.my-loan-relic-name {
  font-size: 18px;
  font-weight: 600;
  color: #2b2118;
}

.my-loan-actions {
  display: flex;
  gap: 8px;
}

.my-loan-body {
  margin-bottom: 16px;
}

.my-loan-info-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 16px;
}

.my-loan-info-item {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.my-loan-info-label {
  font-size: 13px;
  color: #8b7355;
  font-weight: 500;
}

.my-loan-info-value {
  font-size: 15px;
  color: #2b2118;
  font-weight: 500;
}

.my-loan-full-width {
  grid-column: 1 / -1;
}

.my-loan-overdue-text {
  color: #f56c6c !important;
  font-weight: 600 !important;
}

.my-loan-footer {
  padding-top: 12px;
  border-top: 1px solid rgba(203, 164, 115, 0.1);
}

.my-loan-create-time {
  font-size: 13px;
  color: #a69080;
}

.my-loans-pagination {
  display: flex;
  justify-content: center;
  margin-top: 30px;
}

/* 响应式 */
@media (max-width: 768px) {
  .hero-banner h2 {
    font-size: 32px;
  }

  .hero-banner p {
    font-size: 16px;
  }

  .hero-actions {
    flex-direction: column;
    align-items: center;
  }

  .search-bar {
    flex-direction: column;
  }

  .search-bar > * {
    width: 100% !important;
  }

  .relics-grid,
  .categories-grid {
    grid-template-columns: 1fr;
  }

  .my-loans-stats {
    grid-template-columns: 1fr;
  }

  .my-loan-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 12px;
  }

  .my-loan-info-grid {
    grid-template-columns: 1fr;
  }
}

/* 文物详情对话框样式 */
.detail-dialog :deep(.el-dialog__body) {
  padding: 30px;
}

.detail-container {
  display: grid;
  grid-template-columns: 400px 1fr;
  gap: 30px;
}

.detail-left {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-carousel {
  width: 100%;
  border-radius: 12px;
  overflow: hidden;
  background: #f7efe4;
}

.carousel-image {
  width: 100%;
  height: 100%;
  cursor: pointer;
}

.detail-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.detail-actions .el-button {
  flex: 1;
  min-width: 100px;
}

.detail-image-wrapper {
  width: 100%;
  height: 400px;
  background: #f7efe4;
  border-radius: 12px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
}

.detail-main-image {
  width: 100%;
  height: 100%;
  cursor: pointer;
}

.image-error,
.no-image-placeholder {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #9b8d7d;
  gap: 12px;
}

.image-error p,
.no-image-placeholder p {
  margin: 0;
  font-size: 16px;
}

.detail-right {
  display: flex;
  flex-direction: column;
  gap: 20px;
  max-height: 600px;
  overflow-y: auto;
}

.detail-section {
  margin-bottom: 20px;
}

.detail-section:last-child {
  margin-bottom: 0;
}

.section-title {
  font-size: 16px;
  font-weight: 600;
  color: #3d2a1d;
  margin: 0 0 16px 0;
  padding-bottom: 8px;
  border-bottom: 2px solid rgba(181, 136, 82, 0.2);
}

.detail-timeline {
  padding-left: 10px;
}

.timeline-content {
  padding: 8px 0;
}

.timeline-content strong {
  display: block;
  margin-bottom: 4px;
  color: #3d2a1d;
}

.timeline-content p {
  margin: 0;
  color: #6b5744;
  font-size: 14px;
}

.related-relics {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 15px;
}

.related-item {
  cursor: pointer;
  border: 1px solid #e6d8c4;
  border-radius: 8px;
  overflow: hidden;
  transition: all 0.3s;
}

.related-item:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.related-image {
  width: 100%;
  height: 100px;
  object-fit: cover;
}

.related-no-image {
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f7efe4;
  color: #9b8d7d;
}

.related-info {
  padding: 10px;
}

.related-name {
  font-size: 14px;
  font-weight: 600;
  color: #3d2a1d;
  margin-bottom: 4px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.related-meta {
  font-size: 12px;
  color: #9b8d7d;
}

.share-content {
  text-align: center;
}

.share-info h4 {
  margin: 0 0 8px 0;
  color: #3d2a1d;
}

.share-info p {
  margin: 0;
  color: #6b5744;
}

.share-options {
  display: flex;
  gap: 10px;
  justify-content: center;
  margin: 20px 0;
}

.qrcode-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.qrcode-container canvas {
  border: 1px solid #e6d8c4;
  border-radius: 8px;
}

/* 响应式 - 详情对话框 */
@media (max-width: 768px) {
  .detail-container {
    grid-template-columns: 1fr;
  }
  
  .detail-left {
    order: 1;
  }
  
  .detail-right {
    order: 2;
  }
  
  .related-relics {
    grid-template-columns: 1fr;
  }
}
</style>