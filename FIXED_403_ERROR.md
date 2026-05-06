# 修复403登录错误

## 问题原因

Spring Security配置中的路径匹配有误。所有Controller使用 `@RequestMapping("/api/xxx")`，但SecurityConfig中配置的是 `/auth/**` 而不是 `/api/auth/**`，导致登录端点被拦截返回403错误。

## 已修复的内容

### 1. SecurityConfig.java
将所有路径匹配规则添加了 `/api` 前缀：

**修改前：**
```java
.antMatchers("/auth/**", ...).permitAll()
.antMatchers("/relics/**", ...).hasAnyRole(...)
```

**修改后：**
```java
.antMatchers("/api/auth/**", ...).permitAll()
.antMatchers("/api/relics/**", ...).hasAnyRole(...)
```

### 2. ImageLibraryView.vue
添加了缺失的Element Plus图标导入：
```javascript
import { Picture, View, Edit, Download, Delete, UploadFilled } from '@element-plus/icons-vue'
```

## 重启后端服务

1. **停止当前运行的后端服务**（如果正在运行）
   - 在运行后端的命令行窗口按 `Ctrl+C`

2. **启动新编译的后端**
   ```bash
   cd backend
   java -jar target/cultural-relics-manage-1.0.0.jar
   ```

3. **等待启动完成**
   看到以下日志表示启动成功：
   ```
   Tomcat started on port(s): 8080 (http)
   Started CulturalRelicsApplication
   ```

4. **刷新前端页面**
   - 打开浏览器
   - 刷新页面（F5或Ctrl+R）
   - 尝试登录

## 验证

登录应该可以正常工作了，不再返回403错误。

## 注意事项

- 确保MySQL数据库正在运行
- 确保Redis服务正在运行（如果配置了密码，需要在application.yml中设置）
- 端口8080没有被其他程序占用
- 使用正确的用户名和密码登录

## 默认管理员账号

如果数据库是新初始化的，可能需要先注册账号或使用默认管理员账号（如果有的话）。
