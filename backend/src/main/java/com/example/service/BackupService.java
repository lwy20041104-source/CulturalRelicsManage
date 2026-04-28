package com.example.service;

import com.example.common.PageResult;
import com.example.entity.SysBackup;
import com.example.entity.SysBackupConfig;
import com.example.entity.SysRestore;
import com.example.mapper.SysBackupConfigMapper;
import com.example.mapper.SysBackupMapper;
import com.example.mapper.SysRestoreMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 备份恢复服务
 */
@Slf4j
@Service
public class BackupService {
    
    @Autowired
    private SysBackupMapper backupMapper;
    
    @Autowired
    private SysBackupConfigMapper configMapper;
    
    @Autowired
    private SysRestoreMapper restoreMapper;
    
    @Value("${spring.datasource.url}")
    private String dbUrl;
    
    @Value("${spring.datasource.username}")
    private String dbUsername;
    
    @Value("${spring.datasource.password}")
    private String dbPassword;
    
    // 备份文件存储路径
    private static final String BACKUP_DIR = "backups";
    
    // AES加密密钥（实际应用中应该从配置文件或密钥管理系统获取）
    private static final String AES_KEY = "CulturalRelicsBackupKey2026";
    
    /**
     * 分页查询备份列表
     */
    public PageResult<SysBackup> getBackupList(Integer pageNum, Integer pageSize, String backupType, String backupStatus) {
        int offset = (pageNum - 1) * pageSize;
        
        List<SysBackup> records = backupMapper.selectList(backupType, backupStatus, offset, pageSize);
        long total = backupMapper.countList(backupType, backupStatus);
        
        return new PageResult<>(records, total, pageNum, pageSize);
    }
    
    /**
     * 创建手动备份
     */
    @Transactional
    public SysBackup createManualBackup(String backupName, String description, Boolean isEncrypted, String createdBy) {
        SysBackup backup = new SysBackup();
        backup.setBackupName(backupName);
        backup.setBackupType("manual");
        backup.setBackupStatus("processing");
        backup.setDescription(description);
        backup.setIsEncrypted(isEncrypted != null && isEncrypted);
        backup.setCreatedBy(createdBy);
        backup.setCreatedTime(LocalDateTime.now());
        
        // 生成备份文件名
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String fileName = "backup_" + timestamp + ".sql";
        backup.setFileName(fileName);
        
        // 保存备份记录
        backupMapper.insert(backup);
        
        // 异步执行备份
        executeBackup(backup);
        
        return backup;
    }
    
    /**
     * 执行备份
     */
    private void executeBackup(SysBackup backup) {
        new Thread(() -> {
            try {
                // 创建备份目录
                Path backupPath = Paths.get(BACKUP_DIR);
                if (!Files.exists(backupPath)) {
                    Files.createDirectories(backupPath);
                }
                
                // 备份文件完整路径
                String filePath = BACKUP_DIR + File.separator + backup.getFileName();
                backup.setFilePath(filePath);
                
                // 从数据库URL中提取数据库名
                String dbName = extractDatabaseName(dbUrl);
                
                // 执行mysqldump命令
                String command = String.format(
                    "mysqldump -u%s -p%s --databases %s --result-file=%s",
                    dbUsername, dbPassword, dbName, filePath
                );
                
                Process process = Runtime.getRuntime().exec(command);
                int exitCode = process.waitFor();
                
                if (exitCode == 0) {
                    // 备份成功
                    File file = new File(filePath);
                    backup.setFileSize(file.length());
                    
                    // 如果需要加密
                    if (backup.getIsEncrypted()) {
                        encryptFile(filePath);
                    }
                    
                    backup.setBackupStatus("success");
                    log.info("备份成功: {}", backup.getFileName());
                } else {
                    // 备份失败
                    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
                    StringBuilder errorMsg = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        errorMsg.append(line).append("\n");
                    }
                    backup.setBackupStatus("failed");
                    backup.setErrorMessage(errorMsg.toString());
                    log.error("备份失败: {}", errorMsg);
                }
            } catch (Exception e) {
                backup.setBackupStatus("failed");
                backup.setErrorMessage(e.getMessage());
                log.error("备份异常", e);
            } finally {
                // 更新备份记录
                backupMapper.updateById(backup);
            }
        }).start();
    }
    
    /**
     * 从数据库URL中提取数据库名
     */
    private String extractDatabaseName(String url) {
        // jdbc:mysql://localhost:3306/cultural_relics?...
        int lastSlash = url.lastIndexOf('/');
        int questionMark = url.indexOf('?', lastSlash);
        if (questionMark > 0) {
            return url.substring(lastSlash + 1, questionMark);
        }
        return url.substring(lastSlash + 1);
    }
    
    /**
     * 加密文件
     */
    private void encryptFile(String filePath) throws Exception {
        File file = new File(filePath);
        byte[] fileContent = Files.readAllBytes(file.toPath());
        
        // 使用AES加密
        SecretKeySpec secretKey = new SecretKeySpec(AES_KEY.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.ENCRYPT_MODE, secretKey);
        byte[] encryptedContent = cipher.doFinal(fileContent);
        
        // 写入加密后的内容
        Files.write(file.toPath(), encryptedContent);
    }
    
    /**
     * 解密文件
     */
    private void decryptFile(String filePath) throws Exception {
        File file = new File(filePath);
        byte[] encryptedContent = Files.readAllBytes(file.toPath());
        
        // 使用AES解密
        SecretKeySpec secretKey = new SecretKeySpec(AES_KEY.getBytes(), "AES");
        Cipher cipher = Cipher.getInstance("AES");
        cipher.init(Cipher.DECRYPT_MODE, secretKey);
        byte[] decryptedContent = cipher.doFinal(encryptedContent);
        
        // 写入解密后的内容
        Files.write(file.toPath(), decryptedContent);
    }
    
    /**
     * 删除备份
     */
    @Transactional
    public void deleteBackup(Long id) {
        SysBackup backup = backupMapper.selectById(id);
        if (backup != null) {
            // 删除文件
            File file = new File(backup.getFilePath());
            if (file.exists()) {
                file.delete();
            }
            // 删除记录
            backupMapper.deleteById(id);
        }
    }
    
    /**
     * 下载备份文件
     */
    public File downloadBackup(Long id) throws Exception {
        SysBackup backup = backupMapper.selectById(id);
        if (backup == null) {
            throw new RuntimeException("备份记录不存在");
        }
        
        File file = new File(backup.getFilePath());
        if (!file.exists()) {
            throw new RuntimeException("备份文件不存在");
        }
        
        // 如果文件已加密，先解密到临时文件
        if (backup.getIsEncrypted()) {
            String tempFilePath = backup.getFilePath() + ".temp";
            Files.copy(file.toPath(), Paths.get(tempFilePath));
            decryptFile(tempFilePath);
            return new File(tempFilePath);
        }
        
        return file;
    }
    
    /**
     * 恢复数据库
     */
    @Transactional
    public SysRestore restoreDatabase(Long backupId, String createdBy) {
        SysBackup backup = backupMapper.selectById(backupId);
        if (backup == null) {
            throw new RuntimeException("备份记录不存在");
        }
        
        if (!"success".equals(backup.getBackupStatus())) {
            throw new RuntimeException("只能恢复成功的备份");
        }
        
        // 创建恢复记录
        SysRestore restore = new SysRestore();
        restore.setBackupId(backupId);
        restore.setRestoreStatus("processing");
        restore.setRestoreType("full");
        restore.setCreatedBy(createdBy);
        restore.setCreatedTime(LocalDateTime.now());
        restoreMapper.insert(restore);
        
        // 异步执行恢复
        executeRestore(restore, backup);
        
        return restore;
    }
    
    /**
     * 执行恢复
     */
    private void executeRestore(SysRestore restore, SysBackup backup) {
        new Thread(() -> {
            String tempFilePath = null;
            try {
                String filePath = backup.getFilePath();
                
                // 如果文件已加密，先解密
                if (backup.getIsEncrypted()) {
                    tempFilePath = filePath + ".restore_temp";
                    Files.copy(Paths.get(filePath), Paths.get(tempFilePath));
                    decryptFile(tempFilePath);
                    filePath = tempFilePath;
                }
                
                // 从数据库URL中提取数据库名
                String dbName = extractDatabaseName(dbUrl);
                
                // 执行mysql命令恢复数据库
                String command = String.format(
                    "mysql -u%s -p%s %s < %s",
                    dbUsername, dbPassword, dbName, filePath
                );
                
                Process process = Runtime.getRuntime().exec(new String[]{"sh", "-c", command});
                int exitCode = process.waitFor();
                
                if (exitCode == 0) {
                    restore.setRestoreStatus("success");
                    restore.setCompletedTime(LocalDateTime.now());
                    log.info("恢复成功: backup_id={}", backup.getId());
                } else {
                    BufferedReader reader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
                    StringBuilder errorMsg = new StringBuilder();
                    String line;
                    while ((line = reader.readLine()) != null) {
                        errorMsg.append(line).append("\n");
                    }
                    restore.setRestoreStatus("failed");
                    restore.setErrorMessage(errorMsg.toString());
                    log.error("恢复失败: {}", errorMsg);
                }
            } catch (Exception e) {
                restore.setRestoreStatus("failed");
                restore.setErrorMessage(e.getMessage());
                log.error("恢复异常", e);
            } finally {
                // 删除临时文件
                if (tempFilePath != null) {
                    new File(tempFilePath).delete();
                }
                // 更新恢复记录
                restoreMapper.updateById(restore);
            }
        }).start();
    }
    
    /**
     * 获取备份配置
     */
    public SysBackupConfig getBackupConfig() {
        List<SysBackupConfig> configs = configMapper.selectAll();
        if (configs.isEmpty()) {
            // 返回默认配置
            SysBackupConfig config = new SysBackupConfig();
            config.setConfigName("默认配置");
            config.setIsEnabled(true);
            config.setBackupFrequency("daily");
            config.setBackupTime("02:00");
            config.setRetentionDays(30);
            config.setMaxBackupCount(10);
            config.setIsEncrypted(false);
            config.setNotificationEnabled(true);
            return config;
        }
        return configs.get(0);
    }
    
    /**
     * 更新备份配置
     */
    @Transactional
    public void updateBackupConfig(SysBackupConfig config) {
        if (config.getId() == null) {
            config.setCreatedTime(LocalDateTime.now());
            configMapper.insert(config);
        } else {
            configMapper.updateById(config);
        }
    }
    
    /**
     * 清理过期备份
     */
    @Transactional
    public void cleanExpiredBackups() {
        SysBackupConfig config = getBackupConfig();
        if (config.getRetentionDays() == null || config.getRetentionDays() <= 0) {
            return;
        }
        
        LocalDateTime expireTime = LocalDateTime.now().minusDays(config.getRetentionDays());
        String expireTimeStr = expireTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        List<SysBackup> expiredBackups = backupMapper.selectExpiredBackups(expireTimeStr);
        for (SysBackup backup : expiredBackups) {
            deleteBackup(backup.getId());
        }
        
        log.info("清理过期备份: 删除{}个备份", expiredBackups.size());
    }
}
