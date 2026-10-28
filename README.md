# builder-android

## 概述

本仓库提供用于 GitLab CI/CD 的 Android 构建镜像，包含 JDK 和 Android SDK。

## 使用

构建镜像：

```shell
./build.sh
```

### 在 Apple Silicon Mac 上构建 GitLab CI 镜像

GitLab Runner 如果运行在 x86_64（Intel/AMD）的 Ubuntu 机器上，需要使用 `linux/amd64` 镜像。在 Apple Silicon Mac 上构建并推送时执行：

```shell
./build.sh --push --platform linux/amd64
```

`--platform linux/amd64` 指定目标架构；`--push` 在构建成功后推送镜像。不需要推送时去掉 `--push`。

Mac 会通过模拟构建 x86_64 镜像，速度可能较慢，无需另外准备 x86_64 构建机器。不传 `--platform` 时，Docker 使用默认目标平台，在 Apple Silicon Mac 上通常是 `linux/arm64`。

当前 Dockerfile 包含 x86 兼容库及 amd64 版 glab。在 Apple Silicon Mac 上应明确指定 `linux/amd64`，否则可能出现 `Unable to locate package libc6-i386`、`lib32stdc++6`、`lib32z1` 等架构不匹配错误。
