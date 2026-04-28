package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.dto.NotificationVO;
import com.example.service.NotificationService;
import com.example.util.SecurityUtils;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 通知控制器
 */
@RestController
@RequestMapping("/notifications")
public class NotificationController {
    
    private final NotificationService notificationService;
    private final SecurityUtils securityUtils;
    
    public NotificationController(NotificationService notificationService, SecurityUtils securityUtils) {
        this.notificationService = notificationService;
        this.securityUtils = securityUtils;
    }
    
    /**
     * 获取当前用户的通知列表（分页）
     */
    @GetMapping("/list")
    public Result<PageResult<NotificationVO>> getNotifications(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) Boolean isRead,
            @RequestParam(required = false) String keyword,
            Authentication authentication) {
        
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("用户未登录");
        }
        
        PageResult<NotificationVO> result = notificationService.getUserNotifications(userId, pageNum, pageSize, isRead, keyword);
        return Result.success(result);
    }
    
    /**
     * 获取通知统计信息
     */
    @GetMapping("/statistics")
    public Result<java.util.Map<String, Object>> getStatistics(
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {
        
        java.time.LocalDateTime start = startDate != null ? 
            java.time.LocalDateTime.parse(startDate + "T00:00:00") : 
            java.time.LocalDateTime.now().minusDays(30);
        
        java.time.LocalDateTime end = endDate != null ? 
            java.time.LocalDateTime.parse(endDate + "T23:59:59") : 
            java.time.LocalDateTime.now();
        
        java.util.Map<String, Object> statistics = notificationService.getNotificationStatistics(start, end);
        return Result.success(statistics);
    }
    
    /**
     * 获取未读通知数量
     */
    @GetMapping("/unread-count")
    public Result<Integer> getUnreadCount(Authentication authentication) {
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("用户未登录");
        }
        
        int count = notificationService.getUnreadCount(userId);
        return Result.success(count);
    }
    
    /**
     * 标记通知为已读
     */
    @PutMapping("/{id}/read")
    @OperationLog(operationType = "修改", operationModule = "消息通知", operationContent = "标记通知为已读")
    public Result<Boolean> markAsRead(@PathVariable Long id, Authentication authentication) {
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("用户未登录");
        }
        
        boolean success = notificationService.markAsRead(id, userId);
        return success ? Result.success(true) : Result.error("标记失败");
    }
    
    /**
     * 批量标记为已读
     */
    @PutMapping("/read-all")
    @OperationLog(operationType = "修改", operationModule = "消息通知", operationContent = "批量标记通知为已读")
    public Result<Boolean> markAllAsRead(@RequestBody List<Long> notificationIds, Authentication authentication) {
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("用户未登录");
        }
        
        boolean success = notificationService.markAllAsRead(notificationIds, userId);
        return success ? Result.success(true) : Result.error("批量标记失败");
    }
    
    /**
     * 删除通知
     */
    @DeleteMapping("/{id}")
    @OperationLog(operationType = "删除", operationModule = "消息通知", operationContent = "删除通知")
    public Result<Boolean> deleteNotification(@PathVariable Long id, Authentication authentication) {
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("用户未登录");
        }
        
        boolean success = notificationService.deleteNotification(id, userId);
        return success ? Result.success(true) : Result.error("删除失败");
    }
}
