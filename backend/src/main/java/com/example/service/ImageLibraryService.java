package com.example.service;

import com.example.common.PageResult;
import com.example.entity.ImageLibrary;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;

/**
 * 图片库服务接口
 */
public interface ImageLibraryService {
    
    /**
     * 上传图片
     */
    ImageLibrary uploadImage(MultipartFile file, String imageName, String category, 
                            String tags, String description, Long uploaderId, 
                            String uploaderName) throws IOException;
    
    /**
     * 批量上传图片
     */
    List<ImageLibrary> batchUpload(List<MultipartFile> files, String category, 
                                  Long uploaderId, String uploaderName) throws IOException;
    
    /**
     * 分页查询图片
     */
    PageResult<ImageLibrary> getImagePage(int pageNum, int pageSize, String imageName, 
                                         String category, Long uploaderId, String tags);
    
    /**
     * 根据ID获取图片
     */
    ImageLibrary getById(Long id);
    
    /**
     * 更新图片信息
     */
    boolean updateImageInfo(Long id, String imageName, String category, 
                           String tags, String description, Integer isPublic);
    
    /**
     * 删除图片(逻辑删除)
     */
    boolean deleteImage(Long id);
    
    /**
     * 批量删除图片
     */
    boolean batchDelete(List<Long> ids);
    
    /**
     * 物理删除图片文件
     */
    boolean physicalDelete(Long id) throws IOException;
    
    /**
     * 关联图片到对象
     */
    boolean linkToReference(Long imageId, String referenceType, Long referenceId);
    
    /**
     * 获取关联的图片列表
     */
    List<ImageLibrary> getImagesByReference(String referenceType, Long referenceId);
    
    /**
     * 增加浏览次数
     */
    void incrementViewCount(Long id);
    
    /**
     * 增加下载次数
     */
    void incrementDownloadCount(Long id);
    
    /**
     * 获取分类统计
     */
    List<Map<String, Object>> getCategoryStats();
    
    /**
     * 获取上传者统计
     */
    List<Map<String, Object>> getUploaderStats();
    
    /**
     * 获取存储统计
     */
    Map<String, Object> getStorageStats();
    
    /**
     * 搜索图片
     */
    List<ImageLibrary> searchImages(String keyword);
}
