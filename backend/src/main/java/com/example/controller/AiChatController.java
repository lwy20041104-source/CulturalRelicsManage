package com.example.controller;

import com.example.common.Result;
import com.example.dto.AiChatSessionVO;
import com.example.entity.AiChatMessage;
import com.example.entity.AiChatSession;
import com.example.service.AiChatService;
import com.example.util.SecurityUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/ai-chat")
public class AiChatController {

    private final AiChatService aiChatService;
    private final SecurityUtils securityUtils;

    public AiChatController(AiChatService aiChatService, SecurityUtils securityUtils) {
        this.aiChatService = aiChatService;
        this.securityUtils = securityUtils;
    }

    /**
     * 创建新的对话会话
     */
    @PostMapping("/sessions")
    public Result<AiChatSession> createSession(@RequestBody Map<String, Object> params, Authentication authentication) {
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("无法获取用户信息");
        }
        String title = (String) params.get("title");
        AiChatSession session = aiChatService.createSession(userId, title);
        return Result.success(session);
    }

    /**
     * 获取用户的对话会话列表
     */
    @GetMapping("/sessions")
    public Result<List<AiChatSession>> getUserSessions(Authentication authentication) {
        Long userId = securityUtils.getUserIdFromAuth(authentication);
        if (userId == null) {
            return Result.error("无法获取用户信息");
        }
        List<AiChatSession> sessions = aiChatService.getUserSessions(userId);
        return Result.success(sessions);
    }

    /**
     * 获取所有对话会话列表（管理员）- 包含用户姓名
     */
    @GetMapping("/sessions/all")
    public Result<List<AiChatSessionVO>> getAllSessions() {
        List<AiChatSessionVO> sessions = aiChatService.getAllSessions();
        return Result.success(sessions);
    }

    /**
     * 获取会话的消息历史
     */
    @GetMapping("/sessions/{sessionId}/messages")
    public Result<List<AiChatMessage>> getSessionMessages(@PathVariable Long sessionId) {
        List<AiChatMessage> messages = aiChatService.getSessionMessages(sessionId);
        return Result.success(messages);
    }

    /**
     * 删除会话
     */
    @DeleteMapping("/sessions/{sessionId}")
    public Result<String> deleteSession(@PathVariable Long sessionId) {
        boolean success = aiChatService.deleteSession(sessionId);
        return success ? Result.success("删除成功") : Result.error("删除失败");
    }

    /**
     * 更新会话标题
     */
    @PutMapping("/sessions/{sessionId}/title")
    public Result<String> updateSessionTitle(@PathVariable Long sessionId, @RequestBody Map<String, String> params) {
        String title = params.get("title");
        boolean success = aiChatService.updateSessionTitle(sessionId, title);
        return success ? Result.success("更新成功") : Result.error("更新失败");
    }
}
