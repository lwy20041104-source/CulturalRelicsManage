package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.MaintenanceRecord;
import com.example.service.MaintenanceRecordService;
import com.example.service.NotificationService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Slf4j
@RestController
@RequestMapping("/maintenance")
public class MaintenanceRecordController {

    private final MaintenanceRecordService maintenanceRecordService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;
    private final NotificationService notificationService;

    public MaintenanceRecordController(MaintenanceRecordService maintenanceRecordService,
                                      SysOperationLogService operationLogService,
                                      UserContextUtil userContextUtil,
                                      NotificationService notificationService) {
        this.maintenanceRecordService = maintenanceRecordService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
        this.notificationService = notificationService;
    }

    @GetMapping
    public Result<PageResult<MaintenanceRecord>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String relicName,
            org.springframework.security.core.Authentication authentication
    ) {
        // 获取当前用户权限，判断是否需要过滤维护人
        Long maintainerIdFilter = null;
        if (authentication != null) {
            java.util.Collection<? extends org.springframework.security.core.GrantedAuthority> authorities = 
                authentication.getAuthorities();
            
            // 打印所有权限信息用于调试
            log.debug("=== 维护记录查询权限检查 ===");
            log.debug("用户名: {}", authentication.getName());
            log.debug("权限列表: {}", authorities);
            authorities.forEach(a -> log.debug("  - {}", a.getAuthority()));
            
            // 检查是否是管理员或审批员角色（ADMIN和APPROVER可以查看所有记录）
            boolean isAdminOrApprover = authorities.stream()
                .anyMatch(a -> {
                    String authority = a.getAuthority();
                    boolean match = authority.equals("ROLE_ADMIN") || authority.equals("ROLE_APPROVER");
                    log.debug("检查权限: {} -> {}", authority, match);
                    return match;
                });
            
            log.debug("是否是管理员或审批员: {}", isAdminOrApprover);
            
            // 如果不是管理员或审批员（即CURATOR等角色），只查询自己的维护记录
            if (!isAdminOrApprover) {
                try {
                    maintainerIdFilter = userContextUtil.getCurrentUserId();
                    log.debug("保管员权限过滤：只显示维护人ID={}的记录", maintainerIdFilter);
                } catch (Exception e) {
                    log.error("获取当前用户ID失败: {}", e.getMessage());
                }
            } else {
                log.debug("管理员/审批员权限：显示所有维护记录");
            }
            log.debug("=== 权限检查完成 ===");
        } else {
            log.debug("警告: authentication 为 null");
        }
        
        PageResult<MaintenanceRecord> page = maintenanceRecordService.pageRecords(
                pageNum, pageSize, maintainerIdFilter, status, null, relicName);
        return Result.success(page);
    }

    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "保养管理", operationContent = "提交维护申请")
    public Result<Boolean> save(@RequestBody MaintenanceRecord record,
                                Authentication authentication) {
        // 验证维护日期
        if (record.getMaintenanceDate() == null) {
            return Result.error("维护日期不能为空");
        }

        LocalDate today = LocalDate.now();
        
        // 维护日期必须是今天或今天之后
        if (record.getMaintenanceDate().toLocalDate().isBefore(today)) {
            return Result.error("维护日期必须是今天或今天之后");
        }
        
        // 设置维护人ID为当前用户
        try {
            Long currentUserId = userContextUtil.getCurrentUserId();
            record.setMaintainerId(currentUserId);
        } catch (Exception e) {
            log.error("获取当前用户ID失败: {}", e.getMessage());
            return Result.error("获取用户信息失败");
        }
        
        // 设置初始状态为待审批
        record.setStatus("待审批");
        record.setCreateTime(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());
        // maintainer字段为NOT NULL，填充空字符串避免数据库约束错误
        if (record.getMaintainerName() == null || record.getMaintainerName().isEmpty()) {
            record.setMaintainerName("");
        }
        
        boolean success = maintenanceRecordService.save(record);
        
        // 发送维护申请通知
        if (success) {
            try {
                String relicName = record.getRelicName() != null ? record.getRelicName() : "未知文物";
                Long senderId = userContextUtil.getCurrentUserId();
                
                notificationService.sendMaintenanceApplyNotification(
                    record.getId(),
                    relicName,
                    record.getMaintenanceType(),
                    senderId
                );
                log.info("维护申请通知已发送：maintenanceId={}, relic={}", record.getId(), relicName);
            } catch (Exception e) {
                log.error("发送维护申请通知失败: {}", e.getMessage(), e);
            }
        }
        
        return Result.success("维护申请已提交", success);
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody MaintenanceRecord record,
                                  HttpServletRequest request,
                                  Authentication authentication) {
        // 1. 获取修改前的数据
        MaintenanceRecord oldRecord = maintenanceRecordService.getById(record.getId());
        
        if (oldRecord == null) {
            return Result.error("维护记录不存在");
        }
        
        // 2. 权限检查：只能修改自己的申请（管理员和审批员不能修改他人申请）
        if (authentication != null) {
            java.util.Collection<? extends GrantedAuthority> authorities =
                authentication.getAuthorities();
            
            // 检查是否是管理员或审批员角色
            boolean isAdminOrApprover = authorities.stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN") || a.getAuthority().equals("ROLE_APPROVER"));
            
            // 管理员和审批员也不能修改他人的申请，只能审批
            // 所有人都只能修改自己的记录
            try {
                Long currentUserId = userContextUtil.getCurrentUserId();
                if (oldRecord.getMaintainerId() == null || !oldRecord.getMaintainerId().equals(currentUserId)) {
                    return Result.error("无权修改此申请");
                }
            } catch (Exception e) {
                log.error("权限检查失败: {}", e.getMessage());
                return Result.error("权限验证失败");
            }
        }
        
        // 3. 状态检查：只能修改待审批的申请
        if (!"待审批".equals(oldRecord.getStatus())) {
            return Result.error("只能修改待审批状态的申请");
        }
        
        // 4. 验证维护日期（修改时也需要验证）
        if (record.getMaintenanceDate() != null) {
            LocalDateTime now = LocalDateTime.now();
            if (record.getMaintenanceDate().isBefore(now)) {
                return Result.error("维护日期必须是当前时间及以后");
            }
        }
        
        // 5. 执行更新操作
        record.setUpdateTime(LocalDateTime.now());
        boolean success = maintenanceRecordService.updateById(record);
        
        // 6. 记录审计日志
        if (success && oldRecord != null) {
            try {
                MaintenanceRecord newRecord = maintenanceRecordService.getById(record.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "修改", "保养管理",
                    "MAINTENANCE", record.getId(), oldRecord, newRecord,
                    ipAddress, "PUT", "/maintenance"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id,
                                  HttpServletRequest request,
                                  Authentication authentication) {
        // 1. 获取删除前的数据
        MaintenanceRecord oldRecord = maintenanceRecordService.getById(id);
        
        if (oldRecord == null) {
            return Result.error("维护记录不存在");
        }
        
        // 2. 权限检查：只能删除自己的记录（管理员和审批员不能删除他人记录）
        if (authentication != null) {
            java.util.Collection<? extends GrantedAuthority> authorities =
                authentication.getAuthorities();
            
            // 所有人都只能删除自己的记录
            try {
                Long currentUserId = userContextUtil.getCurrentUserId();
                if (oldRecord.getMaintainerId() == null || !oldRecord.getMaintainerId().equals(currentUserId)) {
                    return Result.error("无权删除此记录");
                }
            } catch (Exception e) {
                log.error("权限检查失败: {}", e.getMessage());
                return Result.error("权限验证失败");
            }
        }
        
        // 3. 执行删除操作
        boolean success = maintenanceRecordService.removeById(id);
        
        // 4. 发送撤回通知（仅当状态为待审批时）
        if (success && "待审批".equals(oldRecord.getStatus())) {
            try {
                Long currentUserId = userContextUtil.getCurrentUserId();
                String relicName = oldRecord.getRelicName() != null ? oldRecord.getRelicName() : "未知文物";
                
                notificationService.sendMaintenanceWithdrawNotification(
                    id,
                    relicName,
                    oldRecord.getMaintenanceType(),
                    currentUserId
                );
                log.info("维护申请撤回通知已发送：maintenanceId={}, relic={}", id, relicName);
            } catch (Exception e) {
                log.error("发送维护申请撤回通知失败: {}", e.getMessage(), e);
            }
        }
        
        // 5. 记录审计日志
        if (success && oldRecord != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "删除", "保养管理",
                    "MAINTENANCE", id, oldRecord, null,
                    ipAddress, "DELETE", "/maintenance/" + id
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }
    
    /**
     * 审批维护申请
     */
    @PutMapping("/approve")
    public Result<Boolean> approve(@RequestBody MaintenanceRecord record,
                                   Authentication authentication,
                                   HttpServletRequest request) {
        // 1. 获取审批前的数据
        MaintenanceRecord oldRecord = maintenanceRecordService.getById(record.getId());
        
        if (oldRecord == null) {
            return Result.error("维护记录不存在");
        }
        
        // 2. 状态检查：只能审批待审批的申请
        if (!"待审批".equals(oldRecord.getStatus())) {
            return Result.error("只能审批待审批状态的申请");
        }
        
        // 3. 设置审批信息
        String approver = authentication != null ? authentication.getName() : "system";
        record.setApprover(approver);
        record.setApproveDate(LocalDateTime.now());
        record.setUpdateTime(LocalDateTime.now());
        
        // 4. 执行审批操作
        boolean success = maintenanceRecordService.updateById(record);
        
        // 5. 发送审批结果通知
        if (success && oldRecord.getMaintainerId() != null) {
            try {
                String relicName = oldRecord.getRelicName() != null ? oldRecord.getRelicName() : "未知文物";
                boolean approved = "已通过".equals(record.getStatus());
                String approverRealName = userContextUtil.getCurrentUserRealName();
                
                Long approverId = userContextUtil.getCurrentUserId();
                notificationService.sendMaintenanceApprovalNotification(
                    record.getId(),
                    oldRecord.getMaintainerId(),
                    relicName,
                    approved,
                    approverRealName,
                    approverId
                );
                log.info("维护审批通知已发送：maintenanceId={}, maintainerId={}, approved={}, approverId={}",
                        record.getId(), oldRecord.getMaintainerId(), approved, approverId);
            } catch (Exception e) {
                log.error("发送审批通知失败: {}", e.getMessage(), e);
            }
        }
        
        // 6. 记录审计日志
        if (success && oldRecord != null) {
            try {
                MaintenanceRecord newRecord = maintenanceRecordService.getById(record.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "审批", "保养管理",
                    "MAINTENANCE", record.getId(), oldRecord, newRecord,
                    ipAddress, "PUT", "/maintenance/approve"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        String message = "已通过".equals(record.getStatus()) ? "审批通过" : "审批拒绝";
        return Result.success(message, success);
    }
}
