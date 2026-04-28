<template>
  <el-dropdown trigger="click" @command="handleThemeChange">
    <el-button class="theme-button" circle>
      <el-icon><Brush /></el-icon>
    </el-button>
    <template #dropdown>
      <el-dropdown-menu class="theme-dropdown">
        <div class="theme-dropdown-header">
          <el-icon><Brush /></el-icon>
          <span>{{ locale === 'zh-CN' ? '选择主题' : 'Select Theme' }}</span>
        </div>
        <el-dropdown-item
          v-for="(theme, key) in themes"
          :key="key"
          :command="key"
          :class="{ 'is-active': currentTheme === key }"
          class="theme-item"
        >
          <div class="theme-item-content">
            <div class="theme-icon">{{ theme.icon }}</div>
            <div class="theme-info">
              <div class="theme-name">{{ locale === 'zh-CN' ? theme.name : theme.nameEn }}</div>
              <div class="theme-preview">
                <span
                  v-for="(color, index) in getPreviewColors(theme)"
                  :key="index"
                  class="color-dot"
                  :style="{ backgroundColor: color }"
                ></span>
              </div>
            </div>
            <el-icon v-if="currentTheme === key" class="check-icon"><Check /></el-icon>
          </div>
        </el-dropdown-item>
      </el-dropdown-menu>
    </template>
  </el-dropdown>
</template>

<script setup>
import { computed } from 'vue'
import { Brush, Check } from '@element-plus/icons-vue'
import { useTheme } from '../composables/useTheme'
import { ElMessage } from 'element-plus'

const { themes, currentTheme, setTheme } = useTheme()
const locale = computed(() => localStorage.getItem('locale') || 'zh-CN')

const getPreviewColors = (theme) => {
  return [
    theme.colors.primary,
    theme.colors.bgAside,
    theme.colors.bgMain
  ]
}

const handleThemeChange = (themeName) => {
  setTheme(themeName)
  const theme = themes[themeName]
  const message = locale.value === 'zh-CN' 
    ? `已切换到 ${theme.name}` 
    : `Switched to ${theme.nameEn}`
  ElMessage.success(message)
}
</script>

<style scoped>
.theme-button {
  border: none;
  background: transparent;
  color: var(--text-secondary, #5d4a2f);
  transition: all 0.3s;
}

.theme-button:hover {
  color: var(--color-primary, #a67c52);
  background: var(--bg-hover, #fbf6ee);
}

.theme-dropdown {
  min-width: 280px;
  padding: 8px 0;
}

.theme-dropdown-header {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px 16px;
  font-weight: 600;
  font-size: 14px;
  color: var(--text-primary, #3d2f1f);
  border-bottom: 1px solid var(--border-light, #eadfce);
  margin-bottom: 4px;
}

.theme-item {
  padding: 0 !important;
}

.theme-item-content {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 16px;
  width: 100%;
  transition: all 0.2s;
}

.theme-item:hover .theme-item-content {
  background: var(--bg-hover, #fbf6ee);
}

.theme-item.is-active .theme-item-content {
  background: var(--bg-active, #fef5e7);
}

.theme-icon {
  font-size: 24px;
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background: var(--bg-main, #f5ede0);
}

.theme-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.theme-name {
  font-size: 14px;
  font-weight: 500;
  color: var(--text-primary, #3d2f1f);
}

.theme-preview {
  display: flex;
  gap: 4px;
}

.color-dot {
  width: 16px;
  height: 16px;
  border-radius: 50%;
  border: 2px solid #fff;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.check-icon {
  color: var(--color-primary, #a67c52);
  font-size: 18px;
  font-weight: bold;
}

:deep(.el-dropdown-menu__item) {
  padding: 0;
}

:deep(.el-dropdown-menu__item:hover) {
  background: transparent;
}
</style>
