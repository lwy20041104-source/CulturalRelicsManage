package com.example.mapper;

import com.example.entity.SysRole;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysRoleMapper {
    SysRole selectById(@Param("id") Long id);
    List<SysRole> selectEnabledList();

    SysRole selectByRoleCode(@Param("roleCode") String roleCode);
}
