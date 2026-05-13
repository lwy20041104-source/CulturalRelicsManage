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
import java.sql.Connection;
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
    
    @Autowired
    private DatabaseBackupUtil databaseBackupUtil;
    
    @Autowired
    private javax.sql.DataSource dataSource;
    
    @Value("${spring.datasource.url}")
    private String dbUrl;
    
    @Value("${spring.datasource.username}")
    private String dbUsername;
    
    @Value("${spring.datasource.password}")
    private String dbPassword;
    
    // 备份文件存储路径
    private static final String BACKUP_DIR = "backups";
    
    // AES加密密钥（实际应用中应该从配置文件或密钥管理系统获取）
    // 使用16字节密钥（128位AES），兼容所有Java版本
    private static final String AES_KEY = "CulturalRelics!"; // 16字节
    
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
        return createBackup(backupName, "manual", description, isEncrypted, createdBy);
    }

    /**
     * 创建自动备份
     */
    @Transactional
    public SysBackup createAutoBackup(String backupName, String description, Boolean isEncrypted, String createdBy) {
        return createBackup(backupName, "auto", description, isEncrypted, createdBy);
    }

    /**
     * 创建备份（通用方法）
     */
    @Transactional
    private SysBackup createBackup(String backupName, String backupType, String description, Boolean isEncrypted, String createdBy) {
        SysBackup backup = new SysBackup();
        backup.setBackupName(backupName);
        backup.setBackupType(backupType);
        backup.setBackupStatus("processing");
        backup.setDescription(description);
        backup.setIsEncrypted(isEncrypted != null && isEncrypted);
        backup.setCreatedBy(createdBy);
        backup.setCreatedTime(LocalDateTime.now());
        
        // 生成备份文件名
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
        String fileName = "backup_" + timestamp + ".sql";
        backup.setFileName(fileName);
        
        // 设置文件路径（在插入数据库前设置，避免 file_path 为 null）
        String filePath = BACKUP_DIR + File.separator + fileName;
        backup.setFilePath(filePath);
        
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
                log.info("开始执行备份: {}", backup.getFileName());
                
                // 创建备份目录
                Path backupPath = Paths.get(BACKUP_DIR);
                if (!Files.exists(backupPath)) {
                    Files.createDirectories(backupPath);
                    log.info("创建备份目录: {}", backupPath.toAbsolutePath());
                }
                
                // 使用已设置的文件路径
                String filePath = backup.getFilePath();
                log.info("备份文件路径: {}", filePath);
                
                // 从数据库URL中提取数据库名
                String dbName = extractDatabaseName(dbUrl);
                log.info("数据库名: {}", dbName);
                
                // 尝试使用 Java 原生方式备份
                boolean useNativeBackup = true; // 可以通过配置控制
                
                if (useNativeBackup) {
                    log.info("使用 Java 原生方式备份数据库");
                    executeNativeBackup(backup, filePath, dbName);
                } else {
                    log.info("使用 mysqldump 命令备份数据库");
                    executeMysqldumpBackup(backup, filePath, dbName);
                }
                
            } catch (Exception e) {
                backup.setBackupStatus("failed");
                backup.setErrorMessage(e.getMessage());
                log.error("备份异常", e);
            } finally {
                // 更新备份记录
                try {
                    backupMapper.updateById(backup);
                    log.info("备份记录已更新: id={}, status={}", backup.getId(), backup.getBackupStatus());
                } catch (Exception e) {
                    log.error("更新备份记录失败", e);
                }
            }
        }).start();
    }
    
    /**
     * 使用 Java 原生方式执行备份
     */
    private void executeNativeBackup(SysBackup backup, String filePath, String dbName) {
        try (Connection connection = dataSource.getConnection()) {
            // 使用 DatabaseBackupUtil 备份
            databaseBackupUtil.backupDatabase(connection, filePath, dbName);
            
            // 备份成功
            File file = new File(filePath);
            if (file.exists() && file.length() > 0) {
                backup.setFileSize(file.length());
                
                // 如果需要加密
                if (backup.getIsEncrypted()) {
                    log.info("开始加密备份文件");
                    encryptFile(filePath);
                    // 更新加密后的文件大小
                    backup.setFileSize(file.length());
                }
                
                backup.setBackupStatus("success");
                log.info("备份成功: {}, 文件大小: {} bytes", backup.getFileName(), backup.getFileSize());
            } else {
                backup.setBackupStatus("failed");
                backup.setErrorMessage("备份文件未创建或文件大小为0");
                log.error("备份失败: 备份文件未创建或文件大小为0");
            }
        } catch (Exception e) {
            backup.setBackupStatus("failed");
            backup.setErrorMessage("Java原生备份失败: " + e.getMessage());
            log.error("Java原生备份失败", e);
        }
    }
    
    /**
     * 使用 mysqldump 命令执行备份
     */
    private void executeMysqldumpBackup(SysBackup backup, String filePath, String dbName) {
        try {
            // 构建mysqldump命令
            // 注意：在Windows上需要使用不同的命令格式
            String os = System.getProperty("os.name").toLowerCase();
            Process process;
            
            if (os.contains("win")) {
                // Windows系统
                String command = String.format(
                    "mysqldump -u%s -p%s --databases %s --result-file=\"%s\"",
                    dbUsername, dbPassword, dbName, filePath
                );
                log.info("执行命令 (Windows): {}", command.replace(dbPassword, "****"));
                process = Runtime.getRuntime().exec(new String[]{"cmd", "/c", command});
            } else {
                // Linux/Unix系统
                String command = String.format(
                    "mysqldump -u%s -p%s --databases %s --result-file=%s",
                    dbUsername, dbPassword, dbName, filePath
                );
                log.info("执行命令 (Linux): {}", command.replace(dbPassword, "****"));
                process = Runtime.getRuntime().exec(new String[]{"sh", "-c", command});
            }
            
            // 读取标准输出
            BufferedReader stdReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
            StringBuilder stdOutput = new StringBuilder();
            String line;
            while ((line = stdReader.readLine()) != null) {
                stdOutput.append(line).append("\n");
            }
            
            // 读取错误输出
            BufferedReader errReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            StringBuilder errOutput = new StringBuilder();
            while ((line = errReader.readLine()) != null) {
                errOutput.append(line).append("\n");
            }
            
            int exitCode = process.waitFor();
            log.info("命令执行完成，退出码: {}", exitCode);
            
            if (stdOutput.length() > 0) {
                log.info("标准输出: {}", stdOutput);
            }
            if (errOutput.length() > 0) {
                log.warn("错误输出: {}", errOutput);
            }
            
            // 检查文件是否创建成功
            File file = new File(filePath);
            if (file.exists() && file.length() > 0) {
                // 备份成功
                backup.setFileSize(file.length());
                
                // 如果需要加密
                if (backup.getIsEncrypted()) {
                    log.info("开始加密备份文件");
                    encryptFile(filePath);
                    // 更新加密后的文件大小
                    backup.setFileSize(file.length());
                }
                
                backup.setBackupStatus("success");
                log.info("备份成功: {}, 文件大小: {} bytes", backup.getFileName(), backup.getFileSize());
            } else {
                // 备份失败
                String errorMsg = "备份文件未创建或文件大小为0";
                if (errOutput.length() > 0) {
                    errorMsg += "\n错误信息: " + errOutput.toString();
                }
                if (exitCode != 0) {
                    errorMsg += "\n退出码: " + exitCode;
                }
                backup.setBackupStatus("failed");
                backup.setErrorMessage(errorMsg);
                log.error("备份失败: {}", errorMsg);
            }
        } catch (Exception e) {
            backup.setBackupStatus("failed");
            backup.setErrorMessage("mysqldump备份失败: " + e.getMessage());
            log.error("mysqldump备份失败", e);
        }
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
     * 获取固定长度的AES密钥（16字节用于128位AES）
     */
    private byte[] getAESKey() {
        byte[] key = new byte[16]; // 16字节 = 128位（兼容所有Java版本）
        byte[] keyBytes = AES_KEY.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        
        // 如果密钥长度不足16字节，用0填充；如果超过16字节，截断
        System.arraycopy(keyBytes, 0, key, 0, Math.min(keyBytes.length, 16));
        
        return key;
    }
    
    /**
     * 加密文件
     */
    private void encryptFile(String filePath) throws Exception {
        File file = new File(filePath);
        byte[] fileContent = Files.readAllBytes(file.toPath());
        
        // 使用AES加密，确保密钥长度为32字节
        SecretKeySpec secretKey = new SecretKeySpec(getAESKey(), "AES");
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
        
        // 使用AES解密，确保密钥长度为32字节
        SecretKeySpec secretKey = new SecretKeySpec(getAESKey(), "AES");
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
                log.info("开始执行恢复: backup_id={}", backup.getId());
                
                String filePath = backup.getFilePath();
                
                // 检查备份文件是否存在
                File backupFile = new File(filePath);
                if (!backupFile.exists()) {
                    throw new RuntimeException("备份文件不存在: " + filePath);
                }
                
                log.info("备份文件大小: {} bytes", backupFile.length());
                
                // 如果文件已加密，先解密
                if (backup.getIsEncrypted()) {
                    log.info("备份文件已加密，开始解密");
                    tempFilePath = filePath + ".restore_temp";
                    Files.copy(Paths.get(filePath), Paths.get(tempFilePath));
                    decryptFile(tempFilePath);
                    filePath = tempFilePath;
                    log.info("解密完成");
                }
                
                // 从数据库URL中提取数据库名
                String dbName = extractDatabaseName(dbUrl);
                log.info("恢复数据库: {}", dbName);
                
                // 尝试使用 Java 原生方式恢复
                boolean useNativeRestore = true; // 可以通过配置控制
                
                if (useNativeRestore) {
                    log.info("使用 Java 原生方式恢复数据库");
                    executeNativeRestore(restore, filePath);
                } else {
                    log.info("使用 mysql 命令恢复数据库");
                    executeMysqlRestore(restore, filePath, dbName);
                }
                
            } catch (Exception e) {
                restore.setRestoreStatus("failed");
                restore.setErrorMessage(e.getMessage());
                log.error("恢复异常", e);
            } finally {
                // 删除临时文件
                if (tempFilePath != null) {
                    try {
                        new File(tempFilePath).delete();
                        log.info("临时文件已删除: {}", tempFilePath);
                    } catch (Exception e) {
                        log.warn("删除临时文件失败: {}", tempFilePath, e);
                    }
                }
                // 更新恢复记录
                try {
                    restoreMapper.updateById(restore);
                    log.info("恢复记录已更新: id={}, status={}", restore.getId(), restore.getRestoreStatus());
                } catch (Exception e) {
                    log.error("更新恢复记录失败", e);
                }
            }
        }).start();
    }
    
    /**
     * 使用 Java 原生方式执行恢复
     */
    private void executeNativeRestore(SysRestore restore, String filePath) {
        try (Connection connection = dataSource.getConnection()) {
            // 使用 DatabaseBackupUtil 恢复
            databaseBackupUtil.restoreDatabase(connection, filePath);
            
            restore.setRestoreStatus("success");
            restore.setCompletedTime(LocalDateTime.now());
            log.info("恢复成功");
        } catch (Exception e) {
            restore.setRestoreStatus("failed");
            restore.setErrorMessage("Java原生恢复失败: " + e.getMessage());
            log.error("Java原生恢复失败", e);
        }
    }
    
    /**
     * 使用 mysql 命令执行恢复
     */
    private void executeMysqlRestore(SysRestore restore, String filePath, String dbName) {
        try {
            // 构建mysql命令
            String os = System.getProperty("os.name").toLowerCase();
            Process process;
            
            if (os.contains("win")) {
                // Windows系统
                String command = String.format(
                    "mysql -u%s -p%s %s < \"%s\"",
                    dbUsername, dbPassword, dbName, filePath
                );
                log.info("执行命令 (Windows): {}", command.replace(dbPassword, "****"));
                process = Runtime.getRuntime().exec(new String[]{"cmd", "/c", command});
            } else {
                // Linux/Unix系统
                String command = String.format(
                    "mysql -u%s -p%s %s < %s",
                    dbUsername, dbPassword, dbName, filePath
                );
                log.info("执行命令 (Linux): {}", command.replace(dbPassword, "****"));
                process = Runtime.getRuntime().exec(new String[]{"sh", "-c", command});
            }
            
            // 读取错误输出
            BufferedReader errReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
            StringBuilder errOutput = new StringBuilder();
            String line;
            while ((line = errReader.readLine()) != null) {
                errOutput.append(line).append("\n");
            }
            
            int exitCode = process.waitFor();
            log.info("命令执行完成，退出码: {}", exitCode);
            
            if (exitCode == 0) {
                restore.setRestoreStatus("success");
                restore.setCompletedTime(LocalDateTime.now());
                log.info("恢复成功");
            } else {
                String errorMsg = "恢复失败，退出码: " + exitCode;
                if (errOutput.length() > 0) {
                    errorMsg += "\n错误信息: " + errOutput.toString();
                }
                restore.setRestoreStatus("failed");
                restore.setErrorMessage(errorMsg);
                log.error("恢复失败: {}", errorMsg);
            }
        } catch (Exception e) {
            restore.setRestoreStatus("failed");
            restore.setErrorMessage("mysql命令恢复失败: " + e.getMessage());
            log.error("mysql命令恢复失败", e);
        }
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
