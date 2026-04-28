package com.example.task;

import com.example.entity.LoanRecord;
import com.example.service.LoanRecordService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Component
public class LoanOverdueTask {

    private final LoanRecordService loanRecordService;

    public LoanOverdueTask(LoanRecordService loanRecordService) {
        this.loanRecordService = loanRecordService;
    }

    @Scheduled(cron = "0 0 1 * * ?")
    public void markOverdueLoans() {
        List<LoanRecord> borrowingList = loanRecordService.listByStatus("借展中");

        LocalDateTime now = LocalDateTime.now();
        for (LoanRecord loan : borrowingList) {
            if (loan.getExpectedReturnDate() != null && now.isAfter(loan.getExpectedReturnDate())) {
                loan.setStatus("逾期");
                loan.setUpdateTime(now);
                loanRecordService.updateById(loan);
                log.info("借展记录已标记逾期: id={}", loan.getId());
            }
        }
    }
}
