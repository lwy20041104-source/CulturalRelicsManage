package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.RepairExpert;
import com.example.service.RepairExpertService;
import com.example.service.SysOperationLogService;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 修复专家控制器
 */
@RestController
@RequestMapping("/repair-experts")
public class RepairExpertController {
    
    private final RepairExpertService repairExpertService;
    private final SysOperationLogService operationLogService;
    private final com.example.util.UserContextUtil userContextUtil;
    
    public RepairExpertController(RepairExpertService repairExpertService,
                                 SysOperationLogService operationLogService,
                                 com.example.util.UserContextUtil userContextUtil) {
        this.repairExpertService = repairExpertService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }
    
    /**
     * 查询所有启用的专家（用于下拉选择）
     */
    @GetMapping("/enabled")
    public Result<List<RepairExpert>> listEnabled() {
        List<RepairExpert> experts = repairExpertService.listEnabled();
        return Result.success(experts);
    }
    
    /**
     * 分页查询专家
     */
    @GetMapping
    public Result<PageResult<RepairExpert>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String expertName,
            @RequestParam(required = false) String specialty) {
        PageResult<RepairExpert> result = repairExpertService.pageExperts(
                pageNum, pageSize, expertName, specialty);
        return Result.success(result);
    }
    
    /**
     * 根据ID查询专家详情
     */
    @GetMapping("/{id}")
    public Result<RepairExpert> getById(@PathVariable Long id) {
        RepairExpert expert = repairExpertService.getById(id);
        if (expert == null) {
            return Result.error("专家不存在");
        }
        return Result.success(expert);
    }
    
    /**
     * 新增专家
     */
    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "专家管理", operationContent = "新增修复专家")
    public Result<Boolean> save(@RequestBody RepairExpert expert) {
        boolean success = repairExpertService.save(expert);
        return Result.success("新增成功", success);
    }
    
    /**
     * 更新专家
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody RepairExpert expert, HttpServletRequest request) {
        // 1. 获取修改前的数据
        RepairExpert oldExpert = repairExpertService.getById(expert.getId());
        
        // 2. 执行更新操作
        boolean success = repairExpertService.updateById(expert);
        
        // 3. 记录审计日志
        if (success && oldExpert != null) {
            try {
                RepairExpert newExpert = repairExpertService.getById(expert.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "修改",
                    "专家管理",
                    "EXPERT",
                    expert.getId(),
                    oldExpert,
                    newExpert,
                    ipAddress,
                    "PUT",
                    "/repair-experts"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }
    
    /**
     * 删除专家
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> deleteById(@PathVariable Long id, HttpServletRequest request) {
        // 1. 获取删除前的数据
        RepairExpert oldExpert = repairExpertService.getById(id);
        
        // 2. 执行删除操作
        boolean success = repairExpertService.deleteById(id);
        
        // 3. 记录审计日志
        if (success && oldExpert != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除",
                    "专家管理",
                    "EXPERT",
                    id,
                    oldExpert,
                    null,
                    ipAddress,
                    "DELETE",
                    "/repair-experts/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
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
