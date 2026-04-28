package com.example.service.impl;

import com.example.common.PageResult;
import com.example.entity.MaintenanceRecord;
import com.example.mapper.MaintenanceRecordMapper;
import com.example.service.MaintenanceRecordService;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MaintenanceRecordServiceImpl implements MaintenanceRecordService {

    private final MaintenanceRecordMapper maintenanceRecordMapper;

    public MaintenanceRecordServiceImpl(MaintenanceRecordMapper maintenanceRecordMapper) {
        this.maintenanceRecordMapper = maintenanceRecordMapper;
    }

    @Override
    public MaintenanceRecord getById(Long id) {
        return maintenanceRecordMapper.selectById(id);
    }

    @Override
    public PageResult<MaintenanceRecord> pageRecords(Integer pageNum, Integer pageSize) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        List<MaintenanceRecord> records = maintenanceRecordMapper.selectPage(offset, size);
        long total = maintenanceRecordMapper.countAll();
        return new PageResult<>(records, total, current, size);
    }

    @Override
    public boolean save(MaintenanceRecord record) {
        return maintenanceRecordMapper.insert(record) > 0;
    }

    @Override
    public boolean updateById(MaintenanceRecord record) {
        return maintenanceRecordMapper.updateById(record) > 0;
    }

    @Override
    public boolean removeById(Long id) {
        return maintenanceRecordMapper.deleteById(id) > 0;
    }

    @Override
    public long count() {
        return maintenanceRecordMapper.countAll();
    }
}
