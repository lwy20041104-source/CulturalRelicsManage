package com.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 数据变更DTO
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DataChangeDTO {
    private String field;        // 字段名
    private String label;        // 字段标签（中文名）
    private Object oldValue;     // 旧值
    private Object newValue;     // 新值
    private String valueType;    // 值类型
    private Boolean changed;     // 是否变更
}
