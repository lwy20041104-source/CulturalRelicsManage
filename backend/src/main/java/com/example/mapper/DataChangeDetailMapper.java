package com.example.mapper;

import com.example.entity.DataChangeDetail;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface DataChangeDetailMapper {

    /**
     * 插入变更详情
     */
    int insert(DataChangeDetail detail);

    /**
     * 批量插入变更详情
     */
    int batchInsert(@Param("list") List<DataChangeDetail> details);

    /**
     * 根据日志ID查询变更详情
     */
    List<DataChangeDetail> selectByLogId(@Param("logId") Long logId);

    /**
     * 根据日志ID删除变更详情
     */
    int deleteByLogId(@Param("logId") Long logId);
}
