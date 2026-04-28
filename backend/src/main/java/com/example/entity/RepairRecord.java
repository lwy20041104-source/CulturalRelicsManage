package com.example.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 文物修复记录实体
 */
@Data
public class RepairRecord {
    private Long id;
    private String repairCode;              // 修复编号
    private Long relicId;                   // 文物ID
    private String status;                  // 状态：待审批、待修复、修复中、修复完成、已拒绝
    private String priority;                // 优先级：紧急、高、普通、低
    
    // 申请信息
    private Long applicantId;               // 申请人ID
    private LocalDateTime applyDate;        // 申请日期
    private String repairReason;            // 修复原因
    private String damageDescription;       // 损坏描述
    private BigDecimal estimatedCost;       // 预算费用
    
    // 审批信息
    private String approver;                // 审批人
    private LocalDateTime approveDate;      // 审批日期
    private String approveRemark;           // 审批意见
    
    // 修复信息
    private String repairExpert;            // 修复专家
    private LocalDateTime startDate;        // 开始修复日期
    private LocalDateTime completeDate;     // 完成日期
    private String repairProcess;           // 修复过程
    private String repairMethod;            // 修复方法
    // 注意：使用材料信息已移至repair_record_material关联表
    private BigDecimal actualCost;          // 实际费用
    
    // 照片
    private String beforeImages;            // 修复前照片（多张，逗号分隔）
    private String afterImages;             // 修复后照片（多张，逗号分隔）
    
    // 质量评估
    private Integer qualityScore;           // 质量评分（0-100）
    private String qualityRemark;           // 质量评估意见
    
    private String remark;                  // 备注
    private LocalDateTime createTime;       // 创建时间
    private LocalDateTime updateTime;       // 更新时间
    
    // 关联信息（非数据库字段）
    private String relicName;               // 文物名称
    private String relicCode;               // 文物编号
    private String applicantName;           // 申请人姓名（用于显示）
}
