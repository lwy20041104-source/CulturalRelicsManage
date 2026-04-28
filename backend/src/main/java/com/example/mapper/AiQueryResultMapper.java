package com.example.mapper;

import com.example.entity.AiQueryResult;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AiQueryResultMapper {

    @Insert("INSERT INTO ai_query_result (message_id, relic_id, relic_name, relevance_percent, is_external, source_name, source_type, source_url, match_tags) " +
            "VALUES (#{messageId}, #{relicId}, #{relicName}, #{relevancePercent}, #{isExternal}, #{sourceName}, #{sourceType}, #{sourceUrl}, #{matchTags})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(AiQueryResult result);

    @Select("SELECT * FROM ai_query_result WHERE id = #{id}")
    AiQueryResult selectById(Long id);

    @Select("SELECT * FROM ai_query_result WHERE message_id = #{messageId} ORDER BY relevance_percent DESC")
    List<AiQueryResult> selectByMessageId(Long messageId);

    @Delete("DELETE FROM ai_query_result WHERE message_id = #{messageId}")
    int deleteByMessageId(Long messageId);

    @Select("SELECT * FROM ai_query_result WHERE message_id IN " +
            "(SELECT id FROM ai_chat_message WHERE session_id = #{sessionId})")
    List<AiQueryResult> selectBySessionId(Long sessionId);
}
