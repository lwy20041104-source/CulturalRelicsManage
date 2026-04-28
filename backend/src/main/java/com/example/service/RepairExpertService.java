package com.example.service;

import com.example.common.PageResult;
import com.example.entity.RepairExpert;

import java.util.List;

/**
 * 修复专家服务接口
 */
public interface RepairExpertService {
    
    /**
     * 查询所有启用的专家
     */
    List<RepairExpert> listEnabled();
    
    /**
     * 分页查询专家
     */
    PageResult<RepairExpert> pageExperts(Integer pageNum, Integer pageSize,
                                         String expertName, String specialty);
    
    /**
     * 根据ID查询
     */
    RepairExpert getById(Long id);
    
    /**
     * 新增专家
     */
    boolean save(RepairExpert expert);
    
    /**
     * 更新专家
     */
    boolean updateById(RepairExpert expert);
    
    /**
     * 删除专家
     */
    boolean deleteById(Long id);
}
