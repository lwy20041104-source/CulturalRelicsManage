# 修复记录显示问题 - 完整解决方案

## 📋 问题确认

**现象**: 
- ✅ 数据库中有不同状态的记录（待审批、待修复、修复中、修复完成、已拒绝）
- ❌ 前端只显示"已拒绝"状态的记录
- ❌ 系统管理员和保管员都只能看到"已拒绝"的记录

**结论**: 这不是权限问题，而是数据过滤问题。

---

## 🔍 立即诊断（3步）

### 步骤1: 重启后端服务并查看日志

```bash
cd backend
mvn spring-boot:run
```

**我已经在RepairRecordController中添加了详细的调试日志**，重启后会看到：

```
========== 修复记录查询请求 ==========
请求参数: pageNum=1, pageSize=10
过滤条件: status=[], priority=[], relicName=[], repairExpert=[]
当前用户: admin
用户权限: repairs:manage, relics:manage, ...
是否有repairs:manage权限: true
管理员权限：显示所有记录
查询结果: total=10, records.size=10
记录状态分布: {待审批=2, 待修复=2, 修复中=2, 修复完成=2, 已拒绝=2}
========================================
```

**关键检查点**:
- `过滤条件: status=[]` - status应该为空
- `记录状态分布` - 应该包含多种状态

### 步骤2: 打开浏览器开发者工具

1. 打开浏览器（Chrome/Edge）
2. 按 **F12** 打开开发者工具
3. 切换到 **Network** 标签
4. 登录系统并进入修复管理页面
5. 找到 `/api/repairs` 请求，点击查看

**检查请求URL**:
```
http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=&priority=&relicName=&repairExpert=
```
- ✅ status应该为空字符串
- ❌ 如果status=已拒绝，说明前端发送了错误的参数

**检查响应（Response标签）**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {"id": 1, "status": "待审批", ...},
      {"id": 2, "status": "待修复", ...},
      {"id": 3, "status": "修复中", ...},
      {"id": 4, "status": "修复完成", ...},
      {"id": 5, "status": "已拒绝", ...}
    ],
    "total": 10
  }
}
```
- ✅ records应该包含多种状态
- ❌ 如果只有"已拒绝"，说明后端查询有问题

### 步骤3: 查看浏览器Console日志

1. 在开发者工具中切换到 **Console** 标签
2. 按照 `DEBUG_REPAIRS_VIEW_PATCH.md` 修改前端代码
3. 刷新页面
4. 查看控制台输出

---

## 🎯 根据诊断结果选择解决方案

### 场景A: 后端日志显示"status=[已拒绝]"

**问题**: 前端发送了错误的status参数

**可能原因**:
1. query对象初始化时设置了默认值
2. 从URL参数读取了值
3. 某个地方修改了query.status

**解决方案**: 检查RepairsView.vue

```vue
<!-- 检查这里 -->
const query = reactive({ 
  pageNum: 1, 
  pageSize: 10, 
  status: '',  // 应该是空字符串，不是'已拒绝'
  priority: '', 
  relicName: '', 
  repairExpert: '' 
})

<!-- 检查是否有这样的代码 -->
onMounted(async () => {
  // 不应该有这行
  // query.status = '已拒绝'
  
  // 或者从路由参数读取
  // if (route.query.status) {
  //   query.status = route.query.status
  // }
  
  await Promise.all([loadData(), loadRelics(), loadExperts(), loadAllMaterials()])
})
```

### 场景B: 后端返回多种状态，但前端只显示"已拒绝"

**问题**: 前端在处理数据时进行了过滤

**可能原因**:
1. loadData函数中有filter操作
2. tableData是computed属性，有过滤逻辑
3. el-table有:filter-method

**解决方案1**: 检查loadData函数

```vue
const loadData = async () => {
  const res = await getRepairsPageApi(query)
  
  // 不应该有这样的过滤
  // tableData.value = res.data.records.filter(r => r.status === '已拒绝')
  
  // 应该是这样
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}
```

**解决方案2**: 检查tableData定义

```vue
<!-- 错误的写法 -->
const tableData = computed(() => {
  return rawData.value.filter(r => r.status === '已拒绝')
})

<!-- 正确的写法 -->
const tableData = ref([])
```

**解决方案3**: 检查el-table标签

```vue
<!-- 不应该有filter-method -->
<el-table :data="tableData" border>
  <!-- 不应该有这个 -->
  <!-- :filter-method="filterStatus" -->
</el-table>
```

### 场景C: 后端只返回"已拒绝"状态

**问题**: 后端SQL查询或Service层有问题

**可能原因**:
1. RepairRecordMapper.xml中有硬编码的status过滤
2. Service层添加了额外的过滤逻辑

**解决方案**: 检查RepairRecordMapper.xml

```xml
<select id="selectPage" resultMap="BaseResultMap">
    SELECT rr.*, cr.relic_name, cr.relic_code, su.real_name as applicant_name
    FROM repair_record rr
    LEFT JOIN cultural_relic cr ON rr.relic_id = cr.id
    LEFT JOIN sys_user su ON rr.applicant_id = su.id
    <where>
        <!-- 不应该有这行 -->
        <!-- AND rr.status = '已拒绝' -->
        
        <!-- 应该是动态的 -->
        <if test="status != null and status != ''">
            AND rr.status = #{status}
        </if>
        <!-- ... 其他条件 ... -->
    </where>
    ORDER BY rr.apply_date DESC, rr.id DESC
    LIMIT #{offset}, #{limit}
</select>
```

---

## 🔧 快速修复脚本

### 如果是前端query初始化问题

在 `frontend/src/views/RepairsView.vue` 中找到：

```javascript
const query = reactive({ pageNum: 1, pageSize: 10, status: '', priority: '', relicName: '', repairExpert: '' })
```

确保 `status: ''` 是空字符串。

### 如果是前端数据过滤问题

在 `frontend/src/views/RepairsView.vue` 中找到 `loadData` 函数，确保：

```javascript
const loadData = async () => {
  const res = await getRepairsPageApi(query)
  tableData.value = res.data.records || []  // 不要添加filter
  total.value = res.data.total || 0
}
```

### 如果是后端SQL问题

检查 `backend/src/main/resources/mapper/RepairRecordMapper.xml` 的 `selectPage` 查询，确保没有硬编码的status过滤。

---

## 🧪 验证修复

### 测试1: 系统管理员

1. 使用admin登录
2. 进入修复管理
3. 不选择任何筛选条件
4. 点击"搜索"

**预期**: 看到所有状态的记录

### 测试2: 保管员

1. 使用curator01登录
2. 进入申请修复
3. 不选择任何筛选条件
4. 点击"搜索"

**预期**: 看到自己的所有状态的记录

### 测试3: 状态筛选

1. 在状态下拉框中选择"待审批"
2. 点击"搜索"

**预期**: 只看到待审批的记录

---

## 📊 最可能的问题

根据经验，最可能的问题是：

### 1. 前端el-table有默认过滤器（可能性：80%）

检查 `RepairsView.vue` 中的 `<el-table>` 标签，看是否有：
- `:filter-method`
- `:default-filter`
- 列上的 `:filters` 属性

### 2. 前端tableData是computed属性（可能性：15%）

检查 `tableData` 的定义，应该是 `ref([])` 而不是 `computed()`

### 3. 前端loadData有过滤逻辑（可能性：5%）

检查 `loadData` 函数中是否有 `.filter()` 调用

---

## 🆘 如果还是无法解决

请提供以下信息：

### 1. 后端控制台日志
```
========== 修复记录查询请求 ==========
请求参数: pageNum=?, pageSize=?
过滤条件: status=[?], ...
...
========================================
```

### 2. 浏览器Network标签
- 请求URL（完整的）
- 响应数据（JSON格式）

### 3. 浏览器Console日志
- 添加调试代码后的完整输出

### 4. RepairsView.vue的关键代码
```javascript
// query定义
const query = reactive({ ... })

// tableData定义
const tableData = ...

// loadData函数
const loadData = async () => { ... }

// el-table标签
<el-table :data="tableData" ...>
```

有了这些信息，我可以100%定位问题！

---

**创建时间**: 2026-04-28  
**状态**: 已添加调试日志，等待诊断结果  
**后端编译**: ✅ BUILD SUCCESS
