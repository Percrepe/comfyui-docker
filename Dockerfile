ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    jq \
    tmux \
    htop \
    nvtop \
    && rm -rf /var/lib/apt/lists/*

RUN ln -sf /usr/bin/python3 /usr/bin/python

WORKDIR /
COPY --chmod=755 build/* ./

ARG TORCH_VERSION
ARG XFORMERS_VERSION
ARG INDEX_URL
ARG COMFYUI_VERSION
RUN /install_comfyui.sh

ARG APP_MANAGER_VERSION
RUN /install_app_manager.sh
COPY app-manager/config.json /app-manager/public/config.json
COPY --chmod=755 app-manager/*.sh /app-manager/scripts/

ARG CIVITAI_DOWNLOADER_VERSION
RUN /install_civitai_model_downloader.sh

RUN rm -f /install_*.sh

COPY nginx/nginx.conf /etc/nginx/nginx.conf

ARG RELEASE
ENV TEMPLATE_VERSION=${RELEASE}

ARG VENV_PATH
ENV VENV_PATH=${VENV_PATH}

WORKDIR /
COPY --chmod=755 scripts/* ./

EXPOSE 8080
EXPOSE 8888
EXPOSE 7777

SHELL ["/bin/bash", "--login", "-c"]
CMD [ "/start.sh" ]
