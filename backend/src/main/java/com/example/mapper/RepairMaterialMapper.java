package com.example.mapper;

import com.example.entity.RepairMaterial;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 修复材料Mapper
 */
@Mapper
public interface RepairMaterialMapper {

    /**
     * 分页查询材料列表
     */
    List<RepairMaterial> selectList(@Param("materialName") String materialName,
                                    @Param("category") String category,
                                    @Param("offset") int offset,
                                    @Param("limit") int limit);

    /**
     * 统计材料数量
     */
    long countList(@Param("materialName") String materialName,
                   @Param("category") String category);

    /**
     * 根据ID查询
     */
    RepairMaterial selectById(Long id);

    /**
     * 根据材料编号查询
     */
    RepairMaterial selectByCode(String materialCode);

    /**
     * 查询所有材料（用于下拉选择）
     */
    List<RepairMaterial> selectAll();

    /**
     * 查询库存不足的材料
     */
    List<RepairMaterial> selectLowStock(@Param("threshold") double threshold);

    /**
     * 插入材料
     */
    int insert(RepairMaterial material);

    /**
     * 更新材料
     */
    int updateById(RepairMaterial material);

    /**
     * 更新库存数量
     */
    int updateStock(@Param("id") Long id, @Param("quantity") double quantity);

    /**
     * 删除材料
     */
    int deleteById(Long id);

    /**
     * 获取材料类别列表
     */
    List<String> selectCategories();
}
