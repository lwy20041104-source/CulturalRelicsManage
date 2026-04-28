package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AiChatSession {
    private Long id;
    private Long userId;
    private String sessionTitle;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
