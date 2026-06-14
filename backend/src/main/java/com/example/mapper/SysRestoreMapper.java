package com.example.mapper;

import com.example.entity.SysRestore;
import org.apache.ibatis.annotations.Mapper;

/**
 * 系统恢复Mapper
 */
@Mapper
public interface SysRestoreMapper {

    /**
     * 插入恢复记录
     */
    int insert(SysRestore restore);

    /**
     * 更新恢复记录
     */
    int updateById(SysRestore restore);
}
