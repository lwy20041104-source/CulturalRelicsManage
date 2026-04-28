package com.example.service;

import com.example.common.PageResult;
import com.example.dto.RegisterRequest;
import com.example.entity.SysRole;
import com.example.entity.SysUser;

import java.util.List;

public interface SysUserService {
    SysUser getUserByUsername(String username);
    SysUser getUserById(Long id);
    SysUser login(String username, String password, String roleCode, String ipAddress);
    boolean resetAdminPassword();
    PageResult<SysUser> pageUsers(Integer pageNum, Integer pageSize, String realName, Long roleId);
    List<SysRole> listRoles();
    boolean save(SysUser user);
    boolean updateById(SysUser user);
    boolean removeById(Long id);
    
    /**
     * 借展人注册
     * @param request 注册请求
     * @return 注册成功的用户ID
     */
    Long register(RegisterRequest request);
}
