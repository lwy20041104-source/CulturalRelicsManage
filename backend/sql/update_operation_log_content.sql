-- 更新操作日志内容，将英文方法名改为中文描述
-- 执行此脚本前请备份数据库

-- 更新登录日志
UPDATE sys_operation_log 
SET operation_content = '用户登录' 
WHERE operation_content = 'login';

-- 更新新增操作
UPDATE sys_operation_log 
SET operation_content = CASE operation_module
    WHEN '用户管理' THEN '新增用户'
    WHEN '文物管理' THEN '新增文物'
    WHEN '借展管理' THEN '新增借展记录'
    WHEN '维护管理' THEN '新增维护记录'
    WHEN '修复管理' THEN '新增修复记录'
    ELSE '新增记录'
END
WHERE operation_content = 'save';

-- 更新修改操作
UPDATE sys_operation_log 
SET operation_content = CASE operation_module
    WHEN '用户管理' THEN '修改用户信息'
    WHEN '文物管理' THEN '修改文物信息'
    WHEN '借展管理' THEN '修改借展记录'
    WHEN '维护管理' THEN '修改维护记录'
    WHEN '修复管理' THEN '修改修复记录'
    ELSE '修改信息'
END
WHERE operation_content = 'update';

-- 更新删除操作
UPDATE sys_operation_log 
SET operation_content = CASE operation_module
    WHEN '用户管理' THEN '删除用户'
    WHEN '文物管理' THEN '删除文物'
    WHEN '借展管理' THEN '删除借展记录'
    WHEN '维护管理' THEN '删除维护记录'
    WHEN '修复管理' THEN '删除修复记录'
    ELSE '删除记录'
END
WHERE operation_content = 'delete';

-- 更新登出日志
UPDATE sys_operation_log 
SET operation_content = '退出登录' 
WHERE operation_content = 'logout';

-- 更新导出操作
UPDATE sys_operation_log 
SET operation_content = '导出文物数据' 
WHERE operation_content = 'exportExcel' AND operation_module = '文物管理';

-- 更新批量删除操作
UPDATE sys_operation_log 
SET operation_content = '批量删除文物' 
WHERE operation_content = 'batchDelete' AND operation_module = '文物管理';

-- 更新批量修改状态操作
UPDATE sys_operation_log 
SET operation_content = '批量修改文物状态' 
WHERE operation_content = 'batchUpdateStatus' AND operation_module = '文物管理';

-- 更新导入操作
UPDATE sys_operation_log 
SET operation_content = '导入文物数据' 
WHERE operation_content = 'importExcel' AND operation_module = '文物管理';

-- 更新上传图片操作
UPDATE sys_operation_log 
SET operation_content = '上传文物图片' 
WHERE operation_content = 'uploadImage' AND operation_module = '文物管理';

-- 查看更新结果
SELECT operation_type, operation_module, operation_content, COUNT(*) as count
FROM sys_operation_log
GROUP BY operation_type, operation_module, operation_content
ORDER BY operation_type, operation_module;
