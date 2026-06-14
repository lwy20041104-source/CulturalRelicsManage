package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.PageResult;
import com.example.common.Result;
import com.example.dto.LoanApproveRequest;
import com.example.entity.LoanRecord;
import com.example.entity.SysUser;
import com.example.mapper.SysUserMapper;
import com.example.service.LoanRecordService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/loans")
public class LoanRecordController {

    private final LoanRecordService loanRecordService;
    private final SysUserMapper sysUserMapper;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;

    public LoanRecordController(LoanRecordService loanRecordService, 
                               SysUserMapper sysUserMapper,
                               SysOperationLogService operationLogService,
                               UserContextUtil userContextUtil) {
        this.loanRecordService = loanRecordService;
        this.sysUserMapper = sysUserMapper;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }

    @GetMapping
    public Result<PageResult<LoanRecord>> page(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status
    ) {
        return Result.success(loanRecordService.pageLoans(pageNum, pageSize, status));
    }

    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "借展管理", operationContent = "提交借展申请")
    public Result<Boolean> save(@RequestBody LoanRecord loanRecord) {
        // 验证借展日期
        if (loanRecord.getLoanDate() == null) {
            return Result.error("借展日期不能为空");
        }
        
        // 验证预计归还日期
        if (loanRecord.getExpectedReturnDate() == null) {
            return Result.error("预计归还日期不能为空");
        }
        
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime today = now.toLocalDate().atStartOfDay(); // 今天的开始时间（00:00:00）
        
        // 借展日期不能早于今天
        if (loanRecord.getLoanDate().isBefore(today)) {
            return Result.error("借展日期不能早于今天");
        }
        
        // 预计归还日期必须是当前时间及以后
        if (loanRecord.getExpectedReturnDate().isBefore(now)) {
            return Result.error("预计归还日期必须是当前时间及以后");
        }
        
        // 预计归还日期必须晚于借展日期
        if (loanRecord.getExpectedReturnDate().isBefore(loanRecord.getLoanDate()) || 
            loanRecord.getExpectedReturnDate().isEqual(loanRecord.getLoanDate())) {
            return Result.error("预计归还日期必须晚于借展日期");
        }
        
        // 从borrowerName获取borrowerId
        if (loanRecord.getBorrowerName() != null && !loanRecord.getBorrowerName().isEmpty()) {
            // 先尝试通过real_name查询（返回列表，取第一个匹配）
            List<SysUser> users = sysUserMapper.selectByRealName(loanRecord.getBorrowerName());
            SysUser user = (users != null && !users.isEmpty()) ? users.get(0) : null;
            if (user == null) {
                // 如果找不到，尝试通过username查询
                user = sysUserMapper.selectByUsername(loanRecord.getBorrowerName());
            }
            if (user != null) {
                loanRecord.setBorrowerId(user.getId());
            }
        }
        
        loanRecord.setStatus("待审批");
        loanRecord.setCreateTime(LocalDateTime.now());
        loanRecord.setUpdateTime(LocalDateTime.now());
        return Result.success("申请成功", loanRecordService.save(loanRecord));
    }

    @PutMapping("/approve")
    public Result<Boolean> approve(@RequestBody LoanApproveRequest request, 
                                   javax.servlet.http.HttpServletRequest httpRequest) {
        // 1. 获取审批前的数据
        LoanRecord oldLoan = loanRecordService.getById(request.getId());
        
        // 2. 执行审批操作
        boolean result = loanRecordService.approveLoan(
                request.getId(),
                request.getApproverName(),
                request.getApproveRemark(),
                Boolean.TRUE.equals(request.getApproved())
        );
        
        // 3. 获取审批后的数据并记录审计日志
        if (result && oldLoan != null) {
            try {
                LoanRecord newLoan = loanRecordService.getById(request.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "审批",
                    "借展管理",
                    "LOAN",
                    request.getId(),
                    oldLoan,
                    newLoan,
                    ipAddress,
                    "PUT",
                    "/loans/approve"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("审批完成", result);
    }

    @PutMapping("/{id}/return")
    public Result<Boolean> returnLoan(@PathVariable Long id, HttpServletRequest httpRequest) {
        // 1. 获取归还前的数据
        LoanRecord oldLoan = loanRecordService.getById(id);
        
        // 2. 执行归还操作
        boolean success = loanRecordService.returnLoan(id);
        
        // 3. 记录审计日志
        if (success && oldLoan != null) {
            try {
                LoanRecord newLoan = loanRecordService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "归还",
                    "借展管理",
                    "LOAN",
                    id,
                    oldLoan,
                    newLoan,
                    ipAddress,
                    "PUT",
                    "/loans/" + id + "/return"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("归还登记成功", success);
    }

    @GetMapping("/overdue")
    public Result<List<LoanRecord>> overdue() {
        return Result.success(loanRecordService.listByStatus("逾期"));
    }

    /**
     * 查询当前用户的借展记录（前台用户端）
     */
    @GetMapping("/my")
    public Result<PageResult<LoanRecord>> myLoans(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String status
    ) {
        // 从 SecurityContext 获取当前用户名
        String username = userContextUtil.getCurrentUsername();
        return Result.success(loanRecordService.pageMyLoans(pageNum, pageSize, status, username));
    }

    /**
     * 用户主动归还文物（前台用户端）
     */
    @PutMapping("/{id}/user-return")
    public Result<Boolean> userReturnLoan(@PathVariable Long id, HttpServletRequest httpRequest) {
        // 1. 获取归还前的数据
        LoanRecord oldLoan = loanRecordService.getById(id);
        
        // 2. 从 SecurityContext 获取当前用户名
        String username = userContextUtil.getCurrentUsername();
        boolean success = loanRecordService.userReturnLoan(id, username);
        
        // 3. 记录审计日志
        if (success && oldLoan != null) {
            try {
                LoanRecord newLoan = loanRecordService.getById(id);
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(httpRequest);
                
                operationLogService.logDataChange(
                    userId,
                    realName,
                    "归还申请",
                    "借展管理",
                    "LOAN",
                    id,
                    oldLoan,
                    newLoan,
                    ipAddress,
                    "PUT",
                    "/loans/" + id + "/user-return"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("归还申请已提交", success);
    }
}
