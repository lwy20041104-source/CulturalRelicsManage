// 快速修复脚本：添加图片管理权限
(function() {
    console.log('🔧 开始修复权限...');
    
    // 获取当前权限列表
    let permissions = [];
    try {
        permissions = JSON.parse(sessionStorage.getItem('permissions') || '[]');
        console.log('📋 当前权限列表:', permissions);
    } catch (e) {
        console.error('❌ 解析权限列表失败:', e);
        return;
    }
    
    // 检查是否已有 images:manage 权限
    if (permissions.includes('images:manage')) {
        console.log('✅ images:manage 权限已存在，无需添加');
        return;
    }
    
    // 添加权限
    permissions.push('images:manage');
    sessionStorage.setItem('permissions', JSON.stringify(permissions));
    console.log('✅ 已添加 images:manage 权限');
    console.log('📋 新的权限列表:', permissions);
    
    // 刷新页面
    console.log('🔄 页面将在 2 秒后刷新...');
    setTimeout(() => {
        location.reload();
    }, 2000);
})();
