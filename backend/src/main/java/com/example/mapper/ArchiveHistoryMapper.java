package com.example.mapper;

import com.example.entity.ArchiveHistory;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 档案历史记录Mapper接口
 */
@Mapper
public interface ArchiveHistoryMapper {
    
    /**
     * 根据档案ID查询历史记录
     */
    @Select("SELECT * FROM archive_history WHERE archive_id = #{archiveId} ORDER BY operation_time DESC")
    List<ArchiveHistory> selectByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据档案ID和版本号查询
     */
    @Select("SELECT * FROM archive_history WHERE archive_id = #{archiveId} AND version = #{version} ORDER BY operation_time DESC")
    List<ArchiveHistory> selectByArchiveIdAndVersion(@Param("archiveId") Long archiveId, @Param("version") Integer version);
    
    /**
     * 插入历史记录
     */
    @Insert("INSERT INTO archive_history (archive_id, version, operation_type, operation_content, " +
            "change_log, operator_id, operator_name, operation_time, ip_address) " +
            "VALUES (#{archiveId}, #{version}, #{operationType}, #{operationContent}, " +
            "#{changeLog}, #{operatorId}, #{operatorName}, #{operationTime}, #{ipAddress})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(ArchiveHistory history);
    
    /**
     * 删除档案的所有历史记录
     */
    @Delete("DELETE FROM archive_history WHERE archive_id = #{archiveId}")
    int deleteByArchiveId(@Param("archiveId") Long archiveId);
}
