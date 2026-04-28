package com.example.dto;

import lombok.Data;
import java.math.BigDecimal;

/**
 * 修复申请请求
 */
@Data
public class RepairApplyRequest {
    private Long relicId;                   // 文物ID
    private String priority;                // 优先级：紧急、高、普通、低
    private String repairReason;            // 修复原因
    private String damageDescription;       // 损坏描述
    private BigDecimal estimatedCost;       // 预算费用
    private String beforeImages;            // 修复前照片
    private String repairExpert;            // 修复专家（非必填）
    private String remark;                  // 备注
}
