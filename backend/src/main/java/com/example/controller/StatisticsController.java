package com.example.controller;

import com.example.common.CacheConstants;
import com.example.common.Result;
import com.example.dto.StatisticsOverviewVO;
import com.example.entity.CulturalRelic;
import com.example.entity.LoanRecord;
import com.example.service.CulturalRelicService;
import com.example.service.LoanRecordService;
import com.example.service.MaintenanceRecordService;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/statistics")
public class StatisticsController {

    private final CulturalRelicService culturalRelicService;
    private final LoanRecordService loanRecordService;
    private final MaintenanceRecordService maintenanceRecordService;

    public StatisticsController(CulturalRelicService culturalRelicService,
                                LoanRecordService loanRecordService,
                                MaintenanceRecordService maintenanceRecordService) {
        this.culturalRelicService = culturalRelicService;
        this.loanRecordService = loanRecordService;
        this.maintenanceRecordService = maintenanceRecordService;
    }

    @GetMapping("/overview")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'overview'")
    public Result<StatisticsOverviewVO> overview() {
        StatisticsOverviewVO vo = new StatisticsOverviewVO();
        vo.setRelicTotal(culturalRelicService.count());
        vo.setInStockTotal(culturalRelicService.countByStatus("在库"));
        vo.setLoaningTotal(culturalRelicService.countByStatus("借展中"));
        vo.setMaintenanceTotal(maintenanceRecordService.count());
        return Result.success(vo);
    }

    @GetMapping("/category-distribution")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'category-distribution'")
    public Result<Map<String, Long>> categoryDistribution() {
        List<CulturalRelic> relics = culturalRelicService.list();
        Map<String, Long> result = relics.stream()
                .collect(Collectors.groupingBy(relic -> String.valueOf(relic.getCategoryId()), Collectors.counting()));
        return Result.success(result);
    }

    @GetMapping("/loan-frequency")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'loan-frequency'")
    public Result<Map<Long, Long>> loanFrequency() {
        List<LoanRecord> loans = loanRecordService.list();
        Map<Long, Long> result = loans.stream()
                .collect(Collectors.groupingBy(LoanRecord::getRelicId, Collectors.counting()));
        return Result.success(result);
    }

    @GetMapping("/status-distribution")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'status-distribution'")
    public Result<Map<String, Long>> statusDistribution() {
        List<CulturalRelic> relics = culturalRelicService.list();
        Map<String, Long> result = relics.stream()
                .collect(Collectors.groupingBy(CulturalRelic::getStatus, Collectors.counting()));
        return Result.success(result);
    }

    @GetMapping("/relics")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'relics'")
    public Result<Map<String, Long>> relicStats() {
        return statusDistribution();
    }

    @GetMapping("/loans")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'loans'")
    public Result<Map<Long, Long>> loanStats() {
        return loanFrequency();
    }

    @GetMapping("/maintenance")
    @Cacheable(value = CacheConstants.STATISTICS_CACHE, key = "'maintenance'")
    public Result<Map<String, Long>> maintenanceStats() {
        Map<String, Long> map = new HashMap<>();
        map.put("total", maintenanceRecordService.count());
        return Result.success(map);
    }
}
