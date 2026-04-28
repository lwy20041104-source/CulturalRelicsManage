package com.example.mapper;

import com.example.entity.SysRestore;
import org.apache.ibatis.annotations.*;

/**
 * 系统恢复Mapper
 */
@Mapper
public interface SysRestoreMapper {
    
    /**
     * 插入恢复记录
     */
    @Insert("INSERT INTO sys_restore (backup_id, restore_status, restore_type, restore_tables, " +
            "error_message, created_by, created_time) " +
            "VALUES (#{backupId}, #{restoreStatus}, #{restoreType}, #{restoreTables}, " +
            "#{errorMessage}, #{createdBy}, #{createdTime})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(SysRestore restore);
    
    /**
     * 更新恢复记录
     */
    @Update("UPDATE sys_restore SET restore_status = #{restoreStatus}, error_message = #{errorMessage}, " +
            "completed_time = #{completedTime} WHERE id = #{id}")
    int updateById(SysRestore restore);
}
