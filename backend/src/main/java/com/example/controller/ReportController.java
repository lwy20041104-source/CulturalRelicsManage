package com.example.controller;

import com.example.common.Result;
import com.example.service.ReportService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.Map;

/**
 * 报表统计控制器
 */
@RestController
@RequestMapping("/reports")
public class ReportController {
    
    private final ReportService reportService;
    
    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }
    
    /**
     * 获取综合统计数据（用于数据大屏）
     */
    @GetMapping("/dashboard")
    public Result<Map<String, Object>> getDashboardData() {
        Map<String, Object> data = reportService.getDashboardData();
        return Result.success(data);
    }
    
    /**
     * 获取年度统计报告
     */
    @GetMapping("/annual")
    public Result<Map<String, Object>> getAnnualReport(
            @RequestParam(required = false) Integer year) {
        if (year == null) {
            year = LocalDate.now().getYear();
        }
        Map<String, Object> report = reportService.getAnnualReport(year);
        return Result.success(report);
    }
    
    /**
     * 获取趋势分析数据
     */
    @GetMapping("/trend")
    public Result<Map<String, Object>> getTrendAnalysis(
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate startDate,
            @RequestParam @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate endDate,
            @RequestParam String type) {
        Map<String, Object> trend = reportService.getTrendAnalysis(startDate, endDate, type);
        return Result.success(trend);
    }
    
    /**
     * 获取对比分析数据
     */
    @GetMapping("/comparison")
    public Result<Map<String, Object>> getComparisonAnalysis(
            @RequestParam Integer year1,
            @RequestParam Integer year2) {
        Map<String, Object> comparison = reportService.getComparisonAnalysis(year1, year2);
        return Result.success(comparison);
    }
    
    /**
     * 获取分类统计
     */
    @GetMapping("/category-stats")
    public Result<Map<String, Object>> getCategoryStats() {
        Map<String, Object> stats = reportService.getCategoryStats();
        return Result.success(stats);
    }
    
    /**
     * 获取状态统计
     */
    @GetMapping("/status-stats")
    public Result<Map<String, Object>> getStatusStats() {
        Map<String, Object> stats = reportService.getStatusStats();
        return Result.success(stats);
    }
    
    /**
     * 导出Excel报表
     */
    @GetMapping("/export/excel")
    public void exportExcel(
            @RequestParam String reportType,
            @RequestParam(required = false) Integer year,
            HttpServletResponse response) {
        reportService.exportExcel(reportType, year, response);
    }
    
    /**
     * 导出PDF报表
     */
    @GetMapping("/export/pdf")
    public void exportPdf(
            @RequestParam String reportType,
            @RequestParam(required = false) Integer year,
            HttpServletResponse response) {
        reportService.exportPdf(reportType, year, response);
    }
    
    /**
     * 自定义报表查询
     */
    @PostMapping("/custom")
    public Result<Map<String, Object>> getCustomReport(@RequestBody Map<String, Object> params) {
        Map<String, Object> report = reportService.getCustomReport(params);
        return Result.success(report);
    }
}
