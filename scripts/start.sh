#!/usr/bin/env bash

echo "=== Vast.ai ComfyUI Container ==="
echo "Starting services..."

# Create necessary directories
mkdir -p /workspace/logs
mkdir -p /workspace/ComfyUI

# Start Jupyter Lab in background
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --ServerApp.token='' --ServerApp.password='' > /workspace/logs/jupyter.log 2>&1 &
echo "Jupyter Lab started on port 8888"

# Start code-server in background
code-server --bind-addr 0.0.0.0:7777 --auth none > /workspace/logs/code-server.log 2>&1 &
echo "Code Server started on port 7777"

# Start NGINX in background
nginx > /workspace/logs/nginx.log 2>&1 &
echo "NGINX started"

# Run pre_start script
/pre_start.sh

echo "=== Container started ==="
echo "ComfyUI: http://localhost:8080"
echo "Jupyter Lab: http://localhost:8888"
echo "Code Server: http://localhost:7777"

# Keep container running
tail -f /workspace/logs/*.log
