# 博物馆文物数字化管理平台 - 后端

## 环境要求
- JDK 11+
- Maven 3.6+
- MySQL 8.0+
- Redis 6.0+

## 启动步骤

1. 创建数据库并初始化：
```sql
source backend/src/main/resources/db.sql
```

2. 修改数据库配置（`application.yml`）

3. 启动 Redis

4. 启动项目：
```bash
mvn spring-boot:run
```

## 默认账号
- 用户名：`admin`
- 密码：`123456`

## 接口文档
启动后访问：
- `http://localhost:8080/api/doc.html`

## 已实现模块
- 用户登录认证（JWT）
- 文物信息管理（CRUD + 分页）
- 文物分类管理
- 借展申请/审批/归还
- 维护记录管理
- 统计分析接口
- 逾期自动标记任务
