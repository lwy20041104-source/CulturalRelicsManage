package com.example.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MaintenanceRecord {
    private Long id;
    private Long relicId;
    private String relicName;
    private String maintenanceType;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime maintenanceDate;
    private String maintenanceContent;
    private Long maintainerId;              // 维护人员ID
    private String maintainerName;          // 维护人员姓名（用于显示）
    private String status;                  // 状态：待审批、已通过、已拒绝
    private String approver;                // 审批人
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime approveDate;      // 审批日期
    private String approveRemark;           // 审批意见
    private String remark;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime updateTime;
}
