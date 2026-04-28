package com.example.util;

import com.example.exception.ValidationException;

import java.util.regex.Pattern;

/**
 * 密码强度验证工具类
 */
public class PasswordValidator {
    
    // 密码必须包含数字和字母，长度6-20位
    private static final Pattern PASSWORD_PATTERN = Pattern.compile("^(?=.*[0-9])(?=.*[a-zA-Z]).{6,20}$");
    
    /**
     * 验证密码强度
     * 
     * @param password 密码
     * @throws ValidationException 如果密码不符合要求
     */
    public static void validate(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new ValidationException("密码不能为空");
        }
        
        String trimmedPassword = password.trim();
        
        // 检查长度
        if (trimmedPassword.length() < 6) {
            throw new ValidationException("密码长度不能少于6位");
        }
        
        if (trimmedPassword.length() > 20) {
            throw new ValidationException("密码长度不能超过20位");
        }
        
        // 检查是否包含数字
        if (!trimmedPassword.matches(".*[0-9].*")) {
            throw new ValidationException("密码必须包含数字");
        }
        
        // 检查是否包含字母
        if (!trimmedPassword.matches(".*[a-zA-Z].*")) {
            throw new ValidationException("密码必须包含字母");
        }
        
        // 使用正则表达式进行完整验证
        if (!PASSWORD_PATTERN.matcher(trimmedPassword).matches()) {
            throw new ValidationException("密码必须是6-20位字符，且包含数字和字母");
        }
    }
    
    /**
     * 检查密码是否符合要求（不抛出异常）
     * 
     * @param password 密码
     * @return true 如果密码符合要求，否则 false
     */
    public static boolean isValid(String password) {
        if (password == null || password.trim().isEmpty()) {
            return false;
        }
        
        String trimmedPassword = password.trim();
        return PASSWORD_PATTERN.matcher(trimmedPassword).matches();
    }
    
    /**
     * 获取密码强度描述
     * 
     * @param password 密码
     * @return 密码强度描述
     */
    public static String getStrengthDescription(String password) {
        if (password == null || password.trim().isEmpty()) {
            return "密码为空";
        }
        
        String trimmedPassword = password.trim();
        
        if (trimmedPassword.length() < 6) {
            return "密码太短（至少6位）";
        }
        
        if (trimmedPassword.length() > 20) {
            return "密码太长（最多20位）";
        }
        
        boolean hasDigit = trimmedPassword.matches(".*[0-9].*");
        boolean hasLetter = trimmedPassword.matches(".*[a-zA-Z].*");
        boolean hasLowerCase = trimmedPassword.matches(".*[a-z].*");
        boolean hasUpperCase = trimmedPassword.matches(".*[A-Z].*");
        boolean hasSpecialChar = trimmedPassword.matches(".*[^a-zA-Z0-9].*");
        
        if (!hasDigit) {
            return "密码必须包含数字";
        }
        
        if (!hasLetter) {
            return "密码必须包含字母";
        }
        
        // 计算强度
        int strength = 0;
        if (hasDigit) strength++;
        if (hasLowerCase) strength++;
        if (hasUpperCase) strength++;
        if (hasSpecialChar) strength++;
        if (trimmedPassword.length() >= 10) strength++;
        
        if (strength >= 4) {
            return "强";
        } else if (strength >= 3) {
            return "中";
        } else {
            return "弱";
        }
    }
}
