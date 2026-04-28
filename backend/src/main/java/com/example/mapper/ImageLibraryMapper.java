package com.example.mapper;

import com.example.entity.ImageLibrary;
import org.apache.ibatis.annotations.*;

import java.util.List;
import java.util.Map;

/**
 * 图片库Mapper接口
 */
@Mapper
public interface ImageLibraryMapper {
    
    /**
     * 插入图片记录
     */
    @Insert("INSERT INTO image_library (image_name, original_name, file_path, file_size, file_type, " +
            "width, height, category, tags, description, uploader_id, uploader_name, " +
            "is_public, view_count, download_count, status, create_time, update_time) " +
            "VALUES (#{imageName}, #{originalName}, #{filePath}, #{fileSize}, #{fileType}, " +
            "#{width}, #{height}, #{category}, #{tags}, #{description}, #{uploaderId}, #{uploaderName}, " +
            "#{isPublic}, #{viewCount}, #{downloadCount}, #{status}, #{createTime}, #{updateTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ImageLibrary imageLibrary);
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM image_library WHERE id = #{id}")
    ImageLibrary selectById(@Param("id") Long id);
    
    /**
     * 更新图片信息
     */
    @Update("UPDATE image_library SET image_name = #{imageName}, category = #{category}, " +
            "tags = #{tags}, description = #{description}, is_public = #{isPublic}, " +
            "reference_type = #{referenceType}, reference_id = #{referenceId}, " +
            "update_time = #{updateTime}, status = #{status} WHERE id = #{id}")
    int updateById(ImageLibrary imageLibrary);
    
    /**
     * 删除图片
     */
    @Delete("DELETE FROM image_library WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    /**
     * 分页查询
     */
    @Select("<script>" +
            "SELECT * FROM image_library WHERE status = 1 " +
            "<if test='imageName != null and imageName != \"\"'> AND image_name LIKE CONCAT('%', #{imageName}, '%') </if>" +
            "<if test='category != null and category != \"\"'> AND category = #{category} </if>" +
            "<if test='uploaderId != null'> AND uploader_id = #{uploaderId} </if>" +
            "<if test='tags != null and tags != \"\"'> AND tags LIKE CONCAT('%', #{tags}, '%') </if>" +
            "ORDER BY create_time DESC LIMIT #{offset}, #{limit}" +
            "</script>")
    List<ImageLibrary> selectByPage(Map<String, Object> params);
    
    /**
     * 统计总数
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM image_library WHERE status = 1 " +
            "<if test='imageName != null and imageName != \"\"'> AND image_name LIKE CONCAT('%', #{imageName}, '%') </if>" +
            "<if test='category != null and category != \"\"'> AND category = #{category} </if>" +
            "<if test='uploaderId != null'> AND uploader_id = #{uploaderId} </if>" +
            "<if test='tags != null and tags != \"\"'> AND tags LIKE CONCAT('%', #{tags}, '%') </if>" +
            "</script>")
    int countByCondition(Map<String, Object> params);
    
    /**
     * 根据关联查询
     */
    @Select("SELECT * FROM image_library WHERE status = 1 AND reference_type = #{referenceType} " +
            "AND reference_id = #{referenceId} ORDER BY create_time DESC")
    List<ImageLibrary> selectByReference(Map<String, Object> params);
    
    /**
     * 关键词搜索
     */
    @Select("<script>" +
            "SELECT * FROM image_library WHERE status = 1 " +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND (image_name LIKE CONCAT('%', #{keyword}, '%') " +
            "OR tags LIKE CONCAT('%', #{keyword}, '%') " +
            "OR description LIKE CONCAT('%', #{keyword}, '%'))" +
            "</if>" +
            "ORDER BY create_time DESC" +
            "</script>")
    List<ImageLibrary> searchByKeyword(Map<String, Object> params);
    
    /**
     * 增加浏览次数
     */
    @Update("UPDATE image_library SET view_count = view_count + 1 WHERE id = #{id}")
    void incrementViewCount(@Param("id") Long id);
    
    /**
     * 增加下载次数
     */
    @Update("UPDATE image_library SET download_count = download_count + 1 WHERE id = #{id}")
    void incrementDownloadCount(@Param("id") Long id);
    
    /**
     * 获取分类统计
     */
    @Select("SELECT category, COUNT(*) as count, SUM(file_size) as totalSize " +
            "FROM image_library WHERE status = 1 GROUP BY category")
    List<Map<String, Object>> getCategoryStats();
    
    /**
     * 获取上传者统计
     */
    @Select("SELECT uploader_name, COUNT(*) as count " +
            "FROM image_library WHERE status = 1 GROUP BY uploader_name " +
            "ORDER BY count DESC LIMIT 10")
    List<Map<String, Object>> getUploaderStats();
    
    /**
     * 获取存储统计
     */
    @Select("SELECT " +
            "COUNT(*) as totalCount, " +
            "SUM(file_size) as totalSize, " +
            "AVG(file_size) as avgSize, " +
            "MAX(file_size) as maxSize " +
            "FROM image_library WHERE status = 1")
    Map<String, Object> getStorageStats();
}
