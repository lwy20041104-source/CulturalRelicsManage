package com.example.service.impl;

import com.example.dto.ImageRecognitionResult;
import com.example.dto.ImageRecognitionResult.CategorySuggestion;
import com.example.service.RelicImageRecognitionService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 文物图像识别服务实现
 * 
 * 注意：这是一个基于规则的简化实现，用于演示功能
 * 在生产环境中，应该集成真实的AI图像识别服务（如百度AI、阿里云视觉智能、腾讯云AI等）
 */
@Slf4j
@Service
public class RelicImageRecognitionServiceImpl implements RelicImageRecognitionService {
    
    // 文物分类映射
    private static final Map<Long, String> CATEGORY_MAP = new HashMap<>();
    
    static {
        CATEGORY_MAP.put(1L, "青铜器");
        CATEGORY_MAP.put(2L, "陶瓷器");
        CATEGORY_MAP.put(3L, "书画");
        CATEGORY_MAP.put(4L, "玉器");
        CATEGORY_MAP.put(5L, "金银器");
        CATEGORY_MAP.put(6L, "碑帖");
        CATEGORY_MAP.put(7L, "钱币");
        CATEGORY_MAP.put(8L, "服饰");
        CATEGORY_MAP.put(9L, "佛像");
        CATEGORY_MAP.put(10L, "杂项");
    }
    
    @Override
    public ImageRecognitionResult recognizeRelic(MultipartFile imageFile) {
        try {
            if (imageFile == null || imageFile.isEmpty()) {
                return createErrorResult("图片文件为空");
            }
            
            // 读取图片
            BufferedImage image = ImageIO.read(imageFile.getInputStream());
            if (image == null) {
                return createErrorResult("无法读取图片文件");
            }
            
            // 分析图片特征
            return analyzeImage(image);
            
        } catch (IOException e) {
            log.error("图片识别失败", e);
            return createErrorResult("图片识别失败: " + e.getMessage());
        }
    }
    
    @Override
    public ImageRecognitionResult recognizeRelicByUrl(String imageUrl) {
        try {
            if (imageUrl == null || imageUrl.trim().isEmpty()) {
                return createErrorResult("图片URL为空");
            }
            
            // 从URL读取图片
            URL url = new URL(imageUrl);
            BufferedImage image = ImageIO.read(url);
            if (image == null) {
                return createErrorResult("无法从URL读取图片");
            }
            
            // 分析图片特征
            return analyzeImage(image);
            
        } catch (Exception e) {
            log.error("通过URL识别图片失败", e);
            return createErrorResult("图片识别失败: " + e.getMessage());
        }
    }
    
    /**
     * 分析图片特征并返回识别结果
     * 
     * 这是一个简化的实现，基于颜色和形状特征进行基本分类
     * 实际应用中应该使用深度学习模型
     */
    private ImageRecognitionResult analyzeImage(BufferedImage image) {
        ImageRecognitionResult result = new ImageRecognitionResult();
        result.setSuccess(true);
        
        // 分析图片特征
        ImageFeatures features = extractFeatures(image);
        
        // 基于特征进行分类
        List<CategorySuggestion> suggestions = classifyByFeatures(features);
        
        if (!suggestions.isEmpty()) {
            result.setPrimaryCategory(suggestions.get(0));
            result.setAlternativeCategories(suggestions.subList(1, Math.min(suggestions.size(), 4)));
        } else {
            // 默认分类为杂项
            CategorySuggestion defaultCategory = new CategorySuggestion(
                10L, "杂项", 50.0, "无法确定具体分类"
            );
            result.setPrimaryCategory(defaultCategory);
            result.setAlternativeCategories(new ArrayList<>());
        }
        
        // 设置识别到的特征
        result.setFeatures(features.getDescriptions());
        
        // 根据特征推测年代和材质
        result.setSuggestedEra(inferEra(features));
        result.setSuggestedMaterial(inferMaterial(features));
        
        // 生成描述
        result.setDescription(generateDescription(result));
        
        return result;
    }
    
    /**
     * 提取图片特征
     */
    private ImageFeatures extractFeatures(BufferedImage image) {
        ImageFeatures features = new ImageFeatures();
        
        int width = image.getWidth();
        int height = image.getHeight();
        
        // 分析颜色分布
        Map<String, Integer> colorDistribution = new HashMap<>();
        int totalPixels = 0;
        
        // 采样分析（每隔10个像素采样一次，提高性能）
        for (int y = 0; y < height; y += 10) {
            for (int x = 0; x < width; x += 10) {
                int rgb = image.getRGB(x, y);
                Color color = new Color(rgb);
                
                String colorCategory = categorizeColor(color);
                colorDistribution.put(colorCategory, 
                    colorDistribution.getOrDefault(colorCategory, 0) + 1);
                totalPixels++;
            }
        }
        
        // 计算主要颜色
        String dominantColor = "";
        int maxCount = 0;
        for (Map.Entry<String, Integer> entry : colorDistribution.entrySet()) {
            if (entry.getValue() > maxCount) {
                maxCount = entry.getValue();
                dominantColor = entry.getKey();
            }
        }
        
        features.setDominantColor(dominantColor);
        features.setColorDistribution(colorDistribution);
        features.setWidth(width);
        features.setHeight(height);
        features.setAspectRatio((double) width / height);
        
        // 计算平均亮度
        features.setAverageBrightness(calculateAverageBrightness(image));
        
        return features;
    }
    
    /**
     * 将颜色分类
     */
    private String categorizeColor(Color color) {
        int r = color.getRed();
        int g = color.getGreen();
        int b = color.getBlue();
        
        // 计算亮度
        int brightness = (r + g + b) / 3;
        
        // 黑白灰
        if (Math.abs(r - g) < 30 && Math.abs(g - b) < 30 && Math.abs(r - b) < 30) {
            if (brightness < 50) return "黑色";
            if (brightness > 200) return "白色";
            return "灰色";
        }
        
        // 主色调
        if (r > g && r > b) {
            if (r > 180 && g < 100 && b < 100) return "红色";
            if (r > 150 && g > 100 && b < 100) return "橙色";
            return "棕色";
        }
        if (g > r && g > b) {
            return "绿色";
        }
        if (b > r && b > g) {
            return "蓝色";
        }
        if (r > 150 && g > 150 && b < 100) {
            return "黄色";
        }
        
        return "其他";
    }
    
    /**
     * 计算平均亮度
     */
    private double calculateAverageBrightness(BufferedImage image) {
        long totalBrightness = 0;
        int count = 0;
        
        int width = image.getWidth();
        int height = image.getHeight();
        
        for (int y = 0; y < height; y += 10) {
            for (int x = 0; x < width; x += 10) {
                int rgb = image.getRGB(x, y);
                Color color = new Color(rgb);
                int brightness = (color.getRed() + color.getGreen() + color.getBlue()) / 3;
                totalBrightness += brightness;
                count++;
            }
        }
        
        return count > 0 ? (double) totalBrightness / count : 0;
    }
    
    /**
     * 基于特征进行分类
     */
    private List<CategorySuggestion> classifyByFeatures(ImageFeatures features) {
        List<CategorySuggestion> suggestions = new ArrayList<>();
        
        String dominantColor = features.getDominantColor();
        double brightness = features.getAverageBrightness();
        
        // 基于颜色特征的简单规则分类
        if ("绿色".equals(dominantColor) || "青色".equals(dominantColor)) {
            suggestions.add(new CategorySuggestion(1L, "青铜器", 75.0, "检测到青铜色特征"));
            suggestions.add(new CategorySuggestion(4L, "玉器", 60.0, "可能是玉石材质"));
        } else if ("白色".equals(dominantColor) || "灰色".equals(dominantColor)) {
            suggestions.add(new CategorySuggestion(2L, "陶瓷器", 70.0, "检测到陶瓷色泽"));
            suggestions.add(new CategorySuggestion(6L, "碑帖", 65.0, "可能是石刻或拓片"));
        } else if ("黄色".equals(dominantColor) || "金色".equals(dominantColor)) {
            suggestions.add(new CategorySuggestion(5L, "金银器", 80.0, "检测到金属光泽"));
            suggestions.add(new CategorySuggestion(7L, "钱币", 65.0, "可能是金属钱币"));
        } else if ("棕色".equals(dominantColor) || "褐色".equals(dominantColor)) {
            suggestions.add(new CategorySuggestion(3L, "书画", 65.0, "检测到纸张或绢本特征"));
            suggestions.add(new CategorySuggestion(8L, "服饰", 60.0, "可能是织物材质"));
        } else if ("红色".equals(dominantColor)) {
            suggestions.add(new CategorySuggestion(8L, "服饰", 70.0, "检测到织物色彩"));
            suggestions.add(new CategorySuggestion(2L, "陶瓷器", 60.0, "可能是彩陶"));
        } else if (brightness < 100) {
            suggestions.add(new CategorySuggestion(1L, "青铜器", 65.0, "检测到深色金属特征"));
            suggestions.add(new CategorySuggestion(9L, "佛像", 60.0, "可能是石刻造像"));
        } else {
            suggestions.add(new CategorySuggestion(10L, "杂项", 50.0, "特征不明显"));
        }
        
        // 按置信度排序
        suggestions.sort((a, b) -> Double.compare(b.getConfidence(), a.getConfidence()));
        
        return suggestions;
    }
    
    /**
     * 推测年代
     */
    private String inferEra(ImageFeatures features) {
        // 这里是简化实现，实际应该基于更复杂的特征
        String dominantColor = features.getDominantColor();
        
        if ("绿色".equals(dominantColor) || "青色".equals(dominantColor)) {
            return "商周-汉代";
        } else if ("白色".equals(dominantColor)) {
            return "宋-清代";
        } else if ("黄色".equals(dominantColor)) {
            return "唐-明代";
        }
        
        return "待确定";
    }
    
    /**
     * 推测材质
     */
    private String inferMaterial(ImageFeatures features) {
        String dominantColor = features.getDominantColor();
        
        if ("绿色".equals(dominantColor) || "青色".equals(dominantColor)) {
            return "青铜";
        } else if ("白色".equals(dominantColor) || "灰色".equals(dominantColor)) {
            return "瓷/石";
        } else if ("黄色".equals(dominantColor)) {
            return "金/铜";
        } else if ("棕色".equals(dominantColor)) {
            return "纸/木";
        }
        
        return "待确定";
    }
    
    /**
     * 生成描述
     */
    private String generateDescription(ImageRecognitionResult result) {
        StringBuilder desc = new StringBuilder();
        desc.append("AI识别结果：");
        
        if (result.getPrimaryCategory() != null) {
            CategorySuggestion primary = result.getPrimaryCategory();
            desc.append("该文物最可能属于【")
                .append(primary.getCategoryName())
                .append("】类别（置信度：")
                .append(String.format("%.1f", primary.getConfidence()))
                .append("%）。");
        }
        
        if (result.getSuggestedMaterial() != null && !"待确定".equals(result.getSuggestedMaterial())) {
            desc.append("推测材质为：").append(result.getSuggestedMaterial()).append("。");
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
    
    /**
     * 图片特征类
     */
    private static class ImageFeatures {
        private String dominantColor;
        private Map<String, Integer> colorDistribution;
        private int width;
        private int height;
        private double aspectRatio;
        private double averageBrightness;
        
        public List<String> getDescriptions() {
            List<String> descriptions = new ArrayList<>();
            descriptions.add("主色调：" + dominantColor);
            descriptions.add("尺寸：" + width + "x" + height);
            descriptions.add("亮度：" + String.format("%.1f", averageBrightness));
            return descriptions;
        }
        
        // Getters and Setters
        public String getDominantColor() { return dominantColor; }
        public void setDominantColor(String dominantColor) { this.dominantColor = dominantColor; }
        public Map<String, Integer> getColorDistribution() { return colorDistribution; }
        public void setColorDistribution(Map<String, Integer> colorDistribution) { this.colorDistribution = colorDistribution; }
        public int getWidth() { return width; }
        public void setWidth(int width) { this.width = width; }
        public int getHeight() { return height; }
        public void setHeight(int height) { this.height = height; }
        public double getAspectRatio() { return aspectRatio; }
        public void setAspectRatio(double aspectRatio) { this.aspectRatio = aspectRatio; }
        public double getAverageBrightness() { return averageBrightness; }
        public void setAverageBrightness(double averageBrightness) { this.averageBrightness = averageBrightness; }
    }
}
