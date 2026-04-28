package com.example.service;

import com.example.dto.NotificationVO;

/**
 * WebSocket通知推送服务接口
 */
public interface WebSocketNotificationService {
    
    /**
     * 向指定用户推送通知
     * @param userId 用户ID
     * @param notification 通知内容
     */
    void sendNotificationToUser(Long userId, NotificationVO notification);
    
    /**
     * 向所有在线用户推送通知
     * @param notification 通知内容
     */
    void broadcastNotification(NotificationVO notification);
    
    /**
     * 向指定角色的用户推送通知
     * @param roleCode 角色代码
     * @param notification 通知内容
     */
    void sendNotificationToRole(String roleCode, NotificationVO notification);
}
