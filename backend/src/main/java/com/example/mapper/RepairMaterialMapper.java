package com.example.mapper;

import com.example.entity.RepairMaterial;
import org.apache.ibatis.annotations.*;

import java.util.List;

/**
 * 修复材料Mapper
 */
@Mapper
public interface RepairMaterialMapper {
    
    /**
     * 分页查询材料列表
     */
    @Select("<script>" +
            "SELECT * FROM repair_material " +
            "WHERE 1=1 " +
            "<if test='materialName != null and materialName != \"\"'>" +
            "AND material_name LIKE CONCAT('%', #{materialName}, '%') " +
            "</if>" +
            "<if test='category != null and category != \"\"'>" +
            "AND category = #{category} " +
            "</if>" +
            "ORDER BY create_time DESC " +
            "LIMIT #{offset}, #{limit}" +
            "</script>")
    List<RepairMaterial> selectList(@Param("materialName") String materialName,
                                    @Param("category") String category,
                                    @Param("offset") int offset,
                                    @Param("limit") int limit);
    
    /**
     * 统计材料数量
     */
    @Select("<script>" +
            "SELECT COUNT(*) FROM repair_material " +
            "WHERE 1=1 " +
            "<if test='materialName != null and materialName != \"\"'>" +
            "AND material_name LIKE CONCAT('%', #{materialName}, '%') " +
            "</if>" +
            "<if test='category != null and category != \"\"'>" +
            "AND category = #{category} " +
            "</if>" +
            "</script>")
    long countList(@Param("materialName") String materialName,
                   @Param("category") String category);
    
    /**
     * 根据ID查询
     */
    @Select("SELECT * FROM repair_material WHERE id = #{id}")
    RepairMaterial selectById(Long id);
    
    /**
     * 根据材料编号查询
     */
    @Select("SELECT * FROM repair_material WHERE material_code = #{materialCode}")
    RepairMaterial selectByCode(String materialCode);
    
    /**
     * 查询所有材料（用于下拉选择）
     */
    @Select("SELECT * FROM repair_material ORDER BY material_name")
    List<RepairMaterial> selectAll();
    
    /**
     * 查询库存不足的材料
     */
    @Select("SELECT * FROM repair_material WHERE stock_quantity < #{threshold} ORDER BY stock_quantity")
    List<RepairMaterial> selectLowStock(@Param("threshold") double threshold);
    
    /**
     * 插入材料
     */
    @Insert("INSERT INTO repair_material (material_name, material_code, category, unit, " +
            "unit_price, stock_quantity, supplier, remark, create_time, update_time) " +
            "VALUES (#{materialName}, #{materialCode}, #{category}, #{unit}, " +
            "#{unitPrice}, #{stockQuantity}, #{supplier}, #{remark}, NOW(), NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(RepairMaterial material);
    
    /**
     * 更新材料
     */
    @Update("UPDATE repair_material SET " +
            "material_name = #{materialName}, " +
            "material_code = #{materialCode}, " +
            "category = #{category}, " +
            "unit = #{unit}, " +
            "unit_price = #{unitPrice}, " +
            "stock_quantity = #{stockQuantity}, " +
            "supplier = #{supplier}, " +
            "remark = #{remark}, " +
            "update_time = NOW() " +
            "WHERE id = #{id}")
    int updateById(RepairMaterial material);
    
    /**
     * 更新库存数量
     */
    @Update("UPDATE repair_material SET " +
            "stock_quantity = stock_quantity + #{quantity}, " +
            "update_time = NOW() " +
            "WHERE id = #{id}")
    int updateStock(@Param("id") Long id, @Param("quantity") double quantity);
    
    /**
     * 删除材料
     */
    @Delete("DELETE FROM repair_material WHERE id = #{id}")
    int deleteById(Long id);
    
    /**
     * 获取材料类别列表
     */
    @Select("SELECT DISTINCT category FROM repair_material WHERE category IS NOT NULL ORDER BY category")
    List<String> selectCategories();
}
