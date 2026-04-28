# 个人信息界面国际化实现

## 概述
为前后台的个人信息界面实现中英文切换功能，使其跟随系统语言自动切换，无需单独的语言切换按钮。

## 修改的文件

### 1. 国际化文件
- `frontend/src/i18n/locales/zh-CN.js` - 添加中文翻译
- `frontend/src/i18n/locales/en-US.js` - 添加英文翻译

### 2. 视图文件
- `frontend/src/views/ProfileView.vue` - 后台个人信息界面
- `frontend/src/views/PortalProfileView.vue` - 前台个人信息界面

## 国际化键列表

### 添加的翻译键（profile 命名空间）

| 键名 | 中文 | 英文 | 说明 |
|------|------|------|------|
| title | 个人信息 | Profile | 页面标题 |
| username | 用户名 | Username | 字段标签 |
| realName | 真实姓名 | Real Name | 字段标签 |
| role | 角色 | Role | 字段标签 |
| status | 状态 | Status | 字段标签 |
| email | 邮箱 | Email | 字段标签 |
| phone | 电话 | Phone | 字段标签 |
| museum | 所属博物馆 | Museum | 字段标签（仅前台） |
| createTime | 创建时间 | Create Time | 字段标签 |
| updateTime | 更新时间 | Update Time | 字段标签 |
| enabled | 启用 | Enabled | 状态值 |
| disabled | 禁用 | Disabled | 状态值 |
| editProfile | 编辑个人信息 | Edit Profile | 按钮文本 |
| saveChanges | 保存修改 | Save Changes | 按钮文本 |
| cancel | 取消 | Cancel | 按钮文本 |
| back | 返回 | Back | 按钮文本 |
| changePassword | 修改密码 | Change Password | 字段标签 |
| confirmPassword | 确认密码 | Confirm Password | 字段标签 |

### 占位符文本

| 键名 | 中文 | 英文 |
|------|------|------|
| usernamePlaceholder | 请输入用户名 | Please enter username |
| emailPlaceholder | 请输入邮箱 | Please enter email |
| phonePlaceholder | 请输入电话号码 | Please enter phone number |
| selectMuseum | 请选择所属博物馆 | Please select museum |
| passwordPlaceholder | 6-20位字符，必须包含数字和字母（不修改请留空） | 6-20 characters, must contain numbers and letters (leave blank if not changing) |
| confirmPasswordPlaceholder | 请再次输入密码（不修改请留空） | Please enter password again (leave blank if not changing) |

### 提示文本

| 键名 | 中文 | 英文 |
|------|------|------|
| usernameTip | 用户名不能与其他用户重复 | Username must be unique |
| realNameTip | 真实姓名不可修改 | Real name cannot be modified |
| roleTip | 角色不可修改 | Role cannot be modified |

### 验证错误消息

| 键名 | 中文 | 英文 |
|------|------|------|
| usernameRequired | 请输入用户名 | Please enter username |
| usernameNoSpace | 用户名不能包含空格 | Username cannot contain spaces |
| emailRequired | 请输入邮箱 | Please enter email |
| emailInvalid | 请输入正确的邮箱格式 | Please enter valid email format |
| phoneRequired | 请输入电话号码 | Please enter phone number |
| phoneInvalid | 请输入正确的手机号码 | Please enter valid phone number |
| museumRequired | 请选择所属博物馆 | Please select museum |
| passwordLength | 密码长度必须在6-20位之间 | Password length must be between 6-20 characters |
| passwordNeedNumber | 密码必须包含数字 | Password must contain numbers |
| passwordNeedLetter | 密码必须包含字母 | Password must contain letters |
| passwordInvalid | 密码必须是6-20位字符，且包含数字和字母 | Password must be 6-20 characters and contain both numbers and letters |
| confirmPasswordRequired | 请再次输入密码 | Please enter password again |
| passwordNotMatch | 两次输入的密码不一致 | Passwords do not match |

### 操作消息

| 键名 | 中文 | 英文 |
|------|------|------|
| updateSuccess | 个人信息更新成功 | Profile updated successfully |
| updateFailed | 更新失败 | Update failed |
| loadFailed | 加载个人信息失败 | Failed to load profile |
| loadMuseumsFailed | 加载博物馆列表失败 | Failed to load museum list |

## 实现细节

### 1. 导入 useI18n
```javascript
import { useI18n } from 'vue-i18n'

const { t } = useI18n()
```

### 2. 模板中使用 $t()
```vue
<template>
  <el-card class="profile-card">
    <template #header>
      <div class="card-header">
        <span class="header-title">
          <el-icon><User /></el-icon>
          {{ $t('profile.title') }}
        </span>
        <el-button @click="goBack">
          <el-icon><ArrowLeft /></el-icon>
          {{ $t('profile.back') }}
        </el-button>
      </div>
    </template>
    <!-- ... -->
  </el-card>
</template>
```

### 3. 脚本中使用 t()
```javascript
// 验证规则中使用
const validateUsername = (rule, value, callback) => {
  if (!value) {
    callback(new Error(t('profile.usernameRequired')))
  } else if (/\s/.test(value)) {
    callback(new Error(t('profile.usernameNoSpace')))
  } else {
    callback()
  }
}

// 消息提示中使用
ElMessage.success(t('profile.updateSuccess'))
ElMessage.error(t('profile.loadFailed'))
```

### 4. 动态属性绑定
```vue
<el-form-item :label="$t('profile.username')" prop="username">
  <el-input 
    v-model="editForm.username" 
    :placeholder="$t('profile.usernamePlaceholder')" 
  />
  <div class="form-tip">{{ $t('profile.usernameTip') }}</div>
</el-form-item>
```

## 前后台差异

### 后台 ProfileView.vue
- 没有"所属博物馆"字段
- 不需要加载博物馆列表
- 返回按钮使用 `router.back()`

### 前台 PortalProfileView.vue
- 包含"所属博物馆"字段和选择器
- 需要加载博物馆列表
- 返回按钮跳转到 `/portal`
- 有额外的页面背景样式

## 语言切换机制

### 自动跟随系统语言
个人信息界面不需要单独的语言切换按钮，会自动跟随系统语言设置：

1. **后台系统**：通过顶部导航栏的 `LanguageSwitcher` 组件切换
2. **前台系统**：通过前台页面顶部的 `LanguageSwitcher` 组件切换

### 语言切换流程
```
用户点击语言切换按钮
    ↓
LanguageSwitcher 更新 localStorage
    ↓
Vue I18n 的 locale 值改变
    ↓
所有使用 $t() 和 t() 的文本自动更新
    ↓
个人信息界面文本自动切换
```

## 测试验证

### 测试步骤
1. ✅ 登录后台系统，进入个人信息页面
2. ✅ 切换语言为英文，验证所有文本是否变为英文
3. ✅ 切换回中文，验证所有文本是否恢复中文
4. ✅ 点击"编辑个人信息"，验证表单标签和占位符是否正确翻译
5. ✅ 触发表单验证错误，验证错误消息是否正确翻译
6. ✅ 提交表单，验证成功/失败消息是否正确翻译
7. ✅ 登录前台系统，重复上述测试
8. ✅ 前端构建成功，无错误

### 验证点
- [x] 页面标题国际化
- [x] 字段标签国际化
- [x] 按钮文本国际化
- [x] 占位符文本国际化
- [x] 提示文本国际化
- [x] 验证错误消息国际化
- [x] 操作成功/失败消息国际化
- [x] 状态值（启用/禁用）国际化
- [x] 语言切换后文本立即更新
- [x] 前后台功能正常

## 代码示例

### 中文界面效果
```
个人信息
├── 用户名: admin
├── 真实姓名: 管理员
├── 角色: 系统管理员
├── 状态: 启用
├── 邮箱: admin@example.com
├── 电话: 13800138000
├── 创建时间: 2024-01-01 10:00:00
└── 更新时间: 2024-01-15 15:30:00

[编辑个人信息]
```

### 英文界面效果
```
Profile
├── Username: admin
├── Real Name: Administrator
├── Role: System Administrator
├── Status: Enabled
├── Email: admin@example.com
├── Phone: 13800138000
├── Create Time: 2024-01-01 10:00:00
└── Update Time: 2024-01-15 15:30:00

[Edit Profile]
```

## 注意事项

1. **验证规则动态化**：所有验证错误消息都使用 `t()` 函数，确保语言切换后验证消息也会更新

2. **占位符文本**：使用 `:placeholder` 动态绑定，而不是硬编码

3. **提示文本**：表单提示文本也需要国际化

4. **错误处理**：API 错误消息优先使用后端返回的消息，如果没有则使用国际化的默认消息

5. **一致性**：前后台使用相同的国际化键，保持翻译一致性

## 相关文档
- [菜单栏国际化修复](./MENU_I18N_FIX.md)
- [分类和年代国际化修复](./CATEGORY_ERA_I18N_FIX.md)
- [数据大屏图表国际化修复](./DASHBOARD_CHARTS_I18N_FIX.md)
- [上下文转移总结](./CONTEXT_TRANSFER_SUMMARY.md)

## 总结
成功为前后台个人信息界面实现了完整的中英文切换功能，所有用户可见文本都已国际化，包括标签、按钮、占位符、提示文本、验证消息和操作反馈。界面会自动跟随系统语言设置切换，无需单独的语言切换按钮，用户体验良好。
