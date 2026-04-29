package com.example.service;

import com.example.common.PageResult;
import com.example.entity.MaintenanceRecord;

public interface MaintenanceRecordService {
    MaintenanceRecord getById(Long id);
    
    PageResult<MaintenanceRecord> pageRecords(
        Integer pageNum, 
        Integer pageSize,
        Long maintainerId,
        String status,
        String maintenanceType,
        String relicName
    );
    
    boolean save(MaintenanceRecord record);
    boolean updateById(MaintenanceRecord record);
    boolean removeById(Long id);
    boolean approve(Long id, boolean approved, String approver, String approveRemark);
    long count();
}
