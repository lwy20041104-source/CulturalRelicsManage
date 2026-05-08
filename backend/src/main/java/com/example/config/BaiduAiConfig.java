package com.example.config;

import com.baidu.aip.imageclassify.AipImageClassify;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * 百度AI配置类
 */
@Slf4j
@Data
@Configuration
@ConfigurationProperties(prefix = "baidu.ai")
public class BaiduAiConfig {
    
    /**
     * 是否启用百度AI识别
     */
    private boolean enabled = false;
    
    /**
     * 百度AI应用的APP_ID
     */
    private String appId;
    
    /**
     * 百度AI应用的API_KEY
     */
    private String apiKey;
    
    /**
     * 百度AI应用的SECRET_KEY
     */
    private String secretKey;
    
    /**
     * 识别置信度阈值
     */
    private double confidenceThreshold = 0.6;
    
    /**
     * 创建百度AI图像识别客户端
     */
    @Bean
    public AipImageClassify aipImageClassify() {
        if (!enabled) {
            log.info("百度AI识别未启用，将使用规则识别");
            return null;
        }
        
        if (appId == null || apiKey == null || secretKey == null) {
            log.warn("百度AI配置不完整，将使用规则识别");
            return null;
        }
        
        if ("your_app_id_here".equals(appId) || 
            "your_api_key_here".equals(apiKey) || 
            "your_secret_key_here".equals(secretKey)) {
            log.warn("百度AI配置未设置，将使用规则识别");
            return null;
        }
        
        log.info("初始化百度AI图像识别客户端");
        AipImageClassify client = new AipImageClassify(appId, apiKey, secretKey);
        
        // 可选：设置网络连接参数
        client.setConnectionTimeoutInMillis(5000);
        client.setSocketTimeoutInMillis(10000);
        
        log.info("百度AI图像识别客户端初始化成功");
        return client;
    }
}
