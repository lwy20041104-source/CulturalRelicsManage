# 档案草稿状态验证功能

## 功能描述
防止同一文物创建多个草稿状态的档案。在新增档案时，文物选择下拉框会自动过滤掉已有草稿档案的文物，用户无法选择这些文物创建新档案。

## 业务规则

### 前端过滤逻辑
- 新建档案时，文物选择下拉框只显示可用的文物
- 已有草稿档案的文物不会出现在下拉列表中
- 用户无法选择已有草稿档案的文物

### 后端验证逻辑（双重保护）
- 即使前端被绕过，后端仍会验证
- 如果文物已有草稿档案，后端会拒绝创建并返回错误信息

### 档案状态说明
- **draft（草稿）**: 档案正在编辑中，可以修改、上传文档、删除
- **published（已发布）**: 档案已正式发布，不可修改
- **archived（已归档）**: 档案已归档，不可修改

### 业务场景
1. **场景1：首次创建档案**
   - 文物没有任何档案 → ✅ 文物出现在下拉列表中

2. **场景2：已有草稿档案**
   - 文物已有草稿档案 → ❌ 文物不出现在下拉列表中

3. **场景3：已有已发布档案**
   - 文物已有已发布档案 → ✅ 文物出现在下拉列表中（可创建新版本）

4. **场景4：已有已归档档案**
   - 文物已有已归档档案 → ✅ 文物出现在下拉列表中

5. **场景5：发布草稿后**
   - 用户发布草稿档案 → ✅ 该文物重新出现在下拉列表中

6. **场景6：删除草稿后**
   - 用户删除草稿档案 → ✅ 该文物重新出现在下拉列表中

## 实现细节

### 1. 后端API接口
在 `RelicArchiveController.java` 中添加新接口：

```java
/**
 * 获取可用于创建档案的文物列表（排除已有草稿档案的文物）
 */
@GetMapping("/available-relics")
public Result<List<CulturalRelic>> getAvailableRelics() {
    return Result.success(archiveService.getAvailableRelicsForArchive());
}
```

### 2. 服务层实现
在 `RelicArchiveServiceImpl.java` 中实现过滤逻辑：

```java
@Override
public List<CulturalRelic> getAvailableRelicsForArchive() {
    // 获取所有文物
    List<CulturalRelic> allRelics = relicMapper.selectAll();
    
    // 过滤掉已有草稿档案的文物
    allRelics.removeIf(relic -> {
        RelicArchive draftArchive = archiveMapper.selectByRelicIdAndStatus(relic.getId(), "draft");
        return draftArchive != null;
    });
    
    return allRelics;
}
```

### 3. 数据库查询方法
在 `RelicArchiveMapper.java` 中添加查询方法：

```java
/**
 * 根据文物ID和状态查询档案
 */
@Select("SELECT * FROM relic_archive WHERE relic_id = #{relicId} AND status = #{status} LIMIT 1")
RelicArchive selectByRelicIdAndStatus(@Param("relicId") Long relicId, @Param("status") String status);
```

### 4. 前端API封装
在 `frontend/src/api/archives.js` 中添加：

```javascript
/**
 * 获取可用于创建档案的文物列表（排除已有草稿档案的文物）
 */
export function getAvailableRelicsApi() {
  return request.get('/archives/available-relics')
}
```

### 5. 前端页面调用
在 `frontend/src/views/ArchivesView.vue` 中：

```javascript
const loadRelics = async () => {
  try {
    // 使用新的API获取可用于创建档案的文物列表
    const res = await getAvailableRelicsApi()
    if (res.code === 200) {
      relicOptions.value = res.data || []
    }
  } catch (error) {
    console.error('加载文物列表失败:', error)
  }
}

const openAdd = async () => {
  dialogTitle.value = '新建档案'
  resetForm()
  
  // 重新加载可用文物列表（确保获取最新的可用文物）
  await loadRelics()
  
  // 生成档案编号
  try {
    const res = await generateCodeApi()
    if (res.code === 200) {
      form.archiveCode = res.data
    }
  } catch (error) {
    console.error('生成档案编号失败:', error)
  }
  
  dialogVisible.value = true
}
```

### 6. 后端验证（双重保护）
在 `RelicArchiveServiceImpl.java` 的 `createArchive` 方法中：

```java
@Override
@Transactional
public Long createArchive(RelicArchive archive) {
    // 验证：检查该文物是否已有草稿状态的档案
    if (archive.getRelicId() != null) {
        RelicArchive existingDraft = archiveMapper.selectByRelicIdAndStatus(archive.getRelicId(), "draft");
        if (existingDraft != null) {
            throw new RuntimeException("该文物已存在草稿状态的档案（档案编号：" + existingDraft.getArchiveCode() + 
                                     "），请先发布或删除现有草稿后再创建新档案");
        }
    }
    
    // ... 其余创建逻辑
}
```

## 用户操作流程

### 正常创建档案流程
1. **点击"新建档案"按钮**
   - 系统打开新建档案对话框
   - 自动加载可用文物列表

2. **选择文物**
   - 下拉列表只显示可用的文物
   - 已有草稿档案的文物不会出现

3. **填写档案信息**
   - 档案标题
   - 档案类型
   - 档案描述

4. **提交创建**
   - 系统创建档案成功

### 当文物已有草稿档案时
1. **查看现有草稿**
   - 进入"档案管理"页面
   - 筛选状态为"草稿"
   - 找到该文物的草稿档案

2. **处理现有草稿（二选一）**
   
   **选项A：发布草稿**
   - 点击"详情"进入档案详情页
   - 完善档案信息和文档
   - 点击"发布"按钮
   - 发布后该文物重新出现在可选列表中

   **选项B：删除草稿**
   - 在档案列表中找到草稿档案
   - 点击"删除"按钮
   - 确认删除
   - 删除后该文物重新出现在可选列表中

3. **创建新档案**
   - 处理完现有草稿后
   - 重新点击"新建档案"
   - 该文物现在可以选择了

## 测试场景

### 测试用例1：正常创建档案
**前置条件**: 文物ID=100，该文物没有任何档案
**操作**: 点击"新建档案"，查看文物下拉列表
**预期结果**: ✅ 文物ID=100出现在下拉列表中

### 测试用例2：已有草稿档案的文物不可选
**前置条件**: 文物ID=100，已有草稿档案（AR-2024-001）
**操作**: 点击"新建档案"，查看文物下拉列表
**预期结果**: ❌ 文物ID=100不出现在下拉列表中

### 测试用例3：发布后文物重新可选
**前置条件**: 文物ID=100，已有草稿档案（AR-2024-001）
**操作**: 
1. 发布草稿档案 AR-2024-001
2. 点击"新建档案"，查看文物下拉列表
**预期结果**: ✅ 文物ID=100重新出现在下拉列表中

### 测试用例4：删除草稿后文物重新可选
**前置条件**: 文物ID=100，已有草稿档案（AR-2024-001）
**操作**: 
1. 删除草稿档案 AR-2024-001
2. 点击"新建档案"，查看文物下拉列表
**预期结果**: ✅ 文物ID=100重新出现在下拉列表中

### 测试用例5：已发布档案的文物可选
**前置条件**: 文物ID=100，已有已发布档案（AR-2024-001）
**操作**: 点击"新建档案"，查看文物下拉列表
**预期结果**: ✅ 文物ID=100出现在下拉列表中（可创建新版本）

### 测试用例6：后端验证（绕过前端）
**前置条件**: 文物ID=100，已有草稿档案（AR-2024-001）
**操作**: 通过API直接发送创建请求（绕过前端）
**预期结果**: ❌ 后端返回错误："该文物已存在草稿状态的档案（档案编号：AR-2024-001），请先发布或删除现有草稿后再创建新档案"

## SQL验证查询

### 查询文物的草稿档案
```sql
SELECT * FROM relic_archive 
WHERE relic_id = 59 AND status = 'draft';
```

### 查询所有有草稿档案的文物ID
```sql
SELECT DISTINCT relic_id 
FROM relic_archive 
WHERE status = 'draft';
```

### 查询可用于创建档案的文物（SQL模拟）
```sql
SELECT cr.* 
FROM cultural_relic cr
WHERE cr.id NOT IN (
    SELECT relic_id 
    FROM relic_archive 
    WHERE status = 'draft'
);
```

### 统计各文物的草稿档案数量
```sql
SELECT relic_id, COUNT(*) as draft_count
FROM relic_archive 
WHERE status = 'draft'
GROUP BY relic_id
HAVING draft_count > 1;  -- 查找有多个草稿的文物（不应该存在）
```

## API接口文档

### 获取可用文物列表
**接口**: `GET /api/archives/available-relics`

**请求参数**: 无

**响应示例**:
```json
{
  "code": 200,
  "message": "success",
  "data": [
    {
      "id": 1,
      "relicCode": "WW-2024-001",
      "relicName": "商代青铜鼎",
      "categoryId": 1,
      "categoryName": "青铜器",
      "era": "商代",
      "status": "正常"
    },
    {
      "id": 2,
      "relicCode": "WW-2024-002",
      "relicName": "唐代三彩马",
      "categoryId": 2,
      "categoryName": "陶瓷",
      "era": "唐代",
      "status": "正常"
    }
  ]
}
```

**说明**: 返回的文物列表已自动过滤掉有草稿档案的文物

## 相关文件

### 后端文件
- `backend/src/main/java/com/example/controller/RelicArchiveController.java` - 添加API接口
- `backend/src/main/java/com/example/service/RelicArchiveService.java` - 添加服务接口
- `backend/src/main/java/com/example/service/impl/RelicArchiveServiceImpl.java` - 实现过滤逻辑和验证逻辑
- `backend/src/main/java/com/example/mapper/RelicArchiveMapper.java` - 添加查询方法
- `backend/src/main/java/com/example/mapper/CulturalRelicMapper.java` - 文物查询

### 前端文件
- `frontend/src/api/archives.js` - 添加API调用
- `frontend/src/views/ArchivesView.vue` - 修改文物加载逻辑

## 优势

1. **用户体验好**: 用户在选择文物时就知道哪些文物可用，不会在提交时才发现错误
2. **双重保护**: 前端过滤 + 后端验证，确保数据一致性
3. **实时更新**: 每次打开新建对话框都会重新加载可用文物列表
4. **清晰明了**: 用户不会看到不可选的文物，避免困惑

## 注意事项

1. **性能考虑**: 
   - 查询使用索引（relic_id + status），性能影响很小
   - 如果文物数量很大（>10000），可以考虑添加分页或搜索功能

2. **并发控制**: 
   - 前端过滤可能存在时间差（用户A打开对话框时文物可用，但提交时用户B已创建草稿）
   - 后端验证确保最终数据一致性

3. **缓存问题**: 
   - 每次打开新建对话框都会重新加载文物列表，确保数据最新

4. **编辑档案**: 
   - 编辑档案时不需要重新加载文物列表
   - 编辑时文物ID不可修改

## 建议的数据库索引

为了提高查询性能，建议添加复合索引：

```sql
-- 为 relic_archive 表添加复合索引
CREATE INDEX idx_relic_status ON relic_archive(relic_id, status);
```

## 编译状态
- ✅ 后端编译成功
- ✅ 前端编译成功
- ✅ 前端过滤逻辑已实现
- ✅ 后端验证逻辑已实现

## 实现时间
2026-04-24

