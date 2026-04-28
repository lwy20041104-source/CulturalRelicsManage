package com.example.service.impl;

import com.example.entity.SysUser;
import com.example.mapper.SysUserMapper;
import com.example.service.LoginSecurityService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * 登录安全服务实现类
 */
@Slf4j
@Service
public class LoginSecurityServiceImpl implements LoginSecurityService {
    
    private final SysUserMapper sysUserMapper;
    
    public LoginSecurityServiceImpl(SysUserMapper sysUserMapper) {
        this.sysUserMapper = sysUserMapper;
    }
    
    @Override
    public boolean isAccountLocked(String username) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return false;
        }
        
        // 检查账户是否被锁定
        if (user.getAccountLocked() != null && user.getAccountLocked() == 1) {
            // 检查是否已过锁定期
            if (user.getLockedTime() != null) {
                LocalDateTime unlockTime = user.getLockedTime().plusMinutes(LOCK_DURATION_MINUTES);
                if (LocalDateTime.now().isAfter(unlockTime)) {
                    // 自动解锁
                    unlockAccount(username);
                    log.info("账户自动解锁：{}", username);
                    return false;
                }
            }
            return true;
        }
        
        return false;
    }
    
    @Override
    @Transactional
    public void recordLoginFailure(String username, String ipAddress) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return;
        }
        
        // 增加失败次数
        int failedCount = (user.getLoginFailedCount() == null ? 0 : user.getLoginFailedCount()) + 1;
        user.setLoginFailedCount(failedCount);
        user.setLastLoginIp(ipAddress);
        
        log.warn("用户 {} 登录失败，失败次数：{}，IP：{}", username, failedCount, ipAddress);
        
        // 如果达到最大失败次数，锁定账户
        if (failedCount >= MAX_FAILED_ATTEMPTS) {
            user.setAccountLocked(1);
            user.setLockedTime(LocalDateTime.now());
            log.error("用户 {} 登录失败次数达到 {} 次，账户已锁定", username, MAX_FAILED_ATTEMPTS);
        }
        
        sysUserMapper.updateById(user);
    }
    
    @Override
    @Transactional
    public void lockAccount(String username) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return;
        }
        
        user.setAccountLocked(1);
        user.setLockedTime(LocalDateTime.now());
        sysUserMapper.updateById(user);
        
        log.warn("账户已锁定：{}", username);
    }
    
    @Override
    @Transactional
    public void resetLoginFailures(String username, String ipAddress) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return;
        }
        
        user.setLoginFailedCount(0);
        user.setAccountLocked(0);
        user.setLockedTime(null);
        user.setLastLoginTime(LocalDateTime.now());
        user.setLastLoginIp(ipAddress);
        
        sysUserMapper.updateById(user);
        
        log.info("用户 {} 登录成功，重置失败次数，IP：{}", username, ipAddress);
    }
    
    @Override
    @Transactional
    public void unlockAccount(String username) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return;
        }
        
        user.setAccountLocked(0);
        user.setLoginFailedCount(0);
        user.setLockedTime(null);
        
        sysUserMapper.updateById(user);
        
        log.info("账户已解锁：{}", username);
    }
    
    @Override
    public int getRemainingAttempts(String username) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return MAX_FAILED_ATTEMPTS;
        }
        
        int failedCount = user.getLoginFailedCount() == null ? 0 : user.getLoginFailedCount();
        return Math.max(0, MAX_FAILED_ATTEMPTS - failedCount);
    }
    
    @Override
    public void checkAndAutoUnlock(String username) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            return;
        }
        
        // 如果账户被锁定且已过锁定期，自动解锁
        if (user.getAccountLocked() != null && user.getAccountLocked() == 1 
            && user.getLockedTime() != null) {
            LocalDateTime unlockTime = user.getLockedTime().plusMinutes(LOCK_DURATION_MINUTES);
            if (LocalDateTime.now().isAfter(unlockTime)) {
                unlockAccount(username);
                log.info("账户自动解锁：{}", username);
            }
        }
    }
}
