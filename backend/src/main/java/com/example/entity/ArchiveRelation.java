package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * 档案关联关系实体类
 */
@Data
public class ArchiveRelation {
    
    private Long id;
    private Long archiveId;
    private String relationType;  // loan/repair/maintenance/exhibition
    private Long relationId;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime relationTime;
    
    private String relationDesc;
    
    // 关联对象（不映射到数据库）
    private Object relationObject;  // 根据relationType动态加载对应的对象
}
