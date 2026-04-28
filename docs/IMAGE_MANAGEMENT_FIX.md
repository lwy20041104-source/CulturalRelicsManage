# 图片管理模块编译错误修复

## 问题描述

后端编译时出现错误：
```
E:\java\Graduate\CulturalRelicsManage\CulturalRelicsManage\backend\src\main\java\com\example\service\ImageLibraryService.java:3:61
java: 程序包com.baomidou.mybatisplus.extension.plugins.pagination不存在
```

## 问题原因

项目使用的是**MyBatis**而不是**MyBatis Plus**，但图片管理模块的代码中使用了MyBatis Plus的类和注解：
- `com.baomidou.mybatisplus.extension.plugins.pagination.Page`
- `com.baomidou.mybatisplus.extension.service.IService`
- `com.baomidou.mybatisplus.core.mapper.BaseMapper`
- `@TableName`、`@TableId`等注解

## 解决方案

将所有MyBatis Plus的依赖改为标准MyBatis实现。

## 修改内容

### 1. ImageLibraryService.java

**修改前：**
```java
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;

public interface ImageLibraryService extends IService<ImageLibrary> {
    Page<ImageLibrary> getImagePage(...);
}
```

**修改后：**
```java
import com.example.common.PageResult;

public interface ImageLibraryService {
    PageResult<ImageLibrary> getImagePage(...);
    ImageLibrary getById(Long id);
}
```

### 2. ImageLibraryServiceImpl.java

**修改前：**
```java
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;

public class ImageLibraryServiceImpl extends ServiceImpl<ImageLibraryMapper, ImageLibrary> 
        implements ImageLibraryService {
    
    // 使用 save(), updateById(), removeById() 等MyBatis Plus方法
    // 使用 LambdaQueryWrapper 构建查询
}
```

**修改后：**
```java
import org.springframework.beans.factory.annotation.Autowired;

@Service
public class ImageLibraryServiceImpl implements ImageLibraryService {
    
    @Autowired
    private ImageLibraryMapper imageLibraryMapper;
    
    // 直接调用 Mapper 方法
    // 使用 Map 传递查询参数
}
```

**关键修改：**
- 移除`extends ServiceImpl`
- 注入`ImageLibraryMapper`
- 将`save()`改为`imageLibraryMapper.insert()`
- 将`updateById()`改为`imageLibraryMapper.updateById()`
- 将`removeById()`改为`imageLibraryMapper.deleteById()`
- 将`LambdaQueryWrapper`改为使用`Map`传递参数

### 3. ImageLibraryMapper.java

**修改前：**
```java
import com.baomidou.mybatisplus.core.mapper.BaseMapper;

@Mapper
public interface ImageLibraryMapper extends BaseMapper<ImageLibrary> {
    // 只定义统计方法
}
```

**修改后：**
```java
@Mapper
public interface ImageLibraryMapper {
    
    @Insert("INSERT INTO image_library (...) VALUES (...)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ImageLibrary imageLibrary);
    
    @Select("SELECT * FROM image_library WHERE id = #{id}")
    ImageLibrary selectById(@Param("id") Long id);
    
    @Update("UPDATE image_library SET ... WHERE id = #{id}")
    int updateById(ImageLibrary imageLibrary);
    
    @Delete("DELETE FROM image_library WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    @Select("<script>SELECT * FROM image_library WHERE status = 1 ...</script>")
    List<ImageLibrary> selectByPage(Map<String, Object> params);
    
    @Select("<script>SELECT COUNT(*) FROM image_library WHERE status = 1 ...</script>")
    int countByCondition(Map<String, Object> params);
    
    // 其他查询方法...
}
```

**关键修改：**
- 移除`extends BaseMapper<ImageLibrary>`
- 使用`@Insert`、`@Select`、`@Update`、`@Delete`注解定义SQL
- 使用`<script>`标签支持动态SQL
- 使用`@Options`设置主键自动生成

### 4. ImageLibrary.java

**修改前：**
```java
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;

@Data
@TableName("image_library")
public class ImageLibrary {
    @TableId(type = IdType.AUTO)
    private Long id;
}
```

**修改后：**
```java
import lombok.Data;

@Data
public class ImageLibrary {
    private Long id;
}
```

**关键修改：**
- 移除`@TableName`注解
- 移除`@TableId`注解
- 保留`@Data`注解（Lombok）

### 5. ImageLibraryController.java

**修改前：**
```java
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;

@GetMapping
public Result<Page<ImageLibrary>> getImagePage(...) {
    Page<ImageLibrary> page = imageLibraryService.getImagePage(...);
    return Result.success(page);
}
```

**修改后：**
```java
@GetMapping
public Result<Map<String, Object>> getImagePage(...) {
    PageResult<ImageLibrary> pageResult = imageLibraryService.getImagePage(...);
    
    Map<String, Object> result = new HashMap<>();
    result.put("records", pageResult.getRecords());
    result.put("total", pageResult.getTotal());
    result.put("size", pageResult.getSize());
    result.put("current", pageResult.getCurrent());
    result.put("pages", (pageResult.getTotal() + pageResult.getSize() - 1) / pageResult.getSize());
    
    return Result.success(result);
}
```

**关键修改：**
- 使用`PageResult`替代`Page`
- 手动构建分页结果Map

## 分页实现对比

### MyBatis Plus方式
```java
Page<ImageLibrary> page = new Page<>(pageNum, pageSize);
LambdaQueryWrapper<ImageLibrary> wrapper = new LambdaQueryWrapper<>();
wrapper.eq(ImageLibrary::getStatus, 1)
       .like(ImageLibrary::getImageName, imageName)
       .orderByDesc(ImageLibrary::getCreateTime);
return page(page, wrapper);
```

### 标准MyBatis方式
```java
Map<String, Object> params = new HashMap<>();
params.put("offset", (pageNum - 1) * pageSize);
params.put("limit", pageSize);
params.put("imageName", imageName);

List<ImageLibrary> records = imageLibraryMapper.selectByPage(params);
int total = imageLibraryMapper.countByCondition(params);

return new PageResult<>(records, total, pageNum, pageSize);
```

## 动态SQL实现

使用MyBatis的`<script>`标签和`<if>`标签实现动态SQL：

```java
@Select("<script>" +
        "SELECT * FROM image_library WHERE status = 1 " +
        "<if test='imageName != null and imageName != \"\"'>" +
        "AND image_name LIKE CONCAT('%', #{imageName}, '%') " +
        "</if>" +
        "<if test='category != null and category != \"\"'>" +
        "AND category = #{category} " +
        "</if>" +
        "ORDER BY create_time DESC LIMIT #{offset}, #{limit}" +
        "</script>")
List<ImageLibrary> selectByPage(Map<String, Object> params);
```

## 验证修复

### 1. 编译测试
```bash
cd backend
mvn clean compile
```

应该没有编译错误。

### 2. 启动测试
```bash
mvn spring-boot:run
```

应该能正常启动。

### 3. 功能测试
- 访问图片管理页面
- 测试上传功能
- 测试查询功能
- 测试编辑功能
- 测试删除功能

## 总结

通过将MyBatis Plus的实现改为标准MyBatis实现，解决了编译错误问题。主要改动：

1. **Service层**：移除继承，直接注入Mapper
2. **Mapper层**：使用注解定义SQL，支持动态SQL
3. **Entity层**：移除MyBatis Plus注解
4. **Controller层**：调整返回类型

所有功能保持不变，只是底层实现方式改变。

## 优势

使用标准MyBatis的优势：
- ✅ 不依赖第三方框架
- ✅ SQL更加清晰可控
- ✅ 更容易调试和优化
- ✅ 与项目其他模块保持一致

## 注意事项

1. **参数传递**：使用Map传递多个参数
2. **动态SQL**：使用`<script>`和`<if>`标签
3. **主键生成**：使用`@Options(useGeneratedKeys = true)`
4. **分页查询**：需要两次查询（数据+总数）

修复完成后，图片管理模块可以正常编译和运行！
