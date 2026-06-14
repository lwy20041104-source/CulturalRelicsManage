package com.example.mapper;

import com.example.entity.SysOperationLog;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysOperationLogMapper {

    int insert(SysOperationLog log);

    /**
     * 插入增强的操作日志（包含所有字段）
     */
    int insertEnhanced(SysOperationLog log);

    List<SysOperationLog> selectPage(@Param("operator") String operator,
                                     @Param("operationType") String operationType,
                                     @Param("operationModule") String operationModule,
                                     @Param("offset") int offset,
                                     @Param("pageSize") int pageSize);

    long countPage(@Param("operator") String operator,
                   @Param("operationType") String operationType,
                   @Param("operationModule") String operationModule);

    SysOperationLog selectById(Long id);

    /**
     * 获取资源的操作历史
     */
    List<SysOperationLog> getResourceHistory(@Param("resourceType") String resourceType,
                                             @Param("resourceId") Long resourceId);

    /**
     * 获取用户操作统计（最近N天）
     */
    List<java.util.Map<String, Object>> getUserOperationStatistics(@Param("userId") Long userId,
                                                                    @Param("days") int days);

    /**
     * 获取操作类型统计（最近N天）
     */
    List<java.util.Map<String, Object>> getOperationStatistics(@Param("days") int days);

    /**
     * 清理旧日志
     */
    int cleanOldLogs(@Param("days") int days);
}
