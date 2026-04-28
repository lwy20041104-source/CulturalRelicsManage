package com.example.mapper;

import com.example.entity.RelicImageRelation;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 文物图片关联Mapper接口
 */
@Mapper
public interface RelicImageRelationMapper {
    
    /**
     * 插入关联记录
     */
    @Insert("INSERT INTO relic_image_relation (relic_id, image_id, relation_type, sort_order, create_time, update_time) " +
            "VALUES (#{relicId}, #{imageId}, #{relationType}, #{sortOrder}, #{createTime}, #{updateTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(RelicImageRelation relation);
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM relic_image_relation WHERE id = #{id}")
    RelicImageRelation selectById(@Param("id") Long id);
    
    /**
     * 根据文物ID查询关联（一对一，只返回一条）
     */
    @Select("SELECT * FROM relic_image_relation WHERE relic_id = #{relicId} LIMIT 1")
    RelicImageRelation selectByRelicId(@Param("relicId") Long relicId);
    
    /**
     * 根据文物ID查询所有关联（一对多，支持多张图片）
     */
    @Select("SELECT * FROM relic_image_relation WHERE relic_id = #{relicId} ORDER BY is_main DESC, sort_order ASC")
    List<RelicImageRelation> selectAllByRelicId(@Param("relicId") Long relicId);
    
    /**
     * 根据文物ID查询所有关联（包含图片信息）
     */
    @Select("SELECT r.*, i.id as image_id, i.image_name, i.file_name, i.file_path, i.file_size, i.width, i.height, i.file_type " +
            "FROM relic_image_relation r " +
            "LEFT JOIN image_library i ON r.image_id = i.id " +
            "WHERE r.relic_id = #{relicId} AND i.status = 1 " +
            "ORDER BY r.is_main DESC, r.sort_order ASC")
    @Results(id = "relicImageWithDetails", value = {
        @Result(property = "id", column = "id"),
        @Result(property = "relicId", column = "relic_id"),
        @Result(property = "imageId", column = "image_id"),
        @Result(property = "relationType", column = "relation_type"),
        @Result(property = "isMain", column = "is_main"),
        @Result(property = "sortOrder", column = "sort_order"),
        @Result(property = "createTime", column = "create_time"),
        @Result(property = "updateTime", column = "update_time"),
        @Result(property = "image.id", column = "image_id"),
        @Result(property = "image.imageName", column = "image_name"),
        @Result(property = "image.fileName", column = "file_name"),
        @Result(property = "image.filePath", column = "file_path"),
        @Result(property = "image.fileSize", column = "file_size"),
        @Result(property = "image.width", column = "width"),
        @Result(property = "image.height", column = "height"),
        @Result(property = "image.fileType", column = "file_type")
    })
    List<RelicImageRelation> selectAllByRelicIdWithImage(@Param("relicId") Long relicId);
    
    /**
     * 根据图片ID查询关联（一对一，只返回一条）
     */
    @Select("SELECT * FROM relic_image_relation WHERE image_id = #{imageId} LIMIT 1")
    RelicImageRelation selectByImageId(@Param("imageId") Long imageId);
    
    /**
     * 根据文物ID查询关联（包含图片信息）
     */
    @Select("SELECT r.*, i.image_name, i.file_path, i.file_size, i.width, i.height, i.file_type " +
            "FROM relic_image_relation r " +
            "LEFT JOIN image_library i ON r.image_id = i.id " +
            "WHERE r.relic_id = #{relicId} AND i.status = 1 " +
            "ORDER BY r.is_main DESC " +
            "LIMIT 1")
    @Results({
        @Result(property = "id", column = "id"),
        @Result(property = "relicId", column = "relic_id"),
        @Result(property = "imageId", column = "image_id"),
        @Result(property = "relationType", column = "relation_type"),
        @Result(property = "isMain", column = "is_main"),
        @Result(property = "sortOrder", column = "sort_order"),
        @Result(property = "createTime", column = "create_time"),
        @Result(property = "updateTime", column = "update_time"),
        @Result(property = "image.id", column = "image_id"),
        @Result(property = "image.imageName", column = "image_name"),
        @Result(property = "image.filePath", column = "file_path"),
        @Result(property = "image.fileSize", column = "file_size"),
        @Result(property = "image.width", column = "width"),
        @Result(property = "image.height", column = "height"),
        @Result(property = "image.fileType", column = "file_type")
    })
    RelicImageRelation selectByRelicIdWithImage(@Param("relicId") Long relicId);
    
    /**
     * 批量插入关联记录
     */
    @Insert("<script>" +
            "INSERT INTO relic_image_relation (relic_id, image_id, relation_type, is_main, sort_order) VALUES " +
            "<foreach collection='relations' item='item' separator=','>" +
            "(#{item.relicId}, #{item.imageId}, #{item.relationType}, #{item.isMain}, #{item.sortOrder})" +
            "</foreach>" +
            "</script>")
    int batchInsert(@Param("relations") List<RelicImageRelation> relations);
    
    /**
     * 删除指定文物的指定图片关联
     */
    @Delete("DELETE FROM relic_image_relation WHERE relic_id = #{relicId} AND image_id = #{imageId}")
    int deleteByRelicIdAndImageId(@Param("relicId") Long relicId, @Param("imageId") Long imageId);
    
    /**
     * 更新指定图片的主图状态
     */
    @Update("UPDATE relic_image_relation SET is_main = #{isMain}, relation_type = #{relationType} " +
            "WHERE relic_id = #{relicId} AND image_id = #{imageId}")
    int updateIsMain(@Param("relicId") Long relicId, @Param("imageId") Long imageId, 
                     @Param("isMain") Integer isMain, @Param("relationType") String relationType);
    
    /**
     * 批量更新文物所有图片的主图状态
     */
    @Update("UPDATE relic_image_relation SET is_main = #{isMain}, relation_type = #{relationType} " +
            "WHERE relic_id = #{relicId}")
    int batchUpdateIsMain(@Param("relicId") Long relicId, @Param("isMain") Integer isMain, 
                          @Param("relationType") String relationType);
    
    /**
     * 更新关联
     */
    @Update("UPDATE relic_image_relation SET image_id = #{imageId}, relation_type = #{relationType}, " +
            "is_main = #{isMain}, sort_order = #{sortOrder}, update_time = #{updateTime} WHERE id = #{id}")
    int updateById(RelicImageRelation relation);
    
    /**
     * 删除关联
     */
    @Delete("DELETE FROM relic_image_relation WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    /**
     * 根据文物ID删除关联
     */
    @Delete("DELETE FROM relic_image_relation WHERE relic_id = #{relicId}")
    int deleteByRelicId(@Param("relicId") Long relicId);
    
    /**
     * 根据图片ID删除关联
     */
    @Delete("DELETE FROM relic_image_relation WHERE image_id = #{imageId}")
    int deleteByImageId(@Param("imageId") Long imageId);
    
    /**
     * 查询所有关联
     */
    @Select("SELECT * FROM relic_image_relation ORDER BY create_time DESC")
    List<RelicImageRelation> selectAll();
    
    /**
     * 查询有主图的文物数量
     */
    @Select("SELECT COUNT(DISTINCT relic_id) FROM relic_image_relation")
    int countRelicsWithImage();
    
    /**
     * 查询没有主图的文物数量
     */
    @Select("SELECT COUNT(*) FROM cultural_relic r " +
            "WHERE NOT EXISTS (SELECT 1 FROM relic_image_relation ri WHERE ri.relic_id = r.id)")
    int countRelicsWithoutImage();
    
    /**
     * 批量查询文物的图片路径
     */
    @Select("<script>" +
            "SELECT r.relic_id, i.file_path " +
            "FROM relic_image_relation r " +
            "JOIN image_library i ON r.image_id = i.id " +
            "WHERE r.relic_id IN " +
            "<foreach item='id' collection='relicIds' open='(' separator=',' close=')'>" +
            "#{id}" +
            "</foreach>" +
            "AND i.status = 1" +
            "</script>")
    @MapKey("relicId")
    java.util.Map<Long, java.util.Map<String, Object>> selectImagePathsByRelicIds(@Param("relicIds") List<Long> relicIds);
}
