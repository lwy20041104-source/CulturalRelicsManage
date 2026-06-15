import axios from 'axios'

// 自动检测环境，支持localhost和局域网IP访问
const getBaseURL = () => {
  const hostname = window.location.hostname
  const protocol = window.location.protocol
  
  // 如果是localhost或127.0.0.1，使用localhost
  if (hostname === 'localhost' || hostname === '127.0.0.1') {
    return 'http://localhost:8080/api'
  }
  
  // 否则使用当前访问的IP地址（局域网IP或域名）
  return `${protocol}//${hostname}:8080/api`
}

const request = axios.create({
  baseURL: getBaseURL(),
  timeout: 10000
})

request.interceptors.request.use(config => {
  const token = sessionStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

request.interceptors.response.use(
  response => {
    const data = response.data
    const businessCode = Number(data?.code)
    
    // 检查业务状态码
    if (data?.code !== undefined && businessCode !== 200) {
      // 业务失败，抛出错误
      const error = new Error(data.message || '请求失败')
      error.response = { data: data }
      return Promise.reject(error)
    }
    
    // 业务成功，返回data
    // 非GET请求成功后派发全局事件，供操作日志等页面实时刷新
    if (response.config.method && response.config.method.toLowerCase() !== 'get') {
      window.dispatchEvent(new CustomEvent('operation-done'))
    }
    return data
  },
  error => {
    // HTTP错误响应处理
    if (error.response) {
      const errorData = error.response.data
      
      // 如果后端返回的是标准格式 {code, message, data}
      if (errorData && errorData.message) {
        const customError = new Error(errorData.message)
        customError.response = { data: errorData }
        return Promise.reject(customError)
      }
    }
    
    // 其他错误（网络错误等）
    return Promise.reject(error)
  }
)

export default request
