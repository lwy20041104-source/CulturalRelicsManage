package com.example.mapper;

import com.example.entity.NotificationConfig;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 通知配置Mapper接口
 */
@Mapper
public interface NotificationConfigMapper {
    NotificationConfig selectByUserIdAndType(@Param("userId") Long userId, @Param("notificationType") String notificationType);
}
