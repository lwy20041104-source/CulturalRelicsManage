package com.example.service;

/**
 * 邮件服务接口
 */
public interface EmailService {
    
    /**
     * 发送验证码邮件
     * 
     * @param to 收件人邮箱
     * @param code 验证码
     * @param expireMinutes 有效期（分钟）
     * @return 是否发送成功
     */
    boolean sendVerificationCode(String to, String code, int expireMinutes);
    
    /**
     * 发送简单文本邮件
     * 
     * @param to 收件人邮箱
     * @param subject 邮件主题
     * @param content 邮件内容
     * @return 是否发送成功
     */
    boolean sendSimpleEmail(String to, String subject, String content);
}
