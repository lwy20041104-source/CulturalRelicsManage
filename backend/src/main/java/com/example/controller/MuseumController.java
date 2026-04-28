package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.Museum;
import com.example.service.MuseumService;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/museums")
public class MuseumController {
    
    private final MuseumService museumService;
    private final com.example.service.SysOperationLogService operationLogService;
    private final com.example.util.UserContextUtil userContextUtil;
    
    public MuseumController(MuseumService museumService,
                           com.example.service.SysOperationLogService operationLogService,
                           com.example.util.UserContextUtil userContextUtil) {
        this.museumService = museumService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }
    
    /**
     * 分页查询博物馆列表
     */
    @GetMapping
    public Result<PageResult<Museum>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String museumName,
            @RequestParam(required = false) String city,
            @RequestParam(required = false) Integer status
    ) {
        PageResult<Museum> pageResult = museumService.pageMuseums(pageNum, pageSize, museumName, city, status);
        return Result.success(pageResult);
    }
    
    /**
     * 获取所有启用的博物馆列表（用于下拉选择）
     */
    @GetMapping("/active")
    public Result<List<Museum>> listActive() {
        List<Museum> museums = museumService.listAllActive();
        return Result.success(museums);
    }
    
    /**
     * 根据ID获取博物馆详情
     */
    @GetMapping("/{id}")
    public Result<Museum> getById(@PathVariable Long id) {
        Museum museum = museumService.getById(id);
        if (museum == null) {
            return Result.error("博物馆不存在");
        }
        return Result.success(museum);
    }
    
    /**
     * 新增博物馆
     */
    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "博物馆管理", operationContent = "新增博物馆")
    public Result<String> add(@RequestBody Museum museum) {
        // 检查编码是否已存在
        if (museumService.getByCode(museum.getMuseumCode()) != null) {
            return Result.error("博物馆编码已存在");
        }
        
        // 检查名称是否已存在
        if (museumService.getByName(museum.getMuseumName()) != null) {
            return Result.error("博物馆名称已存在");
        }
        
        if (museum.getStatus() == null) {
            museum.setStatus(1); // 默认有合作
        }
        
        boolean success = museumService.save(museum);
        return success ? Result.success("新增成功") : Result.error("新增失败");
    }
    
    /**
     * 更新博物馆信息
     */
    @PutMapping("/{id}")
    public Result<String> update(@PathVariable Long id, @RequestBody Museum museum,
                                 javax.servlet.http.HttpServletRequest request) {
        // 1. 获取修改前的数据
        Museum oldMuseum = museumService.getById(id);
        
        // 2. 执行更新操作
        museum.setId(id);
        boolean success = museumService.updateById(museum);
        
        // 3. 记录审计日志
        if (success && oldMuseum != null) {
            try {
                Museum newMuseum = museumService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "修改", "博物馆管理",
                    "MUSEUM", id, oldMuseum, newMuseum,
                    ipAddress, "PUT", "/museums/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return success ? Result.success("更新成功") : Result.error("更新失败");
    }
    
    /**
     * 删除博物馆（逻辑删除，将状态改为无合作）
     */
    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id,
                                 javax.servlet.http.HttpServletRequest request) {
        // 1. 获取删除前的数据
        Museum oldMuseum = museumService.getById(id);
        if (oldMuseum == null) {
            return Result.error("博物馆不存在");
        }
        
        // 2. 逻辑删除：将状态改为0（无合作）
        Museum museum = new Museum();
        museum.setId(id);
        museum.setStatus(0);
        boolean success = museumService.updateById(museum);
        
        // 3. 记录审计日志
        if (success) {
            try {
                Museum newMuseum = museumService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "删除", "博物馆管理",
                    "MUSEUM", id, oldMuseum, newMuseum,
                    ipAddress, "DELETE", "/museums/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return success ? Result.success("删除成功") : Result.error("删除失败");
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
