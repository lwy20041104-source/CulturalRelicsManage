package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.SysBackup;
import com.example.entity.SysBackupConfig;
import com.example.entity.SysRestore;
import com.example.service.BackupService;
import com.example.service.SysOperationLogService;
import com.example.task.AutoBackupTask;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * 备份恢复控制器
 */
@Slf4j
@RestController
@RequestMapping("/backup")
public class BackupController {
    
    @Autowired
    private BackupService backupService;
    
    @Autowired
    private SysOperationLogService operationLogService;
    
    @Autowired
    private UserContextUtil userContextUtil;
    
    @Autowired
    private AutoBackupTask autoBackupTask;
    
    /**
     * 分页查询备份列表
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<PageResult<SysBackup>> getBackupList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String backupType,
            @RequestParam(required = false) String backupStatus) {
        try {
            PageResult<SysBackup> result = backupService.getBackupList(pageNum, pageSize, backupType, backupStatus);
            return Result.success(result);
        } catch (Exception e) {
            log.error("查询备份列表失败", e);
            return Result.error("查询备份列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 创建手动备份
     */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN')")
    @OperationLog(operationType = "新增", operationModule = "备份管理", operationContent = "创建手动备份")
    public Result<SysBackup> createBackup(@RequestBody SysBackup backup) {
        try {
            String realName = userContextUtil.getCurrentUserRealName();
            SysBackup result = backupService.createManualBackup(
                backup.getBackupName(),
                backup.getDescription(),
                backup.getIsEncrypted(),
                realName
            );
            return Result.success(result);
        } catch (Exception e) {
            log.error("创建备份失败", e);
            return Result.error("创建备份失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除备份
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public Result<Void> deleteBackup(@PathVariable Long id, HttpServletRequest request) {
        try {
            // 1. 获取删除前的数据
            PageResult<SysBackup> result = backupService.getBackupList(1, 1000, null, null);
            SysBackup oldBackup = result.getRecords().stream()
                .filter(b -> b.getId().equals(id))
                .findFirst()
                .orElse(null);
            
            // 2. 执行删除操作
            backupService.deleteBackup(id);
            
            // 3. 记录审计日志
            if (oldBackup != null) {
                try {
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "删除",
                        "备份管理",
                        "BACKUP",
                        id,
                        oldBackup,
                        null,
                        ipAddress,
                        "DELETE",
                        "/backup/" + id
                    );
                } catch (Exception e) {
                    log.error("记录审计日志失败", e);
                }
            }
            
            return Result.success("删除成功", null);
        } catch (Exception e) {
            log.error("删除备份失败", e);
            return Result.error("删除备份失败: " + e.getMessage());
        }
    }
    
    /**
     * 下载备份文件
     */
    @GetMapping("/{id}/download")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public ResponseEntity<Resource> downloadBackup(@PathVariable Long id) {
        try {
            File file = backupService.downloadBackup(id);
            Resource resource = new FileSystemResource(file);
            
            String filename = URLEncoder.encode(file.getName(), StandardCharsets.UTF_8.toString());
            
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                    .body(resource);
        } catch (Exception e) {
            log.error("下载备份失败", e);
            return ResponseEntity.badRequest().build();
        }
    }
    
    /**
     * 恢复数据库
     */
    @PostMapping("/{id}/restore")
    @PreAuthorize("hasAnyRole('ADMIN')")
    @OperationLog(operationType = "恢复", operationModule = "备份管理", operationContent = "恢复数据库")
    public Result<SysRestore> restoreDatabase(@PathVariable Long id) {
        try {
            String realName = userContextUtil.getCurrentUserRealName();
            SysRestore result = backupService.restoreDatabase(id, realName);
            return Result.success(result);
        } catch (Exception e) {
            log.error("恢复数据库失败", e);
            return Result.error("恢复数据库失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取备份配置
     */
    @GetMapping("/config")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public Result<SysBackupConfig> getBackupConfig() {
        try {
            SysBackupConfig config = backupService.getBackupConfig();
            return Result.success(config);
        } catch (Exception e) {
            log.error("获取备份配置失败", e);
            return Result.error("获取备份配置失败: " + e.getMessage());
        }
    }
    
    /**
     * 更新备份配置
     */
    @PutMapping("/config")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public Result<Void> updateBackupConfig(@RequestBody SysBackupConfig config, HttpServletRequest request) {
        try {
            // 1. 获取修改前的数据
            SysBackupConfig oldConfig = backupService.getBackupConfig();
            
            // 2. 执行更新操作
            backupService.updateBackupConfig(config);
            
            // 3. 记录审计日志
            if (oldConfig != null) {
                try {
                    SysBackupConfig newConfig = backupService.getBackupConfig();
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "修改",
                        "备份管理",
                        "BACKUP_CONFIG",
                        config.getId(),
                        oldConfig,
                        newConfig,
                        ipAddress,
                        "PUT",
                        "/backup/config"
                    );
                } catch (Exception e) {
                    log.error("记录审计日志失败", e);
                }
            }
            
            return Result.success("配置更新成功", null);
        } catch (Exception e) {
            log.error("更新备份配置失败", e);
            return Result.error("更新备份配置失败: " + e.getMessage());
        }
    }
    
    /**
     * 清理过期备份
     */
    @PostMapping("/clean")
    @PreAuthorize("hasAnyRole('ADMIN')")
    @OperationLog(operationType = "删除", operationModule = "备份管理", operationContent = "清理过期备份")
    public Result<Void> cleanExpiredBackups() {
        try {
            backupService.cleanExpiredBackups();
            return Result.success("清理成功", null);
        } catch (Exception e) {
            log.error("清理过期备份失败", e);
            return Result.error("清理过期备份失败: " + e.getMessage());
        }
    }
    
    /**
     * 手动触发自动备份（用于测试）
     */
    @PostMapping("/trigger-auto")
    @PreAuthorize("hasAnyRole('ADMIN')")
    @OperationLog(operationType = "执行", operationModule = "备份管理", operationContent = "手动触发自动备份")
    public Result<Void> triggerAutoBackup() {
        try {
            autoBackupTask.triggerManualAutoBackup();
            return Result.success("自动备份任务已触发", null);
        } catch (Exception e) {
            log.error("触发自动备份失败", e);
            return Result.error("触发自动备份失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取客户端IP地址
     */
    private String getClientIp(HttpServletRequest request) {
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
