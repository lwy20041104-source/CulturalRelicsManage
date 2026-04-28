package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 档案历史记录实体类
 */
@Data
public class ArchiveHistory {
    
    private Long id;
    private Long archiveId;
    private Integer version;
    private String operationType;  // create/update/upload/delete/export/print/publish/archive
    private String operationContent;
    private String changeLog;
    private Long operatorId;
    private String operatorName;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime operationTime;
    
    private String ipAddress;
}
