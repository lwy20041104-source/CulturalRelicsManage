package com.example.mapper;

import com.example.entity.DataChangeDetail;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface DataChangeDetailMapper {
    
    /**
     * 插入变更详情
     */
    @Insert("INSERT INTO sys_data_change_detail (" +
            "log_id, field_name, field_label, old_value, new_value, value_type, create_time" +
            ") VALUES (" +
            "#{logId}, #{fieldName}, #{fieldLabel}, #{oldValue}, #{newValue}, #{valueType}, #{createTime}" +
            ")")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(DataChangeDetail detail);
    
    /**
     * 批量插入变更详情
     */
    @Insert("<script>" +
            "INSERT INTO sys_data_change_detail (" +
            "log_id, field_name, field_label, old_value, new_value, value_type, create_time" +
            ") VALUES " +
            "<foreach collection='list' item='item' separator=','>" +
            "(#{item.logId}, #{item.fieldName}, #{item.fieldLabel}, #{item.oldValue}, " +
            "#{item.newValue}, #{item.valueType}, #{item.createTime})" +
            "</foreach>" +
            "</script>")
    int batchInsert(@Param("list") List<DataChangeDetail> details);
    
    /**
     * 根据日志ID查询变更详情
     */
    @Select("SELECT * FROM sys_data_change_detail WHERE log_id = #{logId} ORDER BY id")
    List<DataChangeDetail> selectByLogId(@Param("logId") Long logId);
    
    /**
     * 根据日志ID删除变更详情
     */
    @Delete("DELETE FROM sys_data_change_detail WHERE log_id = #{logId}")
    int deleteByLogId(@Param("logId") Long logId);
}
