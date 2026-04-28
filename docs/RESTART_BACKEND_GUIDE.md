# 后端服务重启指南

## 问题
添加了新的API接口后，需要重启后端服务才能使新接口生效。

## 解决方案

### 方法1：通过IDE重启（推荐）

如果你使用的是 IntelliJ IDEA 或 Eclipse：

1. 在IDE中找到正在运行的 Spring Boot 应用
2. 点击停止按钮（红色方块）
3. 等待服务完全停止
4. 点击运行按钮（绿色三角）重新启动

### 方法2：通过命令行重启

#### 步骤1：停止当前运行的Java进程

**Windows (PowerShell):**
```powershell
# 查找Java进程
Get-Process -Name "java" | Where-Object {$_.MainWindowTitle -like "*CulturalRelicsApplication*"}

# 停止进程（替换 <PID> 为实际的进程ID）
Stop-Process -Id <PID> -Force
```

或者直接停止所有Java进程（谨慎使用）：
```powershell
Stop-Process -Name "java" -Force
```

#### 步骤2：重新编译和启动

```bash
cd backend
mvn clean package -DskipTests
mvn spring-boot:run
```

或者使用已编译的jar包：
```bash
cd backend
java -jar target/cultural-relics-0.0.1-SNAPSHOT.jar
```

### 方法3：使用Maven插件重启

```bash
cd backend
# 停止（如果使用mvn spring-boot:run启动的）
# Ctrl+C

# 重新启动
mvn spring-boot:run
```

## 验证服务已启动

### 1. 检查控制台输出
看到以下信息表示启动成功：
```
Started CulturalRelicsApplication in X.XXX seconds
```

### 2. 检查端口
```powershell
# Windows
netstat -ano | findstr :8080
```

应该看到端口8080被占用。

### 3. 测试API接口
```bash
# 测试健康检查接口
curl http://localhost:8080/api/auth/admin/self-check

# 测试新的密码重置接口
curl -X POST http://localhost:8080/api/auth/forgot-password \
  -H "Content-Type: application/json" \
  -d '{"username":"test","verificationType":"EMAIL","email":"test@example.com"}'
```

## 常见问题

### Q1: 端口8080已被占用
**A:** 停止占用8080端口的进程：
```powershell
# 查找占用8080端口的进程
netstat -ano | findstr :8080

# 停止进程（替换 <PID> 为实际的进程ID）
Stop-Process -Id <PID> -Force
```

### Q2: 编译失败
**A:** 清理并重新编译：
```bash
cd backend
mvn clean
mvn compile
```

### Q3: 启动时报错
**A:** 检查以下内容：
1. 数据库是否正常运行
2. Redis是否正常运行
3. application.yml配置是否正确
4. 依赖是否完整（运行 `mvn dependency:resolve`）

## 快速重启脚本

### Windows (PowerShell)
创建文件 `restart-backend.ps1`：
```powershell
# 停止Java进程
Write-Host "停止后端服务..." -ForegroundColor Yellow
Stop-Process -Name "java" -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# 进入backend目录
Set-Location backend

# 重新编译
Write-Host "重新编译..." -ForegroundColor Yellow
mvn clean package -DskipTests

# 启动服务
Write-Host "启动后端服务..." -ForegroundColor Green
Start-Process -FilePath "mvn" -ArgumentList "spring-boot:run" -NoNewWindow
```

使用方法：
```powershell
.\restart-backend.ps1
```

## 开发建议

### 使用热重载
为了避免频繁重启，可以使用Spring Boot DevTools：

1. 在 `pom.xml` 中添加依赖（如果还没有）：
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <scope>runtime</scope>
    <optional>true</optional>
</dependency>
```

2. 在IDE中启用自动编译：
   - IntelliJ IDEA: Settings → Build, Execution, Deployment → Compiler → Build project automatically
   - Eclipse: Project → Build Automatically

3. 修改代码后，IDE会自动重新编译，DevTools会自动重启应用

### 使用JRebel
JRebel是一个商业工具，可以实现真正的热部署，无需重启。

## 当前情况

根据错误信息 `404 (Not Found)`，说明：
1. ✅ 前端配置正确（请求URL正确）
2. ✅ 后端配置正确（context-path为/api）
3. ❌ 后端服务没有新的接口（需要重启）

**解决方法：重启后端服务**

重启后，密码重置功能应该就能正常工作了。
