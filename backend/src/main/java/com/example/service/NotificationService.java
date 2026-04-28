package com.example.service;

import com.example.common.PageResult;
import com.example.dto.NotificationVO;
import com.example.entity.SystemNotification;

import java.util.List;

/**
 * 通知服务接口
 */
public interface NotificationService {
    
    /**
     * 创建通知并发送给指定角色的用户
     * 
     * @param notification 通知对象
     * @param roleCodes 角色代码列表（如：ADMIN, CURATOR, APPROVER）
     * @return 是否成功
     */
    boolean createAndSendNotification(SystemNotification notification, List<String> roleCodes);
    
    /**
     * 获取用户的通知列表（分页）
     * 
     * @param userId 用户ID
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @param isRead 是否已读（null表示全部）
     * @param keyword 搜索关键词
     * @return 分页结果
     */
    PageResult<NotificationVO> getUserNotifications(Long userId, Integer pageNum, Integer pageSize, Boolean isRead, String keyword);
    
    /**
     * 标记通知为已读
     * 
     * @param notificationId 通知ID
     * @param userId 用户ID
     * @return 是否成功
     */
    boolean markAsRead(Long notificationId, Long userId);
    
    /**
     * 批量标记为已读
     * 
     * @param notificationIds 通知ID列表
     * @param userId 用户ID
     * @return 是否成功
     */
    boolean markAllAsRead(List<Long> notificationIds, Long userId);
    
    /**
     * 获取用户未读通知数量
     * 
     * @param userId 用户ID
     * @return 未读数量
     */
    int getUnreadCount(Long userId);
    
    /**
     * 删除通知
     * 
     * @param notificationId 通知ID
     * @param userId 用户ID
     * @return 是否成功
     */
    boolean deleteNotification(Long notificationId, Long userId);
    
    /**
     * 发送借展申请通知
     * 
     * @param loanId 借展记录ID
     * @param borrowerName 借展人姓名
     * @param relicName 文物名称
     * @param senderId 发送人ID
     */
    void sendLoanApplyNotification(Long loanId, String borrowerName, String relicName, Long senderId);
    
    /**
     * 发送借展逾期通知
     * 
     * @param loanId 借展记录ID
     * @param borrowerName 借展人姓名
     * @param relicName 文物名称
     * @param overdueDays 逾期天数
     */
    void sendLoanOverdueNotification(Long loanId, String borrowerName, String relicName, int overdueDays);
    
    /**
     * 发送修复申请通知
     * 
     * @param repairId 修复记录ID
     * @param relicName 文物名称
     * @param repairReason 修复原因
     * @param senderId 发送人ID
     */
    void sendRepairApplyNotification(Long repairId, String relicName, String repairReason, Long senderId);
    
    /**
     * 发送修复申请更新通知
     * 
     * @param repairId 修复记录ID
     * @param relicName 文物名称
     * @param repairReason 修复原因
     * @param senderId 发送人ID
     */
    void sendRepairUpdateNotification(Long repairId, String relicName, String repairReason, Long senderId);
    
    /**
     * 发送修复申请撤回通知
     * 
     * @param repairId 修复记录ID
     * @param relicName 文物名称
     * @param repairReason 修复原因
     * @param senderId 发送人ID
     */
    void sendRepairWithdrawNotification(Long repairId, String relicName, String repairReason, Long senderId);
    
    /**
     * 发送借展审批结果通知
     * 
     * @param loanId 借展记录ID
     * @param borrowerId 借展人ID
     * @param relicName 文物名称
     * @param approved 是否通过
     * @param approverName 审批人姓名
     */
    void sendLoanApprovalNotification(Long loanId, Long borrowerId, String relicName, boolean approved, String approverName);
    
    /**
     * 发送修复审批结果通知
     * 
     * @param repairId 修复记录ID
     * @param applicantId 申请人ID
     * @param relicName 文物名称
     * @param approved 是否通过
     * @param approverName 审批人姓名
     */
    void sendRepairApprovalNotification(Long repairId, Long applicantId, String relicName, boolean approved, String approverName);
    
    /**
     * 发送用户主动归还文物通知
     * 
     * @param loanId 借展记录ID
     * @param username 用户名
     * @param relicName 文物名称
     */
    void sendUserReturnNotification(Long loanId, String username, String relicName);
    
    /**
     * 发送修复完成通知
     * 
     * @param repairId 修复记录ID
     * @param applicantId 申请人ID
     * @param relicName 文物名称
     * @param qualityScore 质量评分
     */
    void sendRepairCompletionNotification(Long repairId, Long applicantId, String relicName, Integer qualityScore);
    
    /**
     * 获取通知统计信息
     * 
     * @param startDate 开始日期
     * @param endDate 结束日期
     * @return 统计信息Map
     */
    java.util.Map<String, Object> getNotificationStatistics(java.time.LocalDateTime startDate, java.time.LocalDateTime endDate);
}
