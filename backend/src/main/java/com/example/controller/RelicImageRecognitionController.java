package com.example.controller;

import com.example.common.Result;
import com.example.dto.ImageRecognitionResult;
import com.example.service.RelicImageRecognitionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 文物图像识别控制器
 */
@Slf4j
@RestController
@RequestMapping("/relic-recognition")
@CrossOrigin
public class RelicImageRecognitionController {

    private final RelicImageRecognitionService recognitionService;

    public RelicImageRecognitionController(RelicImageRecognitionService recognitionService) {
        this.recognitionService = recognitionService;
    }
    
    /**
     * 上传图片进行识别
     */
    @PostMapping("/recognize")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'STAFF')")
    public Result<ImageRecognitionResult> recognizeImage(
            @RequestParam("file") MultipartFile file) {
        
        try {
            log.info("收到图像识别请求，文件名：{}", file.getOriginalFilename());
            
            ImageRecognitionResult result = recognitionService.recognizeRelic(file);
            
            if (result.getSuccess()) {
                log.info("图像识别成功，主要分类：{}", 
                    result.getPrimaryCategory() != null ? 
                    result.getPrimaryCategory().getCategoryName() : "未知");
                return Result.success(result);
            } else {
                log.warn("图像识别失败：{}", result.getErrorMessage());
                return Result.error(result.getErrorMessage());
            }
            
        } catch (Exception e) {
            log.error("图像识别异常", e);
            return Result.error("图像识别失败：" + e.getMessage());
        }
    }
    
    /**
     * 通过URL识别图片
     */
    @PostMapping("/recognize-by-url")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'STAFF')")
    public Result<ImageRecognitionResult> recognizeImageByUrl(
            @RequestBody Map<String, String> request) {
        
        try {
            String imageUrl = request.get("imageUrl");
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                return Result.error("图片URL不能为空");
            }
            
            log.info("收到URL图像识别请求：{}", imageUrl);
            
            ImageRecognitionResult result = recognitionService.recognizeRelicByUrl(imageUrl);
            
            if (result.getSuccess()) {
                log.info("图像识别成功，主要分类：{}", 
                    result.getPrimaryCategory() != null ? 
                    result.getPrimaryCategory().getCategoryName() : "未知");
                return Result.success(result);
            } else {
                log.warn("图像识别失败：{}", result.getErrorMessage());
                return Result.error(result.getErrorMessage());
            }
            
        } catch (Exception e) {
            log.error("图像识别异常", e);
            return Result.error("图像识别失败：" + e.getMessage());
        }
    }
}
