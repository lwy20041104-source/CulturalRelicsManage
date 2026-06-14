package com.example.mapper;

import com.example.entity.ArchiveDocument;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 档案文档Mapper接口
 */
@Mapper
public interface ArchiveDocumentMapper {
    
    /**
     * 根据档案ID查询文档列表
     */
    List<ArchiveDocument> selectByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据ID查询
     */
    ArchiveDocument selectById(@Param("id") Long id);
    
    /**
     * 插入文档
     */
    int insert(ArchiveDocument document);
    
    /**
     * 更新文档
     */
    int update(ArchiveDocument document);
    
    /**
     * 删除文档
     */
    int deleteById(@Param("id") Long id);
    
    /**
     * 统计档案文档数量
     */
    Integer countByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 统计档案文档总大小
     */
    Long sumFileSizeByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据文档类型查询
     */
    List<ArchiveDocument> selectByArchiveIdAndType(@Param("archiveId") Long archiveId, @Param("documentType") String documentType);
}
