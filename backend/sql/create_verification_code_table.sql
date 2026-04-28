-- 创建验证码表
CREATE TABLE IF NOT EXISTS verification_code (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL COMMENT '用户ID',
    username VARCHAR(50) NOT NULL COMMENT '用户名',
    code VARCHAR(10) NOT NULL COMMENT '验证码',
    type VARCHAR(20) NOT NULL COMMENT '验证码类型：EMAIL-邮箱，PHONE-手机',
    contact VARCHAR(100) NOT NULL COMMENT '联系方式（邮箱或手机号）',
    purpose VARCHAR(50) NOT NULL COMMENT '用途：RESET_PASSWORD-重置密码',
    used TINYINT(1) DEFAULT 0 COMMENT '是否已使用：0-未使用，1-已使用',
    expire_time DATETIME NOT NULL COMMENT '过期时间',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    INDEX idx_username (username),
    INDEX idx_code (code),
    INDEX idx_expire_time (expire_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='验证码表';

-- 清理过期验证码的存储过程（可选）
DELIMITER //
CREATE PROCEDURE IF NOT EXISTS clean_expired_codes()
BEGIN
    DELETE FROM verification_code 
    WHERE expire_time < NOW() 
    OR (used = 1 AND create_time < DATE_SUB(NOW(), INTERVAL 7 DAY));
END //
DELIMITER ;
