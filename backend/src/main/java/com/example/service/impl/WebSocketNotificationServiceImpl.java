package com.example.service.impl;

import com.example.dto.NotificationVO;
import com.example.entity.SysRole;
import com.example.entity.SysUser;
import com.example.mapper.SysRoleMapper;
import com.example.mapper.SysUserMapper;
import com.example.service.WebSocketNotificationService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * WebSocket通知推送服务实现类
 */
@Slf4j
@Service
public class WebSocketNotificationServiceImpl implements WebSocketNotificationService {
    
    private final SimpMessagingTemplate messagingTemplate;
    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    
    public WebSocketNotificationServiceImpl(SimpMessagingTemplate messagingTemplate,
                                           SysUserMapper userMapper,
                                           SysRoleMapper roleMapper) {
        this.messagingTemplate = messagingTemplate;
        this.userMapper = userMapper;
        this.roleMapper = roleMapper;
    }
    
    @Override
    public void sendNotificationToUser(Long userId, NotificationVO notification) {
        try {
            // 向指定用户的私有队列发送消息
            messagingTemplate.convertAndSendToUser(
                userId.toString(),
                "/queue/notifications",
                notification
            );
            log.info("WebSocket通知已发送给用户：userId={}, title={}", userId, notification.getTitle());
        } catch (Exception e) {
            log.error("发送WebSocket通知失败：userId={}, error={}", userId, e.getMessage(), e);
        }
    }
    
    @Override
    public void broadcastNotification(NotificationVO notification) {
        try {
            // 向所有订阅了该主题的用户广播消息
            messagingTemplate.convertAndSend("/topic/notifications", notification);
            log.info("WebSocket通知已广播：title={}", notification.getTitle());
        } catch (Exception e) {
            log.error("广播WebSocket通知失败：error={}", e.getMessage(), e);
        }
    }
    
    @Override
    public void sendNotificationToRole(String roleCode, NotificationVO notification) {
        try {
            // 获取该角色的所有用户
            SysRole role = roleMapper.selectByRoleCode(roleCode);
            if (role == null) {
                log.warn("角色不存在：roleCode={}", roleCode);
                return;
            }
            
            List<SysUser> users = userMapper.selectPage(0, Integer.MAX_VALUE, null, role.getId());
            
            // 向每个用户发送通知
            for (SysUser user : users) {
                if (user.getStatus() == 1) {
                    sendNotificationToUser(user.getId(), notification);
                }
            }
            
            log.info("WebSocket通知已发送给角色：roleCode={}, userCount={}, title={}", 
                    roleCode, users.size(), notification.getTitle());
        } catch (Exception e) {
            log.error("发送角色WebSocket通知失败：roleCode={}, error={}", roleCode, e.getMessage(), e);
        }
    }
}
