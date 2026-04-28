package com.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CulturalRelic {
    private Long id;
    private String relicCode;
    private String relicName;
    private Long categoryId;
    private String categoryName;
    private String era;
    private String material;
    private String origin;
    private String dimensions;
    private Double weight;
    private String description;
    private String status;
    private String imagePath;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
