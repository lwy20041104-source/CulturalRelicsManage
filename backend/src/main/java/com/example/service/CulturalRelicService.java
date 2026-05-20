package com.example.service;

import com.example.common.PageResult;
import com.example.entity.CulturalRelic;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.util.List;

public interface CulturalRelicService {
    PageResult<CulturalRelic> pageRelics(Integer pageNum, Integer pageSize, String relicName, Long categoryId, String status, String era);
    CulturalRelic getById(Long id);
    boolean save(CulturalRelic relic);
    
    /**
     * 保存文物并处理图片
     * @param relic 文物信息
     * @param imageFile 图片文件（可选）
     * @param imageId 图片ID（可选，从图片库选择）
     * @param uploaderId 上传者ID
     * @param uploaderName 上传者姓名
     * @return 保存后的文物ID
     */
    Long saveWithImage(CulturalRelic relic, org.springframework.web.multipart.MultipartFile imageFile, Long imageId, Long uploaderId, String uploaderName) throws Exception;
    
    boolean updateById(CulturalRelic relic);
    boolean removeById(Long id);
    List<CulturalRelic> list();
    long count();
    long countByStatus(String status);
    
    // 批量操作
    boolean batchDelete(List<Long> ids);
    boolean batchUpdateStatus(List<Long> ids, String status);
    
    // 导入导出
    void exportExcel(String relicName, Long categoryId, String status, String era, HttpServletResponse response) throws Exception;
    void exportPdf(String relicName, Long categoryId, String status, String era, HttpServletResponse response) throws Exception;
    void exportWord(String relicName, Long categoryId, String status, String era, HttpServletResponse response) throws Exception;
    int importExcel(MultipartFile file) throws Exception;
    void downloadTemplate(HttpServletResponse response) throws Exception;
    
    /**
     * 获取可用于修复的文物列表（排除有正在进行修复的文物）
     */
    List<CulturalRelic> getAvailableForRepair();
    
    /**
     * 清除3D模型信息（显式设置为NULL）
     */
    int clear3DModelInfo(Long id);
}
