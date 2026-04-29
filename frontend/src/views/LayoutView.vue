<template>
  <el-container class="layout">
    <el-aside width="238px" class="aside">
      <div class="logo">
        <span class="logo-mark">藏</span>
        <div class="logo-text">
          <strong>{{ $t('login.title').split('系统')[0] }}</strong>
          <small>Cultural Relics</small>
        </div>
      </div>
      <el-menu router :default-active="$route.path" class="menu">
        <el-menu-item index="/dashboard">{{ $t('nav.home') }}</el-menu-item>
        <el-menu-item index="/data-screen">{{ $t('nav.dataScreen') }}</el-menu-item>
        <el-menu-item index="/reports">{{ $t('nav.reports') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('users:manage')" index="/employees">{{ $t('nav.employees') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('users:manage')" index="/loaners">{{ $t('nav.loaners') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('users:manage')" index="/museums">{{ $t('nav.museums') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('relics:manage')" index="/relics">{{ $t('nav.relics') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('categories:manage')" index="/categories">{{ $t('nav.categories') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('images:manage')" index="/images">{{ $t('nav.images') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('archives:manage') || hasPerm('archives:view')" index="/archives">{{ $t('nav.archives') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('loans:manage')" index="/loans">{{ $t('nav.loans') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('maintenance:manage')" index="/maintenance">{{ $t('nav.maintenance') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('repairs:manage')" index="/repairs">{{ $t('nav.repairs') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('repairs:apply')" index="/repair-apply">{{ $t('nav.repairApply') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('users:manage')" index="/operation-logs">{{ $t('nav.operationLogs') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('users:manage')" index="/ai-chat-history">{{ $t('nav.aiChatHistory') }}</el-menu-item>
        <el-menu-item v-if="hasPerm('users:manage')" index="/backup">{{ $t('nav.backup') }}</el-menu-item>
        <el-menu-item index="/ai-query">{{ $t('nav.aiQuery') }}</el-menu-item>
      </el-menu>
    </el-aside>
    <el-container>
      <el-header class="header">
        <div class="welcome">
          {{ $t('common.welcome') || '欢迎' }}，
          <span class="username-link" @click="goToProfile">{{ realName || username }}</span>
        </div>
        <div class="header-actions">
          <NotificationBell />
          <DarkModeToggle />
          <ThemeSwitcher />
          <LanguageSwitcher />
          <el-button type="primary" plain size="small" @click="logout">{{ $t('nav.logout') }}</el-button>
        </div>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script setup>
import { computed } from 'vue'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { User } from '@element-plus/icons-vue'
import { logoutApi } from '../api/auth'
import LanguageSwitcher from '../components/LanguageSwitcher.vue'
import NotificationBell from '../components/NotificationBell.vue'
import ThemeSwitcher from '../components/ThemeSwitcher.vue'
import DarkModeToggle from '../components/DarkModeToggle.vue'

const router = useRouter()
const { t } = useI18n()
const username = computed(() => sessionStorage.getItem('username'))
const realName = computed(() => sessionStorage.getItem('realName'))
const permissions = computed(() => JSON.parse(sessionStorage.getItem('permissions') || '[]'))

const hasPerm = (perm) => permissions.value.includes(perm)

const goToProfile = () => {
  router.push('/profile')
}

const logout = async () => {
  try {
    await logoutApi()
  } catch (e) {
  }
  sessionStorage.clear()
  ElMessage.success(t('nav.logout'))
  router.push('/login')
}
</script>

<style scoped>
.layout {
  min-height: 100vh;
  height: 100vh;
  overflow: hidden;
}

.aside {
  padding: 16px 12px;
  background: var(--bg-aside);
  color: var(--text-secondary);
  border-right: 1px solid var(--border-light);
  height: 100vh;
  overflow-y: auto;
  overflow-x: hidden;
  transition: background-color 0.3s ease;
}

.aside::-webkit-scrollbar {
  width: 6px;
}

.aside::-webkit-scrollbar-track {
  background: transparent;
}

.aside::-webkit-scrollbar-thumb {
  background: var(--scrollbar-thumb);
  border-radius: 3px;
}

.aside::-webkit-scrollbar-thumb:hover {
  background: var(--scrollbar-thumb-hover);
}

.logo {
  height: 62px;
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0 10px;
  margin-bottom: 8px;
}

.logo-mark {
  width: 34px;
  height: 34px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background: linear-gradient(135deg, var(--logo-gradient-start) 0%, var(--logo-gradient-end) 100%);
  color: #ffffff;
  font-weight: 700;
  font-size: 16px;
}

.logo-text {
  display: flex;
  flex-direction: column;
  line-height: 1.15;
}

.logo-text strong {
  color: var(--text-primary);
  font-size: 15px;
}

.logo-text small {
  color: var(--text-light);
  font-size: 11px;
  margin-top: 2px;
}

.menu {
  border-right: none;
  background: transparent;
}

.menu :deep(.el-menu-item) {
  margin: 2px 6px;
  border-radius: 6px;
  color: var(--text-tertiary);
  font-size: 14px;
  height: 42px;
  line-height: 42px;
  transition: all 0.2s;
}

.menu :deep(.el-menu-item:hover) {
  background: var(--bg-hover);
  color: var(--color-primary-light);
}

.menu :deep(.el-menu-item.is-active) {
  background: var(--bg-active);
  color: var(--color-primary-light);
  font-weight: 500;
  border-left: 3px solid var(--color-primary);
  padding-left: 17px;
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid var(--border-light);
  background: var(--bg-card);
  transition: background-color 0.3s ease, border-color 0.3s ease;
}

.header-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}

.welcome {
  color: var(--text-secondary);
  font-size: 14px;
}

.username-link {
  color: var(--color-primary-light);
  cursor: pointer;
  font-weight: 500;
  transition: all 0.2s;
}

.username-link:hover {
  color: var(--color-primary);
  text-decoration: underline;
}

.main {
  padding: 18px;
  background: var(--bg-main);
  height: calc(100vh - 60px);
  overflow-y: auto;
  overflow-x: hidden;
  transition: background-color 0.3s ease;
}

.main::-webkit-scrollbar {
  width: 8px;
}

.main::-webkit-scrollbar-track {
  background: var(--scrollbar-track);
}

.main::-webkit-scrollbar-thumb {
  background: var(--scrollbar-thumb);
  border-radius: 4px;
}

.main::-webkit-scrollbar-thumb:hover {
  background: var(--scrollbar-thumb-hover);
}
</style>
