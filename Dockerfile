FROM eclipse-temurin:21-jdk

ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:${PATH}"

ENV LANG=C.UTF-8
ENV TIME_ZONE=Asia/Shanghai

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        unzip \
        git \
        ca-certificates \
        tzdata \
        libc6-i386 \
        lib32stdc++6 \
        lib32z1 && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

ARG GLAB_VERSION=1.124.0
RUN wget -q \
      "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VERSION}/downloads/glab_${GLAB_VERSION}_linux_amd64.tar.gz" \
      -O /tmp/glab.tar.gz && \
    tar -xzf /tmp/glab.tar.gz -C /usr/local/bin --strip-components=1 bin/glab && \
    rm /tmp/glab.tar.gz && \
    glab --version

# Android Command Line Tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget -q \
      https://dl.google.com/android/repository/commandlinetools-linux-15859902_latest.zip \
      -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip \
      -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools \
       ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip

# 接受 Android SDK 许可证
RUN yes | sdkmanager --licenses > /dev/null || true

# 安装 Android SDK（API 35 匹配 compileSdkVersion 35）
RUN sdkmanager \
      "platform-tools" \
      "platforms;android-35" \
      "build-tools;35.0.0"

WORKDIR /workspace

CMD ["bash"]
