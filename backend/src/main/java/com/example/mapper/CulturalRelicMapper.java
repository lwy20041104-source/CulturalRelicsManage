package com.example.mapper;

import com.example.entity.CulturalRelic;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface CulturalRelicMapper {
    List<CulturalRelic> selectPage(@Param("offset") Integer offset,
                                   @Param("pageSize") Integer pageSize,
                                   @Param("relicName") String relicName,
                                   @Param("categoryId") Long categoryId,
                                   @Param("status") String status,
                                   @Param("era") String era);

    long count(@Param("relicName") String relicName,
               @Param("categoryId") Long categoryId,
               @Param("status") String status,
               @Param("era") String era);

    CulturalRelic selectById(@Param("id") Long id);
    List<CulturalRelic> selectAll();
    long countAll();
    long countByStatus(@Param("status") String status);
    List<java.util.Map<String, Object>> countByCategory();
    List<java.util.Map<String, Object>> countByEra();
    long countByMonth(@Param("year") int year, @Param("month") int month);
    long countByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);
    String selectMaxRelicCode();
    int insert(CulturalRelic relic);
    int updateById(CulturalRelic relic);
    int deleteById(@Param("id") Long id);
    
    /**
     * 查询可用于修复的文物列表（排除指定ID列表的文物）
     * 排除列表由Service层通过RepairRecordService获取
     */
    List<CulturalRelic> selectAvailableForRepair(@Param("excludeIds") java.util.List<Long> excludeIds);
    
    /**
     * 清除3D模型信息（显式设置为NULL）
     */
    int clear3DModelInfo(@Param("id") Long id);
}
