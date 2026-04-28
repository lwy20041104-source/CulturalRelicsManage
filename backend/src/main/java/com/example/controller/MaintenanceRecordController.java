package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.MaintenanceRecord;
import com.example.service.MaintenanceRecordService;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/maintenance")
public class MaintenanceRecordController {

    private final MaintenanceRecordService maintenanceRecordService;
    private final com.example.service.SysOperationLogService operationLogService;
    private final com.example.util.UserContextUtil userContextUtil;

    public MaintenanceRecordController(MaintenanceRecordService maintenanceRecordService,
                                      com.example.service.SysOperationLogService operationLogService,
                                      com.example.util.UserContextUtil userContextUtil) {
        this.maintenanceRecordService = maintenanceRecordService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }

    @GetMapping
    public Result<PageResult<MaintenanceRecord>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize
    ) {
        PageResult<MaintenanceRecord> page = maintenanceRecordService.pageRecords(pageNum, pageSize);
        return Result.success(page);
    }

    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "保养管理", operationContent = "新增保养记录")
    public Result<Boolean> save(@RequestBody MaintenanceRecord record) {
        // 验证维护日期
        if (record.getMaintenanceDate() == null) {
            return Result.error("维护日期不能为空");
        }
        
        LocalDateTime now = LocalDateTime.now();
        
        // 维护日期必须是当前时间及以后
        if (record.getMaintenanceDate().isBefore(now)) {
            return Result.error("维护日期必须是当前时间及以后");
        }
        
        record.setCreateTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());
        return Result.success("新增成功", maintenanceRecordService.save(record));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody MaintenanceRecord record,
                                  javax.servlet.http.HttpServletRequest request) {
        // 验证维护日期（修改时也需要验证）
        if (record.getMaintenanceDate() != null) {
            LocalDateTime now = LocalDateTime.now();
            if (record.getMaintenanceDate().isBefore(now)) {
                return Result.error("维护日期必须是当前时间及以后");
            }
        }
        
        // 1. 获取修改前的数据
        MaintenanceRecord oldRecord = maintenanceRecordService.getById(record.getId());
        
        // 2. 执行更新操作
        record.setUpdateTime(LocalDateTime.now());
        boolean success = maintenanceRecordService.updateById(record);
        
        // 3. 记录审计日志
        if (success && oldRecord != null) {
            try {
                MaintenanceRecord newRecord = maintenanceRecordService.getById(record.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "修改", "保养管理",
                    "MAINTENANCE", record.getId(), oldRecord, newRecord,
                    ipAddress, "PUT", "/maintenance"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id,
                                  javax.servlet.http.HttpServletRequest request) {
        // 1. 获取删除前的数据
        MaintenanceRecord oldRecord = maintenanceRecordService.getById(id);
        
        // 2. 执行删除操作
        boolean success = maintenanceRecordService.removeById(id);
        
        // 3. 记录审计日志
        if (success && oldRecord != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "删除", "保养管理",
                    "MAINTENANCE", id, oldRecord, null,
                    ipAddress, "DELETE", "/maintenance/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }
    
    private String getClientIp(javax.servlet.http.HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
}
