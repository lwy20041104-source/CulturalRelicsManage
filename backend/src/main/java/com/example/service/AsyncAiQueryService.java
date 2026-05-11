package com.example.service;

import com.example.dto.AiRelicQueryResponse;
import com.example.entity.AiChatSession;

import java.util.concurrent.CompletableFuture;

/**
 * 异步AI查询服务接口
 */
public interface AsyncAiQueryService {
    
    /**
     * 异步执行AI查询
     * 
     * @param question 用户问题
     * @param matchAll 是否匹配所有关键词
     * @param userId 用户ID
     * @param sessionId 会话ID（可选）
     * @return CompletableFuture包装的查询结果
     */
    CompletableFuture<AiRelicQueryResponse> queryAsync(String question, Boolean matchAll, Long userId, Long sessionId);
    
    /**
     * 带超时控制的异步查询
     * 
     * @param question 用户问题
     * @param matchAll 是否匹配所有关键词
     * @param userId 用户ID
     * @param sessionId 会话ID（可选）
     * @param timeoutSeconds 超时时间（秒）
     * @return CompletableFuture包装的查询结果
     */
    CompletableFuture<AiRelicQueryResponse> queryAsyncWithTimeout(String question, Boolean matchAll, Long userId, Long sessionId, int timeoutSeconds);
    
    /**
     * 取消正在执行的查询
     * 
     * @param taskId 任务ID
     * @return 是否成功取消
     */
    boolean cancelQuery(String taskId);
    
    /**
     * 获取当前运行的任务数量
     * 
     * @return 运行中的任务数
     */
    int getRunningTaskCount();
}
