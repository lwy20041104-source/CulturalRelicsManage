package com.example.dto;

import lombok.Data;

import java.util.List;

@Data
public class AiRelicQueryResponse {
    private String answer;
    private Integer total;
    private String topReason;
    private Boolean museumHit;
    private String museumMessage;
    private List<AiRelicItemVO> relics;
    private List<AiWebSearchItemVO> webResults;
    private Long sessionId;  // 会话ID，返回给前端用于后续查询
}
