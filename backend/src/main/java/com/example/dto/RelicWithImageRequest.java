package com.example.dto;

import com.example.entity.CulturalRelic;
import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

/**
 * 带图片的文物请求DTO
 */
@Data
public class RelicWithImageRequest {
    
    /**
     * 文物信息
     */
    private CulturalRelic relic;
    
    /**
     * 图片文件（可选）
     */
    private MultipartFile imageFile;
    
    /**
     * 图片ID（从图片库选择，可选）
     */
    private Long imageId;
}
