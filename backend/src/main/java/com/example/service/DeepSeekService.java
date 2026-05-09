package com.example.service;

import com.example.entity.CulturalRelic;
import java.util.List;

/**
 * DeepSeek AI 服务接口
 */
public interface DeepSeekService {
    
    /**
     * 使用 DeepSeek AI 分析用户问题并查询文物
     * 
     * @param question 用户问题
     * @param relics 所有文物列表
     * @return AI 分析结果和推荐的文物ID列表
     */
    DeepSeekAnalysisResult analyzeAndQuery(String question, List<CulturalRelic> relics);
    
    /**
     * DeepSeek 分析结果
     */
    class DeepSeekAnalysisResult {
        private String answer;              // AI 回答
        private List<Long> recommendedRelicIds;  // 推荐的文物ID列表
        private String reasoning;           // 推荐理由
        private List<String> keywords;      // 提取的关键词
        
        public DeepSeekAnalysisResult() {
        }
        
        public DeepSeekAnalysisResult(String answer, List<Long> recommendedRelicIds, String reasoning, List<String> keywords) {
            this.answer = answer;
            this.recommendedRelicIds = recommendedRelicIds;
            this.reasoning = reasoning;
            this.keywords = keywords;
        }
        
        public String getAnswer() {
            return answer;
        }
        
        public void setAnswer(String answer) {
            this.answer = answer;
        }
        
        public List<Long> getRecommendedRelicIds() {
            return recommendedRelicIds;
        }
        
        public void setRecommendedRelicIds(List<Long> recommendedRelicIds) {
            this.recommendedRelicIds = recommendedRelicIds;
        }
        
        public String getReasoning() {
            return reasoning;
        }
        
        public void setReasoning(String reasoning) {
            this.reasoning = reasoning;
        }
        
        public List<String> getKeywords() {
            return keywords;
        }
        
        public void setKeywords(List<String> keywords) {
            this.keywords = keywords;
        }
    }
}
