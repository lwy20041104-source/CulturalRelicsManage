package com.example.service;

import com.example.common.PageResult;
import com.example.dto.RepairApplyRequest;
import com.example.dto.RepairApproveRequest;
import com.example.dto.RepairProgressRequest;
import com.example.entity.RepairRecord;

import java.util.List;
import java.util.Map;

/**
 * 修复记录服务接口
 */
public interface RepairRecordService {
    
    /**
     * 分页查询修复记录
     * 
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @param status 状态
     * @param priority 优先级
     * @param relicName 文物名称
     * @param repairExpert 修复专家
     * @param applicantIdFilter 申请人ID过滤（null表示不过滤）
     * @return 分页结果
     */
    PageResult<RepairRecord> pageRecords(Integer pageNum, Integer pageSize,
                                         String status, String priority,
                                         String relicName, String repairExpert,
                                         Long applicantIdFilter);
    
    /**
     * 根据ID查询
     */
    RepairRecord getById(Long id);
    
    /**
     * 根据文物ID查询修复记录列表
     */
    List<RepairRecord> listByRelicId(Long relicId);
    
    /**
     * 提交修复申请
     */
    boolean applyRepair(RepairApplyRequest request, String applicant);
    
    /**
     * 更新修复申请（仅限待审批状态）
     */
    boolean updateRepairApply(RepairApplyRequest request);
    
    /**
     * 审批修复申请
     */
    boolean approveRepair(RepairApproveRequest request, String approver);
    
    /**
     * 开始修复
     */
    boolean startRepair(Long id);
    
    /**
     * 更新修复进度
     */
    boolean updateProgress(RepairProgressRequest request);
    
    /**
     * 完成修复
     */
    boolean completeRepair(Long id, RepairProgressRequest request);
    
    /**
     * 删除记录
     */
    boolean deleteById(Long id);
    
    /**
     * 统计各状态数量
     */
    Map<String, Long> countByStatus();
}
