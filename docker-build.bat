@echo off
REM Docker 构建和推送到 NAS 仓库脚本 (Windows)
REM 使用方法: docker-build.bat [registry_url] [image_name] [tag]

setlocal enabledelayedexpansion

REM 配置变量
set REGISTRY_URL=%1
if "%REGISTRY_URL%"=="" set REGISTRY_URL=192.168.1.100:5000
set IMAGE_NAME=%2
if "%IMAGE_NAME%"=="" set IMAGE_NAME=hackathon-starter
set TAG=%3
if "%TAG%"=="" set TAG=latest
set FULL_IMAGE_NAME=%REGISTRY_URL%/%IMAGE_NAME%:%TAG%

echo ==========================================
echo Docker 构建和推送脚本
echo ==========================================
echo 仓库地址: %REGISTRY_URL%
echo 镜像名称: %IMAGE_NAME%
echo 标签: %TAG%
echo 完整镜像名: %FULL_IMAGE_NAME%
echo ==========================================
echo.

REM 检查 Docker 是否运行
docker info >nul 2>&1
if errorlevel 1 (
    echo 错误: Docker 未运行，请先启动 Docker
    exit /b 1
)

REM 构建镜像
echo 开始构建 Docker 镜像...
docker build -t %FULL_IMAGE_NAME% -t %IMAGE_NAME%:%TAG% .

if errorlevel 1 (
    echo 错误: 镜像构建失败
    exit /b 1
)

echo 镜像构建成功！
echo.

REM 询问是否推送到仓库
set /p PUSH_CONFIRM="是否推送到 NAS 仓库? (y/n): "
if /i "%PUSH_CONFIRM%"=="y" (
    echo.
    echo 开始推送镜像到 %REGISTRY_URL%...
    echo 提示: 如果仓库需要认证，请先运行: docker login %REGISTRY_URL%
    echo.
    
    REM 推送镜像
    docker push %FULL_IMAGE_NAME%
    
    if errorlevel 1 (
        echo 错误: 镜像推送失败
        echo 提示: 请确保已登录到仓库: docker login %REGISTRY_URL%
        exit /b 1
    )
    
    echo.
    echo ==========================================
    echo 镜像推送成功！
    echo 完整镜像名: %FULL_IMAGE_NAME%
    echo ==========================================
    echo.
    echo 在 NAS 上运行:
    echo   docker pull %FULL_IMAGE_NAME%
    echo   docker run -d -p 8080:8080 --name hackathon-starter %FULL_IMAGE_NAME%
) else (
    echo.
    echo 跳过推送，镜像已构建完成
    echo 本地镜像: %FULL_IMAGE_NAME%
)

endlocal

