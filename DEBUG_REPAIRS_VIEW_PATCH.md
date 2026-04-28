# RepairsView.vue 调试补丁

## 问题诊断

在 `frontend/src/views/RepairsView.vue` 的 `loadData` 函数中添加调试日志。

## 修改位置

找到这段代码：
```javascript
const loadData = async () => {
  const res = await getRepairsPageApi(query)
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
}
```

## 替换为：

```javascript
const loadData = async () => {
  console.log('========== 开始加载修复记录 ==========')
  console.log('查询参数:', JSON.stringify(query, null, 2))
  console.log('query.status值:', query.status, '类型:', typeof query.status, '长度:', query.status?.length)
  
  const res = await getRepairsPageApi(query)
  
  console.log('API响应:', res)
  console.log('响应数据结构:', {
    code: res.code,
    message: res.message,
    dataType: typeof res.data,
    hasRecords: !!res.data?.records,
    recordsLength: res.data?.records?.length,
    total: res.data?.total
  })
  
  if (res.data?.records) {
    console.log('记录数量:', res.data.records.length)
    console.log('记录详情:')
    res.data.records.forEach((record, index) => {
      console.log(`  [${index}] ID=${record.id}, 状态=${record.status}, 文物=${record.relicName}`)
    })
    
    // 统计状态分布
    const statusCount = {}
    res.data.records.forEach(record => {
      statusCount[record.status] = (statusCount[record.status] || 0) + 1
    })
    console.log('状态分布:', statusCount)
  }
  
  tableData.value = res.data.records || []
  total.value = res.data.total || 0
  
  console.log('设置tableData后:', {
    tableDataLength: tableData.value.length,
    total: total.value
  })
  console.log('========================================')
}
```

## 使用方法

1. 打开 `frontend/src/views/RepairsView.vue`
2. 找到 `loadData` 函数（大约在第473行）
3. 用上面的代码替换
4. 保存文件
5. 刷新浏览器
6. 打开浏览器控制台（F12 → Console标签）
7. 进入修复管理页面
8. 查看控制台输出

## 预期输出示例

### 正常情况（应该看到多种状态）:
```
========== 开始加载修复记录 ==========
查询参数: {
  "pageNum": 1,
  "pageSize": 10,
  "status": "",
  "priority": "",
  "relicName": "",
  "repairExpert": ""
}
query.status值:  类型: string 长度: 0
API响应: {code: 200, message: 'success', data: {...}}
响应数据结构: {
  code: 200,
  message: "success",
  dataType: "object",
  hasRecords: true,
  recordsLength: 10,
  total: 10
}
记录数量: 10
记录详情:
  [0] ID=1, 状态=待审批, 文物=商代青铜鼎
  [1] ID=2, 状态=待修复, 文物=唐三彩马
  [2] ID=3, 状态=修复中, 文物=宋代汝窑盘
  [3] ID=4, 状态=修复完成, 文物=明代青花瓷
  [4] ID=5, 状态=已拒绝, 文物=清代玉璧
  ...
状态分布: {待审批: 2, 待修复: 2, 修复中: 2, 修复完成: 2, 已拒绝: 2}
设置tableData后: {tableDataLength: 10, total: 10}
========================================
```

### 异常情况1（status参数不为空）:
```
查询参数: {
  "pageNum": 1,
  "pageSize": 10,
  "status": "已拒绝",  ← 这里不应该有值！
  ...
}
```
**问题**: query.status被意外设置了值

### 异常情况2（API返回数据被过滤）:
```
记录数量: 10
记录详情:
  [0] ID=1, 状态=待审批, 文物=商代青铜鼎
  [1] ID=2, 状态=待修复, 文物=唐三彩马
  ...
状态分布: {待审批: 2, 待修复: 2, 修复中: 2, 修复完成: 2, 已拒绝: 2}
设置tableData后: {tableDataLength: 2, total: 10}  ← 这里不对！
```
**问题**: tableData被过滤了，只保留了部分记录

### 异常情况3（API只返回特定状态）:
```
记录数量: 2
记录详情:
  [0] ID=5, 状态=已拒绝, 文物=清代玉璧
  [1] ID=10, 状态=已拒绝, 文物=汉代玉衣
状态分布: {已拒绝: 2}
```
**问题**: 后端只返回了"已拒绝"状态的记录

## 根据输出诊断问题

### 如果看到 query.status 不为空
→ 前端query对象被意外修改
→ 检查是否有代码设置了默认值
→ 检查是否从URL参数读取了值

### 如果API返回多种状态，但tableData只有部分
→ 前端在设置tableData时进行了过滤
→ 检查loadData函数中是否有filter操作
→ 检查是否有computed属性过滤了tableData

### 如果API只返回特定状态
→ 后端查询有问题
→ 查看后端控制台日志
→ 检查SQL查询逻辑

## 下一步

根据控制台输出，将信息反馈给我，我会帮你精确定位问题。
