package com.example.service.impl;

import com.example.common.CacheConstants;
import com.example.entity.CulturalRelicCategory;
import com.example.mapper.CulturalRelicCategoryMapper;
import com.example.service.CulturalRelicCategoryService;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CulturalRelicCategoryServiceImpl implements CulturalRelicCategoryService {

    private final CulturalRelicCategoryMapper categoryMapper;

    public CulturalRelicCategoryServiceImpl(CulturalRelicCategoryMapper categoryMapper) {
        this.categoryMapper = categoryMapper;
    }

    @Override
    public CulturalRelicCategory getById(Long id) {
        return categoryMapper.selectById(id);
    }

    @Override
    public CulturalRelicCategory getByCategoryName(String categoryName) {
        return categoryMapper.selectByName(categoryName);
    }

    @Override
    @Cacheable(value = CacheConstants.CATEGORY_CACHE, key = "#parentId == null ? 'all' : #parentId")
    public List<CulturalRelicCategory> listByParentId(Long parentId) {
        if (parentId == null) {
            return categoryMapper.selectAll();
        }
        return categoryMapper.selectByParentId(parentId);
    }

    @Override
    @CacheEvict(value = CacheConstants.CATEGORY_CACHE, allEntries = true)
    public boolean save(CulturalRelicCategory category) {
        return categoryMapper.insert(category) > 0;
    }

    @Override
    @CacheEvict(value = CacheConstants.CATEGORY_CACHE, allEntries = true)
    public boolean updateById(CulturalRelicCategory category) {
        return categoryMapper.updateById(category) > 0;
    }

    @Override
    @CacheEvict(value = CacheConstants.CATEGORY_CACHE, allEntries = true)
    public boolean removeById(Long id) {
        return categoryMapper.deleteById(id) > 0;
    }
}
