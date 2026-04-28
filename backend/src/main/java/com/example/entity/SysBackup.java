package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 系统备份记录实体
 */
@Data
public class SysBackup {
    
    private Long id;
    
    /**
     * 备份名称
     */
    private String backupName;
    
    /**
     * 备份类型：manual-手动, auto-自动
     */
    private String backupType;
    
    /**
     * 备份状态：processing-处理中, success-成功, failed-失败
     */
    private String backupStatus;
    
    /**
     * 备份文件名
     */
    private String fileName;
    
    /**
     * 备份文件路径
     */
    private String filePath;
    
    /**
     * 文件大小（字节）
     */
    private Long fileSize;
    
    /**
     * 是否加密：0-否, 1-是
     */
    private Boolean isEncrypted;
    
    /**
     * 备份的表列表（JSON数组）
     */
    private String backupTables;
    
    /**
     * 备份描述
     */
    private String description;
    
    /**
     * 错误信息
     */
    private String errorMessage;
    
    /**
     * 创建人
     */
    private String createdBy;
    
    /**
     * 创建时间
     */
    private LocalDateTime createdTime;
    
    /**
     * 是否删除：0-否, 1-是
     */
    private Boolean deleted;
}
