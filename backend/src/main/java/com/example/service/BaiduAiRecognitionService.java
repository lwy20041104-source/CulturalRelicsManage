package com.example.service;

import com.example.dto.ImageRecognitionResult;

/**
 * 百度AI图像识别服务接口
 */
public interface BaiduAiRecognitionService {

    /**
     * 检查百度AI是否可用
     * @return true-可用，false-不可用
     */
    boolean isAvailable();

    /**
     * 使用百度AI识别图片
     * @param imageData 图片字节数据
     * @return 识别结果，识别失败返回null
     */
    ImageRecognitionResult recognizeWithBaiduAi(byte[] imageData);
}
