package com.example.mapper;

import com.example.entity.RepairRecordMaterial;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

/**
 * 修复记录材料关联Mapper
 */
@Mapper
public interface RepairRecordMaterialMapper {

    /**
     * 根据修复记录ID查询材料列表
     */
    List<RepairRecordMaterial> selectByRepairRecordId(Long repairRecordId);

    /**
     * 根据材料ID查询使用记录
     */
    List<RepairRecordMaterial> selectByMaterialId(Long materialId);

    /**
     * 插入材料使用记录
     */
    int insert(RepairRecordMaterial recordMaterial);

    /**
     * 更新材料使用记录
     */
    int updateById(RepairRecordMaterial recordMaterial);

    /**
     * 删除材料使用记录
     */
    int deleteById(Long id);

    /**
     * 删除修复记录的所有材料
     */
    int deleteByRepairRecordId(Long repairRecordId);

    /**
     * 统计材料使用总量
     */
    double sumQuantityByMaterialId(Long materialId);

    /**
     * 统计材料使用总金额
     */
    double sumTotalPriceByMaterialId(Long materialId);
}
