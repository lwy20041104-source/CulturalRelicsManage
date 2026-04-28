package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 系统通知实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SystemNotification {
    
    private Long id;
    
    /**
     * 通知标题
     */
    private String title;
    
    /**
     * 通知内容
     */
    private String content;
    
    /**
     * 通知类型
     * LOAN_APPLY: 借展申请
     * LOAN_OVERDUE: 借展逾期
     * REPAIR_APPLY: 修复申请
     * LOAN_APPROVED: 借展审批通过
     * LOAN_REJECTED: 借展审批拒绝
     * REPAIR_APPROVED: 修复审批通过
     * REPAIR_REJECTED: 修复审批拒绝
     */
    private String type;
    
    /**
     * 优先级
     * LOW: 低
     * NORMAL: 普通
     * HIGH: 高
     * URGENT: 紧急
     */
    private String priority;
    
    /**
     * 关联类型：LOAN(借展)、REPAIR(修复)
     */
    private String relatedType;
    
    /**
     * 关联ID（借展记录ID或修复记录ID）
     */
    private Long relatedId;
    
    /**
     * 发送人ID
     */
    private Long senderId;
    
    /**
     * 发送人姓名
     */
    private String senderName;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
