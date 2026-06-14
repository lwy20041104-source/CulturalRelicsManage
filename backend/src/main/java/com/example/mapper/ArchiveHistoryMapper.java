package com.example.mapper;

import com.example.entity.ArchiveHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 档案历史记录Mapper接口
 */
@Mapper
public interface ArchiveHistoryMapper {
    
    /**
     * 根据档案ID查询历史记录
     */
    List<ArchiveHistory> selectByArchiveId(@Param("archiveId") Long archiveId);
    
    /**
     * 根据档案ID和版本号查询
     */
    List<ArchiveHistory> selectByArchiveIdAndVersion(@Param("archiveId") Long archiveId, @Param("version") Integer version);
    
    /**
     * 插入历史记录
     */
    int insert(ArchiveHistory history);
    
    /**
     * 删除档案的所有历史记录
     */
    int deleteByArchiveId(@Param("archiveId") Long archiveId);
}
