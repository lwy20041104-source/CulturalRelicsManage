package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.Result;
import com.example.dto.AiRelicQueryRequest;
import com.example.dto.AiRelicQueryResponse;
import com.example.entity.AiChatSession;
import com.example.service.AiChatService;
import com.example.service.RelicAiService;
import com.example.util.SecurityUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/ai/relics")
public class RelicAiController {

    private final RelicAiService relicAiService;
    private final AiChatService aiChatService;
    private final SecurityUtils securityUtils;

    public RelicAiController(RelicAiService relicAiService, AiChatService aiChatService, SecurityUtils securityUtils) {
        this.relicAiService = relicAiService;
        this.aiChatService = aiChatService;
        this.securityUtils = securityUtils;
    }

    @PostMapping("/query")
    @OperationLog(operationType = "查询", operationModule = "AI查询", operationContent = "AI智能查询文物")
    public Result<AiRelicQueryResponse> query(@RequestBody AiRelicQueryRequest request, Authentication authentication) {
        AiRelicQueryResponse response = relicAiService.queryRelics(request.getQuestion(), request.getMatchAll());
        
        // 保存对话记录
        try {
            Long userId = securityUtils.getUserIdFromAuth(authentication);
            if (userId == null) {
                log.warn("无法获取用户ID，跳过保存对话记录");
                return Result.success(response);
            }
            
            Long sessionId = request.getSessionId();
            
            // 如果没有提供sessionId，创建新会话
            if (sessionId == null) {
                AiChatSession session = aiChatService.createSession(userId, "AI查询：" + request.getQuestion());
                sessionId = session.getId();
                response.setSessionId(sessionId); // 将sessionId返回给前端
            }
            
            aiChatService.saveConversation(sessionId, userId, request.getQuestion(), response);
            log.info("保存AI对话记录成功：userId={}, sessionId={}, question={}", userId, sessionId, request.getQuestion());
        } catch (Exception e) {
            log.error("保存AI对话记录失败：{}", e.getMessage(), e);
            // 不影响查询结果返回
        }
        
        return Result.success(response);
    }
}
