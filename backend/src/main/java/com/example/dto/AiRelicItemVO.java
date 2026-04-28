package com.example.dto;

import lombok.Data;

import java.util.List;

@Data
public class AiRelicItemVO {
    private Long id;
    private String relicName;
    private String imagePath;
    private String era;
    private String material;
    private String status;
    private String categoryName;
    private String dimensions;
    private Double weight;
    private String description;
    private String introduction;
    private Integer relevancePercent;
    private List<String> matchTags;
    private Boolean external;
    private String sourceName;
    private String sourceType;
    private String sourceUrl;
}
