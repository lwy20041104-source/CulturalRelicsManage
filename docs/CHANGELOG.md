# 更新日志

## [2024年更新] - 安全增强与代码质量提升

### 新增功能

#### 1. 文物二维码标签生成与扫描 ✨ (最新)
- **二维码生成**：
  - 为每个文物生成唯一的二维码
  - 二维码包含文物编号、名称等信息
  - 支持单个生成和批量生成
  - Base64格式返回，便于前端显示
- **二维码标签**：
  - 200x200像素标准尺寸
  - 包含文物编号和名称文字
  - 扫描提示信息
  - 专业的标签设计
- **扫描查看**：
  - 扫描后跳转到专门的展示页面
  - 无需登录即可查看基本信息
  - 展示文物详细属性（编号、名称、年代、材质、分类、状态等）
  - 响应式设计，支持移动端
- **操作功能**：
  - 在线查看二维码
  - 下载二维码图片（PNG格式）
  - 打印二维码标签（A4纸张）
  - 美观的打印预览
- **技术实现**：
  - 后端使用Google ZXing库生成二维码
  - 前端Vue3组件化设计
  - 独立的扫描页面路由
  - 完整的错误处理

**应用场景**：
- 文物标签管理（实体标签制作）
- 展览导览（观众扫码查看）
- 库房管理（快速定位文物）
- 文物盘点（扫码记录信息）

**相关文件**：
- `backend/src/main/java/com/example/util/QRCodeUtil.java`（二维码工具类）
- `backend/src/main/java/com/example/controller/CulturalRelicController.java`（新增接口）
- `frontend/src/views/RelicsView.vue`（新增二维码功能）
- `frontend/src/views/QRCodeScanView.vue`（扫描页面）
- `frontend/src/api/relics.js`（API接口）
- `docs/QRCODE_FEATURE.md`（功能说明文档）

#### 2. 文物图片上传增强 ✨
- **双模式支持**：既可以上传图片文件，又可以输入图片URL
- **上传模式**：
  - 支持拖拽上传
  - 实时图片预览
  - 文件大小限制（5MB）
  - 格式验证（JPG/PNG/GIF）
  - 自动生成唯一文件名
- **URL模式**：
  - URL格式验证
  - 实时图片预览
  - 加载错误提示
  - 支持图片代理服务
- **模式切换**：
  - 自由切换上传/URL模式
  - 编辑时自动识别图片类型
  - 切换时自动清空之前的选择
- **用户体验**：
  - 图片移除功能
  - 响应式设计
  - 友好的错误提示
  - 统一的UI风格

**相关文件**：
- `frontend/src/views/RelicsView.vue`（前端实现）
- `backend/src/main/java/com/example/controller/CulturalRelicController.java`（后端接口）
- `docs/IMAGE_UPLOAD_GUIDE.md`（使用指南）
- `docs/IMAGE_UPLOAD_TEST.md`（测试指南）
- `docs/IMAGE_UPLOAD_QUICKSTART.md`（快速开始）

#### 2. 密码重置功能 ✨
- **忘记密码流程**：支持邮箱和手机号验证码重置密码
- **邮件服务集成**：
  - Spring Boot Mail真实邮件发送
  - 精美HTML邮件模板（蓝色渐变设计）
  - 多邮箱配置支持（QQ邮箱、163邮箱）
  - Profile配置切换
  - SSL安全连接（端口465）
- **短信服务集成**：
  - 阿里云短信服务
  - 验证码模板管理
  - 发送状态跟踪
- **验证码管理**：
  - 数据库持久化存储
  - 15分钟有效期
  - 使用后自动失效
  - 防重复发送
- **来源跟踪**：
  - 记住从哪个登录页面进入（前台/后台）
  - 重置后自动跳转回对应登录页面
- **安全增强**：
  - 联系方式脱敏显示
  - 密码重置后清除登录失败记录
  - 账户自动解锁

**相关文件**：
- `backend/src/main/java/com/example/service/EmailService.java`
- `backend/src/main/java/com/example/service/impl/EmailServiceImpl.java`
- `backend/src/main/java/com/example/service/SmsService.java`
- `backend/src/main/java/com/example/service/impl/SmsServiceImpl.java`
- `backend/src/main/java/com/example/service/impl/PasswordResetServiceImpl.java`
- `backend/src/main/resources/application-mail-qq.yml`
- `backend/src/main/resources/application-mail-163.yml`
- `backend/sql/create_verification_code_table.sql`
- `frontend/src/views/ForgotPasswordView.vue`
- `frontend/src/views/ResetPasswordView.vue`

#### 2. 登录安全增强 🔒
- **登录失败次数限制**：最多5次失败尝试
- **账户自动锁定**：超过限制锁定30分钟
- **IP地址记录**：记录每次登录的IP地址
- **失败次数提示**：显示剩余尝试次数和锁定时间
- **自动重置**：登录成功或密码重置后清除失败记录
- **Redis缓存**：使用Redis存储失败次数和锁定状态

**相关文件**：
- `backend/src/main/java/com/example/service/LoginSecurityService.java`
- `backend/src/main/java/com/example/service/impl/LoginSecurityServiceImpl.java`
- `backend/sql/add_login_lock_fields.sql`
- `backend/sql/complete_login_lock_setup.sql`

#### 3. 文物状态管理完善 📦
- **借展申请状态检查**：只能申请"在库"状态文物
- **修复申请状态检查**：只能申请"在库"状态文物
- **状态互斥验证**：
  - 修复中的文物不能申请借展
  - 借展中的文物不能申请修复
- **状态自动更新**：
  - 开始修复时文物状态变为"修复中"
  - 完成修复时文物状态变为"在库"
- **状态流转日志**：记录所有状态变更

**相关文件**：
- `backend/src/main/java/com/example/service/impl/LoanRecordServiceImpl.java`
- `backend/src/main/java/com/example/service/impl/RepairRecordServiceImpl.java`
- `backend/src/main/java/com/example/mapper/RepairRecordMapper.java`
- `backend/src/main/resources/mapper/RepairRecordMapper.xml`

#### 4. 异常处理统一 🛡️
- **自定义异常类体系**：
  - `BusinessException`：业务异常
  - `ValidationException`：参数验证异常
  - `ResourceNotFoundException`：资源未找到异常
  - `ServiceException`：服务异常
- **全局异常处理器增强**：
  - 统一异常捕获和处理
  - 规范化错误响应格式
  - 分级日志记录（ERROR/WARN）
  - Spring Validation异常处理
  - 数据库唯一键冲突处理
  - 空指针异常处理
- **代码迁移**：
  - 替换`RuntimeException`为自定义异常
  - 替换`IllegalArgumentException`为`ValidationException`
  - 统一异常处理逻辑

**相关文件**：
- `backend/src/main/java/com/example/exception/BusinessException.java`
- `backend/src/main/java/com/example/exception/ValidationException.java`
- `backend/src/main/java/com/example/exception/ResourceNotFoundException.java`
- `backend/src/main/java/com/example/exception/ServiceException.java`
- `backend/src/main/java/com/example/common/GlobalExceptionHandler.java`
- `backend/src/main/java/com/example/service/impl/SysUserServiceImpl.java`
- `backend/src/main/java/com/example/service/impl/PasswordResetServiceImpl.java`

#### 5. 日志规范制定 📝
- **日志级别规范**：
  - ERROR：系统异常、外部服务失败
  - WARN：业务异常、资源未找到
  - INFO：重要业务操作、状态变更
  - DEBUG：开发调试信息
- **敏感信息脱敏**：
  - 密码：永远不记录
  - 手机号：显示前3位和后4位
  - 邮箱：显示前2位和域名
- **日志格式规范**：
  - 使用占位符
  - 关键信息前置
  - 统一格式
- **规范文档**：
  - 日志使用规范指南
  - 异常处理规范指南
  - 代码质量改进总结
  - 迁移指南

**相关文件**：
- `backend/docs/LOGGING_GUIDELINES.md`
- `backend/docs/EXCEPTION_HANDLING_GUIDELINES.md`
- `backend/docs/CODE_QUALITY_IMPROVEMENTS.md`

### 改进优化

#### 1. 前端体验优化
- **忘记密码链接**：
  - 后台登录页面添加"忘记密码"链接，传递`from=admin`参数
  - 前台登录页面添加"忘记密码"链接，传递`from=portal`参数
- **来源跟踪**：
  - 所有密码重置相关页面传递来源参数
  - 重置成功后自动跳转回对应登录页面
- **表单验证**：
  - 前后端双重验证
  - 友好的错误提示

**相关文件**：
- `frontend/src/views/LoginView.vue`
- `frontend/src/views/PortalLoginView.vue`
- `frontend/src/views/ForgotPasswordView.vue`
- `frontend/src/views/ResetPasswordView.vue`

#### 2. 后端代码质量提升
- **异常处理统一**：所有Service层使用自定义异常
- **日志记录规范**：按照规范使用不同日志级别
- **代码注释完善**：添加关键业务逻辑注释
- **事务管理**：确保数据一致性

#### 3. 安全性提升
- **登录安全**：失败次数限制、账户锁定、IP记录
- **密码重置安全**：验证码、联系方式验证、脱敏显示
- **异常信息安全**：不暴露敏感系统信息
- **日志安全**：敏感信息脱敏

### 数据库变更

#### 新增表
```sql
-- 验证码表
CREATE TABLE verification_code (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    username VARCHAR(50) NOT NULL,
    code VARCHAR(10) NOT NULL,
    type VARCHAR(20) NOT NULL,
    contact VARCHAR(100) NOT NULL,
    purpose VARCHAR(50) NOT NULL,
    used TINYINT DEFAULT 0,
    expire_time DATETIME NOT NULL,
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_code (code),
    INDEX idx_expire_time (expire_time)
);
```

#### 表结构修改
```sql
-- sys_user表新增字段
ALTER TABLE sys_user ADD COLUMN login_failed_count INT DEFAULT 0 COMMENT '登录失败次数';
ALTER TABLE sys_user ADD COLUMN account_locked TINYINT DEFAULT 0 COMMENT '账户是否锁定';
ALTER TABLE sys_user ADD COLUMN locked_time DATETIME COMMENT '锁定时间';
ALTER TABLE sys_user ADD COLUMN last_login_ip VARCHAR(50) COMMENT '最后登录IP';
```

### 配置变更

#### 新增配置文件
- `backend/src/main/resources/application-mail-qq.yml`：QQ邮箱配置
- `backend/src/main/resources/application-mail-163.yml`：163邮箱配置

#### 配置项说明
```yaml
# 邮件服务配置（application-mail-qq.yml）
spring:
  mail:
    host: smtp.qq.com
    port: 465
    username: your-email@qq.com
    password: your-authorization-code
    properties:
      mail:
        smtp:
          auth: true
          ssl:
            enable: true
            trust: smtp.qq.com

# 短信服务配置（application.yml）
sms:
  enabled: false  # 是否启用短信服务
  access-key-id: your-access-key-id
  access-key-secret: your-access-key-secret
  sign-name: your-sign-name
  template-code: your-template-code
```

### 文档更新

#### 新增文档
- `backend/docs/LOGGING_GUIDELINES.md`：日志使用规范指南
- `backend/docs/EXCEPTION_HANDLING_GUIDELINES.md`：异常处理规范指南
- `backend/docs/CODE_QUALITY_IMPROVEMENTS.md`：代码质量改进总结
- `docs/CHANGELOG.md`：更新日志

#### 更新文档
- `docs/PROJECT_ANALYSIS.md`：项目分析报告
- `docs/PROJECT_OVERVIEW.md`：项目概述文档

### 依赖更新

#### 新增依赖
```xml
<!-- 邮件服务 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-mail</artifactId>
</dependency>

<!-- 阿里云短信服务 -->
<dependency>
    <groupId>com.aliyun</groupId>
    <artifactId>dysmsapi20170525</artifactId>
    <version>2.0.24</version>
</dependency>
```

### 破坏性变更

无破坏性变更。所有新功能都是向后兼容的。

### 迁移指南

#### 1. 数据库迁移
```bash
# 执行以下SQL脚本
mysql -u root -p cultural_relics < backend/sql/create_verification_code_table.sql
mysql -u root -p cultural_relics < backend/sql/add_login_lock_fields.sql
mysql -u root -p cultural_relics < backend/sql/complete_login_lock_setup.sql
```

#### 2. 配置邮件服务
```bash
# 1. 复制邮件配置模板
cp backend/src/main/resources/application-mail-qq.yml.example backend/src/main/resources/application-mail-qq.yml

# 2. 修改邮件配置
# 编辑 application-mail-qq.yml，填入你的邮箱和授权码

# 3. 启用邮件配置
# 编辑 application.yml，修改 spring.profiles.include 为 mail-qq
```

#### 3. 配置短信服务（可选）
```bash
# 编辑 application.yml，填入阿里云SMS配置
# 或设置 sms.enabled=false 禁用短信服务
```

#### 4. 代码迁移（可选）
如果你有自定义的Service类，建议按照以下步骤迁移：
1. 添加自定义异常类的导入
2. 将 `RuntimeException` 替换为 `BusinessException`
3. 将 `IllegalArgumentException` 替换为 `ValidationException`
4. 添加资源检查，使用 `ResourceNotFoundException`
5. 外部服务调用失败使用 `ServiceException`
6. 检查日志级别是否正确

详细迁移指南请参考：`backend/docs/CODE_QUALITY_IMPROVEMENTS.md`

### 已知问题

无已知问题。

### 致谢

感谢所有为本次更新做出贡献的开发者！

---

## 历史版本

### [初始版本] - 2024年之前

#### 核心功能
- 用户认证与权限管理
- 文物信息管理
- 文物分类管理
- 借展管理
- 修复管理
- 维护记录管理
- 数据分析与报表
- 智能仪表盘
- AI智能查询
- 批量操作
- 图片代理服务
- 操作日志管理
- 博物馆管理
- 前台借展人端

详细功能说明请参考：`docs/PROJECT_OVERVIEW.md`
