package com.example.service.impl;

import com.example.common.CacheConstants;
import com.example.common.PageResult;
import com.example.entity.CulturalRelic;
import com.example.entity.CulturalRelicCategory;
import com.example.mapper.CulturalRelicMapper;
import com.example.mapper.RepairRecordMapper;
import com.example.service.CulturalRelicCategoryService;
import com.example.service.CulturalRelicService;
import com.example.service.RelicImageRelationService;
import com.example.util.ExportUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Slf4j
@Service
public class CulturalRelicServiceImpl implements CulturalRelicService {

    private final CulturalRelicMapper culturalRelicMapper;
    private final RelicImageRelationService relicImageRelationService;
    private final RepairRecordMapper repairRecordMapper;
    private final CulturalRelicCategoryService categoryService;

    public CulturalRelicServiceImpl(CulturalRelicMapper culturalRelicMapper,
                                   com.example.service.RelicImageRelationService relicImageRelationService,
                                   RepairRecordMapper repairRecordMapper,
                                   CulturalRelicCategoryService categoryService) {
        this.culturalRelicMapper = culturalRelicMapper;
        this.relicImageRelationService = relicImageRelationService;
        this.repairRecordMapper = repairRecordMapper;
        this.categoryService = categoryService;
    }

    @Override
    public PageResult<CulturalRelic> pageRelics(Integer pageNum, Integer pageSize, String relicName, Long categoryId, String status, String era) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        List<CulturalRelic> records = culturalRelicMapper.selectPage(offset, size, relicName, categoryId, status, era);
        long total = culturalRelicMapper.count(relicName, categoryId, status, era);
        return new PageResult<>(records, total, current, size);
    }

    @Override
    public CulturalRelic getById(Long id) {
        return culturalRelicMapper.selectById(id);
    }

    @Override
    @CacheEvict(value = CacheConstants.STATISTICS_CACHE, allEntries = true)
    public boolean save(CulturalRelic relic) {
        relic.setRelicCode(generateNextRelicCode());
        try {
            return culturalRelicMapper.insert(relic) > 0;
        } catch (DuplicateKeyException e) {
            throw new IllegalArgumentException("文物编号生成失败，请重试");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    @CacheEvict(value = CacheConstants.STATISTICS_CACHE, allEntries = true)
    public Long saveWithImage(CulturalRelic relic, org.springframework.web.multipart.MultipartFile imageFile, 
                             Long imageId, Long uploaderId, String uploaderName) throws Exception {
        // 1. 保存文物基本信息
        relic.setRelicCode(generateNextRelicCode());
        try {
            culturalRelicMapper.insert(relic);
            Long relicId = relic.getId();
            log.info("保存文物成功：id={}, name={}", relicId, relic.getRelicName());
            
            // 2. 处理图片
            if (imageFile != null && !imageFile.isEmpty()) {
                // 上传新图片并建立关联
                String imagePath = relicImageRelationService.uploadAndSetRelicMainImage(
                    relicId, imageFile, uploaderId, uploaderName);
                log.info("上传文物图片成功：relicId={}, imagePath={}", relicId, imagePath);
            } else if (imageId != null) {
                // 从图片库选择已有图片
                relicImageRelationService.setRelicMainImage(relicId, imageId);
                log.info("设置文物主图成功：relicId={}, imageId={}", relicId, imageId);
            }
            
            return relicId;
        } catch (DuplicateKeyException e) {
            throw new IllegalArgumentException("文物编号生成失败，请重试");
        }
    }

    @Override
    @CacheEvict(value = CacheConstants.STATISTICS_CACHE, allEntries = true)
    public boolean updateById(CulturalRelic relic) {
        try {
            return culturalRelicMapper.updateById(relic) > 0;
        } catch (DuplicateKeyException e) {
            throw new IllegalArgumentException("文物编号已存在，请更换后重试");
        }
    }

    @Override
    @CacheEvict(value = CacheConstants.STATISTICS_CACHE, allEntries = true)
    @Transactional
    public boolean removeById(Long id) {
        log.info("开始删除文物：id={}", id);
        
        // 1. 删除文物关联的所有图片（包括关联关系和图片库记录）
        try {
            relicImageRelationService.deleteAllImagesByRelicId(id);
            log.info("已删除文物关联的所有图片：relicId={}", id);
        } catch (Exception e) {
            log.error("删除文物关联图片失败：relicId={}, error={}", id, e.getMessage(), e);
            throw new RuntimeException("删除文物关联图片失败", e);
        }
        
        // 2. 删除文物记录
        boolean success = culturalRelicMapper.deleteById(id) > 0;
        
        if (success) {
            log.info("文物删除成功：id={}", id);
        } else {
            log.warn("文物删除失败：id={}", id);
        }
        
        return success;
    }

    @Override
    public List<CulturalRelic> list() {
        return culturalRelicMapper.selectAll();
    }

    @Override
    public long count() {
        return culturalRelicMapper.countAll();
    }

    @Override
    public long countByStatus(String status) {
        return culturalRelicMapper.countByStatus(status);
    }

    @Override
    @Transactional
    public boolean batchDelete(List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return false;
        }
        
        log.info("开始批量删除文物：ids={}, count={}", ids, ids.size());
        
        int count = 0;
        for (Long id : ids) {
            try {
                // 删除每个文物（包括其关联的图片）
                if (removeById(id)) {
                    count++;
                }
            } catch (Exception e) {
                log.error("删除文物失败：id={}, error={}", id, e.getMessage(), e);
                // 继续删除其他文物
            }
        }
        
        log.info("批量删除文物完成：总数={}, 成功={}", ids.size(), count);
        return count > 0;
    }

    @Override
    @Transactional
    public boolean batchUpdateStatus(List<Long> ids, String status) {
        if (ids == null || ids.isEmpty() || status == null || status.trim().isEmpty()) {
            return false;
        }
        int count = 0;
        for (Long id : ids) {
            CulturalRelic relic = culturalRelicMapper.selectById(id);
            if (relic != null) {
                relic.setStatus(status);
                relic.setUpdateTime(LocalDateTime.now());
                count += culturalRelicMapper.updateById(relic);
            }
        }
        log.info("批量修改状态：ids={}, status={}, count={}", ids, status, count);
        return count > 0;
    }

    @Override
    public void exportExcel(String relicName, Long categoryId, String status, String era, HttpServletResponse response) throws Exception {
        // 查询数据
        List<CulturalRelic> relics = culturalRelicMapper.selectPage(0, 10000, relicName, categoryId, status, era);
        
        // 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("文物数据");
        
        // 创建标题行样式
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // 创建标题行
        Row headerRow = sheet.createRow(0);
        String[] headers = {"编号", "名称", "年代", "材质", "分类", "状态", "尺寸", "重量(kg)", "来源", "描述"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // 填充数据
        for (int i = 0; i < relics.size(); i++) {
            CulturalRelic relic = relics.get(i);
            Row row = sheet.createRow(i + 1);
            row.createCell(0).setCellValue(relic.getRelicCode());
            row.createCell(1).setCellValue(relic.getRelicName());
            row.createCell(2).setCellValue(relic.getEra());
            row.createCell(3).setCellValue(relic.getMaterial());
            row.createCell(4).setCellValue(relic.getCategoryName());
            row.createCell(5).setCellValue(relic.getStatus());
            row.createCell(6).setCellValue(relic.getDimensions());
            row.createCell(7).setCellValue(relic.getWeight() != null ? relic.getWeight() : 0);
            row.createCell(8).setCellValue(relic.getOrigin());
            row.createCell(9).setCellValue(relic.getDescription());
        }
        
        // 自动调整列宽
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // 设置响应头
        String fileName = "文物数据_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 写入响应
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        }
        workbook.close();
        
        log.info("导出文物数据：count={}", relics.size());
    }

    @Override
    @Transactional
    public int importExcel(MultipartFile file) throws Exception {
        int count = 0;
        try (InputStream inputStream = file.getInputStream();
             Workbook workbook = new XSSFWorkbook(inputStream)) {
            
            Sheet sheet = workbook.getSheetAt(0);
            int rowCount = sheet.getPhysicalNumberOfRows();
            
            // 跳过标题行
            for (int i = 1; i < rowCount; i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                try {
                    CulturalRelic relic = new CulturalRelic();
                    // 列0: 名称*
                    relic.setRelicName(getCellValue(row.getCell(0)));
                    // 列1: 图片
                    relic.setImagePath(getCellValue(row.getCell(1)));
                    // 列2: 年代*
                    relic.setEra(getCellValue(row.getCell(2)));
                    // 列3: 材质*
                    relic.setMaterial(getCellValue(row.getCell(3)));
                    // 列4: 状态*
                    relic.setStatus(getCellValue(row.getCell(4)));
                    // 列5: 3D模型
                    relic.setModel3dUrl(getCellValue(row.getCell(5)));
                    // 列6: 文物分类*（通过分类名称查找分类ID）
                    String categoryName = getCellValue(row.getCell(6));
                    if (categoryName != null && !categoryName.trim().isEmpty()) {
                        CulturalRelicCategory category = categoryService.getByCategoryName(categoryName.trim());
                        if (category != null) {
                            relic.setCategoryId(category.getId());
                            relic.setCategoryName(category.getCategoryName());
                        } else {
                            relic.setCategoryName(categoryName.trim());
                        }
                    }
                    // 列7: 尺寸
                    relic.setDimensions(getCellValue(row.getCell(7)));
                    // 列8: 重量(kg)
                    String weightStr = getCellValue(row.getCell(8));
                    if (weightStr != null && !weightStr.trim().isEmpty()) {
                        relic.setWeight(Double.parseDouble(weightStr));
                    }
                    // 列9: 描述
                    relic.setDescription(getCellValue(row.getCell(9)));
                    relic.setCreateTime(LocalDateTime.now());
                    relic.setUpdateTime(LocalDateTime.now());
                    
                    // 保存
                    if (save(relic)) {
                        count++;
                    }
                } catch (Exception e) {
                    log.warn("导入第{}行失败：{}", i + 1, e.getMessage());
                }
            }
        }
        
        log.info("导入文物数据：count={}", count);
        return count;
    }

    @Override
    public void downloadTemplate(HttpServletResponse response) throws Exception {
        // 创建工作簿
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("文物导入模板");
        
        // 创建标题行样式
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);
        
        // 创建标题行
        Row headerRow = sheet.createRow(0);
        String[] headers = {"名称*", "图片", "年代*", "材质*", "状态*", "3D模型", "文物分类*", "尺寸", "重量(kg)", "描述"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        
        // 添加示例数据
        Row exampleRow = sheet.createRow(1);
        exampleRow.createCell(0).setCellValue("青铜鼎");
        exampleRow.createCell(1).setCellValue("/uploads/example.jpg");
        exampleRow.createCell(2).setCellValue("商朝");
        exampleRow.createCell(3).setCellValue("青铜");
        exampleRow.createCell(4).setCellValue("在库");
        exampleRow.createCell(5).setCellValue("/models/example.glb");
        exampleRow.createCell(6).setCellValue("青铜器");
        exampleRow.createCell(7).setCellValue("高30cm，口径25cm");
        exampleRow.createCell(8).setCellValue(15.5);
        exampleRow.createCell(9).setCellValue("商代晚期青铜礼器，保存完整。");
        
        // 自动调整列宽
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
        
        // 设置响应头
        String fileName = "文物导入模板.xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 写入响应
        try (OutputStream outputStream = response.getOutputStream()) {
            workbook.write(outputStream);
        }
        workbook.close();
        
        log.info("下载导入模板");
    }

    private String getCellValue(Cell cell) {
        if (cell == null) return null;
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                return String.valueOf(cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return null;
        }
    }

    @Override
    public List<CulturalRelic> getAvailableForRepair() {
        // 获取正在进行修复的文物ID列表（修复业务逻辑在Service层组装，而非Mapper层硬编码）
        List<Long> inProgressRelicIds = repairRecordMapper.selectInProgressRelicIds();
        return culturalRelicMapper.selectAvailableForRepair(inProgressRelicIds);
    }

    @Override
    public int clear3DModelInfo(Long id) {
        return culturalRelicMapper.clear3DModelInfo(id);
    }

    @Override
    public void exportPdf(String relicName, Long categoryId, String status, String era, HttpServletResponse response) throws Exception {
        // 查询数据
        List<CulturalRelic> relics = culturalRelicMapper.selectPage(0, 10000, relicName, categoryId, status, era);
        
        // 设置响应头
        String fileName = "文物数据_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".pdf";
        response.setContentType("application/pdf");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 导出PDF
        try (OutputStream outputStream = response.getOutputStream()) {
            ExportUtils.exportRelicsToPdf(relics, outputStream);
        }
        
        log.info("导出文物PDF：count={}", relics.size());
    }

    @Override
    public void exportWord(String relicName, Long categoryId, String status, String era, HttpServletResponse response) throws Exception {
        // 查询数据
        List<CulturalRelic> relics = culturalRelicMapper.selectPage(0, 10000, relicName, categoryId, status, era);
        
        // 设置响应头
        String fileName = "文物数据_" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss")) + ".docx";
        response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(fileName, "UTF-8"));
        
        // 导出Word
        try (OutputStream outputStream = response.getOutputStream()) {
            ExportUtils.exportRelicsToWord(relics, outputStream);
        }
        
        log.info("导出文物Word：count={}", relics.size());
    }

    private String generateNextRelicCode() {
        String maxCode = culturalRelicMapper.selectMaxRelicCode();
        if (maxCode == null || maxCode.trim().isEmpty()) {
            return "CR2026001";
        }
        int next = Integer.parseInt(maxCode.substring(2)) + 1;
        return "CR" + next;
    }
}
