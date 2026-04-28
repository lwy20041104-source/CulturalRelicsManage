package com.example.service;

import com.example.common.PageResult;
import com.example.entity.MaintenanceRecord;

public interface MaintenanceRecordService {
    MaintenanceRecord getById(Long id);
    PageResult<MaintenanceRecord> pageRecords(Integer pageNum, Integer pageSize);
    boolean save(MaintenanceRecord record);
    boolean updateById(MaintenanceRecord record);
    boolean removeById(Long id);
    long count();
}
