package com.example.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.io.File;

/**
 * Web MVC 配置
 * 配置静态资源访问路径
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {
    
    @Value("${file.upload-path:./uploads/}")
    private String uploadPath;
    
    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 配置上传文件的访问路径
        String absoluteUploadPath = uploadPath;
        if (!uploadPath.startsWith("/") && !uploadPath.matches("^[A-Za-z]:.*")) {
            // 如果是相对路径，转换为项目根目录下的绝对路径
            absoluteUploadPath = System.getProperty("user.dir") + File.separator + uploadPath;
        }
        
        // 确保路径以 / 结尾
        if (!absoluteUploadPath.endsWith(File.separator)) {
            absoluteUploadPath += File.separator;
        }
        
        // 映射 /uploads/** 到实际的文件系统路径
        // 由于 context-path 是 /api，实际访问路径是 /api/uploads/**
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations("file:" + absoluteUploadPath);
        
        System.out.println("配置静态资源访问路径: /api/uploads/** -> " + absoluteUploadPath);
    }
}
