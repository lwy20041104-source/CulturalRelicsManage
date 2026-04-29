package com.example.service.impl;

import com.example.common.PageResult;
import com.example.entity.MaintenanceRecord;
import com.example.mapper.MaintenanceRecordMapper;
import com.example.service.MaintenanceRecordService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
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
    public PageResult<MaintenanceRecord> pageRecords(
            Integer pageNum, 
            Integer pageSize,
            Long maintainerId,
            String status,
            String maintenanceType,
            String relicName) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        
        List<MaintenanceRecord> records = maintenanceRecordMapper.selectPage(
            offset, size, maintainerId, status, maintenanceType, relicName);
        long total = maintenanceRecordMapper.countAll(
            maintainerId, status, maintenanceType, relicName);
        
        return new PageResult<>(records, total, current, size);
    }

    @Override
    @Transactional
    public boolean save(MaintenanceRecord record) {
        // 设置默认状态为待审批
        if (record.getStatus() == null || record.getStatus().isEmpty()) {
            record.setStatus("待审批");
        }
        return maintenanceRecordMapper.insert(record) > 0;
    }

    @Override
    @Transactional
    public boolean updateById(MaintenanceRecord record) {
        return maintenanceRecordMapper.updateById(record) > 0;
    }

    @Override
    @Transactional
    public boolean removeById(Long id) {
        return maintenanceRecordMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional
    public boolean approve(Long id, boolean approved, String approver, String approveRemark) {
        MaintenanceRecord record = maintenanceRecordMapper.selectById(id);
        if (record == null) {
            throw new IllegalArgumentException("维护记录不存在");
        }
        
        if (!"待审批".equals(record.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许审批");
        }
        
        record.setStatus(approved ? "已通过" : "已拒绝");
        record.setApprover(approver);
        record.setApproveDate(LocalDateTime.now());
        record.setApproveRemark(approveRemark);
        
        return maintenanceRecordMapper.updateById(record) > 0;
    }

    @Override
    public long count() {
        return maintenanceRecordMapper.countAll(null, null, null, null);
    }
}
