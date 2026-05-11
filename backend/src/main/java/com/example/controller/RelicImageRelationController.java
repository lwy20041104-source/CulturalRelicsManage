package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.Result;
import com.example.entity.RelicImageRelation;
import com.example.service.RelicImageRelationService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 文物图片关联控制器
 */
@RestController
@RequestMapping("/relic-images")
public class RelicImageRelationController {
    
    private final RelicImageRelationService relicImageRelationService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;
    
    public RelicImageRelationController(RelicImageRelationService relicImageRelationService,
                                       SysOperationLogService operationLogService,
                                       com.example.util.UserContextUtil userContextUtil) {
        this.relicImageRelationService = relicImageRelationService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }
    
    /**
     * 为文物上传并设置主图
     */
    @PostMapping("/upload/{relicId}")
    @OperationLog(operationType = "新增", operationModule = "文物图片管理", operationContent = "上传文物主图")
    public Result<String> uploadRelicImage(
            @PathVariable Long relicId,
            @RequestParam("file") MultipartFile file) {
        try {
            // 获取当前登录用户信息
            String uploaderName = userContextUtil.getCurrentUserRealName();
            Long uploaderId = userContextUtil.getCurrentUserId();
            
            String imagePath = relicImageRelationService.uploadAndSetRelicMainImage(
                    relicId, file, uploaderId, uploaderName);
            return Result.success("上传成功", imagePath);
        } catch (Exception e) {
            return Result.error("上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 为文物设置主图（从已有图片库中选择）
     */
    @PostMapping("/set")
    public Result<Boolean> setRelicMainImage(
            @RequestParam Long relicId,
            @RequestParam Long imageId,
            HttpServletRequest request) {
        try {
            // 1. 获取修改前的数据
            RelicImageRelation oldRelation = relicImageRelationService.getRelicMainImage(relicId);
            
            // 2. 执行设置操作
            boolean success = relicImageRelationService.setRelicMainImage(relicId, imageId);
            
            // 3. 记录审计日志
            if (success) {
                try {
                    RelicImageRelation newRelation = relicImageRelationService.getRelicMainImage(relicId);
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "设置主图",
                        "文物图片管理",
                        "RELIC_IMAGE",
                        relicId,
                        oldRelation,
                        newRelation,
                        ipAddress,
                        "POST",
                        "/relic-images/set"
                    );
                } catch (Exception e) {
                    System.err.println("记录审计日志失败: " + e.getMessage());
                }
            }
            
            return success ? Result.success("设置成功", true) : Result.error("设置失败");
        } catch (Exception e) {
            return Result.error("设置失败: " + e.getMessage());
        }
    }
    
    /**
     * 移除文物主图
     */
    @DeleteMapping("/remove/{relicId}")
    public Result<Boolean> removeRelicMainImage(@PathVariable Long relicId, HttpServletRequest request) {
        // 1. 获取删除前的数据
        RelicImageRelation oldRelation = relicImageRelationService.getRelicMainImage(relicId);
        
        // 2. 执行移除操作
        boolean success = relicImageRelationService.removeRelicMainImage(relicId);
        
        // 3. 记录审计日志
        if (success && oldRelation != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "移除主图",
                    "文物图片管理",
                    "RELIC_IMAGE",
                    relicId,
                    oldRelation,
                    null,
                    ipAddress,
                    "DELETE",
                    "/relic-images/remove/" + relicId
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return success ? Result.success("移除成功", true) : Result.error("移除失败");
    }
    
    /**
     * 获取文物的主图信息
     */
    @GetMapping("/relic/{relicId}")
    public Result<RelicImageRelation> getRelicMainImage(@PathVariable Long relicId) {
        RelicImageRelation relation = relicImageRelationService.getRelicMainImage(relicId);
        return Result.success(relation);
    }
    
    /**
     * 获取文物的所有图片（支持多图片）
     */
    @GetMapping("/list/{relicId}")
    public Result<List<RelicImageRelation>> getRelicImages(@PathVariable Long relicId) {
        List<RelicImageRelation> images = relicImageRelationService.getRelicImages(relicId);
        return Result.success(images);
    }
    
    /**
     * 批量上传文物图片
     */
    @PostMapping("/batch-upload/{relicId}")
    @OperationLog(operationType = "新增", operationModule = "文物图片管理", operationContent = "批量上传文物图片")
    public Result<Map<String, Object>> batchUploadImages(
            @PathVariable Long relicId,
            @RequestParam("files") MultipartFile[] files) {
        try {
            if (files == null || files.length == 0) {
                return Result.error("请选择要上传的文件");
            }
            
            // 限制最多上传10张
            if (files.length > 10) {
                return Result.error("最多只能上传10张图片");
            }
            
            // 获取当前登录用户信息
            String uploaderName = userContextUtil.getCurrentUserRealName();
            Long uploaderId = userContextUtil.getCurrentUserId();
            
            // 批量上传
            Map<String, Object> result = relicImageRelationService.batchUploadAndAddImages(
                relicId, files, uploaderId, uploaderName);
            
            return Result.success("上传完成", result);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("上传失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除文物的某张图片
     */
    @DeleteMapping("/{relicId}/{imageId}")
    public Result<Boolean> removeImage(
            @PathVariable Long relicId,
            @PathVariable Long imageId,
            HttpServletRequest request) {
        try {
            // 1. 获取删除前的数据
            RelicImageRelation oldRelation = relicImageRelationService.getByImageId(imageId);
            
            // 2. 执行删除操作
            boolean success = relicImageRelationService.removeRelicImage(relicId, imageId);
            
            // 3. 记录审计日志
            if (success && oldRelation != null) {
                try {
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "删除图片",
                        "文物图片管理",
                        "RELIC_IMAGE",
                        relicId,
                        oldRelation,
                        null,
                        ipAddress,
                        "DELETE",
                        "/relic-images/" + relicId + "/" + imageId
                    );
                } catch (Exception e) {
                    System.err.println("记录审计日志失败: " + e.getMessage());
                }
            }
            
            return success ? Result.success("删除成功", true) : Result.error("删除失败");
        } catch (Exception e) {
            return Result.error("删除失败: " + e.getMessage());
        }
    }
    
    /**
     * 设置主图
     */
    @PutMapping("/set-main")
    public Result<Boolean> setMainImage(@RequestBody Map<String, Long> params, HttpServletRequest request) {
        try {
            Long relicId = params.get("relicId");
            Long imageId = params.get("imageId");
            
            if (relicId == null || imageId == null) {
                return Result.error("参数错误");
            }
            
            // 1. 获取修改前的数据
            RelicImageRelation oldRelation = relicImageRelationService.getRelicMainImage(relicId);
            
            // 2. 执行设置操作
            boolean success = relicImageRelationService.setMainImage(relicId, imageId);
            
            // 3. 记录审计日志
            if (success) {
                try {
                    RelicImageRelation newRelation = relicImageRelationService.getRelicMainImage(relicId);
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "设置主图",
                        "文物图片管理",
                        "RELIC_IMAGE",
                        relicId,
                        oldRelation,
                        newRelation,
                        ipAddress,
                        "PUT",
                        "/relic-images/set-main"
                    );
                } catch (Exception e) {
                    System.err.println("记录审计日志失败: " + e.getMessage());
                }
            }
            
            return success ? Result.success("主图设置成功", true) : Result.error("设置失败");
        } catch (Exception e) {
            return Result.error("设置失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取文物的主图路径
     */
    @GetMapping("/path/{relicId}")
    public Result<String> getRelicImagePath(@PathVariable Long relicId) {
        String path = relicImageRelationService.getRelicImagePath(relicId);
        return Result.success(path);
    }
    
    /**
     * 批量获取文物的图片路径
     */
    @PostMapping("/paths")
    public Result<Map<Long, String>> getRelicImagePaths(@RequestBody List<Long> relicIds) {
        Map<Long, String> paths = relicImageRelationService.getRelicImagePaths(relicIds);
        return Result.success(paths);
    }
    
    /**
     * 根据图片ID查询关联的文物
     */
    @GetMapping("/image/{imageId}")
    public Result<RelicImageRelation> getByImageId(@PathVariable Long imageId) {
        RelicImageRelation relation = relicImageRelationService.getByImageId(imageId);
        return Result.success(relation);
    }
    
    /**
     * 统计有主图和无主图的文物数量
     */
    @GetMapping("/statistics")
    public Result<Map<String, Integer>> getStatistics() {
        Map<String, Integer> stats = new java.util.HashMap<>();
        stats.put("withImage", relicImageRelationService.countRelicsWithImage());
        stats.put("withoutImage", relicImageRelationService.countRelicsWithoutImage());
        return Result.success(stats);
    }
    
    /**
     * 查询所有关联
     */
    @GetMapping("/all")
    public Result<List<RelicImageRelation>> listAll() {
        List<RelicImageRelation> relations = relicImageRelationService.listAll();
        return Result.success(relations);
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
}
