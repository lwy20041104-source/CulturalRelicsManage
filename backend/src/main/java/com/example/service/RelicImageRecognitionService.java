package com.example.service;

import com.example.dto.ImageRecognitionResult;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文物图像识别服务接口
 */
public interface RelicImageRecognitionService {
    
    /**
     * 识别文物图片并返回分类建议
     * @param imageFile 图片文件
     * @return 识别结果
     */
    ImageRecognitionResult recognizeRelic(MultipartFile imageFile);
    
    /**
     * 通过图片URL识别文物
     * @param imageUrl 图片URL
     * @return 识别结果
     */
    ImageRecognitionResult recognizeRelicByUrl(String imageUrl);
}
