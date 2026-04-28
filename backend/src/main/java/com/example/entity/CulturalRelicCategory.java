package com.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CulturalRelicCategory {
    private Long id;
    private String categoryName;
    private Long parentId;
    private Integer sortOrder;
    private String description;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private Integer relicCount;  // 该分类下的文物数量
}
