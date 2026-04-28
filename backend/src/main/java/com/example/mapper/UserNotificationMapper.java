package com.example.mapper;

import com.example.entity.UserNotification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.time.LocalDateTime;
import java.util.List;

/**
 * 用户通知关联Mapper接口
 */
@Mapper
public interface UserNotificationMapper {
    int insert(UserNotification userNotification);
    int updateById(UserNotification userNotification);
    int deleteById(@Param("id") Long id);
    UserNotification selectById(@Param("id") Long id);
    UserNotification selectByNotificationIdAndUserId(@Param("notificationId") Long notificationId, @Param("userId") Long userId);
    List<UserNotification> selectPage(@Param("offset") Integer offset,
                                      @Param("pageSize") Integer pageSize,
                                      @Param("userId") Long userId,
                                      @Param("isRead") Integer isRead,
                                      @Param("keyword") String keyword);
    long count(@Param("userId") Long userId, @Param("isRead") Integer isRead, @Param("keyword") String keyword);
    
    /**
     * 统计用户未读通知数量
     */
    @Select("SELECT COUNT(*) FROM user_notification WHERE user_id = #{userId} AND is_read = 0")
    int countUnreadByUserId(@Param("userId") Long userId);
    
    /**
     * 统计通知发送数量（按类型）
     */
    @Select("SELECT COUNT(*) FROM user_notification un " +
            "INNER JOIN system_notification sn ON un.notification_id = sn.id " +
            "WHERE sn.type = #{type} AND sn.create_time >= #{startDate} AND sn.create_time <= #{endDate}")
    int countByType(@Param("type") String type, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    /**
     * 统计通知阅读率
     */
    @Select("SELECT COUNT(*) FROM user_notification WHERE is_read = 1 AND create_time >= #{startDate} AND create_time <= #{endDate}")
    int countReadNotifications(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Select("SELECT COUNT(*) FROM user_notification WHERE create_time >= #{startDate} AND create_time <= #{endDate}")
    int countTotalNotifications(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
}
