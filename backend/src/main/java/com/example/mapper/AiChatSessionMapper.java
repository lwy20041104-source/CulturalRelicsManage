package com.example.mapper;

import com.example.dto.AiChatSessionVO;
import com.example.entity.AiChatSession;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AiChatSessionMapper {

    int insert(AiChatSession session);

    AiChatSession selectById(Long id);

    List<AiChatSession> selectByUserId(Long userId);

    List<AiChatSession> selectAll();

    List<AiChatSessionVO> selectAllWithUserName();

    int updateById(AiChatSession session);

    int deleteById(Long id);

    List<AiChatSession> selectRecentByUserId(@Param("userId") Long userId, @Param("limit") int limit);
}
