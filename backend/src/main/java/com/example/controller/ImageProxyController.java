package com.example.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;

/**
 * 图片代理控制器
 * 用于代理外部图片，解决跨域和防盗链问题
 */
@Slf4j
@RestController
@RequestMapping("/proxy")
public class ImageProxyController {

    /**
     * 代理图片请求
     * @param imageUrl 图片URL（Base64编码）
     * @return 图片字节流
     */
    @GetMapping("/image")
    public ResponseEntity<byte[]> proxyImage(@RequestParam("url") String imageUrl) {
        try {
            // Base64 解码
            String decodedUrl = new String(Base64.getDecoder().decode(imageUrl));
            log.info("代理图片请求：{}", decodedUrl);
            
            // 验证 URL
            if (!decodedUrl.startsWith("http://") && !decodedUrl.startsWith("https://")) {
                log.warn("无效的图片URL：{}", decodedUrl);
                return ResponseEntity.badRequest().build();
            }
            
            // 下载图片
            HttpURLConnection connection = (HttpURLConnection) new URL(decodedUrl).openConnection();
            connection.setRequestMethod("GET");
            connection.setConnectTimeout(5000);
            connection.setReadTimeout(10000);
            // 设置 User-Agent 和 Referer 避免防盗链
            connection.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36");
            connection.setRequestProperty("Referer", "https://baike.baidu.com/");
            connection.setRequestProperty("Accept", "image/webp,image/apng,image/*,*/*;q=0.8");
            
            int responseCode = connection.getResponseCode();
            if (responseCode != 200) {
                log.warn("图片下载失败，状态码：{}，URL：{}", responseCode, decodedUrl);
                return ResponseEntity.status(responseCode).build();
            }
            
            // 读取图片数据
            byte[] imageBytes;
            try (InputStream inputStream = connection.getInputStream();
                 ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
                imageBytes = outputStream.toByteArray();
            }
            
            // 获取内容类型
            String contentType = connection.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                contentType = "image/jpeg"; // 默认类型
            }
            
            log.info("图片代理成功：大小={}KB，类型={}，URL={}", 
                imageBytes.length / 1024, contentType, decodedUrl);
            
            // 返回图片
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(contentType));
            headers.setCacheControl("public, max-age=86400"); // 缓存1天
            
            return new ResponseEntity<>(imageBytes, headers, HttpStatus.OK);
            
        } catch (Exception e) {
            log.error("图片代理失败：url={}, error={}", imageUrl, e.getMessage(), e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
