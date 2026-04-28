package com.example.dto;

import lombok.Data;

@Data
public class AiRelicQueryRequest {
    private String question;
    private Boolean matchAll;
    private Long sessionId;  // 会话ID，用于关联对话历史
}
