package com.example.mapper;

import com.example.entity.RelicImageRelation;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 文物图片关联Mapper接口
 */
@Mapper
public interface RelicImageRelationMapper {

    /**
     * 插入关联记录
     */
    int insert(RelicImageRelation relation);

    /**
     * 根据ID查询
     */
    RelicImageRelation selectById(@Param("id") Long id);

    /**
     * 根据文物ID查询关联（一对一，只返回一条）
     */
    RelicImageRelation selectByRelicId(@Param("relicId") Long relicId);

    /**
     * 根据文物ID查询所有关联（一对多，支持多张图片）
     */
    List<RelicImageRelation> selectAllByRelicId(@Param("relicId") Long relicId);

    /**
     * 根据文物ID查询所有关联（包含图片信息）
     */
    List<RelicImageRelation> selectAllByRelicIdWithImage(@Param("relicId") Long relicId);

    /**
     * 根据图片ID查询关联（一对一，只返回一条）
     */
    RelicImageRelation selectByImageId(@Param("imageId") Long imageId);

    /**
     * 根据文物ID查询关联（包含图片信息）
     */
    RelicImageRelation selectByRelicIdWithImage(@Param("relicId") Long relicId);

    /**
     * 批量插入关联记录
     */
    int batchInsert(@Param("relations") List<RelicImageRelation> relations);

    /**
     * 删除指定文物的指定图片关联
     */
    int deleteByRelicIdAndImageId(@Param("relicId") Long relicId, @Param("imageId") Long imageId);

    /**
     * 更新指定图片的主图状态
     */
    int updateIsMain(@Param("relicId") Long relicId, @Param("imageId") Long imageId,
                     @Param("isMain") Integer isMain, @Param("relationType") String relationType);

    /**
     * 批量更新文物所有图片的主图状态
     */
    int batchUpdateIsMain(@Param("relicId") Long relicId, @Param("isMain") Integer isMain,
                          @Param("relationType") String relationType);

    /**
     * 更新关联
     */
    int updateById(RelicImageRelation relation);

    /**
     * 删除关联
     */
    int deleteById(@Param("id") Long id);

    /**
     * 根据文物ID删除关联
     */
    int deleteByRelicId(@Param("relicId") Long relicId);

    /**
     * 根据图片ID删除关联
     */
    int deleteByImageId(@Param("imageId") Long imageId);

    /**
     * 查询所有关联
     */
    List<RelicImageRelation> selectAll();

    /**
     * 查询有主图的文物数量
     */
    int countRelicsWithImage();

    /**
     * 查询没有主图的文物数量
     */
    int countRelicsWithoutImage();

    /**
     * 批量查询文物的图片路径
     */
    java.util.Map<Long, java.util.Map<String, Object>> selectImagePathsByRelicIds(@Param("relicIds") List<Long> relicIds);
}
