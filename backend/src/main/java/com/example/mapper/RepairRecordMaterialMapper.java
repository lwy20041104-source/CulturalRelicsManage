package com.example.mapper;

import com.example.entity.RepairRecordMaterial;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 修复记录材料关联Mapper
 */
@Mapper
public interface RepairRecordMaterialMapper {
    
    /**
     * 根据修复记录ID查询材料列表
     */
    @Select("SELECT rrm.*, rm.material_name, rm.material_code, rm.unit " +
            "FROM repair_record_material rrm " +
            "LEFT JOIN repair_material rm ON rrm.material_id = rm.id " +
            "WHERE rrm.repair_record_id = #{repairRecordId} " +
            "ORDER BY rrm.create_time")
    List<RepairRecordMaterial> selectByRepairRecordId(Long repairRecordId);
    
    /**
     * 根据材料ID查询使用记录
     */
    @Select("SELECT rrm.*, rr.repair_code " +
            "FROM repair_record_material rrm " +
            "LEFT JOIN repair_record rr ON rrm.repair_record_id = rr.id " +
            "WHERE rrm.material_id = #{materialId} " +
            "ORDER BY rrm.create_time DESC")
    List<RepairRecordMaterial> selectByMaterialId(Long materialId);
    
    /**
     * 插入材料使用记录
     */
    @Insert("INSERT INTO repair_record_material (repair_record_id, material_id, quantity, " +
            "unit_price, total_price, remark, create_time) " +
            "VALUES (#{repairRecordId}, #{materialId}, #{quantity}, " +
            "#{unitPrice}, #{totalPrice}, #{remark}, NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(RepairRecordMaterial recordMaterial);
    
    /**
     * 更新材料使用记录
     */
    @Update("UPDATE repair_record_material SET " +
            "quantity = #{quantity}, " +
            "unit_price = #{unitPrice}, " +
            "total_price = #{totalPrice}, " +
            "remark = #{remark} " +
            "WHERE id = #{id}")
    int updateById(RepairRecordMaterial recordMaterial);
    
    /**
     * 删除材料使用记录
     */
    @Delete("DELETE FROM repair_record_material WHERE id = #{id}")
    int deleteById(Long id);
    
    /**
     * 删除修复记录的所有材料
     */
    @Delete("DELETE FROM repair_record_material WHERE repair_record_id = #{repairRecordId}")
    int deleteByRepairRecordId(Long repairRecordId);
    
    /**
     * 统计材料使用总量
     */
    @Select("SELECT COALESCE(SUM(quantity), 0) FROM repair_record_material WHERE material_id = #{materialId}")
    double sumQuantityByMaterialId(Long materialId);
    
    /**
     * 统计材料使用总金额
     */
    @Select("SELECT COALESCE(SUM(total_price), 0) FROM repair_record_material WHERE material_id = #{materialId}")
    double sumTotalPriceByMaterialId(Long materialId);
}
