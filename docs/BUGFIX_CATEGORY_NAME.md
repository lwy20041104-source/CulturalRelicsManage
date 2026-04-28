# Bug修复：category_name字段不存在

## 问题描述

在新增修复申请时，后端报错：
```
java.sql.SQLSyntaxErrorException: Unknown column 'category_name' in 'field list'
```

## 问题原因

在 `RepairRecordMapper.xml` 的 `selectRelicById` 查询中，尝试查询 `category_name` 字段，但数据库的 `cultural_relic` 表中没有这个字段。

`category_name` 是一个关联字段，需要通过 JOIN 查询 `cultural_relic_category` 表才能获取，而不是直接从 `cultural_relic` 表中查询。

## 解决方案

从 `selectRelicById` 查询中移除 `category_name` 字段。

### 修改前

```xml
<select id="selectRelicById" resultType="com.example.entity.CulturalRelic">
    SELECT id, relic_code, relic_name, category_id, category_name, era, material,
           origin, dimensions, weight, description, status, image_path,
           create_time, update_time
    FROM cultural_relic
    WHERE id = #{relicId}
</select>
```

### 修改后

```xml
<select id="selectRelicById" resultType="com.example.entity.CulturalRelic">
    SELECT id, relic_code, relic_name, category_id, era, material,
           origin, dimensions, weight, description, status, image_path,
           create_time, update_time
    FROM cultural_relic
    WHERE id = #{relicId}
</select>
```

## 影响范围

这个查询只用于检查文物状态，不需要 `category_name` 字段，因此移除该字段不会影响功能。

## 测试验证

1. 重新编译：`mvn clean compile -DskipTests`
2. 重启后端服务
3. 尝试新增修复申请
4. 应该能够成功提交

## 相关文件

- `backend/src/main/resources/mapper/RepairRecordMapper.xml`

## 修复日期

2026-04-23

## 状态

✅ 已修复
✅ 编译成功
