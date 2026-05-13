package com.example.controller;

import com.example.common.Result;
import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
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
    
    @Autowired(required = false)
    private SysOperationLogService operationLogService;
    
    @Autowired(required = false)
    private UserContextUtil userContextUtil;

    /**
     * 上传3D模型
     */
    @PostMapping("/{id}/3d-model")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Map<String, Object>> upload3DModel(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file,
            HttpServletRequest httpRequest) {
        
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
            // 1. 获取操作前的文物数据
            CulturalRelic oldRelic = null;
            if (culturalRelicService != null) {
                oldRelic = culturalRelicService.getById(id);
                if (oldRelic == null) {
                    return Result.error("文物不存在");
                }
                // 创建副本用于审计日志
                oldRelic = cloneRelic(oldRelic);
            }
            
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

            // 2. 更新数据库中的文物记录
            if (culturalRelicService != null) {
                CulturalRelic relic = culturalRelicService.getById(id);
                if (relic != null) {
                    relic.setModel3dUrl(modelUrl);
                    relic.setModel3dUploadTime(LocalDateTime.now());
                    culturalRelicService.updateById(relic);
                }
            }

            // 3. 记录审计日志
            if (oldRelic != null) {
                try {
                    CulturalRelic newRelic = culturalRelicService.getById(id);
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(httpRequest);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "上传3D模型",
                        "3D模型管理",
                        "RELIC",
                        id,
                        oldRelic,
                        newRelic,
                        ipAddress,
                        "POST",
                        "/relics/" + id + "/3d-model"
                    );
                } catch (Exception e) {
                    System.err.println("记录审计日志失败: " + e.getMessage());
                    e.printStackTrace();
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
            @RequestBody Map<String, String> request,
            HttpServletRequest httpRequest) {
        
        String modelUrl = request.get("modelUrl");
        if (modelUrl == null || modelUrl.trim().isEmpty()) {
            return Result.error("模型链接不能为空");
        }

        try {
            // 1. 获取操作前的文物数据
            CulturalRelic oldRelic = null;
            if (culturalRelicService != null) {
                oldRelic = culturalRelicService.getById(id);
                if (oldRelic == null) {
                    return Result.error("文物不存在");
                }
                // 创建副本用于审计日志
                oldRelic = cloneRelic(oldRelic);
            } else {
                return Result.error("服务不可用");
            }
            
            // 2. 更新数据库中的文物记录
            CulturalRelic relic = culturalRelicService.getById(id);
            relic.setModel3dUrl(modelUrl.trim());
            relic.setModel3dUploadTime(LocalDateTime.now());
            culturalRelicService.updateById(relic);
            
            // 3. 记录审计日志
            try {
                CulturalRelic newRelic = culturalRelicService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                System.out.println("========== 3D模型审计日志调试 ==========");
                System.out.println("oldRelic: " + oldRelic);
                System.out.println("oldRelic.model3dUrl: " + (oldRelic != null ? oldRelic.getModel3dUrl() : "null"));
                System.out.println("newRelic: " + newRelic);
                System.out.println("newRelic.model3dUrl: " + (newRelic != null ? newRelic.getModel3dUrl() : "null"));
                System.out.println("userId: " + userId);
                System.out.println("realName: " + realName);
                System.out.println("========================================");
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "保存3D模型链接",
                    "3D模型管理",
                    "RELIC",
                    id,
                    oldRelic,
                    newRelic,
                    ipAddress,
                    "POST",
                    "/relics/" + id + "/3d-model-url"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
                e.printStackTrace();
            }
            
            // 返回结果
            Map<String, Object> result = new HashMap<>();
            result.put("relicId", id);
            result.put("modelUrl", modelUrl.trim());
            result.put("uploadTime", relic.getModel3dUploadTime());
            
            return Result.success(result);
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
    public Result<String> delete3DModelUrl(@PathVariable Long id, HttpServletRequest httpRequest) {
        try {
            // 1. 获取操作前的文物数据
            CulturalRelic oldRelic = null;
            if (culturalRelicService != null) {
                oldRelic = culturalRelicService.getById(id);
                if (oldRelic == null) {
                    return Result.error("文物不存在");
                }
                // 创建副本用于审计日志
                oldRelic = cloneRelic(oldRelic);
            } else {
                return Result.error("服务不可用");
            }
            
            // 2. 更新数据库中的文物记录
            CulturalRelic relic = culturalRelicService.getById(id);
            
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
            
            // 3. 记录审计日志
            try {
                CulturalRelic newRelic = culturalRelicService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除3D模型",
                    "3D模型管理",
                    "RELIC",
                    id,
                    oldRelic,
                    newRelic,
                    ipAddress,
                    "DELETE",
                    "/relics/" + id + "/3d-model-url"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
                e.printStackTrace();
            }
            
            return Result.success("删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("删除失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取客户端IP地址
     */
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip;
    }
    
    /**
     * 克隆文物对象（用于审计日志）
     */
    private CulturalRelic cloneRelic(CulturalRelic relic) {
        if (relic == null) {
            return null;
        }
        CulturalRelic clone = new CulturalRelic();
        clone.setId(relic.getId());
        clone.setRelicCode(relic.getRelicCode());
        clone.setRelicName(relic.getRelicName());
        clone.setCategoryId(relic.getCategoryId());
        clone.setCategoryName(relic.getCategoryName());
        clone.setEra(relic.getEra());
        clone.setMaterial(relic.getMaterial());
        clone.setOrigin(relic.getOrigin());
        clone.setDimensions(relic.getDimensions());
        clone.setWeight(relic.getWeight());
        clone.setDescription(relic.getDescription());
        clone.setStatus(relic.getStatus());
        clone.setImagePath(relic.getImagePath());
        clone.setModel3dUrl(relic.getModel3dUrl());
        clone.setModel3dUploadTime(relic.getModel3dUploadTime());
        clone.setCreateTime(relic.getCreateTime());
        clone.setUpdateTime(relic.getUpdateTime());
        return clone;
    }
}
