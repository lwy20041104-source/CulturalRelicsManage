package com.example.mapper;

import com.example.entity.SystemNotification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 系统通知Mapper接口
 */
@Mapper
public interface SystemNotificationMapper {
    int insert(SystemNotification notification);
    SystemNotification selectById(@Param("id") Long id);
    int updateById(SystemNotification notification);
    int deleteById(@Param("id") Long id);
    
    List<SystemNotification> selectPage(@Param("offset") Integer offset,
                                        @Param("pageSize") Integer pageSize,
                                        @Param("type") String type,
                                        @Param("priority") String priority);
    long count(@Param("type") String type, @Param("priority") String priority);
}
