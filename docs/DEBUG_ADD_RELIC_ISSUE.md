# 新增文物数据未保存问题诊断

## 问题描述

新增文物时前端显示"保存成功"，但数据并没有添加到数据库中。

## 诊断步骤

### 1. 检查前端请求

打开浏览器开发者工具（F12），切换到 Network 标签：

1. 点击"新增文物"
2. 填写表单
3. 点击"确定"
4. 查看 Network 标签中的请求

**检查项：**
- 请求URL是什么？（应该是 `/api/relics` 或 `/api/relics/with-image`）
- 请求方法是什么？（应该是 POST）
- 请求状态码是什么？（应该是 200）
- 响应内容是什么？

**查看Console标签的日志：**
```
新增文物 - 有图片: true/false
表单数据: {...}
调用 addRelicApi 或 addRelicWithImageApi
响应: {...}
```

### 2. 检查后端日志

查看后端控制台输出：

**应该看到：**
```
=== 新增文物请求 ===
文物名称: xxx
年代: xxx
材质: xxx
分类ID: xxx
状态: xxx
有图片: true/false
保存文物成功：id=xxx, name=xxx
文物保存成功，ID: xxx
```

**如果看到错误：**
```
新增文物失败: xxx
```

### 3. 检查数据库

#### 查询最新的文物记录

```sql
SELECT * FROM cultural_relic 
ORDER BY id DESC 
LIMIT 10;
```

#### 查询特定名称的文物

```sql
SELECT * FROM cultural_relic 
WHERE relic_name LIKE '%测试%' 
ORDER BY create_time DESC;
```

#### 检查文物编号生成

```sql
SELECT relic_code FROM cultural_relic 
ORDER BY id DESC 
LIMIT 1;
```

### 4. 使用测试页面

打开 `test-add-relic.html` 文件：

1. 填写文物信息
2. 点击"测试原有接口"按钮
3. 查看响应结果
4. 检查数据库是否有新记录

## 常见问题及解决方案

### 问题1：前端调用了错误的接口

**症状：**
- Console显示调用 `addRelicApi`
- 但数据没有保存

**原因：**
- 原有接口可能有问题
- 缺少必需字段

**解决方案：**
```javascript
// 确保所有必需字段都有值
const form = {
    relicName: '...',  // 必需
    era: '...',        // 建议填写
    material: '...',   // 建议填写
    status: '在库',    // 必需
    categoryId: null,  // 可选
    // ...
}
```

### 问题2：后端事务回滚

**症状：**
- 后端日志显示"保存文物成功"
- 但数据库中没有记录

**原因：**
- 图片上传失败导致事务回滚
- 其他异常导致回滚

**解决方案：**
1. 检查后端完整日志
2. 查看是否有异常堆栈
3. 检查 `RelicImageRelationService` 是否正常

### 问题3：数据库约束问题

**症状：**
- 后端日志显示错误
- 提示约束违反

**原因：**
- `relic_code` 重复
- 其他唯一约束冲突

**解决方案：**
```sql
-- 检查是否有重复的编号
SELECT relic_code, COUNT(*) 
FROM cultural_relic 
GROUP BY relic_code 
HAVING COUNT(*) > 1;

-- 查看最大编号
SELECT MAX(relic_code) FROM cultural_relic;
```

### 问题4：权限问题

**症状：**
- 请求返回 401 或 403
- 或者没有权限保存

**解决方案：**
1. 检查用户是否登录
2. 检查 token 是否有效
3. 检查用户权限

### 问题5：Service未注入

**症状：**
- 后端报 NullPointerException
- 提示 service 为 null

**解决方案：**
检查 `CulturalRelicServiceImpl` 的构造函数：
```java
public CulturalRelicServiceImpl(
    CulturalRelicMapper culturalRelicMapper,
    RelicImageRelationService relicImageRelationService) {
    this.culturalRelicMapper = culturalRelicMapper;
    this.relicImageRelationService = relicImageRelationService;
}
```

## 调试命令

### 前端调试

在浏览器Console中执行：

```javascript
// 查看表单数据
console.log('表单数据:', form)

// 查看图片文件
console.log('图片文件:', imageFile.value)

// 手动调用API
const testData = {
    relicName: '测试文物',
    era: '商代',
    material: '青铜',
    status: '在库'
}
addRelicApi(testData).then(res => console.log('响应:', res))
```

### 后端调试

在 `CulturalRelicServiceImpl.saveWithImage` 方法中添加断点：

```java
@Override
@Transactional(rollbackFor = Exception.class)
public Long saveWithImage(...) {
    // 在这里设置断点
    relic.setRelicCode(generateNextRelicCode());
    
    // 在这里设置断点
    culturalRelicMapper.insert(relic);
    
    // 在这里设置断点
    Long relicId = relic.getId();
    
    return relicId;
}
```

### 数据库调试

```sql
-- 开启查询日志
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';

-- 查看最近的查询
SELECT * FROM mysql.general_log 
WHERE command_type = 'Query' 
ORDER BY event_time DESC 
LIMIT 20;

-- 关闭查询日志
SET GLOBAL general_log = 'OFF';
```

## 验证修复

### 1. 测试无图片新增

```javascript
// 前端
const form = {
    relicName: '测试文物1',
    era: '商代',
    material: '青铜',
    status: '在库',
    categoryId: 2
}
await addRelicApi(form)
```

**验证：**
```sql
SELECT * FROM cultural_relic WHERE relic_name = '测试文物1';
```

### 2. 测试有图片新增

```javascript
// 前端
const formData = new FormData()
formData.append('relicName', '测试文物2')
formData.append('era', '商代')
formData.append('material', '青铜')
formData.append('status', '在库')
formData.append('imageFile', imageFile)
await addRelicWithImageApi(formData)
```

**验证：**
```sql
-- 查询文物
SELECT * FROM cultural_relic WHERE relic_name = '测试文物2';

-- 查询图片
SELECT * FROM image_library WHERE reference_type = 'relic';

-- 查询关联
SELECT * FROM relic_image_relation;
```

## 完整测试流程

1. **清理测试数据**
```sql
DELETE FROM cultural_relic WHERE relic_name LIKE '测试%';
```

2. **测试原有接口**
   - 打开 `test-add-relic.html`
   - 点击"测试原有接口"
   - 检查数据库

3. **测试新接口（无图片）**
   - 点击"测试新增（无图片）"
   - 检查数据库

4. **测试新接口（有图片）**
   - 选择图片文件
   - 点击"测试新增（带图片）"
   - 检查数据库
   - 检查 image_library 表
   - 检查 relic_image_relation 表

5. **测试前端界面**
   - 打开文物管理页面
   - 点击"新增文物"
   - 填写表单
   - 上传图片
   - 提交
   - 检查列表是否刷新
   - 检查数据库

## 联系支持

如果以上步骤都无法解决问题，请提供：

1. 前端 Console 的完整日志
2. 后端控制台的完整日志
3. Network 标签中的请求和响应详情
4. 数据库查询结果
5. 测试页面的测试结果

将这些信息整理后反馈给开发团队。
