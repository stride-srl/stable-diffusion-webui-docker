#if ${ROOT}/extensions/sd-webui-deforum is not present then clone it from https://github.com/stride-srl/sd-webui-deforum.git branch features/api else git pull
if [ ! -d "${ROOT}/extensions/sd-webui-deforum" ]; then
   cd ${ROOT}/extensions && git clone https://github.com/stride-srl/sd-webui-deforum.git -b features/api
else
   cd ${ROOT}/extensions/sd-webui-deforum && git pull
fi