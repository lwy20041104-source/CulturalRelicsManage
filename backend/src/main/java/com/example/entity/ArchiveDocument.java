package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 档案文档实体类
 */
@Data
public class ArchiveDocument {
    
    private Long id;
    private Long archiveId;
    private String documentType;  // appraisal/repair/research/certificate/photo/other
    private String documentName;
    private String filePath;
    private Long fileSize;
    private String fileFormat;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime uploadTime;
    
    private Long uploaderId;
    private String uploaderName;
    private String description;
    private Integer sortOrder;
}
