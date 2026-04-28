package com.example.service;

import com.example.entity.SysUser;

/**
 * 登录安全服务接口
 * 处理登录失败次数限制和账户锁定
 */
public interface LoginSecurityService {
    
    /**
     * 最大登录失败次数
     */
    int MAX_FAILED_ATTEMPTS = 3;
    
    /**
     * 账户锁定时长（分钟）
     */
    int LOCK_DURATION_MINUTES = 30;
    
    /**
     * 检查账户是否被锁定
     * @param username 用户名
     * @return true-已锁定，false-未锁定
     */
    boolean isAccountLocked(String username);
    
    /**
     * 记录登录失败
     * @param username 用户名
     * @param ipAddress IP地址
     */
    void recordLoginFailure(String username, String ipAddress);
    
    /**
     * 锁定账户
     * @param username 用户名
     */
    void lockAccount(String username);
    
    /**
     * 重置登录失败次数
     * @param username 用户名
     * @param ipAddress IP地址
     */
    void resetLoginFailures(String username, String ipAddress);
    
    /**
     * 解锁账户
     * @param username 用户名
     */
    void unlockAccount(String username);
    
    /**
     * 获取剩余登录尝试次数
     * @param username 用户名
     * @return 剩余次数
     */
    int getRemainingAttempts(String username);
    
    /**
     * 检查并自动解锁过期的锁定账户
     * @param username 用户名
     */
    void checkAndAutoUnlock(String username);
}
