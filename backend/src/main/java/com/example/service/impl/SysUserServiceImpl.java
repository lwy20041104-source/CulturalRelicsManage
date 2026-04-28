package com.example.service.impl;

import com.example.common.PageResult;
import com.example.dto.RegisterRequest;
import com.example.entity.SysRole;
import com.example.entity.SysUser;
import com.example.entity.UserMuseum;
import com.example.exception.BusinessException;
import com.example.exception.ValidationException;
import com.example.mapper.SysRoleMapper;
import com.example.mapper.SysUserMapper;
import com.example.mapper.UserMuseumMapper;
import com.example.mapper.MuseumMapper;
import com.example.service.LoginSecurityService;
import com.example.service.SysUserService;
import com.example.util.PasswordValidator;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
public class SysUserServiceImpl implements SysUserService {

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    private final SysRoleMapper sysRoleMapper;
    private final SysUserMapper sysUserMapper;
    private final UserMuseumMapper userMuseumMapper;
    private final MuseumMapper museumMapper;
    private final LoginSecurityService loginSecurityService;

    public SysUserServiceImpl(SysRoleMapper sysRoleMapper, SysUserMapper sysUserMapper,
                             UserMuseumMapper userMuseumMapper, MuseumMapper museumMapper,
                             LoginSecurityService loginSecurityService) {
        this.sysRoleMapper = sysRoleMapper;
        this.sysUserMapper = sysUserMapper;
        this.userMuseumMapper = userMuseumMapper;
        this.museumMapper = museumMapper;
        this.loginSecurityService = loginSecurityService;
    }

    @Override
    public SysUser getUserByUsername(String username) {
        return sysUserMapper.selectActiveByUsername(username);
    }

    @Override
    public SysUser getUserById(Long id) {
        return sysUserMapper.selectById(id);
    }

    @Override
    public SysUser login(String username, String password, String roleCode, String ipAddress) {
        // 1. 检查账户是否被锁定
        if (loginSecurityService.isAccountLocked(username)) {
            int remainingMinutes = LoginSecurityService.LOCK_DURATION_MINUTES;
            throw new IllegalArgumentException(
                String.format("账户已被锁定，请在 %d 分钟后重试或联系管理员", remainingMinutes)
            );
        }
        
        // 2. 检查用户是否存在
        SysUser user = getUserByUsername(username);
        if (user == null) {
            throw new IllegalArgumentException("用户不存在或已禁用");
        }

        // 3. 验证密码
        if (!passwordEncoder.matches(password, user.getPassword())) {
            // 记录登录失败，传递IP地址
            loginSecurityService.recordLoginFailure(username, ipAddress);
            
            // 获取剩余尝试次数
            int remainingAttempts = loginSecurityService.getRemainingAttempts(username);
            if (remainingAttempts > 0) {
                throw new IllegalArgumentException(
                    String.format("密码错误，还剩 %d 次尝试机会", remainingAttempts)
                );
            } else {
                throw new IllegalArgumentException(
                    String.format("密码错误次数过多，账户已被锁定 %d 分钟", 
                        LoginSecurityService.LOCK_DURATION_MINUTES)
                );
            }
        }

        // 4. 验证角色
        if (roleCode != null && !roleCode.trim().isEmpty()) {
            if (user.getRoleId() == null) {
                throw new IllegalArgumentException("当前账号未分配角色");
            }
            SysRole role = sysRoleMapper.selectById(user.getRoleId());
            if (role == null || !roleCode.equals(role.getRoleCode())) {
                throw new IllegalArgumentException("账号与所选身份不匹配");
            }
        }

        // 5. 登录成功，重置失败次数并记录IP
        loginSecurityService.resetLoginFailures(username, ipAddress);

        return user;
    }

    @Override
    public boolean resetAdminPassword() {
        SysUser admin = sysUserMapper.selectByUsername("admin");
        if (admin == null) {
            throw new IllegalArgumentException("管理员账号不存在");
        }

        admin.setPassword(passwordEncoder.encode("123456"));
        return sysUserMapper.updateById(admin) > 0;
    }

    @Override
    public PageResult<SysUser> pageUsers(Integer pageNum, Integer pageSize, String realName, Long roleId) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        List<SysUser> records = sysUserMapper.selectPage(offset, size, realName, roleId);
        long total = sysUserMapper.count(realName, roleId);
        return new PageResult<>(records, total, current, size);
    }

    @Override
    public List<SysRole> listRoles() {
        return sysRoleMapper.selectEnabledList();
    }

    @Override
    public boolean save(SysUser user) {
        if (user.getRoleId() == null) {
            throw new IllegalArgumentException("请选择角色");
        }
        
        // 验证密码强度
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            PasswordValidator.validate(user.getPassword());
        } else {
            throw new ValidationException("密码不能为空");
        }
        
        user.setStatus(user.getStatus() == null ? 1 : user.getStatus());
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        try {
            return sysUserMapper.insert(user) > 0;
        } catch (DuplicateKeyException e) {
            throw new IllegalArgumentException("用户名已存在");
        }
    }

    @Override
    public boolean updateById(SysUser user) {
        SysUser existing = sysUserMapper.selectById(user.getId());
        if (existing == null || existing.getStatus() == 0) {
            throw new IllegalArgumentException("用户不存在");
        }
        if (user.getRoleId() == null) {
            throw new IllegalArgumentException("请选择角色");
        }
        
        // 如果修改了密码，验证密码强度
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            PasswordValidator.validate(user.getPassword());
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        } else {
            user.setPassword(null);
        }
        
        try {
            return sysUserMapper.updateById(user) > 0;
        } catch (DuplicateKeyException e) {
            throw new IllegalArgumentException("用户名已存在");
        }
    }

    @Override
    public boolean removeById(Long id) {
        SysUser existing = sysUserMapper.selectById(id);
        if (existing == null || existing.getStatus() == 0) {
            throw new IllegalArgumentException("用户不存在");
        }
        if ("admin".equals(existing.getUsername())) {
            throw new IllegalArgumentException("系统管理员账号不能删除");
        }
        String currentUsername = org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication() == null
                ? null
                : org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName();
        if (currentUsername != null && currentUsername.equals(existing.getUsername())) {
            throw new IllegalArgumentException("不能删除当前登录用户");
        }
        SysUser user = new SysUser();
        user.setId(id);
        user.setStatus(0);
        return sysUserMapper.updateById(user) > 0;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Long register(RegisterRequest request) {
        log.info("开始注册借展人：username={}, realName={}, museumId={}", 
                request.getUsername(), request.getRealName(), request.getMuseumId());
        
        // 1. 验证用户名是否已存在
        SysUser existingUser = sysUserMapper.selectByUsername(request.getUsername());
        if (existingUser != null) {
            throw new ValidationException("用户名已存在");
        }
        
        // 2. 验证密码强度
        PasswordValidator.validate(request.getPassword());
        
        // 3. 验证博物馆是否存在且启用
        if (museumMapper.selectById(request.getMuseumId()) == null) {
            throw new ValidationException("所选博物馆不存在");
        }
        
        // 4. 获取借展人角色ID
        SysRole loanerRole = sysRoleMapper.selectByRoleCode("LOANER");
        if (loanerRole == null) {
            throw new BusinessException("借展人角色不存在，请联系管理员");
        }
        
        // 5. 创建用户
        SysUser user = new SysUser();
        user.setUsername(request.getUsername());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setRealName(request.getRealName());
        user.setEmail(request.getEmail());
        user.setPhone(request.getPhone());
        user.setRoleId(loanerRole.getId());
        user.setStatus(1); // 启用状态
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());
        
        try {
            int result = sysUserMapper.insert(user);
            if (result <= 0) {
                throw new BusinessException("用户创建失败");
            }
            log.info("用户创建成功：userId={}", user.getId());
        } catch (DuplicateKeyException e) {
            throw new ValidationException("用户名已存在");
        }
        
        // 6. 创建用户-博物馆关联
        UserMuseum userMuseum = new UserMuseum();
        userMuseum.setUserId(user.getId());
        userMuseum.setMuseumId(request.getMuseumId());
        userMuseum.setIsPrimary(1); // 设置为主博物馆
        userMuseum.setCreateTime(LocalDateTime.now());
        userMuseum.setUpdateTime(LocalDateTime.now());
        
        int relationResult = userMuseumMapper.insert(userMuseum);
        if (relationResult <= 0) {
            throw new BusinessException("用户-博物馆关联创建失败");
        }
        log.info("用户-博物馆关联创建成功：userId={}, museumId={}", user.getId(), request.getMuseumId());
        
        return user.getId();
    }
}
