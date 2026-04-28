package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AiQueryResult {
    private Long id;
    private Long messageId;
    private Long relicId;
    private String relicName;
    private Integer relevancePercent;
    private Integer isExternal;
    private String sourceName;
    private String sourceType;
    private String sourceUrl;
    private String matchTags;  // JSON数组字符串
    private LocalDateTime createTime;
}
