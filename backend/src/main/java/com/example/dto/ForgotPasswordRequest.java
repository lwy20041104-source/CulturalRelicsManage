package com.example.dto;

import lombok.Data;

import javax.validation.constraints.NotBlank;

/**
 * 忘记密码请求
 */
@Data
public class ForgotPasswordRequest {
    
    @NotBlank(message = "用户名不能为空")
    private String username;
    
    @NotBlank(message = "验证方式不能为空")
    private String verificationType;  // EMAIL 或 PHONE
    
    private String email;  // 邮箱（当verificationType=EMAIL时必填）
    
    private String phone;  // 手机号（当verificationType=PHONE时必填）
}
