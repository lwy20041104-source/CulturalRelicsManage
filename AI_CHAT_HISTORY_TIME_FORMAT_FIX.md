# AI对话历史时间格式修复

## 问题描述

**现象**：AI对话历史界面的时间显示格式为 `2026/04/27 17:25:19`（使用斜杠分隔）

**期望**：时间格式应该为 `2026-04-27 17:25:19`（使用横杠分隔）

## 问题原因

在 `AiChatHistoryView.vue` 中，`formatDateTime` 函数使用了 JavaScript 的 `toLocaleString()` 方法：

```javascript
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  return new Date(dateTime).toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit'
  })
}
```

`toLocaleString('zh-CN', ...)` 方法会根据中文地区的习惯使用 `/` 作为日期分隔符，产生 `2026/04/27 17:25:19` 格式。

## 解决方案

### 修改文件

**文件**：`frontend/src/views/AiChatHistoryView.vue`

### 修改内容

将 `formatDateTime` 函数改为手动格式化：

```javascript
// 格式化日期时间
const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}
```

### 修改说明

1. **手动提取日期时间组件**：使用 `getFullYear()`、`getMonth()`、`getDate()` 等方法
2. **补零处理**：使用 `padStart(2, '0')` 确保月、日、时、分、秒都是两位数
3. **自定义格式**：使用模板字符串拼接成 `YYYY-MM-DD HH:mm:ss` 格式

## 影响范围

此修改影响 AI对话历史界面的以下时间显示：

1. **会话列表表格**：
   - 创建时间列
   - 更新时间列

2. **会话详情对话框**：
   - 会话信息中的创建时间
   - 会话信息中的更新时间
   - 每条消息的发送时间

## 验证步骤

### 1. 刷新前端页面

由于是 Vue 组件的修改，只需刷新浏览器即可看到效果（如果使用了热重载，会自动更新）。

### 2. 检查时间格式

访问 **系统管理员端 > AI对话历史** 页面，检查：

- ✅ 表格中的"创建时间"列显示为 `2026-04-27 17:25:19`
- ✅ 表格中的"更新时间"列显示为 `2026-04-27 17:25:19`
- ✅ 点击"详情"按钮，对话框中的时间也显示为 `2026-04-27 17:25:19`
- ✅ 对话消息的时间戳显示为 `2026-04-27 17:25:19`

## 格式对比

| 修改前 | 修改后 |
|--------|--------|
| `2026/04/27 17:25:19` | `2026-04-27 17:25:19` |
| `2026/4/7 9:5:3` | `2026-04-07 09:05:03` |

**优势**：
- ✅ 使用横杠分隔符，更符合 ISO 8601 标准
- ✅ 始终保持两位数格式（补零），更整齐美观
- ✅ 与系统其他界面的时间格式保持一致

## 相关文件

- `frontend/src/views/AiChatHistoryView.vue` - AI对话历史视图（已修复）

## 注意事项

1. **无需重启服务**：前端修改只需刷新浏览器即可
2. **格式统一**：建议检查其他页面的时间格式，确保全站统一
3. **时区问题**：当前使用本地时区，如果需要显示特定时区，需要额外处理

## 扩展建议

如果系统中有多个地方需要格式化时间，建议创建一个全局的时间格式化工具函数：

```javascript
// utils/dateFormat.js
export const formatDateTime = (dateTime) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`
}

export const formatDate = (dateTime) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  return `${year}-${month}-${day}`
}

export const formatTime = (dateTime) => {
  if (!dateTime) return '-'
  const date = new Date(dateTime)
  const hours = String(date.getHours()).padStart(2, '0')
  const minutes = String(date.getMinutes()).padStart(2, '0')
  const seconds = String(date.getSeconds()).padStart(2, '0')
  return `${hours}:${minutes}:${seconds}`
}
```

然后在各个组件中导入使用：

```javascript
import { formatDateTime } from '@/utils/dateFormat'
```

这样可以确保全站时间格式的一致性，并且便于统一修改。

## 完成状态

✅ **已完成**
- 修改 `AiChatHistoryView.vue` 中的 `formatDateTime` 函数
- 时间格式从 `2026/04/27 17:25:19` 改为 `2026-04-27 17:25:19`
- 刷新浏览器即可看到效果
