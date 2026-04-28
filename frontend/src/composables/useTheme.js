import { ref, watch } from 'vue'

// 暗黑模式状态
const isDarkMode = ref(localStorage.getItem('darkMode') === 'true')

// 预设主题配置（浅色模式）
export const themes = {
  // 默认主题 - 古典棕色
  classic: {
    name: '古典棕色',
    nameEn: 'Classic Brown',
    icon: '🏛️',
    colors: {
      // 主色调
      primary: '#a67c52',
      primaryLight: '#8b6f47',
      primaryDark: '#8a5b2f',
      
      // 背景色
      bgMain: '#f5ede0',
      bgAside: '#fdfbf7',
      bgCard: '#ffffff',
      bgHover: '#fbf6ee',
      bgActive: '#fef5e7',
      
      // 文字颜色
      textPrimary: '#3d2f1f',
      textSecondary: '#5d4a2f',
      textTertiary: '#6c5037',
      textLight: '#9b8d7d',
      
      // 边框颜色
      borderLight: '#eadfce',
      borderNormal: '#e6d8c4',
      borderDark: '#d4c4b0',
      
      // 滚动条
      scrollbarTrack: '#eadfce',
      scrollbarThumb: '#a67c52',
      scrollbarThumbHover: '#8b6f47',
      
      // Logo渐变
      logoGradientStart: '#a67c52',
      logoGradientEnd: '#8b6f47'
    },
    darkColors: {
      primary: '#c9a875',
      primaryLight: '#b99865',
      primaryDark: '#a98855',
      
      bgMain: '#1a1612',
      bgAside: '#221e1a',
      bgCard: '#2a2622',
      bgHover: '#322e2a',
      bgActive: '#3a3632',
      
      textPrimary: '#e8e0d5',
      textSecondary: '#d0c8bd',
      textTertiary: '#b8b0a5',
      textLight: '#8a8278',
      
      borderLight: '#3a3632',
      borderNormal: '#4a4642',
      borderDark: '#5a5652',
      
      scrollbarTrack: '#2a2622',
      scrollbarThumb: '#c9a875',
      scrollbarThumbHover: '#b99865',
      
      logoGradientStart: '#c9a875',
      logoGradientEnd: '#b99865'
    }
  },
  
  // 青瓷主题
  celadon: {
    name: '青瓷雅韵',
    nameEn: 'Celadon Elegance',
    icon: '🏺',
    colors: {
      primary: '#7c9885',
      primaryLight: '#6a8a73',
      primaryDark: '#5a7a63',
      
      bgMain: '#e8f0eb',
      bgAside: '#f5f9f6',
      bgCard: '#ffffff',
      bgHover: '#f0f7f2',
      bgActive: '#e3f2e7',
      
      textPrimary: '#2d3e32',
      textSecondary: '#3d4e42',
      textTertiary: '#4d5e52',
      textLight: '#7d8e82',
      
      borderLight: '#d5e3d9',
      borderNormal: '#c5d8ca',
      borderDark: '#b5c8ba',
      
      scrollbarTrack: '#d5e3d9',
      scrollbarThumb: '#7c9885',
      scrollbarThumbHover: '#6a8a73',
      
      logoGradientStart: '#7c9885',
      logoGradientEnd: '#6a8a73'
    },
    darkColors: {
      primary: '#8fae98',
      primaryLight: '#7f9e88',
      primaryDark: '#6f8e78',
      
      bgMain: '#141a16',
      bgAside: '#1c221e',
      bgCard: '#242a26',
      bgHover: '#2c322e',
      bgActive: '#343a36',
      
      textPrimary: '#d5e3d9',
      textSecondary: '#c5d3c9',
      textTertiary: '#b5c3b9',
      textLight: '#859389',
      
      borderLight: '#343a36',
      borderNormal: '#444a46',
      borderDark: '#545a56',
      
      scrollbarTrack: '#242a26',
      scrollbarThumb: '#8fae98',
      scrollbarThumbHover: '#7f9e88',
      
      logoGradientStart: '#8fae98',
      logoGradientEnd: '#7f9e88'
    }
  },
  
  // 青花主题
  blueWhite: {
    name: '青花瓷韵',
    nameEn: 'Blue & White',
    icon: '🎨',
    colors: {
      primary: '#4a7ba7',
      primaryLight: '#3a6b97',
      primaryDark: '#2a5b87',
      
      bgMain: '#e8f1f8',
      bgAside: '#f5f9fc',
      bgCard: '#ffffff',
      bgHover: '#f0f6fb',
      bgActive: '#e3eef7',
      
      textPrimary: '#1a2e3e',
      textSecondary: '#2a3e4e',
      textTertiary: '#3a4e5e',
      textLight: '#6a7e8e',
      
      borderLight: '#d5e3ed',
      borderNormal: '#c5d8e8',
      borderDark: '#b5c8d8',
      
      scrollbarTrack: '#d5e3ed',
      scrollbarThumb: '#4a7ba7',
      scrollbarThumbHover: '#3a6b97',
      
      logoGradientStart: '#4a7ba7',
      logoGradientEnd: '#3a6b97'
    },
    darkColors: {
      primary: '#5d8fba',
      primaryLight: '#4d7faa',
      primaryDark: '#3d6f9a',
      
      bgMain: '#12181e',
      bgAside: '#1a2026',
      bgCard: '#22282e',
      bgHover: '#2a3036',
      bgActive: '#32383e',
      
      textPrimary: '#d5e3ed',
      textSecondary: '#c5d3dd',
      textTertiary: '#b5c3cd',
      textLight: '#7a8e9e',
      
      borderLight: '#32383e',
      borderNormal: '#42484e',
      borderDark: '#52585e',
      
      scrollbarTrack: '#22282e',
      scrollbarThumb: '#5d8fba',
      scrollbarThumbHover: '#4d7faa',
      
      logoGradientStart: '#5d8fba',
      logoGradientEnd: '#4d7faa'
    }
  },
  
  // 紫檀主题
  rosewood: {
    name: '紫檀沉香',
    nameEn: 'Rosewood',
    icon: '🪵',
    colors: {
      primary: '#8b5a5a',
      primaryLight: '#7b4a4a',
      primaryDark: '#6b3a3a',
      
      bgMain: '#f0e8e8',
      bgAside: '#f9f5f5',
      bgCard: '#ffffff',
      bgHover: '#f6f0f0',
      bgActive: '#f2e3e3',
      
      textPrimary: '#3e2d2d',
      textSecondary: '#4e3d3d',
      textTertiary: '#5e4d4d',
      textLight: '#8e7d7d',
      
      borderLight: '#e3d5d5',
      borderNormal: '#d8c5c5',
      borderDark: '#c8b5b5',
      
      scrollbarTrack: '#e3d5d5',
      scrollbarThumb: '#8b5a5a',
      scrollbarThumbHover: '#7b4a4a',
      
      logoGradientStart: '#8b5a5a',
      logoGradientEnd: '#7b4a4a'
    },
    darkColors: {
      primary: '#a87070',
      primaryLight: '#986060',
      primaryDark: '#885050',
      
      bgMain: '#1a1414',
      bgAside: '#221c1c',
      bgCard: '#2a2424',
      bgHover: '#322c2c',
      bgActive: '#3a3434',
      
      textPrimary: '#e8d8d8',
      textSecondary: '#d0c0c0',
      textTertiary: '#b8a8a8',
      textLight: '#8a7a7a',
      
      borderLight: '#3a3434',
      borderNormal: '#4a4444',
      borderDark: '#5a5454',
      
      scrollbarTrack: '#2a2424',
      scrollbarThumb: '#a87070',
      scrollbarThumbHover: '#986060',
      
      logoGradientStart: '#a87070',
      logoGradientEnd: '#986060'
    }
  },
  
  // 墨玉主题
  inkJade: {
    name: '墨玉清幽',
    nameEn: 'Ink Jade',
    icon: '💎',
    colors: {
      primary: '#5a6a7a',
      primaryLight: '#4a5a6a',
      primaryDark: '#3a4a5a',
      
      bgMain: '#e8eaed',
      bgAside: '#f5f6f8',
      bgCard: '#ffffff',
      bgHover: '#f0f1f3',
      bgActive: '#e3e5e8',
      
      textPrimary: '#2d3238',
      textSecondary: '#3d4248',
      textTertiary: '#4d5258',
      textLight: '#7d8288',
      
      borderLight: '#d5d8dd',
      borderNormal: '#c5c8cd',
      borderDark: '#b5b8bd',
      
      scrollbarTrack: '#d5d8dd',
      scrollbarThumb: '#5a6a7a',
      scrollbarThumbHover: '#4a5a6a',
      
      logoGradientStart: '#5a6a7a',
      logoGradientEnd: '#4a5a6a'
    },
    darkColors: {
      primary: '#7a8a9a',
      primaryLight: '#6a7a8a',
      primaryDark: '#5a6a7a',
      
      bgMain: '#14161a',
      bgAside: '#1c1e22',
      bgCard: '#24262a',
      bgHover: '#2c2e32',
      bgActive: '#34363a',
      
      textPrimary: '#d5d8dd',
      textSecondary: '#c5c8cd',
      textTertiary: '#b5b8bd',
      textLight: '#7d8288',
      
      borderLight: '#34363a',
      borderNormal: '#44464a',
      borderDark: '#54565a',
      
      scrollbarTrack: '#24262a',
      scrollbarThumb: '#7a8a9a',
      scrollbarThumbHover: '#6a7a8a',
      
      logoGradientStart: '#7a8a9a',
      logoGradientEnd: '#6a7a8a'
    }
  },
  
  // 琥珀主题
  amber: {
    name: '琥珀金辉',
    nameEn: 'Amber Gold',
    icon: '✨',
    colors: {
      primary: '#c9a961',
      primaryLight: '#b99951',
      primaryDark: '#a98941',
      
      bgMain: '#f8f3e8',
      bgAside: '#fcf9f5',
      bgCard: '#ffffff',
      bgHover: '#faf6f0',
      bgActive: '#f5f0e3',
      
      textPrimary: '#3e3a2d',
      textSecondary: '#4e4a3d',
      textTertiary: '#5e5a4d',
      textLight: '#8e8a7d',
      
      borderLight: '#ede8d5',
      borderNormal: '#e3d8c5',
      borderDark: '#d3c8b5',
      
      scrollbarTrack: '#ede8d5',
      scrollbarThumb: '#c9a961',
      scrollbarThumbHover: '#b99951',
      
      logoGradientStart: '#c9a961',
      logoGradientEnd: '#b99951'
    },
    darkColors: {
      primary: '#dfc080',
      primaryLight: '#cfb070',
      primaryDark: '#bfa060',
      
      bgMain: '#1a1812',
      bgAside: '#22201a',
      bgCard: '#2a2822',
      bgHover: '#32302a',
      bgActive: '#3a3832',
      
      textPrimary: '#e8e0d5',
      textSecondary: '#d0c8bd',
      textTertiary: '#b8b0a5',
      textLight: '#8a8278',
      
      borderLight: '#3a3832',
      borderNormal: '#4a4842',
      borderDark: '#5a5852',
      
      scrollbarTrack: '#2a2822',
      scrollbarThumb: '#dfc080',
      scrollbarThumbHover: '#cfb070',
      
      logoGradientStart: '#dfc080',
      logoGradientEnd: '#cfb070'
    }
  }
}

// 当前主题
const currentTheme = ref(localStorage.getItem('theme') || 'classic')

// 应用主题到DOM
const applyTheme = (themeName, dark = isDarkMode.value) => {
  const theme = themes[themeName]
  if (!theme) return
  
  const root = document.documentElement
  const colors = dark ? theme.darkColors : theme.colors
  
  // 设置暗黑模式类名
  if (dark) {
    root.classList.add('dark-mode')
  } else {
    root.classList.remove('dark-mode')
  }
  
  // 设置CSS变量
  root.style.setProperty('--color-primary', colors.primary)
  root.style.setProperty('--color-primary-light', colors.primaryLight)
  root.style.setProperty('--color-primary-dark', colors.primaryDark)
  
  root.style.setProperty('--bg-main', colors.bgMain)
  root.style.setProperty('--bg-aside', colors.bgAside)
  root.style.setProperty('--bg-card', colors.bgCard)
  root.style.setProperty('--bg-hover', colors.bgHover)
  root.style.setProperty('--bg-active', colors.bgActive)
  
  root.style.setProperty('--text-primary', colors.textPrimary)
  root.style.setProperty('--text-secondary', colors.textSecondary)
  root.style.setProperty('--text-tertiary', colors.textTertiary)
  root.style.setProperty('--text-light', colors.textLight)
  
  root.style.setProperty('--border-light', colors.borderLight)
  root.style.setProperty('--border-normal', colors.borderNormal)
  root.style.setProperty('--border-dark', colors.borderDark)
  
  root.style.setProperty('--scrollbar-track', colors.scrollbarTrack)
  root.style.setProperty('--scrollbar-thumb', colors.scrollbarThumb)
  root.style.setProperty('--scrollbar-thumb-hover', colors.scrollbarThumbHover)
  
  root.style.setProperty('--logo-gradient-start', colors.logoGradientStart)
  root.style.setProperty('--logo-gradient-end', colors.logoGradientEnd)
  
  // 保存到localStorage
  localStorage.setItem('theme', themeName)
  localStorage.setItem('darkMode', dark.toString())
  currentTheme.value = themeName
  isDarkMode.value = dark
}

// 切换暗黑模式
export const toggleDarkMode = () => {
  const newDarkMode = !isDarkMode.value
  applyTheme(currentTheme.value, newDarkMode)
}

// 设置暗黑模式
export const setDarkMode = (dark) => {
  applyTheme(currentTheme.value, dark)
}

// 获取暗黑模式状态
export const getDarkMode = () => {
  return isDarkMode.value
}

// 初始化主题
export const initTheme = () => {
  const savedTheme = localStorage.getItem('theme') || 'classic'
  const savedDarkMode = localStorage.getItem('darkMode') === 'true'
  applyTheme(savedTheme, savedDarkMode)
}

// 切换主题
export const setTheme = (themeName) => {
  applyTheme(themeName, isDarkMode.value)
}

// 获取当前主题
export const getCurrentTheme = () => {
  return currentTheme.value
}

// 获取主题信息
export const getThemeInfo = (themeName) => {
  return themes[themeName]
}

// 导出useTheme组合式函数
export const useTheme = () => {
  return {
    themes,
    currentTheme,
    isDarkMode,
    setTheme,
    getCurrentTheme,
    getThemeInfo,
    initTheme,
    toggleDarkMode,
    setDarkMode,
    getDarkMode
  }
}
