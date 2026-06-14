package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.SysRole;
import com.example.entity.SysUser;
import com.example.entity.UserMuseum;
import com.example.mapper.UserMuseumMapper;
import com.example.service.LoginSecurityService;
import com.example.service.SysOperationLogService;
import com.example.service.SysUserService;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/users")
public class SysUserController {

    private final SysUserService sysUserService;
    private final UserMuseumMapper userMuseumMapper;
    private final LoginSecurityService loginSecurityService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;

    public SysUserController(SysUserService sysUserService, UserMuseumMapper userMuseumMapper,
                            LoginSecurityService loginSecurityService,
                            SysOperationLogService operationLogService,
                            UserContextUtil userContextUtil) {
        this.sysUserService = sysUserService;
        this.userMuseumMapper = userMuseumMapper;
        this.loginSecurityService = loginSecurityService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }

    @GetMapping
    public Result<PageResult<SysUser>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String realName,
            @RequestParam(required = false) Long roleId
    ) {
        return Result.success(sysUserService.pageUsers(pageNum, pageSize, realName, roleId));
    }

    @GetMapping("/roles")
    public Result<List<SysRole>> roles() {
        return Result.success(sysUserService.listRoles());
    }

    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "用户管理", operationContent = "新增用户")
    @Transactional
    public Result<Boolean> save(@RequestBody Map<String, Object> requestData) {
        log.info("=== 新增用户请求数据 ===");
        log.info("requestData: {}", requestData);
        log.info("museumId: {}", requestData.get("museumId"));
        
        // 提取用户信息
        SysUser user = new SysUser();
        user.setUsername((String) requestData.get("username"));
        user.setPassword((String) requestData.get("password"));
        user.setRealName((String) requestData.get("realName"));
        user.setEmail((String) requestData.get("email"));
        user.setPhone((String) requestData.get("phone"));
        user.setRoleId(requestData.get("roleId") != null ? Long.valueOf(requestData.get("roleId").toString()) : null);
        user.setStatus(requestData.get("status") != null ? Integer.valueOf(requestData.get("status").toString()) : 1);
        
        if (user.getPassword() == null || user.getPassword().trim().isEmpty()) {
            throw new IllegalArgumentException("请输入密码");
        }
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        
        boolean success = sysUserService.save(user);
        log.info("用户保存结果: {}, 用户ID: {}", success, user.getId());
        
        // 如果是借展人角色且提供了博物馆ID，创建关联
        if (success && requestData.get("museumId") != null) {
            Long museumId = Long.valueOf(requestData.get("museumId").toString());
            log.info("创建用户博物馆关联: userId={}, museumId={}", user.getId(), museumId);
            
            UserMuseum userMuseum = new UserMuseum();
            userMuseum.setUserId(user.getId());
            userMuseum.setMuseumId(museumId);
            userMuseum.setIsPrimary(1);
            int insertResult = userMuseumMapper.insert(userMuseum);
            log.info("博物馆关联插入结果: {}", insertResult);
        } else {
            log.info("未创建博物馆关联 - success: {}, museumId: {}", success, requestData.get("museumId"));
        }
        
        return Result.success("新增成功", success);
    }

    @PutMapping
    @Transactional
    public Result<Boolean> update(@RequestBody Map<String, Object> requestData,
                                  HttpServletRequest httpRequest) {
        Long userId = requestData.get("id") != null ? Long.valueOf(requestData.get("id").toString()) : null;
        
        // 1. 获取修改前的数据
        SysUser oldUser = userId != null ? sysUserService.getUserById(userId) : null;
        
        // 2. 执行更新操作
        SysUser user = new SysUser();
        user.setId(userId);
        user.setUsername((String) requestData.get("username"));
        user.setRealName((String) requestData.get("realName"));
        user.setEmail((String) requestData.get("email"));
        user.setPhone((String) requestData.get("phone"));
        user.setRoleId(requestData.get("roleId") != null ? Long.valueOf(requestData.get("roleId").toString()) : null);
        user.setStatus(requestData.get("status") != null ? Integer.valueOf(requestData.get("status").toString()) : 1);
        user.setAccountLocked(requestData.get("accountLocked") != null ? Integer.valueOf(requestData.get("accountLocked").toString()) : null);
        user.setUpdateTime(LocalDateTime.now());
        
        boolean success = sysUserService.updateById(user);
        
        // 如果提供了博物馆ID，更新关联
        if (success && requestData.get("museumId") != null) {
            Long museumId = Long.valueOf(requestData.get("museumId").toString());
            // 先删除旧关联
            userMuseumMapper.deleteByUserId(user.getId());
            // 创建新关联
            UserMuseum userMuseum = new UserMuseum();
            userMuseum.setUserId(user.getId());
            userMuseum.setMuseumId(museumId);
            userMuseum.setIsPrimary(1);
            userMuseumMapper.insert(userMuseum);
        }
        
        // 3. 记录审计日志
        if (success && oldUser != null) {
            try {
                SysUser newUser = sysUserService.getUserById(userId);
                String realName = userContextUtil.getCurrentUserRealName();
                Long operatorId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    operatorId,
                    realName,
                    "修改",
                    "用户管理",
                    "USER",
                    userId,
                    oldUser,
                    newUser,
                    ipAddress,
                    "PUT",
                    "/users"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id, HttpServletRequest httpRequest) {
        // 1. 获取删除前的数据
        SysUser oldUser = sysUserService.getUserById(id);
        
        // 2. 执行删除操作
        boolean success = sysUserService.removeById(id);
        
        // 3. 记录审计日志
        if (success && oldUser != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除",
                    "用户管理",
                    "USER",
                    id,
                    oldUser,
                    null,
                    ipAddress,
                    "DELETE",
                    "/users/" + id
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }
    
    /**
     * 获取用户关联的博物馆
     */
    @GetMapping("/{userId}/museum")
    public Result<UserMuseum> getUserMuseum(@PathVariable Long userId) {
        UserMuseum userMuseum = userMuseumMapper.selectPrimaryWithMuseumNameByUserId(userId);
        return Result.success(userMuseum);
    }
    
    /**
     * 解锁用户账户（通过用户ID）
     */
    @PostMapping("/{userId}/unlock")
    @OperationLog(operationType = "解锁", operationModule = "用户管理", operationContent = "解锁用户账户")
    public Result<Boolean> unlockAccount(@PathVariable Long userId) {
        try {
            SysUser user = sysUserService.getUserById(userId);
            if (user == null) {
                return Result.error("用户不存在");
            }
            loginSecurityService.unlockAccount(user.getUsername());
            // 同步更新用户的 account_locked 状态
            SysUser updateUser = new SysUser();
            updateUser.setId(user.getId());
            updateUser.setAccountLocked(0);
            sysUserService.updateById(updateUser);
            return Result.success("账户解锁成功", true);
        } catch (Exception e) {
            return Result.error("解锁失败：" + e.getMessage());
        }
    }
    
    /**
     * 获取当前登录用户的个人信息
     */
    @GetMapping("/profile")
    public Result<Map<String, Object>> getProfile(Authentication authentication) {
        if (authentication == null || authentication.getName() == null) {
            return Result.error("用户未登录");
        }
        
        String username = authentication.getName();
        SysUser user = sysUserService.getUserByUsername(username);
        
        if (user == null) {
            return Result.error("用户不存在");
        }
        
        // 构建返回数据
        Map<String, Object> profile = new HashMap<>();
        profile.put("id", user.getId());
        profile.put("username", user.getUsername());
        profile.put("realName", user.getRealName());
        profile.put("email", user.getEmail());
        profile.put("phone", user.getPhone());
        profile.put("status", user.getStatus());
        profile.put("roleId", user.getRoleId());
        profile.put("roleName", user.getRoleName());
        profile.put("roleCode", user.getRoleCode());
        profile.put("createTime", user.getCreateTime());
        profile.put("updateTime", user.getUpdateTime());
        
        // 如果是借展人，获取关联的博物馆
        if ("LOANER".equals(user.getRoleCode())) {
            UserMuseum userMuseum = userMuseumMapper.selectPrimaryWithMuseumNameByUserId(user.getId());
            if (userMuseum != null) {
                profile.put("museumId", userMuseum.getMuseumId());
                profile.put("museumName", userMuseum.getMuseumName());
            }
        }
        
        return Result.success(profile);
    }
    
    /**
     * 更新当前登录用户的个人信息
     */
    @PutMapping("/profile")
    @Transactional
    public Result<Boolean> updateProfile(@RequestBody Map<String, Object> requestData, 
                                        Authentication authentication,
                                        HttpServletRequest httpRequest) {
        if (authentication == null || authentication.getName() == null) {
            return Result.error("用户未登录");
        }
        
        String currentUsername = authentication.getName();
        SysUser currentUser = sysUserService.getUserByUsername(currentUsername);
        
        if (currentUser == null) {
            return Result.error("用户不存在");
        }
        
        // 1. 保存修改前的数据
        SysUser oldUser = sysUserService.getUserById(currentUser.getId());
        
        // 2. 构建更新对象
        SysUser user = new SysUser();
        user.setId(currentUser.getId());
        
        // 检查用户名是否修改
        String newUsername = (String) requestData.get("username");
        if (newUsername != null && !newUsername.equals(currentUsername)) {
            // 检查新用户名是否已存在
            SysUser existingUser = sysUserService.getUserByUsername(newUsername);
            if (existingUser != null && !existingUser.getId().equals(currentUser.getId())) {
                return Result.error("用户名已存在");
            }
            user.setUsername(newUsername);
        }
        
        // 更新其他字段（不包括角色和真实姓名）
        user.setEmail((String) requestData.get("email"));
        user.setPhone((String) requestData.get("phone"));
        
        // 如果提供了密码，则更新密码
        String password = (String) requestData.get("password");
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        }
        
        user.setUpdateTime(LocalDateTime.now());
        
        boolean success = sysUserService.updateById(user);
        
        // 如果是借展人且提供了博物馆ID，更新关联
        if (success && "LOANER".equals(currentUser.getRoleCode()) && requestData.get("museumId") != null) {
            Long museumId = Long.valueOf(requestData.get("museumId").toString());
            // 先删除旧关联
            userMuseumMapper.deleteByUserId(user.getId());
            // 创建新关联
            UserMuseum userMuseum = new UserMuseum();
            userMuseum.setUserId(user.getId());
            userMuseum.setMuseumId(museumId);
            userMuseum.setIsPrimary(1);
            userMuseum.setCreateTime(LocalDateTime.now());
            userMuseum.setUpdateTime(LocalDateTime.now());
            userMuseumMapper.insert(userMuseum);
        }
        
        // 3. 记录审计日志
        if (success && oldUser != null) {
            try {
                SysUser newUser = sysUserService.getUserById(currentUser.getId());
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    currentUser.getId(),
                    currentUsername,
                    "修改",
                    "个人信息",
                    "USER",
                    currentUser.getId(),
                    oldUser,
                    newUser,
                    ipAddress,
                    "PUT",
                    "/users/profile"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
    return Result.success("个人信息更新成功", success);
    }
    
    /**
     * 通过用户名解锁账户
     */
    @PostMapping("/unlock-by-username")
    @OperationLog(operationType = "解锁", operationModule = "用户管理", operationContent = "解锁用户账户")
    public Result<Boolean> unlockAccountByUsername(@RequestParam String username) {
        try {
            loginSecurityService.unlockAccount(username);
            return Result.success("账户解锁成功", true);
        } catch (Exception e) {
            return Result.error("解锁失败：" + e.getMessage());
        }
    }
}
