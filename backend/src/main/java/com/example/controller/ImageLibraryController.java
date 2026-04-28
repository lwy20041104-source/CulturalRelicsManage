package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.Result;
import com.example.entity.ImageLibrary;
import com.example.service.ImageLibraryService;
import com.example.service.SysOperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 图片库管理控制器
 */
@RestController
@RequestMapping("/images")
public class ImageLibraryController {
    
    @Autowired
    private ImageLibraryService imageLibraryService;
    
    @Autowired
    private SysOperationLogService operationLogService;
    
    @Autowired
    private com.example.util.UserContextUtil userContextUtil;
    
    /**
     * 上传图片
     */
    @PostMapping("/upload")
    @OperationLog(operationType = "新增", operationModule = "图片管理", operationContent = "上传图片")
    public Result<ImageLibrary> uploadImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "imageName", required = false) String imageName,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "tags", required = false) String tags,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "relicId", required = false) Long relicId) throws IOException {
        
        // 验证必须关联文物
        if (relicId == null) {
            return Result.error("上传失败：图片必须关联一个文物");
        }
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        
        ImageLibrary image = imageLibraryService.uploadImage(file, imageName, category, 
                                                            tags, description, null, username);
        
        // 关联到文物
        if (image != null && image.getId() != null) {
            imageLibraryService.linkToReference(image.getId(), "relic", relicId);
        }
        
        return Result.success("上传成功", image);
    }
    
    /**
     * 批量上传图片
     */
    @PostMapping("/batch-upload")
    @OperationLog(operationType = "新增", operationModule = "图片管理", operationContent = "批量上传图片")
    public Result<List<ImageLibrary>> batchUpload(
            @RequestParam("files") List<MultipartFile> files,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "relicId", required = false) Long relicId) throws IOException {
        
        // 验证必须关联文物
        if (relicId == null) {
            return Result.error("上传失败：图片必须关联一个文物");
        }
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        
        List<ImageLibrary> images = imageLibraryService.batchUpload(files, category, null, username);
        
        // 批量关联到文物
        if (images != null && !images.isEmpty()) {
            for (ImageLibrary image : images) {
                if (image != null && image.getId() != null) {
                    imageLibraryService.linkToReference(image.getId(), "relic", relicId);
                }
            }
        }
        
        return Result.success("批量上传成功", images);
    }
    
    /**
     * 分页查询图片
     */
    @GetMapping
    public Result<Map<String, Object>> getImagePage(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "20") int pageSize,
            @RequestParam(required = false) String imageName,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) Long uploaderId,
            @RequestParam(required = false) String tags) {
        
        com.example.common.PageResult<ImageLibrary> pageResult = imageLibraryService.getImagePage(
                pageNum, pageSize, imageName, category, uploaderId, tags);
        
        Map<String, Object> result = new HashMap<>();
        result.put("records", pageResult.getRecords());
        result.put("total", pageResult.getTotal());
        result.put("size", pageResult.getSize());
        result.put("current", pageResult.getCurrent());
        result.put("pages", (pageResult.getTotal() + pageResult.getSize() - 1) / pageResult.getSize());
        
        return Result.success(result);
    }
    
    /**
     * 获取图片详情
     */
    @GetMapping("/{id}")
    public Result<ImageLibrary> getImageById(@PathVariable Long id) {
        ImageLibrary image = imageLibraryService.getById(id);
        if (image == null || image.getStatus() == 0) {
            return Result.error("图片不存在");
        }
        
        // 增加浏览次数
        imageLibraryService.incrementViewCount(id);
        
        return Result.success(image);
    }
    
    /**
     * 更新图片信息
     */
    @PutMapping("/{id}")
    public Result<String> updateImage(
            @PathVariable Long id,
            @RequestParam(required = false) String imageName,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String tags,
            @RequestParam(required = false) String description,
            @RequestParam(required = false) Integer isPublic,
            HttpServletRequest request) {
        
        // 1. 获取修改前的数据
        ImageLibrary oldImage = imageLibraryService.getById(id);
        
        // 2. 执行更新操作
        boolean success = imageLibraryService.updateImageInfo(id, imageName, category, 
                                                             tags, description, isPublic);
        
        // 3. 记录审计日志
        if (success && oldImage != null) {
            try {
                ImageLibrary newImage = imageLibraryService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "修改",
                    "图片管理",
                    "IMAGE",
                    id,
                    oldImage,
                    newImage,
                    ipAddress,
                    "PUT",
                    "/images/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return success ? Result.success("更新成功") : Result.error("更新失败");
    }
    
    /**
     * 删除图片(逻辑删除)
     */
    @DeleteMapping("/{id}")
    public Result<String> deleteImage(@PathVariable Long id, HttpServletRequest request) {
        // 1. 获取删除前的数据
        ImageLibrary oldImage = imageLibraryService.getById(id);
        
        // 2. 执行删除操作
        boolean success = imageLibraryService.deleteImage(id);
        
        // 3. 记录审计日志
        if (success && oldImage != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除",
                    "图片管理",
                    "IMAGE",
                    id,
                    oldImage,
                    null,
                    ipAddress,
                    "DELETE",
                    "/images/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return success ? Result.success("删除成功") : Result.error("删除失败");
    }
    
    /**
     * 批量删除图片
     */
    @DeleteMapping("/batch")
    @OperationLog(operationType = "删除", operationModule = "图片管理", operationContent = "批量删除图片")
    public Result<String> batchDelete(@RequestBody List<Long> ids) {
        boolean success = imageLibraryService.batchDelete(ids);
        return success ? Result.success("批量删除成功") : Result.error("批量删除失败");
    }
    
    /**
     * 物理删除图片
     */
    @DeleteMapping("/{id}/physical")
    @OperationLog(operationType = "删除", operationModule = "图片管理", operationContent = "物理删除图片")
    public Result<String> physicalDelete(@PathVariable Long id) throws IOException {
        boolean success = imageLibraryService.physicalDelete(id);
        return success ? Result.success("物理删除成功") : Result.error("物理删除失败");
    }
    
    /**
     * 关联图片到对象
     */
    @PutMapping("/{id}/link")
    @OperationLog(operationType = "修改", operationModule = "图片管理", operationContent = "关联图片")
    public Result<String> linkToReference(
            @PathVariable Long id,
            @RequestParam String referenceType,
            @RequestParam Long referenceId) {
        
        boolean success = imageLibraryService.linkToReference(id, referenceType, referenceId);
        return success ? Result.success("关联成功") : Result.error("关联失败");
    }
    
    /**
     * 获取关联的图片列表
     */
    @GetMapping("/reference/{referenceType}/{referenceId}")
    public Result<List<ImageLibrary>> getImagesByReference(
            @PathVariable String referenceType,
            @PathVariable Long referenceId) {
        
        List<ImageLibrary> images = imageLibraryService.getImagesByReference(referenceType, referenceId);
        return Result.success(images);
    }
    
    /**
     * 下载图片
     */
    @GetMapping("/{id}/download")
    @OperationLog(operationType = "查询", operationModule = "图片管理", operationContent = "下载图片")
    public void downloadImage(@PathVariable Long id, HttpServletResponse response) throws IOException {
        ImageLibrary image = imageLibraryService.getById(id);
        if (image == null || image.getStatus() == 0) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "图片不存在");
            return;
        }
        
        // 增加下载次数
        imageLibraryService.incrementDownloadCount(id);
        
        File file = new File(image.getFilePath());
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "文件不存在");
            return;
        }
        
        response.setContentType(image.getFileType());
        response.setHeader("Content-Disposition", 
                          "attachment; filename=\"" + image.getOriginalName() + "\"");
        response.setContentLengthLong(file.length());
        
        try (FileInputStream fis = new FileInputStream(file);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
            os.flush();
        }
    }
    
    /**
     * 搜索图片
     */
    @GetMapping("/search")
    public Result<List<ImageLibrary>> searchImages(@RequestParam String keyword) {
        List<ImageLibrary> images = imageLibraryService.searchImages(keyword);
        return Result.success(images);
    }
    
    /**
     * 获取统计信息
     */
    @GetMapping("/statistics")
    public Result<Map<String, Object>> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("categoryStats", imageLibraryService.getCategoryStats());
        stats.put("uploaderStats", imageLibraryService.getUploaderStats());
        stats.put("storageStats", imageLibraryService.getStorageStats());
        return Result.success(stats);
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
