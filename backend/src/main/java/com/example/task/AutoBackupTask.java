package com.example.task;

import com.example.entity.SysBackup;
import com.example.entity.SysBackupConfig;
import com.example.service.BackupService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * 自动备份定时任务
 * 根据备份配置自动执行数据库备份
 */
@Slf4j
@Component
public class AutoBackupTask {

    @Autowired
    private BackupService backupService;

    /**
     * 每小时检查一次是否需要执行自动备份
     * 根据配置的备份频率和时间执行备份
     */
    @Scheduled(cron = "0 0 * * * ?")  // 每小时整点执行
    public void checkAndExecuteAutoBackup() {
        try {
            log.info("开始检查自动备份任务...");
            
            // 获取备份配置
            SysBackupConfig config = backupService.getBackupConfig();
            
            // 检查是否启用自动备份
            if (config == null || !config.getIsEnabled()) {
                log.info("自动备份未启用，跳过");
                return;
            }
            
            // 检查是否到达备份时间
            if (!isBackupTime(config)) {
                log.info("未到达备份时间，跳过");
                return;
            }
            
            // 检查是否需要执行备份（根据频率）
            if (!shouldBackupToday(config)) {
                log.info("根据备份频率，今天不需要备份，跳过");
                return;
            }
            
            log.info("开始执行自动备份...");
            
            // 生成备份名称
            String backupName = generateAutoBackupName(config.getBackupFrequency());
            String description = String.format("自动备份 - %s", config.getBackupFrequency());
            
            // 执行自动备份
            SysBackup backup = backupService.createAutoBackup(
                backupName,
                description,
                config.getIsEncrypted(),
                "系统"
            );
            
            log.info("自动备份任务已创建: id={}, name={}", backup.getId(), backup.getBackupName());
            
            // 清理过期备份
            if (config.getRetentionDays() != null && config.getRetentionDays() > 0) {
                log.info("开始清理过期备份...");
                backupService.cleanExpiredBackups();
            }
            
        } catch (Exception e) {
            log.error("自动备份任务执行失败", e);
        }
    }

    /**
     * 检查当前时间是否为配置的备份时间
     */
    private boolean isBackupTime(SysBackupConfig config) {
        if (config.getBackupTime() == null || config.getBackupTime().isEmpty()) {
            return false;
        }
        
        try {
            // 解析配置的备份时间（格式：HH:mm）
            LocalTime configTime = LocalTime.parse(config.getBackupTime(), DateTimeFormatter.ofPattern("HH:mm"));
            LocalTime currentTime = LocalTime.now();
            
            // 检查当前小时是否匹配
            return currentTime.getHour() == configTime.getHour();
        } catch (Exception e) {
            log.error("解析备份时间失败: {}", config.getBackupTime(), e);
            return false;
        }
    }

    /**
     * 根据备份频率判断今天是否需要备份
     */
    private boolean shouldBackupToday(SysBackupConfig config) {
        String frequency = config.getBackupFrequency();
        if (frequency == null || frequency.isEmpty()) {
            return false;
        }
        
        LocalDateTime now = LocalDateTime.now();
        int dayOfWeek = now.getDayOfWeek().getValue(); // 1=Monday, 7=Sunday
        int dayOfMonth = now.getDayOfMonth();
        
        switch (frequency.toLowerCase()) {
            case "daily":
                // 每天都备份
                return true;
                
            case "weekly":
                // 每周一备份
                return dayOfWeek == 1;
                
            case "monthly":
                // 每月1号备份
                return dayOfMonth == 1;
                
            case "hourly":
                // 每小时都备份（不推荐，仅用于测试）
                return true;
                
            default:
                log.warn("未知的备份频率: {}", frequency);
                return false;
        }
    }

    /**
     * 生成自动备份名称
     */
    private String generateAutoBackupName(String frequency) {
        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        
        String frequencyText;
        switch (frequency.toLowerCase()) {
            case "daily":
                frequencyText = "每日";
                break;
            case "weekly":
                frequencyText = "每周";
                break;
            case "monthly":
                frequencyText = "每月";
                break;
            case "hourly":
                frequencyText = "每小时";
                break;
            default:
                frequencyText = frequency;
        }
        
        return String.format("%s自动备份 - %s", frequencyText, now.format(formatter));
    }

    /**
     * 手动触发自动备份（用于测试）
     * 可以通过管理接口调用
     */
    public void triggerManualAutoBackup() {
        log.info("手动触发自动备份任务");
        checkAndExecuteAutoBackup();
    }
}
