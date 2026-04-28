# 文物图片上传功能测试文档

## 测试目标

验证新增文物时，图片能够自动存放到 `image_library` 表，并在 `relic_image_relation` 表中记录对应关系。

## 前置条件

1. 数据库已创建以下表：
   - `cultural_relic` - 文物表
   - `image_library` - 图片库表
   - `relic_image_relation` - 文物图片关联表

2. 后端服务已启动（端口 8080）

3. 前端服务已启动（端口 5173）

## 测试步骤

### 测试用例 1：新增文物并上传图片

#### 步骤：

1. 打开浏览器，访问 `http://localhost:5173`
2. 登录系统
3. 进入"文物管理"页面
4. 点击"新增文物"按钮
5. 填写文物信息：
   - 文物名称：测试青铜鼎
   - 年代：商代
   - 材质：青铜
   - 分类：选择一个分类
   - 状态：在库
   - 尺寸：高30cm
   - 重量：15.5
   - 产地：河南安阳
   - 描述：测试用文物
6. 在图片上传区域：
   - 拖拽一张图片文件到上传框
   - 或点击上传框选择图片
7. 确认图片预览显示正确
8. 点击"确定"按钮提交

#### 预期结果：

1. 前端显示"新增成功"消息
2. 文物列表刷新，显示新增的文物
3. 新增的文物显示上传的图片缩略图

#### 数据库验证：

```sql
-- 1. 查询新增的文物
SELECT * FROM cultural_relic 
WHERE relic_name = '测试青铜鼎' 
ORDER BY id DESC LIMIT 1;
-- 记录 relic_id

-- 2. 查询图片库记录
SELECT * FROM image_library 
WHERE reference_type = 'relic' 
AND reference_id = <relic_id>;
-- 应该有一条记录，记录 image_id

-- 3. 查询关联记录
SELECT * FROM relic_image_relation 
WHERE relic_id = <relic_id>;
-- 应该有一条记录，关联 relic_id 和 image_id

-- 4. 联合查询验证
SELECT 
    cr.id as relic_id,
    cr.relic_name,
    i.id as image_id,
    i.image_name,
    i.file_path,
    rir.relation_type
FROM cultural_relic cr
LEFT JOIN relic_image_relation rir ON cr.id = rir.relic_id
LEFT JOIN image_library i ON rir.image_id = i.id
WHERE cr.relic_name = '测试青铜鼎';
-- 应该显示完整的关联信息
```

### 测试用例 2：新增文物不上传图片

#### 步骤：

1. 点击"新增文物"按钮
2. 填写文物信息（不上传图片）
3. 点击"确定"按钮提交

#### 预期结果：

1. 前端显示"新增成功"消息
2. 文物列表显示新增的文物
3. 文物图片列显示"暂无数据"

#### 数据库验证：

```sql
-- 查询文物
SELECT * FROM cultural_relic 
WHERE relic_name = '<文物名称>' 
ORDER BY id DESC LIMIT 1;

-- 查询关联记录（应该为空）
SELECT * FROM relic_image_relation 
WHERE relic_id = <relic_id>;
-- 应该没有记录
```

### 测试用例 3：编辑文物（不修改图片）

#### 步骤：

1. 在文物列表中点击"编辑"按钮
2. 修改文物描述
3. 不修改图片
4. 点击"确定"按钮提交

#### 预期结果：

1. 文物信息更新成功
2. 图片保持不变

### 测试用例 4：图片文件验证

#### 步骤：

1. 点击"新增文物"按钮
2. 尝试上传非图片文件（如 .txt, .pdf）

#### 预期结果：

1. 显示错误提示："只能上传图片文件!"
2. 文件不被接受

#### 步骤：

1. 尝试上传超过 5MB 的图片

#### 预期结果：

1. 显示错误提示："图片大小不能超过 5MB!"
2. 文件不被接受

### 测试用例 5：图片预览和移除

#### 步骤：

1. 点击"新增文物"按钮
2. 上传一张图片
3. 确认图片预览显示
4. 点击"移除"按钮
5. 确认图片预览消失
6. 重新上传另一张图片

#### 预期结果：

1. 图片预览正确显示
2. 移除功能正常工作
3. 可以重新上传新图片

## 后端API测试

### 使用 Postman 或 curl 测试

#### 测试新增文物接口（带图片）

```bash
curl -X POST http://localhost:8080/api/relics/with-image \
  -H "Authorization: Bearer <token>" \
  -F "relicName=测试文物" \
  -F "era=商代" \
  -F "material=青铜" \
  -F "status=在库" \
  -F "imageFile=@/path/to/image.jpg"
```

#### 预期响应：

```json
{
  "code": 200,
  "message": "新增成功",
  "data": 123  // 新增文物的ID
}
```

## 常见问题排查

### 问题 1：图片上传后前端不显示

**可能原因：**
- 图片路径不正确
- 后端静态资源配置问题

**排查步骤：**
1. 检查 `image_library` 表中的 `file_path` 字段
2. 检查后端静态资源映射配置
3. 在浏览器中直接访问图片URL

### 问题 2：提交时报错 "文物编号生成失败"

**可能原因：**
- 数据库连接问题
- 文物编号生成逻辑错误

**排查步骤：**
1. 检查数据库连接
2. 查看后端日志
3. 检查 `generateNextRelicCode()` 方法

### 问题 3：图片上传成功但关联记录未创建

**可能原因：**
- 事务回滚
- `RelicImageRelationService` 调用失败

**排查步骤：**
1. 查看后端日志
2. 检查 `saveWithImage` 方法的事务配置
3. 验证 `RelicImageRelationService` 是否正确注入

### 问题 4：前端显示 "新增失败"

**可能原因：**
- 后端接口返回错误
- 网络请求失败
- 参数格式不正确

**排查步骤：**
1. 打开浏览器开发者工具，查看 Network 标签
2. 检查请求参数和响应
3. 查看后端日志

## 性能测试

### 测试大文件上传

1. 上传 1MB 图片 - 应该在 2 秒内完成
2. 上传 3MB 图片 - 应该在 5 秒内完成
3. 上传 5MB 图片 - 应该在 10 秒内完成

### 测试并发上传

1. 同时新增 5 个文物（每个带图片）
2. 验证所有文物和图片都正确保存
3. 验证关联关系都正确建立

## 清理测试数据

```sql
-- 删除测试文物
DELETE FROM cultural_relic WHERE relic_name LIKE '测试%';

-- 删除测试图片（关联会自动删除）
DELETE FROM image_library WHERE reference_type = 'relic' AND reference_id NOT IN (
    SELECT id FROM cultural_relic
);

-- 验证清理结果
SELECT COUNT(*) FROM cultural_relic WHERE relic_name LIKE '测试%';
SELECT COUNT(*) FROM image_library WHERE reference_type = 'relic' AND reference_id NOT IN (
    SELECT id FROM cultural_relic
);
SELECT COUNT(*) FROM relic_image_relation WHERE relic_id NOT IN (
    SELECT id FROM cultural_relic
);
```

## 测试检查清单

- [ ] 新增文物并上传图片成功
- [ ] 图片存储到 `image_library` 表
- [ ] 关联记录创建到 `relic_image_relation` 表
- [ ] 文物列表显示图片缩略图
- [ ] 新增文物不上传图片成功
- [ ] 编辑文物不影响图片
- [ ] 图片文件类型验证正常
- [ ] 图片文件大小验证正常
- [ ] 图片预览功能正常
- [ ] 图片移除功能正常
- [ ] 后端API返回正确
- [ ] 数据库记录正确
- [ ] 事务回滚正常工作
- [ ] 性能满足要求

## 测试报告模板

```
测试日期：____________________
测试人员：____________________
测试环境：____________________

测试结果：
- 测试用例 1：□ 通过  □ 失败  备注：__________
- 测试用例 2：□ 通过  □ 失败  备注：__________
- 测试用例 3：□ 通过  □ 失败  备注：__________
- 测试用例 4：□ 通过  □ 失败  备注：__________
- 测试用例 5：□ 通过  □ 失败  备注：__________

发现的问题：
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

建议：
1. _______________________________________________
2. _______________________________________________
3. _______________________________________________

总体评价：□ 优秀  □ 良好  □ 一般  □ 需改进
```

## 相关文档

- [文物图片关联功能集成](./RELIC_IMAGE_INTEGRATION.md)
- [新增文物时自动处理图片](./RELIC_ADD_WITH_IMAGE.md)
- [文物图片关联表设计](./RELIC_IMAGE_RELATION_FEATURE.md)
