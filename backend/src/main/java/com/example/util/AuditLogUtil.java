package com.example.util;

import com.example.dto.DataChangeDTO;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Field;
import java.util.*;

/**
 * 审计日志工具类
 * 用于比较对象变更并生成变更记录
 */
public class AuditLogUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(AuditLogUtil.class);
    private static final ObjectMapper objectMapper;
    
    static {
        objectMapper = new ObjectMapper();
        // 注册Java 8日期时间模块
        objectMapper.registerModule(new JavaTimeModule());
        // 禁用将日期写为时间戳的功能
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
    }
    
    /**
     * 比较两个对象的差异
     * 
     * @param oldObj 旧对象
     * @param newObj 新对象
     * @param fieldLabels 字段标签映射（字段名 -> 中文名）
     * @return 变更列表
     */
    public static List<DataChangeDTO> compareObjects(Object oldObj, Object newObj, Map<String, String> fieldLabels) {
        List<DataChangeDTO> changes = new ArrayList<>();
        
        if (oldObj == null || newObj == null) {
            return changes;
        }
        
        try {
            Class<?> clazz = oldObj.getClass();
            Field[] fields = clazz.getDeclaredFields();
            
            for (Field field : fields) {
                field.setAccessible(true);
                
                // 跳过不需要比较的字段
                if (shouldSkipField(field.getName())) {
                    continue;
                }
                
                Object oldValue = field.get(oldObj);
                Object newValue = field.get(newObj);
                
                // 比较值是否变更
                boolean changed = !Objects.equals(oldValue, newValue);
                
                if (changed) {
                    DataChangeDTO change = new DataChangeDTO();
                    change.setField(field.getName());
                    change.setLabel(fieldLabels.getOrDefault(field.getName(), field.getName()));
                    change.setOldValue(oldValue);
                    change.setNewValue(newValue);
                    change.setValueType(getValueType(field.getType()));
                    change.setChanged(true);
                    
                    changes.add(change);
                }
            }
        } catch (Exception e) {
            logger.error("比较对象差异失败", e);
        }
        
        return changes;
    }
    
    /**
     * 将对象转换为JSON字符串
     */
    public static String toJson(Object obj) {
        if (obj == null) {
            return null;
        }
        
        try {
            return objectMapper.writeValueAsString(obj);
        } catch (Exception e) {
            logger.error("对象转JSON失败", e);
            return null;
        }
    }
    
    /**
     * 将变更列表转换为JSON字符串
     */
    public static String changesToJson(List<DataChangeDTO> changes) {
        if (changes == null || changes.isEmpty()) {
            return null;
        }
        
        try {
            return objectMapper.writeValueAsString(changes);
        } catch (Exception e) {
            logger.error("变更列表转JSON失败", e);
            return null;
        }
    }
    
    /**
     * 判断是否应该跳过该字段
     */
    private static boolean shouldSkipField(String fieldName) {
        // 跳过这些字段
        Set<String> skipFields = new HashSet<>(Arrays.asList(
            "id", "createTime", "updateTime", "createBy", "updateBy",
            "serialVersionUID", "class"
        ));
        
        return skipFields.contains(fieldName);
    }
    
    /**
     * 获取值类型
     */
    private static String getValueType(Class<?> type) {
        if (type == String.class) {
            return "STRING";
        } else if (type == Integer.class || type == int.class || 
                   type == Long.class || type == long.class ||
                   type == Double.class || type == double.class ||
                   type == Float.class || type == float.class) {
            return "NUMBER";
        } else if (type == Boolean.class || type == boolean.class) {
            return "BOOLEAN";
        } else if (type == Date.class || type.getName().contains("LocalDate") || 
                   type.getName().contains("LocalDateTime")) {
            return "DATE";
        } else {
            return "OBJECT";
        }
    }
    
    /**
     * 解析User-Agent获取浏览器信息
     */
    public static String parseBrowser(String userAgent) {
        if (userAgent == null || userAgent.isEmpty()) {
            return "Unknown";
        }
        
        if (userAgent.contains("Edge")) {
            return "Edge";
        } else if (userAgent.contains("Chrome")) {
            return "Chrome";
        } else if (userAgent.contains("Firefox")) {
            return "Firefox";
        } else if (userAgent.contains("Safari")) {
            return "Safari";
        } else if (userAgent.contains("Opera") || userAgent.contains("OPR")) {
            return "Opera";
        } else if (userAgent.contains("MSIE") || userAgent.contains("Trident")) {
            return "IE";
        } else {
            return "Other";
        }
    }
    
    /**
     * 解析User-Agent获取操作系统信息
     */
    public static String parseOS(String userAgent) {
        if (userAgent == null || userAgent.isEmpty()) {
            return "Unknown";
        }
        
        if (userAgent.contains("Windows NT 10.0")) {
            return "Windows 10";
        } else if (userAgent.contains("Windows NT 6.3")) {
            return "Windows 8.1";
        } else if (userAgent.contains("Windows NT 6.2")) {
            return "Windows 8";
        } else if (userAgent.contains("Windows NT 6.1")) {
            return "Windows 7";
        } else if (userAgent.contains("Windows")) {
            return "Windows";
        } else if (userAgent.contains("Mac OS X")) {
            return "Mac OS X";
        } else if (userAgent.contains("Linux")) {
            return "Linux";
        } else if (userAgent.contains("Android")) {
            return "Android";
        } else if (userAgent.contains("iPhone") || userAgent.contains("iPad")) {
            return "iOS";
        } else {
            return "Other";
        }
    }
    
    /**
     * 创建字段标签映射（示例）
     */
    public static Map<String, String> createRelicFieldLabels() {
        Map<String, String> labels = new HashMap<>();
        labels.put("relicName", "文物名称");
        labels.put("relicCode", "文物编号");
        labels.put("categoryId", "分类");
        labels.put("era", "年代");
        labels.put("material", "材质");
        labels.put("size", "尺寸");
        labels.put("weight", "重量");
        labels.put("status", "状态");
        labels.put("location", "位置");
        labels.put("description", "描述");
        labels.put("imageUrl", "图片");
        labels.put("model3dUrl", "3D模型链接");
        labels.put("model3dUploadTime", "3D模型上传时间");
        return labels;
    }
    
    /**
     * 创建借展字段标签映射
     */
    public static Map<String, String> createLoanFieldLabels() {
        Map<String, String> labels = new HashMap<>();
        labels.put("relicId", "文物");
        labels.put("borrower", "借展方");
        labels.put("loanDate", "借展日期");
        labels.put("returnDate", "归还日期");
        labels.put("status", "状态");
        labels.put("purpose", "借展目的");
        labels.put("approver", "审批人");
        labels.put("approveDate", "审批日期");
        return labels;
    }
    
    /**
     * 创建修复字段标签映射
     */
    public static Map<String, String> createRepairFieldLabels() {
        Map<String, String> labels = new HashMap<>();
        labels.put("relicId", "文物");
        labels.put("repairReason", "修复原因");
        labels.put("status", "状态");
        labels.put("priority", "优先级");
        labels.put("repairExpert", "修复专家");
        labels.put("estimatedCost", "预估费用");
        labels.put("actualCost", "实际费用");
        labels.put("startDate", "开始日期");
        labels.put("completeDate", "完成日期");
        return labels;
    }
}
