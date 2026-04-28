# 前台借展申请博物馆自动填充测试指南

## 功能说明
前台借展人申请借展时，"借展单位"字段自动填充为当前用户所属的博物馆名称，并设置为只读（不可修改）。

## 已完成的修改

### 1. 登录时保存博物馆名称（PortalLoginView.vue）
```javascript
// 获取选中的博物馆信息
const selectedMuseum = museumList.value.find(m => m.id === loginForm.museumId)
const museumName = selectedMuseum ? selectedMuseum.museumName : ''

// 保存到sessionStorage
sessionStorage.setItem('museumName', museumName)
```

### 2. 借展表单字段设置为只读（PublicPortalView.vue）
```vue
<el-form-item :label="t('borrowerUnit')" prop="borrowerUnit">
  <el-input v-model="loanForm.borrowerUnit" :placeholder="t('borrowerUnit')" disabled />
</el-form-item>
```

### 3. 表单初始化自动填充博物馆名称
```javascript
const loanForm = reactive({
  relicId: null,
  borrowerUnit: sessionStorage.getItem('museumName') || '',  // 自动填充博物馆名称
  borrowerName: sessionStorage.getItem('realName') || sessionStorage.getItem('username') || '',
  borrowerPhone: sessionStorage.getItem('phone') || '',
  // ...
})
```

### 4. 切换到借展页面时自动填充
```javascript
if (!loanForm.borrowerUnit) {
  loanForm.borrowerUnit = sessionStorage.getItem('museumName') || ''
}
```

### 5. 重置表单时自动填充
```javascript
const currentMuseumName = sessionStorage.getItem('museumName') || ''
Object.assign(loanForm, {
  borrowerUnit: currentMuseumName,  // 自动填充博物馆名称
  // ...
})
```

---

## 测试步骤

### 步骤1：重启前端服务
```bash
cd frontend
# 按Ctrl+C停止当前服务
npm run dev
```

### 步骤2：前台登录
1. 访问：`http://localhost:5173/portal-login`
2. 输入登录信息：
   - 用户名：`loaner`
   - 密码：`123456`
   - **博物馆：选择"国家博物馆"**（重要！）
3. 点击"立即登录"

### 步骤3：进入申请借展页面
1. 登录成功后，自动跳转到前台门户
2. 点击顶部导航栏的"申请借展"按钮
3. 或者点击首页的"申请借展"卡片

### 步骤4：验证借展单位字段

**预期结果：**
- ✅ "借展单位"字段应该自动显示：**国家博物馆**
- ✅ 该字段为灰色（禁用状态），无法编辑
- ✅ "借展人"字段自动显示当前用户姓名
- ✅ "联系电话"字段自动显示当前用户电话
- ✅ "借展日期"字段自动显示当前时间

### 步骤5：测试表单提交
1. 选择一个文物（例如：青铜器）
2. 选择预计归还日期（必须晚于当前时间）
3. 填写借展用途
4. 点击"提交"按钮

**预期结果：**
- ✅ 提交成功，提示"借展申请提交成功"
- ✅ 表单自动重置
- ✅ 重置后，"借展单位"仍然显示"国家博物馆"

### 步骤6：验证数据库
打开MySQL客户端，执行以下查询：

```sql
USE cultural_relics;

-- 查询最新的借展记录
SELECT 
    lr.id,
    lr.borrower_unit,
    lr.borrower_name,
    lr.borrower_phone,
    cr.relic_name,
    lr.loan_date,
    lr.expected_return_date,
    lr.status
FROM loan_record lr
JOIN cultural_relic cr ON lr.relic_id = cr.id
ORDER BY lr.id DESC
LIMIT 5;
```

**预期结果：**
- `borrower_unit` 字段应该显示：**国家博物馆**

---

## 测试不同博物馆

### 测试1：使用上海博物馆登录
1. 退出登录
2. 重新登录，选择博物馆为"上海博物馆"
3. 进入申请借展页面
4. **预期：借展单位显示"上海博物馆"**

### 测试2：使用故宫博物院登录
1. 退出登录
2. 重新登录，选择博物馆为"故宫博物院"
3. 进入申请借展页面
4. **预期：借展单位显示"故宫博物院"**

---

## 故障排查

### 问题1：借展单位字段为空

**可能原因：**
1. 登录时没有保存博物馆名称
2. sessionStorage中没有museumName

**排查步骤：**
1. 打开浏览器开发者工具（F12）
2. 切换到 Console 标签页
3. 输入以下命令查看sessionStorage：
   ```javascript
   console.log('museumName:', sessionStorage.getItem('museumName'))
   console.log('museumId:', sessionStorage.getItem('museumId'))
   ```

**解决方案：**
- 如果museumName为空，需要重新登录
- 确保前端服务已重启

---

### 问题2：借展单位字段可以编辑

**可能原因：**
- 前端代码未更新
- 浏览器缓存

**解决方案：**
1. 确认前端服务已重启
2. 清除浏览器缓存（Ctrl+Shift+Delete）
3. 硬刷新页面（Ctrl+F5）

---

### 问题3：切换页面后借展单位变为空

**可能原因：**
- 页面切换逻辑未正确执行

**排查步骤：**
1. 打开浏览器控制台
2. 查看是否有JavaScript错误
3. 检查console.log输出：
   ```
   初始化借展表单用户信息: xxx xxx 国家博物馆
   ```

---

## 完整测试清单

- [ ] 前端服务已重启
- [ ] 使用前台登录页面登录（/portal-login）
- [ ] 登录时选择了博物馆
- [ ] 进入申请借展页面
- [ ] 借展单位字段显示博物馆名称（不是"借展单位"这几个字）
- [ ] 借展单位字段为灰色（禁用状态）
- [ ] 借展单位字段无法编辑
- [ ] 提交借展申请成功
- [ ] 表单重置后，借展单位仍然显示博物馆名称
- [ ] 数据库中borrower_unit字段保存了博物馆名称
- [ ] 使用不同博物馆登录，显示对应的博物馆名称

---

## 预期效果截图说明

### 登录页面
- 博物馆下拉框显示10个博物馆选项
- 选择"国家博物馆"

### 申请借展页面
```
文物名称：     [请选择文物 ▼]
借展单位：     国家博物馆          （灰色，不可编辑）
借展人：       张三                （灰色，不可编辑）
联系电话：     13800138000         （灰色，不可编辑）
借展日期：     2024-01-15 10:30:00 （灰色，不可编辑）
预计归还日期： [请选择日期 📅]
借展用途：     [请输入借展用途]
              [提交] [重置]
```

---

## 数据流程图

```
用户登录
  ↓
选择博物馆（例如：国家博物馆）
  ↓
保存到sessionStorage
  - museumId: 1
  - museumName: "国家博物馆"
  ↓
进入前台门户
  ↓
点击"申请借展"
  ↓
自动填充表单
  - borrowerUnit: "国家博物馆" ✅
  - borrowerName: "张三"
  - borrowerPhone: "13800138000"
  - loanDate: "2024-01-15 10:30:00"
  ↓
提交申请
  ↓
保存到数据库
  - borrower_unit: "国家博物馆" ✅
```

---

## 成功标志

当你看到以下情况时，说明功能正常：

1. ✅ 登录时选择博物馆后，sessionStorage中有museumName
2. ✅ 进入申请借展页面，借展单位字段显示博物馆名称（例如：国家博物馆）
3. ✅ 借展单位字段为灰色，无法编辑
4. ✅ 提交借展申请后，数据库中borrower_unit字段保存了博物馆名称
5. ✅ 表单重置后，借展单位仍然显示博物馆名称
6. ✅ 使用不同博物馆登录，显示对应的博物馆名称

---

## 相关文件

- `frontend/src/views/PortalLoginView.vue` - 前台登录页面（保存博物馆名称）
- `frontend/src/views/PublicPortalView.vue` - 前台门户页面（借展申请表单）
- `backend/src/main/java/com/example/entity/LoanRecord.java` - 借展记录实体
- `backend/src/main/java/com/example/controller/LoanRecordController.java` - 借展记录控制器

---

## 注意事项

1. **必须使用前台登录页面**：`/portal-login`，不能使用后台登录页面
2. **必须选择博物馆**：登录时必须选择博物馆，否则借展单位字段为空
3. **前端服务必须重启**：修改代码后必须重启前端服务才能生效
4. **清除浏览器缓存**：如果修改不生效，尝试清除浏览器缓存

