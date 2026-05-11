package com.example.service.impl;

import com.example.dto.AiRelicQueryResponse;
import com.example.entity.AiChatSession;
import com.example.service.AiChatService;
import com.example.service.AsyncAiQueryService;
import com.example.service.RelicAiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.*;

/**
 * 异步AI查询服务实现
 */
@Slf4j
@Service
public class AsyncAiQueryServiceImpl implements AsyncAiQueryService {
    
    private final RelicAiService relicAiService;
    private final AiChatService aiChatService;
    
    // 存储正在执行的任务
    private final Map<String, CompletableFuture<AiRelicQueryResponse>> runningTasks = new ConcurrentHashMap<>();
    
    // 线程池配置
    private final ExecutorService executorService;
    
    public AsyncAiQueryServiceImpl(RelicAiService relicAiService, AiChatService aiChatService) {
        this.relicAiService = relicAiService;
        this.aiChatService = aiChatService;
        
        // 创建线程池：核心线程数5，最大线程数20，队列容量100
        this.executorService = new ThreadPoolExecutor(
            5,  // 核心线程数
            20, // 最大线程数
            60L, TimeUnit.SECONDS, // 空闲线程存活时间
            new LinkedBlockingQueue<>(100), // 任务队列
            new ThreadFactory() {
                private int counter = 0;
                @Override
                public Thread newThread(Runnable r) {
                    return new Thread(r, "ai-query-thread-" + counter++);
                }
            },
            new ThreadPoolExecutor.CallerRunsPolicy() // 拒绝策略：由调用线程执行
        );
    }
    
    @Override
    @Async
    public CompletableFuture<AiRelicQueryResponse> queryAsync(String question, Boolean matchAll, Long userId, Long sessionId) {
        String taskId = UUID.randomUUID().toString();
        log.info("开始异步AI查询: taskId={}, question={}, userId={}", taskId, question, userId);
        
        CompletableFuture<AiRelicQueryResponse> future = CompletableFuture.supplyAsync(() -> {
            try {
                // 执行AI查询
                AiRelicQueryResponse response = relicAiService.queryRelics(question, matchAll);
                
                // 保存对话记录
                saveConversation(question, response, userId, sessionId);
                
                log.info("异步AI查询完成: taskId={}, 找到{}件文物", taskId, response.getTotal());
                return response;
                
            } catch (Exception e) {
                log.error("异步AI查询失败: taskId={}", taskId, e);
                // 返回错误响应
                return createErrorResponse(e.getMessage());
            } finally {
                // 从运行任务列表中移除
                runningTasks.remove(taskId);
            }
        }, executorService);
        
        // 添加到运行任务列表
        runningTasks.put(taskId, future);
        
        return future;
    }
    
    @Override
    public CompletableFuture<AiRelicQueryResponse> queryAsyncWithTimeout(String question, Boolean matchAll, Long userId, Long sessionId, int timeoutSeconds) {
        String taskId = UUID.randomUUID().toString();
        log.info("开始带超时的异步AI查询: taskId={}, question={}, timeout={}秒", taskId, question, timeoutSeconds);
        
        CompletableFuture<AiRelicQueryResponse> future = CompletableFuture.supplyAsync(() -> {
            try {
                // 执行AI查询
                AiRelicQueryResponse response = relicAiService.queryRelics(question, matchAll);
                
                // 保存对话记录
                saveConversation(question, response, userId, sessionId);
                
                log.info("异步AI查询完成: taskId={}, 找到{}件文物", taskId, response.getTotal());
                return response;
                
            } catch (Exception e) {
                log.error("异步AI查询失败: taskId={}", taskId, e);
                return createErrorResponse(e.getMessage());
            } finally {
                runningTasks.remove(taskId);
            }
        }, executorService);
        
        // 添加超时控制（兼容 Java 8）
        CompletableFuture<AiRelicQueryResponse> timeoutFuture = new CompletableFuture<>();
        
        // 创建超时任务
        ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(1);
        scheduler.schedule(() -> {
            if (!future.isDone()) {
                log.warn("AI查询超时: taskId={}, timeout={}秒", taskId, timeoutSeconds);
                timeoutFuture.complete(createTimeoutResponse(timeoutSeconds));
                future.cancel(true);
            }
        }, timeoutSeconds, TimeUnit.SECONDS);
        
        // 当原始任务完成时，完成超时任务
        future.whenComplete((result, ex) -> {
            scheduler.shutdown();
            if (!timeoutFuture.isDone()) {
                if (ex != null) {
                    timeoutFuture.complete(createErrorResponse(ex.getMessage()));
                } else {
                    timeoutFuture.complete(result);
                }
            }
        });
        
        runningTasks.put(taskId, timeoutFuture);
        
        return timeoutFuture;
    }
    
    @Override
    public boolean cancelQuery(String taskId) {
        CompletableFuture<AiRelicQueryResponse> future = runningTasks.get(taskId);
        if (future != null) {
            boolean cancelled = future.cancel(true);
            if (cancelled) {
                runningTasks.remove(taskId);
                log.info("成功取消AI查询任务: taskId={}", taskId);
            }
            return cancelled;
        }
        log.warn("未找到要取消的AI查询任务: taskId={}", taskId);
        return false;
    }
    
    /**
     * 保存对话记录
     */
    private void saveConversation(String question, AiRelicQueryResponse response, Long userId, Long sessionId) {
        try {
            if (userId == null) {
                log.warn("用户ID为空，跳过保存对话记录");
                return;
            }
            
            // 如果没有提供sessionId，创建新会话
            if (sessionId == null) {
                AiChatSession session = aiChatService.createSession(userId, "AI查询：" + question);
                sessionId = session.getId();
                response.setSessionId(sessionId);
            }
            
            aiChatService.saveConversation(sessionId, userId, question, response);
            log.info("保存AI对话记录成功: userId={}, sessionId={}", userId, sessionId);
            
        } catch (Exception e) {
            log.error("保存AI对话记录失败", e);
            // 不影响查询结果返回
        }
    }
    
    /**
     * 创建超时响应
     */
    private AiRelicQueryResponse createTimeoutResponse(int timeoutSeconds) {
        AiRelicQueryResponse response = new AiRelicQueryResponse();
        response.setAnswer(String.format("AI查询超时（%d秒），请稍后重试或简化您的问题。", timeoutSeconds));
        response.setRelics(new ArrayList<>());
        response.setTotal(0);
        response.setMuseumHit(false);
        response.setMuseumMessage("查询超时");
        response.setTopReason("查询超时");
        response.setWebResults(new ArrayList<>());
        return response;
    }
    
    /**
     * 创建错误响应
     */
    private AiRelicQueryResponse createErrorResponse(String errorMessage) {
        AiRelicQueryResponse response = new AiRelicQueryResponse();
        response.setAnswer("AI查询失败：" + errorMessage);
        response.setRelics(new ArrayList<>());
        response.setTotal(0);
        response.setMuseumHit(false);
        response.setMuseumMessage("查询失败");
        response.setTopReason("查询失败");
        response.setWebResults(new ArrayList<>());
        return response;
    }
    
    /**
     * 获取当前运行的任务数量
     */
    public int getRunningTaskCount() {
        return runningTasks.size();
    }
    
    /**
     * 清理已完成的任务
     */
    public void cleanupCompletedTasks() {
        runningTasks.entrySet().removeIf(entry -> entry.getValue().isDone());
    }
    
    /**
     * 关闭线程池
     */
    public void shutdown() {
        log.info("关闭AI查询线程池");
        executorService.shutdown();
        try {
            if (!executorService.awaitTermination(60, TimeUnit.SECONDS)) {
                executorService.shutdownNow();
            }
        } catch (InterruptedException e) {
            executorService.shutdownNow();
            Thread.currentThread().interrupt();
        }
    }
}
