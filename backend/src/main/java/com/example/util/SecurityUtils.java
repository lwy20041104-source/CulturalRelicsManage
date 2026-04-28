package com.example.util;

import com.example.entity.SysUser;
import com.example.mapper.SysUserMapper;
import com.example.security.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;

@Slf4j
@Component
public class SecurityUtils {

    private final SysUserMapper sysUserMapper;
    private final JwtTokenProvider jwtTokenProvider;

    public SecurityUtils(SysUserMapper sysUserMapper, JwtTokenProvider jwtTokenProvider) {
        this.sysUserMapper = sysUserMapper;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    /**
     * 从认证信息中获取用户ID
     * 优先从JWT token中获取，如果失败则从数据库查询
     * @param authentication Spring Security认证对象
     * @return 用户ID，如果获取失败返回null
     */
    public Long getUserIdFromAuth(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            log.warn("认证信息为空，无法获取用户ID");
            return null;
        }

        // 方法1：尝试从JWT token中直接获取userId（最优方案）
        try {
            String token = getTokenFromRequest();
            if (token != null) {
                String userIdStr = jwtTokenProvider.getUserIdFromToken(token);
                if (userIdStr != null && !userIdStr.isEmpty()) {
                    Long userId = Long.parseLong(userIdStr);
                    log.debug("从JWT token获取用户ID成功：userId={}", userId);
                    return userId;
                }
            }
        } catch (Exception e) {
            log.debug("从JWT token获取用户ID失败，尝试其他方法：{}", e.getMessage());
        }

        String username = authentication.getName();
        
        // 方法2：尝试直接解析为数字（兼容旧代码）
        try {
            Long userId = Long.parseLong(username);
            log.debug("用户名是数字格式，直接使用：userId={}", userId);
            return userId;
        } catch (NumberFormatException e) {
            // 用户名不是数字，继续下一步
            log.debug("用户名不是数字格式：{}", username);
        }

        // 方法3：从数据库查询用户（兜底方案）
        try {
            SysUser user = sysUserMapper.selectByUsername(username);
            if (user != null) {
                log.debug("从数据库查询用户ID成功：username={}, userId={}", username, user.getId());
                return user.getId();
            } else {
                log.warn("用户不存在：{}", username);
                return null;
            }
        } catch (Exception e) {
            log.error("查询用户ID失败：username={}, error={}", username, e.getMessage(), e);
            return null;
        }
    }

    /**
     * 从当前请求中获取JWT token
     * @return JWT token，如果获取失败返回null
     */
    private String getTokenFromRequest() {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                String authHeader = request.getHeader("Authorization");
                if (authHeader != null && authHeader.startsWith("Bearer ")) {
                    return authHeader.substring(7);
                }
            }
        } catch (Exception e) {
            log.debug("获取JWT token失败：{}", e.getMessage());
        }
        return null;
    }

    /**
     * 从认证信息中获取用户名
     * @param authentication Spring Security认证对象
     * @return 用户名
     */
    public String getUsernameFromAuth(Authentication authentication) {
        if (authentication == null) {
            return null;
        }
        return authentication.getName();
    }
}
