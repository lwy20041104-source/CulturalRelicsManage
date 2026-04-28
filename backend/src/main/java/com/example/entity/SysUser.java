package com.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SysUser {
    private Long id;
    private String username;
    private String password;
    private String realName;
    private String email;
    private String phone;
    private Integer status;
    private Long roleId;
    private String roleName;
    private String roleCode;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 登录安全相关字段
    private Integer loginFailedCount;  // 登录失败次数
    private Integer accountLocked;     // 账户是否锁定：0-未锁定，1-已锁定
    private LocalDateTime lockedTime;  // 账户锁定时间
    private LocalDateTime lastLoginTime;  // 最后登录时间
    private String lastLoginIp;        // 最后登录IP
}
