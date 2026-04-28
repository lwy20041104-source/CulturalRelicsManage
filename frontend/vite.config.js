import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  build: {
    chunkSizeWarningLimit: 2500
  },
  server: {
    port: 5173,
    host: '0.0.0.0'
  },
  define: {
    global: 'globalThis'
  }
})
