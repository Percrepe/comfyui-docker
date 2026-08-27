# RunPod 部署指南

## 镜像地址

所有镜像都发布到 GitHub Container Registry (GHCR):

```
ghcr.io/percrepe/comfyui:cu130-py312-v0.34.0
```

### 可用标签

| 标签 | CUDA | Python | Torch |
|------|------|--------|-------|
| `cu130-py311-v0.34.0` | 13.0.1 | 3.11 | 2.12.1 |
| `cu130-py312-v0.34.0` | 13.0.1 | 3.12 | 2.12.1 |
| `cu130-py313-v0.34.0` | 13.0.1 | 3.13 | 2.12.1 |
| `cu128-py311-v0.34.0` | 12.8.1 | 3.11 | 2.11.0 |
| `cu128-py312-v0.34.0` | 12.8.1 | 3.12 | 2.11.0 |
| `cu124-py311-v0.34.0` | 12.4.1 | 3.11 | 2.6.0 |
| `cu124-py312-v0.34.0` | 12.4.1 | 3.12 | 2.6.0 |

## 在 RunPod 上创建模板

### 步骤 1: 登录 RunPod

访问 [runpod.io](https://runpod.io) 并登录。

### 步骤 2: 创建自定义模板

1. 进入 **Pod Templates** 页面
2. 点击 **New Template**
3. 填写以下信息:

**模板名称:** ComfyUI (CUDA 13.0)

**容器镜像:**
```
ghcr.io/percrepe/comfyui:cu130-py312-v0.34.0
```

**容器磁盘 (GB):** 20

**端口配置:**

| 端口 | 协议 | 名称 |
|------|------|------|
| 3000 | HTTP | ComfyUI |
| 7777 | HTTP | Code Server |
| 8888 | HTTP | Jupyter Lab |
| 2999 | HTTP | File Uploader |

**环境变量:**

| 变量 | 值 |
|------|-----|
| `JUPYTER_PASSWORD` | 你的密码 |
| `EXTRA_ARGS` | `--listen 0.0.0.0` |

4. 点击 **Save Template**

### 步骤 3: 部署 Pod

1. 选择你刚创建的模板
2. 选择 GPU 类型 (推荐 RTX 4090 或更好)
3. 点击 **Deploy**

## 本地测试

### 使用 Docker 运行

```bash
# CUDA 13.0 版本
docker run -d \
  --gpus all \
  -p 3000:3001 \
  -p 7777:7777 \
  -p 8888:8888 \
  -e JUPYTER_PASSWORD=your_password \
  -e EXTRA_ARGS=--listen 0.0.0.0 \
  ghcr.io/percrepe/comfyui:cu130-py312-v0.34.0
```

### 访问服务

- **ComfyUI:** http://localhost:3000
- **Code Server:** http://localhost:7777
- **Jupyter Lab:** http://localhost:8888

## 构建镜像

### 使用 GitHub Actions (推荐)

推送代码到 main 分支会自动构建并推送所有镜像。

### 手动构建

```bash
# 克隆仓库
git clone https://github.com/Percrepe/comfyui-docker.git
cd comfyui-docker

# 登录 GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u percrepe --password-stdin

# 构建所有镜像
docker buildx bake -f docker-bake.hcl --push

# 构建特定版本
docker buildx bake -f docker-bake.hcl cu130-py312 --push
```

## 注意事项

1. **首次启动:** ComfyUI 首次启动会下载模型，可能需要几分钟
2. **GPU 兼容性:** CUDA 13.0 需要 NVIDIA 驱动 550+
3. **存储:** 建议使用 RunPod 网络卷存储模型，避免重复下载
