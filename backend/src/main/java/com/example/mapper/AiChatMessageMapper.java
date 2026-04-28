package com.example.mapper;

import com.example.entity.AiChatMessage;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AiChatMessageMapper {

    @Insert("INSERT INTO ai_chat_message (session_id, user_id, message_type, content, query_keyword, result_count, has_external_result, relic_ids) " +
            "VALUES (#{sessionId}, #{userId}, #{messageType}, #{content}, #{queryKeyword}, #{resultCount}, #{hasExternalResult}, #{relicIds})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(AiChatMessage message);

    @Select("SELECT * FROM ai_chat_message WHERE id = #{id}")
    AiChatMessage selectById(Long id);

    @Select("SELECT * FROM ai_chat_message WHERE session_id = #{sessionId} ORDER BY create_time ASC")
    List<AiChatMessage> selectBySessionId(Long sessionId);

    @Select("SELECT * FROM ai_chat_message WHERE user_id = #{userId} ORDER BY create_time DESC LIMIT #{limit}")
    List<AiChatMessage> selectRecentByUserId(@Param("userId") Long userId, @Param("limit") int limit);

    @Delete("DELETE FROM ai_chat_message WHERE session_id = #{sessionId}")
    int deleteBySessionId(Long sessionId);

    @Select("SELECT COUNT(*) FROM ai_chat_message WHERE session_id = #{sessionId}")
    int countBySessionId(Long sessionId);
}
