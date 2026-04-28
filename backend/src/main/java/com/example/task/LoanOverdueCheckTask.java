package com.example.task;

import com.example.entity.CulturalRelic;
import com.example.entity.LoanRecord;
import com.example.service.CulturalRelicService;
import com.example.service.LoanRecordService;
import com.example.service.NotificationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * 借展逾期检查定时任务
 * 每天凌晨1点检查是否有逾期的借展记录
 */
@Component
public class LoanOverdueCheckTask {
    
    private static final Logger log = LoggerFactory.getLogger(LoanOverdueCheckTask.class);
    
    private final LoanRecordService loanRecordService;
    private final CulturalRelicService culturalRelicService;
    private final NotificationService notificationService;
    
    public LoanOverdueCheckTask(LoanRecordService loanRecordService,
                                CulturalRelicService culturalRelicService,
                                NotificationService notificationService) {
        this.loanRecordService = loanRecordService;
        this.culturalRelicService = culturalRelicService;
        this.notificationService = notificationService;
    }
    
    /**
     * 每天凌晨1点执行
     */
    @Scheduled(cron = "0 0 1 * * ?")
    public void checkOverdueLoans() {
        log.info("开始检查逾期借展记录...");
        
        try {
            // 获取所有"借展中"状态的借展记录
            List<LoanRecord> loanRecords = loanRecordService.listByStatus("借展中");
            
            LocalDate today = LocalDate.now();
            int overdueCount = 0;
            
            for (LoanRecord record : loanRecords) {
                if (record.getExpectedReturnDate() == null) {
                    continue;
                }
                
                LocalDate returnDate = record.getExpectedReturnDate().toLocalDate();
                
                // 如果预计归还日期早于今天，说明已逾期
                if (returnDate.isBefore(today)) {
                    int overdueDays = (int) ChronoUnit.DAYS.between(returnDate, today);
                    
                    // 获取文物信息
                    CulturalRelic relic = culturalRelicService.getById(record.getRelicId());
                    if (relic == null) {
                        continue;
                    }
                    
                    // 发送逾期通知
                    try {
                        notificationService.sendLoanOverdueNotification(
                            record.getId(),
                            record.getBorrowerName(),
                            relic.getRelicName(),
                            overdueDays
                        );
                        overdueCount++;
                        log.info("发送逾期通知：loanId={}, borrower={}, relic={}, overdueDays={}", 
                                record.getId(), record.getBorrowerName(), relic.getRelicName(), overdueDays);
                    } catch (Exception e) {
                        log.error("发送逾期通知失败：loanId={}, error={}", record.getId(), e.getMessage(), e);
                    }
                }
            }
            
            log.info("逾期借展检查完成：总记录数={}, 逾期数={}", loanRecords.size(), overdueCount);
        } catch (Exception e) {
            log.error("检查逾期借展记录失败：{}", e.getMessage(), e);
        }
    }
}
