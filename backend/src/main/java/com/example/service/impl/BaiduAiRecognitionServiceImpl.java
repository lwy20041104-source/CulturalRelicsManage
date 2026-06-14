package com.example.service.impl;

import com.baidu.aip.imageclassify.AipImageClassify;
import com.example.config.BaiduAiConfig;
import com.example.dto.ImageRecognitionResult;
import com.example.dto.ImageRecognitionResult.CategorySuggestion;
import com.example.service.BaiduAiRecognitionService;
import lombok.extern.slf4j.Slf4j;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 百度AI图像识别服务实现
 */
@Slf4j
@Service
public class BaiduAiRecognitionServiceImpl implements BaiduAiRecognitionService {

    private final AipImageClassify aipImageClassify;
    private final BaiduAiConfig baiduAiConfig;

    public BaiduAiRecognitionServiceImpl(AipImageClassify aipImageClassify,
                                         BaiduAiConfig baiduAiConfig) {
        this.aipImageClassify = aipImageClassify;
        this.baiduAiConfig = baiduAiConfig;
    }
    
    // 百度AI识别关键词到文物分类的映射
    private static final Map<String, Long> KEYWORD_TO_CATEGORY = new HashMap<>();
    
    // 文物分类ID到名称的映射
    private static final Map<Long, String> CATEGORY_NAMES = new HashMap<>();
    
    static {
        // 初始化分类映射
        CATEGORY_NAMES.put(1L, "青铜器");
        CATEGORY_NAMES.put(2L, "陶瓷器");
        CATEGORY_NAMES.put(3L, "书画");
        CATEGORY_NAMES.put(4L, "玉器");
        CATEGORY_NAMES.put(5L, "金银器");
        CATEGORY_NAMES.put(6L, "碑帖");
        CATEGORY_NAMES.put(7L, "钱币");
        CATEGORY_NAMES.put(8L, "服饰");
        CATEGORY_NAMES.put(9L, "佛像");
        CATEGORY_NAMES.put(10L, "杂项");
        
        // 青铜器相关关键词
        KEYWORD_TO_CATEGORY.put("青铜", 1L);
        KEYWORD_TO_CATEGORY.put("青铜器", 1L);
        KEYWORD_TO_CATEGORY.put("铜器", 1L);
        KEYWORD_TO_CATEGORY.put("鼎", 1L);
        KEYWORD_TO_CATEGORY.put("钟", 1L);
        KEYWORD_TO_CATEGORY.put("编钟", 1L);
        KEYWORD_TO_CATEGORY.put("铜鼎", 1L);
        KEYWORD_TO_CATEGORY.put("青铜鼎", 1L);
        KEYWORD_TO_CATEGORY.put("爵", 1L);
        KEYWORD_TO_CATEGORY.put("觚", 1L);
        KEYWORD_TO_CATEGORY.put("簋", 1L);
        KEYWORD_TO_CATEGORY.put("铜壶", 1L);
        KEYWORD_TO_CATEGORY.put("铜尊", 1L);
        KEYWORD_TO_CATEGORY.put("铜盘", 1L);
        KEYWORD_TO_CATEGORY.put("铜镜", 1L);
        KEYWORD_TO_CATEGORY.put("铜剑", 1L);
        KEYWORD_TO_CATEGORY.put("铜戈", 1L);
        KEYWORD_TO_CATEGORY.put("铜矛", 1L);
        KEYWORD_TO_CATEGORY.put("青铜剑", 1L);
        KEYWORD_TO_CATEGORY.put("青铜镜", 1L);
        KEYWORD_TO_CATEGORY.put("铜像", 1L);
        KEYWORD_TO_CATEGORY.put("铜雕", 1L);
        
        // 陶瓷器相关关键词
        KEYWORD_TO_CATEGORY.put("陶瓷", 2L);
        KEYWORD_TO_CATEGORY.put("瓷器", 2L);
        KEYWORD_TO_CATEGORY.put("陶器", 2L);
        KEYWORD_TO_CATEGORY.put("瓷", 2L);
        KEYWORD_TO_CATEGORY.put("陶", 2L);
        KEYWORD_TO_CATEGORY.put("瓷瓶", 2L);
        KEYWORD_TO_CATEGORY.put("花瓶", 2L);
        KEYWORD_TO_CATEGORY.put("瓷碗", 2L);
        KEYWORD_TO_CATEGORY.put("瓷盘", 2L);
        KEYWORD_TO_CATEGORY.put("青瓷", 2L);
        KEYWORD_TO_CATEGORY.put("白瓷", 2L);
        KEYWORD_TO_CATEGORY.put("彩陶", 2L);
        KEYWORD_TO_CATEGORY.put("黑陶", 2L);
        KEYWORD_TO_CATEGORY.put("唐三彩", 2L);
        KEYWORD_TO_CATEGORY.put("景德镇", 2L);
        KEYWORD_TO_CATEGORY.put("瓷罐", 2L);
        KEYWORD_TO_CATEGORY.put("瓷壶", 2L);
        KEYWORD_TO_CATEGORY.put("瓷杯", 2L);
        KEYWORD_TO_CATEGORY.put("陶罐", 2L);
        KEYWORD_TO_CATEGORY.put("陶壶", 2L);
        KEYWORD_TO_CATEGORY.put("陶俑", 2L);
        KEYWORD_TO_CATEGORY.put("瓷俑", 2L);
        KEYWORD_TO_CATEGORY.put("青花瓷", 2L);
        KEYWORD_TO_CATEGORY.put("粉彩", 2L);
        KEYWORD_TO_CATEGORY.put("斗彩", 2L);
        KEYWORD_TO_CATEGORY.put("五彩", 2L);
        KEYWORD_TO_CATEGORY.put("釉", 2L);
        KEYWORD_TO_CATEGORY.put("釉色", 2L);
        KEYWORD_TO_CATEGORY.put("汝窑", 2L);
        KEYWORD_TO_CATEGORY.put("官窑", 2L);
        KEYWORD_TO_CATEGORY.put("哥窑", 2L);
        KEYWORD_TO_CATEGORY.put("钧窑", 2L);
        KEYWORD_TO_CATEGORY.put("定窑", 2L);
        
        // 书画相关关键词
        KEYWORD_TO_CATEGORY.put("书画", 3L);
        KEYWORD_TO_CATEGORY.put("书法", 3L);
        KEYWORD_TO_CATEGORY.put("绘画", 3L);
        KEYWORD_TO_CATEGORY.put("画", 3L);
        KEYWORD_TO_CATEGORY.put("字画", 3L);
        KEYWORD_TO_CATEGORY.put("国画", 3L);
        KEYWORD_TO_CATEGORY.put("山水画", 3L);
        KEYWORD_TO_CATEGORY.put("水墨画", 3L);
        KEYWORD_TO_CATEGORY.put("卷轴", 3L);
        KEYWORD_TO_CATEGORY.put("手卷", 3L);
        KEYWORD_TO_CATEGORY.put("立轴", 3L);
        KEYWORD_TO_CATEGORY.put("墨迹", 3L);
        KEYWORD_TO_CATEGORY.put("墨宝", 3L);
        KEYWORD_TO_CATEGORY.put("字", 3L);
        KEYWORD_TO_CATEGORY.put("书", 3L);
        KEYWORD_TO_CATEGORY.put("画作", 3L);
        KEYWORD_TO_CATEGORY.put("画卷", 3L);
        KEYWORD_TO_CATEGORY.put("工笔画", 3L);
        KEYWORD_TO_CATEGORY.put("写意画", 3L);
        KEYWORD_TO_CATEGORY.put("花鸟画", 3L);
        KEYWORD_TO_CATEGORY.put("人物画", 3L);
        KEYWORD_TO_CATEGORY.put("扇面", 3L);
        KEYWORD_TO_CATEGORY.put("册页", 3L);
        
        // 玉器相关关键词
        KEYWORD_TO_CATEGORY.put("玉", 4L);
        KEYWORD_TO_CATEGORY.put("玉器", 4L);
        KEYWORD_TO_CATEGORY.put("玉石", 4L);
        KEYWORD_TO_CATEGORY.put("玉佩", 4L);
        KEYWORD_TO_CATEGORY.put("玉璧", 4L);
        KEYWORD_TO_CATEGORY.put("玉琮", 4L);
        KEYWORD_TO_CATEGORY.put("玉圭", 4L);
        KEYWORD_TO_CATEGORY.put("和田玉", 4L);
        KEYWORD_TO_CATEGORY.put("翡翠", 4L);
        KEYWORD_TO_CATEGORY.put("玉环", 4L);
        KEYWORD_TO_CATEGORY.put("玉镯", 4L);
        KEYWORD_TO_CATEGORY.put("玉牌", 4L);
        KEYWORD_TO_CATEGORY.put("玉雕", 4L);
        KEYWORD_TO_CATEGORY.put("玉玺", 4L);
        KEYWORD_TO_CATEGORY.put("玉印", 4L);
        KEYWORD_TO_CATEGORY.put("玉带", 4L);
        KEYWORD_TO_CATEGORY.put("玉带钩", 4L);
        KEYWORD_TO_CATEGORY.put("玉如意", 4L);
        KEYWORD_TO_CATEGORY.put("玉瓶", 4L);
        KEYWORD_TO_CATEGORY.put("玉壶", 4L);
        
        // 金银器相关关键词
        KEYWORD_TO_CATEGORY.put("金", 5L);
        KEYWORD_TO_CATEGORY.put("银", 5L);
        KEYWORD_TO_CATEGORY.put("金器", 5L);
        KEYWORD_TO_CATEGORY.put("银器", 5L);
        KEYWORD_TO_CATEGORY.put("金银", 5L);
        KEYWORD_TO_CATEGORY.put("金银器", 5L);
        KEYWORD_TO_CATEGORY.put("金饰", 5L);
        KEYWORD_TO_CATEGORY.put("银饰", 5L);
        KEYWORD_TO_CATEGORY.put("金冠", 5L);
        KEYWORD_TO_CATEGORY.put("金杯", 5L);
        KEYWORD_TO_CATEGORY.put("银杯", 5L);
        KEYWORD_TO_CATEGORY.put("金碗", 5L);
        KEYWORD_TO_CATEGORY.put("银碗", 5L);
        KEYWORD_TO_CATEGORY.put("金盘", 5L);
        KEYWORD_TO_CATEGORY.put("银盘", 5L);
        KEYWORD_TO_CATEGORY.put("金壶", 5L);
        KEYWORD_TO_CATEGORY.put("银壶", 5L);
        KEYWORD_TO_CATEGORY.put("金瓶", 5L);
        KEYWORD_TO_CATEGORY.put("银瓶", 5L);
        KEYWORD_TO_CATEGORY.put("金镯", 5L);
        KEYWORD_TO_CATEGORY.put("银镯", 5L);
        KEYWORD_TO_CATEGORY.put("金簪", 5L);
        KEYWORD_TO_CATEGORY.put("银簪", 5L);
        
        // 碑帖相关关键词
        KEYWORD_TO_CATEGORY.put("碑", 6L);
        KEYWORD_TO_CATEGORY.put("碑帖", 6L);
        KEYWORD_TO_CATEGORY.put("石碑", 6L);
        KEYWORD_TO_CATEGORY.put("碑文", 6L);
        KEYWORD_TO_CATEGORY.put("拓片", 6L);
        KEYWORD_TO_CATEGORY.put("石刻", 6L);
        KEYWORD_TO_CATEGORY.put("摩崖", 6L);
        KEYWORD_TO_CATEGORY.put("墓志", 6L);
        KEYWORD_TO_CATEGORY.put("墓志铭", 6L);
        KEYWORD_TO_CATEGORY.put("碑刻", 6L);
        KEYWORD_TO_CATEGORY.put("石碣", 6L);
        KEYWORD_TO_CATEGORY.put("碑额", 6L);
        KEYWORD_TO_CATEGORY.put("碑座", 6L);
        
        // 钱币相关关键词（包含可能被误识别为饰品的情况）
        KEYWORD_TO_CATEGORY.put("钱币", 7L);
        KEYWORD_TO_CATEGORY.put("古钱", 7L);
        KEYWORD_TO_CATEGORY.put("铜钱", 7L);
        KEYWORD_TO_CATEGORY.put("银币", 7L);
        KEYWORD_TO_CATEGORY.put("金币", 7L);
        KEYWORD_TO_CATEGORY.put("货币", 7L);
        KEYWORD_TO_CATEGORY.put("铜板", 7L);
        KEYWORD_TO_CATEGORY.put("钱串", 7L);
        KEYWORD_TO_CATEGORY.put("铜钱串", 7L);
        KEYWORD_TO_CATEGORY.put("古币", 7L);
        KEYWORD_TO_CATEGORY.put("方孔钱", 7L);
        KEYWORD_TO_CATEGORY.put("圆形钱", 7L);
        // 钱币可能被误识别为饰品的关键词
        KEYWORD_TO_CATEGORY.put("手链", 7L);
        KEYWORD_TO_CATEGORY.put("项链", 7L);
        KEYWORD_TO_CATEGORY.put("串珠", 7L);
        KEYWORD_TO_CATEGORY.put("挂件", 7L);
        KEYWORD_TO_CATEGORY.put("饰品", 7L);
        KEYWORD_TO_CATEGORY.put("装饰品", 7L);
        KEYWORD_TO_CATEGORY.put("吊坠", 7L);
        KEYWORD_TO_CATEGORY.put("链子", 7L);
        KEYWORD_TO_CATEGORY.put("珠串", 7L);
        KEYWORD_TO_CATEGORY.put("串饰", 7L);
        
        // 服饰相关关键词
        KEYWORD_TO_CATEGORY.put("服饰", 8L);
        KEYWORD_TO_CATEGORY.put("衣服", 8L);
        KEYWORD_TO_CATEGORY.put("织物", 8L);
        KEYWORD_TO_CATEGORY.put("丝绸", 8L);
        KEYWORD_TO_CATEGORY.put("锦", 8L);
        KEYWORD_TO_CATEGORY.put("绣", 8L);
        KEYWORD_TO_CATEGORY.put("刺绣", 8L);
        KEYWORD_TO_CATEGORY.put("龙袍", 8L);
        KEYWORD_TO_CATEGORY.put("官服", 8L);
        KEYWORD_TO_CATEGORY.put("袍", 8L);
        KEYWORD_TO_CATEGORY.put("袄", 8L);
        KEYWORD_TO_CATEGORY.put("裙", 8L);
        KEYWORD_TO_CATEGORY.put("褂", 8L);
        KEYWORD_TO_CATEGORY.put("马褂", 8L);
        KEYWORD_TO_CATEGORY.put("长袍", 8L);
        KEYWORD_TO_CATEGORY.put("旗袍", 8L);
        KEYWORD_TO_CATEGORY.put("云肩", 8L);
        KEYWORD_TO_CATEGORY.put("披风", 8L);
        KEYWORD_TO_CATEGORY.put("帽", 8L);
        KEYWORD_TO_CATEGORY.put("冠", 8L);
        KEYWORD_TO_CATEGORY.put("鞋", 8L);
        KEYWORD_TO_CATEGORY.put("靴", 8L);
        
        // 佛像相关关键词
        KEYWORD_TO_CATEGORY.put("佛", 9L);
        KEYWORD_TO_CATEGORY.put("佛像", 9L);
        KEYWORD_TO_CATEGORY.put("菩萨", 9L);
        KEYWORD_TO_CATEGORY.put("观音", 9L);
        KEYWORD_TO_CATEGORY.put("罗汉", 9L);
        KEYWORD_TO_CATEGORY.put("造像", 9L);
        KEYWORD_TO_CATEGORY.put("石窟", 9L);
        KEYWORD_TO_CATEGORY.put("佛头", 9L);
        KEYWORD_TO_CATEGORY.put("佛身", 9L);
        KEYWORD_TO_CATEGORY.put("佛手", 9L);
        KEYWORD_TO_CATEGORY.put("如来", 9L);
        KEYWORD_TO_CATEGORY.put("释迦牟尼", 9L);
        KEYWORD_TO_CATEGORY.put("弥勒", 9L);
        KEYWORD_TO_CATEGORY.put("文殊", 9L);
        KEYWORD_TO_CATEGORY.put("普贤", 9L);
        KEYWORD_TO_CATEGORY.put("地藏", 9L);
        KEYWORD_TO_CATEGORY.put("金刚", 9L);
        KEYWORD_TO_CATEGORY.put("天王", 9L);
        KEYWORD_TO_CATEGORY.put("护法", 9L);
        KEYWORD_TO_CATEGORY.put("佛龛", 9L);
        KEYWORD_TO_CATEGORY.put("佛塔", 9L);
        KEYWORD_TO_CATEGORY.put("舍利", 9L);
        
        // 杂项相关关键词（其他未分类的文物）
        KEYWORD_TO_CATEGORY.put("文物", 10L);
        KEYWORD_TO_CATEGORY.put("古董", 10L);
        KEYWORD_TO_CATEGORY.put("古玩", 10L);
        KEYWORD_TO_CATEGORY.put("收藏品", 10L);
        KEYWORD_TO_CATEGORY.put("木器", 10L);
        KEYWORD_TO_CATEGORY.put("木雕", 10L);
        KEYWORD_TO_CATEGORY.put("竹雕", 10L);
        KEYWORD_TO_CATEGORY.put("牙雕", 10L);
        KEYWORD_TO_CATEGORY.put("象牙", 10L);
        KEYWORD_TO_CATEGORY.put("漆器", 10L);
        KEYWORD_TO_CATEGORY.put("家具", 10L);
        KEYWORD_TO_CATEGORY.put("屏风", 10L);
        KEYWORD_TO_CATEGORY.put("印章", 10L);
        KEYWORD_TO_CATEGORY.put("印", 10L);
        KEYWORD_TO_CATEGORY.put("砚", 10L);
        KEYWORD_TO_CATEGORY.put("砚台", 10L);
        KEYWORD_TO_CATEGORY.put("笔筒", 10L);
        KEYWORD_TO_CATEGORY.put("笔架", 10L);
        KEYWORD_TO_CATEGORY.put("文房", 10L);
        KEYWORD_TO_CATEGORY.put("香炉", 10L);
        KEYWORD_TO_CATEGORY.put("炉", 10L);
        KEYWORD_TO_CATEGORY.put("瓶", 10L);
        KEYWORD_TO_CATEGORY.put("罐", 10L);
        KEYWORD_TO_CATEGORY.put("盒", 10L);
        KEYWORD_TO_CATEGORY.put("盘", 10L);
        KEYWORD_TO_CATEGORY.put("碗", 10L);
        KEYWORD_TO_CATEGORY.put("杯", 10L);
        KEYWORD_TO_CATEGORY.put("壶", 10L);
        KEYWORD_TO_CATEGORY.put("尊", 10L);
        KEYWORD_TO_CATEGORY.put("觥", 10L);
    }
    
    /**
     * 检查百度AI是否可用
     */
    @Override
    public boolean isAvailable() {
        return baiduAiConfig.isEnabled() && aipImageClassify != null;
    }
    
    /**
     * 使用百度AI识别图片
     */
    @Override
    public ImageRecognitionResult recognizeWithBaiduAi(byte[] imageData) {
        if (!isAvailable()) {
            log.warn("百度AI不可用");
            return null;
        }
        
        try {
            log.info("调用百度AI图像识别接口");
            
            // 调用百度AI通用物体识别接口
            JSONObject response = aipImageClassify.advancedGeneral(imageData, new HashMap<>());
            
            if (response == null) {
                log.error("百度AI返回null");
                return null;
            }
            
            // 检查是否有错误
            if (response.has("error_code")) {
                int errorCode = response.getInt("error_code");
                String errorMsg = response.optString("error_msg", "未知错误");
                log.error("百度AI识别失败，错误码：{}，错误信息：{}", errorCode, errorMsg);
                return createErrorResult("百度AI识别失败：" + errorMsg);
            }
            
            // 解析识别结果
            if (!response.has("result")) {
                log.warn("百度AI返回结果中没有result字段");
                return null;
            }
            
            JSONArray results = response.getJSONArray("result");
            if (results.length() == 0) {
                log.warn("百度AI未识别到任何物体");
                return null;
            }
            
            log.info("百度AI识别到 {} 个物体", results.length());
            
            // 转换为文物分类
            return convertBaiduResultToRelicCategory(results);
            
        } catch (Exception e) {
            log.error("调用百度AI识别失败", e);
            return null;
        }
    }
    
    /**
     * 将百度AI识别结果转换为文物分类
     */
    private ImageRecognitionResult convertBaiduResultToRelicCategory(JSONArray baiduResults) {
        ImageRecognitionResult result = new ImageRecognitionResult();
        result.setSuccess(true);
        
        // 用于存储匹配到的分类及其得分
        Map<Long, Double> categoryScores = new HashMap<>();
        Map<Long, List<String>> categoryReasons = new HashMap<>();
        
        // 遍历百度AI识别结果
        for (int i = 0; i < Math.min(baiduResults.length(), 10); i++) {
            JSONObject item = baiduResults.getJSONObject(i);
            String keyword = item.getString("keyword");
            double score = item.getDouble("score");
            
            log.debug("百度AI识别结果 {}: {} (置信度: {})", i + 1, keyword, score);
            
            // 查找匹配的文物分类
            Long categoryId = findMatchingCategory(keyword);
            if (categoryId != null) {
                // 累加得分（百度AI的score是0-1之间的值，转换为百分比）
                double currentScore = categoryScores.getOrDefault(categoryId, 0.0);
                categoryScores.put(categoryId, currentScore + score * 100);
                
                // 记录识别原因
                categoryReasons.computeIfAbsent(categoryId, k -> new ArrayList<>())
                    .add(String.format("识别到：%s (%.1f%%)", keyword, score * 100));
            }
        }
        
        // 如果没有匹配到任何分类，返回null让规则识别接管
        if (categoryScores.isEmpty()) {
            log.info("百度AI识别的物体未匹配到文物分类，将使用规则识别");
            return null;
        }
        
        // 按得分排序
        List<Map.Entry<Long, Double>> sortedCategories = new ArrayList<>(categoryScores.entrySet());
        sortedCategories.sort((a, b) -> Double.compare(b.getValue(), a.getValue()));
        
        // 构建分类建议列表
        List<CategorySuggestion> suggestions = new ArrayList<>();
        for (Map.Entry<Long, Double> entry : sortedCategories) {
            Long categoryId = entry.getKey();
            Double score = entry.getValue();
            String categoryName = CATEGORY_NAMES.get(categoryId);
            List<String> reasons = categoryReasons.get(categoryId);
            
            // 限制置信度最高为95%
            double confidence = Math.min(score, 95.0);
            
            CategorySuggestion suggestion = new CategorySuggestion(
                categoryId,
                categoryName,
                confidence,
                String.join("；", reasons)
            );
            suggestions.add(suggestion);
        }
        
        // 设置主要分类和备选分类
        if (!suggestions.isEmpty()) {
            result.setPrimaryCategory(suggestions.get(0));
            result.setAlternativeCategories(
                suggestions.subList(1, Math.min(suggestions.size(), 4))
            );
        }
        
        // 设置识别特征
        List<String> features = new ArrayList<>();
        features.add("识别方式：百度AI");
        features.add("识别物体数：" + baiduResults.length());
        features.add("匹配分类数：" + categoryScores.size());
        result.setFeatures(features);
        
        // 根据分类推测年代和材质
        if (result.getPrimaryCategory() != null) {
            Long categoryId = result.getPrimaryCategory().getCategoryId();
            result.setSuggestedEra(inferEraByCategory(categoryId));
            result.setSuggestedMaterial(inferMaterialByCategory(categoryId));
        }
        
        // 生成描述
        result.setDescription(generateDescription(result));
        
        return result;
    }
    
    /**
     * 查找匹配的文物分类
     */
    private Long findMatchingCategory(String keyword) {
        // 精确匹配
        if (KEYWORD_TO_CATEGORY.containsKey(keyword)) {
            return KEYWORD_TO_CATEGORY.get(keyword);
        }
        
        // 模糊匹配
        for (Map.Entry<String, Long> entry : KEYWORD_TO_CATEGORY.entrySet()) {
            if (keyword.contains(entry.getKey()) || entry.getKey().contains(keyword)) {
                return entry.getValue();
            }
        }
        
        return null;
    }
    
    /**
     * 根据分类推测年代
     */
    private String inferEraByCategory(Long categoryId) {
        switch (categoryId.intValue()) {
            case 1: return "商周-汉代";
            case 2: return "新石器-清代";
            case 3: return "唐-清代";
            case 4: return "新石器-清代";
            case 5: return "商周-清代";
            case 6: return "汉-清代";
            case 7: return "春秋-清代";
            case 8: return "汉-清代";
            case 9: return "魏晋-清代";
            default: return "待确定";
        }
    }
    
    /**
     * 根据分类推测材质
     */
    private String inferMaterialByCategory(Long categoryId) {
        switch (categoryId.intValue()) {
            case 1: return "青铜";
            case 2: return "陶/瓷";
            case 3: return "纸/绢";
            case 4: return "玉石";
            case 5: return "金/银";
            case 6: return "石";
            case 7: return "铜/银";
            case 8: return "丝/棉";
            case 9: return "石/铜/木";
            default: return "待确定";
        }
    }
    
    /**
     * 生成描述
     */
    private String generateDescription(ImageRecognitionResult result) {
        StringBuilder desc = new StringBuilder();
        desc.append("【百度AI识别】");
        
        if (result.getPrimaryCategory() != null) {
            CategorySuggestion primary = result.getPrimaryCategory();
            desc.append("该文物最可能属于【")
                .append(primary.getCategoryName())
                .append("】类别（置信度：")
                .append(String.format("%.1f", primary.getConfidence()))
                .append("%）。");
        }
        
        if (result.getSuggestedMaterial() != null && !"待确定".equals(result.getSuggestedMaterial())) {
            desc.append("推测材质：").append(result.getSuggestedMaterial()).append("。");
        }
        
        if (result.getSuggestedEra() != null && !"待确定".equals(result.getSuggestedEra())) {
            desc.append("可能年代：").append(result.getSuggestedEra()).append("。");
        }
        
        desc.append("建议人工复核确认。");
        
        return desc.toString();
    }
    
    /**
     * 创建错误结果
     */
    private ImageRecognitionResult createErrorResult(String errorMessage) {
        ImageRecognitionResult result = new ImageRecognitionResult();
        result.setSuccess(false);
        result.setErrorMessage(errorMessage);
        return result;
    }
}
