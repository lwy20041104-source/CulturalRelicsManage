package com.example.mapper;

import com.example.entity.MaintenanceRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MaintenanceRecordMapper {
    MaintenanceRecord selectById(@Param("id") Long id);
    
    List<MaintenanceRecord> selectPage(
        @Param("offset") Integer offset, 
        @Param("pageSize") Integer pageSize,
        @Param("maintainerId") Long maintainerId,
        @Param("status") String status,
        @Param("maintenanceType") String maintenanceType,
        @Param("relicName") String relicName
    );
    
    long countAll(
        @Param("maintainerId") Long maintainerId,
        @Param("status") String status,
        @Param("maintenanceType") String maintenanceType,
        @Param("relicName") String relicName
    );
    
    long countByMonth(@Param("year") int year, @Param("month") int month);
    long countByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);
    int insert(MaintenanceRecord record);
    int updateById(MaintenanceRecord record);
    int deleteById(@Param("id") Long id);
}
