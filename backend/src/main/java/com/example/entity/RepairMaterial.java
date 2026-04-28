package com.example.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 修复材料实体
 */
@Data
public class RepairMaterial {
    private Long id;
    private String materialName;        // 材料名称
    private String materialCode;        // 材料编号
    private String category;            // 材料类别
    private String unit;                // 单位
    private BigDecimal unitPrice;       // 单价
    private BigDecimal stockQuantity;   // 库存数量
    private String supplier;            // 供应商
    private String remark;              // 备注
    private LocalDateTime createTime;   // 创建时间
    private LocalDateTime updateTime;   // 更新时间
}
