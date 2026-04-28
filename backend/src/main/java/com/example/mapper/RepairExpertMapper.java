package com.example.mapper;

import com.example.entity.RepairExpert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 修复专家Mapper
 */
@Mapper
public interface RepairExpertMapper {
    
    /**
     * 查询所有启用的专家
     */
    List<RepairExpert> selectEnabledList();
    
    /**
     * 分页查询专家
     */
    List<RepairExpert> selectPage(@Param("offset") int offset,
                                   @Param("limit") int limit,
                                   @Param("expertName") String expertName,
                                   @Param("specialty") String specialty);
    
    /**
     * 统计记录数
     */
    long count(@Param("expertName") String expertName,
               @Param("specialty") String specialty);
    
    /**
     * 根据ID查询
     */
    RepairExpert selectById(@Param("id") Long id);
    
    /**
     * 根据姓名查询
     */
    RepairExpert selectByName(@Param("expertName") String expertName);
    
    /**
     * 插入记录
     */
    int insert(RepairExpert expert);
    
    /**
     * 更新记录
     */
    int updateById(RepairExpert expert);
    
    /**
     * 删除记录
     */
    int deleteById(@Param("id") Long id);
    
    /**
     * 生成专家编号
     */
    String generateExpertCode();
}
