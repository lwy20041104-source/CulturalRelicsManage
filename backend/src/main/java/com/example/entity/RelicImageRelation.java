package com.example.entity;

import java.time.LocalDateTime;

/**
 * 文物图片关联实体类
 * 实现文物与图片的一对一关联
 */
public class RelicImageRelation {
    
    private Long id;
    private Long relicId;
    private Long imageId;
    private String relationType;  // main:主图, detail:详情图
    private Integer isMain;       // 是否为主图（1:是, 0:否）
    private Integer sortOrder;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    
    // 关联对象（用于查询时返回完整信息）
    private CulturalRelic relic;
    private ImageLibrary image;
    
    public RelicImageRelation() {
    }
    
    public RelicImageRelation(Long relicId, Long imageId, String relationType) {
        this.relicId = relicId;
        this.imageId = imageId;
        this.relationType = relationType;
    }
    
    // Getters and Setters
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public Long getRelicId() {
        return relicId;
    }
    
    public void setRelicId(Long relicId) {
        this.relicId = relicId;
    }
    
    public Long getImageId() {
        return imageId;
    }
    
    public void setImageId(Long imageId) {
        this.imageId = imageId;
    }
    
    public String getRelationType() {
        return relationType;
    }
    
    public void setRelationType(String relationType) {
        this.relationType = relationType;
    }
    
    public Integer getSortOrder() {
        return sortOrder;
    }
    
    public void setSortOrder(Integer sortOrder) {
        this.sortOrder = sortOrder;
    }
    
    public Integer getIsMain() {
        return isMain;
    }
    
    public void setIsMain(Integer isMain) {
        this.isMain = isMain;
    }
    
    public LocalDateTime getCreateTime() {
        return createTime;
    }
    
    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
    
    public LocalDateTime getUpdateTime() {
        return updateTime;
    }
    
    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }
    
    public CulturalRelic getRelic() {
        return relic;
    }
    
    public void setRelic(CulturalRelic relic) {
        this.relic = relic;
    }
    
    public ImageLibrary getImage() {
        return image;
    }
    
    public void setImage(ImageLibrary image) {
        this.image = image;
    }
    
    @Override
    public String toString() {
        return "RelicImageRelation{" +
                "id=" + id +
                ", relicId=" + relicId +
                ", imageId=" + imageId +
                ", relationType='" + relationType + '\'' +
                ", isMain=" + isMain +
                ", sortOrder=" + sortOrder +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}
