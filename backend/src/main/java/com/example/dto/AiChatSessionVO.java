package com.example.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class AiChatSessionVO {
    private Long id;
    private Long userId;
    private String userName;  // 用户姓名
    private String sessionTitle;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
