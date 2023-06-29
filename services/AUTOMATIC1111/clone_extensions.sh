#!/bin/bash

# if mkdir -p /stable-diffusion-webui/extensions/"$1" is not present then create it
mkdir -p /stable-diffusion-webui/extensions/"$1"
cd /stable-diffusion-webui/extensions/"$1"
git init
git remote add origin "$2"
git fetch origin
git checkout "$3"
git reset --hard


