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
    public List<RelicImageRelation> getRelicImages(Long relicId) {
        // 先查询关联关系
        List<RelicImageRelation> relations = relationMapper.selectAllByRelicId(relicId);
        
        // 手动加载图片信息
        for (RelicImageRelation relation : relations) {
            if (relation.getImageId() != null) {
                ImageLibrary image = imageLibraryMapper.selectById(relation.getImageId());
                relation.setImage(image);
            }
        }
        
        return relations;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean addRelicImages(Long relicId, List<Long> imageIds, boolean setFirstAsMain) {
        if (imageIds == null || imageIds.isEmpty()) {
            return false;
        }
        
        // 检查文物是否已有主图
        List<RelicImageRelation> existingImages = relationMapper.selectAllByRelicId(relicId);
        boolean hasMainImage = existingImages.stream().anyMatch(r -> r.getIsMain() != null && r.getIsMain() == 1);
        
        // 获取当前最大的sort_order
        int maxSortOrder = existingImages.stream()
            .mapToInt(r -> r.getSortOrder() != null ? r.getSortOrder() : 0)
            .max()
            .orElse(0);
        
        // 批量创建关联
        List<RelicImageRelation> relations = new java.util.ArrayList<>();
        for (int i = 0; i < imageIds.size(); i++) {
            Long imageId = imageIds.get(i);
            
            // 检查图片是否存在
            ImageLibrary image = imageLibraryMapper.selectById(imageId);
            if (image == null || image.getStatus() != 1) {
                continue;
            }
            
            // 检查图片是否已被其他文物使用
            RelicImageRelation existingRelation = relationMapper.selectByImageId(imageId);
            if (existingRelation != null) {
                continue;
            }
            
            RelicImageRelation relation = new RelicImageRelation();
            relation.setRelicId(relicId);
            relation.setImageId(imageId);
            
            // 如果是第一张且需要设为主图，或者文物没有主图
            if ((i == 0 && setFirstAsMain && !hasMainImage) || (!hasMainImage && i == 0)) {
                relation.setIsMain(1);
                relation.setRelationType("main");
                relation.setSortOrder(0);
                hasMainImage = true;
            } else {
                relation.setIsMain(0);
                relation.setRelationType("detail");
                relation.setSortOrder(++maxSortOrder);
            }
            
            relations.add(relation);
            
            // 更新图片的reference字段
            image.setReferenceType("relic");
            image.setReferenceId(relicId);
            image.setUpdateTime(LocalDateTime.now());
            imageLibraryMapper.updateById(image);
        }
        
        if (relations.isEmpty()) {
            return false;
        }
        
        return relationMapper.batchInsert(relations) > 0;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> batchUploadAndAddImages(Long relicId, MultipartFile[] files, 
                                                       Long uploaderId, String uploaderName) {
        Map<String, Object> result = new HashMap<>();
        List<String> imagePaths = new java.util.ArrayList<>();
        List<Long> imageIds = new java.util.ArrayList<>();
        int successCount = 0;
        int failedCount = 0;
        
        if (files == null || files.length == 0) {
            result.put("successCount", 0);
            result.put("failedCount", 0);
            result.put("imagePaths", imagePaths);
            return result;
        }
        
        // 检查文物是否已有主图
        List<RelicImageRelation> existingImages = relationMapper.selectAllByRelicId(relicId);
        boolean hasMainImage = existingImages.stream().anyMatch(r -> r.getIsMain() != null && r.getIsMain() == 1);
        int maxSortOrder = existingImages.stream()
            .mapToInt(r -> r.getSortOrder() != null ? r.getSortOrder() : 0)
            .max()
            .orElse(0);
        
        // 逐个上传文件
        for (int i = 0; i < files.length; i++) {
            MultipartFile file = files[i];
            try {
                // 1. 保存文件到存储
                String filePath = fileStorageUtil.save(file);
                
                // 2. 获取图片尺寸
                Integer width = null;
                Integer height = null;
                try {
                    java.awt.image.BufferedImage bufferedImage = javax.imageio.ImageIO.read(file.getInputStream());
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
                RelicImageRelation relation = new RelicImageRelation();
                relation.setRelicId(relicId);
                relation.setImageId(imageLibrary.getId());
                
                // 第一张且没有主图时设为主图
                if (i == 0 && !hasMainImage) {
                    relation.setIsMain(1);
                    relation.setRelationType("main");
                    relation.setSortOrder(0);
                    hasMainImage = true;
                } else {
                    relation.setIsMain(0);
                    relation.setRelationType("detail");
                    relation.setSortOrder(++maxSortOrder);
                }
                
                relation.setCreateTime(LocalDateTime.now());
                relation.setUpdateTime(LocalDateTime.now());
                relationMapper.insert(relation);
                
                imagePaths.add(filePath);
                imageIds.add(imageLibrary.getId());
                successCount++;
            } catch (Exception e) {
                failedCount++;
                System.err.println("上传文件失败: " + file.getOriginalFilename() + ", " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        result.put("successCount", successCount);
        result.put("failedCount", failedCount);
        result.put("imagePaths", imagePaths);
        result.put("imageIds", imageIds);
        
        return result;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean removeRelicImage(Long relicId, Long imageId) {
        // 获取要删除的关联
        RelicImageRelation relation = relationMapper.selectByImageId(imageId);
        if (relation == null || !relation.getRelicId().equals(relicId)) {
            return false;
        }
        
        boolean wasMainImage = relation.getIsMain() != null && relation.getIsMain() == 1;
        
        // 删除关联
        int result = relationMapper.deleteByRelicIdAndImageId(relicId, imageId);
        
        if (result > 0) {
            // 清除图片的reference字段
            ImageLibrary image = imageLibraryMapper.selectById(imageId);
            if (image != null) {
                image.setReferenceType(null);
                image.setReferenceId(null);
                image.setUpdateTime(LocalDateTime.now());
                imageLibraryMapper.updateById(image);
            }
            
            // 如果删除的是主图，自动将第一张图片设为主图
            if (wasMainImage) {
                List<RelicImageRelation> remainingImages = relationMapper.selectAllByRelicId(relicId);
                if (!remainingImages.isEmpty()) {
                    RelicImageRelation firstImage = remainingImages.get(0);
                    relationMapper.updateIsMain(relicId, firstImage.getImageId(), 1, "main");
                }
            }
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean setMainImage(Long relicId, Long imageId) {
        // 检查关联是否存在
        List<RelicImageRelation> relations = relationMapper.selectAllByRelicId(relicId);
        boolean imageExists = relations.stream().anyMatch(r -> r.getImageId().equals(imageId));
        
        if (!imageExists) {
            throw new IllegalArgumentException("该图片不属于此文物");
        }
        
        // 将所有图片设为非主图
        relationMapper.batchUpdateIsMain(relicId, 0, "detail");
        
        // 将指定图片设为主图
        return relationMapper.updateIsMain(relicId, imageId, 1, "main") > 0;
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
    
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteAllImagesByRelicId(Long relicId) {
        try {
            // 1. 获取该文物的所有图片关联
            List<RelicImageRelation> relations = relationMapper.selectAllByRelicId(relicId);
            
            if (relations == null || relations.isEmpty()) {
                System.out.println("文物没有关联的图片：relicId=" + relicId);
                return true;
            }
            
            System.out.println("开始删除文物的所有图片：relicId=" + relicId + ", 图片数量=" + relations.size());
            
            // 2. 遍历删除每张图片
            for (RelicImageRelation relation : relations) {
                Long imageId = relation.getImageId();
                
                try {
                    // 2.1 获取图片信息（用于日志）
                    ImageLibrary image = imageLibraryMapper.selectById(imageId);
                    
                    if (image != null) {
                        System.out.println("准备删除图片：imageId=" + imageId + ", filePath=" + image.getFilePath());
                        
                        // 2.2 删除图片库记录（物理文件由文件系统管理，这里只删除数据库记录）
                        imageLibraryMapper.deleteById(imageId);
                        System.out.println("已删除图片库记录：imageId=" + imageId);
                    }
                    
                    // 2.3 删除关联记录（如果外键约束没有自动删除）
                    try {
                        relationMapper.deleteByRelicIdAndImageId(relicId, imageId);
                        System.out.println("已删除图片关联记录：relicId=" + relicId + ", imageId=" + imageId);
                    } catch (Exception e) {
                        // 外键约束可能已经自动删除，忽略错误
                        System.out.println("关联记录可能已被外键约束自动删除：relicId=" + relicId + ", imageId=" + imageId);
                    }
                    
                } catch (Exception e) {
                    System.err.println("删除图片失败：imageId=" + imageId + ", error=" + e.getMessage());
                    e.printStackTrace();
                    // 继续删除其他图片
                }
            }
            
            System.out.println("文物的所有图片删除完成：relicId=" + relicId);
            return true;
            
        } catch (Exception e) {
            System.err.println("删除文物图片失败：relicId=" + relicId + ", error=" + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("删除文物图片失败", e);
        }
    }
}
