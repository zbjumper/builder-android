# AGENTS.md

This file provides guidance to Codex and other AI coding agents when working with this repository.

## MUST

以下规则是强制规则，AI Agent 必须遵守。

* 在对话中，输出结论或者让用户决策时，必须使用中文
* 当需要在项目任意目录创建 `AGENTS.md` 文件时，都要在同目录创建软连接 `CLAUDE.md` 文件：

  ```bash
  ln -s AGENTS.md path/to/CLAUDE.md
  ```
* 同理，当需要创建 `CLAUDE.md` 文件时，必须实际创建 `AGENTS.md`，并创建 `CLAUDE.md` → `AGENTS.md` 的软连接。

## Project Overview

Docker image builder for Android applications with JDK 21 and Android SDK (API 35). The image includes GitLab CLI (glab) for CI/CD integration.

## Build Commands

### Build Image
```bash
./build.sh
```
Builds the Docker image. Current version: `0.1.1-jdk21`

### Build Manually
```bash
sudo docker build -t builder-android:0.1.1-jdk21 -f Dockerfile .
```

### Image Tag Format
Format: `builder-android:{VERSION}`
Example: `builder-android:0.1.1-jdk21`

## Architecture

**Directory Structure:**
```
├── Dockerfile                              # Main Dockerfile
├── build.sh                                # Build script
├── glab_1.124.0_linux_amd64.tar.gz        # GitLab CLI binary
└── .claude/                                # Claude configuration
```

**Dockerfile Components:**
1. Base: Eclipse Temurin JDK 21 (`eclipse-temurin:21-jdk`)
2. Timezone: Asia/Shanghai
3. System deps: wget, unzip, git, ca-certificates, tzdata, 32-bit libraries
4. GitLab CLI: glab 1.124.0 (pre-installed from tarball)
5. Android SDK:
   - Command Line Tools (latest)
   - platform-tools
   - platforms;android-35
   - build-tools;35.0.0

**Environment Variables:**
- `ANDROID_SDK_ROOT=/opt/android-sdk`
- `ANDROID_HOME=/opt/android-sdk`
- `PATH` includes cmdline-tools, platform-tools, and emulator

## Updating Components

### Update Android SDK Version
1. Edit `Dockerfile` line 45: `"platforms;android-35"` → desired version
2. Edit `Dockerfile` line 46: `"build-tools;35.0.0"` → desired version
3. Update `VERSION` in `build.sh` if needed

### Update glab Version
1. Download new version: `glab_{VERSION}_linux_amd64.tar.gz`
2. Replace existing tarball in repository root
3. Update `Dockerfile` lines 24-26 to reference new filename

### Update JDK Version
1. Change base image in `Dockerfile` line 1: `eclipse-temurin:{VERSION}-jdk`
2. Update `VERSION` in `build.sh` to reflect new JDK version
