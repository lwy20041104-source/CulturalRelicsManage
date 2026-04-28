package com.example.service.impl;

import com.example.common.PageResult;
import com.example.dto.DataChangeDTO;
import com.example.entity.DataChangeDetail;
import com.example.entity.SysOperationLog;
import com.example.mapper.SysOperationLogMapper;
import com.example.service.SysOperationLogService;
import com.example.util.AuditLogUtil;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class SysOperationLogServiceImpl implements SysOperationLogService {
    
    private final SysOperationLogMapper logMapper;
    private final com.example.mapper.DataChangeDetailMapper detailMapper;
    
    public SysOperationLogServiceImpl(SysOperationLogMapper logMapper,
                                     com.example.mapper.DataChangeDetailMapper detailMapper) {
        this.logMapper = logMapper;
        this.detailMapper = detailMapper;
    }
    
    @Override
    public PageResult<SysOperationLog> getPage(String operator, String operationType, String operationModule, int pageNum, int pageSize) {
        int offset = (pageNum - 1) * pageSize;
        List<SysOperationLog> records = logMapper.selectPage(operator, operationType, operationModule, offset, pageSize);
        long total = logMapper.countPage(operator, operationType, operationModule);
        
        PageResult<SysOperationLog> result = new PageResult<>();
        result.setRecords(records);
        result.setTotal(total);
        result.setCurrent(pageNum);
        result.setSize(pageSize);
        return result;
    }
    
    @Override
    public SysOperationLog getById(Long id) {
        return logMapper.selectById(id);
    }
    
    @Override
    public void log(String operator, String operationType, String operationModule, String operationContent, String operationResult, String ipAddress) {
        SysOperationLog log = new SysOperationLog();
        log.setOperator(operator);
        log.setOperationType(operationType);
        log.setOperationModule(operationModule);
        log.setOperationContent(operationContent);
        log.setOperationResult(operationResult);
        log.setIpAddress(ipAddress);
        log.setOperationTime(LocalDateTime.now());
        logMapper.insert(log);
    }
    
    @Override
    public void logEnhanced(SysOperationLog log) {
        if (log.getOperationTime() == null) {
            log.setOperationTime(LocalDateTime.now());
        }
        logMapper.insertEnhanced(log);
    }
    
    @Override
    public void logDataChange(Long userId, String operator, String operationType, String operationModule,
                              String resourceType, Long resourceId, Object beforeData, Object afterData,
                              String ipAddress, String requestMethod, String requestUrl) {
        try {
            System.out.println("========== 开始记录审计日志 ==========");
            System.out.println("userId: " + userId);
            System.out.println("operator: " + operator);
            System.out.println("operationType: " + operationType);
            System.out.println("operationModule: " + operationModule);
            System.out.println("resourceType: " + resourceType);
            System.out.println("resourceId: " + resourceId);
            
            SysOperationLog log = new SysOperationLog();
            log.setUserId(userId);
            log.setOperator(operator);
            log.setOperationType(operationType);
            log.setOperationModule(operationModule);
            log.setResourceType(resourceType);
            log.setResourceId(resourceId);
            log.setIpAddress(ipAddress);
            log.setRequestMethod(requestMethod);
            log.setRequestUrl(requestUrl);
            log.setOperationTime(LocalDateTime.now());
            log.setOperationResult("成功");
            
            // 转换为JSON
            String beforeJson = AuditLogUtil.toJson(beforeData);
            String afterJson = AuditLogUtil.toJson(afterData);
            log.setBeforeData(beforeJson);
            log.setAfterData(afterJson);
            
            System.out.println("beforeData length: " + (beforeJson != null ? beforeJson.length() : 0));
            System.out.println("afterData length: " + (afterJson != null ? afterJson.length() : 0));
            
            // 比较差异
            Map<String, String> fieldLabels = getFieldLabels(resourceType);
            List<DataChangeDTO> changes = AuditLogUtil.compareObjects(beforeData, afterData, fieldLabels);
            String changedFieldsJson = AuditLogUtil.changesToJson(changes);
            log.setChangedFields(changedFieldsJson);
            
            System.out.println("changedFields: " + changedFieldsJson);
            
            // 生成操作内容
            String operationContent = String.format("%s%s（ID:%d）", operationType, operationModule, resourceId);
            log.setOperationContent(operationContent);
            
            System.out.println("operationContent: " + operationContent);
            System.out.println("准备插入数据库...");
            
            int result = logMapper.insertEnhanced(log);
            
            System.out.println("插入结果: " + result);
            System.out.println("生成的日志ID: " + log.getId());
            System.out.println("========== 审计日志记录完成 ==========");
        } catch (Exception e) {
            System.err.println("========== 审计日志记录失败 ==========");
            System.err.println("错误信息: " + e.getMessage());
            e.printStackTrace();
            System.err.println("========================================");
        }
    }
    
    @Override
    public List<SysOperationLog> getResourceHistory(String resourceType, Long resourceId) {
        return logMapper.getResourceHistory(resourceType, resourceId);
    }
    
    @Override
    public List<DataChangeDetail> getChangeDetails(Long logId) {
        return detailMapper.selectByLogId(logId);
    }
    
    @Override
    public List<Object> getUserOperationStatistics(int days) {
        // 返回用户操作统计
        List<Map<String, Object>> stats = logMapper.getUserOperationStatistics(null, days);
        return new ArrayList<>(stats);
    }
    
    @Override
    public List<Object> getOperationTypeStatistics(int days) {
        // 返回操作类型统计
        List<Map<String, Object>> stats = logMapper.getOperationStatistics(days);
        return new ArrayList<>(stats);
    }
    
    @Override
    public int cleanOldLogs(int days) {
        return logMapper.cleanOldLogs(days);
    }
    
    /**
     * 根据资源类型获取字段标签映射
     */
    private Map<String, String> getFieldLabels(String resourceType) {
        if ("RELIC".equals(resourceType)) {
            return AuditLogUtil.createRelicFieldLabels();
        } else if ("LOAN".equals(resourceType)) {
            return AuditLogUtil.createLoanFieldLabels();
        } else if ("REPAIR".equals(resourceType)) {
            return AuditLogUtil.createRepairFieldLabels();
        }
        return new java.util.HashMap<>();
    }
}

