package com.example.service.impl;

import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import com.example.service.Relic3DService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 3D文物模型管理服务实现
 */
@Slf4j
@Service
public class Relic3DServiceImpl implements Relic3DService {

    @Value("${file.upload.path:uploads/3d-models}")
    private String uploadPath;

    @Value("${file.upload.url-prefix:http://localhost:8080/uploads/3d-models}")
    private String urlPrefix;

    private final CulturalRelicService culturalRelicService;

    public Relic3DServiceImpl(CulturalRelicService culturalRelicService) {
        this.culturalRelicService = culturalRelicService;
    }

    @Override
    public String getUploadPath() {
        return uploadPath;
    }

    @Override
    public String getUrlPrefix() {
        return urlPrefix;
    }

    @Override
    public Map<String, Object> upload3DModel(Long relicId, MultipartFile file) {
        if (relicId == null || file == null || file.isEmpty()) {
            throw new IllegalArgumentException("参数不能为空");
        }

        // 检查文物是否存在
        CulturalRelic relic = culturalRelicService.getById(relicId);
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }

        // 校验文件类型
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            throw new IllegalArgumentException("文件名不能为空");
        }
        String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        if (!extension.equals(".gltf") && !extension.equals(".glb") && !extension.equals(".obj")) {
            throw new IllegalArgumentException("只支持 GLTF (.gltf, .glb) 和 OBJ (.obj) 格式");
        }

        // 校验文件大小（50MB）
        if (file.getSize() > 50 * 1024 * 1024) {
            throw new IllegalArgumentException("文件大小不能超过 50MB");
        }

        try {
            // 创建上传目录
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // 生成唯一文件名
            String filename = UUID.randomUUID().toString() + extension;
            Path filePath = Paths.get(uploadPath, filename);

            // 保存文件
            Files.copy(file.getInputStream(), filePath);

            // 构建访问URL
            String modelUrl = urlPrefix + "/" + filename;

            // 更新数据库中的文物记录
            relic.setModel3dUrl(modelUrl);
            relic.setModel3dUploadTime(LocalDateTime.now());
            culturalRelicService.updateById(relic);

            // 返回结果
            Map<String, Object> result = new HashMap<>();
            result.put("relicId", relicId);
            result.put("modelUrl", modelUrl);
            result.put("filename", filename);
            result.put("fileSize", file.getSize());

            return result;
        } catch (IOException e) {
            log.error("文件上传失败: {}", e.getMessage(), e);
            throw new RuntimeException("文件上传失败: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete3DModelFile(Long relicId, String filename) {
        try {
            Path filePath = Paths.get(uploadPath, filename);
            Files.deleteIfExists(filePath);

            // 更新数据库中的文物记录
            CulturalRelic relic = culturalRelicService.getById(relicId);
            if (relic != null) {
                relic.setModel3dUrl(null);
                relic.setModel3dUploadTime(null);
                culturalRelicService.updateById(relic);
            }
        } catch (IOException e) {
            log.error("删除文件失败: {}", e.getMessage(), e);
            throw new RuntimeException("删除文件失败: " + e.getMessage(), e);
        }
    }

    @Override
    public Map<String, Object> get3DModelInfo(Long relicId) {
        Map<String, Object> result = new HashMap<>();
        result.put("relicId", relicId);

        CulturalRelic relic = culturalRelicService.getById(relicId);
        if (relic != null && relic.getModel3dUrl() != null) {
            result.put("modelUrl", relic.getModel3dUrl());
            result.put("uploadTime", relic.getModel3dUploadTime());
            result.put("hasModel", true);
        } else {
            result.put("modelUrl", null);
            result.put("hasModel", false);
        }

        return result;
    }

    @Override
    public Map<String, Object> save3DModelUrl(Long relicId, String modelUrl) {
        if (modelUrl == null || modelUrl.trim().isEmpty()) {
            throw new IllegalArgumentException("模型链接不能为空");
        }

        CulturalRelic relic = culturalRelicService.getById(relicId);
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }

        relic.setModel3dUrl(modelUrl.trim());
        relic.setModel3dUploadTime(LocalDateTime.now());
        culturalRelicService.updateById(relic);

        Map<String, Object> result = new HashMap<>();
        result.put("relicId", relicId);
        result.put("modelUrl", modelUrl.trim());
        result.put("uploadTime", relic.getModel3dUploadTime());

        return result;
    }

    @Override
    public void delete3DModelUrl(Long relicId) {
        CulturalRelic relic = culturalRelicService.getById(relicId);
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }

        String modelUrl = relic.getModel3dUrl();

        // 如果是本地上传的文件，尝试删除文件
        if (modelUrl != null && modelUrl.startsWith(urlPrefix)) {
            String filename = modelUrl.substring(modelUrl.lastIndexOf("/") + 1);
            try {
                Path filePath = Paths.get(uploadPath, filename);
                boolean deleted = Files.deleteIfExists(filePath);
                log.info("本地文件删除结果: {}, 文件路径: {}", deleted, filePath);
            } catch (IOException e) {
                log.warn("删除本地文件失败: {}", e.getMessage());
            }
        }

        // 清除数据库中的3D模型信息
        int updateResult = culturalRelicService.clear3DModelInfo(relicId);
        log.info("数据库更新结果: {}", updateResult);

        // 验证更新是否成功
        CulturalRelic verifyRelic = culturalRelicService.getById(relicId);
        if (verifyRelic.getModel3dUrl() != null) {
            log.warn("3D模型URL未能成功清除");
            throw new RuntimeException("删除失败: 数据库更新未生效");
        }
    }
}
