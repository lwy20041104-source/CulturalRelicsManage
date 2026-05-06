<template>
  <el-dropdown @command="handleCommand" trigger="click">
    <span class="language-switcher">
      <el-icon><Setting /></el-icon>
      <span class="language-text">{{ currentLanguageLabel }}</span>
    </span>
    <template #dropdown>
      <el-dropdown-menu>
        <el-dropdown-item command="zh-CN" :class="{ active: locale === 'zh-CN' }">
          简体中文
        </el-dropdown-item>
        <el-dropdown-item command="en-US" :class="{ active: locale === 'en-US' }">
          English
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
</template>

<script setup>
import { computed } from 'vue'
import { useI18n } from 'vue-i18n'
import { ElMessage } from 'element-plus'
import { Setting } from '@element-plus/icons-vue'

const { locale } = useI18n()

const currentLanguageLabel = computed(() => {
  return locale.value === 'zh-CN' ? '中文' : 'EN'
})

const handleCommand = (command) => {
  if (command === locale.value) return
  
  locale.value = command
  localStorage.setItem('locale', command)
  
  // 提示用户刷新页面以应用Element Plus的语言
  ElMessage.success({
    message: command === 'zh-CN' ? '语言已切换，刷新页面以完全生效' : 'Language switched, refresh to take full effect',
    duration: 2000
  })
  
  // 自动刷新页面
  setTimeout(() => {
    window.location.reload()
  }, 500)
}
</script>

<style scoped>
.language-switcher {
  display: flex;
  align-items: center;
  gap: 6px;
  cursor: pointer;
  padding: 8px 12px;
  border-radius: 6px;
  transition: all 0.3s;
  color: #606266;
}

.language-switcher:hover {
  background-color: #f5f7fa;
  color: #409eff;
}

.language-text {
  font-size: 14px;
  font-weight: 500;
}

.el-dropdown-menu__item.active {
  color: #409eff;
  font-weight: 600;
}
</style>
