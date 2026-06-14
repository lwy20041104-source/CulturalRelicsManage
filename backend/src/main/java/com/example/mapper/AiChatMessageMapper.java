package com.example.mapper;

import com.example.entity.AiChatMessage;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AiChatMessageMapper {

    int insert(AiChatMessage message);

    AiChatMessage selectById(Long id);

    List<AiChatMessage> selectBySessionId(Long sessionId);

    List<AiChatMessage> selectRecentByUserId(@Param("userId") Long userId, @Param("limit") int limit);

    int deleteBySessionId(Long sessionId);

    int countBySessionId(Long sessionId);
}
