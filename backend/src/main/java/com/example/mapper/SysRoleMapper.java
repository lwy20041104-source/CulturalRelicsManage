package com.example.mapper;

import com.example.entity.SysRole;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface SysRoleMapper {
    SysRole selectById(@Param("id") Long id);
    List<SysRole> selectEnabledList();
    
    @Select("SELECT * FROM sys_role WHERE role_code = #{roleCode} AND status = 1 LIMIT 1")
    SysRole selectByRoleCode(@Param("roleCode") String roleCode);
}
