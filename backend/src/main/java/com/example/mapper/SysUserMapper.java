package com.example.mapper;

import com.example.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysUserMapper {
    SysUser selectByUsername(@Param("username") String username);
    SysUser selectActiveByUsername(@Param("username") String username);
    SysUser selectById(@Param("id") Long id);
    
    /**
     * 根据真实姓名查询用户列表（真实姓名可能不唯一）
     */
    List<SysUser> selectByRealName(@Param("realName") String realName);
    
    List<SysUser> selectPage(@Param("offset") Integer offset,
                             @Param("pageSize") Integer pageSize,
                             @Param("realName") String realName,
                             @Param("roleId") Long roleId);
    long count(@Param("realName") String realName, @Param("roleId") Long roleId);
    int insert(SysUser user);
    int updateById(SysUser user);
}
