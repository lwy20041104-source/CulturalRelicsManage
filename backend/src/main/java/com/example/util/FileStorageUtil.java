package com.example.util;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

@Slf4j
@Component
public class FileStorageUtil {

    @Value("${file.upload-path:uploads}")
    private String uploadPath;

    public String save(MultipartFile file) throws IOException {
        // 获取项目根目录的绝对路径
        String projectRoot = System.getProperty("user.dir");
        
        // 规范化上传路径（移除 ./ 和尾部斜杠）
        String normalizedUploadPath = uploadPath
            .replace("./", "")
            .replace(".\\", "")
            .replaceAll("[/\\\\]+$", "");  // 移除尾部的所有斜杠
        
        // 构建上传目录的绝对路径
        Path uploadDir = Paths.get(projectRoot, normalizedUploadPath);
        
        // 确保目录存在
        if (!Files.exists(uploadDir)) {
            Files.createDirectories(uploadDir);
            log.info("创建上传目录: {}", uploadDir.toAbsolutePath());
        }
        
        // 获取原始文件名和后缀
        String original = file.getOriginalFilename() == null ? "file" : file.getOriginalFilename();
        String suffix = "";
        int idx = original.lastIndexOf('.');
        if (idx >= 0) {
            suffix = original.substring(idx);
        }
        
        // 生成唯一文件名
        String filename = UUID.randomUUID().toString().replace("-", "") + suffix;
        
        // 保存文件
        Path targetPath = uploadDir.resolve(filename);
        file.transferTo(targetPath.toFile());
        
        log.info("文件已保存到: {}", targetPath.toAbsolutePath());
        
        // 返回规范化的相对路径（用于数据库存储和URL访问）
        // 确保路径格式为 /uploads/filename，避免双斜杠
        String relativePath = "/" + normalizedUploadPath + "/" + filename;
        log.info("返回的相对路径: {}", relativePath);
        
        return relativePath;
    }
}
