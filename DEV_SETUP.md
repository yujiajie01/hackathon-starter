# 本地开发环境设置

## 使用 pnpm 和 nodemon 进行本地调试

### 前置要求

1. 安装 Node.js (>= 24.11.0)
2. 安装 pnpm:
   ```bash
   npm install -g pnpm
   # 或
   corepack enable
   corepack prepare pnpm@latest --activate
   ```

### 快速开始

#### 1. 安装依赖

```bash
# 使用 pnpm 安装
pnpm install

# 或清理后重新安装
pnpm run clean-install:pnpm
```

#### 2. 启动开发服务器

```bash
# 基础开发模式（自动重启，但需要手动编译 SCSS）
pnpm run dev

# 完整开发模式（自动重启 + 自动编译 SCSS）
pnpm run dev:watch
```

### 可用脚本

- `pnpm run dev` - 启动开发服务器（使用 nodemon 自动重启）
- `pnpm run dev:watch` - 启动开发服务器并监听 SCSS 文件变化
- `pnpm run scss` - 编译 SCSS 文件
- `pnpm run scss:watch` - 监听并自动编译 SCSS 文件
- `pnpm run clean-install:pnpm` - 清理并重新安装依赖

### nodemon 配置

nodemon 配置文件 (`nodemon.json`) 已设置监听以下文件/目录：
- `app.js`
- `controllers/`
- `models/`
- `config/`
- `views/`

当这些文件发生变化时，服务器会自动重启。

### 环境变量

确保创建 `.env` 文件（基于 `.env.example`）并配置必要的环境变量：
- `MONGODB_URI` - MongoDB 连接字符串
- `BASE_URL` - 应用基础 URL
- `SESSION_SECRET` - 会话密钥
- 其他 API 密钥（根据需要）

### 开发提示

1. **热重载**: nodemon 会自动检测代码变化并重启服务器
2. **SCSS 监听**: 使用 `dev:watch` 可以同时监听 JS 和 SCSS 文件
3. **调试**: 可以在 VS Code 中配置调试器连接到 nodemon 进程
4. **日志**: nodemon 会显示详细的日志信息，包括重启原因

### VS Code 调试配置

在 `.vscode/launch.json` 中添加：

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "attach",
      "name": "Attach to nodemon",
      "processId": "${command:PickProcess}",
      "restart": true,
      "protocol": "inspector"
    }
  ]
}
```

### 故障排除

1. **端口被占用**: 修改 `app.js` 中的端口号或关闭占用端口的进程
2. **MongoDB 连接失败**: 检查 `MONGODB_URI` 环境变量
3. **nodemon 不重启**: 检查 `nodemon.json` 配置，确保监听的文件在 watch 列表中

