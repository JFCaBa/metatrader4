#!/bin/bash

cd /opt/mt4

# Create directories if they don't exist
mkdir -p data shared

echo "Building MT4 Docker image..."
docker build -t mt4-wine .

echo ""
echo "Running MT4 container..."
docker run -it --rm \
  -v /opt/mt4/data:/mt4/.mt4 \
  -v /opt/mt4/shared:/mt4/shared \
  -e DISPLAY=:2 \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --network host \
  -u $(id -u):$(id -g) \
  mt4-wine
