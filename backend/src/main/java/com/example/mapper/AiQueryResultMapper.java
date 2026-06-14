package com.example.mapper;

import com.example.entity.AiQueryResult;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AiQueryResultMapper {

    int insert(AiQueryResult result);

    AiQueryResult selectById(Long id);

    List<AiQueryResult> selectByMessageId(Long messageId);

    int deleteByMessageId(Long messageId);

    List<AiQueryResult> selectBySessionId(Long sessionId);
}
