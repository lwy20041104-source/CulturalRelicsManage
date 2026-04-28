package com.example.dto;

import lombok.Data;

@Data
public class LoanApproveRequest {
    private Long id;
    private String approverName;
    private String approveRemark;
    private Boolean approved;
}
