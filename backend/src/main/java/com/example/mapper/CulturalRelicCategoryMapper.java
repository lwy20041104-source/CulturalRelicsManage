package com.example.mapper;

import com.example.entity.CulturalRelicCategory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CulturalRelicCategoryMapper {
    CulturalRelicCategory selectById(@Param("id") Long id);
    List<CulturalRelicCategory> selectByParentId(@Param("parentId") Long parentId);
    List<CulturalRelicCategory> selectAll();
    CulturalRelicCategory selectByName(@Param("categoryName") String categoryName);
    int insert(CulturalRelicCategory category);
    int updateById(CulturalRelicCategory category);
    int deleteById(@Param("id") Long id);
}
