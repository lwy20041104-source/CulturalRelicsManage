package com.example.mapper;

import com.example.entity.SysBackupConfig;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 备份配置Mapper
 */
@Mapper
public interface SysBackupConfigMapper {
    
    /**
     * 查询所有配置
     */
    @Select("SELECT * FROM sys_backup_config")
    List<SysBackupConfig> selectAll();
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM sys_backup_config WHERE id = #{id}")
    SysBackupConfig selectById(@Param("id") Long id);
    
    /**
     * 插入配置
     */
    @Insert("INSERT INTO sys_backup_config (config_name, is_enabled, backup_frequency, backup_time, " +
            "retention_days, max_backup_count, is_encrypted, backup_tables, notification_enabled, " +
            "created_by, created_time) " +
            "VALUES (#{configName}, #{isEnabled}, #{backupFrequency}, #{backupTime}, " +
            "#{retentionDays}, #{maxBackupCount}, #{isEncrypted}, #{backupTables}, #{notificationEnabled}, " +
            "#{createdBy}, #{createdTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(SysBackupConfig config);
    
    /**
     * 更新配置
     */
    @Update("UPDATE sys_backup_config SET config_name = #{configName}, is_enabled = #{isEnabled}, " +
            "backup_frequency = #{backupFrequency}, backup_time = #{backupTime}, " +
            "retention_days = #{retentionDays}, max_backup_count = #{maxBackupCount}, " +
            "is_encrypted = #{isEncrypted}, backup_tables = #{backupTables}, " +
            "notification_enabled = #{notificationEnabled}, updated_by = #{updatedBy}, " +
            "updated_time = NOW() WHERE id = #{id}")
    int updateById(SysBackupConfig config);
}
