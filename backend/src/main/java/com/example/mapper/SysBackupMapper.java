package com.example.mapper;

import com.example.entity.SysBackup;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 系统备份Mapper
 */
@Mapper
public interface SysBackupMapper {
    
    /**
     * 查询备份列表
     */
    @Select("<script>" +
            "SELECT * FROM sys_backup WHERE deleted = 0 " +
            "<if test='backupType != null and backupType != \"\"'> AND backup_type = #{backupType} </if>" +
            "<if test='backupStatus != null and backupStatus != \"\"'> AND backup_status = #{backupStatus} </if>" +
            "ORDER BY created_time DESC " +
            "LIMIT #{offset}, #{pageSize}" +
            "</script>")
    List<SysBackup> selectList(@Param("backupType") String backupType, 
                                @Param("backupStatus") String backupStatus,
                                @Param("offset") int offset,
                                @Param("pageSize") int pageSize);
    
    /**
     * 统计备份数量
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM sys_backup WHERE deleted = 0 " +
            "<if test='backupType != null and backupType != \"\"'> AND backup_type = #{backupType} </if>" +
            "<if test='backupStatus != null and backupStatus != \"\"'> AND backup_status = #{backupStatus} </if>" +
            "</script>")
    long countList(@Param("backupType") String backupType, 
                   @Param("backupStatus") String backupStatus);
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM sys_backup WHERE id = #{id} AND deleted = 0")
    SysBackup selectById(@Param("id") Long id);
    
    /**
     * 插入备份记录
     */
    @Insert("INSERT INTO sys_backup (backup_name, backup_type, backup_status, file_name, file_path, " +
            "file_size, is_encrypted, backup_tables, description, error_message, created_by, created_time, deleted) " +
            "VALUES (#{backupName}, #{backupType}, #{backupStatus}, #{fileName}, #{filePath}, " +
            "#{fileSize}, #{isEncrypted}, #{backupTables}, #{description}, #{errorMessage}, #{createdBy}, #{createdTime}, 0)")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(SysBackup backup);
    
    /**
     * 更新备份记录
     */
    @Update("UPDATE sys_backup SET backup_status = #{backupStatus}, file_size = #{fileSize}, " +
            "error_message = #{errorMessage} WHERE id = #{id}")
    int updateById(SysBackup backup);
    
    /**
     * 删除备份记录（软删除）
     */
    @Update("UPDATE sys_backup SET deleted = 1 WHERE id = #{id}")
    int deleteById(@Param("id") Long id);
    
    /**
     * 查询过期备份
     */
    @Select("SELECT * FROM sys_backup WHERE deleted = 0 AND backup_type = 'auto' " +
            "AND created_time < #{expireTime}")
    List<SysBackup> selectExpiredBackups(@Param("expireTime") String expireTime);
    
    /**
     * 获取所有数据库表名
     */
    @Select("SHOW TABLES")
    List<String> getAllTables();
    
    /**
     * 获取数据库名称
     */
    @Select("SELECT DATABASE()")
    String getDatabaseName();
}
