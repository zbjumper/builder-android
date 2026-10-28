#!/bin/bash

set -e

PUSH=false
for arg in "$@"; do
  case "$arg" in
    --push) PUSH=true ;;
    *)
      echo "Unknown argument: $arg" >&2
      echo "Usage: $0 [--push]" >&2
      exit 1
      ;;
  esac
done

# 镜像版本
VERSION="0.1.1-jdk21"
IMAGE_NAME="zbjumper/builder-android"

TAG="${IMAGE_NAME}:${VERSION}"

echo "=========================================="
echo "Building: ${TAG}"
echo "Dockerfile: Dockerfile"
echo "=========================================="

sudo docker build -t "${TAG}" -f Dockerfile .

echo "Done: ${TAG}"
echo ""
echo "Image built successfully!"

if [ "$PUSH" = true ]; then
  echo "Pushing: ${TAG}"
  sudo docker push "${TAG}"
  echo "Image pushed successfully!"
fi
