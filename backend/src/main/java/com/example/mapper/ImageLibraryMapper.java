package com.example.mapper;

import com.example.entity.ImageLibrary;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * 图片库Mapper接口
 */
@Mapper
public interface ImageLibraryMapper {

    /**
     * 插入图片记录
     */
    int insert(ImageLibrary imageLibrary);

    /**
     * 根据ID查询
     */
    ImageLibrary selectById(@Param("id") Long id);

    /**
     * 更新图片信息
     */
    int updateById(ImageLibrary imageLibrary);

    /**
     * 删除图片
     */
    int deleteById(@Param("id") Long id);

    /**
     * 分页查询
     */
    List<ImageLibrary> selectByPage(Map<String, Object> params);

    /**
     * 统计总数
     */
    int countByCondition(Map<String, Object> params);

    /**
     * 根据关联查询
     */
    List<ImageLibrary> selectByReference(Map<String, Object> params);

    /**
     * 关键词搜索
     */
    List<ImageLibrary> searchByKeyword(Map<String, Object> params);

    /**
     * 增加浏览次数
     */
    void incrementViewCount(@Param("id") Long id);

    /**
     * 增加下载次数
     */
    void incrementDownloadCount(@Param("id") Long id);

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
}
