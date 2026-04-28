package com.example.service;

import com.example.common.PageResult;
import com.example.entity.LoanRecord;

import java.util.List;

public interface LoanRecordService {
    PageResult<LoanRecord> pageLoans(Integer pageNum, Integer pageSize, String status);
    boolean save(LoanRecord loanRecord);
    LoanRecord getById(Long id);
    boolean updateById(LoanRecord loanRecord);
    List<LoanRecord> listByStatus(String status);
    List<LoanRecord> list();
    boolean approveLoan(Long id, String approverName, String approveRemark, boolean approved);
    boolean returnLoan(Long id);
    
    // 前台用户端接口
    PageResult<LoanRecord> pageMyLoans(Integer pageNum, Integer pageSize, String status, String username);
    boolean userReturnLoan(Long id, String username);
}
