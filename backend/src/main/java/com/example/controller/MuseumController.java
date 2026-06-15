package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.Museum;
import com.example.service.MuseumService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/museums")
public class MuseumController {
    
    private final MuseumService museumService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;
    
    public MuseumController(MuseumService museumService,
                           SysOperationLogService operationLogService,
                           UserContextUtil userContextUtil) {
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
                                 HttpServletRequest request) {
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
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "修改", "博物馆管理",
                    "MUSEUM", id, oldMuseum, newMuseum,
                    ipAddress, "PUT", "/museums/" + id
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return success ? Result.success("更新成功") : Result.error("更新失败");
    }
    
    /**
     * 删除博物馆（逻辑删除，将状态改为无合作）
     */
    @DeleteMapping("/{id}")
    public Result<String> delete(@PathVariable Long id,
                                 HttpServletRequest request) {
        // 1. 获取删除前的数据
        Museum oldMuseum = museumService.getById(id);
        if (oldMuseum == null) {
            return Result.error("博物馆不存在");
        }
        
        // 保存修改前的快照（用于审计日志，逻辑删除后会改变 oldMuseum）
        Museum beforeUpdate = new Museum();
        BeanUtils.copyProperties(oldMuseum, beforeUpdate);
        
        // 2. 逻辑删除：将状态改为0（无合作）
        // 必须用完整的 Museum 对象更新，否则全字段 update SQL 会将其他字段清空
        oldMuseum.setStatus(0);
        boolean success = museumService.updateById(oldMuseum);
        
        // 3. 记录审计日志
        if (success) {
            try {
                Museum newMuseum = museumService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "删除", "博物馆管理",
                    "MUSEUM", id, beforeUpdate, newMuseum,
                    ipAddress, "DELETE", "/museums/" + id
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return success ? Result.success("删除成功") : Result.error("删除失败");
    }
}
