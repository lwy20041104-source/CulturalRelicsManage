package com.example.dto;

import lombok.Data;

@Data
public class LoginRequest {
    private String username;
    private String password;
    private String roleCode;
    private Long museumId; // 博物馆ID（借展人登录时必填）
}
