package com.example.service;

import com.example.common.PageResult;
import com.example.entity.RepairMaterial;
import com.example.entity.RepairRecordMaterial;

import java.util.List;
import java.util.Map;

/**
 * 修复材料服务接口
 */
public interface RepairMaterialService {

    /**
     * 分页查询材料列表
     */
    PageResult<RepairMaterial> getMaterialList(Integer pageNum, Integer pageSize,
                                               String materialName, String category);

    /**
     * 获取所有材料（用于下拉选择）
     */
    List<RepairMaterial> getAllMaterials();

    /**
     * 根据ID查询材料
     */
    RepairMaterial getMaterialById(Long id);

    /**
     * 创建材料
     */
    RepairMaterial createMaterial(RepairMaterial material);

    /**
     * 更新材料
     */
    void updateMaterial(RepairMaterial material);

    /**
     * 删除材料
     */
    void deleteMaterial(Long id);

    /**
     * 更新库存
     */
    void updateStock(Long id, double quantity);

    /**
     * 获取材料类别列表
     */
    List<String> getCategories();

    /**
     * 获取库存不足的材料
     */
    List<RepairMaterial> getLowStockMaterials(double threshold);

    /**
     * 获取材料使用统计
     */
    Map<String, Object> getMaterialStatistics(Long materialId);

    /**
     * 添加材料使用记录
     */
    RepairRecordMaterial addMaterialUsage(RepairRecordMaterial recordMaterial);

    /**
     * 获取修复记录的材料列表
     */
    List<RepairRecordMaterial> getRepairRecordMaterials(Long repairRecordId);

    /**
     * 删除材料使用记录
     */
    void deleteMaterialUsage(Long id);
}
