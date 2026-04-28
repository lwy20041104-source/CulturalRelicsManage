package com.example.dto;

import lombok.Data;

@Data
public class StatisticsOverviewVO {
    private Long relicTotal;
    private Long inStockTotal;
    private Long loaningTotal;
    private Long maintenanceTotal;
}
