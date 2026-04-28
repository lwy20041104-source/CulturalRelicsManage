package com.example.dto;

import lombok.Data;

/**
 * 修复审批请求
 */
@Data
public class RepairApproveRequest {
    private Long id;                        // 修复记录ID
    private Boolean approved;               // 是否通过：true通过 false拒绝
    private String approveRemark;           // 审批意见
    private String repairExpert;            // 分配的修复专家（通过时必填）
}
