package com.example.util;

import com.example.entity.SysUser;
import com.example.mapper.SysUserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;

/**
 * 用户上下文工具类
 * 用于获取当前登录用户的信息
 */
@Slf4j
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
            log.error("获取当前用户ID失败: {}", e.getMessage(), e);
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
    
    /**
     * 获取客户端真实IP地址（静态工具方法）
     */
    public static String getClientIp(HttpServletRequest request) {
        if (request == null) {
            return "未知";
        }
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
