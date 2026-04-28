# Redis缓存策略文档

## 概述

本项目已集成Redis缓存，通过Spring Cache注解实现声明式缓存管理，显著提升系统性能。

## 缓存配置

### Redis配置
- **主机**: localhost
- **端口**: 6379
- **默认过期时间**: 1小时
- **序列化方式**: Jackson2JsonRedisSerializer

### 配置文件位置
- `backend/src/main/java/com/example/config/RedisConfig.java`
- `backend/src/main/resources/application.yml`

## 缓存策略

### 1. 分类缓存 (Category Cache)

**缓存名称**: `category`  
**过期时间**: 1小时  
**缓存场景**:
- 分类列表查询（按父级ID）
- 分类树形结构

**缓存键规则**:
- `category:all` - 所有分类
- `category:{parentId}` - 指定父级的子分类

**清除时机**:
- 新增分类时
- 更新分类时
- 删除分类时

**实现位置**: `CulturalRelicCategoryServiceImpl`

```java
@Cacheable(value = CacheConstants.CATEGORY_CACHE, key = "#parentId == null ? 'all' : #parentId")
public List<CulturalRelicCategory> listByParentId(Long parentId)

@CacheEvict(value = CacheConstants.CATEGORY_CACHE, allEntries = true)
public boolean save(CulturalRelicCategory category)
```

### 2. 统计数据缓存 (Statistics Cache)

**缓存名称**: `statistics`  
**过期时间**: 30分钟  
**缓存场景**:
- 概览统计（文物总数、在库数、借展数等）
- 分类分布统计
- 状态分布统计
- 借展频率统计
- 维护统计

**缓存键规则**:
- `statistics:overview` - 概览数据
- `statistics:category-distribution` - 分类分布
- `statistics:status-distribution` - 状态分布
- `statistics:loan-frequency` - 借展频率
- `statistics:maintenance` - 维护统计

**清除时机**:
- 文物数据变更（新增、更新、删除）
- 借展记录变更
- 维护记录变更

**实现位置**: `StatisticsController`

```java
@Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'overview'")
public Result<StatisticsOverviewVO> overview()
```

### 3. 博物馆缓存 (Museum Cache)

**缓存名称**: `museum`  
**过期时间**: 1小时  
**缓存场景**:
- 活跃博物馆列表
- 博物馆详情查询
- 按编码查询博物馆
- 按名称查询博物馆

**缓存键规则**:
- `museum:list:active` - 活跃博物馆列表
- `museum:detail:{id}` - 博物馆详情
- `museum:code:{code}` - 按编码查询
- `museum:name:{name}` - 按名称查询

**清除时机**:
- 新增博物馆时
- 更新博物馆信息时
- 删除博物馆时

**实现位置**: `MuseumServiceImpl`

```java
@Cacheable(value = CacheConstants.MUSEUM_CACHE, key = "'list:active'")
public List<Museum> listAllActive()

@Cacheable(value = CacheConstants.MUSEUM_CACHE, key = "'detail:' + #id")
public Museum getById(Long id)
```

### 4. 图片库缓存 (Image Cache)

**缓存名称**: `image`  
**过期时间**: 30分钟  
**缓存场景**:
- 图片详情查询
- 图片统计数据（分类统计、上传者统计、存储统计）

**缓存键规则**:
- `image:detail:{id}` - 图片详情
- `image:stats:category` - 分类统计
- `image:stats:uploader` - 上传者统计
- `image:stats:storage` - 存储统计

**清除时机**:
- 上传图片时
- 批量上传图片时
- 更新图片信息时
- 删除图片时
- 批量删除图片时

**实现位置**: `ImageLibraryServiceImpl`

```java
@Cacheable(value = CacheConstants.IMAGE_CACHE, key = "'detail:' + #id")
public ImageLibrary getById(Long id)

@Cacheable(value = CacheConstants.IMAGE_CACHE, key = "'stats:category'")
public List<Map<String, Object>> getCategoryStats()
```

## 缓存管理

### 缓存服务

提供统一的缓存管理接口：

**接口**: `CacheService`  
**实现**: `CacheServiceImpl`

**功能**:
- `clearStatisticsCache()` - 清除统计缓存
- `clearCategoryCache()` - 清除分类缓存
- `clearMuseumCache()` - 清除博物馆缓存
- `clearImageCache()` - 清除图片缓存
- `clearAllCache()` - 清除所有缓存

### 手动清除缓存

如需手动清除缓存，可以注入`CacheService`：

```java
@Autowired
private CacheService cacheService;

// 清除统计缓存
cacheService.clearStatisticsCache();

// 清除所有缓存
cacheService.clearAllCache();
```

## 缓存注解说明

### @Cacheable
用于查询方法，如果缓存中有数据则直接返回，否则执行方法并缓存结果。

```java
@Cacheable(value = "cacheName", key = "'key'")
public Object getData() { ... }
```

### @CacheEvict
用于删除缓存，通常用于增删改操作。

```java
@CacheEvict(value = "cacheName", allEntries = true)
public void updateData() { ... }
```

### @CachePut
用于更新缓存，方法总是会执行，结果会更新到缓存。

```java
@CachePut(value = "cacheName", key = "#id")
public Object updateData(Long id) { ... }
```

## 性能优化建议

### 1. 合理设置过期时间
- **频繁变更的数据**: 设置较短过期时间（如统计数据30分钟）
- **相对稳定的数据**: 设置较长过期时间（如分类、博物馆1小时）

### 2. 避免缓存穿透
- 对于不存在的数据，可以缓存空值（已配置`disableCachingNullValues()`）
- 使用布隆过滤器预先判断数据是否存在

### 3. 避免缓存雪崩
- 设置不同的过期时间，避免大量缓存同时失效
- 使用互斥锁或队列控制数据库访问

### 4. 避免缓存击穿
- 对于热点数据，设置永不过期或使用互斥锁

### 5. 缓存预热
- 系统启动时预加载常用数据到缓存
- 定时任务刷新热点数据

## 监控与维护

### Redis监控命令

```bash
# 查看所有键
redis-cli KEYS *

# 查看特定缓存
redis-cli KEYS "category::*"

# 查看缓存过期时间
redis-cli TTL "category::all"

# 清空所有缓存
redis-cli FLUSHALL

# 查看内存使用
redis-cli INFO memory
```

### 缓存命中率监控

建议在生产环境中监控以下指标：
- 缓存命中率
- 缓存大小
- 缓存过期情况
- Redis内存使用率

## 注意事项

1. **序列化问题**: 确保缓存的对象可序列化，避免使用循环引用
2. **缓存一致性**: 更新数据库时及时清除相关缓存
3. **内存管理**: 定期监控Redis内存使用，避免内存溢出
4. **网络延迟**: Redis访问虽快，但仍有网络开销，不要过度缓存
5. **事务处理**: 缓存清除应在事务提交后执行，避免数据不一致

## 扩展建议

### 1. 分布式缓存
如果系统需要水平扩展，考虑使用Redis集群或哨兵模式。

### 2. 二级缓存
结合本地缓存（如Caffeine）和Redis，实现两级缓存架构。

### 3. 缓存预热
在系统启动时或定时任务中预加载热点数据。

### 4. 缓存降级
当Redis不可用时，自动降级到数据库查询。

## 总结

通过合理使用Redis缓存，本项目在以下方面获得显著性能提升：

1. **统计查询**: 从数据库聚合查询优化为缓存读取，响应时间从秒级降至毫秒级
2. **分类数据**: 避免频繁查询数据库，减轻数据库压力
3. **博物馆信息**: 提升用户体验，加快页面加载速度
4. **图片统计**: 复杂统计查询结果缓存，避免重复计算

缓存策略需要根据实际业务场景持续优化和调整。
