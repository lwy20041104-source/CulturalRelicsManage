package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

/**
 * 修复专家实体
 */
@Data
public class RepairExpert {
    private Long id;
    private String expertName;              // 专家姓名
    private String expertCode;              // 专家编号
    private String specialty;               // 专业领域
    private String title;                   // 职称
    private String phone;                   // 联系电话
    private String email;                   // 邮箱
    private Integer workYears;              // 从业年限
    private String certification;           // 资质证书
    private Integer status;                 // 状态：1启用 0禁用
    private String remark;                  // 备注
    private LocalDateTime createTime;       // 创建时间
    private LocalDateTime updateTime;       // 更新时间
}
