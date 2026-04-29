-- 为维护记录表添加审批相关字段
-- 执行日期：2026-04-29

-- 添加审批相关字段
ALTER TABLE maintenance_record 
ADD COLUMN status VARCHAR(20) DEFAULT '待审批' COMMENT '状态：待审批、已通过、已拒绝' AFTER maintainer_id,
ADD COLUMN approver VARCHAR(50) COMMENT '审批人' AFTER status,
ADD COLUMN approve_date DATETIME COMMENT '审批日期' AFTER approver,
ADD COLUMN approve_remark TEXT COMMENT '审批意见' AFTER approve_date;

-- 更新现有记录的状态为"已通过"（假设现有记录都是已完成的）
UPDATE maintenance_record 
SET status = '已通过' 
WHERE status IS NULL OR status = '';

-- 创建索引以提高查询性能
CREATE INDEX idx_maintainer_id ON maintenance_record(maintainer_id);
CREATE INDEX idx_status ON maintenance_record(status);

-- 查看表结构
DESCRIBE maintenance_record;
