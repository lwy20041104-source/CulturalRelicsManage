package com.example.service.impl;

import com.example.common.CacheConstants;
import com.example.common.PageResult;
import com.example.entity.ImageLibrary;
import com.example.mapper.ImageLibraryMapper;
import com.example.service.ImageLibraryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * 图片库服务实现类
 */
@Service
public class ImageLibraryServiceImpl implements ImageLibraryService {
    
    @Autowired
    private ImageLibraryMapper imageLibraryMapper;
    
    @Value("${file.upload-path:./uploads/}")
    private String uploadPath;
    
    @Override
    @Transactional
    @CacheEvict(value = CacheConstants.IMAGE_CACHE, allEntries = true)
    public ImageLibrary uploadImage(MultipartFile file, String imageName, String category,
                                   String tags, String description, Long uploaderId,
                                   String uploaderName) throws IOException {
        // 先获取图片尺寸（在文件转移之前）
        Integer width = null;
        Integer height = null;
        try {
            BufferedImage image = ImageIO.read(file.getInputStream());
            if (image != null) {
                width = image.getWidth();
                height = image.getHeight();
            }
        } catch (Exception e) {
            // 如果读取图片尺寸失败，继续处理，只是尺寸为空
            System.err.println("无法读取图片尺寸: " + e.getMessage());
        }
        
        // 保存文件（这会转移文件，之后无法再读取 InputStream）
        String filePath = saveFile(file);
        
        // 创建图片记录
        ImageLibrary imageLibrary = new ImageLibrary();
        imageLibrary.setImageName(StringUtils.hasText(imageName) ? imageName : file.getOriginalFilename());
        imageLibrary.setOriginalName(file.getOriginalFilename());
        imageLibrary.setFilePath(filePath);
        imageLibrary.setFileSize(file.getSize());
        imageLibrary.setFileType(file.getContentType());
        imageLibrary.setWidth(width);
        imageLibrary.setHeight(height);
        imageLibrary.setCategory(StringUtils.hasText(category) ? category : "uncategorized");
        imageLibrary.setTags(tags);
        imageLibrary.setDescription(description);
        imageLibrary.setUploaderId(uploaderId);
        imageLibrary.setUploaderName(uploaderName);
        imageLibrary.setIsPublic(1);
        imageLibrary.setViewCount(0);
        imageLibrary.setDownloadCount(0);
        imageLibrary.setStatus(1);
        imageLibrary.setCreateTime(LocalDateTime.now());
        imageLibrary.setUpdateTime(LocalDateTime.now());
        
        imageLibraryMapper.insert(imageLibrary);
        return imageLibrary;
    }
    
    @Override
    @Transactional
    @CacheEvict(value = CacheConstants.IMAGE_CACHE, allEntries = true)
    public List<ImageLibrary> batchUpload(List<MultipartFile> files, String category,
                                         Long uploaderId, String uploaderName) throws IOException {
        List<ImageLibrary> result = new ArrayList<>();
        for (MultipartFile file : files) {
            ImageLibrary image = uploadImage(file, null, category, null, null, 
                                           uploaderId, uploaderName);
            result.add(image);
        }
        return result;
    }
    
    @Override
    public PageResult<ImageLibrary> getImagePage(int pageNum, int pageSize, String imageName,
                                                 String category, Long uploaderId, String tags) {
        Map<String, Object> params = new HashMap<>();
        params.put("offset", (pageNum - 1) * pageSize);
        params.put("limit", pageSize);
        params.put("imageName", imageName);
        params.put("category", category);
        params.put("uploaderId", uploaderId);
        params.put("tags", tags);
        
        List<ImageLibrary> records = imageLibraryMapper.selectByPage(params);
        int total = imageLibraryMapper.countByCondition(params);
        
        return new PageResult<>(records, total, pageNum, pageSize);
    }
    
    @Override
    @Cacheable(value = CacheConstants.IMAGE_CACHE, key = "'detail:' + #id")
    public ImageLibrary getById(Long id) {
        return imageLibraryMapper.selectById(id);
    }
    
    @Override
    @Transactional
    @CacheEvict(value = CacheConstants.IMAGE_CACHE, allEntries = true)
    public boolean updateImageInfo(Long id, String imageName, String category,
                                  String tags, String description, Integer isPublic) {
        ImageLibrary image = getById(id);
        if (image == null || image.getStatus() == 0) {
            return false;
        }
        
        if (StringUtils.hasText(imageName)) {
            image.setImageName(imageName);
        }
        if (StringUtils.hasText(category)) {
            image.setCategory(category);
        }
        if (tags != null) {
            image.setTags(tags);
        }
        if (description != null) {
            image.setDescription(description);
        }
        if (isPublic != null) {
            image.setIsPublic(isPublic);
        }
        image.setUpdateTime(LocalDateTime.now());
        
        return imageLibraryMapper.updateById(image) > 0;
    }
    
    @Override
    @Transactional
    @CacheEvict(value = CacheConstants.IMAGE_CACHE, allEntries = true)
    public boolean deleteImage(Long id) {
        ImageLibrary image = getById(id);
        if (image == null) {
            return false;
        }
        image.setStatus(0);
        image.setUpdateTime(LocalDateTime.now());
        return imageLibraryMapper.updateById(image) > 0;
    }
    
    @Override
    @Transactional
    @CacheEvict(value = CacheConstants.IMAGE_CACHE, allEntries = true)
    public boolean batchDelete(List<Long> ids) {
        for (Long id : ids) {
            deleteImage(id);
        }
        return true;
    }
    
    @Override
    @Transactional
    public boolean physicalDelete(Long id) throws IOException {
        ImageLibrary image = getById(id);
        if (image == null) {
            return false;
        }
        
        // 删除文件
        File file = new File(image.getFilePath());
        if (file.exists()) {
            file.delete();
        }
        
        // 删除数据库记录
        return imageLibraryMapper.deleteById(id) > 0;
    }
    
    @Override
    @Transactional
    public boolean linkToReference(Long imageId, String referenceType, Long referenceId) {
        ImageLibrary image = getById(imageId);
        if (image == null || image.getStatus() == 0) {
            return false;
        }
        
        image.setReferenceType(referenceType);
        image.setReferenceId(referenceId);
        image.setUpdateTime(LocalDateTime.now());
        
        return imageLibraryMapper.updateById(image) > 0;
    }
    
    @Override
    public List<ImageLibrary> getImagesByReference(String referenceType, Long referenceId) {
        Map<String, Object> params = new HashMap<>();
        params.put("referenceType", referenceType);
        params.put("referenceId", referenceId);
        return imageLibraryMapper.selectByReference(params);
    }
    
    @Override
    public void incrementViewCount(Long id) {
        imageLibraryMapper.incrementViewCount(id);
    }
    
    @Override
    public void incrementDownloadCount(Long id) {
        imageLibraryMapper.incrementDownloadCount(id);
    }
    
    @Override
    @Cacheable(value = CacheConstants.IMAGE_CACHE, key = "'stats:category'")
    public List<Map<String, Object>> getCategoryStats() {
        return imageLibraryMapper.getCategoryStats();
    }
    
    @Override
    @Cacheable(value = CacheConstants.IMAGE_CACHE, key = "'stats:uploader'")
    public List<Map<String, Object>> getUploaderStats() {
        return imageLibraryMapper.getUploaderStats();
    }
    
    @Override
    @Cacheable(value = CacheConstants.IMAGE_CACHE, key = "'stats:storage'")
    public Map<String, Object> getStorageStats() {
        return imageLibraryMapper.getStorageStats();
    }
    
    @Override
    public List<ImageLibrary> searchImages(String keyword) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        return imageLibraryMapper.searchByKeyword(params);
    }
    
    /**
     * 保存文件到磁盘
     */
    private String saveFile(MultipartFile file) throws IOException {
        // 使用绝对路径，避免相对路径问题
        String absoluteUploadPath = uploadPath;
        if (!uploadPath.startsWith("/") && !uploadPath.matches("^[A-Za-z]:.*")) {
            // 如果是相对路径，转换为项目根目录下的绝对路径
            absoluteUploadPath = System.getProperty("user.dir") + File.separator + uploadPath;
        }
        
        File dir = new File(absoluteUploadPath);
        if (!dir.exists()) {
            boolean created = dir.mkdirs();
            if (!created && !dir.exists()) {
                throw new IOException("无法创建上传目录: " + dir.getAbsolutePath());
            }
        }
        
        String originalFilename = file.getOriginalFilename();
        String suffix = "";
        if (originalFilename != null && originalFilename.contains(".")) {
            suffix = originalFilename.substring(originalFilename.lastIndexOf("."));
        }
        
        String filename = UUID.randomUUID().toString().replace("-", "") + suffix;
        File targetFile = new File(dir, filename);
        file.transferTo(targetFile);
        
        // 返回相对路径用于数据库存储和URL访问
        return "/uploads/" + filename;
    }
}
