import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'
import PortalLoginView from '../views/PortalLoginView.vue'
import PortalRegisterView from '../views/PortalRegisterView.vue'
import ForgotPasswordView from '../views/ForgotPasswordView.vue'
import ResetPasswordView from '../views/ResetPasswordView.vue'
import LayoutView from '../views/LayoutView.vue'
import DashboardView from '../views/DashboardView.vue'
import RelicsView from '../views/RelicsView.vue'
import CategoriesView from '../views/CategoriesView.vue'
import LoansView from '../views/LoansView.vue'
import MaintenanceView from '../views/MaintenanceView.vue'
import AiQueryView from '../views/AiQueryView.vue'
import AiChatHistoryView from '../views/AiChatHistoryView.vue'
import OperationLogsView from '../views/OperationLogsView.vue'
import BackupView from '../views/BackupView.vue'
import RepairsView from '../views/RepairsView.vue'
import RepairApplyView from '../views/RepairApplyView.vue'
import DataScreenView from '../views/DataScreenView.vue'
import ReportsView from '../views/ReportsView.vue'
import PublicPortalView from '../views/PublicPortalView.vue'
import PublicGuestView from '../views/PublicGuestView.vue'
import ImageLibraryView from '../views/ImageLibraryView.vue'
import QRCodeScanView from '../views/QRCodeScanView.vue'
import PublicRelicsView from '../views/PublicRelicsView.vue'
import Relic3DView from '../views/Relic3DView.vue'

const routes = [
  { path: '/login', component: LoginView },
  { path: '/portal-login', component: PortalLoginView },
  { path: '/portal-register', component: PortalRegisterView },
  { path: '/forgot-password', component: ForgotPasswordView },
  { path: '/reset-password', component: ResetPasswordView },
  { path: '/portal', component: PublicPortalView },
  { path: '/portal-guest', component: PublicGuestView }, // 未登录用户访客页面
  { path: '/public-relics', component: PublicRelicsView }, // 公开的文物查询页面
  { path: '/qrcode/:id', component: QRCodeScanView },
  {
    path: '/',
    component: LayoutView,
    redirect: '/dashboard',
    children: [
      { path: '/dashboard', component: DashboardView, meta: { perm: 'dashboard:view' } },
      { path: '/employees', component: () => import('../views/EmployeesView.vue'), meta: { perm: 'users:manage' } },
      { path: '/loaners', component: () => import('../views/LoanersView.vue'), meta: { perm: 'users:manage' } },
      { path: '/ai-query', component: AiQueryView },
      { path: '/operation-logs', component: OperationLogsView, meta: { perm: 'users:manage' } },
      { path: '/ai-chat-history', component: AiChatHistoryView, meta: { perm: 'users:manage' } },
      { path: '/backup', component: BackupView, meta: { perm: 'users:manage' } },
      { path: '/relics', component: RelicsView, meta: { perm: 'relics:manage' } },
      { path: '/categories', component: CategoriesView, meta: { perm: 'categories:manage' } },
      { path: '/loans', component: LoansView, meta: { perm: 'loans:manage' } },
      { path: '/maintenance', component: MaintenanceView, meta: { perm: 'maintenance:manage' } },
      { path: '/repairs', component: RepairsView, meta: { perm: 'repairs:manage' } },
      { path: '/repair-apply', component: RepairApplyView, meta: { perm: 'repairs:apply' } },
      { path: '/repair-experts', component: () => import('../views/ExpertsView.vue'), meta: { perm: 'repairs:manage' } },
      { path: '/repair-materials', component: () => import('../views/RepairMaterialsView.vue'), meta: { perm: 'repairs:manage' } },
      { path: '/images', component: ImageLibraryView, meta: { perm: 'images:manage' } },
      { path: '/data-screen', component: DataScreenView },
      { path: '/reports', component: ReportsView },
      { path: '/notifications', component: () => import('../views/NotificationsView.vue') },
      { path: '/archives', component: () => import('../views/ArchivesView.vue'), meta: { perm: 'archives:manage' } },
      { path: '/archives/:id', component: () => import('../views/ArchiveDetailView.vue'), meta: { perm: 'archives:manage' } },
      { path: '/profile', component: () => import('../views/ProfileView.vue') },
      { path: '/museums', component: () => import('../views/MuseumsView.vue'), meta: { perm: 'users:manage' } },
      { path: '/relics/:id/3d', component: Relic3DView }
    ]
  },
  {
    path: '/portal-profile',
    component: () => import('../views/PortalProfileView.vue')
  },
  {
    path: '/portal-my-loans',
    component: () => import('../views/PortalMyLoansView.vue')
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  const token = sessionStorage.getItem('token')
  const perms = JSON.parse(sessionStorage.getItem('permissions') || '[]')
  const role = sessionStorage.getItem('role')

  // 公开文物查询页面无需登录
  if (to.path === '/public-relics') {
    next()
  }
  // 注册页面无需登录
  else if (to.path === '/portal-register') {
    next()
  }
  // 忘记密码和重置密码页面无需登录
  else if (to.path === '/forgot-password' || to.path === '/reset-password') {
    next()
  }
  // 前台登录页面
  else if (to.path === '/portal-login') {
    if (token && role === 'LOANER') {
      next('/portal')
    } else {
      next()
    }
  }
  // 前台页面允许未登录用户访问（浏览模式）
  else if (to.path === '/portal') {
    // 未登录用户跳转到访客页面
    if (!token) {
      next('/portal-guest')
    }
    // 已登录但不是 LOANER 角色，跳转到后台
    else if (role !== 'LOANER') {
      next('/dashboard')
    }
    // 已登录且是 LOANER 角色，正常访问
    else {
      next()
    }
  }
  // 前台访客页面（未登录用户专用）
  else if (to.path === '/portal-guest') {
    // 如果已登录，跳转到正式门户
    if (token && role === 'LOANER') {
      next('/portal')
    } else {
      next()
    }
  }
  // 前台个人信息页面需要LOANER角色登录
  else if (to.path === '/portal-profile') {
    if (!token) {
      next('/portal-login')
    } else if (role !== 'LOANER') {
      next('/dashboard')
    } else {
      next()
    }
  }
  // 后台管理登录页面
  else if (to.path === '/login') {
    if (token && role !== 'LOANER') {
      next('/dashboard')
    } else if (token && role === 'LOANER') {
      next('/portal')
    } else {
      next()
    }
  }
  // 后台管理页面需要登录且非LOANER角色
  else if (to.path !== '/login' && to.path !== '/portal-login' && !token) {
    next('/login')
  } else if (to.path === '/ai-query') {
    next()
  } else if (to.meta?.perm && !perms.includes(to.meta.perm)) {
    next('/dashboard')
  } else {
    next()
  }
})

export default router
