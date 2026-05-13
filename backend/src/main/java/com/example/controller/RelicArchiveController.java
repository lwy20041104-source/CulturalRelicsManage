package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.ArchiveDocument;
import com.example.entity.ArchiveHistory;
import com.example.entity.RelicArchive;
import com.example.service.RelicArchiveService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 文物档案管理控制器
 */
@RestController
@RequestMapping("/archives")
public class RelicArchiveController {
    
    @Autowired
    private RelicArchiveService archiveService;
    
    @Autowired
    private SysOperationLogService operationLogService;
    
    @Autowired
    private UserContextUtil userContextUtil;
    
    /**
     * 分页查询档案列表
     */
    @GetMapping
    public Result<PageResult<RelicArchive>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String archiveCode,
            @RequestParam(required = false) String archiveType,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Long relicId) {
        return Result.success(archiveService.pageArchives(pageNum, pageSize, archiveCode, archiveType, status, relicId));
    }

    
    /**
     * 获取档案详情
     */
    @GetMapping("/{id}")
    public Result<RelicArchive> getById(@PathVariable Long id) {
        return Result.success(archiveService.getArchiveDetail(id));
    }
    
    /**
     * 根据文物ID获取档案
     */
    @GetMapping("/relic/{relicId}")
    public Result<RelicArchive> getByRelicId(@PathVariable Long relicId) {
        return Result.success(archiveService.getArchiveByRelicId(relicId));
    }
    
    /**
     * 创建档案
     */
    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "档案管理", operationContent = "创建文物档案")
    public Result<Long> create(@RequestBody RelicArchive archive) {
        return Result.success("创建成功", archiveService.createArchive(archive));
    }
    
    /**
     * 更新档案
     */
    @PutMapping
    public Result<Boolean> update(@RequestBody RelicArchive archive, HttpServletRequest request) {
        // 1. 获取修改前的数据
        RelicArchive oldArchive = archiveService.getArchiveDetail(archive.getId());
        
        // 2. 执行更新操作
        boolean success = archiveService.updateArchive(archive);
        
        // 3. 记录审计日志
        if (success && oldArchive != null) {
            try {
                RelicArchive newArchive = archiveService.getArchiveDetail(archive.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "修改",
                    "档案管理",
                    "ARCHIVE",
                    archive.getId(),
                    oldArchive,
                    newArchive,
                    ipAddress,
                    "PUT",
                    "/archives"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }
    
    /**
     * 删除档案
     */
    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id, HttpServletRequest request) {
        // 1. 获取删除前的数据
        RelicArchive oldArchive = archiveService.getArchiveDetail(id);
        
        // 2. 执行删除操作
        boolean success = archiveService.deleteArchive(id);
        
        // 3. 记录审计日志
        if (success && oldArchive != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "删除",
                    "档案管理",
                    "ARCHIVE",
                    id,
                    oldArchive,
                    null,
                    ipAddress,
                    "DELETE",
                    "/archives/" + id
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }
    
    /**
     * 上传档案文档
     */
    @PostMapping("/{id}/documents")
    @OperationLog(operationType = "上传", operationModule = "档案管理", operationContent = "上传档案文档")
    public Result<String> uploadDocument(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file,
            @RequestParam String documentType,
            @RequestParam(required = false) String description) {
        return Result.success("上传成功", archiveService.uploadDocument(id, file, documentType, description));
    }
    
    /**
     * 删除档案文档
     */
    @DeleteMapping("/documents/{documentId}")
    @OperationLog(operationType = "删除", operationModule = "档案管理", operationContent = "删除档案文档")
    public Result<Boolean> deleteDocument(@PathVariable Long documentId) {
        return Result.success("删除成功", archiveService.deleteDocument(documentId));
    }
    
    /**
     * 获取档案文档列表
     */
    @GetMapping("/{id}/documents")
    public Result<List<ArchiveDocument>> getDocuments(@PathVariable Long id) {
        return Result.success(archiveService.getDocuments(id));
    }
    
    /**
     * 获取档案历史记录
     */
    @GetMapping("/{id}/history")
    public Result<List<ArchiveHistory>> getHistory(@PathVariable Long id) {
        return Result.success(archiveService.getArchiveHistory(id));
    }
    
    /**
     * 发布档案
     */
    @PutMapping("/{id}/publish")
    public Result<Boolean> publish(@PathVariable Long id, HttpServletRequest request) {
        // 1. 获取修改前的数据
        RelicArchive oldArchive = archiveService.getArchiveDetail(id);
        
        // 2. 执行发布操作
        boolean success = archiveService.publishArchive(id);
        
        // 3. 记录审计日志
        if (success && oldArchive != null) {
            try {
                RelicArchive newArchive = archiveService.getArchiveDetail(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = getClientIp(request);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "发布",
                    "档案管理",
                    "ARCHIVE",
                    id,
                    oldArchive,
                    newArchive,
                    ipAddress,
                    "PUT",
                    "/archives/" + id + "/publish"
                );
            } catch (Exception e) {
                System.err.println("记录审计日志失败: " + e.getMessage());
            }
        }
        
        return Result.success("发布成功", success);
    }
    
    /**
     * 归档
     */
    @PutMapping("/{id}/archive")
    @OperationLog(operationType = "归档", operationModule = "档案管理", operationContent = "归档文物档案")
    public Result<Boolean> archive(@PathVariable Long id) {
        return Result.success("归档成功", archiveService.archiveArchive(id));
    }
    
    /**
     * 导出档案（PDF）
     */
    @GetMapping("/{id}/export/pdf")
    @OperationLog(operationType = "导出", operationModule = "档案管理", operationContent = "导出档案(PDF)")
    public void exportPdf(@PathVariable Long id, HttpServletResponse response) throws Exception {
        archiveService.exportArchivePdf(id, response);
    }
    
    /**
     * 导出档案（Word）
     */
    @GetMapping("/{id}/export/word")
    @OperationLog(operationType = "导出", operationModule = "档案管理", operationContent = "导出档案(Word)")
    public void exportWord(@PathVariable Long id, HttpServletResponse response) throws Exception {
        archiveService.exportArchiveWord(id, response);
    }
    
    /**
     * 打印档案
     */
    @GetMapping("/{id}/print")
    @OperationLog(operationType = "打印", operationModule = "档案管理", operationContent = "打印档案")
    public Result<String> print(@PathVariable Long id) {
        return Result.success("生成打印预览成功", archiveService.generatePrintPreview(id));
    }
    
    /**
     * 生成档案编号
     */
    @GetMapping("/generate-code")
    public Result<String> generateCode() {
        return Result.success(archiveService.generateArchiveCode());
    }
    
    /**
     * 获取可用于创建档案的文物列表（排除已有草稿档案的文物）
     */
    @GetMapping("/available-relics")
    public Result<List<com.example.entity.CulturalRelic>> getAvailableRelics() {
        return Result.success(archiveService.getAvailableRelicsForArchive());
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
