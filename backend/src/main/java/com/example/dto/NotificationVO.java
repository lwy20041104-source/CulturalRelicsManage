package com.example.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 通知视图对象
 */
@Data
public class NotificationVO {
    
    /**
     * 通知ID
     */
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
     */
    private String type;
    
    /**
     * 优先级
     */
    private String priority;
    
    /**
     * 关联类型
     */
    private String relatedType;
    
    /**
     * 关联ID
     */
    private Long relatedId;
    
    /**
     * 发送人姓名
     */
    private String senderName;
    
    /**
     * 是否已读
     */
    private Boolean isRead;
    
    /**
     * 阅读时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime readTime;
    
    /**
     * 创建时间
     */
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
