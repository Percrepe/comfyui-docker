#!/usr/bin/env bash

export PYTHONUNBUFFERED=1
export APP="ComfyUI"

TEMPLATE_NAME="comfyui"
TEMPLATE_VERSION_FILE="/workspace/${APP}/template.json"

echo "TEMPLATE NAME: ${TEMPLATE_NAME}"
echo "TEMPLATE VERSION: ${TEMPLATE_VERSION}"
echo "VENV PATH: /workspace/${APP}/venv"

mkdir -p /workspace/logs

if [[ ${DISABLE_AUTOLAUNCH} ]]
then
    echo "Auto launching is disabled so the applications will not be started automatically"
    echo "You can launch them manually using the launcher scripts:"
    echo ""
    echo "   /start_comfyui.sh"
else
    ARGS=()

    if [[ ${EXTRA_ARGS} ]];
    then
          ARGS=("${ARGS[@]}" ${EXTRA_ARGS})
    fi

    /start_comfyui.sh "${ARGS[@]}"
fi
