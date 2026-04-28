package com.example.service.impl;

import com.example.service.EmailService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

/**
 * 邮件服务实现类
 */
@Slf4j
@Service
public class EmailServiceImpl implements EmailService {
    
    @Autowired(required = false)
    private JavaMailSender mailSender;
    
    @Value("${spring.mail.username:}")
    private String from;
    
    @Value("${spring.mail.enabled:false}")
    private boolean mailEnabled;
    
    @Override
    public boolean sendVerificationCode(String to, String code, int expireMinutes) {
        if (!mailEnabled || mailSender == null) {
            log.warn("邮件服务未启用，模拟发送验证码到：{}，验证码：{}", to, code);
            return true;
        }
        
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(from);
            helper.setTo(to);
            helper.setSubject("【文物管理系统】密码重置验证码");
            
            String content = buildVerificationCodeHtml(code, expireMinutes);
            helper.setText(content, true);
            
            mailSender.send(message);
            log.info("验证码邮件发送成功：{}", to);
            return true;
        } catch (MessagingException e) {
            log.error("验证码邮件发送失败：{}", to, e);
            return false;
        }
    }
    
    @Override
    public boolean sendSimpleEmail(String to, String subject, String content) {
        if (!mailEnabled || mailSender == null) {
            log.warn("邮件服务未启用，模拟发送邮件到：{}，主题：{}", to, subject);
            return true;
        }
        
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(from);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(content);
            
            mailSender.send(message);
            log.info("邮件发送成功：{}", to);
            return true;
        } catch (Exception e) {
            log.error("邮件发送失败：{}", to, e);
            return false;
        }
    }
    
    /**
     * 构建验证码邮件HTML内容
     */
    private String buildVerificationCodeHtml(String code, int expireMinutes) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "    <meta charset=\"UTF-8\">" +
                "    <style>" +
                "        body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
                "        .container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                "        .header { background: linear-gradient(135deg, #b58852 0%, #8a5b2f 100%); color: white; padding: 30px; text-align: center; border-radius: 8px 8px 0 0; }" +
                "        .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 8px 8px; }" +
                "        .code-box { background: white; border: 2px dashed #8a5b2f; padding: 20px; margin: 20px 0; text-align: center; border-radius: 8px; }" +
                "        .code { font-size: 32px; font-weight: bold; color: #8a5b2f; letter-spacing: 5px; }" +
                "        .tips { color: #666; font-size: 14px; margin-top: 20px; }" +
                "        .footer { text-align: center; color: #999; font-size: 12px; margin-top: 20px; }" +
                "    </style>" +
                "</head>" +
                "<body>" +
                "    <div class=\"container\">" +
                "        <div class=\"header\">" +
                "            <h1>🏛️ 文物管理系统</h1>" +
                "            <p>密码重置验证码</p>" +
                "        </div>" +
                "        <div class=\"content\">" +
                "            <p>您好，</p>" +
                "            <p>您正在进行密码重置操作，您的验证码是：</p>" +
                "            <div class=\"code-box\">" +
                "                <div class=\"code\">" + code + "</div>" +
                "            </div>" +
                "            <div class=\"tips\">" +
                "                <p>⏰ 验证码有效期为 <strong>" + expireMinutes + " 分钟</strong></p>" +
                "                <p>🔒 请勿将验证码告知他人</p>" +
                "                <p>❓ 如果这不是您的操作，请忽略此邮件</p>" +
                "            </div>" +
                "        </div>" +
                "        <div class=\"footer\">" +
                "            <p>此邮件由系统自动发送，请勿回复</p>" +
                "            <p>© 2026 文物管理系统</p>" +
                "        </div>" +
                "    </div>" +
                "</body>" +
                "</html>";
    }
}
