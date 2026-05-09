package com.example.service.impl;

import com.example.config.DeepSeekConfig;
import com.example.entity.CulturalRelic;
import com.example.service.DeepSeekService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DeepSeek AI 服务实现
 */
@Slf4j
@Service
public class DeepSeekServiceImpl implements DeepSeekService {
    
    private final DeepSeekConfig deepSeekConfig;
    private final ObjectMapper objectMapper;
    
    public DeepSeekServiceImpl(DeepSeekConfig deepSeekConfig) {
        this.deepSeekConfig = deepSeekConfig;
        this.objectMapper = new ObjectMapper();
    }
    
    @Override
    public DeepSeekAnalysisResult analyzeAndQuery(String question, List<CulturalRelic> relics) {
        try {
            // 构建文物信息摘要
            String relicsInfo = buildRelicsInfo(relics);
            
            // 构建提示词
            String prompt = buildPrompt(question, relicsInfo);
            
            // 调用 DeepSeek API
            String response = callDeepSeekAPI(prompt);
            
            // 解析响应
            return parseResponse(response, relics);
            
        } catch (Exception e) {
            log.error("DeepSeek AI 分析失败", e);
            // 返回降级结果
            return createFallbackResult(question);
        }
    }
    
    /**
     * 构建文物信息摘要
     */
    private String buildRelicsInfo(List<CulturalRelic> relics) {
        StringBuilder sb = new StringBuilder();
        sb.append("博物馆文物列表（共").append(relics.size()).append("件）：\n\n");
        
        for (int i = 0; i < relics.size() && i < 100; i++) {  // 限制最多100件，避免token过多
            CulturalRelic relic = relics.get(i);
            sb.append("ID: ").append(relic.getId()).append("\n");
            sb.append("名称: ").append(relic.getRelicName()).append("\n");
            sb.append("编号: ").append(relic.getRelicCode() != null ? relic.getRelicCode() : "无").append("\n");
            sb.append("年代: ").append(relic.getEra() != null ? relic.getEra() : "未知").append("\n");
            sb.append("材质: ").append(relic.getMaterial() != null ? relic.getMaterial() : "未知").append("\n");
            sb.append("分类: ").append(relic.getCategoryName() != null ? relic.getCategoryName() : "未分类").append("\n");
            sb.append("状态: ").append(relic.getStatus() != null ? relic.getStatus() : "未知").append("\n");
            if (relic.getDescription() != null && !relic.getDescription().isEmpty()) {
                String desc = relic.getDescription();
                if (desc.length() > 100) {
                    desc = desc.substring(0, 100) + "...";
                }
                sb.append("描述: ").append(desc).append("\n");
            }
            sb.append("\n");
        }
        
        if (relics.size() > 100) {
            sb.append("（还有 ").append(relics.size() - 100).append(" 件文物未列出）\n");
        }
        
        return sb.toString();
    }
    
    /**
     * 构建提示词
     */
    private String buildPrompt(String question, String relicsInfo) {
        return "你是一个专业的博物馆文物智能助手。用户会向你提问关于文物的问题，你需要根据提供的文物列表，分析用户的问题并推荐最相关的文物。\n\n" +
                "用户问题：" + question + "\n\n" +
                relicsInfo + "\n\n" +
                "请按照以下JSON格式回答（只返回JSON，不要有其他文字）：\n" +
                "{\n" +
                "  \"answer\": \"对用户问题的回答（200字以内）\",\n" +
                "  \"recommendedRelicIds\": [推荐的文物ID列表，最多5个],\n" +
                "  \"reasoning\": \"推荐这些文物的理由（100字以内）\",\n" +
                "  \"keywords\": [\"从问题中提取的关键词列表\"]\n" +
                "}\n\n" +
                "注意事项：\n" +
                "1. 如果用户问题与文物列表中的某些文物高度相关，请在recommendedRelicIds中列出这些文物的ID\n" +
                "2. 如果没有找到相关文物，recommendedRelicIds返回空数组[]\n" +
                "3. answer要简洁专业，突出文物的特点和价值\n" +
                "4. reasoning要说明为什么推荐这些文物\n" +
                "5. keywords要提取用户问题中的关键信息（如年代、材质、类型等）\n" +
                "6. 必须严格按照JSON格式返回，不要有任何额外的文字说明";
    }
    
    /**
     * 调用 DeepSeek API
     */
    private String callDeepSeekAPI(String prompt) throws Exception {
        URL url = new URL(deepSeekConfig.getApiUrl());
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        try {
            // 设置请求方法和属性
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Authorization", "Bearer " + deepSeekConfig.getApiKey());
            connection.setDoOutput(true);
            connection.setConnectTimeout(deepSeekConfig.getConnectTimeout());
            connection.setReadTimeout(deepSeekConfig.getReadTimeout());
            
            // 构建请求体
            String requestBody = buildRequestBody(prompt);
            
            // 发送请求
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // 读取响应
            int responseCode = connection.getResponseCode();
            log.info("DeepSeek API 响应码: {}", responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                    return response.toString();
                }
            } else {
                // 读取错误信息
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
                    StringBuilder error = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        error.append(line);
                    }
                    log.error("DeepSeek API 错误: {}", error.toString());
                    throw new RuntimeException("DeepSeek API 调用失败: " + error.toString());
                }
            }
        } finally {
            connection.disconnect();
        }
    }
    
    /**
     * 构建请求体
     */
    private String buildRequestBody(String prompt) throws Exception {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
        sb.append("\"model\":\"").append(deepSeekConfig.getModel()).append("\",");
        sb.append("\"messages\":[");
        sb.append("{\"role\":\"user\",\"content\":").append(objectMapper.writeValueAsString(prompt)).append("}");
        sb.append("],");
        sb.append("\"max_tokens\":").append(deepSeekConfig.getMaxTokens()).append(",");
        sb.append("\"temperature\":").append(deepSeekConfig.getTemperature());
        sb.append("}");
        return sb.toString();
    }
    
    /**
     * 解析 DeepSeek API 响应
     */
    private DeepSeekAnalysisResult parseResponse(String response, List<CulturalRelic> relics) {
        try {
            JsonNode root = objectMapper.readTree(response);
            JsonNode choices = root.get("choices");
            
            if (choices != null && choices.isArray() && choices.size() > 0) {
                JsonNode message = choices.get(0).get("message");
                String content = message.get("content").asText();
                
                log.info("DeepSeek 返回内容: {}", content);
                
                // 提取JSON部分（可能包含在```json```代码块中）
                String jsonContent = extractJSON(content);
                
                // 解析JSON
                JsonNode resultNode = objectMapper.readTree(jsonContent);
                
                String answer = resultNode.get("answer").asText();
                String reasoning = resultNode.get("reasoning").asText();
                
                // 解析推荐的文物ID列表
                List<Long> recommendedIds = new ArrayList<>();
                JsonNode idsNode = resultNode.get("recommendedRelicIds");
                if (idsNode != null && idsNode.isArray()) {
                    for (JsonNode idNode : idsNode) {
                        recommendedIds.add(idNode.asLong());
                    }
                }
                
                // 解析关键词
                List<String> keywords = new ArrayList<>();
                JsonNode keywordsNode = resultNode.get("keywords");
                if (keywordsNode != null && keywordsNode.isArray()) {
                    for (JsonNode keywordNode : keywordsNode) {
                        keywords.add(keywordNode.asText());
                    }
                }
                
                return new DeepSeekAnalysisResult(answer, recommendedIds, reasoning, keywords);
            }
            
            throw new RuntimeException("DeepSeek API 响应格式错误");
            
        } catch (Exception e) {
            log.error("解析 DeepSeek 响应失败", e);
            throw new RuntimeException("解析 DeepSeek 响应失败: " + e.getMessage());
        }
    }
    
    /**
     * 从文本中提取JSON内容
     */
    private String extractJSON(String content) {
        // 如果内容被包裹在```json```代码块中，提取出来
        if (content.contains("```json")) {
            int start = content.indexOf("```json") + 7;
            int end = content.indexOf("```", start);
            if (end > start) {
                return content.substring(start, end).trim();
            }
        }
        
        // 如果内容被包裹在```代码块中，提取出来
        if (content.contains("```")) {
            int start = content.indexOf("```") + 3;
            int end = content.indexOf("```", start);
            if (end > start) {
                return content.substring(start, end).trim();
            }
        }
        
        // 尝试找到JSON对象的开始和结束
        int start = content.indexOf("{");
        int end = content.lastIndexOf("}");
        if (start >= 0 && end > start) {
            return content.substring(start, end + 1);
        }
        
        return content.trim();
    }
    
    /**
     * 创建降级结果（当API调用失败时）
     */
    private DeepSeekAnalysisResult createFallbackResult(String question) {
        String answer = "抱歉，AI分析服务暂时不可用。您可以尝试使用关键词搜索功能。";
        return new DeepSeekAnalysisResult(answer, new ArrayList<>(), "AI服务不可用", Arrays.asList(question));
    }
}
