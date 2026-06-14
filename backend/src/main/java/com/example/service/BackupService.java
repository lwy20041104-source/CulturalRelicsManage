package com.example.service;

import com.example.common.PageResult;
import com.example.entity.SysBackup;
import com.example.entity.SysBackupConfig;
import com.example.entity.SysRestore;

import java.io.File;

/**
 * 备份恢复服务接口
 */
public interface BackupService {

    /**
     * 分页查询备份列表
     */
    PageResult<SysBackup> getBackupList(Integer pageNum, Integer pageSize, String backupType, String backupStatus);

    /**
     * 创建手动备份
     */
    SysBackup createManualBackup(String backupName, String description, Boolean isEncrypted, String createdBy);

    /**
     * 创建自动备份
     */
    SysBackup createAutoBackup(String backupName, String description, Boolean isEncrypted, String createdBy);

    /**
     * 删除备份
     */
    void deleteBackup(Long id);

    /**
     * 下载备份文件
     */
    File downloadBackup(Long id) throws Exception;

    /**
     * 恢复数据库
     */
    SysRestore restoreDatabase(Long backupId, String createdBy);

    /**
     * 获取备份配置
     */
    SysBackupConfig getBackupConfig();

    /**
     * 更新备份配置
     */
    void updateBackupConfig(SysBackupConfig config);

    /**
     * 清理过期备份
     */
    void cleanExpiredBackups();
}
