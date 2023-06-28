#!/bin/bash

# if mkdir -p /extensions/"$1" is not present then create it
if [ ! -d "/extensions/$1" ]; then
   mkdir -p /extensions/"$1"
   cd /extensions/"$1"
   git init
   git remote add origin "$2"
   git fetch origin
   git checkout "$3"
   git reset --hard
else
   cd /extensions/"$1"
   git fetch origin
   git pull
fi


