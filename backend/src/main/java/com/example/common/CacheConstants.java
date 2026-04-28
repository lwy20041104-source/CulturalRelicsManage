package com.example.common;

/**
 * 缓存常量
 * 定义所有缓存的key前缀和过期时间
 */
public class CacheConstants {

    /**
     * 缓存名称
     */
    public static final String CATEGORY_CACHE = "category";
    public static final String STATISTICS_CACHE = "statistics";
    public static final String MUSEUM_CACHE = "museum";
    public static final String RELIC_CACHE = "relic";
    public static final String IMAGE_CACHE = "image";
    public static final String USER_CACHE = "user";
    public static final String EXPERT_CACHE = "expert";

    /**
     * 缓存Key前缀
     */
    public static final String CATEGORY_LIST_KEY = "category:list";
    public static final String CATEGORY_DETAIL_KEY = "category:detail:";
    
    public static final String STATISTICS_OVERVIEW_KEY = "statistics:overview";
    public static final String STATISTICS_CATEGORY_KEY = "statistics:category";
    public static final String STATISTICS_CONDITION_KEY = "statistics:condition";
    public static final String STATISTICS_MUSEUM_KEY = "statistics:museum";
    
    public static final String MUSEUM_LIST_KEY = "museum:list";
    public static final String MUSEUM_DETAIL_KEY = "museum:detail:";
    
    public static final String RELIC_DETAIL_KEY = "relic:detail:";
    public static final String RELIC_LIST_KEY = "relic:list:";
    
    public static final String IMAGE_DETAIL_KEY = "image:detail:";
    public static final String IMAGE_STATISTICS_KEY = "image:statistics";
    
    public static final String USER_DETAIL_KEY = "user:detail:";
    public static final String USER_PERMISSIONS_KEY = "user:permissions:";
    
    public static final String EXPERT_LIST_KEY = "expert:list";
    public static final String EXPERT_DETAIL_KEY = "expert:detail:";

    /**
     * 缓存过期时间（秒）
     */
    public static final long CATEGORY_EXPIRE = 3600L; // 1小时
    public static final long STATISTICS_EXPIRE = 1800L; // 30分钟
    public static final long MUSEUM_EXPIRE = 3600L; // 1小时
    public static final long RELIC_EXPIRE = 1800L; // 30分钟
    public static final long IMAGE_EXPIRE = 1800L; // 30分钟
    public static final long USER_EXPIRE = 3600L; // 1小时
    public static final long EXPERT_EXPIRE = 3600L; // 1小时
}
