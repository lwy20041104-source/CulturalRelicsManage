package com.example.aspect;

import com.example.annotation.OperationLog;
import com.example.entity.SysUser;
import com.example.mapper.SysUserMapper;
import com.example.service.SysOperationLogService;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;

@Aspect
@Component
public class OperationLogAspect {
    
    private static final Logger logger = LoggerFactory.getLogger(OperationLogAspect.class);
    
    private final SysOperationLogService logService;
    private final SysUserMapper userMapper;
    
    public OperationLogAspect(SysOperationLogService logService, SysUserMapper userMapper) {
        this.logService = logService;
        this.userMapper = userMapper;
        logger.info("OperationLogAspect initialized successfully");
    }
    
    @Around("@annotation(com.example.annotation.OperationLog)")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        OperationLog annotation = method.getAnnotation(OperationLog.class);
        
        logger.info("AOP intercepted method: {}.{}", joinPoint.getTarget().getClass().getName(), method.getName());
        
        String operator = "未知用户";
        String ipAddress = "未知";
        
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal())) {
                String username = authentication.getName();
                // 获取用户真实姓名
                SysUser user = userMapper.selectByUsername(username);
                if (user != null && user.getRealName() != null && !user.getRealName().isEmpty()) {
                    operator = user.getRealName();
                } else {
                    operator = username;
                }
            }
            
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                ipAddress = getIpAddress(request);
            }
        } catch (Exception e) {
            logger.warn("Failed to get user info: {}", e.getMessage());
        }
        
        String operationType = annotation.operationType();
        String operationModule = annotation.operationModule();
        // 如果注解中指定了操作内容，使用指定的内容，否则使用方法名
        String operationContent = annotation.operationContent().isEmpty() 
            ? method.getName() 
            : annotation.operationContent();
        String operationResult = "成功";
        
        try {
            Object result = joinPoint.proceed();
            return result;
        } catch (Exception e) {
            operationResult = "失败";
            throw e;
        } finally {
            try {
                logger.info("Recording operation log: operator={}, type={}, module={}, content={}, result={}", 
                    operator, operationType, operationModule, operationContent, operationResult);
                logService.log(operator, operationType, operationModule, operationContent, operationResult, ipAddress);
            } catch (Exception e) {
                logger.error("Failed to record operation log: {}", e.getMessage(), e);
            }
        }
    }
    
    private String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
