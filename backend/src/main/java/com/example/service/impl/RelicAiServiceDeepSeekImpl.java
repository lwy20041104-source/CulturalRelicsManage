package com.example.service.impl;

import com.example.dto.AiRelicItemVO;
import com.example.dto.AiRelicQueryResponse;
import com.example.entity.CulturalRelic;
import com.example.service.CulturalRelicService;
import com.example.service.DeepSeekService;
import com.example.service.RelicAiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 基于 DeepSeek AI 的文物查询服务实现
 */
@Slf4j
@Service
@Primary  // 设置为主要实现，替代原来的关键字匹配实现
public class RelicAiServiceDeepSeekImpl implements RelicAiService {
    
    private final CulturalRelicService culturalRelicService;
    private final DeepSeekService deepSeekService;
    
    public RelicAiServiceDeepSeekImpl(CulturalRelicService culturalRelicService, 
                                      DeepSeekService deepSeekService) {
        this.culturalRelicService = culturalRelicService;
        this.deepSeekService = deepSeekService;
    }
    
    @Override
    public AiRelicQueryResponse queryRelics(String question, Boolean matchAll) {
        String keyword = question == null ? "" : question.trim();
        if (keyword.isEmpty()) {
            throw new IllegalArgumentException("请输入想查询的文物问题或关键词");
        }
        
        log.info("使用 DeepSeek AI 查询文物: question={}", question);
        
        try {
            // 获取所有文物
            List<CulturalRelic> allRelics = culturalRelicService.list();
            
            // 使用 DeepSeek AI 分析并查询
            DeepSeekService.DeepSeekAnalysisResult analysisResult = 
                deepSeekService.analyzeAndQuery(question, allRelics);
            
            // 构建响应
            AiRelicQueryResponse response = new AiRelicQueryResponse();
            
            // 根据AI推荐的ID获取文物详情
            List<AiRelicItemVO> items = new ArrayList<>();
            if (analysisResult.getRecommendedRelicIds() != null && 
                !analysisResult.getRecommendedRelicIds().isEmpty()) {
                
                for (Long relicId : analysisResult.getRecommendedRelicIds()) {
                    CulturalRelic relic = allRelics.stream()
                        .filter(r -> r.getId().equals(relicId))
                        .findFirst()
                        .orElse(null);
                    
                    if (relic != null) {
                        AiRelicItemVO item = buildRelicItem(relic, analysisResult);
                        items.add(item);
                    }
                }
            }
            
            response.setRelics(items);
            response.setTotal(items.size());
            response.setMuseumHit(!items.isEmpty());
            response.setAnswer(analysisResult.getAnswer());
            response.setTopReason(analysisResult.getReasoning());
            response.setMuseumMessage(items.isEmpty() ? 
                "本博物馆暂无符合条件的文物" : 
                "AI为您找到了 " + items.size() + " 件相关文物");
            response.setWebResults(new ArrayList<>());
            
            log.info("DeepSeek AI 查询完成: 找到{}件文物", items.size());
            
            return response;
            
        } catch (Exception e) {
            log.error("DeepSeek AI 查询失败，降级到关键字搜索", e);
            // 降级：使用简单的关键字匹配
            return fallbackKeywordSearch(question, matchAll);
        }
    }
    
    /**
     * 构建文物项
     */
    private AiRelicItemVO buildRelicItem(CulturalRelic relic, 
                                         DeepSeekService.DeepSeekAnalysisResult analysisResult) {
        AiRelicItemVO item = new AiRelicItemVO();
        item.setId(relic.getId());
        item.setRelicName(relic.getRelicName());
        item.setImagePath(relic.getImagePath());
        item.setEra(relic.getEra());
        item.setMaterial(relic.getMaterial());
        item.setStatus(relic.getStatus());
        item.setCategoryName(relic.getCategoryName());
        item.setDimensions(relic.getDimensions());
        item.setWeight(relic.getWeight());
        item.setDescription(relic.getDescription());
        item.setIntroduction(buildIntroduction(relic));
        item.setRelevancePercent(95);  // AI推荐的文物默认高相关度
        item.setMatchTags(analysisResult.getKeywords());
        return item;
    }
    
    /**
     * 构建文物介绍
     */
    private String buildIntroduction(CulturalRelic relic) {
        StringBuilder builder = new StringBuilder();
        builder.append(relic.getRelicName() == null ? "该文物" : relic.getRelicName());
        
        if (hasText(relic.getEra())) {
            builder.append("，年代为").append(relic.getEra());
        }
        if (hasText(relic.getMaterial())) {
            builder.append("，材质为").append(relic.getMaterial());
        }
        if (hasText(relic.getCategoryName())) {
            builder.append("，分类属于").append(relic.getCategoryName());
        }
        if (hasText(relic.getDimensions())) {
            builder.append("，尺寸为").append(relic.getDimensions());
        }
        if (relic.getWeight() != null) {
            builder.append("，重量约 ").append(String.format("%.2f", relic.getWeight())).append("kg");
        }
        if (hasText(relic.getStatus())) {
            builder.append("，当前状态为").append(relic.getStatus());
        }
        if (hasText(relic.getOrigin())) {
            builder.append("，来源/出土地为").append(relic.getOrigin());
        }
        if (hasText(relic.getDescription())) {
            builder.append("。相关介绍：").append(relic.getDescription());
        } else {
            builder.append("。系统中暂未录入更详细的文字介绍。");
        }
        
        return builder.toString();
    }
    
    /**
     * 降级方案：简单的关键字搜索
     */
    private AiRelicQueryResponse fallbackKeywordSearch(String question, Boolean matchAll) {
        log.info("使用降级方案：关键字搜索");
        
        List<CulturalRelic> allRelics = culturalRelicService.list();
        List<AiRelicItemVO> items = new ArrayList<>();
        
        String lowerQuestion = question.toLowerCase();
        
        for (CulturalRelic relic : allRelics) {
            if (matchesKeyword(relic, lowerQuestion)) {
                AiRelicItemVO item = new AiRelicItemVO();
                item.setId(relic.getId());
                item.setRelicName(relic.getRelicName());
                item.setImagePath(relic.getImagePath());
                item.setEra(relic.getEra());
                item.setMaterial(relic.getMaterial());
                item.setStatus(relic.getStatus());
                item.setCategoryName(relic.getCategoryName());
                item.setDimensions(relic.getDimensions());
                item.setWeight(relic.getWeight());
                item.setDescription(relic.getDescription());
                item.setIntroduction(buildIntroduction(relic));
                item.setRelevancePercent(80);
                item.setMatchTags(new ArrayList<>());
                items.add(item);
                
                if (items.size() >= 5) {
                    break;
                }
            }
        }
        
        AiRelicQueryResponse response = new AiRelicQueryResponse();
        response.setRelics(items);
        response.setTotal(items.size());
        response.setMuseumHit(!items.isEmpty());
        response.setAnswer(items.isEmpty() ? 
            "未找到相关文物" : 
            "找到 " + items.size() + " 件相关文物");
        response.setTopReason("基于关键字匹配");
        response.setMuseumMessage(items.isEmpty() ? 
            "本博物馆暂无符合条件的文物" : 
            "为您找到了 " + items.size() + " 件相关文物");
        response.setWebResults(new ArrayList<>());
        
        return response;
    }
    
    /**
     * 简单的关键字匹配
     */
    private boolean matchesKeyword(CulturalRelic relic, String keyword) {
        return contains(relic.getRelicName(), keyword) ||
               contains(relic.getRelicCode(), keyword) ||
               contains(relic.getEra(), keyword) ||
               contains(relic.getMaterial(), keyword) ||
               contains(relic.getCategoryName(), keyword) ||
               contains(relic.getStatus(), keyword) ||
               contains(relic.getDescription(), keyword);
    }
    
    private boolean contains(String source, String keyword) {
        return source != null && keyword != null && 
               source.toLowerCase().contains(keyword);
    }
    
    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
