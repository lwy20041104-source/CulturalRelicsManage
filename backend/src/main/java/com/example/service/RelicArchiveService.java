package com.example.service;

import com.example.common.PageResult;
import com.example.entity.RelicArchive;
import com.example.entity.ArchiveDocument;
import com.example.entity.ArchiveHistory;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 文物档案服务接口
 */
public interface RelicArchiveService {
    
    /**
     * 分页查询档案列表
     */
    PageResult<RelicArchive> pageArchives(Integer pageNum, Integer pageSize, 
                                          String archiveCode, String archiveType, 
                                          String status, Long relicId);
    
    /**
     * 根据ID获取档案详情
     */
    RelicArchive getArchiveDetail(Long id);
    
    /**
     * 根据文物ID获取档案
     */
    RelicArchive getArchiveByRelicId(Long relicId);
    
    /**
     * 创建档案
     */
    Long createArchive(RelicArchive archive);
    
    /**
     * 更新档案
     */
    Boolean updateArchive(RelicArchive archive);
    
    /**
     * 删除档案
     */
    Boolean deleteArchive(Long id);
    
    /**
     * 上传档案文档
     */
    String uploadDocument(Long archiveId, MultipartFile file, String documentType, String description);
    
    /**
     * 删除档案文档
     */
    Boolean deleteDocument(Long documentId);
    
    /**
     * 获取档案文档列表
     */
    List<ArchiveDocument> getDocuments(Long archiveId);
    
    /**
     * 获取档案历史记录
     */
    List<ArchiveHistory> getArchiveHistory(Long archiveId);
    
    /**
     * 发布档案
     */
    Boolean publishArchive(Long id);
    
    /**
     * 归档
     */
    Boolean archiveArchive(Long id);
    
    /**
     * 导出档案（PDF）
     */
    void exportArchivePdf(Long id, HttpServletResponse response) throws Exception;
    
    /**
     * 导出档案（Word）
     */
    void exportArchiveWord(Long id, HttpServletResponse response) throws Exception;
    
    /**
     * 生成打印预览
     */
    String generatePrintPreview(Long id);
    
    /**
     * 自动关联记录
     */
    void autoLinkRelations(Long archiveId);
    
    /**
     * 生成档案编号
     */
    String generateArchiveCode();
    
    /**
     * 获取可用于创建档案的文物列表（排除已有草稿档案的文物）
     */
    List<com.example.entity.CulturalRelic> getAvailableRelicsForArchive();
}
