package com.example.service.impl;

import com.example.common.PageResult;
import com.example.entity.CulturalRelic;
import com.example.entity.LoanRecord;
import com.example.entity.SysUser;
import com.example.mapper.LoanRecordMapper;
import com.example.mapper.SysUserMapper;
import com.example.service.CulturalRelicService;
import com.example.service.LoanRecordService;
import com.example.service.NotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class LoanRecordServiceImpl implements LoanRecordService {

    private static final Logger log = LoggerFactory.getLogger(LoanRecordServiceImpl.class);

    private final CulturalRelicService culturalRelicService;
    private final LoanRecordMapper loanRecordMapper;
    private final NotificationService notificationService;
    private final SysUserMapper sysUserMapper;

    public LoanRecordServiceImpl(CulturalRelicService culturalRelicService, 
                                 LoanRecordMapper loanRecordMapper,
                                 NotificationService notificationService,
                                 SysUserMapper sysUserMapper) {
        this.culturalRelicService = culturalRelicService;
        this.loanRecordMapper = loanRecordMapper;
        this.notificationService = notificationService;
        this.sysUserMapper = sysUserMapper;
    }

    @Override
    public PageResult<LoanRecord> pageLoans(Integer pageNum, Integer pageSize, String status) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        List<LoanRecord> records = loanRecordMapper.selectPage(offset, size, status);
        long total = loanRecordMapper.count(status);
        return new PageResult<>(records, total, current, size);
    }

    @Override
    public boolean save(LoanRecord loanRecord) {
        // 检查文物状态
        CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
        if (relic == null) {
            throw new IllegalArgumentException("文物不存在");
        }
        
        // 只有"在库"状态的文物才能申请借展
        if (!"在库".equals(relic.getStatus())) {
            throw new IllegalArgumentException("只有在库状态的文物才能申请借展，当前状态：" + relic.getStatus());
        }
        
        // 设置初始状态为"待审批"
        loanRecord.setStatus("待审批");
        loanRecord.setCreateTime(LocalDateTime.now());
        loanRecord.setUpdateTime(LocalDateTime.now());
        
        boolean success = loanRecordMapper.insert(loanRecord) > 0;
        
        // 发送借展申请通知
        if (success && loanRecord.getBorrowerId() != null) {
            try {
                notificationService.sendLoanApplyNotification(
                    loanRecord.getId(),
                    loanRecord.getBorrowerName(),
                    relic.getRelicName(),
                    loanRecord.getBorrowerId()
                );
                log.info("借展申请通知已发送：loanId={}, borrowerId={}, borrower={}, relic={}", 
                        loanRecord.getId(), loanRecord.getBorrowerId(), loanRecord.getBorrowerName(), relic.getRelicName());
            } catch (Exception e) {
                log.error("发送借展申请通知失败：{}", e.getMessage(), e);
            }
        }
        
        return success;
    }

    @Override
    public LoanRecord getById(Long id) {
        return loanRecordMapper.selectById(id);
    }

    @Override
    public boolean updateById(LoanRecord loanRecord) {
        return loanRecordMapper.updateById(loanRecord) > 0;
    }

    @Override
    public List<LoanRecord> listByStatus(String status) {
        return loanRecordMapper.selectByStatus(status);
    }

    @Override
    public List<LoanRecord> list() {
        return loanRecordMapper.selectAll();
    }

    @Override
    public boolean approveLoan(Long id, String approverName, String approveRemark, boolean approved) {
        LoanRecord loanRecord = this.getById(id);
        if (loanRecord == null) {
            throw new IllegalArgumentException("借展记录不存在");
        }
        loanRecord.setApproverName(approverName);
        loanRecord.setApproveRemark(approveRemark);
        loanRecord.setApproveTime(LocalDateTime.now());
        loanRecord.setStatus(approved ? "借展中" : "已驳回");

        boolean updated = this.updateById(loanRecord);
        if (updated && approved) {
            CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
            if (relic != null) {
                relic.setStatus("借展中");
                relic.setUpdateTime(LocalDateTime.now());
                culturalRelicService.updateById(relic);
            }
        }
        
        // 发送借展审批结果通知
        if (updated && loanRecord.getBorrowerId() != null) {
            try {
                CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
                if (relic != null) {
                    notificationService.sendLoanApprovalNotification(
                        loanRecord.getId(),
                        loanRecord.getBorrowerId(),
                        relic.getRelicName(),
                        approved,
                        approverName
                    );
                    log.info("借展审批结果通知已发送：loanId={}, borrowerId={}, approved={}, approver={}", 
                            loanRecord.getId(), loanRecord.getBorrowerId(), approved, approverName);
                }
            } catch (Exception e) {
                log.error("发送借展审批结果通知失败：{}", e.getMessage(), e);
            }
        }
        
        return updated;
    }

    @Override
    public boolean returnLoan(Long id) {
        LoanRecord loanRecord = this.getById(id);
        if (loanRecord == null) {
            throw new IllegalArgumentException("借展记录不存在");
        }
        loanRecord.setStatus("已归还");
        loanRecord.setActualReturnDate(LocalDateTime.now());
        loanRecord.setUpdateTime(LocalDateTime.now());

        boolean updated = this.updateById(loanRecord);
        if (updated) {
            CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
            if (relic != null) {
                relic.setStatus("在库");
                relic.setUpdateTime(LocalDateTime.now());
                culturalRelicService.updateById(relic);
            }
        }
        return updated;
    }

    @Override
    public PageResult<LoanRecord> pageMyLoans(Integer pageNum, Integer pageSize, String status, String username) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        int offset = (current - 1) * size;
        
        // 根据用户名查询该用户的借展记录
        List<LoanRecord> records = loanRecordMapper.selectPageByBorrowerName(offset, size, status, username);
        long total = loanRecordMapper.countByBorrowerName(status, username);
        
        log.info("查询用户借展记录：username={}, status={}, total={}", username, status, total);
        return new PageResult<>(records, total, current, size);
    }

    @Override
    public boolean userReturnLoan(Long id, String username) {
        LoanRecord loanRecord = this.getById(id);
        if (loanRecord == null) {
            throw new IllegalArgumentException("借展记录不存在");
        }
        
        SysUser currentUser = sysUserMapper.selectByUsername(username);
        if (currentUser == null) {
            throw new IllegalArgumentException("当前用户不存在");
        }

        // 验证是否是该用户的借展记录（按 borrower_id 校验，避免用户名/真实姓名混用）
        if (loanRecord.getBorrowerId() == null || !currentUser.getId().equals(loanRecord.getBorrowerId())) {
            throw new IllegalArgumentException("无权操作此借展记录");
        }
        
        // 只有"借展中"和"逾期"状态的记录才能归还
        if (!"借展中".equals(loanRecord.getStatus()) && !"逾期".equals(loanRecord.getStatus())) {
            throw new IllegalArgumentException("当前状态不允许归还");
        }
        
        // 更新借展记录状态
        loanRecord.setStatus("已归还");
        loanRecord.setActualReturnDate(LocalDateTime.now());
        loanRecord.setUpdateTime(LocalDateTime.now());
        
        boolean updated = this.updateById(loanRecord);
        if (updated) {
            // 更新文物状态
            CulturalRelic relic = culturalRelicService.getById(loanRecord.getRelicId());
            if (relic != null) {
                relic.setStatus("在库");
                relic.setUpdateTime(LocalDateTime.now());
                culturalRelicService.updateById(relic);
                
                // 发送通知给后台管理员
                try {
                    notificationService.sendUserReturnNotification(
                        loanRecord.getId(),
                        username,
                        relic.getRelicName()
                    );
                    log.info("用户主动归还文物，已发送通知：loanId={}, user={}, relic={}", 
                            loanRecord.getId(), username, relic.getRelicName());
                } catch (Exception e) {
                    log.error("发送用户归还通知失败：loanId={}, error={}", loanRecord.getId(), e.getMessage(), e);
                }
            }
        }
        
        return updated;
    }
}
