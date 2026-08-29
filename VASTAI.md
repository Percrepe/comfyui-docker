# Vast.ai 部署指南

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

## 在 Vast.ai 上部署

### 方法 1: 使用 Docker Template (推荐)

1. 登录 [vast.ai](https://vast.ai)
2. 进入 **Templates** 页面
3. 点击 **New Template**
4. 填写以下信息:

**模板名称:** ComfyUI

**Docker 镜像:**
```
ghcr.io/percrepe/comfyui:cu130-py312-v0.34.0
```

**Docker Options:**
```
--gpus all -p 8080:8080 -p 7777:7777 -p 8888:8888
```

**环境变量:**

| 变量 | 值 |
|------|-----|
| `EXTRA_ARGS` | `--listen 0.0.0.0` |

5. 点击 **Save**

### 方法 2: 手动部署

1. 在 vast.ai 上租用一个 GPU 实例
2. 选择 **Direct SSH** 或 **Jupyter** 连接方式
3. SSH 进入实例后运行:

```bash
docker run -d \
  --gpus all \
  -p 8080:8080 \
  -p 7777:7777 \
  -p 8888:8888 \
  -e EXTRA_ARGS="--listen 0.0.0.0" \
  ghcr.io/percrepe/comfyui:cu130-py312-v0.34.0
```

## 端口说明

| 端口 | 服务 | 说明 |
|------|------|------|
| 8080 | ComfyUI | 主界面，通过浏览器访问 |
| 7777 | Code Server | 在线代码编辑器 |
| 8888 | Jupyter Lab | Jupyter Notebook 环境 |

## 访问服务

部署完成后，通过以下地址访问:

- **ComfyUI:** `http://<实例IP>:8080`
- **Code Server:** `http://<实例IP>:7777`
- **Jupyter Lab:** `http://<实例IP>:8888`

## 环境变量

| 变量 | 描述 | 默认值 |
|------|------|--------|
| `EXTRA_ARGS` | ComfyUI 额外启动参数 | 未设置 |
| `DISABLE_AUTOLAUNCH` | 禁用自动启动应用 | 未设置 |

## 常用 Extra Args

```bash
# 低显存模式
--lowvram

# 禁用 xformers
--disable-xformers

# 监听所有接口 (必须)
--listen 0.0.0.0

# 启用 CUDA 设备
--cuda-device 0
```

## 数据持久化

建议使用 vast.ai 的持久化存储功能:

1. 在实例配置中添加 **Disk** 挂载
2. 将 `/workspace` 目录挂载到持久化存储
3. 这样模型和数据在实例重启后不会丢失

## 注意事项

1. **首次启动:** ComfyUI 首次启动会下载模型，可能需要几分钟
2. **GPU 兼容性:** CUDA 13.0 需要 NVIDIA 驱动 550+
3. **防火墙:** 确保在 vast.ai 面板中开放所需端口
4. **存储:** 建议挂载持久化存储以保存模型和工作流

## 构建镜像

### 使用 GitHub Actions (推荐)

推送代码到 `vastai` 分支会自动构建并推送所有镜像。

### 手动构建

```bash
# 克隆仓库
git clone https://github.com/Percrepe/comfyui-docker.git
cd comfyui-docker
git checkout vastai

# 登录 GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u percrepe --password-stdin

# 构建所有镜像
docker buildx bake -f docker-bake.hcl --push

# 构建特定版本
docker buildx bake -f docker-bake.hcl cu130-py312 --push
```

## 故障排查

### 查看日志

```bash
# 查看 ComfyUI 日志
docker logs <容器ID>

# 查看实时日志
docker logs -f <容器ID>

# 查看日志文件
cat /workspace/logs/comfyui.log
```

### 重启容器

```bash
docker restart <容器ID>
```

### 进入容器

```bash
docker exec -it <容器ID> bash
```
