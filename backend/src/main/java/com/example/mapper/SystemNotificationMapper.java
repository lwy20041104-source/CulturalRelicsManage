package com.example.mapper;

import com.example.entity.SystemNotification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 系统通知Mapper接口
 */
@Mapper
public interface SystemNotificationMapper {
    int insert(SystemNotification notification);
    SystemNotification selectById(@Param("id") Long id);
}
