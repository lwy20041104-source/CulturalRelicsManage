package com.example.service;

import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

/**
 * 3D文物模型管理服务
 */
public interface Relic3DService {

    /**
     * 上传3D模型文件
     * @param relicId 文物ID
     * @param file 模型文件
     * @return 包含modelUrl和relicId的结果Map
     */
    Map<String, Object> upload3DModel(Long relicId, MultipartFile file);

    /**
     * 删除3D模型文件
     * @param relicId 文物ID
     * @param filename 文件名
     */
    void delete3DModelFile(Long relicId, String filename);

    /**
     * 获取3D模型信息
     * @param relicId 文物ID
     * @return 包含modelUrl、hasModel等信息的Map
     */
    Map<String, Object> get3DModelInfo(Long relicId);

    /**
     * 保存3D模型链接
     * @param relicId 文物ID
     * @param modelUrl 模型链接
     * @return 包含modelUrl和relicId的结果Map
     */
    Map<String, Object> save3DModelUrl(Long relicId, String modelUrl);

    /**
     * 智能删除3D模型（支持文件和链接）
     * @param relicId 文物ID
     */
    void delete3DModelUrl(Long relicId);

    /**
     * 获取上传路径
     */
    String getUploadPath();

    /**
     * 获取URL前缀
     */
    String getUrlPrefix();
}
