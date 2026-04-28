package com.example.service;

import com.example.dto.ForgotPasswordRequest;
import com.example.dto.ResetPasswordRequest;

/**
 * 密码重置服务接口
 */
public interface PasswordResetService {
    
    /**
     * 发送验证码
     * @param request 忘记密码请求
     * @return 成功消息
     */
    String sendVerificationCode(ForgotPasswordRequest request);
    
    /**
     * 验证验证码
     * @param username 用户名
     * @param code 验证码
     * @return 是否有效
     */
    boolean verifyCode(String username, String code);
    
    /**
     * 重置密码
     * @param request 重置密码请求
     * @return 是否成功
     */
    boolean resetPassword(ResetPasswordRequest request);
}
