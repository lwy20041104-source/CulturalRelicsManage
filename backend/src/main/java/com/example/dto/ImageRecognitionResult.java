package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * 图像识别结果DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ImageRecognitionResult {
    
    /**
     * 识别是否成功
     */
    private Boolean success;
    
    /**
     * 识别到的主要分类
     */
    private CategorySuggestion primaryCategory;
    
    /**
     * 其他可能的分类（按置信度排序）
     */
    private List<CategorySuggestion> alternativeCategories;
    
    /**
     * 识别到的关键特征
     */
    private List<String> features;
    
    /**
     * 建议的年代
     */
    private String suggestedEra;
    
    /**
     * 建议的材质
     */
    private String suggestedMaterial;
    
    /**
     * 识别描述
     */
    private String description;
    
    /**
     * 错误信息（如果识别失败）
     */
    private String errorMessage;
    
    /**
     * 分类建议
     */
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CategorySuggestion {
        /**
         * 分类ID
         */
        private Long categoryId;
        
        /**
         * 分类名称
         */
        private String categoryName;
        
        /**
         * 置信度（0-100）
         */
        private Double confidence;
        
        /**
         * 匹配原因
         */
        private String reason;
    }
}
