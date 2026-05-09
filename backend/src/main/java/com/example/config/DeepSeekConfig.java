package com.example.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * DeepSeek API 配置
 */
@Data
@Configuration
@ConfigurationProperties(prefix = "deepseek")
public class DeepSeekConfig {
    
    /**
     * DeepSeek API Key
     */
    private String apiKey;
    
    /**
     * DeepSeek API 地址
     */
    private String apiUrl = "https://api.deepseek.com/v1/chat/completions";
    
    /**
     * 使用的模型
     */
    private String model = "deepseek-chat";
    
    /**
     * 最大tokens数
     */
    private Integer maxTokens = 2000;
    
    /**
     * 温度参数（0-2）
     */
    private Double temperature = 0.7;
    
    /**
     * 连接超时时间（毫秒）
     */
    private Integer connectTimeout = 10000;
    
    /**
     * 读取超时时间（毫秒）
     */
    private Integer readTimeout = 30000;
}
