package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.dto.RepairApplyRequest;
import com.example.dto.RepairApproveRequest;
import com.example.dto.RepairProgressRequest;
import com.example.entity.RepairRecord;
import com.example.service.RepairRecordService;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 文物修复记录控制器
 */
@RestController
@RequestMapping("/repairs")
public class RepairRecordController {
    
    private final RepairRecordService repairRecordService;
    private final com.example.service.SysOperationLogService operationLogService;
    private final com.example.util.UserContextUtil userContextUtil;
    private final com.example.service.NotificationService notificationService;
    
    public RepairRecordController(RepairRecordService repairRecordService,
                                 com.example.service.SysOperationLogService operationLogService,
                                 com.example.util.UserContextUtil userContextUtil,
                                 com.example.service.NotificationService notificationService) {
        this.repairRecordService = repairRecordService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
        this.notificationService = notificationService;
    }
    
    /**
     * 分页查询修复记录
     */
    @GetMapping
    public Result<PageResult<RepairRecord>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String priority,
            @RequestParam(required = false) String relicName,
            @RequestParam(required = false) String repairExpert,
            Authentication authentication) {
        
        System.out.println("========== 修复记录查询请求 ==========");
        System.out.println("请求参数: pageNum=" + pageNum + ", pageSize=" + pageSize);
        System.out.println("过滤条件: status=[" + status + "], priority=[" + priority + 
                         "], relicName=[" + relicName + "], repairExpert=[" + repairExpert + "]");
        
        // 获取当前用户权限，判断是否需要过滤申请人
        Long applicantIdFilter = null;
        if (authentication != null) {
            String username = authentication.getName();
            System.out.println("当前用户: " + username);
            
            java.util.Collection<? extends org.springframework.security.core.GrantedAuthority> authorities = 
                authentication.getAuthorities();
            
            System.out.println("用户权限: " + authorities.stream()
                .map(a -> a.getAuthority())
                .collect(java.util.stream.Collectors.joining(", ")));
            
            // 检查是否是管理员角色（ADMIN可以查看所有记录）
            boolean isAdmin = authorities.stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            
            System.out.println("是否是管理员: " + isAdmin);
            
            // 如果不是管理员（即CURATOR等角色），只查询自己申请的
            if (!isAdmin) {
                try {
                    applicantIdFilter = userContextUtil.getCurrentUserId();
                    System.out.println("保管员权限过滤：只显示申请人ID=" + applicantIdFilter + "的记录");
                } catch (Exception e) {
                    System.err.println("获取当前用户ID失败: " + e.getMessage());
                }
            } else {
                System.out.println("管理员权限：显示所有记录");
            }
        }
        
        PageResult<RepairRecord> result = repairRecordService.pageRecords(
                pageNum, pageSize, status, priority, relicName, repairExpert, applicantIdFilter);
        
        System.out.println("查询结果: total=" + result.getTotal() + ", records.size=" + result.getRecords().size());
        if (result.getRecords().size() > 0) {
            System.out.println("记录状态分布: " + result.getRecords().stream()
                .map(RepairRecord::getStatus)
                .collect(java.util.stream.Collectors.groupingBy(s -> s, java.util.stream.Collectors.counting())));
        }
        System.out.println("========================================");
        
        return Result.success(result);
    }
    
    /**
     * 根据ID查询修复记录详情
     */
    @GetMapping("/{id}")
    public Result<RepairRecord> getById(@PathVariable Long id, Authentication authentication) {
        RepairRecord record = repairRecordService.getById(id);
        if (record == null) {
            return Result.error("修复记录不存在");
        }
        
        // 权限检查：保管员只能查看自己的记录
        if (authentication != null) {
            java.util.Collection<? extends org.springframework.security.core.GrantedAuthority> authorities = 
                authentication.getAuthorities();
            
            // 检查是否是管理员角色
            boolean isAdmin = authorities.stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            
            // 如果不是管理员，检查是否是自己的记录
            if (!isAdmin) {
                try {
                    Long currentUserId = userContextUtil.getCurrentUserId();
                    if (record.getApplicantId() == null || !record.getApplicantId().equals(currentUserId)) {
                        return Result.error("无权查看此记录");
                    }
                } catch (Exception e) {
                    System.err.println("权限检查失败: " + e.getMessage());
                    return Result.error("权限验证失败");
                }
            }
        }
        
        return Result.success(record);
    }
    
    /**
     * 根据文物ID查询修复记录列表
     */
    @GetMapping("/relic/{relicId}")
    public Result<List<RepairRecord>> listByRelicId(@PathVariable Long relicId) {
        List<RepairRecord> records = repairRecordService.listByRelicId(relicId);
        return Result.success(records);
    }
    
    /**
     * 提交修复申请
     */
    @PostMapping("/apply")
    @OperationLog(operationType = "新增", operationModule = "文物修复", operationContent = "提交修复申请")
    public Result<Boolean> applyRepair(@RequestBody RepairApplyRequest request,
                                       Authentication authentication) {
        // 验证文物是否有正在进行的修复
        if (request.getRelicId() == null) {
            return Result.error("请选择文物");
        }
        
        List<RepairRecord> existingRepairs = repairRecordService.listByRelicId(request.getRelicId());
        for (RepairRecord repair : existingRepairs) {
            String status = repair.getStatus();
            if ("待审批".equals(status) || "待修复".equals(status) || "修复中".equals(status)) {
                return Result.error("该文物已有正在进行的修复申请（状态：" + status + "），不能重复申请");
            }
        }
        
        String applicant = authentication != null ? authentication.getName() : "system";
        boolean success = repairRecordService.applyRepair(request, applicant);
        return Result.success("修复申请已提交", success);
    }
    
    /**
     * 更新修复申请（仅限待审批状态）
     */
    @PutMapping("/apply/{id}")
    @OperationLog(operationType = "修改", operationModule = "文物修复", operationContent = "更新修复申请")
    public Result<Boolean> updateRepairApply(@PathVariable Long id,
                                             @RequestBody RepairApplyRequest request,
                                             Authentication authentication,
                                             javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取原记录
        RepairRecord oldRecord = repairRecordService.getById(id);
        if (oldRecord == null) {
            return Result.error("修复记录不存在");
        }
        
        // 2. 权限检查：只能修改自己的申请
        if (authentication != null) {
            try {
                Long currentUserId = userContextUtil.getCurrentUserId();
                if (oldRecord.getApplicantId() == null || !oldRecord.getApplicantId().equals(currentUserId)) {
                    return Result.error("无权修改此申请");
                }
            } catch (Exception e) {
                System.err.println("权限检查失败: " + e.getMessage());
                return Result.error("权限验证失败");
            }
        }
        
        // 3. 状态检查：只能修改待审批的申请
        if (!"待审批".equals(oldRecord.getStatus())) {
            return Result.error("只能修改待审批状态的申请");
        }
        
        // 4. 验证文物是否有其他正在进行的修复（排除当前记录）
        if (request.getRelicId() != null && !request.getRelicId().equals(oldRecord.getRelicId())) {
            List<RepairRecord> existingRepairs = repairRecordService.listByRelicId(request.getRelicId());
            for (RepairRecord repair : existingRepairs) {
                if (!repair.getId().equals(id)) {
                    String status = repair.getStatus();
                    if ("待审批".equals(status) || "待修复".equals(status) || "修复中".equals(status)) {
                        return Result.error("该文物已有正在进行的修复申请（状态：" + status + "），不能修改为此文物");
                    }
                }
            }
        }
        
        // 5. 执行更新操作
        request.setId(id);
        boolean success = repairRecordService.updateRepairApply(request);
        
        // 6. 发送更新通知
        if (success) {
            try {
                RepairRecord updatedRecord = repairRecordService.getById(id);
                Long currentUserId = userContextUtil.getCurrentUserId();
                
                notificationService.sendRepairUpdateNotification(
                    id,
                    updatedRecord.getRelicName() != null ? updatedRecord.getRelicName() : "未知文物",
                    updatedRecord.getRepairReason(),
                    currentUserId
                );
                System.out.println("修复申请更新通知已发送：repairId=" + id + ", relic=" + updatedRecord.getRelicName());
            } catch (Exception e) {
                System.err.println("发送修复申请更新通知失败: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // 7. 记录审计日志
        if (success) {
            try {
                RepairRecord newRecord = repairRecordService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "修改",
                    "文物修复",
                    "REPAIR",
                    id,
                    oldRecord,
                    newRecord,
                    ipAddress,
                    "PUT",
                    "/repairs/apply/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("修复申请已更新", success);
    }
    
    /**
     * 审批修复申请
     */
    @PutMapping("/approve")
    public Result<Boolean> approveRepair(@RequestBody RepairApproveRequest request,
                                         Authentication authentication,
                                         javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取审批前的数据
        RepairRecord oldRecord = repairRecordService.getById(request.getId());
        
        // 2. 执行审批操作
        String approver = authentication != null ? authentication.getName() : "system";
        boolean success = repairRecordService.approveRepair(request, approver);
        
        // 3. 记录审计日志
        if (success && oldRecord != null) {
            try {
                RepairRecord newRecord = repairRecordService.getById(request.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "审批",
                    "文物修复",
                    "REPAIR",
                    request.getId(),
                    oldRecord,
                    newRecord,
                    ipAddress,
                    "PUT",
                    "/repairs/approve"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        // 4. 发送通知给申请人
        if (success && oldRecord != null && oldRecord.getApplicantId() != null) {
            try {
                RepairRecord record = repairRecordService.getById(request.getId());
                notificationService.sendRepairApprovalNotification(
                    record.getId(),
                    record.getApplicantId(),
                    record.getRelicName(),
                    Boolean.TRUE.equals(request.getApproved()),
                    approver
                );
                System.out.println("修复审批通知已发送：repairId=" + record.getId() + 
                                 ", applicantId=" + record.getApplicantId() + 
                                 ", approved=" + request.getApproved());
            } catch (Exception e) {
                System.err.println("发送审批通知失败: " + e.getMessage());
            }
        }
        
        String message = Boolean.TRUE.equals(request.getApproved()) ? "审批通过" : "审批拒绝";
        return Result.success(message, success);
    }
    
    /**
     * 开始修复
     */
    @PutMapping("/{id}/start")
    public Result<Boolean> startRepair(@PathVariable Long id,
                                       javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取开始前的数据
        RepairRecord oldRecord = repairRecordService.getById(id);
        
        // 2. 执行开始修复操作
        boolean success = repairRecordService.startRepair(id);
        
        // 3. 记录审计日志
        if (success && oldRecord != null) {
            try {
                RepairRecord newRecord = repairRecordService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "开始修复",
                    "文物修复",
                    "REPAIR",
                    id,
                    oldRecord,
                    newRecord,
                    ipAddress,
                    "PUT",
                    "/repairs/" + id + "/start"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("已开始修复", success);
    }
    
    /**
     * 更新修复进度
     */
    @PutMapping("/progress")
    public Result<Boolean> updateProgress(@RequestBody RepairProgressRequest request,
                                          javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取更新前的数据
        RepairRecord oldRecord = repairRecordService.getById(request.getId());
        
        // 2. 执行更新操作
        boolean success = repairRecordService.updateProgress(request);
        
        // 3. 记录审计日志
        if (success && oldRecord != null) {
            try {
                RepairRecord newRecord = repairRecordService.getById(request.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "更新进度",
                    "文物修复",
                    "REPAIR",
                    request.getId(),
                    oldRecord,
                    newRecord,
                    ipAddress,
                    "PUT",
                    "/repairs/progress"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("修复进度已更新", success);
    }
    
    /**
     * 完成修复
     */
    @PutMapping("/{id}/complete")
    public Result<Boolean> completeRepair(@PathVariable Long id,
                                          @RequestBody(required = false) RepairProgressRequest request,
                                          javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取完成前的数据
        RepairRecord oldRecord = repairRecordService.getById(id);
        
        // 2. 执行完成修复操作
        boolean success = repairRecordService.completeRepair(id, request);
        
        // 3. 记录审计日志
        if (success && oldRecord != null) {
            try {
                RepairRecord newRecord = repairRecordService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "完成修复",
                    "文物修复",
                    "REPAIR",
                    id,
                    oldRecord,
                    newRecord,
                    ipAddress,
                    "PUT",
                    "/repairs/" + id + "/complete"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        // 4. 发送通知给申请人
        if (success && oldRecord != null && oldRecord.getApplicantId() != null) {
            try {
                RepairRecord record = repairRecordService.getById(id);
                Integer qualityScore = request != null ? request.getQualityScore() : null;
                notificationService.sendRepairCompletionNotification(
                    record.getId(),
                    record.getApplicantId(),
                    record.getRelicName(),
                    qualityScore
                );
                System.out.println("修复完成通知已发送：repairId=" + record.getId() + 
                                 ", applicantId=" + record.getApplicantId() + 
                                 ", qualityScore=" + qualityScore);
            } catch (Exception e) {
                System.err.println("发送完成通知失败: " + e.getMessage());
            }
        }
        
        return Result.success("修复已完成", success);
    }
    
    /**
     * 删除修复记录
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> deleteById(@PathVariable Long id,
                                      Authentication authentication,
                                      javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取删除前的数据
        RepairRecord oldRecord = repairRecordService.getById(id);
        
        if (oldRecord == null) {
            return Result.error("修复记录不存在");
        }
        
        // 权限检查：保管员只能删除自己的记录
        if (authentication != null) {
            java.util.Collection<? extends org.springframework.security.core.GrantedAuthority> authorities = 
                authentication.getAuthorities();
            
            // 检查是否是管理员角色
            boolean isAdmin = authorities.stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
            
            // 如果不是管理员，检查是否是自己的记录
            if (!isAdmin) {
                try {
                    Long currentUserId = userContextUtil.getCurrentUserId();
                    if (oldRecord.getApplicantId() == null || !oldRecord.getApplicantId().equals(currentUserId)) {
                        return Result.error("无权删除此记录");
                    }
                } catch (Exception e) {
                    System.err.println("权限检查失败: " + e.getMessage());
                    return Result.error("权限验证失败");
                }
            }
        }
        
        // 2. 执行删除操作
        boolean success = repairRecordService.deleteById(id);
        
        // 3. 发送撤回通知（仅当状态为待审批时）
        if (success && "待审批".equals(oldRecord.getStatus())) {
            try {
                Long currentUserId = userContextUtil.getCurrentUserId();
                
                notificationService.sendRepairWithdrawNotification(
                    id,
                    oldRecord.getRelicName() != null ? oldRecord.getRelicName() : "未知文物",
                    oldRecord.getRepairReason(),
                    currentUserId
                );
                System.out.println("修复申请撤回通知已发送：repairId=" + id + ", relic=" + oldRecord.getRelicName());
            } catch (Exception e) {
                System.err.println("发送修复申请撤回通知失败: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        // 4. 记录审计日志
        if (success && oldRecord != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除",
                    "文物修复",
                    "REPAIR",
                    id,
                    oldRecord,
                    null,
                    ipAddress,
                    "DELETE",
                    "/repairs/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }
    
    /**
     * 统计各状态数量
     */
    @GetMapping("/statistics/status")
    public Result<Map<String, Long>> countByStatus() {
        Map<String, Long> result = repairRecordService.countByStatus();
        return Result.success(result);
    }
    
    /**
     * 获取客户端IP地址
     */
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
