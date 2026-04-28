package com.example.mapper;

import com.example.entity.ArchiveDocument;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 档案文档Mapper接口
 */
@Mapper
public interface ArchiveDocumentMapper {
    
    /**
     * 根据档案ID查询文档列表
     */
    @Select("SELECT * FROM archive_document WHERE archive_id = #{archiveId} ORDER BY sort_order, upload_time DESC")
    List<ArchiveDocument> selectByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM archive_document WHERE id = #{id}")
    ArchiveDocument selectById(@Param("id") Long id);
    
    /**
     * 插入文档
     */
    @Insert("INSERT INTO archive_document (archive_id, document_type, document_name, file_path, " +
            "file_size, file_format, upload_time, uploader_id, uploader_name, description, sort_order) " +
            "VALUES (#{archiveId}, #{documentType}, #{documentName}, #{filePath}, " +
            "#{fileSize}, #{fileFormat}, #{uploadTime}, #{uploaderId}, #{uploaderName}, #{description}, #{sortOrder})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ArchiveDocument document);
    
    /**
     * 更新文档
     */
    @Update("UPDATE archive_document SET " +
            "document_name = #{documentName}, " +
            "description = #{description}, " +
            "sort_order = #{sortOrder} " +
            "WHERE id = #{id}")
    int update(ArchiveDocument document);
    
    /**
     * 删除文档
     */
    @Delete("DELETE FROM archive_document WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    /**
     * 统计档案文档数量
     */
    @Select("SELECT COUNT(*) FROM archive_document WHERE archive_id = #{archiveId}")
    Integer countByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 统计档案文档总大小
     */
    @Select("SELECT COALESCE(SUM(file_size), 0) FROM archive_document WHERE archive_id = #{archiveId}")
    Long sumFileSizeByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据文档类型查询
     */
    @Select("SELECT * FROM archive_document WHERE archive_id = #{archiveId} AND document_type = #{documentType} ORDER BY upload_time DESC")
    List<ArchiveDocument> selectByArchiveIdAndType(@Param("archiveId") Long archiveId, @Param("documentType") String documentType);
}
