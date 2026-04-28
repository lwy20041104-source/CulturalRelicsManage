package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 系统恢复记录实体
 */
@Data
public class SysRestore {
    
    private Long id;
    
    /**
     * 备份ID
     */
    private Long backupId;
    
    /**
     * 恢复状态：processing-处理中, success-成功, failed-失败
     */
    private String restoreStatus;
    
    /**
     * 恢复类型：full-完全恢复, partial-部分恢复
     */
    private String restoreType;
    
    /**
     * 恢复的表列表（JSON数组）
     */
    private String restoreTables;
    
    /**
     * 错误信息
     */
    private String errorMessage;
    
    /**
     * 操作人
     */
    private String createdBy;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdTime;
    
    /**
     * 完成时间
     */
    private LocalDateTime completedTime;
}
