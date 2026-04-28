package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class UserMuseum {
    private Long id;
    private Long userId;
    private Long museumId;
    private Integer isPrimary;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private String museumName; // 博物馆名称（用于关联查询）
}
