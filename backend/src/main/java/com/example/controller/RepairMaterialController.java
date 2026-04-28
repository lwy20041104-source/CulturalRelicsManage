package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.RepairMaterial;
import com.example.entity.RepairRecordMaterial;
import com.example.service.RepairMaterialService;
import com.example.service.SysOperationLogService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

/**
 * 修复材料控制器
 */
@Slf4j
@RestController
@RequestMapping("/repair-materials")
public class RepairMaterialController {
    
    @Autowired
    private RepairMaterialService materialService;
    
    @Autowired
    private SysOperationLogService operationLogService;
    
    @Autowired
    private com.example.util.UserContextUtil userContextUtil;
    
    /**
     * 分页查询材料列表
     */
    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'REPAIR_EXPERT')")
    public Result<PageResult<RepairMaterial>> getMaterialList(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String materialName,
            @RequestParam(required = false) String category) {
        try {
            PageResult<RepairMaterial> result = materialService.getMaterialList(
                    pageNum, pageSize, materialName, category);
            return Result.success(result);
        } catch (Exception e) {
            log.error("查询材料列表失败", e);
            return Result.error("查询材料列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取所有材料（用于下拉选择）
     */
    @GetMapping("/all")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'REPAIR_EXPERT')")
    public Result<List<RepairMaterial>> getAllMaterials() {
        try {
            List<RepairMaterial> materials = materialService.getAllMaterials();
            return Result.success(materials);
        } catch (Exception e) {
            log.error("获取材料列表失败", e);
            return Result.error("获取材料列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 根据ID查询材料
     */
    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'REPAIR_EXPERT')")
    public Result<RepairMaterial> getMaterialById(@PathVariable Long id) {
        try {
            RepairMaterial material = materialService.getMaterialById(id);
            if (material == null) {
                return Result.error("材料不存在");
            }
            return Result.success(material);
        } catch (Exception e) {
            log.error("查询材料失败", e);
            return Result.error("查询材料失败: " + e.getMessage());
        }
    }
    
    /**
     * 创建材料
     */
    @PostMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    @OperationLog(operationType = "新增", operationModule = "材料管理", operationContent = "创建修复材料")
    public Result<RepairMaterial> createMaterial(@RequestBody RepairMaterial material) {
        try {
            RepairMaterial created = materialService.createMaterial(material);
            return Result.success(created);
        } catch (Exception e) {
            log.error("创建材料失败", e);
            return Result.error("创建材料失败: " + e.getMessage());
        }
    }
    
    /**
     * 更新材料
     */
    @PutMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Void> updateMaterial(@PathVariable Long id, @RequestBody RepairMaterial material, 
                                      HttpServletRequest request) {
        try {
            // 1. 获取修改前的数据
            RepairMaterial oldMaterial = materialService.getMaterialById(id);
            
            // 2. 执行更新操作
            material.setId(id);
            materialService.updateMaterial(material);
            
            // 3. 记录审计日志
            if (oldMaterial != null) {
                try {
                    RepairMaterial newMaterial = materialService.getMaterialById(id);
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "修改",
                        "材料管理",
                        "MATERIAL",
                        id,
                        oldMaterial,
                        newMaterial,
                        ipAddress,
                        "PUT",
                        "/repair-materials/" + id
                    );
                } catch (Exception e) {
                    log.error("记录审计日志失败", e);
                }
            }
            
            return Result.success("更新成功", null);
        } catch (Exception e) {
            log.error("更新材料失败", e);
            return Result.error("更新材料失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除材料
     */
    @DeleteMapping("/{id}")
    @PreAuthorize("hasAnyRole('ADMIN')")
    public Result<Void> deleteMaterial(@PathVariable Long id, HttpServletRequest request) {
        try {
            // 1. 获取删除前的数据
            RepairMaterial oldMaterial = materialService.getMaterialById(id);
            
            // 2. 执行删除操作
            materialService.deleteMaterial(id);
            
            // 3. 记录审计日志
            if (oldMaterial != null) {
                try {
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "删除",
                        "材料管理",
                        "MATERIAL",
                        id,
                        oldMaterial,
                        null,
                        ipAddress,
                        "DELETE",
                        "/repair-materials/" + id
                    );
                } catch (Exception e) {
                    log.error("记录审计日志失败", e);
                }
            }
            
            return Result.success("删除成功", null);
        } catch (Exception e) {
            log.error("删除材料失败", e);
            return Result.error("删除材料失败: " + e.getMessage());
        }
    }
    
    /**
     * 更新库存
     */
    @PutMapping("/{id}/stock")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Void> updateStock(@PathVariable Long id, @RequestParam double quantity, 
                                    HttpServletRequest request) {
        try {
            // 1. 获取修改前的数据
            RepairMaterial oldMaterial = materialService.getMaterialById(id);
            
            // 2. 执行更新操作
            materialService.updateStock(id, quantity);
            
            // 3. 记录审计日志
            if (oldMaterial != null) {
                try {
                    RepairMaterial newMaterial = materialService.getMaterialById(id);
                    String realName = userContextUtil.getCurrentUserRealName();
                    Long userId = userContextUtil.getCurrentUserId();
                    String ipAddress = getClientIp(request);
                    
                    operationLogService.logDataChange(
                        userId,
                        realName,
                        "更新库存",
                        "材料管理",
                        "MATERIAL",
                        id,
                        oldMaterial,
                        newMaterial,
                        ipAddress,
                        "PUT",
                        "/repair-materials/" + id + "/stock"
                    );
                } catch (Exception e) {
                    log.error("记录审计日志失败", e);
                }
            }
            
            return Result.success("库存更新成功", null);
        } catch (Exception e) {
            log.error("更新库存失败", e);
            return Result.error("更新库存失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取材料类别列表
     */
    @GetMapping("/categories")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'REPAIR_EXPERT')")
    public Result<List<String>> getCategories() {
        try {
            List<String> categories = materialService.getCategories();
            return Result.success(categories);
        } catch (Exception e) {
            log.error("获取类别列表失败", e);
            return Result.error("获取类别列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取库存不足的材料
     */
    @GetMapping("/low-stock")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<List<RepairMaterial>> getLowStockMaterials(
            @RequestParam(defaultValue = "10") double threshold) {
        try {
            List<RepairMaterial> materials = materialService.getLowStockMaterials(threshold);
            return Result.success(materials);
        } catch (Exception e) {
            log.error("查询库存不足材料失败", e);
            return Result.error("查询库存不足材料失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取材料使用统计
     */
    @GetMapping("/{id}/statistics")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    public Result<Map<String, Object>> getMaterialStatistics(@PathVariable Long id) {
        try {
            Map<String, Object> stats = materialService.getMaterialStatistics(id);
            return Result.success(stats);
        } catch (Exception e) {
            log.error("获取材料统计失败", e);
            return Result.error("获取材料统计失败: " + e.getMessage());
        }
    }
    
    /**
     * 添加材料使用记录
     */
    @PostMapping("/usage")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'REPAIR_EXPERT')")
    @OperationLog(operationType = "新增", operationModule = "材料管理", operationContent = "添加材料使用记录")
    public Result<RepairRecordMaterial> addMaterialUsage(@RequestBody RepairRecordMaterial recordMaterial) {
        try {
            RepairRecordMaterial created = materialService.addMaterialUsage(recordMaterial);
            return Result.success(created);
        } catch (Exception e) {
            log.error("添加材料使用记录失败", e);
            return Result.error("添加材料使用记录失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取修复记录的材料列表
     */
    @GetMapping("/repair-record/{repairRecordId}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR', 'REPAIR_EXPERT')")
    public Result<List<RepairRecordMaterial>> getRepairRecordMaterials(@PathVariable Long repairRecordId) {
        try {
            List<RepairRecordMaterial> materials = materialService.getRepairRecordMaterials(repairRecordId);
            return Result.success(materials);
        } catch (Exception e) {
            log.error("获取修复记录材料列表失败", e);
            return Result.error("获取修复记录材料列表失败: " + e.getMessage());
        }
    }
    
    /**
     * 删除材料使用记录
     */
    @DeleteMapping("/usage/{id}")
    @PreAuthorize("hasAnyRole('ADMIN', 'CURATOR')")
    @OperationLog(operationType = "删除", operationModule = "材料管理", operationContent = "删除材料使用记录")
    public Result<Void> deleteMaterialUsage(@PathVariable Long id) {
        try {
            materialService.deleteMaterialUsage(id);
            return Result.success("删除成功", null);
        } catch (Exception e) {
            log.error("删除材料使用记录失败", e);
            return Result.error("删除材料使用记录失败: " + e.getMessage());
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
}
