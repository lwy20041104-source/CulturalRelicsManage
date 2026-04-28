package com.example.service.impl;

import com.example.entity.ImageLibrary;
import com.example.entity.RelicImageRelation;
import com.example.mapper.ImageLibraryMapper;
import com.example.mapper.RelicImageRelationMapper;
import com.example.service.ImageLibraryService;
import com.example.service.RelicImageRelationService;
import com.example.utils.FileStorageUtil;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 文物图片关联服务实现类
 */
@Service
public class RelicImageRelationServiceImpl implements RelicImageRelationService {
    
    private final RelicImageRelationMapper relationMapper;
    private final ImageLibraryMapper imageLibraryMapper;
    private final ImageLibraryService imageLibraryService;
    private final FileStorageUtil fileStorageUtil;
    
    public RelicImageRelationServiceImpl(RelicImageRelationMapper relationMapper,
                                        ImageLibraryMapper imageLibraryMapper,
                                        ImageLibraryService imageLibraryService,
                                        FileStorageUtil fileStorageUtil) {
        this.relationMapper = relationMapper;
        this.imageLibraryMapper = imageLibraryMapper;
        this.imageLibraryService = imageLibraryService;
        this.fileStorageUtil = fileStorageUtil;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean setRelicMainImage(Long relicId, Long imageId) {
        // 检查图片是否存在
        ImageLibrary image = imageLibraryMapper.selectById(imageId);
        if (image == null || image.getStatus() != 1) {
            throw new IllegalArgumentException("图片不存在或已删除");
        }
        
        // 删除该文物的旧关联（如果存在）
        relationMapper.deleteByRelicId(relicId);
        
        // 删除该图片的旧关联（如果存在，确保一对一）
        relationMapper.deleteByImageId(imageId);
        
        // 创建新关联
        RelicImageRelation relation = new RelicImageRelation();
        relation.setRelicId(relicId);
        relation.setImageId(imageId);
        relation.setRelationType("main");
        relation.setSortOrder(1);
        relation.setCreateTime(LocalDateTime.now());
        relation.setUpdateTime(LocalDateTime.now());
        
        int result = relationMapper.insert(relation);
        
        // 更新图片的reference字段
        if (result > 0) {
            image.setReferenceType("relic");
            image.setReferenceId(relicId);
            image.setUpdateTime(LocalDateTime.now());
            imageLibraryMapper.updateById(image);
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public String uploadAndSetRelicMainImage(Long relicId, MultipartFile file, Long uploaderId, String uploaderName) throws Exception {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("文件不能为空");
        }
        
        // 1. 保存文件到存储
        String filePath = fileStorageUtil.save(file);
        
        // 2. 获取图片尺寸
        Integer width = null;
        Integer height = null;
        try {
            BufferedImage bufferedImage = ImageIO.read(file.getInputStream());
            if (bufferedImage != null) {
                width = bufferedImage.getWidth();
                height = bufferedImage.getHeight();
            }
        } catch (IOException e) {
            // 忽略尺寸获取失败
        }
        
        // 3. 创建图片库记录
        ImageLibrary imageLibrary = new ImageLibrary();
        imageLibrary.setImageName(file.getOriginalFilename());
        imageLibrary.setOriginalName(file.getOriginalFilename());
        imageLibrary.setFilePath(filePath);
        imageLibrary.setFileSize(file.getSize());
        imageLibrary.setFileType(file.getContentType());
        imageLibrary.setWidth(width);
        imageLibrary.setHeight(height);
        imageLibrary.setCategory("relic");
        imageLibrary.setUploaderId(uploaderId);
        imageLibrary.setUploaderName(uploaderName);
        imageLibrary.setReferenceType("relic");
        imageLibrary.setReferenceId(relicId);
        imageLibrary.setIsPublic(1);
        imageLibrary.setViewCount(0);
        imageLibrary.setDownloadCount(0);
        imageLibrary.setStatus(1);
        imageLibrary.setCreateTime(LocalDateTime.now());
        imageLibrary.setUpdateTime(LocalDateTime.now());
        
        imageLibraryMapper.insert(imageLibrary);
        
        // 4. 建立文物图片关联
        setRelicMainImage(relicId, imageLibrary.getId());
        
        return filePath;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeRelicMainImage(Long relicId) {
        // 获取关联的图片ID
        RelicImageRelation relation = relationMapper.selectByRelicId(relicId);
        if (relation == null) {
            return false;
        }
        
        Long imageId = relation.getImageId();
        
        // 删除关联
        int result = relationMapper.deleteByRelicId(relicId);
        
        // 清除图片的reference字段
        if (result > 0 && imageId != null) {
            ImageLibrary image = imageLibraryMapper.selectById(imageId);
            if (image != null) {
                image.setReferenceType(null);
                image.setReferenceId(null);
                image.setUpdateTime(LocalDateTime.now());
                imageLibraryMapper.updateById(image);
            }
        }
        
        return result > 0;
    }
    
    @Override
    public RelicImageRelation getRelicMainImage(Long relicId) {
        return relationMapper.selectByRelicIdWithImage(relicId);
    }
    
    @Override
    public String getRelicImagePath(Long relicId) {
        RelicImageRelation relation = relationMapper.selectByRelicIdWithImage(relicId);
        if (relation != null && relation.getImage() != null) {
            return relation.getImage().getFilePath();
        }
        return null;
    }
    
    @Override
    public Map<Long, String> getRelicImagePaths(List<Long> relicIds) {
        if (relicIds == null || relicIds.isEmpty()) {
            return new HashMap<>();
        }
        
        Map<Long, Map<String, Object>> resultMap = relationMapper.selectImagePathsByRelicIds(relicIds);
        Map<Long, String> pathMap = new HashMap<>();
        
        for (Map.Entry<Long, Map<String, Object>> entry : resultMap.entrySet()) {
            Object filePath = entry.getValue().get("file_path");
            if (filePath != null) {
                pathMap.put(entry.getKey(), filePath.toString());
            }
        }
        
        return pathMap;
    }
    
    @Override
    public RelicImageRelation getByImageId(Long imageId) {
        return relationMapper.selectByImageId(imageId);
    }
    
    @Override
    public int countRelicsWithImage() {
        return relationMapper.countRelicsWithImage();
    }
    
    @Override
    public int countRelicsWithoutImage() {
        return relationMapper.countRelicsWithoutImage();
    }
    
    @Override
    public List<RelicImageRelation> listAll() {
        return relationMapper.selectAll();
    }
}
