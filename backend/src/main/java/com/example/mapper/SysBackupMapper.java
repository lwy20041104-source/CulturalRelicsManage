package com.example.mapper;

import com.example.entity.SysBackup;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 系统备份Mapper
 */
@Mapper
public interface SysBackupMapper {

    /**
     * 查询备份列表
     */
    List<SysBackup> selectList(@Param("backupType") String backupType,
                                @Param("backupStatus") String backupStatus,
                                @Param("offset") int offset,
                                @Param("pageSize") int pageSize);

    /**
     * 统计备份数量
     */
    long countList(@Param("backupType") String backupType,
                   @Param("backupStatus") String backupStatus);

    /**
     * 根据ID查询
     */
    SysBackup selectById(@Param("id") Long id);

    /**
     * 插入备份记录
     */
    int insert(SysBackup backup);

    /**
     * 更新备份记录
     */
    int updateById(SysBackup backup);

    /**
     * 删除备份记录（软删除）
     */
    int deleteById(@Param("id") Long id);

    /**
     * 查询过期备份
     */
    List<SysBackup> selectExpiredBackups(@Param("expireTime") String expireTime);

    /**
     * 获取所有数据库表名
     */
    List<String> getAllTables();

    /**
     * 获取数据库名称
     */
    String getDatabaseName();
}
