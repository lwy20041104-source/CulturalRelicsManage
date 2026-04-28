package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SysOperationLog {
    private Long id;
    private Long userId;
    private String operator;
    private String operationType;
    private String operationModule;
    private String operationContent;
    private String operationResult;
    private String ipAddress;
    
    // 新增字段：资源信息
    private String resourceType;
    private Long resourceId;
    
    // 新增字段：数据对比
    private String beforeData;
    private String afterData;
    private String changedFields;
    
    // 新增字段：请求信息
    private String requestMethod;
    private String requestUrl;
    private String requestParams;
    private String responseData;
    private String errorMessage;
    private Long executionTime;
    
    // 新增字段：客户端信息
    private String userAgent;
    private String browser;
    private String os;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime operationTime;
}

