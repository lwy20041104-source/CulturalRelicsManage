package com.example.mapper;

import com.example.entity.ArchiveRelation;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 档案关联关系Mapper接口
 */
@Mapper
public interface ArchiveRelationMapper {
    
    /**
     * 根据档案ID查询关联记录
     */
    @Select("SELECT * FROM archive_relation WHERE archive_id = #{archiveId} ORDER BY relation_time DESC")
    List<ArchiveRelation> selectByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据关联类型查询
     */
    @Select("SELECT * FROM archive_relation WHERE archive_id = #{archiveId} AND relation_type = #{relationType} ORDER BY relation_time DESC")
    List<ArchiveRelation> selectByArchiveIdAndType(@Param("archiveId") Long archiveId, @Param("relationType") String relationType);
    
    /**
     * 插入关联记录
     */
    @Insert("INSERT INTO archive_relation (archive_id, relation_type, relation_id, relation_time, relation_desc) " +
            "VALUES (#{archiveId}, #{relationType}, #{relationId}, #{relationTime}, #{relationDesc})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ArchiveRelation relation);
    
    /**
     * 删除关联记录
     */
    @Delete("DELETE FROM archive_relation WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    /**
     * 删除档案的所有关联记录
     */
    @Delete("DELETE FROM archive_relation WHERE archive_id = #{archiveId}")
    int deleteByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 检查关联是否存在
     */
    @Select("SELECT COUNT(*) FROM archive_relation WHERE archive_id = #{archiveId} AND relation_type = #{relationType} AND relation_id = #{relationId}")
    int existsRelation(@Param("archiveId") Long archiveId, @Param("relationType") String relationType, @Param("relationId") Long relationId);
}
