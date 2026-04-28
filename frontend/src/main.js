import { createApp } from 'vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import zhCn from 'element-plus/dist/locale/zh-cn.mjs'
import en from 'element-plus/dist/locale/en.mjs'
import App from './App.vue'
import router from './router'
import i18n from './i18n'
import './styles/global.css'
import { initTheme } from './composables/useTheme'

// 初始化主题
initTheme()

const app = createApp(App)

// 根据当前语言设置Element Plus的语言
const locale = localStorage.getItem('locale') || 'zh-CN'
const elementLocale = locale === 'en-US' ? en : zhCn

app.use(createPinia())
app.use(router)
app.use(i18n)
app.use(ElementPlus, { locale: elementLocale })
app.mount('#app')
