package com.example.service;

import com.example.entity.CulturalRelicCategory;

import java.util.List;

public interface CulturalRelicCategoryService {
    CulturalRelicCategory getById(Long id);
    CulturalRelicCategory getByCategoryName(String categoryName);
    List<CulturalRelicCategory> listByParentId(Long parentId);
    boolean save(CulturalRelicCategory category);
    boolean updateById(CulturalRelicCategory category);
    boolean removeById(Long id);
}
