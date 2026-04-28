package com.example.mapper;

import com.example.entity.RelicArchive;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 文物档案Mapper接口
 */
@Mapper
public interface RelicArchiveMapper {
    
    /**
     * 分页查询档案列表
     */
    @Select("<script>" +
            "SELECT * FROM relic_archive " +
            "WHERE 1=1 " +
            "<if test='archiveCode != null and archiveCode != \"\"'>" +
            "AND archive_code LIKE CONCAT('%', #{archiveCode}, '%') " +
            "</if>" +
            "<if test='archiveType != null and archiveType != \"\"'>" +
            "AND archive_type = #{archiveType} " +
            "</if>" +
            "<if test='status != null and status != \"\"'>" +
            "AND status = #{status} " +
            "</if>" +
            "<if test='relicId != null'>" +
            "AND relic_id = #{relicId} " +
            "</if>" +
            "ORDER BY created_time DESC " +
            "LIMIT #{offset}, #{pageSize}" +
            "</script>")
    List<RelicArchive> selectPage(@Param("archiveCode") String archiveCode,
                                   @Param("archiveType") String archiveType,
                                   @Param("status") String status,
                                   @Param("relicId") Long relicId,
                                   @Param("offset") Integer offset,
                                   @Param("pageSize") Integer pageSize);
    
    /**
     * 查询总数
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM relic_archive " +
            "WHERE 1=1 " +
            "<if test='archiveCode != null and archiveCode != \"\"'>" +
            "AND archive_code LIKE CONCAT('%', #{archiveCode}, '%') " +
            "</if>" +
            "<if test='archiveType != null and archiveType != \"\"'>" +
            "AND archive_type = #{archiveType} " +
            "</if>" +
            "<if test='status != null and status != \"\"'>" +
            "AND status = #{status} " +
            "</if>" +
            "<if test='relicId != null'>" +
            "AND relic_id = #{relicId} " +
            "</if>" +
            "</script>")
    Long selectCount(@Param("archiveCode") String archiveCode,
                     @Param("archiveType") String archiveType,
                     @Param("status") String status,
                     @Param("relicId") Long relicId);
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM relic_archive WHERE id = #{id}")
    RelicArchive selectById(@Param("id") Long id);
    
    /**
     * 根据文物ID查询档案
     */
    @Select("SELECT * FROM relic_archive WHERE relic_id = #{relicId} ORDER BY version DESC LIMIT 1")
    RelicArchive selectByRelicId(@Param("relicId") Long relicId);
    
    /**
     * 根据文物ID和状态查询档案
     */
    @Select("SELECT * FROM relic_archive WHERE relic_id = #{relicId} AND status = #{status} LIMIT 1")
    RelicArchive selectByRelicIdAndStatus(@Param("relicId") Long relicId, @Param("status") String status);
    
    /**
     * 根据档案编号查询
     */
    @Select("SELECT * FROM relic_archive WHERE archive_code = #{archiveCode}")
    RelicArchive selectByArchiveCode(@Param("archiveCode") String archiveCode);
    
    /**
     * 插入档案
     */
    @Insert("INSERT INTO relic_archive (relic_id, archive_code, archive_title, archive_type, description, " +
            "version, status, created_by, created_by_name, created_time, updated_time) " +
            "VALUES (#{relicId}, #{archiveCode}, #{archiveTitle}, #{archiveType}, #{description}, " +
            "#{version}, #{status}, #{createdBy}, #{createdByName}, #{createdTime}, #{updatedTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(RelicArchive archive);
    
    /**
     * 更新档案
     */
    @Update("UPDATE relic_archive SET " +
            "archive_title = #{archiveTitle}, " +
            "archive_type = #{archiveType}, " +
            "description = #{description}, " +
            "version = #{version}, " +
            "status = #{status}, " +
            "updated_time = #{updatedTime}, " +
            "published_time = #{publishedTime}, " +
            "archived_time = #{archivedTime} " +
            "WHERE id = #{id}")
    int update(RelicArchive archive);
    
    /**
     * 删除档案
     */
    @Delete("DELETE FROM relic_archive WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    /**
     * 获取最新的档案编号
     */
    @Select("SELECT archive_code FROM relic_archive ORDER BY id DESC LIMIT 1")
    String selectLatestArchiveCode();
    
    /**
     * 统计各状态档案数量
     */
    @Select("SELECT status, COUNT(*) as count FROM relic_archive GROUP BY status")
    List<java.util.Map<String, Object>> selectStatusStatistics();
}
