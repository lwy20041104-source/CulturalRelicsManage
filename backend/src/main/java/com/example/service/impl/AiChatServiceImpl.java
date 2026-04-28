package com.example.service.impl;

import com.example.dto.AiChatSessionVO;
import com.example.dto.AiRelicItemVO;
import com.example.dto.AiRelicQueryResponse;
import com.example.entity.AiChatMessage;
import com.example.entity.AiChatSession;
import com.example.entity.AiQueryResult;
import com.example.mapper.AiChatMessageMapper;
import com.example.mapper.AiChatSessionMapper;
import com.example.mapper.AiQueryResultMapper;
import com.example.service.AiChatService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
public class AiChatServiceImpl implements AiChatService {

    private final AiChatSessionMapper sessionMapper;
    private final AiChatMessageMapper messageMapper;
    private final AiQueryResultMapper queryResultMapper;
    private final ObjectMapper objectMapper;

    public AiChatServiceImpl(AiChatSessionMapper sessionMapper,
                             AiChatMessageMapper messageMapper,
                             AiQueryResultMapper queryResultMapper,
                             ObjectMapper objectMapper) {
        this.sessionMapper = sessionMapper;
        this.messageMapper = messageMapper;
        this.queryResultMapper = queryResultMapper;
        this.objectMapper = objectMapper;
    }

    @Override
    public AiChatSession createSession(Long userId, String title) {
        AiChatSession session = new AiChatSession();
        session.setUserId(userId);
        session.setSessionTitle(title != null ? title : "新对话");
        sessionMapper.insert(session);
        log.info("创建AI对话会话：userId={}, sessionId={}, title={}", userId, session.getId(), title);
        return session;
    }

    @Override
    public List<AiChatSession> getUserSessions(Long userId) {
        return sessionMapper.selectByUserId(userId);
    }

    @Override
    public List<AiChatSessionVO> getAllSessions() {
        return sessionMapper.selectAllWithUserName();
    }

    @Override
    public List<AiChatMessage> getSessionMessages(Long sessionId) {
        return messageMapper.selectBySessionId(sessionId);
    }

    @Override
    @Transactional
    public void saveConversation(Long sessionId, Long userId, String userQuestion, AiRelicQueryResponse aiResponse) {
        // 保存用户消息
        AiChatMessage userMessage = new AiChatMessage();
        userMessage.setSessionId(sessionId);
        userMessage.setUserId(userId);
        userMessage.setMessageType("user");
        userMessage.setContent(userQuestion);
        userMessage.setQueryKeyword(userQuestion);
        messageMapper.insert(userMessage);

        // 保存AI回复
        AiChatMessage aiMessage = new AiChatMessage();
        aiMessage.setSessionId(sessionId);
        aiMessage.setUserId(userId);
        aiMessage.setMessageType("ai");
        aiMessage.setContent(aiResponse.getAnswer());
        aiMessage.setResultCount(aiResponse.getTotal());
        
        // 检查是否有外部搜索结果
        boolean hasExternal = aiResponse.getRelics() != null && 
                              aiResponse.getRelics().stream().anyMatch(r -> r.getExternal() != null && r.getExternal());
        aiMessage.setHasExternalResult(hasExternal ? 1 : 0);
        
        // 收集文物ID列表
        if (aiResponse.getRelics() != null && !aiResponse.getRelics().isEmpty()) {
            String relicIds = aiResponse.getRelics().stream()
                    .filter(r -> r.getId() != null && r.getId() > 0)
                    .map(r -> String.valueOf(r.getId()))
                    .collect(Collectors.joining(","));
            aiMessage.setRelicIds(relicIds);
        }
        
        messageMapper.insert(aiMessage);

        // 保存查询结果详情
        if (aiResponse.getRelics() != null && !aiResponse.getRelics().isEmpty()) {
            for (AiRelicItemVO item : aiResponse.getRelics()) {
                AiQueryResult result = new AiQueryResult();
                result.setMessageId(aiMessage.getId());
                result.setRelicId(item.getId() != null && item.getId() > 0 ? item.getId() : null);
                result.setRelicName(item.getRelicName());
                result.setRelevancePercent(item.getRelevancePercent() != null ? item.getRelevancePercent() : 0);
                result.setIsExternal(item.getExternal() != null && item.getExternal() ? 1 : 0);
                result.setSourceName(item.getSourceName());
                result.setSourceType(item.getSourceType());
                result.setSourceUrl(item.getSourceUrl());
                
                // 将matchTags转换为JSON字符串
                if (item.getMatchTags() != null && !item.getMatchTags().isEmpty()) {
                    try {
                        result.setMatchTags(objectMapper.writeValueAsString(item.getMatchTags()));
                    } catch (JsonProcessingException e) {
                        log.warn("转换matchTags为JSON失败：{}", e.getMessage());
                        result.setMatchTags("[]");
                    }
                } else {
                    result.setMatchTags("[]");
                }
                
                queryResultMapper.insert(result);
            }
        }

        log.info("保存AI对话：sessionId={}, userId={}, question={}, resultCount={}", 
                sessionId, userId, userQuestion, aiResponse.getTotal());
    }

    @Override
    @Transactional
    public boolean deleteSession(Long sessionId) {
        // 删除查询结果
        List<AiChatMessage> messages = messageMapper.selectBySessionId(sessionId);
        for (AiChatMessage message : messages) {
            queryResultMapper.deleteByMessageId(message.getId());
        }
        
        // 删除消息
        messageMapper.deleteBySessionId(sessionId);
        
        // 删除会话
        int count = sessionMapper.deleteById(sessionId);
        log.info("删除AI对话会话：sessionId={}, success={}", sessionId, count > 0);
        return count > 0;
    }

    @Override
    public boolean updateSessionTitle(Long sessionId, String title) {
        AiChatSession session = new AiChatSession();
        session.setId(sessionId);
        session.setSessionTitle(title);
        int count = sessionMapper.updateById(session);
        log.info("更新AI对话会话标题：sessionId={}, title={}, success={}", sessionId, title, count > 0);
        return count > 0;
    }
}
