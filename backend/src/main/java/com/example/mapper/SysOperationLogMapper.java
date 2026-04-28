package com.example.mapper;

import com.example.entity.SysOperationLog;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface SysOperationLogMapper {
    
    @Insert("INSERT INTO sys_operation_log (operator, operation_type, operation_module, operation_content, operation_result, ip_address, operation_time) " +
            "VALUES (#{operator}, #{operationType}, #{operationModule}, #{operationContent}, #{operationResult}, #{ipAddress}, #{operationTime})")
    int insert(SysOperationLog log);
    
    /**
     * 插入增强的操作日志（包含所有字段）
     */
    @Insert("INSERT INTO sys_operation_log (" +
            "user_id, operator, operation_type, operation_module, operation_content, " +
            "resource_type, resource_id, before_data, after_data, changed_fields, " +
            "operation_result, ip_address, request_method, request_url, request_params, " +
            "response_data, error_message, execution_time, user_agent, browser, os, operation_time" +
            ") VALUES (" +
            "#{userId}, #{operator}, #{operationType}, #{operationModule}, #{operationContent}, " +
            "#{resourceType}, #{resourceId}, #{beforeData}, #{afterData}, #{changedFields}, " +
            "#{operationResult}, #{ipAddress}, #{requestMethod}, #{requestUrl}, #{requestParams}, " +
            "#{responseData}, #{errorMessage}, #{executionTime}, #{userAgent}, #{browser}, #{os}, #{operationTime}" +
            ")")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insertEnhanced(SysOperationLog log);
    
    @Select("<script>" +
            "SELECT * FROM sys_operation_log " +
            "WHERE 1=1 " +
            "<if test='operator != null and operator != \"\"'>" +
            "AND operator LIKE CONCAT('%', #{operator}, '%') " +
            "</if>" +
            "<if test='operationType != null and operationType != \"\"'>" +
            "AND operation_type = #{operationType} " +
            "</if>" +
            "<if test='operationModule != null and operationModule != \"\"'>" +
            "AND operation_module LIKE CONCAT('%', #{operationModule}, '%') " +
            "</if>" +
            "ORDER BY operation_time DESC " +
            "LIMIT #{offset}, #{pageSize}" +
            "</script>")
    List<SysOperationLog> selectPage(@Param("operator") String operator,
                                     @Param("operationType") String operationType,
                                     @Param("operationModule") String operationModule,
                                     @Param("offset") int offset,
                                     @Param("pageSize") int pageSize);
    
    @Select("<script>" +
            "SELECT COUNT(*) FROM sys_operation_log " +
            "WHERE 1=1 " +
            "<if test='operator != null and operator != \"\"'>" +
            "AND operator LIKE CONCAT('%', #{operator}, '%') " +
            "</if>" +
            "<if test='operationType != null and operationType != \"\"'>" +
            "AND operation_type = #{operationType} " +
            "</if>" +
            "<if test='operationModule != null and operationModule != \"\"'>" +
            "AND operation_module LIKE CONCAT('%', #{operationModule}, '%') " +
            "</if>" +
            "</script>")
    long countPage(@Param("operator") String operator,
                   @Param("operationType") String operationType,
                   @Param("operationModule") String operationModule);
    
    @Select("SELECT * FROM sys_operation_log WHERE id = #{id}")
    SysOperationLog selectById(Long id);
    
    /**
     * 获取资源的操作历史
     */
    @Select("SELECT * FROM sys_operation_log " +
            "WHERE resource_type = #{resourceType} AND resource_id = #{resourceId} " +
            "ORDER BY operation_time DESC")
    List<SysOperationLog> getResourceHistory(@Param("resourceType") String resourceType,
                                             @Param("resourceId") Long resourceId);
    
    /**
     * 获取用户操作统计（最近N天）
     */
    @Select("SELECT " +
            "DATE(operation_time) AS log_date, " +
            "operation_type, " +
            "COUNT(*) AS operation_count, " +
            "COUNT(CASE WHEN operation_result = 'SUCCESS' THEN 1 END) AS success_count, " +
            "COUNT(CASE WHEN operation_result = 'FAIL' THEN 1 END) AS fail_count " +
            "FROM sys_operation_log " +
            "WHERE user_id = #{userId} " +
            "AND operation_time >= DATE_SUB(NOW(), INTERVAL #{days} DAY) " +
            "GROUP BY DATE(operation_time), operation_type " +
            "ORDER BY log_date DESC")
    List<java.util.Map<String, Object>> getUserOperationStatistics(@Param("userId") Long userId,
                                                                    @Param("days") int days);
    
    /**
     * 获取操作类型统计（最近N天）
     */
    @Select("SELECT " +
            "DATE(operation_time) AS log_date, " +
            "operation_type, " +
            "operation_module, " +
            "COUNT(*) AS operation_count, " +
            "COUNT(DISTINCT user_id) AS user_count, " +
            "AVG(execution_time) AS avg_execution_time, " +
            "MAX(execution_time) AS max_execution_time " +
            "FROM sys_operation_log " +
            "WHERE operation_time >= DATE_SUB(NOW(), INTERVAL #{days} DAY) " +
            "GROUP BY DATE(operation_time), operation_type, operation_module " +
            "ORDER BY log_date DESC, operation_count DESC")
    List<java.util.Map<String, Object>> getOperationStatistics(@Param("days") int days);
    
    /**
     * 清理旧日志
     */
    @Delete("DELETE FROM sys_operation_log " +
            "WHERE operation_time < DATE_SUB(NOW(), INTERVAL #{days} DAY)")
    int cleanOldLogs(@Param("days") int days);
}
