<div align="center">

# Docker image for ComfyUI: The most powerful and modular stable diffusion GUI, api and backend with a graph/nodes interface.

[![GitHub Repo](https://img.shields.io/badge/github-repo-green?logo=github)](https://github.com/Percrepe/comfyui-docker)

</div>

## Image Variants

| Image          | CUDA   | Python | Torch  | xformers     |
|----------------|--------|--------|--------|--------------|
| cu130-py312 *  | 13.0.1 | 3.12   | 2.12.1 | -            |
| cu130-py311    | 13.0.1 | 3.11   | 2.12.1 | -            |
| cu130-py313    | 13.0.1 | 3.13   | 2.12.1 | -            |

\* *default image*

## All Images Include

* Ubuntu 22.04 LTS
* [ComfyUI](https://github.com/comfyanonymous/ComfyUI) v0.34.0
* [Jupyter Lab](https://github.com/jupyterlab/jupyterlab)
* [code-server](https://github.com/coder/code-server)
* [Application Manager](https://github.com/ashleykleynhans/app-manager) 2.0.1
* [CivitAI Downloader](https://github.com/ashleykleynhans/civitai-downloader)

## Building the Docker image

> [!NOTE]
> You will need to edit the `docker-bake.hcl` file and update `REGISTRY_USER`,
> and `RELEASE`.  You can obviously edit the other values too, but these
> are the most important ones.

```bash
# Clone the repo
git clone https://github.com/Percrepe/comfyui-docker.git
cd comfyui-docker

# Log in to Docker Hub
docker login

# Build the default image (CUDA 13.0 and Python 3.12), tag the image, and push the image to Docker Hub
docker buildx bake -f docker-bake.hcl --push

# OR build a different image (eg. CUDA 13.0 and Python 3.11), tag the image, and push the image to Docker Hub
docker buildx bake -f docker-bake.hcl cu130-py311 --push

# OR build ALL images, tag the images, and push the images to Docker Hub
docker buildx bake -f docker-bake.hcl all --push
```

## Running on Vast.ai

### Start the Docker container

```bash
docker run -d \
  --gpus all \
  -v /workspace \
  -p 8080:8080 \
  -p 7777:7777 \
  -p 8888:8888 \
  -e EXTRA_ARGS="--listen 0.0.0.0" \
  ghcr.io/percrepe/comfyui:cu130-py312-v0.34.0
```

### Ports

| Port  | Description          |
|-------|----------------------|
| 8080  | ComfyUI              |
| 7777  | Code Server          |
| 8888  | Jupyter Lab          |

### Environment Variables

| Variable             | Description                                                                                 | Default               |
|----------------------|---------------------------------------------------------------------------------------------|-----------------------|
| DISABLE_AUTOLAUNCH   | Disable application from launching automatically                                            | (not set)             |
| EXTRA_ARGS           | Specify extra command line arguments for ComfyUI, eg. `--lowvram`, `--disable-xformers` etc | (not set)             |

## Logs

ComfyUI creates a log file, and you can tail it instead of
killing the service to view the logs

| Application | Log file                    |
|-------------|-----------------------------|
| ComfyUI     | /workspace/logs/comfyui.log |

## Community and Contributing

Pull requests and issues on [GitHub](https://github.com/Percrepe/comfyui-docker)
are welcome. Bug fixes and new features are encouraged.
