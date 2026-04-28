<template>
  <div style="padding: 20px; background: white;">
    <h1>测试页面</h1>
    <p>如果您能看到这个页面，说明Vue和路由工作正常。</p>
    <p>当前路径: {{ $route.path }}</p>
    <p>Token: {{ token }}</p>
    <p>Role: {{ role }}</p>
    <el-button type="primary" @click="goToLogin">去登录</el-button>
    <el-button type="success" @click="goToPortal">去前台</el-button>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()
const token = computed(() => sessionStorage.getItem('token'))
const role = computed(() => sessionStorage.getItem('role'))

const goToLogin = () => {
  router.push('/login')
}

const goToPortal = () => {
  router.push('/portal')
}
</script>
