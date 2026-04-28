package com.example.entity;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Museum {
    private Long id;
    private String museumCode;        // 博物馆编码
    private String museumName;        // 博物馆名称
    private String museumType;        // 博物馆类型
    private String province;          // 省份
    private String city;              // 城市
    private String address;           // 详细地址
    private String contactPerson;     // 联系人
    private String contactPhone;      // 联系电话
    private String contactEmail;      // 联系邮箱
    private String description;       // 描述
    private Integer status;           // 合作状态：1-有合作，0-无合作
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}
