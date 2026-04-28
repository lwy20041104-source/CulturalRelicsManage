-- 为sys_user表添加登录锁定相关字段
-- 用于防止暴力破解

ALTER TABLE sys_user 
ADD COLUMN login_failed_count INT DEFAULT 0 COMMENT '登录失败次数',
ADD COLUMN account_locked TINYINT(1) DEFAULT 0 COMMENT '账户是否锁定：0-未锁定，1-已锁定',
ADD COLUMN locked_time DATETIME NULL COMMENT '账户锁定时间',
ADD COLUMN last_login_time DATETIME NULL COMMENT '最后登录时间',
ADD COLUMN last_login_ip VARCHAR(50) NULL COMMENT '最后登录IP';

-- 为现有用户初始化字段
UPDATE sys_user 
SET login_failed_count = 0, 
    account_locked = 0 
WHERE login_failed_count IS NULL OR account_locked IS NULL;
