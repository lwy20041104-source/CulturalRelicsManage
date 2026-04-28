package com.example.service;

import com.example.dto.AiChatSessionVO;
import com.example.dto.AiRelicQueryResponse;
import com.example.entity.AiChatMessage;
import com.example.entity.AiChatSession;

import java.util.List;

public interface AiChatService {

    /**
     * 创建新的对话会话
     */
    AiChatSession createSession(Long userId, String title);

    /**
     * 获取用户的对话会话列表
     */
    List<AiChatSession> getUserSessions(Long userId);

    /**
     * 获取所有对话会话列表（管理员）- 包含用户姓名
     */
    List<AiChatSessionVO> getAllSessions();

    /**
     * 获取会话的消息历史
     */
    List<AiChatMessage> getSessionMessages(Long sessionId);

    /**
     * 保存用户消息和AI回复
     */
    void saveConversation(Long sessionId, Long userId, String userQuestion, AiRelicQueryResponse aiResponse);

    /**
     * 删除会话及其所有消息
     */
    boolean deleteSession(Long sessionId);

    /**
     * 更新会话标题
     */
    boolean updateSessionTitle(Long sessionId, String title);
}
