package com.example.service;

import javax.servlet.http.HttpServletResponse;
import java.time.LocalDate;
import java.util.Map;

/**
 * 报表服务接口
 */
public interface ReportService {
    
    /**
     * 获取数据大屏数据
     */
    Map<String, Object> getDashboardData();
    
    /**
     * 获取年度统计报告
     */
    Map<String, Object> getAnnualReport(Integer year);
    
    /**
     * 获取趋势分析数据
     */
    Map<String, Object> getTrendAnalysis(LocalDate startDate, LocalDate endDate, String type);
    
    /**
     * 获取对比分析数据
     */
    Map<String, Object> getComparisonAnalysis(Integer year1, Integer year2);
    
    /**
     * 获取分类统计
     */
    Map<String, Object> getCategoryStats();
    
    /**
     * 获取状态统计
     */
    Map<String, Object> getStatusStats();
    
    /**
     * 导出Excel报表
     */
    void exportExcel(String reportType, Integer year, HttpServletResponse response);
    
    /**
     * 导出PDF报表
     */
    void exportPdf(String reportType, Integer year, HttpServletResponse response);
    
    /**
     * 自定义报表查询
     */
    Map<String, Object> getCustomReport(Map<String, Object> params);
}
