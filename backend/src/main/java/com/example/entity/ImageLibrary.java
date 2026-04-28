package com.example.entity;

import lombok.Data;

import java.time.LocalDateTime;

/**
 * 图片库实体类
 */
@Data
public class ImageLibrary {
    
    private Long id;
    
    /**
     * 图片名称
     */
    private String imageName;
    
    /**
     * 原始文件名
     */
    private String originalName;
    
    /**
     * 文件路径
     */
    private String filePath;
    
    /**
     * 文件大小(字节)
     */
    private Long fileSize;
    
    /**
     * 文件类型(MIME)
     */
    private String fileType;
    
    /**
     * 图片宽度
     */
    private Integer width;
    
    /**
     * 图片高度
     */
    private Integer height;
    
    /**
     * 分类(relic/exhibition/document/other/uncategorized)
     */
    private String category;
    
    /**
     * 标签(逗号分隔)
     */
    private String tags;
    
    /**
     * 描述
     */
    private String description;
    
    /**
     * 上传者ID
     */
    private Long uploaderId;
    
    /**
     * 上传者姓名
     */
    private String uploaderName;
    
    /**
     * 关联类型(relic/loan/repair等)
     */
    private String referenceType;
    
    /**
     * 关联对象ID
     */
    private Long referenceId;
    
    /**
     * 是否公开(1:是 0:否)
     */
    private Integer isPublic;
    
    /**
     * 浏览次数
     */
    private Integer viewCount;
    
    /**
     * 下载次数
     */
    private Integer downloadCount;
    
    /**
     * 状态(1:正常 0:已删除)
     */
    private Integer status;
    
    /**
     * 创建时间
     */
    private LocalDateTime createTime;
    
    /**
     * 更新时间
     */
    private LocalDateTime updateTime;
}
