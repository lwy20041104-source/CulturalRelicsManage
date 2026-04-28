package com.example.util;

import com.example.entity.SysUser;
import com.example.mapper.SysUserMapper;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

/**
 * 用户上下文工具类
 * 用于获取当前登录用户的信息
 */
@Component
public class UserContextUtil {
    
    private final SysUserMapper userMapper;
    
    public UserContextUtil(SysUserMapper userMapper) {
        this.userMapper = userMapper;
    }
    
    /**
     * 获取当前登录用户的真实姓名
     * 如果获取失败，返回用户名
     * 如果用户未登录，返回"系统"
     */
    public String getCurrentUserRealName() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
                return "系统";
            }
            
            String username = authentication.getName();
            SysUser user = userMapper.selectByUsername(username);
            
            if (user != null && user.getRealName() != null && !user.getRealName().isEmpty()) {
                return user.getRealName();
            }
            
            return username;
        } catch (Exception e) {
            return "系统";
        }
    }
    
    /**
     * 获取当前登录用户的用户名
     */
    public String getCurrentUsername() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
                return "系统";
            }
            return authentication.getName();
        } catch (Exception e) {
            return "系统";
        }
    }
    
    /**
     * 获取当前登录用户的ID
     * 注意：这里返回硬编码的1L，生产环境应该从authentication中获取真实用户ID
     */
    public Long getCurrentUserId() {
        // TODO: 从authentication中获取真实用户ID
        return 1L;
    }
    
    /**
     * 获取当前登录用户的完整信息
     */
    public SysUser getCurrentUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
                return null;
            }
            
            String username = authentication.getName();
            return userMapper.selectByUsername(username);
        } catch (Exception e) {
            return null;
        }
    }
}
