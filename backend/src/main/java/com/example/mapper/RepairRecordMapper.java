package com.example.mapper;

import com.example.entity.RepairRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 修复记录Mapper
 */
@Mapper
public interface RepairRecordMapper {
    
    /**
     * 分页查询修复记录
     */
    List<RepairRecord> selectPage(@Param("offset") int offset,
                                   @Param("limit") int limit,
                                   @Param("status") String status,
                                   @Param("priority") String priority,
                                   @Param("relicName") String relicName,
                                   @Param("repairExpert") String repairExpert,
                                   @Param("applicantId") Long applicantId);
    
    /**
     * 统计记录数
     */
    long count(@Param("status") String status,
               @Param("priority") String priority,
               @Param("relicName") String relicName,
               @Param("repairExpert") String repairExpert,
               @Param("applicantId") Long applicantId);
    
    /**
     * 根据ID查询
     */
    RepairRecord selectById(@Param("id") Long id);
    
    /**
     * 根据文物ID查询修复记录列表
     */
    List<RepairRecord> selectByRelicId(@Param("relicId") Long relicId);
    
    /**
     * 插入记录
     */
    int insert(RepairRecord record);
    
    /**
     * 更新记录
     */
    int updateById(RepairRecord record);
    
    /**
     * 删除记录
     */
    int deleteById(@Param("id") Long id);
    
    /**
     * 生成修复编号
     */
    String generateRepairCode();
    
    /**
     * 统计各状态数量
     */
    List<java.util.Map<String, Object>> countByStatus();
    
    /**
     * 按月统计修复记录数
     */
    long countByMonth(@Param("year") int year, @Param("month") int month);
    
    /**
     * 按日期范围统计修复记录数
     */
    long countByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);

    /**
     * 查询正在进行修复的文物ID列表（状态：待审批、待修复、修复中）
     * 供其他Service层调用，用于过滤不可用于修复的文物
     */
    List<Long> selectInProgressRelicIds();
}
