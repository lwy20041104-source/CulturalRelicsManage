package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AiChatMessage {
    private Long id;
    private Long sessionId;
    private Long userId;
    private String messageType;  // user, ai
    private String content;
    private String queryKeyword;
    private Integer resultCount;
    private Integer hasExternalResult;
    private String relicIds;  // 逗号分隔的ID列表
    private LocalDateTime createTime;
}
