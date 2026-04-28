package com.example.mapper;

import com.example.dto.AiChatSessionVO;
import com.example.entity.AiChatSession;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AiChatSessionMapper {

    @Insert("INSERT INTO ai_chat_session (user_id, session_title) VALUES (#{userId}, #{sessionTitle})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(AiChatSession session);

    @Select("SELECT * FROM ai_chat_session WHERE id = #{id}")
    AiChatSession selectById(Long id);

    @Select("SELECT * FROM ai_chat_session WHERE user_id = #{userId} ORDER BY update_time DESC")
    List<AiChatSession> selectByUserId(Long userId);

    @Select("SELECT * FROM ai_chat_session ORDER BY update_time DESC")
    List<AiChatSession> selectAll();

    @Select("SELECT s.id, s.user_id, s.session_title, s.create_time, s.update_time, " +
            "u.real_name as user_name " +
            "FROM ai_chat_session s " +
            "LEFT JOIN sys_user u ON s.user_id = u.id " +
            "ORDER BY s.update_time DESC")
    @Results({
        @Result(property = "id", column = "id"),
        @Result(property = "userId", column = "user_id"),
        @Result(property = "userName", column = "user_name"),
        @Result(property = "sessionTitle", column = "session_title"),
        @Result(property = "createTime", column = "create_time"),
        @Result(property = "updateTime", column = "update_time")
    })
    List<AiChatSessionVO> selectAllWithUserName();

    @Update("UPDATE ai_chat_session SET session_title = #{sessionTitle}, update_time = NOW() WHERE id = #{id}")
    int updateById(AiChatSession session);

    @Delete("DELETE FROM ai_chat_session WHERE id = #{id}")
    int deleteById(Long id);

    @Select("SELECT * FROM ai_chat_session WHERE user_id = #{userId} ORDER BY update_time DESC LIMIT #{limit}")
    List<AiChatSession> selectRecentByUserId(@Param("userId") Long userId, @Param("limit") int limit);
}
