package com.example.dto;

import lombok.Data;
import java.math.BigDecimal;

/**
 * 修复进度更新请求
 */
@Data
public class RepairProgressRequest {
    private Long id;                        // 修复记录ID
    private String status;                  // 状态：修复中、修复完成
    private String repairProcess;           // 修复过程
    private String repairMethod;            // 修复方法
    // 注意：材料使用信息通过repair_record_material关联表管理
    private BigDecimal actualCost;          // 实际费用
    private String afterImages;             // 修复后照片
    private Integer qualityScore;           // 质量评分（0-100）
    private String qualityRemark;           // 质量评估意见
    private String remark;                  // 备注
}
