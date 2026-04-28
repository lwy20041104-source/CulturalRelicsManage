package com.example.service.impl;

import com.example.common.PageResult;
import com.example.entity.*;
import com.example.mapper.*;
import com.example.service.RelicArchiveService;
import com.example.service.CulturalRelicService;
import com.example.utils.FileStorageUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 文物档案服务实现类
 */
@Slf4j
@Service
public class RelicArchiveServiceImpl implements RelicArchiveService {
    
    @Autowired
    private RelicArchiveMapper archiveMapper;
    
    @Autowired
    private ArchiveDocumentMapper documentMapper;
    
    @Autowired
    private ArchiveHistoryMapper historyMapper;
    
    @Autowired
    private ArchiveRelationMapper relationMapper;
    
    @Autowired
    private CulturalRelicService relicService;
    
    @Autowired
    private CulturalRelicMapper relicMapper;
    
    @Autowired
    private com.example.service.SysUserService sysUserService;
    
    @Autowired
    private FileStorageUtil fileStorageUtil;
    
    @Autowired(required = false)
    private HttpServletRequest request;
    
    @Override
    public PageResult<RelicArchive> pageArchives(Integer pageNum, Integer pageSize, 
                                                  String archiveCode, String archiveType, 
                                                  String status, Long relicId) {
        int offset = (pageNum - 1) * pageSize;
        List<RelicArchive> list = archiveMapper.selectPage(archiveCode, archiveType, status, relicId, offset, pageSize);
        Long total = archiveMapper.selectCount(archiveCode, archiveType, status, relicId);
        
        // 填充关联信息
        for (RelicArchive archive : list) {
            enrichArchive(archive, false);
        }
        
        PageResult<RelicArchive> result = new PageResult<>();
        result.setRecords(list);
        result.setTotal(total);
        return result;
    }
    
    @Override
    public RelicArchive getArchiveDetail(Long id) {
        RelicArchive archive = archiveMapper.selectById(id);
        if (archive != null) {
            enrichArchive(archive, true);
        }
        return archive;
    }
    
    @Override
    public RelicArchive getArchiveByRelicId(Long relicId) {
        RelicArchive archive = archiveMapper.selectByRelicId(relicId);
        if (archive != null) {
            enrichArchive(archive, true);
        }
        return archive;
    }
    
    @Override
    @Transactional
    public Long createArchive(RelicArchive archive) {
        // 验证：检查该文物是否已有草稿状态的档案
        if (archive.getRelicId() != null) {
            RelicArchive existingDraft = archiveMapper.selectByRelicIdAndStatus(archive.getRelicId(), "draft");
            if (existingDraft != null) {
                throw new RuntimeException("该文物已存在草稿状态的档案（档案编号：" + existingDraft.getArchiveCode() + 
                                         "），请先发布或删除现有草稿后再创建新档案");
            }
        }
        
        // 设置默认值
        if (archive.getArchiveCode() == null || archive.getArchiveCode().isEmpty()) {
            archive.setArchiveCode(generateArchiveCode());
        }
        if (archive.getVersion() == null) {
            archive.setVersion(1);
        }
        if (archive.getStatus() == null) {
            archive.setStatus("draft");
        }
        
        // 设置创建信息
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            String username = auth.getName();
            SysUser user = sysUserService.getUserByUsername(username);
            if (user != null) {
                archive.setCreatedBy(user.getId());
                archive.setCreatedByName(user.getRealName() != null ? user.getRealName() : username);
            } else {
                archive.setCreatedByName(username);
            }
        }
        archive.setCreatedTime(LocalDateTime.now());
        archive.setUpdatedTime(LocalDateTime.now());
        
        // 插入档案
        archiveMapper.insert(archive);
        
        // 记录历史
        recordHistory(archive.getId(), archive.getVersion(), "create", 
                     "创建档案：" + archive.getArchiveTitle(), "初始版本");
        
        // 自动关联记录
        autoLinkRelations(archive.getId());
        
        return archive.getId();
    }
    
    @Override
    @Transactional
    public Boolean updateArchive(RelicArchive archive) {
        RelicArchive oldArchive = archiveMapper.selectById(archive.getId());
        if (oldArchive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        // 增加版本号
        archive.setVersion(oldArchive.getVersion() + 1);
        archive.setUpdatedTime(LocalDateTime.now());
        
        // 更新档案
        int result = archiveMapper.update(archive);
        
        if (result > 0) {
            // 记录历史
            recordHistory(archive.getId(), archive.getVersion(), "update", 
                         "更新档案：" + archive.getArchiveTitle(), "版本 v" + archive.getVersion());
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional
    public Boolean deleteArchive(Long id) {
        RelicArchive archive = archiveMapper.selectById(id);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        // 删除关联的文档文件
        List<ArchiveDocument> documents = documentMapper.selectByArchiveId(id);
        for (ArchiveDocument doc : documents) {
            try {
                // 简单删除文件，不抛出异常
                String filePath = doc.getFilePath();
                if (filePath != null && !filePath.isEmpty()) {
                    File file = new File(System.getProperty("user.dir") + filePath);
                    if (file.exists()) {
                        file.delete();
                    }
                }
            } catch (Exception e) {
                log.error("删除文档文件失败: {}", doc.getFilePath(), e);
            }
        }
        
        // 删除档案（级联删除文档、历史、关联记录）
        int result = archiveMapper.deleteById(id);
        
        return result > 0;
    }
    
    @Override
    @Transactional
    public String uploadDocument(Long archiveId, MultipartFile file, String documentType, String description) {
        RelicArchive archive = archiveMapper.selectById(archiveId);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        try {
            // 保存文件
            String filePath = fileStorageUtil.save(file);
            
            // 创建文档记录
            ArchiveDocument document = new ArchiveDocument();
            document.setArchiveId(archiveId);
            document.setDocumentType(documentType);
            document.setDocumentName(file.getOriginalFilename());
            document.setFilePath(filePath);
            document.setFileSize(file.getSize());
            document.setFileFormat(getFileExtension(file.getOriginalFilename()));
            document.setUploadTime(LocalDateTime.now());
            
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            if (auth != null) {
                String username = auth.getName();
                SysUser user = sysUserService.getUserByUsername(username);
                if (user != null) {
                    document.setUploaderId(user.getId());
                    document.setUploaderName(user.getRealName() != null ? user.getRealName() : username);
                } else {
                    document.setUploaderName(username);
                }
            }
            document.setDescription(description);
            document.setSortOrder(0);
            
            documentMapper.insert(document);
            
            // 记录历史
            recordHistory(archiveId, archive.getVersion(), "upload", 
                         "上传文档：" + file.getOriginalFilename(), 
                         "文档类型：" + getDocumentTypeName(documentType));
            
            return filePath;
        } catch (Exception e) {
            log.error("上传文档失败", e);
            throw new RuntimeException("上传文档失败: " + e.getMessage());
        }
    }
    
    @Override
    @Transactional
    public Boolean deleteDocument(Long documentId) {
        ArchiveDocument document = documentMapper.selectById(documentId);
        if (document == null) {
            throw new RuntimeException("文档不存在");
        }
        
        // 删除文件
        try {
            String filePath = document.getFilePath();
            if (filePath != null && !filePath.isEmpty()) {
                File file = new File(System.getProperty("user.dir") + filePath);
                if (file.exists()) {
                    file.delete();
                }
            }
        } catch (Exception e) {
            log.error("删除文档文件失败: {}", document.getFilePath(), e);
        }
        
        // 删除记录
        int result = documentMapper.deleteById(documentId);
        
        if (result > 0) {
            // 记录历史
            RelicArchive archive = archiveMapper.selectById(document.getArchiveId());
            if (archive != null) {
                recordHistory(document.getArchiveId(), archive.getVersion(), "delete", 
                             "删除文档：" + document.getDocumentName(), null);
            }
        }
        
        return result > 0;
    }
    
    @Override
    public List<ArchiveDocument> getDocuments(Long archiveId) {
        return documentMapper.selectByArchiveId(archiveId);
    }
    
    @Override
    public List<ArchiveHistory> getArchiveHistory(Long archiveId) {
        return historyMapper.selectByArchiveId(archiveId);
    }
    
    @Override
    @Transactional
    public Boolean publishArchive(Long id) {
        RelicArchive archive = archiveMapper.selectById(id);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        archive.setStatus("published");
        archive.setPublishedTime(LocalDateTime.now());
        archive.setUpdatedTime(LocalDateTime.now());
        
        int result = archiveMapper.update(archive);
        
        if (result > 0) {
            recordHistory(id, archive.getVersion(), "publish", 
                         "发布档案", "档案已正式发布");
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional
    public Boolean archiveArchive(Long id) {
        RelicArchive archive = archiveMapper.selectById(id);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        archive.setStatus("archived");
        archive.setArchivedTime(LocalDateTime.now());
        archive.setUpdatedTime(LocalDateTime.now());
        
        int result = archiveMapper.update(archive);
        
        if (result > 0) {
            recordHistory(id, archive.getVersion(), "archive", 
                         "归档", "档案已归档");
        }
        
        return result > 0;
    }
    
    @Override
    public void exportArchivePdf(Long id, HttpServletResponse response) throws Exception {
        RelicArchive archive = getArchiveDetail(id);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        // 设置响应头
        String fileName = "档案_" + archive.getArchiveCode() + "_" + 
                         LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".pdf";
        response.setContentType("application/pdf");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 生成PDF
        OutputStream outputStream = response.getOutputStream();
        generateArchivePdf(archive, outputStream);
        outputStream.flush();
        outputStream.close();
        
        // 记录历史
        recordHistory(id, archive.getVersion(), "export", 
                     "导出档案（PDF格式）", null);
    }
    
    @Override
    public void exportArchiveWord(Long id, HttpServletResponse response) throws Exception {
        RelicArchive archive = getArchiveDetail(id);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        // 设置响应头
        String fileName = "档案_" + archive.getArchiveCode() + "_" + 
                         LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".docx";
        response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 生成Word
        OutputStream outputStream = response.getOutputStream();
        generateArchiveWord(archive, outputStream);
        outputStream.flush();
        outputStream.close();
        
        // 记录历史
        recordHistory(id, archive.getVersion(), "export", 
                     "导出档案（Word格式）", null);
    }
    
    @Override
    public String generatePrintPreview(Long id) {
        RelicArchive archive = getArchiveDetail(id);
        if (archive == null) {
            throw new RuntimeException("档案不存在");
        }
        
        // 记录历史
        recordHistory(id, archive.getVersion(), "print", 
                     "生成打印预览", null);
        
        // TODO: 生成打印预览HTML
        return "";
    }
    
    @Override
    @Transactional
    public void autoLinkRelations(Long archiveId) {
        RelicArchive archive = archiveMapper.selectById(archiveId);
        if (archive == null) {
            return;
        }
        
        // TODO: 自动关联借展、修复、维护、展览记录
        // 这里需要根据文物ID查询相关记录并创建关联
    }
    
    @Override
    public String generateArchiveCode() {
        String latestCode = archiveMapper.selectLatestArchiveCode();
        String year = String.valueOf(LocalDateTime.now().getYear());
        
        if (latestCode == null || !latestCode.startsWith("AR-" + year)) {
            return "AR-" + year + "-001";
        }
        
        try {
            String[] parts = latestCode.split("-");
            int number = Integer.parseInt(parts[2]) + 1;
            return "AR-" + year + "-" + String.format("%03d", number);
        } catch (Exception e) {
            return "AR-" + year + "-001";
        }
    }
    
    @Override
    public List<CulturalRelic> getAvailableRelicsForArchive() {
        // 获取所有文物
        List<CulturalRelic> allRelics = relicMapper.selectAll();
        
        // 过滤掉已有草稿档案的文物
        allRelics.removeIf(relic -> {
            RelicArchive draftArchive = archiveMapper.selectByRelicIdAndStatus(relic.getId(), "draft");
            return draftArchive != null;
        });
        
        return allRelics;
    }
    
    /**
     * 丰富档案信息
     */
    private void enrichArchive(RelicArchive archive, boolean includeDetails) {
        // 加载文物信息
        if (archive.getRelicId() != null) {
            archive.setRelic(relicService.getById(archive.getRelicId()));
        }
        
        // 统计文档数量和大小
        archive.setDocumentCount(documentMapper.countByArchiveId(archive.getId()));
        archive.setTotalFileSize(documentMapper.sumFileSizeByArchiveId(archive.getId()));
        
        if (includeDetails) {
            // 加载文档列表
            archive.setDocuments(documentMapper.selectByArchiveId(archive.getId()));
            
            // 加载历史记录
            archive.setHistories(historyMapper.selectByArchiveId(archive.getId()));
            
            // 加载关联记录
            archive.setRelations(relationMapper.selectByArchiveId(archive.getId()));
        }
    }
    
    /**
     * 记录历史
     */
    private void recordHistory(Long archiveId, Integer version, String operationType, 
                               String operationContent, String changeLog) {
        ArchiveHistory history = new ArchiveHistory();
        history.setArchiveId(archiveId);
        history.setVersion(version);
        history.setOperationType(operationType);
        history.setOperationContent(operationContent);
        history.setChangeLog(changeLog);
        history.setOperationTime(LocalDateTime.now());
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            String username = auth.getName();
            SysUser user = sysUserService.getUserByUsername(username);
            if (user != null) {
                history.setOperatorId(user.getId());
                history.setOperatorName(user.getRealName() != null ? user.getRealName() : username);
            } else {
                history.setOperatorName(username);
            }
        }
        
        if (request != null) {
            history.setIpAddress(getClientIp());
        }
        
        historyMapper.insert(history);
    }
    
    /**
     * 获取文件扩展名
     */
    private String getFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        return filename.substring(filename.lastIndexOf(".") + 1).toLowerCase();
    }
    
    /**
     * 获取文档类型名称
     */
    private String getDocumentTypeName(String documentType) {
        switch (documentType) {
            case "appraisal": return "鉴定报告";
            case "repair": return "修复记录";
            case "research": return "研究论文";
            case "certificate": return "证书";
            case "photo": return "照片";
            default: return "其他";
        }
    }
    
    /**
     * 获取档案类型名称
     */
    private String getArchiveTypeName(String archiveType) {
        switch (archiveType) {
            case "complete": return "完整档案";
            case "basic": return "基础档案";
            case "image": return "图片档案";
            case "document": return "文档档案";
            default: return archiveType;
        }
    }
    
    /**
     * 获取状态名称
     */
    private String getStatusName(String status) {
        switch (status) {
            case "draft": return "草稿";
            case "published": return "已发布";
            case "archived": return "已归档";
            default: return status;
        }
    }
    
    /**
     * 获取客户端IP
     */
    private String getClientIp() {
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
     * 生成档案PDF
     */
    private void generateArchivePdf(RelicArchive archive, OutputStream outputStream) throws Exception {
        try {
            com.itextpdf.kernel.pdf.PdfWriter writer = new com.itextpdf.kernel.pdf.PdfWriter(outputStream);
            com.itextpdf.kernel.pdf.PdfDocument pdfDoc = new com.itextpdf.kernel.pdf.PdfDocument(writer);
            com.itextpdf.layout.Document document = new com.itextpdf.layout.Document(pdfDoc);
            
            // 设置中文字体
            com.itextpdf.kernel.font.PdfFont font = com.itextpdf.kernel.font.PdfFontFactory.createFont("STSong-Light", "UniGB-UCS2-H");
            document.setFont(font);
            
            // 添加标题
            com.itextpdf.layout.element.Paragraph title = new com.itextpdf.layout.element.Paragraph("文物档案")
                    .setFontSize(20)
                    .setBold()
                    .setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER);
            document.add(title);
            
            // 添加档案编号
            com.itextpdf.layout.element.Paragraph code = new com.itextpdf.layout.element.Paragraph("档案编号：" + archive.getArchiveCode())
                    .setFontSize(14)
                    .setTextAlignment(com.itextpdf.layout.properties.TextAlignment.CENTER);
            document.add(code);
            
            document.add(new com.itextpdf.layout.element.Paragraph("\n"));
            
            // 档案基本信息
            document.add(new com.itextpdf.layout.element.Paragraph("一、档案基本信息").setFontSize(14).setBold());
            
            float[] columnWidths = {1, 2};
            com.itextpdf.layout.element.Table infoTable = new com.itextpdf.layout.element.Table(com.itextpdf.layout.properties.UnitValue.createPercentArray(columnWidths));
            infoTable.setWidth(com.itextpdf.layout.properties.UnitValue.createPercentValue(100));
            
            addTableRow(infoTable, "档案标题", archive.getArchiveTitle(), font);
            addTableRow(infoTable, "档案类型", getArchiveTypeName(archive.getArchiveType()), font);
            addTableRow(infoTable, "状态", getStatusName(archive.getStatus()), font);
            addTableRow(infoTable, "版本", "v" + archive.getVersion(), font);
            addTableRow(infoTable, "创建人", archive.getCreatedByName(), font);
            addTableRow(infoTable, "创建时间", archive.getCreatedTime() != null ? archive.getCreatedTime().toString() : "", font);
            addTableRow(infoTable, "档案描述", archive.getDescription() != null ? archive.getDescription() : "", font);
            
            document.add(infoTable);
            document.add(new com.itextpdf.layout.element.Paragraph("\n"));
            
            // 文物信息
            if (archive.getRelic() != null) {
                document.add(new com.itextpdf.layout.element.Paragraph("二、关联文物信息").setFontSize(14).setBold());
                
                com.itextpdf.layout.element.Table relicTable = new com.itextpdf.layout.element.Table(com.itextpdf.layout.properties.UnitValue.createPercentArray(columnWidths));
                relicTable.setWidth(com.itextpdf.layout.properties.UnitValue.createPercentValue(100));
                
                CulturalRelic relic = archive.getRelic();
                addTableRow(relicTable, "文物编号", relic.getRelicCode(), font);
                addTableRow(relicTable, "文物名称", relic.getRelicName(), font);
                addTableRow(relicTable, "年代", relic.getEra() != null ? relic.getEra() : "", font);
                addTableRow(relicTable, "材质", relic.getMaterial() != null ? relic.getMaterial() : "", font);
                addTableRow(relicTable, "分类", relic.getCategoryName() != null ? relic.getCategoryName() : "", font);
                addTableRow(relicTable, "状态", relic.getStatus() != null ? relic.getStatus() : "", font);
                
                document.add(relicTable);
                document.add(new com.itextpdf.layout.element.Paragraph("\n"));
            }
            
            // 文档清单
            if (archive.getDocuments() != null && !archive.getDocuments().isEmpty()) {
                document.add(new com.itextpdf.layout.element.Paragraph("三、档案文档清单").setFontSize(14).setBold());
                
                float[] docColumnWidths = {0.5f, 2, 1, 1, 1};
                com.itextpdf.layout.element.Table docTable = new com.itextpdf.layout.element.Table(com.itextpdf.layout.properties.UnitValue.createPercentArray(docColumnWidths));
                docTable.setWidth(com.itextpdf.layout.properties.UnitValue.createPercentValue(100));
                
                // 表头
                addTableCell(docTable, "序号", font, true);
                addTableCell(docTable, "文档名称", font, true);
                addTableCell(docTable, "文档类型", font, true);
                addTableCell(docTable, "文件格式", font, true);
                addTableCell(docTable, "上传人", font, true);
                
                // 数据行
                int index = 1;
                for (ArchiveDocument doc : archive.getDocuments()) {
                    addTableCell(docTable, String.valueOf(index++), font, false);
                    addTableCell(docTable, doc.getDocumentName(), font, false);
                    addTableCell(docTable, getDocumentTypeName(doc.getDocumentType()), font, false);
                    addTableCell(docTable, doc.getFileFormat() != null ? doc.getFileFormat().toUpperCase() : "", font, false);
                    addTableCell(docTable, doc.getUploaderName() != null ? doc.getUploaderName() : "", font, false);
                }
                
                document.add(docTable);
                document.add(new com.itextpdf.layout.element.Paragraph("\n"));
            }
            
            // 页脚
            com.itextpdf.layout.element.Paragraph footer = new com.itextpdf.layout.element.Paragraph(
                    "导出时间：" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")))
                    .setFontSize(10)
                    .setTextAlignment(com.itextpdf.layout.properties.TextAlignment.RIGHT);
            document.add(footer);
            
            document.close();
            log.info("PDF导出成功：archiveId={}", archive.getId());
            
        } catch (Exception e) {
            log.error("生成PDF失败", e);
            throw new RuntimeException("生成PDF失败: " + e.getMessage());
        }
    }
    
    /**
     * 生成档案Word
     */
    private void generateArchiveWord(RelicArchive archive, OutputStream outputStream) throws Exception {
        try {
            org.apache.poi.xwpf.usermodel.XWPFDocument document = new org.apache.poi.xwpf.usermodel.XWPFDocument();
            
            // 添加标题
            org.apache.poi.xwpf.usermodel.XWPFParagraph titleParagraph = document.createParagraph();
            titleParagraph.setAlignment(org.apache.poi.xwpf.usermodel.ParagraphAlignment.CENTER);
            org.apache.poi.xwpf.usermodel.XWPFRun titleRun = titleParagraph.createRun();
            titleRun.setText("文物档案");
            titleRun.setBold(true);
            titleRun.setFontSize(20);
            titleRun.setFontFamily("宋体");
            
            // 添加档案编号
            org.apache.poi.xwpf.usermodel.XWPFParagraph codeParagraph = document.createParagraph();
            codeParagraph.setAlignment(org.apache.poi.xwpf.usermodel.ParagraphAlignment.CENTER);
            org.apache.poi.xwpf.usermodel.XWPFRun codeRun = codeParagraph.createRun();
            codeRun.setText("档案编号：" + archive.getArchiveCode());
            codeRun.setFontSize(14);
            codeRun.setFontFamily("宋体");
            
            // 空行
            document.createParagraph();
            
            // 档案基本信息
            org.apache.poi.xwpf.usermodel.XWPFParagraph section1 = document.createParagraph();
            org.apache.poi.xwpf.usermodel.XWPFRun section1Run = section1.createRun();
            section1Run.setText("一、档案基本信息");
            section1Run.setBold(true);
            section1Run.setFontSize(14);
            section1Run.setFontFamily("宋体");
            
            // 创建表格
            org.apache.poi.xwpf.usermodel.XWPFTable infoTable = document.createTable(7, 2);
            infoTable.setWidth("100%");
            
            setWordTableRow(infoTable.getRow(0), "档案标题", archive.getArchiveTitle());
            setWordTableRow(infoTable.getRow(1), "档案类型", getArchiveTypeName(archive.getArchiveType()));
            setWordTableRow(infoTable.getRow(2), "状态", getStatusName(archive.getStatus()));
            setWordTableRow(infoTable.getRow(3), "版本", "v" + archive.getVersion());
            setWordTableRow(infoTable.getRow(4), "创建人", archive.getCreatedByName());
            setWordTableRow(infoTable.getRow(5), "创建时间", archive.getCreatedTime() != null ? archive.getCreatedTime().toString() : "");
            setWordTableRow(infoTable.getRow(6), "档案描述", archive.getDescription() != null ? archive.getDescription() : "");
            
            // 空行
            document.createParagraph();
            
            // 文物信息
            if (archive.getRelic() != null) {
                org.apache.poi.xwpf.usermodel.XWPFParagraph section2 = document.createParagraph();
                org.apache.poi.xwpf.usermodel.XWPFRun section2Run = section2.createRun();
                section2Run.setText("二、关联文物信息");
                section2Run.setBold(true);
                section2Run.setFontSize(14);
                section2Run.setFontFamily("宋体");
                
                org.apache.poi.xwpf.usermodel.XWPFTable relicTable = document.createTable(6, 2);
                relicTable.setWidth("100%");
                
                CulturalRelic relic = archive.getRelic();
                setWordTableRow(relicTable.getRow(0), "文物编号", relic.getRelicCode());
                setWordTableRow(relicTable.getRow(1), "文物名称", relic.getRelicName());
                setWordTableRow(relicTable.getRow(2), "年代", relic.getEra() != null ? relic.getEra() : "");
                setWordTableRow(relicTable.getRow(3), "材质", relic.getMaterial() != null ? relic.getMaterial() : "");
                setWordTableRow(relicTable.getRow(4), "分类", relic.getCategoryName() != null ? relic.getCategoryName() : "");
                setWordTableRow(relicTable.getRow(5), "状态", relic.getStatus() != null ? relic.getStatus() : "");
                
                document.createParagraph();
            }
            
            // 文档清单
            if (archive.getDocuments() != null && !archive.getDocuments().isEmpty()) {
                org.apache.poi.xwpf.usermodel.XWPFParagraph section3 = document.createParagraph();
                org.apache.poi.xwpf.usermodel.XWPFRun section3Run = section3.createRun();
                section3Run.setText("三、档案文档清单");
                section3Run.setBold(true);
                section3Run.setFontSize(14);
                section3Run.setFontFamily("宋体");
                
                org.apache.poi.xwpf.usermodel.XWPFTable docTable = document.createTable(archive.getDocuments().size() + 1, 5);
                docTable.setWidth("100%");
                
                // 表头
                org.apache.poi.xwpf.usermodel.XWPFTableRow headerRow = docTable.getRow(0);
                setWordTableCell(headerRow.getCell(0), "序号", true);
                setWordTableCell(headerRow.getCell(1), "文档名称", true);
                setWordTableCell(headerRow.getCell(2), "文档类型", true);
                setWordTableCell(headerRow.getCell(3), "文件格式", true);
                setWordTableCell(headerRow.getCell(4), "上传人", true);
                
                // 数据行
                int index = 1;
                for (ArchiveDocument doc : archive.getDocuments()) {
                    org.apache.poi.xwpf.usermodel.XWPFTableRow row = docTable.getRow(index);
                    setWordTableCell(row.getCell(0), String.valueOf(index), false);
                    setWordTableCell(row.getCell(1), doc.getDocumentName(), false);
                    setWordTableCell(row.getCell(2), getDocumentTypeName(doc.getDocumentType()), false);
                    setWordTableCell(row.getCell(3), doc.getFileFormat() != null ? doc.getFileFormat().toUpperCase() : "", false);
                    setWordTableCell(row.getCell(4), doc.getUploaderName() != null ? doc.getUploaderName() : "", false);
                    index++;
                }
                
                document.createParagraph();
            }
            
            // 页脚
            org.apache.poi.xwpf.usermodel.XWPFParagraph footerParagraph = document.createParagraph();
            footerParagraph.setAlignment(org.apache.poi.xwpf.usermodel.ParagraphAlignment.RIGHT);
            org.apache.poi.xwpf.usermodel.XWPFRun footerRun = footerParagraph.createRun();
            footerRun.setText("导出时间：" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            footerRun.setFontSize(10);
            footerRun.setFontFamily("宋体");
            
            // 写入输出流
            document.write(outputStream);
            document.close();
            
            log.info("Word导出成功：archiveId={}", archive.getId());
            
        } catch (Exception e) {
            log.error("生成Word失败", e);
            throw new RuntimeException("生成Word失败: " + e.getMessage());
        }
    }
    
    /**
     * 添加PDF表格行
     */
    private void addTableRow(com.itextpdf.layout.element.Table table, String label, String value, 
                            com.itextpdf.kernel.font.PdfFont font) {
        com.itextpdf.layout.element.Cell labelCell = new com.itextpdf.layout.element.Cell()
                .add(new com.itextpdf.layout.element.Paragraph(label).setFontSize(10).setBold());
        labelCell.setBackgroundColor(com.itextpdf.kernel.colors.ColorConstants.LIGHT_GRAY);
        table.addCell(labelCell);
        
        com.itextpdf.layout.element.Cell valueCell = new com.itextpdf.layout.element.Cell()
                .add(new com.itextpdf.layout.element.Paragraph(value != null ? value : "").setFontSize(10));
        table.addCell(valueCell);
    }
    
    /**
     * 添加PDF表格单元格
     */
    private void addTableCell(com.itextpdf.layout.element.Table table, String text, 
                             com.itextpdf.kernel.font.PdfFont font, boolean isHeader) {
        com.itextpdf.layout.element.Cell cell = new com.itextpdf.layout.element.Cell()
                .add(new com.itextpdf.layout.element.Paragraph(text != null ? text : "").setFontSize(9));
        if (isHeader) {
            cell.setBold();
            cell.setBackgroundColor(com.itextpdf.kernel.colors.ColorConstants.LIGHT_GRAY);
        }
        table.addCell(cell);
    }
    
    /**
     * 设置Word表格行
     */
    private void setWordTableRow(org.apache.poi.xwpf.usermodel.XWPFTableRow row, String label, String value) {
        setWordTableCell(row.getCell(0), label, true);
        setWordTableCell(row.getCell(1), value != null ? value : "", false);
    }
    
    /**
     * 设置Word表格单元格
     */
    private void setWordTableCell(org.apache.poi.xwpf.usermodel.XWPFTableCell cell, String text, boolean isHeader) {
        if (isHeader) {
            cell.setColor("CCCCCC");
        }
        org.apache.poi.xwpf.usermodel.XWPFParagraph paragraph = cell.getParagraphs().get(0);
        org.apache.poi.xwpf.usermodel.XWPFRun run = paragraph.createRun();
        run.setText(text);
        run.setFontFamily("宋体");
        run.setFontSize(isHeader ? 10 : 9);
        if (isHeader) {
            run.setBold(true);
        }
    }
}
