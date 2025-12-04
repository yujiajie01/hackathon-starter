#!/bin/bash

# Docker 构建和推送到 NAS 仓库脚本
# 使用方法: ./docker-build.sh [registry_url] [image_name] [tag]

set -e

# 配置变量
REGISTRY_URL="${1:-192.168.1.100:5000}"  # 默认 NAS 仓库地址，请修改为你的实际地址
IMAGE_NAME="${2:-hackathon-starter}"
TAG="${3:-latest}"
FULL_IMAGE_NAME="${REGISTRY_URL}/${IMAGE_NAME}:${TAG}"

echo "=========================================="
echo "Docker 构建和推送脚本"
echo "=========================================="
echo "仓库地址: ${REGISTRY_URL}"
echo "镜像名称: ${IMAGE_NAME}"
echo "标签: ${TAG}"
echo "完整镜像名: ${FULL_IMAGE_NAME}"
echo "=========================================="

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "错误: Docker 未运行，请先启动 Docker"
    exit 1
fi

# 构建镜像
echo ""
echo "开始构建 Docker 镜像..."
docker build -t ${FULL_IMAGE_NAME} -t ${IMAGE_NAME}:${TAG} .

if [ $? -ne 0 ]; then
    echo "错误: 镜像构建失败"
    exit 1
fi

echo "镜像构建成功！"

# 询问是否推送到仓库
read -p "是否推送到 NAS 仓库? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "开始推送镜像到 ${REGISTRY_URL}..."
    
    # 登录到仓库（如果需要）
    echo "提示: 如果仓库需要认证，请先运行: docker login ${REGISTRY_URL}"
    
    # 推送镜像
    docker push ${FULL_IMAGE_NAME}
    
    if [ $? -ne 0 ]; then
        echo "错误: 镜像推送失败"
        echo "提示: 请确保已登录到仓库: docker login ${REGISTRY_URL}"
        exit 1
    fi
    
    echo ""
    echo "=========================================="
    echo "镜像推送成功！"
    echo "完整镜像名: ${FULL_IMAGE_NAME}"
    echo "=========================================="
    echo ""
    echo "在 NAS 上运行:"
    echo "  docker pull ${FULL_IMAGE_NAME}"
    echo "  docker run -d -p 8080:8080 --name hackathon-starter ${FULL_IMAGE_NAME}"
else
    echo ""
    echo "跳过推送，镜像已构建完成"
    echo "本地镜像: ${FULL_IMAGE_NAME}"
fi

