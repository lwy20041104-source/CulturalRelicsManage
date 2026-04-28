package com.example.service;

import com.example.common.PageResult;
import com.example.dto.DataChangeDTO;
import com.example.entity.DataChangeDetail;
import com.example.entity.SysOperationLog;

import java.util.List;

public interface SysOperationLogService {
    PageResult<SysOperationLog> getPage(String operator, String operationType, String operationModule, int pageNum, int pageSize);
    
    SysOperationLog getById(Long id);
    
    void log(String operator, String operationType, String operationModule, String operationContent, String operationResult, String ipAddress);
    
    /**
     * 记录增强的操作日志（包含数据对比）
     */
    void logEnhanced(SysOperationLog log);
    
    /**
     * 记录数据变更（自动对比前后数据）
     */
    void logDataChange(Long userId, String operator, String operationType, String operationModule,
                      String resourceType, Long resourceId, Object beforeData, Object afterData,
                      String ipAddress, String requestMethod, String requestUrl);
    
    /**
     * 获取资源的操作历史
     */
    List<SysOperationLog> getResourceHistory(String resourceType, Long resourceId);
    
    /**
     * 获取日志的变更详情
     */
    List<DataChangeDetail> getChangeDetails(Long logId);
    
    /**
     * 获取用户操作统计
     */
    List<Object> getUserOperationStatistics(int days);
    
    /**
     * 获取操作类型统计
     */
    List<Object> getOperationTypeStatistics(int days);
    
    /**
     * 清理旧日志
     */
    int cleanOldLogs(int days);
}

