package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 备份配置实体
 */
@Data
public class SysBackupConfig {
    
    private Long id;
    
    /**
     * 配置名称
     */
    private String configName;
    
    /**
     * 是否启用：0-否, 1-是
     */
    private Boolean isEnabled;
    
    /**
     * 备份频率：daily-每天, weekly-每周, monthly-每月
     */
    private String backupFrequency;
    
    /**
     * 备份时间（HH:mm）
     */
    private String backupTime;
    
    /**
     * 保留天数
     */
    private Integer retentionDays;
    
    /**
     * 最大备份数量
     */
    private Integer maxBackupCount;
    
    /**
     * 是否加密：0-否, 1-是
     */
    private Boolean isEncrypted;
    
    /**
     * 备份的表列表（JSON数组，为空则备份全部）
     */
    private String backupTables;
    
    /**
     * 是否启用通知：0-否, 1-是
     */
    private Boolean notificationEnabled;
    
    /**
     * 创建人
     */
    private String createdBy;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdTime;
    
    /**
     * 更新人
     */
    private String updatedBy;
    
    /**
     * 更新时间
     */
    private LocalDateTime updatedTime;
}
