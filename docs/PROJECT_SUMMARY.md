# 博物馆文物数字化管理系统 - 项目综合总结

## 一、已实现的功能总结

本系统是一个功能完善的博物馆文物数字化管理平台，共实现了**27个核心功能模块**，覆盖文物管理的全生命周期。

### 1.1 核心业务功能（12个模块）

#### 1. 用户认证与权限管理
- JWT Token无状态认证机制
- 基于角色的访问控制（RBAC）
- 4种用户角色：系统管理员（ADMIN）、文物保管员（CURATOR）、借展审批员（APPROVER）、借展人（LOANER）
- BCrypt密码加密存储
- 登录失败次数限制（5次）与账户自动锁定（30分钟）
- IP地址记录与审计
- 密码重置功能（邮箱/手机验证码）

#### 2. 文物信息管理
- 文物CRUD操作（增删改查）
- 分页查询与多条件筛选
- 文物编号自动生成（格式：WW00001）
- 批量操作（批量删除、批量修改状态）
- Excel导入导出功能
- 打印标签功能
- 文物状态流转控制

#### 3. 3D文物展示 
- 基于Three.js的3D渲染引擎
- 支持GLTF/GLB/OBJ格式
- 交互控制（旋转、缩放、平移）
- 3D模型上传管理（拖拽上传、文件验证）
- 控制面板（自动旋转、重置视角、全屏显示）
- 光照系统与背景调节

#### 4. 文物二维码标签生成与扫描
- 唯一二维码生成（Google ZXing）
- 在线查看与下载功能
- 专业打印预览页面
- 扫描查看（无需登录）
- 移动端适配

#### 5. 文物分类管理
- 分类CRUD操作
- 树形结构展示（支持多级分类）
- 分类统计（实时统计文物数量）
- 图标化展示

#### 6. 借展管理
- 借展申请提交
- 借展审批流程（待审批  借出中  已归还 / 已驳回）
- 逾期状态标识与通知
- 日期验证（前后端双重验证）
- 5种状态统计

#### 7. 修复管理
- 修复申请提交（包含修复原因、优先级、专家分配）
- 修复审批流程
- 修复进度跟踪（5种状态）
- 修复专家管理（专家编号自动生成：EXP00001）
- 文物状态限制（防止重复申请）

#### 8. 维护记录管理
- 维护记录CRUD
- 维护类型分类（清洁、检查、保养、其他）
- 维护历史查询
- 日期验证

#### 9. 数字化档案管理 
- 档案CRUD操作
- 档案编号自动生成（格式：AR-年份-序号）
- 档案类型分类（完整档案、基础档案、图片档案、文档档案）
- 文档管理（上传、预览、下载、删除）
- PDF/Word导出功能（支持中文字体）
- 历史追踪（完整的操作历史记录）
- 状态流转（草稿  已发布  已归档）

#### 10. 博物馆管理
- 博物馆信息管理（CRUD操作）
- 博物馆编码管理（唯一编码约束）
- 用户-博物馆关联
- 前台登录博物馆选择
- 用户管理博物馆分配

#### 11. 消息通知系统 
- WebSocket实时推送（STOMP协议）
- 通知类型（借展申请、审批结果、逾期通知、修复申请等）
- 通知管理（列表查询、未读统计、标记已读、删除）
- 定时任务（每天凌晨检查逾期借展）
- 角色推送（向特定角色的所有用户推送）

#### 12. AI智能查询
- 智能查询引擎（关键词匹配、同义词扩展）
- 双层检索策略（馆藏优先 + 全网兜底）
- 图片智能抓取（7层提取策略）
- 会话管理（多轮对话、历史记录）
- 查询结果持久化（完整的数据链路）
- 相关度评分算法（0-100分）

### 1.2 数据分析与可视化（2个模块）

#### 13. 数据分析与报表
- 统计概览（文物总数、在库数、借展数、修复数）
- 分类统计、状态分布、年代分布
- 借展统计（5种状态）
- 修复统计（5种状态）
- 年度报告、月度报告

#### 14. 智能仪表盘（数据大屏）
- 核心指标卡片（带趋势指示）
- ECharts图表（饼图、柱状图）
- 亮色系配色方案
- 实时数据刷新（自动/手动）
- 自定义布局（3种布局模式）
- 全屏显示模式

### 1.3 用户管理功能（4个模块）

#### 15. 个人信息管理 
- 查看与编辑个人信息
- 修改密码功能
- 前台用户可修改所属博物馆
- 点击用户名跳转访问

#### 16. 员工管理 
- 员工角色管理（ADMIN/CURATOR/APPROVER）
- 完整的CRUD操作
- 搜索与筛选（按姓名、角色）
- 批量操作（批量删除、批量修改状态）

#### 17. 借展人管理 
- 借展人角色管理（LOANER）
- 博物馆关联（必须选择博物馆）
- 完整的CRUD操作
- 搜索与筛选（按姓名、博物馆）
- 批量操作

#### 18. 前台借展人端
- 独立的前台登录界面（棕色复古风格）
- 独立的前台界面
- 文物浏览与分类查询
- 申请借展（自动填充用户信息）
- AI智能查询
- 数据大屏

### 1.4 系统管理功能（5个模块）

#### 19. 操作日志管理
- AOP切面自动记录
- 操作日志查询（多条件筛选）
- 实时刷新（每5秒）
- 操作人姓名正确显示
- 操作结果标识（成功/失败）

#### 20. 批量操作
- 批量删除文物
- 批量修改状态
- 批量导出Excel
- 批量导入Excel
- 下载导入模板
- 批量打印标签

#### 21. 图片代理服务
- 代理外部图片请求
- 解决跨域问题
- 绕过防盗链限制
- Base64编码URL

#### 22. 异常处理与日志规范
- 自定义异常类体系（BusinessException、ValidationException等）
- 全局异常处理器
- 分级日志记录（ERROR/WARN/INFO/DEBUG）
- 敏感信息脱敏
- 规范文档（LOGGING_GUIDELINES.md、EXCEPTION_HANDLING_GUIDELINES.md）

#### 23. 密码重置功能
- 忘记密码流程（验证码验证）
- 邮件服务（HTML模板、多邮箱配置）
- 短信服务（阿里云SMS集成）
- 验证码管理（数据库持久化、15分钟有效期）
- 来源跟踪（前台/后台登录页面）

### 1.5 UI/UX功能（2个模块）

#### 24. 主题自定义系统 
- 6个预设主题（古典棕色、青瓷雅韵、青花瓷韵、紫檀沉香、墨玉清幽、琥珀金辉）
- 主题切换器（顶部导航栏）
- 主题持久化（localStorage）
- 平滑过渡动画（0.3s）
- 全局CSS变量系统

#### 25. 暗黑模式 
- 6个主题  2种模式 = 12种视觉风格
- 暗黑模式切换器（月亮/太阳图标）
- 智能颜色适配
- 护眼设计（减少蓝光刺激）
- 对比度优化（符合WCAG 2.1标准）

### 1.6 增强功能（2个模块）

#### 26. 文物详情增强展示
- 图片轮播展示（支持多图轮播）
- 时间轴展示（文物历史记录）
- 关联文物推荐（基于年代/材质/分类）
- 分享功能（复制链接、微信二维码）
- 打印功能（A4格式）

#### 27. 登录安全增强
- 登录失败次数限制（5次）
- 账户自动锁定（30分钟）
- IP地址记录
- 失败次数提示
- 自动重置（登录成功后）

---

## 二、最近修复的问题

### 2.1 3D模型链接删除功能修复（2026-05-15）

**问题描述**：删除文物的3D模型链接时，前端提示"删除成功"，但链接实际未被删除。

**根本原因**：MyBatis的`updateById()`方法在XML映射中使用了`<if test="model3dUrl != null">`条件判断，导致NULL值不会被包含在UPDATE语句中。

**解决方案**：
- 创建自定义SQL方法`clear3DModelInfo()`，显式将字段设置为NULL
- 修改文件：
  - `CulturalRelicMapper.xml` - 添加自定义UPDATE语句
  - `CulturalRelicMapper.java` - 添加接口方法
  - `CulturalRelicService.java` - 添加服务接口
  - `CulturalRelicServiceImpl.java` - 实现服务方法
  - `Relic3DController.java` - 使用新方法替代`updateById()`

**详细文档**：参见 `docs/3D_MODEL_DELETION_FIX.md`

### 2.4 3D模型详情页返回页码保持功能修复（2026-05-15）

**问题描述**：用户在文物列表的某一页点击查看3D模型，查看完毕后点击"返回"按钮，页面会重置到第一页，而不是保持在原来的页面。

**根本原因**：`goBack()` 函数使用 `router.back()` 只是简单返回，不会保留页面状态（页码、搜索条件等）。

**解决方案**：
- 采用 URL 查询参数传递状态的方案
- 跳转时传递当前页码和搜索条件
- 返回时恢复这些参数
- 列表页初始化时从 URL 读取并恢复状态
- 修改文件：
  - `RelicsView.vue` - 修改 `view3DModel` 函数传递状态，修改 `onMounted` 恢复状态
  - `Relic3DView.vue` - 修改 `goBack` 函数恢复查询参数

**详细文档**：参见 `docs/3D_VIEW_RETURN_PAGE_FIX.md`

### 2.5 备份加密密钥长度错误修复（2026-05-15）

**问题描述**：创建加密备份时失败，错误信息为"Invalid AES key length"。

**根本原因**：原密钥长度不符合AES标准（需要16/24/32字节），且某些Java版本不支持256位加密。

**解决方案**：
- 将加密方式从256位（32字节）改为128位（16字节）
- 使用固定密钥："CulturalRelics!"（16字节）
- 添加`getAESKey()`辅助方法确保密钥长度一致

### 2.3 隐藏功能实现（2026-05-15）

为简化用户界面，隐藏了以下功能（代码保留，可轻松恢复）：

1. **借展管理菜单** - `frontend/src/views/LayoutView.vue`
2. **博物馆管理菜单** - `frontend/src/views/LayoutView.vue`
3. **借展人管理菜单** - `frontend/src/views/LayoutView.vue`
4. **门户登录入口** - `frontend/src/views/LoginView.vue`
5. **逾期未归还通知** - `frontend/src/components/NotificationBell.vue` 和 `frontend/src/views/NotificationsView.vue`

**恢复方法**：参见 `docs/RESTORE_HIDDEN_FEATURES.md`

---

## 三、架构与技术栈

### 3.1 系统架构

本系统采用**前后端分离架构**，职责清晰，易于维护和扩展。

`

         前端层（Vue 3）              
  - 视图组件（Views）                 
  - 路由管理（Router）                
  - 状态管理（Pinia）                 
  - API 调用（Axios）                 
─
               HTTP/HTTPS

      控制层（Controller）            
  - 接收请求                          
  - 参数验证                          
  - 调用服务层                        
  - 返回响应                          

              

       服务层（Service）              
  - 业务逻辑处理                      
  - 事务管理                          
  - 数据转换                          

              

      持久层（Mapper/DAO）            
  - 数据库操作                        
  - SQL 映射                          

              

       数据层（MySQL）                
  - 数据存储                          
  - 索引优化                          

`

### 3.2 后端技术栈

#### 核心框架
- **Spring Boot 2.7.14**：快速开发框架，简化配置
- **Spring MVC**：Web层框架，处理HTTP请求
- **Spring Security**：安全框架，认证与授权
- **Spring AOP**：面向切面编程，实现操作日志
- **MyBatis 2.3.1**：持久层框架，SQL映射

#### 数据库
- **MySQL 8.0.33**：关系型数据库，主要数据存储
- **Redis**：缓存数据库，用于会话管理、登录安全

#### 安全认证
- **JWT (jjwt 0.11.5)**：JSON Web Token，无状态认证
- **BCrypt**：密码加密算法，加盐哈希

#### 文档处理
- **Apache POI 5.2.3**：Excel文件处理（导入导出）
- **iText 7.2.5**：PDF生成（档案导出）
- **html2pdf 4.0.5**：HTML转PDF
- **font-asian 7.2.5**：中文字体支持

#### 二维码与图像
- **Google ZXing 3.5.1**：二维码生成与解析
- **TwelveMonkeys ImageIO 3.9.4**：WEBP图片格式支持
- **Baidu AI SDK 4.16.18**：图像识别

#### 通信服务
- **Spring Boot Mail**：邮件发送服务
- **Spring WebSocket**：WebSocket实时通信
- **阿里云SMS SDK 2.0.24**：短信服务

#### 工具库
- **Lombok**：简化Java代码（自动生成getter/setter）
- **Hutool 5.8.16**：Java工具类库
- **Apache Commons Lang3**：通用工具类
- **Jackson JSR310**：Java 8日期时间处理
- **Jsoup**：HTML解析（网页爬虫）

#### API文档
- **Knife4j 3.0.3**：Swagger增强版，API文档生成

#### 构建工具
- **Maven**：项目管理与构建

### 3.3 前端技术栈

#### 核心框架
- **Vue 3.4.31**：渐进式JavaScript框架
- **Composition API**：组合式API，更好的代码组织
- **Vue Router 4.4.0**：路由管理，单页应用导航
- **Pinia 2.1.7**：状态管理，Vuex的替代方案

#### UI框架
- **Element Plus 2.7.8**：Vue 3组件库
  - Table、Form、Dialog、Button等丰富组件
  - 图标库：@element-plus/icons-vue

#### 数据可视化
- **ECharts 5.5.1**：数据可视化图表库
  - 饼图、柱状图、折线图等多种图表类型
  - 响应式设计，自适应容器大小

#### 3D渲染
- **Three.js 0.160.1**：3D渲染引擎
  - WebGLRenderer：硬件加速渲染
  - OrbitControls：轨道控制器
  - GLTFLoader、OBJLoader：模型加载器

#### 通信
- **Axios 1.7.2**：HTTP请求库
  - 请求拦截器：自动添加Token
  - 响应拦截器：统一错误处理
- **SockJS Client 1.6.1**：WebSocket客户端
- **@stomp/stompjs 7.3.0**：STOMP协议库

#### 国际化
- **Vue I18n 9.13.1**：国际化支持，中英文切换

#### 构建工具
- **Vite 5.3.4**：前端构建工具
  - 快速热更新（HMR）
  - 按需编译，开发体验极佳
- **@vitejs/plugin-vue 5.0.5**：Vue插件

---

## 四、技术栈详解

### 4.1 后端核心技术

#### 1. Spring Boot自动配置
Spring Boot通过自动配置简化了开发流程：
- **自动配置数据源**：根据依赖自动配置HikariCP连接池
- **自动配置MyBatis**：扫描Mapper接口，自动注册
- **自动配置Redis**：配置RedisTemplate和StringRedisTemplate
- **自动配置Security**：配置安全过滤器链

#### 2. JWT认证机制
`java
// Token生成
String token = Jwts.builder()
    .setSubject(username)
    .setIssuedAt(new Date())
    .setExpiration(new Date(System.currentTimeMillis() + expiration))
    .signWith(SignatureAlgorithm.HS512, secret)
    .compact();

// Token验证
Claims claims = Jwts.parser()
    .setSigningKey(secret)
    .parseClaimsJws(token)
    .getBody();
`

**优势**：
- 无状态：服务器不需要存储会话信息
- 可扩展：支持分布式部署
- 跨域友好：通过HTTP Header传递

#### 3. MyBatis动态SQL
`xml
<select id="selectByCondition" resultType="CulturalRelic">
    SELECT * FROM cultural_relic
    <where>
        <if test="name != null and name != ''">
            AND relic_name LIKE CONCAT('%', #{name}, '%')
        </if>
        <if test="era != null and era != ''">
            AND era = #{era}
        </if>
        <if test="status != null and status != ''">
            AND status = #{status}
        </if>
    </where>
</select>
`

#### 4. AOP切面编程
`java
@Around("@annotation(operationLog)")
public Object around(ProceedingJoinPoint joinPoint, OperationLog operationLog) {
    // 记录操作前信息
    String username = SecurityUtils.getUsername();
    String ip = getClientIp();
    
    try {
        // 执行目标方法
        Object result = joinPoint.proceed();
        // 记录成功日志
        saveLog(username, ip, "成功");
        return result;
    } catch (Exception e) {
        // 记录失败日志
        saveLog(username, ip, "失败");
        throw e;
    }
}
`

#### 5. Redis缓存策略
`java
// 登录失败次数记录
String key = "login:failed:" + username;
redisTemplate.opsForValue().increment(key);
redisTemplate.expire(key, 30, TimeUnit.MINUTES);

// 账户锁定
String lockKey = "login:locked:" + username;
redisTemplate.opsForValue().set(lockKey, "1", 30, TimeUnit.MINUTES);
`

### 4.2 前端核心技术

#### 1. Vue 3 Composition API
`javascript
import { ref, onMounted, computed } from 'vue'

export default {
  setup() {
    const relics = ref([])
    const loading = ref(false)
    
    const totalCount = computed(() => relics.value.length)
    
    const fetchRelics = async () => {
      loading.value = true
      try {
        const response = await api.getRelics()
        relics.value = response.data
      } finally {
        loading.value = false
      }
    }
    
    onMounted(() => {
      fetchRelics()
    })
    
    return { relics, loading, totalCount, fetchRelics }
  }
}
`

#### 2. Axios请求拦截
`javascript
// 请求拦截器
axios.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = Bearer 
  }
  return config
})

// 响应拦截器
axios.interceptors.response.use(
  response => response.data,
  error => {
    if (error.response.status === 401) {
      // 跳转到登录页
      router.push('/login')
    }
    return Promise.reject(error)
  }
)
`

#### 3. Vue Router路由守卫
`javascript
router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !token) {
    // 需要认证但未登录，跳转到登录页
    next('/login')
  } else if (to.meta.roles) {
    // 检查角色权限
    const userRole = localStorage.getItem('role')
    if (to.meta.roles.includes(userRole)) {
      next()
    } else {
      next('/403')
    }
  } else {
    next()
  }
})
`

#### 4. ECharts图表配置
`javascript
const option = {
  title: { text: '文物分类统计' },
  tooltip: { trigger: 'item' },
  legend: { orient: 'vertical', left: 'left' },
  series: [{
    name: '文物数量',
    type: 'pie',
    radius: '50%',
    data: [
      { value: 1048, name: '青铜器' },
      { value: 735, name: '陶瓷' },
      { value: 580, name: '玉器' },
      { value: 484, name: '书画' }
    ],
    emphasis: {
      itemStyle: {
        shadowBlur: 10,
        shadowOffsetX: 0,
        shadowColor: 'rgba(0, 0, 0, 0.5)'
      }
    }
  }]
}
`

#### 5. Three.js 3D渲染
`javascript
// 创建场景
const scene = new THREE.Scene()

// 创建相机
const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 1000)

// 创建渲染器
const renderer = new THREE.WebGLRenderer({ antialias: true })
renderer.setSize(width, height)

// 加载模型
const loader = new GLTFLoader()
loader.load(modelUrl, (gltf) => {
  scene.add(gltf.scene)
})

// 添加光照
const light = new THREE.DirectionalLight(0xffffff, 1)
scene.add(light)

// 渲染循环
function animate() {
  requestAnimationFrame(animate)
  renderer.render(scene, camera)
}
animate()
`

---

## 五、核心算法与技术点

### 5.1 认证与授权算法

#### BCrypt密码加密
- **算法**：Blowfish加密算法
- **加盐**：每次加密生成随机盐值
- **迭代次数**：默认10轮（2^10 = 1024次）
- **特点**：相同密码每次加密结果不同，防止彩虹表攻击

`java
// 密码加密
String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());

// 密码验证
boolean isMatch = BCrypt.checkpw(plainPassword, hashedPassword);
`

### 5.2 AI智能查询算法

#### 相关度评分算法
`java
总分 = 名称匹配分(40分) + 年代匹配分(24分) + 材质匹配分(24分) 
     + 分类匹配分(20分) + 描述匹配分(12分) + 来源匹配分(10分)
`

**评分规则**：
- 整句命中：名称+80分、编号+70分、描述+30分
- 关键词命中：名称+40分、编号+35分、年代+24分、材质+24分
- 同义词匹配：自动识别同义词并计分

#### 关键词扩展算法
`java
输入："青铜器"
扩展：["青铜器", "铜器", "青铜"]

输入："唐代瓷器"
分词：["唐代", "瓷器"]
扩展：["唐代", "瓷器", "陶瓷", "陶器", "瓷"]
`

### 5.3 图片提取算法

#### 7层提取策略
`java
String extractImageUrl(Document doc) {
    // 1. og:image meta标签
    Element ogImage = doc.selectFirst("meta[property=og:image]");
    if (ogImage != null) return ogImage.attr("content");
    
    // 2. 百度百科特定选择器
    Element baikeImg = doc.selectFirst(".summary-pic img");
    if (baikeImg != null) return baikeImg.attr("src");
    
    // 3. class="summary-pic"图片
    Element summaryPic = doc.selectFirst("img.summary-pic");
    if (summaryPic != null) return summaryPic.attr("src");
    
    // 4. 第一个有效img标签
    Elements imgs = doc.select("img[src]");
    for (Element img : imgs) {
        String src = img.attr("src");
        if (isValidImageUrl(src)) return src;
    }
    
    // 5. data-src属性（懒加载）
    Element lazyImg = doc.selectFirst("img[data-src]");
    if (lazyImg != null) return lazyImg.attr("data-src");
    
    // 6. srcset属性（响应式）
    Element srcsetImg = doc.selectFirst("img[srcset]");
    if (srcsetImg != null) {
        String srcset = srcsetImg.attr("srcset");
        return parseSrcset(srcset);
    }
    
    // 7. CSS背景图片
    return extractBackgroundImage(doc);
}
`

### 5.4 分页算法

#### MyBatis-Plus分页
`java
// 创建分页对象
Page<CulturalRelic> page = new Page<>(pageNum, pageSize);

// 执行分页查询
IPage<CulturalRelic> result = culturalRelicMapper.selectPage(page, queryWrapper);

// 获取结果
List<CulturalRelic> records = result.getRecords();
long total = result.getTotal();
long pages = result.getPages();
`

**分页计算**：
- 偏移量：offset = (pageNum - 1) * pageSize
- 总页数：	otalPages = Math.ceil(total / pageSize)

### 5.5 推荐算法

#### 基于内容的协同过滤
`java
List<CulturalRelic> recommend(CulturalRelic relic) {
    return allRelics.stream()
        .filter(r -> r.getId() != relic.getId())
        .filter(r -> 
            r.getEra().equals(relic.getEra()) ||           // 相同年代：权重0.4
            r.getMaterial().equals(relic.getMaterial()) || // 相同材质：权重0.3
            r.getCategoryId().equals(relic.getCategoryId()) // 相同分类：权重0.3
        )
        .limit(4)
        .collect(Collectors.toList());
}
`

### 5.6 数据聚合算法

#### Stream API分组统计
`java
// 按分类统计文物数量
Map<String, Long> categoryStats = relics.stream()
    .collect(Collectors.groupingBy(
        CulturalRelic::getCategoryName,
        Collectors.counting()
    ));

// 按状态统计
Map<String, Long> statusStats = relics.stream()
    .collect(Collectors.groupingBy(
        CulturalRelic::getStatus,
        Collectors.counting()
    ));
`

### 5.7 性能优化技术

#### 前端优化
- **懒加载**：图片懒加载、路由懒加载
- **防抖节流**：
`javascript
const debounce = (fn, delay) => {
    let timer = null;
    return (...args) => {
        clearTimeout(timer);
        timer = setTimeout(() => fn(...args), delay);
    };
};

const throttle = (fn, delay) => {
    let lastTime = 0;
    return (...args) => {
        const now = Date.now();
        if (now - lastTime >= delay) {
            fn(...args);
            lastTime = now;
        }
    };
};
`
- **虚拟滚动**：大列表优化
- **组件缓存**：keep-alive缓存组件状态

#### 后端优化
- **索引优化**：数据库字段添加索引
- **连接池**：HikariCP数据库连接池
- **缓存策略**：Redis缓存热点数据
- **批量操作**：批量插入/更新减少数据库交互

---



---

**文档创建完成！**

本文档全面总结了博物馆文物数字化管理系统的27个核心功能模块、技术栈、核心算法、数据库设计、系统架构、项目亮点和未来扩展方向。


---

## 六、数据库设计

### 6.1 核心表结构

本系统共设计了**20+张数据库表**，涵盖文物管理、用户管理、借展管理、修复管理、档案管理、通知管理等各个方面。

#### 1. cultural_relic（文物表）
**功能**：存储文物基本信息
**关键字段**：
- id：主键，自增
- relic_code：文物编号（唯一索引）
- relic_name：文物名称
- era：年代
- material：材质
- category_id：分类ID（外键）
- status：状态（在库/借出/修复中）
- dimensions：尺寸
- weight：重量
- image_path：图片路径
- model_3d_url：3D模型URL
- origin：来源
- description：描述
- create_time、update_time：时间戳

**索引设计**：
- PRIMARY KEY (id)
- UNIQUE INDEX idx_relic_code (relic_code)
- INDEX idx_category_id (category_id)
- INDEX idx_status (status)

#### 2. cultural_relic_category（分类表）
**功能**：文物分类管理，支持树形结构
**关键字段**：
- id：主键
- category_name：分类名称
- parent_id：父分类ID（实现树形结构）
- description：描述

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_parent_id (parent_id)

#### 3. loan_record（借展记录表）
**功能**：记录文物借展信息
**关键字段**：
- id：主键
- relic_id：文物ID（外键）
- borrower：借展人
- institution：借展机构
- loan_date：借展日期
- return_date：预计归还日期
- actual_return_date：实际归还日期
- status：状态（待审批/借出中/已归还/已驳回/逾期）
- purpose：借展目的
- approver：审批人
- approve_time：审批时间

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_relic_id (relic_id)
- INDEX idx_status (status)
- INDEX idx_loan_date (loan_date)

#### 4. repair_record（修复记录表）
**功能**：记录文物修复信息
**关键字段**：
- id：主键
- relic_id：文物ID（外键）
- expert_id：专家ID（外键）
- repair_type：修复类型
- start_date：开始日期
- end_date：结束日期
- status：状态（待审批/待修复/修复中/已完成/已拒绝）
- description：描述
- result：修复结果

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_relic_id (relic_id)
- INDEX idx_expert_id (expert_id)
- INDEX idx_status (status)

#### 5. sys_user（用户表）
**功能**：存储系统用户信息
**关键字段**：
- id：主键
- username：用户名（唯一索引）
- password：密码（BCrypt加密）
- real_name：真实姓名
- role：角色（ADMIN/CURATOR/APPROVER/LOANER）
- email：邮箱
- phone：手机号
- status：状态（ACTIVE/INACTIVE）
- login_failed_count：登录失败次数
- account_locked：账户锁定状态
- locked_time：锁定时间
- last_login_ip：最后登录IP

**索引设计**：
- PRIMARY KEY (id)
- UNIQUE INDEX idx_username (username)
- INDEX idx_role (role)

#### 6. museum（博物馆表）
**功能**：存储博物馆信息
**关键字段**：
- id：主键
- museum_code：博物馆编码（唯一索引）
- museum_name：博物馆名称
- museum_type：博物馆类型
- province：省份
- city：城市
- address：详细地址
- contact_person：联系人
- contact_phone：联系电话
- contact_email：联系邮箱
- status：状态

**索引设计**：
- PRIMARY KEY (id)
- UNIQUE INDEX idx_museum_code (museum_code)
- INDEX idx_city (city)

#### 7. user_museum（用户博物馆关联表）
**功能**：用户与博物馆的多对多关系
**关键字段**：
- id：主键
- user_id：用户ID（外键）
- museum_id：博物馆ID（外键）
- is_primary：是否主要博物馆

**索引设计**：
- PRIMARY KEY (id)
- UNIQUE INDEX idx_user_museum (user_id, museum_id)
- INDEX idx_user_id (user_id)
- INDEX idx_museum_id (museum_id)

#### 8. relic_archive（文物档案表）
**功能**：存储文物档案信息
**关键字段**：
- id：主键
- archive_code：档案编号（唯一索引，格式：AR-年份-序号）
- relic_id：文物ID（外键）
- archive_type：档案类型
- title：档案标题
- status：状态（草稿/已发布/已归档）
- version：版本号
- creator_id：创建人ID
- creator_name：创建人姓名

**索引设计**：
- PRIMARY KEY (id)
- UNIQUE INDEX idx_archive_code (archive_code)
- INDEX idx_relic_id (relic_id)
- INDEX idx_status (status)

#### 9. archive_document（档案文档表）
**功能**：存储档案关联的文档
**关键字段**：
- id：主键
- archive_id：档案ID（外键）
- document_type：文档类型
- file_name：文件名
- file_path：文件路径
- file_size：文件大小
- uploader_id：上传人ID
- uploader_name：上传人姓名

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_archive_id (archive_id)

#### 10. system_notification（系统通知表）
**功能**：存储系统通知信息
**关键字段**：
- id：主键
- title：通知标题
- content：通知内容
- type：通知类型（LOAN_APPLY/LOAN_APPROVED/REPAIR_APPLY等）
- related_id：关联ID

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_type (type)
- INDEX idx_create_time (create_time)

#### 11. user_notification（用户通知关联表）
**功能**：用户与通知的多对多关系
**关键字段**：
- id：主键
- user_id：用户ID（外键）
- notification_id：通知ID（外键）
- is_read：是否已读
- read_time：阅读时间

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_user_id (user_id)
- INDEX idx_notification_id (notification_id)
- INDEX idx_is_read (is_read)

#### 12. ai_chat_session（AI会话表）
**功能**：存储AI查询会话信息
**关键字段**：
- id：主键
- user_id：用户ID（外键）
- title：会话标题
- create_time、update_time：时间戳

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_user_id (user_id)

#### 13. ai_chat_message（AI消息表）
**功能**：存储AI查询消息记录
**关键字段**：
- id：主键
- session_id：会话ID（外键）
- role：角色（user/assistant）
- content：消息内容

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_session_id (session_id)

#### 14. ai_query_result（AI查询结果表）
**功能**：存储AI查询结果详情
**关键字段**：
- id：主键
- message_id：消息ID（外键）
- relic_id：文物ID（外键）
- relevance：相关度评分（0-100）
- source_type：来源类型（馆藏/外部）
- source_name：来源名称
- match_tags：匹配标签

**索引设计**：
- PRIMARY KEY (id)
- INDEX idx_message_id (message_id)

### 5.2 数据库设计特点

#### 1. 索引优化
- **主键索引**：所有表都有自增主键，保证唯一性
- **唯一索引**：编号字段（relic_code、museum_code、archive_code等）防止重复
- **普通索引**：外键字段、状态字段、日期字段，提高查询效率
- **复合索引**：多条件查询字段组合（如user_id + museum_id）

#### 2. 字段设计
- **时间戳**：create_time、update_time自动维护，记录数据变更
- **软删除**：使用status字段标记删除状态，保留历史数据
- **枚举值**：status、type等字段使用VARCHAR存储，便于扩展
- **文本字段**：description使用TEXT类型，支持长文本

#### 3. 关联关系
- **一对多**：文物-借展记录、文物-修复记录、文物-档案
- **多对多**：用户-博物馆（通过user_museum关联表）、用户-通知（通过user_notification关联表）
- **树形结构**：分类表使用parent_id实现多级分类

#### 4. 数据完整性
- **外键约束**：保证数据一致性（如relic_id必须存在于cultural_relic表）
- **非空约束**：关键字段NOT NULL（如relic_name、username）
- **默认值**：status、create_time等字段有默认值
- **唯一约束**：防止重复数据（如username、relic_code）

#### 5. 性能优化
- **分表策略**：将大表拆分为多个小表（如档案表、文档表分离）
- **冗余字段**：适当冗余（如creator_name），减少JOIN查询
- **分页查询**：使用LIMIT和OFFSET实现分页
- **缓存策略**：热点数据使用Redis缓存

---

## 七、系统架构设计

### 7.1 整体架构

本系统采用**前后端分离架构**，基于**三层架构**设计，职责清晰，易于维护和扩展。

\\\

                      前端层（Vue 3）                         
               
     Views        Components       Router             
    (页面组件)     (可复用组件)     (路由管理)           
               
               
     Store            API          Utils              
    (状态管理)      (接口调用)      (工具函数)           
               

                           HTTP/HTTPS (RESTful API)

                    后端层（Spring Boot）                     
               
   Controller       Service        Mapper             
    (控制层)        (业务层)        (数据层)             
               
               
     Config          Utils         Aspect             
    (配置类)        (工具类)        (切面类)             
               

                           JDBC

                    数据层（MySQL + Redis）                   
               
      MySQL          Redis        File Store          
   (关系数据库)     (缓存数据库)     (文件存储)           
               

\\\

### 7.2 分层架构详解

#### 表现层（Presentation Layer）
**职责**：处理用户交互，展示数据
**技术**：Vue 3 + Element Plus + ECharts + Three.js
**组件**：
- **Views**：页面组件（如RelicsView.vue、LoanRecordsView.vue）
- **Components**：可复用组件（如ThemeSwitcher.vue、DarkModeToggle.vue）
- **Router**：路由管理（Vue Router 4）
- **Store**：状态管理（Pinia）
- **API**：接口调用（Axios）
- **Utils**：工具函数（日期格式化、权限检查等）

#### 业务逻辑层（Business Logic Layer）
**职责**：处理业务逻辑，协调数据访问
**技术**：Spring Boot + Spring MVC + Spring Security
**组件**：
- **Controller**：接收请求，返回响应（如CulturalRelicController）
- **Service**：业务逻辑处理（如CulturalRelicService）
- **DTO**：数据传输对象（如LoginRequest、LoginResponse）
- **Validator**：数据验证（如@Valid注解）
- **Config**：配置类（如SecurityConfig、CorsConfig）
- **Aspect**：切面类（如OperationLogAspect）

#### 数据访问层（Data Access Layer）
**职责**：数据持久化，数据库操作
**技术**：MyBatis + MySQL + Redis
**组件**：
- **Mapper**：数据访问接口（如CulturalRelicMapper）
- **Entity**：实体类（如CulturalRelic）
- **XML**：SQL映射文件（如CulturalRelicMapper.xml）
- **RedisTemplate**：Redis操作模板

### 7.3 安全架构

#### 认证流程
\\\
1. 用户登录
   
2. 验证用户名密码（BCrypt）
   
3. 检查登录失败次数（Redis）
   
4. 检查账户锁定状态（Redis）
   
5. 生成JWT Token
   
6. 返回Token给前端
   
7. 前端存储Token（localStorage）
   
8. 后续请求携带Token（Authorization Header）
   
9. 后端验证Token（JwtAuthenticationFilter）
   
10. 提取用户信息（SecurityUtils）
   
11. 执行业务逻辑
\\\

#### 授权流程
\\\
1. 请求资源
   
2. 提取Token
   
3. 验证Token有效性
   
4. 提取用户角色
   
5. 检查角色权限（@PreAuthorize）
   
6. 权限通过  执行业务逻辑
   
7. 权限拒绝  返回403 Forbidden
\\\

### 7.4 通信架构

#### HTTP通信
- **协议**：HTTP/HTTPS
- **格式**：JSON
- **认证**：Bearer Token（JWT）
- **跨域**：CORS配置（允许指定域名访问）
- **请求拦截**：Axios请求拦截器自动添加Token
- **响应拦截**：Axios响应拦截器统一错误处理

#### WebSocket通信
- **协议**：WebSocket + STOMP
- **端点**：/ws-notification
- **消息代理**：
  - /topic：广播消息（所有订阅者）
  - /queue：点对点消息（特定用户）
- **用途**：实时通知推送
- **自动重连**：连接断开后自动重连（最多5次）

### 7.5 缓存架构

#### Redis缓存策略
- **会话缓存**：用户登录状态（Token  用户信息）
- **登录安全**：
  - login:failed:{username}：登录失败次数（TTL 30分钟）
  - login:locked:{username}：账户锁定状态（TTL 30分钟）
- **热点数据**：统计数据、配置信息
- **过期策略**：TTL自动过期

#### 缓存更新策略
- **Cache Aside Pattern**：先更新数据库，再删除缓存
- **Write Through Pattern**：同时更新数据库和缓存
- **Write Behind Pattern**：先更新缓存，异步更新数据库

### 7.6 文件存储架构

#### 本地存储
- **文物图片**：uploads/images/
- **3D模型**：uploads/3d-models/
- **档案文档**：uploads/archives/
- **临时文件**：uploads/temp/

#### 文件访问
- **静态资源**：通过Nginx代理
- **图片代理**：解决防盗链问题（ImageProxyController）
- **下载服务**：设置Content-Disposition响应头

#### 未来扩展
- **对象存储**：阿里云OSS、MinIO
- **CDN加速**：静态资源CDN分发
- **分布式存储**：FastDFS、HDFS

---

## 八、项目亮点和重难点
### 8.1 技术亮点

#### 1. 前后端分离架构
优势：职责清晰，易于维护和扩展
实现：Vue 3 + Spring Boot，RESTful API
效果：前后端独立开发，提高开发效率

#### 2. JWT无状态认证
优势：支持分布式部署，无需服务器存储会话
实现：JWT Token + Spring Security
效果：可扩展性强，支持微服务架构

#### 3. AOP切面编程
优势：代码解耦，统一处理横切关注点
实现：@OperationLog注解 + AspectJ
效果：自动记录操作日志，无需手动编写

#### 4. WebSocket实时通信
优势：实时推送，用户体验好
实现：Spring WebSocket + STOMP
效果：实时通知，无需轮询

#### 5. 3D文物展示
优势：沉浸式体验，数字化展示
实现：Three.js + WebGL
效果：360度查看文物，虚拟展览

#### 6. AI智能查询
优势：智能检索，全网兜底
实现：关键词匹配 + 网页爬虫
效果：馆藏优先，全网补充

#### 7. 主题自定义系统
优势：个性化界面，提升用户体验
实现：CSS变量 + localStorage
效果：6个主题 × 2种模式 = 12种视觉风格

#### 8. 批量操作优化
优势：提高效率，减少操作次数
实现：Promise.all并发处理
效果：批量删除、批量修改状态

### 8.2 功能亮点

#### 1. 完整的文物生命周期管理
从入库、借展、修复、维护到档案管理
覆盖文物管理全流程
状态流转控制，防止非法操作

#### 2. 双层检索策略
馆藏优先：优先检索本馆文物
全网兜底：馆藏无结果时自动触发全网检索
智能评分：基于相关度排序

#### 3. 实时通知系统
WebSocket实时推送
角色推送：向特定角色的所有用户推送
定时任务：每天凌晨检查逾期借展

#### 4. 数字化档案管理
档案CRUD操作
文档管理（上传、预览、下载）
PDF/Word导出（支持中文字体）
历史追踪（完整的操作历史记录）

#### 5. 登录安全增强
登录失败次数限制（5次）
账户自动锁定（30分钟）
IP地址记录
密码重置（邮箱/手机验证码）

### 8.3 重难点突破

#### 1. 图片防盗链问题
问题：百度百科图片无法直接显示
解决：实现图片代理服务，设置正确的Referer头

#### 2. 批量操作性能
问题：大量数据批量处理性能差
解决：使用事务批量提交，优化SQL语句

#### 3. 图表渲染性能
问题：大量数据点导致图表卡顿
解决：数据采样、虚拟渲染、按需加载

#### 4. 跨域问题
问题：前后端分离导致跨域请求被拦截
解决：配置CORS，允许指定域名访问

#### 5. WebSocket连接管理
问题：WebSocket连接断开后无法自动重连
解决：实现自动重连机制（最多5次重试）

#### 6. 3D模型加载优化
问题：大文件3D模型加载慢
解决：文件大小限制、加载进度显示、模型自动缩放

#### 7. 异常处理统一
问题：异常处理分散，错误信息不统一
解决：自定义异常类体系、全局异常处理器、分级日志记录

## 九、未来扩展方向
### 9.1 功能扩展

#### 已完成 ✅
3D文物展示（Three.js）
文物二维码标签生成与扫描
数字化档案管理
消息通知系统
主题自定义系统
暗黑模式

#### 计划中 🔲
AR虚拟展览（AR.js）
移动端APP（React Native/Flutter）
微信小程序
语音导览
多语言支持增强
文物保险管理
展览活动管理
访客管理系统
文物捐赠管理

### 9.2 技术升级

架构升级
微服务架构（Spring Cloud）
消息队列（RabbitMQ/Kafka）
搜索引擎（Elasticsearch）
对象存储（OSS/MinIO）
CDN加速
部署优化
Docker容器化部署
Kubernetes集群管理
Redis集群
MySQL主从复制
Nginx负载均衡
监控告警
Prometheus + Grafana
ELK Stack（日志分析）
链路追踪（Zipkin/Skywalking）

### 9.3 AI增强

图像识别
文物自动分类
OCR文字识别（古籍文物）
图像修复（破损文物数字化修复）
风格迁移（文物艺术风格分析）
自然语言处理
智能问答（ChatGPT、文心一言）
语音识别（语音导览）
情感分析（理解用户查询意图）
推荐系统
深度学习推荐算法
个性化推荐
协同过滤优化
异常检测
文物状态监控
预测分析（借展趋势、修复需求）

### 9.4 数据分析增强

更多维度的统计分析
预测分析（借展趋势、修复需求）
数据挖掘（文物关联分析）
可视化报表导出（PDF、Word）
自定义报表生成器
实时数据大屏（WebSocket）

### 9.5 用户体验优化

已完成 ✅
暗黑模式
主题自定义
批量编辑优化
消息通知系统
计划中 🔲
快捷键支持
拖拽排序
离线模式（PWA）
工作流自定义

## 十、总结
### 10.1 项目成果
本项目是一个功能完善、技术先进的博物馆文物数字化管理系统，具有以下特点：
功能完善
27个核心功能模块，覆盖文物管理全生命周期
4种用户角色，满足不同用户需求
前后台分离，管理员端和借展人端独立
技术先进
前后端分离架构，职责清晰
JWT无状态认证，支持分布式部署
WebSocket实时通信，用户体验好
3D文物展示，沉浸式体验
AI智能查询，双层检索策略
安全可靠
BCrypt密码加密，防止彩虹表攻击
登录安全增强，失败次数限制、账户锁定
操作日志审计，完整的操作记录
异常处理统一，分级日志记录
用户体验
主题自定义，6个主题 × 2种模式 = 12种视觉风格
响应式设计，适配PC和移动端
批量操作，提高效率
实时通知，及时提醒


### 10.2 技术收获
通过本项目的开发，深入理解了以下技术：

#### 后端技术
Spring Boot自动配置机制
Spring Security认证与授权
MyBatis动态SQL
AOP切面编程
Redis缓存策略
WebSocket实时通信
邮件和短信服务集成

#### 前端技术
Vue 3 Composition API
Vue Router路由管理
Axios请求拦截
ECharts数据可视化
Three.js 3D渲染
WebSocket客户端

#### 架构设计
前后端分离架构
RESTful API设计
分层架构设计
安全架构设计
缓存架构设计

#### 工程实践
代码规范与最佳实践
异常处理与日志规范
性能优化技术
安全防护措施
项目文档编写

### 10.3 项目价值

#### 实用价值
解决博物馆文物管理的实际需求
提高文物管理效率
降低管理成本
提升用户体验

#### 学习价值
完整的全栈项目开发经验
主流技术栈的实践应用
架构设计能力的提升
工程实践能力的锻炼

#### 扩展价值
可扩展的架构设计
丰富的功能模块
完善的文档体系
为未来升级奠定基础


-----



附录：项目运行说明
环境要求
JDK：8+
Node.js：16+
MySQL：8.0
Redis：6.0+
Maven：3.6+
后端启动
cd backend
mvn clean install
mvn spring-boot:run
前端启动
cd frontend
npm install
npm run dev
访问地址
前端：http://localhost:5173
后端：http://localhost:8080
API文档：http://localhost:8080/doc.html
默认账号
系统管理员：admin / 123456
馆长：curator01 / 123456
审批员：approver01 / 123456
借展人：loaner / 123456
注意事项
首次运行需要执行数据库初始化脚本
确保MySQL和Redis服务已启动
修改application.yml中的数据库连接配置
配置邮件服务（修改application-mail-qq.yml或application-mail-163.yml）
配置短信服务（修改application.yml中的阿里云SMS配置，或设置sms.enabled=false禁用）
借展人用户需要在数据库中设置phone字段才能正常使用申请借展功能
借展人登录时必须选择所属博物馆
新增借展人用户时必须分配博物馆
系统预置了10个示例博物馆数据
前端需要建立WebSocket连接才能接收实时通知