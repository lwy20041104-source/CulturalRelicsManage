package com.example.service;

import com.example.entity.RelicImageRelation;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

/**
 * 文物图片关联服务接口
 */
public interface RelicImageRelationService {
    
    /**
     * 为文物设置主图
     * @param relicId 文物ID
     * @param imageId 图片ID
     * @return 是否成功
     */
    boolean setRelicMainImage(Long relicId, Long imageId);
    
    /**
     * 为文物上传并设置主图
     * @param relicId 文物ID
     * @param file 图片文件
     * @param uploaderId 上传者ID
     * @param uploaderName 上传者姓名
     * @return 图片路径
     */
    String uploadAndSetRelicMainImage(Long relicId, MultipartFile file, Long uploaderId, String uploaderName) throws Exception;
    
    /**
     * 移除文物主图
     * @param relicId 文物ID
     * @return 是否成功
     */
    boolean removeRelicMainImage(Long relicId);
    
    /**
     * 获取文物的主图关联
     * @param relicId 文物ID
     * @return 关联信息（包含图片详情）
     */
    RelicImageRelation getRelicMainImage(Long relicId);
    
    /**
     * 获取文物的所有图片（支持一对多）
     * @param relicId 文物ID
     * @return 图片列表（按sort_order排序，主图在前）
     */
    List<RelicImageRelation> getRelicImages(Long relicId);
    
    /**
     * 批量添加文物图片
     * @param relicId 文物ID
     * @param imageIds 图片ID列表
     * @param setFirstAsMain 是否将第一张设为主图
     * @return 是否成功
     */
    boolean addRelicImages(Long relicId, List<Long> imageIds, boolean setFirstAsMain);
    
    /**
     * 删除文物的某张图片
     * @param relicId 文物ID
     * @param imageId 图片ID
     * @return 是否成功
     */
    boolean removeRelicImage(Long relicId, Long imageId);
    
    /**
     * 设置主图
     * @param relicId 文物ID
     * @param imageId 图片ID
     * @return 是否成功
     */
    boolean setMainImage(Long relicId, Long imageId);
    
    /**
     * 获取文物的主图路径
     * @param relicId 文物ID
     * @return 图片路径
     */
    String getRelicImagePath(Long relicId);
    
    /**
     * 批量获取文物的图片路径
     * @param relicIds 文物ID列表
     * @return Map<文物ID, 图片路径>
     */
    Map<Long, String> getRelicImagePaths(List<Long> relicIds);
    
    /**
     * 根据图片ID查询关联的文物
     * @param imageId 图片ID
     * @return 关联信息
     */
    RelicImageRelation getByImageId(Long imageId);
    
    /**
     * 统计有主图的文物数量
     * @return 数量
     */
    int countRelicsWithImage();
    
    /**
     * 统计没有主图的文物数量
     * @return 数量
     */
    int countRelicsWithoutImage();
    
    /**
     * 查询所有关联
     * @return 关联列表
     */
    List<RelicImageRelation> listAll();
}
