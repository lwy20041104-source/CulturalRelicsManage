package com.example.service.impl;

import com.example.dto.ForgotPasswordRequest;
import com.example.dto.ResetPasswordRequest;
import com.example.entity.SysUser;
import com.example.entity.VerificationCode;
import com.example.exception.ServiceException;
import com.example.exception.ValidationException;
import com.example.mapper.SysUserMapper;
import com.example.mapper.VerificationCodeMapper;
import com.example.service.EmailService;
import com.example.service.PasswordResetService;
import com.example.service.SmsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Random;

/**
 * 密码重置服务实现类
 */
@Slf4j
@Service
public class PasswordResetServiceImpl implements PasswordResetService {
    
    private final SysUserMapper sysUserMapper;
    private final VerificationCodeMapper verificationCodeMapper;
    private final EmailService emailService;
    private final SmsService smsService;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    // 验证码有效期（分钟）
    private static final int CODE_EXPIRE_MINUTES = 15;
    
    public PasswordResetServiceImpl(SysUserMapper sysUserMapper, 
                                   VerificationCodeMapper verificationCodeMapper,
                                   EmailService emailService,
                                   SmsService smsService) {
        this.sysUserMapper = sysUserMapper;
        this.verificationCodeMapper = verificationCodeMapper;
        this.emailService = emailService;
        this.smsService = smsService;
    }
    
    @Override
    @Transactional
    public String sendVerificationCode(ForgotPasswordRequest request) {
        // 1. 验证用户是否存在
        SysUser user = sysUserMapper.selectByUsername(request.getUsername());
        if (user == null) {
            throw new ValidationException("用户不存在");
        }
        
        // 2. 验证联系方式是否匹配
        String contact;
        String type;
        
        if ("EMAIL".equals(request.getVerificationType())) {
            if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
                throw new ValidationException("请输入邮箱地址");
            }
            if (user.getEmail() == null || !user.getEmail().equals(request.getEmail())) {
                throw new ValidationException("邮箱地址与账户绑定的邮箱不匹配");
            }
            contact = request.getEmail();
            type = "EMAIL";
        } else if ("PHONE".equals(request.getVerificationType())) {
            if (request.getPhone() == null || request.getPhone().trim().isEmpty()) {
                throw new ValidationException("请输入手机号");
            }
            if (user.getPhone() == null || !user.getPhone().equals(request.getPhone())) {
                throw new ValidationException("手机号与账户绑定的手机号不匹配");
            }
            contact = request.getPhone();
            type = "PHONE";
        } else {
            throw new ValidationException("验证方式不正确");
        }
        
        // 3. 生成6位数字验证码
        String code = generateCode();
        
        // 4. 删除该用户之前的验证码
        verificationCodeMapper.deleteByUsername(request.getUsername(), "RESET_PASSWORD");
        
        // 5. 保存验证码到数据库
        VerificationCode verificationCode = new VerificationCode();
        verificationCode.setUserId(user.getId());
        verificationCode.setUsername(user.getUsername());
        verificationCode.setCode(code);
        verificationCode.setType(type);
        verificationCode.setContact(contact);
        verificationCode.setPurpose("RESET_PASSWORD");
        verificationCode.setUsed(0);
        verificationCode.setExpireTime(LocalDateTime.now().plusMinutes(CODE_EXPIRE_MINUTES));
        verificationCode.setCreateTime(LocalDateTime.now());
        
        verificationCodeMapper.insert(verificationCode);
        
        // 6. 发送验证码
        boolean sendSuccess;
        if ("EMAIL".equals(type)) {
            sendSuccess = emailService.sendVerificationCode(contact, code, CODE_EXPIRE_MINUTES);
            if (sendSuccess) {
                log.info("验证码已发送到邮箱：{}", maskContact(contact, type));
                return "验证码已发送到您的邮箱：" + maskContact(contact, type);
            } else {
                throw new ServiceException("邮件", "邮件发送失败，请稍后重试");
            }
        } else {
            sendSuccess = smsService.sendVerificationCode(contact, code, CODE_EXPIRE_MINUTES);
            if (sendSuccess) {
                log.info("验证码已发送到手机：{}", maskContact(contact, type));
                return "验证码已发送到您的手机：" + maskContact(contact, type);
            } else {
                throw new ServiceException("短信", "短信发送失败，请稍后重试");
            }
        }
    }
    
    @Override
    public boolean verifyCode(String username, String code) {
        VerificationCode verificationCode = verificationCodeMapper.selectValidCode(
            username, code, "RESET_PASSWORD");
        return verificationCode != null;
    }
    
    @Override
    @Transactional
    public boolean resetPassword(ResetPasswordRequest request) {
        // 1. 验证两次密码是否一致
        if (!request.getNewPassword().equals(request.getConfirmPassword())) {
            throw new ValidationException("两次输入的密码不一致");
        }
        
        // 2. 验证验证码
        VerificationCode verificationCode = verificationCodeMapper.selectValidCode(
            request.getUsername(), request.getCode(), "RESET_PASSWORD");
        
        if (verificationCode == null) {
            throw new ValidationException("验证码无效或已过期");
        }
        
        // 3. 获取用户
        SysUser user = sysUserMapper.selectByUsername(request.getUsername());
        if (user == null) {
            throw new ValidationException("用户不存在");
        }
        
        // 4. 更新密码
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        
        // 5. 重置登录安全字段
        user.setLoginFailedCount(0);
        user.setAccountLocked(0);
        user.setLockedTime(null);
        
        int result = sysUserMapper.updateById(user);
        
        // 6. 标记验证码为已使用
        if (result > 0) {
            verificationCodeMapper.markAsUsed(verificationCode.getId());
            log.info("用户 {} 密码重置成功", request.getUsername());
            return true;
        }
        
        return false;
    }
    
    /**
     * 生成6位数字验证码
     */
    private String generateCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }
    
    /**
     * 掩码显示联系方式
     */
    private String maskContact(String contact, String type) {
        if (contact == null || contact.length() < 4) {
            return "***";
        }
        
        if ("EMAIL".equals(type)) {
            // 邮箱：显示前2位和@后面的域名
            int atIndex = contact.indexOf('@');
            if (atIndex > 2) {
                return contact.substring(0, 2) + "***" + contact.substring(atIndex);
            }
        } else if ("PHONE".equals(type)) {
            // 手机号：显示前3位和后4位
            if (contact.length() == 11) {
                return contact.substring(0, 3) + "****" + contact.substring(7);
            }
        }
        
        return contact.substring(0, 2) + "***";
    }
}
