#!/bin/bash

set -e

PUSH=false
PLATFORM=""
while [ "$#" -gt 0 ]; do
  case "$1" in
    --push) PUSH=true ;;
    --platform)
      if [ "$#" -lt 2 ] || [ -z "$2" ] || [[ "$2" == --* ]]; then
        echo "Missing value for --platform" >&2
        exit 1
      fi
      PLATFORM="$2"
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      echo "Usage: $0 [--push] [--platform linux/amd64]" >&2
      exit 1
      ;;
  esac
  shift
done

# 镜像版本
VERSION="1.0.1-jdk21"
IMAGE_NAME="zbjumper/builder-android"

TAG="${IMAGE_NAME}:${VERSION}"

echo "=========================================="
echo "Building: ${TAG}"
echo "Dockerfile: Dockerfile"
echo "=========================================="

BUILD_ARGS=()
if [ -n "$PLATFORM" ]; then
  BUILD_ARGS+=(--platform "$PLATFORM")
fi
docker build "${BUILD_ARGS[@]}" -t "${TAG}" -f Dockerfile .

echo "Done: ${TAG}"
echo ""
echo "Image built successfully!"

if [ "$PUSH" = true ]; then
  echo "Pushing: ${TAG}"
  sudo docker push "${TAG}"
  echo "Image pushed successfully!"
fi
