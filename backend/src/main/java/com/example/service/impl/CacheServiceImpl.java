package com.example.service.impl;

import com.example.common.CacheConstants;
import com.example.service.CacheService;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.stereotype.Service;

/**
 * 缓存服务实现类
 */
@Service
public class CacheServiceImpl implements CacheService {
    
    @Override
    @CacheEvict(value = CacheConstants.STATISTICS_CACHE, allEntries = true)
    public void clearStatisticsCache() {
        // 清除统计缓存
    }
    
    @Override
    @CacheEvict(value = CacheConstants.CATEGORY_CACHE, allEntries = true)
    public void clearCategoryCache() {
        // 清除分类缓存
    }
    
    @Override
    @CacheEvict(value = CacheConstants.MUSEUM_CACHE, allEntries = true)
    public void clearMuseumCache() {
        // 清除博物馆缓存
    }
    
    @Override
    @CacheEvict(value = CacheConstants.IMAGE_CACHE, allEntries = true)
    public void clearImageCache() {
        // 清除图片缓存
    }
    
    @Override
    @CacheEvict(value = {
        CacheConstants.STATISTICS_CACHE,
        CacheConstants.CATEGORY_CACHE,
        CacheConstants.MUSEUM_CACHE,
        CacheConstants.IMAGE_CACHE,
        CacheConstants.RELIC_CACHE,
        CacheConstants.USER_CACHE,
        CacheConstants.EXPERT_CACHE
    }, allEntries = true)
    public void clearAllCache() {
        // 清除所有缓存
    }
}
