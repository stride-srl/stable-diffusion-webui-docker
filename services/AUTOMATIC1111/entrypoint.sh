#!/bin/bash

set -Eeuo pipefail

# TODO: move all mkdir -p ?
mkdir -p /data/config/auto/scripts/
# mount scripts individually
find "${ROOT}/scripts/" -maxdepth 1 -type l -delete
cp -vrfTs /data/config/auto/scripts/ "${ROOT}/scripts/"

# Set up config file
python /docker/config.py /data/config/auto/config.json

if [ ! -f /data/config/auto/ui-config.json ]; then
  echo '{}' >/data/config/auto/ui-config.json
fi

if [ ! -f /data/config/auto/styles.csv ]; then
  touch /data/config/auto/styles.csv
fi

# copy models from original models folder
rsync -a --info=NAME ${ROOT}/models/VAE-approx/ /data/models/VAE-approx/
rsync -a --info=NAME ${ROOT}/models/karlo/ /data/models/karlo/

declare -A MOUNTS

MOUNTS["/root/.cache"]="/data/.cache"
MOUNTS["${ROOT}/models"]="/data/models"

MOUNTS["${ROOT}/embeddings"]="/data/embeddings"
MOUNTS["${ROOT}/config.json"]="/data/config/auto/config.json"
MOUNTS["${ROOT}/ui-config.json"]="/data/config/auto/ui-config.json"
MOUNTS["${ROOT}/styles.csv"]="/data/config/auto/styles.csv"
MOUNTS["${ROOT}/extensions"]="/data/config/auto/extensions"
MOUNTS["${ROOT}/config_states"]="/data/config/auto/config_states"

# extra hacks
MOUNTS["${ROOT}/repositories/CodeFormer/weights/facelib"]="/data/.cache"

for to_path in "${!MOUNTS[@]}"; do
  set -Eeuo pipefail
  from_path="${MOUNTS[${to_path}]}"
  rm -rf "${to_path}"
  if [ ! -f "$from_path" ]; then
    mkdir -vp "$from_path"
  fi
  mkdir -vp "$(dirname "${to_path}")"
  ln -sT "${from_path}" "${to_path}"
  echo Mounted $(basename "${from_path}")
done

echo "Installing extension dependencies (if any)"

# because we build our container as root:
chown -R root ~/.cache/
chmod 766 ~/.cache/

# if /stable-diffusion-webui/extensions/sd-webui-deforum is not present then create it
if [ ! -d /stable-diffusion-webui/extensions/sd-webui-deforum ]; then
  echo "Cloning sd-webui-deforum"
  mkdir -p /stable-diffusion-webui/extensions/sd-webui-deforum
  cd /stable-diffusion-webui/extensions/sd-webui-deforum
  git init
  git remote add origin https://github.com/stride-srl/sd-webui-deforum
  git fetch origin
  git checkout features/apiv2
  git reset --hard
else
  echo "Updating sd-webui-deforum"
  cd /stable-diffusion-webui/extensions/sd-webui-deforum
  git fetch origin
  git reset --hard
  git pull
fi

if [ ! -d /stable-diffusion-webui/extensions/sd-webui-controlnet ]; then
  echo "Cloning sd-webui-controlnet"
  mkdir -p /stable-diffusion-webui/extensions/sd-webui-controlnet
  cd /stable-diffusion-webui/extensions/sd-webui-controlnet
  git init
  git remote add origin https://github.com/Mikubill/sd-webui-controlnet.git
  git fetch origin
  git checkout main
  git reset --hard
else
  echo "Updating sd-webui-controlnet"
  cd /stable-diffusion-webui/extensions/sd-webui-controlnet
  git fetch origin
  git reset --hard
  git pull
fi

cd -

shopt -s nullglob
list=(./extensions/*/requirements.txt)
for req in "${list[@]}"; do
  pip install -r "$req"
done

if [ -f "/data/config/auto/startup.sh" ]; then
  pushd ${ROOT}
  echo "Running startup script"
  . /data/config/auto/startup.sh
  popd
fi

exec "$@"
