package com.example.mapper;

import com.example.entity.RelicArchive;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 文物档案Mapper接口
 */
@Mapper
public interface RelicArchiveMapper {

    /**
     * 分页查询档案列表
     */
    List<RelicArchive> selectPage(@Param("archiveCode") String archiveCode,
                                   @Param("archiveType") String archiveType,
                                   @Param("status") String status,
                                   @Param("relicId") Long relicId,
                                   @Param("offset") Integer offset,
                                   @Param("pageSize") Integer pageSize);

    /**
     * 查询总数
     */
    Long selectCount(@Param("archiveCode") String archiveCode,
                     @Param("archiveType") String archiveType,
                     @Param("status") String status,
                     @Param("relicId") Long relicId);

    /**
     * 根据ID查询
     */
    RelicArchive selectById(@Param("id") Long id);

    /**
     * 根据文物ID查询档案
     */
    RelicArchive selectByRelicId(@Param("relicId") Long relicId);

    /**
     * 根据文物ID和状态查询档案
     */
    RelicArchive selectByRelicIdAndStatus(@Param("relicId") Long relicId, @Param("status") String status);

    /**
     * 根据档案编号查询
     */
    RelicArchive selectByArchiveCode(@Param("archiveCode") String archiveCode);

    /**
     * 插入档案
     */
    int insert(RelicArchive archive);

    /**
     * 更新档案
     */
    int update(RelicArchive archive);

    /**
     * 删除档案
     */
    int deleteById(@Param("id") Long id);

    /**
     * 获取最新的档案编号
     */
    String selectLatestArchiveCode();

    /**
     * 统计各状态档案数量
     */
    List<java.util.Map<String, Object>> selectStatusStatistics();
}
