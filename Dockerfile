FROM node:24-slim

WORKDIR /starter

# 设置环境变量
ENV NODE_ENV=production

# 复制 package 文件（利用 Docker 缓存层）
COPY package*.json ./

# 安装依赖
RUN npm ci --omit=dev && \
    npm install -g pm2

# 复制应用代码
COPY . .

# 构建 Sass
RUN npm run scss || true

# 创建非 root 用户
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /starter

USER appuser

EXPOSE 8080

# 使用 pm2 运行应用
CMD ["pm2-runtime", "app.js"]
