package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 文物档案实体类
 */
@Data
public class RelicArchive {
    
    private Long id;
    private Long relicId;
    private String archiveCode;
    private String archiveTitle;
    private String archiveType;  // complete/basic/image/document
    private String description;
    private Integer version;
    private String status;  // draft/published/archived
    private Long createdBy;
    private String createdByName;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createdTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updatedTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime publishedTime;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime archivedTime;
    
    // 关联查询字段（不映射到数据库）
    private CulturalRelic relic;  // 文物信息
    private List<ArchiveDocument> documents;  // 档案文档列表
    private List<ArchiveHistory> histories;  // 历史记录
    private List<ArchiveRelation> relations;  // 关联记录
    private Integer documentCount;  // 文档数量
    private Long totalFileSize;  // 总文件大小
}
