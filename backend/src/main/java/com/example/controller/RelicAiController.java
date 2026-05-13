package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.Result;
import com.example.dto.AiRelicQueryRequest;
import com.example.dto.AiRelicQueryResponse;
import com.example.entity.AiChatSession;
import com.example.service.AiChatService;
import com.example.service.AsyncAiQueryService;
import com.example.service.RelicAiService;
import com.example.util.SecurityUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.CompletableFuture;

@Slf4j
@RestController
@RequestMapping("/ai/relics")
public class RelicAiController {

    private final RelicAiService relicAiService;
    private final AsyncAiQueryService asyncAiQueryService;
    private final AiChatService aiChatService;
    private final SecurityUtils securityUtils;
    
    // 默认超时时间（秒）
    private static final int DEFAULT_TIMEOUT_SECONDS = 30;

    public RelicAiController(RelicAiService relicAiService, 
                            AsyncAiQueryService asyncAiQueryService,
                            AiChatService aiChatService, 
                            SecurityUtils securityUtils) {
        this.relicAiService = relicAiService;
        this.asyncAiQueryService = asyncAiQueryService;
        this.aiChatService = aiChatService;
        this.securityUtils = securityUtils;
    }

    /**
     * 同步AI查询（保留原有接口，用于兼容）
     */
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
    
    /**
     * 异步AI查询（新接口）
     * 使用CompletableFuture实现异步处理，提高并发性能
     */
    @PostMapping("/query-async")
    @OperationLog(operationType = "查询", operationModule = "AI查询", operationContent = "AI智能查询文物（异步）")
    public CompletableFuture<Result<AiRelicQueryResponse>> queryAsync(
            @RequestBody AiRelicQueryRequest request, 
            Authentication authentication) {
        
        try {
            Long userId = securityUtils.getUserIdFromAuth(authentication);
            if (userId == null) {
                log.warn("无法获取用户ID");
                return CompletableFuture.completedFuture(Result.error("用户未登录"));
            }
            
            log.info("接收异步AI查询请求: userId={}, question={}", userId, request.getQuestion());
            
            // 执行异步查询
            return asyncAiQueryService.queryAsync(
                request.getQuestion(), 
                request.getMatchAll(), 
                userId, 
                request.getSessionId()
            ).thenApply(Result::success)
             .exceptionally(ex -> {
                 log.error("异步AI查询失败", ex);
                 return Result.error("AI查询失败: " + ex.getMessage());
             });
             
        } catch (Exception e) {
            log.error("异步AI查询异常", e);
            return CompletableFuture.completedFuture(Result.error("AI查询异常: " + e.getMessage()));
        }
    }
    
    /**
     * 带超时控制的异步AI查询（推荐使用）
     * 
     * @param request 查询请求
     * @param authentication 认证信息
     * @param timeout 超时时间（秒），默认30秒
     */
    @PostMapping("/query-async-timeout")
    @OperationLog(operationType = "查询", operationModule = "AI查询", operationContent = "AI智能查询文物（异步+超时）")
    public CompletableFuture<Result<AiRelicQueryResponse>> queryAsyncWithTimeout(
            @RequestBody AiRelicQueryRequest request,
            @RequestParam(required = false, defaultValue = "30") Integer timeout,
            Authentication authentication) {
        
        try {
            Long userId = securityUtils.getUserIdFromAuth(authentication);
            if (userId == null) {
                log.warn("无法获取用户ID");
                return CompletableFuture.completedFuture(Result.error("用户未登录"));
            }
            
            // 验证超时时间范围（5-120秒）
            int timeoutSeconds = (timeout != null && timeout >= 5 && timeout <= 120) ? timeout : DEFAULT_TIMEOUT_SECONDS;
            
            log.info("接收带超时的异步AI查询请求: userId={}, question={}, timeout={}秒", 
                    userId, request.getQuestion(), timeoutSeconds);
            
            // 执行带超时的异步查询
            return asyncAiQueryService.queryAsyncWithTimeout(
                request.getQuestion(), 
                request.getMatchAll(), 
                userId, 
                request.getSessionId(),
                timeoutSeconds
            ).thenApply(Result::success)
             .exceptionally(ex -> {
                 log.error("异步AI查询失败", ex);
                 return Result.error("AI查询失败: " + ex.getMessage());
             });
             
        } catch (Exception e) {
            log.error("异步AI查询异常", e);
            return CompletableFuture.completedFuture(Result.error("AI查询异常: " + e.getMessage()));
        }
    }
    
    /**
     * 取消正在执行的AI查询
     * 
     * @param taskId 任务ID
     */
    @PostMapping("/cancel/{taskId}")
    public Result<Boolean> cancelQuery(@PathVariable String taskId) {
        try {
            boolean cancelled = asyncAiQueryService.cancelQuery(taskId);
            if (cancelled) {
                return Result.success("查询已取消", true);
            } else {
                return Result.error("未找到要取消的查询任务");
            }
        } catch (Exception e) {
            log.error("取消查询失败", e);
            return Result.error("取消查询失败: " + e.getMessage());
        }
    }
    
    /**
     * 获取异步查询服务状态
     */
    @GetMapping("/async-status")
    public Result<String> getAsyncStatus() {
        try {
            int runningTasks = asyncAiQueryService.getRunningTaskCount();
            return Result.success("当前运行中的任务数: " + runningTasks);
        } catch (Exception e) {
            log.error("获取异步状态失败", e);
            return Result.error("获取状态失败: " + e.getMessage());
        }
    }
}
