package com.example.mapper;

import com.example.entity.LoanRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface LoanRecordMapper {
    List<LoanRecord> selectPage(@Param("offset") Integer offset,
                                @Param("pageSize") Integer pageSize,
                                @Param("status") String status);

    long count(@Param("status") String status);
    long countByMonth(@Param("year") int year, @Param("month") int month);
    long countByDateRange(@Param("startDate") String startDate, @Param("endDate") String endDate);
    LoanRecord selectById(@Param("id") Long id);
    List<LoanRecord> selectByStatus(@Param("status") String status);
    List<LoanRecord> selectAll();
    int insert(LoanRecord record);
    int updateById(LoanRecord record);
    
    // 前台用户端查询
    List<LoanRecord> selectPageByBorrowerName(@Param("offset") Integer offset,
                                              @Param("pageSize") Integer pageSize,
                                              @Param("status") String status,
                                              @Param("borrowerName") String borrowerName);
    long countByBorrowerName(@Param("status") String status, @Param("borrowerName") String borrowerName);
}
