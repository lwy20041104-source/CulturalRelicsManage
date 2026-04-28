package com.example.service.impl;

import com.example.common.PageResult;
import com.example.entity.RepairExpert;
import com.example.mapper.RepairExpertMapper;
import com.example.service.RepairExpertService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 修复专家服务实现
 */
@Slf4j
@Service
public class RepairExpertServiceImpl implements RepairExpertService {
    
    private final RepairExpertMapper repairExpertMapper;
    
    public RepairExpertServiceImpl(RepairExpertMapper repairExpertMapper) {
        this.repairExpertMapper = repairExpertMapper;
    }
    
    @Override
    public List<RepairExpert> listEnabled() {
        return repairExpertMapper.selectEnabledList();
    }
    
    @Override
    public PageResult<RepairExpert> pageExperts(Integer pageNum, Integer pageSize,
                                                String expertName, String specialty) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        
        List<RepairExpert> records = repairExpertMapper.selectPage(offset, size, expertName, specialty);
        long total = repairExpertMapper.count(expertName, specialty);
        
        return new PageResult<>(records, total, current, size);
    }
    
    @Override
    public RepairExpert getById(Long id) {
        return repairExpertMapper.selectById(id);
    }
    
    @Override
    @Transactional
    public boolean save(RepairExpert expert) {
        // 自动生成专家编号
        String expertCode = repairExpertMapper.generateExpertCode();
        expert.setExpertCode(expertCode);
        
        if (expert.getStatus() == null) {
            expert.setStatus(1);
        }
        
        log.info("新增修复专家：code={}, name={}, specialty={}", expertCode, expert.getExpertName(), expert.getSpecialty());
        
        return repairExpertMapper.insert(expert) > 0;
    }
    
    @Override
    @Transactional
    public boolean updateById(RepairExpert expert) {
        RepairExpert existing = repairExpertMapper.selectById(expert.getId());
        if (existing == null) {
            throw new IllegalArgumentException("专家不存在");
        }
        
        log.info("更新修复专家：id={}, name={}", expert.getId(), expert.getExpertName());
        
        return repairExpertMapper.updateById(expert) > 0;
    }
    
    @Override
    @Transactional
    public boolean deleteById(Long id) {
        RepairExpert existing = repairExpertMapper.selectById(id);
        if (existing == null) {
            throw new IllegalArgumentException("专家不存在");
        }
        
        log.info("删除修复专家：id={}, name={}", id, existing.getExpertName());
        
        return repairExpertMapper.deleteById(id) > 0;
    }
}
