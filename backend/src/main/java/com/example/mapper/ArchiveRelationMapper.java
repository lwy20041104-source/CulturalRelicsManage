package com.example.mapper;

import com.example.entity.ArchiveRelation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 档案关联关系Mapper接口
 */
@Mapper
public interface ArchiveRelationMapper {
    
    /**
     * 根据档案ID查询关联记录
     */
    List<ArchiveRelation> selectByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据关联类型查询
     */
    List<ArchiveRelation> selectByArchiveIdAndType(@Param("archiveId") Long archiveId, @Param("relationType") String relationType);
    
    /**
     * 插入关联记录
     */
    int insert(ArchiveRelation relation);
    
    /**
     * 删除关联记录
     */
    int deleteById(@Param("id") Long id);
    
    /**
     * 删除档案的所有关联记录
     */
    int deleteByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 检查关联是否存在
     */
    int existsRelation(@Param("archiveId") Long archiveId, @Param("relationType") String relationType, @Param("relationId") Long relationId);
}
