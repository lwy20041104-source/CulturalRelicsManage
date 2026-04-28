-- 操作日志表结构（如果不存在则创建）
CREATE TABLE IF NOT EXISTS sys_operation_log (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
    operator VARCHAR(100) COMMENT '操作人姓名',
    operation_type VARCHAR(50) COMMENT '操作类型（新增、修改、删除、查询、登录、登出）',
    operation_module VARCHAR(100) COMMENT '操作模块',
    operation_content VARCHAR(500) COMMENT '操作内容',
    operation_result VARCHAR(20) COMMENT '操作结果（成功、失败）',
    ip_address VARCHAR(50) COMMENT 'IP地址',
    operation_time DATETIME COMMENT '操作时间',
    INDEX idx_operator (operator),
    INDEX idx_operation_type (operation_type),
    INDEX idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统操作日志表';

-- 插入一些示例日志数据（仅用于测试）
INSERT INTO sys_operation_log (operator, operation_type, operation_module, operation_content, operation_result, ip_address, operation_time) VALUES
('管理员', '登录', '系统认证', '用户登录', '成功', '127.0.0.1', NOW() - INTERVAL 2 DAY),
('管理员', '新增', '用户管理', '新增用户', '成功', '127.0.0.1', NOW() - INTERVAL 2 DAY),
('管理员', '修改', '文物管理', '修改文物信息', '成功', '127.0.0.1', NOW() - INTERVAL 1 DAY),
('管理员', '删除', '用户管理', '删除用户', '成功', '127.0.0.1', NOW() - INTERVAL 1 DAY),
('管理员', '查询', '文物管理', '导出文物数据', '成功', '127.0.0.1', NOW() - INTERVAL 5 HOUR),
('管理员', '登出', '系统认证', '退出登录', '成功', '127.0.0.1', NOW() - INTERVAL 3 HOUR);
