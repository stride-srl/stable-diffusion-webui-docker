# Stable Diffusion Webui Docker

This repository provides the [WebUI](https://github.com/hlky/stable-diffusion-webui) as docker for easy setup and deployment.

Special thanks to everyone behind this awesome projects, without them, none of this would have been possible:

- https://rentry.org/GUItard
- https://github.com/hlky/stable-diffusion-webui
- https://github.com/AUTOMATIC1111/stable-diffusion-webui
- https://github.com/CompVis/stable-diffusion

## Setup

make sure you have docker installed and up to date. If yes, download this repo and run:

### Build

```
docker compose build
```

in the root of the repo, you can let it build in the background while you go to the next step:

### Download the different models:

[More info here](https://rentry.org/GUItard)

- Main: Stable Diffusion:, version 1.4 can be downloaded [here](https://drive.yerf.org/wl/?id=EBfTrmcCCUAGaQBXVIj5lJmEhjoP1tgl), rename to `model.ckpt`
- GFPGAN to improve generated faces. Download [GFPGANv1.3.pth](https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth).
- RealESRGAN for super-sampling, download [RealESRGAN_x4plus.pth](https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth) and [RealESRGAN_x4plus_anime_6B.pth](https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth).

Put all of the downloaded models in the `model` folder, if everything is setup correctly, the folder structure should look something like this:

```
├── README.md
├── docker-compose.yml
├── build
│   └── Dockerfile
├── cache
├── models
│   ├── GFPGANv1.3.pth
│   ├── RealESRGAN_x4plus.pth
│   ├── RealESRGAN_x4plus_anime_6B.pth
│   └── model.ckpt
├── output
```

### Run

```
docker compose up --build
```

Will build and start the app on http://127.0.0.1:7860/

Note: the first start will take sometime as some other models will be downloaded, these will be cached in the `cache` folder, so next runs are faster.

## Config

in the `docker-compose.yml` you can change the cli parameters of the webui, the ports, and gpu setup. You can find all cli configs [here](https://github.com/hlky/stable-diffusion/blob/554bd068e6f2f6bc55449a67fe017ddd77090f28/scripts/webui.py)
