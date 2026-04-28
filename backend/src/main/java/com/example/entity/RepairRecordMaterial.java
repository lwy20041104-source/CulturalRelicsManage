package com.example.entity;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 修复记录材料关联实体
 */
@Data
public class RepairRecordMaterial {
    private Long id;
    private Long repairRecordId;        // 修复记录ID
    private Long materialId;            // 材料ID
    private BigDecimal quantity;        // 使用数量
    private BigDecimal unitPrice;       // 单价（记录使用时的价格）
    private BigDecimal totalPrice;      // 总价
    private String remark;              // 备注
    private LocalDateTime createTime;   // 创建时间
    
    // 关联信息（非数据库字段）
    private String materialName;        // 材料名称
    private String materialCode;        // 材料编号
    private String unit;                // 单位
}
