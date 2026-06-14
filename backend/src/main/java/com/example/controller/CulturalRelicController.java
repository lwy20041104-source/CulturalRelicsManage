package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import com.example.service.RelicImageRelationService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import com.example.util.FileStorageUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;

import static com.example.util.QRCodeUtil.generateQRCodeLabelBase64;
import static com.example.util.QRCodeUtil.generateRelicQRCodeUrl;

@Slf4j
@RestController
@RequestMapping("/relics")
public class CulturalRelicController {

    private final CulturalRelicService culturalRelicService;
    private final FileStorageUtil fileStorageUtil;
    private final RelicImageRelationService relicImageRelationService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;

    public CulturalRelicController(CulturalRelicService culturalRelicService, 
                                   FileStorageUtil fileStorageUtil,
                                   RelicImageRelationService relicImageRelationService,
                                   SysOperationLogService operationLogService,
                                   UserContextUtil userContextUtil) {
        this.culturalRelicService = culturalRelicService;
        this.fileStorageUtil = fileStorageUtil;
        this.relicImageRelationService = relicImageRelationService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }

    @GetMapping
    public Result<PageResult<CulturalRelic>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String relicName,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String era
    ) {
        return Result.success(culturalRelicService.pageRelics(pageNum, pageSize, relicName, categoryId, status, era));
    }

    @GetMapping("/{id}")
    public Result<CulturalRelic> getById(@PathVariable Long id) {
        return Result.success(culturalRelicService.getById(id));
    }

    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "文物管理", operationContent = "新增文物")
    public Result<CulturalRelic> save(@RequestBody CulturalRelic relic) {
        relic.setCreateTime(LocalDateTime.now());
        relic.setUpdateTime(LocalDateTime.now());
        if (relic.getStatus() == null || relic.getStatus().isEmpty()) {
            relic.setStatus("在库");
        }
        boolean success = culturalRelicService.save(relic);
        if (success) {
            return Result.success("新增成功", relic);
        } else {
            return Result.error("新增失败");
        }
    }

    /**
     * 新增文物（支持图片上传）
     */
    @PostMapping("/with-image")
    @OperationLog(operationType = "新增", operationModule = "文物管理", operationContent = "新增文物（含图片）")
    public Result<Long> saveWithImage(
            @RequestParam("relicName") String relicName,
            @RequestParam(value = "era", required = false) String era,
            @RequestParam(value = "material", required = false) String material,
            @RequestParam(value = "categoryId", required = false) Long categoryId,
            @RequestParam(value = "status", defaultValue = "在库") String status,
            @RequestParam(value = "dimensions", required = false) String dimensions,
            @RequestParam(value = "weight", required = false) Double weight,
            @RequestParam(value = "origin", required = false) String origin,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "imageFile", required = false) MultipartFile imageFile,
            @RequestParam(value = "imageId", required = false) Long imageId) {
        try {
            // 记录请求参数
            log.info("新增文物请求: relicName={}, era={}, material={}, categoryId={}, status={}, hasImage={}",
                     relicName, era, material, categoryId, status, imageFile != null && !imageFile.isEmpty());
            
            // 构建文物对象
            CulturalRelic relic = new CulturalRelic();
            relic.setRelicName(relicName);
            relic.setEra(era);
            relic.setMaterial(material);
            relic.setCategoryId(categoryId);
            relic.setStatus(status);
            relic.setDimensions(dimensions);
            relic.setWeight(weight);
            relic.setOrigin(origin);
            relic.setDescription(description);
            relic.setCreateTime(LocalDateTime.now());
            relic.setUpdateTime(LocalDateTime.now());
            
            // 获取当前登录用户信息
            String uploaderName = userContextUtil.getCurrentUserRealName();
            Long uploaderId = userContextUtil.getCurrentUserId();
            
            // 保存文物和图片
            Long relicId = culturalRelicService.saveWithImage(relic, imageFile, imageId, uploaderId, uploaderName);
            
            log.info("文物保存成功，ID: {}", relicId);
            return Result.success("新增成功", relicId);
        } catch (Exception e) {
            log.error("新增文物失败: {}", e.getMessage(), e);
            return Result.error("新增失败: " + e.getMessage());
        }
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody CulturalRelic relic, javax.servlet.http.HttpServletRequest request) {
        // 1. 获取修改前的数据
        CulturalRelic oldRelic = culturalRelicService.getById(relic.getId());
        
        // 2. 执行更新操作
        relic.setUpdateTime(LocalDateTime.now());
        boolean success = culturalRelicService.updateById(relic);
        
        // 3. 重新查询获取更新后的数据，并记录审计日志（包含数据对比）
        if (success && oldRelic != null) {
            try {
                CulturalRelic newRelic = culturalRelicService.getById(relic.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "修改",
                    "文物管理",
                    "RELIC",
                    relic.getId(),
                    oldRelic,
                    newRelic,
                    ipAddress,
                    "PUT",
                    "/relics"
                );
            } catch (Exception e) {
                // 记录日志失败不影响业务操作
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id, javax.servlet.http.HttpServletRequest request) {
        // 1. 获取删除前的数据
        CulturalRelic oldRelic = culturalRelicService.getById(id);
        
        // 2. 执行删除操作
        boolean success = culturalRelicService.removeById(id);
        
        // 3. 记录审计日志
        if (success && oldRelic != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除",
                    "文物管理",
                    "RELIC",
                    id,
                    oldRelic,
                    null,
                    ipAddress,
                    "DELETE",
                    "/relics/" + id
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }

    @PostMapping("/{id}/images")
    @OperationLog(operationType = "修改", operationModule = "文物管理", operationContent = "上传文物图片")
    public Result<String> uploadImage(@PathVariable Long id, @RequestParam("file") MultipartFile file) throws Exception {
        CulturalRelic relic = culturalRelicService.getById(id);
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }
        
        // 获取当前登录用户信息
        String uploaderName = userContextUtil.getCurrentUserRealName();
        Long uploaderId = userContextUtil.getCurrentUserId();
        
        // 使用新的关联服务上传图片
        String path = relicImageRelationService.uploadAndSetRelicMainImage(id, file, uploaderId, uploaderName);
        
        return Result.success("上传成功", path);
    }
    
    /**
     * 批量删除文物
     */
    @DeleteMapping("/batch")
    @OperationLog(operationType = "删除", operationModule = "文物管理", operationContent = "批量删除文物")
    public Result<Boolean> batchDelete(@RequestBody java.util.List<Long> ids) {
        return Result.success("批量删除成功", culturalRelicService.batchDelete(ids));
    }
    
    /**
     * 批量修改状态
     */
    @PutMapping("/batch/status")
    public Result<Boolean> batchUpdateStatus(@RequestBody java.util.Map<String, Object> params, 
                                             javax.servlet.http.HttpServletRequest request) {
        @SuppressWarnings("unchecked")
        java.util.List<Long> ids = (java.util.List<Long>) params.get("ids");
        String status = (String) params.get("status");
        
        // 记录每个文物的状态变更
        try {
            String realName = userContextUtil.getCurrentUserRealName();
            Long userId = userContextUtil.getCurrentUserId();
            String ipAddress = UserContextUtil.getClientIp(request);
            
            for (Long id : ids) {
                CulturalRelic oldRelic = culturalRelicService.getById(id);
                if (oldRelic != null) {
                    CulturalRelic newRelic = new CulturalRelic();
                    newRelic.setId(id);
                    newRelic.setStatus(status);
                    newRelic.setRelicName(oldRelic.getRelicName());
                    newRelic.setRelicCode(oldRelic.getRelicCode());
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "修改",
                        "文物管理",
                        "RELIC",
                        id,
                        oldRelic,
                        newRelic,
                        ipAddress,
                        "PUT",
                        "/relics/batch/status"
                    );
                }
            }
        } catch (Exception e) {
            log.error("记录审计日志失败: {}", e.getMessage());
        }
        
        return Result.success("批量修改状态成功", culturalRelicService.batchUpdateStatus(ids, status));
    }
    
    /**
     * 导出文物数据（Excel）
     */
    @GetMapping("/export")
    @OperationLog(operationType = "查询", operationModule = "文物管理", operationContent = "导出文物数据(Excel)")
    public void exportExcel(
            @RequestParam(required = false) String relicName,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String era,
            HttpServletResponse response) throws Exception {
        culturalRelicService.exportExcel(relicName, categoryId, status, era, response);
    }
    
    /**
     * 导出文物数据（PDF）
     */
    @GetMapping("/export/pdf")
    @OperationLog(operationType = "查询", operationModule = "文物管理", operationContent = "导出文物数据(PDF)")
    public void exportPdf(
            @RequestParam(required = false) String relicName,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String era,
            HttpServletResponse response) throws Exception {
        culturalRelicService.exportPdf(relicName, categoryId, status, era, response);
    }
    
    /**
     * 导出文物数据（Word）
     */
    @GetMapping("/export/word")
    @OperationLog(operationType = "查询", operationModule = "文物管理", operationContent = "导出文物数据(Word)")
    public void exportWord(
            @RequestParam(required = false) String relicName,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String era,
            HttpServletResponse response) throws Exception {
        culturalRelicService.exportWord(relicName, categoryId, status, era, response);
    }
    
    /**
     * 导入文物数据（Excel）
     */
    @PostMapping("/import")
    @OperationLog(operationType = "新增", operationModule = "文物管理", operationContent = "导入文物数据")
    public Result<String> importExcel(@RequestParam("file") MultipartFile file) throws Exception {
        int count = culturalRelicService.importExcel(file);
        return Result.success("导入成功，共导入 " + count + " 条数据");
    }
    
    /**
     * 下载导入模板
     */
    @GetMapping("/template")
    public void downloadTemplate(HttpServletResponse response) throws Exception {
        culturalRelicService.downloadTemplate(response);
    }
    
    /**
     * 获取可用于修复的文物列表（排除有正在进行修复的文物）
     */
    @GetMapping("/available-for-repair")
    public Result<java.util.List<CulturalRelic>> getAvailableForRepair() {
        return Result.success(culturalRelicService.getAvailableForRepair());
    }

    /**
     * 生成文物二维码
     */
    @GetMapping("/{id}/qrcode")
    @OperationLog(operationType = "查询", operationModule = "文物管理", operationContent = "生成文物二维码")
    public Result<String> generateQRCode(@PathVariable Long id, 
                                         @RequestParam(defaultValue = "http://localhost:5173") String baseUrl) {
        try {
            CulturalRelic relic = culturalRelicService.getById(id);
            if (relic == null) {
                return Result.error("文物不存在");
            }

            // 生成二维码URL（扫描后跳转到文物详情页）
            String qrCodeUrl = generateRelicQRCodeUrl(id, baseUrl);

            // 生成带标签的二维码（包含文物编号和名称）
            String qrCodeBase64 = generateQRCodeLabelBase64(
                qrCodeUrl, 
                relic.getRelicCode(), 
                relic.getRelicName(), 
                200
            );

            if (qrCodeBase64 == null) {
                return Result.error("生成二维码失败");
            }

            return Result.success("生成成功", qrCodeBase64);
        } catch (Exception e) {
            return Result.error("生成二维码失败: " + e.getMessage());
        }
    }

    /**
     * 批量生成文物二维码
     */
    @PostMapping("/batch/qrcode")
    @OperationLog(operationType = "查询", operationModule = "文物管理", operationContent = "批量生成文物二维码")
    public Result<java.util.Map<Long, String>> batchGenerateQRCode(
            @RequestBody java.util.List<Long> ids,
            @RequestParam(defaultValue = "http://localhost:5173") String baseUrl) {
        try {
            java.util.Map<Long, String> qrCodeMap = new java.util.HashMap<>();
            
            for (Long id : ids) {
                CulturalRelic relic = culturalRelicService.getById(id);
                if (relic != null) {
                    String qrCodeUrl = generateRelicQRCodeUrl(id, baseUrl);
                    String qrCodeBase64 = generateQRCodeLabelBase64(
                        qrCodeUrl,
                        relic.getRelicCode(),
                        relic.getRelicName(),
                        200
                    );
                    if (qrCodeBase64 != null) {
                        qrCodeMap.put(id, qrCodeBase64);
                    }
                }
            }

            return Result.success("生成成功", qrCodeMap);
        } catch (Exception e) {
            return Result.error("批量生成二维码失败: " + e.getMessage());
        }
    }
}
