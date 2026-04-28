package com.example.service;

/**
 * 短信服务接口
 */
public interface SmsService {
    
    /**
     * 发送验证码短信
     * 
     * @param phone 手机号
     * @param code 验证码
     * @param expireMinutes 有效期（分钟）
     * @return 是否发送成功
     */
    boolean sendVerificationCode(String phone, String code, int expireMinutes);
}
