package com.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 验证码实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VerificationCode {
    private Long id;
    private Long userId;
    private String username;
    private String code;
    private String type;  // EMAIL, PHONE
    private String contact;  // 邮箱或手机号
    private String purpose;  // RESET_PASSWORD
    private Integer used;  // 0-未使用，1-已使用
    private LocalDateTime expireTime;
    private LocalDateTime createTime;
}
