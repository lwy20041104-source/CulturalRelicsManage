package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * 数据变更详情实体类
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class DataChangeDetail {
    private Long id;
    private Long logId;
    private String fieldName;
    private String fieldLabel;
    private String oldValue;
    private String newValue;
    private String valueType;
    
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
