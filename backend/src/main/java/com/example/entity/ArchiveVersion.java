package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 档案版本实体类
 */
@Data
public class ArchiveVersion {
    
    private Long id;
    private Long archiveId;
    private Integer version;
    private String versionTitle;
    private String changeLog;
    private String contentSnapshot;  // JSON格式的内容快照
    private Long createdBy;
    private String createdByName;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;
}
