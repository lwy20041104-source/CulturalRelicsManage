package com.example.controller;

import com.example.common.Result;
import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
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
 * 3D文物模型管理控制器
 */
@RestController
@RequestMapping("/relics")
@CrossOrigin
public class Relic3DController {

    @Value("${file.upload.path:uploads/3d-models}")
    private String uploadPath;

    @Value("${file.upload.url-prefix:http://localhost:8080/uploads/3d-models}")
    private String urlPrefix;

    @Autowired(required = false)
    private CulturalRelicService culturalRelicService;

    /**
     * 上传3D模型
     */
    @PostMapping("/{id}/3d-model")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Map<String, Object>> upload3DModel(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file) {
        
        if (file.isEmpty()) {
            return Result.error("文件不能为空");
        }

        // 检查文件类型
        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null) {
            return Result.error("文件名不能为空");
        }

        String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();
        if (!extension.equals(".gltf") && !extension.equals(".glb") && !extension.equals(".obj")) {
            return Result.error("只支持 GLTF (.gltf, .glb) 和 OBJ (.obj) 格式");
        }

        // 检查文件大小（50MB）
        if (file.getSize() > 50 * 1024 * 1024) {
            return Result.error("文件大小不能超过 50MB");
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
            if (culturalRelicService != null) {
                CulturalRelic relic = culturalRelicService.getById(id);
                if (relic != null) {
                    relic.setModel3dUrl(modelUrl);
                    relic.setModel3dUploadTime(LocalDateTime.now());
                    culturalRelicService.updateById(relic);
                }
            }

            // 返回结果
            Map<String, Object> result = new HashMap<>();
            result.put("relicId", id);
            result.put("modelUrl", modelUrl);
            result.put("filename", filename);
            result.put("fileSize", file.getSize());

            return Result.success(result);

        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }

    /**
     * 删除3D模型
     */
    @DeleteMapping("/{id}/3d-model")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<String> delete3DModel(@PathVariable Long id, @RequestParam String filename) {
        try {
            Path filePath = Paths.get(uploadPath, filename);
            Files.deleteIfExists(filePath);

            // 更新数据库中的文物记录
            if (culturalRelicService != null) {
                CulturalRelic relic = culturalRelicService.getById(id);
                if (relic != null) {
                    relic.setModel3dUrl(null);
                    relic.setModel3dUploadTime(null);
                    culturalRelicService.updateById(relic);
                }
            }

            return Result.success("删除成功");
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 获取3D模型信息
     */
    @GetMapping("/{id}/3d-model")
    public Result<Map<String, Object>> get3DModelInfo(@PathVariable Long id) {
        Map<String, Object> result = new HashMap<>();
        result.put("relicId", id);
        
        if (culturalRelicService != null) {
            CulturalRelic relic = culturalRelicService.getById(id);
            if (relic != null && relic.getModel3dUrl() != null) {
                result.put("modelUrl", relic.getModel3dUrl());
                result.put("uploadTime", relic.getModel3dUploadTime());
                result.put("hasModel", true);
            } else {
                result.put("modelUrl", null);
                result.put("hasModel", false);
            }
        } else {
            result.put("modelUrl", null);
            result.put("hasModel", false);
        }

        return Result.success(result);
    }

    /**
     * 保存3D模型链接
     */
    @PostMapping("/{id}/3d-model-url")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Map<String, Object>> save3DModelUrl(
            @PathVariable Long id,
            @RequestBody Map<String, String> request) {
        
        String modelUrl = request.get("modelUrl");
        if (modelUrl == null || modelUrl.trim().isEmpty()) {
            return Result.error("模型链接不能为空");
        }

        try {
            // 更新数据库中的文物记录
            if (culturalRelicService != null) {
                CulturalRelic relic = culturalRelicService.getById(id);
                if (relic != null) {
                    relic.setModel3dUrl(modelUrl.trim());
                    relic.setModel3dUploadTime(LocalDateTime.now());
                    culturalRelicService.updateById(relic);
                    
                    // 返回结果
                    Map<String, Object> result = new HashMap<>();
                    result.put("relicId", id);
                    result.put("modelUrl", modelUrl.trim());
                    result.put("uploadTime", relic.getModel3dUploadTime());
                    
                    return Result.success(result);
                } else {
                    return Result.error("文物不存在");
                }
            }
            
            return Result.error("服务不可用");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("保存失败: " + e.getMessage());
        }
    }

    /**
     * 删除3D模型（智能删除：支持文件和链接）
     */
    @DeleteMapping("/{id}/3d-model-url")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<String> delete3DModelUrl(@PathVariable Long id) {
        try {
            // 更新数据库中的文物记录
            if (culturalRelicService != null) {
                CulturalRelic relic = culturalRelicService.getById(id);
                if (relic != null) {
                    // 如果是本地上传的文件，尝试删除文件
                    String modelUrl = relic.getModel3dUrl();
                    if (modelUrl != null && modelUrl.startsWith(urlPrefix)) {
                        String filename = modelUrl.substring(modelUrl.lastIndexOf("/") + 1);
                        Path filePath = Paths.get(uploadPath, filename);
                        Files.deleteIfExists(filePath);
                    }
                    
                    relic.setModel3dUrl(null);
                    relic.setModel3dUploadTime(null);
                    culturalRelicService.updateById(relic);
                    
                    return Result.success("删除成功");
                } else {
                    return Result.error("文物不存在");
                }
            }
            
            return Result.error("服务不可用");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("删除失败: " + e.getMessage());
        }
    }
}
