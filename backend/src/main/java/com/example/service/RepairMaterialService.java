package com.example.service;

import com.example.common.PageResult;
import com.example.entity.RepairMaterial;
import com.example.entity.RepairRecordMaterial;
import com.example.mapper.RepairMaterialMapper;
import com.example.mapper.RepairRecordMaterialMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 修复材料服务
 */
@Slf4j
@Service
public class RepairMaterialService {
    
    @Autowired
    private RepairMaterialMapper materialMapper;
    
    @Autowired
    private RepairRecordMaterialMapper recordMaterialMapper;
    
    /**
     * 分页查询材料列表
     */
    public PageResult<RepairMaterial> getMaterialList(Integer pageNum, Integer pageSize, 
                                                      String materialName, String category) {
        int offset = (pageNum - 1) * pageSize;
        
        List<RepairMaterial> records = materialMapper.selectList(materialName, category, offset, pageSize);
        long total = materialMapper.countList(materialName, category);
        
        return new PageResult<>(records, total, pageNum, pageSize);
    }
    
    /**
     * 获取所有材料（用于下拉选择）
     */
    public List<RepairMaterial> getAllMaterials() {
        return materialMapper.selectAll();
    }
    
    /**
     * 根据ID查询材料
     */
    public RepairMaterial getMaterialById(Long id) {
        return materialMapper.selectById(id);
    }
    
    /**
     * 创建材料
     */
    @Transactional
    public RepairMaterial createMaterial(RepairMaterial material) {
        // 检查材料编号是否重复
        if (material.getMaterialCode() != null && !material.getMaterialCode().isEmpty()) {
            RepairMaterial existing = materialMapper.selectByCode(material.getMaterialCode());
            if (existing != null) {
                throw new RuntimeException("材料编号已存在");
            }
        }
        
        // 设置默认值
        if (material.getStockQuantity() == null) {
            material.setStockQuantity(BigDecimal.ZERO);
        }
        
        materialMapper.insert(material);
        return material;
    }
    
    /**
     * 更新材料
     */
    @Transactional
    public void updateMaterial(RepairMaterial material) {
        RepairMaterial existing = materialMapper.selectById(material.getId());
        if (existing == null) {
            throw new RuntimeException("材料不存在");
        }
        
        // 检查材料编号是否重复（排除自己）
        if (material.getMaterialCode() != null && !material.getMaterialCode().isEmpty()) {
            RepairMaterial duplicate = materialMapper.selectByCode(material.getMaterialCode());
            if (duplicate != null && !duplicate.getId().equals(material.getId())) {
                throw new RuntimeException("材料编号已存在");
            }
        }
        
        materialMapper.updateById(material);
    }
    
    /**
     * 删除材料
     */
    @Transactional
    public void deleteMaterial(Long id) {
        // 检查是否有使用记录
        List<RepairRecordMaterial> usageRecords = recordMaterialMapper.selectByMaterialId(id);
        if (!usageRecords.isEmpty()) {
            throw new RuntimeException("该材料已被使用，无法删除");
        }
        
        materialMapper.deleteById(id);
    }
    
    /**
     * 更新库存
     */
    @Transactional
    public void updateStock(Long id, double quantity) {
        RepairMaterial material = materialMapper.selectById(id);
        if (material == null) {
            throw new RuntimeException("材料不存在");
        }
        
        // 检查库存是否足够（如果是减少库存）
        if (quantity < 0) {
            double newStock = material.getStockQuantity().doubleValue() + quantity;
            if (newStock < 0) {
                throw new RuntimeException("库存不足");
            }
        }
        
        materialMapper.updateStock(id, quantity);
    }
    
    /**
     * 获取材料类别列表
     */
    public List<String> getCategories() {
        return materialMapper.selectCategories();
    }
    
    /**
     * 获取库存不足的材料
     */
    public List<RepairMaterial> getLowStockMaterials(double threshold) {
        return materialMapper.selectLowStock(threshold);
    }
    
    /**
     * 获取材料使用统计
     */
    public Map<String, Object> getMaterialStatistics(Long materialId) {
        Map<String, Object> stats = new HashMap<>();
        
        RepairMaterial material = materialMapper.selectById(materialId);
        if (material == null) {
            throw new RuntimeException("材料不存在");
        }
        
        // 使用总量
        double totalQuantity = recordMaterialMapper.sumQuantityByMaterialId(materialId);
        // 使用总金额
        double totalAmount = recordMaterialMapper.sumTotalPriceByMaterialId(materialId);
        // 使用记录数
        List<RepairRecordMaterial> usageRecords = recordMaterialMapper.selectByMaterialId(materialId);
        
        stats.put("material", material);
        stats.put("totalQuantity", totalQuantity);
        stats.put("totalAmount", totalAmount);
        stats.put("usageCount", usageRecords.size());
        stats.put("usageRecords", usageRecords);
        
        return stats;
    }
    
    /**
     * 添加材料使用记录
     */
    @Transactional
    public RepairRecordMaterial addMaterialUsage(RepairRecordMaterial recordMaterial) {
        // 检查材料是否存在
        RepairMaterial material = materialMapper.selectById(recordMaterial.getMaterialId());
        if (material == null) {
            throw new RuntimeException("材料不存在");
        }
        
        // 检查库存是否足够
        if (material.getStockQuantity().doubleValue() < recordMaterial.getQuantity().doubleValue()) {
            throw new RuntimeException("材料库存不足");
        }
        
        // 计算总价
        BigDecimal totalPrice = recordMaterial.getUnitPrice()
                .multiply(recordMaterial.getQuantity());
        recordMaterial.setTotalPrice(totalPrice);
        
        // 插入使用记录
        recordMaterialMapper.insert(recordMaterial);
        
        // 减少库存
        materialMapper.updateStock(recordMaterial.getMaterialId(), 
                -recordMaterial.getQuantity().doubleValue());
        
        return recordMaterial;
    }
    
    /**
     * 获取修复记录的材料列表
     */
    public List<RepairRecordMaterial> getRepairRecordMaterials(Long repairRecordId) {
        return recordMaterialMapper.selectByRepairRecordId(repairRecordId);
    }
    
    /**
     * 删除材料使用记录
     */
    @Transactional
    public void deleteMaterialUsage(Long id) {
        RepairRecordMaterial recordMaterial = recordMaterialMapper.selectByRepairRecordId(id)
                .stream()
                .filter(rm -> rm.getId().equals(id))
                .findFirst()
                .orElse(null);
        
        if (recordMaterial == null) {
            throw new RuntimeException("使用记录不存在");
        }
        
        // 恢复库存
        materialMapper.updateStock(recordMaterial.getMaterialId(), 
                recordMaterial.getQuantity().doubleValue());
        
        // 删除记录
        recordMaterialMapper.deleteById(id);
    }
}
