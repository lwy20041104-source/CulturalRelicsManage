package com.example.service;

/**
 * 缓存服务接口
 * 提供缓存清除和管理功能
 */
public interface CacheService {
    
    /**
     * 清除所有统计相关缓存
     */
    void clearStatisticsCache();
    
    /**
     * 清除所有分类相关缓存
     */
    void clearCategoryCache();
    
    /**
     * 清除所有博物馆相关缓存
     */
    void clearMuseumCache();
    
    /**
     * 清除所有图片相关缓存
     */
    void clearImageCache();
    
    /**
     * 清除所有缓存
     */
    void clearAllCache();
}
