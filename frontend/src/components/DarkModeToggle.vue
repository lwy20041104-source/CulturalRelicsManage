<template>
  <el-button class="dark-mode-toggle" circle @click="handleToggle">
    <el-icon>
      <Moon v-if="!isDarkMode" />
      <Sunny v-else />
    </el-icon>
  </el-button>
</template>

<script setup>
import { computed } from 'vue'
import { Moon, Sunny } from '@element-plus/icons-vue'
import { useTheme } from '../composables/useTheme'
import { ElMessage } from 'element-plus'

const { isDarkMode, toggleDarkMode } = useTheme()
const locale = computed(() => localStorage.getItem('locale') || 'zh-CN')

const handleToggle = () => {
  toggleDarkMode()
  const message = locale.value === 'zh-CN' 
    ? (isDarkMode.value ? '已切换到暗黑模式' : '已切换到浅色模式')
    : (isDarkMode.value ? 'Switched to Dark Mode' : 'Switched to Light Mode')
  ElMessage.success(message)
}
</script>

<style scoped>
.dark-mode-toggle {
  border: none;
  background: transparent;
  color: var(--text-secondary);
  transition: all 0.3s;
}

.dark-mode-toggle:hover {
  color: var(--color-primary);
  background: var(--bg-hover);
  transform: rotate(180deg);
}

.dark-mode-toggle :deep(.el-icon) {
  font-size: 18px;
}
</style>
