package com.example.service.impl;

import com.example.mapper.*;
import com.example.service.ReportService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * 报表服务实现
 */
@Slf4j
@Service
public class ReportServiceImpl implements ReportService {
    
    private final CulturalRelicMapper culturalRelicMapper;
    private final LoanRecordMapper loanRecordMapper;
    private final MaintenanceRecordMapper maintenanceRecordMapper;
    private final RepairRecordMapper repairRecordMapper;
    
    public ReportServiceImpl(CulturalRelicMapper culturalRelicMapper,
                            LoanRecordMapper loanRecordMapper,
                            MaintenanceRecordMapper maintenanceRecordMapper,
                            RepairRecordMapper repairRecordMapper) {
        this.culturalRelicMapper = culturalRelicMapper;
        this.loanRecordMapper = loanRecordMapper;
        this.maintenanceRecordMapper = maintenanceRecordMapper;
        this.repairRecordMapper = repairRecordMapper;
    }
    
    @Override
    public Map<String, Object> getDashboardData() {
        Map<String, Object> data = new HashMap<>();
        
        // 文物总数
        long totalRelics = culturalRelicMapper.count(null, null, null, null);
        data.put("totalRelics", totalRelics);
        
        // 在库文物数
        long inStockRelics = culturalRelicMapper.count(null, null, "在库", null);
        data.put("inStockRelics", inStockRelics);
        
        // 借展中文物数
        long loaningRelics = culturalRelicMapper.count(null, null, "借展中", null);
        data.put("loaningRelics", loaningRelics);
        
        // 修复中文物数
        long repairingRelics = culturalRelicMapper.count(null, null, "修复中", null);
        data.put("repairingRelics", repairingRelics);
        
        // 借展记录统计
        Map<String, Long> loanStats = new HashMap<>();
        long totalLoans = loanRecordMapper.count(null);
        loanStats.put("total", totalLoans);
        loanStats.put("pending", loanRecordMapper.count("待审批"));
        loanStats.put("loaning", loanRecordMapper.count("借展中"));
        loanStats.put("returned", loanRecordMapper.count("已归还"));
        loanStats.put("rejected", loanRecordMapper.count("已驳回"));
        loanStats.put("overdue", loanRecordMapper.count("逾期"));
        data.put("loanStats", loanStats);
        log.info("借展统计数据: {}", loanStats);
        
        // 修复记录统计
        List<Map<String, Object>> repairStatusList = repairRecordMapper.countByStatus();
        Map<String, Long> repairStats = new HashMap<>();
        
        // 初始化所有状态为0
        repairStats.put("pending", 0L);
        repairStats.put("waitingRepair", 0L);
        repairStats.put("repairing", 0L);
        repairStats.put("completed", 0L);
        repairStats.put("rejected", 0L);
        
        // 填充实际数据
        for (Map<String, Object> item : repairStatusList) {
            String status = (String) item.get("status");
            Object countObj = item.get("count");
            Long count = 0L;
            
            if (countObj instanceof Long) {
                count = (Long) countObj;
            } else if (countObj instanceof Integer) {
                count = ((Integer) countObj).longValue();
            }
            
            // 映射状态到前端期望的键名
            if ("待审批".equals(status)) {
                repairStats.put("pending", count);
            } else if ("待修复".equals(status)) {
                repairStats.put("waitingRepair", count);
            } else if ("修复中".equals(status)) {
                repairStats.put("repairing", count);
            } else if ("修复完成".equals(status) || "已完成".equals(status)) {
                repairStats.put("completed", count);
            } else if ("已拒绝".equals(status)) {
                repairStats.put("rejected", count);
            }
        }
        data.put("repairStats", repairStats);
        log.info("修复统计数据: {}", repairStats);
        
        // 分类统计
        List<Map<String, Object>> categoryStats = culturalRelicMapper.countByCategory();
        log.info("分类统计数据: {}", categoryStats);
        data.put("categoryStats", categoryStats);
        
        // 年代统计
        List<Map<String, Object>> eraStats = culturalRelicMapper.countByEra();
        log.info("年代统计数据: {}", eraStats);
        data.put("eraStats", eraStats);
        
        // 热力图数据 - 按月统计活动
        Map<String, Object> heatmapData = getActivityHeatmapData();
        data.put("heatmapData", heatmapData);
        log.info("热力图数据: {}", heatmapData);
        
        // 近30天维护记录数 - 简化实现
        long maintenanceCount = maintenanceRecordMapper.countAll(null, null, null, null);
        data.put("recentMaintenanceCount", maintenanceCount);
        
        return data;
    }
    
    /**
     * 获取活动热力图数据（按月统计）
     */
    private Map<String, Object> getActivityHeatmapData() {
        Map<String, Object> result = new HashMap<>();
        
        // 获取当前年份
        int currentYear = LocalDate.now().getYear();
        
        // 统计每月的活动数据
        List<Map<String, Object>> monthlyData = new ArrayList<>();
        
        for (int month = 1; month <= 12; month++) {
            Map<String, Object> monthData = new HashMap<>();
            monthData.put("month", month);
            
            // 入库数量（文物创建时间在该月的数量）
            long relicCount = culturalRelicMapper.countByMonth(currentYear, month);
            monthData.put("relicCount", relicCount);
            
            // 借展数量（借展日期在该月的数量）
            long loanCount = loanRecordMapper.countByMonth(currentYear, month);
            monthData.put("loanCount", loanCount);
            
            // 修复数量（修复开始日期在该月的数量）
            long repairCount = repairRecordMapper.countByMonth(currentYear, month);
            monthData.put("repairCount", repairCount);
            
            // 维护数量（维护日期在该月的数量）
            long maintenanceCount = maintenanceRecordMapper.countByMonth(currentYear, month);
            monthData.put("maintenanceCount", maintenanceCount);
            
            monthlyData.add(monthData);
        }
        
        result.put("year", currentYear);
        result.put("monthlyData", monthlyData);
        
        return result;
    }
    
    @Override
    public Map<String, Object> getAnnualReport(Integer year) {
        Map<String, Object> report = new HashMap<>();
        report.put("year", year);
        
        // 统计该年度的总数
        long annualLoans = 0;
        long annualMaintenance = 0;
        long annualRepairs = 0;
        long newRelicsCount = 0;
        
        // 月度趋势 - 使用真实数据库查询
        List<Map<String, Object>> monthlyTrend = new ArrayList<>();
        
        for (int month = 1; month <= 12; month++) {
            Map<String, Object> monthData = new HashMap<>();
            monthData.put("month", month);
            
            // 查询该月的借展数量
            long monthLoans = loanRecordMapper.countByMonth(year, month);
            monthData.put("loans", monthLoans);
            annualLoans += monthLoans;
            
            // 查询该月的维护数量
            long monthMaintenance = maintenanceRecordMapper.countByMonth(year, month);
            monthData.put("maintenance", monthMaintenance);
            annualMaintenance += monthMaintenance;
            
            // 查询该月的修复数量
            long monthRepairs = repairRecordMapper.countByMonth(year, month);
            monthData.put("repairs", monthRepairs);
            annualRepairs += monthRepairs;
            
            // 查询该月的新增文物数量
            long monthRelics = culturalRelicMapper.countByMonth(year, month);
            monthData.put("newRelics", monthRelics);
            newRelicsCount += monthRelics;
            
            monthlyTrend.add(monthData);
        }
        
        report.put("annualLoans", annualLoans);
        report.put("annualMaintenance", annualMaintenance);
        report.put("annualRepairs", annualRepairs);
        report.put("newRelicsCount", newRelicsCount);
        report.put("monthlyTrend", monthlyTrend);
        
        log.info("生成年度报告：year={}, loans={}, maintenance={}, repairs={}, newRelics={}", 
            year, annualLoans, annualMaintenance, annualRepairs, newRelicsCount);
        
        return report;
    }
    
    @Override
    public Map<String, Object> getTrendAnalysis(LocalDate startDate, LocalDate endDate, String type) {
        Map<String, Object> trend = new HashMap<>();
        trend.put("startDate", startDate.toString());
        trend.put("endDate", endDate.toString());
        trend.put("type", type);
        
        List<Map<String, Object>> dataPoints = new ArrayList<>();
        
        // 按天统计真实数据
        LocalDate current = startDate;
        while (!current.isAfter(endDate)) {
            Map<String, Object> point = new HashMap<>();
            point.put("date", current.toString());
            
            String dateStr = current.toString();
            long count = 0;
            
            // 根据类型查询对应的数据
            switch (type) {
                case "loan":
                    count = loanRecordMapper.countByDateRange(dateStr, dateStr);
                    break;
                case "maintenance":
                    count = maintenanceRecordMapper.countByDateRange(dateStr, dateStr);
                    break;
                case "repair":
                    count = repairRecordMapper.countByDateRange(dateStr, dateStr);
                    break;
                case "relic":
                    count = culturalRelicMapper.countByDateRange(dateStr, dateStr);
                    break;
                default:
                    count = 0;
            }
            
            point.put("count", count);
            dataPoints.add(point);
            current = current.plusDays(1);
        }
        
        trend.put("dataPoints", dataPoints);
        
        log.info("生成趋势分析：type={}, start={}, end={}, points={}", 
            type, startDate, endDate, dataPoints.size());
        
        return trend;
    }
    
    @Override
    public Map<String, Object> getComparisonAnalysis(Integer year1, Integer year2) {
        Map<String, Object> comparison = new HashMap<>();
        comparison.put("year1", year1);
        comparison.put("year2", year2);
        
        // 统计year1的数据
        long year1Loans = 0;
        long year1Maintenance = 0;
        long year1Repairs = 0;
        long year1Relics = 0;
        
        for (int month = 1; month <= 12; month++) {
            year1Loans += loanRecordMapper.countByMonth(year1, month);
            year1Maintenance += maintenanceRecordMapper.countByMonth(year1, month);
            year1Repairs += repairRecordMapper.countByMonth(year1, month);
            year1Relics += culturalRelicMapper.countByMonth(year1, month);
        }
        
        // 统计year2的数据
        long year2Loans = 0;
        long year2Maintenance = 0;
        long year2Repairs = 0;
        long year2Relics = 0;
        
        for (int month = 1; month <= 12; month++) {
            year2Loans += loanRecordMapper.countByMonth(year2, month);
            year2Maintenance += maintenanceRecordMapper.countByMonth(year2, month);
            year2Repairs += repairRecordMapper.countByMonth(year2, month);
            year2Relics += culturalRelicMapper.countByMonth(year2, month);
        }
        
        Map<String, Long> year1Data = new HashMap<>();
        year1Data.put("loans", year1Loans);
        year1Data.put("maintenance", year1Maintenance);
        year1Data.put("repairs", year1Repairs);
        year1Data.put("relics", year1Relics);
        
        Map<String, Long> year2Data = new HashMap<>();
        year2Data.put("loans", year2Loans);
        year2Data.put("maintenance", year2Maintenance);
        year2Data.put("repairs", year2Repairs);
        year2Data.put("relics", year2Relics);
        
        comparison.put("year1Data", year1Data);
        comparison.put("year2Data", year2Data);
        
        // 计算增长率
        Map<String, Double> growthRate = new HashMap<>();
        growthRate.put("loans", calculateGrowthRate(year1Loans, year2Loans));
        growthRate.put("maintenance", calculateGrowthRate(year1Maintenance, year2Maintenance));
        growthRate.put("repairs", calculateGrowthRate(year1Repairs, year2Repairs));
        growthRate.put("relics", calculateGrowthRate(year1Relics, year2Relics));
        
        comparison.put("growthRate", growthRate);
        
        log.info("生成对比分析：year1={}, year2={}, year1Data={}, year2Data={}", 
            year1, year2, year1Data, year2Data);
        
        return comparison;
    }
    
    @Override
    public Map<String, Object> getCategoryStats() {
        Map<String, Object> stats = new HashMap<>();
        // 简化实现，返回空列表
        List<Map<String, Object>> categoryList = new ArrayList<>();
        stats.put("categories", categoryList);
        return stats;
    }
    
    @Override
    public Map<String, Object> getStatusStats() {
        Map<String, Object> stats = new HashMap<>();
        
        Map<String, Long> statusCount = new HashMap<>();
        statusCount.put("在库", culturalRelicMapper.count(null, null, "在库", null));
        statusCount.put("借展中", culturalRelicMapper.count(null, null, "借展中", null));
        statusCount.put("修复中", culturalRelicMapper.count(null, null, "修复中", null));
        statusCount.put("封存", culturalRelicMapper.count(null, null, "封存", null));
        
        stats.put("statusCount", statusCount);
        return stats;
    }
    
    @Override
    public void exportExcel(String reportType, Integer year, HttpServletResponse response) {
        try {
            response.setContentType("application/vnd.ms-excel");
            response.setCharacterEncoding("UTF-8");
            String fileName = reportType + "_" + year + "_" + 
                LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".xlsx";
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
            
            // 这里需要使用 Apache POI 或 EasyExcel 来生成Excel
            // 简化实现，实际项目中需要完整实现
            response.getWriter().write("Excel export not fully implemented yet");
            
            log.info("导出Excel报表：type={}, year={}", reportType, year);
        } catch (IOException e) {
            log.error("导出Excel失败", e);
        }
    }
    
    @Override
    public void exportPdf(String reportType, Integer year, HttpServletResponse response) {
        try {
            response.setContentType("application/pdf");
            response.setCharacterEncoding("UTF-8");
            String fileName = reportType + "_" + year + "_" + 
                LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")) + ".pdf";
            response.setHeader("Content-Disposition", "attachment; filename=" + fileName);
            
            // 这里需要使用 iText 或其他PDF库来生成PDF
            // 简化实现，实际项目中需要完整实现
            response.getWriter().write("PDF export not fully implemented yet");
            
            log.info("导出PDF报表：type={}, year={}", reportType, year);
        } catch (IOException e) {
            log.error("导出PDF失败", e);
        }
    }
    
    @Override
    public Map<String, Object> getCustomReport(Map<String, Object> params) {
        Map<String, Object> report = new HashMap<>();
        
        // 根据参数动态生成报表
        String reportType = (String) params.get("reportType");
        LocalDate startDate = LocalDate.parse((String) params.get("startDate"));
        LocalDate endDate = LocalDate.parse((String) params.get("endDate"));
        
        report.put("reportType", reportType);
        report.put("startDate", startDate.toString());
        report.put("endDate", endDate.toString());
        report.put("data", new ArrayList<>());
        
        log.info("生成自定义报表：type={}, start={}, end={}", reportType, startDate, endDate);
        
        return report;
    }
    
    private double calculateGrowthRate(Long oldValue, Long newValue) {
        if (oldValue == null || oldValue == 0) {
            return newValue == null || newValue == 0 ? 0 : 100;
        }
        if (newValue == null) {
            return -100;
        }
        return ((newValue - oldValue) * 100.0) / oldValue;
    }
}
