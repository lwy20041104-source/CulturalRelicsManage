package com.example.controller;

import com.example.common.Result;
import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import com.example.service.Relic3DService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * 3D文物模型管理控制器
 */
@Slf4j
@RestController
@RequestMapping("/relics")
@CrossOrigin
public class Relic3DController {

    private final Relic3DService relic3DService;
    private final CulturalRelicService culturalRelicService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;

    public Relic3DController(Relic3DService relic3DService,
                             CulturalRelicService culturalRelicService,
                             SysOperationLogService operationLogService,
                             UserContextUtil userContextUtil) {
        this.relic3DService = relic3DService;
        this.culturalRelicService = culturalRelicService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }

    /**
     * 上传3D模型
     */
    @PostMapping("/{id}/3d-model")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Map<String, Object>> upload3DModel(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file,
            HttpServletRequest httpRequest) {
        
        try {
            // 获取操作前的文物数据（用于审计日志）
            CulturalRelic oldRelic = culturalRelicService.getById(id);
            if (oldRelic == null) {
                return Result.error("文物不存在");
            }
            CulturalRelic oldRelicCopy = cloneRelic(oldRelic);

            // 委托给Service层处理
            Map<String, Object> result = relic3DService.upload3DModel(id, file);

            // 记录审计日志
            try {
                CulturalRelic newRelic = culturalRelicService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId, realName, "上传3D模型", "3D模型管理",
                    "RELIC", id, oldRelicCopy, newRelic,
                    ipAddress, "POST", "/relics/" + id + "/3d-model"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage(), e);
            }

            return Result.success(result);

        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            log.error("文件上传失败: {}", e.getMessage(), e);
            return Result.error("文件上传失败: " + e.getMessage());
        }
    }

    /**
     * 删除3D模型文件
     */
    @DeleteMapping("/{id}/3d-model")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<String> delete3DModel(@PathVariable Long id, @RequestParam String filename) {
        try {
            relic3DService.delete3DModelFile(id, filename);
            return Result.success("删除成功");
        } catch (Exception e) {
            log.error("删除失败: {}", e.getMessage(), e);
            return Result.error("删除失败: " + e.getMessage());
        }
    }

    /**
     * 获取3D模型信息
     */
    @GetMapping("/{id}/3d-model")
    public Result<Map<String, Object>> get3DModelInfo(@PathVariable Long id) {
        return Result.success(relic3DService.get3DModelInfo(id));
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
        
        try {
            // 获取操作前的文物数据（用于审计日志）
            CulturalRelic oldRelic = culturalRelicService.getById(id);
            if (oldRelic == null) {
                return Result.error("文物不存在");
            }
            CulturalRelic oldRelicCopy = cloneRelic(oldRelic);

            Map<String, Object> result = relic3DService.save3DModelUrl(id, modelUrl);

            // 记录审计日志
            try {
                CulturalRelic newRelic = culturalRelicService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId, realName, "保存3D模型链接", "3D模型管理",
                    "RELIC", id, oldRelicCopy, newRelic,
                    ipAddress, "POST", "/relics/" + id + "/3d-model-url"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage(), e);
            }
            
            return Result.success(result);
        } catch (IllegalArgumentException e) {
            return Result.error(e.getMessage());
        } catch (Exception e) {
            log.error("保存失败: {}", e.getMessage(), e);
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
            // 获取操作前的文物数据（用于审计日志）
            CulturalRelic oldRelic = culturalRelicService.getById(id);
            if (oldRelic == null) {
                return Result.error("文物不存在");
            }
            CulturalRelic oldRelicCopy = cloneRelic(oldRelic);

            relic3DService.delete3DModelUrl(id);

            // 记录审计日志
            try {
                CulturalRelic newRelic = culturalRelicService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId, realName, "删除3D模型", "3D模型管理",
                    "RELIC", id, oldRelicCopy, newRelic,
                    ipAddress, "DELETE", "/relics/" + id + "/3d-model-url"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage(), e);
            }
            
            return Result.success("删除成功");
        } catch (Exception e) {
            log.error("删除3D模型异常: {}", e.getMessage(), e);
            return Result.error("删除失败: " + e.getMessage());
        }
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
