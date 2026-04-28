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
     */
    public Long getCurrentUserId() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !authentication.isAuthenticated() || "anonymousUser".equals(authentication.getPrincipal())) {
                return null;
            }
            
            String username = authentication.getName();
            SysUser user = userMapper.selectByUsername(username);
            
            return user != null ? user.getId() : null;
        } catch (Exception e) {
            System.err.println("获取当前用户ID失败: " + e.getMessage());
            return null;
        }
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
