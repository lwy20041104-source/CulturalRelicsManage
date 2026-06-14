package com.example.mapper;

import com.example.entity.SysBackupConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 备份配置Mapper
 */
@Mapper
public interface SysBackupConfigMapper {

    /**
     * 查询所有配置
     */
    List<SysBackupConfig> selectAll();

    /**
     * 根据ID查询
     */
    SysBackupConfig selectById(@Param("id") Long id);

    /**
     * 插入配置
     */
    int insert(SysBackupConfig config);

    /**
     * 更新配置
     */
    int updateById(SysBackupConfig config);
}
