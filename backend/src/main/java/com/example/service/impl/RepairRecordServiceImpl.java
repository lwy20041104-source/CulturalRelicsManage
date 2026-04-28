package com.example.service.impl;

import com.example.common.PageResult;
import com.example.dto.RepairApplyRequest;
import com.example.dto.RepairApproveRequest;
import com.example.dto.RepairProgressRequest;
import com.example.entity.RepairRecord;
import com.example.mapper.RepairRecordMapper;
import com.example.mapper.SysUserMapper;
import com.example.service.NotificationService;
import com.example.service.RepairRecordService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 修复记录服务实现
 */
@Slf4j
@Service
public class RepairRecordServiceImpl implements RepairRecordService {
    
    private final RepairRecordMapper repairRecordMapper;
    private final NotificationService notificationService;
    private final SysUserMapper sysUserMapper;
    
    public RepairRecordServiceImpl(RepairRecordMapper repairRecordMapper,
                                   NotificationService notificationService,
                                   SysUserMapper sysUserMapper) {
        this.repairRecordMapper = repairRecordMapper;
        this.notificationService = notificationService;
        this.sysUserMapper = sysUserMapper;
    }
    
    @Override
    public PageResult<RepairRecord> pageRecords(Integer pageNum, Integer pageSize,
                                                String status, String priority,
                                                String relicName, String repairExpert,
                                                Long applicantIdFilter) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        
        List<RepairRecord> records = repairRecordMapper.selectPage(
            offset, size, status, priority, relicName, repairExpert, applicantIdFilter);
        long total = repairRecordMapper.count(
            status, priority, relicName, repairExpert, applicantIdFilter);
        
        log.info("查询修复记录：pageNum={}, pageSize={}, applicantIdFilter={}, total={}", 
                pageNum, pageSize, applicantIdFilter, total);
        
        return new PageResult<>(records, total, current, size);
    }
    
    @Override
    public RepairRecord getById(Long id) {
        return repairRecordMapper.selectById(id);
    }
    
    @Override
    public List<RepairRecord> listByRelicId(Long relicId) {
        return repairRecordMapper.selectByRelicId(relicId);
    }
    
    @Override
    @Transactional
    public boolean applyRepair(RepairApplyRequest request, String applicant) {
        // 检查文物状态
        com.example.entity.CulturalRelic relic = repairRecordMapper.selectRelicById(request.getRelicId());
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }
        
        // 只有"在库"状态的文物才能申请修复
        if (!"在库".equals(relic.getStatus())) {
            throw new IllegalArgumentException("只有在库状态的文物才能申请修复，当前状态：" + relic.getStatus());
        }
        
        // 获取申请人ID
        Long applicantId = null;
        if (applicant != null && !applicant.isEmpty()) {
            com.example.entity.SysUser user = sysUserMapper.selectByUsername(applicant);
            if (user != null) {
                applicantId = user.getId();
            }
        }
        
        // 生成修复编号
        String repairCode = repairRecordMapper.generateRepairCode();
        
        RepairRecord record = new RepairRecord();
        record.setRepairCode(repairCode);
        record.setRelicId(request.getRelicId());
        record.setStatus("待审批");
        record.setPriority(request.getPriority() != null ? request.getPriority() : "普通");
        record.setApplicantId(applicantId);
        record.setApplyDate(LocalDateTime.now());
        record.setRepairReason(request.getRepairReason());
        record.setDamageDescription(request.getDamageDescription());
        record.setEstimatedCost(request.getEstimatedCost());
        record.setBeforeImages(request.getBeforeImages());
        record.setRepairExpert(request.getRepairExpert());  // 保存修复专家（可为空）
        record.setRemark(request.getRemark());
        
        int result = repairRecordMapper.insert(record);
        log.info("提交修复申请：repairCode={}, relicId={}, applicantId={}, repairExpert={}", 
                repairCode, request.getRelicId(), applicantId, request.getRepairExpert());
        
        // 发送修复申请通知
        if (result > 0) {
            try {
                notificationService.sendRepairApplyNotification(
                    record.getId(),
                    relic.getRelicName(),
                    request.getRepairReason(),
                    applicantId
                );
                log.info("修复申请通知已发送：repairId={}, relic={}, applicantId={}", record.getId(), relic.getRelicName(), applicantId);
            } catch (Exception e) {
                log.error("发送修复申请通知失败：{}", e.getMessage(), e);
            }
        }
        
        return result > 0;
    }
    
    @Override
    @Transactional
    public boolean updateRepairApply(RepairApplyRequest request) {
        // 获取原记录
        RepairRecord record = repairRecordMapper.selectById(request.getId());
        if (record == null) {
            throw new IllegalArgumentException("修复记录不存在");
        }
        
        // 检查状态
        if (!"待审批".equals(record.getStatus())) {
            throw new IllegalArgumentException("只能修改待审批状态的申请");
        }
        
        // 如果修改了文物，检查新文物状态
        if (request.getRelicId() != null && !request.getRelicId().equals(record.getRelicId())) {
            com.example.entity.CulturalRelic relic = repairRecordMapper.selectRelicById(request.getRelicId());
            if (relic == null) {
                throw new IllegalArgumentException("文物不存在");
            }
            if (!"在库".equals(relic.getStatus())) {
                throw new IllegalArgumentException("只有在库状态的文物才能申请修复，当前状态：" + relic.getStatus());
            }
            record.setRelicId(request.getRelicId());
        }
        
        // 更新字段
        if (request.getPriority() != null) {
            record.setPriority(request.getPriority());
        }
        if (request.getRepairReason() != null) {
            record.setRepairReason(request.getRepairReason());
        }
        if (request.getDamageDescription() != null) {
            record.setDamageDescription(request.getDamageDescription());
        }
        if (request.getEstimatedCost() != null) {
            record.setEstimatedCost(request.getEstimatedCost());
        }
        if (request.getBeforeImages() != null) {
            record.setBeforeImages(request.getBeforeImages());
        }
        if (request.getRepairExpert() != null) {
            record.setRepairExpert(request.getRepairExpert());
        }
        if (request.getRemark() != null) {
            record.setRemark(request.getRemark());
        }
        
        int result = repairRecordMapper.updateById(record);
        log.info("更新修复申请：id={}, relicId={}", request.getId(), record.getRelicId());
        
        return result > 0;
    }
    
    @Override
    @Transactional
    public boolean approveRepair(RepairApproveRequest request, String approver) {
        RepairRecord record = repairRecordMapper.selectById(request.getId());
        if (record == null) {
            throw new IllegalArgumentException("修复记录不存在");
        }
        
        if (!"待审批".equals(record.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许审批");
        }
        
        record.setApprover(approver);
        record.setApproveDate(LocalDateTime.now());
        record.setApproveRemark(request.getApproveRemark());
        
        boolean approved = Boolean.TRUE.equals(request.getApproved());
        
        if (approved) {
            // 审批通过
            if (request.getRepairExpert() == null || request.getRepairExpert().trim().isEmpty()) {
                throw new IllegalArgumentException("审批通过时必须分配修复专家");
            }
            record.setStatus("待修复");
            record.setRepairExpert(request.getRepairExpert());
            log.info("修复申请审批通过：id={}, expert={}, approver={}", request.getId(), request.getRepairExpert(), approver);
        } else {
            // 审批拒绝
            record.setStatus("已拒绝");
            log.info("修复申请被拒绝：id={}, approver={}, reason={}", request.getId(), approver, request.getApproveRemark());
        }
        
        boolean updated = repairRecordMapper.updateById(record) > 0;
        
        // 发送修复审批结果通知（如果需要通知申请人）
        if (updated) {
            try {
                com.example.entity.CulturalRelic relic = repairRecordMapper.selectRelicById(record.getRelicId());
                if (relic != null) {
                    // 这里需要获取申请人ID，可以从record中获取或者通过其他方式
                    // notificationService.sendRepairApprovalNotification(
                    //     record.getId(),
                    //     applicantId,
                    //     relic.getRelicName(),
                    //     approved,
                    //     approver
                    // );
                    log.info("修复审批结果通知已发送：repairId={}, approved={}, approver={}", 
                            record.getId(), approved, approver);
                }
            } catch (Exception e) {
                log.error("发送修复审批结果通知失败：{}", e.getMessage(), e);
            }
        }
        
        return updated;
    }
    
    @Override
    @Transactional
    public boolean startRepair(Long id) {
        RepairRecord record = repairRecordMapper.selectById(id);
        if (record == null) {
            throw new IllegalArgumentException("修复记录不存在");
        }
        
        if (!"待修复".equals(record.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许开始修复");
        }
        
        // 检查文物状态
        com.example.entity.CulturalRelic relic = repairRecordMapper.selectRelicById(record.getRelicId());
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }
        
        // 更新修复记录状态
        record.setStatus("修复中");
        record.setStartDate(LocalDateTime.now());
        
        boolean updated = repairRecordMapper.updateById(record) > 0;
        
        // 更新文物状态为"修复中"
        if (updated) {
            relic.setStatus("修复中");
            relic.setUpdateTime(LocalDateTime.now());
            // 需要通过CulturalRelicMapper更新
            updateRelicStatus(relic);
        }
        
        log.info("开始修复：id={}, repairCode={}, expert={}", id, record.getRepairCode(), record.getRepairExpert());
        
        return updated;
    }
    
    @Override
    @Transactional
    public boolean updateProgress(RepairProgressRequest request) {
        RepairRecord record = repairRecordMapper.selectById(request.getId());
        if (record == null) {
            throw new IllegalArgumentException("修复记录不存在");
        }
        
        if (!"修复中".equals(record.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许更新进度");
        }
        
        if (request.getRepairProcess() != null) {
            record.setRepairProcess(request.getRepairProcess());
        }
        if (request.getRepairMethod() != null) {
            record.setRepairMethod(request.getRepairMethod());
        }
        // 注意：材料使用信息通过repair_record_material关联表管理
        if (request.getActualCost() != null) {
            record.setActualCost(request.getActualCost());
        }
        if (request.getAfterImages() != null) {
            record.setAfterImages(request.getAfterImages());
        }
        if (request.getRemark() != null) {
            record.setRemark(request.getRemark());
        }
        
        log.info("更新修复进度：id={}, repairCode={}", request.getId(), record.getRepairCode());
        
        return repairRecordMapper.updateById(record) > 0;
    }
    
    @Override
    @Transactional
    public boolean completeRepair(Long id, RepairProgressRequest request) {
        RepairRecord record = repairRecordMapper.selectById(id);
        if (record == null) {
            throw new IllegalArgumentException("修复记录不存在");
        }
        
        if (!"修复中".equals(record.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许完成修复");
        }
        
        // 检查文物状态
        com.example.entity.CulturalRelic relic = repairRecordMapper.selectRelicById(record.getRelicId());
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }
        
        // 更新修复记录状态
        record.setStatus("修复完成");
        record.setCompleteDate(LocalDateTime.now());
        
        if (request != null) {
            if (request.getRepairProcess() != null) {
                record.setRepairProcess(request.getRepairProcess());
            }
            if (request.getRepairMethod() != null) {
                record.setRepairMethod(request.getRepairMethod());
            }
            // 注意：材料使用信息通过repair_record_material关联表管理
            if (request.getActualCost() != null) {
                record.setActualCost(request.getActualCost());
            }
            if (request.getAfterImages() != null) {
                record.setAfterImages(request.getAfterImages());
            }
            if (request.getQualityScore() != null) {
                record.setQualityScore(request.getQualityScore());
            }
            if (request.getQualityRemark() != null) {
                record.setQualityRemark(request.getQualityRemark());
            }
            if (request.getRemark() != null) {
                record.setRemark(request.getRemark());
            }
        }
        
        boolean updated = repairRecordMapper.updateById(record) > 0;
        
        // 更新文物状态为"在库"
        if (updated) {
            relic.setStatus("在库");
            relic.setUpdateTime(LocalDateTime.now());
            updateRelicStatus(relic);
        }
        
        log.info("完成修复：id={}, repairCode={}, qualityScore={}", id, record.getRepairCode(), record.getQualityScore());
        
        return updated;
    }
    
    /**
     * 更新文物状态（通过Mapper）
     */
    private void updateRelicStatus(com.example.entity.CulturalRelic relic) {
        repairRecordMapper.updateRelicStatus(relic.getId(), relic.getStatus(), relic.getUpdateTime());
    }
    
    @Override
    @Transactional
    public boolean deleteById(Long id) {
        RepairRecord record = repairRecordMapper.selectById(id);
        if (record == null) {
            throw new IllegalArgumentException("修复记录不存在");
        }
        
        // 只允许删除待审批和已拒绝的记录
        if (!"待审批".equals(record.getStatus()) && !"已拒绝".equals(record.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许删除");
        }
        
        log.info("删除修复记录：id={}, repairCode={}", id, record.getRepairCode());
        
        return repairRecordMapper.deleteById(id) > 0;
    }
    
    @Override
    public Map<String, Long> countByStatus() {
        List<Map<String, Object>> list = repairRecordMapper.countByStatus();
        Map<String, Long> result = new HashMap<>();
        
        for (Map<String, Object> item : list) {
            String status = (String) item.get("status");
            Long count = ((Number) item.get("count")).longValue();
            result.put(status, count);
        }
        
        return result;
    }
}
