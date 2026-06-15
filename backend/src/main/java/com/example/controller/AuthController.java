package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.Result;
import com.example.dto.ForgotPasswordRequest;
import com.example.dto.LoginRequest;
import com.example.dto.LoginResponse;
import com.example.dto.RegisterRequest;
import com.example.dto.ResetPasswordRequest;
import com.example.entity.SysRole;
import com.example.entity.SysUser;
import com.example.mapper.SysRoleMapper;
import com.example.security.JwtTokenProvider;
import com.example.service.PasswordResetService;
import com.example.service.SysOperationLogService;
import com.example.service.SysUserService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;
import javax.validation.Valid;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/auth")
@Validated
public class AuthController {

    private final SysUserService sysUserService;
    private final JwtTokenProvider jwtTokenProvider;
    private final SysRoleMapper sysRoleMapper;
    private final DataSource dataSource;
    private final SysOperationLogService logService;
    private final PasswordResetService passwordResetService;

    public AuthController(SysUserService sysUserService, JwtTokenProvider jwtTokenProvider, 
                         SysRoleMapper sysRoleMapper, DataSource dataSource,
                         SysOperationLogService logService, PasswordResetService passwordResetService) {
        this.sysUserService = sysUserService;
        this.jwtTokenProvider = jwtTokenProvider;
        this.sysRoleMapper = sysRoleMapper;
        this.dataSource = dataSource;
        this.logService = logService;
        this.passwordResetService = passwordResetService;
    }

    @PostMapping("/login")
    public Result<LoginResponse> login(@RequestBody LoginRequest request, HttpServletRequest httpRequest) {
        String operationResult = "成功";
        SysUser user = null;
        String ipAddress = getIpAddress();
        
        try {
            // 如果是借展人登录，验证博物馆ID
            if ("LOANER".equals(request.getRoleCode())) {
                if (request.getMuseumId() == null) {
                    return Result.error("借展人登录必须选择博物馆");
                }
                // 这里可以添加验证用户是否属于该博物馆的逻辑
            }
            
            // 传递IP地址到login方法
            user = sysUserService.login(request.getUsername(), request.getPassword(), request.getRoleCode(), ipAddress);
            String token = jwtTokenProvider.generateToken(user.getUsername(), String.valueOf(user.getId()));
            LoginResponse response = new LoginResponse(token, user.getUsername(), user.getRealName(), user.getId(), user.getPhone());
            return Result.success("登录成功", response);
        } catch (IllegalArgumentException e) {
            operationResult = "失败";
            // 返回具体的错误信息（包含剩余尝试次数或锁定信息）
            return Result.error(e.getMessage());
        } catch (Exception e) {
            operationResult = "失败";
            return Result.error("登录失败：" + e.getMessage());
        } finally {
            // 手动记录登录日志
            try {
                String operator;
                if (user != null && user.getRealName() != null && !user.getRealName().isEmpty()) {
                    operator = user.getRealName();
                } else if (request.getUsername() != null) {
                    // 登录失败时 user 为 null，通过用户名查询真实姓名
                    SysUser dbUser = sysUserService.getUserByUsername(request.getUsername());
                    operator = (dbUser != null && dbUser.getRealName() != null && !dbUser.getRealName().isEmpty())
                        ? dbUser.getRealName()
                        : request.getUsername();
                } else {
                    operator = "未知用户";
                }
                logService.log(operator, "登录", "系统认证", "用户登录", operationResult, ipAddress);
            } catch (Exception e) {
                // 记录日志失败不影响登录
            }
        }
    }
    
    /**
     * 借展人注册
     */
    @PostMapping("/register")
    public Result<Long> register(@Valid @RequestBody RegisterRequest request) {
        try {
            Long userId = sysUserService.register(request);
            
            // 记录注册日志
            try {
                String ipAddress = getIpAddress();
                logService.log(request.getRealName(), "注册", "系统认证", 
                        "借展人注册：" + request.getUsername(), "成功", ipAddress);
            } catch (Exception e) {
                // 记录日志失败不影响注册
            }
            
            return Result.success("注册成功，请登录", userId);
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            // 记录注册失败日志
            try {
                String ipAddress = getIpAddress();
                logService.log(request.getUsername(), "注册", "系统认证", 
                        "借展人注册失败", "失败", ipAddress);
            } catch (Exception ex) {
                // 忽略
            }
            return Result.error("注册失败：" + e.getMessage());
        }
    }

    @GetMapping("/admin/self-check")
    public Result<Map<String, Object>> adminSelfCheck() {
        Map<String, Object> data = new HashMap<>();
        try (Connection connection = dataSource.getConnection()) {
            String url = connection.getMetaData().getURL();
            data.put("dbUrl", url == null ? "unknown" : url.replaceAll("(?i)(password=)[^&]+", "$1***"));
            data.put("dbUser", connection.getMetaData().getUserName());
        } catch (Exception e) {
            data.put("dbUrl", "unavailable");
            data.put("dbUser", "unavailable");
        }

        SysUser admin = sysUserService.getUserByUsername("admin");
        data.put("adminExists", admin != null);
        if (admin != null) {
            data.put("adminStatus", admin.getStatus());
            data.put("adminRoleId", admin.getRoleId());
            data.put("adminPasswordPrefix", admin.getPassword() == null ? null : admin.getPassword().substring(0, Math.min(7, admin.getPassword().length())));
            try {
                sysUserService.login("admin", "123456", "ADMIN", "127.0.0.1");
                data.put("admin123456Matches", true);
            } catch (Exception e) {
                data.put("admin123456Matches", false);
                data.put("loginError", e.getMessage());
            }

            try {
                String token = jwtTokenProvider.generateToken("admin", String.valueOf(admin.getId()));
                data.put("jwtGenerateOk", true);
                data.put("jwtTokenPrefix", token.substring(0, Math.min(20, token.length())));
            } catch (Exception e) {
                data.put("jwtGenerateOk", false);
                data.put("jwtError", e.getMessage());
            }
        }
        return Result.success(data);
    }

    @PostMapping("/admin/reset-password")
    public Result<Boolean> resetAdminPassword() {
        boolean success = sysUserService.resetAdminPassword();
        return Result.success("管理员密码已重置为123456", success);
    }

    @PostMapping("/logout")
    @OperationLog(operationType = "登出", operationModule = "系统认证", operationContent = "退出登录")
    public Result<Boolean> logout() {
        return Result.success("退出成功", true);
    }

    @GetMapping("/user-info")
    public Result<SysUser> userInfo(@RequestParam String username) {
        SysUser user = sysUserService.getUserByUsername(username);
        return Result.success(user);
    }

    @GetMapping("/permissions")
    public Result<List<String>> permissions(@RequestParam String username) {
        SysUser user = sysUserService.getUserByUsername(username);
        List<String> perms = new ArrayList<>();
        if (user != null && user.getRoleId() != null) {
            SysRole role = sysRoleMapper.selectById(user.getRoleId());
            if (role != null) {
                String code = role.getRoleCode();
                if ("ADMIN".equals(code)) {
                    perms.add("dashboard:view");
                    perms.add("relics:manage");
                    perms.add("categories:manage");
                    perms.add("images:manage");
                    perms.add("archives:manage");
                    perms.add("loans:manage");
                    perms.add("maintenance:manage");
                    perms.add("repairs:manage");
                    perms.add("users:manage");
                    perms.add("ai:query");
                } else if ("CURATOR".equals(code)) {
                    perms.add("dashboard:view");
                    perms.add("relics:manage");
                    perms.add("categories:manage");
                    perms.add("images:manage");
                    perms.add("archives:manage");
                    perms.add("maintenance:manage");
                    perms.add("repairs:manage");
                    perms.add("ai:query");
                } else if ("APPROVER".equals(code)) {
                    perms.add("dashboard:view");
                    perms.add("loans:manage");
                    perms.add("maintenance:manage");
                    perms.add("repairs:manage");
                    perms.add("ai:query");
                }
            }
        }
        return Result.success(perms);
    }
    
    /**
     * 发送密码重置验证码（仅支持邮箱）
     */
    @PostMapping("/forgot-password")
    public Result<String> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        try {
            String message = passwordResetService.sendVerificationCode(request);
            
            // 记录操作日志
            try {
                String ipAddress = getIpAddress();
                logService.log(request.getUsername(), "忘记密码", "系统认证", 
                        "发送验证码到邮箱", "成功", ipAddress);
            } catch (Exception e) {
                // 忽略日志记录失败
            }
            
            return Result.success(message);
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("发送验证码失败：" + e.getMessage());
        }
    }
    
    /**
     * 验证验证码
     */
    @PostMapping("/verify-code")
    public Result<Boolean> verifyCode(@RequestParam String username, @RequestParam String code) {
        try {
            boolean valid = passwordResetService.verifyCode(username, code);
            if (valid) {
                return Result.success("验证码正确", true);
            } else {
                return Result.error("验证码无效或已过期");
            }
        } catch (Exception e) {
            return Result.error("验证失败：" + e.getMessage());
        }
    }
    
    /**
     * 重置密码
     */
    @PostMapping("/reset-password")
    public Result<Boolean> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        try {
            boolean success = passwordResetService.resetPassword(request);
            
            // 记录操作日志
            try {
                String ipAddress = getIpAddress();
                logService.log(request.getUsername(), "重置密码", "系统认证", 
                        "密码重置成功", "成功", ipAddress);
            } catch (Exception e) {
                // 忽略日志记录失败
            }
            
            if (success) {
                return Result.success("密码重置成功，请使用新密码登录", true);
            } else {
                return Result.error("密码重置失败");
            }
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            return Result.error("密码重置失败：" + e.getMessage());
        }
    }
    
    private String getIpAddress() {
        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
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
        } catch (Exception e) {
            // 忽略异常
        }
        return "未知";
    }
}
