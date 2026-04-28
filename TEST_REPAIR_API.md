# 修复记录API测试指南

## 🐛 问题现象

数据库中有不同状态的记录（待审批、待修复、修复中、修复完成、已拒绝），但前端只能看到"已拒绝"的记录。

## 🔍 诊断步骤

### 步骤1: 直接查询数据库

```sql
-- 查看所有修复记录
SELECT id, repair_code, status, applicant_id, apply_date
FROM repair_record
ORDER BY id DESC;

-- 查看状态分布
SELECT status, COUNT(*) as count
FROM repair_record
GROUP BY status;
```

**预期结果**: 应该看到多种状态的记录

### 步骤2: 测试后端API（使用curl或Postman）

#### 2.1 获取token（登录）

**Admin登录**:
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
```

**Curator登录**:
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"curator01","password":"curator123"}'
```

保存返回的token，例如: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

#### 2.2 测试修复记录查询API

**查询所有记录（不带任何过滤）**:
```bash
curl -X GET "http://localhost:8080/api/repairs?pageNum=1&pageSize=10" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**查询特定状态的记录**:
```bash
# 查询待审批
curl -X GET "http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=待审批" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# 查询待修复
curl -X GET "http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=待修复" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# 查询修复中
curl -X GET "http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=修复中" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# 查询修复完成
curl -X GET "http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=修复完成" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"

# 查询已拒绝
curl -X GET "http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=已拒绝" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

**预期结果**: 
- Admin token: 应该返回所有状态的记录
- Curator token: 应该只返回该curator的记录

### 步骤3: 检查后端日志

启动后端服务，查看控制台输出：

```
查询修复记录：pageNum=1, pageSize=10, applicantIdFilter=null, total=10
```

或

```
保管员权限过滤：只显示申请人ID=3的记录
查询修复记录：pageNum=1, pageSize=10, applicantIdFilter=3, total=5
```

### 步骤4: 使用浏览器开发者工具

1. 打开浏览器（Chrome/Edge）
2. 按F12打开开发者工具
3. 切换到 **Network** 标签
4. 登录系统并进入修复管理页面
5. 查看 `/api/repairs` 请求

**检查请求**:
```
Request URL: http://localhost:8080/api/repairs?pageNum=1&pageSize=10&status=&priority=&relicName=&repairExpert=
Request Method: GET
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

**检查响应**:
```json
{
  "code": 200,
  "message": "success",
  "data": {
    "records": [
      {
        "id": 1,
        "repairCode": "REP2024001",
        "status": "待审批",
        ...
      },
      {
        "id": 2,
        "repairCode": "REP2024002",
        "status": "待修复",
        ...
      }
    ],
    "total": 10,
    "pageNum": 1,
    "pageSize": 10
  }
}
```

**关键检查点**:
- ✅ 请求URL中的status参数是否为空字符串（应该是空）
- ✅ 响应中的records数组是否包含多种状态
- ✅ 响应中的total数量是否正确

## 🎯 可能的问题和解决方案

### 问题1: 前端发送了错误的status参数

**症状**: Network标签显示请求URL中status不为空
```
/api/repairs?pageNum=1&pageSize=10&status=已拒绝&...
```

**原因**: 前端query对象被意外修改

**解决方案**: 检查RepairsView.vue中是否有代码修改了query.status

### 问题2: 后端返回的数据被前端过滤

**症状**: 
- Network标签显示响应包含多种状态的记录
- 但页面只显示"已拒绝"的记录

**原因**: 前端在处理响应数据时进行了过滤

**解决方案**: 检查loadData函数中是否有过滤逻辑
```javascript
const loadData = async () => {
  const res = await getRepairsPageApi(query)
  // 检查这里是否有过滤
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}
```

### 问题3: 后端SQL查询有问题

**症状**: 
- 直接查询数据库有多种状态
- 但API返回只有"已拒绝"状态

**原因**: SQL查询或Mapper有问题

**解决方案**: 
1. 检查RepairRecordMapper.xml的selectPage查询
2. 在RepairRecordServiceImpl中添加日志
```java
log.info("查询参数: status={}, applicantIdFilter={}", status, applicantIdFilter);
log.info("查询结果: total={}, records.size={}", total, records.size());
```

### 问题4: 前端表格有过滤器

**症状**: 数据加载正常，但表格显示被过滤

**原因**: el-table有:filter-method或其他过滤逻辑

**解决方案**: 检查RepairsView.vue中的el-table标签

### 问题5: 浏览器缓存问题

**症状**: 其他都正常，但就是显示旧数据

**解决方案**: 
1. 清除浏览器缓存（Ctrl+Shift+Delete）
2. 硬刷新（Ctrl+F5）
3. 使用无痕模式测试

## 🔧 调试代码

### 在RepairsView.vue中添加调试日志

```vue
<script setup>
const loadData = async () => {
  console.log('=== 开始加载数据 ===')
  console.log('查询参数:', query)
  
  const res = await getRepairsPageApi(query)
  
  console.log('API响应:', res)
  console.log('记录数量:', res.data.records?.length)
  console.log('记录状态分布:', res.data.records?.map(r => r.status))
  
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
  
  console.log('tableData:', tableData.value)
  console.log('=== 数据加载完成 ===')
}
</script>
```

### 在RepairRecordController中添加调试日志

```java
@GetMapping
public Result<PageResult<RepairRecord>> page(...) {
    System.out.println("=== 收到查询请求 ===");
    System.out.println("参数: pageNum=" + pageNum + ", pageSize=" + pageSize + 
                      ", status=" + status + ", priority=" + priority);
    
    // ... 权限检查代码 ...
    
    System.out.println("applicantIdFilter=" + applicantIdFilter);
    
    PageResult<RepairRecord> result = repairRecordService.pageRecords(...);
    
    System.out.println("查询结果: total=" + result.getTotal() + 
                      ", records.size=" + result.getRecords().size());
    System.out.println("记录状态: " + result.getRecords().stream()
                      .map(RepairRecord::getStatus)
                      .collect(Collectors.toList()));
    System.out.println("=== 查询完成 ===");
    
    return Result.success(result);
}
```

## 📝 测试清单

完成以下测试，找出问题所在：

- [ ] 数据库直接查询 - 确认有多种状态的记录
- [ ] 后端API测试（curl） - 确认API返回正确数据
- [ ] 浏览器Network标签 - 确认请求和响应
- [ ] 前端Console日志 - 确认数据处理流程
- [ ] 后端Console日志 - 确认查询逻辑
- [ ] 清除缓存重试 - 排除缓存问题

## 🆘 如果还是找不到问题

请提供以下信息：

1. **数据库查询结果**:
```sql
SELECT id, status FROM repair_record;
```

2. **浏览器Network标签截图**:
   - 请求URL
   - 响应数据

3. **浏览器Console日志**:
   - 添加调试代码后的输出

4. **后端Console日志**:
   - 添加调试代码后的输出

有了这些信息，我可以精确定位问题所在。

---

**创建时间**: 2026-04-28  
**用途**: 诊断修复记录显示问题
