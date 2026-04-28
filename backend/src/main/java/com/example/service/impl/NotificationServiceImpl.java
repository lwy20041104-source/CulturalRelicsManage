package com.example.service.impl;

import com.example.common.PageResult;
import com.example.dto.NotificationVO;
import com.example.entity.NotificationConfig;
import com.example.entity.SystemNotification;
import com.example.entity.SysRole;
import com.example.entity.SysUser;
import com.example.entity.UserNotification;
import com.example.mapper.NotificationConfigMapper;
import com.example.mapper.SystemNotificationMapper;
import com.example.mapper.SysRoleMapper;
import com.example.mapper.SysUserMapper;
import com.example.mapper.UserNotificationMapper;
import com.example.service.NotificationService;
import com.example.service.WebSocketNotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 通知服务实现类
 */
@Service
public class NotificationServiceImpl implements NotificationService {
    
    private static final Logger log = LoggerFactory.getLogger(NotificationServiceImpl.class);
    
    private final SystemNotificationMapper notificationMapper;
    private final UserNotificationMapper userNotificationMapper;
    private final NotificationConfigMapper configMapper;
    private final SysUserMapper userMapper;
    private final SysRoleMapper roleMapper;
    private final WebSocketNotificationService webSocketNotificationService;
    
    public NotificationServiceImpl(SystemNotificationMapper notificationMapper,
                                   UserNotificationMapper userNotificationMapper,
                                   NotificationConfigMapper configMapper,
                                   SysUserMapper userMapper,
                                   SysRoleMapper roleMapper,
                                   WebSocketNotificationService webSocketNotificationService) {
        this.notificationMapper = notificationMapper;
        this.userNotificationMapper = userNotificationMapper;
        this.configMapper = configMapper;
        this.userMapper = userMapper;
        this.roleMapper = roleMapper;
        this.webSocketNotificationService = webSocketNotificationService;
    }
    
    @Override
    @Transactional
    public boolean createAndSendNotification(SystemNotification notification, List<String> roleCodes) {
        try {
            log.info("开始创建并发送通知：type={}, title={}, roleCodes={}", 
                    notification.getType(), notification.getTitle(), roleCodes);
            
            // 1. 保存通知
            notification.setCreateTime(LocalDateTime.now());
            notificationMapper.insert(notification);
            log.info("通知已保存到数据库：notificationId={}", notification.getId());
            
            // 2. 获取目标用户列表
            List<Long> targetUserIds = getUserIdsByRoleCodes(roleCodes, notification.getType());
            
            if (targetUserIds.isEmpty()) {
                log.warn("没有找到符合条件的用户，通知类型：{}，角色：{}", notification.getType(), roleCodes);
                return true;
            }
            
            log.info("准备为 {} 个用户创建通知关联", targetUserIds.size());
            
            // 3. 为每个用户创建通知关联
            for (Long userId : targetUserIds) {
                UserNotification userNotification = new UserNotification();
                userNotification.setNotificationId(notification.getId());
                userNotification.setUserId(userId);
                userNotification.setIsRead(0);
                userNotification.setCreateTime(LocalDateTime.now());
                userNotificationMapper.insert(userNotification);
                log.info("用户通知关联已创建：userId={}, notificationId={}", userId, notification.getId());
                
                // 通过WebSocket实时推送通知
                try {
                    NotificationVO vo = convertToVO(notification);
                    webSocketNotificationService.sendNotificationToUser(userId, vo);
                    log.info("WebSocket通知已推送：userId={}, title={}", userId, notification.getTitle());
                } catch (Exception e) {
                    log.error("WebSocket推送失败：userId={}, error={}", userId, e.getMessage(), e);
                }
            }
            
            log.info("通知发送成功：type={}, title={}, recipients={}", 
                    notification.getType(), notification.getTitle(), targetUserIds.size());
            return true;
        } catch (Exception e) {
            log.error("发送通知失败：{}", e.getMessage(), e);
            throw new RuntimeException("发送通知失败", e);
        }
    }
    
    @Override
    public PageResult<NotificationVO> getUserNotifications(Long userId, Integer pageNum, Integer pageSize, Boolean isRead, String keyword) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        
        Integer isReadValue = isRead == null ? null : (isRead ? 1 : 0);
        List<UserNotification> records = userNotificationMapper.selectPage(offset, size, userId, isReadValue, keyword);
        long total = userNotificationMapper.count(userId, isReadValue, keyword);
        
        // 转换为VO
        List<NotificationVO> voList = records.stream().map(un -> {
            SystemNotification notification = notificationMapper.selectById(un.getNotificationId());
            if (notification == null) {
                return null;
            }
            
            NotificationVO vo = new NotificationVO();
            vo.setId(notification.getId());
            vo.setTitle(notification.getTitle());
            vo.setContent(notification.getContent());
            vo.setType(notification.getType());
            vo.setPriority(notification.getPriority());
            vo.setRelatedType(notification.getRelatedType());
            vo.setRelatedId(notification.getRelatedId());
            vo.setSenderName(notification.getSenderName());
            vo.setIsRead(un.getIsRead() == 1);
            vo.setReadTime(un.getReadTime());
            vo.setCreateTime(notification.getCreateTime());
            return vo;
        }).filter(vo -> vo != null).collect(Collectors.toList());
        
        return new PageResult<>(voList, total, current, size);
    }
    
    @Override
    @Transactional
    public boolean markAsRead(Long notificationId, Long userId) {
        UserNotification userNotification = userNotificationMapper.selectByNotificationIdAndUserId(notificationId, userId);
        if (userNotification == null) {
            return false;
        }
        
        userNotification.setIsRead(1);
        userNotification.setReadTime(LocalDateTime.now());
        return userNotificationMapper.updateById(userNotification) > 0;
    }
    
    @Override
    @Transactional
    public boolean markAllAsRead(List<Long> notificationIds, Long userId) {
        if (notificationIds == null || notificationIds.isEmpty()) {
            return false;
        }
        
        for (Long notificationId : notificationIds) {
            markAsRead(notificationId, userId);
        }
        return true;
    }
    
    @Override
    public int getUnreadCount(Long userId) {
        return userNotificationMapper.countUnreadByUserId(userId);
    }
    
    @Override
    @Transactional
    public boolean deleteNotification(Long notificationId, Long userId) {
        UserNotification userNotification = userNotificationMapper.selectByNotificationIdAndUserId(notificationId, userId);
        if (userNotification == null) {
            return false;
        }
        return userNotificationMapper.deleteById(userNotification.getId()) > 0;
    }
    
    @Override
    public void sendLoanApplyNotification(Long loanId, String borrowerName, String relicName, Long senderId) {
        log.info("开始发送借展申请通知：loanId={}, borrowerName={}, relicName={}, senderId={}", 
                loanId, borrowerName, relicName, senderId);
        
        SystemNotification notification = new SystemNotification();
        notification.setTitle("新的借展申请");
        notification.setContent(String.format("用户 %s 提交了文物\"%s\"的借展申请，请及时审批。", borrowerName, relicName));
        notification.setType("LOAN_APPLY");
        notification.setPriority("NORMAL");
        notification.setRelatedType("LOAN");
        notification.setRelatedId(loanId);
        notification.setSenderId(senderId);
        notification.setSenderName(borrowerName);
        
        // 发送给系统管理员和借展审批员
        createAndSendNotification(notification, Arrays.asList("ADMIN", "APPROVER"));
        log.info("借展申请通知发送完成：loanId={}", loanId);
    }
    
    @Override
    public void sendLoanOverdueNotification(Long loanId, String borrowerName, String relicName, int overdueDays) {
        SystemNotification notification = new SystemNotification();
        notification.setTitle("文物逾期未归还");
        notification.setContent(String.format("用户 %s 借展的文物\"%s\"已逾期 %d 天未归还，请及时处理。", 
                borrowerName, relicName, overdueDays));
        notification.setType("LOAN_OVERDUE");
        notification.setPriority("HIGH");
        notification.setRelatedType("LOAN");
        notification.setRelatedId(loanId);
        
        // 发送给系统管理员和文物保管员
        createAndSendNotification(notification, Arrays.asList("ADMIN", "CURATOR"));
    }
    
    @Override
    public void sendRepairApplyNotification(Long repairId, String relicName, String repairReason, Long senderId) {
        SystemNotification notification = new SystemNotification();
        notification.setTitle("新的修复申请");
        notification.setContent(String.format("文物\"%s\"提交了修复申请，修复原因：%s，请及时审批。", relicName, repairReason));
        notification.setType("REPAIR_APPLY");
        notification.setPriority("NORMAL");
        notification.setRelatedType("REPAIR");
        notification.setRelatedId(repairId);
        notification.setSenderId(senderId);
        
        // 发送给系统管理员和文物保管员
        createAndSendNotification(notification, Arrays.asList("ADMIN", "CURATOR"));
    }
    
    @Override
    public void sendLoanApprovalNotification(Long loanId, Long borrowerId, String relicName, boolean approved, String approverName) {
        SystemNotification notification = new SystemNotification();
        notification.setTitle(approved ? "借展申请已通过" : "借展申请已驳回");
        notification.setContent(String.format("您申请借展的文物\"%s\"已被 %s %s。", 
                relicName, approverName, approved ? "审批通过" : "驳回"));
        notification.setType(approved ? "LOAN_APPROVED" : "LOAN_REJECTED");
        notification.setPriority("NORMAL");
        notification.setRelatedType("LOAN");
        notification.setRelatedId(loanId);
        notification.setSenderName(approverName);
        notification.setCreateTime(LocalDateTime.now());
        
        // 发送给借展人
        notificationMapper.insert(notification);
        
        UserNotification userNotification = new UserNotification();
        userNotification.setNotificationId(notification.getId());
        userNotification.setUserId(borrowerId);
        userNotification.setIsRead(0);
        userNotification.setCreateTime(LocalDateTime.now());
        userNotificationMapper.insert(userNotification);
    }
    
    @Override
    public void sendRepairApprovalNotification(Long repairId, Long applicantId, String relicName, boolean approved, String approverName) {
        SystemNotification notification = new SystemNotification();
        notification.setTitle(approved ? "修复申请已通过" : "修复申请已拒绝");
        notification.setContent(String.format("文物\"%s\"的修复申请已被 %s %s。", 
                relicName, approverName, approved ? "审批通过" : "拒绝"));
        notification.setType(approved ? "REPAIR_APPROVED" : "REPAIR_REJECTED");
        notification.setPriority("NORMAL");
        notification.setRelatedType("REPAIR");
        notification.setRelatedId(repairId);
        notification.setSenderName(approverName);
        notification.setCreateTime(LocalDateTime.now());
        
        // 发送给申请人
        notificationMapper.insert(notification);
        
        UserNotification userNotification = new UserNotification();
        userNotification.setNotificationId(notification.getId());
        userNotification.setUserId(applicantId);
        userNotification.setIsRead(0);
        userNotification.setCreateTime(LocalDateTime.now());
        userNotificationMapper.insert(userNotification);
    }
    
    @Override
    public void sendUserReturnNotification(Long loanId, String username, String relicName) {
        SystemNotification notification = new SystemNotification();
        notification.setTitle("用户主动归还文物");
        notification.setContent(String.format("用户 %s 已主动归还文物\"%s\"，请及时确认。", username, relicName));
        notification.setType("USER_RETURN");
        notification.setPriority("HIGH");
        notification.setRelatedType("LOAN");
        notification.setRelatedId(loanId);
        notification.setSenderName(username);
        notification.setCreateTime(LocalDateTime.now());
        
        // 发送给管理员和审批员
        List<String> roleCodes = Arrays.asList("ADMIN", "APPROVER");
        createAndSendNotification(notification, roleCodes);
        
        log.info("用户归还通知已发送：loanId={}, username={}, relicName={}", loanId, username, relicName);
    }
    
    @Override
    public void sendRepairCompletionNotification(Long repairId, Long applicantId, String relicName, Integer qualityScore) {
        try {
            log.info("开始发送修复完成通知：repairId={}, applicantId={}, relicName={}, qualityScore={}", 
                    repairId, applicantId, relicName, qualityScore);
            
            SystemNotification notification = new SystemNotification();
            notification.setTitle("修复已完成");
            
            String content;
            if (qualityScore != null) {
                content = String.format("您申请的文物\"%s\"修复已完成，质量评分：%d分", relicName, qualityScore);
            } else {
                content = String.format("您申请的文物\"%s\"修复已完成", relicName);
            }
            
            notification.setContent(content);
            notification.setType("REPAIR_COMPLETED");
            notification.setPriority("NORMAL");
            notification.setRelatedType("REPAIR");
            notification.setRelatedId(repairId);
            notification.setSenderId(null); // 系统通知
            notification.setCreateTime(LocalDateTime.now());
            
            // 保存通知到数据库
            notificationMapper.insert(notification);
            log.info("修复完成通知已保存到数据库：notificationId={}", notification.getId());
            
            // 创建用户通知关联
            UserNotification userNotification = new UserNotification();
            userNotification.setNotificationId(notification.getId());
            userNotification.setUserId(applicantId);
            userNotification.setIsRead(0);
            userNotification.setCreateTime(LocalDateTime.now());
            userNotificationMapper.insert(userNotification);
            log.info("用户通知关联已创建：userId={}, notificationId={}", applicantId, notification.getId());
            
            // 通过WebSocket实时推送通知
            try {
                NotificationVO vo = convertToVO(notification);
                webSocketNotificationService.sendNotificationToUser(applicantId, vo);
                log.info("WebSocket通知已推送：userId={}, title={}", applicantId, notification.getTitle());
            } catch (Exception e) {
                log.warn("WebSocket推送失败，用户可能不在线：userId={}, error={}", applicantId, e.getMessage());
            }
            
            log.info("修复完成通知发送成功：repairId={}, applicantId={}, relicName={}", 
                    repairId, applicantId, relicName);
        } catch (Exception e) {
            log.error("发送修复完成通知失败：repairId={}, applicantId={}, error={}", 
                    repairId, applicantId, e.getMessage(), e);
        }
    }
    
    /**
     * 根据角色代码和通知类型获取用户ID列表
     */
    private List<Long> getUserIdsByRoleCodes(List<String> roleCodes, String notificationType) {
        log.info("开始获取目标用户列表：roleCodes={}, notificationType={}", roleCodes, notificationType);
        List<Long> userIds = new ArrayList<>();
        
        for (String roleCode : roleCodes) {
            // 1. 获取角色ID
            SysRole role = roleMapper.selectByRoleCode(roleCode);
            if (role == null) {
                log.warn("角色不存在：roleCode={}", roleCode);
                continue;
            }
            log.info("找到角色：roleCode={}, roleId={}, roleName={}", roleCode, role.getId(), role.getRoleName());
            
            // 2. 获取该角色的所有启用用户
            List<SysUser> users = userMapper.selectPage(0, Integer.MAX_VALUE, null, role.getId());
            log.info("查询到角色用户数：roleCode={}, userCount={}", roleCode, users.size());
            
            // 3. 过滤已启用该通知类型的用户
            for (SysUser user : users) {
                log.debug("检查用户：userId={}, username={}, realName={}, status={}", 
                        user.getId(), user.getUsername(), user.getRealName(), user.getStatus());
                
                if (user.getStatus() == 1 && isNotificationEnabled(user.getId(), notificationType)) {
                    userIds.add(user.getId());
                    log.info("添加目标用户：userId={}, username={}, realName={}", 
                            user.getId(), user.getUsername(), user.getRealName());
                } else {
                    log.debug("用户不符合条件：userId={}, status={}, notificationEnabled={}", 
                            user.getId(), user.getStatus(), isNotificationEnabled(user.getId(), notificationType));
                }
            }
        }
        
        List<Long> distinctUserIds = userIds.stream().distinct().collect(Collectors.toList());
        log.info("最终目标用户列表：userIds={}, count={}", distinctUserIds, distinctUserIds.size());
        return distinctUserIds;
    }
    
    /**
     * 检查用户是否启用了该通知类型
     */
    private boolean isNotificationEnabled(Long userId, String notificationType) {
        NotificationConfig config = configMapper.selectByUserIdAndType(userId, notificationType);
        
        // 如果没有配置，默认启用
        return config == null || config.getEnabled() == 1;
    }
    
    /**
     * 将SystemNotification转换为NotificationVO
     */
    private NotificationVO convertToVO(SystemNotification notification) {
        NotificationVO vo = new NotificationVO();
        vo.setId(notification.getId());
        vo.setTitle(notification.getTitle());
        vo.setContent(notification.getContent());
        vo.setType(notification.getType());
        vo.setPriority(notification.getPriority());
        vo.setRelatedType(notification.getRelatedType());
        vo.setRelatedId(notification.getRelatedId());
        vo.setSenderName(notification.getSenderName());
        vo.setIsRead(false);
        vo.setCreateTime(notification.getCreateTime());
        return vo;
    }
    
    @Override
    public java.util.Map<String, Object> getNotificationStatistics(LocalDateTime startDate, LocalDateTime endDate) {
        java.util.Map<String, Object> statistics = new java.util.HashMap<>();
        
        try {
            // 总通知数
            int totalNotifications = userNotificationMapper.countTotalNotifications(startDate, endDate);
            statistics.put("totalNotifications", totalNotifications);
            
            // 已读通知数
            int readNotifications = userNotificationMapper.countReadNotifications(startDate, endDate);
            statistics.put("readNotifications", readNotifications);
            
            // 阅读率
            double readRate = totalNotifications > 0 ? (double) readNotifications / totalNotifications * 100 : 0;
            statistics.put("readRate", Math.round(readRate * 100.0) / 100.0);
            
            // 按类型统计
            java.util.Map<String, Integer> typeStatistics = new java.util.HashMap<>();
            String[] types = {"LOAN_APPLY", "LOAN_OVERDUE", "LOAN_APPROVED", "LOAN_REJECTED", 
                            "REPAIR_APPLY", "REPAIR_APPROVED", "REPAIR_REJECTED"};
            for (String type : types) {
                int count = userNotificationMapper.countByType(type, startDate, endDate);
                typeStatistics.put(type, count);
            }
            statistics.put("typeStatistics", typeStatistics);
            
            log.info("通知统计查询成功：startDate={}, endDate={}, total={}", startDate, endDate, totalNotifications);
        } catch (Exception e) {
            log.error("获取通知统计失败：{}", e.getMessage(), e);
            throw new RuntimeException("获取通知统计失败", e);
        }
        
        return statistics;
    }
}
