# Stage 1: Build
FROM node:18-alpine AS builder

WORKDIR /data

# 安裝 pnpm
RUN npm install -g pnpm

# 拷貝 package 設定
COPY package*.json pnpm-lock.yaml ./

# 安裝依賴
RUN pnpm install --frozen-lockfile

# 拷貝源碼
COPY . .

# Build n8n CLI
RUN pnpm build

# Stage 2: Run
FROM node:18-alpine

WORKDIR /home/node

# 從 builder 拷貝編譯好的 n8n
COPY --from=builder /data/packages/cli/dist /home/node/n8n

# 設定 PATH 讓 n8n 可執行
ENV PATH="/home/node/n8n/bin:${PATH}"

EXPOSE 5678

CMD ["n8n"]
